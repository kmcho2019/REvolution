# Run Front-Memory Replay

```bash
P=docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning

uv run python "$P/20260626_front_memory_replay_gate/tools/front_memory_replay.py" \
  --ppa-candidates "$P/20260626_rf_deepgate_hybrid_delayed_probe/analysis/ppa_distribution/data/ppa_candidates.csv" \
  --top-k 8 \
  --output-dir "$P/20260626_front_memory_replay_gate"
```
