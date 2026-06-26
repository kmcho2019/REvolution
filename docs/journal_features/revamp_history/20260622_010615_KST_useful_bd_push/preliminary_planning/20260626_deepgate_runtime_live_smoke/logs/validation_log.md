# T93 Validation Log

## Storage

`df -h /workspace` reported a `27T` mounted workspace with `2.7T` available
and `90%` use before the T93 live-smoke attempts.

## vLLM

Every live command performed preflight against:

```text
http://20.0.0.103:8000/v1/models
```

The endpoint returned `openai/gpt-oss-120b` with `max_model_len=131072`, which
passes the `128000` token requirement.

## Runtime Descriptor Gate

The T93 pass condition is narrow:

1. the run uses `deepgate_pooled_pc3`;
2. at least one generated candidate has valid PPA;
3. the archive initializes;
4. `archive_cells.csv` stores finite `deepgate_pool_pc0..2` values.

Attempt 4 satisfies this condition on `Prob045_alu`.

## Validation Commands

The code path was already validated by the T92 implementation commit:

```bash
uv run pytest tests/revolution/test_deepgate_descriptor_evaluator.py
uv run ruff check \
  src/revolution/deepgate_descriptor_evaluator.py \
  src/revolution/qd/descriptors.py \
  src/revolution/qd/engine.py \
  src/revolution/runtime/candidate_evaluator.py \
  scripts/extract_deepgate_pooled_metrics.py \
  docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260626_deepgate_runtime_descriptor_gate/tools/build_deepgate_pooled_projection.py \
  tests/revolution/test_deepgate_descriptor_evaluator.py
uv run python -m pyright \
  src/revolution/deepgate_descriptor_evaluator.py \
  src/revolution/qd/descriptors.py \
  src/revolution/qd/engine.py \
  src/revolution/runtime/candidate_evaluator.py \
  scripts/extract_deepgate_pooled_metrics.py \
  docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260626_deepgate_runtime_descriptor_gate/tools/build_deepgate_pooled_projection.py \
  tests/revolution/test_deepgate_descriptor_evaluator.py
PYTHONPATH=/workspace/exp/diversity_check/encoder_envs/deepgate3_probe/lib/python3.8/site-packages \
  uv tool run ty check \
  src/revolution/deepgate_descriptor_evaluator.py \
  scripts/extract_deepgate_pooled_metrics.py \
  tests/revolution/test_deepgate_descriptor_evaluator.py
git diff --check
```

T93 adds no source code. It records live-smoke behavior only.
