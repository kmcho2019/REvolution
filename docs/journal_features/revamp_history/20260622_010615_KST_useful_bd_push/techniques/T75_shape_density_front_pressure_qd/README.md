# T75 Shape-Density Front-Pressure QD

Status: pre-registered; not run yet.

T75 is the direct post-T74 RTL-native follow-up. It keeps T73/T74's
source-aligned MasterRTL/RTL-Timer shape-density descriptor, but changes the
front creation pressure directly by raising the `front_slot_lane_nsga2`
front-slot sampling fraction from the historical hard-coded `0.10` to `0.30`.

## Question

Can T73's valid-PPA yield and source-aligned archive occupancy be kept while
stronger local-front parent pressure creates more raw PPA-front material?

## Method Delta

T75 keeps:

- descriptor profile: `source_aligned_shape_density_3d`;
- archive type: `grid_quantile`;
- cell mode: `elite_pareto_slot`;
- maximum elites per cell: `2`;
- parent selection: `front_slot_lane_nsga2`;
- champion lane: `0.80`;
- seed, prompt, model, token budgets, subset, and evaluation flow from T73/T74.

T75 changes:

- `qd_front_slot_lane_fraction=0.30`;
- `qd_operator_one_parent_fraction=1.0`;
- `qd_two_parent_gate=none`.

The first change directly increases local-front parent sampling. The second
removes the low-rate two-parent prompt exposure that T74 audited as too sparse
to explain a useful improvement. The method therefore isolates front-slot
pressure rather than mixing it with another fusion variant.

## Package Map

- `methodology.md`: paper-grade method definition and anti-gaming gates.
- `commands/live_screen_v0.md`: frozen probe, preflight, run, validation, and
  packaging commands.
- `tables/descriptor_probe_source_aligned_shape_density_3d.json`: descriptor
  probe proving no PPA/synthesis/simulation dependency.
- `tables/t75_method_contract.json`: compact method contract.
- `results_report.md`: pending result placeholder.
- `artifacts_manifest.md`: expected artifacts and comparison paths.

## Current Decision

`pending_registered`.

Do not promote from registration. T75 must preserve the 13-problem
reference-complete hard/tuning coverage and improve at least one primary
front metric versus T73 or classic before it can leave diagnostic status.
