# S20 Cell-Crowded Parent Seed 1001 Result

Date packaged: 2026-07-08.

Variant: `qd_parent_selection=cell_crowded_tournament`, otherwise
Smooth-QD V2 parity settings. Full RTLLM was launched over all 50
problems; the headline comparison uses the 46 reference-complete
problems, matching P3.

## Run

- Run root:
  `exp/natural_qd_push/suite_variants_wave_b_20260708_214449_UTC/live/pareto_front_cell_crowded/seed_1001`.
- vLLM preflight:
  `suite_variant_campaign/preflights/s20_pareto_front_cell_crowded_seed1001_20260708_214449_UTC.json`.
- Runtime: 4657.62 seconds.
- LLM API calls: 4800 total.
- Validation: pass against the full 50-problem manifest with full V2
  parity pins checked.
- Operator contract: pass; `single_thought_count=0`.

## Seed 1001 Read

| Arm | Mean HV46 | HV-AUC46 | Coverage | HV wins |
| --- | --- | --- | --- | --- |
| classic REvolution | 0.111401 | 0.090551 | 33/46 | 17 |
| Smooth-QD V2 | 0.096767 | 0.083539 | 32/46 | 7 |
| S20 cell-crowded parent | 0.089752 | 0.082324 | 33/46 | 10 |

S20 is `80.6%` of matched classic HV and `92.8%` of matched V2 HV on
this seed. It is `90.9%` of matched classic HV-AUC46 and `98.5%` of
matched V2 HV-AUC46. Coverage ties classic at 33 reference-complete
problems and is one problem above V2.

## Interpretation

This is not a promotion result. Replacing V2 global NSGA-II parent
selection with cell-crowded tournament selection keeps the operator
contract clean and preserves coverage, but it loses too much final HV.
The mechanism looks yield-neutral but HV-diluting: S20 has slightly more
mean Pareto points and reference-beating candidates than V2, yet the
front material does not concentrate into stronger suite-scale PPA
hypervolume.

Because the suite-first ladder treats one full-suite seed as a
runtime/extraction gate rather than a quality kill, S20 should still
complete seed 1002 before retirement. If the two-seed read remains below
classic and V2 on HV/AUC, close S20 as a parent-selection negative and
move to S21 scalar-elite retention.

## Artifacts

- `pareto_analysis/aggregate_backend_metrics.csv`
- `tables/hv_auc.csv`
- `tables/operator_contract.csv`
- `tables/run_validation.json`
- `ppa_distribution/summary.json`
