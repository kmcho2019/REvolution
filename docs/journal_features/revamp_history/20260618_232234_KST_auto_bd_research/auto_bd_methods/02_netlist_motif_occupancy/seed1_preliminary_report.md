# Netlist Motif Occupancy Seed-1 Preliminary Report

## Scope

This is a development-subset seed-1 method report. It is only a fast
Gate 0 and artifact sanity check. It is not a seed-3 screening report, a
seed-5 final report, or a complete PPA/hypervolume/common-audit QD report.

## Run Policy

- Phase: `development_preliminary_seed1`
- Method arm: `netlist_motif_occupancy`
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
| Classic minus motif | 0 |
| Motif minus classic | 0 |
| Classic problem-seed minus motif | 0 |

The netlist motif occupancy descriptor matches original REvolution's
seed-1 development coverage set `C`.

## Problem Summary

| Problem | Status | PPA Artifacts | Best Score |
| --- | --- | ---: | ---: |
| `RTLLM/Prob011_multi_16bit` | success | 22 | 0.2966177416721881 |
| `RTLLM/Prob019_sub_64bit` | success | 40 | 0.3454853847797425 |
| `RTLLM/Prob048_pe` | success | 22 | 0.002637280923532347 |
| `VerilogEval-Spec-to-RTL/Prob021_mux256to1v` | success | 34 | 0.43702052370842176 |
| `VerilogEval-Spec-to-RTL/Prob030_popcount255` | success | 38 | 0.28511627906976744 |
| `VerilogEval-Spec-to-RTL/Prob105_rotate100` | success | 36 | 0.043176166884953404 |

## Artifacts

- `../../auto_bd_gate0_coverage_seed1_netlist_motif_occupancy.json`
- `../../../../../../exp/auto_bd_research/development_preliminary_seed1/netlist_motif_occupancy/seed_1001/revolution/openai_gpt-oss-120b/20260618_184839_revolution_summary_results.txt`
- `../../../../../../exp/auto_bd_research/development_preliminary_seed1/netlist_motif_occupancy/seed_1001/revolution/openai_gpt-oss-120b/20260618_185911_revolution_summary_results.txt`

## Interpretation

This result shows that motif occupancy can be used in-loop without
breaking valid-PPA coverage on the six-problem seed-1 development subset.
It is more hardware-native than the random descriptor and more structured
than aggregate Yosys-stat axes, but this preliminary result does not yet
show whether it improves PPA, QD diversity, or common-audit archive
quality.

## Remaining Required Evidence

- seed-3 screening before promotion beyond preliminary status
- common-audit archive QD score and coverage
- PPA hypervolume and anytime curves
- correlation against manual BDs, Yosys-stat controls, and PPA objectives
- canonical-netlist, motif-signature, and PPA-relevant diversity
- representative elites showing interpretable motif differences
