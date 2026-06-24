# Design-Space Analysis

- backends: `classic_revolution_12x3, shape_density_front_pressure_qd_12x3, classic_revolution_8x5, shape_density_front_pressure_qd_8x5, classic_revolution_6x7, shape_density_front_pressure_qd_6x7`
- successful_candidates: `1214`
- classical_anchor_backend: `unresolved`
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

- `RTLLM/Prob015_multi_pipe_8bit`: [report.md](problems/RTLLM/Prob015_multi_pipe_8bit/report.md)
- `RTLLM/Prob024_fsm`: [report.md](problems/RTLLM/Prob024_fsm/report.md)
- `RTLLM/Prob041_traffic_light`: [report.md](problems/RTLLM/Prob041_traffic_light/report.md)
- `RTLLM/Prob045_alu`: [report.md](problems/RTLLM/Prob045_alu/report.md)
- `RTLLM/Prob049_signal_generator`: [report.md](problems/RTLLM/Prob049_signal_generator/report.md)
- `VerilogEval-Spec-to-RTL/Prob116_m2014_q3`: [report.md](problems/VerilogEval-Spec-to-RTL/Prob116_m2014_q3/report.md)
- `VerilogEval-Spec-to-RTL/Prob135_m2014_q6b`: [report.md](problems/VerilogEval-Spec-to-RTL/Prob135_m2014_q6b/report.md)
- `VerilogEval-Spec-to-RTL/Prob153_gshare`: [report.md](problems/VerilogEval-Spec-to-RTL/Prob153_gshare/report.md)

## Warnings

- Found multiple non-QD candidate backends for pairwise feature plots: classic_revolution_12x3, classic_revolution_8x5, classic_revolution_6x7.
- Skipped pairwise feature plots because no classical anchor backend was available.
