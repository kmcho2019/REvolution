# T47 T26 Contract Probe Results

Status: not run.

## Current Decision

`pending_pre_registered`.

T47 is a guardrail package, not completed evidence. It exists to make the next
T26-family experiment answer the strongest current objections:

- default-reference `Prob040_synchronizer` cannot carry a headline HV win;
- paired HV must not be net-negative after default-reference quarantine;
- `best_score` must be reported beside HV and front counts;
- family-proxy/front-netlist counts cannot be treated as independent wins when
  they equal the PPA-front count.

## Pre-Run Table Check

`probe_problem_matrix.csv` contains 92 planned rows for the hard/tuning and
held-out phases. All 92 rows have `reference_available`. The known repaired
default-reference problems in `default_reference_quarantine.csv` are not in
the T47 probe, so the planned screen avoids the `Prob040_synchronizer`
headline-reference failure mode from the one-seed RTLLM package.

## Completion Gate

Do not assign a T1 or higher tier until live artifacts prove the acceptance
signals in `methodology.md`.

## Follow-Up If It Fails

If exact T26 fails the hard/tuning sanity probe, do not launch a held-out run.
Specify a narrower T26.1 variant or return to a different lane with a recorded
reason in `technique_lanes.md`.
