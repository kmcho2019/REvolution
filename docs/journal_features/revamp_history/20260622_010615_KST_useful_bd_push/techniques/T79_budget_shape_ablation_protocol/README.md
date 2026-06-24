# T79 Budget-Shape Ablation Protocol

T79 pre-registers the live `L8` budget-shape ablation. It is not a completed
result package yet.

## Question

Does a deeper equal-candidate budget help the selected QD arm more than classic
REvolution?

## Frozen Primary Subset

The primary subset is frozen at
`tables/t79_budget_ablation_subset.csv` and
`tables/budget_shape_subset.yaml`.

It has eight reference-complete designs selected from the existing frozen and
holdout tables before any T79 live outcome:

- `RTLLM/Prob015_multi_pipe_8bit`
- `RTLLM/Prob024_fsm`
- `RTLLM/Prob041_traffic_light`
- `RTLLM/Prob045_alu`
- `RTLLM/Prob049_signal_generator`
- `VerilogEval-Spec-to-RTL/Prob116_m2014_q3`
- `VerilogEval-Spec-to-RTL/Prob135_m2014_q6b`
- `VerilogEval-Spec-to-RTL/Prob153_gshare`

## Planned Matrix

| Shape | Candidate Budget | Classic | QD |
| --- | ---: | --- | --- |
| `12x3` | `48` | complete | complete |
| `8x5` | `48` | complete | planned |
| `6x7` | `48` | planned | planned |

QD uses the T75 arm: `shape_density_front_pressure_qd`.

## Status

`one_arm_complete`.

Promotion remains impossible until all six planned arms finish or a blocked
run is documented with exact partial artifacts and continuation rules.

Completed arms are recorded in `tables/t79_live_arm_status.csv`. The `12x3`
classic and QD pair has passed the registered validators, but this is still
not a budget-shape result.
