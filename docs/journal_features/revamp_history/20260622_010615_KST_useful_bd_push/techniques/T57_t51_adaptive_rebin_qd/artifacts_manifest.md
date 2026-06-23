# T57 Artifacts Manifest

Status: pre-registered; no live result yet.

## Raw Run

- Planned root:
  `exp/useful_bd_push/t57_t51_adaptive_rebin_<timestamp>/hard_tuning/t51_adaptive_rebin_qd/seed_1001`
- Planned preflight:
  `exp/useful_bd_push/t57_t51_adaptive_rebin_<timestamp>/hard_tuning/preflight/`

## Packaged Result

Required after the live arm exits:

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

## Visualizations

Required after packaging:

- `visualizations/direct_ppa_pareto/` with `index.html`, `metrics.json`, and
  `screenshot.png`.
- `visualizations/qd_ppa_viewer/` with full Phase 03.1 export, validation
  files, screenshot, and any honest projection caveat.

## Regeneration Scripts

- `scripts/package_t48_gated_probe.py`
- `scripts/report_final_analysis_bundle.py`
- `scripts/export_qd_ppa_visualization.py`
- `scripts/validate_qd_ppa_visualization.py`
- `scripts/validate_adaptive_rebinning_run.py`
- `scripts/validate_pareto_front_run.py`
- `scripts/validate_single_thought_operator_run.py`
