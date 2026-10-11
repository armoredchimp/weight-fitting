"""
Sets the per-match (fixture) weight tables from the tuned seasonal ones, and
compares weights across positions.

    python calibrate_fixture.py                    calibrate, write fixture_weights.sql
    python calibrate_fixture.py compare            seasonal weights side by side, gaps flagged
    python calibrate_fixture.py compare fixture    same for the fixture weight tables

Calibrating, for every category:
  1. Starts from the seasonal weights. Where a seasonal row isn't filled in yet
     (keeping, for now) it starts from the current fixture weights instead.
     Left/right backs and left/right wingers are treated as one position: their
     seasonal rows are averaged, their matches pooled, and both get the same row.
  2. Zeroes stats that are too jumpy in a single match: percentages other than
     pass accuracy, and the "lost" duplicates of the won counts. Stats that
     only exist per match start at 0.
  3. Scores this season's matches (current_player_stats) with those weights
     and picks:
       scale     ONE number for the whole category, shrinking every weight of
                 every position by the same amount, so one match can't swing
                 far past what a season average does. Because it's shared, the
                 gaps between positions stay exactly as they are in the
                 seasonal tables.
       Baseline  one per position: the points a full match starts from, so an
                 ordinary full game scores about what an ordinary player at
                 that position scores over a season
  4. Prints how the new match scores spread out and writes fixture_weights.sql.
     Reads only; run the SQL yourself in the Supabase SQL editor.

Comparing prints each category's weights with positions in pitch order, then
flags mirror positions that don't match and neighbouring positions whose
weight for the same stat differs by more than COMPARE_FLAG. Reads only.

The scoring maths mirrors shared/categoryScoring.ts in ff-admin. If you change a
stat list or a constant there, change it here too.

Uses the same .env / DATABASE_URL as fit_weights.py.
"""

import sys
from datetime import date

import numpy as np
import pandas as pd

from fit_weights import query

# ---------------------------------------------------------------------------
# CONFIG — the knobs worth touching
# ---------------------------------------------------------------------------

# How much wider single-match scores may spread than season scores, for the
# typical position. 2 means a match can be about twice as far from average as a
# season can. Lower it if match scores swing too much, raise it if every match
# looks the same. The swing column shows where each position actually lands.
MATCH_SPREAD = 2.0

# compare flags neighbouring positions whose weights differ by more than this
COMPARE_FLAG = 1.5

# Last season's per90 tables used as the "what a season looks like" reference.
# Add the other four leagues' 2526 per90 tables for a broader reference.
SEASON_TABLES = ["prem_stats_2526_per90"]
SEASON_MIN_MINUTES = 900

MATCH_TABLE = "current_player_stats"
FULL_GAME_MINUTES = 70      # matches at least this long set the scale and Baseline
MIN_FULL_GAMES = 30         # skip a position with fewer full games than this
MIN_SEASON_PLAYERS = 10     # ...or fewer qualifying season players than this

# ---------------------------------------------------------------------------
# Positions
# ---------------------------------------------------------------------------

# Mirror positions that always share one set of weights.
PAIRS = {"Left Back": "Full Back", "Right Back": "Full Back",
         "Left Wing": "Winger", "Right Wing": "Winger"}

PITCH_ORDER = ["Goalkeeper", "Centre Back", "Left Back", "Right Back", "Defensive Midfield",
               "Central Midfield", "Attacking Midfield", "Left Wing", "Right Wing", "Centre Forward"]
SHORT = {"Goalkeeper": "GK", "Centre Back": "CB", "Left Back": "LB", "Right Back": "RB",
         "Defensive Midfield": "DM", "Central Midfield": "CM", "Attacking Midfield": "AM",
         "Left Wing": "LW", "Right Wing": "RW", "Centre Forward": "CF"}

# Positions next to each other on the pitch (mirrors counted once), for compare.
NEIGHBOURS = [
    ("Centre Back", "Full Back"), ("Centre Back", "Defensive Midfield"),
    ("Full Back", "Defensive Midfield"), ("Full Back", "Winger"),
    ("Defensive Midfield", "Central Midfield"), ("Central Midfield", "Attacking Midfield"),
    ("Central Midfield", "Winger"), ("Attacking Midfield", "Winger"),
    ("Attacking Midfield", "Centre Forward"), ("Winger", "Centre Forward"),
]

# ---------------------------------------------------------------------------
# Mirrors of shared/categoryScoring.ts — keep in sync
# ---------------------------------------------------------------------------

CAP = 5000                  # capScore's ceiling
CLEAN_SHEET_MIN_MINUTES = 60
PASS_ACC_PRIOR = 80
PASS_ACC_PRIOR_PASSES = 10

# category: (seasonal weights table, fixture weights table)
TABLES = {
    "defense":    ("getSeasonDefensive",  "getDefensiveScore"),
    "passing":    ("getSeasonPassing",    "getPassingScore"),
    "possession": ("getSeasonPossession", "getPossessionScore"),
    "attacking":  ("getSeasonAttacking",  "getAttackingScore"),
    "finishing":  ("getSeasonFinishing",  "getFinishingScore"),
    "keeping":    ("getSeasonKeeping",    "getKeeperScore"),
}

SCALE = {"passing": 0.33, "attacking": 0.35, "defense": 0.14, "finishing": 0.75}

KEEP_PERCENTAGES = {"AccuratePassesPercentage"}     # smoothed per match, so it stays
ZERO_IN_MATCHES = {"DuelsLostPer90", "AerialsLostPer90"}   # duplicates of the won counts

SEASON_STATS = {
    "defense": [
        "TacklesPer90", "FoulsPer90", "InterceptionsPer90", "BlockedShotsPer90",
        "Cleansheets", "GoalsConcededPer90", "ClearancesPer90", "CrossesBlockedPer90",
        "AerialsWonPer90", "DuelsWonPercentage", "DribbledPastPer90", "ErrorLeadToGoal",
        "LongBallsWonPer90",
    ],
    "passing": [
        "KeyPassesPer90", "PassesPer90", "AssistsPer90", "AccurateCrossesPer90",
        "ThroughBallsPer90", "BigChancesCreatedPer90", "LongBallsPer90",
        "AccuratePassesPer90", "AccuratePassesPercentage", "ThroughBallsWonPer90",
        "TotalCrossesPer90",
    ],
    "possession": [
        "AccuratePassesPer90", "PassesPer90", "SuccessfulDribblesPer90", "LongBallsWonPer90",
        "DispossessedPer90", "FoulsPer90", "FoulsDrawnPer90", "ShotsOffTargetPer90",
        "KeyPassesPer90", "BigChancesCreatedPer90", "ThroughBallsWonPer90", "OffsidesPer90",
        "AccuratePassesPercentage", "DuelsWonPer90", "LongBallsPer90", "ThroughBallsPer90",
    ],
    "attacking": [
        "AccurateCrossesPer90", "AssistsPer90", "BigChancesCreatedPer90", "BigChancesMissedPer90",
        "GoalsPer90", "KeyPassesPer90", "HitWoodworkPer90", "LongBallsWonPer90",
        "OffsidesPer90", "OwnGoalsPer90", "ShotsBlockedPer90", "ShotsOffTargetPer90",
        "ShotsOnTargetPer90", "SuccessfulDribblesPer90", "DribbleAttemptsPer90",
        "ThroughBallsWonPer90",
    ],
    "finishing": [
        "BigChancesMissedPer90", "GoalsPer90", "HitWoodworkPer90", "OffsidesPer90",
        "ShotsBlockedPer90", "ShotsOffTargetPer90", "ShotsOnTargetPer90", "ShotsTotalPer90",
    ],
    "keeping": [
        "AerialsWonPer90", "Cleansheets", "ClearancesPer90", "DuelsWonPercentage",
        "GoalsConcededPer90", "ErrorLeadToGoal", "FoulsDrawnPer90", "FoulsPer90",
        "LongBallsWonPer90", "SavesPer90", "SavesInsideBoxPer90", "PenaltiesSavedPer90",
    ],
}


def uniq(*lists):
    return list(dict.fromkeys(k for lst in lists for k in lst))


FIXTURE_STATS = {
    "defense": uniq([
        "TacklesPer90", "FoulsPer90", "InterceptionsPer90", "ClearancesPer90", "AerialsWonPer90",
        "DuelsWonPercentage", "Cleansheets", "ErrorLeadToGoal", "DribbledPastPer90", "BlockedShotsPer90",
        "GoalsConcededPer90", "CrossesBlockedPer90", "LongBallsWonPer90", "ClearanceOfflinePer90",
        "ErrorLeadToShotPer90", "LastManTacklePer90", "OffsidesProvokedPer90", "TacklesWonPercentage",
        "DuelsLostPer90", "AerialsLostPer90", "AerialsWonPercentage", "BallRecoveryPer90", "LongBallsWonPercentage",
    ], SEASON_STATS["defense"]),
    "passing": uniq([
        "BigChancesCreatedPer90", "KeyPassesPer90", "AccuratePassesPercentage", "PassesPer90", "AssistsPer90",
        "AccurateCrossesPer90", "ThroughBallsPer90", "ChancesCreatedPer90", "LongBallsPer90", "BackwardPassesPer90",
        "PassesInFinalThirdPer90", "AccuratePassesPer90", "SuccessfulCrossesPercentage",
    ], SEASON_STATS["passing"]),
    "possession": uniq([
        "AccuratePassesPer90", "PassesPer90", "SuccessfulDribblesPer90", "DispossessedPer90", "FoulsPer90",
        "FoulsDrawnPer90", "LongBallsWonPer90", "ShotsOffTargetPer90", "KeyPassesPer90", "BigChancesCreatedPer90",
        "ThroughBallsWonPer90", "OffsidesPer90", "DuelsWonPer90", "TouchesPer90", "PossessionLostPer90",
        "BallRecoveryPer90", "BackwardPassesPer90", "TurnOverPer90", "LongBallsPer90", "LongBallsWonPercentage",
        "AerialsLostPer90", "AerialsWonPercentage", "ThroughBallsPer90",
    ], SEASON_STATS["possession"]),
    "attacking": uniq([
        "AssistsPer90", "BigChancesCreatedPer90", "GoalsPer90", "ShotsOnTargetPer90", "SuccessfulDribblesPer90",
        "KeyPassesPer90", "AccurateCrossesPer90", "BigChancesMissedPer90", "HitWoodworkPer90", "LongBallsWonPer90",
        "OffsidesPer90", "OwnGoalsPer90", "ShotsBlockedPer90", "ShotsOffTargetPer90", "ChancesCreatedPer90",
        "PenaltiesWonPer90", "PassesInFinalThirdPer90", "SuccessfulCrossesPercentage", "DribbleAttemptsPer90",
        "ThroughBallsWonPer90",
    ], SEASON_STATS["attacking"]),
    "finishing": uniq([
        "BigChancesMissedPer90", "GoalsPer90", "HitWoodworkPer90", "BlockedShotsPer90", "ShotsOffTargetPer90",
        "ShotsOnTargetPer90", "OffsidesPer90", "PenaltiesMissedPer90", "PenaltiesScoredPer90", "ShotsTotalPer90",
    ], SEASON_STATS["finishing"]),
    "keeping": uniq([
        "AerialsWonPer90", "Cleansheets", "ClearancesPer90", "GoalsConcededPer90", "ErrorLeadToGoal", "SavesPer90",
        "SavesInsideBoxPer90", "DuelsWonPercentage", "FoulsDrawnPer90", "FoulsPer90", "LongBallsWonPer90",
        "GoalkeeperGoalsConcededPer90", "PunchesPer90", "GoodHighClaimPer90", "PenaltiesSavedPer90",
    ], SEASON_STATS["keeping"]),
}

FIXTURE_KEYS = uniq(*FIXTURE_STATS.values())


# ---------------------------------------------------------------------------
# Scoring — same maths as categoryScoring.ts, over whole columns at once
# ---------------------------------------------------------------------------

def col_key(col):
    return col.replace("_", "").lower()


def stat_key(key):
    return key.lower().removesuffix("per90")


def num(series):
    return pd.to_numeric(series, errors="coerce").fillna(0.0).astype(float)


def weight_of(weights, k):
    if weights is None:
        return 0.0
    v = weights.get(k)
    if v is None or pd.isna(v):
        return 0.0
    return float(v)


def weighted_total(stats, weights, keys, rate):
    """Baseline * rate + every stat * weight, percentage terms also * rate."""
    total = pd.Series(weight_of(weights, "Baseline"), index=stats.index) * rate
    for k in keys:
        w = weight_of(weights, k)
        if w == 0 or k not in stats:
            continue
        term = stats[k] * w
        total = total + (term * rate if k.endswith("Percentage") else term)
    return total


def finish(cat, total, stats):
    if cat == "possession":
        v = total / 700 * stats["AccuratePassesPercentage"]
    elif cat == "keeping":
        v = total / 6
    else:
        v = total * SCALE[cat]
    return v.clip(0, CAP)


def spread(x):
    """Width of the middle 80%; falls back to std when most values tie."""
    s = x.quantile(0.9) - x.quantile(0.1)
    return float(s) if s > 0 else float(x.std() or 0)


# ---------------------------------------------------------------------------
# Data
# ---------------------------------------------------------------------------

def match_frame():
    """current_player_stats rows as the same stat keys matchStats() builds."""
    raw = query(
        f'select * from public."{MATCH_TABLE}" '
        f"where minutes_played > 0 and detailed_position is not null"
    )
    cols = {col_key(c): c for c in raw.columns}

    data, missing = {}, []
    for k in FIXTURE_KEYS:
        c = cols.get(stat_key(k))
        if c is None:
            missing.append(k)
            data[k] = 0.0
        else:
            data[k] = num(raw[c])
    out = pd.DataFrame(data, index=raw.index)

    minutes = num(raw[cols["minutesplayed"]])
    out.loc[minutes < CLEAN_SHEET_MIN_MINUTES, "Cleansheets"] = 0.0
    if "passes" in cols and "accuratepasses" in cols:
        passes, accurate = num(raw[cols["passes"]]), num(raw[cols["accuratepasses"]])
        out["AccuratePassesPercentage"] = (
            (accurate + PASS_ACC_PRIOR_PASSES * PASS_ACC_PRIOR / 100)
            / (passes + PASS_ACC_PRIOR_PASSES) * 100
        )

    out["_minutes"] = minutes
    out["_rate"] = minutes.clip(upper=90) / 90
    out["_pos"] = raw[cols["detailedposition"]]
    return out, missing


def season_frame():
    raw = pd.concat([
        query(f'select * from public."{t}" '
              f'where "MinutesPlayed" >= {SEASON_MIN_MINUTES} and "DetailedPosition" is not null')
        for t in SEASON_TABLES
    ], ignore_index=True)
    keys = uniq(*SEASON_STATS.values(), FIXTURE_KEYS)
    out = pd.DataFrame({k: (num(raw[k]) if k in raw.columns else 0.0) for k in keys}, index=raw.index)
    out["_pos"] = raw["DetailedPosition"]
    return out


def weights_table(name):
    return query(f'select * from public."{name}"').set_index("Position")


def scored_for(cat, pos):
    if pos == "Goalkeeper":
        return cat in ("keeping", "passing")
    return cat != "keeping"


def stored_value(k, v):
    # percentage columns are numeric(5,2) in some tables, Baseline is integer
    # (match Baselines can outgrow smallint), everything else smallint
    if k.endswith("Percentage"):
        return round(float(np.clip(v, -999.99, 999.99)), 2)
    if k == "Baseline":
        return int(np.clip(round(v), -2_000_000_000, 2_000_000_000))
    return int(np.clip(round(v), -32767, 32767))


def group_of(pos):
    return PAIRS.get(pos, pos)


def average_row(rows, keys):
    """One weights row from several (mirror positions); nulls count as 0."""
    return {k: float(np.mean([weight_of(r, k) for r in rows])) for k in keys}


def fmt(v):
    return f"{v:.0f}" if float(v).is_integer() else f"{v:.2f}"


# ---------------------------------------------------------------------------
# Calibrate
# ---------------------------------------------------------------------------

def main():
    print("loading data...")
    season = season_frame()
    match, missing = match_frame()
    if missing:
        print(f"no {MATCH_TABLE} column for: {', '.join(missing)} (these score 0 in matches)")
    full = match[match["_minutes"] >= FULL_GAME_MINUTES]
    print(f"{len(match)} match performances ({len(full)} of {FULL_GAME_MINUTES}+ min), "
          f"{len(season)} season players\n")

    alters, updates, report, skipped = [], [], [], []

    for cat, (season_name, fixture_name) in TABLES.items():
        s_tab, f_tab = weights_table(season_name), weights_table(fixture_name)
        keys = FIXTURE_STATS[cat]

        for c in [k for k in keys if k not in f_tab.columns] + (
                ["Baseline"] if "Baseline" not in f_tab.columns else []):
            kind = ("numeric(5,2)" if c.endswith("Percentage")
                    else "integer" if c == "Baseline" else "smallint")
            alters.append(f'alter table public."{fixture_name}" add column if not exists "{c}" {kind};')

        groups = {}
        for pos in f_tab.index:
            if scored_for(cat, pos):
                groups.setdefault(group_of(pos), []).append(pos)

        # 1. per position: starting weights, data, and the scale it would pick alone
        blocks = []
        for group, members in groups.items():
            members = [p for p in PITCH_ORDER if p in members] or members
            label = " / ".join(members)
            s_rows = [s_tab.loc[p] if p in s_tab.index else None for p in members]
            if all(sum(1 for k in SEASON_STATS[cat] if weight_of(r, k) != 0) >= 3 for r in s_rows):
                source, src_keys, rows = "season", SEASON_STATS[cat], s_rows
            else:
                source, src_keys, rows = "fixture", keys, [f_tab.loc[p] for p in members]
            src_row = average_row(rows, src_keys + ["Baseline"])

            start = {
                k: 0.0 if k in ZERO_IN_MATCHES or (k.endswith("Percentage") and k not in KEEP_PERCENTAGES)
                else weight_of(src_row, k)
                for k in keys
            }

            s_sub = season[season["_pos"].isin(members)]
            m_full = full[full["_pos"].isin(members)]
            if len(s_sub) < MIN_SEASON_PLAYERS or len(m_full) < MIN_FULL_GAMES:
                skipped.append(f"{cat} / {label}: {len(s_sub)} season players, {len(m_full)} full games")
                continue

            # season raw totals (what calculateOverallValuations computes), and
            # match raw totals with the starting weights and no Baseline yet
            season_total = weighted_total(s_sub, src_row, src_keys, 1.0)
            match_total = weighted_total(m_full, start, keys, m_full["_rate"])
            sp_s, sp_m = spread(season_total), spread(match_total)
            own = min(1.0, MATCH_SPREAD * sp_s / sp_m) if sp_s > 0 and sp_m > 0 else 1.0

            blocks.append(dict(members=members, label=label, source=source, start=start,
                               s_sub=s_sub, m_full=m_full, season_total=season_total,
                               match_total=match_total, own=own))

        if not blocks:
            continue

        # 2. one scale for the whole category: the typical position's pick
        scale = float(np.median([b["own"] for b in blocks]))

        # 3. per position: Baseline with the shared scale, then report and SQL
        for b in blocks:
            m_full = b["m_full"]
            baseline = (b["season_total"].median() - scale * b["match_total"].median()) / m_full["_rate"].median()

            new_w = {k: stored_value(k, v * scale) for k, v in b["start"].items()}
            new_w["Baseline"] = stored_value("Baseline", baseline)

            # how it comes out, with the values as they'll be stored
            m_all = match[match["_pos"].isin(b["members"])]
            m_scores = finish(cat, weighted_total(m_all, new_w, keys, m_all["_rate"]), m_all)
            f_scores = m_scores[m_all["_minutes"] >= FULL_GAME_MINUTES]
            s_scores = finish(cat, b["season_total"], b["s_sub"])
            sp_season = spread(s_scores)

            report.append({
                "category": cat, "position": b["label"], "from": b["source"],
                "full_games": len(m_full),
                "scale": round(scale, 2),
                "own_scale": round(b["own"], 2),
                "Baseline": new_w["Baseline"],
                "season_med": round(s_scores.median()),
                "match_med": round(f_scores.median()),
                "match_p10": round(f_scores.quantile(0.1)),
                "match_p90": round(f_scores.quantile(0.9)),
                "swing": round(spread(f_scores) / sp_season, 1) if sp_season > 0 else None,
                "at_0": f"{100 * (f_scores <= 0).mean():.0f}%",
                "at_cap": f"{100 * (f_scores >= CAP).mean():.0f}%",
            })

            sets = ",\n  ".join(f'"{k}" = {v}' for k, v in new_w.items())
            where = ", ".join(f"'{p}'" for p in b["members"])
            updates.append(
                f"-- {cat} / {b['label']}: from {b['source']} weights, category scale {scale:.2f}, "
                f"{len(m_full)} full games\n"
                f'update public."{fixture_name}" set\n  {sets}\n'
                f'where "Position" in ({where});\n'
            )

    df = pd.DataFrame(report)
    if len(df):
        print("Full games only. season_med is the seasonal score for the same position;")
        print("match_med should sit close to it, p10/p90 show the spread.")
        print("scale is shared by the whole category; own_scale is what the position would")
        print(f"have picked alone. swing = match spread / season spread (target {MATCH_SPREAD}).\n")
        print(df.to_string(index=False))
    for s in skipped:
        print(f"skipped (too little data): {s}")

    if updates:
        with open("fixture_weights.sql", "w", encoding="utf-8") as f:
            f.write(f"-- calibrate_fixture.py, {date.today()}, MATCH_SPREAD = {MATCH_SPREAD}\n")
            f.write("-- Deploy the shared scorer first, then run this, then re-score weeks 0 to -4.\n\n")
            f.write("begin;\n\n")
            f.write("\n".join(alters) + ("\n\n" if alters else ""))
            f.write("\n".join(updates))
            f.write("\ncommit;\n")
        print(f"\nWrote {len(updates)} updates to fixture_weights.sql")


# ---------------------------------------------------------------------------
# Compare
# ---------------------------------------------------------------------------

def compare(which):
    if which not in ("season", "fixture"):
        sys.exit("usage: python calibrate_fixture.py compare [season|fixture]")
    idx = 0 if which == "season" else 1

    for cat, tables in TABLES.items():
        name = tables[idx]
        tab = weights_table(name)
        stat_list = SEASON_STATS[cat] if which == "season" else FIXTURE_STATS[cat]
        positions = [p for p in PITCH_ORDER if p in tab.index and scored_for(cat, p)]

        rows = {}
        for k in stat_list + ["Baseline"]:
            vals = [weight_of(tab.loc[p], k) for p in positions]
            if any(vals):
                rows[k] = vals

        print(f"\n=== {cat} ({name}) ===")
        if not rows:
            print("no weights filled in")
            continue
        table = pd.DataFrame(rows, index=[SHORT[p] for p in positions]).T
        print(table.apply(lambda col: col.map(fmt)).to_string())

        flags = []
        for k, vals in rows.items():
            if k == "Baseline":
                continue
            v = dict(zip(positions, vals))

            for a, b in (("Left Back", "Right Back"), ("Left Wing", "Right Wing")):
                if a in v and b in v and v[a] != v[b]:
                    flags.append((0, 0, f"{k}: {SHORT[a]} {fmt(v[a])} vs {SHORT[b]} {fmt(v[b])} "
                                        f"(mirror positions should match)"))

            g = {}
            for p, x in v.items():
                g.setdefault(group_of(p), []).append(x)
            g = {name_: float(np.mean(xs)) for name_, xs in g.items()}
            if not k.endswith("Percentage"):
                g = {name_: float(round(x)) for name_, x in g.items()}

            for a, b in NEIGHBOURS:
                if a not in g or b not in g:
                    continue
                x, y = g[a], g[b]
                if x == 0 and y == 0:
                    continue
                if x == 0 or y == 0:
                    flags.append((2, 0, f"{k}: {a} {fmt(x)}, {b} {fmt(y)} (only one weighted)"))
                elif (x > 0) != (y > 0):
                    flags.append((1, 0, f"{k}: {a} {fmt(x)}, {b} {fmt(y)} (opposite signs)"))
                else:
                    r = max(abs(x), abs(y)) / min(abs(x), abs(y))
                    if r > COMPARE_FLAG:
                        flags.append((3, -r, f"{k}: {a} {fmt(x)} vs {b} {fmt(y)} ({r:.1f}x)"))

        if flags:
            print(f"\nflags ({len(flags)}):")
            for *_, text in sorted(flags):
                print(f"  {text}")
        else:
            print("\nno flags")


if __name__ == "__main__":
    args = sys.argv[1:]
    if not args:
        main()
    elif args[0] == "compare":
        compare(args[1] if len(args) > 1 else "season")
    else:
        sys.exit(__doc__)