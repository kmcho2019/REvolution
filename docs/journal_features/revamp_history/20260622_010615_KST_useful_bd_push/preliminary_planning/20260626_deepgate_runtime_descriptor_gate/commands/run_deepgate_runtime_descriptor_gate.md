# Run DeepGate Runtime Descriptor Gate

Run from `/workspace`.

```bash
uv run python \
  docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260626_deepgate_runtime_descriptor_gate/tools/build_deepgate_pooled_projection.py \
  --transition-rows-csv docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260625_deepgate_transition_bridge_probe/tables/deepgate_bridge_rows.csv \
  --transition-embeddings-npy exp/useful_bd_push/deepgate_transition_bridge_probe_20260625_190300_UTC/deepgate_embeddings.npy \
  --cone-rows-csv docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260626_deepgate_cone_bridge_probe/tables/deepgate_cone_rows.csv \
  --cone-embeddings-npy exp/useful_bd_push/deepgate_cone_bridge_probe_20260626_UTC/deepgate_cone_embeddings.npy \
  --output-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260626_deepgate_runtime_descriptor_gate/tables
```

Unit validation:

```bash
uv run pytest tests/revolution/test_deepgate_descriptor_evaluator.py
uv run ruff check src/revolution/deepgate_descriptor_evaluator.py \
  src/revolution/qd/descriptors.py \
  src/revolution/qd/engine.py \
  src/revolution/runtime/candidate_evaluator.py \
  scripts/extract_deepgate_pooled_metrics.py \
  docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260626_deepgate_runtime_descriptor_gate/tools/build_deepgate_pooled_projection.py \
  tests/revolution/test_deepgate_descriptor_evaluator.py
uv run python -m pyright src/revolution/deepgate_descriptor_evaluator.py \
  scripts/extract_deepgate_pooled_metrics.py \
  docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260626_deepgate_runtime_descriptor_gate/tools/build_deepgate_pooled_projection.py \
  tests/revolution/test_deepgate_descriptor_evaluator.py
uv tool run ty check src/revolution/deepgate_descriptor_evaluator.py \
  scripts/extract_deepgate_pooled_metrics.py \
  tests/revolution/test_deepgate_descriptor_evaluator.py
```
