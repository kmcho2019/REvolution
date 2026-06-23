# QD Feature-Space Analysis

## Backend aggregate comparison

| Backend | Functionality | Synthesis | Solved | Best score | Runtime (s) | QD coverage | QD score |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| classic | 42.6% | 41.2% | 13 | 0.2279 | 991.6 | N/A | N/A |
| rtl_native_front_guarded_parent_qd | 42.9% | 41.7% | 13 | 0.2780 | 1081.0 | 63.9% | 0.7821 |

## QD backend feature-space summary

### rtl_native_front_guarded_parent_qd

- successful_candidates: `260`
- final_elites: `72`
- collapsed_features: `ltp_noff, rtl_instance_count_est, utilization`
- near_collapsed_features: `ltp_noff, rtl_instance_count_est, utilization`
- histogram: ![](backends/rtl_native_front_guarded_parent_qd/feature_histograms.png)
- PCA: ![](backends/rtl_native_front_guarded_parent_qd/pca_fitness.png)
- t-SNE: tsne_skipped

## Regression summary

### quality_score

- sample_count: `260`
- ridge_alpha: `100.0000`
- ridge_r2: `0.7648`
- top_coefficients:
  - `wire_cell_ratio_est`: `-0.1537`
  - `max_identifier_fanout`: `0.0943`
  - `logic_op_count`: `0.0870`
  - `rent_retained_sample_ratio`: `0.0805`
  - `scoap_cc0_bin_3_pct`: `0.0780`
  - `operator_mix_score`: `0.0761`
  - `scoap_signal_smoothness`: `0.0749`
  - `scoap_co_bin_2_pct`: `0.0689`
  - `if_count`: `-0.0685`
  - `scoap_cc0_bin_0_pct`: `-0.0617`

### g_P

- sample_count: `260`
- ridge_alpha: `10.0000`
- ridge_r2: `0.9079`
- top_coefficients:
  - `operator_mix_score`: `0.2350`
  - `if_count`: `-0.2037`
  - `mux_cells`: `0.1944`
  - `compare_count`: `0.1914`
  - `rtl_cyclomatic_max_log`: `-0.1674`
  - `control_count`: `-0.1515`
  - `scoap_cc0_bin_3_pct`: `0.1486`
  - `unique_identifier_count`: `-0.1438`
  - `adder_ratio`: `-0.1353`
  - `rtl_cyclomatic_total_log`: `-0.1341`

### g_A

- sample_count: `260`
- ridge_alpha: `100.0000`
- ridge_r2: `0.6848`
- top_coefficients:
  - `wire_cell_ratio_est`: `-0.1620`
  - `rent_retained_sample_ratio`: `0.1441`
  - `laplacian_lambda2`: `0.1430`
  - `compare_count`: `-0.1133`
  - `scoap_co_bin_3_pct`: `-0.1124`
  - `adder_ratio`: `0.1100`
  - `ternary_count`: `0.0978`
  - `operator_mix_score`: `-0.0974`
  - `reconv_source_ratio`: `0.0903`
  - `share_family_inv`: `-0.0876`

### g_T

- sample_count: `260`
- ridge_alpha: `10.0000`
- ridge_r2: `0.9615`
- top_coefficients:
  - `log_max_level`: `-0.2709`
  - `resource_sharing_ratio_est`: `0.2293`
  - `arithmetic_cells`: `-0.2218`
  - `rent_r2`: `-0.2218`
  - `scoap_signal_smoothness`: `0.1909`
  - `comb_ratio`: `-0.1571`
  - `seq_ratio`: `0.1571`
  - `share_family_inv`: `0.1495`
  - `wire_count_log_est`: `-0.1404`
  - `logic_op_count`: `0.1362`

## Recommended large profile

- selected_non_target_features: `seq_ratio, sequential_cells, pipeline_event_count, ff_depth, if_count, rent_exponent, always_count`
- sequential_axes: `seq_ratio, sequential_cells, pipeline_event_count, ff_depth, if_count, rent_exponent, always_count, g_P, g_A, g_T`
- combinational_axes: `seq_ratio, sequential_cells, pipeline_event_count, ff_depth, if_count, rent_exponent, always_count, g_P, g_A`
