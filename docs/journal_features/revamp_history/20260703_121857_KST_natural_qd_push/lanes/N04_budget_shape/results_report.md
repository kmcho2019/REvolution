# N04 Budget Shape Results

Status: COMPLETED 2026-07-07. Verdict: no escalation.

## Result

Frozen eight-design 6x7, seed 1001:

| Arm | Mean HV | HV-AUC | Coverage | Pareto pts | Operator audit |
| --- | --- | --- | --- | --- | --- |
| classic_revolution_6x7 | `0.1700994814185665` | `0.146221021526` | `8/8` | `2.625` | pass |
| smooth_qd_v2_6x7 | `0.17199937669444593` | `0.132267067187` | `8/8` | `1.75` | pass |

V2 is `101.1%` of classic on final HV but only `90.5%` on HV-AUC.
Problem-level final-HV W/L/T is `2/2/4`; the wins are `traffic_light`
and `alu`, while `signal_generator` and `gshare` lose.

## Gate Decision

Do not launch 4x11 and do not start a 6x7 seed ladder from this read.
The registered escalation required both HV and HV-AUC to at least match
classic with coverage retained. Coverage is retained and final HV is a
near tie, but HV-AUC is materially worse and Pareto breadth drops.

Cause class: front-loss / anytime-loss. The deeper budget lets V2 catch
up late on final HV, but classic is stronger through the run and keeps a
wider final front.

## Follow-Up

N05b's warmup-depth interaction remains a possible diagnostic, but N04a
does not justify it as a promotion path. If pursued, it needs a new
pre-registration and should be framed as an AUC/front-breadth diagnostic,
not as a route to a 4x11 headline.
