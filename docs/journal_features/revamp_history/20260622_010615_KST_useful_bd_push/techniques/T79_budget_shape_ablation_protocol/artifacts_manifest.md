# T79 Artifacts Manifest

| Path | Description |
| --- | --- |
| `README.md` | Package index and current status. |
| `methodology.md` | Budget-shape protocol and selection rules. |
| `results_report.md` | Pre-run status and required completion package. |
| `commands/live_budget_shape_v0.md` | Pre-registered live command matrix. |
| `tables/t79_budget_ablation_subset.csv` | Frozen eight-design primary subset. |
| `tables/budget_shape_subset.yaml` | Validator/reporting subset config. |
| `tables/t79_deferred_candidates.csv` | Deferred candidates and exclusion reasons. |
| `tables/t79_budget_shape_matrix.csv` | Six planned method/shape arms. |
| `tables/t79_method_contract.json` | Machine-readable pre-run contract. |
| `tables/latest_live_run_root.txt` | Current live run root for T79 packaging. |
| `tables/t79_live_arm_status.csv` | Status ledger for completed or active live arms; currently all six arms complete. |
| `tables/final_analysis/shape_pair_summary.csv` | Compact matched classic-vs-QD deltas by budget shape. |
| `tables/final_analysis/pareto_aggregate_backend_metrics.csv` | Aggregate Pareto metrics copied from the final analysis bundle. |
| `tables/final_analysis/pareto_backend_problem_metrics.csv` | Per-problem Pareto metrics copied from the final analysis bundle. |
| `tables/final_analysis/ppa_candidates.csv` | Raw valid-PPA candidate table copied from the final analysis bundle. |
| `reports/final_analysis/report.md` | Top-level generated final analysis report. |
| `reports/final_analysis/backend_comparison.md` | Generated backend comparison report. |
| `reports/final_analysis/pareto_analysis.md` | Generated Pareto analysis report. |
| `reports/final_analysis/ppa_distribution.md` | Generated PPA distribution report. |
| `figures/final_analysis/summary_mean_hypervolume.png` | Clean aggregate HV summary figure. |
| `figures/final_analysis/summary_yield_and_score.png` | Clean aggregate yield and score summary figure. |
| `figures/final_analysis/summary_archive_coverage_vs_hv_delta.png` | Clean archive-coverage versus HV-delta summary figure. |
| `figures/final_analysis/pareto_fronts/*.png` | Raw copied per-problem Pareto-front diagnostics. |
| `visualizations/direct_ppa_pareto/index.html` | Static reader-facing direct PPA/Pareto supplement. |
| `visualizations/direct_ppa_pareto/metrics.json` | Compact direct PPA/Pareto metrics for the supplement. |
| `visualizations/direct_ppa_pareto/screenshot.png` | Screenshot source for the direct PPA/Pareto supplement. |
| `visualizations/qd_ppa_viewer/12x3/index.html` | Phase 03.1-compatible viewer for matched `12x3` classic/QD arms. |
| `visualizations/qd_ppa_viewer/8x5/index.html` | Phase 03.1-compatible viewer for matched `8x5` classic/QD arms. |
| `visualizations/qd_ppa_viewer/6x7/index.html` | Phase 03.1-compatible viewer for matched `6x7` classic/QD arms. |
| `visualizations/qd_ppa_viewer/*/screenshot.png` | Compare-mode Playwright render screenshot for each viewer. |
| `tables/preflight_models_20260624_042959_UTC.json` | vLLM `/v1/models` response. |
| `tables/preflight_models_20260624_042959_UTC.txt` | Human-readable preflight summary. |
| `figures/t79_budget_subset_selection.png` | Frozen subset selection plot. |
| `figures/visual_inspection_notes.md` | Manual visual inspection notes. |
| `tools/build_t79_budget_shape_tables.py` | Reproducer for subset tables and figure. |
| `tools/validate_t79_command_matrix.py` | Dry parser/task-count validator for the six planned arms. |
| `tools/build_t79_summary_figures.py` | Reproducer for compact tracked T79 summary figures. |
