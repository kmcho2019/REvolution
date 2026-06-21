# Adaptive Emitter CVT BD Methodology

## Intent

Keep the current promising CVT archive mechanics but improve sampling with
separate explore, exploit, and repair emitters. This method tests whether QD's
benefit comes from descriptor geometry, parent selection, or both.

## Inputs

- Candidate RTL and fixed benchmark metadata.
- A frozen CVT descriptor, preferably ST-NOD+motif, SOG+Yosys, or the best
  replay candidate from this push.
- Candidate status history available at decision time.

Descriptor inputs exclude final PPA, reference PPA, fitness, hypervolume,
Pareto rank, and test pass labels. Emitter scheduling may use archive status
and validity funnel history available during search, but must be logged.

## Emitters

Use a fixed mixture:

- exploit emitter: samples high-quality occupied cells, approximating classic
  pressure;
- explore emitter: samples sparse or low-occupancy CVT regions;
- repair emitter: samples parents/operators associated with parse/synthesis
  recovery, without using final PPA as a descriptor.

The mixture weights are registered before a run. A minimal first setting is
`50 percent exploit`, `30 percent explore`, `20 percent repair`.

## Archive Mapping

Use the same CVT centroids and descriptor dimensions as the non-adaptive
baseline. Report passive archive metrics for all methods.

## Ablations

Run:

- CVT baseline without adaptive emitters;
- exploit-only emitter;
- explore-only emitter;
- full mixture;
- full mixture with repair disabled if validity leakage is suspected.

## Expected Outputs

- `tables/emitter_schedule.csv`
- `tables/emitter_yield.csv`
- `tables/ablation_metrics.csv`
- `figures/emitter_contribution.png`
- `figures/coverage_hv_auc.png`
