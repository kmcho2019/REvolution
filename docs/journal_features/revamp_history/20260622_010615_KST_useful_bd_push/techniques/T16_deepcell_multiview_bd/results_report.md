# DeepCell Multiview BD Results Report

Status: `T0 retrospective_multiview_proxy_not_promoted`.

## Answer

The branch has not reproduced DeepCell. The measured multiview proxy evidence
does not justify full-RTLLM spend.

Replay evidence:

- T14 hypergraph plus implementation features reaches HV `3.739236`, a
  `+1.01%` replay gain over lexical.
- Hypergraph-only views broaden some PPA counts but lose HV.
- T14 hybrid still keeps fewer direct front hits than lexical (`119` versus
  `122`).

Live evidence:

- T95 official DeepGate reaches mean HV `0.1153` versus classic `0.1406`.
- T96 RF/DeepGate hybrid reaches mean HV `0.1199` versus classic `0.1406`.
- T99 implementation-view archive reaches mean HV `0.1201` versus classic
  `0.1406`.

## Evidence Matrix

The compact source table is `tables/t16_multiview_proxy_evidence.csv`.

| Source | View | Useful Signal | Blocking Signal |
| --- | --- | --- | --- |
| T14 | Directed hypergraph + implementation | Hybrid replay beats lexical HV by `+1.01%`. | Direct front hits trail lexical. |
| T95 | Official DeepGate AIG/cone | Delayed high-exploit improves over T94. | Classic wins mean HV and front breadth. |
| T96 | RF timing + branching + DeepGate | Hybrid improves over pure DeepGate. | Classic and T83 RF-only remain stronger. |
| T99 | Raw implementation view | Best live raw implementation representative. | Classic wins mean HV and Pareto breadth. |

## Decision

Do not spend on exact deterministic multiview proxy axes. The live proxy
evidence says simple view concatenation is not enough.

Reopen only with paired post-mapping cell-view plus AIG-view extraction,
masked multiview training, or a secondary/reporting use that improves
front creation without becoming the main parent-selection pressure.
