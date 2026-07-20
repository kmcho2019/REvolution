# Hypothesis Registry

The registry is a living index, not an execution queue. Add audit-derived ideas
before implementation and link every terminal decision.

| ID | Class | Hypothesis | Conference weakness | Intended role | State | Outcome |
| --- | --- | --- | --- | --- | --- | --- |
| H1 | CORE_CORRECTION | Bottleneck-conditioned strategy adaptation improves search over global success adaptation. | Strategy adaptation is global and outcome-only. | PRIMARY_ALGORITHM | PROPOSED | PENDING |
| H2 | CORE_CORRECTION | Preference-decomposed success populations improve final PPA HV over one scalar success population. | Scalar ranking can collapse PPA tradeoffs. | PRIMARY_ALGORITHM | PROPOSED | PENDING |
| H3 | AUGMENTATION | Contract-preserving local patch evolution improves valid-PPA yield without final-HV regression. | Broad rewrites can cause semantic drift. | RELIABILITY | PROPOSED | PENDING |
| H4 | AUGMENTATION | A confirmed algorithmic paper candidate generalizes to optimization of valid suboptimal RTL. | Conference scope is generation-centric. | GENERALIZATION | PROPOSED | PENDING |

Allowed progression states:

`PROPOSED -> READY -> IMPLEMENTED -> SMOKE_VALIDATED -> SUITE_EVALUATED`

A nominated finalist then enters `CONFIRMING`. Proposal review may move directly
from `PROPOSED` to `RETIRED`; external blockers may occur from any state.

Allowed terminal outcomes:

`PAPER_CANDIDATE | VIABLE | RETIRED | BLOCKED`

New IDs must represent distinct mechanisms derived from
`conference_method_audit.md`. Parameter values and combinations do not receive
new IDs unless an independent mechanism and rationale are stated.
