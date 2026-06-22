# T39 Artifacts Manifest

Status: bounded live arm completed and packaged.

## Committed Method Artifacts

- `methodology.md`: method definition, leakage exclusions, and acceptance
  signals.
- `commands/live_screen_v0.md`: exact preflight, live run, validation, and
  packaging commands.
- `tables/live_screen_v0_subset.yaml`: frozen three-problem live screen.
- `tables/run_matrix.csv`: planned sparse-yield arm.
- `results_report.md`: bounded-arm result and tier decision.
- `tables/preflight_models_20260622_062937_UTC.json`: successful local vLLM
  preflight for `openai/gpt-oss-120b`.
- `tables/t39_live_candidate_ppa_points.csv`: full bounded-arm candidate
  PPA/front/archive table.
- `tables/t39_live_problem_summary.csv`: per-problem bounded-arm summary.
- `tables/t39_live_archive_summary.csv`: active archive and global-front
  counts.
- `tables/t39_live_pareto_front_validation.json` and `.md`: validator output.
- `figures/t39_live_raw_area_power_fronts.png`: primary direct PPA-front
  figure.
- `figures/t39_live_improvement_fronts.png`: normalized improvement companion.
- `figures/t39_live_archive_counts.png`: count summary.
- `visualizations/direct_ppa_pareto/index.html`: filesystem-openable direct
  PPA viewer.
- `visualizations/direct_ppa_pareto/screenshot.png`: Playwright-rendered
  viewer screenshot.

## Runtime Artifacts To Capture

- `exp/useful_bd_push/t39_sparse_yield_warmup_qd_<timestamp>/preflight/`
- `exp/useful_bd_push/t39_sparse_yield_warmup_qd_<timestamp>/sparse_warmup_elite_slot_qd/`

Runtime outputs stay under `exp/`, not `/aux`.

## Full Bounded Arm

- Root:
  `exp/useful_bd_push/t39_sparse_yield_warmup_qd_20260622_062937_UTC/`
- Mode:
  `sparse_warmup_elite_slot_qd/seed_1001/openai_gpt-oss-120b/`
- Scope:
  `RTLLM/Prob045_alu`, `RTLLM/Prob041_traffic_light`, and
  `RTLLM/Prob015_multi_pipe_8bit`; population `12`, generations `3`.
- Result:
  validator passed, all three problems have active archive members, and the
  T38 multi-pipe empty-archive failure is fixed.
