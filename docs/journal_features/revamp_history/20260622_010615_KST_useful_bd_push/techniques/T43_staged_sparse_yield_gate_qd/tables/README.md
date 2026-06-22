# T43 Tables

Status: complete live screen.

Setup tables:

- `live_screen_v0_subset.yaml`: frozen three-problem screen.
- `run_matrix.csv`: planned arms and frozen comparators.

Generated tables:

- `live_runtime_summary.csv`
- `preflight_models_20260622_102415_UTC.json`
- `staged_sparse_yield_gate_qd_validation.{json,md}`
- `t43_candidate_ppa_points.csv`
- `t43_problem_method_summary.csv`
- `t43_method_manifest.csv`

Key rows in `t43_problem_method_summary.csv`:

- T43 staged gate: `0` pooled raw-front hits on ALU, traffic-light, and
  multi-pipe.
- T43 staged gate: `26` traffic-light valid PPA points versus `12` for the
  matched classic arm.
- T43 staged gate: multi-pipe best score `0.052795`, below T39 `0.222285` and
  T42 `0.116397`.

Regenerate derived tables with `scripts/package_t43_staged_sparse_yield_gate.py`.
