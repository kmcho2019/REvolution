# QD Feature-Space Analysis

## Backend aggregate comparison

| Backend | Functionality | Synthesis | Solved | Best score | Runtime (s) | QD coverage | QD score |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| classic_revolution_12x3 | 48.4% | 47.9% | 8 | 0.3337 | 955.4 | N/A | N/A |
| shape_density_front_pressure_qd_12x3 | 55.5% | 53.1% | 8 | 0.2899 | 945.6 | 28.3% | 1.2548 |
| classic_revolution_8x5 | 56.8% | 55.7% | 8 | 0.3266 | 1097.9 | N/A | N/A |
| shape_density_front_pressure_qd_8x5 | 53.1% | 52.6% | 8 | 0.3085 | 1274.3 | 29.8% | 1.5660 |
| classic_revolution_6x7 | 59.9% | 57.8% | 8 | 0.3659 | 1279.3 | N/A | N/A |
| shape_density_front_pressure_qd_6x7 | 50.0% | 49.0% | 8 | 0.3040 | 1506.4 | 26.4% | 1.3847 |

## QD backend feature-space summary

### shape_density_front_pressure_qd_12x3

- successful_candidates: `204`
- final_elites: `58`
- collapsed_features: `ltp_noff, utilization`
- near_collapsed_features: `ltp_noff, utilization`
- histogram: ![](backends/shape_density_front_pressure_qd_12x3/feature_histograms.png)
- PCA: ![](backends/shape_density_front_pressure_qd_12x3/pca_fitness.png)
- t-SNE: tsne_skipped

### shape_density_front_pressure_qd_8x5

- successful_candidates: `202`
- final_elites: `73`
- collapsed_features: `ltp_noff, utilization`
- near_collapsed_features: `ltp_noff, utilization`
- histogram: ![](backends/shape_density_front_pressure_qd_8x5/feature_histograms.png)
- PCA: ![](backends/shape_density_front_pressure_qd_8x5/pca_fitness.png)
- t-SNE: tsne_skipped

### shape_density_front_pressure_qd_6x7

- successful_candidates: `188`
- final_elites: `58`
- collapsed_features: `ltp_noff, utilization`
- near_collapsed_features: `ltp_noff, utilization`
- histogram: ![](backends/shape_density_front_pressure_qd_6x7/feature_histograms.png)
- PCA: ![](backends/shape_density_front_pressure_qd_6x7/pca_fitness.png)
- t-SNE: tsne_skipped

## Regression summary

### quality_score

- sample_count: `594`
- ridge_alpha: `10.0000`
- ridge_r2: `0.6539`
- top_coefficients:
  - `source_aligned_rtltimer_dff_density`: `-1.0227`
  - `seq_ratio`: `0.5906`
  - `comb_ratio`: `-0.5906`
  - `masterrtl_operator_log_edges`: `-0.5098`
  - `adder_ratio`: `-0.4533`
  - `mux_cells`: `0.3478`
  - `source_aligned_rtltimer_wire_density`: `-0.3397`
  - `source_aligned_rtltimer_dff_refs`: `-0.3290`
  - `sequential_cells`: `-0.2576`
  - `arithmetic_cells`: `0.1866`

### g_P

- sample_count: `594`
- ridge_alpha: `0.1000`
- ridge_r2: `0.8563`
- top_coefficients:
  - `source_aligned_rtltimer_dff_density`: `-2.5103`
  - `source_aligned_masterrtl_node_dict`: `-2.3993`
  - `source_aligned_rtltimer_dff_refs`: `-2.0294`
  - `sequential_cells`: `1.6972`
  - `source_aligned_rtltimer_wires`: `-1.6135`
  - `cell_count_log`: `1.4915`
  - `source_aligned_masterrtl_graph_keys`: `1.3685`
  - `source_aligned_masterrtl_graph_edges`: `1.3590`
  - `arithmetic_cells`: `-0.8096`
  - `seq_ratio`: `0.5962`

### g_A

- sample_count: `594`
- ridge_alpha: `10.0000`
- ridge_r2: `0.5200`
- top_coefficients:
  - `masterrtl_operator_log_edges`: `-1.2519`
  - `arithmetic_cells`: `0.6014`
  - `source_aligned_masterrtl_branching`: `0.5631`
  - `cell_count_log`: `-0.5074`
  - `source_aligned_rtltimer_wire_density`: `-0.4662`
  - `comb_ratio`: `-0.2536`
  - `seq_ratio`: `0.2536`
  - `mux_ratio`: `0.2159`
  - `rtltimer_state_timing_class`: `0.2070`
  - `mux_cells`: `0.1777`

### g_T

- sample_count: `594`
- ridge_alpha: `10.0000`
- ridge_r2: `0.5827`
- top_coefficients:
  - `arithmetic_cells`: `-1.3694`
  - `rtltimer_state_timing_class`: `-1.3658`
  - `masterrtl_operator_log_edges`: `0.4242`
  - `source_aligned_rtltimer_assigns`: `0.3828`
  - `adder_ratio`: `0.2265`
  - `mux_cells`: `0.2095`
  - `source_aligned_rtltimer_wire_density`: `-0.1933`
  - `combinational_cells`: `0.1872`
  - `seq_ratio`: `0.1831`
  - `comb_ratio`: `-0.1831`

## Recommended large profile

- selected_non_target_features: `source_aligned_rtltimer_dff_density, rtltimer_state_timing_class, source_aligned_rtltimer_dff_refs, sequential_cells, seq_ratio, comb_ratio, source_aligned_masterrtl_node_dict`
- sequential_axes: `source_aligned_rtltimer_dff_density, rtltimer_state_timing_class, source_aligned_rtltimer_dff_refs, sequential_cells, seq_ratio, comb_ratio, source_aligned_masterrtl_node_dict, g_P, g_A, g_T`
- combinational_axes: `source_aligned_rtltimer_dff_density, rtltimer_state_timing_class, source_aligned_rtltimer_dff_refs, sequential_cells, seq_ratio, comb_ratio, source_aligned_masterrtl_node_dict, g_P, g_A`
