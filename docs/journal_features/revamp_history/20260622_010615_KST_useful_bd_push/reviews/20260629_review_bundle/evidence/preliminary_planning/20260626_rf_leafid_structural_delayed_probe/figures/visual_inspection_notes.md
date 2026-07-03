# Visual Inspection Notes

## Summary Figure

File:
`rf_leafid_structural_delayed_summary.png`

Read:

- The left panel makes the aggregate conclusion clear: T83 nearly matches
  classic on mean HV, but loses Pareto points, reference-beating candidates,
  and HV wins.
- The right panel shows why the result is not robust: `Prob135_m2014_q6b`
  supplies the large positive T83 delta, while `Prob041_traffic_light` is the
  large negative RTLLM delta.
- Labels and annotations are legible after shortening problem IDs in the plot.

Decision: use this as the reader-facing figure for the T83 screen.

## Auto-Generated Per-Problem Figures

Inspected:

- `analysis/pareto_analysis/problems/RTLLM/Prob041_traffic_light/pairwise_fronts.png`
- `analysis/pareto_analysis/problems/VerilogEval-Spec-to-RTL/Prob135_m2014_q6b/pairwise_fronts.png`

Read:

- The point clouds are usable for diagnostics.
- Long backend names clip the top title/legend area in these generated plots.
- Do not use the raw per-problem plots as the first presentation figure without
  regenerating cleaner labels.
