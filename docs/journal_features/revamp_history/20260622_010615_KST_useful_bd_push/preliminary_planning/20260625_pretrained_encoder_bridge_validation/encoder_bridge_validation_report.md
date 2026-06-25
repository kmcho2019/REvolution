# Encoder Bridge Validation Report

## Answer

The preliminary plan is only partially complete. We completed the spend-ready
live screen and the first true pretrained Qwen3 live arm, but no pretrained
encoder configuration has cleared the full-RTLLM promotion gate.

The best current pretrained follow-up is the DeepGate bridge, not a live run:
the official DeepGate2 model is valid and now embeds a bounded generated-AIG
subset without trivial collapse, but coverage is too narrow.

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
| Qwen3 canonical RTL | Live-screened, not promoted | Current model smoke passes on CUDA with `4x1024` nonconstant toy RTL embeddings. The generated-candidate probe produced `540 x 1024` embeddings over `424` unique canonical RTL hashes. The matched `8x5` screen preserved coverage but lost mean HV: `0.1108` versus classic `0.1406`. | Do not promote exact `qwen_canonical_rtl_pca3` as-is. |
| DeepGate / DeepGate2 | Model valid, bridge partially unblocked | Official python-deepgate pretrained path works on shipped AIG examples. The generated bridge probe embeds `24` bounded AIG rows with pairwise cosine mean `0.9318`, all four backends represented, and `2/8` problems covered. The transition smoke improves sequential AIG export but blocks in parser topological sorting. | Fix sequential cone extraction or parser scalability before live spend. |
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

Qwen3 satisfies the implementation gate but fails the small-screen promotion
gate. DeepGate satisfies the model and partial generated-noncollapse gates,
but fails generated-candidate coverage.

## Next Implementation Target

Do not launch another expensive live arm yet. The next DeepGate target should
be a bridge-only fix:

- handle sequential designs by cone extraction or an explicit state policy;
- handle `Prob045_alu`-scale AIGs with a faster parser or a tighter graph
  summary;
- compare DeepGate embeddings against simple AIG statistics on the same rows.

DeepGate and MasterRTL pretrained heads should not receive live budget until
their generated-candidate bridge issues are fixed.
