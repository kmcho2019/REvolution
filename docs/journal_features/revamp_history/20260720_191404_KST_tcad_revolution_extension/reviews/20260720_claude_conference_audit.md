# Claude Conference Audit Review

Date: 2026-07-20

Scope: read-only review of the conference audit, claims contract, hypothesis
registry, conference paper, classic engine, and cited completed evidence.

## Attempts

The first high-effort review used a 600-second hard timeout and returned no
usable output. It is recorded as `TIMED_OUT`, not as evidence of approval.

The narrower retry completed in read-only mode and returned `WARN`.

## Findings And Disposition

| Severity | Finding | Disposition |
| --- | --- | --- |
| REQUIRED | The paper splits populations at simulation correctness, while code requires synthesis, post-synthesis functionality, and valid PPA. | Accepted and verified in current code and repository history. Added a paper/code divergence table. |
| REQUIRED | The paper describes parent preservation, while code excludes old Fail and selects champions from old Success plus offspring. | Accepted and verified back to commit `60c1b69d`, before paper submission. Added the divergence and zero-Success consequence. |
| REQUIRED | The evolutionary-loop `SUPPORTED` label was too broad because only the Llama baseline is an equal-call control. | Accepted. Narrowed support to the single unreplicated Llama comparison. |
| REQUIRED | Related-work collisions lacked version pins and evidence anchors; H1 and COEVO were treated as more identical than established. | Accepted. Pinned six versions, added section anchors, and changed H1 to a novelty hold with a possible reformulation path. |
| OPTIONAL | Negative-map wording sounded like universal refutation. | Accepted. Limited dispositions to comparable mechanism and budget, absent new measured evidence. |
| OPTIONAL | Missing reference PPA can return zero inside the helper. | Accepted. Stated reference completeness as a baseline precondition. |
| OPTIONAL | Record fixed `tau=1` behavior and precise two-parent reward. | Accepted. Added both details. |
| OPTIONAL | Registry and audit disposition need synchronization. | Accepted as clarification. H1-H4 remain `PROPOSED`; terminal decisions occur at proposal review. |

## Reviewer Recommendation

The reviewer recommends classic-only mechanism telemetry, UCB versus fixed
uniform allocation, and a canonical no-C-F reanalysis as non-headline component
work. At most one stage-aware failure card should be drafted after a precise
COEVO delta is established. No candidate should be `READY`.

## Closure Review

The same reviewer rechecked all required and optional dispositions against the
paper, classic engine, and cited local evidence. It returned `PASS` with no
blocking factual, methodological, novelty, or consistency issue.

One non-blocking caveat was accepted: the conference ablation matches 200
independent samples to 10 offspring times 20 generations, but does not account
for REvolution initialization and feedback calls. The audit now calls it
offspring-count-matched rather than fully equal-budget.

## Final Verdict

`PASS`. The conference-method audit gate is closed independently of the still
open baseline and statistical gates. No candidate may become `READY` yet.
