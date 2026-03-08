# User Guide

This guide walks through environment preparation, script usage, common options, and validation steps for running the REvolution framework.

## 1. Prerequisites

### 1.1 External toolchain

Install the following binaries and keep them on your `PATH`:

- **Icarus Verilog** (`iverilog`, `vvp`) – syntax and functional simulation. Tested with `v12_0`.
- **Yosys** – logic synthesis. Tested with `0.54+29`.
- **OpenROAD** – place & route + PPA reporting. Tested with `v2.0-22560-gb571c4b471`.

The `Dockerfile` provisions exact versions if you prefer a containerised setup.

### 1.2 Python environment

REvolution uses [uv](https://github.com/astral-sh/uv) to manage dependencies:

```bash
uv sync                 # install dependencies into .venv
source .venv/bin/activate
```

`pyproject.toml` and `uv.lock` capture all required Python packages, including CLI helpers (`tqdm`), testing utilities (`pytest`), and OpenAI-compatible SDKs.

### 1.3 LLM access

Set environment variables for every backend you plan to use:

```bash
export OPENAI_API_KEY="..."
export OPENROUTER_API_KEY="..."
export DEEPSEEK_API_KEY="..."
export GEMINI_API_KEY="..."
```

For local inference servers such as vLLM, ensure the server is reachable (`http://localhost:8888/v1` by default) and skip API keys.

### 1.4 Devcontainer and shared vLLM compose (optional)

REvolution's devcontainer now uses `.devcontainer/docker-compose.yml` and includes an optional `vllm` profile. The Compose network name matches the legalization reference setup (`llm-evolegalizer-net`), so one vLLM service can be shared across both repos.

Typical flow:

1. Reopen REvolution in container using `.devcontainer/devcontainer.json`.
2. Optionally create `.devcontainer/.env` from `.devcontainer/.env.example` and set model-related values.
3. Start vLLM from either repo:
   ```bash
   docker compose -f .devcontainer/docker-compose.yml --profile vllm up -d vllm
   ```
4. Use REvolution with vLLM:
   ```bash
   python scripts/run_evolution.py \
     --api_backend vllm \
     --vllm_host vllm \
     --vllm_port 8888 \
     --model_name /models/<model-directory>
   ```

If the vLLM server runs outside the shared Compose network, use `--vllm_host host.docker.internal` (or `172.17.0.1` on typical Linux bridge setups).

The CLI defaults for `--vllm_host` and `--vllm_port` also read `VLLM_HOST` and `VLLM_PORT` from the environment.
`run_evolution.py`, `run_backend.py`, and `run_one_shot.py` also perform a vLLM `/v1/models` preflight and report `max_model_len`. Use `--vllm_min_model_len` (default `128000`) and `--vllm_preflight_timeout_s` to tune this check.
For reasoning-oriented vLLM models, keep `--max_tokens` large enough that the
model can finish the required JSON envelope and code payload. On the shared
`/project/cad-team/LX_Semicon/models/openai-gpt-oss-120b` endpoint used during
CodeEvolve live smoke testing, `--max_tokens 128000` avoided artificial
truncation; smaller caps could still be used later if a specific model is shown
to remain format-stable.
For `--backend codeevolve --generation_mode diff`, the runner now promotes the
generic diff cap to match `--max_tokens` on large-context vLLM runs when the
default `--diff_max_tokens 1024` was left unchanged.

## 2. Repository assets

- `data/bench/<suite>/<problem>` holds the benchmark Verilog specs, testbenches, reference designs, and `synthesis_top_module_names.json` mapping required for synthesis.
- `data/prompts/<profile>` contains prompt templates consumed by `PromptStore`. Copy the `default` profile to author your own variants.
- `pdk/` stores Liberty/LEF/GDS resources used by the synthesis flow. The paths are resolved automatically by `SynthesisEvaluator`.

## 3. Running experiments

### 3.1 Backend-selectable runs (`scripts/run_backend.py`)

`run_backend.py` is the canonical runner for backend ablations. It supports:

- `--backend revolution|funsearch|eoh|codeevolve`
- shared model/benchmark options (`--benchmarks`, `--problems`, `--model_name`, `--api_backend`, `--save_path`, `--num_workers`)
- backend-specific controls (`--population_size`, `--num_generations`, `--strategy_selection`, `--fs_*`, `--eoh_*`, `--codeevolve_*`)
- shared evaluation controls:
  - `--evaluation_mode strict_ablation|search_accelerated`
  - `--accelerated_synthesis_top_k <int>` (used in `search_accelerated`)
- deterministic run controls (`--seed` with per-worker derived seeds)

`cvdp` benchmark support in `run_backend.py` is currently enabled for `--backend eoh`.
CodeEvolve phase 1 currently targets `RTLLM` and `VerilogEval-Spec-to-RTL`
only; multi-file codebase tasks and `cvdp` adapters are intentionally deferred.

By default outputs are isolated by backend under `<save_path>/<backend>/...` (`--backend_subdir` can be disabled if needed).

Example (REvolution backend):

```bash
python scripts/run_backend.py \
  --backend revolution \
  --benchmarks RTLLM \
  --problems Prob001_accu \
  --api_backend vllm \
  --vllm_host vllm \
  --vllm_port 8888 \
  --model_name /models/openai-gpt-oss-120b \
  --population_size 4 \
  --num_generations 3
```

Example (FunSearch backend):

```bash
python scripts/run_backend.py \
  --backend funsearch \
  --benchmarks RTLLM \
  --problems Prob001_accu \
  --api_backend vllm \
  --vllm_host vllm \
  --vllm_port 8888 \
  --model_name /models/openai-gpt-oss-120b \
  --prompt_profile funsearch \
  --fs_num_islands 8 \
  --fs_functions_per_prompt 2 \
  --fs_max_evaluations 64 \
  --seed 42
```

`scripts/run_funsearch.py` is a convenience wrapper that injects `--backend funsearch`.

Example (EoH backend):

```bash
python scripts/run_backend.py \
  --backend eoh \
  --benchmarks RTLLM \
  --problems Prob001_accu \
  --api_backend vllm \
  --vllm_host vllm \
  --vllm_port 8888 \
  --model_name /models/openai-gpt-oss-120b \
  --eoh_population_size 4 \
  --eoh_num_generations 3 \
  --eoh_operators e1 e2 m1 m2 m3 \
  --generation_mode diff
```

Example (CodeEvolve backend):

```bash
python scripts/run_backend.py \
  --backend codeevolve \
  --benchmarks RTLLM \
  --problems Prob001_accu \
  --api_backend vllm \
  --vllm_host vllm \
  --vllm_port 8888 \
  --model_name /models/openai-gpt-oss-120b \
  --prompt_profile codeevolve \
  --max_tokens 128000 \
  --generation_mode diff \
  --codeevolve_num_islands 3 \
  --codeevolve_num_epochs 24 \
  --codeevolve_init_pop 8 \
  --codeevolve_exploration_rate 0.2 \
  --codeevolve_meta_prompting \
  --codeevolve_max_evaluations 72 \
  --seed 42
```

FunSearch feedback controls:
- `--fs_feedback_policy off|fail_only|always` (default `off`)
- `--fs_feedback_sample_probability <0..1>`

CodeEvolve controls:
- `--codeevolve_num_islands`, `--codeevolve_num_epochs`, `--codeevolve_init_pop`
- `--codeevolve_exploration_rate`, `--codeevolve_selection_policy`, `--codeevolve_roulette_by_rank`
- `--codeevolve_meta_prompting`, `--codeevolve_num_inspirations`, `--codeevolve_max_chat_depth`
- `--codeevolve_migration_topology`, `--codeevolve_migration_interval`, `--codeevolve_migration_rate`
- `--codeevolve_use_scheduler`, `--codeevolve_scheduler_type`, `--codeevolve_scheduler_kwargs_json`
- `--codeevolve_max_evaluations`, `--codeevolve_max_llm_calls`, `--codeevolve_max_llm_tokens`, `--codeevolve_max_runtime_seconds`
- Practical note for reasoning-heavy vLLM models: validate with a generous
  `--max_tokens` budget before concluding that diff-mode or meta-prompting
  failures are backend bugs. CodeEvolve diff runs now auto-promote the default
  diff cap on large-context vLLM endpoints so diff offspring are not
  accidentally constrained to the legacy `1024`-token default.

#### 3.1.1 Ablation fairness controls (`scripts/run_backend_ablation.py`)

Use `run_backend_ablation.py` when you need one-command REvolution vs
FunSearch vs EoH vs CodeEvolve sweeps with explicit fairness normalization.

- `--primary_budget_axis candidate_evaluations|llm_calls|dual_gate`
  - default: `candidate_evaluations` (recommended for headline comparisons)
- `--max_evaluations`: candidate budget per problem (primary in `candidate_evaluations`)
- `--max_llm_calls_per_problem`: required for `llm_calls` and `dual_gate`
- `--backends revolution funsearch eoh codeevolve`: select the backend subset to launch
- `--revolution_population_size`, `--funsearch_initial_population_size`, `--eoh_population_size`, `--eoh_operators`, `--codeevolve_num_islands`, `--codeevolve_init_pop`: preferred schedule knobs used to derive candidate budgets

The ablation runner propagates budget metadata to per-problem summaries (`run_budget.primary_budget_axis`, evaluation/call caps), which the backend comparison report consumes for fairness diagnostics.

### 3.2 Evolutionary runs (`scripts/run_evolution.py`)

This script distributes problems across worker processes and executes the multi-generation loop.

Essential arguments:

- `--benchmarks <names>`: select suites from `data/bench` (default: all).
- `--problems <ids>`: restrict to specific problems (optional).
- `--num_workers <int>`: worker count (processes in `problem` mode, candidate-evaluation threads in `candidate` mode).
- `--multiprocessing_mode {problem,candidate}`: distribute work across problems (default) or evaluate candidates inside a problem in parallel.
- `--population_size <int>` / `--num_generations <int>`: evolutionary parameters.
- `--save_path <dir>`: base directory for artefacts (default: `./exp` relative to the repo).
- `--model_name <str>` / `--api_backend {openai,openrouter,deepseek,gemini,vllm}` / `--vllm_host <str>` / `--vllm_port <int>`: LLM configuration.
- `--temperature`, `--top_p`, `--max_tokens`: sampling parameters forwarded to the LLM.
- `--strategy_selection {random,epsilon-greedy,ucb}`: meta-strategy for picking genetic operators.
  - default: `ucb`
- `--epsilon`, `--ucb_c`: exploration constants used by the meta-strategies.
- `--generation_mode {whole,diff}`: default offspring mode for successful parents. Failed parents always fall back to `whole`.
- `--diff_apply_policy {strict,hybrid,fuzzy}`: diff matching policy (`hybrid` default).
- `--diff_max_tokens <int>`: lower completion cap for diff requests (default `1024`).
- `--diff_compact_context/--no-diff_compact_context`: include compact parent context in diff prompts.
- `--diff_similarity_threshold <float>` / `--diff_fuzzy_margin <float>`: fuzzy fallback controls for ambiguous hunks.
- `--population_pool_mode {dual,single}`: dual maintains separate fail/success pools; single blends them but throttles fail-derived offspring once successes are available.
- `--evaluation_mode {standard,gen0}`: switch between the full pipeline and the latency-only Gen0 scorer.
- `--gen0_evaluate_best`: when used with `--evaluation_mode gen0`, replay the top-ranked candidate through the full functional testbench, synthesis, and OpenROAD PPA flow and store the logs under `Gen0/best_candidate/`.
- `--cvdp_jsonl <path>` / `--cvdp_categories <list>` / `--cvdp_simulation_timeout_s <int>`: enable CVDP dataset support (`bench/cvdp/...`) and control pytest/cocotb timeout (default 120 seconds).

Example (dual-pool UCB search):

```bash
python scripts/run_evolution.py \
  --benchmarks VerilogEval-Spec-to-RTL RTLLM \
  --model_name meta-llama/llama-3.3-70b-instruct \
  --api_backend openrouter \
  --num_workers 32 \
  --population_size 12 \
  --num_generations 24 \
  --strategy_selection ucb \
  --generation_mode diff
```

Latency-optimised Gen0 sampling (no simulation or synthesis):

```bash
python scripts/run_evolution.py \
  --benchmarks VerilogEval-Spec-to-RTL \
  --problems Prob001_zero \
  --evaluation_mode gen0 \
  --population_size 16 \
  --num_workers 1
```

The `gen0` mode skips test benches, synthesis, and PPA analysis by default. It simply collects `population_size` candidates, scores them using the feedback LLM (the returned `score` field), and keeps the top-ranked artefacts under `Gen0/<problem>_sample*/`.

Add `--gen0_evaluate_best` to re-run the winning candidate through the full evaluation pipeline. The artefacts are copied to `Gen0/best_candidate/`, which contains the mirrored `code.sv`, the latest feedback, an evaluation summary, and any simulation/synthesis logs generated during the optional pass. If the benchmark does not ship a matching `<problem>_test.sv` the optional run aborts gracefully and documents the reason in `best_candidate_metadata.json`.

To review those snapshots in bulk, run:

```bash
python scripts/gen0_report_generator.py \
  --experiment_path exp/gen0_mode_experiment_202510192348/_root_.cache_huggingface_models_openai-gpt-oss-120b \
  --save_markdown
```

The console table highlights syntax, simulation, and PPA outcomes for each problem and writes `GEN0_BEST_CANDIDATE_REPORT.md` unless `--markdown_path` is provided.

When you want to explore ideas that are not part of any bundled benchmark, point Gen0 at a standalone text file:

```bash
python scripts/run_evolution.py \
  --evaluation_mode gen0 \
  --gen0_prompt_file prompts/pipelined_fifo.txt \
  --population_size 8
```

The prompt file is read verbatim (UTF-8 by default) and becomes the `problem_description` for the run. The synthetic problem name defaults to the filename stem; set `--gen0_prompt_name` if you need predictable folder names. Because no testbench or reference design exists, `--gen0_evaluate_best` is automatically ignored in custom prompt mode.

#### Configuration files

`scripts/run_evolution.py` accepts `--config path/to/settings.yaml` (or `.json`). The file can contain any subset of CLI options; unspecified values fall back to the parser defaults. When both a config file and explicit CLI switches are supplied, the CLI values win. Curated examples live under `data/configs/`—copy them as a starting point for reproducible experiment setups.

Every invocation writes two files next to summary/log outputs in `exp/<model>/`:

- `<timestamp>_config.yaml`: flat runnable arguments, directly reusable with `--config`.
- `<timestamp>_config_meta.yaml`: metadata sidecar containing provenance details (originating CLI args, source config path, and source config values when present).

Legacy nested snapshots that store fields under `resolved_arguments` are still accepted by `--config`.

`run_evolution.py` remains backward-compatible. It delegates to
`run_backend.py` when invoked with a non-`revolution` backend (for example
`--backend funsearch`, `--backend eoh`, or `--backend codeevolve`) or when the
loaded config contains backend-specific keys such as `fs_*`, `eoh_*`, or
`codeevolve_*`.

#### Archiving completed runs

Use `scripts/archive_baseline.py` to package run outputs for long-term tracking and ablation bookkeeping.

- Single-run example: `python scripts/archive_baseline.py --run-dir exp/<model> --archive-root baselines`
- Ablation-root example: `python scripts/archive_baseline.py --run-dir exp/ablation/<run_id> --archive-root baselines`
- Default storage-saving example: `python scripts/archive_baseline.py --run-dir exp/<model> --archive-root baselines`
- Full archive example: `python scripts/archive_baseline.py --run-dir exp/<model> --archive-root baselines --artifact-mode full`

Each archive includes `manifest.json`, copied summary/report files, copied config snapshots, and `artifacts/raw_results.tar.xz`. The default `--artifact-mode candidate_core` keeps only candidate code/thought/feedback files in the tarball. Use `--artifact-mode full` for complete raw artifacts. The command is strict about reproducibility and fails if no `*_config.yaml|yml|json` snapshots are found under `--run-dir`.

### 3.3 Baseline n-shot runs (`scripts/run_one_shot.py`)

Generates `--num_samples` candidates per problem, evaluates them once, and skips the evolutionary loop. CLI arguments mirror `run_evolution.py` with two differences:

- `--num_samples` controls population size (there is no `--num_generations`).
- There is no multiprocessing mode switch; every worker simply runs `SingleShotEngine`.

Example:

```bash
python scripts/run_one_shot.py \
  --benchmarks RTLLM \
  --num_samples 40 \
  --model_name gpt-4.1-mini \
  --api_backend openai
```

### 3.4 Output inspection

Both scripts create a hierarchy under `exp/<model>/<benchmark>/<problem>/`:

- `Gen0/`, `Gen1/`, …: per-generation folders with `candidate_<idx>_thought.txt`, `candidate_<idx>.sv`, logs, and diff artefacts. In Gen0 runs the best artefact is also mirrored to `Gen0/best_candidate/` along with an evaluation summary when `--gen0_evaluate_best` is used.
- `generation_log.jsonl`: append-only record of every candidate with status, metrics, strategy metadata, and reward signals.
- `<problem>_summary.json`: final summary with champion metrics, runtime statistics, and token usage.
- `problem_run.log`: merged stdout/stderr captured by `StreamRedirector` from each worker process.

## 4. Utility scripts

- `scripts/evolutionary_report_generator.py`: generate Markdown reports summarising a run (`--experiment_path path/to/exp/...`).
- `scripts/backend_comparison_report.py`: combine multiple backend experiment roots into one side-by-side markdown report with pass/fail emojis, per-problem status, designs-with-any-pass counts, solved-only score/PPA deltas (including aggregate `PPA Delta (A/P/T)` and `Avg PPA Delta`) with regression checks, and budget/fairness diagnostics (`--backend_run revolution=<path> --backend_run funsearch=<path> --backend_run eoh=<path> --backend_run codeevolve=<path>`).
- `scripts/run_backend_ablation.py`: one-command ablation sweep runner for REvolution/FunSearch/EoH/CodeEvolve plus optional comparison report generation, multi-seed loops (`--seeds`), strict fairness checks, selectable primary budget axis (`candidate_evaluations|llm_calls|dual_gate`), backend selection via `--backends`, and command validation via `--dry_run`.
  - Also writes top-level snapshots under `save_root` as `<timestamp>_ablation_config.yaml` and `<timestamp>_ablation_config_meta.yaml`.
- `scripts/run_backend.py`: backend-agnostic run orchestration for REvolution/FunSearch/EoH/CodeEvolve comparisons.
- `scripts/run_funsearch.py`: shortcut wrapper for FunSearch backend runs.
- `scripts/archive_baseline.py`: archive run roots into reproducible packages (`manifest.json`, copied configs/summaries, and compressed raw artifacts).
- `scripts/run_diff_mode_benchmark.py`: whole-vs-diff benchmark harness with matched-seed runs (`--seeds`), fixed hard validation matrix defaults (RTLLM/VerilogEval/CVDP), aggregate token/runtime report output, diff-failure catalogs, and optional `--skip_if_unreachable` fail-fast artifact mode for unstable vLLM connectivity.
- `scripts/run_diff_mode_diagnostics.py`: real-LLM diff robustness diagnostics for parse/apply failure taxonomy over curated stress cases, with skip artifact support when vLLM is unreachable and worst-case failure sample retention per reason.
- `scripts/run_diff_prompt_suite.py`: self-contained prompt-optimization suite for diff mode with per-run objective scoring and case-level hard-pass/safe-reject diagnostics.
- `scripts/summarize_diff_prompt_suite.py`: cross-run leaderboard/report generator for prompt-suite outputs (`summary.md`, `summary.json`, and CSV exports for plotting); also emits explicit zero-run summaries when all inputs are skipped runs.
- `scripts/run_diff_prompt_optimization_loop.py`: first prompt-search loop runner that evaluates multiple prompt candidates via `run_diff_prompt_suite.py` and ranks them by `summary.objective_score`.
- `scripts/gen0_report_generator.py`: inspect `Gen0/best_candidate` snapshots, check syntax/simulation/synthesis status, and optionally export Markdown (`--save_markdown`).
- `scripts/generate_cutoff_compile_result_variants.sh`: reproduce paper tables with a specified gate cutoff (`--gate 50` by default).
- `scripts/generate_visualizations*.py` and `plot_problem_pareto.py`: create PPA scatter plots or aggregate charts.
- `scripts/prompt_file_manager.py`: split and merge concatenated prompt bundles.
- `scripts/run_test.sh`, `run_regression_test.sh`, `run_cvdp_test.sh`: convenience wrappers for curated benchmark subsets.

Diff-mode benchmark example:

```bash
python scripts/run_diff_mode_benchmark.py \
  --model_name /models/openai-gpt-oss-120b \
  --api_backend vllm \
  --vllm_host vllm \
  --vllm_port 8888 \
  --seeds 1 2 \
  --skip_if_unreachable
```

Diff diagnostics example:

```bash
python scripts/run_diff_mode_diagnostics.py \
  --model_name /models/openai-gpt-oss-120b \
  --api_backend vllm \
  --vllm_host vllm \
  --vllm_port 8888 \
  --repeat_per_case 5 \
  --failure_examples_per_reason 5
```

Diff prompt suite summarizer example:

```bash
python scripts/summarize_diff_prompt_suite.py \
  --results_root exp/diff_prompt_suite \
  --output_dir exp/diff_prompt_suite/summary
```

Diff prompt optimization loop example:

```bash
python scripts/run_diff_prompt_optimization_loop.py \
  --model_name /models/openai-gpt-oss-120b \
  --api_backend vllm \
  --system_prompt_dir data/prompts/candidates \
  --system_prompt_glob '*.txt' \
  --repeat_per_case 3 \
  --include_profile_prompt
```

All Python helper scripts accept `--help` to show the full argument list.

## 5. Troubleshooting tips

- **Missing executables**: `VerilogEvaluator` and `SynthesisEvaluator` perform `shutil.which` checks at instantiation. If you encounter `FileNotFoundError`, verify that `iverilog`, `vvp`, `yosys`, and `openroad` are discoverable or pass absolute paths when constructing the engines manually.
- **LLM schema errors**: malformed JSON responses are stored with `_format_error.json` metadata inside the candidate directory. Inspect these files to adjust prompts or retry with a different model.
- **Diff application failures**: candidates generated in diff mode create `<candidate>_diff_apply_error.json` snapshots with `reason_code`, phase diagnostics, and raw diff payload to speed up triage.
- **Diff telemetry**: generation logs include `diff_phase_distribution_generation`, `failed_diff_reason_counts_generation`, and `tokens_per_successful_candidate_by_mode_generation` for rapid mode-level regression checks.
- **Synthesis timeouts**: `SynthesisEvaluator` writes timeout or crash information directly into the `_synthesis_report.rpt` file. Consider loosening the design constraints or increasing resources.
- **CVDP harness timeouts**: `run_evolution.py` exposes `--cvdp_simulation_timeout_s` (default `120`) for cocotb/pytest harness execution.
- **Token usage**: generation logs include per-generation token counts (`total_llm_*` fields), handy when budgeting API usage.

## 6. Testing and validation

- Run unit tests:
  ```bash
  pytest
  ```
- Capture coverage and inspect missing lines:
  ```bash
  pytest --cov=src/revolution --cov-report=term-missing
  ```
  The suite includes targeted checks for the single-pool evolutionary mode, `PromptStore` helpers, `StreamRedirector`, and `EoHLogger` to make it clear when regression risk touches prompting, logging, or path management.
- Use `scripts/run_test.sh` for smoke coverage across a small benchmark subset after modifying core logic.
- When altering prompts or evaluation hooks, regenerate reports for a known run and confirm metrics match expectations.
- The summary JSON exposes `all_*_passed` sets to count how many unique candidates cleared each evaluation stage—use these to spot regressions in compilation or synthesis rates.

## 7. Customisation checklist

- **Prompt profile**: clone `data/prompts/default` and pass `prompt_profile` / `prompt_root` when instantiating `EoHEngine` programmatically to experiment with alternative instructions.
- **Strategy tweaks**: extend the `strategies` dictionary in `algorithm.py` to add new genetic operators. Remember to ship matching templates.
- **EDA overrides**: instantiate `EoHEngine` manually if you need to point to custom PDKs or different synthesis timeouts.
- **Benchmark additions**: drop new problems under `data/bench/<suite>` with `{problem}_test.sv`, `{problem}_ref.sv`, and update `synthesis_top_module_names.json`.

With the above steps you can reproduce the published experiments, validate changes locally, and extend the framework to new problem domains.
