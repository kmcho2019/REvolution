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
