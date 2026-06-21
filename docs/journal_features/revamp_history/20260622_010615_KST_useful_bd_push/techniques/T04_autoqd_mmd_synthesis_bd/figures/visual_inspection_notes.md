# T04 Figure Visual Inspection Notes

Inspection date: 2026-06-21 UTC.

## `seed1_mean_hypervolume.png`

Readable line plot with clear legend labels. The plot shows RFF-PCA ahead of
classic at generation 1, nearly tied at generation 2, and slightly below
classic at generation 3.

## `seed1_metric_deltas_vs_classic.png`

Readable horizontal delta plot. The strongest visible signals are positive
PPA-front unique netlists and common-audit QD score, with smaller negative
bars for final HV, best fitness, valid PPA, and audit cells.

## `seed1_common_audit_cells_heatmap.png`

Readable heatmap with visible per-problem cell counts. It shows RFF-PCA has
one fewer occupied audit cell than classic on `Prob030_popcount255` and
`Prob105_rotate100`, but one more on `Prob019_sub_64bit`.

## `seed1_common_audit_coverage.png`

Simple and readable bar chart. RFF-PCA common-audit coverage is between
classic and manual BD, matching the table result that occupied cells decline
even though QD score improves.

## `seed1_ppa_grid_coverage.png`

Readable bar chart. RFF-PCA matches classic mean PPA-grid coverage, while
manual BD is slightly higher.

## `seed1_validity_funnel.png`

Readable grouped bars. The method bars are consistently lower than classic by
the same amount across functionality, synthesis, and valid PPA, matching the
5.74% relative decline in `validity_gate.csv`.

## `duplicate_accounting.png`

Readable stacked bars. RFF-PCA has fewer total valid-PPA candidates and fewer
unique canonical netlists than classic, so its positive archive signal should
not be described as a duplicate-accounting win.
