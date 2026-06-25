# Preliminary Planning Index

This directory holds pre-run planning packages for choosing QD/MAP-Elites
configurations before spending full RTLLM budget.

## Packages

| Package | Purpose | Status |
| --- | --- | --- |
| `20260625_encoder_config_screening/` | Shortlist pretrained-encoder, encoder-like, RTL-native, and custom-BD candidates for the next RTLLM comparison. | Completed first live screen; exact tested QD arms not promoted |
| `20260625_pretrained_encoder_bridge_validation/` | Validate whether pretrained and encoder-like lanes are real enough to spend live RTLLM budget. | Active; Qwen3 is the next live-hook candidate |
| `20260625_qwen_live_screen_probe/` | Probe Qwen3 canonical-RTL embeddings on the completed live-screen candidate corpus before implementing a live QD hook. | Completed probe; embeddings are nonconstant but strongly same-problem clustered |

## Current Rule

Only configurations with a working live descriptor path enter an expensive
screening run. Replay-positive encoder lanes stay in the package as bridge
work until they have a verified runtime hook and non-collapse checks.

The current pretrained-encoder rule is stricter: an external model must load
from pinned checkpoints, pass an upstream or fixture smoke, and show
nonconstant generated-candidate descriptors before it can be called a live
pretrained-BD arm.

The Qwen3 generated-candidate probe passes the nonconstant-output gate, but
its nearest-neighbor graph is almost entirely same-problem. A live Qwen arm
therefore still needs explicit descriptor-health reporting and should not be
promoted to full RTLLM from replay evidence alone.
