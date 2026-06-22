# T48 Artifacts Manifest

Status: implementation ready. Live result is pending.

## Method Sources

Implemented source touch points:

- `src/revolution/qd/engine.py`
- `src/revolution/backends/revolution_backend.py`
- `scripts/run_backend.py`
- `tests/revolution/test_qd_engine.py`
- `tests/revolution/test_revolution_backend.py`

The implementation must keep `qd_two_parent_gate=none` as the default so prior
T26/T47 behavior is unchanged.

Focused validation:

- `uv run pytest tests/revolution/test_qd_engine.py tests/revolution/test_revolution_backend.py -q`
- `uv run ruff check src/revolution/qd/engine.py src/revolution/backends/revolution_backend.py scripts/run_backend.py tests/revolution/test_qd_engine.py tests/revolution/test_revolution_backend.py`
- `uv tool run ty check src/revolution/qd/engine.py src/revolution/backends/revolution_backend.py`
- `uv run python -m pyright src/revolution/qd/engine.py src/revolution/backends/revolution_backend.py`

## Planned Live Run

- run root:
  `exp/useful_bd_push/t48_t26_gated_near_front_fusion_<timestamp>/hard_tuning`
- candidate backend:
  `t26_gated_near_front_fusion_qd`
- comparator backend:
  T47 `classic_revolution` seeds `1001` and `1002`
- fixed subset:
  `data/configs/hard_iteration_subset.yaml`
- command card:
  `commands/hard_tuning_sanity.md`

## Required Result Artifacts

- vLLM `/v1/models` preflight metadata;
- T48 live command log;
- per-problem/seed metrics table;
- aggregate metrics table;
- validity gate table;
- candidate-level PPA data;
- direct raw area-power PPA-front figures;
- visual inspection notes;
- results report with T0/T1/T2/T3 tier decision.

If archive artifacts are complete, add the full Phase 03.1
`visualizations/qd_ppa_viewer/` bundle beside the direct PPA-front supplement.
