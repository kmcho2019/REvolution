# Encoder Bridge Validation Report

## Answer

The preliminary plan is only partially complete. We completed the spend-ready
live screen, but we have not yet run a live QD arm that actually uses a
validated pretrained encoder.

The best next pretrained candidate is `Qwen3 canonical RTL`. It should be the
next implementation target, not because it is proven live, but because it is
the only pretrained lane with a working model path and positive replay signal.

## Completed Live Screen Context

The registered `8x5` live screen compared classic REvolution against:

- `code_thought_sr_front_slot_8x5`;
- `masterrtl_structural_mix_8x5`.

Classic remained the headline winner:

| Arm | Mean HV | Pareto Points | Ref-Beating | HV Wins |
| --- | ---: | ---: | ---: | ---: |
| `classic_revolution_8x5` | 0.1406 | 3.25 | 8.00 | 7 |
| `code_thought_sr_front_slot_8x5` | 0.1141 | 1.88 | 4.12 | 0 |
| `masterrtl_structural_mix_8x5` | 0.1218 | 2.00 | 5.50 | 1 |

That result rejects those exact QD arms for full RTLLM promotion, but it does
not answer the pretrained-encoder question.

## Current Encoder Status

| Candidate | Status | Evidence | Decision |
| --- | --- | --- | --- |
| Qwen3 canonical RTL | Highest-priority bridge | Current model smoke passes on CUDA with `4x1024` nonconstant toy RTL embeddings. T33 replay showed about `+2.63%` selected-HV gain versus lexical for canonical RTL. | Implement live hook and small screen. |
| DeepGate / DeepGate2 | Model valid, bridge blocked | Official python-deepgate pretrained path works on shipped AIG examples, but generated-candidate DeepGate3 probe had only 3 usable embeddings and pairwise cosine mean `0.999923`. | Fix AIG/export/pooling bridge before live spend. |
| MasterRTL pretrained heads | Model artifacts valid, generated leaves blocked | XGBoost/RF artifacts load in the isolated env. T77 generated-candidate Area-head leaves collapsed to one prediction and one leaf row. | Do not use Area leaves as a BD. Revisit RF/timing only after feature parity. |
| AURORA-style learned BD | Not pretrained | Raw implementation features had `+1.06%` replay HV, but compressed AURORA/PCA/RFF bottlenecks lost. | Use only as a custom learned feature lane. |
| T36 bounded front graph | Encoder-like replay candidate | T36 replay had `+4.04%` HV over lexical and front-hit recovery, but exact T58 live conversion failed. | Redesign live successor; do not rerun exact T58. |

## What Counts As A Valid Pretrained Arm

A pretrained live arm must satisfy all of the following before full RTLLM
budget:

1. Pin upstream source and checkpoint hashes.
2. Load the actual pretrained model, not a surrogate.
3. Reproduce or smoke-test the upstream inference path.
4. Define the exact RTL/netlist preprocessing contract.
5. Produce nonconstant generated-candidate descriptors.
6. Show descriptors are not only problem-id or duplicate clusters.
7. Integrate the descriptor into the live QD archive without using final PPA
   as archive coordinates.

Qwen3 currently satisfies 1-3 for a small smoke and has replay evidence, but
still needs 4-7 in the live path.

## Next Implementation Target

Implement `qd_qwen3_canonical_rtl_8x5` as a small-screen candidate:

- generate canonical RTL text for each candidate;
- embed with `Qwen/Qwen3-Embedding-0.6B` through the isolated Qwen env;
- cache embeddings by text hash;
- project to a fixed descriptor space learned only from non-PPA text
  embeddings;
- emit descriptor-health diagnostics;
- run the same 8-design `8x5` screen before any full RTLLM spend.

DeepGate and MasterRTL pretrained heads should not receive live budget until
their generated-candidate bridge issues are fixed.
