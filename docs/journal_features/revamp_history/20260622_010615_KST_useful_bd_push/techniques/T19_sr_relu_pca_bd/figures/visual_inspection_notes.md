# T19 Figure Visual Inspection Notes

## `seed1_mean_hypervolume.png`

Readable line chart. It shows SR ReLU PCA jumping ahead of classic early and
ending with higher mean hypervolume. This is the strongest visual support for
keeping the method in the validation queue.

## `seed1_metric_deltas_vs_classic.png`

Readable horizontal delta chart. It makes the tradeoff clear: mean HV,
common-audit QD score, and motif signatures improve, while best fitness,
valid-PPA count, PPA-front unique netlists, and common-audit occupied cells
decline.

## `seed1_common_audit_cells_heatmap.png`

Readable heatmap. It shows SR ReLU PCA does not improve common-audit cell
occupancy broadly; the method occupies fewer common-audit cells than classic in
aggregate. This supports the conservative `T0 diagnostic` tier.

## `seed1_common_audit_coverage.png`

Readable grouped bar chart. It communicates the common-audit occupancy loss
without requiring the reader to inspect table values.

## `seed1_ppa_grid_coverage.png`

Readable grouped bar chart. It shows SR ReLU PCA is close to classic in PPA
grid coverage but does not establish a broad coverage win.

## `seed1_validity_funnel.png`

Readable funnel chart. It shows the SR ReLU PCA pass-rate decline is modest and
far from the 50 percent collapse gate.

## `duplicate_accounting.png`

Readable grouped bar chart. It shows duplicate counts are not the explanation
for the SR ReLU HV lead, but unique canonical netlist count still declines
slightly versus classic.
