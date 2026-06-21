# Lineage Repair BD Methodology

## Intent

Represent candidates by how they arise and how edits repair or alter structure.
This tests whether QD should explore productive lineage regions rather than
only static netlist coordinates.

## Inputs

- Candidate lineage metadata: parent id, operator id, mutation prompt, edit
  summary, generation index, and retry count.
- Structural before/after features from parent and child netlists.
- Non-PPA operational statuses such as parse and synthesis extraction status
  for funnel accounting.

In-loop BD inputs exclude final PPA, reference PPA, fitness, hypervolume,
Pareto labels, and functional test pass labels. Validity statuses may be used
for reporting and gating, but not as a hidden reward.

## Preprocessing

1. Link each candidate to its parent and operator record.
2. Compute parent-child structural deltas using Yosys stat, motif/pathlet, and
   stage-delta schemas.
3. Canonicalize edit summaries into coarse classes: arithmetic change,
   control change, pipeline/state change, simplification, expansion, and
   repair.
4. Build per-lineage windows over the last `k` ancestors without using future
   evaluation labels.

## Descriptor

Compute a lineage vector with:

- parent-child structural distance;
- edit class one-hot counts over the last `k` steps;
- operator novelty relative to that benchmark's prior candidates;
- repair distance: how much the child restores synthesizable structure after a
  parse/synthesis failure in the lineage, reported separately from reward;
- descendant branching factor and age, computed only from already-generated
  candidates available at the decision time;
- static child descriptor summary from a non-PPA structural feature set.

Run an ablation without any validity-derived coordinates to check whether the
descriptor is merely sorting by survival.

## Archive Mapping

Use grid axes over structural delta magnitude and edit class entropy. Also test
CVT over the full lineage vector. Archive cells should reveal whether certain
operators or repair paths produce valid-PPA descendants without using final PPA
as a descriptor input.

## Parent Selection Coupling

This method may bias parent sampling toward underexplored lineage/edit cells.
Replacement still uses the configured quality objective. Report whether
lineage pressure preserves classic-covered problems.

## Expected Outputs

- `tables/lineage_features.csv`
- `tables/operator_yield_audit.csv`
- `tables/validity_ablation.csv`
- `figures/lineage_archive.png`
- `figures/operator_delta_vs_ppa.png`
