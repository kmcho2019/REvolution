# Preliminary Planning Index

This directory holds pre-run planning packages for choosing QD/MAP-Elites
configurations before spending full RTLLM budget.

## Packages

Start with `current_selection_status.md` for the current promotion decision and
the next gate.

| Package | Purpose | Status |
| --- | --- | --- |
| `20260625_encoder_config_screening/` | Shortlist pretrained-encoder, encoder-like, RTL-native, and custom-BD candidates for the next RTLLM comparison. | Completed Qwen-inclusive live screen; no screened QD arm promoted |
| `20260625_pretrained_encoder_bridge_validation/` | Validate whether pretrained and encoder-like lanes are real enough to spend live RTLLM budget. | Active; Qwen3 is the next live-hook candidate |
| `20260625_qwen_live_screen_probe/` | Probe Qwen3 canonical-RTL embeddings and bridge them into a live QD descriptor hook. | Probe, smoke, and matched screen complete; not promoted as-is |
| `20260625_deepgate_generated_bridge_probe/` | Re-test official DeepGate2 embeddings on generated RTL-derived AIGs after Qwen lost the live screen. | Partially unblocked; embeddings are nonconstant on 24 rows, but only 2/8 problems cover |
| `20260625_deepgate_transition_bridge_probe/` | Test state-as-input transition AIG abstraction for sequential DeepGate coverage. | Corrected bridge embeds 60 rows across 5/8 problems; not promoted |
| `20260625_masterrtl_front_slot_probe/` | Test whether the closest MasterRTL structural-mix live arm improves when explicit front-slot parent sampling is enabled. | Completed; small diagnostic gain over MasterRTL mix, still trails classic and not promoted |
| `20260625_t11_top4_front_slot_probe/` | Test raw T11 top-4 runtime graph axes with the conservative front-slot parent lane as a T36/T58 successor. | Completed; trails classic and MasterRTL front-slot, not promoted |
| `20260625_aux_archive_high_exploit_probe/` | Test whether QD archive memory works better as an auxiliary side channel with classic-like exploitation pressure. | Completed; best screened QD by mean HV, still not promoted |
| `20260625_aux_archive_front_breadth_probe/` | Test whether the best-HV auxiliary archive arm can recover Pareto breadth with bounded front-slot sampling. | Completed; front-breadth tax erased the high-exploit HV gain, not promoted |
| `20260625_aux_archive_high_exploit_depth_probe/` | Test whether the high-exploit auxiliary archive mechanism benefits from `6x7` depth against the existing T79 classic `6x7` baseline. | Completed; depth helps classic more than QD, not promoted |
| `20260625_aux_archive_seed_replication_gate/` | Replicate classic and high-exploit auxiliary archive at seeds `1002` and `1003` to measure noise and the `Prob135_m2014_q6b` robustness caveat. | Completed; negative, not promoted |
| `20260626_aux_archive_adaptive_sparse_front_probe/` | Test adaptive sparse-front parent pressure after fixed high-exploit auxiliary archive failed seed replication. | Completed; trigger fired, but HV regressed and not promoted |
| `20260626_delayed_archive_activation_probe/` | Test whether passive early archive logging plus delayed archive pressure preserves classic-like hill climbing before QD activation. | Completed; close to high-exploit, still below classic and not promoted |
| `20260626_archive_stagnation_activation_probe/` | Test whether archive pressure should activate only after passive archive cells and members stop growing. | Completed; trigger fired lightly, but HV regressed and not promoted |
| `20260626_masterrtl_rf_timing_state_gate/` | Record the T81 MasterRTL pretrained RF timing model-state gate and decide whether it is ready for a live hook. | Completed offline; positive non-collapse gate, not a live QD result |
| `20260626_masterrtl_rf_timing_runtime_hook/` | Record the T82 runtime hook that exposes RF timing model-state metrics as a live descriptor profile. | Completed implementation gate; superseded by live smoke and screen |
| `20260626_masterrtl_rf_timing_live_smoke/` | Run the first one-problem live smoke for `source_aligned_rf_timing_state_3d`. | Completed; one valid PPA/archive member, superseded by completed screen |
| `20260626_masterrtl_rf_timing_state_screen/` | Run the frozen eight-design `8x5` screen for the validated MasterRTL RF timing-state descriptor profile. | Completed; all eight headline-paired comparisons valid, but classic wins mean HV and front metrics |
| `20260626_rf_leafid_structural_delayed_probe/` | Test RF timing leaf-ID model-state as a secondary coordinate beside source-aligned structural axes and delayed archive activation. | Completed; near-classic all-design mean HV, but RTLLM-only and robustness checks block promotion |
| `20260626_rf_leafid_front_slot_delayed_probe/` | Test whether T83's RF leaf-ID axes recover front material with bounded local front-slot parent sampling. | Pre-registered; endpoint preflight and descriptor probe passed |

## Current Rule

Only configurations with a working live descriptor path enter an expensive
screening run. Replay-positive encoder lanes stay in the package as bridge
work until they have a verified runtime hook and non-collapse checks.

The preliminary plan now has a completed three-seed gate for the best
diagnostic arm, but it is still not finished enough to choose final
full-RTLLM QD configs. The periodic 2026-06-25 Claude review recorded
`PASS_WITH_ACTIONS`: the package is honest, but every screened QD arm still
loses classic. The seed-replication gate confirmed that warning. Classic wins
all three seed-level mean-HV comparisons against
`masterrtl_aux_archive_high_exploit_8x5`; the three-seed mean HV is `0.1442`
for classic versus `0.1261` for auxiliary archive, a `-12.51%` relative gap.
Removing `Prob135_m2014_q6b` leaves a `-18.25%` relative gap. The next
adaptive sparse-front decision gate is now complete and negative. It used the
existing `sparse_front_triggered_nsga2` parent selector to lower champion
pressure only when local archive fronts were thin. The trigger fired on three
RTLLM problems, but mean HV regressed to `0.0946` versus classic `0.1406`.

The current pretrained-encoder rule is stricter: an external model must load
from pinned checkpoints, pass an upstream or fixture smoke, and show
nonconstant generated-candidate descriptors before it can be called a live
pretrained-BD arm.

The Qwen3 generated-candidate probe passes the nonconstant-output gate, and
the live hook now inserts a Qwen descriptor archive member in a bounded smoke.
Its nearest-neighbor graph is still almost entirely same-problem. The matched
`8x5` screen completed with `8/8` problem coverage, but Qwen mean HV
(`0.1108`) trailed classic (`0.1406`), so it is not a full-RTLLM arm as-is.

The DeepGate generated bridge probe now shows a stronger diagnostic signal than
the old three-sample collapsed probe: `24` generated rows embed with pairwise
cosine mean `0.9318`. It is still not spend-ready because the bounded
latch-free AIG policy covers only `2/8` screening problems.

Transition abstraction can rewrite sequential AIGs into latch-free one-cycle
transition logic. After canonical renumbering and constant repair, it embeds
`60` rows across `5/8` screening problems with pairwise cosine mean `0.9213`.
It still misses the largest designs, so the next DeepGate escalation should
use cone extraction, caching, or a faster graph converter.

The MasterRTL front-slot follow-up completed the frozen eight-design `8x5`
screen as `masterrtl_structural_front_slot_8x5`. It improved mean HV slightly
over plain MasterRTL structural mix (`0.1227` versus `0.1218`) and improved
mean reference-beating candidates (`6.62` versus `5.50`), but classic remains
ahead on mean HV (`0.1406`) and Pareto breadth (`3.25` versus `1.75`). It is
not a final-RTLLM candidate as-is.

The T11 top-4 front-slot follow-up completed the same screen as
`t11_runtime_top4_front_slot_8x5`. It avoids exact T58's PCA4 geometry but
still trails classic on mean HV (`0.1208` versus `0.1406`), Pareto breadth
(`1.88` versus `3.25`), and HV wins (`0` versus `6`). It is diagnostic, not a
full-RTLLM candidate.

`masterrtl_aux_archive_high_exploit_8x5` completed the frozen screen and then
the seed-replication gate. It keeps MasterRTL structural archive cells active,
but lowers forced fill pressure and samples parents by global NSGA-II rank with
a high champion lane. The single-seed screen made it the closest QD arm by
mean HV (`0.1339` versus classic `0.1406`), but replication does not support
promotion: across seeds `1001`, `1002`, and `1003`, auxiliary archive loses
all three seed-level mean-HV comparisons and averages `0.1261` versus classic
`0.1442`.

`masterrtl_aux_archive_front_breadth_8x5` completed the same frozen screen.
It keeps the same descriptor and low forced-fill setup, but lowers champion
pressure to `0.80` and adds a `0.20` front-slot lane. This did not preserve the
high-exploit HV signal: mean HV fell to `0.1134` versus classic `0.1406` and
high-exploit auxiliary archive `0.1339`. It improves mean Pareto points over
the high-exploit variant (`2.125` versus `1.75`), but still trails classic
(`3.25`) and is not promoted.

`masterrtl_aux_archive_high_exploit_6x7` completed the identical eight-design
screen against T79's matched `classic_revolution_6x7` baseline. Depth does not
rescue the high-exploit auxiliary archive mechanism: QD mean HV is `0.1229`
versus matched classic `0.1701`, and it also trails the earlier high-exploit
`8x5` QD arm (`0.1339`).

`masterrtl_aux_archive_adaptive_sparse_front_8x5` completed the frozen screen
after seed replication retired fixed high-exploit geometry. The sparse-front
trigger fired on `Prob015_multi_pipe_8bit`, `Prob041_traffic_light`, and
`Prob045_alu`, so the mechanism was exercised. It still fails promotion:
mean HV is `0.0946` versus classic `0.1406`, though mean Pareto points improve
over fixed high-exploit (`2.38` versus `1.75`).

`masterrtl_delayed_archive_activation_8x5` completed the frozen screen. It
delays archive-driven fill, backfill, and failure pressure until generation
`3`, while still passively logging descriptor/archive state from the start.
Mean HV is `0.1324` versus classic `0.1406`, with mean Pareto points `2.00`
and mean reference-beating candidates `6.00`. It is close to fixed
high-exploit but still outside the registered promotion tolerance.

`masterrtl_archive_stagnation_activation_8x5` completed the frozen screen. It
replaces the fixed generation trigger with a scheduler-visible archive-health
trigger: activate QD pressure only after two consecutive archive-history
intervals show no occupied-cell or archive-member growth. The trigger fired on
`3/8` problems and `7/49` archive-history rows, but the arm regressed to mean
HV `0.1089` versus classic `0.1406`. It is diagnostic negative and not
promoted. Do not spend another run on this simple MasterRTL auxiliary archive
timing family without a materially different mechanism.

The current materially different lane is now live-smoke unblocked:
`20260626_masterrtl_rf_timing_live_smoke/` ran
`source_aligned_rf_timing_state_3d` on `Prob015_multi_pipe_8bit` with a `2x0`
budget. It produced one valid PPA candidate, one archive member, `51` RF
timing paths, `17` unique RF leaf rows, and `319` unique RF leaf IDs. This is
not a PPA comparison and cannot establish non-collapse by itself because it
has one archive observation. It authorizes the frozen `8x5` screen, not final
RTLLM spend.

That frozen `8x5` screen is now complete in
`20260626_masterrtl_rf_timing_state_screen/`. It is a valid headline-paired
comparison, not a missing-reference artifact: both methods have valid PPA
candidates on all eight designs. The result is negative for this exact
descriptor profile. Mean HV is `0.1140` for RF timing QD versus `0.1406` for
classic, mean Pareto points are `2.00` versus `3.25`, and RF timing QD wins
only `2/8` HV comparisons. Do not promote `source_aligned_rf_timing_state_3d`
as-is to full RTLLM spend.

`masterrtl_rf_leafid_structural_delayed_8x5` completed the frozen screen. It
keeps the validated RF timing model path but replaces the collapsed
`path_count` axis with `source_aligned_rf_timing_leaf_ids`, pairs it with
MasterRTL branching and RTLTimer wire density, and uses delayed archive
activation. This is the closest recent pretrained-model-state screen by
all-design mean HV (`0.1369` versus classic `0.1406`), but it is not promoted.
The result depends heavily on `Prob135_m2014_q6b`: excluding that problem gives
a `-20.29%` mean-HV gap, and the RTLLM-only slice remains clearly negative.

The next registered gate is
`20260626_rf_leafid_front_slot_delayed_probe/`. It keeps T83's descriptor axes
and delayed archive activation, but changes parent selection to
`front_slot_lane_nsga2` with a `0.20` local front-slot lane and `0.80`
champion lane. This directly tests whether T83's front-breadth failure is a
coupling problem before spending on any full RTLLM comparison.
