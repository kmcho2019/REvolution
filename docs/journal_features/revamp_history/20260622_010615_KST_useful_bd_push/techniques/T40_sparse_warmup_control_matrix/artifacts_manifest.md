# T40 Artifacts Manifest

Status: pre-registered; no runtime artifacts committed yet.

## Committed Method Artifacts

- `methodology.md`: validation matrix definition and guardrails.
- `commands/live_screen_v0.md`: exact preflight, control, and validation
  commands.
- `tables/live_screen_v0_subset.yaml`: frozen three-problem live screen.
- `tables/run_matrix.csv`: planned arms and fixed settings.
- `figures/README.md`: required figure contract.
- `figures/visual_inspection_notes.md`: pending visual inspection checklist.
- `visualizations/direct_ppa_pareto/README.md`: pending direct PPA viewer
  location.
- `results_report.md`: pending-result report scaffold.

## Runtime Artifacts To Capture

- `exp/useful_bd_push/t40_sparse_warmup_control_matrix_<timestamp>/preflight/`
- `exp/useful_bd_push/t40_sparse_warmup_control_matrix_<timestamp>/classic_revolution/`
- `exp/useful_bd_push/t40_sparse_warmup_control_matrix_<timestamp>/manual_sparse_pareto_qd/`
- `exp/useful_bd_push/t40_sparse_warmup_control_matrix_<timestamp>/random_sparse_elite_slot_qd/`
- `exp/useful_bd_push/t40_sparse_warmup_control_matrix_<timestamp>/graph_full_pareto_sparse_qd/`

The frozen candidate reference is:

- `exp/useful_bd_push/t39_sparse_yield_warmup_qd_20260622_062937_UTC/sparse_warmup_elite_slot_qd/`

Runtime outputs stay under `exp/`, not `/aux`.
