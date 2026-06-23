# T63 Fused RTL-Native Live Screen Visual Inspection Notes

Status: generated; manual screenshot inspection completed.

- `t63_metric_delta_summary.png` is the clearest summary figure. It shows the
  actual result: best-score gain, valid-PPA tie, and negative HV/HV-AUC/front
  deltas versus classic.
- `t63_validity_funnel.png` is readable and confirms no aggregate valid-PPA
  collapse, though it also shows functional-yield weakness.
- `t63_hv_delta_heatmap.png` is readable but diagnostic only. Many cells are
  near zero and one strong loss plus one strong win dominate the color scale.
- `t63_front_counts.png` is useful for locating local front-material gains,
  especially R041 and V153, but it also shows the R015 front deficit.
- `t63_operator_counters.png` is provenance only. Both counters are zero
  because this profile did not exercise those parent-selection paths.
- `t63_direct_ppa_fronts_seed1001.png` is readable as an
  improvement-coordinate supplement.
- `visualizations/direct_ppa_pareto/t63_raw_area_power_fronts_seed1001.png`
  is the primary raw area-power PPA-front view. The 13-panel layout is dense
  but readable enough for a package supplement.
- `visualizations/direct_ppa_pareto/screenshot.png` renders the direct
  supplement with summary cards and all figures.
- `visualizations/qd_ppa_viewer/screenshot.png` renders the full Phase 03.1
  compare-mode viewer with linked archive and PPA panels. Playwright reported
  two compare-guide debug-hook failures; the screenshot itself is nonblank and
  readable.
