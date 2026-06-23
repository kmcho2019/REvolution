# T66 Visual Inspection Notes

Status: generated and manually inspected.

- `t66_hv_delta_heatmap.png` exposes that the RTLLM slice drives the
  negative HV result.
- `t66_metric_delta_summary.png` clearly shows the split result: positive
  best-score and valid-PPA movement, but negative HV, HV-AUC, and front
  points.
- `t66_validity_funnel.png` is readable and shows no broad coverage loss.
- `t66_parent_gate_counters.png` is readable and shows a degenerate
  two-parent lane: all two-parent counters are zero.
- `t66_direct_ppa_fronts_seed1001.png` is readable as an
  improvement-coordinate diagnostic. The raw area-power reader-facing panel is
  in `../../visualizations/direct_ppa_pareto/t66_raw_area_power_fronts_seed1001.png`.
