# PCN Variant Results Report

This report tracks the staged PCN experiments. The first smoke run completed on
2026-06-30 and is treated as a diagnostic, not a positive PCN result, because
the memory-recall lane never fired under the initial credit gate.

## Executive Conclusion

The initial `smoke` stage does not justify scaling to the original full screen.
Classic REvolution remains the clear winner on the three-problem smoke subset:
mean HV is 0.3508 for classic versus 0.1758 for the best PCN arm
(`pcn_rf_leafid_quality_memory_8x5`). The best PCN arm retains only 50.1
percent of classic mean HV and loses mean HV-AUC by 0.1946.

The mechanism table explains why this is not yet a fair test of PCN memory.
`qd_memory_active` became true for the PCN arms, but `memory_refine_generated`
is zero for every method/problem. The initial `qd_memory_min_cell_credit=0.50`
gate was stricter than the observed cell credits, which were mostly around
0.24 to 0.34. The first smoke therefore tested a guarded QD shell with passive
archive accounting, not actual QD-memory recall.

Next action: run `smoke_credit025`, a corrective smoke stage with the same
three problems and budget, but with `qd_memory_min_cell_credit=0.25`. It keeps
only three arms: matched classic, RF-leaf PCN, and random-memory PCN. If RF
still loses badly or cannot beat random when memory recall actually fires, PCN
should be revised before any broader screen.

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

The only fair conclusion from `smoke` is that the initial memory gate was too
strict and that RF-leaf descriptors look more promising than SR or random under
the same guarded shell. The corrected `smoke_credit025` stage is required
before deciding whether PCN deserves screen-scale compute.

## Interpretation Rule

A PCN success claim requires both performance and mechanism evidence. A mean HV
increase without memory-lane contribution is not a QD-memory result. A
memory-lane contribution without HV/HV-AUC or front-breadth preservation is not
a PPA optimization win.
