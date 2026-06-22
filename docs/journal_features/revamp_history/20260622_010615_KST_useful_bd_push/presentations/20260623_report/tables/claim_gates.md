# Claim Gates

These gates must be evaluated before any presentation claim that QD/MAP-Elites
is useful for RTL PPA evolution.

Policy: this milestone is PPA-first. A QD arm can remain acceptable with a lower
functionality or synthesis rate if it keeps at least one valid functional PPA
candidate on every classic-covered design and improves the paired PPA evidence.
Once that hard coverage gate passes, yield-rate loss is a warning and analysis
topic, not a hidden rejection rule.

| Gate | Required Evidence | Failure Meaning |
| --- | --- | --- |
| Classic-covered retention | Every problem where classic has at least one valid functional PPA candidate must also have a valid QD candidate. | QD cannot be promoted on that comparison. |
| Yield warning | Functionality, synthesis-valid, and valid-PPA rates are reported per problem, with 50% or larger drops labeled when classic has at least 10 passing samples. | Not a launch blocker if classic-covered retention passes, but the report must show the tradeoff. |
| Paired HV | Per-problem and aggregate HV deltas versus classic. | Aggregate-only wins are insufficient. |
| HV-AUC | AUC over generation history, not only final population. | Final-only gains may be unstable. |
| Direct PPA fronts | Raw area-power front points and representative plots. | BD-space visuals cannot substitute for PPA evidence. |
| Family breadth | Unique front netlists, synthesized-cell-count family proxies, and duplicate accounting. | Do not claim broad semantic implementation-family dominance from proxy counts alone. |
| Archive evidence | Coverage, QD score, and Phase 03.1 viewer for live QD archive arms. | Archive claims are unsupported. |
| Selection timing | Full-run QD arm selected before full RTLLM outcomes. | Treat as exploratory/post-hoc. |
| Screen exclusion | Aggregate metrics reported both with and without development-screen problems. | Selection bias is hidden. |
| Budget parity | LLM calls, evaluated candidates, tokens, and runtime reported for both arms. | Same pop/gen budget is not enough. |
| Visual inspection | Notes for each figure and screenshot. | Figure is not presentation-ready. |

## Allowed Claim Levels

- `diagnostic`: useful for method selection, but not a QD-effectiveness claim.
- `near_classic`: close to classic and passes the retention gate.
- `useful_qd`: positive paired evidence on pre-declared PPA metrics while
  passing retention and reporting any yield warnings. Family or archive claims
  require the corresponding family or archive artifacts.
- `strong_win`: at least 10% positive paired evidence plus independent
  stability evidence. The one-seed RTLLM milestone cannot claim this alone.

## Replication Order

The one-seed RTLLM run is allowed as the first milestone because the deadline
prioritizes producing organized evidence, plots, tables, and presentation
materials. Multi-seed replication is required before any seed-stable or
statistical-significance claim.
