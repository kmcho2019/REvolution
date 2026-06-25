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
| `20260625_deepgate_transition_bridge_probe/` | Test state-as-input transition AIG abstraction for sequential DeepGate coverage. | Export coverage improves, but official parser remains too slow |

## Current Rule

Only configurations with a working live descriptor path enter an expensive
screening run. Replay-positive encoder lanes stay in the package as bridge
work until they have a verified runtime hook and non-collapse checks.

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
transition logic, but full-design transition AIGs still hit the official
DeepGate parser's topological-sort bottleneck. The next DeepGate escalation
should use cone extraction or a faster graph converter.
