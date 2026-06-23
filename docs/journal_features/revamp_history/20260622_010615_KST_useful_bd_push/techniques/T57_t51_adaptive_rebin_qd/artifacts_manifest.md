# T57 Artifacts Manifest

Status: completed hard/tuning result, `T0 diagnostic_no_rebin_signal`.

## Raw Run

- Raw root:
  `exp/useful_bd_push/t57_t51_adaptive_rebin_20260623_083945_UTC/hard_tuning/t51_adaptive_rebin_qd/seed_1001`
- Preflight:
  `exp/useful_bd_push/t57_t51_adaptive_rebin_20260623_083945_UTC/hard_tuning/preflight/`
- Viewer source:
  `exp/useful_bd_push/t57_t51_adaptive_rebin_20260623_083945_UTC/qd_ppa_viewer_source/final_analysis/`

## Packaged Result

- `hard_tuning_package/README.md`
- `hard_tuning_package/tables/t57_problem_seed_metrics.csv`
- `hard_tuning_package/tables/t57_aggregate_metrics.csv`
- `hard_tuning_package/tables/t57_comparison_deltas.csv`
- `hard_tuning_package/tables/t57_family_comparison_13_problem_subset.csv`
- `hard_tuning_package/tables/t57_family_deltas_13_problem_subset.csv`
- `hard_tuning_package/tables/t57_validity_gates.csv`
- `hard_tuning_package/tables/t57_rebinning_counters.csv`
- `hard_tuning_package/data/t57_ppa_candidates.csv`
- `hard_tuning_package/figures/`
- `results_report.md`
- Adaptive validation diagnostics:
  `exp/useful_bd_push/t57_t51_adaptive_rebin_20260623_083945_UTC/hard_tuning/adaptive_rebin_validation_modes/adaptive_rebinning_validation.md`

## Visualizations

- `visualizations/direct_ppa_pareto/` with `index.html`, `metrics.json`, and
  `screenshot.png`.
- `visualizations/qd_ppa_viewer/` with full Phase 03.1 export, validation
  files, screenshot, and Playwright caveat.

## Regeneration Scripts

- `scripts/package_t48_gated_probe.py`
- `scripts/report_final_analysis_bundle.py`
- `scripts/export_qd_ppa_visualization.py`
- `scripts/validate_qd_ppa_visualization.py`
- `scripts/validate_adaptive_rebinning_run.py`
- `scripts/validate_pareto_front_run.py`
- `scripts/validate_single_thought_operator_run.py`
