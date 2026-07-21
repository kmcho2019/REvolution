# Hypothesis Registry

The registry is a living index, not an execution queue. Add audit-derived ideas
before implementation and link every terminal decision.

| ID | Class | Hypothesis | Conference weakness | Intended role | State | Outcome |
| --- | --- | --- | --- | --- | --- | --- |
| H1 | CORE_CORRECTION | Bottleneck-conditioned strategy adaptation improves search over global success adaptation. | Strategy adaptation is global and outcome-only. | PRIMARY_ALGORITHM | RETIRED | RETIRED |
| H2 | CORE_CORRECTION | Preference-decomposed success populations improve final PPA HV over one scalar success population. | Scalar ranking can collapse PPA tradeoffs. | PRIMARY_ALGORITHM | RETIRED | RETIRED |
| H3 | AUGMENTATION | Contract-preserving local patch evolution improves valid-PPA yield without final-HV regression. | Broad rewrites can cause semantic drift. | RELIABILITY | RETIRED | RETIRED |
| H4 | AUGMENTATION | A confirmed algorithmic paper candidate generalizes to optimization of valid suboptimal RTL. | Conference scope is generation-centric. | GENERALIZATION | PROPOSED | PENDING |
| H5 | CORE_CORRECTION | M-F-only failed-pool routing improves unconditional valid-PPA repair count and preserves final PPA search. | Failed candidates share five intents despite a dedicated correction operator and short horizon. | PRIMARY_ALGORITHM | SUITE_EVALUATED | RETIRED |
| H8 | CORE_CORRECTION | Retaining failed candidates by verification stage improves repair continuity. | Classic discards old failed lineages and scalarizes every failure to `-inf`. | RELIABILITY | RETIRED | RETIRED |
| H9 | CORE_CORRECTION | Strict parent-relative deltas improve offspring validity without harming final PPA search. | Whole-output edit breadth is negatively associated with valid-PPA yield for successful-parent refinement. | PRIMARY_ALGORITHM | RETIRED | RETIRED |
| H10 | CORE_CORRECTION | Preserving typed terminal status alongside critic analysis broadens fail-origin valid-PPA repair. | Classic uses terminal status for pools but omits it from ordinary parent memory; critic artifacts often disagree with it. | RELIABILITY | IMPLEMENTED | PENDING |

Allowed progression states:

`PROPOSED -> READY -> IMPLEMENTED -> SMOKE_VALIDATED -> SUITE_EVALUATED`

A nominated finalist then enters `CONFIRMING`. Proposal review may move directly
from `PROPOSED` to `RETIRED`; external blockers may occur from any state.

Allowed terminal outcomes:

`PAPER_CANDIDATE | VIABLE | RETIRED | BLOCKED`

New IDs must represent distinct mechanisms derived from
`conference_method_audit.md`. Parameter values and combinations do not receive
new IDs unless an independent mechanism and rationale are stated.

H9 was Wave 2's first reviewed mechanism. It retired before implementation or
live spend because global diff evolution has a direct related-work collision
and the classic evidence reverses for failed-parent repair. See
`../candidates/H9_strict_delta_evolution/decision.md`.

H10 is Wave 2's second reviewed mechanism. Its one-line terminal-state
invariant passed scientific, evidence, exact-card, code-boundary, and runtime
reviews. It is `IMPLEMENTED`, and its tracked implementation manifest now
uses corrected v8 rebinding after a pre-admission provenance block. Final
smoke-admission review passes; admission, smoke, and suite evidence remain
open. CVDP confirmation is blocked pending a prospective evaluator composition.

## Evidence Outside The Candidate State Machine

| ID | Item | Classification | Reason |
| --- | --- | --- | --- |
| H6 | Remove C-F from successful-parent evolution. | `HISTORICAL_SUPPORT` | Completed matched evidence is informative, but current seed roles and gates were assigned after outcomes existed. |
| H7 | Replace UCB with uniform operator allocation. | `DEFERRED_DIAGNOSTIC` | Low novelty and no hardware grounding; aggregate pulls are already near uniform. |
