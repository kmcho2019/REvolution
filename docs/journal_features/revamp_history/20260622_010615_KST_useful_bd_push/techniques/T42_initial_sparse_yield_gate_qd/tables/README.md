# T42 Tables

Status: pre-registered live screen.

Committed setup tables:

- `live_screen_v0_subset.yaml`: frozen three-problem screen.
- `run_matrix.csv`: planned arms and frozen comparators.

Expected generated tables after live execution:

- `live_runtime_summary.csv`
- `preflight_models_<RUN_TS>.json`
- `initial_sparse_yield_gate_qd_validation.{json,md}`
- `t42_candidate_ppa_points.csv`
- `t42_problem_method_summary.csv`
- `t42_method_manifest.csv`

Regenerate derived tables with `scripts/package_t42_initial_sparse_yield_gate.py`.
