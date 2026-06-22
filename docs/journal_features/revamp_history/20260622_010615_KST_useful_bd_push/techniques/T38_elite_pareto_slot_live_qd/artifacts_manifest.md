# T38 Artifacts Manifest

Status: pre-registered; no live results committed yet.

## Committed Method Artifacts

- `methodology.md`: pre-registered method definition and gates.
- `commands/live_screen_v0.md`: exact preflight, comparator, control, T38,
  and validation commands.
- `tables/live_screen_v0_subset.yaml`: frozen three-problem live screen.
- `tables/run_matrix.csv`: planned method matrix.

## Runtime Artifacts To Capture

- `exp/useful_bd_push/t38_elite_pareto_slot_live_qd_<timestamp>/preflight/`
- `exp/useful_bd_push/t38_elite_pareto_slot_live_qd_<timestamp>/classic_revolution/`
- `exp/useful_bd_push/t38_elite_pareto_slot_live_qd_<timestamp>/graph_pareto_front_qd/`
- `exp/useful_bd_push/t38_elite_pareto_slot_live_qd_<timestamp>/elite_pareto_slot_qd/`

Runtime outputs stay under `exp/`, not `/aux`.
