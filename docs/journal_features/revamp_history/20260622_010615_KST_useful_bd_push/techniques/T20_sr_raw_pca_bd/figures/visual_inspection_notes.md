# T20 Figure Visual Inspection Notes

## `seed1_mean_hypervolume.png`

Readable line chart. It shows SR raw PCA reaching most of its HV early, then
ending slightly below classic at the final generation. This supports the
near-miss ablation interpretation.

## `seed1_metric_deltas_vs_classic.png`

Readable horizontal delta chart. It clearly shows the split result: front
netlists and motif signatures improve, valid PPA and audit cells are flat, and
best fitness, mean HV, and common-audit QD score decline.

## `seed1_common_audit_cells_heatmap.png`

Readable heatmap. It confirms raw PCA does not lose aggregate common-audit cell
occupancy, although the occupied cells do not yield a higher passive QD score.

## `seed1_common_audit_coverage.png`

Readable grouped bar chart. It shows raw PCA matching classic common-audit
coverage, which separates this ablation from weaker descriptor failures.

## `seed1_ppa_grid_coverage.png`

Readable grouped bar chart. It shows raw PCA matching classic mean PPA-grid
coverage on the seed-1001 replay.

## `seed1_validity_funnel.png`

Readable funnel chart. It shows raw PCA matching classic functionality,
synthesis, and valid-PPA counts.

## `duplicate_accounting.png`

Readable grouped bar chart. It shows raw PCA has slightly fewer duplicate
netlists and more unique canonical netlists than classic.
