# QD Feature-Space Analysis

## Backend aggregate comparison

| Backend | Functionality | Synthesis | Solved | Best score | Runtime (s) | QD coverage | QD score |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| classic | 42.6% | 41.2% | 13 | 0.2279 | 991.6 | N/A | N/A |
| rtl_native_seeded_thought_qd | 49.0% | 48.7% | 12 | 0.2266 | 2411.8 | 42.9% | 0.5304 |

## QD backend feature-space summary

### rtl_native_seeded_thought_qd

- successful_candidates: `141`
- final_elites: `44`
- collapsed_features: `ltp_noff, rtl_instance_count_est, utilization`
- near_collapsed_features: `ltp_noff, rtl_instance_count_est, utilization`
- histogram: ![](backends/rtl_native_seeded_thought_qd/feature_histograms.png)
- PCA: ![](backends/rtl_native_seeded_thought_qd/pca_fitness.png)
- t-SNE: tsne_skipped

## Regression summary

### quality_score

- sample_count: `141`
- ridge_alpha: `10.0000`
- ridge_r2: `0.9620`
- top_coefficients:
  - `resource_sharing_ratio_est`: `-0.2937`
  - `scoap_cc0_bin_2_pct`: `-0.2415`
  - `scoap_cc0_bin_3_pct`: `0.2279`
  - `ff_depth`: `-0.1990`
  - `math_op_ast_count`: `-0.1907`
  - `operator_mix_score`: `-0.1590`
  - `rent_clamped_flag`: `0.1462`
  - `scoap_co_bin_2_pct`: `0.1455`
  - `for_count`: `-0.1424`
  - `pipeline_event_count`: `0.1407`

### g_P

- sample_count: `141`
- ridge_alpha: `1.0000`
- ridge_r2: `0.9980`
- top_coefficients:
  - `scoap_signal_smoothness`: `-0.2832`
  - `math_op_ast_count`: `-0.2779`
  - `resource_sharing_ratio_est`: `-0.2708`
  - `scoap_cc0_bin_2_pct`: `-0.2358`
  - `scoap_cc0_bin_3_pct`: `0.2309`
  - `scoap_cc1_bin_3_pct`: `0.1988`
  - `arith_count`: `0.1878`
  - `control_count`: `-0.1840`
  - `sog_entropy`: `-0.1818`
  - `log_max_level`: `-0.1804`

### g_A

- sample_count: `141`
- ridge_alpha: `100.0000`
- ridge_r2: `0.7420`
- top_coefficients:
  - `for_count`: `-0.1383`
  - `scoap_cc0_bin_2_pct`: `-0.1163`
  - `scoap_cc0_bin_3_pct`: `0.1043`
  - `adder_ratio`: `0.1043`
  - `scoap_cc1_bin_2_pct`: `-0.0839`
  - `operator_mix_score`: `-0.0836`
  - `ff_depth`: `-0.0832`
  - `rent_clamped_flag`: `0.0827`
  - `timing_risk_entropy`: `0.0791`
  - `fsm_state_count_est`: `-0.0741`

### g_T

- sample_count: `141`
- ridge_alpha: `100.0000`
- ridge_r2: `0.8914`
- top_coefficients:
  - `ff_depth`: `-0.1740`
  - `rent_r2`: `-0.1255`
  - `sequential_cells`: `-0.1216`
  - `math_op_ast_count`: `-0.1044`
  - `fsm_state_count_est`: `0.0915`
  - `resource_sharing_ratio_est`: `0.0858`
  - `scoap_signal_smoothness`: `0.0819`
  - `log_max_level`: `-0.0732`
  - `if_count`: `-0.0691`
  - `ternary_count`: `0.0622`

## Recommended large profile

- selected_non_target_features: `seq_ratio, logic_op_count, logic_depth, logic_depth_ltp, sequential_cells, scoap_co_bin_2_pct, pipeline_event_count`
- sequential_axes: `seq_ratio, logic_op_count, logic_depth, logic_depth_ltp, sequential_cells, scoap_co_bin_2_pct, pipeline_event_count, g_P, g_A, g_T`
- combinational_axes: `seq_ratio, logic_op_count, logic_depth, logic_depth_ltp, sequential_cells, scoap_co_bin_2_pct, pipeline_event_count, g_P, g_A`

## Warnings

- Generation log missing or unusable; using final_population_ppa_details only for rtl_native_seeded_thought_qd/VerilogEval-Spec-to-RTL/Prob153_gshare.
