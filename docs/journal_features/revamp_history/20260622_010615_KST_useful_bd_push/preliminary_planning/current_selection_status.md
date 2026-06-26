# Current Selection Status

Status: no QD configuration is currently promoted for the final full-RTLLM
comparison.

## Answer

The preliminary plan is not finished. It has produced hard screening data,
including a three-seed replication of the best diagnostic arm, the T84
front-slot follow-up, and the T96 RF/DeepGate hybrid screen, but it has not
identified a QD/MAP-Elites configuration that is strong enough to spend the
full RTLLM budget on as a positive candidate. T96 improves over pure T95
DeepGate on mean HV, but it regresses against its closer T83 RF sibling and is
still negative versus classic on aggregate HV and front breadth.

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
| Pretrained MasterRTL RF model-state | `T83_rf_leafid_structural_delayed_qd` | `0.1260` replicated | Best RF model-state representative; three-seed mean HV is `0.125986` versus classic `0.144182`, so not promoted. |
| MasterRTL auxiliary archive | `masterrtl_aux_archive_high_exploit_8x5` | `0.1261` replicated | Best auxiliary-archive representative by replicated mean HV; keep only as a category representative. |
| Delayed archive timing | `masterrtl_delayed_archive_activation_8x5` | `0.1324` | Best timing/schedule clue; still below classic. |
| Raw MasterRTL structural cells | `masterrtl_structural_front_slot_8x5` | `0.1227` | Best raw structural-cell variant on the frozen screen. |
| T11/T36 graph-like bridge | `t11_runtime_top4_front_slot_8x5` | `0.1208` | Best live graph-like representative; replay signals remain stronger than live results. |
| Code-thought/SR front-slot | `code_thought_sr_front_slot_8x5` | `0.1141` | Best current SR/code-thought representative in this preliminary pool. |
| Qwen3 pretrained text/code | `qwen_canonical_rtl_pca3_8x5` | `0.1108` | Best actual pretrained text/code embedding live arm; keep as the Qwen representative despite weak HV. |
| Front-guarded QD memory control | `T86_fg_qdm_random_memory_12x3` | `0.1382` smoke-only | Control representative only; random-memory FG-QDM trails classic and slightly beats SR-memory, so exact `sr_pca_3d` memory is not descriptor-positive. |
| DeepGate / synthesized-netlist encoder | `T95_deepgate_delayed_high_exploit_8x5` | `0.1153` | Best pure DeepGate representative; delayed high-exploit coupling improves over T94 but trails classic. |
| Hybrid pretrained RTL/netlist encoder | `T96_rf_deepgate_hybrid_delayed_8x5` | `0.1199` | Best RF/DeepGate hybrid representative; improves over pure T95 DeepGate but regresses versus same-seed T83 `0.1369`, trails classic, and loses front breadth. |
| AURORA / AutoQD learned descriptor | `AURORA-style raw implementation-feature lane` | n/a | Keep as category placeholder; current evidence is replay/diagnostic, not frozen live HV. |

## Top 10 Current Configs By Mean HV

Primary sort key is mean HV. Secondary read is whether the row is comparable,
replicated, and category-useful.

| Rank | Config | Mean HV | Comparator | Read |
| ---: | --- | ---: | --- | --- |
| 1 | `masterrtl_delayed_archive_activation_8x5` | `0.1324` | Classic `8x5` `0.1406` | Best single-seed archive-timing clue; still below classic. |
| 2 | `masterrtl_aux_archive_high_exploit_8x5` | `0.1261` replicated | Classic `8x5` `0.1442` replicated | Best replicated auxiliary-archive representative; negative. |
| 3 | `T83_rf_leafid_structural_delayed_qd` | `0.1260` replicated | Classic `8x5` `0.1442` replicated | Best RF model-state representative; replication negative. |
| 4 | `masterrtl_aux_archive_high_exploit_6x7` | `0.1229` | Classic `6x7` `0.1701` | Different budget shape; depth-only continuation failed. |
| 5 | `masterrtl_structural_front_slot_8x5` | `0.1227` | Classic `8x5` `0.1406` | Best raw MasterRTL structural-cell variant. |
| 6 | `masterrtl_structural_mix_8x5` | `0.1218` | Classic `8x5` `0.1406` | Plain structural mix; category baseline. |
| 7 | `t11_runtime_top4_front_slot_8x5` | `0.1208` | Classic `8x5` `0.1406` | Best live graph-like bridge arm. |
| 8 | `rf_deepgate_hybrid_delayed_8x5` | `0.1199` | Classic `8x5` `0.1406` | Best hybrid pretrained RTL/netlist representative; improves over T95 but regresses versus T83 and remains negative. |
| 9 | `T84_rf_leafid_front_slot_delayed_qd` | `0.1162` | Classic `8x5` `0.1406` | Completed negative; keep only as failed coupling evidence. |
| 10 | `deepgate_delayed_high_exploit_8x5` | `0.1153` | Classic `8x5` `0.1406` | Best screened pure synthesized-netlist pretrained encoder representative; improves over T94 but remains negative. |

Dropped just below the top 10: `code_thought_sr_front_slot_8x5` (`0.1141`),
`masterrtl_rf_timing_state_8x5` (`0.1140`),
`masterrtl_aux_archive_front_breadth_8x5` (`0.1134`),
`qwen_canonical_rtl_pca3_8x5` (`0.1108`),
`masterrtl_archive_stagnation_activation_8x5` (`0.1089`),
`deepgate_pooled_pc3_8x5` (`0.1040`), and
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
| DeepGate transition/cone AIG | Official pretrained bridge now has pooled candidate descriptors across all `96` sampled candidates, `8/8` screen problems, a runtime hook for `deepgate_pool_pc0..2`, one live archive insertion, and two matched `8x5` screens. | Best DeepGate screen is T95 at mean HV `0.1153` versus classic `0.1406`; keep as category representative only. |
| MasterRTL pretrained Area leaf | Pretrained model artifact loads, but generated candidates collapse to one Area prediction and one leaf row. | Retire direct Area-head leaves unless retrained or replaced. |
| MasterRTL RF timing model-state | Pretrained RF timing flow has a runtime descriptor hook and two frozen `8x5` screens. | T82 is negative; T83 is nearer on all-design HV but still not promoted. |
| MasterRTL raw structural mix | Credible RTL-native descriptor lane. | Needs stronger coupling; fixed auxiliary archive failed replication. |
| T11/T36 graph-like lane | Replay signal exists; live top-4/front-slot successor ran. | Not promoted: live `8x5` mean HV `0.1208` versus classic `0.1406`. |

T92 changes the DeepGate status from replay-only to bounded-live-smoke-ready.
It freezes T91's pooled candidate embedding PCA into `deepgate_pool_pc0..2`,
wires those axes through both `QDEngine` and worker `CandidateEvaluator`, and
verifies the isolated official DeepGate environment on a generated
`Prob024_fsm` candidate. The isolated smoke emits finite descriptor values
(`0.1691`, `0.0919`, `-0.000085`) from a full-transition AIG with `61`
variables and `50` ANDs.

T93 adds live runtime evidence. Three generation-0 attempts produced no
valid-PPA candidate, so no descriptor could be observed. A bounded
`Prob045_alu` `4x1` run then produced one valid-PPA candidate, initialized one
archive cell, and wrote finite DeepGate descriptors
(`0.00027`, `0.08078`, `-0.09394`) into `archive_cells.csv`. DeepGate still
lacks matched HV evidence and is not a final RTLLM arm.

T94 supplies that matched HV evidence and keeps the conclusion negative. The
`deepgate_pooled_pc3_8x5` screen covers all eight frozen preliminary problems,
and the corrected completeness table marks every problem as `headline`.
Classic remains stronger on aggregate mean HV (`0.1406` versus `0.1040`),
mean Pareto points (`3.25` versus `1.75`), and mean reference-beating
candidates (`8.00` versus `4.50`). DeepGate narrowly wins HV on `Prob024_fsm`
and `Prob153_gshare`, and ties `Prob116_m2014_q3`, but it loses the larger
RTLLM front-material cases. Keep it as the DeepGate category representative;
do not spend full RTLLM budget on exact `deepgate_pooled_pc3_8x5`.

T95 tests whether T94 was mainly paying archive pressure too early. It keeps
the same official `deepgate_pooled_pc3` descriptor and frozen eight-design
`8x5` screen, but delays archive activation to generation `3`, lowers
fill/backfill to `0.10/0.05`, and raises champion-lane exploitation to
`0.90`. It improves mean HV over T94 (`0.1153` versus `0.1040`) and mean
reference-beating count (`5.25` versus `4.50`), but classic still leads mean
HV (`0.1406`), Pareto points (`3.25` versus `1.88`), and HV wins (`7` versus
`1`). Treat T95 as the best DeepGate category representative, not a promoted
full-RTLLM arm.

T96 tests whether pure DeepGate is missing a complementary RTL-native
pretrained model-state axis. It combines `source_aligned_rf_timing_leaf_ids`,
`source_aligned_masterrtl_branching`, and `deepgate_pool_pc0` under the
delayed high-exploit schedule. It improves over pure T95 DeepGate on mean HV
(`0.1199` versus `0.1153`), but it regresses versus the closer same-seed T83
RF leaf-ID structural delayed arm (`0.1369`). Classic remains ahead on mean HV
(`0.1406`), Pareto points (`3.25` versus `1.625`), and reference-beating
candidates (`8.00` versus `5.375`). The paired HV record is classic `3`
strict wins, `3` ties, and T96 `2` strict wins. T96 also has visible
valid-PPA yield drops on `Prob015_multi_pipe_8bit` (`24` to `10`) and
`Prob045_alu` (`36` to `11`). Keep T96 as the hybrid pretrained RTL/netlist
representative; do not promote it to full RTLLM spend.

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
HV is `0.1375`; classic wins `2/3` HV comparisons and ties
`Prob015_multi_pipe_8bit` at zero HV for both arms. Classic also leads mean
Pareto points `3.00` versus `2.00` and mean reference-beating candidates
`17.33` versus `9.00`.

Decision: keep T85 as the current front-guarded memory category representative,
but do not rank it in the frozen eight-design top-10 table or promote it to
final RTLLM spend. A future T85 continuation must change the mechanism or
descriptor materially; exact `sr_pca_3d` warmup-4 FG-QDM is a negative smoke.

T86 random-memory control: the matched smoke completed on the same three
problems. Classic mean HV is `0.1903`, random-memory FG-QDM is `0.1382`, and
SR-memory FG-QDM is `0.1375`. Random memory also has higher mean Pareto points
than SR memory (`2.67` versus `2.00`) and produces memory-refine global-front
adds on two problems while SR memory produces none.

Decision: exact `sr_pca_3d` FG-QDM is not descriptor-positive because it does
not beat the random-memory control. Keep T86 as control evidence, but do not
promote either T85 or T86 to the frozen eight-design screen or full RTLLM
spend.

T87 source-aligned shape-density memory: after simplifying the FG-QDM credit
logic and metadata handling, the RTL-native descriptor swap completed the same
three-problem smoke. It reaches mean HV `0.1264`, below SR memory `0.1375`,
random memory `0.1382`, and classic `0.1903`. It is the strongest FG-QDM arm
on `Prob045_alu` (`0.2099` HV versus random `0.1929` and SR `0.1853`), but it
loses badly on `Prob041_traffic_light` and produces zero valid-PPA children
from the memory-refine and front-rescue lanes across the smoke.

Decision: exact `source_aligned_shape_density_3d` FG-QDM is not promoted. Keep
T87 as negative RTL-native FG-QDM coupling evidence; do not spend on a frozen
eight-design FG-QDM continuation unless the coupling mechanism changes
materially.

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

Seed robustness is now complete and blocks promotion. Across seeds `1001`,
`1002`, and `1003`, classic mean HV is `0.144182` and T83 mean HV is
`0.125986`, a `-12.62%` relative gap. T83 loses all three seed-level mean-HV
comparisons. Removing `Prob135_m2014_q6b` leaves classic at `0.164779` and
T83 at `0.134527`; the RTLLM-only slice is also negative (`0.108504` versus
classic `0.150861`). The preliminary plan therefore remains unfinished: no QD
configuration is currently promoted for final full-RTLLM spend.

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
