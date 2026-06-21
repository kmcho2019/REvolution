# Motif Pathlet BD Figure Inspection

Inspected on 2026-06-21 UTC.

## `seed1_mean_hypervolume.png`

- Readable line plot with compact method labels.
- Shows motif occupancy tracks classic through generation 1 and then stalls
  while classic and manual BD continue improving.
- Good audit figure for the `T0` decision.

## `seed1_common_audit_coverage.png`

- Readable three-bar plot.
- The y-axis values are small because the common audit archive has 1536 cells;
  use the occupied-cell table beside this plot when presenting the result.

## `seed1_ppa_grid_coverage.png`

- Readable three-bar plot.
- Shows motif occupancy is slightly below classic and manual BD on mean
  PPA-grid coverage.

## `seed1_common_audit_cells_heatmap.png`

- Readable heatmap with compact problem labels and cell counts.
- Clearly shows motif occupancy has fewer common-audit cells than classic,
  especially on `Prob019_sub_64bit`.

## `seed1_metric_deltas_vs_classic.png`

- Readable horizontal delta plot with friendly metric labels.
- Clearly communicates the large HV and common-audit QD regressions.

## `seed1_validity_funnel.png`

- Readable grouped bar plot.
- Shows the validity drop is modest and not the reason for rejection.

## `duplicate_accounting.png`

- Readable stacked bar plot.
- Shows motif occupancy has fewer total valid-PPA netlists and fewer unique
  canonical netlists than classic.
