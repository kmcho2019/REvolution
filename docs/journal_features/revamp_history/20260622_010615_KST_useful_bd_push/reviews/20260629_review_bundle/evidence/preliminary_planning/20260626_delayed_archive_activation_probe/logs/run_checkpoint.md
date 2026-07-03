# Run Checkpoint

Status: completed.

## Preflight

- Storage: `/workspace` has about `2.9T` available at preregistration time.
- Code checks before launch:
  - `uv run pytest tests/revolution/test_qd_engine.py -k delays_archive_pressure -q`
  - `uv run ruff check src/revolution/qd/scheduler.py src/revolution/qd/engine.py src/revolution/backends/revolution_backend.py scripts/run_backend.py tests/revolution/test_qd_engine.py`
  - `uv tool run ty check src/revolution/qd/scheduler.py src/revolution/qd/engine.py src/revolution/backends/revolution_backend.py`
  - `uv run python -m pyright src/revolution/qd/scheduler.py src/revolution/qd/engine.py src/revolution/backends/revolution_backend.py`
  - `git diff --check`

## Launch

The vLLM endpoint returned `openai/gpt-oss-120b` with
`max_model_len=131072`, satisfying the `128000` token requirement.

The live run completed `8/8` problems:

- run root:
  `exp/useful_bd_push/prelim_delayed_archive_activation_20260626_022126_UTC/live`;
- run name: `masterrtl_delayed_archive_activation_8x5`;
- total runtime: `1620.73s`;
- summary:
  `exp/useful_bd_push/prelim_delayed_archive_activation_20260626_022126_UTC/live/masterrtl_delayed_archive_activation_8x5/seed_1001/openai_gpt-oss-120b/20260626_022434_revolution_summary_results.txt`;
- telemetry:
  `exp/useful_bd_push/prelim_delayed_archive_activation_20260626_022126_UTC/live/masterrtl_delayed_archive_activation_8x5/seed_1001/openai_gpt-oss-120b/20260626_022434_revolution_scheduler_telemetry.json`.

## Validators

Both validators passed with no output:

- `uv run python scripts/validate_pareto_front_run.py ...`;
- `uv run python scripts/validate_single_thought_operator_run.py ...`.

## Final Analysis

Completed sections:

- backend comparison;
- Pareto analysis;
- PPA distribution;
- hard-iteration analysis;
- evolutionary reports.

Interrupted section:

- source-aligned design-space feature recovery after more than `10` minutes.

The traceback shows the interrupted call was inside MasterRTL-backed source
aligned feature recovery. The promotion decision uses the completed Pareto and
PPA tables.
