# Synthesis Delta ST-NOD Figure Inspection

Inspected on 2026-06-21 UTC.

## `seed1_mean_hypervolume.png`

- Readable line plot with compact labels.
- Shows ST-NOD ahead of classic at generation 1 and close to classic by the
  final generation.
- This is the strongest figure supporting the near-miss interpretation.

## `seed1_common_audit_coverage.png`

- Readable three-bar plot.
- Shows ST-NOD common-audit coverage is slightly below classic and above manual
  BD.

## `seed1_ppa_grid_coverage.png`

- Readable three-bar plot.
- Shows ST-NOD slightly above classic and manual BD on mean PPA-grid coverage.

## `seed1_common_audit_cells_heatmap.png`

- Readable heatmap with compact problem labels.
- Shows ST-NOD nearly matches classic common-audit occupied-cell count, with
  one fewer cell on `Prob019_sub_64bit`.

## `seed1_metric_deltas_vs_classic.png`

- Readable horizontal delta plot.
- Clearly communicates the tradeoff: positive structural diversity metrics,
  small HV/validity loss, and large common-audit QD score loss.

## `seed1_validity_funnel.png`

- Readable grouped bar plot.
- Shows the validity drop is minor and not a rejection reason.

## `duplicate_accounting.png`

- Readable stacked bar plot.
- Shows ST-NOD has slightly more unique canonical netlists than classic but
  fewer total valid-PPA candidates.
