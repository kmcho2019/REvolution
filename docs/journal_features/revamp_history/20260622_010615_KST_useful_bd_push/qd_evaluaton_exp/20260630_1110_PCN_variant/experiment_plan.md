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
not run this stage until Stage 1b shows nonzero memory-refine calls and no
obvious HV/HV-AUC collapse.

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
- `pcn_v2_rf_eoh_memory`

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

After `smoke_v2`, the stop rule is active for the current RF-memory
configuration. It should not be scaled until a revised PCN-v3 smoke shows that
active memory improves on the passive control or only fires under a clearer
stagnation/front-gap trigger.
