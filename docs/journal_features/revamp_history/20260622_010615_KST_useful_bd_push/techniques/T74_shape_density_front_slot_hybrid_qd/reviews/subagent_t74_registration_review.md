# Subagent T74 Registration Review

Date: 2026-06-24T00:40Z

## Prompt

Read-only task in `/workspace`. Inspect the current T72 and T73 packages,
`best_current_techniques.md`, technique registry, and relevant QD config/code
paths. Answer what exact T74 source-aligned hybrid should be registered next,
what existing knobs/descriptors can implement it without new code, and what
anti-gaming gates/visualization artifacts must be required before any live
spend or promotion. Do not edit files.

## Key Feedback

- Register a no-code T74 hybrid that keeps T73's
  `source_aligned_shape_density_3d` `grid_quantile` archive.
- Add `near_front_descriptor` gating to the low-rate single-thought two-parent
  prompt exposure.
- Keep `qd_max_elites_per_cell=2`; do not widen local front slots yet.
- Do not claim a true dual/secondary active archive without code changes.
- Treat secondary lanes as passive/reporting evidence unless implemented.
- Record that `qd_operator_one_parent_fraction`, not
  `qd_two_parent_probability`, controls one-parent versus two-parent prompt
  exposure for `single_thought_operator`.
- Require reference-complete `ppa_completeness.csv`, no
  missing/defaulted-reference headline metrics, no classic-covered design
  loss, parent/arity audit, direct raw PPA Pareto figures, and the full Phase
  03.1 viewer with screenshot and validation notes.

## Resolution

The T74 registration was corrected after this review:

- `qd_two_parent_probability` stays `0.0`.
- `qd_operator_one_parent_fraction=0.90` stays fixed from T73.
- T74 changes the gate from `none` to `near_front_descriptor`.
- The package requires realized two-parent prompt and descriptor-distance
  audit instead of relying on the older `two_parent_gate_attempts` counters,
  which are not the single-thought arity path.
