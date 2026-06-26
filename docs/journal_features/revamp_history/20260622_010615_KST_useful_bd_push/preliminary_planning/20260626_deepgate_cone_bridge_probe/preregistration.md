# T90 DeepGate Cone Bridge Preregistration

## Question

Can bounded output-cone extraction extend the official DeepGate transition
bridge to the large skipped designs without changing the pretrained model?

## Inputs

- Transition bridge rows:
  `docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260625_deepgate_transition_bridge_probe/tables/deepgate_bridge_rows.csv`
- Transition AIG files referenced by that CSV.
- Official `python-deepgate` environment:
  `exp/diversity_check/encoder_envs/deepgate3_probe`.

## Method

For every `skipped_too_large` transition AIG, extract the smallest nontrivial
single-output cones whose transitive fan-in has at most `700` AND gates. Each
cone is remapped to a dense latch-free AAG and embedded with the same official
DeepGate pretrained model used by the transition bridge.

The first run uses:

- `max_cone_ands=700`;
- `max_cones_per_row=3`;
- no live LLM calls;
- no QD runtime hook changes.

## Gate

The cone bridge is useful only if it embeds at least one cone for each of the
three previously skipped screen problems:

- `Prob015_multi_pipe_8bit`;
- `Prob045_alu`;
- `Prob153_gshare`.

Passing this gate authorizes only a cached descriptor-table prototype or a
bounded covered-subset live smoke. It does not authorize a full RTLLM DeepGate
arm by itself.
