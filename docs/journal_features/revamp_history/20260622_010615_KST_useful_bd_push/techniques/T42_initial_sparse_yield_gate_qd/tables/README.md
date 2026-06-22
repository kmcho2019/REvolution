# T42 Tables

Status: complete live screen.

Committed setup tables:

- `live_screen_v0_subset.yaml`: frozen three-problem screen.
- `run_matrix.csv`: planned arms and frozen comparators.

Committed result tables:

- `live_runtime_summary.csv`
- `preflight_models_20260622_093940_UTC.json`
- `initial_sparse_yield_gate_qd_validation.json`
- `initial_sparse_yield_gate_qd_validation.md`
- `t42_candidate_ppa_points.csv`: candidate-level raw PPA data, including
  raw area-power front flags and active-objective front flags.
- `t42_problem_method_summary.csv`: per-problem valid-PPA, raw-front,
  pooled-front, best-score, min-area, and min-power summary.
- `t42_method_manifest.csv`: source run roots and labels for each comparator.

Regenerate derived tables with `scripts/package_t42_initial_sparse_yield_gate.py`.
