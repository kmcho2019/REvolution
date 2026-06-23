# T52 Code-Thought Full-Pareto QD Visual Inspection Notes

Status: manually inspected on 2026-06-23 UTC.

- `t52_metric_delta_summary.png` is readable and makes the main result clear:
  T52 only improves best score while losing HV, HV-AUC, valid-PPA count, and
  front points versus classic.
- `t52_hv_delta_heatmap.png` is readable in the HTML supplement; the sparse
  one-seed row makes the design-level losses easy to identify.
- `t52_direct_ppa_fronts_seed1001.png` renders all 13 panels. Some panels are
  sparse, but the multi-pipe and VerilogEval losses are visible.
- `t52_validity_funnel.png` is readable and shows that total valid-PPA count is
  close to classic, while the gate table records the Prob098 yield warning.
- `visualizations/direct_ppa_pareto/screenshot.png` renders without broken
  images or overlapping text.
- `visualizations/qd_ppa_viewer/screenshot.png` renders the full Phase 03.1
  compare view with archive and PPA panes visible.
