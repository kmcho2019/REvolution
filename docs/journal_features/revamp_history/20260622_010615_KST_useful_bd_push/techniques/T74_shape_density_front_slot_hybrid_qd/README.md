# T74 Shape-Density Front-Slot Hybrid QD

Status: completed `T0 diagnostic_regression_not_promoted`.

T74 is the next source-aligned RTL-native follow-up after T72 and T73.
It keeps T73's less-collapsed `source_aligned_shape_density_3d` descriptor
cells, then gates the existing low-rate single-thought two-parent prompt
requests through `near_front_descriptor` so the extra cells have a direct path
to create more Pareto-front material.

## Question

Can T73's valid-PPA yield and archive-occupancy gains be combined with stronger
front-slot/archive coupling without losing the near-classic HV behavior seen in
T72?

## Method Delta

T74 keeps the T73 descriptor and archive geometry:

- descriptor profile: `source_aligned_shape_density_3d`;
- archive type: `grid_quantile`;
- cell mode: `elite_pareto_slot`;
- parent selection: `front_slot_lane_nsga2`;
- champion lane: `0.80`;
- seed and hard/tuning subset fixed to the T72/T73 surface.

T74 changes only the coupling:

- T73: `qd_two_parent_gate=none`;
- T74: `qd_two_parent_gate=near_front_descriptor`.

Both T73 and T74 keep `qd_operator_one_parent_fraction=0.90`, so the
single-thought operator requests two parents about 10% of the time.
`qd_two_parent_probability` remains `0.0` because it is not the arity control
for the single-thought operator path.

If the gate cannot find a compatible pair, the existing one-parent fallback is
used and must be counted. This is not allowed to become an unmeasured fallback
path.

## Package Map

- `methodology.md`: paper-grade method definition and anti-gaming gates.
- `commands/live_screen_v0.md`: frozen commands for probe, preflight, live run,
  validators, and packaging.
- `tables/descriptor_probe_source_aligned_shape_density_3d.json`: descriptor
  probe proving no PPA/synthesis/simulation dependency.
- `tables/t74_method_contract.json`: compact machine-readable method contract.
- `results_report.md`: live-screen result and tier decision.
- `artifacts_manifest.md`: expected artifact and command inventory.
- `matched_classic_comparison/`: compact matched package with data, tables,
  figures, reports, and Phase 03.1 viewer.

## Current Decision

`T0 diagnostic_regression_not_promoted`.

T74 preserves reference-complete coverage on the 13-problem hard/tuning
screen, but it does not improve the primary front metrics. Classic wins mean
HV (`0.0926007600` versus `0.0851926237`), HV wins (`8` versus `1`), Pareto
points (`2.31` versus `1.62`), valid-PPA samples (`257` versus `237`), and
functionality/synthesis rates. Exact T74 is retired.
