# T27 T26 Live QD Audit Results Report

Status: completed live audit package; claim status downgraded after the
reference-complete RTLLM correction.

## Summary

T27 audits the completed T26 conservative-exploit SR raw run against the T24
and T25 live controls. The original audit table reported T26 wins on mean live
PPA hypervolume, hypervolume AUC, and best score. That interpretation is now
downgraded: the later RTLLM reference-complete comparison excludes four
missing/defaulted-reference problems and is negative versus classic. Treat this
package as mechanism context, not as evidence that T26 broadly beats classic.

## Compared Methods

| Method | Source |
| --- | --- |
| Classic REvolution | T24 live matrix |
| Landing Smooth-QD manual BD | T24 live matrix |
| Random descriptor QD | T24 live matrix |
| SR raw PCA QD | T24 live matrix |
| Guarded SR raw Pareto QD | T25 live result |
| Conservative exploit SR raw QD | T26 live result |

Primary tables:

- `tables/live_qd_problem_metrics.csv`
- `tables/live_qd_aggregate_metrics.csv`
- `tables/live_qd_comparison_deltas.csv`

Primary figures:

- `figures/live_qd_problem_metrics.png`
- `figures/live_qd_aggregate_metrics.png`

## Aggregate Results

| Method | Mean HV | HV AUC | Best | Valid PPA | PPA-front points | Unique PPA points | Active Pareto members |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Classic | 0.160241 | 0.122837 | 0.341634 | 66 | 18 | 53 | n/a |
| Manual BD | 0.181459 | 0.153877 | 0.297425 | 63 | 9 | 56 | 9 |
| Random | 0.112776 | 0.077037 | 0.277994 | 37 | 7 | 31 | 7 |
| SR raw | 0.147152 | 0.127593 | 0.295832 | 49 | 16 | 44 | 16 |
| Guarded SR raw | 0.141203 | 0.119673 | 0.285091 | 41 | 10 | 37 | 10 |
| Conservative exploit | 0.178862 | 0.144485 | 0.351947 | 57 | 9 | 53 | 9 |

## Key Deltas

Against classic, this narrow development-screen audit reported mean live
hypervolume +11.62%, hypervolume AUC +17.62%, and mean best score +3.02%. Do
not cite those deltas as broad RTLLM evidence. The reference-complete full
RTLLM correction supersedes that interpretation and is negative versus classic.
The narrow audit still records useful mechanism details: T26 loses 9 valid-PPA
samples (-13.64%), loses 9 PPA-front points (-50.00%), ties unique PPA points,
and increases mean front nearest-neighbor spread by 29.23%.

Against random descriptor QD, T26 improves mean hypervolume by 58.60%,
hypervolume AUC by 87.55%, mean best score by 26.60%, valid-PPA count by
54.05%, PPA-front points by 28.57%, unique PPA points by 70.97%, and active
global Pareto members by 28.57%.

Against SR raw, T26 improves mean hypervolume by 21.55%, hypervolume AUC by
13.24%, mean best score by 18.97%, valid-PPA count by 16.33%, and unique PPA
points by 20.45%. The tradeoff is front material: T26 has 9 active global
Pareto members versus SR raw's 16, and 9 PPA-front points versus SR raw's 16.

Against manual BD, T26 is close on final mean hypervolume (-1.43%) but trails
HV AUC (-6.10%). It improves mean best score by 18.33%, ties active Pareto
members and PPA-front points, and loses 3 unique PPA points.

## Interpretation

T27 is now best read as a narrow mechanism audit. It showed that the
conservative exploit policy can recover local quality pressure, but it did not
establish a claim-safe broad RTLLM win.

Classic and SR raw retain more PPA-front points, and SR raw retains more active
global Pareto members. That means the conservative exploit policy may be
collapsing front material even when narrow aggregate metrics look favorable.

## Tier Decision

T27 no longer supports T26 as a `T1 near_classic validation_candidate`. It is a
`T0 diagnostic` mechanism package because later reference-complete evidence
does not support the broad positive claim.

It is not `T2 useful_qd` because the audit does not provide a claim-safe
reference-complete win, canonical duplicate accounting, common passive archive
scoring, holdout behavior, or multi-seed confidence.

## Next Experiment

The next package should be a holdout and canonical-family audit before another
descriptor reset. Required checks:

- canonical netlist or motif-family duplicate accounting;
- common passive descriptor archive over the same candidate pool;
- holdout screen using the frozen holdout subset;
- comparison against classic, manual BD, random, SR raw, and T26;
- explicit decision on whether to branch to repair emitters.
