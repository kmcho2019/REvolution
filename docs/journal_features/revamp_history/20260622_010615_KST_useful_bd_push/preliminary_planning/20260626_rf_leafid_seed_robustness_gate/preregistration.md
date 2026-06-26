# Preregistration

## Question

Does the near-classic single-seed T83 result survive seed robustness?

## Frozen Arm

`masterrtl_rf_leafid_structural_delayed_8x5`

Descriptor axes:

```text
source_aligned_rf_timing_leaf_ids
source_aligned_masterrtl_branching
source_aligned_rtltimer_wire_density
```

Search policy:

```text
grid_quantile archive
warmup successes = 4
fill target fraction = 0.10
improve backfill fraction = 0.05
archive activation generation = 3
cell mode = elite_pareto_slot
max elites per cell = 2
parent selection = nsga2_global_rank
champion lane fraction = 0.90
two-parent probability = 0.0
single-thought one-parent operator
repair disabled
```

## Seeds

Use QD seeds `1002` and `1003`, plus the existing T83 seed `1001`.
Compare against matched classic seeds:

- `1001`: existing encoder-config screen baseline.
- `1002` and `1003`: existing auxiliary-archive seed-replication baseline.

Do not rerun classic unless those artifacts fail packaging validation.

## Metrics

Primary:

- mean HV over the reference-complete paired eight-design subset;
- per-seed mean HV delta versus matched classic;
- mean Pareto points;
- mean reference-beating candidates;
- valid-PPA comparison completeness.

Robustness:

- repeat aggregate with `Prob135_m2014_q6b` removed;
- RTLLM-only aggregate;
- seed-level win/loss count;
- descriptor collapse summary.

## Promotion Rule

T83 remains unpromoted unless all conditions hold:

1. the three-seed mean HV is within the registered near-classic tolerance;
2. no seed has missing classic-covered designs;
3. the no-`Prob135_m2014_q6b` aggregate is not materially worse than classic;
4. Pareto/front metrics do not collapse relative to the single-seed read.

If the gate fails, keep T83 as a category representative and move to a
materially different encoder or archive-coupling lane.
