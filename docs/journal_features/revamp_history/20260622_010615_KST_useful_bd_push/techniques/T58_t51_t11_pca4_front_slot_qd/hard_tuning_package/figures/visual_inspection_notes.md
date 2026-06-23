# T58 T51 T11-PCA4 Front-Slot QD Visual Inspection Notes

Status: generated and manually inspected.

- `t58_hv_delta_heatmap.png` exposes paired HV losses without hiding the few
  neutral/winning cells. The RTLLM subset drives most of the negative result.
- `t58_metric_delta_summary.png` clearly shows the split: negative HV/HV-AUC
  and front evidence, positive best-score and valid-PPA evidence.
- `t58_validity_funnel.png` is readable and shows no aggregate yield collapse.
- `t58_operator_counters.png` is visually sparse because success-parent
  requests and two-parent attempts are both zero; keep it because it documents
  the fixed T51 control setting.
- `t58_raw_area_power_fronts_seed1001.png` is readable for all 13 problems and
  uses literal area/power axes with lower-left better.
- `t58_direct_ppa_fronts_seed1001.png` is readable for all 13 problems in
  improvement-vs-reference coordinates. Some panels are sparse because the
  measured front itself is sparse, not because the plot is broken.
- `visualizations/direct_ppa_pareto/screenshot.png` renders without broken
  assets and gives a clear reader-facing summary.
- `visualizations/qd_ppa_viewer/screenshot.png` renders the full Phase 03.1
  compare view without blank canvases.
