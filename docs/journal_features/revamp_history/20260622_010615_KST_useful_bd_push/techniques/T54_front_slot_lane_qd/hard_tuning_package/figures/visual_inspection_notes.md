# T54 Front-Slot Lane QD Visual Inspection Notes

Status: inspected after browser screenshot capture.

- `t54_hv_delta_heatmap.png` should expose seed/problem HV wins
  and losses without hiding paired failures.
- `t54_metric_delta_summary.png` should show whether the method
  wins through HV/front material or only through best score.
- `t54_validity_funnel.png` should make yield collapse visible.
- `t54_operator_counters.png` should show whether the
  configured counters are active or degenerate.
- `t54_direct_ppa_fronts_seed*.png` should make raw area-power
  distribution differences easy to inspect by problem.
- `visualizations/direct_ppa_pareto/screenshot.png` renders without broken
  images. The first counter plot had overlapping x-axis labels, so
  `t54_operator_counters.png` was regenerated with shorter labels before
  recapturing the screenshot.
