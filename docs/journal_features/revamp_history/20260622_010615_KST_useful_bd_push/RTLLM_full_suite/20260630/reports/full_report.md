# RTLLM Full Suite Results

This report is generated from the `full` stage.
Missing method/problem rows count as zero valid-PPA coverage for the
headline mean HV table.

## Executive Conclusion

This is the corrected EoH-preserving suite. The QD arms keep the
classic thought/code/feedback operator stack and add only descriptor
archive or PCN memory pressure.

The best non-classic arm by mean HV is `pcn_v3_rf_stagnation_memory_8x5`,
which retains 103.4% of
classic mean HV.

This is a positive one-seed signal for PCN-style QD memory, not a
definitive multi-seed claim. The descriptor/archive-only QD arms do
not beat classic in this corrected full-suite run.

Use this report only after checking `analysis/<stage>/operator_contract.csv`.
Any nonzero `single_thought_count` invalidates the corrected comparison.

## Run Status

- Method arms are tracked with stage-prefixed `.done` sentinels.
- Packaging completed and generated direct PPA/Pareto reports.
- Headline metrics use 46 reference-complete design(s).

## Top Methods By Mean HV

| Rank | Method | Family | Covered | Mean HV | HV retention | Delta HV | Mean HV-AUC | Delta HV-AUC |
| --- | --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| 1 | `pcn_v3_rf_stagnation_memory_8x5` | pcn_qd_memory | 33/46 | 0.1031 | 103.4% | 0.0033 | 0.0907 | 0.0008 |
| 2 | `classic_revolution_8x5` | classic | 33/46 | 0.0997 | 100.0% | 0.0000 | 0.0899 | 0.0000 |
| 3 | `deepgate_high_exploit_eoh_8x5` | encoder | 25/46 | 0.0933 | 93.5% | -0.0065 | 0.0783 | -0.0116 |
| 4 | `masterrtl_archive_activation_eoh_8x5` | custom_qd | 33/46 | 0.0914 | 91.6% | -0.0083 | 0.0763 | -0.0136 |

## Metric Definitions

- `Covered`: number of reference-complete designs with at least one
  valid-PPA candidate for the method.
- `Mean HV`: mean final PPA hypervolume over all 46 headline designs;
  missing method/problem PPA rows contribute zero.
- `Mean HV-AUC`: mean generation-wise hypervolume area under curve,
  recomputed from `ppa_candidates.csv` over generations 0 through 5.
- `HV retention`: method mean HV divided by classic mean HV.
- `Delta HV`: method mean HV minus classic mean HV.

## Method Takeaways

- Compare this report against 20260629 only as an operator-corrected
  rerun, not as a direct same-method continuation.
- The PCN arm is the only active QD-memory method in this suite.
- PCN records 9 wins,
  9 losses, and
  28 ties versus classic by final HV.
- The other QD arms test descriptor/archive pressure under EoH
  thought/code/feedback operators.

## Comparison Tables

- `tables/full_suite_method_summary.csv`: one row per method with
  coverage, mean HV, mean HV-AUC, Pareto count, reference-beating
  count, and win/loss/tie totals.
- `tables/full_suite_problem_metrics.csv`: one row per method/problem
  with final HV, HV-AUC, deltas versus classic, valid-PPA count,
  Pareto count, and reference-beating count.
- `analysis/full/reference_complete_pareto_analysis/backend_problem_metrics.csv`:
  canonical final Pareto metrics emitted by the repo analysis script.
- `analysis/full/completeness/*.csv`: method-specific candidate/reference
  completeness gates.
- `analysis/full/operator_contract.csv`: per-method operator audit.

## Generated Figures

- `figures/mean_hv_by_method.png`
- `figures/mean_hv_auc_by_method.png`
- `figures/hv_delta_by_method.png`
- `figures/valid_ppa_count_by_method.png`
- `figures/pareto_points_by_method.png`
- `figures/hv_win_loss_heatmap.png`
- `figures/hv_delta_distribution.png`
- `figures/coverage_vs_hv.png`

Figures include completed methods only. The summary table still
keeps not-started smoke-only arms for manifest/status accounting.

## PCN Mechanism Artifacts

- `reports/pcn_memory_mechanism.md` summarizes whether the
  guarded memory lane actually fired.
- `analysis/full/pcn_memory_mechanism_summary.csv` records
  per-problem memory-refine counters.
- `figures/full/pcn_memory_front_contributions.png` shows
  where memory-refine added local/global front material.

## Viewer Caveat

The direct PPA/Pareto reports and suite figures were generated
successfully. The Phase 03.1 viewer export failed in the initial
packaging pass because the viewer exporter expected staged PPA inputs
under each viewer source root, then strict export also encountered
reference-complete designs with no PPA rows for a pairwise viewer.
Therefore common-contract archive metrics are not used for the
headline result in this report. HV-AUC here is recomputed directly
from the reference-complete `ppa_candidates.csv` chronology.

## Research Read

This corrected suite tests whether prior QD underperformance was
caused by the single-thought operator mismatch. A positive result
requires the operator contract to pass and the reference-complete
mean HV/HV-AUC comparison to improve over the 20260629 QD arms.

## Interpretation Rule

A QD method supports a headline claim only if the reference-complete
subset remains positive after coverage losses, missing candidate PPA,
and missing-reference designs are handled by the frozen manifests.
PCN passes this one-seed screen; the descriptor/archive-only QD arms do not.
