# T22 Figure Visual Inspection Notes

## `seed1_mean_hypervolume.png`

Readable line chart. It shows random BD ahead early and close to classic late,
which explains why this control must remain visible in the central comparison.

## `seed1_metric_deltas_vs_classic.png`

Readable horizontal delta chart. It clearly shows the control's split behavior:
front-net and valid-PPA gains, but losses in mean HV, audit cells, audit QD
score, and motif signatures.

## `seed1_common_audit_cells_heatmap.png`

Readable heatmap. It shows random BD does not improve common-audit cell
coverage broadly, supporting the negative-control classification.

## `seed1_common_audit_coverage.png`

Readable grouped bar chart. It shows random BD has fewer common-audit cells than
classic even though it has more PPA-front unique netlists.

## `seed1_ppa_grid_coverage.png`

Readable grouped bar chart. It shows random BD matches classic aggregate
PPA-grid coverage, so its final-HV loss is not just a coverage-count issue.

## `seed1_validity_funnel.png`

Readable funnel chart. It shows random BD slightly improves pass counts versus
classic, so its failure is not due to validity collapse.

## `duplicate_accounting.png`

Readable grouped bar chart. It shows random BD has more duplicate netlists and
fewer unique canonical netlists than classic despite stronger front-net count.
