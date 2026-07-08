# S03 Elite Pareto Slot 2 Seed 1005 Result

Date packaged: 2026-07-08.

Variant: `qd_cell_mode=elite_pareto_slot` and
`qd_max_elites_per_cell=2`, otherwise Smooth-QD V2 parity settings. Full
RTLLM was launched over all 50 problems; the headline comparison uses
the 46 reference-complete problems, matching P3.

## Run

- Run root:
  `exp/natural_qd_push/suite_variants_wave_a_20260708_201819_UTC/live/elite_pareto_slot_2/seed_1005`.
- vLLM preflight:
  `suite_variant_campaign/preflights/s03_elite_pareto_slot_2_seed1005_20260708_201819_UTC.json`.
- Runtime: 4688.36 seconds.
- LLM API calls: 4800 total.
- Validation: pass against the full 50-problem manifest, with full V2
  parity pins checked.
- Operator contract: pass; `single_thought_count=0`.

## Seed 1005 Read

| Arm | Mean HV46 | HV-AUC46 | Coverage | HV wins |
| --- | --- | --- | --- | --- |
| classic REvolution | 0.104404 | 0.086940 | 33/46 | 15 |
| Smooth-QD V2 | 0.096063 | 0.086125 | 33/46 | 11 |
| S03 elite-pareto slot 2 | 0.099037 | 0.084646 | 31/46 | 7 |

S03 is `94.9%` of matched classic HV and `97.4%` of matched classic
HV-AUC46 on this seed, with two fewer covered reference-complete
problems. It is `103.1%` of matched V2 HV but `98.3%` of matched V2
HV-AUC46, with two fewer covered problems.

## Five-Seed Read

| Arm | Mean HV46 | HV-AUC46 | Coverage | HV wins |
| --- | --- | --- | --- | --- |
| classic REvolution | 0.103802 | 0.086982 | 164/230 | 70 |
| Smooth-QD V2 | 0.098801 | 0.087428 | 166/230 | 47 |
| S03 elite-pareto slot 2 | 0.100278 | 0.085114 | 163/230 | 51 |

Across seeds 1001-1005, S03 is `96.6%` of matched classic HV and
`97.9%` of matched classic HV-AUC46, with one fewer covered
reference-complete problem. It is `101.5%` of V2 mean HV, but trails V2
on HV-AUC46 and coverage.

## Interpretation

S03 is a clean natural negative for the primary TCAD target. The
two-seed promotion signal did not survive five-seed confirmation: the
slot-2 archive recovers some V2 final-HV loss, but it does not match
classic HV, classic HV-AUC46, or classic coverage.

Do not open S03 combination arms from this evidence alone. The next
suite-first branch should test simple parent/retention controls that
separate native MAP-Elites pressure from bounded Pareto-cell retention:
S20 (`cell_crowded_tournament`) and S21 (`scalar_elite_nsga2`).

## Artifacts

- `pareto_analysis/aggregate_backend_metrics.csv`
- `tables/hv_auc.csv`
- `tables/operator_contract.csv`
- `tables/run_validation.json`
- `ppa_distribution/summary.json`
