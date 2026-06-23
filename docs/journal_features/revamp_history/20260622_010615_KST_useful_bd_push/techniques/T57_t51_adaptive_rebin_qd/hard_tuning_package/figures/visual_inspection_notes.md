# T57 T51 Adaptive-Rebin QD Visual Inspection Notes

Status: inspected after packaging.

- `t57_metric_delta_summary.png` is presentation-readable: it clearly shows
  negative HV, HV-AUC, valid-PPA, and front deltas, with best score as the only
  aggregate win.
- `t57_hv_delta_heatmap.png` exposes the paired problem spread and does not
  hide the large `Prob041_traffic_light` loss.
- `t57_validity_funnel.png` makes the aggregate valid-PPA drop visible.
- `t57_front_counts.png` shows the lower aggregate front-point count.
- `t57_rebinning_counters.png` makes the zero-rebin outcome obvious.
- `t57_direct_ppa_fronts_seed1001.png` is dense but usable for all 13
  problem-level raw area-power panels.
- `visualizations/direct_ppa_pareto/screenshot.png` renders without broken
  assets and places the negative headline metrics above the plots.
- `visualizations/qd_ppa_viewer/screenshot.png` renders the Phase 03.1
  compare view with archive and PPA panes visible.
