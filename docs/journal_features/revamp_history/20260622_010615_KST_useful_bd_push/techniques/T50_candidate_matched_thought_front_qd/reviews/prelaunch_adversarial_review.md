# T50 Prelaunch Adversarial Review

Status: initial review failed; revised docs passed re-review before commit.

Reviewer: sub-agent `019ef22e-233f-7883-8876-db593deb336f`.

## Findings

- T50 was described as budget matched, but thought-only generation adds a
  thought-spec request stage. The fair claim is evaluated-code-candidate
  matching, not LLM-call or token matching.
- The methodology listed T47, T48, and T49 as QD-family comparators, while the
  command card only made classic/T50 packaging explicit.
- The method changed three controls at once: population size, repair removal,
  and local Pareto cap. The docs should not imply a single-causal correction.
- Thought/code budget measurements were under-specified because prior T49
  counters came from latest per-problem snapshots.
- The artifact manifest required a preflight summary file that the command card
  did not write.
- The local README named T50 as most recent pre-registered package but did not
  list it in the technique-state table.

## Resolution

- Renamed the package and method wording to candidate-matched thought-front
  control.
- Added explicit LLM request/token accounting requirements and blocked
  efficiency claims unless logs prove parity.
- Required post-package T50-versus-T47/T48/T49 aggregate comparison tables.
- Reworded the method as a narrow multi-variable control, not a minimal or
  single-causal correction.
- Added `models_summary_<timestamp>.txt` generation to the preflight command.
- Added T50 to the local technique-state table and registry.

## Launch Recommendation

Re-review found no remaining launch blockers. Launch is acceptable only after
these revised docs are committed and the preflight records both model metadata
files. T50 remains a pre-registered screen, not a promoted QD claim.
