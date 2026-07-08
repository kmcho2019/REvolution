# S03 Elite Pareto Slot 2 Seed 1001 Result

Date packaged: 2026-07-08.

Variant: `qd_cell_mode=elite_pareto_slot` and
`qd_max_elites_per_cell=2`, otherwise Smooth-QD V2 parity settings. Full
RTLLM was launched over all 50 problems; the headline comparison uses
the 46 reference-complete problems, matching P3.

## Run

- Run root:
  `exp/natural_qd_push/suite_variants_wave_a_20260708_140623_UTC/live/elite_pareto_slot_2/seed_1001`.
- vLLM preflight:
  `suite_variant_campaign/preflights/s03_elite_pareto_slot_2_seed1001_20260708_140623_UTC.json`.
- Runtime: 6300.64 seconds.
- LLM API calls: 4801 total.
- Validation: pass against the full 50-problem manifest.
- Operator contract: pass; `single_thought_count=0`.

## Seed 1001 Read

| Arm | Mean HV46 | HV-AUC46 | Coverage | HV wins |
| --- | --- | --- | --- | --- |
| classic REvolution | 0.111401 | 0.090551 | 33/46 | 13 |
| Smooth-QD V2 | 0.096767 | 0.083539 | 32/46 | 9 |
| S03 elite-pareto slot 2 | 0.100189 | 0.088742 | 32/46 | 11 |

S03 is `89.9%` of matched classic HV and `98.0%` of matched classic
HV-AUC46 on this seed, with one fewer covered reference-complete problem.
It is `103.5%` of matched V2 HV and `106.2%` of matched V2 HV-AUC46,
while tying V2 coverage.

## Interpretation

Slot-2 retention is not a classic-beating seed, but it is the strongest
new Wave A read against V2 so far. The mechanism is simple and natural:
keep one scalar-quality elite and one local-front slot per occupied cell,
reducing the larger in-cell Pareto archive from V2 without changing the
operator path. Complete seed 1002 before deciding whether this is a
suite-level robustness lead or just a seed-1001 V2 recovery.

## Artifacts

- `pareto_analysis/aggregate_backend_metrics.csv`
- `tables/hv_auc.csv`
- `tables/operator_contract.csv`
- `tables/run_validation.json`
- `ppa_distribution/summary.json`
