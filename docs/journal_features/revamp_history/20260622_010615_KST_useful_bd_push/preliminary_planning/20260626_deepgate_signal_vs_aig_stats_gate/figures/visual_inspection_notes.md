# Visual Inspection Notes

## `deepgate_signal_vs_aig_stats.png`

- The bar-chart labels are readable and the two upper panels communicate the
  same-problem nearest-neighbor and cosine-gap diagnostics directly.
- The raw DeepGate PCA panel clearly shows problem clusters, which supports the
  caution against live promotion.
- The residual PCA panel remains nonblank and visibly dispersed after removing
  AIG statistics, which supports keeping DeepGate as an active lane.
- The figure is acceptable for preliminary-planning docs and colleague
  discussion. It should be redrawn with a larger covered design set before use
  as a paper or final presentation figure.
