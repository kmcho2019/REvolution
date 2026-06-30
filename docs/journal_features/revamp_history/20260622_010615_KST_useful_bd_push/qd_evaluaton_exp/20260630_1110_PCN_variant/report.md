# PCN Variant Results Report

This report tracks the staged PCN experiments. The first smoke run completed on
2026-06-30 and is treated as a diagnostic, not a clean PCN result, because it
did not preserve classic REvolution's EoH operator stack and its memory-recall
lane never fired.

## Executive Conclusion

The initial `smoke` stage does not justify scaling to the original full screen.
Classic REvolution remains the clear winner on the three-problem smoke subset:
mean HV is 0.3508 for classic versus 0.1758 for the best PCN arm
(`pcn_rf_leafid_quality_memory_8x5`). The best PCN arm retains only 50.1
percent of classic mean HV and loses mean HV-AUC by 0.1946.

The result is diagnostic rather than decisive because the tested algorithm was
not the intended PCN algorithm. It used QD mode with
`single_thought_operator`, while classic used `eoh_strategies`. It also logged
`memory_refine_generated=0` for every method/problem. The first smoke therefore
tested a passive QD shell with a different operator stack, not
classic-preserving memory recall.

Next action: run `smoke_v2`, the corrected PCN-v2 smoke. It keeps the same
three problems, budget, model, seed, evaluator, and worker settings. The PCN-v2
arms use `pcn_classic_preserving_memory`, `qd_operator_kind=eoh_strategies`,
`qd_memory_min_cell_credit=0.25`, and one forced memory-refine slot after the
evidence gate if a sampleable cell exists. The matrix is matched classic,
PCN-v2 RF memory, PCN-v2 random memory, and PCN-v2 passive EoH archive.

## Why This Variant Exists

The 20260629 RTLLM full suite showed that the best QD arm,
`rf_deepgate_hybrid_delayed_8x5`, retained only 73.4 percent of classic mean HV
on the reference-complete RTLLM subset. Coverage also dropped from 33/46 for
classic to 27/46 for the best QD arm. That result suggests the issue is not
only descriptor choice. The archive policy itself was too disruptive.

PCN tests a stricter question: can descriptor-indexed memory help if classic
REvolution remains the main optimizer?

## Overview Figures

- `figures/pcn_algorithm_flow.png`: PCN scheduler and memory-credit flow.
- `figures/pcn_stage_ladder.png`: smoke, screen, long-budget, and RTLLM
  promotion sequence.
- `figures/smoke/mean_hv_by_method.png`: smoke mean-HV ranking.
- `figures/smoke/hv_delta_vs_classic_heatmap.png`: per-problem HV deltas.
- `figures/smoke/problem_valid_ppa_by_method.png`: valid-PPA counts.
- `figures/smoke/memory_refine_generated_by_problem.png`: mechanism check
  showing that the initial memory lane generated zero calls.

## Smoke Result Tables

The packaged smoke tables live under `analysis/smoke/`.

### Method Summary

| Method | Covered | Mean HV | Mean HV-AUC | HV retention |
| --- | ---: | ---: | ---: | ---: |
| `classic_revolution_8x5` | 3/3 | 0.3508 | 0.3072 | 100.0% |
| `pcn_rf_leafid_quality_memory_8x5` | 3/3 | 0.1758 | 0.1126 | 50.1% |
| `pcn_random_quality_memory_8x5` | 3/3 | 0.0771 | 0.0750 | 22.0% |
| `pcn_passive_archive_8x5` | 3/3 | 0.0619 | 0.0613 | 17.6% |
| `pcn_sr_quality_memory_8x5` | 3/3 | 0.0566 | 0.0559 | 16.1% |

### Per-Problem Read

- `Prob019_sub_64bit`: all PCN variants have zero HV while classic reaches
  0.4499. This is the largest failure mode.
- `Prob036_edge_detect`: RF-leaf PCN ties classic final HV, but trails HV-AUC
  because it reaches the front later.
- `Prob045_alu`: PCN variants add two Pareto points in some cases, but classic
  still wins HV and produces many more valid-PPA candidates.

### Mechanism Check

`analysis/smoke/pcn_memory_summary.csv` shows zero `memory_refine_generated`
calls across all smoke PCN arms. This invalidates any strong claim about PCN
memory, because the memory mechanism did not spend live LLM budget.

The only fair conclusion from `smoke` is that the old implementation violated
the main PCN premise. The corrected `smoke_v2` stage is required before
deciding whether PCN deserves screen-scale compute or long-budget tests.

## Interpretation Rule

A PCN success claim requires both performance and mechanism evidence. A mean HV
increase without memory-lane contribution is not a QD-memory result. A
memory-lane contribution without HV/HV-AUC or front-breadth preservation is not
a PPA optimization win.
