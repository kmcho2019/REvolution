# Full RTLLM Family Audit Visual Inspection Notes

## `full_family_aggregate_counts.png`

- Status: accept.
- The four-panel bar chart is clear and presentation-usable.
- It makes the core split visible: exact T26 QD has more front family-proxy
  hits and front netlists, while classic has more reference-beating family
  proxies.
- Supported claim: T26 is not a duplicate-collapse result and does improve
  active-front family-proxy material, but it is not a total-family breadth win.

## `full_front_family_delta_heatmap.png`

- Status: accept with caution.
- The heatmap is dense but readable enough for appendix/report use.
- It separates count deltas from ratio deltas so the ratio column is not
  washed out by larger count magnitudes.
- It shows why the aggregate result is mixed: synchronizer and several
  smaller positive rows help T26, while ALU, divider, RAM, traffic-light, and
  signal-generator rows retain negative audited-PPA breadth or front-family
  proxy deltas.
- Supported claim: full-suite front-family proxy gains are real but uneven.

## `full_family_ratio_distribution.png`

- Status: accept.
- The histogram shows both methods are mostly unique under the family key.
- Supported claim: neither method's front is materially explained by duplicate
  family-proxy collapse; the front-family ratio is `1.0` for both methods.
