# DeepGate Transition Bridge Commands

Run from `/workspace`.

## Header Smoke

The header smoke used Yosys with `clk2fflogic`, then converted latch lines into
state inputs and next-state outputs.

## Full Probe Attempts

```bash
/workspace/exp/diversity_check/encoder_envs/deepgate3_probe/bin/python \
  docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260625_deepgate_generated_bridge_probe/tools/run_deepgate_generated_bridge_probe.py \
  --live-root exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/live \
  --output-dir exp/useful_bd_push/deepgate_transition_bridge_probe_20260625_183300_UTC \
  --package-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260625_deepgate_transition_bridge_probe \
  --max-per-backend-problem 3 \
  --max-aig-vars 700 \
  --state-policy transition
```

The `700`-variable run was interrupted after the parser remained in
topological sorting. The same happened with `300` variables and then with
`200` variables plus one candidate per backend/problem.
