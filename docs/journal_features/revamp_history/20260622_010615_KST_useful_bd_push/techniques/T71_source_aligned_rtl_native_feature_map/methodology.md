# T71 Methodology

## Question

Can source-aligned MasterRTL/RTL-Timer extractor outputs define a small,
interpretable behavior-descriptor map for generated RTL candidates before we
spend another live RTL-native QD budget?

## Terminology

Behavior descriptor means the non-objective information used by MAP-Elites or
QD search to place candidates into archive cells. It is not the fitness
function.

Source-aligned means the feature values come from the T69/T70 open-Yosys
MasterRTL and RTL-Timer preprocessing path. They are not the older T15/T60
proxy tables, and they are not posthoc PPA labels.

Archive cell means the discrete bin a candidate would occupy in a MAP-Elites
archive. T71 proposes cells only; it does not run a live archive optimizer.

## Inputs

T71 reads:

```text
techniques/T70_generated_rtl_extractor_smoke/tables/t70_extractor_results.csv
```

The source table has 19 generated T67 candidates from 7 RTLLM problems. T70
already verified that every sampled candidate passes both MasterRTL SOG
extraction and RTL-Timer SOG BOG extraction.

## Descriptor Axes

The proposed primary map uses two RTL-native axes:

| Axis | Definition | Meaning |
| --- | --- | --- |
| Operator scale | Equal-count quartile of `log(1 + masterrtl_graph_edges)`. | MasterRTL operator/control/dataflow graph scale. |
| State/timing class | Class from `rtltimer_dff_refs`: `comb` is 0, `low_seq` is 1-7, `mid_seq` is 8-20, and `high_seq` is 21 or more. | RTL-Timer state and timing-risk morphology. |

The archive cell is:

```text
operator_scale_bin + "__" + state_timing_class
```

This gives 16 possible cells: 4 operator-scale quartiles by 4 state/timing
classes.

## Derived Diagnostics

The feature table also records non-PPA diagnostics:

- `graph_branching = masterrtl_graph_edges / masterrtl_graph_keys`
- `wire_pressure = rtltimer_wires / rtltimer_lines`
- `timing_state_density = rtltimer_dff_refs / rtltimer_wires`
- `assign_density = rtltimer_assigns / rtltimer_lines`

These diagnostics help interpret the map, but they are not used to define the
primary T71 archive cell.

## Leakage Rules

Descriptor construction excludes:

- PPA
- fitness
- test pass rate
- Pareto rank
- hypervolume
- reference PPA

Candidate synthesis availability is retained only as a provenance column, not
as a descriptor coordinate.

## Promotion Gate

T71 can only unblock the next live method if the map is noncollapsed and
readable. It cannot make a QD usefulness claim by itself. A future live method
must compare against classic on a reference-complete paired PPA subset and
must include the normal validity, front-material, and visualization gates.
