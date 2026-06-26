# Run DeepGate Pooled Descriptor Replay

```bash
uv run python \
  docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260626_deepgate_pooled_descriptor_replay/tools/run_deepgate_pooled_descriptor_replay.py \
  --transition-rows-csv docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260625_deepgate_transition_bridge_probe/tables/deepgate_bridge_rows.csv \
  --transition-embeddings-npy exp/useful_bd_push/deepgate_transition_bridge_probe_20260625_190300_UTC/deepgate_embeddings.npy \
  --cone-rows-csv docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260626_deepgate_cone_bridge_probe/tables/deepgate_cone_rows.csv \
  --cone-embeddings-npy exp/useful_bd_push/deepgate_cone_bridge_probe_20260626_UTC/deepgate_cone_embeddings.npy \
  --output-dir exp/useful_bd_push/deepgate_pooled_descriptor_replay_20260626_UTC \
  --package-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260626_deepgate_pooled_descriptor_replay
```
