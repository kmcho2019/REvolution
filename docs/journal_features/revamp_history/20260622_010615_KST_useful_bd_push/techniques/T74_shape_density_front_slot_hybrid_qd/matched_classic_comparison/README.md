# T74 Matched Classic Comparison

This package contains the compact committed result for T74 on the 13-problem
hard/tuning subset, seed `1001`.

Decision: `T0 diagnostic_regression_not_promoted`.

T74 preserves reference-complete coverage, but classic remains the
multi-objective/Pareto winner and T74 regresses from T73 on mean HV and
valid-PPA yield.

## Contents

- `data/`: raw PPA candidates, reference PPA, and best-candidate table copied
  from `final_analysis/ppa_distribution/data/`.
- `tables/`: aggregate and per-problem metrics, completeness table, and
  final-analysis summaries.
- `figures/`: compact HV-delta, valid-PPA, and representative raw PPA-front
  figures.
- `visualizations/qd_ppa_viewer/`: full Phase 03.1 linked archive/PPA viewer.
- `tools/package_t74_matched_summary.py`: script used to regenerate the compact
  package from the run-root `final_analysis/`.

## Key Numbers

| Backend | Mean HV | Mean Pareto Points | HV Wins | Valid PPA |
| --- | ---: | ---: | ---: | ---: |
| classic | 0.0926007600 | 2.31 | 8 | 257 |
| T73 | 0.0890223082 | 1.46 | 0 | 294 |
| T74 | 0.0851926237 | 1.62 | 1 | 237 |

The result does not support promoting the T73/T74 shape-density plus low-rate
pair-gating lineage.
