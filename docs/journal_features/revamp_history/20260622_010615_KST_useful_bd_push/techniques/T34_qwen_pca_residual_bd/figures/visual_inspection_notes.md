# T34 Visual Inspection Notes

Inspection date: 2026-06-22 UTC.

## `t34_raw_area_power_pareto_front.png`

- Pass. The figure uses raw area and raw power axes with lower-is-better
  labels.
- Pass. It includes a full valid-PPA panel and a lower-left Pareto zoom for
  `Prob018_float_multi`.
- Pass. It overlays all-valid candidates, the all-valid Pareto front, lexical,
  random, the best T33 base view, and the best T34 residual view.
- Caveat. This is a representative front view; aggregate direct-front metrics
  are in `tables/t34_ppa_front_metrics.csv`.

## `t34_hypervolume_by_projection.png`

- Pass. The plot is readable and marks the lexical selected-HV baseline.
- Caveat. Many bars are near-ties because PCA residualization mostly preserves
  the T33 RTL-view behavior rather than creating a new separation.

## `t34_collapse_vs_hypervolume.png`

- Pass. The scatter shows the key tradeoff: high-HV residuals remain in the
  high same-problem-collapse region, while lower-collapse residuals stay below
  lexical HV.
- Pass. T33 base views and T34 residual views use distinct colors.
