# T44 Tables

- `run_matrix.csv`: planned matched full-screen arms and frozen references.
- `live_screen_v0_subset.yaml`: fixed three-problem RTLLM screen.
- `smoke_summary.json`: bounded one-problem smoke outcome.
- `preflight_models_20260622_113144_UTC.json`: `/v1/models` response before
  the smoke.
- `preflight_models_20260622_114838_UTC.json`: `/v1/models` response before
  the full live screen.
- `t44_pareto_front_validation.{json,md}`: strict archive validation for the
  matched classic and T44 QD arms.
- `t44_candidate_ppa_points.csv`: candidate-level raw area-power PPA rows used
  by the direct figures and HTML supplement.
- `t44_problem_method_summary.csv`: per-problem valid-PPA, front-count, and
  best-score summary.
- `t44_method_manifest.csv`: source run roots for the compared methods.

The full Phase 03.1 viewer source data lives under
`../visualizations/qd_ppa_viewer_source/final_analysis/`. The required raw
viewer inputs are
`ppa_distribution/data/ppa_candidates.csv`,
`ppa_distribution/data/reference_ppa_metrics.csv`, and
`design_space_analysis/successful_candidates.csv`.
