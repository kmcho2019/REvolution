# T46 Artifacts Manifest

Status: pre-run manifest.

## Planned Run

- run root:
  `exp/useful_bd_push/t46_t11_runtime_pca4_graph_<RUN_TS>/`
- candidate backend:
  `t11_runtime_pca4_graph_qd`
- matched control:
  `classic_revolution`
- fixed subset:
  `tables/live_screen_v0_subset.yaml`
- command card:
  `commands/live_screen_v0.md`

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
