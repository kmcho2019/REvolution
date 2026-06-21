# T21 Figure Visual Inspection Notes

## `seed1_mean_hypervolume.png`

Readable line chart. It shows ST-NOD+motif improving early HV relative to
classic but finishing slightly below classic, matching the near-miss
interpretation.

## `seed1_metric_deltas_vs_classic.png`

Readable horizontal delta chart. It clearly shows the core tradeoff: strong
gains in PPA-front unique netlists and audit cells, but losses in mean HV, best
fitness, valid PPA, and common-audit QD score.

## `seed1_common_audit_cells_heatmap.png`

Readable heatmap. It shows the hybrid's broad audit-cell occupancy and supports
the archive-coverage ablation conclusion.

## `seed1_common_audit_coverage.png`

Readable grouped bar chart. It shows ST-NOD+motif occupying more common-audit
cells than classic and manual BD.

## `seed1_ppa_grid_coverage.png`

Readable grouped bar chart. It shows the hybrid's PPA-grid coverage is higher
than classic in aggregate, although that does not translate into higher final
HV.

## `seed1_validity_funnel.png`

Readable funnel chart. It shows the validity decline is modest and far from the
50 percent collapse gate.

## `duplicate_accounting.png`

Readable grouped bar chart. It shows fewer duplicate netlists and more unique
canonical netlists than classic.
