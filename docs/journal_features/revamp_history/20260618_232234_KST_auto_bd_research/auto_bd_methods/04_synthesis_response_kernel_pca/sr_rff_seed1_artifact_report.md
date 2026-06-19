# sr_rff_pca_qd Seed-1 Artifact Report

Status: generated from standardized Auto-BD artifacts.

## Source

- Phase: `development_preliminary_seed1`
- Seed: `1001`
- Reference method: `classic_revolution`
- Standard result root: `exp/auto_bd_research/development_preliminary_seed1/sr_rff_pca_qd/seed_1001/standard_results`

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
| Mean best fitness | 0.2630 |
| Fitness W/T/L | 0/6/0 |
| Mean hypervolume | 0.1229 |
| Hypervolume W/T/L | 0/5/1 |
| Unique canonical netlists | 63 |
| Unique motif signatures | 43 |
| PPA-front unique netlists | 20 |

## Robustness Funnel

| Stage | Count | Rate |
| --- | --- | --- |
| Syntax | 246 | 85.4% |
| Functionality | 197 | 68.4% |
| Synthesis | 197 | 68.4% |
| OpenROAD | 197 | 68.4% |
| Valid PPA | 197 | 68.4% |

## QD Archive

| Metric | Value |
| --- | --- |
| Archive type | grid_quantile |
| Internal occupied cells | 19 |
| Internal QD score | 4.1810 |
| Common-audit occupied cells | 10 |
| Common-audit coverage | 0.0065 |
| Common-audit QD score | 2.8111 |
| Common-audit entropy | 2.6807 |

## Representative Elites

| Selection | Problem | Fitness | Area | Power | Timing | RTL | Netlist |
| --- | --- | --- | --- | --- | --- | --- | --- |
| method_best | `RTLLM/Prob019_sub_64bit` | 0.4823 | 340.0000 | 0.0002 | 0.0000 | `.../RTLLM/Prob019_sub_64bit/Gen1/Prob019_sub_64bit_sample2_M-E/code.sv` | `.../RTLLM/Prob019_sub_64bit/Gen1/Prob019_sub_64bit_sample2_M-E/code.syn.v` |
| problem_best | `RTLLM/Prob011_multi_16bit` | 0.3433 | 1016.0000 | 0.0741 | 0.7000 | `.../RTLLM/Prob011_multi_16bit/Gen2/Prob011_multi_16bit_sample5_M-T/code.sv` | `.../RTLLM/Prob011_multi_16bit/Gen2/Prob011_multi_16bit_sample5_M-T/code.syn.v` |
| problem_best | `RTLLM/Prob019_sub_64bit` | 0.4823 | 340.0000 | 0.0002 | 0.0000 | `.../RTLLM/Prob019_sub_64bit/Gen1/Prob019_sub_64bit_sample2_M-E/code.sv` | `.../RTLLM/Prob019_sub_64bit/Gen1/Prob019_sub_64bit_sample2_M-E/code.syn.v` |
| problem_best | `RTLLM/Prob048_pe` | 0.0026 | 3439.0000 | 0.4490 | 1.5700 | `.../RTLLM/Prob048_pe/Gen0/Prob048_pe_sample10_initial/code.sv` | `.../RTLLM/Prob048_pe/Gen0/Prob048_pe_sample10_initial/code.syn.v` |
| problem_best | `VerilogEval-Spec-to-RTL/Prob021_mux256to1v` | 0.4232 | 1482.0000 | 0.0004 | 0.0000 | `.../VerilogEval-Spec-to-RTL/Prob021_mux256to1v/Gen2/Prob021_mux256to1v_sample1_M-E/code.sv` | `.../VerilogEval-Spec-to-RTL/Prob021_mux256to1v/Gen2/Prob021_mux256to1v_sample1_M-E/code.syn.v` |
| problem_best | `VerilogEval-Spec-to-RTL/Prob030_popcount255` | 0.2850 | 1339.0000 | 0.0312 | 0.0000 | `.../VerilogEval-Spec-to-RTL/Prob030_popcount255/Gen0/Prob030_popcount255_sample10_initial/code.sv` | `.../VerilogEval-Spec-to-RTL/Prob030_popcount255/Gen0/Prob030_popcount255_sample10_initial/code.syn.v` |
| problem_best | `VerilogEval-Spec-to-RTL/Prob105_rotate100` | 0.0416 | 965.0000 | 0.0960 | 0.2200 | `.../VerilogEval-Spec-to-RTL/Prob105_rotate100/Gen0/Prob105_rotate100_sample10_initial/code.sv` | `.../VerilogEval-Spec-to-RTL/Prob105_rotate100/Gen0/Prob105_rotate100_sample10_initial/code.syn.v` |

## Notes

- This report is generated; keep interpretation and final decisions in `accept_reject.md`.
- Full cross-method comparisons live in `../../auto_bd_seed1_centralized_report.md`.
