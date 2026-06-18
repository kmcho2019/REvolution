# simple_yosys_stat_bd Seed-1 Artifact Report

Status: generated from standardized Auto-BD artifacts.

## Source

- Phase: `development_preliminary_seed1`
- Seed: `1001`
- Reference method: `classic_revolution`
- Standard result root: `exp/auto_bd_research/development_preliminary_seed1/simple_yosys_stat_bd/seed_1001/standard_results`

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
| Valid PPA candidates | 201 |
| Mean best fitness | 0.2512 |
| Fitness W/T/L | 0/5/1 |
| Mean hypervolume | 0.1242 |
| Hypervolume W/T/L | 1/3/2 |
| Unique canonical netlists | 62 |
| Unique motif signatures | 45 |
| PPA-front unique netlists | 16 |

## Robustness Funnel

| Stage | Count | Rate |
| --- | --- | --- |
| Syntax | 257 | 89.2% |
| Functionality | 201 | 69.8% |
| Synthesis | 201 | 69.8% |
| OpenROAD | 201 | 69.8% |
| Valid PPA | 201 | 69.8% |

## QD Archive

| Metric | Value |
| --- | --- |
| Archive type | grid_quantile |
| Internal occupied cells | 23 |
| Internal QD score | 3.6027 |
| Common-audit occupied cells | 11 |
| Common-audit coverage | 0.0072 |
| Common-audit QD score | 2.0779 |
| Common-audit entropy | 2.8840 |

## Representative Elites

| Selection | Problem | Fitness | Area | Power | Timing | RTL | Netlist |
| --- | --- | --- | --- | --- | --- | --- | --- |
| method_best | `RTLLM/Prob019_sub_64bit` | 0.4807 | 343.0000 | 0.0002 | 0.0000 | `.../RTLLM/Prob019_sub_64bit/Gen1/Prob019_sub_64bit_sample7_M-E/code.sv` | `.../RTLLM/Prob019_sub_64bit/Gen1/Prob019_sub_64bit_sample7_M-E/code.syn.v` |
| problem_best | `RTLLM/Prob011_multi_16bit` | 0.2536 | 1161.0000 | 0.0996 | 0.6900 | `.../RTLLM/Prob011_multi_16bit/Gen3/Prob011_multi_16bit_sample5_C-D/code.sv` | `.../RTLLM/Prob011_multi_16bit/Gen3/Prob011_multi_16bit_sample5_C-D/code.syn.v` |
| problem_best | `RTLLM/Prob019_sub_64bit` | 0.4807 | 343.0000 | 0.0002 | 0.0000 | `.../RTLLM/Prob019_sub_64bit/Gen1/Prob019_sub_64bit_sample7_M-E/code.sv` | `.../RTLLM/Prob019_sub_64bit/Gen1/Prob019_sub_64bit_sample7_M-E/code.syn.v` |
| problem_best | `RTLLM/Prob048_pe` | 0.0119 | 3417.0000 | 0.4250 | 1.6200 | `.../RTLLM/Prob048_pe/Gen3/Prob048_pe_sample11_M-S/code.sv` | `.../RTLLM/Prob048_pe/Gen3/Prob048_pe_sample11_M-S/code.syn.v` |
| problem_best | `VerilogEval-Spec-to-RTL/Prob021_mux256to1v` | 0.4232 | 1482.0000 | 0.0004 | 0.0000 | `.../VerilogEval-Spec-to-RTL/Prob021_mux256to1v/Gen2/Prob021_mux256to1v_sample8_C-F/code.sv` | `.../VerilogEval-Spec-to-RTL/Prob021_mux256to1v/Gen2/Prob021_mux256to1v_sample8_C-F/code.syn.v` |
| problem_best | `VerilogEval-Spec-to-RTL/Prob030_popcount255` | 0.2966 | 1296.0000 | 0.0306 | 0.0000 | `.../VerilogEval-Spec-to-RTL/Prob030_popcount255/Gen2/Prob030_popcount255_sample8_M-I/code.sv` | `.../VerilogEval-Spec-to-RTL/Prob030_popcount255/Gen2/Prob030_popcount255_sample8_M-I/code.syn.v` |
| problem_best | `VerilogEval-Spec-to-RTL/Prob105_rotate100` | 0.0416 | 965.0000 | 0.0960 | 0.2200 | `.../VerilogEval-Spec-to-RTL/Prob105_rotate100/Gen0/Prob105_rotate100_sample10_initial/code.sv` | `.../VerilogEval-Spec-to-RTL/Prob105_rotate100/Gen0/Prob105_rotate100_sample10_initial/code.syn.v` |

## Notes

- This report is generated; keep interpretation and final decisions in `accept_reject.md`.
- Full cross-method comparisons live in `../../auto_bd_seed1_centralized_report.md`.
