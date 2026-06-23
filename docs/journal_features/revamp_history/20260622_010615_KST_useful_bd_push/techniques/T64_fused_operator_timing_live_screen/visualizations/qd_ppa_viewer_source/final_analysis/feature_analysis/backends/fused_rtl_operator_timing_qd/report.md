# fused_rtl_operator_timing_qd feature-space report

- successful_candidates: `283`
- final_elites: `88`
- feature_count: `96`
- collapsed_features: `ltp_noff, rtl_instance_count_est, utilization`
- near_collapsed_features: `ltp_noff, rtl_instance_count_est, utilization`

## Top fitness correlations

- `ff_depth`: `-0.5930`
- `control_pipeline_ratio`: `0.5810`
- `sequential_cells`: `-0.5696`
- `wire_cell_ratio_est`: `-0.5435`
- `pipeline_event_count`: `-0.5276`
- `scoap_co_bin_2_pct`: `0.5202`
- `comb_ratio`: `0.4951`
- `seq_ratio`: `-0.4951`
- `rent_r2`: `0.4833`
- `mux_cells`: `-0.4588`

## Highest-variation features

- `hyper_directed_edge_count`: coverage=`1.0000`, stddev=`1013.0956`, unique=`55`
- `rtl_char_count`: coverage=`1.0000`, stddev=`919.6197`, unique=`250`
- `sog_complexity_score`: coverage=`1.0000`, stddev=`726.2275`, unique=`57`
- `hyper_driven_net_count`: coverage=`1.0000`, stddev=`579.6564`, unique=`62`
- `hyper_net_count`: coverage=`1.0000`, stddev=`579.6564`, unique=`62`
- `hyper_sink_net_count`: coverage=`1.0000`, stddev=`579.5497`, unique=`63`
- `total_cells`: coverage=`1.0000`, stddev=`450.4104`, unique=`56`
- `hyper_cell_count`: coverage=`1.0000`, stddev=`378.7755`, unique=`45`
- `rent_graph_node_count`: coverage=`1.0000`, stddev=`378.7755`, unique=`45`
- `combinational_cells`: coverage=`1.0000`, stddev=`347.0596`, unique=`46`

## Plot files

- histogram: ![](./feature_histograms.png)
- PCA: ![](./pca_fitness.png)
- t-SNE: tsne_skipped
