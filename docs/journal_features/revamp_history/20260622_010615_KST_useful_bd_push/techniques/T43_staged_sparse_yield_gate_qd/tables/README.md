# T43 Tables

Status: pre-registered live screen.

Committed setup tables:

- `live_screen_v0_subset.yaml`: frozen three-problem screen.
- `run_matrix.csv`: planned arms and frozen comparators.

Expected generated tables after live execution:

- `live_runtime_summary.csv`
- `preflight_models_<RUN_TS>.json`
- `staged_sparse_yield_gate_qd_validation.{json,md}`
- `t43_candidate_ppa_points.csv`
- `t43_problem_method_summary.csv`
- `t43_method_manifest.csv`

Regenerate derived tables with `scripts/package_t43_staged_sparse_yield_gate.py`.
