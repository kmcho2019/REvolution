# S01 Capacity 7 Seed 1002 Result

Date packaged: 2026-07-08.

Variant: `qd_max_elites_per_cell=7`, otherwise Smooth-QD V2 parity
settings. Full RTLLM was launched over all 50 problems; the headline
comparison uses the 46 reference-complete problems, matching P3.

## Run

- Run root:
  `exp/natural_qd_push/suite_variants_wave_a_20260708_120949_UTC/live/capacity7/seed_1002`.
- vLLM preflight:
  `suite_variant_campaign/preflights/s01_capacity7_seed1002_20260708_120949_UTC.json`.
- Runtime: 6315.58 seconds.
- LLM API calls: 4800 total.
- Validation: pass against the full 50-problem manifest.
- Operator contract: pass; `single_thought_count=0`.

## Seed 1002 Read

| Arm | Mean HV46 | HV-AUC46 | Coverage | HV wins |
| --- | --- | --- | --- | --- |
| classic REvolution | 0.097557 | 0.081183 | 33/46 | 20 |
| Smooth-QD V2 | 0.100310 | 0.090753 | 33/46 | 4 |
| S01 capacity7 | 0.094507 | 0.086806 | 33/46 | 10 |

S01 is `96.9%` of matched classic HV and `106.9%` of matched classic
HV-AUC46 on this seed. It is `94.2%` of matched V2 HV and `95.7%` of
matched V2 HV-AUC46. Coverage ties both comparators at 33
reference-complete valid-PPA problems.

## Two-Seed Read

| Arm | Mean HV46 | HV-AUC46 | Coverage |
| --- | --- | --- | --- |
| classic REvolution | 0.104479 | 0.085867 | 66/92 |
| Smooth-QD V2 | 0.098539 | 0.087146 | 65/92 |
| S01 capacity7 | 0.092056 | 0.082392 | 67/92 |

Across seeds 1001 and 1002, S01 is `88.1%` of matched classic HV and
`96.0%` of matched classic HV-AUC46. It has one extra covered problem
over classic across 92 seed-problems, but that coverage gain is too small
to offset the main PPA HV loss.

## Interpretation

Capacity 7 is not a primary promotion candidate. The larger per-cell
front has a small coverage/yield signal and one AUC-positive seed, but
the two-seed average misses classic and V2 on both mean HV and HV-AUC46.
The result supports the mechanism read from seed 1001: extra in-cell
front material can add valid candidates without reliably preserving the
selection pressure needed for suite-scale PPA quality.

## Artifacts

- `pareto_analysis/aggregate_backend_metrics.csv`
- `tables/hv_auc.csv`
- `tables/operator_contract.csv`
- `tables/run_validation.json`
- `ppa_distribution/summary.json`
