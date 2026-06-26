# Run Checkpoint

Status: preregistered; not launched.

## Preflight

- Storage: `/workspace` has about `2.9T` available at preregistration time.
- Code checks before launch:
  - `uv run pytest tests/revolution/test_qd_engine.py -k delays_archive_pressure -q`
  - `uv run ruff check src/revolution/qd/scheduler.py src/revolution/qd/engine.py src/revolution/backends/revolution_backend.py scripts/run_backend.py tests/revolution/test_qd_engine.py`
  - `uv tool run ty check src/revolution/qd/scheduler.py src/revolution/qd/engine.py src/revolution/backends/revolution_backend.py`
  - `uv run python -m pyright src/revolution/qd/scheduler.py src/revolution/qd/engine.py src/revolution/backends/revolution_backend.py`
  - `git diff --check`

## Launch

Pending vLLM model preflight and git commit.
