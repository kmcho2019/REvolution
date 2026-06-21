# Simple Yosys Stat BD Figure Inspection

Inspected on 2026-06-21 UTC.

## `seed1_mean_hypervolume.png`

- Readable line plot with method legend, generation axis, and mean
  hypervolume axis.
- Shows simple Yosys-stat closely tracks classic by the final generation.
- The legend is dense but does not cover the final simple/classic comparison.

## `seed1_common_audit_coverage.png`

- Readable bar plot with clear y-axis.
- Method labels are angled and long, but not clipped.
- Good enough for review; a final paper figure should group baselines and
  highlight only classic, manual-BD, and selected methods.

## `seed1_ppa_grid_coverage.png`

- Readable bar plot with clear y-axis.
- Shows simple Yosys-stat has higher PPA-grid coverage than classic on this
  seed-1 slice.
- Same long-label limitation as the common-audit coverage plot.

## `seed1_common_audit_cells_heatmap.png`

- Readable heatmap with cell counts annotated.
- Long problem labels fit, but the plot is taller than ideal for a paper
  column.
- Useful for method-package audit; final manuscript should use a compact
  subset or abbreviated problem labels.
