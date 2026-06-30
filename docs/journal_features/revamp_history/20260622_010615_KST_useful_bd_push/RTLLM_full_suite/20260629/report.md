# RTLLM Full Suite Results

This report is generated from the reference-complete RTLLM subset.
Missing method/problem rows count as zero valid-PPA coverage for the
headline mean HV table.

## Executive Conclusion

Classic REvolution is the clear winner on this one-seed 8x5 RTLLM
reference-complete suite. No QD/MAP-Elites variant beats classic in
mean HV, HV-AUC, valid-PPA coverage, or Pareto point count. The best QD
arm by mean HV is `rf_deepgate_hybrid_delayed_8x5`, which retains
73.4% of classic mean HV.

This is negative evidence for the exact selected full-suite methods, not
a proof that diversity is useless in RTL evolution. It says that these
BDs and archive schedules do not overcome the classic hill-climbing
baseline under the current 8x5 budget and one-seed protocol.

## Run Status

- All eight method arms completed with `.done` sentinels.
- Packaging completed and generated direct PPA/Pareto reports.
- Headline metrics use 46 RTLLM designs with valid reference PPA.
- Four missing-reference RTLLM designs remain diagnostic-only:
  `Prob006_adder_pipe_64bit`, `Prob013_multi_booth_8bit`,
  `Prob018_float_multi`, and `Prob040_synchronizer`.

## Top Methods By Mean HV

| Rank | Method | Family | Covered | Mean HV | HV retention | Delta HV | Mean HV-AUC | Delta HV-AUC |
| --- | --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| 1 | `classic_revolution_8x5` | classic | 33/46 | 0.1002 | 100.0% | 0.0000 | 0.0877 | 0.0000 |
| 2 | `rf_deepgate_hybrid_delayed_8x5` | encoder | 27/46 | 0.0735 | 73.4% | -0.0267 | 0.0667 | -0.0210 |
| 3 | `masterrtl_rf_leafid_structural_delayed_8x5` | encoder | 31/46 | 0.0713 | 71.1% | -0.0289 | 0.0633 | -0.0244 |
| 4 | `masterrtl_delayed_archive_activation_8x5` | custom_qd | 31/46 | 0.0625 | 62.3% | -0.0377 | 0.0599 | -0.0278 |
| 5 | `fg_qdm_rf_leafid_front_credit_8x5` | front_guarded_qd_memory | 30/46 | 0.0614 | 61.3% | -0.0388 | 0.0591 | -0.0286 |
| 6 | `aurora_raw_impl_compact_delayed_8x5` | learned_descriptor | 31/46 | 0.0600 | 59.9% | -0.0402 | 0.0540 | -0.0338 |
| 7 | `deepgate_delayed_high_exploit_8x5` | encoder | 27/46 | 0.0576 | 57.5% | -0.0426 | 0.0546 | -0.0332 |
| 8 | `qwen_canonical_rtl_pca3_8x5` | encoder | 28/46 | 0.0432 | 43.1% | -0.0570 | 0.0384 | -0.0493 |

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

- Best encoder-style arm: `rf_deepgate_hybrid_delayed_8x5`, followed by
  `masterrtl_rf_leafid_structural_delayed_8x5`.
- Best custom RTL-native QD arm: `masterrtl_delayed_archive_activation_8x5`.
- Front-guarded QD memory did not beat the simpler delayed MasterRTL
  archive arm in this full-suite configuration.
- Pure Qwen3 RTL PCA and pure DeepGate pooled PC3 are weaker than the
  hybrid/source-aligned methods on this run.
- Coverage loss is material: classic covers 33/46 reference-complete
  designs, while the best QD arms cover 27-31/46.

## Comparison Tables

- `tables/full_suite_method_summary.csv`: one row per method with
  coverage, mean HV, mean HV-AUC, Pareto count, reference-beating
  count, and win/loss/tie totals.
- `tables/full_suite_problem_metrics.csv`: one row per method/problem
  with final HV, HV-AUC, deltas versus classic, valid-PPA count,
  Pareto count, and reference-beating count.
- `analysis/reference_complete_pareto_analysis/backend_problem_metrics.csv`:
  canonical final Pareto metrics emitted by the repo analysis script.
- `analysis/completeness/*.csv`: method-specific candidate/reference
  completeness gates.

## Generated Figures

- `figures/mean_hv_by_method.png`
- `figures/mean_hv_auc_by_method.png`
- `figures/hv_delta_by_method.png`
- `figures/valid_ppa_count_by_method.png`
- `figures/pareto_points_by_method.png`
- `figures/hv_win_loss_heatmap.png`
- `figures/hv_delta_distribution.png`
- `figures/coverage_vs_hv.png`

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

This suite supports a conservative conclusion: under the current 8x5
budget, the selected QD methods do not demonstrate QD usefulness over
classic REvolution on broad RTLLM PPA optimization. The best signals
are relative, not absolute: hybrid RF+DeepGate and MasterRTL RF
leaf-ID descriptors are stronger than pure Qwen, pure DeepGate, and
AURORA-style compact raw implementation descriptors. That suggests
source-aligned and hybrid hardware descriptors remain the most
plausible next direction, but the current archive policies still lose
too much coverage and exploitation pressure.

## Interpretation Rule

A QD method supports a headline claim only if the reference-complete
subset remains positive after coverage losses, missing candidate PPA,
and missing-reference designs are handled by the frozen manifests.
This run does not pass that standard for any QD arm.
