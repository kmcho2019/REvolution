# NetTAG Text-Graph BD Results Report

Status: `T0 retrospective_text_graph_proxy_not_promoted`.

## Answer

The text/graph lane has real signal, but the current branch has not produced a
promoted live text-graph BD.

Replay positives:

- T33 canonical RTL and identifier-role RTL Qwen views beat lexical selected
  HV by about `+2.63%`.
- T36 T11 graph descriptors with one bounded local-front slot reach selected
  HV `3.851344`, a `+4.04%` replay gain versus lexical, and recover direct
  front hits to `126`.

Live blockers:

- T58 moves frozen T11-PCA4 graph coordinates into a T51-style live archive and
  loses classic on mean HV (`0.076253` versus `0.092601`), HV-AUC, front
  points, unique PPA points, and reference-beating candidates.
- T96 adds an official DeepGate pooled netlist axis to RF model-state and
  source branching, improving pure DeepGate (`0.1199` versus `0.1153`) but
  still losing classic (`0.1406`) and regressing versus T83 (`0.1369`).

## Evidence Matrix

The compact evidence table is `tables/t09_text_graph_proxy_evidence.csv`.

| Source | Useful Signal | Blocking Signal |
| --- | --- | --- |
| T33 | RTL Qwen views beat lexical selected HV by about `+2.63%`; netlist views reduce same-problem collapse. | Netlist views that best reduce collapse lose selected HV; RTL views remain problem-clustered. |
| T36 | T11 graph plus one front lane beats lexical and fitness-top selected HV in replay. | Replay only; not a live QD/MAP-Elites proof. |
| T58 | Graph-coordinate archive preserves classic-covered designs and adds `+9` valid PPA samples. | Mean HV drops to `0.076253` versus classic `0.092601`; front material regresses. |
| T96 | RF/DeepGate hybrid improves pure DeepGate mean HV. | Classic and T83 both remain stronger; front breadth and valid-yield warnings block promotion. |

## Decision

Do not spend on exact primary text-graph archive coordinates. The branch
already tested the main cheap proxy path: text embeddings, graph replay
descriptors, live graph-coordinate archive pressure, and a graph/netlist
hybrid. The live evidence says those signals do not yet create enough PPA-front
material.

Reopen this lane only with a true text-attributed graph model, a secondary
archive that does not steer most LLM calls, or a front-rescue/source-selection
mechanism that logs graph-text memory contribution per generated child.
