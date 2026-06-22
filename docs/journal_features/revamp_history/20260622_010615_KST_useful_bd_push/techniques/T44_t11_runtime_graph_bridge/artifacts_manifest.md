# T44 Artifacts Manifest

Status: pre-registered with runtime smoke evidence.

## Runtime Roots

- Smoke/preflight root:
  `exp/useful_bd_push/t44_t11_runtime_graph_bridge_20260622_113144_UTC/`
- Runtime outputs stay under `exp/`, not `/aux`.

## Committed Artifacts

- `methodology.md`
- `commands/live_screen_v0.md`
- `results_report.md`
- `tables/run_matrix.csv`
- `tables/smoke_summary.json`
- `tables/preflight_models_20260622_113144_UTC.json`
- `tables/live_screen_v0_subset.yaml`
- `tables/README.md`
- `figures/README.md`
- `figures/visual_inspection_notes.md`

## Code Paths

- `src/revolution/graph_descriptor_evaluator.py`
- `src/revolution/qd/descriptors.py`
- `scripts/package_t44_t11_runtime_graph_bridge.py`
- `data/configs/qd_descriptor_profiles.yaml`
- `tests/revolution/test_graph_descriptor_evaluator.py`
- `tests/revolution/test_qd_descriptors.py`
- `tests/scripts/test_package_t44_t11_runtime_graph_bridge.py`

## Validation So Far

- `uv run pytest tests/revolution/test_graph_descriptor_evaluator.py tests/revolution/test_qd_descriptors.py`
- `uv run ruff check src/revolution/graph_descriptor_evaluator.py src/revolution/qd/descriptors.py tests/revolution/test_graph_descriptor_evaluator.py tests/revolution/test_qd_descriptors.py`

## Pending Artifacts

The full live run must add direct raw PPA figures, source CSVs, full
Phase 03.1 `visualizations/qd_ppa_viewer/`, direct
`visualizations/direct_ppa_pareto/` supplement, validation JSON/MD,
screenshots, hashes, honest classic-projection notes, and a final tier
decision.
