# T84 RF Leaf-ID Front-Slot Delayed Preregistration

## Candidate

`masterrtl_rf_leafid_front_slot_delayed_8x5`

## Question

T83 showed that validated MasterRTL RF timing model-state breadth can run live
and get within `2.63%` of classic mean HV on one seed, but it lost Pareto
breadth and was RTLLM-negative. T84 asks whether a bounded front-slot parent
lane can turn that model-state diversity into front material.

## Descriptor Axes

```text
source_aligned_rf_timing_leaf_ids
source_aligned_masterrtl_branching
source_aligned_rtltimer_wire_density
```

The descriptor probe says these axes require source-aligned RTL and RF timing
model-state extraction. They do not require final PPA, reference PPA, fitness,
hypervolume, Pareto rank, test pass rate, synthesis result metrics, Qwen
embeddings, or auto-BD artifacts.

## Search Surface

T84 keeps the T83 delayed archive surface except parent selection:

| Setting | Value |
| --- | --- |
| Archive type | `grid_quantile` |
| Warmup successes | `4` |
| Cell mode | `elite_pareto_slot` |
| Max elites per cell | `2` |
| Fill target fraction | `0.10` |
| Improve backfill fraction | `0.05` |
| Archive activation generation | `3` |
| Parent selection after activation | `front_slot_lane_nsga2` |
| Front-slot lane fraction | `0.20` |
| Champion lane after activation | `0.80` |
| Two-parent probability | `0.0` |
| Operator | `single_thought_operator`, one-parent only |
| Repair | disabled |

The expected post-activation parent mix is intentionally exploit-heavy:
`20%` local front-slot requests, then `80%` champion sampling inside the
remaining global NSGA-II pool path.

## Promotion Gate

T84 can advance only if it:

- preserves every classic-covered design in the frozen eight-design screen;
- avoids a large valid-PPA collapse;
- improves T83's mean Pareto points or mean reference-beating candidates;
- keeps mean HV within a small tolerance of classic or improves T83 mean HV;
- improves the no-`Prob135_m2014_q6b` robustness read relative to T83;
- does not hide descriptor collapse or duplicate/invalid candidates as useful
  diversity.

If it loses T83's HV signal without recovering front material, retire this
exact RF leaf-ID front-slot delayed coupling.
