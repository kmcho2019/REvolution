# netlist_motif_occupancy Seed-1 Artifact Report

Status: generated from standardized Auto-BD artifacts.

## Source

- Phase: `development_preliminary_seed1`
- Seed: `1001`
- Reference method: `classic_revolution`
- Standard result root: `exp/auto_bd_research/development_preliminary_seed1/netlist_motif_occupancy/seed_1001/standard_results`

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
| Valid PPA candidates | 192 |
| Mean best fitness | 0.2350 |
| Fitness W/T/L | 0/4/2 |
| Mean hypervolume | 0.0606 |
| Hypervolume W/T/L | 1/3/2 |
| Unique canonical netlists | 64 |
| Unique motif signatures | 37 |
| PPA-front unique netlists | 13 |

## Robustness Funnel

| Stage | Count | Rate |
| --- | --- | --- |
| Syntax | 251 | 87.2% |
| Functionality | 192 | 66.7% |
| Synthesis | 192 | 66.7% |
| OpenROAD | 192 | 66.7% |
| Valid PPA | 192 | 66.7% |

## QD Archive

| Metric | Value |
| --- | --- |
| Archive type | grid_quantile |
| Internal occupied cells | 26 |
| Internal QD score | 3.8403 |
| Common-audit occupied cells | 8 |
| Common-audit coverage | 0.0052 |
| Common-audit QD score | -3.0274 |
| Common-audit entropy | 2.6138 |

## Representative Elites

| Selection | Problem | Fitness | Area | Power | Timing | RTL | Netlist |
| --- | --- | --- | --- | --- | --- | --- | --- |
| method_best | `VerilogEval-Spec-to-RTL/Prob021_mux256to1v` | 0.4370 | 1394.0000 | 0.0005 | 0.0000 | `.../VerilogEval-Spec-to-RTL/Prob021_mux256to1v/Gen2/Prob021_mux256to1v_sample2_C-D/code.sv` | `.../VerilogEval-Spec-to-RTL/Prob021_mux256to1v/Gen2/Prob021_mux256to1v_sample2_C-D/code.syn.v` |
| problem_best | `RTLLM/Prob011_multi_16bit` | 0.2966 | 1075.0000 | 0.0940 | 0.6700 | `.../RTLLM/Prob011_multi_16bit/Gen3/Prob011_multi_16bit_sample2_C-D/code.sv` | `.../RTLLM/Prob011_multi_16bit/Gen3/Prob011_multi_16bit_sample2_C-D/code.syn.v` |
| problem_best | `RTLLM/Prob019_sub_64bit` | 0.3455 | 592.0000 | 0.0004 | 0.0000 | `.../RTLLM/Prob019_sub_64bit/Gen2/Prob019_sub_64bit_sample1_M-E/code.sv` | `.../RTLLM/Prob019_sub_64bit/Gen2/Prob019_sub_64bit_sample1_M-E/code.syn.v` |
| problem_best | `RTLLM/Prob048_pe` | 0.0026 | 3439.0000 | 0.4490 | 1.5700 | `.../RTLLM/Prob048_pe/Gen1/Prob048_pe_sample1_initial/code.sv` | `.../RTLLM/Prob048_pe/Gen1/Prob048_pe_sample1_initial/code.syn.v` |
| problem_best | `VerilogEval-Spec-to-RTL/Prob021_mux256to1v` | 0.4370 | 1394.0000 | 0.0005 | 0.0000 | `.../VerilogEval-Spec-to-RTL/Prob021_mux256to1v/Gen2/Prob021_mux256to1v_sample2_C-D/code.sv` | `.../VerilogEval-Spec-to-RTL/Prob021_mux256to1v/Gen2/Prob021_mux256to1v_sample2_C-D/code.syn.v` |
| problem_best | `VerilogEval-Spec-to-RTL/Prob030_popcount255` | 0.2851 | 1339.0000 | 0.0311 | 0.0000 | `.../VerilogEval-Spec-to-RTL/Prob030_popcount255/Gen2/Prob030_popcount255_sample12_C-F/code.sv` | `.../VerilogEval-Spec-to-RTL/Prob030_popcount255/Gen2/Prob030_popcount255_sample12_C-F/code.syn.v` |
| problem_best | `VerilogEval-Spec-to-RTL/Prob105_rotate100` | 0.0432 | 963.0000 | 0.0957 | 0.2200 | `.../VerilogEval-Spec-to-RTL/Prob105_rotate100/Gen2/Prob105_rotate100_sample2_M-E/code.sv` | `.../VerilogEval-Spec-to-RTL/Prob105_rotate100/Gen2/Prob105_rotate100_sample2_M-E/code.syn.v` |

## Notes

- This report is generated; keep interpretation and final decisions in `accept_reject.md`.
- Full cross-method comparisons live in `../../auto_bd_seed1_centralized_report.md`.
