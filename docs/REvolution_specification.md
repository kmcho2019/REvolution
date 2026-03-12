# REvolution Framework Specification (Paper + Implementation)

## 1) Scope, Sources, and Intended Use

This document is a consolidated specification intended for reviewers and future feature/research work on top of the REvolution codebase. It merges:

- The paper summary and conceptual algorithm from `docs/REvolution_paper/REvolution_evolutionary_framework_for_RTL_generation_driven_by_LLMs.md`.
- Implementation notes from `docs/implementation_details.md`, `docs/method_interaction_and_evolutionary_loop.md`, `docs/module_structure.md`, and `docs/user_guide.md`.
- Concrete behavior observed in the code under `src/revolution/` and runtime scripts in `scripts/`.

Where the paper and code differ, this spec notes the distinction explicitly so implementers can reason about research intent vs. current behavior.

---

## 2) Paper: Core Methodology Summary

### 2.1 Problem Motivation

The paper frames two main challenges for LLM-based RTL generation:

1) **Functional correctness**: LLMs often fail to satisfy HDL semantics and testbench requirements.
2) **PPA (Power, Performance, Area)**: Standard LLM outputs are not optimized for post-synthesis metrics.

Prior feedback-based approaches improve candidates locally but are susceptible to local optima. REvolution introduces global search via evolutionary computation (EC) coupled with LLM generation and tool feedback.

### 2.2 Individual Representation

Each individual is a tuple:

- **Thought**: High-level design strategy in natural language.
- **Code**: Verilog RTL implementation.
- **Feedback**: LLM-generated analysis from simulation and/or PPA feedback.

### 2.3 Dual-Population Algorithm

The paper splits candidates into:

- **Fail population**: Functionally incorrect candidates (focus: bug fixing).
- **Success population**: Functionally correct candidates (focus: PPA optimization).

Offspring allocation is proportional to population sizes in each generation. Different prompt strategies are used per population.

### 2.4 Prompt Strategies (Genetic Operators)

The paper defines mutation and crossover strategies:

- **M-F**: Mutate-Fix (repair functional failures)
- **M-S**: Mutate-Simplify (simplify while preserving correctness)
- **M-E**: Mutate-Explore (diverse re-interpretation)
- **M-R**: Mutate-Refactor (restructure without changing behavior)
- **M-I**: Mutate-Improve (general improvements)
- **C-F**: Crossover-Fusion (fuse two successful parents)

### 2.5 Adaptive Strategy Selection

The paper describes a self-adaptive mechanism: prompt strategy selection probabilities are updated based on success rates (multi-armed bandit style), improving search efficiency.

### 2.6 Fitness (Paper Definition)

Paper formula (multi-objective):

```
F_gen = alpha*(P_ref - P_gen)/P_ref
      + beta *(A_ref - A_gen)/A_ref
      + gamma*(T_ref - T_gen)/T_ref
```

where P/A/T correspond to power/area/effective clock period. Functionally incorrect individuals get -inf.

### 2.7 QD Extension Track

The active feature branch adds a second search mode:

- `search_mode=revolution`: classic REvolution behavior
- `search_mode=revolution_qd`: archive-backed success-state search

The intended QD state is:

- `fail_pool`
- `success_archive`
- `success_view`

Current branch status:

- grid archive substrate and runtime path are implemented
- CVT now has an initial warm-up/freeze runtime path
- reporting/artifact parity and richer QD operators remain staged work
- the living implementation record is maintained in
  `docs/revolution_qd_map_elites_implementation_plan.md`

---

## 3) Implementation Architecture and Key Modules

### 3.1 Top-Level Layout (Repo)

- `src/revolution/`: core Python package.
- `scripts/`: CLI entrypoints, report generation, data utilities.
- `data/`: benchmarks, prompt templates, configs.
- `pdk/`: technology files used by synthesis flow.
- `docs/`: documentation and the paper markdown.

### 3.2 Core Classes (src/revolution)

| Component            | File                             | Responsibility                                                                                      |
| -------------------- | -------------------------------- | --------------------------------------------------------------------------------------------------- |
| `EoHEngine`          | `src/revolution/algorithm.py`    | Main evolutionary loop, population mgmt, prompt orchestration, evaluation pipeline, reward updates. |
| `Heuristic`          | `src/revolution/algorithm.py`    | Candidate data structure (Thought/Code/Feedback + metrics).                                         |
| `VerilogEvaluator`   | `src/revolution/evaluation.py`   | Icarus Verilog compile/sim pipeline.                                                                |
| `SynthesisEvaluator` | `src/revolution/evaluation.py`   | Yosys + OpenROAD flow + post-synth regression.                                                      |
| `LLMInterface`       | `src/revolution/llm.py`          | OpenAI-compatible async LLM client, JSON parsing, retry/backoff, token stats.                       |
| `PromptStore`        | `src/revolution/prompt_store.py` | Prompt templating and profile management.                                                           |
| `EoHLogger`          | `src/revolution/logging.py`      | JSONL generation log + final summary.                                                               |
| `StreamRedirector`   | `src/revolution/utils.py`        | Capture stdout/stderr to per-problem log files.                                                     |
| `QDEngine`           | `src/revolution/qd/engine.py`    | Experimental archive-backed search path for `revolution_qd`, currently supporting grid and CVT.    |
| `GridArchive`        | `src/revolution/qd/archive.py`   | Grid MAP-Elites archive for reduced-axis QD runs.                                                   |
| `CVTArchive`         | `src/revolution/qd/archive.py`   | Warm-up/freeze CVT archive with frozen scaling and nearest-centroid cell assignment.                |
| `split_qd_budget`    | `src/revolution/qd/scheduler.py` | Linear fail-share and fill/improve budget split helper.                                             |
| QD scoring helpers   | `src/revolution/qd/scoring.py`   | Weighted PPA quality score, gain axes, repair score, code hashing.                                  |
| Descriptor registry  | `src/revolution/qd/descriptors.py` | Descriptor profiles, axis resolution, and requirements metadata.                                  |

#### 3.2.1 `EoHEngine`: Public Interface and Core State

Constructor (selected parameters):

- `benchmark_name`, `problem_name`: benchmark identifiers and problem id.
- `llm_interface`: instance of `LLMInterface`.
- `verilog_evaluator`, `synthesis_evaluator`: instances of evaluators.
- `population_size`, `num_generations`.
- LLM sampling knobs: `default_llm_temp`, `default_llm_top_p`, `default_llm_max_tokens`.
- Strategy selection knobs: `strategy_selection_method` (`random|epsilon-greedy|ucb`), `epsilon`, `ucb_c`.
- Generation controls: `generation_mode` (`whole|diff`), `population_pool_mode` (`dual|single`), `require_strict_format`.
- Prompt routing: `prompt_profile`, `prompt_root`.
- Parallel evaluation: `candidate_workers` (thread pool size for candidate evaluation).
- `champion_metrics_config`: optional list defining \"champion\" metrics beyond best score.

Key state stored on the engine:

- Pools and population: `fail_pool`, `success_pool`, and `population` (single-pool mode).
- Reference metrics: `ref_ppa_metrics` (from `<problem>_ppa.txt`).
- Strategy stats: `fail_strategy_stats`, `success_strategy_stats` (`count` + `value` per strategy).
- Diff controls: `diff_apply_policy` (`strict|hybrid|fuzzy`), `diff_max_tokens`,
  `diff_compact_context`, `diff_similarity_threshold`, `diff_fuzzy_margin`,
  `diff_length_scale`, `diff_allow_dots`.
- Single-pool controls: `single_fail_allocation_cap`, `single_success_weight_exp` (and `single_success_min_fraction`, currently unused).
- Logger instance: `logger` (`EoHLogger`).
- Prompt store: `prompts = PromptStore(...)`.

Core methods and behavior:

- `run()`: orchestrates the full run:
  - loads reference PPA,
  - initializes `EoHLogger`,
  - runs Gen0 (`initialize_population()`),
  - iterates `evolve_one_generation()` for `num_generations`,
  - writes final summary and returns a one-line result string.
- `initialize_population()`:
  - uses `LLMInterface.generate_n_responses()` in **whole** mode,
  - writes candidate directories,
  - evaluates candidates and populates pools.
- `evolve_one_generation()`:
  - allocates offspring between fail/success views,
  - selects strategies (bandit-based meta-selection),
  - builds prompts and issues batched LLM requests,
  - applies diffs if required,
  - evaluates offspring,
  - updates rewards and strategy stats,
  - performs survivor selection.
- `load_problem_description()`: reads `<problem>_prompt.txt` for the current benchmark.
- `._evaluate_candidates()`: full pipeline of syntax + functionality + synthesis + PPA, plus LLM feedback generation.
- `._apply_diff()` / `._do_replace()`: patch application with fuzzy matching.
- `._calculate_reference_ppa()` / `._calculate_fitness_score()`: reference load + fitness scoring.
- `._resolve_top_module_name()`: reads `synthesis_top_module_names.json`.

#### 3.2.2 `Heuristic`: Candidate Object

The `Heuristic` class is a simple data container with UUID identity, generation info, parent IDs, strategy and origin metadata, evaluation status, PPA metrics, and file paths. See Section 4.1 for the full field list.

#### 3.2.3 `LLMInterface`: Core API

Primary methods (all async internally; the engine uses `asyncio.run()` to call them):

- `generate_response(prompt, temperature, top_p, max_tokens, generation_mode, system_prompt_override)`:
  - returns `(thought, code, meta)` where `meta` includes `format_ok`, `error`, `raw`, `parsed_mode`.
  - strict JSON validation (`_strict_validate_eoh`) is used; a lenient parse fallback marks `format_ok=False`.
- `generate_n_responses(prompt, n, ...)`: n candidates from a single prompt.
- `generate_batch_responses(prompts, ...)`: batch of different prompts concurrently.
- `generate_feedback(problem_def, verilog_code, simulation_log, ...)`:
  - returns `{"score": int, "justification": str, "analysis": str}` JSON.
- `generate_batch_feedback(feedback_requests, ...)`: concurrent feedback generation.
- `parse_thought_and_code()`: lenient parsing for legacy formats (used only when strict parse fails).
- `get_and_reset_usage_stats()`: returns token and call counts (code vs. feedback separated).

#### 3.2.4 `PromptStore`: Prompt File API

Key methods:

- `read(key)`: load a prompt by key (e.g., `evolve/M-F/whole`).
- `write(key, content)`: persist prompt content.
- `list_keys()`: list all available prompt keys.
- `load_from_concat(path, write_to_disk, overwrite)`: parse a concatenated prompt bundle.
- `save_concat(path, keys)`: write a bundle from the prompt store.

#### 3.2.5 `VerilogEvaluator`: Simulation API

`evaluate(generated_sv_file, test_sv_file, ref_sv_file, top_module_name, output_directory, simulation_timeout_seconds)`:

- Accepts either a single DUT file or a list of DUT+library files.
- Produces compilation and simulation logs, and classifies status:
  - `success`, `compilation_error`, `simulation_error`, `simulation_timeout`, `file_error`.

#### 3.2.6 `SynthesisEvaluator`: Synthesis + PPA API

`evaluate(verilog_file, problem_name, synth_top_module_name, output_directory, report_base_path, verilog_evaluator, test_sv_file, ref_sv_file, simulation_timeout_s, synthesis_timeout_s)`:

- Runs Yosys then OpenROAD, writes report paths.
- Runs post-synthesis simulation with the PDK cell library.
- Returns flags `synthesis_success`, `synthesis_functionality_success`, `ppa_success`, plus `ppa_metrics` and log paths.

#### 3.2.7 `EoHLogger`: Logging API

Key methods:

- `log_generation(...)`: appends one JSONL record per generation with strategy usage, success rates, PPA stats, diff stats, and LLM token usage.
- `finalize_summary(...)`: writes `<problem>_summary.json` with run aggregates and final population stats.

#### 3.2.8 `StreamRedirector`

Context manager to redirect stdout/stderr to a log file (used by run scripts to isolate per-problem logs).

### 3.3 Engine Variants

- **`SingleShotEngine`**: n-shot baseline without evolution (initial generation only).
- **`Gen0LatencyEngine`**: "BatchPick" mode: generate Gen0 candidates, score via LLM feedback, optionally evaluate the best candidate.
- **`CVDPEngine`**: adapts evaluation for JSONL-based CVDP dataset (cocotb/pytest harness).

### 3.4 How Core Classes Work Together in a Typical Run

The typical execution path is `scripts/run_evolution.py`:

1) Parse CLI/config and build task list (benchmarks + problem IDs).
2) For each problem, a worker process:
   - Creates `LLMInterface` using the selected backend and API key.
   - Creates `VerilogEvaluator` and `SynthesisEvaluator` (or stubs in Gen0 latency mode).
   - Instantiates the correct engine:
     - `EoHEngine` (default),
     - `Gen0LatencyEngine` (when `--evaluation_mode gen0`),
     - `CVDPEngine` (when benchmark is `cvdp`).
3) `EoHEngine.run()` (or variant) drives the full lifecycle:
   - `PromptStore` templates are used to construct system + user prompts.
   - `LLMInterface` returns JSON-structured results.
   - `VerilogEvaluator` runs syntax/functional simulation.
   - `SynthesisEvaluator` runs Yosys + OpenROAD and post-synth regression.
   - `EoHLogger` records JSONL generation logs and final summary.
4) The parent script aggregates per-problem logs into run-level summary logs.

For `scripts/run_one_shot.py`, the flow is identical except it always uses `SingleShotEngine` (no evolution) and skips LLM feedback generation in the evaluation loop.

`scripts/run_backend.py` provides a backend-pluggable entrypoint for ablations. Current backend profiles are `revolution`, `funsearch`, and `eoh`. The EoH backend supports both whole and diff generation modes and can evaluate `cvdp` problems through a dedicated runtime evaluator (`revolution.runtime.cvdp_evaluator.CVDPEvaluator`) instead of the VerilogEval testbench flow.

---

## 4) Data Structures and Schemas

### 4.1 `Heuristic` Candidate Fields

Defined in `src/revolution/algorithm.py`:

- `id`: UUID
- `thought`: LLM strategy summary
- `code`: Verilog RTL string (or original code on diff failure)
- `feedback`: LLM analysis of errors or PPA improvements
- `score`: fitness score (float)
- `generation`: generation index
- `parent_ids`: list of parent UUIDs
- `status`: one of:
  - `new`, `success`, `failed_format`, `failed_diff`, `failed_syntax`, `failed_functionality`, `failed_synthesis`, `failed_synthesis_functionality`
- `synthesis_success`, `synthesis_functionality`, `ppa_success`
- `ppa_metrics`: dict with `tns`, `wns`, `eff_clk_period`, `power`, `area`, `report_path`
- `code_file_path`: path to `code.sv`
- `strategy`: evolutionary strategy (`initial`, `M-F`, `M-S`, `M-E`, `M-R`, `M-I`, `C-F`)
- `reward_from_parent`: reward used to update strategy statistics
- `origin_pool`: `initial`, `fail_pool`, or `success_pool`
- `generated_mode`: `whole` or `diff`

### 4.2 LLM Output Schema (`eoh_v1`)

The system expects a **single JSON object**. Strict validation (when enabled) requires:

```
{
  "format": "eoh_v1",
  "mode": "whole" | "diff",
  "thought": "<string>",
  "code": "<full Verilog>"                       # if mode=whole
  // OR
  "code": { "edits": [ { "file": "...", "hunks": [ {"search":"...","replace":"..."} ] } ] }   # if mode=diff
}
```

Notes:

- The parser normalizes tolerated variants into canonical form (`top-level edits`, inferred `mode`) before strict checks.
- Strict diff validation expects single-file edit payloads (one `code.edits` entry).
- If `require_strict_format=True` (default), any violation yields `failed_format` and skips evaluation.
- `LLMInterface` also tries to recover from malformed JSON using `_extract_json_obj` and `_repair_json_like`.

### 4.3 Diff Format and Application

Diff JSON (preferred):

```
{"edits": [
  {"file": "path", "hunks": [
    {"search": "<exact>\n", "replace": "<new>\n"}
  ]}
]}
```

Legacy diff format is also supported (SEARCH / REPLACE blocks). The diff applier
uses a deterministic pipeline:

1) strict exact unique matching
2) whitespace-normalized line matching
3) guarded fuzzy matching (with optional wildcard `...` support)

Fuzzy fallback is gated by:
- threshold (`diff_similarity_threshold`, default `0.86`)
- ambiguity margin (`diff_fuzzy_margin`, default `0.03`)
- top-candidate score diagnostics (`best_ratio`, `second_ratio`, top windows)

The `diff_apply_policy` controls strictness:
- `strict`: exact unique matches only.
- `hybrid`: exact -> whitespace-normalized -> guarded fuzzy.
- `fuzzy`: same pipeline with permissive fallback intent.

JSON diff application additionally enforces:
- single-target-file edits (`multi_file_edit_not_allowed` on violations),
- preflight exact-anchor overlap detection (`overlap_conflict`),
- atomic in-order hunk application with per-hunk diagnostics.

If diff application fails, the candidate is marked `failed_diff`, and diagnostics
are saved alongside `code.sv` in `*_diff_apply_error.json` with structured
`reason_code`, `reason`, `matching_policy`, `parent_sha256`, and per-hunk metadata.

---

## 5) Evolutionary Workflow (Implementation)

### 5.1 Initialization (Gen0)

- `initialize_population()` uses `LLMInterface.generate_n_responses` to request `population_size` candidates.
- **Always uses `whole` mode** for Gen0, regardless of global generation mode.
- Candidates are saved under:

```
exp/<model>/<benchmark>/<problem>/Gen0/<problem>_sample<idx>_initial/
  code.sv
  thought.txt
  diff.json (optional)
  diff.txt  (optional)
  *_format_error.json (optional)
  *_feedback.txt (optional)
```

- Results are evaluated and split into fail/success pools (or a single pool in single-pool mode).

### 5.2 Main Evolution Loop

`EoHEngine.run()` calls `evolve_one_generation()` for each generation:

1) **Pool sampling**
   - Dual-pool mode: offspring count proportional to fail/success pool sizes.
   - Single-pool mode: caps fail allocation via `single_fail_allocation_cap` and biases parent selection via `single_success_weight_exp`.

2) **Strategy selection**
   - Meta-strategy: random, epsilon-greedy, or UCB (softmax of UCB scores).
   - Statistics stored in `fail_strategy_stats` and `success_strategy_stats`.

3) **Prompt construction**
   - Strategies map to prompt builders; prompt templates are pulled from `PromptStore`.
   - Post-Gen0 offspring generation uses configured `generation_mode` (`whole` or `diff`) for both fail and success pools.
   - Gen0 initialization remains `whole` mode by design.

4) **LLM batch generation**
   - `LLMInterface.generate_batch_responses` executes concurrent requests.

5) **Diff application** (if `diff`)
   - Applies edits to parent code or marks `failed_diff` with diagnostics.

6) **Evaluation** (simulation + synthesis)

7) **Reward update**
   - Fail pool reward: 1 if a child becomes `success`.
   - Success pool reward: 1 if a child remains `success` and exceeds parent best score.
   - Per-strategy Q-values updated by incremental mean:

```
Q_new = Q_old + (reward - Q_old) / count
```

8) **Survivor selection**
   - Candidates sorted by score; champions by metrics can be preserved (configurable via `champion_metrics_config`).

### 5.3 Early Termination

If no parents remain to evolve (`fail_view + success_view == 0`), the loop stops.

---

## 6) Evaluation Pipeline

### 6.1 Verilog Simulation (Icarus Verilog)

Implemented in `VerilogEvaluator.evaluate()`:

- Compilation flags: `-Wall -Winfloop -Wno-timescale -g2012`.
- Output files:
  - `<candidate>_compiled.vvp`
  - `<candidate>_simulation.log`
- Accepts either a single DUT file or a list of files (used for post-synthesis simulation with PDK cell libraries).
- Success detection:
  - VerilogEval: match `Mismatches: 0`.
  - RTLLM: match `===========Your Design Passed===========`.
- Simulation runs in the DUT file's directory so testbenches can load auxiliary data files.
- The default testbench top module name is `"tb"`.

Timeout: default 60 seconds (configurable). Compilation or simulation errors map to `failed_syntax` or `failed_functionality`.

### 6.2 Synthesis and PPA (Yosys + OpenROAD)

Implemented in `SynthesisEvaluator.evaluate()`:

- Generates:
  - SDC file
  - Yosys script (`scripts/ref/ref.yosys.tcl`)
  - OpenROAD script (`scripts/ref/ref.openroad.tcl`)
- Default synthesis clock period is 0.01 ns; `_create_sdc_file()` infers clock ports via a regex on port names and falls back to `f_clk` when none are found.
- `SynthesisEvaluator.__init__()` anchors template paths to `scripts/ref/` and forces the PDK path to `data/pdk/` under the repo root (overriding the constructor argument).
- Runs synthesis command:

```
yosys <script> && openroad <script> | tee <report>
```

- Post-synthesis functional check simulates the synthesized netlist with the testbench and PDK cell library (`pdk/Nangate45/work_around_yosys/cells.v`).

### 6.3 PPA Metrics

Parsed from OpenROAD report:

- `tns`, `wns` from timing summary lines.
- `power` from `Total` line.
- `area` from `Design area` line.
- Effective clock period:
  - If `wns < 0`: sequential => `eff_clk_period = clk_period - wns`.
  - Else: combinational => `eff_clk_period = 0.0`.

### 6.4 Reference PPA

Reference metrics are read from `<problem>_ppa.txt`. If missing or malformed, defaults are used:

```
area = 1e4
power = 1.0
eff_clk_period = clk_period
```

### 6.5 Flow Summary

```
benchmark description
        ↓
LLMInterface.generate_* ──► Heuristic objects (thought + code) ──► disk artefacts
        ↓                                               │
   simulation (iverilog/vvp) ───────────────────────────┤
        ↓ (pass)                                        │
   synthesis + PPA (Yosys/OpenROAD) ────────────────────┤
        ↓                                               │
  fitness score + status ──► fail/success pools ──► strategy selection ─┐
        └───────────────────────────────────────────────────────────────┘
```

---

## 7) Fitness Function (Implementation vs. Paper)

### 7.1 Implementation Fitness

`_calculate_fitness_score()` uses **equal weights** (no explicit alpha/beta/gamma):

- Sequential: average of normalized power/area/timing deltas.
- Combinational: average of power/area deltas.
- Fitness is the **negative** of average improvement percentage, so better PPA yields higher score.

### 7.2 Difference from Paper

The paper allows weighted objectives (alpha/beta/gamma). The current code fixes equal weights and does not expose alpha/beta/gamma in the CLI. If weighted objectives are required, code changes are needed (e.g., add CLI args and update `_calculate_fitness_score`).

---

## 8) Prompting System

### 8.1 Prompt Store and Profiles

- Templates live in `data/prompts/<profile>/...`.
- `PromptStore` reads by key (e.g., `evolve/M-F/whole`, `system/whole`).
- Supports concatenated prompt bundles with explicit markers.
- `safe_format()` substitutes placeholders and preserves unknown placeholders.

### 8.2 Prompt Placeholders

Common placeholders:

- `context_json`: JSON payload containing task, problem description, and parent(s).
- `file_to_edit` / `original_file`: used only in diff mode.
- Feedback templates: `problem_def`, `code`, `simulation_log`.

### 8.3 System Prompts

- Default system prompts enforce `eoh_v1` JSON output.
- For Gen0 mode, the `batchpick` profile is used by default (see `scripts/run_evolution.py`).

### 8.4 LLM Interface Details

`LLMInterface` (in `src/revolution/llm.py`) provides:

- Backends: `openai`, `openrouter`, `deepseek`, `gemini`, `vllm` (OpenAI-compatible API surface).
- Retry/backoff for transient API errors.
- Token accounting separated into code-generation vs feedback usage:
  - `code_prompt_tokens`, `code_completion_tokens`
  - `feedback_prompt_tokens`, `feedback_completion_tokens`
- Strict JSON validation with a lenient parsing fallback (meta flag `format_ok` drives `failed_format` handling in the engine).

---

## 9) Logging and Output Artifacts

### 9.1 Directory Layout

All outputs go under `exp/<model>/<benchmark>/<problem>/`:

```
Gen0/
  <problem>_sample1_initial/
    code.sv
    thought.txt
    diff.txt / diff.json (if diff mode)
    *_feedback.txt
    *_format_error.json
    *_diff_apply_error.json
Gen1/...
...
generation_log.jsonl
<problem>_summary.json
problem_run.log
```

Gen0 latency mode additionally mirrors best candidate to:

```
Gen0/best_candidate/
  code.sv
  thought.txt
  best_candidate_metadata.json
  <optional evaluation logs>
```

### 9.2 Generation Log (`generation_log.jsonl`)

Per generation log entries include:

- Candidate statuses and strategy usage.
- Success rates (format, syntax, functionality, synthesis).
- Diff statistics (`attempts`, `failed`, `pass_rate`).
- PPA stats per generation and per strategy.
- LLM usage metrics (API calls, token counts).

### 9.3 Final Summary (`*_summary.json`)

Includes:

- Total runtime, total generations.
- Aggregate success rates.
- Strategy usage counts and rewards.
- LLM token usage totals.
- Final population PPA summaries.

---

## 10) Benchmarks and Data Layout

### 10.1 Standard Benchmarks (RTLLM, VerilogEval)

Each problem uses a naming convention in `data/bench/<suite>/`:

- `<problem>_prompt.txt` : natural language specification
- `<problem>_test.sv` : testbench
- `<problem>_ref.sv` : reference implementation
- `<problem>_ppa.txt` : reference PPA metrics
- `synthesis_top_module_names.json` : top module name mapping
- Optional misc files: copied into candidate directory for tests (data files referenced by testbench).

### 10.2 CVDP Dataset

- JSONL file at `data/bench/cvdp/cvdp_v1.0.2_nonagentic_code_generation_no_commercial.jsonl`.
- `CVDPEngine` extracts:
  - `input.prompt` as problem description.
  - `harness.files` to materialize cocotb/pytest harness.
  - `output.context` to identify DUT file path under `rtl/`.

---

## 11) Engine Variants and Special Modes

### 11.1 SingleShotEngine

- Runs only Gen0 (no evolution).
- Skips LLM feedback stage to reduce cost.
- Useful for baseline pass@1 or n-shot evaluation.

### 11.2 Gen0LatencyEngine (BatchPick)

- Generates `population_size` candidates.
- Uses LLM feedback scoring (0-10) to rank candidates quickly.
- Optional full evaluation of best candidate via `--gen0_evaluate_best`.
- Supports `--gen0_prompt_file` for standalone prompts (no benchmark assets).

### 11.3 CVDPEngine

- Uses cocotb/pytest harness instead of VerilogEval-style testbenches.
- Parses `.env` to set `VERILOG_SOURCES`, `PYTHONPATH`, and other cocotb variables.
- No synthesis/PPA step.
- Generates LLM feedback for failures and successes (suggested improvements).

---

## 12) CLI and Configuration (scripts/)

### 12.1 `scripts/run_evolution.py`

Primary arguments:

- `--benchmarks`, `--problems`
- `--population_size`, `--num_generations`
- `--generation_mode {whole,diff}`
- `--diff_apply_policy {strict,hybrid,fuzzy}`
- `--diff_max_tokens`
- `--diff_compact_context/--no-diff_compact_context`
- `--diff_similarity_threshold`, `--diff_fuzzy_margin`
- `--population_pool_mode {dual,single}`
- `--strategy_selection {random,epsilon-greedy,ucb}`
- `--evaluation_mode {standard,gen0}`
- `--gen0_evaluate_best`, `--gen0_prompt_file`
- `--api_backend {openai,openrouter,deepseek,gemini,vllm}`
- `--model_name`, `--vllm_host`, `--vllm_port`
- `--vllm_min_model_len`, `--vllm_preflight_timeout_s`
- `--prompt_profile` (choose prompt profile)

Supports YAML/JSON configs via `--config`. Each run writes:
- `exp/<model>/<timestamp>_config.yaml` (flat runnable config)
- `exp/<model>/<timestamp>_config_meta.yaml` (provenance sidecar metadata)

Legacy snapshots with `resolved_arguments` remain valid `--config` inputs.

### 12.2 `scripts/run_one_shot.py`

- Same benchmark selection and LLM configuration.
- `--num_samples` for population size.

### 12.3 Reporting and Utilities

- `scripts/evolutionary_report_generator.py`: summarises experiment results into Markdown tables.
- `scripts/run_diff_mode_benchmark.py`: matched-seed whole-vs-diff benchmark harness (default 6/6/6 hard matrix + failure catalogs).
- `scripts/run_diff_mode_diagnostics.py`: repeated real-LLM diff robustness diagnostics and parse/apply failure taxonomy.
- `scripts/gen0_report_generator.py`: checks Gen0 best-candidate snapshots and optionally emits Markdown.
- `scripts/plot_problem_pareto.py`: PPA scatter plots.
- `scripts/prompt_file_manager.py`: manage concatenated prompt bundles.

---

## 13) Docker Environment and Toolchain

Defined in `Dockerfile`:

- Base image: `ubuntu:22.04`.
- Installs: Icarus Verilog `v12_0`, Yosys commit `7b0c1fe49`, OpenROAD commit `b571c4b471`, Verilator commit `0cd4a57ad`, Bison 3.5.4.
- Python dependencies installed via `uv sync` (Python >= 3.11 as per `pyproject.toml`).
- Non-root user `user` with `/workspace` as working directory.
- Default command: `/bin/bash`.

---

## 14) Extension and Research Hooks

### 14.1 Adding New Strategies

- Update `strategies` dict in `EoHEngine.evolve_one_generation()`.
- Implement prompt builder (`_create_prompt_*`) and templates under `data/prompts/<profile>/evolve/`.
- Ensure reward logic in evolution reflects new strategy semantics.

### 14.2 Changing Fitness

- Modify `_calculate_fitness_score()` in `src/revolution/algorithm.py`.
- Optionally expose alpha/beta/gamma via CLI or config file.
- Update logging/report scripts if new metrics are required.

### 14.3 Benchmarks

- Add `<problem>_prompt.txt`, `_test.sv`, `_ref.sv`, `_ppa.txt` to `data/bench/<suite>/`.
- Update `synthesis_top_module_names.json` with module name.

### 14.4 Prompt Profiles

- Clone `data/prompts/default` or `data/prompts/batchpick`.
- Update templates; use `PromptStore` profiles via CLI `--prompt_profile`.

### 14.5 Evaluation Tooling

- To swap simulation or synthesis tools, extend/override `VerilogEvaluator` or `SynthesisEvaluator`.
- For CVDP-style harnesses, review `CVDPEngine`.

---

## 15) Known Implementation Notes / Deviations

- **Fitness weighting**: Implementation uses equal weights; paper allows weighted objectives (alpha/beta/gamma).
- **Single-pool mode**: Code defines `single_success_min_fraction` but does not currently apply it in survivor selection.
- **Reference PPA**: Uses precomputed `_ppa.txt`, not synthesized on the fly.
- **Strict JSON enforcement**: Failures are captured as `failed_format` and skipped if `require_strict_format=True`.

---

## 16) Quick Reference: File Paths

- Paper: `docs/REvolution_paper/REvolution_evolutionary_framework_for_RTL_generation_driven_by_LLMs.md`
- Implementation details: `docs/implementation_details.md`
- Evolution loop doc: `docs/method_interaction_and_evolutionary_loop.md`
- Module structure: `docs/module_structure.md`
- User guide: `docs/user_guide.md`
- Core engine: `src/revolution/algorithm.py`
- Evaluation: `src/revolution/evaluation.py`
- LLM interface: `src/revolution/llm.py`
- Prompt system: `src/revolution/prompt_store.py`
- Logging: `src/revolution/logging.py`
- CLI entry: `scripts/run_evolution.py`
