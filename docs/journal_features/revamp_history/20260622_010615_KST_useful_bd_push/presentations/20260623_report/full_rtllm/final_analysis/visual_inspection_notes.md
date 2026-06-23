# Formal Bundle Visual Inspection Notes

Inspection date: 2026-06-23 UTC.

## Checks

- Verified every generated JSON file parses.
- Verified every generated CSV file is readable and non-empty.
- Verified all `1026` generated PNG files open with Pillow.
- Spot-checked:
  - `pareto_analysis/problems/RTLLM/Prob015_multi_pipe_8bit/pairwise_fronts.png`
  - `feature_analysis/backends/sr_raw_conservative_exploit_qd/feature_histograms.png`
  - `design_space_analysis/aggregate/RTLLM_combinational_raw_power_area.png`

## Notes

- The aggregate design-space figure and feature histograms are readable.
- Some generated per-problem Pareto figures place the title close to, or over,
  the legend. These figures should be treated as formal audit output, not the
  primary presentation-ready visual source.
- The presentation should continue using the manually inspected
  `../figures/`, `../visualizations/direct_ppa_pareto/`, and
  `../visualizations/qd_ppa_viewer/` artifacts for reader-facing claims.
