# T40 Artifacts Manifest

Status: complete live control matrix.

## Committed Method Artifacts

- `methodology.md`: validation matrix definition and guardrails.
- `commands/live_screen_v0.md`: exact preflight, control, and validation
  commands.
- `tables/live_screen_v0_subset.yaml`: frozen three-problem live screen.
- `tables/run_matrix.csv`: completed arms and fixed settings.
- `tables/preflight_models_20260622_070540_UTC.json`: vLLM model preflight.
- `tables/t40_method_manifest.csv`: source run roots and method paths.
- `tables/t40_problem_method_summary.csv`: per-problem method metrics.
- `tables/t40_candidate_ppa_points.csv`: candidate-level PPA/front rows.
- `tables/*_validation.{json,md}`: QD archive validator outputs.
- `figures/t40_raw_area_power_fronts.png`: primary direct PPA front.
- `figures/t40_front_count_summary.png`: valid-PPA and pooled-front counts.
- `figures/visual_inspection_notes.md`: accepted visual inspection notes.
- `visualizations/direct_ppa_pareto/index.html`: direct PPA viewer.
- `visualizations/direct_ppa_pareto/metrics.json`: viewer metrics.
- `visualizations/direct_ppa_pareto/screenshot.png`: viewer screenshot.
- `results_report.md`: measured result and tier decision.

## Runtime Artifact Roots

- `exp/useful_bd_push/t40_sparse_warmup_control_matrix_<timestamp>/preflight/`
- `exp/useful_bd_push/t40_sparse_warmup_control_matrix_<timestamp>/classic_revolution/`
- `exp/useful_bd_push/t40_sparse_warmup_control_matrix_<timestamp>/manual_sparse_pareto_qd/`
- `exp/useful_bd_push/t40_sparse_warmup_control_matrix_<timestamp>/random_sparse_elite_slot_qd/`
- `exp/useful_bd_push/t40_sparse_warmup_control_matrix_<timestamp>/graph_full_pareto_sparse_qd/`

The frozen candidate reference is:

- `exp/useful_bd_push/t39_sparse_yield_warmup_qd_20260622_062937_UTC/sparse_warmup_elite_slot_qd/`

Runtime outputs stay under `exp/`, not `/aux`.
