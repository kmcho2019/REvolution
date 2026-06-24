# Hard Iteration Subset Analysis

- Subset: `hard_iteration_subset`
- Problems: `8`
- Pareto hypervolume is computed in normalized improvement space against the zero-improvement reference point.

## Summary Table

| Backend | Functionality Mean | Synthesis Mean | Solved | Best Score Mean | Runtime Mean (s) | QD Coverage Mean | QD Score Mean | Pareto HV Mean | Pareto Points Mean |
|:---|:---|:---|---:|:---|---:|:---|:---|:---|:---|
| `classic_revolution_12x3` | 48.4% | 47.9% | 8/8 | 0.3337 | 955.40 | N/A | N/A | 0.1864 | 2.25 |
| `shape_density_front_pressure_qd_12x3` | 55.5% | 53.1% | 8/8 | 0.2899 | 945.57 | 28.3% | 1.2548 | 0.1060 | 2.25 |
| `classic_revolution_8x5` | 56.8% | 55.7% | 8/8 | 0.3266 | 1097.89 | N/A | N/A | 0.1414 | 2.62 |
| `shape_density_front_pressure_qd_8x5` | 53.1% | 52.6% | 8/8 | 0.3085 | 1274.26 | 29.8% | 1.5660 | 0.1231 | 1.62 |
| `classic_revolution_6x7` | 59.9% | 57.8% | 8/8 | 0.3659 | 1279.29 | N/A | N/A | 0.1701 | 2.62 |
| `shape_density_front_pressure_qd_6x7` | 50.0% | 49.0% | 8/8 | 0.3040 | 1506.43 | 26.4% | 1.3847 | 0.1194 | 2.00 |

## Recommendations

- Overall: `classic_revolution_6x7`
- Score-oriented QD: `shape_density_front_pressure_qd_12x3`
- Archive-health QD: `shape_density_front_pressure_qd_8x5`
- Multi-objective: `classic_revolution_12x3`

## Per-Problem Winners

| Benchmark | Problem | Winner | Synthesis Rate | Best Score |
|:---|:---|:---|:---|:---|
| RTLLM | Prob015_multi_pipe_8bit | `classic_revolution_6x7` | 39.6% | 0.2434 |
| RTLLM | Prob024_fsm | `shape_density_front_pressure_qd_12x3` | 54.2% | 0.5002 |
| RTLLM | Prob041_traffic_light | `classic_revolution_6x7` | 66.7% | 0.4482 |
| RTLLM | Prob045_alu | `classic_revolution_8x5` | 77.1% | 0.4093 |
| RTLLM | Prob049_signal_generator | `shape_density_front_pressure_qd_8x5` | 91.7% | 0.2348 |
| VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | `shape_density_front_pressure_qd_12x3` | 83.3% | 0.4654 |
| VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | `shape_density_front_pressure_qd_6x7` | 93.8% | 0.2636 |
| VerilogEval-Spec-to-RTL | Prob153_gshare | `classic_revolution_6x7` | 52.1% | 0.1443 |
