# Yosys-SOG Visual Inspection Notes

- `sog_projection.png` renders cleanly with separate Classic and exact T26
  QD colors.
- `sog_projection_zoom.png` trims only the extreme tail so the dense
  low-complexity region can be inspected.
- Hollow markers identify Pareto-front candidates without hiding the raw
  valid-PPA point cloud.
- `archive_coverage_heatmap.png` shows front-cell occupancy counts by
  method, which is easier to read than the dense scatter for the archive
  question.
- Axes are RTL structural descriptors from Yosys JSON, not final PPA,
  reference PPA, or test labels.
- Problem-local cells make the heatmap a pooled diagnostic over local per-problem bins; use `tables/comparison_deltas.csv` for paired reads.
