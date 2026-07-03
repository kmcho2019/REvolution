# T80 Structural-Mix Gate Command

Run from `/workspace`:

```bash
uv run python \
  docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T80_masterrtl_structural_mix_gate/tools/run_t80_masterrtl_structural_mix_gate.py
```

Focused checks:

```bash
uv run pytest tests/revolution/test_source_aligned_descriptor_evaluator.py

uv run ruff check \
  src/revolution/source_aligned_descriptor_evaluator.py \
  src/revolution/qd/descriptors.py \
  tests/revolution/test_source_aligned_descriptor_evaluator.py \
  docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T80_masterrtl_structural_mix_gate/tools/run_t80_masterrtl_structural_mix_gate.py
```
