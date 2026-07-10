# Suite Variant Results Log

Append-only. Record launch, package, validation, and decision events for
the suite-first campaign.

## 2026-07-08 - Campaign Opened

- User-directed continuation after the post-N10 negative-map PASS.
- Premise: 8-design screen correlation with full RTLLM is weak, so
  natural variants should be probed directly on full RTLLM.
- Initial registry: `variant_registry.csv`.
- First registered wave: `wave_a_preregistration.md`.

## 2026-07-08 - S01 Capacity 7 Seed 1001

- Launched S01 capacity7 over full RTLLM 50 with seed 1001:
  `exp/natural_qd_push/suite_variants_wave_a_20260708_104148_UTC/live/capacity7/seed_1001`.
- vLLM preflight recorded:
  `preflights/s01_capacity7_seed1001_20260708_104148_UTC.json`.
- Runtime completed normally in 4746.45 seconds with 4801 total LLM API
  calls.
- Package:
  `S01_capacity7/seed_1001/`.
- Validation:
  `tables/run_validation.json` passes against the full 50-problem RTLLM
  manifest. The PPA/HV headline package remains scoped to the 46
  reference-complete problems, matching P3.
- Operator audit:
  `tables/operator_contract.csv` passes; S01 has
  `single_thought_count=0`.
- Seed read:
  classic `0.111401` HV / `0.090551` AUC46 / `33` covered;
  V2 `0.096767` HV / `0.083539` AUC46 / `32` covered;
  S01 `0.089605` HV / `0.077978` AUC46 / `34` covered.
- Decision:
  do not promote on seed 1001 alone. Complete seed 1002 because Wave A
  treats one suite seed as a runtime/extraction gate and the user
  explicitly reopened full-suite probing after weak screen-transfer
  evidence.

## 2026-07-08 - S01 Capacity 7 Seed 1002

- Launched S01 capacity7 over full RTLLM 50 with seed 1002:
  `exp/natural_qd_push/suite_variants_wave_a_20260708_120949_UTC/live/capacity7/seed_1002`.
- vLLM preflight recorded:
  `preflights/s01_capacity7_seed1002_20260708_120949_UTC.json`.
- Runtime completed normally in 6315.58 seconds with 4800 total LLM API
  calls.
- Package:
  `S01_capacity7/seed_1002/`.
- Validation:
  `tables/run_validation.json` passes against the full 50-problem RTLLM
  manifest. The PPA/HV headline package remains scoped to the 46
  reference-complete problems, matching P3.
- Operator audit:
  `tables/operator_contract.csv` passes; S01 has
  `single_thought_count=0`.
- Seed read:
  classic `0.097557` HV / `0.081183` AUC46 / `33` covered;
  V2 `0.100310` HV / `0.090753` AUC46 / `33` covered;
  S01 `0.094507` HV / `0.086806` AUC46 / `33` covered.
- Two-seed S01 read:
  classic `0.104479` HV / `0.085867` AUC46 / `66/92` covered;
  V2 `0.098539` HV / `0.087146` AUC46 / `65/92` covered;
  S01 `0.092056` HV / `0.082392` AUC46 / `67/92` covered.
- Decision:
  S01 is not a primary promotion candidate. The tiny coverage gain does
  not justify a 5-seed confirmation because mean HV and HV-AUC remain
  below both classic and V2.

## 2026-07-08 - S02 Warmup 16 Seed 1001

- Launched S02 warmup16 over full RTLLM 50 with seed 1001:
  `exp/natural_qd_push/suite_variants_wave_a_20260708_120949_UTC/live/warmup16/seed_1001`.
- vLLM preflight recorded:
  `preflights/s02_warmup16_seed1001_20260708_120949_UTC.json`.
- Runtime completed normally in 6345.74 seconds with 4800 total LLM API
  calls.
- Package:
  `S02_warmup16/seed_1001/`.
- Validation:
  `tables/run_validation.json` passes against the full 50-problem RTLLM
  manifest. The PPA/HV headline package remains scoped to the 46
  reference-complete problems, matching P3.
- Operator audit:
  `tables/operator_contract.csv` passes; S02 has
  `single_thought_count=0`.
- Seed read:
  classic `0.111401` HV / `0.090551` AUC46 / `33` covered;
  V2 `0.096767` HV / `0.083539` AUC46 / `32` covered;
  S02 `0.097150` HV / `0.089942` AUC46 / `31` covered.
- Decision:
  complete seed 1002. Warmup16 is not a primary win on seed 1001, but it
  improves over V2 on HV and HV-AUC and nearly matches classic AUC with a
  clean, natural initialization-only mechanism.

## 2026-07-08 - S02 Warmup 16 Seed 1002

- Launched S02 warmup16 over full RTLLM 50 with seed 1002:
  `exp/natural_qd_push/suite_variants_wave_a_20260708_140623_UTC/live/warmup16/seed_1002`.
- vLLM preflight recorded:
  `preflights/s02_warmup16_seed1002_20260708_140623_UTC.json`.
- Runtime completed normally in 6257.36 seconds with 4800 total LLM API
  calls.
- Package:
  `S02_warmup16/seed_1002/`.
- Validation:
  `tables/run_validation.json` passes against the full 50-problem RTLLM
  manifest. The PPA/HV headline package remains scoped to the 46
  reference-complete problems, matching P3.
- Operator audit:
  `tables/operator_contract.csv` passes; S02 has
  `single_thought_count=0`.
- Seed read:
  classic `0.097557` HV / `0.081183` AUC46 / `33` covered;
  V2 `0.100310` HV / `0.090753` AUC46 / `33` covered;
  S02 `0.097839` HV / `0.081757` AUC46 / `32` covered.
- Two-seed S02 read:
  classic `0.104479` HV / `0.085867` AUC46 / `66/92` covered;
  V2 `0.098539` HV / `0.087146` AUC46 / `65/92` covered;
  S02 `0.097494` HV / `0.085850` AUC46 / `63/92` covered.
- Decision:
  do not promote S02 as a primary five-seed arm. Keep warmup
  interpolation S11/S12 as a possible later check because S02 nearly ties
  classic AUC but loses HV and coverage.

## 2026-07-08 - S03 Elite Pareto Slot 2 Seed 1001

- Launched S03 elite-pareto slot 2 over full RTLLM 50 with seed 1001:
  `exp/natural_qd_push/suite_variants_wave_a_20260708_140623_UTC/live/elite_pareto_slot_2/seed_1001`.
- vLLM preflight recorded:
  `preflights/s03_elite_pareto_slot_2_seed1001_20260708_140623_UTC.json`.
- Runtime completed normally in 6300.64 seconds with 4801 total LLM API
  calls.
- Package:
  `S03_elite_pareto_slot_2/seed_1001/`.
- Validation:
  `tables/run_validation.json` passes against the full 50-problem RTLLM
  manifest. The PPA/HV headline package remains scoped to the 46
  reference-complete problems, matching P3.
- Operator audit:
  `tables/operator_contract.csv` passes; S03 has
  `single_thought_count=0`.
- Seed read:
  classic `0.111401` HV / `0.090551` AUC46 / `33` covered;
  V2 `0.096767` HV / `0.083539` AUC46 / `32` covered;
  S03 `0.100189` HV / `0.088742` AUC46 / `32` covered.
- Decision:
  complete seed 1002. S03 does not beat classic on seed 1001, but it is
  the best new Wave A V2-recovery signal so far: it beats V2 on HV and
  AUC while tying V2 coverage with a simple retention-only mechanism.

## 2026-07-08 - S03 Elite Pareto Slot 2 Seed 1002

- Launched S03 elite-pareto slot 2 over full RTLLM 50 with seed 1002:
  `exp/natural_qd_push/suite_variants_wave_a_20260708_160650_UTC/live/elite_pareto_slot_2/seed_1002`.
- vLLM preflight recorded:
  `preflights/s03_elite_pareto_slot_2_seed1002_20260708_160650_UTC.json`.
- Runtime completed normally in 4662.90 seconds with 4801 total LLM API
  calls.
- Package:
  `S03_elite_pareto_slot_2/seed_1002/`.
- Validation:
  `tables/run_validation.json` passes against the full 50-problem RTLLM
  manifest. The PPA/HV headline package remains scoped to the 46
  reference-complete problems, matching P3.
- Operator audit:
  `tables/operator_contract.csv` passes; S03 has
  `single_thought_count=0`.
- Seed read:
  classic `0.097557` HV / `0.081183` AUC46 / `33` covered;
  V2 `0.100310` HV / `0.090753` AUC46 / `33` covered;
  S03 `0.107216` HV / `0.091135` AUC46 / `33` covered.
- Two-seed S03 read:
  classic `0.104479` HV / `0.085867` AUC46 / `66/92` covered;
  V2 `0.098539` HV / `0.087146` AUC46 / `65/92` covered;
  S03 `0.103703` HV / `0.089938` AUC46 / `65/92` covered.
- Decision:
  promote S03 to five-seed confirmation. The two-seed read is still just
  below matched classic HV and one covered problem below classic, but it
  is within one percent of classic HV, beats classic HV-AUC46, and beats
  V2 on HV and HV-AUC46 while tying V2 coverage.

## 2026-07-08 - S03 Elite Pareto Slot 2 Seed 1003

- Launched S03 elite-pareto slot 2 over full RTLLM 50 with seed 1003:
  `exp/natural_qd_push/suite_variants_wave_a_20260708_173313_UTC/live/elite_pareto_slot_2/seed_1003`.
- vLLM preflight recorded:
  `preflights/s03_elite_pareto_slot_2_seed1003_20260708_173313_UTC.json`.
- Runtime completed normally in 4622.08 seconds with 4800 total LLM API
  calls.
- Package:
  `S03_elite_pareto_slot_2/seed_1003/`.
- Validation:
  `tables/run_validation.json` passes against the full 50-problem RTLLM
  manifest. The PPA/HV headline package remains scoped to the 46
  reference-complete problems, matching P3.
- Operator audit:
  `tables/operator_contract.csv` passes; S03 has
  `single_thought_count=0`.
- Seed read:
  classic `0.102093` HV / `0.087210` AUC46 / `33` covered;
  V2 `0.099854` HV / `0.090295` AUC46 / `35` covered;
  S03 `0.100070` HV / `0.080866` AUC46 / `34` covered.
- Three-seed S03 read:
  classic `0.103684` HV / `0.086315` AUC46 / `99/138` covered;
  V2 `0.098977` HV / `0.088196` AUC46 / `100/138` covered;
  S03 `0.102492` HV / `0.086914` AUC46 / `99/138` covered.
- Decision:
  continue S03 seeds 1004-1005. Seed 1003 weakens the AUC signal, but
  the three-seed aggregate remains within 1.1% of matched classic HV,
  beats classic HV-AUC46, ties classic coverage, and still beats V2 mean
  HV.

## 2026-07-08 - S03 Elite Pareto Slot 2 Seed 1004

- Launched S03 elite-pareto slot 2 over full RTLLM 50 with seed 1004:
  `exp/natural_qd_push/suite_variants_wave_a_20260708_185527_UTC/live/elite_pareto_slot_2/seed_1004`.
- vLLM preflight recorded:
  `preflights/s03_elite_pareto_slot_2_seed1004_20260708_185527_UTC.json`.
- Runtime completed normally in 4666.62 seconds with 4800 total LLM API
  calls.
- Package:
  `S03_elite_pareto_slot_2/seed_1004/`.
- Validation:
  `tables/run_validation.json` passes against the full 50-problem RTLLM
  manifest. The PPA/HV headline package remains scoped to the 46
  reference-complete problems, matching P3.
- Operator audit:
  `tables/operator_contract.csv` passes; S03 has
  `single_thought_count=0`.
- Seed read:
  classic `0.103555` HV / `0.089027` AUC46 / `32` covered;
  V2 `0.101008` HV / `0.086425` AUC46 / `33` covered;
  S03 `0.094876` HV / `0.080182` AUC46 / `33` covered.
- Four-seed S03 read:
  classic `0.103652` HV / `0.086993` AUC46 / `131/184` covered;
  V2 `0.099485` HV / `0.087753` AUC46 / `133/184` covered;
  S03 `0.100588` HV / `0.085231` AUC46 / `132/184` covered.
- Decision:
  close S03 with seed 1005, but treat the candidate as likely below the
  classic-HV manuscript target unless seed 1005 recovers unusually
  strongly. If the final five-seed read remains below classic HV/AUC,
  pivot to backup suite-first variants instead of opening S03
  combinations.

## 2026-07-08 - S03 Elite Pareto Slot 2 Seed 1005

- Launched S03 elite-pareto slot 2 over full RTLLM 50 with seed 1005:
  `exp/natural_qd_push/suite_variants_wave_a_20260708_201819_UTC/live/elite_pareto_slot_2/seed_1005`.
- vLLM preflight recorded:
  `preflights/s03_elite_pareto_slot_2_seed1005_20260708_201819_UTC.json`.
- Runtime completed normally in 4688.36 seconds with 4800 total LLM API
  calls.
- Package:
  `S03_elite_pareto_slot_2/seed_1005/`.
- Validation:
  `tables/run_validation.json` passes against the full 50-problem RTLLM
  manifest with full V2 parity pins checked. The PPA/HV headline package
  remains scoped to the 46 reference-complete problems, matching P3.
- Operator audit:
  `tables/operator_contract.csv` passes; S03 has
  `single_thought_count=0`.
- Seed read:
  classic `0.104404` HV / `0.086940` AUC46 / `33` covered;
  V2 `0.096063` HV / `0.086125` AUC46 / `33` covered;
  S03 `0.099037` HV / `0.084646` AUC46 / `31` covered.
- Five-seed S03 read:
  classic `0.103802` HV / `0.086982` AUC46 / `164/230` covered;
  V2 `0.098801` HV / `0.087428` AUC46 / `166/230` covered;
  S03 `0.100278` HV / `0.085114` AUC46 / `163/230` covered.
- Decision:
  do not promote S03 as the TCAD primary extension. It is a clean
  retention-only negative against classic and only a secondary final-HV
  recovery over V2. Pivot to S20/S21 parent/retention controls before
  more capacity or warmup scans.

## 2026-07-08 - S20 Cell-Crowded Parent Seed 1001

- Launched S20 cell-crowded parent selection over full RTLLM 50 with seed
  1001:
  `exp/natural_qd_push/suite_variants_wave_b_20260708_214449_UTC/live/pareto_front_cell_crowded/seed_1001`.
- vLLM preflight recorded:
  `preflights/s20_pareto_front_cell_crowded_seed1001_20260708_214449_UTC.json`.
- Runtime completed normally in 4657.62 seconds with 4800 total LLM API
  calls.
- Package:
  `S20_pareto_front_cell_crowded/seed_1001/`.
- Validation:
  `tables/run_validation.json` passes against the full 50-problem RTLLM
  manifest with full V2 parity pins checked. The PPA/HV headline package
  remains scoped to the 46 reference-complete problems, matching P3.
- Operator audit:
  `tables/operator_contract.csv` passes; S20 has
  `single_thought_count=0`.
- Seed read:
  classic `0.111401` HV / `0.090551` AUC46 / `33` covered;
  V2 `0.096767` HV / `0.083539` AUC46 / `32` covered;
  S20 `0.089752` HV / `0.082324` AUC46 / `33` covered.
- Decision:
  do not promote on seed 1001. Complete seed 1002 before retiring S20:
  the variant is a clean config-only parent-selection test and preserves
  classic coverage, but seed 1001 loses too much final HV and is slightly
  below V2 HV-AUC46.

## 2026-07-09 - S20 Cell-Crowded Parent Seed 1002

- Launched S20 cell-crowded parent selection over full RTLLM 50 with seed
  1002:
  `exp/natural_qd_push/suite_variants_wave_b_20260708_231033_UTC/live/pareto_front_cell_crowded/seed_1002`.
- vLLM preflight recorded:
  `preflights/s20_pareto_front_cell_crowded_seed1002_20260708_231033_UTC.json`.
- Runtime completed normally in 4713.26 seconds with 4800 total LLM API
  calls.
- Package:
  `S20_pareto_front_cell_crowded/seed_1002/`.
- Validation:
  `tables/run_validation.json` passes against the full 50-problem RTLLM
  manifest with full V2 parity pins checked. The PPA/HV headline package
  remains scoped to the 46 reference-complete problems, matching P3.
- Operator audit:
  `tables/operator_contract.csv` passes; S20 has
  `single_thought_count=0`.
- Seed read:
  classic `0.097557` HV / `0.081183` AUC46 / `33` covered;
  V2 `0.100310` HV / `0.090753` AUC46 / `33` covered;
  S20 `0.101958` HV / `0.088570` AUC46 / `33` covered.
- Two-seed S20 read:
  classic `0.104479` HV / `0.085867` AUC46 / `66/92` covered;
  V2 `0.098539` HV / `0.087146` AUC46 / `65/92` covered;
  S20 `0.095855` HV / `0.085447` AUC46 / `66/92` covered.
- Decision:
  do not promote S20. Seed 1002 is a clean positive single-seed read, but
  the registered two-seed probe remains below classic and V2 on HV/AUC
  and only ties classic coverage. Close S20 as a natural
  parent-selection negative and run S21 scalar-elite retention next.

## 2026-07-09 - S21 Scalar-Elite NSGA-II Seed 1001

- Launched S21 scalar-elite retention over full RTLLM 50 with seed 1001:
  `exp/natural_qd_push/suite_variants_wave_b_20260709_003700_UTC/live/scalar_elite_nsga2/seed_1001`.
- vLLM preflight recorded:
  `preflights/s21_scalar_elite_nsga2_seed1001_20260709_003700_UTC.json`.
- Runtime completed normally in 4735.83 seconds with 4800 total LLM API
  calls.
- Package:
  `S21_scalar_elite_nsga2/seed_1001/`.
- Validation:
  `tables/run_validation.json` passes against the full 50-problem RTLLM
  manifest. The PPA/HV headline package remains scoped to the 46
  reference-complete problems, matching P3.
- Operator audit:
  `tables/operator_contract.csv` passes; S21 has
  `single_thought_count=0`.
- Seed read:
  classic `0.111401` HV / `0.090551` AUC46 / `33` covered;
  V2 `0.096767` HV / `0.083539` AUC46 / `32` covered;
  S21 `0.089155` HV / `0.082753` AUC46 / `34` covered.
- Decision:
  do not promote on seed 1001. Complete seed 1002 because S21 is the
  canonical scalar MAP-Elites retention control and seed 1001 improves
  coverage, but treat the current signal as HV-negative and likely
  coverage-only unless seed 1002 recovers strongly.

## 2026-07-09 - S21 Scalar-Elite NSGA-II Seed 1002 Running

- Launched S21 scalar-elite retention over full RTLLM 50 with seed 1002:
  `exp/natural_qd_push/suite_variants_wave_b_20260709_020320_UTC/live/scalar_elite_nsga2/seed_1002`.
- vLLM preflight recorded:
  `preflights/s21_scalar_elite_nsga2_seed1002_20260709_020320_UTC.json`.
- Current status at 2026-07-09T02:13:37Z:
  the first scheduler batch has produced 12 RTLLM problem summaries and
  the run is still active. No seed metrics should be reported until the
  full 50-problem run completes and the standard package chain passes.
- Restart note:
  `restart_handoff_20260709.md` records the active exec session, run
  root, launch log, packaging commands, fixed-denominator HV-AUC warning,
  and audit feedback.

## 2026-07-09 - S21 Scalar-Elite NSGA-II Two-Seed Closure

- Completed S21 scalar-elite retention seed 1002 normally in 4751.68
  seconds with 4800 LLM API calls.
- Package:
  `S21_scalar_elite_nsga2/seed_1002/`.
- Validation:
  `tables/run_validation.json` passes against the full 50-problem RTLLM
  manifest with the S21 config pins checked.
- Operator audit:
  `tables/operator_contract.csv` passes; S21 seed 1002 has
  `single_thought_count=0`.
- Seed read:
  classic `0.097557` HV / `0.081183` AUC46 / `33` covered;
  V2 `0.100310` HV / `0.090753` AUC46 / `33` covered;
  S21 `0.084834` HV / `0.078138` AUC46 / `31` covered.
- Two-seed S21 read:
  classic `0.104479` HV / `0.085867` AUC46 / `66/92` covered;
  V2 `0.098539` HV / `0.087146` AUC46 / `65/92` covered;
  S21 `0.086994` HV / `0.080445` AUC46 / `65/92` covered.
- Decision:
  do not promote S21. Scalar one-elite retention is a clean natural
  MAP-Elites control, but it trails matched classic on HV, HV-AUC46, and
  coverage and trails V2 on HV/HV-AUC46 while only tying V2 coverage.

## 2026-07-09 - INVALID - S09 Front-Slot Lane 0.20 Seed 1001 Attempt

- Launched S09 front-slot lane 0.20 over full RTLLM 50 with seed 1001:
  `exp/natural_qd_push/suite_variants_wave_b_20260709_102340_UTC/live/front_slot_lane_020/seed_1001`.
- vLLM preflight recorded:
  `preflights/s09_front_slot_lane_020_seed1001_20260709_102340_UTC.json`.
- Current status at 2026-07-09T10:27:34Z:
  run has started and printed the vLLM preflight line with
  `max_model_len=131072`. No seed metrics should be reported until the
  full 50-problem run completes and the standard package chain passes.
- Variant pins:
  `qd_cell_mode=elite_pareto_slot`,
  `qd_max_elites_per_cell=2`,
  `qd_parent_selection=front_slot_lane_nsga2`, and
  `qd_front_slot_lane_fraction=0.20`, with all other V2 parity pins
  retained.
- Correction:
  this launch was stopped before any completed problem because the
  command omitted the V2 parity pin `qd_champion_lane_fraction=0.5`.
  The partial raw root was quarantined as
  `exp/natural_qd_push/suite_variants_wave_b_20260709_102340_UTC_INVALID_MISSING_CHAMPION_LANE`
  and must not be interpreted as a result.

## 2026-07-09 - S09 Front-Slot Lane 0.20 Seed 1001 Relaunched

- Relaunched S09 front-slot lane 0.20 over full RTLLM 50 with seed 1001:
  `exp/natural_qd_push/suite_variants_wave_b_20260709_103042_UTC/live/front_slot_lane_020/seed_1001`.
- vLLM preflight recorded:
  `preflights/s09_front_slot_lane_020_seed1001_20260709_103042_UTC.json`.
- Variant pins:
  `qd_cell_mode=elite_pareto_slot`,
  `qd_max_elites_per_cell=2`,
  `qd_parent_selection=front_slot_lane_nsga2`,
  `qd_front_slot_lane_fraction=0.20`, and
  `qd_champion_lane_fraction=0.5`, with all other V2 parity pins
  retained.
- No seed metrics should be reported until the full 50-problem run
  completes and the standard package chain passes.

## 2026-07-09 - S09 Front-Slot Lane 0.20 Seed 1001 Packaged

- Completed S09 front-slot lane 0.20 seed 1001 normally in 4809.40
  seconds with 4800 LLM API calls.
- Package:
  `S09_front_slot_lane_020/seed_1001/`.
- Validation:
  `tables/run_validation.json` passes against the full 50-problem RTLLM
  manifest with the S09 config pins checked.
- Operator audit:
  `tables/operator_contract.csv` passes; S09 seed 1001 has
  `single_thought_count=0`.
- Seed read:
  classic `0.111401` HV / `0.090551` AUC46 / `33` covered;
  V2 `0.096767` HV / `0.083539` AUC46 / `32` covered;
  S09 `0.102139` HV / `0.093403` AUC46 / `34` covered.
- Decision:
  S09 is a positive single-seed probe, not a conclusion. It beats V2 on
  final HV and beats both classic and V2 on HV-AUC46 and coverage, but it
  still trails matched classic final HV. Complete seed 1002 after the
  planned server restart before considering five-seed confirmation.

## 2026-07-09 - S09 Front-Slot Lane 0.20 Seed 1002 Running

- Launched S09 front-slot lane 0.20 over full RTLLM 50 with seed 1002:
  `exp/natural_qd_push/suite_variants_wave_b_20260709_134750_UTC/live/front_slot_lane_020/seed_1002`.
- Launch log:
  `exp/natural_qd_push/suite_variants_wave_b_20260709_134750_UTC/launch_front_slot_lane_020_seed1002.log`.
- vLLM preflight recorded:
  `preflights/s09_front_slot_lane_020_seed1002_20260709_134750_UTC.json`.
- Variant pins:
  `qd_cell_mode=elite_pareto_slot`,
  `qd_max_elites_per_cell=2`,
  `qd_parent_selection=front_slot_lane_nsga2`,
  `qd_front_slot_lane_fraction=0.20`, and
  `qd_champion_lane_fraction=0.5`, with all other V2 parity pins
  retained.
- Current status:
  run has started and printed the vLLM preflight line with
  `max_model_len=131072`. No seed metrics should be reported until the
  full 50-problem run completes and the standard package chain passes.

## 2026-07-09 - S09 Front-Slot Lane 0.20 Two-Seed Closure

- Completed S09 front-slot lane 0.20 seed 1002 normally in 4731.28
  seconds with 4800 LLM API calls.
- Package:
  `S09_front_slot_lane_020/seed_1002/`.
- Validation:
  `tables/run_validation.json` passes against the full 50-problem RTLLM
  manifest with the S09 config pins checked.
- Operator audit:
  `tables/operator_contract.csv` passes; S09 seed 1002 has
  `single_thought_count=0`.
- Seed read:
  classic `0.097557` HV / `0.081183` AUC46 / `33` covered;
  V2 `0.100310` HV / `0.090753` AUC46 / `33` covered;
  S09 `0.090574` HV / `0.077897` AUC46 / `32` covered.
- Two-seed S09 read:
  classic `0.104479` HV / `0.085867` AUC46 / `66/92` covered;
  V2 `0.098539` HV / `0.087146` AUC46 / `65/92` covered;
  S09 `0.096357` HV / `0.085650` AUC46 / `66/92` covered.
- Classification:
  `front-loss`. S09 ties classic coverage and covers one more problem
  than V2 across two seeds, but the retained fronts are weaker on HV and
  HV-AUC46. The seed 1001 positive result did not replicate.
- Decision:
  do not promote S09 to five seeds. Treat front-slot lane 0.20 as a
  natural parent-source interpolation control, not a TCAD primary-arm
  candidate.

## 2026-07-09 - S22 Front-Slot Lane 0.10 Seed 1001 Running

- Launched S22 front-slot lane 0.10 over full RTLLM 50 with seed 1001:
  `exp/natural_qd_push/suite_variants_wave_b_20260709_151403_UTC/live/front_slot_lane_010/seed_1001`.
- Launch log:
  `exp/natural_qd_push/suite_variants_wave_b_20260709_151403_UTC/launch_front_slot_lane_010_seed1001.log`.
- vLLM preflight recorded:
  `preflights/s22_front_slot_lane_010_seed1001_20260709_151403_UTC.json`.
- Variant pins:
  `qd_cell_mode=elite_pareto_slot`,
  `qd_max_elites_per_cell=2`,
  `qd_parent_selection=front_slot_lane_nsga2`,
  `qd_front_slot_lane_fraction=0.10`, and
  `qd_champion_lane_fraction=0.5`, with all other V2 parity pins
  retained.
- Current status:
  run has not yet produced metrics. No seed metrics should be reported
  until the full 50-problem run completes and the standard package chain
  passes.

## 2026-07-09 - S22 Front-Slot Lane 0.10 Seed 1001 Packaged

- Completed S22 front-slot lane 0.10 seed 1001 normally in 4748.79
  seconds with 4800 LLM API calls.
- Package:
  `S22_front_slot_lane_010/seed_1001/`.
- Validation:
  `tables/run_validation.json` passes against the full 50-problem RTLLM
  manifest with the S22 config pins checked.
- Operator audit:
  `tables/operator_contract.csv` passes; S22 seed 1001 has
  `single_thought_count=0`.
- Seed read:
  classic `0.111401` HV / `0.090551` AUC46 / `33` covered;
  V2 `0.096767` HV / `0.083539` AUC46 / `32` covered;
  S22 `0.102589` HV / `0.088878` AUC46 / `34` covered.
- Decision:
  complete seed 1002. S22 seed 1001 is V2-positive and
  coverage-positive against classic, but it still trails matched classic
  on final HV and HV-AUC46, so it is not promotion-ready on one seed.

## 2026-07-09 - S22 Front-Slot Lane 0.10 Seed 1002 Running

- Launched S22 front-slot lane 0.10 over full RTLLM 50 with seed 1002:
  `exp/natural_qd_push/suite_variants_wave_b_20260709_164211_UTC/live/front_slot_lane_010/seed_1002`.
- Launch log:
  `exp/natural_qd_push/suite_variants_wave_b_20260709_164211_UTC/launch_front_slot_lane_010_seed1002.log`.
- vLLM preflight recorded:
  `preflights/s22_front_slot_lane_010_seed1002_20260709_164211_UTC.json`.
- Variant pins:
  `qd_cell_mode=elite_pareto_slot`,
  `qd_max_elites_per_cell=2`,
  `qd_parent_selection=front_slot_lane_nsga2`,
  `qd_front_slot_lane_fraction=0.10`, and
  `qd_champion_lane_fraction=0.5`, with all other V2 parity pins
  retained.
- Current status:
  run has started and printed the vLLM preflight line with
  `max_model_len=131072`. No seed metrics should be reported until the
  full 50-problem run completes and the standard package chain passes.

## 2026-07-09 - S22 Front-Slot Lane 0.10 Two-Seed Closure

- Completed S22 front-slot lane 0.10 seed 1002 normally in 4747.64
  seconds with 4800 LLM API calls.
- Package:
  `S22_front_slot_lane_010/seed_1002/`.
- Validation:
  `tables/run_validation.json` passes against the full 50-problem RTLLM
  manifest with the S22 config pins checked.
- Operator audit:
  `tables/operator_contract.csv` passes; S22 seed 1002 has
  `single_thought_count=0`.
- Seed 1002 read:
  classic `0.097557` HV / `0.081183` AUC46 / `33` covered;
  V2 `0.100310` HV / `0.090753` AUC46 / `33` covered;
  S22 `0.100856` HV / `0.089351` AUC46 / `32` covered.
- Two-seed S22 read:
  classic `0.104479` HV / `0.085867` AUC46 / `66/92` covered;
  V2 `0.098539` HV / `0.087146` AUC46 / `65/92` covered;
  S22 `0.101722` HV / `0.089115` AUC46 / `66/92` covered.
- Classification:
  `HV-AUC-positive front-slot control`. S22 beats V2 on all two-seed
  aggregate metrics and beats classic on HV-AUC46 while tying classic
  coverage, but it still trails classic final HV.
- Decision:
  do not promote S22 to five seeds as a primary TCAD arm. Keep it as
  natural parent-source evidence and move the primary search toward a
  mechanism that can recover classic final HV.

## 2026-07-09 - Post-S22 Next Launch Block Prepared

- No new full-suite run launched. The handoff remains restart-safe with
  no active benchmark or report process.
- Added an exact S07 capacity3 seed-1001 preflight+launch block to
  `commands.md` with all V2 parity pins expanded.
- Rationale:
  S01 capacity7 showed a small coverage signal with a large HV tax; S07
  tests the opposite one-knob direction, reducing per-cell front capacity
  from five to three to check whether less in-cell crowding restores
  selection pressure while preserving coverage.
- Decision:
  after restart, prefer S07 over S10 for the next primary-HV probe if a
  new long run is allowed. Keep S04/S05 descriptor completions for
  descriptor-health evidence, not as the primary HV search.

## 2026-07-09 - S07 Capacity 3 Seed 1001 Packaged

- Launched and completed S07 `capacity3` seed 1001:
  `exp/natural_qd_push/suite_variants_wave_b_20260709_182124_UTC/live/capacity3/seed_1001`.
- Runtime completed normally in 4763.21 seconds with 4800 LLM API calls.
- Package:
  `S07_capacity3/seed_1001/`.
- Validation:
  `tables/run_validation.json` passes against the full 50-problem RTLLM
  manifest with the S07 config pins checked.
- Operator audit:
  `tables/operator_contract.csv` passes; S07 seed 1001 has
  `single_thought_count=0`.
- Seed read:
  classic `0.111401` HV / `0.090551` AUC46 / `33` covered;
  V2 `0.096767` HV / `0.083539` AUC46 / `32` covered;
  S07 `0.100296` HV / `0.091895` AUC46 / `32` covered.
- Classification:
  `HV-AUC-positive capacity-control signal`. Capacity3 beats V2 on final
  HV and beats both comparators on HV-AUC46, but it trails classic final
  HV by about 10.0% and loses one coverage point against classic.
- Decision:
  do not promote from one seed. Complete seed 1002 only as a two-seed
  replication check; this seed alone does not meet the primary TCAD gate.

## 2026-07-09 - S07 Capacity 3 Seed 1002 Running

- Launched S07 `capacity3` seed 1002:
  `exp/natural_qd_push/suite_variants_wave_b_20260709_195220_UTC/live/capacity3/seed_1002`.
- Launch log:
  `exp/natural_qd_push/suite_variants_wave_b_20260709_195220_UTC/launch_capacity3_seed1002.log`.
- vLLM preflight recorded:
  `preflights/s07_capacity3_seed1002_20260709_195220_UTC.json`.
- Variant pins are unchanged from S07 seed 1001 except for `seed=1002`.
- Current status:
  run has started and printed the vLLM preflight line with
  `max_model_len=131072`. No seed or two-seed metrics should be
  reported until the full 50-problem run completes and the standard
  package chain passes.

## 2026-07-09 - S07 Capacity 3 Two-Seed Closure

- Completed and packaged S07 `capacity3` seed 1002:
  `S07_capacity3/seed_1002/`.
- Runtime completed normally in 4758.87 seconds with 4800 LLM API calls.
- Validation:
  `tables/run_validation.json` passes against the full 50-problem RTLLM
  manifest with the S07 config pins checked.
- Operator audit:
  `tables/operator_contract.csv` passes; S07 seed 1002 has
  `single_thought_count=0`.
- Seed 1002 read:
  classic `0.097557` HV / `0.081183` AUC46 / `33` covered;
  V2 `0.100310` HV / `0.090753` AUC46 / `33` covered;
  S07 `0.105630` HV / `0.088873` AUC46 / `34` covered.
- Two-seed S07 read:
  classic `0.104479` HV / `0.085867` AUC46 / `66/92` covered;
  V2 `0.098539` HV / `0.087146` AUC46 / `65/92` covered;
  S07 `0.102963` HV / `0.090384` AUC46 / `66/92` covered.
- Classification:
  `HV-AUC-positive capacity near-miss`. S07 beats V2 on all two-seed
  aggregate metrics, beats classic on HV-AUC46, and ties classic
  coverage, but it still trails classic final HV by about 1.5%.
- Decision:
  do not claim S07 as a primary final-HV win. Treat it as the best
  capacity-control near-miss and secondary trajectory-quality evidence
  unless later seeds or variants clear the strict classic-HV gate.

## 2026-07-09 - S07 Five-Seed Confirmation Preregistered

- Read-only experimental audit recommended confirming S07 to five seeds
  before launching a new mechanism. Rationale: S07 is the only current
  lane within about 1.5% of matched classic final HV while already
  beating classic on HV-AUC46 and tying classic coverage across two
  seeds.
- Read-only organization audit flagged stale command risk. The packaged
  S07 seed 1001/1002 launch blocks in `commands.md` are now marked
  historical, and a self-contained S07 seed 1003 confirmation block was
  added with all V2 parity pins expanded.
- Registry decisions before the next launch:
  S07 is `confirming_near_miss_to_five_seeds`; S10 front-slot 0.40 is
  blocked by S09/S22 evidence; S08/S19 larger-capacity variants are
  deferred because capacity7 was negative and capacity3 is the better
  capacity direction; S12 warmup24 is blocked until S11 warmup12 gives a
  positive HV/coverage signal.
- Launch gate:
  seed 1003 must use `classic_operator_kind=eoh_strategies`,
  `qd_operator_kind=eoh_strategies`, `eoh_success_operator_set=classic`,
  `representation_kind=code_individual`, 128k token budgets,
  `strict_ablation`, and the S07 one-knob capacity change only. Any
  nonzero `single_thought_count` invalidates headline use.

## 2026-07-09 - S07 Capacity 3 Seed 1003 Running

- Launched S07 `capacity3` seed 1003:
  `exp/natural_qd_push/suite_variants_wave_b_20260709_213030_UTC/live/capacity3/seed_1003`.
- Launch log:
  `exp/natural_qd_push/suite_variants_wave_b_20260709_213030_UTC/launch_capacity3_seed1003.log`.
- vLLM preflight recorded:
  `preflights/s07_capacity3_seed1003_20260709_213030_UTC.json`.
- Preflight passed with model `openai/gpt-oss-120b` and
  `max_model_len=131072`.
- Variant pins are unchanged from S07 seeds 1001/1002 except for
  `seed=1003`.
- Current status:
  run has started over 50 RTLLM problems. No seed or aggregate metrics
  should be reported until the full run completes and the standard
  package chain passes.

## 2026-07-09 - S07 Capacity 3 Seed 1003 Packaged

- Completed and packaged S07 `capacity3` seed 1003:
  `S07_capacity3/seed_1003/`.
- Runtime completed normally in 4722.00 seconds with 4800 LLM API calls.
- Validation:
  `tables/run_validation.json` passes against the full 50-problem RTLLM
  manifest with the S07 config pins checked.
- Operator audit:
  `tables/operator_contract.csv` passes; S07 seed 1003 has
  `single_thought_count=0`.
- Seed 1003 read:
  classic `0.102093` HV / `0.087210` AUC46 / `33` covered;
  V2 `0.099854` HV / `0.090295` AUC46 / `35` covered;
  S07 `0.100464` HV / `0.087032` AUC46 / `33` covered.
- Three-seed S07 read:
  classic `0.103684` HV / `0.086315` AUC46 / `99/138` covered;
  V2 `0.098977` HV / `0.088196` AUC46 / `100/138` covered;
  S07 `0.102130` HV / `0.089267` AUC46 / `99/138` covered.
- Classification:
  `HV-AUC-positive capacity near-miss`. Seed 1003 does not clear
  classic final HV, but the three-seed read still beats V2 on HV and
  HV-AUC46, beats classic on HV-AUC46, and ties classic coverage.
- Decision:
  continue to seed 1004 under the pre-registered confirmation ladder.
  Do not claim S07 as a primary final-HV win unless the five-seed
  aggregate clears classic HV and coverage.

## 2026-07-09 - S07 Capacity 3 Seed 1004 Running

- Launched S07 `capacity3` seed 1004:
  `exp/natural_qd_push/suite_variants_wave_b_20260709_225719_UTC/live/capacity3/seed_1004`.
- Launch log:
  `exp/natural_qd_push/suite_variants_wave_b_20260709_225719_UTC/launch_capacity3_seed1004.log`.
- vLLM preflight recorded:
  `preflights/s07_capacity3_seed1004_20260709_225719_UTC.json`.
- Preflight passed with model `openai/gpt-oss-120b` and
  `max_model_len=131072`.
- Variant pins are unchanged from S07 seeds 1001-1003 except for
  `seed=1004`.
- Current status:
  run has started over 50 RTLLM problems. No seed or aggregate metrics
  should be reported until the full run completes and the standard
  package chain passes.

## 2026-07-10 - S07 Capacity 3 Seed 1004 Package

- Completed and packaged S07 `capacity3` seed 1004 under
  `suite_variant_campaign/S07_capacity3/seed_1004/`.
- Runtime completed normally in 4675.61 seconds with 4800 LLM API calls.
  The package passes the full 50-problem validation manifest and passes
  the operator audit with `single_thought_count=0`.
- Seed 1004 is a positive matched-suite seed:
  S07 `0.112252` HV / `0.093789` HV-AUC46 / `33/46` coverage vs
  classic `0.103555` / `0.089027` / `32/46` and V2 `0.101008` /
  `0.086425` / `33/46`.
- Four-seed S07 now clears the registered confirmation threshold:
  S07 `0.104661` HV / `0.090397` HV-AUC46 / `132/184` coverage vs
  classic `0.103652` / `0.086993` / `131/184` and V2 `0.099485` /
  `0.087753` / `133/184`.
- Classification:
  `promoted-to-final-confirmation`. The capacity3 lane is the first
  suite-first natural variant in this campaign to clear matched classic
  on final HV, HV-AUC46, and coverage at four seeds.
- Decision:
  finish S07 seed 1005 before any manuscript claim. The final-HV margin
  is still small, so a fifth seed is required to decide whether S07 is a
  viable TCAD extension or another near-miss.

## 2026-07-10 - S07 Capacity 3 Seed 1005 Running

- Launched S07 `capacity3` seed 1005:
  `exp/natural_qd_push/suite_variants_wave_b_20260710_002626_UTC/live/capacity3/seed_1005`.
- Launch log:
  `exp/natural_qd_push/suite_variants_wave_b_20260710_002626_UTC/launch_capacity3_seed1005.log`.
- vLLM preflight recorded:
  `preflights/s07_capacity3_seed1005_20260710_002626_UTC.json`.
- Preflight passed with model `openai/gpt-oss-120b` and
  `max_model_len=131072`.
- Variant pins are unchanged from S07 seeds 1001-1004 except for
  `seed=1005`.
- Current status:
  run has started over 50 RTLLM problems. No seed or five-seed metrics
  should be reported until the full run completes and the standard
  package chain passes.

## 2026-07-10 - S07 Capacity 3 Five-Seed Closure

- Completed and packaged S07 `capacity3` seed 1005 under
  `suite_variant_campaign/S07_capacity3/seed_1005/`.
- Runtime completed normally in 4731.86 seconds with 4800 LLM API calls.
  The package passes the full 50-problem validation manifest and passes
  the operator audit with `single_thought_count=0`.
- Seed 1005 is negative for S07 against matched classic:
  S07 `0.093760` HV / `0.078565` HV-AUC46 / `33/46` coverage vs
  classic `0.104404` / `0.086940` / `33/46` and V2 `0.096063` /
  `0.086125` / `33/46`.
- Five-seed S07 closure:
  S07 `0.102481` HV / `0.088031` HV-AUC46 / `165/230` coverage vs
  classic `0.103802` / `0.086982` / `164/230` and V2 `0.098801` /
  `0.087428` / `166/230`.
- Classification:
  `five-seed HV-negative, HV-AUC-positive, coverage-positive`. The
  four-seed HV lead did not survive seed 1005. S07 is a clean secondary
  result, not the primary TCAD PPA-HV win.
- Decision:
  do not open S07 combinations without a new mechanism that specifically
  explains final-HV recovery. The next primary search should shift away
  from capacity-only variants, likely toward descriptor reduction or
  descriptor-health lanes after an extraction/config smoke.

## 2026-07-10 - S07 Final Statistics and Case Studies

- Added `S07_capacity3/five_seed_analysis/` with seed-paired deltas,
  descriptive sign/Wilcoxon/t-test results, a per-problem win/loss map,
  and case-study tables for `Prob015_multi_pipe_8bit` and `Prob024_fsm`.
- Seed-paired S07-vs-classic deltas:
  mean HV `-0.001322` (2 positive / 3 negative seeds, Wilcoxon
  `p=0.6250`), HV-AUC46 `+0.001049` (3 positive / 2 negative seeds,
  Wilcoxon `p=0.8125`), and coverage `+0.2` covered problems per seed.
- Per-problem map:
  S07 wins mean final HV on 15 problems, classic wins on 8, and 23 tie.
  Coverage improves on 3 problems and drops on 4.
- Mechanism read:
  `Prob015_multi_pipe_8bit` is the clean compact-retention success case:
  S07 recovers `3/5` covered seeds where classic has `0/5`.
  `Prob024_fsm` is also S07-positive on mean HV/AUC while retaining
  `5/5` coverage.
- Decision remains unchanged:
  S07 is secondary evidence, not the primary final-HV claim. Run targeted
  descriptor follow-ups only after this S07 posture is kept explicit.

## 2026-07-10 - Post-S07 Follow-Up Decision

- Registered `S23 journal_logic_width_2d` as the next smoke-ready
  full-suite lane after S07 closure.
- S23 keeps the V2 platform and uses explicit `logic_depth comb_width_log`
  descriptor axes, dropping `ff_depth` while preserving the original
  journal trio descriptor family.
- Registered `S31 s07_logic_width_2d` only as a contingent combination:
  keep S07 capacity3 plus the S23 reduced descriptor after S23 gives a
  non-catastrophic full-suite signal.
- Non-LLM config smoke passed for S23/S31, the reserved
  `logic_depth ff_depth` 2D lane, compact8d/CVT, and gt3d/testability
  archive construction.
- Decision:
  run S23 before S31, compact8d/CVT, or gt3d/testability. Compact8d/CVT
  remains a descriptor-health reserve because it changes descriptor
  family and geometry and had prior extraction fragility. GT3D/testability
  remains a coverage-focused reserve because existing suite evidence is
  HV-weak.

## 2026-07-10 - S23 Logic-Width 2D Seed 1001 Running

- Launched S23 `journal_logic_width_2d` seed 1001 at
  `exp/natural_qd_push/suite_variants_wave_c_20260710_021651_UTC/live/journal_logic_width_2d/seed_1001`.
- Launch log:
  `exp/natural_qd_push/suite_variants_wave_c_20260710_021651_UTC/launch_journal_logic_width_2d_seed1001.log`.
- Preflight recorded at
  `preflights/s23_journal_logic_width_2d_seed1001_20260710_021651_UTC.json`;
  it passed with model `openai/gpt-oss-120b` and
  `max_model_len=131072`.
- Variant pins:
  `qd_descriptor_axes=logic_depth,comb_width_log`,
  `qd_archive_type=grid_quantile`, `qd_num_cells=16`,
  `qd_grid_quantile_warmup_successes=8`, `qd_cell_mode=pareto_front`,
  `qd_max_elites_per_cell=5`, `qd_parent_selection=nsga2_global_rank`,
  and `qd_champion_lane_fraction=0.5`.
- Operator/evaluation pins:
  `classic_operator_kind=eoh_strategies`,
  `qd_operator_kind=eoh_strategies`, `eoh_success_operator_set=classic`,
  `representation_kind=code_individual`,
  `evaluation_mode=strict_ablation`, `max_tokens=128000`, and
  `diff_max_tokens=128000`.
- Current status:
  full RTLLM smoke is running. No S23 metrics should be reported until
  all 50 RTLLM problems complete and the standard validation/package chain
  passes.

## 2026-07-10 - S23 Logic-Width 2D Seed 1001 Package

- Completed and packaged S23 `journal_logic_width_2d` seed 1001 under
  `S23_journal_logic_width_2d/seed_1001/`.
- Runtime completed normally in 5223.39 seconds with 4800 LLM API calls.
  `tables/run_validation.json` passes the full 50-problem manifest with
  the explicit `qd_descriptor_axes=['logic_depth', 'comb_width_log']`
  contract and no `qd_descriptor_profile` drift.
- `tables/operator_contract.csv` passes with `single_thought_count=0`:
  classic `1002` candidates / `804` EoH, S23 `857` candidates / `579`
  EoH / `82` allowed QD tuple-operator candidates, and V2 `1007`
  candidates / `803` EoH.
- Seed read:
  S23 `0.084403` HV / `0.076832` HV-AUC46 / `31/46` coverage vs
  matched classic `0.111401` / `0.090551` / `33/46` and V2 `0.096767`
  / `0.083539` / `32/46`.
- Mechanism read:
  S23 reduces descriptor-collapse events to `4/50` archives compared
  with `24/50` for matched V2 seed 1001 and `24/50` for S07 seed 1001,
  but successful-candidate yield drops to `857` candidates over
  `31/46` reference-complete problems.
- Largest final-HV losses vs classic are `Prob036_edge_detect`
  (`-0.538825`), `Prob019_sub_64bit` (`-0.449959`), and `Prob024_fsm`
  (`-0.195683`). Isolated wins on `Prob002_adder_16bit`,
  `Prob008_comparator_4bit`, `Prob049_signal_generator`, and
  `Prob043_RAM` do not offset those losses.
- Classification:
  `seed1001 HV-catastrophic descriptor-reduction control`. The
  pre-registered smoke stop rule closes S23 after seed 1001 because it
  reaches only 75.8% of matched classic final HV. Do not run seed 1002
  or launch `S31 s07_logic_width_2d` from this evidence.

## 2026-07-10 - S11 Warmup12 Seed 1001 Running

- Launched S11 `warmup12` seed 1001 at
  `exp/natural_qd_push/suite_variants_wave_b_20260710_035929_UTC/live/warmup12/seed_1001`.
- Launch log:
  `exp/natural_qd_push/suite_variants_wave_b_20260710_035929_UTC/launch_warmup12_seed1001.log`.
- Preflight recorded at
  `preflights/s11_warmup12_seed1001_20260710_035929_UTC.json`;
  it passed with model `openai/gpt-oss-120b` and
  `max_model_len=131072`.
- Variant pins:
  S11 changes only `qd_grid_quantile_warmup_successes=12` from the V2
  platform. It keeps `qd_descriptor_profile=journal_logic_ff_width_3d`,
  `qd_archive_type=grid_quantile`, `qd_num_cells=16`,
  `qd_cell_mode=pareto_front`, `qd_max_elites_per_cell=5`,
  `qd_parent_selection=nsga2_global_rank`, and
  `qd_champion_lane_fraction=0.5`.
- Operator/evaluation pins:
  `classic_operator_kind=eoh_strategies`,
  `qd_operator_kind=eoh_strategies`, `eoh_success_operator_set=classic`,
  `representation_kind=code_individual`,
  `evaluation_mode=strict_ablation`, `max_tokens=128000`, and
  `diff_max_tokens=128000`.
- Decision posture:
  S11 is warmup-family closure after the S02 warmup16 negative, not a
  new primary TCAD lane. No metrics should be reported until all 50
  RTLLM problems complete and the standard validation/package chain
  passes. Stop after seed 1001 unless it shows real HV or coverage
  recovery.
