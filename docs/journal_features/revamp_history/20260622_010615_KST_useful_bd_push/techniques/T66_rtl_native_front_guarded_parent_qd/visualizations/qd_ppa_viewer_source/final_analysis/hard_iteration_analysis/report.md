# Hard Iteration Subset Analysis

- Subset: `hard_iteration_subset`
- Problems: `13`
- Pareto hypervolume is computed in normalized improvement space against the zero-improvement reference point.

## Summary Table

| Backend | Functionality Mean | Synthesis Mean | Solved | Best Score Mean | Runtime Mean (s) | QD Coverage Mean | QD Score Mean | Pareto HV Mean | Pareto Points Mean |
|:---|:---|:---|---:|:---|---:|:---|:---|:---|:---|
| `classic` | 42.6% | 41.2% | 13/13 | 0.2279 | 991.57 | N/A | N/A | 0.0926 | 2.31 |
| `rtl_native_front_guarded_parent_qd` | 42.9% | 41.7% | 13/13 | 0.2780 | 1080.98 | 63.9% | 0.7821 | 0.0813 | 1.54 |

## Recommendations

- Overall: `rtl_native_front_guarded_parent_qd`
- Score-oriented QD: `rtl_native_front_guarded_parent_qd`
- Archive-health QD: `rtl_native_front_guarded_parent_qd`
- Multi-objective: `classic`

## Per-Problem Winners

| Benchmark | Problem | Winner | Synthesis Rate | Best Score |
|:---|:---|:---|:---|:---|
| RTLLM | Prob004_adder_8bit | `rtl_native_front_guarded_parent_qd` | 72.9% | 0.3815 |
| RTLLM | Prob015_multi_pipe_8bit | `rtl_native_front_guarded_parent_qd` | 41.7% | 0.2434 |
| RTLLM | Prob024_fsm | `rtl_native_front_guarded_parent_qd` | 39.6% | 0.4701 |
| RTLLM | Prob037_parallel2serial | `rtl_native_front_guarded_parent_qd` | 43.8% | -0.0000 |
| RTLLM | Prob041_traffic_light | `rtl_native_front_guarded_parent_qd` | 50.0% | 0.3993 |
| RTLLM | Prob045_alu | `rtl_native_front_guarded_parent_qd` | 41.7% | 0.3933 |
| RTLLM | Prob049_signal_generator | `rtl_native_front_guarded_parent_qd` | 70.8% | 0.2348 |
| VerilogEval-Spec-to-RTL | Prob098_circuit7 | `classic` | 70.8% | 0.0120 |
| VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | `classic` | 58.3% | 0.4644 |
| VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | `classic` | 77.1% | 0.2636 |
| VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | `classic` | 43.8% | 0.3297 |
| VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | `classic` | 4.2% | -0.3630 |
| VerilogEval-Spec-to-RTL | Prob153_gshare | `rtl_native_front_guarded_parent_qd` | 39.6% | 0.1431 |
