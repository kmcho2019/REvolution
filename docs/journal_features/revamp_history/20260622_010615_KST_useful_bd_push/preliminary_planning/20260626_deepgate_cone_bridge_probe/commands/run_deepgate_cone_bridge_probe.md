# Run DeepGate Cone Bridge Probe

```bash
/workspace/exp/diversity_check/encoder_envs/deepgate3_probe/bin/python \
  docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260626_deepgate_cone_bridge_probe/tools/run_deepgate_cone_bridge_probe.py \
  --rows-csv docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260625_deepgate_transition_bridge_probe/tables/deepgate_bridge_rows.csv \
  --output-dir exp/useful_bd_push/deepgate_cone_bridge_probe_20260626_UTC \
  --package-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260626_deepgate_cone_bridge_probe \
  --max-cone-ands 700 \
  --max-cones-per-row 3
```
