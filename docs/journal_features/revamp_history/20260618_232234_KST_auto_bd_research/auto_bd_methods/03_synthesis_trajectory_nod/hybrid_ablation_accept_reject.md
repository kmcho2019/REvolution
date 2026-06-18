# ST-NOD Motif-Trajectory Hybrid Accept / Reject

Decision: DO NOT PROMOTE TO SEED-3 SCREENING.

## Rationale

The hybrid `stnod_motif_trajectory_9d` arm passes seed-1 Gate 0 and gives
better common-audit diversity than motif-only or trajectory-only ST-NOD.
It covers all six classic-covered development problems, occupies 16
common-audit cells, and produces 77 unique canonical netlists.

It does not show enough performance evidence to justify the added
descriptor dimensionality. Against the trajectory-only ST-NOD arm, it has
fewer valid-PPA candidates, lower mean best fitness, and slightly lower
mean hypervolume at seed-1. Because the research plan selects the
simplest method that preserves coverage and gives defensible uplift, this
ablation should not displace the already promoted trajectory-only ST-NOD
candidate.

## Next Use

Keep the hybrid result as evidence for the P4 motif-only versus
trajectory-motif comparison. Revisit only if seed-3 trajectory-only ST-NOD
fails on diversity while preserving repair/PPA coverage, or if a future
learned/codebook method needs a richer fixed-vector input basis.
