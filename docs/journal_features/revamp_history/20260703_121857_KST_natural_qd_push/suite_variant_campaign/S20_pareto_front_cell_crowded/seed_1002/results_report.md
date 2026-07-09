# S20 Cell-Crowded Parent Seed 1002 Result

Date packaged: 2026-07-09.

Variant: `qd_parent_selection=cell_crowded_tournament`, otherwise
Smooth-QD V2 parity settings. Full RTLLM was launched over all 50
problems; the headline comparison uses the 46 reference-complete
problems, matching P3.

## Run

- Run root:
  `exp/natural_qd_push/suite_variants_wave_b_20260708_231033_UTC/live/pareto_front_cell_crowded/seed_1002`.
- vLLM preflight:
  `suite_variant_campaign/preflights/s20_pareto_front_cell_crowded_seed1002_20260708_231033_UTC.json`.
- Runtime: 4713.26 seconds.
- LLM API calls: 4800 total.
- Validation: pass against the full 50-problem manifest with full V2
  parity pins checked.
- Operator contract: pass; `single_thought_count=0`.

## Seed 1002 Read

| Arm | Mean HV46 | HV-AUC46 | Coverage | HV wins |
| --- | --- | --- | --- | --- |
| classic REvolution | 0.097557 | 0.081183 | 33/46 | 20 |
| Smooth-QD V2 | 0.100310 | 0.090753 | 33/46 | 2 |
| S20 cell-crowded parent | 0.101958 | 0.088570 | 33/46 | 12 |

S20 is `104.5%` of matched classic HV and `109.1%` of matched classic
HV-AUC46 on this seed, with equal coverage. It is `101.6%` of matched V2
HV but `97.6%` of matched V2 HV-AUC46, again with equal coverage.

## Two-Seed Read

| Arm | Mean HV46 | HV-AUC46 | Coverage | HV wins |
| --- | --- | --- | --- | --- |
| classic REvolution | 0.104479 | 0.085867 | 66/92 | 37 |
| Smooth-QD V2 | 0.098539 | 0.087146 | 65/92 | 9 |
| S20 cell-crowded parent | 0.095855 | 0.085447 | 66/92 | 22 |

Across seeds 1001-1002, S20 is `91.7%` of matched classic HV and
`99.5%` of matched classic HV-AUC46. It ties classic coverage and covers
one more reference-complete problem than V2, but remains below V2 on
both HV and HV-AUC46.

## Interpretation

Seed 1002 is the best S20 data point and shows that cell-crowded parent
selection can produce a clean suite-level win on one seed. The registered
two-seed probe still fails the promotion gate: mean HV remains below
classic and V2, HV-AUC46 remains slightly below classic and V2, and the
coverage gain is only relative to V2.

Close S20 as a natural parent-selection negative for the primary TCAD
target. The mechanism is not broken, but it does not reliably convert
cell-local crowding pressure into stronger full-suite PPA hypervolume.
Move next to S21 scalar-elite retention, which isolates canonical
one-elite MAP-Elites pressure without adding new engine logic.

## Artifacts

- `pareto_analysis/aggregate_backend_metrics.csv`
- `tables/hv_auc.csv`
- `tables/operator_contract.csv`
- `tables/run_validation.json`
- `ppa_distribution/summary.json`
