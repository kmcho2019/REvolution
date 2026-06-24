# T74 Shape-Density Front-Slot Hybrid QD Methodology

Status: pre-registered; result pending.

## Research Question

T72 showed that source-aligned MasterRTL/RTL-Timer cells can run live and stay
near classic on mean HV, but the fixed cell map collapsed. T73 widened the
shape-density cells and improved valid-PPA yield, but classic still won mean
HV, HV wins, and Pareto breadth.

T74 asks whether the widened T73 cells become useful when the existing
low-rate two-parent single-thought prompts are restricted to descriptor-near
front candidates. The target is not average fitness. The target is better
PPA-front illumination under the same budget.

## Descriptor Definition

T74 reuses `source_aligned_shape_density_3d`:

| Axis | Source | Meaning |
| --- | --- | --- |
| `source_aligned_masterrtl_branching` | source-aligned MasterRTL/SOG path | operator/control/dataflow branching density |
| `source_aligned_rtltimer_wire_density` | source-aligned RTLTimer path | signal/wire density per source line |
| `source_aligned_rtltimer_dff_density` | source-aligned RTLTimer path | register-state density per source line |

The descriptor probe in `tables/` records:

- `requires_ppa=false`;
- `requires_synthesis=false`;
- `requires_graph_metrics=false`;
- `requires_simulation=false`;
- `requires_source_aligned_rtl=true`.

Do not use final PPA, reference PPA, fitness, hypervolume, Pareto rank, classic
results, problem identity, or test pass rate as in-loop BD inputs.

## Method Delta From T73

Everything stays fixed unless listed here.

| Setting | T73 | T74 |
| --- | --- | --- |
| descriptor profile | `source_aligned_shape_density_3d` | same |
| archive type | `grid_quantile` | same |
| cell mode | `elite_pareto_slot` | same |
| parent selection | `front_slot_lane_nsga2` | same |
| champion lane | `0.80` | same |
| operator one-parent fraction | `0.90` | same |
| requested two-parent prompt rate | about `0.10` | about `0.10`, gated |
| `qd_two_parent_probability` | `0.0` | `0.0` |
| two-parent gate | `none` | `near_front_descriptor` |

This makes T74 a coupling test, not another descriptor search. The hypothesis
is that T73 produced enough distinct RTL-native cells, but too little useful
front material. Gated two-parent prompts should let nearby valid front
candidates mix without globally pairing unrelated RTL families.

Implementation note: in the current `single_thought_operator` path,
`qd_operator_one_parent_fraction`, not `qd_two_parent_probability`, controls
whether a prompt asks for one or two parents. `qd_two_parent_gate` still affects
the sampled pair through `_sample_two_success_parents()`. T74 therefore keeps
`qd_two_parent_probability=0.0` and changes the gate only.

This is an intentionally narrow intervention. With population `12`,
generations `3`, and about `10%` requested two-parent prompt exposure, the
screen may contain only a small number of realized two-parent descendants. A
null or tiny positive result should therefore be treated as underpowered unless
the audit shows enough realized gated pairs to support the mechanism claim.

## Fixed Experiment Surface

Use the same hard/tuning surface as T72 and T73:

- seed: `1001`;
- population size: `12`;
- generations: `3`;
- benchmarks/problems: `../T72_source_aligned_rtl_cell_qd/tables/hard_tuning_subset.yaml`;
- model: `openai/gpt-oss-120b` through local vLLM;
- token budgets: `128000` max tokens and diff tokens;
- representation: `code_individual`;
- operator: `single_thought_operator`;
- repair: none.

Do not change subset, budget, prompt, operator, or model after seeing T74
outcomes. Versioned exceptions must be recorded before running.

## Required Measurements

The T74 package must report:

- reference-complete `ppa_completeness.csv`;
- mean HV and HV-AUC versus T47 classic, T51, T66, T67, T72, and T73;
- HV wins, Pareto points, unique PPA points, reference-beating candidates, and
  valid-PPA samples;
- active archive members, occupied cells, and grid-quantile health;
- front-slot parent requests and hits;
- requested and realized one-parent/two-parent prompt counts;
- evidence that realized two-parent prompts were `near_front_descriptor`
  compatible using `tools/audit_t74_two_parent_pairs.py`, or a clear statement
  that no compatible pairs were available;
- PPA/front contribution from gated two-parent descendants;
- duplicate and invalid-candidate accounting;
- direct raw PPA-front panels for representative wins and losses;
- full Phase 03.1 `visualizations/qd_ppa_viewer/` bundle if archive artifacts
  exist.

## Promotion Gates

T74 can be promoted only if:

- every classic-covered design has at least one valid T74 PPA candidate;
- headline comparisons exclude missing-reference problems;
- duplicate or invalid candidates are not counted as useful diversity;
- mean HV is near-classic or better, or a clear primary front metric improves
  without a hidden validity collapse;
- any functionality/synthesis decline is labeled and interpreted with the
  small-denominator caveat from the central policy;
- the report includes inspected figures and does not overclaim the tier.

If T74 improves only valid-PPA yield while classic keeps HV and Pareto breadth,
mark it `T0 positive_diagnostic_not_promoted` and retire exact T73/T74
coupling before another same-family live spend.
