-- finishing / Centre Forward — 33 tiered, 99% of pairs satisfied
update public."getSeasonFinishing" set
  "GoalsPer90" = 3000,
  "ShotsOnTargetPer90" = 400,
  "BigChancesMissedPer90" = -1000,
  "OffsidesPer90" = -500,
  "ShotsOffTargetPer90" = -50,
  "PenaltiesMissedPer90" = -1500,
  "HitWoodworkPer90" = 200,
  "ShotsBlockedPer90" = 50,
  "ShotsTotalPer90" = 150,
  "Baseline" = 700
where "Position" = 'Centre Forward';
