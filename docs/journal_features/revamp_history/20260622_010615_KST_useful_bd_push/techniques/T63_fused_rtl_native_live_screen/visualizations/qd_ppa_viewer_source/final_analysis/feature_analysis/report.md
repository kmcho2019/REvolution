# QD Feature-Space Analysis

## Backend aggregate comparison

| Backend | Functionality | Synthesis | Solved | Best score | Runtime (s) | QD coverage | QD score |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| classic | 42.6% | 41.2% | 13 | 0.2279 | 991.6 | N/A | N/A |
| fused_rtl_state_pipeline_qd | 41.7% | 41.2% | 13 | 0.2683 | 1081.8 | 58.7% | 0.7348 |

## QD backend feature-space summary

### fused_rtl_state_pipeline_qd

- successful_candidates: `257`
- final_elites: `69`
- collapsed_features: `ltp_noff, rtl_instance_count_est, utilization`
- near_collapsed_features: `ltp_noff, rtl_instance_count_est, utilization`
- histogram: ![](backends/fused_rtl_state_pipeline_qd/feature_histograms.png)
- PCA: ![](backends/fused_rtl_state_pipeline_qd/pca_fitness.png)
- t-SNE: tsne_skipped

## Regression summary

### quality_score

- sample_count: `257`
- ridge_alpha: `100.0000`
- ridge_r2: `0.8103`
- top_coefficients:
  - `wire_cell_ratio_est`: `-0.1379`
  - `scoap_cc0_bin_2_pct`: `-0.1226`
  - `mux_ratio`: `-0.1146`
  - `rent_retained_sample_ratio`: `0.1109`
  - `pipeline_event_count`: `-0.1103`
  - `operator_mix_score`: `0.1034`
  - `for_count`: `-0.1000`
  - `max_identifier_fanout`: `0.0957`
  - `scoap_co_bin_1_pct`: `0.0924`
  - `case_count`: `0.0902`

### g_P

- sample_count: `257`
- ridge_alpha: `10.0000`
- ridge_r2: `0.9182`
- top_coefficients:
  - `operator_mix_score`: `0.2448`
  - `scoap_cc0_bin_3_pct`: `0.2436`
  - `hyper_max_fanout`: `-0.1879`
  - `scoap_cc0_bin_2_pct`: `-0.1839`
  - `sog_entropy`: `-0.1824`
  - `control_count`: `-0.1765`
  - `pipeline_event_count`: `-0.1707`
  - `scoap_cc0_bin_0_pct`: `-0.1686`
  - `scoap_co_bin_1_pct`: `0.1594`
  - `ternary_count`: `-0.1579`

### g_A

- sample_count: `257`
- ridge_alpha: `100.0000`
- ridge_r2: `0.7000`
- top_coefficients:
  - `wire_cell_ratio_est`: `-0.2127`
  - `rent_retained_sample_ratio`: `0.1993`
  - `scoap_co_bin_3_pct`: `-0.1768`
  - `max_rhs_operator_count`: `-0.1489`
  - `laplacian_lambda2`: `0.1467`
  - `ternary_count`: `0.1376`
  - `scoap_co_bin_1_pct`: `0.1236`
  - `scoap_cc0_bin_2_pct`: `-0.1175`
  - `for_count`: `-0.1171`
  - `timing_risk_entropy`: `0.1132`

### g_T

- sample_count: `257`
- ridge_alpha: `10.0000`
- ridge_r2: `0.8990`
- top_coefficients:
  - `log_max_level`: `-0.2990`
  - `rent_r2`: `-0.2926`
  - `control_pipeline_ratio`: `0.2559`
  - `scoap_cc0_bin_0_pct`: `-0.2115`
  - `scoap_cc0_bin_3_pct`: `0.2060`
  - `control_count`: `-0.2036`
  - `hyper_mean_fanout`: `0.1890`
  - `scoap_cc1_bin_2_pct`: `0.1739`
  - `rent_k`: `-0.1673`
  - `resource_sharing_ratio_est`: `0.1581`

## Recommended large profile

- selected_non_target_features: `seq_ratio, sequential_cells, ff_depth, pipeline_event_count, control_pipeline_ratio, logic_op_count, scoap_co_bin_2_pct`
- sequential_axes: `seq_ratio, sequential_cells, ff_depth, pipeline_event_count, control_pipeline_ratio, logic_op_count, scoap_co_bin_2_pct, g_P, g_A, g_T`
- combinational_axes: `seq_ratio, sequential_cells, ff_depth, pipeline_event_count, control_pipeline_ratio, logic_op_count, scoap_co_bin_2_pct, g_P, g_A`
