# P3 Full-RTLLM Confirmation — Pre-Registration (2026-07-03)

Registered BEFORE any full-suite V2 result exists.

## Promotion arm decision (per the registered rule)

- N03b's 3-seed screen read vs V2: HV 98.9%, HV-AUC -2.8% — the
  seed-1001 +6.4% did not replicate; displacement fails.
  **Promotion arm = Smooth-QD V2** (as registered on 2026-07-03 before
  any P1 read).
- N03b remains promote-ELIGIBLE vs classic (3/3 seed wins, +11.7%
  3-seed HV, better front breadth than V2 on every seed) and is the
  designated Branch-B utility-metric candidate if V2's full-suite HV
  margin lands between parity and +5%.

## Arm and comparators

- V2 arm: the pinned platform flags (`../tables/v2_platform_config.md`)
  on the FULL RTLLM 50-problem list (headline analysis restricted to
  the 46 reference-complete designs per the frozen manifest
  `.../RTLLM_full_suite/20260630/tables/rtllm_reference_complete_manifest.csv`).
- Command shape cloned from the 20260701 classic comparator method
  script (`.../qd_evaluaton_exp/20260701_1155_PCN_v3_experiments/
  commands/methods/classic_revolution_8x5.sh`): strict_ablation,
  48 total worker slots / 12 active problems / 4 per problem,
  128000-token budgets, `--eoh_success_operator_set classic`.
- Comparators (REUSED, zero new classic spend):
  `exp/useful_bd_push/pcn_v3_experiments_20260701/live/rtllm_full_5seed/
  classic_revolution_8x5/seed_100{1..5}` (pinned 5-seed mean HV
  0.10380 / HV-AUC 0.08680) and `classic_no_cf_8x5` (0.10685/0.09459).

## Ladder and gates (registered)

1. Seed 1001 first. Read vs classic seed-1001 (0.0997/0.0899, the
   20260630 corrected values). Proceed to seeds 1002-1005 unless the
   run is invalid (operator audit, run validation) — a weak single-seed
   read does NOT stop the ladder (seed-noise lesson, both directions).
2. 5-seed read vs the classic 5-seed baselines: report mean HV,
   canonical HV-AUC, coverage (of 46), valid-PPA counts,
   reference-beating counts, per-problem W/L/T, and the operator
   contract for every seed.
3. Claim mapping (frozen contract): the journal claim gates are the
   +5% HV log-ratio with cluster-bootstrap CI low > 0 via
   `scripts/report_journal_statistics.py` conventions, plus
   functionality NEW_OK/coverage >= classic. Screen-scale numbers are
   never cited as full-suite evidence.
4. Every seed package ships `ppa_completeness.csv` semantics via the
   reference-complete manifest restriction; missing-reference designs
   (Prob006/013/018/040) are excluded from headline aggregates.

## Command (seed 1001; per-seed preflight recorded)

As the pinned anchor command, except: full 50-problem RTLLM list,
`--benchmarks RTLLM`, 48/12/4 workers, and
`--eoh_success_operator_set classic` made explicit (comparator parity).
Save path: `exp/natural_qd_push/p3_v2_full_rtllm_<UTC>/live/
smooth_qd_v2_8x5/seed_<s>`.
