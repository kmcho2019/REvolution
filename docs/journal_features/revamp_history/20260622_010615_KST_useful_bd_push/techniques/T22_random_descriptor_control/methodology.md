# Random Descriptor Control Methodology

## Intent

Package the required negative control for the useful-BD push. This method tests
whether a QD archive can look competitive just because candidates are partitioned
into different cells, even when the descriptor has no hardware semantics.

T22 is a control package, not a candidate for promotion.

## Inputs

- Candidate RTL and the normal synthesis/PPA evaluation flow.
- Canonical synthesized-netlist hash for each archiveable candidate.
- Fixed run metadata for joining candidates to the central report.

The descriptor excludes PPA, reference PPA, fitness, hypervolume, Pareto rank,
test pass rate, problem ID, and all semantic structural features.

## Descriptor Algorithm

For each archiveable candidate:

```text
netlist_hash = canonical_netlist_hash(synthesized_netlist_text)
random_hash_i = sha256(seed, i, netlist_hash)[0:64 bits] / 2^64
bd = [random_hash_0, random_hash_1, random_hash_2]
```

The descriptor is deterministic for a fixed canonical synthesized netlist hash,
but the axes are intentionally meaningless.

## Archive Integration

- method family: `random_descriptor`;
- profile: `random_hash_3d`;
- descriptor seed: `20260618_auto_bd_random_descriptor`;
- archive type: `grid_quantile`;
- descriptor dimensions: 3;
- bin range: `[0, 1]` on each axis;
- cell mode: Pareto front;
- max elites per cell: 5;
- parent selection: `nsga2_global_rank`;
- champion-lane fraction: 0.5.

## Current Replay Scope

This package re-scores the seed-1001 `random_descriptor_qd` standard-result
artifacts with the current useful-BD reporting policy. It uses the same
six-problem development subset, model, seed, prompts, budget, and passive audit
surface as the other central replay packages.

## Acceptance Interpretation

Random hash can never be a promoted BD because it is not interpretable and does
not describe RTL/netlist behavior. It is accepted only as a baseline control.

Any proposed useful-BD claim should beat this control on the relevant common
surface. If a semantic descriptor cannot beat random hash on QD/PPA evidence,
the descriptor's claim must be narrowed or rejected.

## Expected Follow-Up

Keep T22 in the central comparison and any future live validation matrix. Do
not spend follow-up effort improving random hash itself; instead use it to
calibrate how much apparent diversity can arise from archive partitioning.
