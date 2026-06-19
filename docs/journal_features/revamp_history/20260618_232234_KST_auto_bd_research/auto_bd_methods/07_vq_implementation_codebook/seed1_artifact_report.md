# sr_vq_codebook_qd Seed-1 Artifact Report

Status: generated from standardized Auto-BD artifacts.

## Source

- Phase: `development_preliminary_seed1`
- Seed: `1001`
- Reference method: `classic_revolution`
- Standard result root: `exp/auto_bd_research/development_preliminary_seed1/sr_vq_codebook_qd/seed_1001/standard_results`

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
| Valid PPA candidates | 174 |
| Mean best fitness | 0.2105 |
| Fitness W/T/L | 0/5/1 |
| Mean hypervolume | 0.1110 |
| Hypervolume W/T/L | 1/3/2 |
| Unique canonical netlists | 45 |
| Unique motif signatures | 30 |
| PPA-front unique netlists | 13 |

## Robustness Funnel

| Stage | Count | Rate |
| --- | --- | --- |
| Syntax | 220 | 76.4% |
| Functionality | 174 | 60.4% |
| Synthesis | 174 | 60.4% |
| OpenROAD | 174 | 60.4% |
| Valid PPA | 174 | 60.4% |

## QD Archive

| Metric | Value |
| --- | --- |
| Archive type | grid_quantile |
| Internal occupied cells | 11 |
| Internal QD score | 1.8219 |
| Common-audit occupied cells | 9 |
| Common-audit coverage | 0.0059 |
| Common-audit QD score | 0.8485 |
| Common-audit entropy | 2.6088 |

## Representative Elites

| Selection | Problem | Fitness | Area | Power | Timing | RTL | Netlist |
| --- | --- | --- | --- | --- | --- | --- | --- |
| method_best | `RTLLM/Prob019_sub_64bit` | 0.4538 | 392.0000 | 0.0003 | 0.0000 | `.../RTLLM/Prob019_sub_64bit/Gen2/Prob019_sub_64bit_sample1_M-E/code.sv` | `.../RTLLM/Prob019_sub_64bit/Gen2/Prob019_sub_64bit_sample1_M-E/code.syn.v` |
| problem_best | `RTLLM/Prob011_multi_16bit` | 0.0424 | 1070.0000 | 0.1530 | 1.1800 | `.../RTLLM/Prob011_multi_16bit/Gen0/Prob011_multi_16bit_sample10_initial/code.sv` | `.../RTLLM/Prob011_multi_16bit/Gen0/Prob011_multi_16bit_sample10_initial/code.syn.v` |
| problem_best | `RTLLM/Prob019_sub_64bit` | 0.4538 | 392.0000 | 0.0003 | 0.0000 | `.../RTLLM/Prob019_sub_64bit/Gen2/Prob019_sub_64bit_sample1_M-E/code.sv` | `.../RTLLM/Prob019_sub_64bit/Gen2/Prob019_sub_64bit_sample1_M-E/code.syn.v` |
| problem_best | `RTLLM/Prob048_pe` | 0.0056 | 3451.0000 | 0.4320 | 1.6100 | `.../RTLLM/Prob048_pe/Gen3/Prob048_pe_sample12_M-I/code.sv` | `.../RTLLM/Prob048_pe/Gen3/Prob048_pe_sample12_M-I/code.syn.v` |
| problem_best | `VerilogEval-Spec-to-RTL/Prob021_mux256to1v` | 0.4232 | 1482.0000 | 0.0004 | 0.0000 | `.../VerilogEval-Spec-to-RTL/Prob021_mux256to1v/Gen1/Prob021_mux256to1v_sample2_M-E/code.sv` | `.../VerilogEval-Spec-to-RTL/Prob021_mux256to1v/Gen1/Prob021_mux256to1v_sample2_M-E/code.syn.v` |
| problem_best | `VerilogEval-Spec-to-RTL/Prob030_popcount255` | 0.2966 | 1296.0000 | 0.0306 | 0.0000 | `.../VerilogEval-Spec-to-RTL/Prob030_popcount255/Gen2/Prob030_popcount255_sample12_M-I/code.sv` | `.../VerilogEval-Spec-to-RTL/Prob030_popcount255/Gen2/Prob030_popcount255_sample12_M-I/code.syn.v` |
| problem_best | `VerilogEval-Spec-to-RTL/Prob105_rotate100` | 0.0416 | 965.0000 | 0.0960 | 0.2200 | `.../VerilogEval-Spec-to-RTL/Prob105_rotate100/Gen0/Prob105_rotate100_sample10_initial/code.sv` | `.../VerilogEval-Spec-to-RTL/Prob105_rotate100/Gen0/Prob105_rotate100_sample10_initial/code.syn.v` |

## Notes

- This report is generated; keep interpretation and final decisions in `accept_reject.md`.
- Full cross-method comparisons live in `../../auto_bd_seed1_centralized_report.md`.
