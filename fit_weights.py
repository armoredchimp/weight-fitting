

import sys
import unicodedata

import numpy as np
import pandas as pd
from scipy.optimize import lsq_linear

# ---------------------------------------------------------------------------
# CONFIG
# ---------------------------------------------------------------------------

POSITION = "Centre Forward"
MIN_MINUTES = 900

# Ridge strength. Higher = weights spread more evenly and stay smaller.
# 1.0 is a reasonable start; try 0.3 and 3.0 to see how much it matters.
ALPHA = 1.0

# Final weights are rescaled so the largest magnitude lands here, matching the
# range of the existing hand-tuned tables.
MAX_WEIGHT = 3000

# Score gap the fit aims for between adjacent tiers, in pre-scaling units.
TIER_MARGIN = 1.0

# Every column in getSeasonAttacking that exists in the per90 tables.
#   "+"  weight must be >= 0     "-"  weight must be <= 0     "?"  unconstrained
STATS = {
    "GoalsPer90": "+",
    "AssistsPer90": "+",
    "BigChancesCreatedPer90": "+",
    "KeyPassesPer90": "+",
    "ShotsOnTargetPer90": "+",
    "SuccessfulDribblesPer90": "+",
    "AccurateCrossesPer90": "+",
    "ThroughBallsWonPer90": "+",
    "LongBallsWonPer90": "+",
    "HitWoodworkPer90": "+",
    "BigChancesMissedPer90": "-",
    "OffsidesPer90": "-",
    "OwnGoalsPer90": "-",
    "ShotsOffTargetPer90": "-",
    "DribbleAttemptsPer90": "?",
    "ShotsBlockedPer90": "?",
}

# Higher number = better tier.
TIERS = {
    "Hugo Ekitike": 4, "Matheus Cunha": 4, "Georginio Rutter": 4, "Joao Pedro": 4,

    "Erling Haaland": 3, "Junior Kroupi": 3, "Igor Thiago": 3, "Ollie Watkins": 3,
    "Richarlison": 3, "Lukas Nmecha": 3, "Callum Wilson": 3, "Hee-chan Hwang": 3,
    "Nick Woltemade": 3,

    "Viktor Gyokeres": 2, "Danny Welbeck": 2, "Igor Jesus": 2, "Raul Jimenez": 2,
    "Jean-Philippe Mateta": 2, "Taty Castellanos": 2, "Beto": 2,
    "Benjamin Sesko": 2, "Dominic Calvert-Lewin": 2, "Evanilson": 2,

    "Brian Brobbey": 1, "Rodrigo Muniz": 1, "Thierno Barry": 1, "Wilson Isidor": 1,
    "Liam Delap": 1, "Jorgen Strand Larsen": 1, "Chris Wood": 1, "Randal Kolo Muani": 1,
}

TIER_NAMES = {4: "Elite", 3: "Good", 2: "Average", 1: "Poor"}


# ---------------------------------------------------------------------------

def norm(name):
    """Strip accents, whitespace and case so tier names match export names."""
    s = unicodedata.normalize("NFKD", str(name))
    s = "".join(c for c in s if not unicodedata.combining(c))
    return " ".join(s.split()).casefold()


def main(path):
    df = pd.read_csv(path)

    missing = [c for c in STATS if c not in df.columns]
    if missing:
        print(f"WARNING: columns absent from the export, dropping: {missing}\n")
    cols = [c for c in STATS if c in df.columns]

    pool = df[
        (df["DetailedPosition"] == POSITION)
        & (df["MinutesPlayed"] >= MIN_MINUTES)
    ].copy()
    pool[cols] = pool[cols].fillna(0.0)
    pool["_key"] = pool["PlayerName"].map(norm)

    tiers = {norm(k): v for k, v in TIERS.items()}
    pool["_tier"] = pool["_key"].map(tiers)

    unmatched = sorted(set(tiers) - set(pool["_key"]))
    if unmatched:
        print("TIERED PLAYERS NOT FOUND IN THE EXPORT (check spelling):")
        for u in unmatched:
            print(f"  - {u}")
        print()

    fit = pool.dropna(subset=["_tier"]).reset_index(drop=True)
    print(f"{len(pool)} {POSITION}s over {MIN_MINUTES} minutes; {len(fit)} tiered.\n")
    if len(fit) < 8:
        sys.exit("Not enough tiered players to fit against.")

    X = fit[cols].to_numpy(dtype=float)
    tier = fit["_tier"].to_numpy(dtype=float)

    # Standardise so ridge penalises each stat comparably. Scaling is positive,
    # so the sign bounds mean the same thing in standardised space.
    scale = X.std(axis=0)
    scale[scale == 0] = 1.0
    Xs = X / scale

    # One row per cross-tier pair.
    rows, targets = [], []
    for i in range(len(fit)):
        for j in range(len(fit)):
            if tier[i] > tier[j]:
                rows.append(Xs[i] - Xs[j])
                targets.append(TIER_MARGIN * (tier[i] - tier[j]))
    A = np.array(rows)
    y = np.array(targets)
    print(f"{len(A)} pairwise constraints across {len(cols)} stats.\n")

    # Ridge as extra rows: sqrt(alpha) * I against zeros.
    A_ridge = np.vstack([A, np.sqrt(ALPHA) * np.eye(len(cols))])
    y_ridge = np.concatenate([y, np.zeros(len(cols))])

    lo = np.array([0.0 if STATS[c] == "+" else -np.inf for c in cols])
    hi = np.array([0.0 if STATS[c] == "-" else np.inf for c in cols])

    sol = lsq_linear(A_ridge, y_ridge, bounds=(lo, hi), max_iter=500)
    w = sol.x / scale                      # back to raw per90 units
    w = w / np.abs(w).max() * MAX_WEIGHT    # into the existing weight range

    # ---- how well does it reproduce the tiers? ----
    fit["_score"] = X @ w
    ok = sum(
        1 for i in range(len(fit)) for j in range(len(fit))
        if tier[i] > tier[j] and fit["_score"][i] > fit["_score"][j]
    )
    print(f"Pairs satisfied: {ok}/{len(A)} ({100 * ok / len(A):.0f}%)\n")

    print("FITTED ORDER (tier in brackets — look for anything badly out of place)")
    for _, r in fit.sort_values("_score", ascending=False).iterrows():
        print(f"  {r['_score']:>10.0f}  [{TIER_NAMES[int(r['_tier'])]:<7}] {r['PlayerName']}")

    print("\nWEIGHTS")
    for c, v in sorted(zip(cols, w), key=lambda t: -abs(t[1])):
        print(f"  {c:<28} {round(v):>7}")

    sets = ",\n  ".join(f'"{c}" = {round(v)}' for c, v in zip(cols, w))
    print("\n-- paste into Supabase, or type these into the /weights GUI")
    print(f'update public."getSeasonAttacking" set\n  {sets}\nwhere "Position" = \'{POSITION}\';')


if __name__ == "__main__":
    if len(sys.argv) < 2:
        sys.exit("usage: python fit_weights.py <per90_export.csv>")
    main(sys.argv[1])