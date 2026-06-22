# T47 Visual Inspection Notes

Status: manually inspected on 2026-06-22 UTC.

- `t47_hv_delta_heatmap.png` is readable after label shortening. It shows
  exact T26 is mostly tied on zero-HV or near-tie problems, with visible losses
  on `R037 p2s`, `R041 traffic`, and a seed-split `V153 gshare`.
- `t47_metric_delta_summary.png` now uses relative paired deltas, avoiding the
  misleading raw-count scale. It clearly shows negative HV, HV-AUC, and
  valid-PPA movement, with a mixed front-count signal.
- `t47_validity_funnel.png` is readable and captures the main yield tradeoff:
  exact T26 has more functional candidates but fewer valid-PPA candidates.
- `t47_front_counts.png` is readable after label shortening. It shows local
  front gains on some small-front problems but aggregate front-count loss.
