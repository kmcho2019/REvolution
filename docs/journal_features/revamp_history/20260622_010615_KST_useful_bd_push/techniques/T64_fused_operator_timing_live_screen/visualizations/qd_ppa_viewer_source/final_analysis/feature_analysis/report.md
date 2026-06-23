# QD Feature-Space Analysis

## Backend aggregate comparison

| Backend | Functionality | Synthesis | Solved | Best score | Runtime (s) | QD coverage | QD score |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| classic | 42.6% | 41.2% | 13 | 0.2279 | 991.6 | N/A | N/A |
| fused_rtl_operator_timing_qd | 46.2% | 45.4% | 13 | 0.2270 | 1059.4 | 45.6% | 1.0156 |

## QD backend feature-space summary

### fused_rtl_operator_timing_qd

- successful_candidates: `283`
- final_elites: `88`
- collapsed_features: `ltp_noff, rtl_instance_count_est, utilization`
- near_collapsed_features: `ltp_noff, rtl_instance_count_est, utilization`
- histogram: ![](backends/fused_rtl_operator_timing_qd/feature_histograms.png)
- PCA: ![](backends/fused_rtl_operator_timing_qd/pca_fitness.png)
- t-SNE: tsne_skipped

## Regression summary

### quality_score

- sample_count: `283`
- ridge_alpha: `100.0000`
- ridge_r2: `0.7740`
- top_coefficients:
  - `wire_cell_ratio_est`: `-0.1586`
  - `scoap_cc0_bin_2_pct`: `-0.1383`
  - `scoap_co_bin_1_pct`: `0.1382`
  - `scoap_co_bin_3_pct`: `-0.1147`
  - `scoap_cc0_bin_3_pct`: `0.1121`
  - `if_count`: `-0.1092`
  - `for_count`: `-0.1089`
  - `max_identifier_fanout`: `0.1044`
  - `compare_count`: `-0.0978`
  - `control_pipeline_ratio`: `0.0937`

### g_P

- sample_count: `283`
- ridge_alpha: `100.0000`
- ridge_r2: `0.8586`
- top_coefficients:
  - `if_count`: `-0.1364`
  - `operator_mix_score`: `0.1338`
  - `control_count`: `-0.1038`
  - `scoap_cc0_bin_3_pct`: `0.0958`
  - `wire_cell_ratio_est`: `-0.0899`
  - `scoap_co_bin_1_pct`: `0.0798`
  - `scoap_cc0_bin_2_pct`: `-0.0783`
  - `scoap_cc1_bin_3_pct`: `0.0738`
  - `always_count`: `-0.0680`
  - `fsm_state_count_est`: `-0.0658`

### g_A

- sample_count: `283`
- ridge_alpha: `1.0000`
- ridge_r2: `0.9701`
- top_coefficients:
  - `laplacian_lambda2`: `1.0371`
  - `wire_cell_ratio_est`: `-0.9952`
  - `wire_count_log_est`: `-0.8074`
  - `scoap_cc0_bin_3_pct`: `0.7852`
  - `cell_count_log`: `-0.6313`
  - `scoap_cc0_bin_1_pct`: `-0.5949`
  - `scoap_cc1_bin_1_pct`: `0.5277`
  - `arithmetic_cells`: `0.4569`
  - `comb_ratio`: `-0.4502`
  - `seq_ratio`: `0.4502`

### g_T

- sample_count: `283`
- ridge_alpha: `100.0000`
- ridge_r2: `0.8404`
- top_coefficients:
  - `state_control_ratio`: `-0.1620`
  - `scoap_signal_smoothness`: `0.1439`
  - `hyper_mean_fanout`: `0.1426`
  - `math_op_ast_count`: `-0.1398`
  - `rent_r2`: `-0.1203`
  - `log_max_level`: `-0.1145`
  - `resource_sharing_ratio_est`: `0.1124`
  - `arithmetic_cells`: `-0.1112`
  - `control_pipeline_ratio`: `0.0998`
  - `operator_mix_score`: `0.0947`

## Recommended large profile

- selected_non_target_features: `seq_ratio, sequential_cells, ff_depth, pipeline_event_count, always_count, rent_exponent, rent_r2`
- sequential_axes: `seq_ratio, sequential_cells, ff_depth, pipeline_event_count, always_count, rent_exponent, rent_r2, g_P, g_A, g_T`
- combinational_axes: `seq_ratio, sequential_cells, ff_depth, pipeline_event_count, always_count, rent_exponent, rent_r2, g_P, g_A`
