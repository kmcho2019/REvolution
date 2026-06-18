# Yosys-Stat BD Control Seed-1 Preliminary Report

## Scope

This is a development-subset seed-1 control report. It is only a fast
Gate 0 and artifact sanity check. It is not a seed-3 screening report, a
seed-5 final report, or a complete PPA/hypervolume/common-audit QD report.

## Run Policy

- Phase: `development_preliminary_seed1`
- Method arm: `simple_yosys_stat_bd`
- Seed: `1001`
- Model: `openai/gpt-oss-120b`
- vLLM context requirement: `max_model_len=131072`
- Archive substrate: landing Smooth-QD with `grid_quantile`,
  `pareto_front` cells, and `nsga2_global_rank` parent selection

## Gate 0 Result

| Metric | Value |
| --- | ---: |
| Covered problems | 6 |
| Missing problems | 0 |
| Classic minus Yosys-stat | 0 |
| Yosys-stat minus classic | 0 |
| Classic problem-seed minus Yosys-stat | 0 |

The Yosys-stat BD control matches original REvolution's seed-1
development coverage set `C`.

## Problem Summary

| Problem | Status | PPA Artifacts | Best Score |
| --- | --- | ---: | ---: |
| `RTLLM/Prob011_multi_16bit` | success | 26 | 0.25355788897531184 |
| `RTLLM/Prob019_sub_64bit` | success | 40 | 0.4806618149034077 |
| `RTLLM/Prob048_pe` | success | 23 | 0.011884916798857224 |
| `VerilogEval-Spec-to-RTL/Prob021_mux256to1v` | success | 28 | 0.4231863785854045 |
| `VerilogEval-Spec-to-RTL/Prob030_popcount255` | success | 42 | 0.296595978718354 |
| `VerilogEval-Spec-to-RTL/Prob105_rotate100` | success | 42 | 0.04155040525406675 |

## Artifacts

- `../../auto_bd_gate0_coverage_seed1_simple_yosys_stat_bd.json`
- `../../../../../../exp/auto_bd_research/development_preliminary_seed1/simple_yosys_stat_bd/seed_1001/revolution/openai_gpt-oss-120b/20260618_180728_revolution_summary_results.txt`
- `../../../../../../exp/auto_bd_research/development_preliminary_seed1/simple_yosys_stat_bd/seed_1001/revolution/openai_gpt-oss-120b/20260618_181700_revolution_summary_results.txt`

## Interpretation

This result shows that a compact, synthesis-stat descriptor does not
break valid-PPA coverage on the six-problem seed-1 development subset.
It is a strong simple control because it is CAD-native and nearly free to
extract, but it is still too coarse to claim as the final Auto-BD method
without stronger PPA, QD, diversity, and interpretability evidence.

## Remaining Required Evidence

- seed-3 screening, if this control is used in promoted comparisons
- common-audit archive QD score and coverage
- PPA hypervolume and anytime curves
- correlation against manual BDs and PPA objectives
- canonical-netlist and motif-signature diversity
- centralized per-problem win/loss/tie table
