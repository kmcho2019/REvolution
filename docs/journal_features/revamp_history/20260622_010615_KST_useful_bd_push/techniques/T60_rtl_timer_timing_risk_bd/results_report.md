# T60 RTLTimer Timing-Risk BD Results Report

Status: scaffold only. No experimental tier is assigned yet.

## Required Tables

- `tables/ppa_completeness.csv`
- `tables/validity_funnel.csv`
- `tables/rtl_timer_features.csv`
- `tables/timing_risk_archive_metrics.csv`
- `tables/problem_metrics.csv`
- `tables/comparison_deltas.csv`

## Required Figures

- `figures/timing_risk_projection.png`
- `figures/timing_risk_archive_coverage.png`
- `figures/raw_area_power_fronts.png`
- `figures/metric_delta_summary.png`

## Required Interpretation

The report must answer:

- whether RTL timing-risk descriptors preserve more useful front material than
  SR-PCA, T11 graph, or lexical controls;
- whether any gain survives the reference-complete paired subset;
- whether the descriptor is genuinely RTL-native diversity or just a proxy for
  problem identity, final PPA, or invalid-candidate rate;
- whether the next step should be MasterRTL/SOG fusion, RTLTimer-only
  validation, or retirement.
