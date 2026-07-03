# SR Raw PCA BD Methodology

## Intent

Provide the plain synthesis-response PCA ablation for the automatic-BD lane.
This method asks whether frozen PCA over PPA-free synthesis-response features
is enough to produce a useful MAP-Elites descriptor, before adding random ReLU
or random Fourier feature maps.

`T20` is not a new algorithm invented after the fact. It packages the
historical `sr_raw_pca_qd` central replay arm that was already run in the
20260618 Auto-BD sweep.

## Inputs

- Candidate RTL from the normal REvolution generation path.
- Yosys synthesis-response features: final stats, motif occupancy,
  ST-NOD trajectory swings, per-stage motif ratios, and per-stage cell-count
  deltas.
- Frozen fitting artifacts from the seed-1001 development corpus.
- Fixed problem/run metadata needed for reporting joins.

The descriptor excludes PPA, reference PPA, fitness, hypervolume, Pareto rank,
test pass percentage, and problem ID.

## Descriptor Algorithm

For each candidate:

```text
z = robust_scale(raw_synthesis_response_features)
bd = PCA_3(z)
```

The descriptor uses:

- raw feature schema: `synthesis_response_raw_v1`;
- descriptor version: `sr_raw_pca_v1`;
- training candidates: 205;
- descriptor axes: `sr_pca_0`, `sr_pca_1`, and `sr_pca_2`;
- archive type in the historical run: `grid_quantile`;
- cell mode: Pareto front;
- max elites per cell: 5.

The first three PCA axes explain 43.71%, 22.44%, and 18.34% of the fitted
training variance. Those axes are high-variance synthesis-response directions,
not learned PPA objectives.

## Role In The Lane

Raw PCA is the control between deterministic hand-designed descriptors and the
nonlinear automatic descriptors:

- if raw PCA works, later random maps may be unnecessary;
- if raw PCA preserves validity but loses quality, random maps or local Pareto
  archive coupling may be needed;
- if raw PCA collapses coverage, the whole synthesis-response PCA family would
  be suspect.

The current result lands in the middle case: raw PCA preserves valid-PPA count
and audit-cell occupancy, but it loses final quality and passive QD score.

## Current Replay Scope

The package re-scores `sr_raw_pca_qd` from the seed-1001 development run using
the same central useful-BD report as the other replay packages. It compares
classic REvolution, landing Smooth-QD/manual BD, and SR raw PCA on the same
six-problem subset, same model, same seed, and same candidate budget.

This is replay evidence only. It is valid for ablation and lane decisions; it
does not prove a live-run claim by itself.

## Acceptance Interpretation

SR raw PCA can be a useful supporting method if it shows that synthesis-response
features carry non-PPA diversity signal without harming validity. It should not
be promoted unless quality and common-audit QD score stay near classic or are
recovered by a pre-registered archive-coupling variant.

## Expected Follow-Up

Raw PCA should remain in the ablation set for SR-RFF and SR-ReLU follow-up
runs. The most useful next comparison is not another standalone raw-PCA run; it
is a local-Pareto archive test that asks whether raw PCA's extra front netlists
and motif signatures can be retained without the quality drop.
