# rtl_native_seeded_thought_qd feature-space report

- successful_candidates: `141`
- final_elites: `44`
- feature_count: `96`
- collapsed_features: `ltp_noff, rtl_instance_count_est, utilization`
- near_collapsed_features: `ltp_noff, rtl_instance_count_est, utilization`

## Top fitness correlations

- `max_identifier_fanout`: `0.6037`
- `logic_op_count`: `0.5800`
- `logic_depth_ltp`: `0.5749`
- `logic_depth`: `0.5707`
- `wire_cell_ratio_est`: `-0.5653`
- `control_pipeline_ratio`: `0.5419`
- `resource_sharing_ratio_est`: `-0.5335`
- `scoap_co_bin_0_pct`: `-0.5279`
- `scoap_cc0_bin_0_pct`: `-0.4897`
- `scoap_cc1_bin_0_pct`: `-0.4897`

## Highest-variation features

- `rtl_char_count`: coverage=`1.0000`, stddev=`946.5683`, unique=`115`
- `total_cells`: coverage=`1.0000`, stddev=`335.6140`, unique=`32`
- `hyper_sink_net_count`: coverage=`1.0000`, stddev=`118.7908`, unique=`35`
- `hyper_driven_net_count`: coverage=`1.0000`, stddev=`118.7456`, unique=`34`
- `hyper_net_count`: coverage=`1.0000`, stddev=`118.7456`, unique=`34`
- `mux_cells`: coverage=`1.0000`, stddev=`57.9366`, unique=`16`
- `arithmetic_cells`: coverage=`1.0000`, stddev=`37.0916`, unique=`10`
- `rtl_line_count`: coverage=`1.0000`, stddev=`26.6308`, unique=`56`
- `rtl_nonempty_line_count`: coverage=`1.0000`, stddev=`24.8292`, unique=`54`
- `sog_complexity_score`: coverage=`1.0000`, stddev=`21.1210`, unique=`34`

## Plot files

- histogram: ![](./feature_histograms.png)
- PCA: ![](./pca_fitness.png)
- t-SNE: tsne_skipped
