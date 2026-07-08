# S03 Elite Pareto Slot 2 Seed 1003 Result

Date packaged: 2026-07-08.

Variant: `qd_cell_mode=elite_pareto_slot` and
`qd_max_elites_per_cell=2`, otherwise Smooth-QD V2 parity settings. Full
RTLLM was launched over all 50 problems; the headline comparison uses
the 46 reference-complete problems, matching P3.

## Run

- Run root:
  `exp/natural_qd_push/suite_variants_wave_a_20260708_173313_UTC/live/elite_pareto_slot_2/seed_1003`.
- vLLM preflight:
  `suite_variant_campaign/preflights/s03_elite_pareto_slot_2_seed1003_20260708_173313_UTC.json`.
- Runtime: 4622.08 seconds.
- LLM API calls: 4800 total.
- Validation: pass against the full 50-problem manifest.
- Operator contract: pass; `single_thought_count=0`.

## Seed 1003 Read

| Arm | Mean HV46 | HV-AUC46 | Coverage | HV wins |
| --- | --- | --- | --- | --- |
| classic REvolution | 0.102093 | 0.087210 | 33/46 | 13 |
| Smooth-QD V2 | 0.099854 | 0.090295 | 35/46 | 12 |
| S03 elite-pareto slot 2 | 0.100070 | 0.080866 | 34/46 | 10 |

S03 is `98.0%` of matched classic HV and `92.7%` of matched classic
HV-AUC46 on this seed, with one more covered reference-complete problem.
It is `100.2%` of matched V2 HV but only `89.6%` of matched V2 HV-AUC46,
with one fewer covered problem than V2.

## Three-Seed Read

| Arm | Mean HV46 | HV-AUC46 | Coverage | HV wins |
| --- | --- | --- | --- | --- |
| classic REvolution | 0.103684 | 0.086315 | 99/138 | 43 |
| Smooth-QD V2 | 0.098977 | 0.088196 | 100/138 | 24 |
| S03 elite-pareto slot 2 | 0.102492 | 0.086914 | 99/138 | 35 |

Across seeds 1001-1003, S03 is `98.9%` of matched classic HV and
`100.7%` of matched classic HV-AUC46 with equal coverage. It is `103.6%`
of matched V2 HV but `98.5%` of matched V2 HV-AUC46, with one fewer
covered reference-complete problem.

## Interpretation

Seed 1003 weakens the S03 promotion signal but does not close it. The
three-seed aggregate still nearly matches classic HV, ties classic
coverage, improves classic HV-AUC46, and beats V2 on mean HV. The loss
against V2 on HV-AUC46 and coverage means S03 is not yet a clean TCAD
claim.

Continue seeds 1004-1005 before launching combination or backup variants.
The mechanism remains simple enough to be a natural journal extension if
the five-seed read recovers the classic HV target or keeps a clear
HV-AUC/functionality utility trade.

## Artifacts

- `pareto_analysis/aggregate_backend_metrics.csv`
- `tables/hv_auc.csv`
- `tables/operator_contract.csv`
- `tables/run_validation.json`
- `ppa_distribution/summary.json`
