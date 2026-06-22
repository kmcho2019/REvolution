# T39 Artifacts Manifest

Status: pre-registered; no runtime artifacts committed yet.

## Committed Method Artifacts

- `methodology.md`: method definition, leakage exclusions, and acceptance
  signals.
- `commands/live_screen_v0.md`: exact preflight, live run, validation, and
  packaging commands.
- `tables/live_screen_v0_subset.yaml`: frozen three-problem live screen.
- `tables/run_matrix.csv`: planned sparse-yield arm.
- `results_report.md`: pending-result report scaffold.

## Runtime Artifacts To Capture

- `exp/useful_bd_push/t39_sparse_yield_warmup_qd_<timestamp>/preflight/`
- `exp/useful_bd_push/t39_sparse_yield_warmup_qd_<timestamp>/sparse_warmup_elite_slot_qd/`

Runtime outputs stay under `exp/`, not `/aux`.

## Expected Package Artifacts

- `tables/t39_live_candidate_ppa_points.csv`
- `tables/t39_live_problem_summary.csv`
- `tables/t39_live_archive_summary.csv`
- `tables/t39_live_pareto_front_validation.json` and `.md`
- `figures/t39_live_raw_area_power_fronts.png`
- `figures/t39_live_improvement_fronts.png`
- `figures/t39_live_archive_counts.png`
- `visualizations/direct_ppa_pareto/index.html`
- `visualizations/direct_ppa_pareto/screenshot.png`
