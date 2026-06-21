# ST-NOD Motif Hybrid BD Methodology

## Intent

Package the ST-NOD plus final-netlist motif hybrid ablation from the 20260618
Auto-BD sweep. The method asks whether concatenating trajectory features with
final motif occupancy gives a more useful behavior descriptor than either
motif-only occupancy or trajectory-only ST-NOD.

This is `T21` because the hybrid was already run but was not represented in the
current useful-BD package index.

## Inputs

- Candidate RTL from the normal generation path.
- Final synthesized netlist motif occupancy.
- Yosys stage-dump snapshots from the ST-NOD sidecar flow.
- Fixed benchmark/run metadata for reporting.

The descriptor excludes PPA, reference PPA, fitness, hypervolume, Pareto rank,
and test pass percentage. It also does not fit any learned transformation over
the evaluation results.

## Descriptor Algorithm

For each candidate:

```text
motif = final_netlist_motif_ratios(candidate)
trajectory = stnod_stage_swing_features(candidate)
bd = concat(motif_logic_ratio,
            motif_control_ratio,
            motif_arith_ratio,
            motif_diversity,
            stnod_cell_growth_log,
            stnod_logic_swing,
            stnod_control_swing,
            stnod_arith_swing,
            stnod_diversity_swing)
```

The emitted descriptor is `stnod_motif_trajectory_9d`. The first four axes come
from final synthesized-netlist motif ratios; the final five axes come from the
ST-NOD stage trajectory.

## Archive Integration

- archive type: `grid_quantile`;
- descriptor profile: `stnod_motif_trajectory_9d`;
- fitting protocol: none;
- cell mode: Pareto front;
- objectives: PPA after evaluation;
- parent selection: `nsga2_global_rank`;
- champion-lane fraction: 0.5.

The historical method card records this as an ablation against
`netlist_motif_occupancy` and `synthesis_trajectory_nod`, not as a new final
method.

## Current Replay Scope

This package re-scores the seed-1001
`synthesis_trajectory_motif_nod` standard-result artifacts with the current
useful-BD reporting policy. The comparison uses the same six-problem
development subset, model, seed, prompts, budget, and passive audit surface as
the other central replay packages.

## Acceptance Interpretation

The hybrid should be kept if it proves that richer deterministic descriptors
recover archive/front diversity that simpler descriptors miss. It should not be
promoted unless it also preserves quality and passive-QD score.

In the current replay, the hybrid increases archive coverage and PPA-front
unique netlists substantially, but loses too much best fitness and
common-audit QD score. That makes it a useful `T0 diagnostic`, not a promoted
method.

## Expected Follow-Up

Do not keep increasing deterministic descriptor dimensionality by concatenation
alone. Future deterministic variants should use one of:

- feature selection or CVT over the ST-NOD plus motif vector;
- local-Pareto cell retention so the added cells keep higher-quality points;
- pathlet or reconvergence features only if they improve passive-QD score;
- an SR-ReLU or SR-RFF hybrid that can keep the early-HV behavior of the
  synthesis-response lane.
