# sr_raw_pca_qd Seed-1 Artifact Report

Status: generated from standardized Auto-BD artifacts.

## Source

- Phase: `development_preliminary_seed1`
- Seed: `1001`
- Reference method: `classic_revolution`
- Standard result root: `exp/auto_bd_research/development_preliminary_seed1/sr_raw_pca_qd/seed_1001/standard_results`

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
| Valid PPA candidates | 209 |
| Mean best fitness | 0.2404 |
| Fitness W/T/L | 0/5/1 |
| Mean hypervolume | 0.1208 |
| Hypervolume W/T/L | 1/4/1 |
| Unique canonical netlists | 74 |
| Unique motif signatures | 48 |
| PPA-front unique netlists | 14 |

## Robustness Funnel

| Stage | Count | Rate |
| --- | --- | --- |
| Syntax | 261 | 90.6% |
| Functionality | 209 | 72.6% |
| Synthesis | 209 | 72.6% |
| OpenROAD | 209 | 72.6% |
| Valid PPA | 209 | 72.6% |

## QD Archive

| Metric | Value |
| --- | --- |
| Archive type | grid_quantile |
| Internal occupied cells | 27 |
| Internal QD score | 4.7046 |
| Common-audit occupied cells | 12 |
| Common-audit coverage | 0.0078 |
| Common-audit QD score | 1.9663 |
| Common-audit entropy | 2.8654 |

## Representative Elites

| Selection | Problem | Fitness | Area | Power | Timing | RTL | Netlist |
| --- | --- | --- | --- | --- | --- | --- | --- |
| method_best | `RTLLM/Prob019_sub_64bit` | 0.4823 | 340.0000 | 0.0002 | 0.0000 | `.../RTLLM/Prob019_sub_64bit/Gen1/Prob019_sub_64bit_sample5_M-E/code.sv` | `.../RTLLM/Prob019_sub_64bit/Gen1/Prob019_sub_64bit_sample5_M-E/code.syn.v` |
| problem_best | `RTLLM/Prob011_multi_16bit` | 0.2065 | 1088.0000 | 0.1420 | 0.6600 | `.../RTLLM/Prob011_multi_16bit/Gen3/Prob011_multi_16bit_sample10_C-D/code.sv` | `.../RTLLM/Prob011_multi_16bit/Gen3/Prob011_multi_16bit_sample10_C-D/code.syn.v` |
| problem_best | `RTLLM/Prob019_sub_64bit` | 0.4823 | 340.0000 | 0.0002 | 0.0000 | `.../RTLLM/Prob019_sub_64bit/Gen1/Prob019_sub_64bit_sample5_M-E/code.sv` | `.../RTLLM/Prob019_sub_64bit/Gen1/Prob019_sub_64bit_sample5_M-E/code.syn.v` |
| problem_best | `RTLLM/Prob048_pe` | 0.0008 | 3450.0000 | 0.4500 | 1.5700 | `.../RTLLM/Prob048_pe/Gen0/Prob048_pe_sample11_initial/code.sv` | `.../RTLLM/Prob048_pe/Gen0/Prob048_pe_sample11_initial/code.syn.v` |
| problem_best | `VerilogEval-Spec-to-RTL/Prob021_mux256to1v` | 0.4232 | 1482.0000 | 0.0004 | 0.0000 | `.../VerilogEval-Spec-to-RTL/Prob021_mux256to1v/Gen1/Prob021_mux256to1v_sample2_M-E/code.sv` | `.../VerilogEval-Spec-to-RTL/Prob021_mux256to1v/Gen1/Prob021_mux256to1v_sample2_M-E/code.syn.v` |
| problem_best | `VerilogEval-Spec-to-RTL/Prob030_popcount255` | 0.2883 | 1335.0000 | 0.0297 | 0.0000 | `.../VerilogEval-Spec-to-RTL/Prob030_popcount255/Gen3/Prob030_popcount255_sample11_M-S/code.sv` | `.../VerilogEval-Spec-to-RTL/Prob030_popcount255/Gen3/Prob030_popcount255_sample11_M-S/code.syn.v` |
| problem_best | `VerilogEval-Spec-to-RTL/Prob105_rotate100` | 0.0416 | 965.0000 | 0.0960 | 0.2200 | `.../VerilogEval-Spec-to-RTL/Prob105_rotate100/Gen0/Prob105_rotate100_sample10_initial/code.sv` | `.../VerilogEval-Spec-to-RTL/Prob105_rotate100/Gen0/Prob105_rotate100_sample10_initial/code.syn.v` |

## Notes

- This report is generated; keep interpretation and final decisions in `accept_reject.md`.
- Full cross-method comparisons live in `../../auto_bd_seed1_centralized_report.md`.
