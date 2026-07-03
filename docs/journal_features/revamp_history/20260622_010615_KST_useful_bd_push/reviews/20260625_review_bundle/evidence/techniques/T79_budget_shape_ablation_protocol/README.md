# T79 Budget-Shape Ablation Protocol

T79 is the live `L8` budget-shape ablation package.

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
| `8x5` | `48` | complete | complete |
| `6x7` | `48` | complete | complete |

QD uses the T75 arm: `shape_density_front_pressure_qd`.

## Status

`live_complete_diagnostic_negative`.

All six planned arms finished with `8/8` successful frozen designs and `48`
samples per design.

Completed arms are recorded in `tables/t79_live_arm_status.csv`. The `12x3`,
`8x5`, and `6x7` classic/QD pairs are complete and have passed the registered
validators. The aggregate analysis bundle, tracked summary figures, raw CSVs,
visual notes, direct PPA/Pareto supplement, and Phase 03.1 viewer bundles are
packaged. The remaining visualization caveat is strict Playwright interaction
validation on arbitrary T79 subsets; strict schema validation passes for all
three viewer bundles.

## Result Summary

T79 does not support the hypothesis that this T75 QD arm benefits more than
classic from deeper equal-candidate budgets. QD loses matched classic on mean
Pareto hypervolume for all three shapes:

- `12x3`: QD HV delta `-0.0804`.
- `8x5`: QD HV delta `-0.0183`.
- `6x7`: QD HV delta `-0.0507`.

The least negative QD shape is `8x5`, but it still trails classic on HV,
Pareto points, reference-beating count, synthesis yield, and best score. The
current conclusion is diagnostic-negative for exact T75 under T79 settings.
