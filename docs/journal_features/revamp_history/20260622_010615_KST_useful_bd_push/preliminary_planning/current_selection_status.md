# Current Selection Status

Status: no QD configuration is currently promoted for the final full-RTLLM
comparison.

## Answer

The preliminary plan is not finished. It has produced hard screening data,
including a three-seed replication of the best diagnostic arm and the T84
front-slot follow-up, but it has not identified a QD/MAP-Elites configuration
that is strong enough to spend the full RTLLM budget on as a positive
candidate.

Selection should not discard whole encoder/config categories just because the
current best member is below classic. Maintain:

1. one best current representative per encoder/config category; and
2. a top-10 current configuration table ranked primarily by mean HV.

The top-10 table below is operational, not a final paper claim. Mean HV is most
comparable inside the frozen eight-design preliminary screen; rows with a
different budget or replication caveat are marked explicitly.

## Current Category Representatives

| Category | Keep Representative | Mean HV | Status |
| --- | --- | ---: | --- |
| Baseline | `classic_revolution_8x5` | `0.1406` | Comparator, not QD. |
| Pretrained MasterRTL RF model-state | `T83_rf_leafid_structural_delayed_qd` | `0.1369` | Best current QD by single-seed mean HV; not promoted because front breadth and no-`Prob135` robustness fail. |
| MasterRTL auxiliary archive | `masterrtl_aux_archive_high_exploit_8x5` | `0.1339` | Best auxiliary-archive single seed; three-seed mean HV falls to `0.1261`, so keep only as a category representative. |
| Delayed archive timing | `masterrtl_delayed_archive_activation_8x5` | `0.1324` | Best timing/schedule clue; still below classic. |
| Raw MasterRTL structural cells | `masterrtl_structural_front_slot_8x5` | `0.1227` | Best raw structural-cell variant on the frozen screen. |
| T11/T36 graph-like bridge | `t11_runtime_top4_front_slot_8x5` | `0.1208` | Best live graph-like representative; replay signals remain stronger than live results. |
| Code-thought/SR front-slot | `code_thought_sr_front_slot_8x5` | `0.1141` | Best current SR/code-thought representative in this preliminary pool. |
| Qwen3 pretrained text/code | `qwen_canonical_rtl_pca3_8x5` | `0.1108` | Best actual pretrained text/code embedding live arm; keep as the Qwen representative despite weak HV. |
| Front-guarded QD memory | `T85_fg_qdm_sr_memory_warmup4_12x3` | `0.1375` smoke-only | Mechanism representative only; three-problem `12x3` smoke is not top-10 comparable and loses classic mean HV `0.1903`. |
| DeepGate / synthesized-netlist encoder | `DeepGate transition-AIG bridge` | n/a | Keep as category placeholder; not top-10 until a verified pretrained live screen has comparable HV. |
| AURORA / AutoQD learned descriptor | `AURORA-style raw implementation-feature lane` | n/a | Keep as category placeholder; current evidence is replay/diagnostic, not frozen live HV. |

## Top 10 Current Configs By Mean HV

Primary sort key is mean HV. Secondary read is whether the row is comparable,
replicated, and category-useful.

| Rank | Config | Mean HV | Comparator | Read |
| ---: | --- | ---: | --- | --- |
| 1 | `T83_rf_leafid_structural_delayed_qd` | `0.1369` | Classic `8x5` `0.1406` | Best current QD by single-seed mean HV; diagnostic, not promoted. |
| 2 | `masterrtl_aux_archive_high_exploit_8x5` | `0.1339` | Classic `8x5` `0.1406` | Best auxiliary archive single seed; replication negative. |
| 3 | `masterrtl_delayed_archive_activation_8x5` | `0.1324` | Classic `8x5` `0.1406` | Best archive-timing clue; still below classic. |
| 4 | `masterrtl_aux_archive_high_exploit_6x7` | `0.1229` | Classic `6x7` `0.1701` | Different budget shape; depth-only continuation failed. |
| 5 | `masterrtl_structural_front_slot_8x5` | `0.1227` | Classic `8x5` `0.1406` | Best raw MasterRTL structural-cell variant. |
| 6 | `masterrtl_structural_mix_8x5` | `0.1218` | Classic `8x5` `0.1406` | Plain structural mix; category baseline. |
| 7 | `t11_runtime_top4_front_slot_8x5` | `0.1208` | Classic `8x5` `0.1406` | Best live graph-like bridge arm. |
| 8 | `T84_rf_leafid_front_slot_delayed_qd` | `0.1162` | Classic `8x5` `0.1406` | Completed negative; keep only as failed coupling evidence. |
| 9 | `code_thought_sr_front_slot_8x5` | `0.1141` | Classic `8x5` `0.1406` | SR/code-thought representative. |
| 10 | `masterrtl_rf_timing_state_8x5` | `0.1140` | Classic `8x5` `0.1406` | T82 exact RF timing-state profile; negative but model-state integration is valid. |

Dropped just below the top 10: `masterrtl_aux_archive_front_breadth_8x5`
(`0.1134`), `qwen_canonical_rtl_pca3_8x5` (`0.1108`),
`masterrtl_archive_stagnation_activation_8x5` (`0.1089`), and
`masterrtl_aux_archive_adaptive_sparse_front_8x5` (`0.0946`). Keep Qwen anyway
as the best current actual pretrained text/code encoder representative.

## Best Replicated Result So Far

The strongest replicated QD arm from the frozen eight-design screen is
`masterrtl_aux_archive_high_exploit_8x5`. It reached seed `1001` mean HV
`0.1339` versus classic `0.1406`, but the result did not replicate.

| Metric | Classic | Aux archive | Read |
| --- | ---: | ---: | --- |
| Three-seed mean HV | `0.1442` | `0.1261` | QD loses by `-12.51%` |
| Seed-level HV wins | `3` | `0` | QD loses every seed |
| No-Prob135 relative HV delta | - | - | QD loses by `-18.25%` |

Decision: fixed high-exploit auxiliary archive is diagnostic negative and not
promoted.

## Encoder And Descriptor Read

| Lane | Current Status | Decision |
| --- | --- | --- |
| Qwen3 canonical RTL | Real pretrained live hook; matched screen completed at `8x5`. | Not promoted: mean HV `0.1108` versus classic `0.1406`. |
| DeepGate transition AIG | Official pretrained bridge embeds nonconstant generated candidates across `5/8` screen problems. | Not spend-ready: large designs still exceed the practical bridge cap. |
| MasterRTL pretrained Area leaf | Pretrained model artifact loads, but generated candidates collapse to one Area prediction and one leaf row. | Retire direct Area-head leaves unless retrained or replaced. |
| MasterRTL RF timing model-state | Pretrained RF timing flow has a runtime descriptor hook and two frozen `8x5` screens. | T82 is negative; T83 is nearer on all-design HV but still not promoted. |
| MasterRTL raw structural mix | Credible RTL-native descriptor lane. | Needs stronger coupling; fixed auxiliary archive failed replication. |
| T11/T36 graph-like lane | Replay signal exists; live top-4/front-slot successor ran. | Not promoted: live `8x5` mean HV `0.1208` versus classic `0.1406`. |

## Pre-RF Archive-Pressure Context

Do not run another fixed MasterRTL geometry tweak. The adaptive sparse-front
gate in `20260626_aux_archive_adaptive_sparse_front_probe/` fired its trigger,
but it also lost badly on mean HV (`0.0946` versus classic `0.1406`).

The delayed archive activation gate in
`20260626_delayed_archive_activation_probe/` is now complete. It tests a
materially different timing mechanism: keep passive archive logging from the
start, but delay QD archive pressure until generation `3` so early generations
can behave more like classic hill climbing.

The timing change is useful but not enough. Delayed activation reaches mean HV
`0.1324`, mean Pareto points `2.00`, and mean reference-beating candidates
`6.00`; classic remains ahead at mean HV `0.1406`, mean Pareto points `3.25`,
and mean reference-beating candidates `8.00`.

No QD configuration is promoted for final full-RTLLM spend yet. The next
candidate should be materially different from fixed MasterRTL auxiliary archive
pressure.

## Front-Guarded QD-Memory Candidate

`T85_front_guarded_qd_memory` is implemented, pre-registered, and has completed
two three-problem live smokes. It is materially different from the fixed
auxiliary archive family: the archive is passive memory, the primary success
pool remains separate, empty-cell fill gets no budget, and only credited
retained cells can receive the small memory-refine or front-rescue lanes.

First smoke result: `Prob045_alu` produced a useful mechanism signal,
including one front-rescue global-front add, but `Prob015_multi_pipe_8bit`
never initialized the grid because it ended with `7` warmup successes against
the `8`-success threshold.

Warmup-4 rerun: lowering `qd_grid_quantile_warmup_successes` to `4` fixed the
coverage failure and produced valid winners on all three problems. The scalar
score read was mixed: T85 beat classic on `Prob015_multi_pipe_8bit` but lost on
`Prob041_traffic_light` and `Prob045_alu`.

The formal HV/Pareto read blocks promotion. On the same three
reference-complete problems, classic mean HV is `0.1903` and T85 warmup-4 mean
HV is `0.1375`; classic wins all three HV comparisons, with mean Pareto points
`3.00` versus `2.00` and mean reference-beating candidates `17.33` versus
`9.00`.

Decision: keep T85 as the current front-guarded memory category representative,
but do not rank it in the frozen eight-design top-10 table or promote it to
final RTLLM spend. A future T85 continuation must change the mechanism or
descriptor materially; exact `sr_pca_3d` warmup-4 FG-QDM is a negative smoke.

Measured archive-stagnation activation is now complete and negative. It kept
passive archive logging from the start and activated archive pressure only
after two consecutive archive-history intervals showed no growth in occupied
cells or archive-member count. The trigger fired on `3/8` problems and `7/49`
archive-history rows, but mean HV fell to `0.1089` versus classic `0.1406`.

This pushed the next candidates toward validated MasterRTL pretrained
model-state descriptors, recorded in the RF gates below.

## Previous RF Gate

`T82_masterrtl_rf_timing_runtime_hook` completed the implementation gate that
turns the validated T81 MasterRTL pretrained RF timing-state signal into a
live descriptor profile. The follow-up one-problem live smoke verified archive
artifacts and descriptor logging on `Prob015_multi_pipe_8bit`. The frozen
eight-design `8x5` screen has now also completed.

| Metric | Value |
| --- | ---: |
| Screened problems | `8` |
| Headline-paired comparisons | `8` |
| Classic mean HV | `0.1406` |
| RF timing QD mean HV | `0.1140` |
| Classic mean Pareto points | `3.25` |
| RF timing QD mean Pareto points | `2.00` |
| RF timing QD HV wins | `2/8` |

Decision: valid implementation, negative screen. The final RTLLM plan remains
unfinished because no QD configuration is promoted. Do not spend the full
RTLLM budget on the exact `source_aligned_rf_timing_state_3d` profile.

## RF Leaf-ID Structural Gate

`T83_rf_leafid_structural_delayed_qd` completed the next materially different
RF timing candidate. It uses explicit descriptor axes:

```text
source_aligned_rf_timing_leaf_ids
source_aligned_masterrtl_branching
source_aligned_rtltimer_wire_density
```

This keeps the validated RF timing model-state path but avoids the collapsed
RF `path_count` axis, and combines it with the delayed archive activation
schedule that was the best recent archive-pressure timing clue.

| Metric | Classic | T83 QD |
| --- | ---: | ---: |
| Screened problems | `8` | `8` |
| Headline-paired comparisons | `8` | `8` |
| Mean HV | `0.1406` | `0.1369` |
| Mean Pareto points | `3.25` | `2.00` |
| Mean reference-beating candidates | `8.00` | `4.50` |
| HV wins | `5/8` | `3/8` |

Decision: exact T83 is a useful diagnostic but not a full-RTLLM candidate.
The all-design mean-HV gap is only `-2.63%`, but removing
`Prob135_m2014_q6b` widens the gap to `-20.29%`, and RTLLM-only mean HV is
negative (`0.0995` versus classic `0.1453`). The preliminary plan therefore
remains unfinished: no QD configuration is currently promoted for final
full-RTLLM spend.

## RF Leaf-ID Front-Slot Gate

`T84_rf_leafid_front_slot_delayed_qd` completed the registered follow-up to
T83. It keeps T83's RF leaf-ID axes and delayed activation, but changes the
coupling to `front_slot_lane_nsga2`.

| Metric | Classic | T83 QD | T84 QD |
| --- | ---: | ---: | ---: |
| Screened problems | `8` | `8` | `8` |
| Headline-paired comparisons | `8` | `8` | `8` |
| Mean HV | `0.1406` | `0.1369` | `0.1162` |
| Mean Pareto points | `3.25` | `2.00` | `1.88` |
| Mean reference-beating candidates | `8.00` | `4.50` | `3.75` |
| HV wins | `5/8` | `3/8` | `0/8` |

Decision: exact T84 is retired. It slightly improves the no-`Prob135_m2014_q6b`
mean-HV read versus T83 (`0.1328` versus `0.1281`), but it loses the
all-design mean-HV signal and does not recover front material. Keep T83, not
T84, as the current MasterRTL RF model-state representative.
