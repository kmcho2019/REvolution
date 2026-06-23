# T53 Sparse-Front Trigger QD Visual Inspection Notes

Status: manually inspected after packaging.

- `t53_hv_delta_heatmap.png` exposes paired HV wins and losses without hiding
  failures.
- `t53_metric_delta_summary.png` clearly shows that T53 wins on best score but
  loses HV, HV-AUC, valid-PPA count, front points, unique PPA points, and
  reference-beating count.
- `t53_validity_funnel.png` makes the valid-PPA decline visible.
- `t53_operator_counters.png` shows nonzero sparse-front trigger use, so T53
  is not a no-op ablation.
- `t53_direct_ppa_fronts_seed1001.png` is readable and uses consistent colors.
  The 13-panel layout leaves blank space in the last row, but it does not hide
  the result.
- `visualizations/qd_ppa_viewer/screenshots/compare_classic_qd.png` renders
  both archive panes and the linked PPA pane. The Playwright hover-clear check
  has a documented caveat in `visualizations/qd_ppa_viewer/`.
