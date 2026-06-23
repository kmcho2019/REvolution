# T54 Artifacts Manifest

Status: completed hard/tuning result; `T0 diagnostic_not_promoted`.

## Raw Run

- Run root:
  `exp/useful_bd_push/t54_front_slot_lane_20260623_054428_UTC/hard_tuning/code_thought_front_slot_lane_qd/seed_1001`
- Preflight:
  `exp/useful_bd_push/t54_front_slot_lane_20260623_054428_UTC/hard_tuning/preflight/`
- Validation:
  `single_thought_operator_validation.md` and `pareto_front_validation.md`
  under the run root.

## Packaged Result

The live result is packaged at:

- `hard_tuning_package/README.md`
- `hard_tuning_package/tables/t54_problem_seed_metrics.csv`
- `hard_tuning_package/tables/t54_aggregate_metrics.csv`
- `hard_tuning_package/tables/t54_comparison_deltas.csv`
- `hard_tuning_package/tables/t54_family_comparison_13_problem_subset.csv`
- `hard_tuning_package/tables/t54_family_deltas_13_problem_subset.csv`
- `hard_tuning_package/tables/t54_validity_gates.csv`
- `hard_tuning_package/tables/t54_operator_counters.csv`
- `hard_tuning_package/data/t54_ppa_candidates.csv`
- `hard_tuning_package/figures/`
- `results_report.md`

## Visualizations

- `visualizations/direct_ppa_pareto/` with `index.html`, `metrics.json`, and
  `screenshot.png`.
- `visualizations/qd_ppa_viewer/` with full Phase 03.1 export, validation
  files, screenshot, and `playwright_caveat.md`.

## Regeneration Scripts

- `scripts/package_t48_gated_probe.py`
- `scripts/report_final_analysis_bundle.py`
- `scripts/export_qd_ppa_visualization.py`
- `scripts/validate_qd_ppa_visualization.py`
- `scripts/validate_pareto_front_run.py`
- `scripts/validate_single_thought_operator_run.py`
