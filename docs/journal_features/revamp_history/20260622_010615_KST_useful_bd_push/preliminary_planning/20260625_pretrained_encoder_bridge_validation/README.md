# Pretrained Encoder Bridge Validation

This package continues the encoder-screening plan after the first live `8x5`
screen. The live screen produced hard data for spend-ready custom and
RTL-native QD arms, but it did not finish the pretrained-encoder part of the
plan.

## Verdict

The current plan is not finished. The next candidate to implement for live
screening is Qwen3 canonical RTL, because it is the only true pretrained
encoder lane with:

- a working current model-load smoke;
- nonconstant toy RTL embeddings;
- positive replay HV evidence from T33.

DeepGate and MasterRTL pretrained artifacts are real, but their generated-RTL
bridges are not spend-ready. AURORA and T36 remain useful encoder-like or
learned lanes, but they are not validated external pretrained encoder arms.

## Package Contents

| Path | Purpose |
| --- | --- |
| `encoder_bridge_validation_report.md` | Main decision report. |
| `commands/model_smoke_commands.md` | Commands used for Qwen3, DeepGate, and MasterRTL checks. |
| `tables/encoder_bridge_status.csv` | Candidate-level pass/block decision table. |
| `tables/model_artifact_inventory.csv` | Checkpoint/model file hashes and pinned commits. |
| `tables/model_smoke_summary.csv` | Current model-load and non-collapse smoke results. |

## Current Spend Decision

Do not launch full RTLLM on the current QD arms as-is. First implement and run
a small live Qwen3 canonical-RTL descriptor hook, then compare it against
classic and the best custom/RTL-native controls on the same screening subset.
