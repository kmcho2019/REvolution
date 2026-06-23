# fused_rtl_state_pipeline_qd feature-space report

- successful_candidates: `257`
- final_elites: `69`
- feature_count: `96`
- collapsed_features: `ltp_noff, rtl_instance_count_est, utilization`
- near_collapsed_features: `ltp_noff, rtl_instance_count_est, utilization`

## Top fitness correlations

- `control_pipeline_ratio`: `0.6134`
- `ff_depth`: `-0.5597`
- `sequential_cells`: `-0.5553`
- `wire_cell_ratio_est`: `-0.5354`
- `pipeline_event_count`: `-0.5113`
- `scoap_co_bin_2_pct`: `0.4996`
- `operator_mix_score`: `0.4573`
- `comb_ratio`: `0.4418`
- `seq_ratio`: `-0.4418`
- `scoap_cc1_bin_2_pct`: `0.4043`

## Highest-variation features

- `hyper_directed_edge_count`: coverage=`1.0000`, stddev=`1060.9966`, unique=`53`
- `rtl_char_count`: coverage=`1.0000`, stddev=`941.5927`, unique=`237`
- `sog_complexity_score`: coverage=`1.0000`, stddev=`779.9910`, unique=`53`
- `hyper_driven_net_count`: coverage=`1.0000`, stddev=`630.5067`, unique=`59`
- `hyper_net_count`: coverage=`1.0000`, stddev=`630.5067`, unique=`59`
- `hyper_sink_net_count`: coverage=`1.0000`, stddev=`630.3705`, unique=`58`
- `total_cells`: coverage=`1.0000`, stddev=`505.0163`, unique=`63`
- `hyper_cell_count`: coverage=`1.0000`, stddev=`406.3720`, unique=`43`
- `rent_graph_node_count`: coverage=`1.0000`, stddev=`406.3720`, unique=`43`
- `combinational_cells`: coverage=`1.0000`, stddev=`373.2060`, unique=`41`

## Plot files

- histogram: ![](./feature_histograms.png)
- PCA: ![](./pca_fitness.png)
- t-SNE: tsne_skipped
