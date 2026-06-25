# DeepGate Transition Bridge Commands

Run from `/workspace`.

## Header Smoke

The header smoke used Yosys with `clk2fflogic`, then converted latch lines into
state inputs and next-state outputs. The final corrected script also densely
renumbers variables and maps constants to a surrogate PI so DeepGate's parser
does not see invalid `-1` nodes.

## Completed Probe

```bash
/workspace/exp/diversity_check/encoder_envs/deepgate3_probe/bin/python \
  docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260625_deepgate_generated_bridge_probe/tools/run_deepgate_generated_bridge_probe.py \
  --live-root exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/live \
  --output-dir exp/useful_bd_push/deepgate_transition_bridge_probe_20260625_190300_UTC \
  --package-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260625_deepgate_transition_bridge_probe \
  --max-per-backend-problem 3 \
  --max-aig-vars 700 \
  --state-policy transition
```

This run completed and produced `60` embeddings across `5/8` screening
problems.
