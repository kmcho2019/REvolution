# REvolution TCAD Extension Program History

Record program-level decisions, candidate state transitions, baseline hashes,
final-suite freezes, integration choices, paper-claim changes, and blockers.
Candidate-specific commands and results belong in each candidate history.

## Session start

- Branch:
- HEAD:
- Dirty state:
- Toolchain:
- Model/API configuration hash:
- Baseline artifact root:
- Development manifest hash:
- Holdout manifest hash:
- Final manifest hash:

## Decision log

| Date | Decision | Evidence | Consequence |
| --- | --- | --- | --- |
| 2026-07-20 | Import the supplied program bundle as `PROPOSED`, flatten its program files to the goal root, and do not activate it yet. | Source ZIP SHA-256 `88a931485fa38f90cee7a4e804950a594c43c2900907067794191ab87e4f3d09`; `intake_review.md`. | Candidate ideas remain unchanged pending claims, novelty, and gate review. |
| 2026-07-20 | Reframe the scaffold as an audit-driven, bounded discovery program rather than a fixed H1-H4 execution queue. | Owner direction; completed QD/Pareto negative map; revised plan and draft claims contract. | The program now distinguishes PAPER_CANDIDATE, VIABLE, RETIRED, and BLOCKED candidates; uses sequential waves; and finishes JOURNAL_READY, PORTFOLIO_READY, or PIVOT_REQUIRED. Live experiments remain on hold pending contract acceptance and baseline freeze. |

## Scaffold Revision Review

- Reviewer: external Claude Code 2.1.215, read-only plan mode, high effort.
- Scope: complete scaffold diff and current directory; no implementation files.
- Verdict: `WARN`; no `FAIL`-level contradiction.
- Accepted findings: require full-suite evidence for `VIABLE`; preregister
  development-disjoint confirmation seeds and the statistical method; audit
  holdout eligibility; reconcile program resource ceilings; confront retired
  single-thought evidence; align W/L/T, state, and H4 terminology.
- Accepted cleanup: make the shared candidate contract canonical and shorten the
  four repeated candidate goal templates.
- Deferred observation: root plan, TODO, and launch template necessarily repeat
  a small amount of workflow because they serve charter, tracking, and launch
  roles. Cross-document consistency is checked before activation.
- Follow-up review: external Claude Code 2.1.215 re-read the revised scaffold and
  returned `PASS` with every prior required finding resolved. Its remaining
  non-blocking observations were to expose practical margins/metric floors
  directly in the manifest, which was accepted, and to migrate H1-H4 into the
  canonical hypothesis template before `READY`, which is already enforced by
  the candidate contract because those files remain `PROPOSED` seed sketches.
- Activation decision: the owner approved the revised workflow and directed the
  root goal to launch on a dedicated branch. `program_claims_contract.md`
  revision 1 now governs discovery and candidate evidence. The goal may perform
  the audit and baseline setup immediately; live candidate experiments remain
  blocked until the intake pre-live gates are frozen.
