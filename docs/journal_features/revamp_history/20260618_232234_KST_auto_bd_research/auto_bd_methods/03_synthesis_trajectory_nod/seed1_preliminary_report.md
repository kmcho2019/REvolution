# Synthesis-Trajectory NOD Seed-1 Preliminary Report

## Scope

This is a development-subset seed-1 method report. It is only a fast
Gate 0, sidecar-artifact, and runtime sanity check. It is not a seed-3
screening report, a seed-5 final report, or a complete PPA/hypervolume
or common-audit QD report.

## Run Policy

- Phase: `development_preliminary_seed1`
- Method arm: `synthesis_trajectory_nod`
- Seed: `1001`
- Model: `openai/gpt-oss-120b`
- vLLM context requirement: `max_model_len=131072`
- Token policy: `--max_tokens 128000`, `--diff_max_tokens 128000`
- Archive substrate: landing Smooth-QD with `grid_quantile`,
  `pareto_front` cells, and `nsga2_global_rank` parent selection

## Pre-Fix Failure

The first ST-NOD seed-1 attempt failed during initialization for all six
problems. Successful synthesis/PPA candidates reached descriptor
extraction, but the legacy QD path had not created
`stage_dump_verilog_paths`.

Fix commit: `ac0e5d3a4c` (`fix(auto-bd): Create ST-NOD dumps in QD`).
The failed artifacts were preserved under:

`../../../../../../exp/auto_bd_research/development_preliminary_seed1/synthesis_trajectory_nod/seed_1001/revolution/openai_gpt-oss-120b_failed_pre_c97c73a/`

## Gate 0 Result

| Metric | Value |
| --- | ---: |
| Covered problems | 6 |
| Missing problems | 0 |
| Classic minus ST-NOD | 0 |
| ST-NOD minus classic | 0 |
| Classic problem-seed minus ST-NOD | 0 |
| ST-NOD problem-seed minus classic | 0 |

The ST-NOD descriptor matches original REvolution's seed-1 development
coverage set `C`.

## Problem Summary

| Problem | Status | PPA Artifacts | Best Score |
| --- | --- | ---: | ---: |
| `RTLLM/Prob011_multi_16bit` | success | 31 | 0.263880966784778 |
| `RTLLM/Prob019_sub_64bit` | success | 41 | 0.48228021147642647 |
| `RTLLM/Prob048_pe` | success | 26 | 0.006881127714002822 |
| `VerilogEval-Spec-to-RTL/Prob021_mux256to1v` | success | 31 | 0.4231863785854045 |
| `VerilogEval-Spec-to-RTL/Prob030_popcount255` | success | 36 | 0.2887477059705553 |
| `VerilogEval-Spec-to-RTL/Prob105_rotate100` | success | 40 | 0.04155040525406675 |

## Runtime Sanity

| Benchmark half | ST-NOD Runtime | Motif Runtime |
| --- | ---: | ---: |
| RTLLM | 528.97 s | 564.57 s |
| VerilogEval | 554.05 s | 548.10 s |

The seed-1 ST-NOD cost is in the same range as motif occupancy. Caching
is not required before seed-3 screening, though it may still be useful
for larger main or seed-5 runs.

## Artifacts

- `../../auto_bd_gate0_coverage_seed1_synthesis_trajectory_nod.json`
- `../../../../../../exp/auto_bd_research/development_preliminary_seed1/synthesis_trajectory_nod/seed_1001/revolution/openai_gpt-oss-120b/20260618_194350_revolution_summary_results.txt`
- `../../../../../../exp/auto_bd_research/development_preliminary_seed1/synthesis_trajectory_nod/seed_1001/revolution/openai_gpt-oss-120b/20260618_195311_revolution_summary_results.txt`

## Interpretation

This result shows that ST-NOD can be used in-loop without breaking
valid-PPA coverage on the six-problem seed-1 development subset. It also
confirms that the sidecar stage-dump path can be integrated without an
obvious seed-1 runtime blowup.

This preliminary result does not yet show that ST-NOD improves PPA,
hypervolume, common-audit QD coverage, or structural diversity.

## Remaining Required Evidence

- seed-3 screening before promotion beyond preliminary status
- motif-only versus trajectory descriptor comparison
- common-audit archive QD score and coverage
- PPA hypervolume and anytime curves
- correlation against manual BDs, Yosys-stat controls, and PPA objectives
- canonical-netlist, motif-signature, and PPA-relevant diversity
- representative elites showing interpretable trajectory differences
