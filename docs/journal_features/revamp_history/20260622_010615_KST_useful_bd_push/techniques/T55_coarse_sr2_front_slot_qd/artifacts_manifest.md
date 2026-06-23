# T55 Artifacts Manifest

Status: completed and packaged as `T0 positive_mechanism_ablation_not_promoted`.

## Raw Run

- QD root:
  `exp/useful_bd_push/t55_coarse_sr2_front_slot_20260623_064153_UTC/hard_tuning/code_thought_coarse_sr2_front_slot_qd/seed_1001`
- Classic comparator root:
  `exp/useful_bd_push/t47_t26_contract_probe_20260622_203146_UTC/hard_tuning/classic_revolution/seed_1001`
- Final-analysis source:
  `exp/useful_bd_push/t55_coarse_sr2_front_slot_20260623_064153_UTC/qd_ppa_viewer_source/final_analysis/`
- Preflight:
  `exp/useful_bd_push/t55_coarse_sr2_front_slot_20260623_064153_UTC/hard_tuning/preflight/`

## Packaged Result

These paths are packaged:

- `hard_tuning_package/README.md`
- `hard_tuning_package/tables/t55_problem_seed_metrics.csv`
- `hard_tuning_package/tables/t55_aggregate_metrics.csv`
- `hard_tuning_package/tables/t55_comparison_deltas.csv`
- `hard_tuning_package/tables/t55_family_comparison_13_problem_subset.csv`
- `hard_tuning_package/tables/t55_family_deltas_13_problem_subset.csv`
- `hard_tuning_package/tables/t55_validity_gates.csv`
- `hard_tuning_package/tables/t55_operator_counters.csv`
- `hard_tuning_package/data/t55_ppa_candidates.csv`
- `hard_tuning_package/figures/`
- `results_report.md`

## Visualizations

Packaged after validation:

- `visualizations/direct_ppa_pareto/` with `index.html`, `metrics.json`, and
  `screenshot.png`.
- `visualizations/qd_ppa_viewer/` with full Phase 03.1 export, validation
  files, screenshot, and any honest projection caveat.

Strict Phase 03.1 schema validation passed. The optional Playwright smoke
generated screenshots but failed deeper compare/hover checks; see
`visualizations/qd_ppa_viewer/playwright_caveat.md`.

## Regeneration Scripts

- `scripts/package_t48_gated_probe.py`
- `scripts/report_final_analysis_bundle.py`
- `scripts/export_qd_ppa_visualization.py`
- `scripts/validate_qd_ppa_visualization.py`
- `scripts/validate_pareto_front_run.py`
- `scripts/validate_single_thought_operator_run.py`
