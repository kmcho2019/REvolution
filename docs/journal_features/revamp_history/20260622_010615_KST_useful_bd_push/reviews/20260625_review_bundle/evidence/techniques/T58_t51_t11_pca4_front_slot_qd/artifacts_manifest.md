# T58 Artifacts Manifest

Status: completed; `T0 diagnostic_no_promotion`.

## Raw Run

- Raw QD root:
  `exp/useful_bd_push/t58_t51_t11_pca4_front_slot_20260623_093653_UTC/hard_tuning/t51_t11_pca4_front_slot_qd/seed_1001`
- Classic comparator root:
  `exp/useful_bd_push/t47_t26_contract_probe_20260622_203146_UTC/hard_tuning/classic_revolution/seed_1001`
- Summary log:
  `exp/useful_bd_push/t58_t51_t11_pca4_front_slot_20260623_093653_UTC/hard_tuning/t51_t11_pca4_front_slot_qd/seed_1001/openai_gpt-oss-120b/20260623_093714_revolution_summary_results.txt`
- Scheduler telemetry:
  `exp/useful_bd_push/t58_t51_t11_pca4_front_slot_20260623_093653_UTC/hard_tuning/t51_t11_pca4_front_slot_qd/seed_1001/openai_gpt-oss-120b/20260623_093714_revolution_scheduler_telemetry.json`
- Final-analysis viewer source:
  `exp/useful_bd_push/t58_t51_t11_pca4_front_slot_20260623_093653_UTC/qd_ppa_viewer_source/final_analysis/`
- Descriptor probe:
  `t11_runtime_pca_0..3`, `requires_ppa=false`,
  `requires_graph_metrics=true`.
- vLLM preflight:
  `openai/gpt-oss-120b max_model_len=131072`.

## Packaged Result

- `hard_tuning_package/README.md`
- `hard_tuning_package/tables/t58_problem_seed_metrics.csv`
- `hard_tuning_package/tables/t58_aggregate_metrics.csv`
- `hard_tuning_package/tables/t58_comparison_deltas.csv`
- `hard_tuning_package/tables/t58_family_comparison_13_problem_subset.csv`
- `hard_tuning_package/tables/t58_family_deltas_13_problem_subset.csv`
- `hard_tuning_package/tables/t58_validity_gates.csv`
- `hard_tuning_package/tables/t58_operator_counters.csv`
- `hard_tuning_package/data/t58_ppa_candidates.csv`
- `hard_tuning_package/figures/`
- `results_report.md`

## Visualizations

- `visualizations/direct_ppa_pareto/` with `index.html`, `metrics.json`, and
  `screenshot.png`.
- `visualizations/qd_ppa_viewer/` with full Phase 03.1 export, validation
  files, screenshot matrix, representative screenshot, and Playwright caveat.

## Validation

- `validate_single_thought_operator_run.py`: passed with `--require-full-subset`.
- `validate_pareto_front_run.py`: passed with `--require-full-subset`.
- `validate_qd_ppa_visualization.py --strict`: passed.
- Playwright screenshot smoke generated screenshots and reported the rank-guide
  caveat in `visualizations/qd_ppa_viewer/playwright_caveat.md`.
- Manual screenshot inspection: direct PPA and full viewer screenshots are
  readable, nonblank, and have no broken assets.

## Regeneration Scripts

- `scripts/package_t48_gated_probe.py`
- `scripts/report_final_analysis_bundle.py`
- `scripts/export_qd_ppa_visualization.py`
- `scripts/validate_qd_ppa_visualization.py`
- `scripts/validate_pareto_front_run.py`
- `scripts/validate_single_thought_operator_run.py`
