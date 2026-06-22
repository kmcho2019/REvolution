# T41 Tables

Status: complete live screen.

Committed tables:

- `live_screen_v0_subset.yaml`: frozen three-problem screen.
- `run_matrix.csv`: planned arms and frozen comparators.
- `live_runtime_summary.csv`: matched arm runtimes.
- `preflight_models_20260622_083629_UTC.json`: vLLM model preflight.
- `adaptive_sparse_yield_gate_qd_validation.{json,md}`: Pareto archive
  validator output.
- `t41_candidate_ppa_points.csv`: candidate-level raw PPA/front rows.
- `t41_problem_method_summary.csv`: per-problem method summary.
- `t41_method_manifest.csv`: source run roots for T41, T40, and T39 arms.

Regenerate derived tables with
`scripts/package_t41_adaptive_sparse_yield_gate.py`.
