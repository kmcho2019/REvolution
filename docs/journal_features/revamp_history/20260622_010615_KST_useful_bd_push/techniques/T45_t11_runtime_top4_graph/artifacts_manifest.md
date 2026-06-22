# T45 Artifacts Manifest

Status: pre-registered; live artifacts pending.

## Runtime Roots

- Planned full live root:
  `exp/useful_bd_push/t45_t11_runtime_top4_graph_${RUN_TS}/`
- Runtime outputs stay under `exp/`, not `/aux`.

## Planned Committed Artifacts

- `methodology.md`
- `commands/live_screen_v0.md`
- `results_report.md`
- `tables/run_matrix.csv`
- `tables/live_screen_v0_subset.yaml`
- `tables/t45_pareto_front_validation.{json,md}`
- `tables/t45_candidate_ppa_points.csv`
- `tables/t45_problem_method_summary.csv`
- `tables/t45_method_manifest.csv`
- `figures/t45_raw_area_power_fronts.png`
- `figures/t45_front_count_summary.png`
- `figures/visual_inspection_notes.md`
- `visualizations/direct_ppa_pareto/{README.md,index.html,metrics.json,screenshot.png}`
- `visualizations/qd_ppa_viewer/{README.md,index.html,manifest.json,validation.json,validation.md,screenshot.png}`
- `visualizations/qd_ppa_viewer/datasets/*.json`
- `visualizations/qd_ppa_viewer_source/final_analysis/...`

## Code Paths

- `data/configs/qd_descriptor_profiles.yaml`
- `src/revolution/graph_descriptor_evaluator.py`
- `src/revolution/qd/descriptors.py`
- `src/revolution/qd/ppa_visualization_export.py`
- `src/revolution/qd/ppa_visualization_viewer.py`
- `scripts/package_t45_t11_runtime_top4_graph.py`
- `scripts/export_qd_ppa_visualization.py`
- `scripts/validate_qd_ppa_visualization.py`
- `tests/revolution/test_qd_descriptors.py`
- `tests/scripts/test_package_t45_t11_runtime_top4_graph.py`

## Validation

Required after the live run:

- vLLM `/v1/models` preflight saved in `tables/`;
- `scripts/validate_pareto_front_run.py` with `--require-full-subset`;
- `scripts/package_t45_t11_runtime_top4_graph.py`;
- `scripts/report_final_analysis_bundle.py`;
- `scripts/export_qd_ppa_visualization.py --strict`;
- `scripts/validate_qd_ppa_visualization.py --strict --playwright`;
- visual inspection of the direct PPA PNG, direct HTML screenshot, and full
  Phase 03.1 viewer screenshot.

Hashes will be filled after artifacts are generated and normalized.
