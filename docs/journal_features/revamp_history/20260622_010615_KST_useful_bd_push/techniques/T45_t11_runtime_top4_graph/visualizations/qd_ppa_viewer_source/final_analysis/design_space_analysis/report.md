# Design-Space Analysis

- backends: `classic, t11_runtime_top4_graph_qd`
- successful_candidates: `102`
- classical_anchor_backend: `classic`
- feature_selection_mode: `auto`
- selected_features: `none`

## Contents

- [Reports](#reports)
- [Problems](#problems)
- [Warnings](#warnings)

## Reports

- aggregate: [report.md](aggregate/report.md)
- successful candidates: [successful_candidates.csv](successful_candidates.csv)
- recommended profile: [recommended_profile.json](recommended_profile.json)
- all-backend feature plots use the report's selected feature subset
- pairwise classic-vs-QD feature plots use the QD backend's descriptor basis when available

## Problems

- `RTLLM/Prob045_alu`: [report.md](problems/RTLLM/Prob045_alu/report.md)
- `RTLLM/Prob041_traffic_light`: [report.md](problems/RTLLM/Prob041_traffic_light/report.md)
- `RTLLM/Prob015_multi_pipe_8bit`: [report.md](problems/RTLLM/Prob015_multi_pipe_8bit/report.md)

## Warnings

- Skipped automatic graph recovery for graph-backed features `hyper_mean_fanout, edge_per_node, log_edge_count, hyper_directed_edge_count`; cached QD descriptor values are still used when present.
- classic vs t11_runtime_top4_graph_qd: descriptor features are cached only for the QD backend; plotting cached QD descriptor rows without offline classic graph recovery.
