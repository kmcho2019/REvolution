# Implementation Details

## Architectural overview

REvolution centres around the `EoHEngine` class (`src/revolution/algorithm.py`), which manages the end-to-end evolution of Verilog designs. The active feature branch also adds an experimental `QDEngine` (`src/revolution/qd/engine.py`) that keeps the same prompt/evaluation substrate but replaces the success-side flat pool with an archive-backed success state for `search_mode=revolution_qd`.

Each run focuses on a single benchmark problem and coordinates:

- population management (dual fail/success pools or a single unified pool),
- calls to the language model through `LLMInterface`,
- evaluation of generated RTL via `VerilogEvaluator` (syntax and functional checks) and `SynthesisEvaluator` (Yosys + OpenROAD + post-synthesis regression),
- logging and summarisation through `EoHLogger`.

The framework also exposes `SingleShotEngine` for baseline n-shot evaluation, the new `Gen0LatencyEngine` for feedback-first scoring with an optional full evaluation pass on the winning candidate (or a standalone prompt file when no benchmark assets are available), and `CVDPEngine` for JSONL-defined hardware design prompts.

## Candidate representation

Candidates are instances of the `Heuristic` data class. Each object records the LLM “thought” string, generated Verilog code, evaluation status, origin strategy (`initial`, `M-*`, `C-F`), parent identifiers, per-stage success flags, PPA metrics, and the file paths of the saved artefacts. A unique UUID allows cross-referencing with logs and stored files.

During initialisation (`initialize_population`) the engine requests `population_size` JSON responses from the LLM. Every valid response is written to disk together with the thought process, enabling downstream tooling to reload context or audit failures.

## Evolutionary pipeline

The main execution entry point is `EoHEngine.run()`:

1. Reference metrics are loaded (`_calculate_reference_ppa`) to normalise fitness against the provided golden design.
2. `initialize_population()` creates generation zero using deterministic “whole” prompts. Candidates are evaluated and stored in fail/success pools.
3. Each generation invokes `evolve_one_generation()`:
   - The engine decides how many offspring originate from fail versus success pools, respecting `population_pool_mode`.
   - `_select_strategy()` picks genetic operators (`M-F`, `M-S`, `M-E`, `M-R`, `M-I`, `C-F`) according to the configured meta-strategy (`random`, `epsilon-greedy`, `ucb`).
   - Prompt payloads are assembled for each parent set. Prompts are mediated by `PromptStore`; Gen0 is always `whole`, while post-Gen0 offspring generation respects configured `generation_mode` for both fail and success parent pools.
  - LLM responses are parsed. Whole-mode responses can be persisted directly; diff-mode responses feed `_apply_diff()` to patch parent code.
  - Diff application is policy-driven (`strict`, `hybrid`, `fuzzy`) and records structured diagnostics (`reason_code`, per-hunk details, phase metadata) for every failed patch.
  - Any formatting or diff-application error is captured as a failed candidate with supporting artefacts.
   - `_evaluate_candidates()` executes simulation and synthesis in two stages. Simulation failures are summarised and fed back through `LLMInterface.generate_batch_feedback()` for future prompts. Successful candidates continue to synthesis and PPA analysis. Scores are computed with `_calculate_fitness_score()` using relative improvements over reference metrics.
4. Strategy rewards reinforce the meta-strategy statistics via a stochastic approximation update (`s["value"] = s["value"] + (reward - s["value"]) / s["count"]`), biasing future selections toward productive operators.
5. The logger records per-generation summaries (`EoHLogger.log_generation`) and, at the end of the run, writes a final summary with the champion candidate and aggregated stats.

The loop terminates after `num_generations` iterations or early if no parents remain to evolve.

## QD search-mode status

The current QD implementation is staged:

- `search_mode=revolution_qd` is exposed through `run_backend.py` and the `revolution` backend adapter.
- `grid` archive support is the first active runtime path.
- `cvt` archive support now has an initial runtime path with warm-up buffering,
  frozen scaling, centroid generation, and nearest-centroid insertion.
- QD-specific success-side operators now include `M-T` (targeted descriptor
  mutation) and `C-D` (diverse archive fusion) on the `QDEngine` path.
- grid runtime phase selection now resolves as explicit override first, then
  benchmark defaults from `ProblemSpec`, then local fallback.
- grid `success_view` sampling now uses archive elites plus a bounded per-cell
  reservoir of recent successful occupants, while the archive remains the
  success-side source of truth.
- `qd_descriptor_file` can now define grid-axis bin/bounds specs in addition to
  descriptor profiles, so grid experiments can move beyond the uniform
  `[-1, 1]` gain-axis fallback.
- sequential grid defaults now include `g_P` alongside `g_A` and `g_T`, so
  default sequential grid runs preserve power, area, and timing gain axes.
- the current retrospective-analysis-driven profile ladder now distinguishes:
  - immediate current-runtime-compatible profiles:
    `implemented_structural_compact_3d`,
    `implemented_structural_fixed_5d`
  - early-stage runtime-supported retrospective profiles:
    `size_control_3d`,
    `timing_control_3d`
  - additional runtime-supported follow-on controls:
    `wire_assign_if_3d`,
    `size_sharing_3d`,
    `wire_ctrl_assign_3d`,
    `wire_if_math_3d`,
    `wire_always_ternary_3d`,
    `assign_always_math_3d`
- grid archive construction now honors `qd_descriptor_profile` when
  `qd_grid_axes` is omitted; the Stage 10 refresh work fixed an earlier bug
  where grid runs silently fell back to gain axes.
- the first corrected Stage 10 refresh snapshots under
  `/tmp/qd_rich20x5_refresh_v2` suggest these structural retrospective profiles
  should remain explicit experiment controls rather than new defaults for now.
- CVT/runtime parity is still incomplete mainly around live smoke completion,
  broader benchmark coverage, and deeper evaluator-side descriptor richness.
- Stage 6 benchmark plumbing is now partially landed:
  `revolution` can use the existing JSONL-backed `cvdp` subset path, and
  `src/revolution/runtime/realbench_adapter.py` provides a manifest-based
  RealBench module adapter for future dataset drops.

The QD substrate currently lives under `src/revolution/qd/`:

- `archive.py`: grid and CVT archive insertion/replacement contracts, including
  CVT warm-up/freeze scaling
- `artifacts.py`: archive summary files, archive-space reports, and
  per-candidate `qd_archive_event.json` emission plus per-problem
  `descriptor_health.json` / `descriptor_health_report.md`
- `scheduler.py`: linear fail-share and fill/improve budget split
- `scoring.py`: exact weighted PPA quality score, gain axes, repair score, hash normalization
- `descriptors.py`: descriptor registry and profile resolution
- `engine.py`: archive-selectable QD runtime engine that reuses existing prompt
  builders, diff application, evaluation, and logger wiring
  - also owns the current QD-specific prompt builders for `M-T` and `C-D`
- `visualization.py`: archive-history plots plus 2-axis grid heatmaps,
  multi-axis grid marginal/projection plots, and CVT projection helpers emitted
  from the QD runtime
- `scripts/backend_comparison_report.py`: now consumes descriptor-health
  sidecars and renders a dedicated `QD Descriptor Health` section
- `scripts/archive_baseline.py`: now preserves descriptor-health sidecars in
  archived QD summaries

## Evaluation stack

`VerilogEvaluator` compiles designs with Icarus Verilog (iverilog) and runs them under `vvp`. Compilation output, simulation logs, and timeouts are written to `<candidate>_simulation.log`. Timeout cleanup now terminates the full subprocess tree for the active stage instead of only the direct wrapper process. Optional reference design files enable mismatch counting on VerilogEval, while RTLLM detects the `===========Your Design Passed===========` banner. When the selected descriptor axes require dynamic metrics, `VerilogEvaluator` also injects a temporary VCD probe into the testbench and returns the emitted waveform path for later activity extraction.

Top-module resolution is now split explicitly:

- simulation uses the testbench top module from
  `ProblemContext.testbench_top_module` / `ProblemSpec.testbench_top_module`
- synthesis uses the DUT top module from
  `synthesis_top_module_names.json` or benchmark manifest metadata

That distinction matters for RTLLM and VerilogEval. Their simulations must
compile the harness top (`tb`) even though synthesis must still target DUT
module names like `RAM`, `alu`, or `TopModule`. If a run suddenly shows empty
simulation stdout and blanket functionality failure across classic and QD
modes, inspect the `iverilog -s ...` target first.

`SimulationDescriptorEvaluator` parses those VCD files and derives the current
activity-oriented descriptor family:
`toggle_count_log_est`, `toggle_density_est`, `active_signal_ratio_est`, and
`avg_toggle_rate_est`. These metrics are attached as `dynamic_metrics`.

`SynthesisEvaluator` automates the Yosys + OpenROAD flow. It generates SDC, Yosys, and OpenROAD scripts from the candidate design, then executes `yosys` and `openroad` as separate managed subprocesses rather than a shell pipeline. Reports are written directly to `<candidate>_synthesis_report.rpt`, include stage-specific timeout/crash markers, and still carry the OpenROAD text needed for timing/power/area parsing. Netlists are regression-tested again using `VerilogEvaluator` to ensure synthesis has not broken functionality.

`CVDPEvaluator` remains the JSONL/harness-backed functional path for `cvdp`
tasks. The feature branch now also includes a lightweight RealBench adapter that
converts module-manifest entries into `ProblemContext` / `ProblemSpec`
instances, but live RealBench runs still depend on an external dataset root
because no checked-in `data/bench/RealBench` tree exists in this worktree.

Classic `EoHEngine` fitness remains the existing score used by the original loop. The QD substrate additionally defines an explicit maximize-form `quality_score`:

`alpha * (P_ref - P_gen) / P_ref + beta * (A_ref - A_gen) / A_ref + gamma * (T_ref - T_gen) / T_ref`

with automatic defaults of `1/3,1/3,1/3` for sequential circuits and `1/2,1/2,0` for combinational circuits.

## LLM integration and prompting

`LLMInterface` wraps asynchronous OpenAI-compatible clients and consolidates retry logic, token accounting, and request batching. It supports OpenAI, OpenRouter, DeepSeek, Gemini, and local vLLM deployments. Responses must adhere to the `eoh_v1` JSON schema. The client now uses a deliberate 600-second default request timeout so live runs fail fast enough to recover from stalled API calls instead of waiting effectively indefinitely. When `require_strict_format` is enabled, malformed outputs are skipped and logged with context artefacts.

Prompt construction is delegated to `PromptStore`. Templates live in `data/prompts/<profile>/...` and can be swapped by passing `prompt_profile` and `prompt_root` to the engine.
Diff-mode prompts carry the base file contents and expected search strings so the model can emit structured edits that `_apply_diff()` can apply. To reduce token pressure, diff requests use an independent token budget (`diff_max_tokens`) and can omit duplicated parent code blocks via compact-context prompting (`diff_compact_context`).

## Logging and persistence

The engine writes everything necessary to reproduce a candidate:

- Generated code and thoughts under `exp/<model>/<benchmark>/<problem>/Gen<idx>/<problem_sample_strategy>/`, where each candidate folder is self-contained (code, thought, diff artefacts, feedback) to avoid collisions during parallel evaluation.
- Simulation logs, synthesis reports, and diff application traces (`*_diff_apply_error.json` with reason codes and diagnostics).
- JSONL generation logs with per-candidate metadata and strategy stats.
- QD archive-state artifacts for `revolution_qd` runs:
  `archive_history.jsonl`, `archive_cells.csv`, `archive_summary.json`,
  `qd_metrics.json`, `grid_layout.json` or `centroids.json`,
  `archive_space.json`, and `archive_space_report.md`.
- Per-candidate QD archive-event artifacts:
  `qd_archive_event.json` in every archive-handled successful candidate
  directory, recording descriptor values, structural/RTL/dynamic/physical
  metric payloads, cell assignment, and insertion or displacement outcome.
- QD visualization outputs for `revolution_qd` runs:
  `coverage_vs_generation.png`, `best_quality_vs_generation.png`,
  `qd_score_vs_generation.png`, plus 2-axis grid heatmaps, multi-axis grid
  marginals/projection plots, or CVT projection plots.
- Use [qd_map_elites_guide.md](/workspace/.worktrees/revolution-qd-map-elites/docs/qd_map_elites_guide.md)
  for the code-accurate one-generation trace and full-run trace.
- `scripts/backend_comparison_report.py` now treats `archive_summary.json` as a
  QD sidecar rather than a per-problem summary, and renders a dedicated QD
  archive section instead of accidentally double-counting it as a design.
- `scripts/archive_baseline.py` now preserves the QD sidecars as archived
  summary files, along with the generated QD plots, so baseline packages keep
  archive coverage and quality history.
- A final `<problem>_summary.json` containing aggregated metrics, champion details, reward histories, and token usage.

Support scripts in `scripts/` load these artefacts to build tables, visualisations, or markdown reports.

## Extensibility considerations

- **Strategies**: add new operators to `strategies` in `algorithm.py` and update prompt templates.
- **Benchmarks**: drop new problem folders in `data/bench/<suite>/` with `_test.sv`, `_ref.sv`, and synthesis metadata.
- **EDA tools**: override `VerilogEvaluator` or `SynthesisEvaluator` paths when initialising the engines.
- **Prompt profiles**: author new templates under `data/prompts/<profile>` and point the engine to them.

Because every stage saves its outputs, new tooling can analyse intermediate data without modifying the core loop.
