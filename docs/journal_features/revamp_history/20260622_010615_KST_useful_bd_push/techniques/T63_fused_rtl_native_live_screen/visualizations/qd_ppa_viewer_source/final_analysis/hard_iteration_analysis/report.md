# Hard Iteration Subset Analysis

- Subset: `hard_iteration_subset`
- Problems: `13`
- Pareto hypervolume is computed in normalized improvement space against the zero-improvement reference point.

## Summary Table

| Backend | Functionality Mean | Synthesis Mean | Solved | Best Score Mean | Runtime Mean (s) | QD Coverage Mean | QD Score Mean | Pareto HV Mean | Pareto Points Mean |
|:---|:---|:---|---:|:---|---:|:---|:---|:---|:---|
| `classic` | 42.6% | 41.2% | 13/13 | 0.2279 | 991.57 | N/A | N/A | 0.0926 | 2.31 |
| `fused_rtl_state_pipeline_qd` | 41.7% | 41.2% | 13/13 | 0.2683 | 1081.79 | 58.7% | 0.7348 | 0.0896 | 1.92 |

## Recommendations

- Overall: `classic`
- Score-oriented QD: `fused_rtl_state_pipeline_qd`
- Archive-health QD: `fused_rtl_state_pipeline_qd`
- Multi-objective: `classic`

## Per-Problem Winners

| Benchmark | Problem | Winner | Synthesis Rate | Best Score |
|:---|:---|:---|:---|:---|
| RTLLM | Prob004_adder_8bit | `fused_rtl_state_pipeline_qd` | 70.8% | 0.3815 |
| RTLLM | Prob015_multi_pipe_8bit | `classic` | 27.1% | 0.1352 |
| RTLLM | Prob024_fsm | `fused_rtl_state_pipeline_qd` | 52.1% | 0.5002 |
| RTLLM | Prob037_parallel2serial | `classic` | 37.5% | 0.0846 |
| RTLLM | Prob041_traffic_light | `fused_rtl_state_pipeline_qd` | 50.0% | 0.4077 |
| RTLLM | Prob045_alu | `fused_rtl_state_pipeline_qd` | 39.6% | 0.4031 |
| RTLLM | Prob049_signal_generator | `fused_rtl_state_pipeline_qd` | 79.2% | 0.2348 |
| VerilogEval-Spec-to-RTL | Prob098_circuit7 | `classic` | 70.8% | 0.0120 |
| VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | `classic` | 58.3% | 0.4644 |
| VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | `classic` | 77.1% | 0.2636 |
| VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | `classic` | 43.8% | 0.3297 |
| VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | `fused_rtl_state_pipeline_qd` | 6.2% | N/A |
| VerilogEval-Spec-to-RTL | Prob153_gshare | `fused_rtl_state_pipeline_qd` | 39.6% | 0.1356 |
