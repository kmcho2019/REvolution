# CircuitFusion Multimodal BD Results Report

Status: `T0 retrospective_multimodal_proxy_not_promoted`.

## Answer

The branch has not reproduced CircuitFusion. The measured multimodal proxy
evidence is negative for full-RTLLM promotion.

The closest live hybrid is T96 RF/DeepGate:

- mean HV `0.1199` versus classic `0.1406`;
- mean Pareto points `1.625` versus classic `3.25`;
- improves over pure DeepGate T95 (`0.1153`) but regresses versus T83 RF-only
  same-seed (`0.1369`).

T99 raw implementation features are also below classic:

- mean HV `0.1201` versus classic `0.1406`;
- mean Pareto points `2.00` versus classic `3.25`;
- useful as the AURORA/raw category representative, not as a promoted method.

## Evidence Matrix

The compact source table is `tables/t10_multimodal_proxy_evidence.csv`.

| Source | Modalities | Useful Signal | Blocking Signal |
| --- | --- | --- | --- |
| T33 | RTL/netlist text | Canonical RTL Qwen views beat lexical selected HV by about `+2.63%`. | Netlist views reduce collapse but lose selected HV. |
| T95 | Official DeepGate netlist graph | Delayed high-exploit improves over T94 (`0.1153` versus `0.1040`). | Classic still wins mean HV `0.1406` and front breadth. |
| T96 | RF timing state + RTL structure + DeepGate | Hybrid improves over pure T95 DeepGate. | Loses classic and regresses versus T83 RF-only. |
| T99 | Raw implementation structure | Stronger than Qwen and pure DeepGate by mean HV. | Loses classic mean HV and Pareto breadth. |

## Decision

Do not spend on exact primary multimodal proxy axes. The current evidence says
plain fusion of existing text, graph, RTL-native, and implementation axes does
not recover enough PPA-front material.

Reopen only if the branch adds a real functional-sketch modality, trains a
non-PPA cross-modal objective, or uses multimodal descriptors as a guarded
secondary memory/reporting signal rather than the main archive coordinate.
