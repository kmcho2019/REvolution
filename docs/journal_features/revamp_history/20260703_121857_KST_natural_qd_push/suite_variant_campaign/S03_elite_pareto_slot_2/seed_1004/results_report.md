# S03 Elite Pareto Slot 2 Seed 1004 Result

Date packaged: 2026-07-08.

Variant: `qd_cell_mode=elite_pareto_slot` and
`qd_max_elites_per_cell=2`, otherwise Smooth-QD V2 parity settings. Full
RTLLM was launched over all 50 problems; the headline comparison uses
the 46 reference-complete problems, matching P3.

## Run

- Run root:
  `exp/natural_qd_push/suite_variants_wave_a_20260708_185527_UTC/live/elite_pareto_slot_2/seed_1004`.
- vLLM preflight:
  `suite_variant_campaign/preflights/s03_elite_pareto_slot_2_seed1004_20260708_185527_UTC.json`.
- Runtime: 4666.62 seconds.
- LLM API calls: 4800 total.
- Validation: pass against the full 50-problem manifest.
- Operator contract: pass; `single_thought_count=0`.

## Seed 1004 Read

| Arm | Mean HV46 | HV-AUC46 | Coverage | HV wins |
| --- | --- | --- | --- | --- |
| classic REvolution | 0.103555 | 0.089027 | 32/46 | 12 |
| Smooth-QD V2 | 0.101008 | 0.086425 | 33/46 | 12 |
| S03 elite-pareto slot 2 | 0.094876 | 0.080182 | 33/46 | 9 |

S03 is `91.6%` of matched classic HV and `90.1%` of matched classic
HV-AUC46 on this seed, with one more covered reference-complete problem.
It is `93.9%` of matched V2 HV and `92.8%` of matched V2 HV-AUC46,
tying V2 coverage.

## Four-Seed Read

| Arm | Mean HV46 | HV-AUC46 | Coverage | HV wins |
| --- | --- | --- | --- | --- |
| classic REvolution | 0.103652 | 0.086993 | 131/184 | 55 |
| Smooth-QD V2 | 0.099485 | 0.087753 | 133/184 | 36 |
| S03 elite-pareto slot 2 | 0.100588 | 0.085231 | 132/184 | 44 |

Across seeds 1001-1004, S03 is `97.0%` of matched classic HV and
`98.0%` of matched classic HV-AUC46 with one more covered
reference-complete problem. It is `101.1%` of matched V2 HV but `97.1%`
of matched V2 HV-AUC46, with one fewer covered problem than V2.

## Interpretation

Seed 1004 is a negative confirmation seed for S03. The four-seed
aggregate no longer supports a likely classic-HV win, and the AUC signal
has dropped below both classic and V2. The remaining positive read is
limited: S03 still beats V2 on mean HV and keeps a small coverage gain
over matched classic.

Complete seed 1005 to close the registered five-seed confirmation and
avoid making a premature decision after partial confirmation. If the
five-seed result remains below classic HV and HV-AUC46, treat S03 as a
documented natural negative/secondary V2-HV variant and pivot to backup
suite-first variants rather than combination arms.

## Artifacts

- `pareto_analysis/aggregate_backend_metrics.csv`
- `tables/hv_auc.csv`
- `tables/operator_contract.csv`
- `tables/run_validation.json`
- `ppa_distribution/summary.json`
