# REvolution QD/MAP-Elites Implementation Plan

## Summary

Implement `revolution_qd` as a new REvolution search mode while keeping classic
`revolution` behavior unchanged. QD mode replaces the success-side flat pool
with an archive-backed success state and supports both `grid` and `cvt` archive
geometries through the same runner, logging, and reporting surfaces.

This document is the canonical living plan for the feature branch
`feat/revolution-qd-map-elites` in worktree
`/workspace/.worktrees/revolution-qd-map-elites`. It must be updated before and
after every implementation stage so that completed work, tests, smoke runs,
debt review notes, and commit evidence stay synchronized with the codebase.

## Research Intent Lock

- Keep REvolution's original repair-driven search loop intact for
  side-by-side comparison.
- Add `--search_mode {revolution,revolution_qd}` instead of forking the whole
  framework.
- In `revolution_qd`, the success-side source of truth is the archive only:
  `fail_pool`, `success_archive`, `success_view`.
- Support both `grid` and `cvt` archives as first-class modes. Implement and
  validate `grid` first, then `cvt`, but end with parity across CLI, config,
  logs, artifacts, and tests.
- Define `quality_score` in `quality_mode=ppa` exactly as the REvolution PPA
  fitness equation and maximize it.
- Preserve one-metric specialists by keeping `g_P`, `g_A`, and `g_T` available
  as separate descriptor axes.
- Keep descriptor selection experiment-friendly and configurable from CLI,
  config, and descriptor files.
- Keep generation mode flexible per phase and per benchmark so larger problems
  can prefer diff-heavy workflows when whole-mode context becomes impractical.

## Status

- Branch: `feat/revolution-qd-map-elites`
- Base branch: `wip/journal-extension-2026`
- Base commit: `447c012822`
- Current stage:
  `Stage 18 merge-readiness docs/tests/cleanup complete;`
  `the fixed retrospective redo under`
  ``/tmp/qd_rich20x5_redo_full_fixed/20260314_115920`` `is now the`
  `comparative reference for practical backend guidance;`
  `the earlier redo root remains invalidated for numeric comparison;`
  `local merge review against wip/journal-extension-2026 is clean on the`
  `touched surface`
- Current backend scope:
  - `RTLLM`
  - `VerilogEval-Spec-to-RTL`
  - `cvdp` 1.0.2 limited to `cid002` and `cid003`
  - `RealBench` module subsets
- Current backend status: grid and initial CVT runtime paths are live with
  archive-backed success-state handling, benchmark-default phase-mode wiring, a
  bounded per-cell `success_view` reservoir, configurable grid-axis bin
  loading, frozen-scaler CVT warm-up, and initial archive-state artifact
  emission; QD operator routing, QD-aware report/archive packaging, and
  archive-history visualization are now live, and Stage 6 benchmark capability
  scaffolding for `cvdp` plus fixture-backed `RealBench` modules is now landed;
  sequential grid defaults now include `g_P`, per-candidate
  `qd_archive_event.json` artifacts are emitted for archive-handled successful
  candidates, `archive_space.json` plus `archive_space_report.md` are emitted
  per QD problem, and a dedicated QD runtime guide now documents descriptor
  extraction plus generation/run traces; runtime structural metrics are now
  emitted from synthesized netlists, and the retrospective RTL/AST/netlist
  descriptor family (`wire_count_log_est`, `assign_count`, `if_count`,
  `ctrl_depth_est`, `ast_depth_est`, `resource_sharing_ratio_est`, and related
  counts) is now wired into live QD runs through `rtl_metrics`; Icarus/VCD
  activity descriptors (`toggle_count_log_est`, `toggle_density_est`,
  `active_signal_ratio_est`, `avg_toggle_rate_est`) are now wired into live QD
  runs through `dynamic_metrics`; second-wave retrospective builtin profiles
  (`wire_ctrl_assign_3d`, `wire_if_math_3d`, `wire_always_ternary_3d`,
  `assign_always_math_3d`) are now executable through the repo config surface,
  and per-problem `descriptor_health.json` plus
  `descriptor_health_report.md` now make axis collapse/missingness visible in
  the run tree itself; `backend_comparison_report.py` now aggregates those
  descriptor-health sidecars into a dedicated QD report section and
  `archive_baseline.py` preserves them in archived runs; a repo-native
  long-budget retrospective redo harness now exists for `/tmp/qd_rich20x5`-
  style reruns using the shared vLLM endpoint; engine seam cleanup and broader
  type-debt reduction still remain pending

## Worktree Info

- Main workspace: `/workspace`
- Feature worktree: `/workspace/.worktrees/revolution-qd-map-elites`
- Created with:
  `git worktree add -b feat/revolution-qd-map-elites /workspace/.worktrees/revolution-qd-map-elites wip/journal-extension-2026`
- Note: the feature worktree starts from the committed state of
  `wip/journal-extension-2026`; unrelated untracked files in `/workspace` do not
  carry into the new worktree automatically.

## Decisions Locked

- Public mode switch:
  `--search_mode {revolution,revolution_qd}`
- Archive backends:
  `--qd_archive_type {grid,cvt}`
- Quality mode:
  `quality_mode = {ppa,functional_only}`
- Grid is implemented first because it is easier to debug and less prone to
  geometry bugs, but CVT is not a second-class feature at merge time.
- Grid axis bins and bounds can be loaded from `qd_descriptor_file` under
  `grid_axes:`; unspecified axes still fall back to derived defaults.
- Default `quality_score` weights:
  - sequential circuits: `alpha=beta=gamma=1/3`
  - combinational circuits: `alpha=beta=1/2`, `gamma=0`
- QD budgeting uses the simple linear fill rule:
  `fail_share = 1 - min(1.0, occupied_cells / max(N_target, 1))`
- Phase generation modes are overridable via CLI/config:
  `qd_fail_generation_mode`, `qd_seed_generation_mode`,
  `qd_backfill_generation_mode`, `qd_refine_generation_mode`,
  `qd_crossover_generation_mode`
- Descriptor selection is configurable through preset profiles, explicit axis
  lists, and descriptor files.
- There is a separate remote GitHub branch named `realbench` intended to carry
  fuller RealBench benchmark integration plus analysis capability. It is not
  merged into `wip/journal-extension-2026` yet, so this branch keeps only the
  manifest-based Stage 6 adapter/fixture path for now.

## Descriptor Inventory, Runtime Status, Default Fixes, And Rich-Rerun Plan

This section is the descriptor-specific source of truth for the branch. It
separates what is actually implemented today from what was merely proposed,
what the completed experiments really used, and what still needs follow-up.

### Descriptor Status Taxonomy

- `Implemented and runtime-usable`
  means the descriptor exists in the runtime registry and can flow into
  `descriptor_values` during QD evaluation.
- `Implemented but lightly validated`
  means the runtime can extract and use the descriptor, but the branch's main
  experiment evidence has not stressed it as heavily as the core gain/structural
  axes.
- `Planned but not implemented`
  means the descriptor is part of the design intent or roadmap, but it is not
  in the current runtime registry.
- `Exploratory future candidate`
  means the descriptor is a research idea worth testing later, but it should
  not yet be described as part of the implemented branch surface.

Descriptor references elsewhere in this document should use these labels rather
than implying that proposal text and runtime implementation are the same thing.

### Implemented Descriptor Registry

#### Implemented and runtime-usable: structural descriptors

The current runtime registry in `src/revolution/qd/descriptors.py` includes:

- `seq_ratio`
- `comb_ratio`
- `mux_ratio`
- `adder_ratio`
- `ltp_noff`
- `cell_count_log`

Current extraction path:

- `seq_ratio`, `comb_ratio`, `mux_ratio`, and `adder_ratio`
  are derived from structural cell-count composition in
  `src/revolution/runtime/structural_evaluator.py`
- `ltp_noff`
  is a longest-topological-path descriptor intended to track long
  combinational chains
- `cell_count_log`
  is represented as a `log1p`-transformed descriptor in the registry even
  though the structural evaluator emits raw total-cell count into the metric
  payload first

#### Implemented but lightly validated: physical descriptors

The current runtime registry also includes these OpenROAD-facing descriptors:

- `wirelength`
- `utilization`
- `cts_buffer_count`
- `repair_buffer_count`
- `hold_buffer_count`

Current extraction path:

- these are parsed from the synthesis/OpenROAD reporting path in
  `src/revolution/evaluation.py`
- they are written into the machine-readable physical-metrics sidecar and are
  available to the runtime through `physical_metrics`
- they are therefore runtime-usable today, but the branch's most closely
  reviewed comparison runs still rely more on structural descriptors and PPA
  gain axes than on these physical descriptors

#### Implemented and runtime-usable: PPA gain descriptors

The runtime registry includes:

- `g_P`
- `g_A`
- `g_T`

Definitions:

- `g_P = (P_ref - P_gen) / P_ref`
- `g_A = (A_ref - A_gen) / A_ref`
- `g_T = (T_ref - T_gen) / T_ref`

These are the most heavily exercised QD descriptors in the branch's completed
comparison runs so far.

#### Implemented and runtime-usable: dynamic simulation descriptors

The runtime registry now also includes Icarus/VCD-derived activity descriptors:

- `toggle_count_log_est`
- `toggle_density_est`
- `active_signal_ratio_est`
- `avg_toggle_rate_est`

Current extraction path:

- `src/revolution/evaluation.py` can now inject a lightweight VCD probe into
  the active testbench when the selected archive axes require dynamic metrics
- `src/revolution/simulation_descriptor_evaluator.py` parses the emitted VCD
  and derives activity estimates from tracked DUT-scoped signal changes
- the resulting metrics are attached to candidates as `dynamic_metrics`

Current validation status:

- runtime-usable today on Icarus-backed benchmarks
- still lightly validated relative to the already more heavily exercised gain
  axes and structural axes
- currently treated as experimental descriptors rather than defaults

### Implemented Descriptor Profiles

The current descriptor-profile config in
`data/configs/qd_descriptor_profiles.yaml` defines:

- `rtl_core`
  - `seq_ratio`
  - `mux_ratio`
  - `ltp_noff`
  - `cell_count_log`
- `rtl_phys`
  - `seq_ratio`
  - `ltp_noff`
  - `wirelength`
  - `utilization`
- `rtl_phys_cts`
  - `seq_ratio`
  - `ltp_noff`
  - `wirelength`
  - `cts_buffer_count`
  - `repair_buffer_count`
- `hybrid_seq_default`
  - `seq_ratio`
  - `mux_ratio`
  - `ltp_noff`
  - `cell_count_log`
  - `g_P`
  - `g_A`
  - `g_T`
- `hybrid_comb_default`
  - `mux_ratio`
  - `ltp_noff`
  - `cell_count_log`
  - `g_P`
  - `g_A`
- `hybrid_phys_seq`
  - `seq_ratio`
  - `ltp_noff`
  - `wirelength`
  - `utilization`
  - `cts_buffer_count`
  - `g_P`
  - `g_A`
  - `g_T`

Current runtime default resolution from `src/revolution/qd/descriptors.py`:

- current `grid` default:
  - combinational: `g_A`, `g_P`
  - sequential: `g_A`, `g_P`, `g_T`
- current `cvt` default:
  - combinational:
    `mux_ratio`, `ltp_noff`, `cell_count_log`, `g_P`, `g_A`
  - sequential:
    `seq_ratio`, `mux_ratio`, `ltp_noff`, `cell_count_log`, `g_P`, `g_A`,
    `g_T`

Current public descriptor-control surface:

- `qd_descriptor_profile`
- `qd_descriptor_axes`
- `qd_descriptor_file`
- `qd_grid_axes`
- `qd_cvt_axes`

### Actual Descriptor Usage In The Completed `20 x 5` Run

The completed `20 x 5` long-budget comparison did **not** use the richer
descriptor inventory above in any meaningful way. It used reduced gain-axis
descriptors to isolate archive mechanics:

- RTLLM `grid`:
  `g_A`, `g_T`
- RTLLM `cvt`:
  `g_A`, `g_T`
- VerilogEval `grid`:
  `g_A`, `g_P`
- VerilogEval `cvt`:
  `g_A`, `g_P`

Interpretation:

- this was a useful archive-mechanics and geometry-comparison run
- it was **not** a full descriptor-rich QD study
- it validated low-dimensional archive behavior much more than it validated
  the branch's fuller descriptor program

### Known Descriptor Gaps And Current Limitations

- Structural descriptors and PPA gain descriptors currently have the strongest
  empirical support in this branch.
- Physical descriptors are implemented and available, but the most visible run
  evidence still under-exercises them.
- The completed `20 x 5` run under-used the implemented descriptor inventory.
- Current paper-style claims should therefore frame the existing results as
  archive-mechanics and low-dimensional QD evidence, not as proof that the full
  structural-plus-physical descriptor program is already validated.
- Icarus-derived dynamic descriptors are now implemented, but their current
  extraction path is still benchmark- and testbench-dependent because it relies
  on VCD dumping through the active Icarus simulation harness.

### Completed Default Fix: Sequential Grid Includes `g_P`

Implementation landed:

- `src/revolution/qd/descriptors.py` now resolves sequential `grid` defaults
  to `g_A`, `g_P`, `g_T`
- `src/revolution/qd/engine.py` now uses the same corrected default at runtime
  when `qd_grid_axes` is not explicitly provided
- regression coverage was added for sequential default resolution and the
  engine-level default wiring

Interpretation:

- this closes the remaining mismatch where default sequential grid runs could
  silently ignore the power-improvement axis
- it does **not** invalidate the completed richer-descriptor rerun below,
  because that rerun already used explicit grid axes including `g_P`

### Future Descriptor Roadmap

#### Planned but not implemented

- latency / cycle-to-valid descriptors
- throughput or initiation-interval descriptors where benchmark semantics
  allow them
- richer OpenROAD congestion or routing-stress descriptors
- additional structural or control-shape proxies if extraction remains cheap
  and stable

#### Exploratory future candidates

- fanout or criticality proxies
- FSM/control-entropy proxies
- formal-complexity or proof-difficulty proxies
- localized congestion-hotspot descriptors

Promotion rule for future descriptors:

- do not promote a future descriptor into defaults unless extraction stability,
  descriptor-probe coverage, and empirical QD benefit are all documented in the
  living plan

### Rich-Descriptor `20 x 5` Rerun Plan

Goal:

- rerun the same `20 x 5` comparison on the same four designs while using much
  richer QD descriptor spaces than the reduced gain-only setup used previously
- status: completed; the finished rerun results are recorded later in this
  document

Design set:

- RTLLM:
  - `Prob043_RAM`
  - `Prob045_alu`
- VerilogEval-Spec-to-RTL:
  - `Prob153_gshare`
  - `Prob156_review2015_fancytimer`

Common settings:

- model:
  `/project/cad-team/LX_Semicon/models/openai-gpt-oss-120b`
- `population_size=20`
- `num_generations=5`
- `temperature=1.0`
- `top_p=1.0`
- `max_tokens=128000`
- `diff_max_tokens=128000`
- `num_workers=2`
- `candidate_workers=0`
- `evaluation_mode=search_accelerated`
- `accelerated_synthesis_top_k=1`
- `seed=42`

Classic control:

- keep classic REvolution unchanged as the non-QD baseline

Richer grid rerun:

- first fix the sequential grid default so it includes `g_P`
- then run the richer grid rerun using explicit descriptor axes instead of
  relying on minimal defaults
- planned richer grid axes:
  - sequential-style problems:
    `seq_ratio`, `ltp_noff`, `g_A`, `g_P`, `g_T`
  - combinational-style problems:
    `mux_ratio`, `ltp_noff`, `g_A`, `g_P`
- for the richer grid rerun, use explicit `grid_axes:` configuration in
  `qd_descriptor_file` rather than fallback bounds/bin inference

Richer CVT rerun:

- use fuller descriptor profiles as the primary descriptor-rich experiment
- planned CVT profiles:
  - sequential-style problems:
    `hybrid_seq_default`
  - combinational-style problems:
    `hybrid_comb_default`
- sequential follow-up if primary CVT rerun is stable:
  - rerun sequential tasks with `hybrid_phys_seq` to test whether physical
    descriptors improve archive diversity or best-quality outcomes

Archive settings for the richer rerun:

- keep `qd_num_cells=16`
- keep `qd_cvt_warmup_successes=4`
- for grid, explicitly configure per-axis bin/bounds specs through
  `qd_descriptor_file`

Required post-rerun review checklist:

- compare best score across classic, grid, and CVT
- compare coverage, QD score, best quality, and mean quality
- inspect descriptor extraction failures
- inspect grid heatmaps and CVT projection plots
- explicitly assess whether adding `g_P` changes sequential grid retention of
  power-specialist elites
- compare the richer rerun against the earlier reduced-axis run without
  pretending they are the same experiment
- assess whether CVT benefits more than grid from the richer descriptor space

## Retrospective Descriptor Analysis From `/tmp/qd_rich20x5`

This section records the retrospective feature-analysis work performed after the
initial rich-descriptor reruns. Unlike the earlier descriptor section above,
this section is grounded in the finished experiment corpus under
`/tmp/qd_rich20x5` and explicitly separates:

- actual branch runtime support
- retrospective simulation-only axes
- immediate config/profile changes adopted on this branch
- deferred runtime-feature work that still needs code changes

### Data Sources Reviewed

- `/tmp/qd_rich20x5/QD_FEATURE_STATE_AND_RECOMMENDATIONS.md`
- `/tmp/qd_rich20x5/analysis/reports/qd_feature_experiment_report.md`
- `/tmp/qd_rich20x5/analysis/reports/feature_variation_live.md`
- `/tmp/qd_rich20x5/analysis/data/recommendation_matrix.csv`
- `/tmp/qd_rich20x5/analysis/data/stable_feature_set_scores.csv`
- `/tmp/qd_rich20x5/analysis/data/current_qd_axis_inventory.csv`
- `/tmp/qd_rich20x5/analysis/data/experimental_descriptor_profiles.yaml`

### Actual Run Findings

The retrospective executive summary confirms that the earlier rich-grid choice
was a poor main exploratory profile for this corpus, while CVT remained viable:

- current rich grid equivalent (`rich_seq_grid`) mean coverage:
  `0.0859375`
- current runtime CVT baseline (`hybrid_seq_default`) mean coverage:
  `0.421875`
- current sequential objective-only grid default (`g_A`, `g_P`, `g_T`) mean
  coverage:
  `0.5859375`

Important interpretation from the retrospective analysis:

- the earlier rich-grid runs collapsed structurally
- `seq_ratio` and `ltp_noff` did not carry meaningful occupied-cell separation
  on this corpus
- occupancy was still driven mostly by gain axes (`g_A`, `g_P`, `g_T`)
- the objective-only sequential grid default is therefore acceptable as an
  ablation/control, but it is not sufficient evidence of structural-space
  illumination

### Retrospective Feature-Set Findings

Current-runtime-compatible implemented sets:

- `implemented_structural_fixed_5d`
  - axes:
    `seq_ratio`, `comb_ratio`, `mux_ratio`, `adder_ratio`, `cell_count_log`
  - retrospective mean coverage:
    `0.5234375`
  - role:
    immediate current-runtime-compatible structural control profile
- `comb_ratio + adder_ratio + cell_count_log`
  - retrospective mean coverage:
    `0.671875`
  - role:
    strongest already-supported compact structural profile

Retrospective primary target sets at the time of the original analysis:

- `size_control_3d`
  - axes:
    `wire_count_log_est`, `assign_count`, `ctrl_depth_est`
  - retrospective mean coverage:
    `0.7473958333333333`
  - original recommendation:
    first future runtime descriptor target
  - Stage 11 status:
    now runtime-supported on this branch
- `timing_control_3d`
  - axes:
    `wire_count_log_est`, `if_count`, `ast_depth_est`
  - retrospective mean coverage:
    `0.65625`
  - original recommendation:
    timing/control-oriented second future runtime target
  - Stage 11 status:
    now runtime-supported on this branch

Second-wave exploratory combinations from the same analysis:

- `wire_count_log_est + assign_count + if_count`
- `wire_count_log_est + ctrl_depth_est + assign_count`
- `wire_count_log_est + if_count + math_op_ast_count`

### Current Runtime Support vs Retrospective-Only Axes

Runtime-supported today on this branch:

- structural:
  `seq_ratio`, `comb_ratio`, `mux_ratio`, `adder_ratio`, `ltp_noff`,
  `cell_count_log`
- physical:
  `wirelength`, `utilization`, `cts_buffer_count`, `repair_buffer_count`,
  `hold_buffer_count`
- gains:
  `g_P`, `g_A`, `g_T`

New runtime-supported RTL/AST/netlist-estimate axes:

- `wire_count_log_est`
- `wire_cell_ratio_est`
- `assign_count`
- `if_count`
- `always_count`
- `case_count`
- `ternary_count`
- `rtl_instance_count_est`
- `fsm_state_count_est`
- `ctrl_depth_est`
- `ast_depth_est`
- `math_op_ast_count`
- `resource_sharing_ratio_est`

Still retrospective-only / future-only for now:

- latency / cycle-to-valid descriptors
- throughput / initiation-interval descriptors
- richer congestion or routing-pressure descriptors
- second-wave hypothetical combinations that need new axes beyond the current
  RTL/AST/netlist estimator family

Interpretation:

- the retrospective analysis is useful for feature prioritization
- the primary recommended retrospective sets are now available in the runtime
  branch
- the remaining future-only axes above should still not be described as
  implemented

### Adopted Immediate Changes

This branch now adopts two current-runtime-compatible profiles from the
retrospective analysis:

- `implemented_structural_fixed_5d`
  - use as the immediate structural control/baseline profile
- `implemented_structural_compact_3d`
  - defined as:
    `comb_ratio`, `adder_ratio`, `cell_count_log`
  - use as the immediate low-dimensional exploratory replacement for the
    earlier poor `rich_seq_grid`-style choice on this corpus

This branch now also adopts live runtime support for the primary retrospective
descriptor family:

- `size_control_3d`
  - `wire_count_log_est`, `assign_count`, `ctrl_depth_est`
- `timing_control_3d`
  - `wire_count_log_est`, `if_count`, `ast_depth_est`
- additional currently implemented supporting axes:
  `always_count`, `case_count`, `ternary_count`, `rtl_instance_count_est`,
  `fsm_state_count_est`, `wire_cell_ratio_est`, `math_op_ast_count`,
  `resource_sharing_ratio_est`

This branch now also adopts live runtime support for the first dynamic
simulation descriptor family:

- `toggle_count_log_est`
- `toggle_density_est`
- `active_signal_ratio_est`
- `avg_toggle_rate_est`

This branch also adopts the retrospective grid-axis bounds for the structural
axes used by those profiles:

- `seq_ratio`
- `comb_ratio`
- `mux_ratio`
- `adder_ratio`
- `cell_count_log`
- `wire_count_log_est`
- `assign_count`
- `ctrl_depth_est`
- `if_count`
- `ast_depth_est`
- `wire_cell_ratio_est`
- `resource_sharing_ratio_est`

### Deferred Runtime-Feature Work

Still deferred until further runtime descriptor support is added:

- latency / cycle-to-valid descriptors
- throughput / initiation-interval descriptors
- richer OpenROAD congestion or routing-stress descriptors
- second-wave hypothetical combinations that depend on not-yet-implemented
  future axes

Reason for deferral:

- this execution phase adds the primary RTL/AST/netlist estimator family, but
  richer physical-flow congestion signals and benchmark-specific latency /
  throughput descriptors still remain

### Refresh Experiment Plan

Refresh run root:

- `/tmp/qd_rich20x5_refresh`

Reuse the same 4-problem corpus:

- RTLLM:
  - `Prob043_RAM`
  - `Prob045_alu`
- VerilogEval-Spec-to-RTL:
  - `Prob153_gshare`
  - `Prob156_review2015_fancytimer`

Refresh matrix:

- `grid`
  - `qd_descriptor_profile=implemented_structural_compact_3d`
- `cvt`
  - `qd_descriptor_profile=implemented_structural_fixed_5d`
  - `qd_num_cells=16`
  - `qd_cvt_warmup_successes=4`

Keep the same long-budget settings as the earlier rich reruns:

- `population_size=20`
- `num_generations=5`
- `temperature=1.0`
- `top_p=1.0`
- `max_tokens=128000`
- `diff_max_tokens=128000`
- `num_workers=2`
- `candidate_workers=0`
- `evaluation_mode=search_accelerated`
- `accelerated_synthesis_top_k=1`
- `seed=42`

Classic baseline handling:

- do not rerun classic unless the refresh changes reveal a regression
- compare against the existing classic historical baseline under
  `/tmp/qd_rich20x5`

### Comparison Rules

The refresh comparison must explicitly answer:

- does `implemented_structural_compact_3d` improve grid coverage relative to
  the earlier `rich_seq_grid`-style run
- does `implemented_structural_fixed_5d` improve or degrade CVT coverage and
  archive quality relative to `hybrid_seq_default`
- do the refreshed runs still exhibit axis collapse
- does the new compact structural grid remain interpretable on both RTLLM and
  VerilogEval

Interpretation rules:

- if grid improves materially while CVT holds or improves, treat that as
  evidence that the old rich-grid profile was the wrong near-term choice on
  this corpus
- if CVT degrades materially with `implemented_structural_fixed_5d`, keep it
  as a documented control profile rather than changing defaults
- if neither improves, record that the retrospective simulation did not
  transfer cleanly to the live runtime
- treat `size_control_3d` and `timing_control_3d` as runtime-supported but
  still early-stage profiles until live smokes and longer reruns confirm they
  behave well outside retrospective replay

### Refresh Execution Findings From `/tmp/qd_rich20x5_refresh_v2`

This section is kept as a historical Stage 10 checkpoint only. It is
superseded by the later fixed redo under
`/tmp/qd_rich20x5_redo_full_fixed/20260314_115920`, which is now the branch's
main comparative reference for backend recommendations.

The first Stage 10 refresh attempt under `/tmp/qd_rich20x5_refresh` exposed a
real runtime/config bug:

- `implemented_structural_compact_3d` had been added to the descriptor config,
  but `QDEngine` grid initialization still fell back to hardcoded gain axes
  when `qd_grid_axes` was omitted
- effect:
  early "refresh" grid runs were mislabeled as structural-profile runs while
  actually using `g_A`, `g_P`, `g_T`

That bug is now fixed in `src/revolution/qd/engine.py`, and a corrected smoke
run under `/tmp/qd_rich20x5_refresh_v2/smokes/grid_rtllm_compact_profile`
confirms:

- `descriptor_profile = implemented_structural_compact_3d`
- `descriptor_axes = comb_ratio, adder_ratio, cell_count_log`
- grid geometry uses the retrospective-derived explicit bounds from
  `data/configs/qd_descriptor_profiles.yaml`

Corrected refresh matrix:

- root:
  `/tmp/qd_rich20x5_refresh_v2`
- grid profile:
  `implemented_structural_compact_3d`
- CVT profile:
  `implemented_structural_fixed_5d`
- status:
  historical interim checkpoint only; useful for diagnosing the Stage 10
  profile-selection bug, but no longer the latest experimental evidence
- executive comparison note:
  `/tmp/qd_rich20x5_refresh_v2/QD_PROFILE_REFRESH_SUMMARY.md`

Interim comparison against baseline `/tmp/qd_rich20x5`:

- `RTLLM/Prob043_RAM`
  - baseline grid:
    `coverage=0.0625`, `qd_score=0.5538087600419216`
  - refresh grid:
    `coverage=0.125`, `qd_score=0.23661908152587477`
  - baseline CVT:
    `coverage=0.4375`, `qd_score=2.2098059043421205`
  - refresh CVT:
    `coverage=0.0625`, `qd_score=0.23661908152587477`
- `RTLLM/Prob045_alu`
  - baseline grid:
    `coverage=0.03125`, `qd_score=0.15088639200998752`
  - refresh grid:
    `coverage=0.125`, `qd_score=0.08804914908995333`
  - baseline CVT:
    `coverage=0.5`, `qd_score=0.8971647283001513`
  - refresh CVT:
    `coverage=0.0`, `qd_score=0`
- `VerilogEval-Spec-to-RTL/Prob153_gshare`
  - baseline grid:
    `coverage=0.21875`, `qd_score=0.22159468620046935`
  - refresh grid:
    `coverage=0.125`, `qd_score=0.05641133616170021`
  - baseline CVT:
    `coverage=0.5`, `qd_score=0.03473310176867479`
  - refresh CVT:
    `coverage=0.0625`, `qd_score=0.02575814311200209`
- `VerilogEval-Spec-to-RTL/Prob156_review2015_fancytimer`
  - baseline grid:
    `coverage=0.03125`, `qd_score=-0.21196762495855093`
  - refresh grid:
    `coverage=0.0`, `qd_score=0`
  - baseline CVT:
    `coverage=0.25`, `qd_score=-1.1153786401307686`
  - refresh CVT:
    `coverage=0.0`, `qd_score=0`

Current interpretation:

- the retrospective structural-profile recommendations are now truly live in
  runtime, but they are **not** outperforming the older richer/gain-heavy
  baseline on this four-problem corpus so far
- the corrected compact grid profile is at least interpretable and now uses
  real structural axes, but it is currently trading off archive quality for a
  small coverage gain on some RTLLM tasks
- the fixed structural CVT profile is currently weaker than the earlier
  `hybrid_seq_default`/gain-heavy baseline on the same corpus
- provisional conclusion:
  the retrospective simulation ranking did not transfer cleanly to the live
  long-context runtime at this budget; keep these new profiles as explicit
  experimental controls rather than changing defaults

## Original Plan Comparison Review

This section compares the current implementation state to the original QD/MAP-
Elites plan that seeded the branch. The goal is to make any divergence
explicit, evaluate whether it was appropriate, and keep the roadmap honest.

### High-level alignment

- `search_mode=revolution_qd` was added as planned and classic
  `search_mode=revolution` remains intact.
- `ProblemSpec`, `StructuralEvaluator`, the descriptor registry/config path,
  and the exact maximize-form REvolution PPA `quality_score` were all landed in
  line with the original design.
- `grid` was implemented before `cvt`, matching the original risk-reduction
  rollout.
- Descriptor selection is configurable through CLI, config, and descriptor
  profile files as intended.
- The simple linear fill-based scheduler was implemented exactly as planned.

### Explicit divergences and review

- Divergence: `QDEngine` currently lives in `src/revolution/qd/engine.py`
  instead of first refactoring `src/revolution/algorithm.py` into a richer set
  of shared helper seams.
  Review:
  This was an intentional short-term divergence. It reduced the risk of
  breaking classic REvolution while letting the grid runtime path land sooner.
  The tradeoff is some duplicated offspring-materialization and generation-loop
  logic. This is acceptable for the grid-first checkpoint, but it should be
  reduced before or during CVT integration so the branch does not accumulate
  engine-loop drift.

- Resolved divergence: `success_view` originally landed as an archive-elite
  view only, without the planned bounded per-cell recent-occupant reservoir.
  Review:
  This gap is now closed for the grid runtime path. The archive remains the
  success-side source of truth, while `success_view` now adds a bounded recent-
  occupant reservoir for parent sampling without creating a second flat success
  store.

- Resolved divergence: grid binning originally used only fallback bounds and
  derived bin counts instead of allowing explicit per-axis bin specs from
  config.
  Review:
  The grid runtime now accepts per-axis `grid_axes:` entries from
  `qd_descriptor_file` so structural and physical grid experiments do not have
  to rely on the old uniform fallback. This is still a lightweight config
  scheme, but it closes the main usability gap without introducing a second
  parallel config mechanism.

- Divergence: physical descriptor plumbing now exists through machine-readable
  OpenROAD sidecars and runtime `physical_metrics`, but the main published run
  evidence still under-exercises those axes relative to structural and gain
  descriptors.
  Review:
  This is now a validation-depth gap rather than a missing-runtime-plumbing
  gap. The branch should not describe physical descriptors as absent, but it
  also should not over-claim that the full structural-plus-physical descriptor
  program is already empirically validated.

- Divergence: live RTLLM grid smokes were attempted but are currently blocked by
  long-running first-generation behavior on the shared vLLM endpoint rather
  than producing quick pass/fail evidence.
  Review:
  This is not a design divergence, but it does affect validation confidence.
  The blocked smoke does not disprove the runtime path, but it means the branch
  still lacks the intended end-to-end live validation evidence for Stage 3.

- Resolved divergence: the branch originally exposed per-phase generation-mode
  overrides in CLI/backend config before the QD runtime `auto` path actually
  consumed `ProblemSpec.phase_generation_defaults`.
  Review:
  This gap has now been closed for the current grid runtime path. Resolution
  order is now `explicit override -> ProblemSpec defaults -> local fallback`,
  which is materially closer to the original plan and makes benchmark-specific
  diff-policy experiments meaningful.

- Divergence: top-level and immediate docs were updated earlier than the
  original stage ordering would have required.
  Review:
  This divergence is appropriate and beneficial. The user explicitly requested
  that new features be reflected immediately in the nearest docs and the
  top-level repo map. The documentation now better matches actual branch state.

### Internal review conclusion

- The implementation is still aligned with the original research intent at the
  architectural level.
- The main acceptable divergence is tactical: the branch prioritized a working
  grid runtime path with limited duplication before doing the deeper engine
  seam refactor.
- The largest remaining risk is not conceptual drift but technical debt around
  duplicated generation-loop logic and incomplete runtime parity for CVT,
  reporting, and richer archive-parent semantics.

### Evidence basis for the review

- Strong evidence:
  parser/config, scoring, descriptor, archive, scheduler, and grid runtime
  selection paths are covered by focused unit tests and backend tests.
- Moderate evidence:
  top-level docs and immediate feature docs now reflect the current staged QD
  surface, including initial CVT runtime support and the remaining reporting/
  smoke gaps.
- Weak evidence:
  live end-to-end vLLM smoke validation is still incomplete because the shared
  endpoint did not yield a fast first-generation success/failure result in the
  attempted Stage 3 grid smokes.

## Documentation Surface Review

The original plan required that new feature work be reflected both near the
implementation and in the top-level repo map. The current branch is aligned
with that requirement.

- `README.md` now exposes `revolution_qd`, grid-vs-CVT staging status, and a
  concrete example command for the grid runtime path.
- `GUIDELINES.md` now acts as a repo map that points readers to the right docs
  and source areas for high-level orientation before they dive into details.
- `docs/user_guide.md`, `docs/module_structure.md`,
  `docs/implementation_details.md`, and `docs/REvolution_specification.md` all
  mention the QD feature surface and now describe the current grid-plus-initial-
  CVT state instead of the older grid-only checkpoint.

Documentation risk to watch:

- These docs are directionally correct for the current branch, but they should
  be refreshed again when reporting/artifact parity, visualization outputs, and
  richer QD operator routing are added.

## Validation Workflow

- This worktree currently has no checked-in `.github/workflows/` CI definition,
  so branch validation is tracked through the local proxy checklist below.
- Required local checklist for QD feature work:
  - `pytest`
  - `ruff check` on touched files or the intentionally scoped tree
  - `python -m pyright` on touched source modules
  - vLLM `/v1/models` preflight
  - at least one bounded runtime smoke for changed LLM-backed behavior
- When repo-wide lint or typecheck debt outside the feature scope prevents a
  clean global pass, record the scoped pass result and the broader blocking debt
  explicitly instead of leaving the validation state ambiguous.

## Stage Tracker

### Stage 0: Worktree And Living Plan Bootstrap

- [x] Create feature worktree from `wip/journal-extension-2026`.
- [x] Query live vLLM `/v1/models` endpoint and record model metadata.
- [x] Create this canonical living plan document.
- [x] Review Stage 0 status and commit bootstrap docs-only change.

### Stage 1: Search Mode, ProblemSpec, Archive Interface, And Per-Phase Modes

- [x] Add `search_mode=revolution_qd` plumbing to runners and backend config.
- [x] Add QD config surface for archive type, quality mode, descriptor config,
      and phase generation-mode overrides.
- [x] Add `ProblemSpec` capability layer.
- [x] Add shared archive protocol / state types without altering classic mode.
- [x] Add regression and config-surface tests.
- [x] Update docs and plan with Stage 1 validation notes.
- [x] Commit Stage 1 with signed multi-line commit message.

### Stage 2: Exact Quality Score, Descriptor Registry, And Extraction Substrate

- [x] Add exact REvolution PPA `quality_score`.
- [x] Add `g_P`, `g_A`, `g_T` extraction and logging fields.
- [x] Add functional-only fallback ranking.
- [x] Add descriptor registry and descriptor profile config file.
- [x] Add configurable descriptor axes / descriptor file loading.
- [x] Add structural descriptor extraction (`seq_ratio`, `mux_ratio`,
      `ltp_noff`, etc.).
- [x] Add duplicate code hashing before expensive evaluation.
- [x] Add tests and a descriptor probe utility.
- [x] Update docs and plan with Stage 2 validation notes.
- [x] Commit Stage 2.

### Stage 3: Grid Backend First Implementation

- [x] Add `QDEngine` scaffolding.
- [x] Implement `GridArchive`.
- [x] Implement linear fill/improve scheduler.
- [x] Implement archive-backed success insertion/replacement.
- [x] Wire the first grid runtime path through `revolution_backend.py`.
- [x] Add grid-specific tests.
- [x] Refresh top-level and immediate QD docs for the grid-runtime checkpoint.
- [x] Wire `ProblemSpec.phase_generation_defaults` into QD runtime `auto`
      policy resolution.
- [x] Add bounded per-cell reservoir support so `success_view` matches the
      planned elite-plus-recent-occupant semantics.
- [x] Add configurable grid-bin specification loading for structural/physical
      grid experiments.
- [x] Refactor the shared offspring-materialization seam duplicated between
      `EoHEngine` and `QDEngine`.
- [x] Run RTLLM and VerilogEval grid smokes to a real completion state.
- [x] Add a deterministic fast-smoke path so Stage 3 runtime validation does
      not depend only on slow long-context vLLM runs.
- [x] Update docs and plan with Stage 3 validation notes.
- [x] Commit Stage 3 checkpoints.

### Stage 4: CVT Backend With Parity Surface

- [x] Implement CVT warm-up, scaler fit, frozen centroids, and reinsertion.
- [x] Keep grid/CVT on equal footing in summary, artifacts, and tests.
- [x] Add CVT-specific tests and parity tests.
- [x] Run RTLLM and VerilogEval CVT smokes.
- [x] Update docs and plan with Stage 4 validation notes.
- [x] Commit Stage 4.

### Stage 5: QD Operators And Flexible Diff Usage

- [x] Add `M-T` and `C-D` prompts and operator routing.
- [x] Route whole/diff by explicit per-phase policy resolution.
- [x] Add operator routing tests.
- [x] Run targeted whole-heavy and diff-heavy smoke tests.
- [x] Update docs and plan with Stage 5 validation notes.
- [x] Commit Stage 5.

### Stage 6: CVDP And RealBench Module Capability Expansion

- [x] Add `cvdp` `cid002` / `cid003` capability path.
- [x] Add `RealBench` module-subset adapter and fixtures.
- [x] Gate `quality_mode=ppa` vs `functional_only` per problem.
- [x] Add tests and smokes or explicitly record blocked live smoke.
- [x] Update docs and plan with Stage 6 validation notes.
- [x] Commit Stage 6.

### Stage 7: Archive Logging, Reporting, Visualization, And Descriptor Study

- [x] Emit `archive_history.jsonl`, `archive_cells.csv`,
      `archive_summary.json`, `qd_metrics.json`, and
      `grid_layout.json` or `centroids.json`.
- [x] Add generation metrics and per-cell exports.
- [x] Add visualization outputs.
- [x] Extend archive/report packaging.
- [x] Add reporting tests.
- [x] Add visualization tests.
- [x] Run grid and CVT artifact-validation smokes.
- [x] Update docs and plan with Stage 7 validation notes.
- [x] Commit Stage 7.

### Stage 8: Full Regression, Docs, And Merge-Ready Cleanup

- [x] Run full pytest suite.
- [x] Run `ruff` on touched files and record broader repo lint debt status.
- [x] Run `pyright` on touched modules and record broader repo type-debt status.
- [x] Run `ty` on touched modules and record broader type-debt status.
- [x] Run final vLLM-backed smoke matrix and record blocked/passed status.
- [x] Perform code cleanliness and intent-alignment review.
- [x] Update top-level docs and finalize this plan incrementally as new stages
      land.
- [x] Commit Stage 8 checkpoints.

### Stage 9: QD Observability, Default Cleanup, And Trace Docs

- [x] Record the finished richer `20 x 5` descriptor run and its updated
      interpretation.
- [x] Fix sequential `grid` defaults so `g_P` is included in both descriptor
      resolution and runtime default wiring.
- [x] Emit per-candidate `qd_archive_event.json` for archive-handled successful
      candidates, including warm-up buffered CVT candidates.
- [x] Emit per-problem `archive_space.json` and `archive_space_report.md`.
- [x] Add archive-space introspection helpers shared by grid and CVT.
- [x] Add regression tests for the corrected default plus the new QD artifacts.
- [x] Add a dedicated QD runtime guide with one-generation and whole-run
      traces.
- [x] Update top-level docs and the living plan to point to the new guide and
      artifact set.
- [x] Run bounded live grid/CVT validation after the new artifact layer lands.
- [x] Commit Stage 9.

### Stage 10: Retrospective Feature Integration And Profile Refresh

- [x] Record the retrospective data sources and findings from
      `/tmp/qd_rich20x5`.
- [x] Add `implemented_structural_fixed_5d` to repo descriptor profiles.
- [x] Add `implemented_structural_compact_3d` to repo descriptor profiles.
- [x] Add retrospective-derived `grid_axes` bounds for the implemented
      structural axes.
- [x] Keep `size_control_3d` and `timing_control_3d` documented as deferred
      future runtime work.
- [x] Update top-level and QD docs with the new adopted profile ladder and the
      retrospective-analysis interpretation.
- [x] Run unit tests for descriptor config loading/resolution.
- [ ] Run bounded vLLM smokes for the new profiles.
- [ ] Run the refresh `20 x 5` comparison using the new explicit profiles.
- [x] Generate refreshed benchmark comparison summaries.
- [x] Compare refreshed runs against `/tmp/qd_rich20x5` baseline and record
      whether coverage/QD score improved.
- [ ] Update validation log, debt review, intent alignment review, and commit
      ledger.

### Stage 11: Runtime Retrospective Descriptor Rollout

- [x] Implement runtime structural-metric emission from synthesized netlists.
- [x] Implement lightweight RTL/AST/netlist descriptor extraction for the
      primary retrospective axis family.
- [x] Add runtime-supported profiles for `size_control_3d`,
      `timing_control_3d`, and related follow-on controls.
- [x] Wire the new descriptor family into both the shared
      `CandidateEvaluator` path and the legacy `QDEngine`/`EoHEngine`
      evaluation path.
- [x] Add regression coverage for the new runtime descriptor extraction path.
- [x] Run focused pytest/ruff/ty validation after the rollout.
- [x] Run bounded live vLLM smokes for the new runtime-supported profiles.
- [x] Update validation log, debt review, intent alignment review, and commit
      ledger with Stage 11 findings.

### Stage 12: Multi-Axis Grid Visualization Follow-Through

- [x] Add per-axis marginal plots for multi-axis grid archives.
- [x] Add pairwise occupancy/quality projection heatmaps for multi-axis grid
      archives.
- [x] Keep the existing 2-axis grid heatmap path unchanged.
- [x] Update archive-space reporting to describe the new multi-axis grid
      visualization behavior.
- [x] Add regression coverage for the new visualization outputs.
- [x] Run focused pytest/ruff/pyright/ty validation for the visualization
      change.
- [x] Update QD docs and the living plan with the new artifact inventory.

### Stage 13: Dynamic Activity Descriptor Rollout

- [x] Add Icarus/VCD-derived activity descriptor extraction behind descriptor
      requirements so non-dynamic runs do not pay the waveform cost.
- [x] Add `toggle_count_log_est`, `toggle_density_est`,
      `active_signal_ratio_est`, and `avg_toggle_rate_est` to the runtime
      descriptor registry.
- [x] Thread `dynamic_metrics` through both the shared
      `CandidateEvaluator` path and the legacy `QDEngine`/`EoHEngine`
      evaluation path.
- [x] Extend QD archive-event artifacts so successful candidates preserve
      dynamic metrics alongside structural, RTL, and physical metrics.
- [x] Add exploratory built-in activity profiles and grid-axis bounds.
- [x] Add regression coverage for VCD parsing, Verilog evaluator probe
      injection, descriptor resolution, and QD artifact payloads.
- [x] Run focused pytest/ruff/pyright/ty validation for the rollout.
- [x] Update QD docs and the living plan with the new dynamic descriptor
      family and its current caveats.

### Stage 14: Second-Wave Retrospective Profiles And Descriptor Health

- [x] Promote the strongest already-runtime-supported second-wave retrospective
      combinations into builtin descriptor profiles.
- [x] Add explicit grid-axis bounds for the new second-wave profile axes where
      the retrospective analysis provides grounded corpus ranges.
- [x] Emit per-problem `descriptor_health.json` and
      `descriptor_health_report.md` artifacts so axis collapse and low-signal
  behavior are visible from the run tree itself.
- [x] Thread descriptor-health references into `archive_summary.json` and
      `qd_metrics.json` so downstream tooling can discover the new artifacts.
- [x] Add regression coverage for the new builtin profiles, grid-axis specs,
      and descriptor-health artifact emission.
- [ ] Run bounded live vLLM smoke(s) with one of the new second-wave profiles.
- [ ] Run longer-budget comparative evaluation for the new second-wave
      profiles before considering any default change.

### Stage 15: Descriptor-Health Report Aggregation

- [x] Extend `backend_comparison_report.py` so QD runs render a descriptor-
      health section in addition to archive coverage/quality metrics.
- [x] Preserve `descriptor_health.json` and `descriptor_health_report.md` in
      `archive_baseline.py` archives.
- [x] Add regression coverage for report rendering and archive preservation of
      the new descriptor-health artifacts.
- [x] Update docs and the living plan so the new report path is discoverable.
- [x] Use the new report section on fresh long-budget QD runs once Stage 10
      refresh evidence is finalized.

### Stage 16: Retrospective 20x5 Redo Harness

- [x] Add a repo-native long-budget retrospective rerun harness that encodes
      the same four-design corpus and 128k-token vLLM settings used in
      `/tmp/qd_rich20x5`.
- [x] Add preset-driven mode matrices so refresh controls and follow-on
      profiles can be rerun reproducibly instead of through ad hoc commands.
- [x] Add a dry-run regression test for the new rerun harness.
- [x] Update docs and the living plan so the new redo workflow is discoverable.
- [x] Launch a fresh long-budget redo root using the new harness.
- [x] Record the resulting run root and comparison outputs in the validation
      log once the rerun completes.

### Stage 17: Simulation-Top Regression Fix And Redo Recovery

- [x] Diagnose why `/tmp/qd_rich20x5_redo_full` produced meaningless all-fail
      results despite using the intended long-token settings.
- [x] Split synthesis-top and testbench-top resolution in the runtime model so
      simulation no longer uses DUT top names from
      `synthesis_top_module_names.json`.
- [x] Thread the fix through both `CandidateEvaluator` and the legacy
      `algorithm.py` evaluation path.
- [x] Add regression tests that would have caught the bug on RTLLM and
      VerilogEval-style harnesses.
- [x] Run bounded live sentinels to confirm `iverilog -s tb` is restored and
      functionality results are meaningful again.
- [x] Mark the original redo root as invalid for numeric comparison.
- [x] Launch a replacement full redo matrix under a fresh root.
- [x] Record the fixed redo comparison outputs once the replacement matrix
      completes.

### Stage 18: Merge-Readiness Docs, Tests, And Cleanup

- [x] Review the branch delta against `wip/journal-extension-2026` and confirm
      the feature branch is a straight descendant locally.
- [x] Refresh user-facing docs so they reference the finished fixed redo rather
      than the earlier `refresh_v2` checkpoint.
- [x] Expand `docs/qd_map_elites_guide.md` with mode tables, profile tables,
      descriptor-family tables, and Mermaid lifecycle diagrams.
- [x] Add missing docstrings across the touched QD/runtime surface.
- [x] Remove branch-local unused `type: ignore` comments from
      `src/revolution/backends/revolution_backend.py`.
- [x] Re-run `git diff --check`, full `pytest`, targeted `ruff`, targeted
      `pyright`, and targeted `ty`.
- [x] Record that no new live vLLM runs were executed in this merge-readiness
      cleanup pass.

## Exact TODO List

### Public Surface

- [x] Add `search_mode`
- [x] Add `qd_archive_type`
- [x] Add `qd_num_cells`
- [x] Add `qd_fill_target_fraction`
- [x] Add `qd_cell_reservoir`
- [x] Add `qd_neighbor_k`
- [x] Add `qd_cvt_warmup_successes`
- [x] Add `qd_quality_mode`
- [x] Add `qd_alpha`, `qd_beta`, `qd_gamma`
- [x] Add `qd_descriptor_profile`
- [x] Add `qd_descriptor_axes`
- [x] Add `qd_descriptor_file`
- [x] Add `qd_enable_descriptor_experiments`
- [x] Add `qd_descriptor_probe_budget`
- [x] Add `qd_grid_axes`
- [x] Add `qd_cvt_axes`
- [x] Add per-phase generation-mode overrides

### Core Runtime

- [x] Add `src/revolution/runtime/problem_spec.py`
- [x] Add `src/revolution/runtime/structural_evaluator.py`
- [x] Add `src/revolution/qd/types.py`
- [x] Add `src/revolution/qd/scoring.py`
- [x] Add `src/revolution/qd/descriptors.py`
- [x] Add `src/revolution/qd/archive.py`
- [x] Add `src/revolution/qd/scheduler.py`
- [x] Add `src/revolution/qd/engine.py` follow-through cleanup for shared engine
      seams and reduced duplication
- [x] Add `src/revolution/qd/visualization.py`
- [x] Refactor `src/revolution/algorithm.py` for shared engine seams
- [x] Wire `ProblemSpec.phase_generation_defaults` into runtime `auto` phase
      resolution
- [x] Add bounded per-cell `success_view` reservoir support
- [x] Add configurable grid-bin specification loading

### Descriptor Registry Candidates

- [x] Support structural descriptors:
  `seq_ratio`, `comb_ratio`, `mux_ratio`, `adder_ratio`, `ltp_noff`,
  `cell_count_log`
- [x] Support physical descriptors:
  `wirelength`, `utilization`, `cts_buffer_count`, `repair_buffer_count`,
  `hold_buffer_count`
- [x] Support PPA gain descriptors:
  `g_P`, `g_A`, `g_T`
- [x] Add initial preset profiles:
  `rtl_core`, `rtl_phys`, `rtl_phys_cts`, `hybrid_seq_default`,
  `hybrid_comb_default`, `hybrid_phys_seq`
- [x] Add descriptor probe script for extraction coverage and experiment logging
- [x] Add machine-readable physical-metric sidecars for OpenROAD-backed
      descriptor extraction parity

### Reporting

- [x] Add archive history JSONL
- [x] Add archive cells CSV
- [x] Add archive summary JSON
- [x] Add QD metrics JSON
- [x] Add grid layout / centroid output
- [x] Add grid heatmaps and CVT projection plots

### Future Descriptor Follow-Through

- [x] Fix sequential `grid` default resolution so it includes `g_P` in addition
      to `g_A` and `g_T`
- [x] Add regression coverage for the corrected sequential `grid` default
- [x] Re-run the `20 x 5` comparison with richer descriptor spaces for both
      `grid` and `cvt`
- [x] Compare rich-descriptor rerun results against the existing reduced-axis
      run on coverage, QD score, best quality, and visualization behavior
- [ ] Evaluate whether `hybrid_phys_seq` materially improves sequential CVT
      archive diversity or best-quality outcomes
- [x] Add Icarus-derived dynamic descriptors only after extraction reliability
      and probe coverage are documented
- [x] Add richer multi-axis grid visualization support beyond the current 2D
      heatmap path
- [x] Implement new runtime descriptor extraction for retrospective-only axes
      such as `wire_count_log_est`, `assign_count`, `if_count`,
      `ctrl_depth_est`, and `ast_depth_est`
- [ ] Evaluate whether the new activity profiles improve archive fill or
      archive quality enough to justify any default or near-default use

## Validation Log

### Stage 0

- Date: `2026-03-12`
- Worktree created successfully.
- vLLM preflight command:
  `curl -s http://host.docker.internal:8000/v1/models`
- Result:
  - `id=/project/cad-team/LX_Semicon/models/openai-gpt-oss-120b`
  - `max_model_len=131072`
- Automated tests: not yet run
- Smoke tests: preflight only
- Commit:
  - `32ea6f39e6` `docs(qd): bootstrap living implementation plan and worktree log`

### Stage 1

- Date: `2026-03-12`
- Implemented:
  - runner/back-end `search_mode` scaffolding
  - QD parser/config surface for archive type, descriptor inputs, quality mode,
    and per-phase generation-mode overrides
  - new `ProblemSpec` capability layer
  - shared `QDArchive` protocol and insert-result types
  - `run_evolution.py` delegation to `run_backend.py` for QD-mode configs
  - guard rejecting `search_mode=revolution_qd` with
    `population_pool_mode=single`
- Automated tests:
  - `/workspace/.venv/bin/python -m pytest tests/revolution/test_defaults.py tests/revolution/test_problem_spec.py tests/scripts/test_run_backend.py tests/scripts/test_run_evolution.py`
  - Result: `26 passed in 1.50s`
  - `/workspace/.venv/bin/python -m pytest tests/revolution/test_backends_base.py tests/scripts/test_run_backend_ablation.py`
  - Result: `15 passed in 0.75s`
- Smoke tests:
  - no live backend run yet; Stage 1 is parser/config/capability scaffolding only
- Notes:
  - `run_backend.py` now annotates summary metadata with `search_mode`,
    `problem_spec`, and initial `qd_config` fields.
  - `run_evolution.py` stays as a legacy wrapper and forwards QD requests to
    `run_backend.py` instead of growing a second execution path.

### Stage 2

- Date: `2026-03-12`
- Implemented:
  - exact REvolution PPA `quality_score` helper using the maximize-form
    equation with automatic sequential/combinational defaults
  - explicit `g_P`, `g_A`, `g_T` gain extraction
  - functional-only fallback scoring for CVDP-style paths
  - `normalized_code_hash`, `partial_pass_fraction`, `repair_score`,
    `archiveable`, and `archive_rejection_reason` fields on evaluations
  - descriptor registry, descriptor profile YAML, and descriptor-axis
    resolution helpers
  - descriptor probe CLI utility
  - lightweight structural metric extraction for Yosys-like statistics
- Automated tests:
  - `/workspace/.venv/bin/python -m pytest tests/revolution/test_structural_evaluator.py tests/revolution/test_qd_scoring.py tests/revolution/test_qd_descriptors.py tests/scripts/test_qd_descriptor_probe.py tests/revolution/test_candidate_evaluator.py tests/revolution/test_cvdp_evaluator.py`
  - Result: `24 passed in 0.73s`
  - `/workspace/.venv/bin/python -m pytest tests/revolution/test_defaults.py tests/revolution/test_problem_spec.py tests/revolution/test_structural_evaluator.py tests/revolution/test_qd_scoring.py tests/revolution/test_qd_descriptors.py tests/revolution/test_candidate_evaluator.py tests/revolution/test_candidate_evaluator_parity.py tests/revolution/test_cvdp_evaluator.py tests/revolution/test_backends_base.py tests/scripts/test_run_backend.py tests/scripts/test_run_evolution.py tests/scripts/test_run_backend_ablation.py tests/scripts/test_qd_descriptor_probe.py`
  - Result: `71 passed in 1.23s`
- Smoke tests:
  - no live LLM/backend smoke yet; Stage 2 is evaluation/config substrate only
- Notes:
  - descriptor selection now supports preset profiles, explicit axis lists, and
    descriptor files
  - `run_backend.py` threads descriptor and quality settings into
    `CandidateEvaluator`
  - CVDP evaluator now emits functional-only quality metadata compatible with
    later archive insertion logic
- Commit:
  - `2268a7f81f` `feat(qd): add scoring and descriptor substrate`

### Stage 3

- Date: `2026-03-12`
- In-progress implementation:
  - added `GridArchive` with tested empty-cell insert, same-cell replacement,
    and edge-bin clamping semantics
  - added exact linear QD fail-share and fill/improve budget split helpers
  - added experimental `QDEngine` runtime wiring for `search_mode=revolution_qd`
    with archive-backed success-state handling on the grid path
  - updated README, GUIDELINES, and immediate implementation docs to reflect
    the new QD feature surface and repo navigation pointers
- Automated tests:
  - `/workspace/.venv/bin/python -m pytest tests/revolution/test_qd_archive.py tests/revolution/test_qd_scheduler.py tests/revolution/test_qd_descriptors.py tests/revolution/test_qd_scoring.py`
  - Result: `20 passed in 0.83s`
  - `/workspace/.venv/bin/python -m pytest tests/revolution/test_defaults.py tests/revolution/test_problem_spec.py tests/revolution/test_qd_scoring.py tests/revolution/test_qd_descriptors.py tests/revolution/test_structural_evaluator.py tests/revolution/test_qd_archive.py tests/revolution/test_qd_scheduler.py tests/revolution/test_qd_engine.py tests/revolution/test_revolution_backend.py tests/scripts/test_run_backend.py tests/scripts/test_qd_descriptor_probe.py`
- Result: `51 passed in 1.01s`
- Smoke tests:
  - attempted live RTLLM smoke with `search_mode=revolution_qd`, `qd_archive_type=grid`,
    `population_size=1`, `num_generations=0`, vLLM endpoint
    `http://host.docker.internal:8000`
  - attempted once with `--max_tokens 128000` and once with `--max_tokens 4096`
  - both runs were manually stopped after stalling in the first end-to-end
    generation step without producing a quick failure signal; this is recorded
    as a blocked smoke rather than a pass
- Notes:
  - `revolution_backend.py` now selects `QDEngine` when
    `search_mode=revolution_qd`
  - this checkpoint was still grid-only; later Stage 4 work removes that
    limitation and adds initial CVT runtime support
  - top-level docs refreshed at this checkpoint:
    - `README.md`
    - `GUIDELINES.md`
    - `docs/user_guide.md`
    - `docs/module_structure.md`
    - `docs/implementation_details.md`
    - `docs/REvolution_specification.md`
  - phase-generation override flags are exposed and carried through runtime
    construction, and benchmark-specific `ProblemSpec` defaults are now applied
    in the `QDEngine` `auto` path with explicit overrides still taking
    precedence
  - focused runtime/default-wiring validation:
    - `/workspace/.venv/bin/python -m pytest tests/revolution/test_qd_engine.py tests/revolution/test_revolution_backend.py tests/revolution/test_problem_spec.py tests/revolution/test_defaults.py tests/scripts/test_run_backend.py`
    - Result: `31 passed in 1.57s`
  - focused reservoir/runtime sampling validation:
    - `/workspace/.venv/bin/python -m pytest tests/revolution/test_qd_engine.py tests/revolution/test_qd_archive.py tests/revolution/test_revolution_backend.py tests/revolution/test_problem_spec.py tests/revolution/test_defaults.py tests/scripts/test_run_backend.py`
    - Result: `37 passed in 1.03s`
  - focused grid-bin configuration validation:
    - `/workspace/.venv/bin/python -m pytest tests/revolution/test_qd_descriptors.py tests/revolution/test_qd_engine.py tests/revolution/test_revolution_backend.py tests/revolution/test_defaults.py tests/scripts/test_run_backend.py`
    - Result: `39 passed in 1.09s`
  - full regression rerun after Stage 3 follow-through and lint/type fixes:
    - `/workspace/.venv/bin/python -m pytest`
    - Result: `308 passed in 2.72s`
  - branch-scoped lint validation:
    - `/workspace/.venv/bin/ruff check src/revolution/algorithm.py src/revolution/backends/revolution_backend.py src/revolution/qd src/revolution/runtime tests/revolution/test_qd_descriptors.py tests/revolution/test_qd_engine.py tests/revolution/test_revolution_backend.py tests/revolution/test_problem_spec.py tests/revolution/test_defaults.py tests/scripts/test_run_backend.py scripts/run_backend.py scripts/run_evolution.py`
    - Result: `All checks passed!`
  - source-scoped type validation:
    - `/workspace/.venv/bin/python -m pyright src/revolution/backends/revolution_backend.py src/revolution/qd src/revolution/runtime/problem_spec.py`
    - Result: `0 errors, 1 warning`
    - Warning detail:
      - `src/revolution/qd/descriptors.py`: `yaml` could not be resolved from source by pyright
  - broader typecheck observation:
    - `/workspace/.venv/bin/python -m pyright src/revolution scripts/run_backend.py scripts/run_evolution.py`
    - Result: blocked by pre-existing repo-wide type debt outside the current
      QD branch surface, plus environment/source-resolution warnings for some
      third-party modules
  - grid runtime now keeps a bounded per-cell reservoir for recent successful
    occupants, and `success_view` samples from archive elites plus that
    reservoir without making it a second source of truth
  - grid runtime now loads per-axis bin/bounds settings from
    `qd_descriptor_file` `grid_axes:` entries when present, with derived
    fallbacks for unspecified axes
  - live vLLM smoke evidence:
    - preflight command:
      - `curl -s http://host.docker.internal:8000/v1/models`
    - runtime smoke command:
      - `timeout 180s bash -lc 'OPENAI_API_KEY=${OPENAI_API_KEY:-vllm-local-placeholder} /workspace/.venv/bin/python scripts/run_backend.py --backend revolution --search_mode revolution_qd --qd_archive_type grid --benchmarks RTLLM --problems Prob001_accu --api_backend vllm --vllm_host host.docker.internal --vllm_port 8000 --vllm_min_model_len 128000 --model_name /project/cad-team/LX_Semicon/models/openai-gpt-oss-120b --population_size 1 --num_generations 0 --num_workers 1 --temperature 0.3 --top_p 0.95 --max_tokens 2048 --save_path /workspace/.tmp_qd_smokes/grid_smoke --no-backend_subdir'`
    - result:
      - vLLM preflight succeeded and the run started
      - the runtime smoke timed out after `180s` without a completion signal
      - smoke remains blocked, not passed
  - deterministic fast-smoke path:
    - added `scripts/run_backend_qd_smoke_vllm.sh`
    - added dry-run coverage in
      `tests/scripts/test_run_backend_qd_smoke_vllm.py`
    - the harness fixes the smoke surface to small deterministic budgets
      instead of relying only on ad hoc long-context commands
  - shared engine-seam cleanup:
    - moved offspring materialization into the shared
      `EoHEngine._materialize_offspring_batch()` helper
    - `QDEngine` now reuses that helper instead of carrying its own near-copy
      of the diff/format/materialization path
  - focused seam-cleanup validation:
    - `/workspace/.venv/bin/python -m pytest tests/revolution/test_algorithm.py tests/revolution/test_qd_engine.py tests/revolution/test_revolution_backend.py tests/scripts/test_run_backend.py`
    - Result: `101 passed in 7.30s`
    - `/workspace/.venv/bin/ruff check src/revolution/algorithm.py src/revolution/qd/engine.py tests/revolution/test_algorithm.py tests/revolution/test_qd_engine.py tests/revolution/test_revolution_backend.py tests/scripts/test_run_backend.py`
    - Result: `All checks passed!`
  - reduced-budget grid smoke retry:
    - `VLLM_HOST=host.docker.internal VLLM_PORT=8000 SMOKE_TIMEOUT_S=180 SMOKE_MAX_TOKENS=256 bash scripts/run_backend_qd_smoke_vllm.sh --archive grid --suite verilogeval --policy whole-heavy`
    - result:
      - vLLM preflight succeeded
      - the run entered the problem loop
      - the bounded whole-heavy grid smoke still timed out without completion
  - Stage 3 seam-cleanup checkpoint commit:
    - `7777665902` `refactor(qd): share offspring materialization across engines`
  - commit-message hygiene review for `447c012822..HEAD`:
    - checked `git log --format=%B`, `git show --pretty=fuller --no-patch`, and
      `sed -n 'l'` formatting output for each commit
    - initial review found duplicate sign-off footers on two branch commits
    - branch history was rewritten to remove the extra `Signed-off-by: Codex
      <codex@openai.com>` footer so each commit now carries exactly one
      repository-author sign-off
    - post-rewrite review found no malformed headers, raw `\\n`, spacing
      corruption, or remaining duplicate sign-off footers
    - prevention note added to `GUIDELINES.md`: when using `git commit -s`, do
      not manually add a second `Signed-off-by:` footer
  - first Stage 3 substrate commit:
    - `efbf9b48d0` `feat(qd): add grid archive and linear scheduler substrate`
  - second Stage 3 runtime/docs checkpoint commit:
    - `4a82690a1f` `feat(qd): wire grid runtime path and refresh docs`

### Stage 4

- Date: `2026-03-12`
- In-progress implementation:
  - added `CVTArchive` with warm-up buffering, frozen z-score scaling, relaxed
    centroid generation, warm-up reinsertion, and nearest-centroid replacement
    semantics
  - removed the `grid only` runtime guard from `QDEngine` and switched archive
    construction to backend selection (`grid` or `cvt`)
  - threaded `qd_cvt_axes`, `qd_cvt_warmup_successes`,
    `qd_descriptor_profile`, and `qd_descriptor_axes` through the revolution
    backend into `QDEngine`
  - generalized descriptor extraction in `QDEngine` so CVT axes can draw from
    gains plus any structural/physical metrics already attached to a candidate
- Automated tests:
  - `/workspace/.venv/bin/python -m pytest tests/revolution/test_qd_archive.py tests/revolution/test_qd_engine.py tests/revolution/test_revolution_backend.py tests/revolution/test_defaults.py tests/scripts/test_run_backend.py`
  - Result: `39 passed in 0.99s`
  - `/workspace/.venv/bin/python -m pytest`
  - Result: `312 passed in 2.80s`
  - `/workspace/.venv/bin/ruff check src/revolution/qd/archive.py src/revolution/qd/engine.py src/revolution/qd/__init__.py src/revolution/backends/revolution_backend.py src/revolution/algorithm.py tests/revolution/test_qd_archive.py tests/revolution/test_qd_engine.py tests/revolution/test_revolution_backend.py`
  - Result: `All checks passed!`
  - `/workspace/.venv/bin/python -m pyright src/revolution/qd/archive.py src/revolution/qd/engine.py src/revolution/backends/revolution_backend.py`
  - Result: `0 errors, 0 warnings`
- Smoke tests:
  - preflight command:
    - `curl -s http://host.docker.internal:8000/v1/models`
  - CVT runtime smoke command:
    - `timeout 180s bash -lc 'OPENAI_API_KEY=${OPENAI_API_KEY:-vllm-local-placeholder} /workspace/.venv/bin/python scripts/run_backend.py --backend revolution --search_mode revolution_qd --qd_archive_type cvt --qd_cvt_axes g_A g_T --qd_cvt_warmup_successes 1 --benchmarks RTLLM --problems Prob001_accu --api_backend vllm --vllm_host host.docker.internal --vllm_port 8000 --vllm_min_model_len 128000 --model_name /project/cad-team/LX_Semicon/models/openai-gpt-oss-120b --population_size 1 --num_generations 0 --num_workers 1 --temperature 0.3 --top_p 0.95 --max_tokens 1024 --save_path /workspace/.tmp_qd_smokes/cvt_smoke --no-backend_subdir'`
  - result:
    - vLLM preflight succeeded and the CVT run started
    - the runtime smoke timed out after `180s` without a completion signal
    - CVT smoke remains blocked, not passed
- Notes:
  - CVT runtime support is now real, but archive-reporting parity is still not
    implemented
  - the current runtime can reliably use gain axes in both grid and CVT mode;
    richer structural/physical axes still depend on evaluator-side metric
    plumbing that is not fully wired through the legacy `EoHEngine` path yet
  - this stage reduces a major config/runtime mismatch, but it does not close
    the remaining duplicated generation-loop seam between `EoHEngine` and
    `QDEngine`
  - first Stage 4 runtime/docs checkpoint commit:
    - `c03242b784` `feat(qd): add initial cvt archive runtime support`

### Stage 7

- Date: `2026-03-12`
- Expanded implementation checkpoint:
  - added engine-level archive artifact emission for both grid and CVT runs:
    `archive_history.jsonl`, `archive_cells.csv`, `archive_summary.json`,
    `qd_metrics.json`, and `grid_layout.json` or `centroids.json`
  - archive history now records per-generation occupancy, coverage, QD score,
    best/mean quality, replacement counts, and gain aggregates
  - added `src/revolution/qd/visualization.py` and runtime-emitted QD plots:
    `coverage_vs_generation.png`, `best_quality_vs_generation.png`,
    `qd_score_vs_generation.png`, plus final 2-axis grid heatmaps, multi-axis
    grid marginals/projection plots, or CVT projection plots
  - updated `scripts/backend_comparison_report.py` to ignore
    `archive_summary.json` as a per-problem summary and render a dedicated QD
    archive metrics section instead
  - updated `scripts/archive_baseline.py` to preserve QD sidecars and QD plots
    in archived summary payloads so `candidate_core` archives keep archive-state
    evidence
- Automated tests:
  - `/workspace/.venv/bin/python -m pytest tests/revolution/test_qd_engine.py tests/revolution/test_qd_archive.py tests/revolution/test_revolution_backend.py tests/scripts/test_archive_baseline.py tests/scripts/test_backend_comparison_report.py`
  - Result: `40 passed in 9.27s`
  - `/workspace/.venv/bin/python -m pytest`
  - Result: `319 passed in 9.12s`
  - `/workspace/.venv/bin/ruff check src/revolution/qd src/revolution/backends/revolution_backend.py scripts/backend_comparison_report.py scripts/archive_baseline.py tests/revolution/test_qd_engine.py tests/scripts/test_backend_comparison_report.py tests/scripts/test_archive_baseline.py`
  - Result: `All checks passed!`
  - `/workspace/.venv/bin/python -m pyright src/revolution/qd src/revolution/backends/revolution_backend.py scripts/backend_comparison_report.py scripts/archive_baseline.py`
  - Result: `0 errors, 1 warning`
    - `src/revolution/qd/descriptors.py`: `yaml` could not be resolved from source by pyright
- Smoke tests:
  - grid smoke command:
    - `timeout 240s /workspace/.venv/bin/python scripts/run_backend.py --backend revolution --search_mode revolution_qd --qd_archive_type grid --qd_grid_axes g_A g_T --benchmarks RTLLM --problems Prob001_accu --api_backend vllm --vllm_host host.docker.internal --vllm_port 8000 --model_name /project/cad-team/LX_Semicon/models/openai-gpt-oss-120b --max_tokens 128000 --population_size 1 --num_generations 0 --candidate_workers 0 --evaluation_mode search_accelerated --accelerated_synthesis_top_k 1 --save_path /tmp/revolution_qd_smoke_stage7 --seed 42`
  - grid result:
    - vLLM preflight succeeded and the run entered the problem loop
    - the smoke timed out after `240s` without producing a completion signal
    - partial logs/config snapshots were written under `/tmp/revolution_qd_smoke_stage7`
  - CVT smoke command:
    - `timeout 120s /workspace/.venv/bin/python scripts/run_backend.py --backend revolution --search_mode revolution_qd --qd_archive_type cvt --qd_cvt_axes g_A g_P --qd_num_cells 4 --qd_cvt_warmup_successes 1 --benchmarks RTLLM --problems Prob001_accu --api_backend vllm --vllm_host host.docker.internal --vllm_port 8000 --model_name /project/cad-team/LX_Semicon/models/openai-gpt-oss-120b --max_tokens 128000 --population_size 1 --num_generations 0 --candidate_workers 0 --evaluation_mode search_accelerated --accelerated_synthesis_top_k 1 --save_path /tmp/revolution_qd_smoke_stage7_cvt --seed 42`
  - CVT result:
    - vLLM preflight succeeded and the run entered the problem loop
    - the smoke timed out after `120s` without producing a completion signal
    - partial logs/config snapshots were written under `/tmp/revolution_qd_smoke_stage7_cvt`
- Notes:
  - Stage 7 is no longer just engine-local artifact emission; report/archive
    packaging and first-pass visualization outputs are now wired through the
    runtime and script layer
  - the remaining Stage 7 gap is mostly deeper visualization coverage and
    downstream analysis polish, not basic artifact/report discovery anymore
  - live smoke evidence is still blocked rather than passed; the bounded runs
    reach vLLM preflight and enter the runner but do not complete within the
    timeout budget
  - broader repo-wide `pyright` remains red outside the touched QD/reporting
    surface; current failures are still pre-existing in
    `run_evolution.py`, `algorithm.py`, `candidate_evaluator.py`, `llm.py`,
    and other older modules, so the local validation checklist continues to use
    touched-module typechecks plus an explicit repo-debt note
  - Stage 7 reporting/visualization parity checkpoint commit:
    - `013972bfe4` `feat(qd): add reporting and visualization parity for qd runs`

### Stage 5

- Date: `2026-03-12`
- Partial implementation checkpoint:
  - added `M-T` prompt builders and prompt templates for targeted descriptor
    mutation on the success-side fill/backfill path
  - added `C-D` prompt builders and prompt templates for diverse two-parent
    archive fusion on the success-side fill/backfill path
  - fill/backfill operator routing now selects from `M-T`, `M-E`, and `C-D`
    instead of collapsing all backfill into `M-E`
- Automated tests:
  - `/workspace/.venv/bin/python -m pytest tests/revolution/test_qd_engine.py tests/revolution/test_revolution_backend.py tests/revolution/test_defaults.py tests/scripts/test_run_backend.py tests/revolution/test_prompt_store.py`
  - Result: `40 passed in 1.00s`
  - `/workspace/.venv/bin/python -m pytest`
  - Result: `317 passed in 2.69s`
  - `/workspace/.venv/bin/ruff check src/revolution/qd/engine.py src/revolution/algorithm.py tests/revolution/test_qd_engine.py`
  - Result: `All checks passed!`
  - `/workspace/.venv/bin/python -m pyright src/revolution/qd/engine.py`
  - Result: `0 errors, 0 warnings`
- Notes:
  - the new operators are currently localized in `QDEngine` rather than pushed
    into the classic engine, which keeps the QD-specific surface contained but
    preserves the existing engine-seam debt
  - whole/diff execution already follows explicit per-phase mode resolution in
    the QD runtime, but targeted live smoke evidence for the new operators is
    still missing
  - Stage 5 operator checkpoint commit:
    - `7cb58e1240` `feat(qd): add targeted and diverse qd operators`

### Stage 6

- Date: `2026-03-12`
- Partial implementation checkpoint:
  - enabled `revolution` in the backend registry for the existing JSONL-backed
    `cvdp` path used by `scripts/run_backend.py`
  - added `src/revolution/runtime/realbench_adapter.py` with a manifest-based
    RealBench module adapter:
    `module_manifest.json` -> problem discovery -> `ProblemContext` /
    `ProblemSpec`
  - added `--realbench_root` and `--realbench_subset module` to
    `scripts/run_backend.py`
  - fixed a legacy `EoHEngine` initialization assumption so JSONL-backed tasks
    can use `ProblemSpec.prompt_text` and `ProblemSpec.benchmark_root` instead
    of requiring on-disk `<problem>_prompt.txt` files
- Automated tests:
  - `/workspace/.venv/bin/python -m pytest tests/revolution/test_problem_spec.py tests/revolution/test_cvdp_evaluator.py tests/revolution/test_realbench_adapter.py tests/scripts/test_run_backend.py`
  - Result: `27 passed in 0.98s`
  - `/workspace/.venv/bin/python -m pytest tests/revolution/test_qd_engine.py tests/revolution/test_realbench_adapter.py tests/revolution/test_problem_spec.py tests/scripts/test_run_backend.py`
  - Result: `39 passed in 7.03s`
  - `/workspace/.venv/bin/python -m pytest`
  - Result: `319 passed in 9.12s`
  - `/workspace/.venv/bin/python -m pytest`
  - Result: `324 passed in 10.80s`
  - `/workspace/.venv/bin/ruff check src/revolution/runtime/realbench_adapter.py src/revolution/runtime/__init__.py src/revolution/backends/registry.py scripts/run_backend.py tests/revolution/test_realbench_adapter.py tests/scripts/test_run_backend.py`
  - Result: `All checks passed!`
  - `/workspace/.venv/bin/ruff check src/revolution/runtime/realbench_adapter.py src/revolution/runtime/__init__.py src/revolution/backends/registry.py scripts/run_backend.py src/revolution/algorithm.py tests/revolution/test_realbench_adapter.py tests/revolution/test_qd_engine.py tests/scripts/test_run_backend.py`
  - Result: `All checks passed!`
  - `/workspace/.venv/bin/python -m pyright src/revolution/runtime/realbench_adapter.py src/revolution/runtime/__init__.py src/revolution/backends/registry.py`
  - Result: `0 errors, 0 warnings`
  - `/workspace/.venv/bin/python -m pyright src/revolution/algorithm.py src/revolution/runtime/realbench_adapter.py src/revolution/backends/registry.py src/revolution/runtime/__init__.py`
  - Result: broader pre-existing `algorithm.py` type debt remains; no new
    Stage 6-specific adapter errors were introduced
  - `/workspace/.venv/bin/python -m pyright src/revolution/runtime/realbench_adapter.py src/revolution/runtime/__init__.py src/revolution/backends/registry.py scripts/run_backend.py`
  - Result: `0 errors, 1 warning` (`tqdm` source-resolution warning only)
- Smoke tests:
  - CVDP smoke command:
    - `timeout 120s /workspace/.venv/bin/python scripts/run_backend.py --backend revolution --search_mode revolution_qd --qd_archive_type grid --benchmarks cvdp --problems cvdp_copilot_16qam_mapper_0001 --api_backend vllm --vllm_host host.docker.internal --vllm_port 8000 --model_name /project/cad-team/LX_Semicon/models/openai-gpt-oss-120b --max_tokens 128000 --population_size 1 --num_generations 0 --candidate_workers 0 --evaluation_mode search_accelerated --accelerated_synthesis_top_k 1 --save_path /tmp/revolution_qd_stage6_cvdp --seed 42`
  - Retry smoke command:
    - `timeout 150s /workspace/.venv/bin/python scripts/run_backend.py --backend revolution --search_mode revolution_qd --qd_archive_type grid --benchmarks cvdp --problems cvdp_copilot_16qam_mapper_0001 --api_backend vllm --vllm_host host.docker.internal --vllm_port 8000 --model_name /project/cad-team/LX_Semicon/models/openai-gpt-oss-120b --max_tokens 128000 --population_size 1 --num_generations 0 --candidate_workers 0 --evaluation_mode search_accelerated --accelerated_synthesis_top_k 1 --save_path /tmp/revolution_qd_stage6_cvdp_retry --seed 42`
  - CVDP smoke result:
    - initial run exposed a real bug in `EoHEngine.load_problem_description()`
      for JSONL-backed tasks
    - after the fix, the run passed vLLM preflight, entered the problem loop,
      and timed out after `120s` without a completion signal
    - the retry reproduced the same behavior with a `150s` timeout
    - this is now a blocked live smoke, not an initialization failure
  - RealBench smoke result:
    - no checked-in dataset exists under `data/bench/RealBench`
    - Stage 6 therefore validates RealBench through adapter fixtures only
- Notes:
  - Stage 6 is now real at the capability layer rather than only planned:
    the runner can discover `cvdp` for `revolution` and can discover
    manifest-backed RealBench module tasks
  - RealBench runtime support is still not completion-grade because the branch
    lacks a checked-in dataset and the legacy engine still assumes benchmark
    layouts more often than the manifest adapter would prefer
  - the `ProblemSpec.prompt_text` / `benchmark_root` initialization fix is
    useful beyond Stage 6 because it reduces one class of path-coupling debt
    between the classic engine and non-file-backed benchmark formats
  - code documentation and typing review:
    - the new public adapter helpers in
      `src/revolution/runtime/realbench_adapter.py` have explicit type hints
      and short docstrings
    - Stage 6 did not eliminate older `algorithm.py` type debt, so the branch
      still relies on scoped pyright passes plus explicit debt tracking rather
      than a clean repo-wide typecheck
  - Stage 6 feature checkpoint commit:
    - `a7ca6aeedd` `feat(qd): add cvdp and realbench capability scaffolding`
  - commit-hygiene note:
    - the first stored version of the Stage 6 feature commit had literal `\\n`
      escapes in the body because the commit message was passed incorrectly
    - the commit was amended immediately, and the branch rule remains:
      always inspect `git log --format=%B` and `sed -n 'l'` before proceeding
  - RealBench integration note:
    - a separate remote GitHub branch named `realbench` is intended to carry
      fuller RealBench benchmark integration plus analysis capability
    - that branch is not merged into `wip/journal-extension-2026` yet, so the
      Stage 6 path in this branch intentionally stays at the manifest-based
      adapter plus fixture-validation level

### Stage 8

- Date: `2026-03-12`
- Incremental cleanup / validation checkpoint:
  - added `scripts/run_backend_qd_smoke_vllm.sh` as the repeatable QD smoke
    harness for `grid` / `cvt`, `rtllm` / `verilogeval`, and
    `whole-heavy` / `diff-heavy` policy shapes
  - updated `README.md`, `GUIDELINES.md`, `docs/user_guide.md`, and
    `docs/module_structure.md` so the new smoke harness and current benchmark
    status are discoverable from the top-level docs
  - cleaned stale living-plan checkboxes for already-landed reporting and
    visualization outputs
- Automated tests:
  - `/workspace/.venv/bin/python -m pytest tests/scripts/test_run_backend_qd_smoke_vllm.py tests/scripts/test_run_backend.py tests/revolution/test_realbench_adapter.py tests/revolution/test_qd_engine.py`
  - Result: `37 passed in 7.11s`
  - `/workspace/.venv/bin/python -m pytest`
  - Result: `325 passed in 9.08s`
  - `/workspace/.venv/bin/ruff check tests/scripts/test_run_backend_qd_smoke_vllm.py`
  - Result: `All checks passed!`
  - attempted broad lint command on markdown/shell files:
    - Result: invalid signal; `ruff` was pointed at non-Python files and
      produced parser noise
    - follow-up action: keep `ruff` scoped to Python paths and record shell/doc
      validation separately
- Smoke tests:
  - dry-run matrix command:
    - `VLLM_HOST=host.docker.internal VLLM_PORT=8000 bash scripts/run_backend_qd_smoke_vllm.sh --archive matrix --suite verilogeval --policy diff-heavy --dry-run`
  - dry-run result:
    - printed stable `grid` and `cvt` commands using
      `/workspace/.venv/bin/python`
    - confirmed fixed archive-mode, benchmark, and diff-heavy policy wiring
  - bounded live matrix command:
    - `VLLM_HOST=host.docker.internal VLLM_PORT=8000 SMOKE_TIMEOUT_S=60 bash scripts/run_backend_qd_smoke_vllm.sh --archive matrix --suite verilogeval --policy diff-heavy`
  - bounded live matrix result:
    - vLLM preflight succeeded for both archive modes
    - grid entered the runner and timed out under the harness timeout
    - CVT entered the runner and timed out under the harness timeout
    - the final smoke matrix was executed and is now repeatable, but it still
      remains blocked rather than passed
- Review notes:
  - code cleanliness:
    - the new smoke harness removes some validation sprawl by centralizing the
      live QD smoke surface into one maintained script instead of more ad hoc
      shell history
    - the main remaining architectural debt is still the duplicated
      `EoHEngine` / `QDEngine` loop seam, not the smoke tooling
  - intent alignment:
    - the branch is now more aligned with the original plan's validation story
      because the smoke matrix is explicit and reproducible
    - the branch still cannot claim completion-grade live validation because
      the bounded grid/CVT matrix does not finish on the shared endpoint yet
  - Stage 8 feature checkpoint commit:
    - `5c669d1c1f` `feat(qd): add repeatable vllm smoke harness`

### Stage 3/4/5/8 follow-through

- Date: `2026-03-12`
- Regression fix discovered by live experimentation:
  - larger VerilogEval comparison runs exposed a classic-mode bug where
    `EoHEngine` was incorrectly selecting QD-only success strategies and could
    crash with `KeyError: 'M-T'`
  - fixed by splitting classic success strategies from QD success strategies
    and restoring the full QD set inside `QDEngine`
  - focused validation after the fix:
    - `/workspace/.venv/bin/python -m pytest tests/revolution/test_algorithm.py tests/revolution/test_qd_engine.py tests/revolution/test_revolution_backend.py tests/scripts/test_run_backend.py`
    - Result: `103 passed in 7.35s`
    - `/workspace/.venv/bin/ruff check src/revolution/algorithm.py src/revolution/qd/engine.py tests/revolution/test_algorithm.py tests/revolution/test_qd_engine.py tests/revolution/test_revolution_backend.py tests/scripts/test_run_backend.py`
    - Result: `All checks passed!`
- Completion-grade live smokes now pass for both archive backends and both
  benchmark suites under bounded accelerated settings:
  - VerilogEval grid:
    `Prob001_zero`, `population_size=1`, `num_generations=0`,
    `evaluation_mode=search_accelerated`, `accelerated_synthesis_top_k=1`,
    `max_tokens=128`, completed in `53.85s`
  - VerilogEval CVT: same budget, completed in `70.51s`
  - RTLLM grid:
    `Prob001_accu`, same budget, completed in `70.52s`
  - RTLLM CVT: same budget, completed in `127.21s`
- Targeted phase-routing smokes also now complete:
  - grid whole-heavy on `VerilogEval-Spec-to-RTL/Prob001_zero` with
    `population_size=1`, `num_generations=1`, `max_tokens=128`,
    completed in `273.61s`
  - CVT diff-heavy on the same problem with `population_size=1`,
    `num_generations=1`, `max_tokens=128`, completed in `331.56s`
- Larger short-budget comparative runs completed for both suites:
  - RTLLM `Prob045_alu`: classic, grid, and CVT all completed in roughly
    `285-290s`
  - VerilogEval `Prob030_popcount255`: classic, grid, and CVT all completed in
    roughly `404-406s`
- Empirical findings from those larger runs:
  - all three modes failed on both larger problems under the short-budget
    setting (`population_size=1`, `num_generations=1`, `max_tokens=256`)
  - in both QD modes the archive remained empty (`occupied_cells=0`,
    `coverage=0.0`, `qd_score=0`) even though archive artifacts were emitted
  - the dominant blockers were prompt/response robustness rather than archive
    semantics:
    - empty Gen1 completions from the shared vLLM endpoint
    - truncated whole-mode JSON/code payloads on larger VerilogEval prompts
    - feedback responses that did not contain a parsable JSON object
  - conclusion: the branch is now completion-grade for smoke validation, but
    the short-budget experiments are not evidence of meaningful QD search
    performance on harder problems
- Practical implication for future runs:
  - keep the low-budget smoke profile for CI-like reachability checks
  - use materially larger completion budgets than `128-256` tokens for harder
    RTLLM/VerilogEval experiments if archive occupancy is the goal
- Additional typecheck evidence:
  - `/workspace/.venv/bin/python -m pyright src/revolution/algorithm.py src/revolution/qd/engine.py`
  - Result: existing `algorithm.py` type debt remains on heterogeneous
    synthesis-result dictionaries, optional prompt-override containers, and
    generic strategy bookkeeping
  - `uv tool run ty check src/revolution/algorithm.py src/revolution/qd/engine.py tests/revolution/test_algorithm.py`
  - result: the new strategy split does not introduce a targeted `ty` failure,
    but `algorithm.py` still has substantial pre-existing `ty` diagnostics
    around heterogeneous synthesis-result dictionaries, optional override
    containers, and generic strategy bookkeeping
  - `uv tool run ty` also surfaces transient environment-resolution issues for
    some third-party and test imports when run from the tool sandbox
- OpenROAD metrics sidecar follow-through:
  - `src/revolution/evaluation.py` now emits `physical_metrics` and
    `metrics_sidecar_path` from the legacy synthesis evaluator
  - the sidecar is written as `<report_base>_synthesis_report.metrics.json`
    beside the existing `.rpt` and `.ppa` files
  - current guaranteed coverage is lightweight but real:
    - `utilization` is parsed from the OpenROAD report text when present
    - regex hooks for `wirelength`, `cts_buffer_count`,
      `repair_buffer_count`, and `hold_buffer_count` now exist and will emit
      values if the report contains those metrics
  - focused validation:
    - `/workspace/.venv/bin/python -m pytest tests/revolution/test_evaluation.py tests/revolution/test_candidate_evaluator.py tests/revolution/test_candidate_evaluator_parity.py`
    - Result: `43 passed in 1.82s`
    - `/workspace/.venv/bin/ruff check src/revolution/evaluation.py tests/revolution/test_evaluation.py`
    - Result: `All checks passed!`
    - `/workspace/.venv/bin/python -m pyright src/revolution/evaluation.py`
    - Result: `0 errors, 0 warnings`
- Shared-engine seam follow-through:
  - `src/revolution/algorithm.py` now owns shared helpers for:
    - logger initialization
    - generation-stat logging and LLM usage reset
    - run-summary finalization
  - `src/revolution/qd/engine.py` now reuses those helpers instead of carrying
    separate near-copy logger/finalization code
  - the generation policies still remain intentionally separate between classic
    REvolution and `revolution_qd`; the cleanup goal here was to remove shared
    plumbing duplication without forcing the two generation loops into one
    abstraction
  - focused validation:
    - `/workspace/.venv/bin/python -m pytest tests/revolution/test_algorithm.py tests/revolution/test_qd_engine.py tests/revolution/test_revolution_backend.py tests/scripts/test_run_backend.py`
    - Result: `103 passed in 7.28s`
    - `/workspace/.venv/bin/ruff check src/revolution/algorithm.py src/revolution/qd/engine.py tests/revolution/test_algorithm.py`
    - Result: `All checks passed!`
    - `/workspace/.venv/bin/python -m pyright src/revolution/algorithm.py src/revolution/qd/engine.py`
    - Result: still blocked by older `algorithm.py` typing debt, but the seam
      extraction itself did not add a new failure class

### Moderate-budget RTLLM / VerilogEval experiment follow-through

- Date: `2026-03-12`
- Status:
  superseded for research interpretation because it used `max_tokens=1024` and
  `diff_max_tokens=1024` on a reasoning-oriented model that requires long
  output budgets
- Experiment goal:
  - move beyond reachability smokes and test whether classic `revolution`,
    `revolution_qd --qd_archive_type grid`, and
    `revolution_qd --qd_archive_type cvt` can produce successful candidates and
    non-empty archives on relatively larger PPA-relevant tasks
- Experimental command shape:
  - model:
    `/project/cad-team/LX_Semicon/models/openai-gpt-oss-120b`
  - common settings:
    `population_size=8`, `num_generations=3`, `num_workers=2`,
    `evaluation_mode=search_accelerated`, `accelerated_synthesis_top_k=1`,
    `temperature=0.4`, `top_p=0.95`, `max_tokens=1024`,
    `diff_max_tokens=1024`, `--seed 42`
  - RTLLM problem set:
    `Prob043_RAM`, `Prob045_alu`
  - VerilogEval problem set:
    `Prob153_gshare`, `Prob156_review2015_fancytimer`
  - QD axes:
    - RTLLM grid/CVT: `g_A`, `g_T`
    - VerilogEval grid/CVT: `g_A`, `g_P`
- Current experiment evidence captured from `/tmp/qd_midbatch/...` artifacts:
  - RTLLM `Prob043_RAM`:
    - classic:
      - `3` generation-log rows observed
      - max observed `best_score=0.2366190815`
      - total successful candidates observed: `4`
    - grid:
      - `2` generation-log rows observed
      - archive summary:
        `occupied_cells=1`, `coverage=0.0625`, `qd_score=0.2366190815`
      - total successful candidates observed: `6`
      - generated plots are non-empty and readable:
        `coverage_vs_generation.png`, `best_quality_vs_generation.png`,
        `qd_score_vs_generation.png`, `grid_occupancy_heatmap.png`,
        `grid_quality_heatmap.png`, `grid_g_P_heatmap.png`,
        `grid_g_A_heatmap.png`, `grid_g_T_heatmap.png`
    - CVT:
      - `2` generation-log rows observed
      - archive summary:
        `occupied_cells=2`, `coverage=0.125`, `qd_score=0.4633680699`
      - archive cells show one initial elite and one Gen1 `M-E` occupant in a
        second centroid cell
      - generated plots are non-empty and readable:
        `coverage_vs_generation.png`, `best_quality_vs_generation.png`,
        `qd_score_vs_generation.png`, `cvt_quality_projection.png`,
        `cvt_g_P_projection.png`, `cvt_g_A_projection.png`,
        `cvt_g_T_projection.png`
  - RTLLM `Prob045_alu`:
    - classic, grid, and CVT all remained dominated by `failed_format`
    - observed archive occupancy stayed at `0` for both QD modes
    - no meaningful visualization content was produced beyond empty/default
      archive outputs
  - VerilogEval `Prob153_gshare` and `Prob156_review2015_fancytimer`:
    - classic, grid, and CVT were all dominated by `failed_format` already in
      Gen0 under the `1024`-token budget
    - observed archive occupancy stayed at `0` for both QD modes
    - no useful plots were generated because no successful occupants reached
      the archive
- Key empirical conclusions:
  - this run is still useful as a debugging artifact because it exposed the QD
    sidecar/history drift that was subsequently fixed
  - this run is not valid evidence about benchmark difficulty or QD-vs-classic
    effectiveness because the token budget was too short for this reasoning
    model family
  - any negative conclusions from the `1024`-token run must be superseded by
    long-token reruns (`>=128000`)
- Implementation issues exposed by the experiments:
  - QD artifact drift:
    - before the fix, `archive_history.jsonl` stayed empty after a successful
      initial population because only evolved generations appended snapshots
    - before the fix, `qd_metrics.json` omitted the top-level occupancy/quality
      fields and only stored `history` plus `visualization_files`
    - fixed in `src/revolution/qd/engine.py` by recording an initial snapshot
      immediately after `initialize_population()` and by promoting the latest
      headline archive metrics into `qd_metrics.json`
    - focused validation after the fix:
      - `/workspace/.venv/bin/python -m pytest tests/revolution/test_qd_engine.py`
      - Result: `17 passed in 9.88s`
      - `/workspace/.venv/bin/ruff check src/revolution/qd/engine.py tests/revolution/test_qd_engine.py`
      - Result: `All checks passed!`
      - `uv tool run ty check src/revolution/qd/engine.py`
      - Result: `All checks passed!`
  - runner shutdown debt:
    - interrupting long `run_backend.py` multiprocessing runs still leaves a
      noisy `KeyboardInterrupt` / pool-cleanup traceback
    - this does not invalidate experiment artifacts, but it should be treated
      as runner cleanup debt rather than ideal behavior
- Practical recommendations based on the experiment:
  - keep tiny-token smoke profiles only for reachability checks
  - do not use `1024`-token runs as research evidence on this shared reasoning
    model
  - rerun moderate-budget RTLLM / VerilogEval comparisons with
    `max_tokens>=128000` and matching `diff_max_tokens` before updating any
    archive-quality conclusions

### Long-token rerun and configuration-audit follow-through

- Date: `2026-03-12`
- Status:
  in progress, but already strong enough to supersede the core negative
  interpretation from the `1024`-token run
- Motivation:
  - the prior moderate-budget comparison used `max_tokens=1024` and
    `diff_max_tokens=1024` on the shared reasoning-model vLLM endpoint
  - that configuration was invalid for research interpretation because it
    measured truncation pressure more than search quality
- Immediate configuration fixes made before the rerun:
  - `scripts/run_backend_qd_smoke_vllm.sh` now defaults to
    `SMOKE_MAX_TOKENS=128000` and `SMOKE_DIFF_MAX_TOKENS=128000`
  - `scripts/run_evolution_smoke_vllm.sh` now defaults to
    `SMOKE_MAX_TOKENS=128000` and forwards `--diff_max_tokens 128000`
  - `scripts/run_backend.py` now prints explicit warnings when a large-context
    vLLM endpoint is paired with sub-`128000` `max_tokens` or
    `diff_max_tokens`
  - added focused regression coverage:
    - `tests/scripts/test_run_backend.py`
    - `tests/scripts/test_run_backend_qd_smoke_vllm.py`
    - `tests/scripts/test_run_evolution_smoke_vllm.py`
- Validation after the configuration fix:
  - `/workspace/.venv/bin/python -m pytest tests/scripts/test_run_backend.py tests/scripts/test_run_backend_qd_smoke_vllm.py tests/scripts/test_run_evolution_smoke_vllm.py`
  - Result: `22 passed in 2.00s`
  - `/workspace/.venv/bin/python -m pytest`
  - Result: `331 passed in 14.31s`
  - `/workspace/.venv/bin/ruff check scripts/run_backend.py tests/scripts/test_run_backend.py tests/scripts/test_run_backend_qd_smoke_vllm.py tests/scripts/test_run_evolution_smoke_vllm.py`
  - Result: `All checks passed!`
  - `bash -n scripts/run_backend_qd_smoke_vllm.sh scripts/run_evolution_smoke_vllm.sh`
  - Result: success
  - `/workspace/.venv/bin/python -m pyright scripts/run_backend.py`
  - Result: `0 errors, 1 warning`
    (`tqdm` source-resolution only)
  - `uv tool run ty check scripts/run_backend.py`
  - Result: existing environment/import-resolution warning only (`tqdm`)
- Corrected rerun command shape:
  - model:
    `/project/cad-team/LX_Semicon/models/openai-gpt-oss-120b`
  - common settings:
    `population_size=8`, `num_generations=3`, `num_workers=2`,
    `evaluation_mode=search_accelerated`, `accelerated_synthesis_top_k=1`,
    `temperature=0.4`, `top_p=0.95`, `max_tokens=128000`,
    `diff_max_tokens=128000`, `--seed 42`
  - RTLLM problem set:
    `Prob043_RAM`, `Prob045_alu`
  - VerilogEval problem set:
    `Prob153_gshare`, `Prob156_review2015_fancytimer`
  - QD axes:
    - RTLLM grid/CVT: `g_A`, `g_T`
    - VerilogEval grid/CVT: `g_A`, `g_P`
- Rerun observations so far from `/tmp/qd_longbudget/...`:
  - global:
    - `code_format_error.json` count stayed at `0` across the long-budget RTLLM
      and VerilogEval reruns checked so far
    - this alone invalidates the earlier conclusion that the larger RTLLM /
      VerilogEval tasks were primarily format-failure dominated
  - RTLLM `Prob043_RAM`:
    - classic:
      - Gen0: `success: 8`
      - latest observed generation:
        `generation=1`, `best_score=0.4261226376`,
        `status={success: 7, failed_functionality: 1}`
    - grid Gen0:
      - `success: 8`
      - archive summary:
        `occupied_cells=1`, `coverage=0.0625`,
        `qd_score=0.2366190815`
    - CVT Gen0:
      - `success: 8`
      - archive summary:
        `occupied_cells=1`, `coverage=0.0625`,
        `qd_score=0.2366190815`
    - interpretation:
      - QD is mechanically working on this larger task under the long-token
        budget, but early coverage is still low because the successful Gen0
        candidates observed so far land in the same gain cell / centroid region
  - RTLLM `Prob045_alu`:
    - classic Gen0:
      - status mix:
        `failed_functionality: 5`, `failed_syntax: 2`, `success: 1`
      - `best_score=0.0967941389`
    - grid Gen0:
      - status mix:
        `failed_functionality: 6`, `failed_syntax: 1`, `success: 1`
      - archive summary:
        `occupied_cells=1`, `coverage=0.0625`,
        `qd_score=0.1150942900`
    - CVT Gen0:
      - status mix:
        `failed_functionality: 7`, `success: 1`
      - archive summary:
        `occupied_cells=0`, `coverage=0.0`, `qd_score=0`
    - interpretation:
      - the corrected run shows real functional/synthesis pressure rather than
        formatting collapse
      - grid already preserves one successful specialist, while CVT has not yet
        converted the single Gen0 success into occupied frozen-centroid state in
        the currently observed window
  - VerilogEval `Prob156_review2015_fancytimer`:
    - classic Gen0 produced eight complete `code.sv` candidates with sizes
      around `3.8k-6.1k` chars
    - sample simulation logs now show large functional mismatch counts such as
      `165951` to `199075` mismatches out of `200000`, not formatting failure
    - interpretation:
      - the bottleneck moved from truncation to genuine functional correctness
  - VerilogEval `Prob153_gshare`:
    - directories and per-problem logs exist, but the observed window has not
      yet reached a written `generation_log.jsonl`
    - treat this as still-running / slower-evaluating, not as evidence of
      archive failure
- Updated empirical interpretation:
  - the additional branch changes made after the short-budget run were not
    invalidated by the token-budget correction
  - the artifact-history fix in `src/revolution/qd/engine.py` remains valid
    because long-budget QD runs still need an initial archive snapshot to avoid
    empty-looking metrics
  - the earlier negative claim that larger RTLLM / VerilogEval tasks were
    mostly `failed_format` was configuration-induced and should not be reused
  - the long-budget rerun shows QD and classic both reaching meaningful
    evaluation states; the remaining challenge is functional correctness and
    descriptor diversity, not prompt truncation
- Roadmap adjustments after the rerun:
  - treat any future short-budget (`<128000`) reasoning-model experiments as
    smoke/debug evidence only
  - when comparing classic vs grid vs CVT on larger tasks, report archive fill
    only after at least one long-budget generation has fully completed
  - prioritize longer multi-generation runs on tasks like `Prob043_RAM` and
    `Prob045_alu`, because they now expose real QD behavior instead of format
    artifacts

### Completed `20 x 5` long-budget comparison (`temperature=1.0`, `top_p=1.0`)

- Purpose:
  - rerun the same larger RTLLM / VerilogEval comparison slice with a more
    substantive search budget after correcting the bad short-token setup
- Common configuration:
  - model:
    `/project/cad-team/LX_Semicon/models/openai-gpt-oss-120b`
  - common settings:
    `population_size=20`, `num_generations=5`, `num_workers=2`,
    `candidate_workers=0`, `evaluation_mode=search_accelerated`,
    `accelerated_synthesis_top_k=1`, `temperature=1.0`, `top_p=1.0`,
    `max_tokens=128000`, `diff_max_tokens=128000`, `seed=42`
  - RTLLM problem set:
    `Prob043_RAM`, `Prob045_alu`
  - VerilogEval problem set:
    `Prob153_gshare`, `Prob156_review2015_fancytimer`
  - QD axes:
    - RTLLM grid/CVT: `g_A`, `g_T`
    - VerilogEval grid/CVT: `g_A`, `g_P`
- Result overview from `/tmp/qd_longbudget_20x5/...`:
  - RTLLM `Prob043_RAM`:
    - classic best score: `0.44449010410240736`
    - grid:
      `occupied_cells=1`, `coverage=0.0625`,
      `qd_score=0.4305511495240007`,
      `best_quality=0.4305511495240007`
    - CVT:
      `occupied_cells=4`, `coverage=0.25`,
      `qd_score=1.077114727148152`,
      `best_quality=0.4261226375763753`
    - interpretation:
      classic keeps the best single elite, but CVT clearly explores and fills
      more of the feature space while staying near-classic on best quality
  - RTLLM `Prob045_alu`:
    - classic best score: `0.1581891057231093`
    - grid:
      `occupied_cells=2`, `coverage=0.125`,
      `qd_score=0.10705696826335506`,
      `best_quality=0.15404691504041004`
    - CVT:
      `occupied_cells=5`, `coverage=0.3125`,
      `qd_score=0.6572922005388002`,
      `best_quality=0.16489191142650636`
    - interpretation:
      this is the strongest positive QD result so far; CVT beats classic on
      best quality and fills meaningfully more archive territory than grid
  - VerilogEval `Prob153_gshare`:
    - classic best score: `0.13560291914358902`
    - grid archive state:
      `occupied_cells=5`, `coverage=0.3125`,
      `qd_score=-0.7576534220927813`,
      `best_quality=0.15112296251468296`
    - CVT:
      `occupied_cells=7`, `coverage=0.4375`,
      `qd_score=0.2377194033112486`,
      `best_quality=0.13560291914358902`
    - interpretation:
      CVT preserves a broader and healthier archive, while grid reaches a
      slightly better single elite but also accumulates enough negative-score
      cells to drag total QD score below zero
  - VerilogEval `Prob156_review2015_fancytimer`:
    - classic best score: `-0.2052573876663846`
    - grid archive state before finalization hang:
      `occupied_cells=3`, `coverage=0.1875`,
      `qd_score=-0.40373818413968365`,
      `best_quality=-0.00304644029900661`
    - CVT:
      `occupied_cells=3`, `coverage=0.1875`,
      `qd_score=-0.6705769462837745`,
      `best_quality=-0.17356127933152068`
    - interpretation:
      this remains a hard control/FSM task for all modes; grid appears to find
      the least-bad specialist so far, but neither QD backend turns the task
      into a healthy positive-score archive under this budget
- Visualization/artifact evidence:
  - grid heatmaps and archive CSV/JSON outputs exist for the completed grid
    runs, e.g. `RTLLM/Prob043_RAM/grid_occupancy_heatmap.png` and
    `VerilogEval-Spec-to-RTL/Prob153_gshare/grid_quality_heatmap.png`
  - CVT projection plots and centroid dumps exist for the completed CVT runs,
    e.g. `RTLLM/Prob043_RAM/cvt_quality_projection.png` and
    `VerilogEval-Spec-to-RTL/Prob153_gshare/centroids.json`
- Implementation issue exposed by the `20 x 5` run:
  - `VerilogEval-Spec-to-RTL` grid mode did not emit the top-level
    `*_revolution_summary_results.txt` and remained stuck in end-of-run
    finalization even after both problem directories had Gen5 artifacts
  - `Prob153_gshare` finished and wrote its per-problem summary, but
    `Prob156_review2015_fancytimer` stopped logging after candidate 14 in the
    tail of Gen5 while child processes remained sleeping
  - this is not a prompt/truncation problem; it looks like a real runtime
    finalization or worker-pool coordination defect on the grid path
- Updated research interpretation after the `20 x 5` run:
  - QD, especially CVT, now has clear positive evidence on larger RTLLM PPA
    tasks:
    it can fill the archive and, on `Prob045_alu`, improve the best elite over
    classic REvolution
  - CVT is currently the most convincing backend for preserving multiple useful
    niches without collapsing total archive quality
  - grid can still find strong specialists, but on harder VerilogEval tasks it
    is more vulnerable to filling the archive with net-negative elites
  - the remaining ambiguity is no longer "does QD work mechanically?" but
    "what descriptor / replacement / budgeting refinements keep grid healthy on
    tougher control-heavy tasks?"
- Immediate follow-up priority from this experiment:
  - diagnose and fix the VerilogEval grid end-of-run hang before treating grid
    comparison results as fully complete
  - run another `20 x 5` comparison after the hang fix to confirm whether the
    recovered final grid summary matches the partial archive evidence captured
    here

### Completed richer-descriptor `20 x 5` comparison

- Purpose:
  - repeat the same four-design matrix with materially richer descriptor spaces
    instead of the earlier reduced gain-only setup
- Common configuration:
  - model:
    `/project/cad-team/LX_Semicon/models/openai-gpt-oss-120b`
  - common settings:
    `population_size=20`, `num_generations=5`, `num_workers=2`,
    `candidate_workers=0`, `evaluation_mode=search_accelerated`,
    `accelerated_synthesis_top_k=1`, `temperature=1.0`, `top_p=1.0`,
    `max_tokens=128000`, `diff_max_tokens=128000`, `seed=42`
  - grid axes:
    `seq_ratio`, `ltp_noff`, `g_A`, `g_P`, `g_T`
  - CVT profile:
    `hybrid_seq_default`
  - RTLLM problem set:
    `Prob043_RAM`, `Prob045_alu`
  - VerilogEval problem set:
    `Prob153_gshare`, `Prob156_review2015_fancytimer`
- Result overview from `/tmp/qd_rich20x5/...`:
  - RTLLM `Prob043_RAM`:
    - classic best score: `0.44449010410240736`
    - grid:
      `occupied_cells=2/32`, `coverage=0.0625`,
      `qd_score=0.5538087600419216`,
      `best_quality=0.44282189588469034`
    - CVT:
      `occupied_cells=7/16`, `coverage=0.4375`,
      `qd_score=2.2098059043421205`,
      `best_quality=0.44449010410240736`
    - interpretation:
      CVT matches classic on the best elite and dramatically improves archive
      fill plus total archive quality over grid
  - RTLLM `Prob045_alu`:
    - classic best score: `0.4067868453906301`
    - grid:
      `occupied_cells=1/32`, `coverage=0.03125`,
      `qd_score=0.15088639200998752`,
      `best_quality=0.15088639200998752`
    - CVT:
      `occupied_cells=8/16`, `coverage=0.5`,
      `qd_score=0.8971647283001513`,
      `best_quality=0.1581891057231093`
    - interpretation:
      classic still keeps the strongest single elite, but CVT again shows much
      healthier archive fill than grid
  - VerilogEval `Prob153_gshare`:
    - classic best score: `0.1788682750113996`
    - grid:
      `occupied_cells=7/32`, `coverage=0.21875`,
      `qd_score=0.22159468620046935`,
      `best_quality=0.1431034287119163`
    - CVT:
      `occupied_cells=8/16`, `coverage=0.5`,
      `qd_score=0.03473310176867479`,
      `best_quality=0.1442725990926532`
    - interpretation:
      classic still wins single-best quality; both QD modes now fill archive
      space meaningfully, with CVT giving higher coverage and grid giving a
      slightly healthier total archive score under this descriptor setup
  - VerilogEval `Prob156_review2015_fancytimer`:
    - classic best score: `-0.044251681938680516`
    - grid:
      `occupied_cells=1/32`, `coverage=0.03125`,
      `qd_score=-0.21196762495855093`,
      `best_quality=-0.21196762495855093`
    - CVT:
      `occupied_cells=4/16`, `coverage=0.25`,
      `qd_score=-1.1153786401307686`,
      `best_quality=-0.12890970454996659`
    - interpretation:
      this remains difficult for all modes; CVT fills more cells, but the
      archive quality remains net negative under the current setup
- Updated empirical interpretation:
  - richer descriptors strengthen the positive CVT story on RTLLM and confirm
    that low-dimensional reduced-axis runs were under-using the implemented
    descriptor system
  - the richer grid run is still sparse on RTLLM and harder VerilogEval tasks,
    which makes archive observability more important
  - multi-axis grid runs now emit marginals and pairwise projections rather
    than only 2-axis heatmaps
  - this richer run is the direct reason to add per-candidate
    `qd_archive_event.json` plus per-problem `archive_space.json` /
    `archive_space_report.md`

### Stage 9

- Date: `2026-03-13`
- Implementation checkpoint:
  - fixed sequential `grid` defaults so descriptor resolution and runtime
    wiring both use `g_A`, `g_P`, `g_T` for sequential problems
  - extended the shared archive protocol with `cell_id_for(...)`,
    `describe_space()`, and `describe_assignment(...)`
  - added per-candidate `qd_archive_event.json` emission for archive-handled
    successful candidates, including empty-cell fills, elite replacements,
    same-cell non-insertions, and CVT warm-up buffered successes
  - added per-problem `archive_space.json` and `archive_space_report.md`
  - added `src/revolution/qd/artifacts.py` to centralize QD artifact writing
  - added the dedicated guide `docs/qd_map_elites_guide.md` with descriptor
    extraction notes, a QD file map, a one-generation trace, and a full-run
    trace
- Automated tests:
  - `/workspace/.venv/bin/python -m pytest tests/revolution/test_qd_descriptors.py tests/revolution/test_qd_archive.py tests/revolution/test_qd_engine.py`
  - Result: `40 passed in 0.99s`
  - `/workspace/.venv/bin/python -m pytest`
  - Result: `339 passed in 10.93s`
  - `/workspace/.venv/bin/ruff check src/revolution/qd src/revolution/runtime/candidate_evaluator.py tests/revolution/test_qd_descriptors.py tests/revolution/test_qd_archive.py tests/revolution/test_qd_engine.py`
  - Result: `All checks passed!`
  - `/workspace/.venv/bin/python -m pyright src/revolution/qd`
  - Result: `0 errors, 1 warning`
    - warning detail:
      - `src/revolution/qd/descriptors.py`: `yaml` could not be resolved from
        source by pyright
  - `uv tool run ty check src/revolution/qd`
  - Result:
    scoped QD modules are clean aside from the same environment-level `yaml`
    import-resolution warning
- Live validation:
  - preflight command:
    - `curl -s http://host.docker.internal:8000/v1/models`
  - long-token grid artifact smoke:
    - `python scripts/run_backend.py --backend revolution --search_mode revolution_qd --qd_archive_type grid --benchmarks RTLLM --problems Prob043_RAM --api_backend vllm --vllm_host host.docker.internal --vllm_port 8000 --vllm_min_model_len 128000 --model_name /project/cad-team/LX_Semicon/models/openai-gpt-oss-120b --population_size 4 --num_generations 1 --num_workers 1 --candidate_workers 0 --evaluation_mode search_accelerated --accelerated_synthesis_top_k 1 --temperature 1.0 --top_p 1.0 --max_tokens 128000 --diff_max_tokens 128000 --save_path /tmp/qd_stage9_smoke/grid --no-backend_subdir --seed 42`
    - result:
      - vLLM preflight succeeded
      - runner started and config/log files were created
      - no first candidate directory was materialized within the bounded
        observation window, so the run was recorded as blocked rather than
        passed
  - bounded fast-smoke grid validation:
    - `timeout 120s /workspace/.venv/bin/python scripts/run_backend.py --backend revolution --search_mode revolution_qd --qd_archive_type grid --benchmarks RTLLM --problems Prob001_accu --api_backend vllm --vllm_host host.docker.internal --vllm_port 8000 --vllm_min_model_len 128000 --model_name /project/cad-team/LX_Semicon/models/openai-gpt-oss-120b --population_size 1 --num_generations 0 --num_workers 1 --candidate_workers 0 --evaluation_mode search_accelerated --accelerated_synthesis_top_k 1 --temperature 0.3 --top_p 0.95 --max_tokens 128 --diff_max_tokens 128 --save_path /tmp/qd_stage9_fast_smoke/grid_timeout --no-backend_subdir --seed 42`
    - result:
      - vLLM preflight succeeded
      - runner started and config/log files were created
      - timed out after `120s` before the first candidate directory or any
        QD artifact files were materialized
  - bounded fast-smoke CVT validation:
    - `timeout 120s /workspace/.venv/bin/python scripts/run_backend.py --backend revolution --search_mode revolution_qd --qd_archive_type cvt --benchmarks RTLLM --problems Prob001_accu --api_backend vllm --vllm_host host.docker.internal --vllm_port 8000 --vllm_min_model_len 128000 --model_name /project/cad-team/LX_Semicon/models/openai-gpt-oss-120b --population_size 1 --num_generations 0 --num_workers 1 --candidate_workers 0 --evaluation_mode search_accelerated --accelerated_synthesis_top_k 1 --temperature 0.3 --top_p 0.95 --max_tokens 128 --diff_max_tokens 128 --save_path /tmp/qd_stage9_fast_smoke/cvt --no-backend_subdir --seed 42`
    - result:
      - vLLM preflight succeeded
      - runner started and config/log files were created
      - timed out after `120s` before the first candidate directory or any
        QD artifact files were materialized
- Notes:
  - Stage 9 closes the archive-observability gap in the code and in unit
    coverage even though bounded live validation is currently limited by the
    shared endpoint not materializing a first candidate quickly enough
  - the new guide and artifact set are now the recommended way to understand
    or debug QD runs without reverse-engineering `archive_history.jsonl` alone
- Commit:
  - `50fd888e3d` `feat(qd): add archive event logs and space reports`

### Stage 10

- Date: `2026-03-13`
- Implementation checkpoint:
  - added retrospective-analysis-driven runtime-usable profiles:
    - `implemented_structural_fixed_5d`
    - `implemented_structural_compact_3d`
  - added retrospective-derived explicit `grid_axes` bounds for:
    - `seq_ratio`
    - `comb_ratio`
    - `mux_ratio`
    - `adder_ratio`
    - `cell_count_log`
  - found and fixed a real Stage 10 runtime bug:
    grid archive construction ignored `qd_descriptor_profile` when
    `qd_grid_axes` was omitted, so the first refresh-grid attempt silently used
    gain axes instead of the new structural profile
  - `archive_summary.json` and `qd_metrics.json` now record
    `descriptor_profile` and `descriptor_axes`
- Automated tests:
  - `/workspace/.venv/bin/python -m pytest tests/revolution/test_qd_descriptors.py tests/revolution/test_qd_engine.py`
  - Result: `35 passed in 7.82s`
  - `/workspace/.venv/bin/python -m pytest`
  - Result: `343 passed in 12.24s`
  - `/workspace/.venv/bin/ruff check src/revolution/qd/artifacts.py src/revolution/qd/engine.py tests/revolution/test_qd_descriptors.py tests/revolution/test_qd_engine.py`
  - Result: `All checks passed!`
  - `/workspace/.venv/bin/python -m pyright src/revolution/qd`
  - Result: `0 errors, 1 warning`
    - warning detail:
      - `src/revolution/qd/descriptors.py`: `yaml` could not be resolved from
        source by pyright
  - `uv tool run ty check src/revolution/qd`
  - Result: `All checks passed!`
- Live validation:
  - corrected grid-profile smoke:
    - `timeout 1800s /workspace/.venv/bin/python scripts/run_backend.py --backend revolution --search_mode revolution_qd --qd_archive_type grid --qd_descriptor_profile implemented_structural_compact_3d --benchmarks RTLLM --problems Prob043_RAM --api_backend vllm --vllm_host host.docker.internal --vllm_port 8000 --vllm_min_model_len 128000 --model_name /project/cad-team/LX_Semicon/models/openai-gpt-oss-120b --population_size 1 --num_generations 0 --num_workers 1 --candidate_workers 0 --evaluation_mode search_accelerated --accelerated_synthesis_top_k 1 --temperature 0.3 --top_p 0.95 --max_tokens 128000 --diff_max_tokens 128000 --save_path /tmp/qd_rich20x5_refresh_v2/smokes/grid_rtllm_compact_profile --no-backend_subdir --seed 42`
    - result:
      - completed successfully in `613.41s`
      - emitted `archive_summary.json`, `archive_space_report.md`, and
        `qd_archive_event.json`
      - confirmed active axes:
        `comb_ratio`, `adder_ratio`, `cell_count_log`
  - corrected CVT-profile smoke:
    - `timeout 1800s /workspace/.venv/bin/python scripts/run_backend.py --backend revolution --search_mode revolution_qd --qd_archive_type cvt --qd_descriptor_profile implemented_structural_fixed_5d --qd_num_cells 16 --qd_cvt_warmup_successes 4 --benchmarks RTLLM --problems Prob043_RAM --api_backend vllm --vllm_host host.docker.internal --vllm_port 8000 --vllm_min_model_len 128000 --model_name /project/cad-team/LX_Semicon/models/openai-gpt-oss-120b --population_size 1 --num_generations 0 --num_workers 1 --candidate_workers 0 --evaluation_mode search_accelerated --accelerated_synthesis_top_k 1 --temperature 0.3 --top_p 0.95 --max_tokens 128000 --diff_max_tokens 128000 --save_path /tmp/qd_rich20x5_refresh_v2/smokes/cvt_rtllm_fixed_profile --no-backend_subdir --seed 42`
    - result:
      - still running at the time of this checkpoint; do not mark the Stage 10
        bounded-smoke checkbox complete until it emits archive artifacts or a
        clean failed summary
  - refresh rerun root:
    - `/tmp/qd_rich20x5_refresh_v2`
  - interim executive comparison summary:
    - `/tmp/qd_rich20x5_refresh_v2/QD_PROFILE_REFRESH_SUMMARY.md`
  - interim comparison status:
    - all four QD problem directories now have `archive_summary.json`
    - wrapper-level `20 x 5` processes were still running at this checkpoint,
      so the refresh comparison should be treated as an interim snapshot rather
      than a final top-level summary set
- Notes:
  - the retrospective-driven profiles are now truly live in runtime
  - the current refresh snapshots are weaker than the earlier richer/gain-heavy
    baseline on this four-problem corpus, so they should remain explicit
    experimental controls rather than new defaults

### Stage 11

- Date: `2026-03-13`
- Implementation checkpoint:
  - added runtime descriptor extraction for the primary retrospective
    source/AST/netlist family in
    `src/revolution/rtl_descriptor_evaluator.py`
  - synthesis-side metrics now emit `structural_metrics` from synthesized
    netlists in `src/revolution/evaluation.py`
  - candidate enrichment now carries `rtl_metrics` through:
    - `src/revolution/runtime/candidate_evaluator.py`
    - `src/revolution/runtime/cvdp_evaluator.py`
    - `src/revolution/algorithm.py`
    - `src/revolution/qd/engine.py`
  - runtime-supported retrospective profiles now include:
    - `size_control_3d`
    - `timing_control_3d`
    - `wire_assign_if_3d`
    - `size_sharing_3d`
  - QD candidate archive-event artifacts now include `rtl_metrics`
- Automated tests:
  - `/workspace/.venv/bin/python -m pytest tests/revolution/test_rtl_descriptor_evaluator.py tests/revolution/test_structural_evaluator.py tests/revolution/test_candidate_evaluator.py tests/revolution/test_cvdp_evaluator.py tests/revolution/test_qd_descriptors.py tests/revolution/test_qd_engine.py tests/revolution/test_evaluation.py`
  - Result: `84 passed`
  - `/workspace/.venv/bin/python -m pytest`
  - Result: `349 passed`
  - `/workspace/.venv/bin/ruff check src/revolution/rtl_descriptor_evaluator.py src/revolution/evaluation.py src/revolution/qd src/revolution/runtime/structural_evaluator.py src/revolution/runtime/candidate_evaluator.py src/revolution/runtime/cvdp_evaluator.py tests/revolution/test_rtl_descriptor_evaluator.py tests/revolution/test_structural_evaluator.py tests/revolution/test_candidate_evaluator.py tests/revolution/test_cvdp_evaluator.py tests/revolution/test_qd_descriptors.py tests/revolution/test_qd_engine.py tests/revolution/test_evaluation.py`
  - Result: `All checks passed!`
  - `/workspace/.venv/bin/python -m pyright src/revolution/rtl_descriptor_evaluator.py src/revolution/evaluation.py src/revolution/qd/descriptors.py src/revolution/qd/engine.py src/revolution/qd/artifacts.py src/revolution/runtime/structural_evaluator.py src/revolution/runtime/cvdp_evaluator.py`
  - Result: `0 errors, 1 warning`
    - warning detail:
      - `src/revolution/qd/descriptors.py`: `yaml` could not be resolved from
        source by pyright
  - `uv tool run ty check src/revolution/rtl_descriptor_evaluator.py src/revolution/evaluation.py src/revolution/qd src/revolution/runtime/structural_evaluator.py src/revolution/runtime/cvdp_evaluator.py`
  - Result: `All checks passed!`
- Live validation:
  - attempted richer-profile smokes under:
    - `/tmp/qd_stage11_smoke`
    - `/tmp/qd_stage11_smoke_v2`
  - commands passed vLLM preflight and entered the runner, but they did not
    materialize a first candidate directory or archive artifact inside the
    bounded observation window
  - result:
    - treat Stage 11 smoke validation as attempted-but-blocked on the shared
      endpoint, not as a passed completion-grade smoke
- Notes:
  - the runtime rollout is code-complete and covered by tests, but live smoke
    evidence for the new retrospective profiles is still weaker than the
    existing Stage 10 compact/fixed-profile smoke evidence
  - the practical bottleneck remains the shared reasoning-model endpoint rather
    than descriptor-resolution failures or archive-serialization bugs

### Stage 12

- Date: `2026-03-13`
- Implementation checkpoint:
  - extended `src/revolution/qd/visualization.py` so multi-axis grid archives
    now emit:
    - per-axis occupancy marginals
    - per-axis best-quality marginals
    - pairwise occupancy projection heatmaps
    - pairwise quality projection heatmaps
  - preserved the existing 2-axis grid heatmap path unchanged
  - updated `archive_space_report.md` wording in
    `src/revolution/qd/artifacts.py` so multi-axis grid output is described
    accurately
- Automated tests:
  - `/workspace/.venv/bin/python -m pytest tests/revolution/test_qd_engine.py`
  - Result: `24 passed`
  - `/workspace/.venv/bin/ruff check src/revolution/qd/visualization.py src/revolution/qd/artifacts.py tests/revolution/test_qd_engine.py`
  - Result: `All checks passed!`
  - `/workspace/.venv/bin/python -m pyright src/revolution/qd/visualization.py src/revolution/qd/artifacts.py`
  - Result: `0 errors, 0 warnings`
  - `uv tool run ty check src/revolution/qd/visualization.py src/revolution/qd/artifacts.py`
  - Result: `All checks passed!`
- Live validation:
  - no new live vLLM smoke was required for this stage because the change is
    in artifact rendering after archive snapshots already exist
  - regression coverage validates the new files through the existing
    `QDEngine._write_qd_artifacts(...)` path
- Notes:
  - richer grid runs no longer degrade to history-only output when the archive
    has more than 2 axes
  - the remaining visualization gap is higher-level report consumption, not
    raw file generation

### Stage 13

- Date: `2026-03-13`
- Implementation checkpoint:
  - added `src/revolution/simulation_descriptor_evaluator.py` for lightweight
    VCD/activity parsing
  - `src/revolution/evaluation.py` now supports descriptor-gated testbench
    probe injection and returns `vcd_file_path` in simulation results
  - candidate enrichment now carries `dynamic_metrics` through:
    - `src/revolution/runtime/candidate_evaluator.py`
    - `src/revolution/algorithm.py`
    - `src/revolution/qd/engine.py`
  - QD candidate archive-event artifacts now include `dynamic_metrics`
  - runtime-supported exploratory activity profiles now include:
    - `activity_size_3d`
    - `activity_control_3d`
- Automated tests:
  - `/workspace/.venv/bin/python -m pytest tests/revolution/test_simulation_descriptor_evaluator.py tests/revolution/test_qd_descriptors.py tests/revolution/test_evaluation.py tests/revolution/test_candidate_evaluator.py tests/revolution/test_qd_engine.py`
  - Result: `80 passed in 11.21s`
  - `/workspace/.venv/bin/python -m pytest tests/revolution/test_candidate_evaluator_parity.py`
  - Result: `6 passed in 0.73s`
  - `/workspace/.venv/bin/python -m pytest`
  - Result: `354 passed in 12.64s`
  - `/workspace/.venv/bin/ruff check src/revolution/simulation_descriptor_evaluator.py src/revolution/evaluation.py src/revolution/algorithm.py src/revolution/qd/descriptors.py src/revolution/qd/engine.py src/revolution/qd/artifacts.py src/revolution/runtime/candidate_evaluator.py tests/revolution/test_simulation_descriptor_evaluator.py tests/revolution/test_qd_descriptors.py tests/revolution/test_evaluation.py tests/revolution/test_candidate_evaluator.py tests/revolution/test_qd_engine.py`
  - Result: `All checks passed!`
  - `/workspace/.venv/bin/python -m pyright src/revolution/simulation_descriptor_evaluator.py src/revolution/evaluation.py src/revolution/qd/descriptors.py src/revolution/qd/engine.py src/revolution/qd/artifacts.py`
  - Result: `0 errors, 1 warning`
    - warning detail:
      - `src/revolution/qd/descriptors.py`: `yaml` could not be resolved from
        source by pyright
  - `uv tool run ty check src/revolution/simulation_descriptor_evaluator.py src/revolution/evaluation.py src/revolution/qd`
  - Result: `All checks passed!`
- Live validation:
  - attempted bounded activity-profile smoke:
    - `timeout 1800s /workspace/.venv/bin/python scripts/run_backend.py --backend revolution --search_mode revolution_qd --qd_archive_type grid --qd_descriptor_profile activity_control_3d --benchmarks RTLLM --problems Prob001_accu --api_backend vllm --vllm_host host.docker.internal --vllm_port 8000 --vllm_min_model_len 128000 --model_name /project/cad-team/LX_Semicon/models/openai-gpt-oss-120b --population_size 1 --num_generations 0 --num_workers 1 --candidate_workers 0 --evaluation_mode search_accelerated --accelerated_synthesis_top_k 1 --temperature 0.3 --top_p 0.95 --max_tokens 128000 --diff_max_tokens 128000 --save_path /tmp/qd_stage13_smoke/activity_grid_rtllm --no-backend_subdir --seed 42`
    - result:
      - vLLM preflight succeeded
      - runner created config and top-level run-log files
      - no first candidate directory or archive artifact was materialized
        before the bounded observation window, so treat this as
        attempted-but-blocked rather than passed
- Notes:
  - dynamic descriptors are now runtime-real rather than roadmap-only, but
    they remain experimental because their signal quality depends on VCD scope
    filtering and the behavior of the benchmark testbench
  - the rollout intentionally keeps activity extraction descriptor-gated so
    classic REvolution and non-dynamic QD runs do not pay the waveform cost
  - focused pyright validation was kept on the new dynamic-descriptor surface;
    broader legacy typing debt in `algorithm.py` and
    `runtime/candidate_evaluator.py` remains tracked separately
- Commit:
  - `6975cfdb48` `feat(qd): add dynamic activity descriptor extraction`

### Stage 14

- Date: `2026-03-13`
- Implementation checkpoint:
  - promoted the strongest already-runtime-supported second-wave retrospective
    combinations into builtin profiles:
    - `wire_ctrl_assign_3d`
    - `wire_if_math_3d`
    - `wire_always_ternary_3d`
    - `assign_always_math_3d`
  - added retrospective-grounded explicit grid-axis specs for:
    - `always_count`
    - `case_count`
    - `math_op_ast_count`
  - added per-problem descriptor diagnostics:
    - `descriptor_health.json`
    - `descriptor_health_report.md`
  - `archive_summary.json` and `qd_metrics.json` now expose the new
    descriptor-health artifact filenames for downstream tooling
- Automated tests:
  - `/workspace/.venv/bin/python -m pytest tests/revolution/test_qd_descriptors.py tests/revolution/test_qd_engine.py`
  - Result: `38 passed in 12.12s`
  - `/workspace/.venv/bin/ruff check src/revolution/qd tests/revolution/test_qd_descriptors.py tests/revolution/test_qd_engine.py`
  - Result: `All checks passed!`
  - `/workspace/.venv/bin/python -m pytest`
  - Result: `354 passed in 13.17s`
  - `/workspace/.venv/bin/python -m pyright src/revolution/qd`
  - Result: `0 errors, 1 warning`
    - warning detail:
      - `src/revolution/qd/descriptors.py`: `yaml` could not be resolved from
        source by pyright
  - `uv tool run ty check src/revolution/qd`
  - Result: `All checks passed!`
- Live validation:
  - attempted bounded second-wave profile smoke:
    - `timeout 900s /workspace/.venv/bin/python scripts/run_backend.py --backend revolution --search_mode revolution_qd --qd_archive_type grid --qd_descriptor_profile wire_ctrl_assign_3d --benchmarks RTLLM --problems Prob043_RAM --api_backend vllm --vllm_host host.docker.internal --vllm_port 8000 --vllm_min_model_len 128000 --model_name /project/cad-team/LX_Semicon/models/openai-gpt-oss-120b --population_size 1 --num_generations 0 --num_workers 1 --candidate_workers 0 --evaluation_mode search_accelerated --accelerated_synthesis_top_k 1 --temperature 0.3 --top_p 0.95 --max_tokens 128000 --diff_max_tokens 128000 --save_path /tmp/qd_stage14_smoke/wire_ctrl_assign_grid_rtllm --no-backend_subdir --seed 42`
    - result:
      - vLLM preflight succeeded
      - runner created config/log files plus `problem_run.log`
      - no first candidate directory or archive artifact materialized in the
        bounded observation window, so treat this as attempted-but-blocked on
        the shared endpoint rather than a descriptor-resolution failure
- Notes:
  - this stage intentionally focuses on making second-wave retrospective
    profiles executable and diagnosable before spending more vLLM budget on
    longer reruns
  - descriptor-health reporting is derived from archive-handled successful
    candidates plus current archive elites, so it is a debugging aid for live
    runs rather than a full replacement for the offline corpus-wide
    retrospective analysis

### Stage 15

- Date: `2026-03-13`
- Implementation checkpoint:
  - `scripts/backend_comparison_report.py` now loads
    `descriptor_health.json` when present and renders a dedicated
    `QD Descriptor Health` section
  - `scripts/archive_baseline.py` now preserves:
    - `descriptor_health.json`
    - `descriptor_health_report.md`
    in archived QD summary payloads
- Automated tests:
  - `/workspace/.venv/bin/python -m pytest tests/scripts/test_backend_comparison_report.py tests/scripts/test_archive_baseline.py`
  - Result: `16 passed in 1.26s`
  - `/workspace/.venv/bin/ruff check scripts/backend_comparison_report.py scripts/archive_baseline.py tests/scripts/test_backend_comparison_report.py tests/scripts/test_archive_baseline.py`
  - Result: `All checks passed!`
- Live validation:
  - not run for Stage 15
  - this stage is report/archive consumption only
  - the descriptor-health report section was later exercised on the fixed redo
    outputs under
    `/tmp/qd_rich20x5_redo_full_fixed/20260314_115920`
- Notes:
  - this closes a concrete follow-up from Stage 14 by making the new
    descriptor-health sidecars visible in the normal repo reporting workflow
  - the remaining gap is no longer basic report visibility; it is repeated-seed
    and broader-benchmark evidence for the newer profile ladder

### Stage 16

- Date: `2026-03-13`
- Implementation checkpoint:
  - added `scripts/run_qd_retrospective_redo_vllm.sh`
  - the new harness encodes:
    - the same four-design corpus used in `/tmp/qd_rich20x5`
    - `population_size=20`
    - `num_generations=5`
    - `max_tokens=128000`
    - `diff_max_tokens=128000`
    - repeatable preset matrices:
      - `refresh`
      - `follow-on`
      - `full`
  - each suite run now automatically emits a local
    `backend_comparison_report.py` markdown after the matrix finishes
- Automated tests:
  - `/workspace/.venv/bin/python -m pytest tests/scripts/test_run_qd_retrospective_redo_vllm.py`
  - Result: `1 passed in 0.08s`
  - `/workspace/.venv/bin/ruff check tests/scripts/test_run_qd_retrospective_redo_vllm.py`
  - Result: `All checks passed!`
  - `bash -n scripts/run_qd_retrospective_redo_vllm.sh`
  - Result: clean
- Live validation:
  - launched the fresh long-budget redo matrix with the new harness
  - exact launch:
    - `VLLM_HOST=host.docker.internal VLLM_PORT=8000 REDO_SAVE_PATH=/tmp/qd_rich20x5_redo_full bash scripts/run_qd_retrospective_redo_vllm.sh --preset full --suite matrix`
  - launch time:
    - `2026-03-13T18:20:07Z`
  - original run root:
    - `/tmp/qd_rich20x5_redo_full/20260313_181943`
  - final status:
    - the harness completed, but this root is now retained only as an invalid
      regression case study because Stage 17 later proved it compiled the DUT
      top instead of the testbench top during simulation
- Notes:
  - this stage now has a real launched redo root rather than only harness
    scaffolding
  - fixed a real usability defect after launch:
    `scripts/run_qd_retrospective_redo_vllm.sh` initially had mode `644`, so
    direct invocation failed with `Permission denied` until the executable bit
    was restored
  - validated the direct-invocation path with:
    - `VLLM_HOST=host.docker.internal VLLM_PORT=8000 scripts/run_qd_retrospective_redo_vllm.sh --dry-run`
  - the later fixed redo under `/tmp/qd_rich20x5_redo_full_fixed/20260314_115920`
    supersedes this original root for all numeric comparison

### Stage 17

- Date: `2026-03-14`
- Implementation checkpoint:
  - fixed the simulation-top regression that invalidated
    `/tmp/qd_rich20x5_redo_full/20260313_181943`
  - `ProblemContext` now carries `testbench_top_module`, and runtime helpers
    now distinguish:
    - synthesis top:
      `resolve_synthesis_top_module_name(...)`
    - simulation top:
      `resolve_testbench_top_module(...)`
  - `ProblemSpec` now records `testbench_top_module` alongside synthesis
    `top_module`
  - `CandidateEvaluator` now uses:
    - `testbench_top_module_name` for pre-synthesis simulation and dynamic
      metric extraction
    - `synthesis_top_module_name` for synthesis/PPA
  - the legacy `EoHEngine` path in `src/revolution/algorithm.py` now uses the
    same split and no longer passes DUT top names to Icarus simulation
  - RealBench adapter support now accepts `testbench_top_module` from the
    manifest and otherwise falls back to testbench parsing
- Automated tests:
  - `/workspace/.venv/bin/python -m pytest tests/revolution/test_problem_spec.py tests/revolution/test_candidate_evaluator.py tests/revolution/test_candidate_evaluator_parity.py tests/revolution/test_revolution_backend.py tests/scripts/test_run_backend.py`
  - Result: `44 passed in 1.43s`
  - `/workspace/.venv/bin/python -m pytest`
  - Result: `360 passed in 13.60s`
  - `/workspace/.venv/bin/ruff check src/revolution/runtime src/revolution/algorithm.py tests/revolution/test_problem_spec.py tests/revolution/test_candidate_evaluator.py tests/revolution/test_candidate_evaluator_parity.py tests/revolution/test_revolution_backend.py tests/scripts/test_run_backend.py`
  - Result: `All checks passed!`
  - `/workspace/.venv/bin/python -m pyright src/revolution/runtime/problem_context.py src/revolution/runtime/problem_spec.py src/revolution/runtime/candidate_evaluator.py src/revolution/runtime/realbench_adapter.py src/revolution/algorithm.py`
  - Result:
    red on pre-existing `algorithm.py` and `candidate_evaluator.py` typing debt;
    no new syntax/type regression was introduced by the split-top fix
  - `uv tool run ty check src/revolution/runtime/problem_context.py src/revolution/runtime/problem_spec.py src/revolution/runtime/candidate_evaluator.py src/revolution/runtime/realbench_adapter.py src/revolution/algorithm.py`
  - Result:
    red on the same pre-existing `algorithm.py` and `candidate_evaluator.py`
    typing debt; no new split-top-specific breakage found
- Live validation:
  - original invalid redo root:
    - `/tmp/qd_rich20x5_redo_full/20260313_181943`
    - this root is **invalid for numeric comparison**
    - reason: simulation compiled the DUT top instead of the testbench top
      (`-s RAM`, `-s alu`, `-s TopModule`) which caused blanket functionality
      failure and empty simulation stdout
  - RTLLM classic sentinel:
    - root:
      `/tmp/qd_topfix_sentinels/rtllm_classic/_project_cad-team_LX_Semicon_models_openai-gpt-oss-120b`
    - summary:
      `/tmp/qd_topfix_sentinels/rtllm_classic/_project_cad-team_LX_Semicon_models_openai-gpt-oss-120b/20260314_115541_revolution_summary_results.txt`
    - evidence:
      compile command restored to `iverilog ... -s tb ...`
      and the run completed with a meaningful success result:
      `Prob043_RAM,...,0.39049514834774496`
  - VerilogEval classic sentinel:
    - root:
      `/tmp/qd_topfix_sentinels/verilogeval_classic/_project_cad-team_LX_Semicon_models_openai-gpt-oss-120b`
    - evidence:
      `/tmp/qd_topfix_sentinels/verilogeval_classic/_project_cad-team_LX_Semicon_models_openai-gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob153_gshare/problem_run.log`
      now shows `iverilog ... -s tb ...`, and
      `Gen0/Prob153_gshare_sample1_initial/code_simulation.log`
      reports real harness output:
      `Mismatches: 0 in 1083 samples`
  - RTLLM QD sentinel:
    - root:
      `/tmp/qd_topfix_sentinels/rtllm_qd_grid/_project_cad-team_LX_Semicon_models_openai-gpt-oss-120b`
    - summary:
      `/tmp/qd_topfix_sentinels/rtllm_qd_grid/_project_cad-team_LX_Semicon_models_openai-gpt-oss-120b/RTLLM/Prob043_RAM/archive_summary.json`
    - evidence:
      compile command restored to `iverilog ... -s tb ...`
      and the run emitted meaningful QD artifacts, including:
      `archive_space_report.md`, `archive_summary.json`,
      and `descriptor_health.json`
  - replacement full redo launch:
    - exact launch:
      `VLLM_HOST=host.docker.internal VLLM_PORT=8000 REDO_SAVE_PATH=/tmp/qd_rich20x5_redo_full_fixed bash scripts/run_qd_retrospective_redo_vllm.sh --preset full --suite matrix`
    - launch time:
      `2026-03-14T11:59:20Z`
    - fixed run root:
      `/tmp/qd_rich20x5_redo_full_fixed/20260314_115920`
    - completed comparison outputs:
      - `/tmp/qd_rich20x5_redo_full_fixed/20260314_115920/combined_backend_comparison.md`
      - `/tmp/qd_rich20x5_redo_full_fixed/20260314_115920/analysis/classic_vs_qd/results/report.md`
    - key findings:
      - `cvt_size_control` is the best balanced archive-health/QD-score option
        in the fixed redo:
        `mean coverage = 39.05%`, `mean QD score = 1.0268`
      - `cvt_struct` is the strongest score/frontier-oriented QD option in the
        fixed redo analysis:
        `macro final best score = 24.86%`,
        `macro final selectable hyperarea = 0.085`
      - `grid_struct` is the best grid control:
        `mean coverage = 25.00%`,
        `macro cumulative hyperarea = 0.167`
      - classic remains the safest non-QD baseline:
        `macro synthesis success = 48.75%`
- Notes:
  - the root cause was not a QD-profile failure; it invalidated `classic`,
    `grid`, and `cvt` equally because the functional harness never actually ran
  - the fixed redo now provides the comparative reference that should be used
    in docs and merge guidance:
    - prefer `cvt` over `grid` for most QD runs
    - use `implemented_structural_fixed_5d` / `cvt_struct` when
      score/frontier quality is the main objective
    - use `size_control_3d` / `cvt_size_control` when archive health,
      coverage, and QD score are the main objective
    - use `implemented_structural_compact_3d` / `grid_struct` as the main grid
      control

### Stage 18

- Date: `2026-03-16`
- Implementation checkpoint:
  - completed a merge-readiness cleanup pass on the QD/touched surface before
    merge into `wip/journal-extension-2026`
  - refreshed stale docs so they now point to the finished fixed redo instead
    of the earlier `refresh_v2` checkpoint
  - expanded `docs/qd_map_elites_guide.md` with:
    - mode comparison tables
    - descriptor-family tables
    - profile guidance tables
    - Mermaid diagrams for one-generation, whole-run, and descriptor-pipeline
      flows
  - added missing docstrings across the public QD/runtime symbols touched by
    this branch
  - removed branch-local unused `type: ignore` comments from
    `src/revolution/backends/revolution_backend.py`
  - tightened `src/revolution/runtime/candidate_evaluator.py` typing so the
    touched-surface `pyright` and `ty` checks are green again
- Automated validation:
  - `git diff --check wip/journal-extension-2026...HEAD`
  - Result: clean
  - `python` AST docstring scan on the touched QD/runtime surface
  - Result: `NO_MISSING_DOCSTRINGS`
  - `/workspace/.venv/bin/python -m pytest`
  - Result: `376 passed, 4 skipped in 20.20s`
  - `/workspace/.venv/bin/ruff check src/revolution/qd src/revolution/runtime/problem_context.py src/revolution/runtime/problem_spec.py src/revolution/runtime/candidate_evaluator.py src/revolution/runtime/structural_evaluator.py src/revolution/rtl_descriptor_evaluator.py src/revolution/simulation_descriptor_evaluator.py src/revolution/backends/revolution_backend.py src/revolution/evaluation.py scripts/run_backend.py scripts/backend_comparison_report.py scripts/archive_baseline.py tests/revolution/test_qd_archive.py tests/revolution/test_qd_descriptors.py tests/revolution/test_qd_engine.py tests/revolution/test_qd_scheduler.py tests/revolution/test_qd_scoring.py tests/revolution/test_problem_spec.py tests/revolution/test_candidate_evaluator.py tests/revolution/test_candidate_evaluator_parity.py tests/revolution/test_revolution_backend.py tests/revolution/test_evaluation.py tests/scripts/test_run_backend.py tests/scripts/test_backend_comparison_report.py tests/scripts/test_archive_baseline.py tests/scripts/test_run_qd_retrospective_redo_vllm.py`
  - Result: `All checks passed!`
  - `/workspace/.venv/bin/python -m pyright src/revolution/qd src/revolution/runtime/problem_context.py src/revolution/runtime/problem_spec.py src/revolution/runtime/candidate_evaluator.py src/revolution/runtime/structural_evaluator.py src/revolution/rtl_descriptor_evaluator.py src/revolution/simulation_descriptor_evaluator.py src/revolution/backends/revolution_backend.py scripts/run_backend.py scripts/backend_comparison_report.py scripts/archive_baseline.py`
  - Result: `0 errors, 2 warnings`
  - warning details:
    - `scripts/run_backend.py`: `tqdm` source-resolution only
    - `src/revolution/qd/descriptors.py`: `yaml` source-resolution only
  - `uv tool run ty check src/revolution/qd src/revolution/runtime/problem_context.py src/revolution/runtime/problem_spec.py src/revolution/runtime/candidate_evaluator.py src/revolution/runtime/structural_evaluator.py src/revolution/rtl_descriptor_evaluator.py src/revolution/simulation_descriptor_evaluator.py src/revolution/backends/revolution_backend.py scripts/run_backend.py scripts/backend_comparison_report.py scripts/archive_baseline.py`
  - Result: `All checks passed!`
- Merge posture:
  - local merge base against `wip/journal-extension-2026` remains:
    `447c0128225ac3cdb91c41f9559bda208d3065f5`
  - local left/right count:
    `0 54`
  - interpretation:
    this branch is a straight descendant of the merge target locally, so merge
    conflict risk is low unless the target branch changes remotely before merge
- Live validation:
  - none in this cleanup pass by design
  - no new vLLM experiments were run here because the branch already has fixed
    redo evidence and this pass was limited to docs, tests, cleanup, and
    docstrings
  - the fix is now covered by regression tests that assert simulation uses the
    harness top while synthesis still uses the mapped DUT top

## Debt Review

### Stage 0

- No code changes yet.
- Main architecture risk to watch:
  avoid duplicating success-state truth between archive and a flat pool.
- Main integration risk to watch:
  avoid forcing archive-specific logic deep into classic `revolution` paths
  where a clean `search_mode` split is sufficient.

### Stage 1

- Kept the classic `revolution` engine path intact.
- Avoided early engine forking by landing typed config/capability scaffolding
  before archive logic.
- The QD surface is broad, but still mostly passive; behavioral changes are
  limited to validation and metadata until Stage 3.
- Follow-up risk to watch:
  the large QD config surface should eventually be grouped into dedicated
  config objects once the execution path exists, otherwise `run_backend.py`
  argument plumbing will become noisy.

### Stage 2

- The descriptor registry is intentionally lightweight and declarative, which
  keeps experimentation easy and avoids prematurely over-abstracting archive
  logic before Stage 3.
- Structural extraction is currently based on Yosys-like payloads rather than
  a direct subprocess integration. That is sufficient for unit-tested substrate
  work now, but Stage 3 or 4 will need actual runtime wiring from synthesis
  artifacts.
- Candidate evaluation enrichment is centralized so later archive logic does
  not need to recompute code hashes, quality score aliases, or repair score.

### Stage 3

- The archive and scheduler substrate are intentionally separate from the
  existing engine until the runner can be wired without duplicating major
  portions of `EoHEngine`.
- Grid geometry is explicit and easy to test, which is the intended low-risk
  first step before CVT warm-up/freeze logic is introduced.
- The new `QDEngine` reuses a meaningful amount of existing prompt/eval code,
  but there is still duplicated offspring-materialization logic. That seam
  should be refactored once the grid runtime is stable enough to avoid
  spreading engine-loop duplication into CVT work.
- The current grid runtime now exposes both a bounded per-cell reservoir and a
  lightweight grid-bin specification loading path. The remaining gap is not
  configurability itself, but broader archive parity, reporting, and CVT
  geometry support.
  - The `ProblemSpec` phase-default data model is now consumed by `QDEngine`, but
  the resolution logic still lives only in the QD engine rather than behind a
  shared reusable helper. That is acceptable for now, but it is still a seam
  to watch if classic and QD mode continue to diverge in prompt routing.
- New QD helpers added in this branch now have type hints and short docstrings
  for the public descriptor/grid-spec surface, but the broader repo still has
  uneven docstring/type coverage in older modules.
- Physical descriptor plumbing is now better grounded because the legacy
  synthesis evaluator emits a machine-readable metrics sidecar and returns
  `physical_metrics`. The remaining gap is metric richness, not total absence:
  utilization is reliable now, while deeper OpenROAD metrics still depend on
  what the report text exposes.
- The Stage 3 smoke gate is now satisfied. Minimal accelerated grid runs on
  RTLLM and VerilogEval complete end-to-end; the remaining Stage 3 debt is
  architectural cleanup, not runtime reachability.

### Stage 4

- CVT archive logic now lives behind the same archive-selection surface as
  grid, which removes an obvious config/runtime mismatch from the branch.
- The CVT implementation deliberately keeps scaling frozen after warm-up. That
  matches the original intent and avoids archive-geometry drift.
- The main remaining debt is still architectural rather than geometric:
  `QDEngine` duplicates request/materialization flow that should eventually be
  shared with `EoHEngine`.
- Descriptor richness remains partly aspirational in the runtime path. The
  archive can consume structural or physical axes, but the legacy engine path
  still surfaces gains more reliably than deeper synthesis-derived metrics.
- The Stage 4 smoke gate is now satisfied under bounded accelerated settings.
  The remaining Stage 4 gap is usefulness on harder runs, not basic CVT
  execution.

### Stage 7

- The engine now emits the baseline archive-state files without requiring the
  reporting scripts to infer archive shape from legacy summaries.
- The reporting and archive-packaging scripts now consume the new files as
  first-class inputs, which closes the earlier `archive_summary.json`
  double-counting bug and prevents `candidate_core` archives from silently
  dropping QD sidecars or plots.
- The new visualization module is intentionally lightweight and runtime-local.
  That is a good first step, but it adds another place where plotting logic now
  exists, so future cleanup should decide whether QD-specific visualization
  stays engine-local or gets moved behind a broader reporting interface.
- The largest remaining debt is still the `EoHEngine` / `QDEngine` seam rather
  than artifact plumbing.

### Stage 5

- The new QD operators are intentionally implemented inside `QDEngine` to keep
  QD-specific prompt logic from spreading further into the legacy engine.
- This is a pragmatic debt tradeoff: the branch gains the missing operator
  semantics now, but the duplicated engine/prompt seam remains and still needs
  cleanup before the architecture is considered clean.
- The Stage 5 whole-heavy and diff-heavy smoke requirement is now satisfied,
  but those runs should be treated as routing validation rather than evidence
  of QD quality improvement because the archives stayed empty under short
  token budgets.

### Stage 6

- The new RealBench adapter is intentionally manifest-based and lightweight.
  That keeps the branch independent of a vendored dataset, but it also means
  some benchmark semantics now live in a side manifest contract that must stay
  documented if the dataset is added later.
- The `ProblemSpec.prompt_text` / `benchmark_root` initialization fix reduces a
  real engine-coupling bug for JSONL-backed tasks, but it also highlights the
  broader seam debt: `EoHEngine` still assumes standard benchmark layouts in
  several deeper paths besides prompt loading.
- `revolution` now supports the `cvdp` discovery path, which matches the plan,
  but the live smoke still times out before giving strong end-to-end evidence.
- The Stage 6 code itself is documented and typed at the public-helper level,
  but the branch still does not have uniform docstring/type coverage in the
  older engine modules, especially around `algorithm.py`.

### Stage 8

- The new smoke harness is a cleanup win because it replaces scattered
  one-off smoke commands with one script and one dry-run test.
- The branch still carries the bigger unresolved debt:
  `QDEngine` still duplicates some higher-level request-bookkeeping and
  generation-loop behavior, even though the lower-level offspring
  materialization seam is now shared with `EoHEngine`.
- Validation debt is now explicit rather than vague: the matrix is runnable and
  reproducible.
- The completion-grade bounded smoke gap is now closed.
- The remaining validation gap is quality-oriented: on harder RTLLM and
  VerilogEval problems with short budgets, classic, grid, and CVT all still
  fail before generating successful archive occupants.

### Stage 9

- The new `src/revolution/qd/artifacts.py` module is a targeted cleanup rather
  than abstraction sprawl: it centralizes archive-artifact writing that would
  otherwise keep inflating `QDEngine`.
- Archive introspection now belongs to the archive objects themselves through
  `describe_space()` and `describe_assignment(...)`, which is the right
  ownership boundary for grid/CVT geometry details.
- The new artifact surface does increase per-run output volume. Future
  large-budget studies should watch for output bloat and decide whether older
  intermediate files need optional pruning.
- The biggest remaining debt is still shared-engine cleanup and older
  `algorithm.py` typing/documentation debt, not the new archive-observability
  layer.

### Stage 10

- The Stage 10 bug fix is small but important: profile selection now behaves
  the way the docs, config, and experiment commands already implied it should.
- The remaining debt is empirical, not structural:
  the retrospective-driven structural profiles are now reproducible, but they
  are not yet strong enough on this corpus to justify any default change.
- Long-budget live validation is also expensive enough that full `20 x 5`
  refresh matrices remain multi-hour jobs; the plan should continue to
  distinguish bounded profile-smoke evidence from full experiment evidence.

### Stage 11

- The new retrospective descriptor rollout adds one focused evaluator module
  (`src/revolution/rtl_descriptor_evaluator.py`) instead of scattering source-
  and AST-level heuristics across multiple unrelated runtime files.
- Structural metrics now have two live runtime sources:
  report/sidecar extraction and synthesized-netlist extraction. That is useful
  but means those paths need to stay aligned to avoid silent drift.
- The new descriptor family is intentionally heuristic and lightweight. That is
  appropriate for this stage, but the branch should continue treating these
  axes as experimental until longer live evidence accumulates.
- The main remaining debt is empirical and endpoint-related rather than
  architectural: bounded live smokes for these new profiles still stall before
  first-candidate artifact materialization on the shared endpoint.

### Stage 12

- The multi-axis visualization follow-through stays within the existing
  `qd/visualization.py` and `qd/artifacts.py` surface instead of adding a
  second report-generation layer.
- The new plots increase artifact count for higher-dimensional grid runs, so
  future archive packaging and comparison tooling should decide which of those
  files are primary outputs versus debug-only assets.
- The remaining debt is now on report consumption and summarization, not on
  raw multi-axis plot generation.

### Stage 13

- The new dynamic-descriptor rollout is deliberately small in structure:
  one focused evaluator (`src/revolution/simulation_descriptor_evaluator.py`)
  plus descriptor-gated wiring through existing evaluation paths.
- The main remaining debt is empirical rather than structural:
  the current VCD probe path dumps from the active testbench hierarchy, so
  descriptor quality depends on how cleanly DUT-local signals can be separated
  from testbench-local activity on each benchmark.
- The rollout adds another descriptor family but avoids broad abstraction
  growth by reusing the same `descriptor_requirements(...)` gating pattern
  already used for RTL/AST/netlist metrics.

### Stage 14

- The second-wave retrospective rollout intentionally stays config/artifact
  focused: it adds more executable profiles and better diagnostics without
  changing global defaults or introducing another descriptor-specific runtime
  framework.
- The new `descriptor_health` artifacts are a deliberate debt-reduction move:
  they surface axis-collapse and zero-signal behavior directly from the run
  tree, which reduces reliance on ad hoc offline notebooks for basic QD
  debugging.
- Remaining debt is empirical and downstream-facing:
  the new profiles still need live comparison runs, and report consumers do not
  yet aggregate `descriptor_health` across problems or backends.

### Stage 15

- Stage 15 deliberately extends existing scripts instead of adding new report
  entry points, which keeps the branch's reporting surface coherent.
- The remaining debt is aggregation depth rather than missing plumbing:
  descriptor-health is now visible in backend comparison reports and archived
  summaries, but there is still no higher-order trend summary across multiple
  experiment roots or repeated runs.

### Stage 16

- The new rerun harness keeps the branch from accumulating more experimental
  debt through copy-pasted shell history.
- Remaining debt is still empirical:
  the harness exists, but the branch still needs the long-budget rerun results
  themselves before any new default or profile recommendation should change.

### Stage 17

- The split-top fix removes a real correctness regression rather than adding
  new feature surface. This is debt repayment, not scope growth.
- Remaining debt is now mostly historical and empirical:
  - the invalid redo root must remain excluded from numeric comparison
  - repeated-seed evidence is still absent, so the fixed redo should be treated
    as directional rather than statistical
  - broader legacy repo-wide type and lint debt still exists outside this
    branch's touched surface

### Stage 18

- The merge-readiness pass deliberately stayed on the touched QD/runtime
  surface instead of widening into unrelated repo-wide cleanup, which keeps the
  branch reviewable and lowers merge risk.
- The remaining debt after this pass is now mostly beyond the branch's
  immediate merge goal:
  - repo-wide old script lint debt outside the touched surface
  - broader legacy typing debt outside the targeted validation scope
  - repeated-seed or broader-benchmark evidence for the new QD profile ladder
  - future benchmark/runtime expansion beyond the current QD branch scope

## Intent Alignment Review

### Stage 0

- Current branch state matches intended starting point.
- Plan preserves both archive backends, configurable descriptors, and
  per-phase generation-mode flexibility.
- Grid-first implementation order is aligned with the debugging strategy while
  keeping CVT parity as an explicit requirement.

### Stage 1

- The implementation still matches the intended architecture:
  classic REvolution remains unchanged, while QD mode now has a typed entry
  surface instead of ad-hoc future flags.
- `ProblemSpec` captures benchmark defaults for descriptor profile, quality
  mode, and per-phase generation-mode preferences without hardcoding those
  choices directly into the backend runner.
- No success-side archive state has been introduced yet, so there is no risk
  of archive/pool source-of-truth drift at this stage.

### Stage 2

- The scoring implementation now matches the intended research framing:
  maximize weighted normalized PPA gains while also exposing the three gains
  independently for archive descriptors.
- Descriptor configuration remains open for empirical iteration, which matches
  the paper-oriented requirement to test new feature sets rather than locking
  into only `seq_ratio`, `mux_ratio`, and `ltp_noff`.
- The current implementation still stops short of archive behavior, so there is
  no divergence yet from the planned grid-first then CVT rollout.

### Stage 3

- The linear fail-share helper exactly matches the planned budgeting rule and
  reaches zero at the target fill fraction.
- The archive replacement semantics already match the intended MAP-Elites
  contract: empty-cell insert, occupied-cell replace only on higher quality.
- The branch still honors the intended “archive as success truth” direction,
  and `success_view` is now materially closer to the original plan because it
  combines archive elites with a small bounded per-cell reservoir rather than
  being elite-only.
- Benchmark-specific phase-generation defaults now affect runtime `auto`
  resolution, which brings the implemented diff-flexibility story materially
  closer to the original intent.
- Grid experiments are now materially closer to the original intent because
  structural and physical axes can carry explicit bin/bounds settings from the
  descriptor config file instead of relying only on uniform gain-axis defaults.
- The most important remaining work is broader live validation, richer
  QD-specific operators, CVT parity, and reducing `QDEngine` loop duplication
  before the architecture hardens further.

### Stage 4

- The branch is now closer to the original intent because both `grid` and
  `cvt` exist as real runtime archive choices instead of one being config-only.
- The CVT warm-up/freeze implementation is aligned with the original plan's
  requirement to avoid moving cell boundaries throughout the run.
- The branch still has an intent gap around descriptor realism: the design
  allows structural/physical axes, but the end-to-end runtime still needs
  better evaluator-side metric plumbing before those axes are equally strong in
  live runs.
- The remaining divergence is therefore acceptable but explicit: CVT geometry
  is implemented, while reporting parity and richer descriptor/evaluator
  integration remain staged follow-through.

### Stage 7

- The branch now partially satisfies the original “archive evolution as a
  first-class output” goal because raw archive-state files are emitted from the
  runtime itself.
- The branch is now much closer to the original intent because downstream
  consumption has caught up: comparison reports, baseline archives, and runtime
  plots now treat the QD sidecars as primary artifacts.
- The remaining intent gap is validation and breadth rather than core design:
  the new outputs exist, but the branch still needs successful live smoke
  completion, broader benchmark coverage, and deeper visualization/reporting
  polish before the feature can be called complete.

### Stage 5

- The branch is now materially closer to the original intent because fill-phase
  QD search no longer relies only on generic exploration; it has explicit
  targeted mutation and diverse fusion operators.
- The remaining intent gap is validation, not architecture: the operators are
  present and routed, but the branch still lacks live smoke evidence showing
  them behaving well on long-context runs.

### Stage 6

- The branch is now closer to the original benchmark-scope intent because
  `revolution_qd` can participate in the existing `cvdp` subset path and a
  concrete RealBench module adapter contract exists.
- The RealBench part is still intentionally partial: fixture-backed adapter
  coverage exists, but no checked-in dataset means the branch cannot yet claim
  live RealBench execution evidence.
- The CVDP smoke progression is meaningful: the branch moved from an immediate
  prompt-path crash to a live run that reaches the problem loop before timing
  out. That is still not completion-grade, but it is an appropriate direction
  of travel rather than a divergence from the original plan.

### Stage 8

- The validation workflow is now closer to the original intent because there is
  a concrete repeatable QD smoke matrix rather than only hand-written example
  commands in the plan.
- The remaining gap is practical rather than conceptual: the smoke matrix runs
  against the real shared vLLM endpoint, but the jobs still time out before the
  branch can claim completion-grade live success evidence.

### Stage 9

- The branch is now closer to the original QD research intent because archive
  behavior is inspectable per candidate and per problem rather than only at the
  coarse archive-summary level.
- The sequential-grid default fix better aligns default archive behavior with
  the intended preservation of separate power, area, and timing specialists on
  sequential problems.
- The remaining gap is now mostly empirical rather than architectural:
  bounded live artifact validation is blocked by slow first-candidate
  materialization on the shared endpoint, but the code and test surface are now
  aligned with the intended observability model.

### Stage 10

- The branch now matches the Stage 10 intent more closely because the adopted
  retrospective profiles are not just documented; they are runtime-selectable
  and verified by smoke evidence.
- The first refresh-grid attempt diverged from intent because the structural
  profile was silently ignored at runtime. That divergence was inappropriate,
  was found by inspecting the emitted archive-space reports, and is now fixed.
- The current interim refresh results suggest the retrospective simulation
  ranking does not transfer cleanly to the live long-context runtime at this
  budget. That is an empirical outcome, not an architectural failure, and the
  plan now records it explicitly instead of forcing a premature default change.

### Stage 11

- Stage 11 moves the branch closer to the original QD intent because the first
  retrospective “future” descriptor family is now part of the live runtime
  instead of only offline analysis artifacts.
- The rollout still respects the original configurability goal: the new axes
  arrive behind the existing descriptor-profile and axis-selection surfaces
  rather than hardcoding a new archive policy.
- Classic REvolution remains comparable because the new RTL/AST/netlist metric
  extraction is only activated when the selected QD axes actually require it.
- The remaining alignment gap is validation breadth, not architecture:
  unit/integration evidence is strong, but live smoke evidence for the new
  profiles is still thinner than for the earlier Stage 10 structural controls.

### Stage 12

- Stage 12 closes an explicit roadmap item from the retrospective-analysis
  follow-through: richer grid runs are now visually inspectable even when the
  archive has more than 2 axes.
- The implementation stays aligned with the original observability intent by
  reusing the existing archive-artifact path instead of inventing a separate
  visualization-only workflow.
- The remaining intent gap is presentation quality in downstream reports, not
  the absence of multi-axis grid diagnostics themselves.

### Stage 13

- Stage 13 moves the branch closer to the original descriptor roadmap because
  the first dynamic/activity descriptor family is now part of the live runtime
  rather than only a future note in the plan.
- The rollout still respects the original configurability goal:
  activity extraction only activates when the selected archive axes require it,
  so classic REvolution remains comparable and unaffected by default.
- The remaining alignment gap is validation breadth rather than architecture:
  the branch now supports activity descriptors end-to-end, but their archive
  usefulness still needs bounded live smokes and longer-budget experiments.

### Stage 14

- Stage 14 stays aligned with the retrospective-analysis intent by making the
  strongest already-runtime-supported second-wave combinations selectable
  without inventing a new off-branch experiment harness.
- The new `descriptor_health` files also improve intent alignment because they
  expose exactly the sort of axis-collapse problem that the retrospective
  analysis found in the earlier grid runs, but now from the branch's own live
  outputs.
- The remaining intent gap is still experimental rather than architectural:
  the branch can now run and introspect these second-wave profiles, but it has
  not yet shown that any of them beat the earlier controls on live long-budget
  runs.

### Stage 15

- Stage 15 improves alignment with the retrospective-analysis workflow by
  moving one more analysis step out of `/tmp`-only notebooks and into the
  repo's normal reporting path.
- This keeps the branch closer to the original research intent of making QD
  behavior explainable and reviewable from tracked artifacts rather than from
  ad hoc manual inspection alone.

### Stage 16

- Stage 16 improves alignment with the retrospective-analysis intent by turning
  the `/tmp/qd_rich20x5` rerun idea into a tracked, reproducible repo-native
  workflow.
- The remaining alignment gap is run completion and interpretation, not the
  absence of a reproducible experiment path.

### Stage 17

- Stage 17 restores alignment with the core experimental intent by making the
  redo matrix functionally comparable to the original `/tmp/qd_rich20x5` runs.
- The earlier redo root diverged in an unacceptable way because it never
  exercised the benchmark harness correctly; documenting it as invalid and
  launching a fixed rerun is the correct response.
- The branch is now back on the intended comparison path, and the fixed redo
  completed successfully: classic and QD runs both use the real harness top for
  simulation while keeping synthesis bound to the DUT top.

### Stage 18

- Stage 18 improves alignment with the original merge intent by turning the
  branch from an active implementation notebook into a merge-ready change set
  with synchronized docs, explicit recommendation guidance, and clean
  touched-surface validation.
- The branch now presents the finished fixed redo as the current evidence base
  instead of leaving readers on stale intermediate checkpoints, which makes the
  documented recommendations materially closer to the actual code and artifact
  state.

## Roadmap Extension

This roadmap extends the original stage list with the concrete findings from
implementation and testing so far.

### Stage 3 follow-through before Stage 4

- Continue reducing the remaining request-bookkeeping / generation-loop seam
  still duplicated between `EoHEngine` and `QDEngine` now that offspring
  materialization is shared.
- Keep the small completion-oriented live smoke profile for the grid runtime
  separate from the paper-grade `128k` long-context smoke profile.
- Reduce branch-local pyright noise further where fixes are low-risk, while
  keeping broader pre-existing repo-wide type debt explicitly tracked instead of
  hiding it behind narrow command scopes.
- Use the larger `RTLLM/Prob045_alu` and
  `VerilogEval-Spec-to-RTL/Prob030_popcount255` short-budget runs as the
  branch's current regression pair for prompt/runtime robustness.

### Stage 4 revision

- Initial CVT runtime support is now landed. The next Stage 4 follow-through is
  parity work:
  - shared reporting/artifact emission across grid and CVT
  - archive metadata export for centroids/scaler state
  - better success-side evidence on harder runs, not just completion evidence
- Keep parity tests that compare shared archive behavior across grid and CVT:
  insertion semantics, quality-based replacement, exported metadata shape, and
  summary compatibility.
- Moderate-budget evidence now shows that CVT can out-fill grid on
  `RTLLM/Prob043_RAM` under the same short budget (`2` occupied cells vs `1`),
  so CVT should remain in the default paper path rather than being treated as a
  visualization-only backend.

### Descriptor follow-through revision

- The branch now has a richer implemented descriptor inventory than the main
  completed `20 x 5` run actually used.
- The richer-descriptor rerun is now complete and confirms that the descriptor
  story should be split into:
  - archive geometry suitability
  - descriptor richness
  - archive observability
- The next descriptor-focused follow-through should explicitly separate:
  - archive-geometry questions
  - descriptor-richness questions
  - runtime-extraction reliability questions
- Completed near-term fix:
  - sequential `grid` defaults now include `g_P` alongside `g_A` and `g_T`
- Completed near-term rerun:
  - the same four-design `20 x 5` matrix was rerun with richer descriptor
    spaces for both `grid` and `cvt`
  - explicit grid-axis specs were used
  - `hybrid_seq_default` was used as the primary CVT descriptor-rich profile
- New near-term follow-through:
  - preserve archive decisions at the candidate level with
    `qd_archive_event.json`
  - preserve archive geometry in a human-readable per-problem report
  - improve downstream reporting and summary consumption of the new multi-axis
    grid marginals/projection plots
- Interpretation rule for that rerun:
  - if CVT improves coverage and archive quality under richer descriptors while
    grid becomes sparse or unstable, treat that as evidence about archive
    geometry suitability rather than proof that richer descriptors are a bad
    idea

### Stage 5 revision

- Add `M-T` and `C-D` only after the grid runtime and archive parent-view
  semantics are stable enough to measure them meaningfully.
- Include explicit tests for how per-phase generation-mode overrides interact
  with benchmark defaults from `ProblemSpec`.
- Revisit whether diff-capable backfill should be enabled by default on larger
  benchmarks only after the runtime is actually honoring those benchmark
  defaults.
- Treat low-budget operator smokes as routing validation only. Do not use them
  as evidence of archive or PPA improvement until longer-budget runs produce
  successful candidates.
- The moderate-budget experiments reinforce that recommendation: larger
  VerilogEval control/FSM tasks still fail mostly at the response-format layer
  before operator choice matters, so prompt/output robustness is the next
  limiting factor there.

### Stage 7 revision

- Logging/reporting should now include both algorithm evidence and research
  evidence:
  - archive occupancy and QD score
  - blocked vs passed smoke status
  - descriptor profile used
  - whether the run was `grid` or `cvt`
  - whether the run was `ppa` or `functional_only`
- The next Stage 7 follow-through should focus on:
  - adding more complete visualization coverage for per-metric archive views
  - deciding whether QD plot generation should remain runtime-local or move
    into a reusable reporting layer
  - ensuring archive packaging and comparison reports can surface the new plot
    files without manual inspection

### Stage 8 revision

- The final branch review should explicitly compare the finished branch against
  this “Original Plan Comparison Review” section, not just against the running
  checklist, so the merge decision is based on both execution and intent.
- Add `ty` to the merge-readiness checklist alongside `pytest`, `ruff`, and
  focused `pyright`, with any remaining diagnostics explicitly separated into
  QD-branch debt, older repo-wide debt, and transient tool-environment import
  issues.
- Keep a documented “research-budget” recommendation beside the smoke
  checklist:
  for the shared reasoning-model vLLM endpoint, use `max_tokens>=128000` and
  `diff_max_tokens>=128000` before drawing conclusions about archive fill or
  mode quality on larger RTLLM / VerilogEval problems; shorter budgets are
  debugging-only.

### Stage 9 revision

- The new archive-observability layer is now in place. The next step is not
  inventing more archive metadata, but deciding which parts should surface in
  future reports by default and which should remain detailed debug artifacts.
- Multi-axis grid studies now have first-pass visualization support through
  per-axis marginals and pairwise projection heatmaps. The next step is better
  downstream report consumption rather than raw plot generation.
- The next descriptor-rich follow-through should prioritize:
  - `hybrid_phys_seq` validation on sequential CVT tasks
  - bounded live smokes for the new Icarus-derived activity profiles and a
    first archive-quality comparison against the existing structural controls
  - further shared-engine cleanup and older `algorithm.py`
    typing/documentation reduction

## Commit Ledger

- `4fefc818ee` `feat(qd): add runtime retrospective descriptor extraction`
- `675d2fbc4d` `fix(qd): record initial archive snapshots and experiment findings`
- `32ea6f39e6` `docs(qd): bootstrap living implementation plan and worktree log`
- `e91188281b` `feat(qd): add search mode and capability scaffolding`
- `2268a7f81f` `feat(qd): add scoring and descriptor substrate`
- `efbf9b48d0` `feat(qd): add grid archive and linear scheduler substrate`
- `98db8207e4` `docs(qd): record stage 3 substrate checkpoint`
- `4a82690a1f` `feat(qd): wire grid runtime path and refresh docs`
- `fae94e617c` `docs(qd): review plan alignment and extend roadmap`
- `6c987af52a` `feat(qd): honor problem defaults and add success reservoirs`
- `dc62a11c2b` `docs(qd): document single sign-off commit rule`
- `d5a7176628` `feat(qd): add configurable grid-axis bin loading`
- `ed3e933f61` `chore(qd): record validation status and clean branch typing`
- `c03242b784` `feat(qd): add initial cvt archive runtime support`
- `855472eb70` `docs(qd): record stage 4 cvt checkpoint`
- `013972bfe4` `feat(qd): add reporting and visualization parity for qd runs`
- `8228eec6a8` `docs(qd): record stage 7 reporting checkpoint`
- `8b0393d10e` `feat(qd): emit archive-state artifacts for qd runs`
- `7cb58e1240` `feat(qd): add targeted and diverse qd operators`
- `79b3c9c38d` `docs(qd): record stage 5 operator checkpoint`
- `a7ca6aeedd` `feat(qd): add cvdp and realbench capability scaffolding`
- `3947e578df` `docs(qd): record stage 6 capability checkpoint`
- `5c669d1c1f` `feat(qd): add repeatable vllm smoke harness`
- `87f10971d7` `docs(qd): record stage 8 smoke harness checkpoint`
- `7777665902` `refactor(qd): share offspring materialization across engines`
- `10030191a8` `docs(qd): record stage 3 seam cleanup checkpoint`
- `38290247dc` `fix(qd): separate classic and qd success strategies`
- `33d97c9cd0` `docs(qd): record completion smokes and experiment findings`
- `fc2637529e` `feat(qd): emit openroad metrics sidecars from synthesis reports`
- `94fd2ae074` `refactor(qd): share logger and run-finalization seams`
- `40646b455d` `docs(qd): sync living plan ledger after experiment update`
- `0fa6b0af2d` `fix(qd): guard long-context vllm token budgets`
- `edd230b585` `docs(qd): record 20x5 experiment results`
- `20f1353e07` `docs(qd): expand descriptor inventory and rerun roadmap`
- `50fd888e3d` `feat(qd): add archive event logs and space reports`
- `13611203f0` `fix(qd): honor retrospective grid profiles in runtime`
- `9e7ec003fa` `feat(qd): add multi-axis grid visualization outputs`
- `6975cfdb48` `feat(qd): add dynamic activity descriptor extraction`
- `aea5ae7823` `docs(qd): record stage 13 dynamic descriptor rollout`
- `ad65b66ba6` `feat(qd): add second-wave profiles and descriptor health reports`
- `ec87266c73` `feat(reporting): aggregate qd descriptor health in reports`
- `30c41c568e` `feat(experiments): add retrospective qd redo harness`
- `91108364e5` `docs(qd): record retrospective redo launch`
- `cc7947af71` `fix(experiments): mark qd redo harness executable`
- `dbbb6293fc` `fix(runtime): split simulation and synthesis top resolution`
- `c8deb0d797` `fix(evaluation): clean up eda subprocess groups on timeout`
- `1ad0d1e075` `test(evaluation): add Prob144 timeout fixtures and cleanup regressions`
- `a71021a759` `feat(cli): expose shared rtl and synthesis timeout controls`
- `61b8423d69` `fix(llm): reduce request timeout and add Prob144 live stress coverage`
- `eb56e695cc` `docs(qd): summarize preliminary backend guidance`
- `0b8253d8aa` `docs(qd): expand descriptor extraction guide`

## Deferred Follow-Ups

- Formal-heavy RealBench support beyond module subsets.
- Benchmark-specific descriptor studies once the core archive pipeline is
  stable.
- Validate whether `hybrid_phys_seq` materially improves sequential CVT archive
  diversity or best-quality outcomes.
- Improve downstream report consumption and summarization of the new multi-axis
  grid marginal/projection artifacts.
- Validate whether the new activity profiles produce meaningful archive
  diversity or archive-quality gains on RTLLM / VerilogEval before considering
  any default change.
- Validate whether the new second-wave retrospective profiles
  (`wire_ctrl_assign_3d`, `wire_if_math_3d`, `wire_always_ternary_3d`,
  `assign_always_math_3d`) materially improve archive fill or archive quality
  relative to the first-wave structural/runtime profiles.
- Extend descriptor-health summarization beyond per-report sections into
  higher-order trend summaries across problems, backends, and repeated runs.
- Repeat the fixed retrospective redo with additional seeds before treating the
  current recommendation ladder as statistically stable.
- Keep `/tmp/qd_rich20x5_redo_full/20260313_181943` recorded as an invalid
  regression case study only; do not use it for numeric comparison.
- Continue reducing older `algorithm.py` typing/documentation debt and shared
  engine-loop duplication where the cleanup is low-risk.
- Consider integrating the separate remote `realbench` branch once its fuller
  benchmark-analysis surface is ready.
- Additional descriptors adopted only after probe evidence justifies them.

## Smoke Commands

- Preflight:
  `curl -s http://host.docker.internal:8000/v1/models`
- Planned grid smoke:
  `python scripts/run_backend.py --backend revolution --search_mode revolution_qd --qd_archive_type grid --benchmarks RTLLM --api_backend vllm --vllm_host host.docker.internal --vllm_port 8000 --vllm_min_model_len 128000 --max_tokens 128000`
- Planned CVT smoke:
  `python scripts/run_backend.py --backend revolution --search_mode revolution_qd --qd_archive_type cvt --benchmarks RTLLM --api_backend vllm --vllm_host host.docker.internal --vllm_port 8000 --vllm_min_model_len 128000 --max_tokens 128000`
- Planned diff-heavy smoke:
  `python scripts/run_backend.py --backend revolution --search_mode revolution_qd --qd_archive_type cvt --benchmarks cvdp --qd_backfill_generation_mode diff --qd_refine_generation_mode diff --api_backend vllm --vllm_host host.docker.internal --vllm_port 8000 --vllm_min_model_len 128000 --max_tokens 128000 --diff_max_tokens 128000`
- Stage 9 grid artifact smoke:
  `timeout 120s /workspace/.venv/bin/python scripts/run_backend.py --backend revolution --search_mode revolution_qd --qd_archive_type grid --benchmarks RTLLM --problems Prob001_accu --api_backend vllm --vllm_host host.docker.internal --vllm_port 8000 --vllm_min_model_len 128000 --model_name /project/cad-team/LX_Semicon/models/openai-gpt-oss-120b --population_size 1 --num_generations 0 --num_workers 1 --candidate_workers 0 --evaluation_mode search_accelerated --accelerated_synthesis_top_k 1 --temperature 0.3 --top_p 0.95 --max_tokens 128 --diff_max_tokens 128 --save_path /tmp/qd_stage9_fast_smoke/grid_timeout --no-backend_subdir --seed 42`
- Stage 9 CVT artifact smoke:
  `timeout 120s /workspace/.venv/bin/python scripts/run_backend.py --backend revolution --search_mode revolution_qd --qd_archive_type cvt --benchmarks RTLLM --problems Prob001_accu --api_backend vllm --vllm_host host.docker.internal --vllm_port 8000 --vllm_min_model_len 128000 --model_name /project/cad-team/LX_Semicon/models/openai-gpt-oss-120b --population_size 1 --num_generations 0 --num_workers 1 --candidate_workers 0 --evaluation_mode search_accelerated --accelerated_synthesis_top_k 1 --temperature 0.3 --top_p 0.95 --max_tokens 128 --diff_max_tokens 128 --save_path /tmp/qd_stage9_fast_smoke/cvt --no-backend_subdir --seed 42`
- Repeatable QD smoke harness:
  `bash scripts/run_backend_qd_smoke_vllm.sh --archive matrix --suite verilogeval --policy diff-heavy`
- Planned activity-profile smoke:
  `python scripts/run_backend.py --backend revolution --search_mode revolution_qd --qd_archive_type grid --qd_descriptor_profile activity_control_3d --benchmarks RTLLM --problems Prob043_RAM --api_backend vllm --vllm_host host.docker.internal --vllm_port 8000 --vllm_min_model_len 128000 --max_tokens 128000`
