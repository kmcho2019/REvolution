# T11 Top-4 Front-Slot Probe Report

## Question

Can the strongest encoder-like graph lane become competitive if we avoid exact
T58's PCA4 geometry and instead use raw T11 top-4 runtime graph axes with the
same conservative front-slot parent lane?

## Method

The candidate arm was:

`t11_runtime_top4_front_slot_8x5`

It used:

- frozen eight-design preliminary screen;
- seed `1001`;
- population `8`, generations `5`;
- `grid_quantile` archive;
- `elite_pareto_slot` cells;
- `qd_fill_target_fraction=0.25`;
- `qd_improve_backfill_fraction=0.20`;
- `qd_champion_lane_fraction=0.80`;
- `qd_parent_selection=front_slot_lane_nsga2`;
- `qd_front_slot_lane_fraction=0.10`;
- one-parent single-thought operator;
- no repair;
- descriptor profile `t11_runtime_top4_graph`.

The descriptor axes were:

| Axis | Meaning |
| --- | --- |
| `hyper_mean_fanout` | Average hypergraph fanout of generated RTL/netlist graph structure. |
| `edge_per_node` | Graph edge density normalized by node count. |
| `log_edge_count` | Log-scaled graph edge count. |
| `hyper_directed_edge_count` | Directed hyperedge count in the runtime graph extraction. |

These are encoder-like graph descriptors, not pretrained model weights. They
are included because T36/T11 had the strongest replay signal, and the goal is
to test the best plausible candidates before a full RTLLM spend.

## Run Status

| Item | Result |
| --- | --- |
| Problems completed | `8/8` |
| Runtime | `1691.70s` |
| Summary path | `exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/live/t11_runtime_top4_front_slot_8x5/seed_1001/openai_gpt-oss-120b/20260625_200436_revolution_summary_results.txt` |
| Scheduler telemetry | `exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/live/t11_runtime_top4_front_slot_8x5/seed_1001/openai_gpt-oss-120b/20260625_200436_revolution_scheduler_telemetry.json` |
| Pareto validator | passed |
| Single-thought validator | passed |

## Aggregate Result

| Backend | Mean HV | Pareto Points | Ref-Beating | HV Wins |
| --- | ---: | ---: | ---: | ---: |
| `classic_revolution_8x5` | 0.1406 | 3.25 | 8.00 | 6 |
| `masterrtl_structural_front_slot_8x5` | 0.1227 | 1.75 | 6.62 | 1 |
| `t11_runtime_top4_front_slot_8x5` | 0.1208 | 1.88 | 5.38 | 0 |
| `masterrtl_structural_mix_8x5` | 0.1218 | 2.00 | 5.50 | 1 |
| `code_thought_sr_front_slot_8x5` | 0.1141 | 1.88 | 4.12 | 0 |
| `qwen_canonical_rtl_pca3_8x5` | 0.1108 | 1.62 | 4.38 | 0 |

T11 top-4 front-slot is not the best screened QD arm. It trails the
MasterRTL front-slot follow-up on mean HV and trails classic on every headline
promotion metric.

## Per-Problem Deltas Versus Classic

| Problem | HV Delta | Pareto Delta | Ref-Beating Delta |
| --- | ---: | ---: | ---: |
| `Prob015_multi_pipe_8bit` | +0.0000 | -6 | +0 |
| `Prob024_fsm` | +0.0002 | +0 | +1 |
| `Prob041_traffic_light` | -0.0770 | +1 | +2 |
| `Prob045_alu` | -0.0697 | -3 | -14 |
| `Prob049_signal_generator` | -0.0124 | -1 | -3 |
| `Prob116_m2014_q3` | +0.0000 | +0 | -3 |
| `Prob135_m2014_q6b` | +0.0000 | +0 | -1 |
| `Prob153_gshare` | -0.0000 | -2 | -3 |

The only positive HV movement is the tiny `Prob024_fsm` delta. The large
losses are concentrated on `Prob041_traffic_light` and `Prob045_alu`, the same
type of front-quality failure that blocked prior graph-lane promotions.

## Interpretation

This run answers a useful planning question: raw T11 top-4 graph axes do not
rescue the graph-encoder lane when combined with the conservative front-slot
parent lane on the frozen eight-design screen.

The graph lane remains useful as a diagnostic representation, but the current
evidence does not justify full RTLLM spending on direct T11 graph archive
geometry. If the graph family is revisited, it should be as a secondary
archive/reporting lane, a trained auxiliary model, or a hybrid that protects
front-yield more strongly than this run.

## Decision

Do not promote `t11_runtime_top4_front_slot_8x5` to the final RTLLM comparison.

The current best screened QD arm remains the MasterRTL structural front-slot
follow-up, but even that arm is diagnostic rather than promotable because
classic remains ahead on mean HV and Pareto breadth.
