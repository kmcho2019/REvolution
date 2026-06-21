# Simple Yosys Stat BD Results Report

Status: scaffold only. No experimental tier is assigned yet.

## Required Tables

- `tables/validity_funnel.csv`: generated, syntax-valid, functional,
  synthesis-valid, valid-PPA, and Pareto-front counts.
- `tables/ppa_comparison.csv`: best fitness, hypervolume, valid-PPA count,
  Pareto size, and per-problem deltas against classic and landing Smooth-QD.
- `tables/archive_metrics.csv`: occupied cells, entropy, QD score, unique
  canonical netlists, duplicate rate, and motif-signature count.
- `tables/runtime.csv`: Yosys extraction, descriptor assignment, archive
  update, and reporting time.

## Required Figures

- `figures/stat_feature_projection.png`
- `figures/archive_coverage_heatmap.png`
- `figures/ppa_delta_vs_classic.png`
- `figures/validity_funnel.png`

## Conclusion

Pending. Assign one of `T0 diagnostic`, `T1 near_classic`, `T2 useful_bd`, or
`T3 strong_win` only after the required tables and figures are generated.
