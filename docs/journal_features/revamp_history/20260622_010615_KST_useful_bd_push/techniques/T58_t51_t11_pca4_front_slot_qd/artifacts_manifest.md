# T58 Artifacts Manifest

Status: pre-registered; no live result yet.

## Planned Raw Run

- Planned root:
  `exp/useful_bd_push/t58_t51_t11_pca4_front_slot_<timestamp>/hard_tuning/t51_t11_pca4_front_slot_qd/seed_1001`
- Planned preflight:
  `exp/useful_bd_push/t58_t51_t11_pca4_front_slot_<timestamp>/hard_tuning/preflight/`
- Descriptor probe:
  `t11_runtime_pca_0..3`, `requires_ppa=false`,
  `requires_graph_metrics=true`.

## Required Packaged Result

- `hard_tuning_package/README.md`
- `hard_tuning_package/tables/t58_problem_seed_metrics.csv`
- `hard_tuning_package/tables/t58_aggregate_metrics.csv`
- `hard_tuning_package/tables/t58_comparison_deltas.csv`
- `hard_tuning_package/tables/t58_family_comparison_13_problem_subset.csv`
- `hard_tuning_package/tables/t58_family_deltas_13_problem_subset.csv`
- `hard_tuning_package/tables/t58_validity_gates.csv`
- `hard_tuning_package/data/t58_ppa_candidates.csv`
- `hard_tuning_package/figures/`
- `results_report.md`

## Required Visualizations

- `visualizations/direct_ppa_pareto/` with `index.html`, `metrics.json`, and
  `screenshot.png`.
- `visualizations/qd_ppa_viewer/` with full Phase 03.1 export, validation
  files, screenshot, and any honest projection caveat.

## Regeneration Scripts

- `scripts/package_t48_gated_probe.py`
- `scripts/report_final_analysis_bundle.py`
- `scripts/export_qd_ppa_visualization.py`
- `scripts/validate_qd_ppa_visualization.py`
- `scripts/validate_pareto_front_run.py`
- `scripts/validate_single_thought_operator_run.py`
