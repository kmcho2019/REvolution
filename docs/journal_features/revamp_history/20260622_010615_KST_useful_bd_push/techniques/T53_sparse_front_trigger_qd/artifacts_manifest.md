# T53 Artifacts Manifest

Status: completed seed `1001` package.

## Raw Run

- `exp/useful_bd_push/t53_sparse_front_trigger_20260623_045328_UTC/hard_tuning/code_thought_sparse_front_trigger_qd/seed_1001`
- `exp/useful_bd_push/t53_sparse_front_trigger_20260623_045328_UTC/hard_tuning/preflight/`
- `exp/useful_bd_push/t53_sparse_front_trigger_20260623_045328_UTC/hard_tuning/pareto_front_validation.md`
- `exp/useful_bd_push/t53_sparse_front_trigger_20260623_045328_UTC/hard_tuning/single_thought_operator_validation.md`

## Packaged Result

- `hard_tuning_package/README.md`
- `hard_tuning_package/tables/t53_problem_seed_metrics.csv`
- `hard_tuning_package/tables/t53_aggregate_metrics.csv`
- `hard_tuning_package/tables/t53_comparison_deltas.csv`
- `hard_tuning_package/tables/t53_family_comparison_13_problem_subset.csv`
- `hard_tuning_package/tables/t53_family_deltas_13_problem_subset.csv`
- `hard_tuning_package/tables/t53_validity_gates.csv`
- `hard_tuning_package/tables/t53_operator_counters.csv`
- `hard_tuning_package/data/t53_ppa_candidates.csv`
- `hard_tuning_package/figures/`
- `hard_tuning_package/validation/`

## Visualizations

- `visualizations/direct_ppa_pareto/` with `index.html`, `metrics.json`, and
  `screenshot.png`.
- `visualizations/qd_ppa_viewer/` with full Phase 03.1 export, validation
  files, screenshot set, strict-validation caveat, and Playwright hover caveat.

## Regeneration Scripts

- `scripts/package_t48_gated_probe.py`
- `scripts/report_final_analysis_bundle.py`
- `scripts/export_qd_ppa_visualization.py`
- `scripts/validate_qd_ppa_visualization.py`
- `scripts/validate_pareto_front_run.py`
- `scripts/validate_single_thought_operator_run.py`
