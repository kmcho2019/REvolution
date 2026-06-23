# Design-Space Analysis

- backends: `classic, fused_rtl_operator_timing_qd`
- successful_candidates: `540`
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

- `RTLLM/Prob004_adder_8bit`: [report.md](problems/RTLLM/Prob004_adder_8bit/report.md)
- `RTLLM/Prob015_multi_pipe_8bit`: [report.md](problems/RTLLM/Prob015_multi_pipe_8bit/report.md)
- `RTLLM/Prob024_fsm`: [report.md](problems/RTLLM/Prob024_fsm/report.md)
- `RTLLM/Prob037_parallel2serial`: [report.md](problems/RTLLM/Prob037_parallel2serial/report.md)
- `RTLLM/Prob041_traffic_light`: [report.md](problems/RTLLM/Prob041_traffic_light/report.md)
- `RTLLM/Prob045_alu`: [report.md](problems/RTLLM/Prob045_alu/report.md)
- `RTLLM/Prob049_signal_generator`: [report.md](problems/RTLLM/Prob049_signal_generator/report.md)
- `VerilogEval-Spec-to-RTL/Prob098_circuit7`: [report.md](problems/VerilogEval-Spec-to-RTL/Prob098_circuit7/report.md)
- `VerilogEval-Spec-to-RTL/Prob116_m2014_q3`: [report.md](problems/VerilogEval-Spec-to-RTL/Prob116_m2014_q3/report.md)
- `VerilogEval-Spec-to-RTL/Prob135_m2014_q6b`: [report.md](problems/VerilogEval-Spec-to-RTL/Prob135_m2014_q6b/report.md)
- `VerilogEval-Spec-to-RTL/Prob150_review2015_fsmonehot`: [report.md](problems/VerilogEval-Spec-to-RTL/Prob150_review2015_fsmonehot/report.md)
- `VerilogEval-Spec-to-RTL/Prob151_review2015_fsm`: [report.md](problems/VerilogEval-Spec-to-RTL/Prob151_review2015_fsm/report.md)
- `VerilogEval-Spec-to-RTL/Prob153_gshare`: [report.md](problems/VerilogEval-Spec-to-RTL/Prob153_gshare/report.md)

## Warnings

- Skipped automatic graph recovery for graph-backed features `operator_mix_score`; cached QD descriptor values are still used when present.
- classic vs fused_rtl_operator_timing_qd: descriptor features are cached only for the QD backend; plotting cached QD descriptor rows without offline classic graph recovery.
