# synthesis_trajectory_nod Seed-1 Artifact Report

Status: generated from standardized Auto-BD artifacts.

## Source

- Phase: `development_preliminary_seed1`
- Seed: `1001`
- Reference method: `classic_revolution`
- Standard result root: `exp/auto_bd_research/development_preliminary_seed1/synthesis_trajectory_nod/seed_1001/standard_results`

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
| Valid PPA candidates | 205 |
| Mean best fitness | 0.2511 |
| Fitness W/T/L | 0/5/1 |
| Mean hypervolume | 0.1208 |
| Hypervolume W/T/L | 2/3/1 |
| Unique canonical netlists | 72 |
| Unique motif signatures | 52 |
| PPA-front unique netlists | 13 |

## Robustness Funnel

| Stage | Count | Rate |
| --- | --- | --- |
| Syntax | 259 | 89.9% |
| Functionality | 205 | 71.2% |
| Synthesis | 205 | 71.2% |
| OpenROAD | 205 | 71.2% |
| Valid PPA | 205 | 71.2% |

## QD Archive

| Metric | Value |
| --- | --- |
| Archive type | grid_quantile |
| Internal occupied cells | 31 |
| Internal QD score | 4.0109 |
| Common-audit occupied cells | 11 |
| Common-audit coverage | 0.0072 |
| Common-audit QD score | -2.0643 |
| Common-audit entropy | 2.8120 |

## Representative Elites

| Selection | Problem | Fitness | Area | Power | Timing | RTL | Netlist |
| --- | --- | --- | --- | --- | --- | --- | --- |
| method_best | `RTLLM/Prob019_sub_64bit` | 0.4823 | 340.0000 | 0.0002 | 0.0000 | `.../RTLLM/Prob019_sub_64bit/Gen3/Prob019_sub_64bit_sample3_M-E/code.sv` | `.../RTLLM/Prob019_sub_64bit/Gen3/Prob019_sub_64bit_sample3_M-E/code.syn.v` |
| problem_best | `RTLLM/Prob011_multi_16bit` | 0.2639 | 1068.0000 | 0.1020 | 0.7400 | `.../RTLLM/Prob011_multi_16bit/Gen2/Prob011_multi_16bit_sample4_M-E/code.sv` | `.../RTLLM/Prob011_multi_16bit/Gen2/Prob011_multi_16bit_sample4_M-E/code.syn.v` |
| problem_best | `RTLLM/Prob019_sub_64bit` | 0.4823 | 340.0000 | 0.0002 | 0.0000 | `.../RTLLM/Prob019_sub_64bit/Gen3/Prob019_sub_64bit_sample3_M-E/code.sv` | `.../RTLLM/Prob019_sub_64bit/Gen3/Prob019_sub_64bit_sample3_M-E/code.syn.v` |
| problem_best | `RTLLM/Prob048_pe` | 0.0069 | 3440.0000 | 0.4460 | 1.5600 | `.../RTLLM/Prob048_pe/Gen2/Prob048_pe_sample1_M-E/code.sv` | `.../RTLLM/Prob048_pe/Gen2/Prob048_pe_sample1_M-E/code.syn.v` |
| problem_best | `VerilogEval-Spec-to-RTL/Prob021_mux256to1v` | 0.4232 | 1482.0000 | 0.0004 | 0.0000 | `.../VerilogEval-Spec-to-RTL/Prob021_mux256to1v/Gen2/Prob021_mux256to1v_sample1_M-E/code.sv` | `.../VerilogEval-Spec-to-RTL/Prob021_mux256to1v/Gen2/Prob021_mux256to1v_sample1_M-E/code.syn.v` |
| problem_best | `VerilogEval-Spec-to-RTL/Prob030_popcount255` | 0.2887 | 1335.0000 | 0.0294 | 0.0000 | `.../VerilogEval-Spec-to-RTL/Prob030_popcount255/Gen2/Prob030_popcount255_sample6_C-F/code.sv` | `.../VerilogEval-Spec-to-RTL/Prob030_popcount255/Gen2/Prob030_popcount255_sample6_C-F/code.syn.v` |
| problem_best | `VerilogEval-Spec-to-RTL/Prob105_rotate100` | 0.0416 | 965.0000 | 0.0960 | 0.2200 | `.../VerilogEval-Spec-to-RTL/Prob105_rotate100/Gen0/Prob105_rotate100_sample10_initial/code.sv` | `.../VerilogEval-Spec-to-RTL/Prob105_rotate100/Gen0/Prob105_rotate100_sample10_initial/code.syn.v` |

## Notes

- This report is generated; keep interpretation and final decisions in `accept_reject.md`.
- Full cross-method comparisons live in `../../auto_bd_seed1_centralized_report.md`.
