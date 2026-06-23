# T55 Coarse SR2 Front-Slot QD Visual Inspection Notes

Status: inspected after browser screenshot capture.

- `t55_hv_delta_heatmap.png` exposes isolated wins and paired losses without
  hiding that the aggregate favors classic.
- `t55_metric_delta_summary.png` clearly shows the result shape: positive best
  score, negative HV, HV-AUC, valid-PPA count, and front breadth.
- `t55_validity_funnel.png` shows no design-level coverage loss but lower
  aggregate valid-PPA volume than classic.
- `t55_operator_counters.png` was regenerated as a horizontal bar chart after
  the first plot's x-axis labels overlapped in the browser screenshot.
- `t55_direct_ppa_fronts_seed1001.png` is legible enough for a reader-facing
  supplement, but the small panels are still best treated as an overview.
- `visualizations/direct_ppa_pareto/screenshot.png` renders without broken
  images or text overlap after the counter-plot refresh.
- `visualizations/qd_ppa_viewer/screenshot.png` renders the two-axis archive
  as a visible `4 x 4 x 1` slab with `sr_pca_0` and `sr_pca_1` labels.
