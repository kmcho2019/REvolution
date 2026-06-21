# RTL Diversity Lineage Yield Analysis

- Edge count: 3358
- Parent-yield rows: 2063
- Parent-found edges: 2233
- Positive quality-delta edges: 779
- New-cell edges: 1829

## Aggregate

| source_table | method_name | edge_count | parent_found_edges | parent_found_rate | unique_parent_count | new_cell_edges | positive_quality_delta_edges | mean_quality_delta | best_quality_delta |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| archive_cells.csv | landing_smooth_qd_manual_bd | 672 | 499 | 0.7425595238095238 | 362 | 391 | 157 | -0.036497518166275764 | 1.2230399698340875 |
| archive_cells.csv | random_descriptor_qd | 950 | 754 | 0.7936842105263158 | 502 | 718 | 248 | -0.03151140717445665 | 0.8471968002169348 |
| archive_cells.csv | sr_random_relu_pca_qd | 636 | 469 | 0.7374213836477987 | 379 | 408 | 176 | -0.05822549709021035 | 0.5759305598999062 |
| archive_cells.csv | synthesis_trajectory_nod | 597 | 373 | 0.6247906197654941 | 407 | 312 | 147 | -0.03566569578946693 | 0.45671817512877116 |
| global_pareto_archive.csv | landing_smooth_qd_manual_bd | 120 | 28 | 0.23333333333333334 | 100 | 0 | 9 | -0.047691078603098284 | 0.18980208955764388 |
| global_pareto_archive.csv | random_descriptor_qd | 131 | 43 | 0.3282442748091603 | 102 | 0 | 12 | -0.06026536937052149 | 0.5226008019591125 |
| global_pareto_archive.csv | sr_random_relu_pca_qd | 128 | 35 | 0.2734375 | 105 | 0 | 15 | -0.030124726473085575 | 0.2854951848419707 |
| global_pareto_archive.csv | synthesis_trajectory_nod | 124 | 32 | 0.25806451612903225 | 106 | 0 | 15 | -0.013021032309266262 | 0.26004012012757727 |
