# T49 Thought-K Repair Visual Inspection Notes

Status: manually inspected after Playwright screenshot capture.

- `t49_metric_delta_summary.png` is readable and shows the mixed direction:
  best-score gain, slight HV-AUC gain, and losses in mean HV, valid PPA, and
  front points.
- `t49_hv_delta_heatmap.png` exposes the paired problem-level losses without
  hiding zero-HV cells.
- `t49_direct_ppa_fronts_seed1001.png` is understandable, but several panels
  are sparse. This supports a diagnostic conclusion.
- `t49_validity_funnel.png` makes the smaller generated-candidate budget and
  lower valid-PPA count clear.
- `t49_operator_counters.png` confirms the expected single-thought behavior:
  no success-parent requests and no two-parent attempts.
- `visualizations/direct_ppa_pareto/screenshot.png` renders without text
  overlap or broken image links.
