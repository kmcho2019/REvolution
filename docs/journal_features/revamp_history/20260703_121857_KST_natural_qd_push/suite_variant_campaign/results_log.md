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
