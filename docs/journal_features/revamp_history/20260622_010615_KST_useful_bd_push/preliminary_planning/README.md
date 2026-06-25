# Preliminary Planning Index

This directory holds pre-run planning packages for choosing QD/MAP-Elites
configurations before spending full RTLLM budget.

## Packages

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
| `20260625_aux_archive_seed_replication_gate/` | Replicate classic and high-exploit auxiliary archive at seeds `1002` and `1003` to measure noise and the `Prob135_m2014_q6b` robustness caveat. | Preregistered |

## Current Rule

Only configurations with a working live descriptor path enter an expensive
screening run. Replay-positive encoder lanes stay in the package as bridge
work until they have a verified runtime hook and non-collapse checks.

The preliminary plan is not finished enough to choose final full-RTLLM QD
configs. The periodic 2026-06-25 Claude review recorded
`PASS_WITH_ACTIONS`: the package is honest, but every screened QD arm still
loses classic, all current screens are single-seed, and the best auxiliary
archive aggregate is dominated by `Prob135_m2014_q6b`. The next decision gate
is seed replication of classic plus the auxiliary high-exploit arm and a
genuinely adaptive archive-pressure mechanism, not another minor MasterRTL
geometry tweak.

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

`masterrtl_aux_archive_high_exploit_8x5` completed the frozen screen. It keeps
MasterRTL structural archive cells active, but lowers forced fill pressure and
samples parents by global NSGA-II rank with a high champion lane. This is the
best screened QD arm by mean HV (`0.1339` versus classic `0.1406`), but it
still fails promotion because it is about `4.78%` behind classic and loses
Pareto breadth (`1.75` versus `3.25`) plus reference-beating candidates (`4.00`
versus `8.00`).

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
