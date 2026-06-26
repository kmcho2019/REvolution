# NetTAG Text-Graph BD Methodology

## Intent

Adapt text-attributed graph netlist modeling to RTL evolution. The intended
method uses gate graph structure plus short textual attributes so it can
capture operator and Boolean-expression context without relying only on raw RTL
embeddings.

This completed T09 package is a retrospective proxy audit. It does not claim a
true NetTAG model. It uses measured text, graph, and graph/netlist hybrid
evidence already produced on this branch.

## Completed Proxy Scope

The proxy evidence covers four related surfaces:

- T33 Qwen3 preprocessing ladder over canonical RTL, identifier-role RTL,
  canonical Yosys netlists, and summary-plus-netlist text views.
- T36 T11 graph-contrastive replay with a bounded local-front lane.
- T58 live T51 plus frozen T11-PCA4 graph-coordinate archive.
- T96 hybrid RF/DeepGate descriptor combining MasterRTL RF model-state,
  source-aligned branching, and official DeepGate pooled netlist signal.

This scope tests whether text and graph representations produce useful BD
signals, and whether those signals survive when moved from replay into live
archive pressure. It does not validate a learned text-attributed graph model.

## Leakage Limits

The summarized descriptor inputs exclude final PPA, reference PPA, fitness,
hypervolume, Pareto labels, and test pass labels. PPA is used only for offline
replay scoring, matched comparison, and tier decisions.

## Evaluated Descriptor Families

| Family | Evidence | Read |
| --- | --- | --- |
| Text-only and text-plus-netlist | T33 Qwen3 preprocessing ladder | RTL views improve replay selected HV, while netlist views reduce collapse but lose selected HV. |
| Graph-only replay | T36 T11 bounded front lane | Strong replay candidate that beats lexical and fitness-top selected HV. |
| Graph-coordinate live archive | T58 T51 T11-PCA4 front-slot QD | Live graph archive loses classic/T51 on HV and front breadth. |
| Graph/netlist hybrid | T96 RF/DeepGate delayed QD | Hybrid improves pure DeepGate but regresses versus T83 and trails classic. |

## Archive Implication

Text/graph descriptors should not be used as the primary live archive geometry
without a new mechanism. The better next use is secondary reporting,
front-rescue memory, or a trained objective that proves graph-text cells
produce valid-PPA and front-adding children.
