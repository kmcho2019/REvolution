# T46 Artifacts Manifest

Status: complete result package.

## Live Run

- run root:
  `exp/useful_bd_push/t46_t11_runtime_pca4_graph_20260622_182358_UTC`
- candidate backend:
  `t11_runtime_pca4_graph_qd`
- matched control:
  `classic_revolution`
- fixed subset:
  `tables/live_screen_v0_subset.yaml`
- command card:
  `commands/live_screen_v0.md`
- vLLM preflight:
  `tables/preflight_models_20260622_182358_UTC.json`

## Method Sources

- `src/revolution/qd/descriptors.py`
- `data/configs/qd_descriptor_profiles.yaml`
- `scripts/package_t46_t11_runtime_pca4_graph.py`
- `tests/revolution/test_qd_descriptors.py`
- `tests/scripts/test_package_t46_t11_runtime_pca4_graph.py`

## Projection Fit

- source table:
  `techniques/T14_dehnn_hypergraph_bd/tables/hypergraph_features.csv`
- parsed rows used: `768`
- component table:
  `tables/t46_projection_components.csv`
- leakage exclusions:
  PPA, reference PPA, fitness, hypervolume, Pareto labels, validity labels,
  pass rate, problem id, corpus, model, method, seed, and candidate id.

## Validation Commands

Pre-run checks:

- `uv run pytest tests/revolution/test_qd_descriptors.py tests/scripts/test_package_t46_t11_runtime_pca4_graph.py -q`
- `uv run ruff check src/revolution/qd/descriptors.py scripts/package_t46_t11_runtime_pca4_graph.py tests/revolution/test_qd_descriptors.py tests/scripts/test_package_t46_t11_runtime_pca4_graph.py`
- `uv tool run ty check src/revolution/qd/descriptors.py scripts/package_t46_t11_runtime_pca4_graph.py tests/revolution/test_qd_descriptors.py tests/scripts/test_package_t46_t11_runtime_pca4_graph.py`
- `git diff --check`

Post-run validation and viewer commands are listed in
`commands/live_screen_v0.md`.

## Result Artifacts

- direct raw-PPA figure:
  `figures/t46_raw_area_power_fronts.png`
- count summary:
  `figures/t46_front_count_summary.png`
- visual inspection notes:
  `figures/visual_inspection_notes.md`
- direct raw-PPA supplement:
  `visualizations/direct_ppa_pareto/index.html`
- full Phase 03.1 viewer:
  `visualizations/qd_ppa_viewer/index.html`
- viewer validation:
  `visualizations/qd_ppa_viewer/validation.md`
- final analysis source bundle:
  `visualizations/qd_ppa_viewer_source/final_analysis/`

## Validation Results

- Pareto archive validation: passed,
  `tables/t46_pareto_front_validation.md`.
- Full Phase 03.1 viewer validation: passed,
  `visualizations/qd_ppa_viewer/validation.md`.
- Direct raw-PPA screenshot was captured and manually inspected:
  `visualizations/direct_ppa_pareto/screenshot.png`.
- Full viewer compare screenshot was captured and manually inspected:
  `visualizations/qd_ppa_viewer/screenshot.png`.
