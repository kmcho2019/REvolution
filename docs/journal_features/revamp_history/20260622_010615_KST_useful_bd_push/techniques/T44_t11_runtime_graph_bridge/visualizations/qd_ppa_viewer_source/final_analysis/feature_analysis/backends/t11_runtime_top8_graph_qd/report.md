# t11_runtime_top8_graph_qd feature-space report

- successful_candidates: `36`
- final_elites: `30`
- feature_count: `60`
- collapsed_features: `logic_depth_ltp_delta, ltp_noff, utilization`
- near_collapsed_features: `logic_depth_ltp_delta, ltp_noff, utilization`

## Top fitness correlations

- `ff_depth`: `-0.8853`
- `sequential_cells`: `-0.8686`
- `comb_ratio`: `0.8075`
- `seq_ratio`: `-0.8075`
- `scoap_cc0_bin_3_pct`: `0.7729`
- `scoap_cc1_bin_0_pct`: `-0.7684`
- `scoap_cc0_bin_0_pct`: `-0.7653`
- `scoap_cc1_bin_3_pct`: `0.7235`
- `rent_exponent_confidence_gated`: `0.7199`
- `scoap_co_bin_0_pct`: `-0.7187`

## Highest-variation features

- `total_cells`: coverage=`1.0000`, stddev=`564.9862`, unique=`32`
- `hyper_driven_net_count`: coverage=`1.0000`, stddev=`207.3681`, unique=`25`
- `hyper_net_count`: coverage=`1.0000`, stddev=`207.3681`, unique=`25`
- `hyper_sink_net_count`: coverage=`1.0000`, stddev=`205.3369`, unique=`25`
- `mux_cells`: coverage=`1.0000`, stddev=`110.8921`, unique=`24`
- `arithmetic_cells`: coverage=`1.0000`, stddev=`46.0333`, unique=`14`
- `sequential_cells`: coverage=`1.0000`, stddev=`40.7198`, unique=`11`
- `hyper_directed_edge_count`: coverage=`1.0000`, stddev=`21.9357`, unique=`26`
- `combinational_cells`: coverage=`1.0000`, stddev=`18.1666`, unique=`17`
- `hyper_cell_count`: coverage=`1.0000`, stddev=`15.8857`, unique=`23`

## Plot files

- histogram: ![](./feature_histograms.png)
- PCA: ![](./pca_fitness.png)
- t-SNE: tsne_skipped
