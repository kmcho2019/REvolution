# T100 Methodology

## Question

Can front-guarded QD memory become useful when the remembered implementation
families are indexed by validated RTL-native model-state descriptors instead
of SR-PCA synthesis-response axes?

## Method

T100 combines:

- T97's front-credit FG-QDM scheduler;
- T83's RF leaf-ID structural descriptor axes;
- the T85/T97 three-problem smoke subset;
- seed `1001`, `12x3`, and the same vLLM endpoint as the prior FG-QDM smokes.

The archive remains passive memory. It does not spend budget filling empty
cells. Most calls still come from the classic primary success pool.

## Frozen Settings

```text
qd_scheduler_mode = front_guarded_memory
qd_parent_selection = front_guarded_memory
qd_memory_classic_fraction = 0.85
qd_memory_refine_fraction = 0.10
qd_memory_rescue_fraction = 0.05
qd_memory_probe_fraction = 0.00
qd_memory_min_cell_credit = 0.50
qd_memory_front_gap_epsilon = 0.03
qd_two_parent_probability = 0.00
qd_operator_kind = single_thought_operator
qd_operator_one_parent_fraction = 1.0
```

## Comparator

Use the same classic smoke comparator already used for T85 through T98. Do not
compare this three-problem smoke directly against the eight-design top-10 table
without marking the scope difference.

## Acceptance Read

The primary read is not archive occupancy. The useful mechanism signal is
whether memory-lane calls produce valid-PPA and front material per call.
Report at minimum:

- mean HV;
- Pareto point count;
- reference-beating candidates;
- memory-lane generated count;
- memory-lane valid-PPA count;
- memory-lane global-front and local-front additions.
