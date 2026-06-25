# Live Screening Results

## Verdict

Do not promote either spend-ready QD arm to the full RTLLM run yet.
Classic REvolution remains the headline winner on mean HV, Pareto
point count, reference-beating count, and per-problem HV wins.

The strongest QD arm in this screen is `masterrtl_structural_mix_8x5`,
but it is still below classic on the headline Pareto metrics.

## Run Roots

- live root: `/workspace/exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/live`
- final analysis: `/workspace/exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/live/final_analysis`

## Aggregate Pareto Metrics

![Mean HV](figures/live_screen_mean_hv.png)

| Backend | Mean HV | Pareto Points | Ref-Beating | HV Wins |
| --- | ---: | ---: | ---: | ---: |
| `classic_revolution_8x5` | 0.1406 | 3.25 | 8.00 | 7 |
| `code_thought_sr_front_slot_8x5` | 0.1141 | 1.88 | 4.12 | 0 |
| `masterrtl_structural_mix_8x5` | 0.1218 | 2.00 | 5.50 | 1 |

## QD Delta Summary

![HV Delta](figures/live_screen_hv_delta_by_problem.png)

| QD Backend | Mean HV Delta | HV Wins vs Classic | Mean Pareto Delta |
| --- | ---: | ---: | ---: |
| `code_thought_sr_front_slot_8x5` | -0.0266 | 1/8 | -1.38 |
| `masterrtl_structural_mix_8x5` | -0.0189 | 1/8 | -1.25 |

## Encoder Status

No pretrained encoder was used in this live screen. Qwen3, DeepGate3,
AURORA, and T11/T36 remain bridge-required because their current evidence
is replay-only, near-collapsed, or failed in a prior live conversion.
Pretrained-weight configurations should not enter the next live spend
until model-loading, schema, and non-collapse validation pass.
