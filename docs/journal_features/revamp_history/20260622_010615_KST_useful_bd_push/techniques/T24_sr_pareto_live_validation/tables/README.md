# T24 Tables

- `preflight_models_20260621_184346_UTC.json`: committed copy of the live
  `/v1/models` preflight for `http://20.0.0.103:8000/v1`.
- `run_matrix.csv`: fixed development-screen arms, problems, seeds, descriptor
  profiles, and command references.
- `live_screen_v0_subset.yaml`: subset config consumed by
  `scripts/validate_pareto_front_run.py` after live execution.
- `live_sr_rff_vs_classic.csv`: completed classic-vs-SR-RFF live comparison
  for the first T24 arm pair.
- `live_sr_rff_pareto_validation.json`: validator payload for the SR-RFF
  Pareto archive.
- `live_sr_rff_pareto_validation.md`: human-readable validator summary.

Still needed after the remaining live arms run: central comparison CSVs for
validity funnel, global PPA hypervolume, HV AUC, archive QD score/coverage,
global Pareto points, unique front families, duplicate accounting, and
per-problem deltas.
