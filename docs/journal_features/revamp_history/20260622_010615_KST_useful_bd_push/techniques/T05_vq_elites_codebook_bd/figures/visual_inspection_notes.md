# T05 Figure Visual Inspection Notes

Inspection date: 2026-06-21 UTC.

## `seed1_mean_hypervolume.png`

Readable line plot with clear labels. SR VQ tracks classic at generation 1,
then falls below classic at generations 2 and 3 while remaining above manual
BD at the final generation.

## `seed1_metric_deltas_vs_classic.png`

Readable horizontal delta plot. It makes the negative diagnosis obvious:
common-audit QD score, motif signatures, audit cells, valid PPA, best fitness,
and mean HV all regress, while PPA-front unique netlists is the only positive
headline metric.

## `seed1_common_audit_cells_heatmap.png`

Readable per-problem heatmap. SR VQ occupies fewer common-audit cells than
classic on `Prob019_sub_64bit`, `Prob030_popcount255`, and
`Prob105_rotate100`, but it occupies one extra cell on `Prob048_pe`.

## `seed1_common_audit_coverage.png`

Readable bar chart. SR VQ common-audit coverage matches manual BD and remains
below classic.

## `seed1_ppa_grid_coverage.png`

Readable bar chart. SR VQ has lower mean PPA-grid coverage than both classic
and manual BD.

## `seed1_validity_funnel.png`

Readable grouped bars. Functionality, synthesis, and valid-PPA rates are all
visibly lower than classic by the same amount, matching the 16.75% relative
decline in `validity_gate.csv`.

## `duplicate_accounting.png`

Readable stacked bars. SR VQ has fewer valid-PPA candidates and fewer unique
canonical netlists than classic; the method does not hide a diversity gain
behind duplicate accounting.
