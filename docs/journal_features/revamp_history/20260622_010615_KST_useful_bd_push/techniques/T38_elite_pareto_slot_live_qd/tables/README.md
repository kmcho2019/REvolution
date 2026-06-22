# T38 Tables

- `live_screen_v0_subset.yaml`: frozen three-problem live screen.
- `run_matrix.csv`: planned comparator/control/T38 command matrix.
- `preflight_models_20260622_054857_UTC.json`: live `/v1/models` capture
  showing `openai/gpt-oss-120b` with `max_model_len` 131072.
- `smoke_summary.json`: one-problem CLI/runtime smoke summary. It is not PPA
  evidence because no candidate reached functional/synthesis PPA.
- `smoke_pareto_front_validation.json` and `.md`: validator output for the
  smoke archive contract; valid with `max_front_size_seen=0`.
- `t38_live_candidate_ppa_points.csv`: valid-PPA candidate table with raw PPA,
  normalized improvements, local/global front flags, and archive-member flags.
- `t38_live_problem_summary.csv`: per-problem live-arm summary.
- `t38_live_archive_summary.csv`: active archive and global-front counts.
- `t38_live_pareto_front_validation.json` and `.md`: validator output for the
  full bounded arm; valid with `max_front_size_seen=2`.

Comparator-arm tables are still pending. Hypervolume/HV-AUC and
family/netlist breadth need the classic/full-Pareto controls before any
positive claim.
