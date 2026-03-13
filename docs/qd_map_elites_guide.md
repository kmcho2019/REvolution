# QD/MAP-Elites Guide

## Overview

This branch adds `search_mode=revolution_qd` to the existing REvolution
backend. The QD path keeps the same prompt, evaluation, and logging substrate
as classic REvolution, but replaces the success-side flat pool with an
archive-backed success state.

Current QD state:

- `fail_pool`: failed or otherwise non-archiveable candidates
- `success_archive`: the source of truth for successful elites
- `success_view`: archive elites plus a bounded per-cell reservoir used for
  parent sampling

Supported archive geometries:

- `grid`: uniform-binned MAP-Elites archive
- `cvt`: frozen-scaler CVT archive with warm-up buffering

The main runtime lives in [engine.py](/workspace/.worktrees/revolution-qd-map-elites/src/revolution/qd/engine.py).

## File Map

Core QD files:

- [archive.py](/workspace/.worktrees/revolution-qd-map-elites/src/revolution/qd/archive.py):
  grid/CVT archive insertion, replacement, and assignment introspection
- [artifacts.py](/workspace/.worktrees/revolution-qd-map-elites/src/revolution/qd/artifacts.py):
  archive summaries, archive-space reports, and per-candidate archive-event logs
- [descriptors.py](/workspace/.worktrees/revolution-qd-map-elites/src/revolution/qd/descriptors.py):
  descriptor registry, profile loading, default-axis resolution, and grid-axis specs
- [engine.py](/workspace/.worktrees/revolution-qd-map-elites/src/revolution/qd/engine.py):
  QD runtime loop, prompt routing, archive insertion, and artifact emission
- [scheduler.py](/workspace/.worktrees/revolution-qd-map-elites/src/revolution/qd/scheduler.py):
  linear fill/improve budget split
- [scoring.py](/workspace/.worktrees/revolution-qd-map-elites/src/revolution/qd/scoring.py):
  `quality_score`, gain components, repair score, and code hashing
- [visualization.py](/workspace/.worktrees/revolution-qd-map-elites/src/revolution/qd/visualization.py):
  history plots plus grid/CVT archive visualizations

Related evaluation files:

- [algorithm.py](/workspace/.worktrees/revolution-qd-map-elites/src/revolution/algorithm.py):
  shared REvolution engine, candidate materialization, prompt creation helpers,
  and the current candidate evaluation path used by `QDEngine`
- [evaluation.py](/workspace/.worktrees/revolution-qd-map-elites/src/revolution/evaluation.py):
  Icarus, Yosys, and OpenROAD execution plus structural/physical metric parsing
- [structural_evaluator.py](/workspace/.worktrees/revolution-qd-map-elites/src/revolution/runtime/structural_evaluator.py):
  structural metric extraction helpers
- [rtl_descriptor_evaluator.py](/workspace/.worktrees/revolution-qd-map-elites/src/revolution/rtl_descriptor_evaluator.py):
  lightweight RTL-text, AST, and netlist-estimate descriptor extraction used by
  the new retrospective runtime profiles
- [simulation_descriptor_evaluator.py](/workspace/.worktrees/revolution-qd-map-elites/src/revolution/simulation_descriptor_evaluator.py):
  VCD/activity parsing used by the dynamic simulation-derived descriptor family
- [problem_spec.py](/workspace/.worktrees/revolution-qd-map-elites/src/revolution/runtime/problem_spec.py):
  benchmark capability defaults and per-phase generation-mode defaults

Prompt files:

- [M-T whole](/workspace/.worktrees/revolution-qd-map-elites/data/prompts/default/evolve/M-T/whole.txt)
- [M-T diff](/workspace/.worktrees/revolution-qd-map-elites/data/prompts/default/evolve/M-T/diff.txt)
- [C-D whole](/workspace/.worktrees/revolution-qd-map-elites/data/prompts/default/evolve/C-D/whole.txt)
- [C-D diff](/workspace/.worktrees/revolution-qd-map-elites/data/prompts/default/evolve/C-D/diff.txt)

## Descriptor Extraction

Structural descriptors come from the synthesis side of the pipeline:

- `seq_ratio`
- `comb_ratio`
- `mux_ratio`
- `adder_ratio`
- `ltp_noff`
- `cell_count_log`

These are extracted through the Yosys-oriented path and attached to candidates
as `structural_metrics`.

Retrospective RTL/AST/netlist-estimate descriptors now also exist at runtime
through `rtl_metrics`:

- `wire_count_log_est`
- `wire_cell_ratio_est`
- `assign_count`
- `if_count`
- `always_count`
- `case_count`
- `ternary_count`
- `rtl_instance_count_est`
- `fsm_state_count_est`
- `ast_depth_est`
- `ctrl_depth_est`
- `math_op_ast_count`
- `resource_sharing_ratio_est`

Extraction path:

- source-text counts and lightweight RTL-shape counts come from
  [rtl_descriptor_evaluator.py](/workspace/.worktrees/revolution-qd-map-elites/src/revolution/rtl_descriptor_evaluator.py)
- `wire_count_log_est` and `wire_cell_ratio_est` prefer the synthesized netlist
  when available and fall back to source-level wire-like declarations
- `ast_depth_est`, `ctrl_depth_est`, `math_op_ast_count`, and
  `resource_sharing_ratio_est` come from a lightweight Yosys AST dump when the
  candidate RTL file is available

Physical descriptors come from the OpenROAD reporting path:

- `wirelength`
- `utilization`
- `cts_buffer_count`
- `repair_buffer_count`
- `hold_buffer_count`

These are attached as `physical_metrics`.

Dynamic simulation descriptors now come from the Icarus/VCD path and are
attached as `dynamic_metrics`:

- `toggle_count_log_est`
- `toggle_density_est`
- `active_signal_ratio_est`
- `avg_toggle_rate_est`

Extraction path:

- [evaluation.py](/workspace/.worktrees/revolution-qd-map-elites/src/revolution/evaluation.py)
  injects a temporary `$dumpfile/$dumpvars` probe only when the selected
  archive axes require dynamic metrics
- [simulation_descriptor_evaluator.py](/workspace/.worktrees/revolution-qd-map-elites/src/revolution/simulation_descriptor_evaluator.py)
  parses the emitted waveform and estimates signal-change behavior from
  DUT-scoped activity
- the current path is intentionally descriptor-gated so classic REvolution and
  non-dynamic QD runs do not pay waveform cost

PPA gain axes are derived from reference-vs-generated PPA metrics:

- `g_P = (P_ref - P_gen) / P_ref`
- `g_A = (A_ref - A_gen) / A_ref`
- `g_T = (T_ref - T_gen) / T_ref`

Important current-runtime detail:

- the checked-in `QDEngine` computes archive descriptor tuples on demand in
  [engine.py](/workspace/.worktrees/revolution-qd-map-elites/src/revolution/qd/engine.py)
  via `_descriptor_tuple(...)`
- the QD loop currently uses the shared evaluation path in
  [algorithm.py](/workspace/.worktrees/revolution-qd-map-elites/src/revolution/algorithm.py),
  not the separate typed `CandidateEvaluator` loop as its primary runtime

## Retrospective Profile Ladder

The finished retrospective analysis under `/tmp/qd_rich20x5` showed that the
branch should distinguish between:

- current-runtime-compatible profiles that can be used immediately
- retrospective-only profiles that still need new runtime descriptor extraction

Adopted immediate profiles on this branch:

- `implemented_structural_compact_3d`
  - `comb_ratio`, `adder_ratio`, `cell_count_log`
  - use as the immediate compact structural grid profile
- `implemented_structural_fixed_5d`
  - `seq_ratio`, `comb_ratio`, `mux_ratio`, `adder_ratio`, `cell_count_log`
  - use as the immediate current-runtime-compatible structural CVT/control
    profile

Runtime-supported retrospective profiles:

- `size_control_3d`
  - `wire_count_log_est`, `assign_count`, `ctrl_depth_est`
- `timing_control_3d`
  - `wire_count_log_est`, `if_count`, `ast_depth_est`
- `wire_assign_if_3d`
  - `wire_count_log_est`, `assign_count`, `if_count`
- `size_sharing_3d`
  - `wire_count_log_est`, `wire_cell_ratio_est`,
    `resource_sharing_ratio_est`

Exploratory dynamic profiles:

- `activity_size_3d`
  - `toggle_count_log_est`, `active_signal_ratio_est`, `wire_count_log_est`
- `activity_control_3d`
  - `toggle_density_est`, `active_signal_ratio_est`, `ctrl_depth_est`

Stage 10 runtime note:

- grid mode now honors `qd_descriptor_profile` when `qd_grid_axes` is omitted,
  so `implemented_structural_compact_3d` is no longer just a config file entry;
  it is active in real grid runs and visible in `archive_space_report.md`
- current refresh evidence under `/tmp/qd_rich20x5_refresh_v2` indicates the
  structural retrospective profiles are useful controls, but not new defaults
  yet

Stage 11 runtime note:

- the branch now supports the primary retrospective source/AST/netlist
  descriptor family during real QD runs, not just retrospective replay
- these profiles should still be treated as early-stage experimental surfaces
  until bounded smokes and longer reruns confirm their live behavior

## Archive Geometry

### Grid

Grid cells are defined by uniform bins over each descriptor axis. The archive
stores one elite per cell.

Current default axis behavior:

- combinational grid default: `g_A`, `g_P`
- sequential grid default: `g_A`, `g_P`, `g_T`

Grid assignment is implemented in
[archive.py](/workspace/.worktrees/revolution-qd-map-elites/src/revolution/qd/archive.py)
through `cell_id_for(...)` and `describe_assignment(...)`.

### CVT

CVT buffering and assignment work like this:

1. Successful candidates are buffered until `warmup_successes` is reached.
2. A frozen scaler is fit from the warm-up descriptors.
3. Centroids are generated in normalized descriptor space.
4. Warm-up candidates are reinserted into the now-initialized archive.
5. Later candidates are assigned to the nearest centroid in frozen scaled space.

The current implementation is in
[archive.py](/workspace/.worktrees/revolution-qd-map-elites/src/revolution/qd/archive.py).

## Output Artifacts

Run-level / problem-level QD artifacts:

- `archive_history.jsonl`
- `archive_cells.csv`
- `archive_summary.json`
- `qd_metrics.json`
- `grid_layout.json` or `centroids.json`
- `archive_space.json`
- `archive_space_report.md`
- `coverage_vs_generation.png`
- `best_quality_vs_generation.png`
- `qd_score_vs_generation.png`
- grid heatmaps for 2-axis grid runs
- per-axis occupancy/quality marginals for multi-axis grid runs
- pairwise occupancy/quality projection heatmaps for multi-axis grid runs
- CVT projection plots for initialized CVT runs

Per-successful-candidate artifact:

- `qd_archive_event.json`

This file records:

- descriptor tuple and descriptor values
- quality score and gain components
- insertion decision
- cell id and assignment details
- archive occupancy / QD score before and after insertion
- previous elite and current cell elite summaries
- structural, RTL, dynamic, and physical metric payloads when available

## What Happens In One Generation

Assume Gen0 has already run and the archive has been rebuilt from the initial
successful pool.

1. `QDEngine.evolve_one_generation()` increments `current_generation`.
2. The engine computes a QD budget with `split_qd_budget(...)` from
   [scheduler.py](/workspace/.worktrees/revolution-qd-map-elites/src/revolution/qd/scheduler.py).
3. That budget decides how many offspring come from:
   - seed
   - fail repair/explore
   - success-side backfill
   - success-side refine
4. If `seed_budget > 0`, the engine asks the LLM for fresh designs directly
   from the problem description.
5. If `fail_budget > 0`, the engine samples fail-pool parents and chooses from
   `M-F` and `M-E`.
6. For success-side fill/backfill, it chooses from `M-T`, `M-E`, and `C-D`
   when enough successful parents exist.
7. For refine, it chooses from `M-S`, `M-R`, `M-I`, and `C-F`.
8. Parent sampling uses `success_view`, which is archive elites plus the
   bounded per-cell reservoir, not elites alone.
9. `M-T` computes a desired descriptor shift from the parent’s current archive
   coordinates.
10. `C-D` chooses two success parents with large descriptor distance.
11. All requests are batched to the LLM and materialized into `Heuristic`
    candidates using the shared offspring-materialization path.
12. Offspring are evaluated by the shared REvolution candidate pipeline:
    syntax, simulation, synthesis, post-synthesis functionality, and PPA.
13. For successful candidates, QD descriptor tuples are constructed from:
    - structural metrics
    - RTL/AST/netlist-estimate metrics
    - dynamic simulation metrics
    - physical metrics
    - computed `g_P`, `g_A`, `g_T`
14. Each success is inserted into the archive:
    - `filled_empty`
    - `replaced_elite`
    - `not_inserted`
    - `warmup_buffered` for pre-init CVT
15. Replaced elites and non-inserted same-cell successes can enter the
    per-cell reservoir.
16. Failed offspring are reranked into the fail pool.
17. The generation snapshot is written:
    coverage, occupied cells, QD score, best/mean quality, budgets, and plots.

## What Happens Through The Entire Process

1. `QDEngine.run()` starts, loads reference PPA, and initializes the logger.
2. `initialize_population()` runs Gen0 through the shared REvolution path.
3. The archive is rebuilt from Gen0 successes.
4. Every archive-handled successful candidate gets `qd_archive_event.json`.
5. Initial archive summaries, archive-space reports, and visualizations are
   written.
6. The engine runs `num_generations` generations of QD evolution.
7. Each generation updates:
   - archive state
   - fail pool
   - success reservoir
   - generation history
   - per-problem QD artifacts
8. At the end of the run, the engine finalizes the run summary using archive
   elites instead of a flat success pool.

## Reading Results

When debugging a QD run, inspect artifacts in this order:

1. `archive_summary.json`
2. `qd_metrics.json`
3. `archive_space_report.md`
4. `archive_cells.csv`
5. `archive_history.jsonl`
6. one or more `qd_archive_event.json` files from successful candidates
7. `problem_run.log`, `code_simulation.log`, and synthesis reports for any
   suspicious candidate

For richer multi-axis grid runs:

- current history plots still exist
- use the per-axis marginal plots and pairwise projection heatmaps first
- use `archive_space_report.md`, `archive_space.json`, `archive_cells.csv`, and
  per-candidate `qd_archive_event.json` to understand full cell organization
