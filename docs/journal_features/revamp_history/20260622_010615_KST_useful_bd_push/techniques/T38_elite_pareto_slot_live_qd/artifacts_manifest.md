# T38 Artifacts Manifest

Status: bounded live arm completed and packaged.

## Committed Method Artifacts

- `methodology.md`: pre-registered method definition and gates.
- `commands/live_screen_v0.md`: exact preflight, comparator, control, T38,
  and validation commands.
- `tables/live_screen_v0_subset.yaml`: frozen three-problem live screen.
- `tables/run_matrix.csv`: planned method matrix.
- `tables/preflight_models_20260622_054857_UTC.json`: successful local vLLM
  preflight for `openai/gpt-oss-120b`.
- `tables/smoke_summary.json`: bounded one-problem smoke summary.
- `tables/smoke_pareto_front_validation.json` and `.md`: smoke validator
  output.
- `tables/t38_live_candidate_ppa_points.csv`: full bounded-arm candidate
  PPA/front/archive table.
- `tables/t38_live_problem_summary.csv`: per-problem full bounded-arm summary.
- `tables/t38_live_archive_summary.csv`: active archive and global-front
  counts.
- `tables/t38_live_pareto_front_validation.json` and `.md`: full bounded-arm
  validator output.
- `figures/t38_live_raw_area_power_fronts.png`: primary direct PPA-front
  figure.
- `figures/t38_live_improvement_fronts.png`: normalized improvement companion.
- `figures/t38_live_archive_counts.png`: count summary.
- `visualizations/direct_ppa_pareto/index.html`: filesystem-openable direct
  PPA viewer.
- `visualizations/direct_ppa_pareto/screenshot.png`: Playwright-rendered
  viewer screenshot.

## Runtime Artifacts To Capture

- `exp/useful_bd_push/t38_elite_pareto_slot_live_qd_<timestamp>/preflight/`
- `exp/useful_bd_push/t38_elite_pareto_slot_live_qd_<timestamp>/classic_revolution/`
- `exp/useful_bd_push/t38_elite_pareto_slot_live_qd_<timestamp>/graph_pareto_front_qd/`
- `exp/useful_bd_push/t38_elite_pareto_slot_live_qd_<timestamp>/elite_pareto_slot_qd/`

Runtime outputs stay under `exp/`, not `/aux`.

## Smoke Run

- Root:
  `exp/useful_bd_push/t38_elite_pareto_slot_live_qd_20260622_054857_UTC/`
- Mode:
  `elite_pareto_slot_smoke/seed_1001/openai_gpt-oss-120b/`
- Scope:
  `RTLLM/Prob045_alu`, population `4`, generations `1`.
- Result:
  runtime and validator contract passed, but there were zero archive members
  and zero synthesis-PPA candidates. This is not a PPA-front result.

## Full Bounded Arm

- Root:
  `exp/useful_bd_push/t38_elite_pareto_slot_live_qd_20260622_054857_UTC/`
- Mode:
  `elite_pareto_slot_qd/seed_1001/openai_gpt-oss-120b/`
- Scope:
  `RTLLM/Prob045_alu`, `RTLLM/Prob041_traffic_light`, and
  `RTLLM/Prob015_multi_pipe_8bit`; population `12`, generations `3`.
- Result:
  validator passed, ALU and traffic-light have active archive members,
  multi-pipe has valid/global front candidates but zero active archive members.
