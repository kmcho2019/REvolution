# Backend Comparison Report

Legend: `✅` pass/improvement, `❌` fail/regression, `➖` neutral.
Score/PPA aggregate metrics exclude failed designs (no synthesis pass) and non-finite scores.
Valid PPA samples count generated samples with PPA metrics even when QD warmup or archive insertion later drops them.
When the final population has no retained PPA aggregate, Score/PPA deltas use the best generated valid PPA sample.
Pareto hypervolume uses normalized improvement space against the zero-improvement reference point.
Multi-objective winner: `classic` (mean hypervolume, then per-problem HV wins, then mean Pareto points).

## Budget and Fairness Diagnostics

| Backend | Benchmark | Primary Axis | Config Max Evals | Config Max LLM Calls | Avg LLM Calls / Design | Avg Tokens / Design | Calls / Func-Pass Design | Calls / Synth-Pass Design |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `classic` | ALL | unspecified | 120 | N/A | 259.54 ± 0.36 | 832898.23 ± 99076.40 | 259.54 | 259.54 |
| `classic` | RTLLM | unspecified | 120 | N/A | 259.57 ± 0.40 | 830898.14 ± 157763.59 | 259.57 | 259.57 |
| `classic` | VerilogEval-Spec-to-RTL | unspecified | 120 | N/A | 259.50 ± 0.67 | 835231.67 ± 127244.00 | 259.50 | 259.50 |
| `qd_target` | ALL | unspecified | 120 | N/A | 359.23 ± 1.72 | 902706.69 ± 106290.84 | 359.23 | 359.23 |
| `qd_target` | RTLLM | unspecified | 120 | N/A | 358.29 ± 3.05 | 889361.43 ± 175020.98 | 358.29 | 358.29 |
| `qd_target` | VerilogEval-Spec-to-RTL | unspecified | 120 | N/A | 360.33 ± 0.83 | 918276.17 ± 124567.61 | 360.33 | 360.33 |

## Per-Problem Metrics

| Backend | Benchmark | Problem | Functionality | Synthesis | Valid PPA Samples | Score Delta vs Ref | PPA Delta (A/P/T) | Avg PPA Delta | Runtime (s) | LLM Calls |
|:---|:---|:---|:---|:---|---:|:---|:---|:---|---:|---:|
| `classic` | RTLLM | Prob004_adder_8bit | ✅ Pass (70.0%) | ✅ Pass (70.0%) | 84 | +32.99% ✅ | +0.00% ➖ / +98.97% ✅ / N/A | +49.49% ✅ | 823.03 | 259 |
| `qd_target` | RTLLM | Prob004_adder_8bit | ✅ Pass (99.2%) | ✅ Pass (99.2%) | 119 | +14.04% ✅ | +15.22% ✅ / +26.91% ✅ / N/A | +21.06% ✅ | 1567.89 | 360 |
| `classic` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (43.3%) | ✅ Pass (41.7%) | 50 | +23.61% ✅ | +40.00% ✅ / +54.01% ✅ / -23.17% ❌ | +23.61% ✅ | 1195.21 | 260 |
| `qd_target` | RTLLM | Prob015_multi_pipe_8bit | ✅ Pass (74.2%) | ✅ Pass (54.2%) | 65 | +51.18% ✅ | +47.65% ✅ / +27.84% ✅ / +78.05% ✅ | +51.18% ✅ | 2649.89 | 360 |
| `classic` | RTLLM | Prob024_fsm | ✅ Pass (34.2%) | ✅ Pass (27.5%) | 33 | +68.35% ✅ | +47.83% ✅ / +71.22% ✅ / N/A | +59.52% ✅ | 836.87 | 259 |
| `qd_target` | RTLLM | Prob024_fsm | ✅ Pass (51.7%) | ✅ Pass (50.0%) | 60 | +50.02% ✅ | +21.74% ✅ / +46.33% ✅ / N/A | +34.04% ✅ | 1537.11 | 360 |
| `classic` | RTLLM | Prob037_parallel2serial | ✅ Pass (30.8%) | ✅ Pass (30.0%) | 36 | +22.83% ✅ | +22.00% ✅ / +24.28% ✅ / +22.22% ✅ | +22.83% ✅ | 956.00 | 260 |
| `qd_target` | RTLLM | Prob037_parallel2serial | ✅ Pass (40.0%) | ✅ Pass (36.7%) | 44 | +9.79% ✅ | +10.00% ✅ / +15.67% ✅ / +3.70% ✅ | +9.79% ✅ | 2194.77 | 359 |
| `classic` | RTLLM | Prob041_traffic_light | ✅ Pass (68.3%) | ✅ Pass (68.3%) | 82 | +44.23% ✅ | +33.53% ✅ / +99.15% ✅ / N/A | +66.34% ✅ | 917.13 | 259 |
| `qd_target` | RTLLM | Prob041_traffic_light | ✅ Pass (45.0%) | ✅ Pass (45.0%) | 54 | +37.97% ✅ | +14.71% ✅ / +99.21% ✅ / N/A | +56.96% ✅ | 1950.37 | 360 |
| `classic` | RTLLM | Prob045_alu | ✅ Pass (70.8%) | ✅ Pass (70.8%) | 85 | +42.14% ✅ | +27.19% ✅ / +99.24% ✅ / N/A | +63.22% ✅ | 1276.83 | 260 |
| `qd_target` | RTLLM | Prob045_alu | ✅ Pass (18.1%) | ✅ Pass (18.1%) | 21 | +14.05% ✅ | +24.00% ✅ / +18.16% ✅ / N/A | +21.08% ✅ | 1991.74 | 349 |
| `classic` | RTLLM | Prob049_signal_generator | ✅ Pass (54.2%) | ✅ Pass (54.2%) | 65 | +25.98% ✅ | +42.55% ✅ / +7.49% ✅ / +27.91% ✅ | +25.98% ✅ | 843.64 | 260 |
| `qd_target` | RTLLM | Prob049_signal_generator | ✅ Pass (66.7%) | ✅ Pass (66.7%) | 80 | +27.42% ✅ | +10.64% ✅ / +46.04% ✅ / +25.58% ✅ | +27.42% ✅ | 1423.41 | 360 |
| `classic` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | ✅ Pass (65.0%) | ✅ Pass (65.0%) | 78 | +33.25% ✅ | +0.00% ➖ / +99.75% ✅ / N/A | +49.87% ✅ | 1192.47 | 259 |
| `qd_target` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | ✅ Pass (56.7%) | ✅ Pass (56.7%) | 68 | +1.20% ✅ | +0.00% ➖ / +3.60% ✅ / N/A | +1.80% ✅ | 2137.28 | 361 |
| `classic` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | ✅ Pass (69.2%) | ✅ Pass (69.2%) | 83 | +34.68% ✅ | +40.00% ✅ / +64.04% ✅ / N/A | +52.02% ✅ | 1391.33 | 261 |
| `qd_target` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | ✅ Pass (7.5%) | ✅ Pass (7.5%) | 9 | +34.68% ✅ | +40.00% ✅ / +64.04% ✅ / N/A | +52.02% ✅ | 4190.29 | 362 |
| `classic` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | ✅ Pass (91.7%) | ✅ Pass (91.7%) | 110 | +18.62% ✅ | +20.00% ✅ / +35.87% ✅ / N/A | +27.94% ✅ | 1369.85 | 259 |
| `qd_target` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | ✅ Pass (55.0%) | ✅ Pass (55.0%) | 66 | -1.29% ❌ | -20.00% ❌ / +16.14% ✅ / N/A | -1.93% ❌ | 2052.19 | 360 |
| `classic` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | ✅ Pass (46.7%) | ✅ Pass (46.7%) | 56 | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 1126.79 | 259 |
| `qd_target` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | ✅ Pass (26.7%) | ✅ Pass (26.7%) | 32 | -0.00% ➖ | +0.00% ➖ / +0.00% ➖ / N/A | +0.00% ➖ | 1827.30 | 360 |
| `classic` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | ✅ Pass (19.2%) | ✅ Pass (18.3%) | 22 | -20.87% ❌ | -28.79% ❌ / -51.68% ❌ / +17.86% ✅ | -20.87% ❌ | 1305.65 | 259 |
| `qd_target` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | ✅ Pass (22.5%) | ✅ Pass (22.5%) | 27 | -13.47% ❌ | -10.61% ❌ / -47.65% ❌ / +17.86% ✅ | -13.47% ❌ | 2033.79 | 360 |
| `classic` | VerilogEval-Spec-to-RTL | Prob153_gshare | ✅ Pass (45.0%) | ✅ Pass (43.3%) | 52 | +14.59% ✅ | +7.97% ✅ / +31.81% ✅ / +4.00% ✅ | +14.59% ✅ | 1751.34 | 260 |
| `qd_target` | VerilogEval-Spec-to-RTL | Prob153_gshare | ✅ Pass (1.7%) | ✅ Pass (1.7%) | 2 | +13.56% ✅ | +7.77% ✅ / +31.58% ✅ / +1.33% ✅ | +13.56% ✅ | 2237.97 | 359 |

## Aggregate Backend Metrics by Benchmark

| Backend | Benchmark | Designs | Func Any-Pass | Synth Any-Pass | Func Pass@1 Mean | Synth Pass@1 Mean | Valid Score Designs | Avg Score Delta | Score Trend (✅/➖/❌) | Valid PPA Designs / Samples | Avg PPA Delta | PPA Delta (A/P/T) | PPA Trend (✅/➖/❌) | PPA Regressions (A/P/T) | Runtime Mean ± CI (s) | Calls Mean ± CI |
|:---|:---|---:|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `classic` | RTLLM | 7 | ✅ 7/7 (100.0%) | ✅ 7/7 (100.0%) | 53.1% ± 12.8% | 51.8% ± 14.0% | 7/7 | +37.16% ± 12.02% ✅ | ✅ 7 / ➖ 0 / ❌ 0 | 7/7 (435 samples) | +44.43% ± 14.59% ✅ | +30.44% ± 11.94% ✅ / +64.91% ± 28.07% ✅ / +8.99% ± 31.68% ✅ | ✅ 7 / ➖ 0 / ❌ 0 | A ✅ 0/7 / P ✅ 0/7 / T ❌ 1/3 | 978.39 ± 136.15 | 259.57 ± 0.40 |
| `classic` | VerilogEval-Spec-to-RTL | 6 | ✅ 6/6 (100.0%) | ✅ 6/6 (100.0%) | 56.1% ± 19.9% | 55.7% ± 20.2% | 6/6 | +13.38% ± 16.90% ✅ | ✅ 4 / ➖ 1 / ❌ 1 | 6/6 (401 samples) | +20.59% ± 22.85% ✅ | +6.53% ± 18.37% ✅ / +29.97% ± 41.78% ✅ / +10.93% ± 13.58% ✅ | ✅ 4 / ➖ 1 / ❌ 1 | A ❌ 1/6 / P ❌ 1/6 / T ✅ 0/2 | 1356.24 ± 175.14 | 259.50 ± 0.67 |
| `qd_target` | RTLLM | 7 | ✅ 7/7 (100.0%) | ✅ 7/7 (100.0%) | 56.4% ± 19.5% | 52.8% ± 18.8% | 7/7 | +29.21% ± 12.95% ✅ | ✅ 7 / ➖ 0 / ❌ 0 | 7/7 (443 samples) | +31.65% ± 12.64% ✅ | +20.56% ± 9.66% ✅ / +40.02% ± 21.32% ✅ / +35.78% ± 43.24% ✅ | ✅ 7 / ➖ 0 / ❌ 0 | A ✅ 0/7 / P ✅ 0/7 / T ✅ 0/3 | 1902.17 ± 321.39 | 358.29 ± 3.05 |
| `qd_target` | VerilogEval-Spec-to-RTL | 6 | ✅ 6/6 (100.0%) | ✅ 6/6 (100.0%) | 28.3% ± 18.6% | 28.3% ± 18.6% | 6/6 | +5.78% ± 13.25% ✅ | ✅ 3 / ➖ 1 / ❌ 2 | 6/6 (204 samples) | +8.66% ± 18.34% ✅ | +2.86% ± 16.49% ✅ / +11.29% ± 29.68% ✅ / +9.60% ± 16.19% ✅ | ✅ 3 / ➖ 1 / ❌ 2 | A ❌ 2/6 / P ❌ 1/6 / T ✅ 0/2 | 2413.14 ± 705.10 | 360.33 ± 0.83 |

## Aggregate Backend Metrics (All Benchmarks)

| Backend | Benchmark | Designs | Func Any-Pass | Synth Any-Pass | Func Pass@1 Mean | Synth Pass@1 Mean | Valid Score Designs | Avg Score Delta | Score Trend (✅/➖/❌) | Valid PPA Designs / Samples | Avg PPA Delta | PPA Delta (A/P/T) | PPA Trend (✅/➖/❌) | PPA Regressions (A/P/T) | Runtime Mean ± CI (s) | Calls Mean ± CI |
|:---|:---|---:|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `classic` | ALL | 13 | ✅ 13/13 (100.0%) | ✅ 13/13 (100.0%) | 54.5% ± 11.0% | 53.6% ± 11.5% | 13/13 | +26.19% ± 11.78% ✅ | ✅ 11 / ➖ 1 / ❌ 1 | 13/13 (836 samples) | +33.43% ± 14.24% ✅ | +19.41% ± 12.20% ✅ / +48.78% ± 25.40% ✅ / +9.76% ± 17.90% ✅ | ✅ 11 / ➖ 1 / ❌ 1 | A ❌ 1/13 / P ❌ 1/13 / T ❌ 1/5 | 1152.78 ± 149.16 | 259.54 ± 0.36 |
| `qd_target` | ALL | 13 | ✅ 13/13 (100.0%) | ✅ 13/13 (100.0%) | 43.4% ± 15.2% | 41.5% ± 14.5% | 13/13 | +18.40% ± 11.07% ✅ | ✅ 10 / ➖ 1 / ❌ 2 | 13/13 (647 samples) | +21.04% ± 12.24% ✅ | +12.39% ± 10.12% ✅ / +26.76% ± 18.91% ✅ / +25.30% ± 27.30% ✅ | ✅ 10 / ➖ 1 / ❌ 2 | A ❌ 2/13 / P ❌ 1/13 / T ✅ 0/5 | 2138.00 ± 379.72 | 359.23 ± 1.72 |

## Pareto / Multi-Objective Metrics

| Backend | Benchmark | Problem | Objectives | Candidates | Pareto Points | Hypervolume | Ref-Beating | Best Pareto Delta (A/P/T) |
|:---|:---|:---|---:|---:|---:|:---|---:|:---|
| `classic` | RTLLM | Prob004_adder_8bit | 2 | 13 | 2 | 0.0410 | 3 | +15.22% ✅ / +98.97% ✅ / N/A |
| `qd_target` | RTLLM | Prob004_adder_8bit | 2 | 1 | 1 | 0.0410 | 1 | +15.22% ✅ / +26.91% ✅ / N/A |
| `classic` | RTLLM | Prob015_multi_pipe_8bit | 3 | 43 | 11 | 0.0012 | 3 | +40.00% ✅ / +54.01% ✅ / +41.46% ✅ |
| `qd_target` | RTLLM | Prob015_multi_pipe_8bit | 3 | 40 | 5 | 0.1035 | 1 | +47.65% ✅ / +63.92% ✅ / +78.05% ✅ |
| `classic` | RTLLM | Prob024_fsm | 2 | 18 | 1 | 0.3406 | 11 | +47.83% ✅ / +71.22% ✅ / N/A |
| `qd_target` | RTLLM | Prob024_fsm | 2 | 10 | 2 | 0.1206 | 8 | +32.61% ✅ / +46.76% ✅ / N/A |
| `classic` | RTLLM | Prob037_parallel2serial | 3 | 12 | 1 | 0.0119 | 3 | +22.00% ✅ / +24.28% ✅ / +22.22% ✅ |
| `qd_target` | RTLLM | Prob037_parallel2serial | 3 | 7 | 1 | 0.0006 | 3 | +10.00% ✅ / +15.67% ✅ / +3.70% ✅ |
| `classic` | RTLLM | Prob041_traffic_light | 2 | 51 | 4 | 0.3539 | 46 | +39.41% ✅ / +99.21% ✅ / N/A |
| `qd_target` | RTLLM | Prob041_traffic_light | 2 | 39 | 2 | 0.2046 | 29 | +24.12% ✅ / +99.21% ✅ / N/A |
| `classic` | RTLLM | Prob045_alu | 2 | 78 | 1 | 0.2698 | 78 | +27.19% ✅ / +99.24% ✅ / N/A |
| `qd_target` | RTLLM | Prob045_alu | 2 | 20 | 2 | 0.0455 | 20 | +24.00% ✅ / +19.04% ✅ / N/A |
| `classic` | RTLLM | Prob049_signal_generator | 3 | 8 | 4 | 0.0173 | 4 | +42.55% ✅ / +46.04% ✅ / +27.91% ✅ |
| `qd_target` | RTLLM | Prob049_signal_generator | 3 | 4 | 2 | 0.0180 | 3 | +19.15% ✅ / +46.04% ✅ / +25.58% ✅ |
| `classic` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | 2 | 3 | 1 | 0.0000 | 2 | +0.00% ➖ / +99.75% ✅ / N/A |
| `qd_target` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | 2 | 2 | 1 | 0.0000 | 1 | +0.00% ➖ / +3.60% ✅ / N/A |
| `classic` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 9 | 1 | 0.2562 | 9 | +40.00% ✅ / +64.04% ✅ / N/A |
| `qd_target` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | 2 | 5 | 1 | 0.2562 | 4 | +40.00% ✅ / +64.04% ✅ / N/A |
| `classic` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 8 | 2 | 0.0717 | 2 | +20.00% ✅ / +36.77% ✅ / N/A |
| `qd_target` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | 2 | 3 | 1 | 0.0000 | 0 | -20.00% ❌ / +16.14% ✅ / N/A |
| `classic` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | 2 | 4 | 1 | 0.0000 | 0 | +0.00% ➖ / +0.00% ➖ / N/A |
| `qd_target` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | 2 | 1 | 1 | 0.0000 | 0 | +0.00% ➖ / +0.00% ➖ / N/A |
| `classic` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | 3 | 21 | 5 | 0.0000 | 0 | -16.67% ❌ / -42.51% ❌ / +21.43% ✅ |
| `qd_target` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | 3 | 12 | 3 | 0.0000 | 0 | -10.61% ❌ / -45.19% ❌ / +17.86% ✅ |
| `classic` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 29 | 6 | 0.0010 | 8 | +9.45% ✅ / +36.16% ✅ / +14.67% ✅ |
| `qd_target` | VerilogEval-Spec-to-RTL | Prob153_gshare | 3 | 2 | 2 | 0.0003 | 2 | +7.77% ✅ / +31.58% ✅ / +6.67% ✅ |

## Aggregate Pareto Metrics by Benchmark

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume ± CI | Mean Pareto Points ± CI | Mean Ref-Beating ± CI | HV Wins |
|:---|:---|---:|---:|:---|:---|:---|---:|
| `classic` | RTLLM | 7 | 7 | 0.1479 ± 0.1221 | 3.43 ± 2.67 | 21.14 ± 21.88 | 5 |
| `classic` | VerilogEval-Spec-to-RTL | 6 | 6 | 0.0548 ± 0.0822 | 2.67 ± 1.80 | 3.50 ± 3.19 | 6 |
| `qd_target` | RTLLM | 7 | 7 | 0.0762 ± 0.0528 | 2.14 ± 1.00 | 9.29 ± 8.12 | 2 |
| `qd_target` | VerilogEval-Spec-to-RTL | 6 | 6 | 0.0428 ± 0.0837 | 1.50 ± 0.67 | 1.17 ± 1.28 | 0 |

## Aggregate Pareto Metrics (All Benchmarks)

| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume ± CI | Mean Pareto Points ± CI | Mean Ref-Beating ± CI | HV Wins |
|:---|:---|---:|---:|:---|:---|:---|---:|
| `classic` | ALL | 13 | 13 | 0.1050 ± 0.0775 | 3.08 ± 1.61 | 13.00 ± 12.48 | 11 |
| `qd_target` | ALL | 13 | 13 | 0.0608 ± 0.0468 | 1.85 ± 0.62 | 5.54 ± 4.83 | 2 |

## QD Archive Metrics

| Backend | Benchmark | Problem | Archive | Coverage | QD Score | Best Quality | Occupied Cells |
|:---|:---|:---|:---|:---|:---|:---|:---|
| `qd_target` | RTLLM | Prob004_adder_8bit | grid_quantile | 100.0% | 0.1404 | 0.1404 | 1/1 |
| `qd_target` | RTLLM | Prob015_multi_pipe_8bit | grid_quantile | 12.5% | 0.9522 | 0.5118 | 8/64 |
| `qd_target` | RTLLM | Prob024_fsm | grid_quantile | 66.7% | 1.0005 | 0.5002 | 2/3 |
| `qd_target` | RTLLM | Prob037_parallel2serial | grid_quantile | 33.3% | 0.0979 | 0.0979 | 2/6 |
| `qd_target` | RTLLM | Prob041_traffic_light | grid_quantile | 30.6% | 3.7249 | 0.3797 | 11/36 |
| `qd_target` | RTLLM | Prob045_alu | grid_quantile | 41.7% | 0.5371 | 0.1405 | 5/12 |
| `qd_target` | RTLLM | Prob049_signal_generator | grid_quantile | 50.0% | 0.5380 | 0.2742 | 2/4 |
| `qd_target` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | grid_quantile | 100.0% | 0.0120 | 0.0120 | 1/1 |
| `qd_target` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | grid_quantile | 18.8% | 0.5378 | 0.3468 | 3/16 |
| `qd_target` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | grid_quantile | 37.5% | -0.3629 | -0.0129 | 6/16 |
| `qd_target` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | grid_quantile | 100.0% | 0.0000 | -0.0000 | 1/1 |
| `qd_target` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | grid_quantile | 31.2% | -1.2112 | -0.1347 | 5/16 |
| `qd_target` | VerilogEval-Spec-to-RTL | Prob153_gshare | grid_quantile | 0.0% | 0.0000 | N/A | 0/0 |

## QD Descriptor Health

| Backend | Benchmark | Problem | Profile | Axes | Observations | Archive Elites | Init / Shape | Collapsed Axes | Decisions |
|:---|:---|:---|:---|:---|---:|---:|:---|:---|:---|
| `qd_target` | RTLLM | Prob004_adder_8bit | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 30 | 1 | init=run_finalization_fallback, shape=1x1x1 | logic_depth, ff_depth, comb_width_log | live warmup_buffered=30; replay duplicate_objectives=29, filled_empty=1 |
| `qd_target` | RTLLM | Prob015_multi_pipe_8bit | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 24 | 19 | init=warmup_complete, shape=4x4x4 | none | live duplicate_objectives=4, filled_empty=1, pareto_inserted=11, warmup_buffered=8; replay duplicate_objectives=1, filled_empty=7 |
| `qd_target` | RTLLM | Prob024_fsm | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 24 | 5 | init=run_finalization_fallback, shape=1x1x3 | logic_depth, ff_depth | live warmup_buffered=24; replay duplicate_objectives=19, filled_empty=2, pareto_inserted=3 |
| `qd_target` | RTLLM | Prob037_parallel2serial | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 21 | 7 | init=warmup_complete, shape=1x2x3 | logic_depth | live duplicate_objectives=7, pareto_inserted=2, warmup_buffered=12; replay duplicate_objectives=7, filled_empty=2, pareto_inserted=3 |
| `qd_target` | RTLLM | Prob041_traffic_light | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 25 | 21 | init=warmup_complete, shape=3x3x4 | none | live duplicate_objectives=3, filled_empty=6, pareto_inserted=8, warmup_buffered=8; replay duplicate_objectives=1, filled_empty=5, pareto_inserted=2 |
| `qd_target` | RTLLM | Prob045_alu | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 15 | 15 | init=warmup_complete, shape=3x1x4 | ff_depth | live filled_empty=1, pareto_inserted=6, warmup_buffered=8; replay filled_empty=4, pareto_inserted=4 |
| `qd_target` | RTLLM | Prob049_signal_generator | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 28 | 4 | init=warmup_complete, shape=2x1x2 | ff_depth | live duplicate_objectives=19, pareto_inserted=1, warmup_buffered=8; replay duplicate_objectives=5, filled_empty=2, pareto_inserted=1 |
| `qd_target` | VerilogEval-Spec-to-RTL | Prob098_circuit7 | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 20 | 2 | init=run_finalization_fallback, shape=1x1x1 | logic_depth, ff_depth, comb_width_log | live warmup_buffered=20; replay duplicate_objectives=18, filled_empty=1, pareto_inserted=1 |
| `qd_target` | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 8 | 5 | init=warmup_complete, shape=4x1x4 | ff_depth | live warmup_buffered=8; replay duplicate_objectives=3, filled_empty=3, pareto_inserted=2 |
| `qd_target` | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 21 | 6 | init=warmup_complete, shape=4x1x4 | ff_depth | live duplicate_objectives=12, filled_empty=1, warmup_buffered=8; replay duplicate_objectives=3, filled_empty=5 |
| `qd_target` | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 20 | 1 | init=run_finalization_fallback, shape=1x1x1 | logic_depth, ff_depth, comb_width_log | live warmup_buffered=20; replay duplicate_objectives=19, filled_empty=1 |
| `qd_target` | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 16 | 12 | init=warmup_complete, shape=2x2x4 | none | live duplicate_objectives=2, pareto_inserted=6, warmup_buffered=8; replay duplicate_objectives=2, filled_empty=5, pareto_inserted=1 |
| `qd_target` | VerilogEval-Spec-to-RTL | Prob153_gshare | journal_logic_ff_width_3d | logic_depth, ff_depth, comb_width_log | 2 | 0 | init=pending | none | live warmup_buffered=2 |

