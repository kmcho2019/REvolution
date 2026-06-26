# T85 Validation Log

## 2026-06-26 Stage 0

Commands:

```bash
uv run ruff check \
  src/revolution/qd/engine.py \
  src/revolution/backends/revolution_backend.py \
  src/revolution/algorithm.py \
  scripts/run_backend.py \
  tests/revolution/test_qd_engine.py \
  tests/scripts/test_run_backend.py

uv run pytest \
  tests/revolution/test_qd_engine.py::test_front_guarded_memory_requires_matching_parent_selection \
  tests/revolution/test_qd_engine.py::test_front_guarded_memory_preserves_primary_pool \
  tests/revolution/test_qd_engine.py::test_front_guarded_memory_updates_parent_cell_credit \
  tests/scripts/test_run_backend.py::test_backend_parser_accepts_qd_options \
  -q

uv run python -m pyright \
  src/revolution/algorithm.py \
  src/revolution/qd/engine.py \
  src/revolution/backends/revolution_backend.py \
  scripts/run_backend.py
```

Result:

- `ruff`: pass
- focused `pytest`: `4 passed`
- source `pyright`: `0 errors`

Notes:

- A first pytest invocation used an outdated test name and ran zero tests. The
  corrected focused command above passed.
- Repo-wide pyright still has older test-suite typing debt, so Stage 0 records
  source-file pyright on touched runtime modules.
