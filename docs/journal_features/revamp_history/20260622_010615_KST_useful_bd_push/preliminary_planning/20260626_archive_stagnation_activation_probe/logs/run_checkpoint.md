# Run Checkpoint

Status: completed.

## Preflight

- Storage check before preregistration: `/workspace` has `2.9T` available and
  is `90%` used.
- vLLM preflight passed before launch:
  `openai/gpt-oss-120b`, `max_model_len=131072`.
- Focused code checks before preregistration:
  - `uv run pytest tests/revolution/test_qd_engine.py -k "archive_pressure or stagnation" -q`
  - `uv run ruff check src/revolution/qd/engine.py src/revolution/backends/revolution_backend.py scripts/run_backend.py tests/revolution/test_qd_engine.py`
  - `uv tool run ty check src/revolution/qd/engine.py src/revolution/backends/revolution_backend.py`
  - `uv run python -m pyright src/revolution/qd/engine.py src/revolution/backends/revolution_backend.py`
  - `git diff --check`

## Launch

- Run root:
  `exp/useful_bd_push/prelim_archive_stagnation_activation_20260626_031337_UTC/live`
- Run path:
  `exp/useful_bd_push/prelim_archive_stagnation_activation_20260626_031337_UTC/live/masterrtl_archive_stagnation_activation_8x5/seed_1001`
- Run completed `8/8` problems in `1433.52s`.
- Comprehensive log:
  `exp/useful_bd_push/prelim_archive_stagnation_activation_20260626_031337_UTC/live/masterrtl_archive_stagnation_activation_8x5/seed_1001/openai_gpt-oss-120b/20260626_031704_revolution_run_log.txt`

## Result

- `scripts/validate_pareto_front_run.py` passed with no output.
- `scripts/validate_single_thought_operator_run.py` passed with no output.
- Targeted Pareto and PPA-distribution reports completed.
- Decision: diagnostic negative, not promoted.
