# T17 Figure Visual Inspection Notes

## `mome_retention_hypervolume.png`

Readable grouped bar chart. It shows bounded local-Pareto retention is nearly
identical to scalar-cell retention on mean HV for most methods. This supports
the conservative `T0 diagnostic` tier because the retention rule does not create
a decisive HV win by itself.

## `mome_global_pareto_points.png`

Readable grouped bar chart. It clearly shows bounded local-Pareto retention
keeps many more nondominated points than scalar-cell retention across all
methods, including SR-RFF PCA and SR ReLU PCA.

## `mome_vs_scalar_deltas.png`

Readable three-panel relative-delta chart. The top panel shows HV deltas are
tiny, while the middle and bottom panels show front-netlist and PPA-grid-cell
gains. This is the most direct visual explanation of the result.

## `mome_retained_candidates_heatmap.png`

Readable heatmap. It shows which method/problem pairs supply retained
local-Pareto candidates and highlights that the extra retained material is not
from a single problem only.
