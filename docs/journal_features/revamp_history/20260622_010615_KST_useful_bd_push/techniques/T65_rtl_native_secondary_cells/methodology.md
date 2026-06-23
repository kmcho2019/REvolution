# T65 RTL-Native Secondary Cells Methodology

## Purpose

T65 tests the follow-up suggested by T63/T64: keep the stronger T51-style
generator/archive machinery intact, but score the resulting unique PPA
candidates with RTL-native secondary cells. This asks whether RTLTimer-style
source features should be used as reporting or secondary archive cells instead
of as the primary live MAP-Elites geometry.

## Inputs

The audit uses already packaged hard/tuning artifacts:

- T51 `code_thought_front_slot_qd`
- T63 `fused_rtl_state_pipeline_qd`
- T64 `fused_rtl_operator_timing_qd`
- the shared Classic comparator included in those packages

The Phase 03.1 viewer datasets provide code paths. The corresponding
`*_ppa_candidates.csv` files provide the direct unique-PPA candidate surface
and the direct `is_pareto_front` label. This prevents the audit from using
viewer-local pooled-rank flags that mark Classic and QD differently.

## Descriptor Definition

The descriptor inputs are extracted from source RTL text with
`RTLDescriptorEvaluator.extract_text_metrics`. They do not use final PPA,
reference PPA, hypervolume, Pareto rank, fitness, tests, or synthesis pass
rate.

T65 assigns problem-local 4x4 secondary cells for three profiles:

| Profile | Axis 0 | Axis 1 | Intent |
| --- | --- | --- | --- |
| `timing_risk` | `control_pipeline_ratio` | `timing_risk_score` | RTLTimer-style critical-path risk shape |
| `operator_timing` | `operator_pressure_score` | `timing_risk_score` | arithmetic/operator pressure plus timing risk |
| `control_pipeline` | `control_count` | `pipeline_event_count` | control structure versus pipeline/register events |

`operator_pressure_score` is a PPA-free source-text score:

```text
arith_count + compare_count + logic_op_count
+ 2 * mul_count + max_rhs_operator_count
```

## Metrics

For each method and secondary profile, T65 reports:

- unique PPA candidate count;
- direct Pareto-front candidate count;
- occupied secondary cells;
- direct-front secondary cells;
- mean deltas versus Classic by problem.

This is a diagnostic secondary-cell audit. It is not a live generation run and
cannot by itself prove a useful QD method.
