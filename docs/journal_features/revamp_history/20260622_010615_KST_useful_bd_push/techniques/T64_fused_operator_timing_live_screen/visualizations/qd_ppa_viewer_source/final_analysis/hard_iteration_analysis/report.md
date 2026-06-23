# Hard Iteration Subset Analysis

- Subset: `hard_iteration_subset`
- Problems: `13`
- Pareto hypervolume is computed in normalized improvement space against the zero-improvement reference point.

## Summary Table

| Backend | Functionality Mean | Synthesis Mean | Solved | Best Score Mean | Runtime Mean (s) | QD Coverage Mean | QD Score Mean | Pareto HV Mean | Pareto Points Mean |
|:---|:---|:---|---:|:---|---:|:---|:---|:---|:---|
| `classic` | 42.6% | 41.2% | 13/13 | 0.2279 | 991.57 | N/A | N/A | 0.0926 | 2.31 |
| `fused_rtl_operator_timing_qd` | 46.2% | 45.4% | 13/13 | 0.2270 | 1059.40 | 45.6% | 1.0156 | 0.0846 | 1.77 |

## Recommendations

- Overall: `fused_rtl_operator_timing_qd`
- Score-oriented QD: `fused_rtl_operator_timing_qd`
- Archive-health QD: `fused_rtl_operator_timing_qd`
- Multi-objective: `classic`

## Per-Problem Winners

| Benchmark | Problem | Winner | Synthesis Rate | Best Score |
|:---|:---|:---|:---|:---|
| RTLLM | Prob004_adder_8bit | `fused_rtl_operator_timing_qd` | 75.0% | 0.3815 |
| RTLLM | Prob015_multi_pipe_8bit | `classic` | 27.1% | 0.1352 |
| RTLLM | Prob024_fsm | `fused_rtl_operator_timing_qd` | 47.9% | 0.5002 |
| RTLLM | Prob037_parallel2serial | `fused_rtl_operator_timing_qd` | 45.8% | -0.0000 |
| RTLLM | Prob041_traffic_light | `fused_rtl_operator_timing_qd` | 45.8% | 0.4038 |
| RTLLM | Prob045_alu | `fused_rtl_operator_timing_qd` | 22.9% | 0.3879 |
| RTLLM | Prob049_signal_generator | `fused_rtl_operator_timing_qd` | 91.7% | 0.2348 |
| VerilogEval-Spec-to-RTL | Prob098_circuit7 | `classic` | 70.8% | 0.0120 |
| VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | `classic` | 58.3% | 0.4644 |
| VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | `fused_rtl_operator_timing_qd` | 87.5% | 0.2636 |
| VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | `classic` | 43.8% | 0.3297 |
| VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | `fused_rtl_operator_timing_qd` | 10.4% | -0.2160 |
| VerilogEval-Spec-to-RTL | Prob153_gshare | `fused_rtl_operator_timing_qd` | 41.7% | 0.1356 |
