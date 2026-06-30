# PCN Variant Results Report

This report tracks the staged PCN experiments. The first smoke run completed on
2026-06-30 and is treated as a diagnostic, not a clean PCN result, because it
did not preserve classic REvolution's EoH operator stack and its memory-recall
lane never fired.

## Executive Conclusion

The corrected `smoke_v2` result fixes the implementation problem from the
first smoke: PCN-v2 uses the EoH operator stack and the memory-refine lane does
fire. On the three reference-complete smoke problems, RF memory retains 97.3
percent of classic mean HV and beats the random-memory control on both mean HV
and mean HV-AUC.

That is useful mechanism evidence, but it is not enough to scale the exact
RF-memory configuration. RF memory still trails classic mean HV
0.3422 to 0.3518, while the passive EoH archive control is slightly ahead at
0.3530. The safest conclusion is that PCN-v2 now tests the intended mechanism,
and the RF descriptor is better than random memory, but active memory recall is
not yet proven better than conservative EoH search plus passive archive
accounting.

Next action: do not launch 20x10 or a broader screen from this exact RF-memory
arm. Define a PCN-v3 smoke that uses the same fixed implementation but makes
memory recall more selective: passive-first, stagnation-triggered, or
front-gap-triggered. The next variant should focus on avoiding the `Prob045`
HV loss while keeping the `Prob036` HV-AUC improvement.

## Corrected Smoke V2

`smoke_v2` used the same three reference-complete problems as the original
smoke:

- `Prob019_sub_64bit`
- `Prob036_edge_detect`
- `Prob045_alu`

The matched budget was `population_size=8`, `num_generations=5`, and
`seed=1001`. All arms used `openai/gpt-oss-120b` through the local vLLM
endpoint with 128k token limits.

Packaged artifacts:

- `analysis/smoke_v2/summary.md`
- `analysis/smoke_v2/pcn_method_summary.csv`
- `analysis/smoke_v2/pcn_problem_summary.csv`
- `analysis/smoke_v2/pcn_memory_summary.csv`
- `figures/smoke_v2/`
- `analysis/smoke_v2/ppa_distribution/`

### Smoke V2 Method Summary

| Method | Covered | Mean HV | Mean HV-AUC | HV retention | Delta HV |
| --- | ---: | ---: | ---: | ---: | ---: |
| `pcn_v2_passive_eoh_archive_8x5` | 3/3 | 0.3530 | 0.3167 | 100.3% | +0.0012 |
| `classic_revolution_8x5` | 3/3 | 0.3518 | 0.2956 | 100.0% | +0.0000 |
| `pcn_v2_rf_eoh_memory_8x5` | 3/3 | 0.3422 | 0.3116 | 97.3% | -0.0097 |
| `pcn_v2_random_eoh_memory_8x5` | 3/3 | 0.3100 | 0.1896 | 88.1% | -0.0418 |

The table should be read as a smoke signal, not a final performance claim.
With only three problems and one seed, the stable finding is the ordering and
mechanism behavior, not the small passive-vs-classic margin.

The passive arm is a control, not a new QD success claim. It runs the
corrected PCN EoH path with archive logging but no memory recall, so a small
gap between passive and classic may reflect EoH scheduling and stochastic
generation order as much as archive accounting.

### Smoke V2 Per-Problem Read

- `Prob019_sub_64bit`: classic, RF memory, and passive archive tie final HV.
  Random memory loses substantial HV, so generic memory pressure is harmful.
- `Prob036_edge_detect`: RF memory and passive archive tie classic final HV
  while improving HV-AUC by 0.0712. This is the encouraging PCN signal: the
  corrected EoH/QD path reaches useful material earlier without losing final
  HV.
- `Prob045_alu`: RF memory loses 0.0290 HV to classic even though it has more
  valid-PPA and Pareto points. This is the main failure mode. Extra front
  material did not translate into better hypervolume.

### Smoke V2 Mechanism Check

The corrected implementation passes the gates that the first smoke failed:

- RF memory generated one memory-refine call on each smoke problem.
- Random memory also generated one memory-refine call on each problem.
- RF and random memory each produced valid-PPA memory children on all three
  problems.
- RF memory produced one local-front insertion on `Prob045_alu`.
- No memory arm produced a global-front insertion.
- RF memory beat random memory on mean HV and mean HV-AUC.

The missing gate is performance against the passive control. The active RF
memory lane is better than random memory, but it is not better than passive
archive accounting in this smoke. That points to a scheduling issue more than
a descriptor-collapse issue.

### Figure Review

The generated figures were visually inspected. `mean_hv_by_method.png`,
`mean_hv_auc_by_method.png`, and `hv_delta_vs_classic_heatmap.png` make the
method ordering and per-problem failure clear. The
`memory_refine_generated_by_problem.png` plot confirms that the corrected
memory lane actually fired. The direct PPA panel for `Prob045_alu` shows why
the result is not a clean win: RF memory has more points, but the useful area
gain range is weaker than classic.

### Decision

Do not run the full screen or 20x10 experiment from
`pcn_v2_rf_eoh_memory_8x5` as configured. The corrected algorithm is no longer
invalid, but the active memory schedule is too eager for a scale-up.

The next PCN variant should keep the implementation and descriptor fixed while
changing only the trigger policy:

- passive archive for most generations;
- memory recall only after scalar best score or global front stagnates;
- memory recall only from cells with a demonstrable front gap or local-front
  candidate;
- at most one memory call in an 8-candidate generation;
- no two-parent fusion and no descriptor-targeted prompt.

That variant would test the sharper claim: QD memory helps when classic is
stalled or has discarded a near-front implementation family, not merely because
a credited cell exists.

## Initial Smoke

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

The corrected `smoke_v2` stage above replaces this initial smoke for PCN
mechanism assessment.

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
