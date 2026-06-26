# T92 Validation Log

## Projection Artifact

```bash
uv run python \
  docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260626_deepgate_runtime_descriptor_gate/tools/build_deepgate_pooled_projection.py \
  --transition-rows-csv docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260625_deepgate_transition_bridge_probe/tables/deepgate_bridge_rows.csv \
  --transition-embeddings-npy exp/useful_bd_push/deepgate_transition_bridge_probe_20260625_190300_UTC/deepgate_embeddings.npy \
  --cone-rows-csv docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260626_deepgate_cone_bridge_probe/tables/deepgate_cone_rows.csv \
  --cone-embeddings-npy exp/useful_bd_push/deepgate_cone_bridge_probe_20260626_UTC/deepgate_cone_embeddings.npy \
  --output-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260626_deepgate_runtime_descriptor_gate/tables
```

Result:

```text
artifact_kind=deepgate_pooled_projection_v0
candidate_count=96
embedding_dim=256
axes=deepgate_pool_pc0,deepgate_pool_pc1,deepgate_pool_pc2
```

## Isolated DeepGate Smoke

```bash
/workspace/exp/diversity_check/encoder_envs/deepgate3_probe/bin/python \
  scripts/extract_deepgate_pooled_metrics.py \
  --code exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/live/classic_revolution_8x5/seed_1001/openai_gpt-oss-120b/RTLLM/Prob024_fsm/Gen1/Prob024_fsm_sample1_M-S/code.sv \
  --top fsm \
  --projection-artifact docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260626_deepgate_runtime_descriptor_gate/tables/deepgate_pooled_projection.json \
  --output-json /tmp/deepgate_runtime_smoke_metrics.json \
  --work-dir /tmp/deepgate_runtime_smoke \
  --max-aig-vars 700 \
  --max-cone-ands 700 \
  --max-cones 3
```

Result:

```json
{
  "deepgate_pool_pc0": 0.1690518098127865,
  "deepgate_pool_pc1": 0.09191954180278154,
  "deepgate_pool_pc2": -0.00008487391307619545,
  "deepgate_pool_aig_variables": 61.0,
  "deepgate_pool_aig_ands": 50.0,
  "deepgate_pool_source_full_transition": 1.0
}
```

## Local Validation

```bash
uv run pytest tests/revolution/test_deepgate_descriptor_evaluator.py
```

Result: `6 passed`.

```bash
uv run ruff check src/revolution/deepgate_descriptor_evaluator.py \
  src/revolution/qd/descriptors.py \
  src/revolution/qd/engine.py \
  src/revolution/runtime/candidate_evaluator.py \
  scripts/extract_deepgate_pooled_metrics.py \
  docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260626_deepgate_runtime_descriptor_gate/tools/build_deepgate_pooled_projection.py \
  tests/revolution/test_deepgate_descriptor_evaluator.py
```

Result: passed.

```bash
uv run python -m pyright src/revolution/deepgate_descriptor_evaluator.py \
  scripts/extract_deepgate_pooled_metrics.py \
  docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260626_deepgate_runtime_descriptor_gate/tools/build_deepgate_pooled_projection.py \
  tests/revolution/test_deepgate_descriptor_evaluator.py
```

Result: `0 errors`.

```bash
PYTHONPATH=/workspace/exp/diversity_check/encoder_envs/deepgate3_probe/lib/python3.8/site-packages \
  uv tool run ty check src/revolution/deepgate_descriptor_evaluator.py \
  scripts/extract_deepgate_pooled_metrics.py \
  tests/revolution/test_deepgate_descriptor_evaluator.py
```

Result: passed.

```bash
git diff --check
```

Result: passed.

## Storage Check

```bash
df -h /workspace
```

Result: `/workspace` is `90%` used with about `2.7T` available.
