-- passing / Central Midfield — 40 tiered, 99% of pairs satisfied
update public."getSeasonPassing" set
  "KeyPassesPer90" = 600,
  "PassesPer90" = 2,
  "AssistsPer90" = 2000,
  "AccurateCrossesPer90" = 500,
  "ThroughBallsPer90" = 80,
  "BigChancesCreatedPer90" = 1400,
  "AccuratePassesPer90" = 20,
  "AccuratePassesPercentage" = 15,
  "ThroughBallsWonPer90" = 900,
  "LongBallsPer90" = -15,
  "TotalCrossesPer90" = 40,
  "Baseline" = 450
where "Position" = 'Central Midfield';
