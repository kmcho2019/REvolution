# Hypothesis Registry

| ID | Hypothesis | Conference limitation | Status | Primary metric | Paper role |
| --- | --- | --- | --- | --- | --- |
| H1 | Bottleneck-conditioned strategy adaptation improves PPA search versus global success-rate adaptation. | Strategy adaptation is global and outcome-only. | PROPOSED | Reference-complete HV/HV-AUC | Primary algorithm candidate |
| H2 | Preference-decomposed success populations improve PPA HV versus a single scalar success population. | One scalar objective can collapse PPA tradeoffs; behavior QD is misaligned. | PROPOSED | Reference-complete HV | Primary algorithm candidate |
| H3 | Contract-preserving local patch evolution improves hardened valid-PPA yield without final-HV regression. | Full-design rewrites cause semantic drift and regressions. | PROPOSED | Hardened valid-PPA and HV-AUC | Reliability candidate |
| H4 | The promoted method generalizes from spec-to-RTL generation to optimization of valid suboptimal RTL. | Conference scope is primarily generation-centric. | PROPOSED | Seed-relative PPA gain and functional preservation | Task/generalization contribution |

Allowed status transitions:

`PROPOSED -> READY -> IMPLEMENTED -> SCREENED -> PROMOTED | RETIRED | BLOCKED`
