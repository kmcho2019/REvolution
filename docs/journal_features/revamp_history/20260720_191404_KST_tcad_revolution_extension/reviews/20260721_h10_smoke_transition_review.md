# H10 Smoke Transition Review

Date: 2026-07-21

Reviewer: read-only `claude -p --permission-mode plan --effort high` run with a
600-second timeout.

Verdict: `PASS_FOR_SMOKE_TRANSITION`.

## Accepted Findings

- The four smoke ledger events and transition documents must enter a clean,
  signed commit before any full-suite admission.
- The independent raw-evidence audit must be recorded before advancing the
  living registry. It returned `PASS_FOR_SMOKE_VALIDATION`.
- No full-suite runbook is frozen. It must preserve exact
  admit/run/seal/account/record ordering and assert literal `PASS` after every
  admission command before `seed_1001_classic` can launch.
- The smoke licenses technical feasibility only. Its single-design repair
  signal is deletion-fragile and has no efficacy or generalization force.
- Treatment reached its synthesis cap. Full-suite resource caps are post-arm
  gates, so an envelope violation remains a real retirement risk.

## Adjudicated Findings

- The reviewer requested edits to the status prose in the H10 card and the v6
  provenance amendment. Both files are immutable implementation-bound
  preregistration snapshots. Rewriting either after treatment evidence would
  break the accepted manifest. The living registry, README, portfolio, and
  histories record the current state and the v8 supersession instead.
- The reviewer reported an apparent repair-count ambiguity. Direct inspection
  rejects it: `repair_concentration.csv` records four total valid-PPA repairs
  and four `format->valid_ppa` transitions for treatment
  `Prob025_sequence_detector`. No reporter change is justified.
- Absolute `/workspace` ledger paths are a disclosed portability limitation,
  not an integrity defect in this fixed environment.

## Transition Boundary

H10 may advance only to `SMOKE_VALIDATED`. The next experiment remains the
fresh sequential RTLLM-50 pairs at seeds 1001 and 1002. No arm may be admitted
until a separate full-suite runbook is frozen, independently reviewed, and
committed with a clean tree.
