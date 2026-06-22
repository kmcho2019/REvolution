# T38 Tables

- `live_screen_v0_subset.yaml`: frozen three-problem live screen.
- `run_matrix.csv`: planned comparator/control/T38 command matrix.
- `preflight_models_20260622_054857_UTC.json`: live `/v1/models` capture
  showing `openai/gpt-oss-120b` with `max_model_len` 131072.
- `smoke_summary.json`: one-problem CLI/runtime smoke summary. It is not PPA
  evidence because no candidate reached functional/synthesis PPA.
- `smoke_pareto_front_validation.json` and `.md`: validator output for the
  smoke archive contract; valid with `max_front_size_seen=0`.

Raw live analysis tables are pending and should include candidate-level PPA
points, direct Pareto-front flags, archive metrics, validity/yield counts,
hypervolume/HV-AUC, and family/netlist breadth.
