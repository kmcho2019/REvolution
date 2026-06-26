# Run Checkpoint

Status: pending launch.

## Preflight

- Storage check before preregistration: `/workspace` has `2.9T` available and
  is `90%` used.
- Focused code checks before preregistration:
  - `uv run pytest tests/revolution/test_qd_engine.py -k "archive_pressure or stagnation" -q`
  - `uv run ruff check src/revolution/qd/engine.py src/revolution/backends/revolution_backend.py scripts/run_backend.py tests/revolution/test_qd_engine.py`
  - `uv tool run ty check src/revolution/qd/engine.py src/revolution/backends/revolution_backend.py`
  - `uv run python -m pyright src/revolution/qd/engine.py src/revolution/backends/revolution_backend.py`
  - `git diff --check`

## Launch

Pending vLLM preflight and run launch.

## Result

Pending.
