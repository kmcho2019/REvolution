# T37 Replay Command

Run from `/workspace`:

```bash
uv run python scripts/analyze_t37_t36_slot_count_ablation.py \
  --candidates-csv exp/diversity_check/wp1_qwen_common_audit_20260621_075031_UTC/qwen_common_audit_candidates.csv \
  --graph-manifest-csv docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T07_deepgate_family_bd/tables/netlist_graph_manifest.csv \
  --hypergraph-features-csv docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T14_dehnn_hypergraph_bd/tables/hypergraph_features.csv \
  --package-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T37_t36_slot_count_ablation \
  --retention-fraction 0.5 \
  --random-seed 0 \
  --cell-bins 2
```

This is a replay diagnostic over already evaluated candidates. It does not call
vLLM and therefore does not require the local model endpoint preflight.
