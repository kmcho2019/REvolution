# T91 DeepGate Pooled Descriptor Replay Preregistration

## Question

Can full-transition and cone-level DeepGate embeddings be pooled into a
candidate-level descriptor table that covers all eight preliminary screen
problems and preserves nontrivial PPA-front cell structure?

## Inputs

- Full-transition bridge rows and embeddings from
  `20260625_deepgate_transition_bridge_probe`.
- Cone bridge rows and embeddings from
  `20260626_deepgate_cone_bridge_probe`.
- Candidate PPA files beside each `code.sv`.

## Method

For each generated candidate:

1. use the full-transition embedding when the full AIG embedded;
2. otherwise use the normalized mean of that candidate's cone embeddings;
3. compute three global PCA coordinates;
4. assign problem-local quartile cells over the three coordinates;
5. mark direct area-power Pareto candidates inside each problem.

This is not a live QD run and does not use reference-normalized HV. It is a
descriptor-table replay gate.

## Gate

DeepGate can advance to a bounded live smoke only if:

- all eight screen problems have candidate-level descriptors;
- both full-transition and cone-pooled candidates are represented;
- each problem has more than one occupied cell;
- area-power Pareto candidates occupy nonzero descriptor cells in every
  problem.
