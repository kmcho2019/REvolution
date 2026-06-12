# Descriptor Profile Pre-Registration (P2)

Status: REGISTERED 2026-06-12, before any bake-off run. The narrative's
predeclared bake-off rule selects among exactly these profiles; no axis
may be added, renamed, or re-justified after bake-off runs begin. The
selection rule is frozen in `docs/journal_features/journal_narrative.md`
(paired best-quality delta, then median occupancy, then mean
|correlation|, plus the >= 0.25 occupancy and collapse gates).

## Why pre-registration happens now

The P1 mechanistic diagnosis (history 2026-06-12 13:05) showed the
initial trio collapses on small designs: 4/11 hard-subset problems
never exited grid-quantile warmup because every axis had one unique
value. Diagnostic evidence may NOMINATE candidates; it may not select
them - selection happens only by the predeclared rule on bake-off runs.

## Additional predeclared measurement

Beyond the narrative's gates, the bake-off records per profile:
warmup-completion rate (problems whose archive initialized in-run
without the patience fallback) and per-axis collapsed counts from
`descriptor_health.json`. Rationale: an axis that cannot form quantile
boundaries on the target problem mix provides no diversity pressure
regardless of its correlation profile.

## The four registered profiles

1. `journal_logic_ff_width_3d` (initial trio): `logic_depth`,
   `ff_depth`, `comb_width_log`. Netlist-graph axes validated against
   literature and yosys `ltp` (doc 10). Known weakness: degenerate on
   small/spec-exact designs.
2. `journal_graph_testability_3d` (graph/testability):
   `rtl_cyclomatic_total_log`, `reconv_sink_ratio`,
   `scoap_signal_smoothness`. Decision-structure, reconvergence, and
   SCOAP-derived controllability/observability smoothness - axes with
   plausible variance even on small control logic.
3. `activity_control_3d` (activity; existing registered profile):
   `toggle_density_est`, `active_signal_ratio_est`, `ctrl_depth_est`.
   Simulation-derived switching activity plus control depth; depends on
   `icarus_vcd` probes (`toggle_density_est` requires simulation).
4. `journal_simple_2d` (deliberately simpler control):
   `wire_count_log_est`, `assign_count`. Cheap RTL-text/estimator axes
   that vary on nearly any edit; exists to test whether descriptor
   sophistication earns anything over crude size/structure splits.
   NOTE: the grid_quantile visualizer currently renders 3-axis spaces
   only; 2-axis rendering must land before this arm ships (TODO P2).

## Operational constraints

- All four run under the frozen QD target machinery (grid_quantile,
  pareto_front cells, warmup 8) on the locked fast subset first, then
  the bake-off slice per the narrative.
- `journal_logic_ff_width_3d` stays the working profile for P1 repair
  screens; the bake-off is a P2 decision and must not retroactively
  re-judge P1 screen verdicts.
- Profile additions to `data/configs/qd_descriptor_profiles.yaml` are
  additive; existing profile definitions are untouched.
