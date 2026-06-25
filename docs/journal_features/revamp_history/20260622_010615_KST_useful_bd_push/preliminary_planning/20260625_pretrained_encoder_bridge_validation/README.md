# Pretrained Encoder Bridge Validation

This package continues the encoder-screening plan after the first live `8x5`
screen. The live screen produced hard data for spend-ready custom and
RTL-native QD arms, but it did not finish the pretrained-encoder part of the
plan.

## Verdict

The current plan is not finished. Qwen3 canonical RTL has now been implemented
and live-screened, but it lost the headline Pareto/HV gate. The DeepGate
follow-up bridge is partially unblocked, but it is not ready for a live RTLLM
arm.

Qwen3 was the first true pretrained encoder lane with:

- a working current model-load smoke;
- nonconstant toy RTL embeddings;
- nonconstant generated-candidate RTL embeddings;
- a bounded archive-insertion live smoke;
- positive replay HV evidence from T33.

The matched screen preserved `8/8` coverage but produced mean HV `0.1108`
versus classic `0.1406`, so exact `qwen_canonical_rtl_pca3` is not promoted.

DeepGate and MasterRTL pretrained artifacts are real. DeepGate now has a
noncollapsed generated-AIG subset result, but the current bridge covers only
`2/8` screening problems. AURORA and T36 remain useful encoder-like or learned
lanes, but they are not validated external pretrained encoder arms.

## Package Contents

| Path | Purpose |
| --- | --- |
| `encoder_bridge_validation_report.md` | Main decision report. |
| `commands/model_smoke_commands.md` | Commands used for Qwen3, DeepGate, and MasterRTL checks. |
| `tables/encoder_bridge_status.csv` | Candidate-level pass/block decision table. |
| `tables/model_artifact_inventory.csv` | Checkpoint/model file hashes and pinned commits. |
| `tables/model_smoke_summary.csv` | Current model-load and non-collapse smoke results. |
| `../20260625_deepgate_generated_bridge_probe/` | New generated RTL-to-AIG DeepGate bridge result. |

## Current Spend Decision

Do not launch full RTLLM on the current QD arms as-is. Qwen has already lost
the small screen, and DeepGate needs sequential/large-AIG bridge fixes before
live spending.
