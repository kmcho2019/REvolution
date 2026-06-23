# RTL Timing-Risk Visual Inspection Notes

- `timing_risk_projection.png` renders cleanly with separate Classic and
  exact T26 QD colors.
- The legend uses reader-facing method labels, not internal backend keys.
- Hollow markers identify Pareto-front candidates without hiding the raw point
  cloud.
- A few high-risk outliers stretch the y-axis, but the dense low-risk cluster
  and front markers remain visible.
- Axes are descriptor-only timing-risk proxies, not PPA objectives; the figure
  should be used as diagnostic geometry, not as a performance claim.
- Problem-local cell assignment changes archive bins, not raw feature geometry; pair the figure with `tables/comparison_deltas.csv`.
