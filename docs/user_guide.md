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

## 2. Repository assets

- `data/bench/<suite>/<problem>` holds the benchmark Verilog specs, testbenches, reference designs, and `synthesis_top_module_names.json` mapping required for synthesis.
- `data/prompts/<profile>` contains prompt templates consumed by `PromptStore`. Copy the `default` profile to author your own variants.
- `pdk/` stores Liberty/LEF/GDS resources used by the synthesis flow. The paths are resolved automatically by `SynthesisEvaluator`.

## 3. Running experiments

### 3.1 Evolutionary runs (`scripts/run_evolution.py`)

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
- `--epsilon`, `--ucb_c`: exploration constants used by the meta-strategies.
- `--generation_mode {whole,diff}`: default offspring mode for successful parents. Failed parents always fall back to `whole`.
- `--population_pool_mode {dual,single}`: dual maintains separate fail/success pools; single blends them but throttles fail-derived offspring once successes are available.
- `--evaluation_mode {standard,gen0}`: switch between the full pipeline and the latency-only Gen0 scorer.
- `--gen0_evaluate_best`: when used with `--evaluation_mode gen0`, replay the top-ranked candidate through the full functional testbench, synthesis, and OpenROAD PPA flow and store the logs under `Gen0/best_candidate/`.
- `--cvdp_jsonl <path>` / `--cvdp_categories <list>`: enable CVDP dataset support (`bench/cvdp/...`).

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
  --problems Prob001_example \
  --evaluation_mode gen0 \
  --population_size 16 \
  --num_workers 1
```

The `gen0` mode skips test benches, synthesis, and PPA analysis by default. It simply collects `population_size` candidates, scores them using the feedback LLM (the returned `score` field), and keeps the top-ranked artefacts under `Gen0/<problem>_sample*/`.

Add `--gen0_evaluate_best` to re-run the winning candidate through the full evaluation pipeline. The artefacts are copied to `Gen0/best_candidate/`, which contains the mirrored `code.sv`, the latest feedback, an evaluation summary, and any simulation/synthesis logs generated during the optional pass. If the benchmark does not ship a matching `<problem>_test.sv` the optional run aborts gracefully and documents the reason in `best_candidate_metadata.json`.

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

Every invocation writes `<timestamp>_config.yaml` next to the summary/log files in `exp/<model>/`. The snapshot records the merged argument set along with the originating CLI invocation and, when present, the config file contents. This makes it straightforward to re-run an experiment with identical settings.

### 3.2 Baseline n-shot runs (`scripts/run_one_shot.py`)

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

### 3.3 Output inspection

Both scripts create a hierarchy under `exp/<model>/<benchmark>/<problem>/`:

- `Gen0/`, `Gen1/`, …: per-generation folders with `candidate_<idx>_thought.txt`, `candidate_<idx>.sv`, logs, and diff artefacts. In Gen0 runs the best artefact is also mirrored to `Gen0/best_candidate/` along with an evaluation summary when `--gen0_evaluate_best` is used.
- `generation_log.jsonl`: append-only record of every candidate with status, metrics, strategy metadata, and reward signals.
- `<problem>_summary.json`: final summary with champion metrics, runtime statistics, and token usage.
- `problem_run.log`: merged stdout/stderr captured by `StreamRedirector` from each worker process.

## 4. Utility scripts

- `scripts/evolutionary_report_generator.py`: generate Markdown reports summarising a run (`--experiment_path path/to/exp/...`).
- `scripts/generate_cutoff_compile_result_variants.sh`: reproduce paper tables with a specified gate cutoff (`--gate 50` by default).
- `scripts/generate_visualizations*.py` and `plot_problem_pareto.py`: create PPA scatter plots or aggregate charts.
- `scripts/prompt_file_manager.py`: split and merge concatenated prompt bundles.
- `scripts/run_test.sh`, `run_regression_test.sh`, `run_cvdp_test.sh`: convenience wrappers for curated benchmark subsets.

All Python helper scripts accept `--help` to show the full argument list.

## 5. Troubleshooting tips

- **Missing executables**: `VerilogEvaluator` and `SynthesisEvaluator` perform `shutil.which` checks at instantiation. If you encounter `FileNotFoundError`, verify that `iverilog`, `vvp`, `yosys`, and `openroad` are discoverable or pass absolute paths when constructing the engines manually.
- **LLM schema errors**: malformed JSON responses are stored with `_format_error.json` metadata inside the candidate directory. Inspect these files to adjust prompts or retry with a different model.
- **Diff application failures**: candidates generated in diff mode create `<candidate>_diff_error.json` snapshots so you can review `search`/`replace` hunks.
- **Synthesis timeouts**: `SynthesisEvaluator` writes timeout or crash information directly into the `_synthesis_report.rpt` file. Consider loosening the design constraints or increasing resources.
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
