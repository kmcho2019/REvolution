# T41 Artifacts Manifest

Status: pre-registered; runtime artifacts pending.

## Committed Method Artifacts

- `methodology.md`: method definition, fixed settings, leakage rules, and
  acceptance gates.
- `commands/live_screen_v0.md`: exact preflight, live, validation, and
  packaging command card.
- `tables/live_screen_v0_subset.yaml`: frozen three-problem screen.
- `tables/run_matrix.csv`: planned adaptive arm and frozen comparators.
- `figures/README.md`: figure contract.
- `figures/visual_inspection_notes.md`: visual inspection checklist.
- `visualizations/direct_ppa_pareto/README.md`: expected direct PPA viewer.
- `results_report.md`: pending-result report scaffold.
- `scripts/package_t41_adaptive_sparse_yield_gate.py`: package generator for
  direct PPA-front figures, tables, and viewer.

## Runtime Artifacts To Capture

- `exp/useful_bd_push/t41_adaptive_sparse_yield_gate_qd_<timestamp>/preflight/`
- `exp/useful_bd_push/t41_adaptive_sparse_yield_gate_qd_<timestamp>/classic_revolution/`
- `exp/useful_bd_push/t41_adaptive_sparse_yield_gate_qd_<timestamp>/adaptive_sparse_yield_gate_qd/`

Frozen comparator roots:

- T40 manual/random/full-Pareto controls:
  `exp/useful_bd_push/t40_sparse_warmup_control_matrix_20260622_070540_UTC/`
- T39 one-slot reference:
  `exp/useful_bd_push/t39_sparse_yield_warmup_qd_20260622_062937_UTC/`

Runtime outputs stay under `exp/`, not `/aux`.

## Packaged Outputs To Commit After The Run

- `tables/t41_candidate_ppa_points.csv`
- `tables/t41_problem_method_summary.csv`
- `tables/t41_method_manifest.csv`
- `figures/t41_raw_area_power_fronts.png`
- `figures/t41_front_count_summary.png`
- `visualizations/direct_ppa_pareto/index.html`
- `visualizations/direct_ppa_pareto/metrics.json`
