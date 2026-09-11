"""

Reads the per90 table straight out of Supabase; no CSV exports.

    python fit_weights.py profile attacking      print percentile table -> paste to an LLM
    python fit_weights.py fit attacking          fit every position tiered below
    python fit_weights.py fit                    fit every category tiered below

Workflow: profile a category, hand the table to an LLM for a TIERS block,
paste that block in below, fit. Writes weights.sql. Reads only, never writes
to the database.

Setup:
    pip install pandas numpy scipy psycopg2-binary python-dotenv
    .env  ->  DATABASE_URL=postgresql://postgres.<ref>:<pw>@<host>:5432/postgres
              (Supabase: Project Settings -> Database -> Connection string -> URI)
"""

import os
import sys
import unicodedata

import numpy as np
import pandas as pd
import psycopg2
from dotenv import load_dotenv
from scipy.optimize import lsq_linear

# ---------------------------------------------------------------------------
# CONFIG
# ---------------------------------------------------------------------------

TABLE = "prem_stats_2526_per90"
MIN_MINUTES = 900

ALPHA = 200             # ridge strength; higher spreads weight more evenly
MAX_WEIGHT = 3000       # largest magnitude in the output
MIN_TIERED = 8          # skip a position with fewer tiered players than this


# ---------------------------------------------------------------------------
# TIERS — paste generated blocks here. Key is (category, position).
# Any name that doesn't match the data is reported, not silently dropped.
# ---------------------------------------------------------------------------

BASELINES = {
    ("possession", "Central Midfield"): 300,
   
}

TIERS = {
        ("possession", "Central Midfield"): {
        "Elite":   ["Elliot Anderson", "Bruno Guimaraes", "Curtis Jones",
                    "Enzo Fernandez", "Tijjani Reijnders"],
        "Good":    ["James Ward-Prowse", "Declan Rice", "Pascal Gross",
                    "Kobbie Mainoo", "Mikel Merino", "Alexis Mac Allister",
                    "Joao Gomes", "Enzo Le Fee", "Sasa Lukic"],
        "Average": ["Youri Tielemans", "Jordan Henderson", "Ao Tanaka",
                    "Lewis Miley", "Mateus Fernandes", "Jacob Ramsey",
                    "Alex Scott", "Kiernan Dewsbury-Hall", "Daichi Kamada",
                    "Pape Matar Sarr", "Joelinton", "Sean Longstaff"],
        "Poor":    ["Conor Gallagher", "Yegor Yarmolyuk", "Will Hughes",
                    "Josh Cullen", "Noah Sadiki", "Jean-Ricner Bellegarde",
                    "Diego Gomez", "Tim Iroegbunam", "Josh Laurent",
                    "Nicolas Dominguez", "Yasin Ayari", "Habib Diarra"],
    },

    # ("attacking", "Right Wing"): { ... },
    # ("defensive", "Centre Back"): { ... },
}


# ---------------------------------------------------------------------------
# Per category: weights table, stat signs, and the columns shown when profiling.
#   "+" weight >= 0     "-" weight <= 0     "?" unconstrained
# ---------------------------------------------------------------------------

CATEGORIES = {
    "attacking": {
        "table": "getSeasonAttacking",
        "signs": {
            "GoalsPer90": "+", "AssistsPer90": "+", "BigChancesCreatedPer90": "+",
            "KeyPassesPer90": "+", "ShotsOnTargetPer90": "+", "SuccessfulDribblesPer90": "+",
            "AccurateCrossesPer90": "+", "ThroughBallsWonPer90": "+", "LongBallsWonPer90": "+",
            "HitWoodworkPer90": "+", "PenaltiesWonPer90": "+",
            "BigChancesMissedPer90": "-", "OffsidesPer90": "-", "OwnGoalsPer90": "-",
            "ShotsOffTargetPer90": "-",
            "DribbleAttemptsPer90": "?", "ShotsBlockedPer90": "-",
        },
        "profile": ["GoalsPer90", "AssistsPer90", "KeyPassesPer90", "BigChancesCreatedPer90",
                    "SuccessfulDribblesPer90", "AccurateCrossesPer90"],
        "profile_raw": ["BigChancesMissedPer90"],
    },
    "defensive": {
        "table": "getSeasonDefensive",
        "signs": {
            "TacklesPer90": "?", "InterceptionsPer90": "+", "BlockedShotsPer90": "?",
            "ClearancesPer90": "+", "CrossesBlockedPer90": "+", "AerialsWonPer90": "?",
            "DuelsWonPercentage": "+", "LongBallsWonPer90": "+", "Cleansheets": "+",
            "FoulsPer90": "-", "GoalsConcededPer90": "-", "DuelsWonPer90": "+", "DribbledPastPer90": "-",
            "ErrorLeadToGoal": "-", "OwnGoalsPer90": "-"
        },
        "profile": ["TacklesPer90", "GoalsConcededPer90", "ClearancesPer90",
                    "BlockedShotsPer90", "AerialsWonPer90", "DuelsWonPer90", "DuelsWonPercentage"],
        "profile_raw": ["DribbledPastPer90", "FoulsPer90", "OwnGoalsPer90"],
        "profile_invert": ["GoalsConcededPer90"],
    },
    "finishing": {
        "table": "getSeasonFinishing",
        "signs": {
            "GoalsPer90": "+", "ShotsOnTargetPer90": "+",
            "BigChancesMissedPer90": "-", "OffsidesPer90": "-", "ShotsOffTargetPer90": "-",
            "PenaltiesMissedPer90": "-",
            "HitWoodworkPer90": "+", "ShotsBlockedPer90": "-", "ShotsTotalPer90": "?",
        },
        "profile": ["GoalsPer90", "ShotsOnTargetPer90", "ShotsTotalPer90"],
        "profile_raw": ["BigChancesMissedPer90", "ShotsOffTargetPer90"],
    },
    "passing": {
        "table": "getSeasonPassing",
        "signs": {
            "KeyPassesPer90": "+", "PassesPer90": "+", "AssistsPer90": "+",
            "AccurateCrossesPer90": "+", "ThroughBallsPer90": "+",
            "BigChancesCreatedPer90": "+", "AccuratePassesPer90": "+",
            "AccuratePassesPercentage": "+", "ThroughBallsWonPer90": "+",
            "LongBallsPer90": "?", "TotalCrossesPer90": "?",
        },
        "profile": ["AssistsPer90", "AccuratePassesPercentage", "KeyPassesPer90",
                    "ThroughBallsPer90", "BigChancesCreatedPer90", "AccurateCrossesPer90"],
        "profile_raw": [],
    },
    "possession": {
        "table": "getSeasonPossession",
        "signs": {
            "AccuratePassesPer90": "+", "AccuratePassesPercentage": "+",
            "SuccessfulDribblesPer90": "+", "FoulsDrawnPer90": "+", "DuelsWonPer90": "+",
            "LongBallsWonPer90": "+",
            "DispossessedPer90": "-", "FoulsPer90": "-",
            "LongBallsPer90": "?",
        },
        "profile": ["AccuratePassesPer90", "AccuratePassesPercentage",
                    "SuccessfulDribblesPer90", "DuelsWonPer90", "FoulsDrawnPer90",
                    "ThroughBallsPer90", "KeyPassesPer90", "BigChancesCreatedPer90"],
        "profile_raw": ["DispossessedPer90"],
        "profile_invert": ["DispossessedPer90"],
    },
    "keeping": {
        "table": "getKeeperScore",
        "signs": {
            "SavesPer90": "+", "SavesInsideBoxPer90": "+", "PenaltiesSavedPer90": "+",
            "Cleansheets": "+", "ClearancesPer90": "+", "AerialsWonPer90": "+",
            "DuelsWonPercentage": "+", "LongBallsWonPer90": "+", "FoulsDrawnPer90": "+",
            "GoalsConcededPer90": "-", "ErrorLeadToGoal": "-", "FoulsPer90": "-",

        },
        "profile": ["SavesPer90", "SavesInsideBoxPer90", "Cleansheets",
                    "AccuratePassesPercentage", "LongBallsWonPer90"],
        "profile_raw": ["GoalsConcededPer90"],
    },
}

TIER_VALUES = {"Elite": 4, "Good": 3, "Average": 2, "Poor": 1}
TIER_NAMES = {v: k for k, v in TIER_VALUES.items()}


# ---------------------------------------------------------------------------

def norm(name):
    s = unicodedata.normalize("NFKD", str(name))
    s = "".join(c for c in s if not unicodedata.combining(c))
    for a, b in (("ø", "o"), ("Ø", "O"), ("æ", "ae"), ("Æ", "AE"),
                 ("ð", "d"), ("Ð", "D"), ("ł", "l"), ("Ł", "L"), ("þ", "th")):
        s = s.replace(a, b)
    return " ".join(s.split()).casefold()


def query(sql):
    load_dotenv()
    url = os.environ.get("DATABASE_URL")
    if not url:
        sys.exit("DATABASE_URL not set — put it in a .env file next to this script.")
    with psycopg2.connect(url) as conn, conn.cursor() as cur:
        cur.execute(sql)
        cols = [d[0] for d in cur.description]
        return pd.DataFrame(cur.fetchall(), columns=cols)


def load(cols):
    """Pull PlayerName, DetailedPosition, MinutesPlayed plus the columns asked for."""
    wanted = ["PlayerName", "DetailedPosition", "MinutesPlayed"] + list(cols)
    sel = ", ".join(f'"{c}"' for c in dict.fromkeys(wanted))
    df = query(
        f'select {sel} from public."{TABLE}" '
        f'where "MinutesPlayed" >= {MIN_MINUTES} and "DetailedPosition" is not null'
    )
    for c in cols:
        df[c] = pd.to_numeric(df[c], errors="coerce").fillna(0.0)
    df["_key"] = df["PlayerName"].map(norm)
    return df


def do_profile(cat):
    spec = CATEGORIES[cat]
    pct_cols, raw_cols = spec["profile"], spec["profile_raw"]
    df = load(pct_cols + raw_cols)

    out = df[["PlayerName", "DetailedPosition", "MinutesPlayed"]].copy()
    invert = set(spec.get("profile_invert", []))
    for c in pct_cols:
        pct = df.groupby("DetailedPosition")[c].rank(pct=True) * 100
        if c in invert:
            pct = 100 - pct
        out[c.replace("Per90", "")] = pct.round()
    out["composite"] = out[[c.replace("Per90", "") for c in pct_cols]].mean(axis=1).round()
    for c in raw_cols:
        out[c.replace("Per90", "") + "_raw"] = df[c].round(2)

    print(f"# {cat} — percentiles WITHIN each position, {TABLE}, {MIN_MINUTES}+ minutes")
    print("# composite is an equal-weight average: a strawman to disagree with, not the answer\n")
    for pos, sub in out.groupby("DetailedPosition"):
        print(f"\n## {pos}  ({len(sub)} players)")
        print(sub.drop(columns=["DetailedPosition"])
                 .sort_values("composite", ascending=False)
                 .to_string(index=False))


def do_fit(only=None):
    statements, summary = [], []

    for (cat, position), groups in TIERS.items():
        if only and cat != only:
            continue
        spec = CATEGORIES.get(cat)
        if not spec:
            print(f"unknown category '{cat}' — skipping")
            continue

        signs = spec["signs"]
        df = load(list(signs))
        cols = [c for c in signs if c in df.columns]
        if len(cols) < len(signs):
            print(f"[{cat}] absent from {TABLE}, dropped: {sorted(set(signs) - set(cols))}")

        want = {}
        for tname, names in groups.items():
            for n in names:
                want[norm(n)] = TIER_VALUES[tname]

        sub = df[(df["DetailedPosition"] == position) & df["_key"].isin(want)].copy()
        sub["_tier"] = sub["_key"].map(want)
        sub = sub.reset_index(drop=True)

        missed = sorted(set(want) - set(sub["_key"]))
        if missed:
            print(f"[{cat} / {position}] not found (name mismatch, wrong position, "
                  f"or under {MIN_MINUTES} mins): {missed}")

        if len(sub) < MIN_TIERED or sub["_tier"].nunique() < 2:
            summary.append((cat, position, len(sub), None))
            continue

        X = sub[cols].to_numpy(dtype=float)
        tier = sub["_tier"].to_numpy(dtype=float)

        scale = X.std(axis=0)
        scale[scale == 0] = 1.0
        Xs = X / scale

        rows, targets = [], []
        for i in range(len(sub)):
            for j in range(len(sub)):
                if tier[i] > tier[j]:
                    rows.append(Xs[i] - Xs[j])
                    targets.append(tier[i] - tier[j])
        A, y = np.array(rows), np.array(targets)

        A_r = np.vstack([A, np.sqrt(ALPHA) * np.eye(len(cols))])
        y_r = np.concatenate([y, np.zeros(len(cols))])
        lo = np.array([0.0 if signs[c] == "+" else -np.inf for c in cols])
        hi = np.array([0.0 if signs[c] == "-" else np.inf for c in cols])

        w = lsq_linear(A_r, y_r, bounds=(lo, hi), max_iter=500).x / scale
        if np.abs(w).max() > 0:
            w = w / np.abs(w).max() * MAX_WEIGHT

        scores = X @ w
        base = BASELINES.get((cat, position), 0)
        scores = scores + base
        ok = sum(1 for i in range(len(sub)) for j in range(len(sub))
                 if tier[i] > tier[j] and scores[i] > scores[j])
        pct = 100 * ok / len(A)
        summary.append((cat, position, len(sub), pct))

        print(f"\n[{cat} / {position}] {len(sub)} tiered, {pct:.0f}% of {len(A)} pairs satisfied")
        for s, t, n in sorted(zip(scores, tier, sub["PlayerName"]), reverse=True):
            print(f"   {s:>9.0f}  [{TIER_NAMES[int(t)]:<7}] {n}")
        print("   weights:", ", ".join(
            f"{c.replace('Per90','')}={round(v)}"
            for c, v in sorted(zip(cols, w), key=lambda t: -abs(t[1])) if round(v)
        ))

        sets = ",\n  ".join(f'"{c}" = {round(v)}' for c, v in zip(cols, w))
        if base:
            sets += f',\n  "Baseline" = {base}'
        statements.append(
            f"-- {cat} / {position} — {len(sub)} tiered, {pct:.0f}% of pairs satisfied\n"
            f'update public."{spec["table"]}" set\n  {sets}\n'
            f"where \"Position\" = '{position}';\n"
        )

    print("\n" + "=" * 66)
    print(f"{'CATEGORY':<12} {'POSITION':<22} {'N':>4}  {'FIT':>6}")
    for cat, pos, n, pct in sorted(summary):
        print(f"{cat:<12} {pos:<22} {n:>4}  {(f'{pct:.0f}%' if pct else 'skip'):>6}")

    if statements:
        with open("weights.sql", "w", encoding="utf-8") as f:
            f.write("\n".join(statements))
        print(f"\nWrote {len(statements)} update statements to weights.sql")


if __name__ == "__main__":
    if len(sys.argv) < 2:
        sys.exit(__doc__)
    mode = sys.argv[1]
    arg = sys.argv[2] if len(sys.argv) > 2 else None

    if mode == "profile":
        if arg not in CATEGORIES:
            sys.exit(f"pick one of: {', '.join(CATEGORIES)}")
        do_profile(arg)
    elif mode == "fit":
        do_fit(arg)
    else:
        sys.exit(__doc__)