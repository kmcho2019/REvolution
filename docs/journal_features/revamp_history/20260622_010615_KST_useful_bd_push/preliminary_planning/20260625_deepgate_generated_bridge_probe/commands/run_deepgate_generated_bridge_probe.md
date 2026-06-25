# DeepGate Generated Bridge Command

Run from `/workspace`.

```bash
/workspace/exp/diversity_check/encoder_envs/deepgate3_probe/bin/python \
  docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260625_deepgate_generated_bridge_probe/tools/run_deepgate_generated_bridge_probe.py \
  --live-root exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/live \
  --output-dir exp/useful_bd_push/deepgate_generated_bridge_probe_20260625_182350_UTC \
  --package-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260625_deepgate_generated_bridge_probe \
  --max-per-backend-problem 3 \
  --max-aig-vars 400
```

The script copies compact CSV, JSON, and PNG artifacts into this package. Full
AIG files and the embedding matrix remain under:

`exp/useful_bd_push/deepgate_generated_bridge_probe_20260625_182350_UTC`.
