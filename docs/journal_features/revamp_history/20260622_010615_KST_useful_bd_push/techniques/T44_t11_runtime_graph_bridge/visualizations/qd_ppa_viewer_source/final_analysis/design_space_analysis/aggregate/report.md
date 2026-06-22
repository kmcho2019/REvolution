# Aggregate Design-Space Views

Raw pooled PPA plots mix different problems and units. Treat those figures as qualitative-only.

Pairwise feature plots use the QD backend's descriptor basis when that metadata is available.

## Contents

- [overall / combinational / normalized PPA](#overall-combinational-normalized-ppa)
- [overall / combinational / raw PPA](#overall-combinational-raw-ppa)
- [overall / combinational / feature space](#overall-combinational-feature-space)
- [overall / combinational / classic vs t11_runtime_top8_graph_qd](#overall-combinational-classic-vs-t11_runtime_top8_graph_qd)
- [overall / sequential / normalized PPA](#overall-sequential-normalized-ppa)
- [overall / sequential / raw PPA](#overall-sequential-raw-ppa)
- [overall / sequential / feature space](#overall-sequential-feature-space)
- [overall / sequential / classic vs t11_runtime_top8_graph_qd](#overall-sequential-classic-vs-t11_runtime_top8_graph_qd)
- [RTLLM / combinational / normalized PPA](#rtllm-combinational-normalized-ppa)
- [RTLLM / combinational / raw PPA](#rtllm-combinational-raw-ppa)
- [RTLLM / combinational / feature space](#rtllm-combinational-feature-space)
- [RTLLM / combinational / classic vs t11_runtime_top8_graph_qd](#rtllm-combinational-classic-vs-t11_runtime_top8_graph_qd)
- [RTLLM / sequential / normalized PPA](#rtllm-sequential-normalized-ppa)
- [RTLLM / sequential / raw PPA](#rtllm-sequential-raw-ppa)
- [RTLLM / sequential / feature space](#rtllm-sequential-feature-space)
- [RTLLM / sequential / classic vs t11_runtime_top8_graph_qd](#rtllm-sequential-classic-vs-t11_runtime_top8_graph_qd)

## overall / combinational / normalized PPA

- `normalized g_P vs g_A`: ![](overall_combinational_normalized_g_P_g_A.png)

## overall / combinational / raw PPA

- `raw Power vs Area`: ![](overall_combinational_raw_power_area.png)

## overall / combinational / feature space

- feature basis: `recommended report feature subset`
- features: `none`

- `feature PCA`: `too_few_varying_features`

## overall / combinational / classic vs t11_runtime_top8_graph_qd

- feature basis: `t11_runtime_top8_graph descriptor profile`
- features: `hyper_mean_fanout, edge_per_node, log_edge_count, hyper_directed_edge_count, hyper_fanout_entropy, hyper_driven_net_count, hyper_sink_net_count, log_net_count`

- `PCA`: ![](overall_combinational_classic_vs_t11_runtime_top8_graph_qd_features_pca.png)

## overall / sequential / normalized PPA

- `normalized g_P vs g_A`: ![](overall_sequential_normalized_g_P_g_A.png)
- `normalized g_P vs g_T`: ![](overall_sequential_normalized_g_P_g_T.png)
- `normalized g_A vs g_T`: ![](overall_sequential_normalized_g_A_g_T.png)

## overall / sequential / raw PPA

- `raw Power vs Area`: ![](overall_sequential_raw_power_area.png)
- `raw Power vs Performance`: ![](overall_sequential_raw_power_eff_clk_period.png)
- `raw Area vs Performance`: ![](overall_sequential_raw_area_eff_clk_period.png)

## overall / sequential / feature space

- feature basis: `recommended report feature subset`
- features: `none`

- `feature PCA`: `too_few_varying_features`

## overall / sequential / classic vs t11_runtime_top8_graph_qd

- feature basis: `t11_runtime_top8_graph descriptor profile`
- features: `hyper_mean_fanout, edge_per_node, log_edge_count, hyper_directed_edge_count, hyper_fanout_entropy, hyper_driven_net_count, hyper_sink_net_count, log_net_count`

- `PCA`: ![](overall_sequential_classic_vs_t11_runtime_top8_graph_qd_features_pca.png)

## RTLLM / combinational / normalized PPA

- `normalized g_P vs g_A`: ![](RTLLM_combinational_normalized_g_P_g_A.png)

## RTLLM / combinational / raw PPA

- `raw Power vs Area`: ![](RTLLM_combinational_raw_power_area.png)

## RTLLM / combinational / feature space

- feature basis: `recommended report feature subset`
- features: `none`

- `feature PCA`: `too_few_varying_features`

## RTLLM / combinational / classic vs t11_runtime_top8_graph_qd

- feature basis: `t11_runtime_top8_graph descriptor profile`
- features: `hyper_mean_fanout, edge_per_node, log_edge_count, hyper_directed_edge_count, hyper_fanout_entropy, hyper_driven_net_count, hyper_sink_net_count, log_net_count`

- `PCA`: ![](RTLLM_combinational_classic_vs_t11_runtime_top8_graph_qd_features_pca.png)

## RTLLM / sequential / normalized PPA

- `normalized g_P vs g_A`: ![](RTLLM_sequential_normalized_g_P_g_A.png)
- `normalized g_P vs g_T`: ![](RTLLM_sequential_normalized_g_P_g_T.png)
- `normalized g_A vs g_T`: ![](RTLLM_sequential_normalized_g_A_g_T.png)

## RTLLM / sequential / raw PPA

- `raw Power vs Area`: ![](RTLLM_sequential_raw_power_area.png)
- `raw Power vs Performance`: ![](RTLLM_sequential_raw_power_eff_clk_period.png)
- `raw Area vs Performance`: ![](RTLLM_sequential_raw_area_eff_clk_period.png)

## RTLLM / sequential / feature space

- feature basis: `recommended report feature subset`
- features: `none`

- `feature PCA`: `too_few_varying_features`

## RTLLM / sequential / classic vs t11_runtime_top8_graph_qd

- feature basis: `t11_runtime_top8_graph descriptor profile`
- features: `hyper_mean_fanout, edge_per_node, log_edge_count, hyper_directed_edge_count, hyper_fanout_entropy, hyper_driven_net_count, hyper_sink_net_count, log_net_count`

- `PCA`: ![](RTLLM_sequential_classic_vs_t11_runtime_top8_graph_qd_features_pca.png)
