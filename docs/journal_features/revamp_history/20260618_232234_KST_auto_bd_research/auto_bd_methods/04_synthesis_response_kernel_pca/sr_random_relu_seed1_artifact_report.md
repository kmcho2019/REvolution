# sr_random_relu_pca_qd Seed-1 Artifact Report

Status: generated from standardized Auto-BD artifacts.

## Source

- Phase: `development_preliminary_seed1`
- Seed: `1001`
- Reference method: `classic_revolution`
- Standard result root: `exp/auto_bd_research/development_preliminary_seed1/sr_random_relu_pca_qd/seed_1001/standard_results`

## Gate 0

| Metric | Value |
| --- | --- |
| Gate 0 | PASS |
| Covered problems | 6 |
| Classic covered problems | 6 |
| Missing classic problems | - |

## PPA And Diversity Summary

| Metric | Value |
| --- | --- |
| Valid PPA candidates | 197 |
| Mean best fitness | 0.2536 |
| Fitness W/T/L | 1/4/1 |
| Mean hypervolume | 0.1454 |
| Hypervolume W/T/L | 2/3/1 |
| Unique canonical netlists | 68 |
| Unique motif signatures | 44 |
| PPA-front unique netlists | 11 |

## Robustness Funnel

| Stage | Count | Rate |
| --- | --- | --- |
| Syntax | 240 | 83.3% |
| Functionality | 197 | 68.4% |
| Synthesis | 197 | 68.4% |
| OpenROAD | 197 | 68.4% |
| Valid PPA | 197 | 68.4% |

## QD Archive

| Metric | Value |
| --- | --- |
| Archive type | grid_quantile |
| Internal occupied cells | 25 |
| Internal QD score | 5.2658 |
| Common-audit occupied cells | 10 |
| Common-audit coverage | 0.0065 |
| Common-audit QD score | 2.3765 |
| Common-audit entropy | 2.7269 |

## Representative Elites

| Selection | Problem | Fitness | Area | Power | Timing | RTL | Netlist |
| --- | --- | --- | --- | --- | --- | --- | --- |
| method_best | `RTLLM/Prob019_sub_64bit` | 0.4823 | 340.0000 | 0.0002 | 0.0000 | `.../RTLLM/Prob019_sub_64bit/Gen1/Prob019_sub_64bit_sample5_M-E/code.sv` | `.../RTLLM/Prob019_sub_64bit/Gen1/Prob019_sub_64bit_sample5_M-E/code.syn.v` |
| problem_best | `RTLLM/Prob011_multi_16bit` | 0.2222 | 1055.0000 | 0.1360 | 0.6800 | `.../RTLLM/Prob011_multi_16bit/Gen2/Prob011_multi_16bit_sample3_M-F/code.sv` | `.../RTLLM/Prob011_multi_16bit/Gen2/Prob011_multi_16bit_sample3_M-F/code.syn.v` |
| problem_best | `RTLLM/Prob019_sub_64bit` | 0.4823 | 340.0000 | 0.0002 | 0.0000 | `.../RTLLM/Prob019_sub_64bit/Gen1/Prob019_sub_64bit_sample5_M-E/code.sv` | `.../RTLLM/Prob019_sub_64bit/Gen1/Prob019_sub_64bit_sample5_M-E/code.syn.v` |
| problem_best | `RTLLM/Prob048_pe` | 0.0150 | 3400.0000 | 0.4230 | 1.6200 | `.../RTLLM/Prob048_pe/Gen1/Prob048_pe_sample10_M-S/code.sv` | `.../RTLLM/Prob048_pe/Gen1/Prob048_pe_sample10_M-S/code.syn.v` |
| problem_best | `VerilogEval-Spec-to-RTL/Prob021_mux256to1v` | 0.4720 | 1183.0000 | 0.0004 | 0.0000 | `.../VerilogEval-Spec-to-RTL/Prob021_mux256to1v/Gen1/Prob021_mux256to1v_sample2_M-E/code.sv` | `.../VerilogEval-Spec-to-RTL/Prob021_mux256to1v/Gen1/Prob021_mux256to1v_sample2_M-E/code.syn.v` |
| problem_best | `VerilogEval-Spec-to-RTL/Prob030_popcount255` | 0.2886 | 1335.0000 | 0.0295 | 0.0000 | `.../VerilogEval-Spec-to-RTL/Prob030_popcount255/Gen2/Prob030_popcount255_sample2_C-D/code.sv` | `.../VerilogEval-Spec-to-RTL/Prob030_popcount255/Gen2/Prob030_popcount255_sample2_C-D/code.syn.v` |
| problem_best | `VerilogEval-Spec-to-RTL/Prob105_rotate100` | 0.0416 | 965.0000 | 0.0960 | 0.2200 | `.../VerilogEval-Spec-to-RTL/Prob105_rotate100/Gen0/Prob105_rotate100_sample10_initial/code.sv` | `.../VerilogEval-Spec-to-RTL/Prob105_rotate100/Gen0/Prob105_rotate100_sample10_initial/code.syn.v` |

## Notes

- This report is generated; keep interpretation and final decisions in `accept_reject.md`.
- Full cross-method comparisons live in `../../auto_bd_seed1_centralized_report.md`.
