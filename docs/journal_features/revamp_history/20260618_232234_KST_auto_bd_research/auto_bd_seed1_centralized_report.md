# Auto-BD Seed-1 Centralized Report

Status: preliminary development-subset report.

## Normalization

- Objective directions: minimize area, power, and effective clock.
- Improvement: `(reference - candidate) / max(abs(reference), 1e-12)`.
- Combinational tasks use area/power; sequential tasks also use effective clock.
- Hypervolume uses normalized improvement space against the zero-improvement reference point.
- Negative objective improvements are clipped to zero inside the hypervolume computation.
- Invalid candidates remain in generated/robustness counts but are excluded from valid-only PPA/HV.

## Gate Matrix

| Method | Gate 0 | Covered | Classic Covered | Missing Classic |
| --- | --- | --- | --- | --- |
| `classic_revolution` | PASS | 6 | 6 | - |
| `landing_smooth_qd_manual_bd` | PASS | 6 | 6 | - |
| `random_descriptor_qd` | PASS | 6 | 6 | - |
| `simple_yosys_stat_bd` | PASS | 6 | 6 | - |
| `netlist_motif_occupancy` | PASS | 6 | 6 | - |
| `synthesis_trajectory_nod` | PASS | 6 | 6 | - |

## Leaderboard

| Method | Valid PPA | Mean Fitness | Fitness W/T/L | Mean HV | HV W/T/L | Unique Netlists | Dup Netlists | Unique Motifs | PPA-Front Netlists | Audit Cells | Audit QD | Runtime s | LLM Calls |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `classic_revolution` | 209 | 0.2671 | 0/6/0 | 0.1245 | 0/6/0 | 70 | 139 | 43 | 12 | 12 | 2.3163 | 2472.4182 | 576 |
| `landing_smooth_qd_manual_bd` | 219 | 0.2271 | 0/5/1 | 0.1059 | 0/4/2 | 61 | 158 | 33 | 18 | 9 | 1.8526 | 2634.4162 | 576 |
| `random_descriptor_qd` | 213 | 0.2645 | 0/6/0 | 0.1175 | 2/3/1 | 64 | 149 | 41 | 21 | 8 | 1.7008 | 2836.8772 | 576 |
| `simple_yosys_stat_bd` | 201 | 0.2512 | 0/5/1 | 0.1242 | 1/3/2 | 62 | 139 | 45 | 16 | 11 | 2.0779 | 2488.3132 | 576 |
| `netlist_motif_occupancy` | 192 | 0.2350 | 0/4/2 | 0.0606 | 1/3/2 | 64 | 128 | 37 | 13 | 8 | -3.0274 | 2818.0163 | 576 |
| `synthesis_trajectory_nod` | 205 | 0.2511 | 0/5/1 | 0.1208 | 2/3/1 | 72 | 133 | 52 | 13 | 11 | -2.0643 | 2732.1768 | 576 |

## Robustness Funnel

| Method | Total | Syntax | Functionality | Synthesis | OpenROAD | Valid PPA |
| --- | --- | --- | --- | --- | --- | --- |
| `classic_revolution` | 288 | 275 (95.5%) | 209 (72.6%) | 209 (72.6%) | 209 (72.6%) | 209 (72.6%) |
| `landing_smooth_qd_manual_bd` | 288 | 275 (95.5%) | 219 (76.0%) | 219 (76.0%) | 219 (76.0%) | 219 (76.0%) |
| `random_descriptor_qd` | 288 | 248 (86.1%) | 213 (74.0%) | 213 (74.0%) | 213 (74.0%) | 213 (74.0%) |
| `simple_yosys_stat_bd` | 288 | 257 (89.2%) | 201 (69.8%) | 201 (69.8%) | 201 (69.8%) | 201 (69.8%) |
| `netlist_motif_occupancy` | 288 | 251 (87.2%) | 192 (66.7%) | 192 (66.7%) | 192 (66.7%) | 192 (66.7%) |
| `synthesis_trajectory_nod` | 288 | 259 (89.9%) | 205 (71.2%) | 205 (71.2%) | 205 (71.2%) | 205 (71.2%) |

## Failure Breakdown

| Method | Failure Reason | Count |
| --- | --- | --- |
| `classic_revolution` | `failed_functionality` | 66 |
| `classic_revolution` | `failed_syntax` | 13 |
| `landing_smooth_qd_manual_bd` | `failed_functionality` | 56 |
| `landing_smooth_qd_manual_bd` | `failed_syntax` | 13 |
| `random_descriptor_qd` | `failed_functionality` | 35 |
| `random_descriptor_qd` | `failed_syntax` | 22 |
| `random_descriptor_qd` | `failed_diff` | 17 |
| `random_descriptor_qd` | `failed_synthesis` | 1 |
| `simple_yosys_stat_bd` | `failed_functionality` | 56 |
| `simple_yosys_stat_bd` | `failed_diff` | 22 |
| `simple_yosys_stat_bd` | `failed_syntax` | 9 |
| `netlist_motif_occupancy` | `failed_functionality` | 59 |
| `netlist_motif_occupancy` | `failed_syntax` | 18 |
| `netlist_motif_occupancy` | `failed_diff` | 18 |
| `netlist_motif_occupancy` | `failed_format` | 1 |
| `synthesis_trajectory_nod` | `failed_functionality` | 53 |
| `synthesis_trajectory_nod` | `failed_syntax` | 15 |
| `synthesis_trajectory_nod` | `failed_diff` | 14 |
| `synthesis_trajectory_nod` | `failed_synthesis_functionality` | 1 |

## Anytime Summary

| Method | Final Gen | Final Covered | Final Fitness | Final HV | Fitness AUC | HV AUC |
| --- | --- | --- | --- | --- | --- | --- |
| `classic_revolution` | 3 | 6 | 0.2671 | 0.1245 | 0.2327 | 0.0728 |
| `landing_smooth_qd_manual_bd` | 3 | 6 | 0.2271 | 0.1059 | 0.2095 | 0.0643 |
| `random_descriptor_qd` | 3 | 6 | 0.2645 | 0.1175 | 0.2451 | 0.0987 |
| `simple_yosys_stat_bd` | 3 | 6 | 0.2512 | 0.1242 | 0.2262 | 0.0919 |
| `netlist_motif_occupancy` | 3 | 6 | 0.2350 | 0.0606 | 0.2087 | 0.0416 |
| `synthesis_trajectory_nod` | 3 | 6 | 0.2511 | 0.1208 | 0.2214 | 0.0789 |

The JSON report includes per-generation anytime rows for each method.

## Figures

- `anytime_mean_best_fitness`: `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_seed1_figures/anytime_mean_best_fitness.png`
- `anytime_mean_hypervolume`: `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_seed1_figures/anytime_mean_hypervolume.png`

## Per-Problem Win/Loss Matrix

| Method | Problem | Fitness Delta | Fitness | HV Delta | HV |
| --- | --- | --- | --- | --- | --- |
| `classic_revolution` | `RTLLM/Prob011_multi_16bit` | 0.0000 | T | 0.0000 | T |
| `classic_revolution` | `RTLLM/Prob019_sub_64bit` | 0.0000 | T | 0.0000 | T |
| `classic_revolution` | `RTLLM/Prob048_pe` | 0.0000 | T | 0.0000 | T |
| `classic_revolution` | `VerilogEval-Spec-to-RTL/Prob021_mux256to1v` | 0.0000 | T | 0.0000 | T |
| `classic_revolution` | `VerilogEval-Spec-to-RTL/Prob030_popcount255` | 0.0000 | T | 0.0000 | T |
| `classic_revolution` | `VerilogEval-Spec-to-RTL/Prob105_rotate100` | 0.0000 | T | 0.0000 | T |
| `landing_smooth_qd_manual_bd` | `RTLLM/Prob011_multi_16bit` | -0.2114 | L | -0.0245 | L |
| `landing_smooth_qd_manual_bd` | `RTLLM/Prob019_sub_64bit` | -0.0296 | T | -0.0871 | L |
| `landing_smooth_qd_manual_bd` | `RTLLM/Prob048_pe` | 0.0010 | T | 0.0000 | T |
| `landing_smooth_qd_manual_bd` | `VerilogEval-Spec-to-RTL/Prob021_mux256to1v` | 0.0000 | T | 0.0000 | T |
| `landing_smooth_qd_manual_bd` | `VerilogEval-Spec-to-RTL/Prob030_popcount255` | 0.0000 | T | 0.0000 | T |
| `landing_smooth_qd_manual_bd` | `VerilogEval-Spec-to-RTL/Prob105_rotate100` | 0.0000 | T | 0.0000 | T |
| `random_descriptor_qd` | `RTLLM/Prob011_multi_16bit` | -0.0004 | T | 0.0023 | W |
| `random_descriptor_qd` | `RTLLM/Prob019_sub_64bit` | -0.0296 | T | -0.0871 | L |
| `random_descriptor_qd` | `RTLLM/Prob048_pe` | 0.0010 | T | 0.0000 | T |
| `random_descriptor_qd` | `VerilogEval-Spec-to-RTL/Prob021_mux256to1v` | 0.0138 | T | 0.0429 | W |
| `random_descriptor_qd` | `VerilogEval-Spec-to-RTL/Prob030_popcount255` | -0.0002 | T | 0.0000 | T |
| `random_descriptor_qd` | `VerilogEval-Spec-to-RTL/Prob105_rotate100` | 0.0000 | T | 0.0000 | T |
| `simple_yosys_stat_bd` | `RTLLM/Prob011_multi_16bit` | -0.1111 | L | -0.0245 | L |
| `simple_yosys_stat_bd` | `RTLLM/Prob019_sub_64bit` | -0.0016 | T | -0.0048 | L |
| `simple_yosys_stat_bd` | `RTLLM/Prob048_pe` | 0.0063 | T | 0.0000 | T |
| `simple_yosys_stat_bd` | `VerilogEval-Spec-to-RTL/Prob021_mux256to1v` | 0.0000 | T | 0.0000 | T |
| `simple_yosys_stat_bd` | `VerilogEval-Spec-to-RTL/Prob030_popcount255` | 0.0115 | T | 0.0275 | W |
| `simple_yosys_stat_bd` | `VerilogEval-Spec-to-RTL/Prob105_rotate100` | 0.0000 | T | 0.0000 | T |
| `netlist_motif_occupancy` | `RTLLM/Prob011_multi_16bit` | -0.0681 | L | -0.0227 | L |
| `netlist_motif_occupancy` | `RTLLM/Prob019_sub_64bit` | -0.1368 | L | -0.4037 | L |
| `netlist_motif_occupancy` | `RTLLM/Prob048_pe` | -0.0029 | T | 0.0000 | T |
| `netlist_motif_occupancy` | `VerilogEval-Spec-to-RTL/Prob021_mux256to1v` | 0.0138 | T | 0.0429 | W |
| `netlist_motif_occupancy` | `VerilogEval-Spec-to-RTL/Prob030_popcount255` | 0.0000 | T | 0.0000 | T |
| `netlist_motif_occupancy` | `VerilogEval-Spec-to-RTL/Prob105_rotate100` | 0.0016 | T | 0.0000 | T |
| `synthesis_trajectory_nod` | `RTLLM/Prob011_multi_16bit` | -0.1008 | L | -0.0245 | L |
| `synthesis_trajectory_nod` | `RTLLM/Prob019_sub_64bit` | 0.0000 | T | 0.0000 | T |
| `synthesis_trajectory_nod` | `RTLLM/Prob048_pe` | 0.0013 | T | 0.0000 | W |
| `synthesis_trajectory_nod` | `VerilogEval-Spec-to-RTL/Prob021_mux256to1v` | 0.0000 | T | 0.0000 | T |
| `synthesis_trajectory_nod` | `VerilogEval-Spec-to-RTL/Prob030_popcount255` | 0.0036 | T | 0.0026 | W |
| `synthesis_trajectory_nod` | `VerilogEval-Spec-to-RTL/Prob105_rotate100` | 0.0000 | T | 0.0000 | T |

## Per-Problem PPA And Diversity

| Method | Problem | Valid PPA | Best Fitness | HV | Pareto Points | Ref-Beating | Unique Netlists | Dup Netlists | PPA-Front Netlists | Objectives |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `classic_revolution` | `RTLLM/Prob011_multi_16bit` | 16 | 0.3647 | 0.0245 | 1 | 3 | 12 | 4 | 1 | area/power/eff_clk_period |
| `classic_revolution` | `RTLLM/Prob019_sub_64bit` | 43 | 0.4823 | 0.4499 | 3 | 6 | 12 | 31 | 3 | area/power |
| `classic_revolution` | `RTLLM/Prob048_pe` | 27 | 0.0056 | 0.0000 | 8 | 11 | 4 | 23 | 2 | area/power/eff_clk_period |
| `classic_revolution` | `VerilogEval-Spec-to-RTL/Prob021_mux256to1v` | 31 | 0.4232 | 0.2724 | 5 | 31 | 4 | 27 | 1 | area/power |
| `classic_revolution` | `VerilogEval-Spec-to-RTL/Prob030_popcount255` | 48 | 0.2851 | 0.0000 | 1 | 22 | 19 | 29 | 1 | area/power |
| `classic_revolution` | `VerilogEval-Spec-to-RTL/Prob105_rotate100` | 44 | 0.0416 | 0.0000 | 15 | 15 | 19 | 25 | 4 | area/power/eff_clk_period |
| `landing_smooth_qd_manual_bd` | `RTLLM/Prob011_multi_16bit` | 27 | 0.1533 | 0.0000 | 14 | 0 | 18 | 9 | 7 | area/power/eff_clk_period |
| `landing_smooth_qd_manual_bd` | `RTLLM/Prob019_sub_64bit` | 45 | 0.4527 | 0.3628 | 1 | 5 | 8 | 37 | 1 | area/power |
| `landing_smooth_qd_manual_bd` | `RTLLM/Prob048_pe` | 24 | 0.0066 | 0.0000 | 13 | 12 | 5 | 19 | 2 | area/power/eff_clk_period |
| `landing_smooth_qd_manual_bd` | `VerilogEval-Spec-to-RTL/Prob021_mux256to1v` | 38 | 0.4232 | 0.2724 | 8 | 38 | 3 | 35 | 1 | area/power |
| `landing_smooth_qd_manual_bd` | `VerilogEval-Spec-to-RTL/Prob030_popcount255` | 45 | 0.2851 | 0.0000 | 1 | 23 | 17 | 28 | 1 | area/power |
| `landing_smooth_qd_manual_bd` | `VerilogEval-Spec-to-RTL/Prob105_rotate100` | 40 | 0.0416 | 0.0000 | 24 | 24 | 10 | 30 | 6 | area/power/eff_clk_period |
| `random_descriptor_qd` | `RTLLM/Prob011_multi_16bit` | 33 | 0.3643 | 0.0268 | 1 | 4 | 20 | 13 | 1 | area/power/eff_clk_period |
| `random_descriptor_qd` | `RTLLM/Prob019_sub_64bit` | 36 | 0.4527 | 0.3628 | 1 | 2 | 6 | 30 | 1 | area/power |
| `random_descriptor_qd` | `RTLLM/Prob048_pe` | 26 | 0.0066 | 0.0000 | 6 | 9 | 7 | 19 | 4 | area/power/eff_clk_period |
| `random_descriptor_qd` | `VerilogEval-Spec-to-RTL/Prob021_mux256to1v` | 40 | 0.4370 | 0.3153 | 5 | 40 | 4 | 36 | 2 | area/power |
| `random_descriptor_qd` | `VerilogEval-Spec-to-RTL/Prob030_popcount255` | 37 | 0.2850 | 0.0000 | 15 | 14 | 13 | 24 | 7 | area/power |
| `random_descriptor_qd` | `VerilogEval-Spec-to-RTL/Prob105_rotate100` | 41 | 0.0416 | 0.0000 | 26 | 26 | 14 | 27 | 6 | area/power/eff_clk_period |
| `simple_yosys_stat_bd` | `RTLLM/Prob011_multi_16bit` | 26 | 0.2536 | 0.0000 | 14 | 0 | 17 | 9 | 6 | area/power/eff_clk_period |
| `simple_yosys_stat_bd` | `RTLLM/Prob019_sub_64bit` | 40 | 0.4807 | 0.4451 | 1 | 3 | 6 | 34 | 1 | area/power |
| `simple_yosys_stat_bd` | `RTLLM/Prob048_pe` | 23 | 0.0119 | 0.0000 | 6 | 9 | 6 | 17 | 3 | area/power/eff_clk_period |
| `simple_yosys_stat_bd` | `VerilogEval-Spec-to-RTL/Prob021_mux256to1v` | 28 | 0.4232 | 0.2724 | 1 | 28 | 4 | 24 | 1 | area/power |
| `simple_yosys_stat_bd` | `VerilogEval-Spec-to-RTL/Prob030_popcount255` | 42 | 0.2966 | 0.0275 | 5 | 15 | 13 | 29 | 3 | area/power |
| `simple_yosys_stat_bd` | `VerilogEval-Spec-to-RTL/Prob105_rotate100` | 42 | 0.0416 | 0.0000 | 16 | 16 | 16 | 26 | 2 | area/power/eff_clk_period |
| `netlist_motif_occupancy` | `RTLLM/Prob011_multi_16bit` | 22 | 0.2966 | 0.0018 | 10 | 3 | 17 | 5 | 6 | area/power/eff_clk_period |
| `netlist_motif_occupancy` | `RTLLM/Prob019_sub_64bit` | 40 | 0.3455 | 0.0462 | 2 | 4 | 8 | 32 | 1 | area/power |
| `netlist_motif_occupancy` | `RTLLM/Prob048_pe` | 22 | 0.0026 | 0.0000 | 3 | 10 | 5 | 17 | 2 | area/power/eff_clk_period |
| `netlist_motif_occupancy` | `VerilogEval-Spec-to-RTL/Prob021_mux256to1v` | 34 | 0.4370 | 0.3153 | 5 | 34 | 4 | 30 | 2 | area/power |
| `netlist_motif_occupancy` | `VerilogEval-Spec-to-RTL/Prob030_popcount255` | 38 | 0.2851 | 0.0000 | 1 | 22 | 14 | 24 | 1 | area/power |
| `netlist_motif_occupancy` | `VerilogEval-Spec-to-RTL/Prob105_rotate100` | 36 | 0.0432 | 0.0000 | 1 | 25 | 16 | 20 | 1 | area/power/eff_clk_period |
| `synthesis_trajectory_nod` | `RTLLM/Prob011_multi_16bit` | 31 | 0.2639 | 0.0000 | 5 | 0 | 24 | 7 | 5 | area/power/eff_clk_period |
| `synthesis_trajectory_nod` | `RTLLM/Prob019_sub_64bit` | 41 | 0.4823 | 0.4499 | 1 | 5 | 10 | 31 | 1 | area/power |
| `synthesis_trajectory_nod` | `RTLLM/Prob048_pe` | 26 | 0.0069 | 0.0000 | 4 | 10 | 6 | 20 | 2 | area/power/eff_clk_period |
| `synthesis_trajectory_nod` | `VerilogEval-Spec-to-RTL/Prob021_mux256to1v` | 31 | 0.4232 | 0.2724 | 4 | 31 | 3 | 28 | 1 | area/power |
| `synthesis_trajectory_nod` | `VerilogEval-Spec-to-RTL/Prob030_popcount255` | 36 | 0.2887 | 0.0026 | 2 | 18 | 14 | 22 | 2 | area/power |
| `synthesis_trajectory_nod` | `VerilogEval-Spec-to-RTL/Prob105_rotate100` | 40 | 0.0416 | 0.0000 | 20 | 21 | 15 | 25 | 2 | area/power/eff_clk_period |

## Artifact Roots

- `classic_revolution`: `exp/auto_bd_research/development_preliminary_seed1/classic_revolution/seed_1001/standard_results`
- `landing_smooth_qd_manual_bd`: `exp/auto_bd_research/development_preliminary_seed1/landing_smooth_qd_manual_bd/seed_1001/standard_results`
- `random_descriptor_qd`: `exp/auto_bd_research/development_preliminary_seed1/random_descriptor_qd/seed_1001/standard_results`
- `simple_yosys_stat_bd`: `exp/auto_bd_research/development_preliminary_seed1/simple_yosys_stat_bd/seed_1001/standard_results`
- `netlist_motif_occupancy`: `exp/auto_bd_research/development_preliminary_seed1/netlist_motif_occupancy/seed_1001/standard_results`
- `synthesis_trajectory_nod`: `exp/auto_bd_research/development_preliminary_seed1/synthesis_trajectory_nod/seed_1001/standard_results`
