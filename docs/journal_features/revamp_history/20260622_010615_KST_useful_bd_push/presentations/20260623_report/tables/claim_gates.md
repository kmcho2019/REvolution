# Claim Gates

These gates must be evaluated before any presentation claim that QD/MAP-Elites
is useful for RTL PPA evolution.

| Gate | Required Evidence | Failure Meaning |
| --- | --- | --- |
| Classic-covered retention | Every problem where classic has at least one valid functional PPA candidate must also have a valid QD candidate. | QD cannot be promoted on that comparison. |
| Validity collapse | No 50% or larger valid-PPA or synthesis-valid decline where classic has at least 10 passing samples. | Label as yield-blocked unless small-n rules apply. |
| Paired HV | Per-problem and aggregate HV deltas versus classic. | Aggregate-only wins are insufficient. |
| HV-AUC | AUC over generation history, not only final population. | Final-only gains may be unstable. |
| Direct PPA fronts | Raw area-power front points and representative plots. | BD-space visuals cannot substitute for PPA evidence. |
| Family breadth | Unique front netlists/families and duplicate accounting. | Do not count duplicate or invalid candidates as useful diversity. |
| Archive evidence | Coverage, QD score, and Phase 03.1 viewer for live QD archive arms. | Archive claims are unsupported. |
| Selection timing | Full-run QD arm selected before full RTLLM outcomes. | Treat as exploratory/post-hoc. |
| Screen exclusion | Aggregate metrics reported both with and without development-screen problems. | Selection bias is hidden. |
| Budget parity | LLM calls, evaluated candidates, and runtime reported for both arms. | Same pop/gen budget is not enough. |
| Visual inspection | Notes for each figure and screenshot. | Figure is not presentation-ready. |

## Allowed Claim Levels

- `diagnostic`: useful for method selection, but not a QD-effectiveness claim.
- `near_classic`: close to classic and passes retention/yield gates.
- `useful_qd`: positive paired evidence on HV/HV-AUC/front/family/archive
  metrics while passing retention/yield gates.
- `strong_win`: at least 10% positive paired evidence plus independent
  stability evidence. The one-seed RTLLM milestone cannot claim this alone.

## Replication Order

The one-seed RTLLM run is allowed as the first milestone because the deadline
prioritizes producing organized evidence, plots, tables, and presentation
materials. Multi-seed replication is required before any seed-stable or
statistical-significance claim.
