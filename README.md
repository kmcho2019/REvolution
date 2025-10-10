
-----

# REvolution: Evolutionary RTL Generation with Large Language Models

## Overview

**REvolution** orchestrates large language models (LLMs), logic simulation, and full physical design analysis to iteratively synthesize register-transfer level (RTL) implementations. Candidates are evolved across generations: each one captures an LLM thought process, Verilog code, and evaluation feedback; dual success/fail pools and adaptive strategy selection keep the exploration productive while pushing power, performance, and area (PPA) forward.

## Key Features

- Dual-pool evolutionary engine with configurable strategies (`M-*`, `C-F`) and meta-strategy selection (random, epsilon-greedy, UCB).
- End-to-end evaluation pipeline: Icarus Verilog for syntax/functional checks, Yosys + OpenROAD for PPA, and post-synthesis regression.
- Unified LLM client with retry/backoff, prompt templating, diff/whole generation modes, and multi-backend support (OpenAI, OpenRouter, DeepSeek, Gemini, vLLM).
- Detailed JSONL logging, per-problem summaries, and prebuilt scripts for table generation and visualization.
- Benchmarks bundled from VerilogEval, RTLLM, and CVDP with reusable PDK assets.

## Documentation

The `docs/` directory contains deeper dives:

- `docs/implementation_details.md` – architecture and component responsibilities.
- `docs/module_structure.md` – file-by-file breakdown of the codebase.
- `docs/method_interaction_and_evolutionary_loop.md` – data flow through the evolutionary loop.
- `docs/user_guide.md` – setup, CLI usage, troubleshooting, and testing guidance.

## Environment Setup

### Docker workflow (recommended)

1. Install Docker.
2. Build the image (installs toolchains and Python dependencies):
   ```bash
   docker build -t revolution-env .
   ```
3. Start an interactive container with API keys:
   ```bash
   docker run --rm -it \
     -e OPENAI_API_KEY="your-openai-key" \
     -e DEEPSEEK_API_KEY="your-deepseek-key" \
     -e OPENROUTER_API_KEY="your-openrouter-key" \
     revolution-env
   ```
   The project is mounted at `/workspace` with all required EDA tools available.

### Local development setup

1. Install the external binaries and ensure they are on `PATH`:
   - Yosys `0.54+29`
   - Icarus Verilog `v12_0`
   - OpenROAD `v2.0-22560-gb571c4b471`
2. Install [uv](https://github.com/astral-sh/uv) and provision the virtual environment:
   ```bash
   uv sync
   source .venv/bin/activate
   ```
3. The bundled `pyproject.toml` and `uv.lock` will install the Python dependencies used by the framework and scripts.

### LLM API configuration

Set the appropriate environment variables before running any script:

```bash
export OPENAI_API_KEY="..."
export OPENROUTER_API_KEY="..."
export DEEPSEEK_API_KEY="..."
export GEMINI_API_KEY="..."   # optional
```

For a local vLLM server, ensure it is reachable at `http://localhost:8888/v1` (or override with `--vllm_port`) and no API key is required.

## Running the Framework

### Multi-problem evolution (`scripts/run_evolution.py`)

This script distributes problems across worker processes and executes the full evolutionary loop. Key arguments:

- `--benchmarks` / `--problems`: control which suites and problem IDs run.
- `--num_workers`: process-level parallelism across problems.
- `--population_size`, `--num_generations`: evolutionary dynamics.
- `--strategy_selection`: choose meta-strategy (`random`, `epsilon-greedy`, `ucb`).
- `--generation_mode`: request whole-file or diff-based offspring generation.
- `--population_pool_mode`: dual or single pool scheduling.
- `--api_backend`, `--model_name`, `--vllm_port`: LLM configuration.
- `--cvdp_jsonl`, `--cvdp_categories`: enable CVDP dataset integration.

Example (RTLLM + VerilogEval with OpenRouter):

```bash
python scripts/run_evolution.py \
  --benchmarks RTLLM VerilogEval-Spec-to-RTL \
  --model_name meta-llama/llama-3.3-70b-instruct \
  --api_backend openrouter \
  --strategy_selection ucb \
  --num_workers 32 \
  --population_size 10 \
  --num_generations 20
```

### Single-shot baseline (`scripts/run_one_shot.py`)

Generate and evaluate an `n`-shot population without any evolutionary iterations—useful for baseline pass-rate estimation:

```bash
python scripts/run_one_shot.py \
  --benchmarks VerilogEval-Spec-to-RTL \
  --num_samples 50 \
  --model_name gpt-4.1-mini \
  --api_backend openai
```

### Output layout

Runs write artifacts under `exp/<model>/<benchmark>/<problem>/`, including candidate Verilog, simulation logs, synthesis reports, JSONL generation logs, and a `<problem>_summary.json` summary.

## Report Generation and Utilities

- `scripts/evolutionary_report_generator.py`: turn a problem directory into a Markdown report with candidate-level PPA stats.
- `scripts/generate_cutoff_compile_result_variants.sh`: reproduce paper tables with a gate-count cutoff (default 50).
- `scripts/generate_compiled_table.py` and friends: batch aggregations across experiments.
- `scripts/plot_problem_pareto.py`: recreate the PPA scatter plots for selected problems.
- `scripts/prompt_file_manager.py`: manage concatenated prompt bundles for `PromptStore`.

## Testing and Validation

- Unit tests live in `tests/` and can be executed with:
  ```bash
  pytest
  ```
- Generate a coverage report to confirm the newly added cases (PromptStore, logging, stream redirection, and single-pool evolution) are exercised:
  ```bash
  pytest --cov=src/revolution --cov-report=term-missing
  ```
- Hardware regressions and example flows are provided under `scripts/run_test.sh`, `scripts/run_regression_test.sh`, and `scripts/run_cvdp_test.sh`. These rely on the same toolchain dependencies as the main engine.

Refer to `docs/user_guide.md` for troubleshooting tips, recommended validation steps, and more CLI examples.
