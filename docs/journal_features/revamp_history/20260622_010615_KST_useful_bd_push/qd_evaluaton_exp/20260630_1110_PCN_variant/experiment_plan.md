# PCN Experiment Plan

## Objective

Test whether a quality-gated QD memory can improve or preserve PPA-front search
relative to classic REvolution while avoiding the failure modes seen in the
20260629 RTLLM full suite.

## Stages

### Stage 1: Smoke

Problems:

- `Prob019_sub_64bit`
- `Prob036_edge_detect`
- `Prob045_alu`

Budget:

```text
population_size = 8
num_generations = 5
seed = 1001
```

Arms:

- `classic_revolution_8x5`
- `pcn_passive_archive_8x5`
- `pcn_rf_leafid_quality_memory_8x5`
- `pcn_random_quality_memory_8x5`
- `pcn_sr_quality_memory_8x5`

Smoke passes only if the PCN RF arm preserves all classic-covered designs,
does not show an obvious HV/HV-AUC collapse, and emits nonzero memory-refine
calls. The initial smoke failed this mechanism check because the 0.50
cell-credit gate prevented memory recall.

### Stage 1b: Corrected PCN-v2 Smoke

Problems and budget are identical to Stage 1.

Arms:

- `classic_revolution_8x5`
- `pcn_v2_rf_eoh_memory_8x5`
- `pcn_v2_random_eoh_memory_8x5`
- `pcn_v2_passive_eoh_archive_8x5`

This stage corrects the algorithm mismatch from Stage 1:

- `qd_scheduler_mode=pcn_classic_preserving_memory`;
- `qd_operator_kind=eoh_strategies`;
- classic-lane requests use the classic EoH strategy stack;
- memory-refine requests use one-parent classic EoH operators;
- `qd_memory_min_cell_credit=0.25`;
- memory-refine is forced to one call after activation if a sampleable memory
  cell exists.

This stage exists to verify whether PCN memory helps after preserving classic's
hill-climbing machinery and actually spending live LLM budget on memory recall.

Stage 1b completed. RF memory fired on all three problems, produced valid-PPA
children, and beat the random-memory control. It did not beat classic mean HV,
and the passive EoH archive control was slightly stronger than the active RF
memory arm. Do not launch Stage 2 or 20x10 from this exact configuration.
Define a narrower next variant first, likely passive-first or
stagnation-triggered memory.

### Stage 1c: PCN-v3 Stagnation Smoke

Problems and budget are identical to Stage 1b.

Arms:

- `classic_revolution_8x5`
- `pcn_v3_rf_stagnation_memory_8x5`
- `pcn_v3_random_stagnation_memory_8x5`
- `pcn_v2_passive_eoh_archive_8x5`

This stage changes only the memory trigger. It keeps
`pcn_classic_preserving_memory`, EoH operators, one-parent memory mutation,
RF descriptor axes, random descriptor control, and passive archive control.

Memory recall is allowed only after the normal evidence gate and a simple
stagnation trigger:

- `current_generation >= 2`;
- at least 8 valid-PPA candidates have been observed;
- at least one sampleable credited memory cell exists;
- the latest completed generation did not improve scalar best quality, did
  not expand the global Pareto front, or still has fewer than two global-front
  points.

PCN-v3 passes only if RF memory beats random memory, does not lose to the
passive control, and avoids the `Prob045_alu` HV damage seen in Stage 1b.

Stage 1c completed. RF stagnation memory retained 98.9 percent of classic mean
HV, beat both the random-memory and passive-archive controls, and produced
valid-PPA memory children on all three smoke problems. It still trailed classic
mean HV by 0.0039 and did not produce global-front or local-front additions
from the memory lane. Treat it as the best PCN mechanism signal so far, not as
a headline win.

### Stage 2: Frozen Screen

Problems:

- `Prob019_sub_64bit`
- `Prob036_edge_detect`
- `Prob045_alu`
- `Prob015_multi_pipe_8bit`
- `Prob041_traffic_light`
- `Prob043_RAM`
- `Prob049_signal_generator`
- `Prob024_fsm`

Budget:

```text
population_size = 8
num_generations = 5
seed = 1001
```

The screen determines whether PCN RF should proceed to long-budget tests.
Random PCN must remain as the control for "memory without meaningful BD". Do
not run this stage as a performance scale-up unless Stage 1c is accepted as a
diagnostic near-tie. The screen should answer whether the RF-over-random signal
survives beyond the three-problem smoke.

### Stage 3: Long-Budget Diagnostic

Problems:

- `Prob019_sub_64bit`
- `Prob036_edge_detect`
- `Prob045_alu`
- `Prob041_traffic_light`

Budgets:

```text
20x10
10x20
```

Arms:

- matched classic
- best active PCN arm after the frozen screen

The question is whether additional depth lets memory recall mature into useful
front material.

## Metrics

Headline comparisons use reference-complete designs only.

- valid-PPA coverage;
- final HV;
- HV-AUC;
- Pareto point count;
- unique PPA point count;
- reference-beating candidate count;
- memory lane valid-PPA rate;
- memory lane global-front and local-front adds per call;
- sampleable cell count and mean cell credit.

## Promotion Gate

PCN may advance to a broader RTLLM run only if it satisfies all hard gates and
at least one mechanism gate.

Hard gates:

- no missing classic-covered design in the reference-complete subset;
- no hidden missing-reference PPA in headline metrics;
- same model, seed, budget, and problem set as classic;
- descriptor leakage check passes;
- memory lane is configured at 10 percent and materializes as one forced slot
  at 8x5 only after the evidence gate opens.

Mechanism gates:

- memory lane adds at least one global-front candidate;
- memory lane adds at least one credited local-front candidate;
- PCN RF beats PCN random on mean HV or HV-AUC;
- PCN RF preserves a front-relevant implementation family classic would not
  keep in the primary pool.

## Stop Rule

If Stage 1b fails coverage, does not fire memory, or shows a severe HV
collapse, do not run Stage 2. If Stage 2 is negative and PCN random is
comparable to PCN RF, do not launch a full RTLLM suite. Record the result as
negative evidence for this search-policy variant.

After `smoke_v2`, the stop rule is active for the eager RF-memory
configuration. It should not be scaled until `smoke_v3` shows that active
memory improves on the passive control or fires under a clearer stagnation
trigger without repeating the `Prob045_alu` HV loss.

After `smoke_v3`, the hard stop is lifted only for a diagnostic frozen screen.
Do not run 20x10 or full RTLLM until PCN shows at least one memory-lane
front-add signal or preserves the RF-over-random advantage on more problems
without losing classic-covered designs.
