# Implementation Details

## Architectural overview

REvolution centres around the `EoHEngine` class (`src/revolution/algorithm.py`), which manages the end-to-end evolution of Verilog designs. Each run focuses on a single benchmark problem and coordinates:

- population management (dual fail/success pools or a single unified pool),
- calls to the language model through `LLMInterface`,
- evaluation of generated RTL via `VerilogEvaluator` (syntax and functional checks) and `SynthesisEvaluator` (Yosys + OpenROAD + post-synthesis regression),
- logging and summarisation through `EoHLogger`.

The framework also exposes `SingleShotEngine` for baseline n-shot evaluation, the new `Gen0LatencyEngine` for feedback-first scoring with an optional full evaluation pass on the winning candidate, and `CVDPEngine` for JSONL-defined hardware design prompts.

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
   - Prompt payloads are assembled for each parent set. Prompts are mediated by `PromptStore` and always request “whole” generation for failed parents while respecting the configured `generation_mode` for successful ones.
   - LLM responses are parsed. Whole-mode responses can be persisted directly; diff-mode responses feed `_apply_diff()` to patch parent code. Any formatting or diff-application error is captured as a failed candidate with supporting artefacts.
   - `_evaluate_candidates()` executes simulation and synthesis in two stages. Simulation failures are summarised and fed back through `LLMInterface.generate_batch_feedback()` for future prompts. Successful candidates continue to synthesis and PPA analysis. Scores are computed with `_calculate_fitness_score()` using relative improvements over reference metrics.
4. Strategy rewards reinforce the meta-strategy statistics via a stochastic approximation update (`s["value"] = s["value"] + (reward - s["value"]) / s["count"]`), biasing future selections toward productive operators.
5. The logger records per-generation summaries (`EoHLogger.log_generation`) and, at the end of the run, writes a final summary with the champion candidate and aggregated stats.

The loop terminates after `num_generations` iterations or early if no parents remain to evolve.

## Evaluation stack

`VerilogEvaluator` compiles designs with Icarus Verilog (iverilog) and runs them under `vvp`. Compilation output, simulation logs, and timeouts are written to `<candidate>_simulation.log`. Optional reference design files enable mismatch counting on VerilogEval, while RTLLM detects the `===========Your Design Passed===========` banner.

`SynthesisEvaluator` automates the Yosys + OpenROAD flow. It generates SDC, Yosys, and OpenROAD scripts from the candidate design, writes reports to `<candidate>_synthesis_report.rpt`, and parses timing/power/area metrics. Netlists are regression-tested again using `VerilogEvaluator` to ensure synthesis has not broken functionality.

Fitness is defined as the negative relative PPA delta versus the reference design. For sequential circuits the average includes the effective clock period; for combinational circuits power and area are averaged.

## LLM integration and prompting

`LLMInterface` wraps asynchronous OpenAI-compatible clients and consolidates retry logic, token accounting, and request batching. It supports OpenAI, OpenRouter, DeepSeek, Gemini, and local vLLM deployments. Responses must adhere to the `eoh_v1` JSON schema. When `require_strict_format` is enabled, malformed outputs are skipped and logged with context artefacts.

Prompt construction is delegated to `PromptStore`. Templates live in `data/prompts/<profile>/...` and can be swapped by passing `prompt_profile` and `prompt_root` to the engine. Diff-mode prompts carry the base file contents and expected search strings so the model can emit structured edits that `_apply_diff()` can apply.

## Logging and persistence

The engine writes everything necessary to reproduce a candidate:

- Generated code and thoughts under `exp/<model>/<benchmark>/<problem>/Gen<idx>/<problem_sample_strategy>/`, where each candidate folder is self-contained (code, thought, diff artefacts, feedback) to avoid collisions during parallel evaluation.
- Simulation logs, synthesis reports, and diff application traces.
- JSONL generation logs with per-candidate metadata and strategy stats.
- A final `<problem>_summary.json` containing aggregated metrics, champion details, reward histories, and token usage.

Support scripts in `scripts/` load these artefacts to build tables, visualisations, or markdown reports.

## Extensibility considerations

- **Strategies**: add new operators to `strategies` in `algorithm.py` and update prompt templates.
- **Benchmarks**: drop new problem folders in `data/bench/<suite>/` with `_test.sv`, `_ref.sv`, and synthesis metadata.
- **EDA tools**: override `VerilogEvaluator` or `SynthesisEvaluator` paths when initialising the engines.
- **Prompt profiles**: author new templates under `data/prompts/<profile>` and point the engine to them.

Because every stage saves its outputs, new tooling can analyse intermediate data without modifying the core loop.
