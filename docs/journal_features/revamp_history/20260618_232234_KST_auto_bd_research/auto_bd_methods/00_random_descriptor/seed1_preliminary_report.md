# Random Descriptor Control Seed-1 Preliminary Report

## Scope

This is a development-subset seed-1 control report. It is only a fast
Gate 0 and artifact sanity check. It is not a seed-3 screening report, a
seed-5 final report, or a complete PPA/hypervolume/common-audit QD report.

## Run Policy

- Phase: `development_preliminary_seed1`
- Method arm: `random_descriptor_qd`
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
| Classic minus random | 0 |
| Random minus classic | 0 |
| Classic problem-seed minus random | 0 |

The random descriptor control matches original REvolution's seed-1
development coverage set `C`.

## Problem Summary

| Problem | Status | PPA Artifacts | Best Score |
| --- | --- | ---: | ---: |
| `RTLLM/Prob011_multi_16bit` | success | 33 | 0.3643308942855222 |
| `RTLLM/Prob019_sub_64bit` | success | 36 | 0.452712179958205 |
| `RTLLM/Prob048_pe` | success | 26 | 0.006579168080201192 |
| `VerilogEval-Spec-to-RTL/Prob021_mux256to1v` | success | 40 | 0.43702052370842176 |
| `VerilogEval-Spec-to-RTL/Prob030_popcount255` | success | 37 | 0.2849612403100775 |
| `VerilogEval-Spec-to-RTL/Prob105_rotate100` | success | 41 | 0.04155040525406675 |

## Artifacts

- `../../auto_bd_gate0_coverage_seed1_random_descriptor_qd.json`
- `../../../../../../exp/auto_bd_research/development_preliminary_seed1/random_descriptor_qd/seed_1001/revolution/openai_gpt-oss-120b/20260618_173737_revolution_summary_results.txt`
- `../../../../../../exp/auto_bd_research/development_preliminary_seed1/random_descriptor_qd/seed_1001/revolution/openai_gpt-oss-120b/20260618_174705_revolution_summary_results.txt`

## Interpretation

This result shows that deterministic random archive partitioning does not
break valid-PPA coverage on the six-problem seed-1 development subset.
That is useful as a pipeline sanity check, but it does not provide a
meaningful behavioral descriptor.

Any proposed Auto-BD method must beat this control on the full report
surface, not only on internal archive coverage.

## Remaining Required Evidence

- seed-3 screening, if this control is used in promoted comparisons
- common-audit archive QD score and coverage
- PPA hypervolume and anytime curves
- canonical-netlist and motif-signature diversity
- centralized per-problem win/loss/tie table
