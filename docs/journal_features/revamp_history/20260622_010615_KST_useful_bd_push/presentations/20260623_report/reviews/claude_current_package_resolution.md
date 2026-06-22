# Claude Current Package Review Resolution

Status: resolved by narrowing the report from a `useful_qd` claim to a
`diagnostic` front-signal package.

## Blocking Findings Addressed

- The aggregate HV/HV-AUC win is now tied directly to
  defaulted-reference `Prob040_synchronizer`.
- The result summary now includes Prob040-excluded HV/HV-AUC rows.
- The result summary now reports the omitted all-RTLLM `best_score` loss.
- The report and slides now say paired HV is net-negative.
- The family-audit discussion now states that front-family and front-netlist
  counts are not independent of front-point count when `front_family_ratio=1.0`.

## Remaining Follow-Up

- Run multi-seed replication before any seed-stable claim.
- Replace or quarantine defaulted-reference problems before using them as
  headline HV evidence.
- Add a determinism check if screen and full-run deltas are compared as
  same-seed evidence.
- Map the milestone back to the frozen `journal_narrative.md` contract before
  any final TCAD-style claim.
