# Module Structure

## Top-level layout

- `src/`: Python package source code.
  - `revolution/`: core evolutionary framework (see below).
  - `eor.egg-info/`: packaging metadata produced by the build system.
- `scripts/`: executable helpers for running experiments, tests, report generation, data prep, and visualisations.
- `tests/`: unit tests organised under `tests/revolution/`.
- `data/`: benchmark assets.
  - `bench/`: VerilogEval, RTLLM, and CVDP problem definitions, reference designs, and synthesis metadata.
  - `prompts/`: prompt templates grouped by profile for `PromptStore`.
  - `configs/`: YAML templates demonstrating `--config` usage for the main scripts.
- `pdk/`: technology collateral used by the synthesis flow.
- `exp/`: default output directory for run artefacts (created at runtime).
- `Dockerfile`: reproducible environment for CI or local development.
- `pyproject.toml` / `uv.lock`: Python dependency definitions maintained by `uv`.

## `docs/journal_features/`

- `overall_plan.md`: canonical journal-extension roadmap, ETA checklist,
  implementation rules, validation policy, and links to each feature spec. This
  plan is based on the `feat/qd-theory-grounded-descriptors` branch.
- `01_bd_trio.md`: behavior descriptor trio specification for logic depth,
  FF depth, and width.
- `02_quantile_binning.md`: initial quantile-based adaptive grid plan.
- `03_pareto_front_archive.md`: bounded Pareto-front per cell and
  multiobjective MAP-Elites plan.
- `03_1_pareto_visualization.md`: linked archive/PPA/Pareto viewer plan for
  classic-vs-QD and QD-vs-QD run comparison.
- `04_two_tier_fail_pool.md`: success-archive plus fail-pool parent-source
  plan.
- `05_single_mutation_operator.md`: single thought-level mutation/crossover
  prompt plan.
- `06_thought_only_k_code.md`: thought-only individual and k-code evaluation
  plan.
- `07_ks_adaptive_rebinning.md`: KS-triggered adaptive re-binning and final
  integration plan.

## `src/revolution/`

- `__init__.py`: package export surface, re-exports engines plus backend/runtime abstractions.
- `algorithm.py`: main evolutionary driver (`Heuristic`, `EoHEngine`, `SingleShotEngine`, `CVDPEngine`) with strategy and diff orchestration.
- `backends/base.py`: backend interface (`EvolutionBackend`) and shared context/service dataclasses.
- `backends/revolution_backend.py`: backend adapter that selects classic
  `EoHEngine` or archive-backed `QDEngine` based on `search_mode`.
- `qd/`: QD/MAP-Elites substrate and runtime extensions.
  - `qd/archive.py`: grid, CVT, and grid-quantile archive geometries plus
    scalar-elite and bounded Pareto-front cell replacement semantics.
  - `qd/artifacts.py`: archive summaries, archive-space reports,
    one-row-per-member `archive_cells.csv`, and per-candidate archive-event
    writers.
  - `qd/design_space_report_support.py`: shared report-layout dataclasses plus plotting and markdown helpers for the standalone design-space analysis pipeline.
  - `qd/feature_space_analysis.py`: shared feature-statistics, embedding, regression, and profile-selection helpers used by retrospective reporting scripts. This is the shared "feature math" layer behind both `report_design_space_analysis.py` and `report_qd_feature_space.py`.
  - `qd/scheduler.py`: occupancy-based fail/success budget splitting helpers.
  - `qd/scoring.py`: exact PPA `quality_score`, gain axes, repair score, and code hashing helpers.
  - `qd/successful_candidate_catalog.py`: shared retrospective loader for successful candidates from `generation_log.jsonl` plus best-effort artifact enrichment from synthesis reports, QD archive events, and on-disk RTL artifacts. It normalizes classic and QD runs into one row-oriented candidate catalog for downstream reports.
- `qd/descriptors.py`: descriptor registry, descriptor requirement metadata,
  profile loading, grid-axis spec handling, and descriptor-axis resolution.
- `qd/engine.py`: archive-backed `QDEngine` for grid, CVT, and grid-quantile modes that
  reuses REvolution prompt, evaluation, and logging infrastructure.
  - `qd/visualization.py`: QD archive-history plots plus 2-axis grid heatmaps, multi-axis grid marginal/projection helpers, CVT projection helpers, and artifact-replayed grid-quantile evolution visualizations.
  - `qd/ppa_visualization_export.py`,
    `qd/ppa_visualization_metrics.py`, and
    `qd/ppa_visualization_viewer.py`: static linked QD archive plus
    PPA/Pareto viewer exporter, fixed-objective Pareto-rank/hypervolume
    helpers, and inline HTML bundle generation with viridis fitness legends,
    shaded sequential PPA glyphs, rank-scaled markers, reference/sample axis
    ticks, compare-mode shape legends, linked-hover dimming, layer-cell
    tooltips, and linked hover debug hooks.
- `backends/funsearch_backend.py`: FunSearch-style RTL backend (islands, signature clusters, reset/reseed, budgeted loop).
- `runtime/problem_context.py`: benchmark/problem path and metadata resolution.
- `runtime/problem_spec.py`: benchmark capability layer and default descriptor / generation-mode preferences.
- `runtime/parallelism.py`: shared parallelism config resolution, Manager-backed elastic slot coordination, and per-problem worker leasing helpers used by both runners and backends.
- `runtime/structural_evaluator.py`: structural descriptor extraction helpers for Yosys-like stats payloads.
- `runtime/candidate_evaluator.py`: backend-agnostic format/syntax/functionality/synthesis/PPA evaluation orchestration with `strict_ablation` and `search_accelerated` modes.
- `runtime/realbench_adapter.py`: manifest-based RealBench module discovery plus `ProblemContext` / `ProblemSpec` builders.
- `runtime/run_artifacts.py`: shared generation-log/summary writer plus legacy summary key alias support.
- `evaluation.py`: evaluation stack (`VerilogEvaluator`, `SynthesisEvaluator`).
- `simulation_descriptor_evaluator.py`: VCD/activity parsing for simulation-derived QD descriptors.
- `llm.py`: unified async LLM client with retry/backoff, token tracking, and JSON parsing helpers.
- `logging.py`: `EoHLogger` for JSONL generation logs, per-run summaries, and reward statistics.
- `prompt_store.py`: filesystem-backed prompt templating system with concatenated bundle support and tolerant `safe_format`.
- `prompt_tuning.py`: strict `PromptStore` bundle export/materialization,
  GEPA proxy-run scoring helpers, and final prompt-optimization validation
  gates. The detailed feature spec is
  `docs/journal_features/misc/01_gepa_prompt_tuning.md`.
- `vllm_preflight.py`: lightweight `/v1/models` preflight helpers for vLLM connectivity and `max_model_len` checks.
- `configuration.py`: helpers for loading CLI config files (including legacy snapshot compatibility), validating options, and recording runnable snapshot + metadata-sidecar files.
- `utils.py`: utility helpers (for example `StreamRedirector`).

## `scripts/`

- `run_evolution.py`: CLI entry point for multi-problem evolutionary runs with elastic global worker-pool scheduling and config-file translation for older parallelism keys.
- `run_backend.py`: canonical backend-selectable runner (`--backend revolution|funsearch`) with shared elastic/global parallelism controls.
- `run_backend_qd_smoke_vllm.sh`: repeatable grid/CVT QD smoke harness for live
  vLLM validation with fixed small-budget defaults and `--dry-run`.
- `run_qd_theory_grounded_smoke_vllm.sh`: dedicated CVT smoke/comparison
  harness for the theory-grounded descriptor family, including a structural
  control matrix and `--dry-run`.
- `report_qd_rent_calibration.py`: manifest-driven offline Rent calibration
  helper that compares repo-native graph extraction against stored RentCon
  outputs and emits JSON/markdown summaries.
- `run_qd_theory_followup_vllm.sh`: bounded multi-problem theory-vs-control
  CVT follow-up matrix for RTLLM / VerilogEval with `--dry-run`.
- `run_qd_theory_followup_manifest.py`: manifest-driven broader theory
  follow-up runner that writes a resolved run-plan snapshot and supports
  case/profile filtering plus smoke-budget overrides.
- `report_qd_theory_followup.py`: focused follow-up report generator for the
  theory-profile experiment roots, including compact-profile recommendation,
  pairwise control deltas, and promotion-decision output.
- `run_qd_retrospective_redo_vllm.sh`: repeatable long-budget retrospective
  rerun harness for the four-design `/tmp/qd_rich20x5` corpus with preset
  profile matrices and automatic suite-local comparison reports.
- `qd_descriptor_probe.py`: descriptor/profile inspection helper for QD experiments.
- `run_funsearch.py`: convenience wrapper for `run_backend.py --backend funsearch`.
- `run_backend_ablation.py`: ablation sweep orchestrator across both backends with multi-seed support, strict fairness checks, and configurable budget-axis normalization (`candidate_evaluations`, `llm_calls`, `dual_gate`).
- `backend_comparison_report.py`: side-by-side + aggregate backend report generator across experiment roots with pass/fail emoji status, any-pass design counts, valid PPA generated-sample counts, solved-only score/PPA summaries (including aggregate `PPA Delta (A/P/T)` and `Avg PPA Delta`), PPA regression counts, budget/fairness diagnostics, QD archive metrics, and live-vs-replay descriptor-health decisions when QD sidecars are present.
- `run_one_shot.py`: CLI for n-shot baselines that reuse the evaluation stack without evolution.
- `archive_baseline.py`: archive utility for run roots and ablation roots with manifest/index metadata, copied run configs, preserved QD sidecars/plots, and compressed raw artifacts.
- `report_design_space_analysis.py`: retrospective classical-vs-QD design-space report generator with per-problem generation-local vs accumulated PPA plots, cached-QD descriptor pairwise plots for graph-backed profiles, quick-reference sections, stable markdown indices, and `successful_candidates.csv` / `recommended_profile.json` exports.
- `report_ppa_distribution.py`: successful-candidate PPA distribution report generator with absolute PPA scatter views, score-contour shading, projected Pareto-front overlays, reference-normalized gain views, best-candidate CSVs, and classic-vs-QD figure slices.
- `run_diff_mode_benchmark.py`: whole-vs-diff benchmark harness with hard-task selection, aggregate token/runtime comparisons, and diff failure catalog generation.
- `run_diff_mode_diagnostics.py`: repeated real-LLM diff stress harness producing strict-parse/apply failure catalogs across curated edge cases, including worst-case failure sample retention.
- `run_diff_prompt_optimization_loop.py`: prompt-candidate loop runner that calls `run_diff_prompt_suite.py` per candidate and ranks prompts by objective score.
- `run_gepa_prompt_tuning.py`: DSPy/GEPA campaign runner for full
  `PromptStore` profile bundles. It configures the DSPy reflection model,
  gives GEPA one strict prompt bundle candidate, materializes temporary prompt
  profiles, runs and scores RTL/QD proxy artifacts, and writes campaign
  reports.
- `data/configs/gepa_prompt_tuning_proxy_problems.yaml`: default proxy
  benchmark/problem list for GEPA prompt-tuning campaigns.
- `report_gepa_prompt_tuning.py` and `validate_gepa_prompt_tuning_run.py`:
  report regeneration plus strict final classic-vs-baseline-vs-optimized
  validation for prompt-tuning campaigns.
- `run_test.sh`, `run_regression_test.sh`, `run_cvdp_test.sh`: shell wrappers for regression suites.
- `generate_*`, `plot_problem_pareto.py`, `evolutionary_report_generator.py`: reporting and visualisation utilities.
- `render_grid_quantile_visualizations.py`,
  `validate_grid_quantile_run.py`,
  `validate_grid_quantile_visualizations.py`: Phase 02 grid-quantile archive,
  visualization rendering, and validation utilities.
- `validate_pareto_front_run.py`: Phase 03 Pareto-front hard-subset audit for
  member counts, front bounds, and same-cell non-dominance.
- `validate_single_thought_operator_run.py`: Feature 05 hard-subset audit for
  the unified single-thought operator, including EoH-vs-unified metric gates,
  parent-count artifacts, and prompt-snapshot leakage checks.
- `export_qd_ppa_visualization.py` and `validate_qd_ppa_visualization.py`:
  Phase 03.1 static viewer export and validation for linked archive-space and
  PPA/Pareto inspection. The exporter can project classic candidates posthoc
  into a selected QD archive source and emits
  `visualization/qd_ppa_viewer/index.html` plus per-problem JSON datasets. The
  validator checks the scene/debug contract, PPA color-mode controls, rank-size
  semantics, viridis fitness shading, shaded sequential PPA glyphs, reference
  and sample hover/tick behavior, PPA auto-rotation, layer tooltips, linked
  alpha dimming, and strict offline reproducibility.
- `prompt_file_manager.py`: manage prompt bundle files and synchronise `data/prompts/`.
- `util/` and `ref/`: helper scripts, synthesis references, and datasets.

## `tests/`

- `tests/revolution/test_algorithm.py`: unit tests for selection logic, diff application, and state transitions.
- `tests/revolution/test_evaluation.py`: covers simulator/synthesiser wrappers using fixtures/mocks.
- `tests/revolution/test_llm.py`: ensures JSON parsing, retry loops, and prompt handling behave as expected.
- `tests/revolution/test_vllm_preflight.py`: validates vLLM preflight URL handling, metadata parsing, and warning logic.
- `tests/scripts/test_run_diff_mode_benchmark.py`: validates hard-task selection and aggregate reporting helpers for whole-vs-diff benchmarks.
- `tests/scripts/test_run_diff_mode_diagnostics.py`: validates diagnostics skip behavior and result aggregation paths.
- `tests/scripts/test_run_diff_prompt_optimization_loop.py`: validates prompt-loop ranking and skipped-run handling.
- `tests/revolution/test_prompt_tuning.py` and
  `tests/scripts/test_gepa_prompt_tuning_scripts.py`: validate strict prompt
  bundle parsing, materialization, artifact scoring, fake-evaluator campaigns,
  report generation, and final GEPA gate enforcement.

## Generated artefacts

- `compile_results_gate_cutoff_50.md`, `log.txt`, and other markdown logs under the repository root are outputs produced by helper scripts.
- Additional problem-specific folders, tables, or plots are created beneath `exp/` during runs.
