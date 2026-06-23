# T56 Artifacts Manifest

Status: completed; `T0 diagnostic_retire_coarse_sr2_geometry`.

## Raw Run

- Run root:
  `exp/useful_bd_push/t56_coarse_sr2_t51_control_20260623_074326_UTC/hard_tuning/code_thought_coarse_sr2_t51_control_qd/seed_1001`
- Preflight:
  `exp/useful_bd_push/t56_coarse_sr2_t51_control_20260623_074326_UTC/hard_tuning/preflight/`
- Runtime: `1598.41` seconds.

## Packaged Result

- `hard_tuning_package/README.md`
- `hard_tuning_package/tables/t56_problem_seed_metrics.csv`
- `hard_tuning_package/tables/t56_aggregate_metrics.csv`
- `hard_tuning_package/tables/t56_comparison_deltas.csv`
- `hard_tuning_package/tables/t56_family_comparison_13_problem_subset.csv`
- `hard_tuning_package/tables/t56_family_deltas_13_problem_subset.csv`
- `hard_tuning_package/tables/t56_validity_gates.csv`
- `hard_tuning_package/tables/t56_operator_counters.csv`
- `hard_tuning_package/data/t56_ppa_candidates.csv`
- `hard_tuning_package/figures/`
- `results_report.md`

## Visualizations

- `visualizations/direct_ppa_pareto/` with `index.html`, `metrics.json`, and
  `screenshot.png`.
- `visualizations/qd_ppa_viewer/` with full Phase 03.1 export, validation
  files, screenshot, and any honest projection caveat.

Strict Phase 03.1 schema validation passes. The optional Playwright smoke
generates screenshots but reports compare and hover warnings; the caveat is
documented in `visualizations/qd_ppa_viewer/playwright_caveat.md`.

## Regeneration Scripts

- `scripts/package_t48_gated_probe.py`
- `scripts/report_final_analysis_bundle.py`
- `scripts/export_qd_ppa_visualization.py`
- `scripts/validate_qd_ppa_visualization.py`
- `scripts/validate_pareto_front_run.py`
- `scripts/validate_single_thought_operator_run.py`
