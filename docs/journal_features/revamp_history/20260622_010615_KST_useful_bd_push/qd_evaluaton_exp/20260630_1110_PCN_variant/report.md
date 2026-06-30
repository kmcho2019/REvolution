# PCN Variant Results Report

This report tracks the staged PCN experiments. The first smoke run completed on
2026-06-30 and is treated as a diagnostic, not a clean PCN result, because it
did not preserve classic REvolution's EoH operator stack and its memory-recall
lane never fired.

## Executive Conclusion

The corrected PCN ladder has now run three smoke stages. The initial smoke was
invalid as a PCN test because it did not preserve classic REvolution's EoH
operator stack and the memory-refine lane never fired. `smoke_v2` fixed those
mechanism problems. `smoke_v3` then made memory recall more selective by
requiring stagnation evidence before spending the auxiliary memory call.

`smoke_v3` is the best PCN signal so far. RF stagnation memory retains 98.9
percent of classic mean HV, beats the random-memory control, and also beats
the passive EoH archive control on mean HV and mean HV-AUC. The result is
still not a headline win: classic remains first on mean HV, 0.3471 versus
0.3432, and the RF memory lane does not yet add global-front or local-front
candidates.

The current conclusion is narrow but useful: front-guarded PCN is no longer
collapsing the classic optimizer, and learned RF memory is now better than
random memory and passive archive logging in this smoke. It is not yet strong
enough for a 20x10 or full RTLLM launch. The next step should be either a
diagnostic frozen 8-problem screen or a PCN-v4 trigger that requires stronger
stagnation and front-contribution evidence before memory recall fires.

## Stagnation Smoke V3

`smoke_v3` used the same three reference-complete problems and `8x5` budget as
`smoke_v2`:

- `Prob019_sub_64bit`
- `Prob036_edge_detect`
- `Prob045_alu`

The new active arms were:

- `pcn_v3_rf_stagnation_memory_8x5`
- `pcn_v3_random_stagnation_memory_8x5`

Both preserved the corrected PCN-v2 implementation: EoH operators, one-parent
memory mutation, no two-parent fusion, no descriptor-targeted prompt, and the
separate classic primary pool. The only policy change was
`qd_memory_trigger=stagnation` with `qd_memory_target_front_size=2`.

Packaged artifacts:

- `analysis/smoke_v3/summary.md`
- `analysis/smoke_v3/pcn_method_summary.csv`
- `analysis/smoke_v3/pcn_problem_summary.csv`
- `analysis/smoke_v3/pcn_memory_summary.csv`
- `figures/smoke_v3/`
- `analysis/smoke_v3/ppa_distribution/`

### Smoke V3 Method Summary

| Method | Covered | Mean HV | Mean HV-AUC | HV retention | Delta HV |
| --- | ---: | ---: | ---: | ---: | ---: |
| `classic_revolution_8x5` | 3/3 | 0.3471 | 0.3140 | 100.0% | +0.0000 |
| `pcn_v3_rf_stagnation_memory_8x5` | 3/3 | 0.3432 | 0.3131 | 98.9% | -0.0039 |
| `pcn_v2_passive_eoh_archive_8x5` | 3/3 | 0.3416 | 0.3080 | 98.4% | -0.0055 |
| `pcn_v3_random_stagnation_memory_8x5` | 3/3 | 0.3378 | 0.3057 | 97.3% | -0.0092 |

This is a better ordering than `smoke_v2`: the RF memory arm now beats both
controls. The margin is small, but the direction is meaningful because the
random-memory control is matched to the same scheduler and the passive arm
keeps the same EoH archive accounting without spending memory calls.

### Smoke V3 Per-Problem Read

- `Prob019_sub_64bit`: RF, random, and passive are all within a tiny positive
  margin of classic on final HV. RF has more valid-PPA candidates than classic
  and reaches slightly higher HV-AUC.
- `Prob036_edge_detect`: RF, passive, random, and classic tie final HV. This
  problem no longer separates the methods on final front quality.
- `Prob045_alu`: RF remains the failure mode, but the loss is smaller than in
  `smoke_v2`. RF loses 0.0116 HV to classic, while random loses 0.0277 and
  passive loses 0.0165. RF also has three Pareto points versus one for
  classic, but those points do not improve area-power hypervolume enough.

### Smoke V3 Mechanism Check

`pcn_v3_rf_stagnation_memory_8x5` passes the basic mechanism gates:

- memory-refine generated one call on all three smoke problems;
- memory-refine produced one valid-PPA child on all three smoke problems;
- RF memory beat random memory on mean HV and mean HV-AUC;
- RF memory beat passive archive logging on mean HV and mean HV-AUC;
- all classic-covered designs remained covered.

The missing mechanism gate is front productivity. The RF memory lane produced
valid children, but no global-front or local-front additions. The result
therefore supports "guarded memory is no longer harmful" more strongly than
"guarded memory directly adds new Pareto material."

### Smoke V3 Figure Review

The generated `smoke_v3` figures were visually inspected. The mean-HV bar
chart clearly shows the ordering `classic > RF > passive > random`. The
delta heatmap makes the central failure mode readable: all methods are neutral
or slightly positive on `Prob019`, tied on `Prob036`, and negative on
`Prob045`, with RF least negative among PCN arms. The memory-refine chart
confirms that RF memory fired on every smoke problem.

The direct PPA panel for `Prob045_alu` is especially useful. It shows that RF
memory explores more front breadth than classic, but classic still owns the
most useful area-gain region. That should guide the next variant: memory
recall must be tied to expected area-power front contribution, not just
stagnation.

### Smoke V3 Decision

Do not launch 20x10 or full RTLLM from this exact RF stagnation memory arm.
It is close enough to justify a small diagnostic screen if time permits, but
the absence of memory-lane front additions is a hard limit on the claim.

Reasonable next options:

- run the frozen 8-problem screen only as a diagnostic for RF-over-random
  survival;
- define PCN-v4 with a stricter trigger that requires both scalar stagnation
  and front stagnation, rather than either one;
- add a simple expected-benefit guard: memory recall can fire only from cells
  whose champion is near the global front or whose prior child improved a
  local/front metric;
- keep the implementation one-parent and EoH-only until memory produces front
  material.

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
