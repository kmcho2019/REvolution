# Run DeepGate Signal Vs AIG Stats Gate

```bash
uv run python \
  docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260626_deepgate_signal_vs_aig_stats_gate/tools/analyze_deepgate_signal_vs_aig_stats.py \
  --rows-csv docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260625_deepgate_transition_bridge_probe/tables/deepgate_bridge_rows.csv \
  --embeddings-npy exp/useful_bd_push/deepgate_transition_bridge_probe_20260625_190300_UTC/deepgate_embeddings.npy \
  --output-dir exp/useful_bd_push/deepgate_signal_vs_aig_stats_gate_20260626_UTC \
  --package-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260626_deepgate_signal_vs_aig_stats_gate
```
