# Adaptive Sparse-Front Probe Report

Status: `diagnostic_negative_not_promoted`.

## Conclusion

`masterrtl_aux_archive_adaptive_sparse_front_8x5` should not be promoted to
the final RTLLM comparison. The adaptive trigger fired on the intended
front-thin problems, but the arm lost too much hypervolume relative to both
classic and the fixed high-exploit auxiliary archive.

## Key Numbers

| Backend | Mean HV | Mean Pareto Points | Mean Ref-Beating | HV Wins |
| --- | ---: | ---: | ---: | ---: |
| `classic_revolution_8x5` | `0.1406` | `3.25` | `8.00` | `5` |
| `masterrtl_aux_archive_high_exploit_8x5` | `0.1339` | `1.75` | `4.00` | `1` |
| `masterrtl_aux_archive_adaptive_sparse_front_8x5` | `0.0946` | `2.38` | `4.88` | `2` |

The adaptive arm improves mean Pareto points over fixed high-exploit
auxiliary archive, but it is far outside the registered `1-2%` HV tolerance
versus classic. It is also worse than fixed high-exploit on mean HV.

## Trigger Read

Sparse-front pressure fired on three RTLLM problems:

| Problem | Trigger Batches | Parent Requests |
| --- | ---: | ---: |
| `Prob015_multi_pipe_8bit` | `8` | `8` |
| `Prob041_traffic_light` | `21` | `21` |
| `Prob045_alu` | `24` | `24` |

That confirms the mechanism was exercised. The result is therefore a negative
mechanism result, not a no-op run.

## Interpretation

The current fixed MasterRTL auxiliary archive family has now failed three
follow-ups:

- front-breadth pressure recovered some Pareto breadth but lost HV;
- depth-only `6x7` helped classic more than QD;
- adaptive sparse-front pressure fired, but still lost aggregate HV.

The next milestone should not spend full RTLLM budget on this family. Either
switch to a meaningfully different mechanism, such as explicit stagnation
detection with delayed archive activation, or write the current milestone as a
rigorous negative screen for these QD variants.

## Artifacts

- `tables/adaptive_sparse_front_aggregate.csv`
- `tables/adaptive_sparse_front_trigger_counters.csv`
- `logs/run_checkpoint.md`
- Final-analysis source:
  `exp/useful_bd_push/prelim_adaptive_sparse_front_20260626_013437_UTC/live/final_analysis_with_adaptive_sparse_front`
