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

Smoke passes only if the PCN RF arm preserves all classic-covered designs and
does not show an obvious HV/HV-AUC collapse.

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
Random PCN must remain as the control for "memory without meaningful BD".

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
- `pcn_rf_leafid_quality_memory`

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
- memory lane is at most 10 percent at 8x5.

Mechanism gates:

- memory lane adds at least one global-front candidate;
- memory lane adds at least one credited local-front candidate;
- PCN RF beats PCN random on mean HV or HV-AUC;
- PCN RF preserves a front-relevant implementation family classic would not
  keep in the primary pool.

## Stop Rule

If Stage 1 fails coverage or shows a severe HV collapse, do not run Stage 2.
If Stage 2 is negative and PCN random is comparable to PCN RF, do not launch a
full RTLLM suite. Record the result as negative evidence for this search-policy
variant.
