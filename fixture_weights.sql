-- calibrate_fixture.py, 2026-10-09, MATCH_SPREAD = 2.0
-- Deploy the shared scorer first, then run this, then re-score weeks 0 to -4.

begin;

alter table public."getDefensiveScore" add column if not exists "Baseline" integer;
alter table public."getPassingScore" add column if not exists "Baseline" integer;
alter table public."getPossessionScore" add column if not exists "Baseline" integer;
alter table public."getAttackingScore" add column if not exists "Baseline" integer;
alter table public."getFinishingScore" add column if not exists "BlockedShotsPer90" smallint;
alter table public."getFinishingScore" add column if not exists "Baseline" integer;

-- defense / Attacking Midfield: from season weights, scale 0.98, 313 full games
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
where "Position" = 'Attacking Midfield';

-- defense / Central Midfield: from season weights, scale 0.95, 1011 full games
update public."getDefensiveScore" set
  "TacklesPer90" = 571,
  "FoulsPer90" = -951,
  "InterceptionsPer90" = 809,
  "ClearancesPer90" = 19,
  "AerialsWonPer90" = 428,
  "DuelsWonPercentage" = 0.0,
  "Cleansheets" = 38,
  "ErrorLeadToGoal" = -285,
  "DribbledPastPer90" = -2474,
  "BlockedShotsPer90" = 571,
  "GoalsConcededPer90" = -1713,
  "CrossesBlockedPer90" = 476,
  "LongBallsWonPer90" = 285,
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
  "Baseline" = 7211
where "Position" = 'Central Midfield';

-- defense / Centre Back: from season weights, scale 0.88, 1241 full games
update public."getDefensiveScore" set
  "TacklesPer90" = 526,
  "FoulsPer90" = -876,
  "InterceptionsPer90" = 526,
  "ClearancesPer90" = 18,
  "AerialsWonPer90" = 570,
  "DuelsWonPercentage" = 0.0,
  "Cleansheets" = 110,
  "ErrorLeadToGoal" = -263,
  "DribbledPastPer90" = -2629,
  "BlockedShotsPer90" = 701,
  "GoalsConcededPer90" = -2366,
  "CrossesBlockedPer90" = 701,
  "LongBallsWonPer90" = 263,
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
  "Baseline" = 9727
where "Position" = 'Centre Back';

-- defense / Centre Forward: from season weights, scale 1.00, 491 full games
update public."getDefensiveScore" set
  "TacklesPer90" = 800,
  "FoulsPer90" = -1000,
  "InterceptionsPer90" = 1050,
  "ClearancesPer90" = 20,
  "AerialsWonPer90" = 450,
  "DuelsWonPercentage" = 0.0,
  "Cleansheets" = 25,
  "ErrorLeadToGoal" = -300,
  "DribbledPastPer90" = -2200,
  "BlockedShotsPer90" = 350,
  "GoalsConcededPer90" = -600,
  "CrossesBlockedPer90" = 400,
  "LongBallsWonPer90" = 300,
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
  "Baseline" = 6143
where "Position" = 'Centre Forward';

-- defense / Defensive Midfield: from season weights, scale 1.00, 36 full games
update public."getDefensiveScore" set
  "TacklesPer90" = 600,
  "FoulsPer90" = -1000,
  "InterceptionsPer90" = 800,
  "ClearancesPer90" = 20,
  "AerialsWonPer90" = 450,
  "DuelsWonPercentage" = 0.0,
  "Cleansheets" = 60,
  "ErrorLeadToGoal" = -300,
  "DribbledPastPer90" = -3000,
  "BlockedShotsPer90" = 700,
  "GoalsConcededPer90" = -2400,
  "CrossesBlockedPer90" = 500,
  "LongBallsWonPer90" = 300,
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
  "Baseline" = 9466
where "Position" = 'Defensive Midfield';

-- defense / Left Back: from season weights, scale 0.90, 369 full games
update public."getDefensiveScore" set
  "TacklesPer90" = 537,
  "FoulsPer90" = -895,
  "InterceptionsPer90" = 627,
  "ClearancesPer90" = 18,
  "AerialsWonPer90" = 403,
  "DuelsWonPercentage" = 0.0,
  "Cleansheets" = 98,
  "ErrorLeadToGoal" = -269,
  "DribbledPastPer90" = -2685,
  "BlockedShotsPer90" = 671,
  "GoalsConcededPer90" = -2148,
  "CrossesBlockedPer90" = 806,
  "LongBallsWonPer90" = 269,
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
  "Baseline" = 9688
where "Position" = 'Left Back';

-- defense / Left Wing: from season weights, scale 0.74, 397 full games
update public."getDefensiveScore" set
  "TacklesPer90" = 445,
  "FoulsPer90" = -742,
  "InterceptionsPer90" = 705,
  "ClearancesPer90" = 15,
  "AerialsWonPer90" = 334,
  "DuelsWonPercentage" = 0.0,
  "Cleansheets" = 30,
  "ErrorLeadToGoal" = -223,
  "DribbledPastPer90" = -1856,
  "BlockedShotsPer90" = 334,
  "GoalsConcededPer90" = -1114,
  "CrossesBlockedPer90" = 594,
  "LongBallsWonPer90" = 223,
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
  "Baseline" = 7913
where "Position" = 'Left Wing';

-- defense / Right Back: from season weights, scale 1.00, 348 full games
update public."getDefensiveScore" set
  "TacklesPer90" = 600,
  "FoulsPer90" = -1000,
  "InterceptionsPer90" = 700,
  "ClearancesPer90" = 20,
  "AerialsWonPer90" = 450,
  "DuelsWonPercentage" = 0.0,
  "Cleansheets" = 110,
  "ErrorLeadToGoal" = -300,
  "DribbledPastPer90" = -3000,
  "BlockedShotsPer90" = 750,
  "GoalsConcededPer90" = -2400,
  "CrossesBlockedPer90" = 900,
  "LongBallsWonPer90" = 300,
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
  "Baseline" = 10236
where "Position" = 'Right Back';

-- defense / Right Wing: from season weights, scale 0.84, 398 full games
update public."getDefensiveScore" set
  "TacklesPer90" = 506,
  "FoulsPer90" = -843,
  "InterceptionsPer90" = 801,
  "ClearancesPer90" = 17,
  "AerialsWonPer90" = 380,
  "DuelsWonPercentage" = 0.0,
  "Cleansheets" = 34,
  "ErrorLeadToGoal" = -253,
  "DribbledPastPer90" = -2108,
  "BlockedShotsPer90" = 380,
  "GoalsConcededPer90" = -1265,
  "CrossesBlockedPer90" = 675,
  "LongBallsWonPer90" = 253,
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
  "Baseline" = 7845
where "Position" = 'Right Wing';

-- passing / Attacking Midfield: from season weights, scale 1.00, 313 full games
update public."getPassingScore" set
  "BigChancesCreatedPer90" = 1250,
  "KeyPassesPer90" = 800,
  "AccuratePassesPercentage" = 20.0,
  "PassesPer90" = 2,
  "AssistsPer90" = 2000,
  "AccurateCrossesPer90" = 400,
  "ThroughBallsPer90" = 70,
  "ChancesCreatedPer90" = 0,
  "LongBallsPer90" = 0,
  "BackwardPassesPer90" = 0,
  "PassesInFinalThirdPer90" = 0,
  "AccuratePassesPer90" = 25,
  "SuccessfulCrossesPercentage" = 0.0,
  "ThroughBallsWonPer90" = 750,
  "TotalCrossesPer90" = 45,
  "Baseline" = 1862
where "Position" = 'Attacking Midfield';

-- passing / Central Midfield: from season weights, scale 0.96, 1011 full games
update public."getPassingScore" set
  "BigChancesCreatedPer90" = 1205,
  "KeyPassesPer90" = 675,
  "AccuratePassesPercentage" = 14.47,
  "PassesPer90" = 2,
  "AssistsPer90" = 1929,
  "AccurateCrossesPer90" = 386,
  "ThroughBallsPer90" = 77,
  "ChancesCreatedPer90" = 0,
  "LongBallsPer90" = 0,
  "BackwardPassesPer90" = 0,
  "PassesInFinalThirdPer90" = 0,
  "AccuratePassesPer90" = 19,
  "SuccessfulCrossesPercentage" = 0.0,
  "ThroughBallsWonPer90" = 723,
  "TotalCrossesPer90" = 43,
  "Baseline" = 1274
where "Position" = 'Central Midfield';

-- passing / Centre Back: from season weights, scale 0.92, 1241 full games
update public."getPassingScore" set
  "BigChancesCreatedPer90" = 1155,
  "KeyPassesPer90" = 555,
  "AccuratePassesPercentage" = 7.39,
  "PassesPer90" = 2,
  "AssistsPer90" = 2218,
  "AccurateCrossesPer90" = 370,
  "ThroughBallsPer90" = 120,
  "ChancesCreatedPer90" = 0,
  "LongBallsPer90" = 0,
  "BackwardPassesPer90" = 0,
  "PassesInFinalThirdPer90" = 0,
  "AccuratePassesPer90" = 9,
  "SuccessfulCrossesPercentage" = 0.0,
  "ThroughBallsWonPer90" = 693,
  "TotalCrossesPer90" = 42,
  "Baseline" = 699
where "Position" = 'Centre Back';

-- passing / Centre Forward: from season weights, scale 0.77, 491 full games
update public."getPassingScore" set
  "BigChancesCreatedPer90" = 967,
  "KeyPassesPer90" = 541,
  "AccuratePassesPercentage" = 30.93,
  "PassesPer90" = 2,
  "AssistsPer90" = 1701,
  "AccurateCrossesPer90" = 309,
  "ThroughBallsPer90" = 77,
  "ChancesCreatedPer90" = 0,
  "LongBallsPer90" = 0,
  "BackwardPassesPer90" = 0,
  "PassesInFinalThirdPer90" = 0,
  "AccuratePassesPer90" = 35,
  "SuccessfulCrossesPercentage" = 0.0,
  "ThroughBallsWonPer90" = 580,
  "TotalCrossesPer90" = 35,
  "Baseline" = 1185
where "Position" = 'Centre Forward';

-- passing / Defensive Midfield: from season weights, scale 1.00, 36 full games
update public."getPassingScore" set
  "BigChancesCreatedPer90" = 1250,
  "KeyPassesPer90" = 600,
  "AccuratePassesPercentage" = 10.0,
  "PassesPer90" = 2,
  "AssistsPer90" = 2000,
  "AccurateCrossesPer90" = 400,
  "ThroughBallsPer90" = 100,
  "ChancesCreatedPer90" = 0,
  "LongBallsPer90" = 0,
  "BackwardPassesPer90" = 0,
  "PassesInFinalThirdPer90" = 0,
  "AccuratePassesPer90" = 12,
  "SuccessfulCrossesPercentage" = 0.0,
  "ThroughBallsWonPer90" = 750,
  "TotalCrossesPer90" = 45,
  "Baseline" = 744
where "Position" = 'Defensive Midfield';

-- passing / Goalkeeper: from season weights, scale 1.00, 576 full games
update public."getPassingScore" set
  "BigChancesCreatedPer90" = 1250,
  "KeyPassesPer90" = 700,
  "AccuratePassesPercentage" = 40.0,
  "PassesPer90" = 2,
  "AssistsPer90" = 2200,
  "AccurateCrossesPer90" = 400,
  "ThroughBallsPer90" = 130,
  "ChancesCreatedPer90" = 0,
  "LongBallsPer90" = 0,
  "BackwardPassesPer90" = 0,
  "PassesInFinalThirdPer90" = 0,
  "AccuratePassesPer90" = 10,
  "SuccessfulCrossesPercentage" = 0.0,
  "ThroughBallsWonPer90" = 750,
  "TotalCrossesPer90" = 45,
  "Baseline" = -101
where "Position" = 'Goalkeeper';

-- passing / Left Back: from season weights, scale 0.75, 369 full games
update public."getPassingScore" set
  "BigChancesCreatedPer90" = 940,
  "KeyPassesPer90" = 451,
  "AccuratePassesPercentage" = 9.02,
  "PassesPer90" = 2,
  "AssistsPer90" = 1503,
  "AccurateCrossesPer90" = 451,
  "ThroughBallsPer90" = 75,
  "ChancesCreatedPer90" = 0,
  "LongBallsPer90" = 0,
  "BackwardPassesPer90" = 0,
  "PassesInFinalThirdPer90" = 0,
  "AccuratePassesPer90" = 11,
  "SuccessfulCrossesPercentage" = 0.0,
  "ThroughBallsWonPer90" = 564,
  "TotalCrossesPer90" = 34,
  "Baseline" = 1546
where "Position" = 'Left Back';

-- passing / Left Wing: from season weights, scale 0.58, 397 full games
update public."getPassingScore" set
  "BigChancesCreatedPer90" = 724,
  "KeyPassesPer90" = 347,
  "AccuratePassesPercentage" = 20.27,
  "PassesPer90" = 1,
  "AssistsPer90" = 1158,
  "AccurateCrossesPer90" = 347,
  "ThroughBallsPer90" = 46,
  "ChancesCreatedPer90" = 0,
  "LongBallsPer90" = 0,
  "BackwardPassesPer90" = 0,
  "PassesInFinalThirdPer90" = 0,
  "AccuratePassesPer90" = 23,
  "SuccessfulCrossesPercentage" = 0.0,
  "ThroughBallsWonPer90" = 434,
  "TotalCrossesPer90" = 26,
  "Baseline" = 3075
where "Position" = 'Left Wing';

-- passing / Right Back: from season weights, scale 1.00, 348 full games
update public."getPassingScore" set
  "BigChancesCreatedPer90" = 1250,
  "KeyPassesPer90" = 600,
  "AccuratePassesPercentage" = 12.0,
  "PassesPer90" = 2,
  "AssistsPer90" = 2000,
  "AccurateCrossesPer90" = 600,
  "ThroughBallsPer90" = 100,
  "ChancesCreatedPer90" = 0,
  "LongBallsPer90" = 0,
  "BackwardPassesPer90" = 0,
  "PassesInFinalThirdPer90" = 0,
  "AccuratePassesPer90" = 15,
  "SuccessfulCrossesPercentage" = 0.0,
  "ThroughBallsWonPer90" = 750,
  "TotalCrossesPer90" = 45,
  "Baseline" = 717
where "Position" = 'Right Back';

-- passing / Right Wing: from season weights, scale 0.86, 398 full games
update public."getPassingScore" set
  "BigChancesCreatedPer90" = 1073,
  "KeyPassesPer90" = 515,
  "AccuratePassesPercentage" = 30.05,
  "PassesPer90" = 2,
  "AssistsPer90" = 1717,
  "AccurateCrossesPer90" = 515,
  "ThroughBallsPer90" = 69,
  "ChancesCreatedPer90" = 0,
  "LongBallsPer90" = 0,
  "BackwardPassesPer90" = 0,
  "PassesInFinalThirdPer90" = 0,
  "AccuratePassesPer90" = 34,
  "SuccessfulCrossesPercentage" = 0.0,
  "ThroughBallsWonPer90" = 644,
  "TotalCrossesPer90" = 39,
  "Baseline" = 1992
where "Position" = 'Right Wing';

-- possession / Right Wing: from season weights, scale 1.00, 398 full games
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
  "Baseline" = 403
where "Position" = 'Right Wing';

-- possession / Attacking Midfield: from season weights, scale 1.00, 313 full games
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
where "Position" = 'Attacking Midfield';

-- possession / Central Midfield: from season weights, scale 0.93, 1011 full games
update public."getPossessionScore" set
  "AccuratePassesPer90" = 56,
  "PassesPer90" = 0,
  "SuccessfulDribblesPer90" = 232,
  "DispossessedPer90" = -371,
  "FoulsPer90" = -278,
  "FoulsDrawnPer90" = 371,
  "LongBallsWonPer90" = 185,
  "ShotsOffTargetPer90" = -56,
  "KeyPassesPer90" = 93,
  "BigChancesCreatedPer90" = 139,
  "ThroughBallsWonPer90" = 74,
  "OffsidesPer90" = -74,
  "DuelsWonPer90" = 139,
  "TouchesPer90" = 0,
  "PossessionLostPer90" = 0,
  "BallRecoveryPer90" = 0,
  "BackwardPassesPer90" = 0,
  "TurnOverPer90" = 0,
  "LongBallsPer90" = -74,
  "LongBallsWonPercentage" = 0.0,
  "AerialsLostPer90" = 0,
  "AerialsWonPercentage" = 0.0,
  "ThroughBallsPer90" = 37,
  "AccuratePassesPercentage" = 111.16,
  "Baseline" = 1366
where "Position" = 'Central Midfield';

-- possession / Centre Back: from season weights, scale 1.00, 1241 full games
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
  "AccuratePassesPercentage" = 79.97,
  "Baseline" = 293
where "Position" = 'Centre Back';

-- possession / Centre Forward: from season weights, scale 1.00, 491 full games
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
where "Position" = 'Centre Forward';

-- possession / Defensive Midfield: from season weights, scale 1.00, 36 full games
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
where "Position" = 'Defensive Midfield';

-- possession / Left Back: from season weights, scale 1.00, 369 full games
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
  "Baseline" = 543
where "Position" = 'Left Back';

-- possession / Left Wing: from season weights, scale 0.95, 397 full games
update public."getPossessionScore" set
  "AccuratePassesPer90" = 76,
  "PassesPer90" = 0,
  "SuccessfulDribblesPer90" = 171,
  "DispossessedPer90" = -285,
  "FoulsPer90" = -285,
  "FoulsDrawnPer90" = 304,
  "LongBallsWonPer90" = 190,
  "ShotsOffTargetPer90" = -57,
  "KeyPassesPer90" = 85,
  "BigChancesCreatedPer90" = 114,
  "ThroughBallsWonPer90" = 66,
  "OffsidesPer90" = -76,
  "DuelsWonPer90" = 142,
  "TouchesPer90" = 0,
  "PossessionLostPer90" = 0,
  "BallRecoveryPer90" = 0,
  "BackwardPassesPer90" = 0,
  "TurnOverPer90" = 0,
  "LongBallsPer90" = -76,
  "LongBallsWonPercentage" = 0.0,
  "AerialsLostPer90" = 0,
  "AerialsWonPercentage" = 0.0,
  "ThroughBallsPer90" = 38,
  "AccuratePassesPercentage" = 161.49,
  "Baseline" = 1893
where "Position" = 'Left Wing';

-- possession / Right Back: from season weights, scale 1.00, 348 full games
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
  "Baseline" = 662
where "Position" = 'Right Back';

-- attacking / Attacking Midfield: from season weights, scale 0.86, 313 full games
update public."getAttackingScore" set
  "AssistsPer90" = 2504,
  "BigChancesCreatedPer90" = 1640,
  "GoalsPer90" = 648,
  "ShotsOnTargetPer90" = 389,
  "SuccessfulDribblesPer90" = 1036,
  "KeyPassesPer90" = 475,
  "AccurateCrossesPer90" = 432,
  "BigChancesMissedPer90" = -173,
  "HitWoodworkPer90" = 0,
  "LongBallsWonPer90" = 259,
  "OffsidesPer90" = -173,
  "OwnGoalsPer90" = 0,
  "ShotsBlockedPer90" = -130,
  "ShotsOffTargetPer90" = -130,
  "ChancesCreatedPer90" = 0,
  "PenaltiesWonPer90" = 1122,
  "PassesInFinalThirdPer90" = 0,
  "SuccessfulCrossesPercentage" = 0.0,
  "DribbleAttemptsPer90" = 17,
  "ThroughBallsWonPer90" = 259,
  "Baseline" = 1882
where "Position" = 'Attacking Midfield';

-- attacking / Central Midfield: from season weights, scale 0.76, 1011 full games
update public."getAttackingScore" set
  "AssistsPer90" = 2522,
  "BigChancesCreatedPer90" = 1682,
  "GoalsPer90" = 688,
  "ShotsOnTargetPer90" = 420,
  "SuccessfulDribblesPer90" = 1147,
  "KeyPassesPer90" = 497,
  "AccurateCrossesPer90" = 459,
  "BigChancesMissedPer90" = -153,
  "HitWoodworkPer90" = 0,
  "LongBallsWonPer90" = 191,
  "OffsidesPer90" = -153,
  "OwnGoalsPer90" = 0,
  "ShotsBlockedPer90" = -115,
  "ShotsOffTargetPer90" = -115,
  "ChancesCreatedPer90" = 0,
  "PenaltiesWonPer90" = 1223,
  "PassesInFinalThirdPer90" = 0,
  "SuccessfulCrossesPercentage" = 0.0,
  "DribbleAttemptsPer90" = 15,
  "ThroughBallsWonPer90" = 268,
  "Baseline" = 2142
where "Position" = 'Central Midfield';

-- attacking / Centre Back: from season weights, scale 0.73, 1241 full games
update public."getAttackingScore" set
  "AssistsPer90" = 2922,
  "BigChancesCreatedPer90" = 2045,
  "GoalsPer90" = 950,
  "ShotsOnTargetPer90" = 511,
  "SuccessfulDribblesPer90" = 1461,
  "KeyPassesPer90" = 657,
  "AccurateCrossesPer90" = 584,
  "BigChancesMissedPer90" = -146,
  "HitWoodworkPer90" = 0,
  "LongBallsWonPer90" = 110,
  "OffsidesPer90" = -146,
  "OwnGoalsPer90" = 0,
  "ShotsBlockedPer90" = -110,
  "ShotsOffTargetPer90" = -110,
  "ChancesCreatedPer90" = 0,
  "PenaltiesWonPer90" = 1534,
  "PassesInFinalThirdPer90" = 0,
  "SuccessfulCrossesPercentage" = 0.0,
  "DribbleAttemptsPer90" = 15,
  "ThroughBallsWonPer90" = 365,
  "Baseline" = 911
where "Position" = 'Centre Back';

-- attacking / Centre Forward: from season weights, scale 0.80, 491 full games
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
  "PenaltiesWonPer90" = 884,
  "PassesInFinalThirdPer90" = 0,
  "SuccessfulCrossesPercentage" = 0.0,
  "DribbleAttemptsPer90" = 8,
  "ThroughBallsWonPer90" = 322,
  "Baseline" = 650
where "Position" = 'Centre Forward';

-- attacking / Defensive Midfield: from season weights, scale 1.00, 36 full games
update public."getAttackingScore" set
  "AssistsPer90" = 3600,
  "BigChancesCreatedPer90" = 2500,
  "GoalsPer90" = 1100,
  "ShotsOnTargetPer90" = 650,
  "SuccessfulDribblesPer90" = 1800,
  "KeyPassesPer90" = 800,
  "AccurateCrossesPer90" = 700,
  "BigChancesMissedPer90" = -200,
  "HitWoodworkPer90" = 0,
  "LongBallsWonPer90" = 200,
  "OffsidesPer90" = -200,
  "OwnGoalsPer90" = 0,
  "ShotsBlockedPer90" = -150,
  "ShotsOffTargetPer90" = -150,
  "ChancesCreatedPer90" = 0,
  "PenaltiesWonPer90" = 1900,
  "PassesInFinalThirdPer90" = 0,
  "SuccessfulCrossesPercentage" = 0.0,
  "DribbleAttemptsPer90" = 20,
  "ThroughBallsWonPer90" = 400,
  "Baseline" = 804
where "Position" = 'Defensive Midfield';

-- attacking / Left Back: from season weights, scale 0.89, 369 full games
update public."getAttackingScore" set
  "AssistsPer90" = 3010,
  "BigChancesCreatedPer90" = 2036,
  "GoalsPer90" = 974,
  "ShotsOnTargetPer90" = 575,
  "SuccessfulDribblesPer90" = 1505,
  "KeyPassesPer90" = 620,
  "AccurateCrossesPer90" = 354,
  "BigChancesMissedPer90" = -177,
  "HitWoodworkPer90" = 0,
  "LongBallsWonPer90" = 221,
  "OffsidesPer90" = -177,
  "OwnGoalsPer90" = 0,
  "ShotsBlockedPer90" = -133,
  "ShotsOffTargetPer90" = -133,
  "ChancesCreatedPer90" = 0,
  "PenaltiesWonPer90" = 1593,
  "PassesInFinalThirdPer90" = 0,
  "SuccessfulCrossesPercentage" = 0.0,
  "DribbleAttemptsPer90" = 18,
  "ThroughBallsWonPer90" = 354,
  "Baseline" = 1160
where "Position" = 'Left Back';

-- attacking / Left Wing: from season weights, scale 0.84, 397 full games
update public."getAttackingScore" set
  "AssistsPer90" = 2339,
  "BigChancesCreatedPer90" = 1503,
  "GoalsPer90" = 585,
  "ShotsOnTargetPer90" = 334,
  "SuccessfulDribblesPer90" = 835,
  "KeyPassesPer90" = 418,
  "AccurateCrossesPer90" = 334,
  "BigChancesMissedPer90" = -167,
  "HitWoodworkPer90" = 0,
  "LongBallsWonPer90" = 251,
  "OffsidesPer90" = -167,
  "OwnGoalsPer90" = 0,
  "ShotsBlockedPer90" = -125,
  "ShotsOffTargetPer90" = -125,
  "ChancesCreatedPer90" = 0,
  "PenaltiesWonPer90" = 919,
  "PassesInFinalThirdPer90" = 0,
  "SuccessfulCrossesPercentage" = 0.0,
  "DribbleAttemptsPer90" = 17,
  "ThroughBallsWonPer90" = 251,
  "Baseline" = 1708
where "Position" = 'Left Wing';

-- attacking / Right Back: from season weights, scale 0.68, 348 full games
update public."getAttackingScore" set
  "AssistsPer90" = 2298,
  "BigChancesCreatedPer90" = 1555,
  "GoalsPer90" = 744,
  "ShotsOnTargetPer90" = 439,
  "SuccessfulDribblesPer90" = 1149,
  "KeyPassesPer90" = 473,
  "AccurateCrossesPer90" = 270,
  "BigChancesMissedPer90" = -135,
  "HitWoodworkPer90" = 0,
  "LongBallsWonPer90" = 169,
  "OffsidesPer90" = -135,
  "OwnGoalsPer90" = 0,
  "ShotsBlockedPer90" = -101,
  "ShotsOffTargetPer90" = -101,
  "ChancesCreatedPer90" = 0,
  "PenaltiesWonPer90" = 1217,
  "PassesInFinalThirdPer90" = 0,
  "SuccessfulCrossesPercentage" = 0.0,
  "DribbleAttemptsPer90" = 14,
  "ThroughBallsWonPer90" = 270,
  "Baseline" = 1364
where "Position" = 'Right Back';

-- attacking / Right Wing: from season weights, scale 1.00, 398 full games
update public."getAttackingScore" set
  "AssistsPer90" = 2800,
  "BigChancesCreatedPer90" = 1800,
  "GoalsPer90" = 700,
  "ShotsOnTargetPer90" = 400,
  "SuccessfulDribblesPer90" = 1000,
  "KeyPassesPer90" = 500,
  "AccurateCrossesPer90" = 400,
  "BigChancesMissedPer90" = -200,
  "HitWoodworkPer90" = 0,
  "LongBallsWonPer90" = 300,
  "OffsidesPer90" = -200,
  "OwnGoalsPer90" = 0,
  "ShotsBlockedPer90" = -150,
  "ShotsOffTargetPer90" = -150,
  "ChancesCreatedPer90" = 0,
  "PenaltiesWonPer90" = 1100,
  "PassesInFinalThirdPer90" = 0,
  "SuccessfulCrossesPercentage" = 0.0,
  "DribbleAttemptsPer90" = 20,
  "ThroughBallsWonPer90" = 300,
  "Baseline" = 1059
where "Position" = 'Right Wing';

-- finishing / Attacking Midfield: from season weights, scale 0.58, 313 full games
update public."getFinishingScore" set
  "BigChancesMissedPer90" = -466,
  "GoalsPer90" = 1924,
  "HitWoodworkPer90" = 163,
  "BlockedShotsPer90" = 0,
  "ShotsOffTargetPer90" = -26,
  "ShotsOnTargetPer90" = 321,
  "OffsidesPer90" = -233,
  "PenaltiesMissedPer90" = -816,
  "PenaltiesScoredPer90" = 0,
  "ShotsTotalPer90" = 105,
  "ShotsBlockedPer90" = 38,
  "Baseline" = 1581
where "Position" = 'Attacking Midfield';

-- finishing / Central Midfield: from season weights, scale 1.00, 1011 full games
update public."getFinishingScore" set
  "BigChancesMissedPer90" = -650,
  "GoalsPer90" = 3500,
  "HitWoodworkPer90" = 350,
  "BlockedShotsPer90" = 0,
  "ShotsOffTargetPer90" = -40,
  "ShotsOnTargetPer90" = 700,
  "OffsidesPer90" = -350,
  "PenaltiesMissedPer90" = -1300,
  "PenaltiesScoredPer90" = 0,
  "ShotsTotalPer90" = 210,
  "ShotsBlockedPer90" = 75,
  "Baseline" = 1081
where "Position" = 'Central Midfield';

-- finishing / Centre Back: from season weights, scale 1.00, 1241 full games
update public."getFinishingScore" set
  "BigChancesMissedPer90" = -500,
  "GoalsPer90" = 3700,
  "HitWoodworkPer90" = 420,
  "BlockedShotsPer90" = 0,
  "ShotsOffTargetPer90" = -35,
  "ShotsOnTargetPer90" = 850,
  "OffsidesPer90" = -300,
  "PenaltiesMissedPer90" = -1200,
  "PenaltiesScoredPer90" = 0,
  "ShotsTotalPer90" = 250,
  "ShotsBlockedPer90" = 90,
  "Baseline" = 660
where "Position" = 'Centre Back';

-- finishing / Centre Forward: from season weights, scale 0.63, 491 full games
update public."getFinishingScore" set
  "BigChancesMissedPer90" = -626,
  "GoalsPer90" = 1877,
  "HitWoodworkPer90" = 125,
  "BlockedShotsPer90" = 0,
  "ShotsOffTargetPer90" = -31,
  "ShotsOnTargetPer90" = 250,
  "OffsidesPer90" = -313,
  "PenaltiesMissedPer90" = -938,
  "PenaltiesScoredPer90" = 0,
  "ShotsTotalPer90" = 94,
  "ShotsBlockedPer90" = 31,
  "Baseline" = 1722
where "Position" = 'Centre Forward';

-- finishing / Defensive Midfield: from season weights, scale 1.00, 36 full games
update public."getFinishingScore" set
  "BigChancesMissedPer90" = -450,
  "GoalsPer90" = 3800,
  "HitWoodworkPer90" = 450,
  "BlockedShotsPer90" = 0,
  "ShotsOffTargetPer90" = -30,
  "ShotsOnTargetPer90" = 900,
  "OffsidesPer90" = -300,
  "PenaltiesMissedPer90" = -1200,
  "PenaltiesScoredPer90" = 0,
  "ShotsTotalPer90" = 260,
  "ShotsBlockedPer90" = 95,
  "Baseline" = 806
where "Position" = 'Defensive Midfield';

-- finishing / Left Back: from season weights, scale 1.00, 369 full games
update public."getFinishingScore" set
  "BigChancesMissedPer90" = -500,
  "GoalsPer90" = 3700,
  "HitWoodworkPer90" = 420,
  "BlockedShotsPer90" = 0,
  "ShotsOffTargetPer90" = -35,
  "ShotsOnTargetPer90" = 850,
  "OffsidesPer90" = -300,
  "PenaltiesMissedPer90" = -1200,
  "PenaltiesScoredPer90" = 0,
  "ShotsTotalPer90" = 250,
  "ShotsBlockedPer90" = 90,
  "Baseline" = 711
where "Position" = 'Left Back';

-- finishing / Left Wing: from season weights, scale 0.43, 397 full games
update public."getFinishingScore" set
  "BigChancesMissedPer90" = -390,
  "GoalsPer90" = 1388,
  "HitWoodworkPer90" = 108,
  "BlockedShotsPer90" = 0,
  "ShotsOffTargetPer90" = -22,
  "ShotsOnTargetPer90" = 217,
  "OffsidesPer90" = -195,
  "PenaltiesMissedPer90" = -629,
  "PenaltiesScoredPer90" = 0,
  "ShotsTotalPer90" = 74,
  "ShotsBlockedPer90" = 26,
  "Baseline" = 1438
where "Position" = 'Left Wing';

-- finishing / Right Back: from season weights, scale 1.00, 348 full games
update public."getFinishingScore" set
  "BigChancesMissedPer90" = -500,
  "GoalsPer90" = 3700,
  "HitWoodworkPer90" = 420,
  "BlockedShotsPer90" = 0,
  "ShotsOffTargetPer90" = -35,
  "ShotsOnTargetPer90" = 850,
  "OffsidesPer90" = -300,
  "PenaltiesMissedPer90" = -1200,
  "PenaltiesScoredPer90" = 0,
  "ShotsTotalPer90" = 250,
  "ShotsBlockedPer90" = 90,
  "Baseline" = 758
where "Position" = 'Right Back';

-- finishing / Right Wing: from season weights, scale 0.70, 398 full games
update public."getFinishingScore" set
  "BigChancesMissedPer90" = -630,
  "GoalsPer90" = 2241,
  "HitWoodworkPer90" = 175,
  "BlockedShotsPer90" = 0,
  "ShotsOffTargetPer90" = -35,
  "ShotsOnTargetPer90" = 350,
  "OffsidesPer90" = -315,
  "PenaltiesMissedPer90" = -1015,
  "PenaltiesScoredPer90" = 0,
  "ShotsTotalPer90" = 119,
  "ShotsBlockedPer90" = 42,
  "Baseline" = 1465
where "Position" = 'Right Wing';

-- keeping / Goalkeeper: from season weights, scale 0.81, 576 full games
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
where "Position" = 'Goalkeeper';

commit;
