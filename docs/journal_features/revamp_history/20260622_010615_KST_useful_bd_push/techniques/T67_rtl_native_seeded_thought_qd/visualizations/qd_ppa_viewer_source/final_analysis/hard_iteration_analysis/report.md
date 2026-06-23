# Hard Iteration Subset Analysis

- Subset: `hard_iteration_subset`
- Problems: `13`
- Pareto hypervolume is computed in normalized improvement space against the zero-improvement reference point.

## Summary Table

| Backend | Functionality Mean | Synthesis Mean | Solved | Best Score Mean | Runtime Mean (s) | QD Coverage Mean | QD Score Mean | Pareto HV Mean | Pareto Points Mean |
|:---|:---|:---|---:|:---|---:|:---|:---|:---|:---|
| `classic` | 42.6% | 41.2% | 13/13 | 0.2279 | 991.57 | N/A | N/A | 0.0926 | 2.31 |
| `rtl_native_seeded_thought_qd` | 49.0% | 48.7% | 12/13 | 0.2266 | 2411.75 | 42.9% | 0.5304 | 0.0917 | 1.38 |

## Recommendations

- Overall: `rtl_native_seeded_thought_qd`
- Score-oriented QD: `rtl_native_seeded_thought_qd`
- Archive-health QD: `rtl_native_seeded_thought_qd`
- Multi-objective: `classic`

## Per-Problem Winners

| Benchmark | Problem | Winner | Synthesis Rate | Best Score |
|:---|:---|:---|:---|:---|
| RTLLM | Prob004_adder_8bit | `rtl_native_seeded_thought_qd` | 75.0% | 0.3815 |
| RTLLM | Prob015_multi_pipe_8bit | `rtl_native_seeded_thought_qd` | 68.8% | 0.0528 |
| RTLLM | Prob024_fsm | `rtl_native_seeded_thought_qd` | 45.8% | 0.4917 |
| RTLLM | Prob037_parallel2serial | `classic` | 37.5% | 0.0846 |
| RTLLM | Prob041_traffic_light | `rtl_native_seeded_thought_qd` | 75.0% | 0.4077 |
| RTLLM | Prob045_alu | `rtl_native_seeded_thought_qd` | 39.6% | 0.4153 |
| RTLLM | Prob049_signal_generator | `rtl_native_seeded_thought_qd` | 70.8% | 0.2638 |
| VerilogEval-Spec-to-RTL | Prob098_circuit7 | `classic` | 70.8% | 0.0120 |
| VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | `classic` | 58.3% | 0.4644 |
| VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | `classic` | 77.1% | 0.2636 |
| VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | `rtl_native_seeded_thought_qd` | 60.4% | 0.3297 |
| VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | `rtl_native_seeded_thought_qd` | 29.2% | -0.1259 |
| VerilogEval-Spec-to-RTL | Prob153_gshare | `classic` | 27.1% | 0.1086 |
