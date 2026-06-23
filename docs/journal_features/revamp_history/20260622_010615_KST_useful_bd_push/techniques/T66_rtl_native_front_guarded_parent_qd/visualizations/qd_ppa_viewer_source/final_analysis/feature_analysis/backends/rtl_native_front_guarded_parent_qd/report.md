# rtl_native_front_guarded_parent_qd feature-space report

- successful_candidates: `260`
- final_elites: `72`
- feature_count: `96`
- collapsed_features: `ltp_noff, rtl_instance_count_est, utilization`
- near_collapsed_features: `ltp_noff, rtl_instance_count_est, utilization`

## Top fitness correlations

- `sequential_cells`: `-0.6936`
- `ff_depth`: `-0.6695`
- `wire_cell_ratio_est`: `-0.6691`
- `pipeline_event_count`: `-0.6350`
- `comb_ratio`: `0.6197`
- `seq_ratio`: `-0.6197`
- `operator_mix_score`: `0.6161`
- `control_pipeline_ratio`: `0.5760`
- `logic_depth`: `0.5293`
- `logic_depth_ltp`: `0.5250`

## Highest-variation features

- `rtl_char_count`: coverage=`1.0000`, stddev=`1025.4771`, unique=`243`
- `hyper_directed_edge_count`: coverage=`1.0000`, stddev=`1007.4398`, unique=`61`
- `sog_complexity_score`: coverage=`1.0000`, stddev=`722.9551`, unique=`56`
- `hyper_driven_net_count`: coverage=`1.0000`, stddev=`574.8217`, unique=`66`
- `hyper_net_count`: coverage=`1.0000`, stddev=`574.8217`, unique=`66`
- `hyper_sink_net_count`: coverage=`1.0000`, stddev=`574.2905`, unique=`61`
- `total_cells`: coverage=`1.0000`, stddev=`498.9227`, unique=`64`
- `hyper_cell_count`: coverage=`1.0000`, stddev=`377.1213`, unique=`47`
- `rent_graph_node_count`: coverage=`1.0000`, stddev=`377.1213`, unique=`47`
- `combinational_cells`: coverage=`1.0000`, stddev=`345.4799`, unique=`48`

## Plot files

- histogram: ![](./feature_histograms.png)
- PCA: ![](./pca_fitness.png)
- t-SNE: tsne_skipped
