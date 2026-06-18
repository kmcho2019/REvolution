# random_descriptor_qd Seed-1 Artifact Report

Status: generated from standardized Auto-BD artifacts.

## Source

- Phase: `development_preliminary_seed1`
- Seed: `1001`
- Reference method: `classic_revolution`
- Standard result root: `exp/auto_bd_research/development_preliminary_seed1/random_descriptor_qd/seed_1001/standard_results`

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
| Valid PPA candidates | 213 |
| Mean best fitness | 0.2645 |
| Fitness W/T/L | 0/6/0 |
| Mean hypervolume | 0.1175 |
| Hypervolume W/T/L | 2/3/1 |
| Unique canonical netlists | 64 |
| Unique motif signatures | 41 |
| PPA-front unique netlists | 21 |

## Robustness Funnel

| Stage | Count | Rate |
| --- | --- | --- |
| Syntax | 248 | 86.1% |
| Functionality | 213 | 74.0% |
| Synthesis | 213 | 74.0% |
| OpenROAD | 213 | 74.0% |
| Valid PPA | 213 | 74.0% |

## QD Archive

| Metric | Value |
| --- | --- |
| Archive type | grid_quantile |
| Internal occupied cells | 39 |
| Internal QD score | 6.1505 |
| Common-audit occupied cells | 8 |
| Common-audit coverage | 0.0052 |
| Common-audit QD score | 1.7008 |
| Common-audit entropy | 2.6551 |

## Representative Elites

| Selection | Problem | Fitness | Area | Power | Timing | RTL | Netlist |
| --- | --- | --- | --- | --- | --- | --- | --- |
| method_best | `RTLLM/Prob019_sub_64bit` | 0.4527 | 394.0000 | 0.0003 | 0.0000 | `.../RTLLM/Prob019_sub_64bit/Gen1/Prob019_sub_64bit_sample2_M-E/code.sv` | `.../RTLLM/Prob019_sub_64bit/Gen1/Prob019_sub_64bit_sample2_M-E/code.syn.v` |
| problem_best | `RTLLM/Prob011_multi_16bit` | 0.3643 | 944.0000 | 0.0827 | 0.6500 | `.../RTLLM/Prob011_multi_16bit/Gen3/Prob011_multi_16bit_sample10_C-D/code.sv` | `.../RTLLM/Prob011_multi_16bit/Gen3/Prob011_multi_16bit_sample10_C-D/code.syn.v` |
| problem_best | `RTLLM/Prob019_sub_64bit` | 0.4527 | 394.0000 | 0.0003 | 0.0000 | `.../RTLLM/Prob019_sub_64bit/Gen1/Prob019_sub_64bit_sample2_M-E/code.sv` | `.../RTLLM/Prob019_sub_64bit/Gen1/Prob019_sub_64bit_sample2_M-E/code.syn.v` |
| problem_best | `RTLLM/Prob048_pe` | 0.0066 | 3448.0000 | 0.4310 | 1.6100 | `.../RTLLM/Prob048_pe/Gen1/Prob048_pe_sample10_C-D/code.sv` | `.../RTLLM/Prob048_pe/Gen1/Prob048_pe_sample10_C-D/code.syn.v` |
| problem_best | `VerilogEval-Spec-to-RTL/Prob021_mux256to1v` | 0.4370 | 1394.0000 | 0.0005 | 0.0000 | `.../VerilogEval-Spec-to-RTL/Prob021_mux256to1v/Gen1/Prob021_mux256to1v_sample2_M-E/code.sv` | `.../VerilogEval-Spec-to-RTL/Prob021_mux256to1v/Gen1/Prob021_mux256to1v_sample2_M-E/code.syn.v` |
| problem_best | `VerilogEval-Spec-to-RTL/Prob030_popcount255` | 0.2850 | 1339.0000 | 0.0312 | 0.0000 | `.../VerilogEval-Spec-to-RTL/Prob030_popcount255/Gen0/Prob030_popcount255_sample10_initial/code.sv` | `.../VerilogEval-Spec-to-RTL/Prob030_popcount255/Gen0/Prob030_popcount255_sample10_initial/code.syn.v` |
| problem_best | `VerilogEval-Spec-to-RTL/Prob105_rotate100` | 0.0416 | 965.0000 | 0.0960 | 0.2200 | `.../VerilogEval-Spec-to-RTL/Prob105_rotate100/Gen0/Prob105_rotate100_sample10_initial/code.sv` | `.../VerilogEval-Spec-to-RTL/Prob105_rotate100/Gen0/Prob105_rotate100_sample10_initial/code.syn.v` |

## Notes

- This report is generated; keep interpretation and final decisions in `accept_reject.md`.
- Full cross-method comparisons live in `../../auto_bd_seed1_centralized_report.md`.
