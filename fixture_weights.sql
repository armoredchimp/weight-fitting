-- calibrate_fixture.py, 2026-10-10, MATCH_SPREAD = 2.0
-- Deploy the shared scorer first, then run this, then re-score weeks 0 to -4.

begin;

alter table public."getDefensiveScore" add column if not exists "Baseline" integer;
alter table public."getPassingScore" add column if not exists "Baseline" integer;
alter table public."getPossessionScore" add column if not exists "Baseline" integer;
alter table public."getAttackingScore" add column if not exists "Baseline" integer;
alter table public."getFinishingScore" add column if not exists "BlockedShotsPer90" smallint;
alter table public."getFinishingScore" add column if not exists "Baseline" integer;

-- defense / Attacking Midfield: from season weights, category scale 0.98, 313 full games
update public."getDefensiveScore" set
  "TacklesPer90" = 590,
  "FoulsPer90" = -984,
  "InterceptionsPer90" = 836,
  "ClearancesPer90" = 20,
  "AerialsWonPer90" = 443,
  "DuelsWonPercentage" = 0.0,
  "Cleansheets" = 30,
  "ErrorLeadToGoal" = -295,
  "DribbledPastPer90" = -2360,
  "BlockedShotsPer90" = 443,
  "GoalsConcededPer90" = -1377,
  "CrossesBlockedPer90" = 393,
  "LongBallsWonPer90" = 295,
  "ClearanceOfflinePer90" = 0,
  "ErrorLeadToShotPer90" = 0,
  "LastManTacklePer90" = 0,
  "OffsidesProvokedPer90" = 0,
  "TacklesWonPercentage" = 0.0,
  "DuelsLostPer90" = 0,
  "AerialsLostPer90" = 0,
  "AerialsWonPercentage" = 0.0,
  "BallRecoveryPer90" = 0,
  "LongBallsWonPercentage" = 0.0,
  "Baseline" = 7413
where "Position" in ('Attacking Midfield');

-- defense / Central Midfield: from season weights, category scale 0.98, 1011 full games
update public."getDefensiveScore" set
  "TacklesPer90" = 590,
  "FoulsPer90" = -984,
  "InterceptionsPer90" = 836,
  "ClearancesPer90" = 20,
  "AerialsWonPer90" = 443,
  "DuelsWonPercentage" = 0.0,
  "Cleansheets" = 39,
  "ErrorLeadToGoal" = -295,
  "DribbledPastPer90" = -2557,
  "BlockedShotsPer90" = 590,
  "GoalsConcededPer90" = -1770,
  "CrossesBlockedPer90" = 492,
  "LongBallsWonPer90" = 295,
  "ClearanceOfflinePer90" = 0,
  "ErrorLeadToShotPer90" = 0,
  "LastManTacklePer90" = 0,
  "OffsidesProvokedPer90" = 0,
  "TacklesWonPercentage" = 0.0,
  "DuelsLostPer90" = 0,
  "AerialsLostPer90" = 0,
  "AerialsWonPercentage" = 0.0,
  "BallRecoveryPer90" = 0,
  "LongBallsWonPercentage" = 0.0,
  "Baseline" = 7281
where "Position" in ('Central Midfield');

-- defense / Centre Back: from season weights, category scale 0.98, 1241 full games
update public."getDefensiveScore" set
  "TacklesPer90" = 590,
  "FoulsPer90" = -984,
  "InterceptionsPer90" = 590,
  "ClearancesPer90" = 20,
  "AerialsWonPer90" = 639,
  "DuelsWonPercentage" = 0.0,
  "Cleansheets" = 123,
  "ErrorLeadToGoal" = -295,
  "DribbledPastPer90" = -2951,
  "BlockedShotsPer90" = 787,
  "GoalsConcededPer90" = -2655,
  "CrossesBlockedPer90" = 787,
  "LongBallsWonPer90" = 295,
  "ClearanceOfflinePer90" = 0,
  "ErrorLeadToShotPer90" = 0,
  "LastManTacklePer90" = 0,
  "OffsidesProvokedPer90" = 0,
  "TacklesWonPercentage" = 0.0,
  "DuelsLostPer90" = 0,
  "AerialsLostPer90" = 0,
  "AerialsWonPercentage" = 0.0,
  "BallRecoveryPer90" = 0,
  "LongBallsWonPercentage" = 0.0,
  "Baseline" = 9848
where "Position" in ('Centre Back');

-- defense / Centre Forward: from season weights, category scale 0.98, 491 full games
update public."getDefensiveScore" set
  "TacklesPer90" = 787,
  "FoulsPer90" = -984,
  "InterceptionsPer90" = 1033,
  "ClearancesPer90" = 20,
  "AerialsWonPer90" = 443,
  "DuelsWonPercentage" = 0.0,
  "Cleansheets" = 25,
  "ErrorLeadToGoal" = -295,
  "DribbledPastPer90" = -2164,
  "BlockedShotsPer90" = 344,
  "GoalsConcededPer90" = -590,
  "CrossesBlockedPer90" = 393,
  "LongBallsWonPer90" = 295,
  "ClearanceOfflinePer90" = 0,
  "ErrorLeadToShotPer90" = 0,
  "LastManTacklePer90" = 0,
  "OffsidesProvokedPer90" = 0,
  "TacklesWonPercentage" = 0.0,
  "DuelsLostPer90" = 0,
  "AerialsLostPer90" = 0,
  "AerialsWonPercentage" = 0.0,
  "BallRecoveryPer90" = 0,
  "LongBallsWonPercentage" = 0.0,
  "Baseline" = 6127
where "Position" in ('Centre Forward');

-- defense / Defensive Midfield: from season weights, category scale 0.98, 36 full games
update public."getDefensiveScore" set
  "TacklesPer90" = 590,
  "FoulsPer90" = -984,
  "InterceptionsPer90" = 787,
  "ClearancesPer90" = 20,
  "AerialsWonPer90" = 443,
  "DuelsWonPercentage" = 0.0,
  "Cleansheets" = 59,
  "ErrorLeadToGoal" = -295,
  "DribbledPastPer90" = -2951,
  "BlockedShotsPer90" = 688,
  "GoalsConcededPer90" = -2360,
  "CrossesBlockedPer90" = 492,
  "LongBallsWonPer90" = 295,
  "ClearanceOfflinePer90" = 0,
  "ErrorLeadToShotPer90" = 0,
  "LastManTacklePer90" = 0,
  "OffsidesProvokedPer90" = 0,
  "TacklesWonPercentage" = 0.0,
  "DuelsLostPer90" = 0,
  "AerialsLostPer90" = 0,
  "AerialsWonPercentage" = 0.0,
  "BallRecoveryPer90" = 0,
  "LongBallsWonPercentage" = 0.0,
  "Baseline" = 9406
where "Position" in ('Defensive Midfield');

-- defense / Left Back / Right Back: from season weights, category scale 0.98, 717 full games
update public."getDefensiveScore" set
  "TacklesPer90" = 590,
  "FoulsPer90" = -984,
  "InterceptionsPer90" = 688,
  "ClearancesPer90" = 20,
  "AerialsWonPer90" = 443,
  "DuelsWonPercentage" = 0.0,
  "Cleansheets" = 108,
  "ErrorLeadToGoal" = -295,
  "DribbledPastPer90" = -2951,
  "BlockedShotsPer90" = 738,
  "GoalsConcededPer90" = -2360,
  "CrossesBlockedPer90" = 885,
  "LongBallsWonPer90" = 295,
  "ClearanceOfflinePer90" = 0,
  "ErrorLeadToShotPer90" = 0,
  "LastManTacklePer90" = 0,
  "OffsidesProvokedPer90" = 0,
  "TacklesWonPercentage" = 0.0,
  "DuelsLostPer90" = 0,
  "AerialsLostPer90" = 0,
  "AerialsWonPercentage" = 0.0,
  "BallRecoveryPer90" = 0,
  "LongBallsWonPercentage" = 0.0,
  "Baseline" = 10130
where "Position" in ('Left Back', 'Right Back');

-- defense / Left Wing / Right Wing: from season weights, category scale 0.98, 795 full games
update public."getDefensiveScore" set
  "TacklesPer90" = 590,
  "FoulsPer90" = -984,
  "InterceptionsPer90" = 934,
  "ClearancesPer90" = 20,
  "AerialsWonPer90" = 443,
  "DuelsWonPercentage" = 0.0,
  "Cleansheets" = 39,
  "ErrorLeadToGoal" = -295,
  "DribbledPastPer90" = -2459,
  "BlockedShotsPer90" = 443,
  "GoalsConcededPer90" = -1475,
  "CrossesBlockedPer90" = 787,
  "LongBallsWonPer90" = 295,
  "ClearanceOfflinePer90" = 0,
  "ErrorLeadToShotPer90" = 0,
  "LastManTacklePer90" = 0,
  "OffsidesProvokedPer90" = 0,
  "TacklesWonPercentage" = 0.0,
  "DuelsLostPer90" = 0,
  "AerialsLostPer90" = 0,
  "AerialsWonPercentage" = 0.0,
  "BallRecoveryPer90" = 0,
  "LongBallsWonPercentage" = 0.0,
  "Baseline" = 8135
where "Position" in ('Left Wing', 'Right Wing');

-- passing / Attacking Midfield: from season weights, category scale 0.95, 313 full games
update public."getPassingScore" set
  "BigChancesCreatedPer90" = 1183,
  "KeyPassesPer90" = 757,
  "AccuratePassesPercentage" = 18.93,
  "PassesPer90" = 2,
  "AssistsPer90" = 1893,
  "AccurateCrossesPer90" = 379,
  "ThroughBallsPer90" = 66,
  "ChancesCreatedPer90" = 0,
  "LongBallsPer90" = 0,
  "BackwardPassesPer90" = 0,
  "PassesInFinalThirdPer90" = 0,
  "AccuratePassesPer90" = 24,
  "SuccessfulCrossesPercentage" = 0.0,
  "ThroughBallsWonPer90" = 710,
  "TotalCrossesPer90" = 43,
  "Baseline" = 2072
where "Position" in ('Attacking Midfield');

-- passing / Central Midfield: from season weights, category scale 0.95, 1011 full games
update public."getPassingScore" set
  "BigChancesCreatedPer90" = 1183,
  "KeyPassesPer90" = 663,
  "AccuratePassesPercentage" = 14.2,
  "PassesPer90" = 2,
  "AssistsPer90" = 1893,
  "AccurateCrossesPer90" = 379,
  "ThroughBallsPer90" = 76,
  "ChancesCreatedPer90" = 0,
  "LongBallsPer90" = 0,
  "BackwardPassesPer90" = 0,
  "PassesInFinalThirdPer90" = 0,
  "AccuratePassesPer90" = 19,
  "SuccessfulCrossesPercentage" = 0.0,
  "ThroughBallsWonPer90" = 710,
  "TotalCrossesPer90" = 43,
  "Baseline" = 1327
where "Position" in ('Central Midfield');

-- passing / Centre Back: from season weights, category scale 0.95, 1241 full games
update public."getPassingScore" set
  "BigChancesCreatedPer90" = 1183,
  "KeyPassesPer90" = 568,
  "AccuratePassesPercentage" = 7.57,
  "PassesPer90" = 2,
  "AssistsPer90" = 2272,
  "AccurateCrossesPer90" = 379,
  "ThroughBallsPer90" = 123,
  "ChancesCreatedPer90" = 0,
  "LongBallsPer90" = 0,
  "BackwardPassesPer90" = 0,
  "PassesInFinalThirdPer90" = 0,
  "AccuratePassesPer90" = 9,
  "SuccessfulCrossesPercentage" = 0.0,
  "ThroughBallsWonPer90" = 710,
  "TotalCrossesPer90" = 43,
  "Baseline" = 668
where "Position" in ('Centre Back');

-- passing / Centre Forward: from season weights, category scale 0.95, 491 full games
update public."getPassingScore" set
  "BigChancesCreatedPer90" = 1183,
  "KeyPassesPer90" = 663,
  "AccuratePassesPercentage" = 37.86,
  "PassesPer90" = 2,
  "AssistsPer90" = 2082,
  "AccurateCrossesPer90" = 379,
  "ThroughBallsPer90" = 95,
  "ChancesCreatedPer90" = 0,
  "LongBallsPer90" = 0,
  "BackwardPassesPer90" = 0,
  "PassesInFinalThirdPer90" = 0,
  "AccuratePassesPer90" = 43,
  "SuccessfulCrossesPercentage" = 0.0,
  "ThroughBallsWonPer90" = 710,
  "TotalCrossesPer90" = 43,
  "Baseline" = 432
where "Position" in ('Centre Forward');

-- passing / Defensive Midfield: from season weights, category scale 0.95, 36 full games
update public."getPassingScore" set
  "BigChancesCreatedPer90" = 1183,
  "KeyPassesPer90" = 568,
  "AccuratePassesPercentage" = 9.47,
  "PassesPer90" = 2,
  "AssistsPer90" = 1893,
  "AccurateCrossesPer90" = 379,
  "ThroughBallsPer90" = 95,
  "ChancesCreatedPer90" = 0,
  "LongBallsPer90" = 0,
  "BackwardPassesPer90" = 0,
  "PassesInFinalThirdPer90" = 0,
  "AccuratePassesPer90" = 11,
  "SuccessfulCrossesPercentage" = 0.0,
  "ThroughBallsWonPer90" = 710,
  "TotalCrossesPer90" = 43,
  "Baseline" = 847
where "Position" in ('Defensive Midfield');

-- passing / Goalkeeper: from season weights, category scale 0.95, 576 full games
update public."getPassingScore" set
  "BigChancesCreatedPer90" = 1183,
  "KeyPassesPer90" = 663,
  "AccuratePassesPercentage" = 37.86,
  "PassesPer90" = 2,
  "AssistsPer90" = 2082,
  "AccurateCrossesPer90" = 379,
  "ThroughBallsPer90" = 123,
  "ChancesCreatedPer90" = 0,
  "LongBallsPer90" = 0,
  "BackwardPassesPer90" = 0,
  "PassesInFinalThirdPer90" = 0,
  "AccuratePassesPer90" = 9,
  "SuccessfulCrossesPercentage" = 0.0,
  "ThroughBallsWonPer90" = 710,
  "TotalCrossesPer90" = 43,
  "Baseline" = 73
where "Position" in ('Goalkeeper');

-- passing / Left Back / Right Back: from season weights, category scale 0.95, 717 full games
update public."getPassingScore" set
  "BigChancesCreatedPer90" = 1183,
  "KeyPassesPer90" = 568,
  "AccuratePassesPercentage" = 11.36,
  "PassesPer90" = 2,
  "AssistsPer90" = 1893,
  "AccurateCrossesPer90" = 568,
  "ThroughBallsPer90" = 95,
  "ChancesCreatedPer90" = 0,
  "LongBallsPer90" = 0,
  "BackwardPassesPer90" = 0,
  "PassesInFinalThirdPer90" = 0,
  "AccuratePassesPer90" = 14,
  "SuccessfulCrossesPercentage" = 0.0,
  "ThroughBallsWonPer90" = 710,
  "TotalCrossesPer90" = 43,
  "Baseline" = 968
where "Position" in ('Left Back', 'Right Back');

-- passing / Left Wing / Right Wing: from season weights, category scale 0.95, 795 full games
update public."getPassingScore" set
  "BigChancesCreatedPer90" = 1183,
  "KeyPassesPer90" = 568,
  "AccuratePassesPercentage" = 33.13,
  "PassesPer90" = 2,
  "AssistsPer90" = 1893,
  "AccurateCrossesPer90" = 568,
  "ThroughBallsPer90" = 76,
  "ChancesCreatedPer90" = 0,
  "LongBallsPer90" = 0,
  "BackwardPassesPer90" = 0,
  "PassesInFinalThirdPer90" = 0,
  "AccuratePassesPer90" = 38,
  "SuccessfulCrossesPercentage" = 0.0,
  "ThroughBallsWonPer90" = 710,
  "TotalCrossesPer90" = 43,
  "Baseline" = 1197
where "Position" in ('Left Wing', 'Right Wing');

-- possession / Left Wing / Right Wing: from season weights, category scale 1.00, 795 full games
update public."getPossessionScore" set
  "AccuratePassesPer90" = 80,
  "PassesPer90" = 0,
  "SuccessfulDribblesPer90" = 180,
  "DispossessedPer90" = -300,
  "FoulsPer90" = -300,
  "FoulsDrawnPer90" = 320,
  "LongBallsWonPer90" = 200,
  "ShotsOffTargetPer90" = -60,
  "KeyPassesPer90" = 90,
  "BigChancesCreatedPer90" = 120,
  "ThroughBallsWonPer90" = 70,
  "OffsidesPer90" = -80,
  "DuelsWonPer90" = 150,
  "TouchesPer90" = 0,
  "PossessionLostPer90" = 0,
  "BallRecoveryPer90" = 0,
  "BackwardPassesPer90" = 0,
  "TurnOverPer90" = 0,
  "LongBallsPer90" = -80,
  "LongBallsWonPercentage" = 0.0,
  "AerialsLostPer90" = 0,
  "AerialsWonPercentage" = 0.0,
  "ThroughBallsPer90" = 40,
  "AccuratePassesPercentage" = 170.0,
  "Baseline" = 631
where "Position" in ('Left Wing', 'Right Wing');

-- possession / Attacking Midfield: from season weights, category scale 1.00, 313 full games
update public."getPossessionScore" set
  "AccuratePassesPer90" = 70,
  "PassesPer90" = 0,
  "SuccessfulDribblesPer90" = 220,
  "DispossessedPer90" = -350,
  "FoulsPer90" = -300,
  "FoulsDrawnPer90" = 380,
  "LongBallsWonPer90" = 200,
  "ShotsOffTargetPer90" = -60,
  "KeyPassesPer90" = 90,
  "BigChancesCreatedPer90" = 130,
  "ThroughBallsWonPer90" = 70,
  "OffsidesPer90" = -80,
  "DuelsWonPer90" = 150,
  "TouchesPer90" = 0,
  "PossessionLostPer90" = 0,
  "BallRecoveryPer90" = 0,
  "BackwardPassesPer90" = 0,
  "TurnOverPer90" = 0,
  "LongBallsPer90" = -80,
  "LongBallsWonPercentage" = 0.0,
  "AerialsLostPer90" = 0,
  "AerialsWonPercentage" = 0.0,
  "ThroughBallsPer90" = 40,
  "AccuratePassesPercentage" = 150.0,
  "Baseline" = 2127
where "Position" in ('Attacking Midfield');

-- possession / Central Midfield: from season weights, category scale 1.00, 1011 full games
update public."getPossessionScore" set
  "AccuratePassesPer90" = 60,
  "PassesPer90" = 0,
  "SuccessfulDribblesPer90" = 250,
  "DispossessedPer90" = -400,
  "FoulsPer90" = -300,
  "FoulsDrawnPer90" = 400,
  "LongBallsWonPer90" = 200,
  "ShotsOffTargetPer90" = -60,
  "KeyPassesPer90" = 100,
  "BigChancesCreatedPer90" = 150,
  "ThroughBallsWonPer90" = 80,
  "OffsidesPer90" = -80,
  "DuelsWonPer90" = 150,
  "TouchesPer90" = 0,
  "PossessionLostPer90" = 0,
  "BallRecoveryPer90" = 0,
  "BackwardPassesPer90" = 0,
  "TurnOverPer90" = 0,
  "LongBallsPer90" = -80,
  "LongBallsWonPercentage" = 0.0,
  "AerialsLostPer90" = 0,
  "AerialsWonPercentage" = 0.0,
  "ThroughBallsPer90" = 40,
  "AccuratePassesPercentage" = 120.0,
  "Baseline" = 400
where "Position" in ('Central Midfield');

-- possession / Centre Back: from season weights, category scale 1.00, 1241 full games
update public."getPossessionScore" set
  "AccuratePassesPer90" = 40,
  "PassesPer90" = 0,
  "SuccessfulDribblesPer90" = 350,
  "DispossessedPer90" = -550,
  "FoulsPer90" = -300,
  "FoulsDrawnPer90" = 450,
  "LongBallsWonPer90" = 200,
  "ShotsOffTargetPer90" = -60,
  "KeyPassesPer90" = 120,
  "BigChancesCreatedPer90" = 190,
  "ThroughBallsWonPer90" = 100,
  "OffsidesPer90" = -80,
  "DuelsWonPer90" = 150,
  "TouchesPer90" = 0,
  "PossessionLostPer90" = 0,
  "BallRecoveryPer90" = 0,
  "BackwardPassesPer90" = 0,
  "TurnOverPer90" = 0,
  "LongBallsPer90" = -80,
  "LongBallsWonPercentage" = 0.0,
  "AerialsLostPer90" = 0,
  "AerialsWonPercentage" = 0.0,
  "ThroughBallsPer90" = 40,
  "AccuratePassesPercentage" = 80.0,
  "Baseline" = 289
where "Position" in ('Centre Back');

-- possession / Centre Forward: from season weights, category scale 1.00, 491 full games
update public."getPossessionScore" set
  "AccuratePassesPer90" = 90,
  "PassesPer90" = 0,
  "SuccessfulDribblesPer90" = 300,
  "DispossessedPer90" = -280,
  "FoulsPer90" = -300,
  "FoulsDrawnPer90" = 450,
  "LongBallsWonPer90" = 200,
  "ShotsOffTargetPer90" = -60,
  "KeyPassesPer90" = 100,
  "BigChancesCreatedPer90" = 140,
  "ThroughBallsWonPer90" = 80,
  "OffsidesPer90" = -80,
  "DuelsWonPer90" = 150,
  "TouchesPer90" = 0,
  "PossessionLostPer90" = 0,
  "BallRecoveryPer90" = 0,
  "BackwardPassesPer90" = 0,
  "TurnOverPer90" = 0,
  "LongBallsPer90" = -80,
  "LongBallsWonPercentage" = 0.0,
  "AerialsLostPer90" = 0,
  "AerialsWonPercentage" = 0.0,
  "ThroughBallsPer90" = 40,
  "AccuratePassesPercentage" = 190.0,
  "Baseline" = -832
where "Position" in ('Centre Forward');

-- possession / Defensive Midfield: from season weights, category scale 1.00, 36 full games
update public."getPossessionScore" set
  "AccuratePassesPer90" = 50,
  "PassesPer90" = 0,
  "SuccessfulDribblesPer90" = 280,
  "DispossessedPer90" = -500,
  "FoulsPer90" = -300,
  "FoulsDrawnPer90" = 420,
  "LongBallsWonPer90" = 200,
  "ShotsOffTargetPer90" = -60,
  "KeyPassesPer90" = 110,
  "BigChancesCreatedPer90" = 170,
  "ThroughBallsWonPer90" = 90,
  "OffsidesPer90" = -80,
  "DuelsWonPer90" = 150,
  "TouchesPer90" = 0,
  "PossessionLostPer90" = 0,
  "BallRecoveryPer90" = 0,
  "BackwardPassesPer90" = 0,
  "TurnOverPer90" = 0,
  "LongBallsPer90" = -80,
  "LongBallsWonPercentage" = 0.0,
  "AerialsLostPer90" = 0,
  "AerialsWonPercentage" = 0.0,
  "ThroughBallsPer90" = 40,
  "AccuratePassesPercentage" = 100.0,
  "Baseline" = 644
where "Position" in ('Defensive Midfield');

-- possession / Left Back / Right Back: from season weights, category scale 1.00, 717 full games
update public."getPossessionScore" set
  "AccuratePassesPer90" = 50,
  "PassesPer90" = 0,
  "SuccessfulDribblesPer90" = 280,
  "DispossessedPer90" = -450,
  "FoulsPer90" = -300,
  "FoulsDrawnPer90" = 400,
  "LongBallsWonPer90" = 200,
  "ShotsOffTargetPer90" = -60,
  "KeyPassesPer90" = 100,
  "BigChancesCreatedPer90" = 160,
  "ThroughBallsWonPer90" = 90,
  "OffsidesPer90" = -80,
  "DuelsWonPer90" = 150,
  "TouchesPer90" = 0,
  "PossessionLostPer90" = 0,
  "BallRecoveryPer90" = 0,
  "BackwardPassesPer90" = 0,
  "TurnOverPer90" = 0,
  "LongBallsPer90" = -80,
  "LongBallsWonPercentage" = 0.0,
  "AerialsLostPer90" = 0,
  "AerialsWonPercentage" = 0.0,
  "ThroughBallsPer90" = 40,
  "AccuratePassesPercentage" = 90.0,
  "Baseline" = 639
where "Position" in ('Left Back', 'Right Back');

-- attacking / Attacking Midfield: from season weights, category scale 0.80, 313 full games
update public."getAttackingScore" set
  "AssistsPer90" = 2331,
  "BigChancesCreatedPer90" = 1527,
  "GoalsPer90" = 603,
  "ShotsOnTargetPer90" = 362,
  "SuccessfulDribblesPer90" = 965,
  "KeyPassesPer90" = 442,
  "AccurateCrossesPer90" = 402,
  "BigChancesMissedPer90" = -161,
  "HitWoodworkPer90" = 0,
  "LongBallsWonPer90" = 241,
  "OffsidesPer90" = -161,
  "OwnGoalsPer90" = 0,
  "ShotsBlockedPer90" = -121,
  "ShotsOffTargetPer90" = -121,
  "ChancesCreatedPer90" = 0,
  "PenaltiesWonPer90" = 0,
  "PassesInFinalThirdPer90" = 0,
  "SuccessfulCrossesPercentage" = 0.0,
  "DribbleAttemptsPer90" = 16,
  "ThroughBallsWonPer90" = 241,
  "Baseline" = 2063
where "Position" in ('Attacking Midfield');

-- attacking / Central Midfield: from season weights, category scale 0.80, 1011 full games
update public."getAttackingScore" set
  "AssistsPer90" = 2653,
  "BigChancesCreatedPer90" = 1769,
  "GoalsPer90" = 724,
  "ShotsOnTargetPer90" = 442,
  "SuccessfulDribblesPer90" = 1206,
  "KeyPassesPer90" = 523,
  "AccurateCrossesPer90" = 482,
  "BigChancesMissedPer90" = -161,
  "HitWoodworkPer90" = 0,
  "LongBallsWonPer90" = 201,
  "OffsidesPer90" = -161,
  "OwnGoalsPer90" = 0,
  "ShotsBlockedPer90" = -121,
  "ShotsOffTargetPer90" = -121,
  "ChancesCreatedPer90" = 0,
  "PenaltiesWonPer90" = 0,
  "PassesInFinalThirdPer90" = 0,
  "SuccessfulCrossesPercentage" = 0.0,
  "DribbleAttemptsPer90" = 16,
  "ThroughBallsWonPer90" = 281,
  "Baseline" = 2053
where "Position" in ('Central Midfield');

-- attacking / Centre Back: from season weights, category scale 0.80, 1241 full games
update public."getAttackingScore" set
  "AssistsPer90" = 3216,
  "BigChancesCreatedPer90" = 2251,
  "GoalsPer90" = 1045,
  "ShotsOnTargetPer90" = 563,
  "SuccessfulDribblesPer90" = 1608,
  "KeyPassesPer90" = 724,
  "AccurateCrossesPer90" = 643,
  "BigChancesMissedPer90" = -161,
  "HitWoodworkPer90" = 0,
  "LongBallsWonPer90" = 121,
  "OffsidesPer90" = -161,
  "OwnGoalsPer90" = 0,
  "ShotsBlockedPer90" = -121,
  "ShotsOffTargetPer90" = -121,
  "ChancesCreatedPer90" = 0,
  "PenaltiesWonPer90" = 0,
  "PassesInFinalThirdPer90" = 0,
  "SuccessfulCrossesPercentage" = 0.0,
  "DribbleAttemptsPer90" = 16,
  "ThroughBallsWonPer90" = 402,
  "Baseline" = 856
where "Position" in ('Centre Back');

-- attacking / Centre Forward: from season weights, category scale 0.80, 491 full games
update public."getAttackingScore" set
  "AssistsPer90" = 2412,
  "BigChancesCreatedPer90" = 1608,
  "GoalsPer90" = 402,
  "ShotsOnTargetPer90" = 241,
  "SuccessfulDribblesPer90" = 1367,
  "KeyPassesPer90" = 563,
  "AccurateCrossesPer90" = 482,
  "BigChancesMissedPer90" = -402,
  "HitWoodworkPer90" = 0,
  "LongBallsWonPer90" = 161,
  "OffsidesPer90" = -161,
  "OwnGoalsPer90" = 0,
  "ShotsBlockedPer90" = -161,
  "ShotsOffTargetPer90" = -161,
  "ChancesCreatedPer90" = 0,
  "PenaltiesWonPer90" = 0,
  "PassesInFinalThirdPer90" = 0,
  "SuccessfulCrossesPercentage" = 0.0,
  "DribbleAttemptsPer90" = 8,
  "ThroughBallsWonPer90" = 322,
  "Baseline" = 731
where "Position" in ('Centre Forward');

-- attacking / Defensive Midfield: from season weights, category scale 0.80, 36 full games
update public."getAttackingScore" set
  "AssistsPer90" = 2894,
  "BigChancesCreatedPer90" = 2010,
  "GoalsPer90" = 884,
  "ShotsOnTargetPer90" = 523,
  "SuccessfulDribblesPer90" = 1447,
  "KeyPassesPer90" = 643,
  "AccurateCrossesPer90" = 563,
  "BigChancesMissedPer90" = -161,
  "HitWoodworkPer90" = 0,
  "LongBallsWonPer90" = 161,
  "OffsidesPer90" = -161,
  "OwnGoalsPer90" = 0,
  "ShotsBlockedPer90" = -121,
  "ShotsOffTargetPer90" = -121,
  "ChancesCreatedPer90" = 0,
  "PenaltiesWonPer90" = 0,
  "PassesInFinalThirdPer90" = 0,
  "SuccessfulCrossesPercentage" = 0.0,
  "DribbleAttemptsPer90" = 16,
  "ThroughBallsWonPer90" = 322,
  "Baseline" = 1123
where "Position" in ('Defensive Midfield');

-- attacking / Left Back / Right Back: from season weights, category scale 0.80, 717 full games
update public."getAttackingScore" set
  "AssistsPer90" = 2733,
  "BigChancesCreatedPer90" = 1849,
  "GoalsPer90" = 884,
  "ShotsOnTargetPer90" = 523,
  "SuccessfulDribblesPer90" = 1367,
  "KeyPassesPer90" = 563,
  "AccurateCrossesPer90" = 322,
  "BigChancesMissedPer90" = -161,
  "HitWoodworkPer90" = 0,
  "LongBallsWonPer90" = 201,
  "OffsidesPer90" = -161,
  "OwnGoalsPer90" = 0,
  "ShotsBlockedPer90" = -121,
  "ShotsOffTargetPer90" = -121,
  "ChancesCreatedPer90" = 0,
  "PenaltiesWonPer90" = 0,
  "PassesInFinalThirdPer90" = 0,
  "SuccessfulCrossesPercentage" = 0.0,
  "DribbleAttemptsPer90" = 16,
  "ThroughBallsWonPer90" = 322,
  "Baseline" = 1226
where "Position" in ('Left Back', 'Right Back');

-- attacking / Left Wing / Right Wing: from season weights, category scale 0.80, 795 full games
update public."getAttackingScore" set
  "AssistsPer90" = 2251,
  "BigChancesCreatedPer90" = 1447,
  "GoalsPer90" = 563,
  "ShotsOnTargetPer90" = 322,
  "SuccessfulDribblesPer90" = 804,
  "KeyPassesPer90" = 402,
  "AccurateCrossesPer90" = 322,
  "BigChancesMissedPer90" = -161,
  "HitWoodworkPer90" = 0,
  "LongBallsWonPer90" = 241,
  "OffsidesPer90" = -161,
  "OwnGoalsPer90" = 0,
  "ShotsBlockedPer90" = -121,
  "ShotsOffTargetPer90" = -121,
  "ChancesCreatedPer90" = 0,
  "PenaltiesWonPer90" = 0,
  "PassesInFinalThirdPer90" = 0,
  "SuccessfulCrossesPercentage" = 0.0,
  "DribbleAttemptsPer90" = 16,
  "ThroughBallsWonPer90" = 241,
  "Baseline" = 1772
where "Position" in ('Left Wing', 'Right Wing');

-- finishing / Attacking Midfield: from season weights, category scale 1.00, 313 full games
update public."getFinishingScore" set
  "BigChancesMissedPer90" = -800,
  "GoalsPer90" = 3300,
  "HitWoodworkPer90" = 280,
  "BlockedShotsPer90" = 0,
  "ShotsOffTargetPer90" = -45,
  "ShotsOnTargetPer90" = 550,
  "OffsidesPer90" = -400,
  "PenaltiesMissedPer90" = 0,
  "PenaltiesScoredPer90" = 0,
  "ShotsTotalPer90" = 180,
  "ShotsBlockedPer90" = 65,
  "Baseline" = 1418
where "Position" in ('Attacking Midfield');

-- finishing / Central Midfield: from season weights, category scale 1.00, 1011 full games
update public."getFinishingScore" set
  "BigChancesMissedPer90" = -650,
  "GoalsPer90" = 3500,
  "HitWoodworkPer90" = 350,
  "BlockedShotsPer90" = 0,
  "ShotsOffTargetPer90" = -40,
  "ShotsOnTargetPer90" = 700,
  "OffsidesPer90" = -350,
  "PenaltiesMissedPer90" = 0,
  "PenaltiesScoredPer90" = 0,
  "ShotsTotalPer90" = 210,
  "ShotsBlockedPer90" = 75,
  "Baseline" = 1081
where "Position" in ('Central Midfield');

-- finishing / Centre Back: from season weights, category scale 1.00, 1241 full games
update public."getFinishingScore" set
  "BigChancesMissedPer90" = -500,
  "GoalsPer90" = 3700,
  "HitWoodworkPer90" = 420,
  "BlockedShotsPer90" = 0,
  "ShotsOffTargetPer90" = -35,
  "ShotsOnTargetPer90" = 850,
  "OffsidesPer90" = -300,
  "PenaltiesMissedPer90" = 0,
  "PenaltiesScoredPer90" = 0,
  "ShotsTotalPer90" = 250,
  "ShotsBlockedPer90" = 90,
  "Baseline" = 660
where "Position" in ('Centre Back');

-- finishing / Centre Forward: from season weights, category scale 1.00, 491 full games
update public."getFinishingScore" set
  "BigChancesMissedPer90" = -1000,
  "GoalsPer90" = 3000,
  "HitWoodworkPer90" = 200,
  "BlockedShotsPer90" = 0,
  "ShotsOffTargetPer90" = -50,
  "ShotsOnTargetPer90" = 400,
  "OffsidesPer90" = -500,
  "PenaltiesMissedPer90" = 0,
  "PenaltiesScoredPer90" = 0,
  "ShotsTotalPer90" = 150,
  "ShotsBlockedPer90" = 50,
  "Baseline" = 1627
where "Position" in ('Centre Forward');

-- finishing / Defensive Midfield: from season weights, category scale 1.00, 36 full games
update public."getFinishingScore" set
  "BigChancesMissedPer90" = -450,
  "GoalsPer90" = 3800,
  "HitWoodworkPer90" = 450,
  "BlockedShotsPer90" = 0,
  "ShotsOffTargetPer90" = -30,
  "ShotsOnTargetPer90" = 900,
  "OffsidesPer90" = -300,
  "PenaltiesMissedPer90" = 0,
  "PenaltiesScoredPer90" = 0,
  "ShotsTotalPer90" = 260,
  "ShotsBlockedPer90" = 95,
  "Baseline" = 806
where "Position" in ('Defensive Midfield');

-- finishing / Left Back / Right Back: from season weights, category scale 1.00, 717 full games
update public."getFinishingScore" set
  "BigChancesMissedPer90" = -500,
  "GoalsPer90" = 3700,
  "HitWoodworkPer90" = 420,
  "BlockedShotsPer90" = 0,
  "ShotsOffTargetPer90" = -35,
  "ShotsOnTargetPer90" = 850,
  "OffsidesPer90" = -300,
  "PenaltiesMissedPer90" = 0,
  "PenaltiesScoredPer90" = 0,
  "ShotsTotalPer90" = 250,
  "ShotsBlockedPer90" = 90,
  "Baseline" = 724
where "Position" in ('Left Back', 'Right Back');

-- finishing / Left Wing / Right Wing: from season weights, category scale 1.00, 795 full games
update public."getFinishingScore" set
  "BigChancesMissedPer90" = -900,
  "GoalsPer90" = 3200,
  "HitWoodworkPer90" = 250,
  "BlockedShotsPer90" = 0,
  "ShotsOffTargetPer90" = -50,
  "ShotsOnTargetPer90" = 500,
  "OffsidesPer90" = -450,
  "PenaltiesMissedPer90" = 0,
  "PenaltiesScoredPer90" = 0,
  "ShotsTotalPer90" = 170,
  "ShotsBlockedPer90" = 60,
  "Baseline" = 1347
where "Position" in ('Left Wing', 'Right Wing');

-- keeping / Goalkeeper: from season weights, category scale 0.81, 576 full games
update public."getKeeperScore" set
  "AerialsWonPer90" = 122,
  "Cleansheets" = 162,
  "ClearancesPer90" = 81,
  "GoalsConcededPer90" = -1785,
  "ErrorLeadToGoal" = -487,
  "SavesPer90" = 0,
  "SavesInsideBoxPer90" = 243,
  "DuelsWonPercentage" = 0.0,
  "FoulsDrawnPer90" = 49,
  "FoulsPer90" = -243,
  "LongBallsWonPer90" = 122,
  "GoalkeeperGoalsConcededPer90" = 0,
  "PunchesPer90" = 0,
  "GoodHighClaimPer90" = 0,
  "PenaltiesSavedPer90" = 649,
  "Baseline" = 4804
where "Position" in ('Goalkeeper');

commit;
