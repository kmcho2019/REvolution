# QD Feature-Space Analysis

## Backend aggregate comparison

| Backend | Functionality | Synthesis | Solved | Best score | Runtime (s) | QD coverage | QD score |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| classic | 43.8% | 42.4% | 3 | 0.3346 | 579.9 | N/A | N/A |
| t11_runtime_top4_graph_qd | 33.3% | 28.5% | 3 | 0.2995 | 689.3 | 3.1% | 1.3933 |

## QD backend feature-space summary

### t11_runtime_top4_graph_qd

- successful_candidates: `41`
- final_elites: `32`
- collapsed_features: `ltp_noff, utilization`
- near_collapsed_features: `ltp_noff, utilization`
- histogram: ![](backends/t11_runtime_top4_graph_qd/feature_histograms.png)
- PCA: ![](backends/t11_runtime_top4_graph_qd/pca_fitness.png)
- t-SNE: tsne_skipped

## Regression summary

### quality_score

- sample_count: `41`
- ridge_alpha: `10.0000`
- ridge_r2: `0.9466`
- top_coefficients:
  - `sequential_cells`: `-0.1983`
  - `scoap_cc1_bin_3_pct`: `0.1082`
  - `seq_ratio`: `-0.1067`
  - `comb_ratio`: `0.1067`
  - `scoap_cc0_bin_3_pct`: `0.0908`
  - `adder_ratio`: `-0.0864`
  - `rent_r2`: `-0.0824`
  - `scoap_signal_smoothness`: `0.0740`
  - `scoap_cc1_bin_1_pct`: `-0.0736`
  - `edge_per_node`: `-0.0712`

### g_P

- sample_count: `41`
- ridge_alpha: `10.0000`
- ridge_r2: `0.9476`
- top_coefficients:
  - `sequential_cells`: `-0.1684`
  - `scoap_cc1_bin_3_pct`: `0.1183`
  - `seq_ratio`: `-0.1019`
  - `comb_ratio`: `0.1019`
  - `scoap_cc0_bin_3_pct`: `0.0995`
  - `ff_depth`: `-0.0893`
  - `scoap_signal_smoothness`: `0.0874`
  - `adder_ratio`: `-0.0855`
  - `scoap_cc1_bin_1_pct`: `-0.0777`
  - `hyper_max_level_delta`: `-0.0718`

### g_A

- sample_count: `41`
- ridge_alpha: `1.0000`
- ridge_r2: `0.9837`
- top_coefficients:
  - `sequential_cells`: `-0.5761`
  - `rent_r2`: `-0.4778`
  - `edge_per_node`: `-0.2088`
  - `rent_retained_sample_ratio`: `-0.1968`
  - `adder_ratio`: `0.1754`
  - `comb_width_log`: `-0.1714`
  - `reconv_source_ratio`: `-0.1694`
  - `total_cells`: `-0.1567`
  - `cell_count_log`: `-0.1551`
  - `mux_ratio`: `0.1509`

### g_T

- sample_count: `41`
- ridge_alpha: `1.0000`
- ridge_r2: `0.9600`
- top_coefficients:
  - `ff_depth`: `0.6471`
  - `adder_ratio`: `-0.4353`
  - `hyper_max_level_delta`: `0.3415`
  - `rent_k`: `-0.2742`
  - `logic_depth`: `-0.2545`
  - `logic_depth_ltp`: `-0.2540`
  - `rent_retained_sample_ratio`: `-0.2506`
  - `scoap_signal_smoothness`: `0.2152`
  - `laplacian_lambda2`: `0.2124`
  - `rent_clamped_flag`: `0.1568`

## Recommended large profile

- selected_non_target_features: `sequential_cells, ff_depth, rent_exponent_confidence_gated, total_cells, scoap_cc1_bin_1_pct, rent_confidence, hyper_mean_fanout`
- sequential_axes: `sequential_cells, ff_depth, rent_exponent_confidence_gated, total_cells, scoap_cc1_bin_1_pct, rent_confidence, hyper_mean_fanout, g_P, g_A, g_T`
- combinational_axes: `sequential_cells, ff_depth, rent_exponent_confidence_gated, total_cells, scoap_cc1_bin_1_pct, rent_confidence, hyper_mean_fanout, g_P, g_A`
