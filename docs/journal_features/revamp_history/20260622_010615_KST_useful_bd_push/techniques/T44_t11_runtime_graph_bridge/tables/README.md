# T44 Tables

- `run_matrix.csv`: planned matched full-screen arms and frozen references.
- `live_screen_v0_subset.yaml`: fixed three-problem RTLLM screen.
- `smoke_summary.json`: bounded one-problem smoke outcome.
- `preflight_models_20260622_113144_UTC.json`: `/v1/models` response from
  the live GPT-OSS endpoint before the smoke.

Full-run result tables are pending.
After the full screen, `scripts/package_t44_t11_runtime_graph_bridge.py` must
add `t44_candidate_ppa_points.csv`, `t44_problem_method_summary.csv`, and
`t44_method_manifest.csv` so the direct PPA figures and HTML supplement can be
regenerated.
