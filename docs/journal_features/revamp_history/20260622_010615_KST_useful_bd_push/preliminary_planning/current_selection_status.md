# Current Selection Status

Status: no QD configuration is currently promoted for the final full-RTLLM
comparison.

## Answer

The preliminary plan is not finished. It has produced hard negative screening
data, including a three-seed replication of the best diagnostic arm, but it has
not identified a QD/MAP-Elites configuration that is strong enough to spend the
full RTLLM budget on as a positive candidate.

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

## Latest RF Gate

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

## Next Gate

Do not run another exact T83 geometry tweak. The next live spend should either
add a materially stronger front-preserving coupling around RF model-state
features, or switch to another validated encoder/BD lane with noncollapse and
classic-like exploitation pressure already documented.
