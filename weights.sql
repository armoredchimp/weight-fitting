-- keeping / Goalkeeper — 23 tiered, 92% of pairs satisfied
update public."getSeasonKeeping" set
  "SavesPer90" = 0,
  "SavesInsideBoxPer90" = 0,
  "PenaltiesSavedPer90" = 3000,
  "Cleansheets" = 20,
  "ClearancesPer90" = 0,
  "AerialsWonPer90" = 0,
  "DuelsWonPercentage" = 0,
  "LongBallsWonPer90" = 11,
  "FoulsDrawnPer90" = 68,
  "GoalsConcededPer90" = -599,
  "ErrorLeadToGoal" = -19,
  "FoulsPer90" = -46,
  "Baseline" = 300
where "Position" = 'Goalkeeper';
