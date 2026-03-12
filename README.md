
-----

# REvolution: Evolutionary RTL Generation with Large Language Models

## Overview

**REvolution** orchestrates large language models (LLMs), logic simulation, and full physical design analysis to iteratively synthesize register-transfer level (RTL) implementations. Candidates are evolved across generations: each one captures an LLM thought process, Verilog code, and evaluation feedback; dual success/fail pools and adaptive strategy selection keep the exploration productive while pushing power, performance, and area (PPA) forward.

## Key Features

- Dual-pool evolutionary engine with configurable strategies (`M-*`, `C-F`) and meta-strategy selection (random, epsilon-greedy, UCB).
- Experimental `revolution_qd` search mode with grid and CVT archive support, configurable descriptor axes, and staged reporting/operator parity work.
- End-to-end evaluation pipeline: Icarus Verilog for syntax/functional checks, Yosys + OpenROAD for PPA, and post-synthesis regression.
- Unified LLM client with retry/backoff, prompt templating, diff/whole generation modes, and multi-backend support (OpenAI, OpenRouter, DeepSeek, Gemini, vLLM).
- Detailed JSONL logging, per-problem summaries, and prebuilt scripts for table generation and visualization.
- Benchmarks bundled from VerilogEval, RTLLM, and CVDP with reusable PDK assets.

## Documentation

The `docs/` directory contains deeper dives:

- `docs/implementation_details.md` – architecture and component responsibilities.
- `docs/revolution_qd_map_elites_implementation_plan.md` – living QD/MAP-Elites implementation status, validation notes, and staged roadmap.
- `docs/diff_mode.md` – diff-mode schema, policies, diagnostics, and benchmark workflow.
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
  
(Note that CVDP evaluations that depend on Docker might cause issues with this setup.)

### Devcontainer + optional shared vLLM Compose

REvolution now ships a Compose-based devcontainer (`.devcontainer/docker-compose.yml`) with an optional `vllm` service profile.

This is compatible with the LLM-EvoLegalizer devcontainer setup: both can join the same Docker network (`llm-evolegalizer-net`), so one vLLM server can be reused across both repositories.

1. Open REvolution in VS Code and reopen in container using `.devcontainer/devcontainer.json`.
2. Optional: configure vLLM launch variables by copying:
   ```bash
   cp .devcontainer/.env.example .devcontainer/.env
   ```
3. Start a shared vLLM service from either repo:
   ```bash
   docker compose -f .devcontainer/docker-compose.yml --profile vllm up -d vllm
   ```
4. From REvolution (inside devcontainer), target the server:
   - If vLLM runs on the shared network: use `--vllm_host vllm`.
   - If vLLM runs outside Compose: use `--vllm_host host.docker.internal` (or Linux bridge IP such as `172.17.0.1`).

Quick check from inside the REvolution devcontainer:

```bash
curl http://vllm:8888/v1/models
```

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

For a local vLLM server, ensure it is reachable at `http://localhost:8888/v1` (or the shared compose hostname `http://vllm:8888/v1`) and no API key is required.
Set `--api_backend` to `vllm` to use a local vLLM server.

`scripts/run_evolution.py` and `scripts/run_one_shot.py` read `VLLM_HOST` and `VLLM_PORT` environment variables for default host/port values, so you can avoid repeating `--vllm_host`/`--vllm_port` in devcontainer sessions.
All primary runners (`run_evolution.py`, `run_backend.py`, `run_one_shot.py`) perform a lightweight vLLM `/v1/models` preflight and print the served `max_model_len`.
Use `--vllm_min_model_len` (default `128000`) and `--vllm_preflight_timeout_s` to tune this gate. A failed preflight is reported as a warning and does not abort the run.
For reasoning-oriented vLLM models with large context windows, keep
`--max_tokens` high enough to avoid truncated JSON/code responses. On the
shared `/project/cad-team/LX_Semicon/models/openai-gpt-oss-120b` endpoint used
for CodeEvolve smoke tests, `--max_tokens 128000` is the safe setting. For
`--backend codeevolve --generation_mode diff`, the runner now promotes the
generic diff cap to match `--max_tokens` on large-context vLLM runs when the
default `--diff_max_tokens 1024` was left unchanged.


## Running the Framework

### Backend-selectable runner (`scripts/run_backend.py`)

Use `run_backend.py` for backend ablations across REvolution, FunSearch, EoH,
and CodeEvolve:

The `revolution` backend now also exposes the experimental QD search-mode
surface:

- `--search_mode revolution|revolution_qd`
- `--qd_archive_type grid|cvt`
- `--qd_descriptor_profile`, `--qd_descriptor_axes`, `--qd_descriptor_file`
- `--qd_fail_generation_mode`, `--qd_seed_generation_mode`,
  `--qd_backfill_generation_mode`, `--qd_refine_generation_mode`,
  `--qd_crossover_generation_mode`

Current status on this feature branch:

- `grid` is the active first runtime path for QD search.
- grid runtime `auto` phase selection now honors benchmark defaults from
  `ProblemSpec`, while explicit per-phase overrides still win.
- `success_view` is no longer elite-only; grid mode now keeps a small bounded
  per-cell reservoir for archive-adjacent parent sampling.
- `qd_descriptor_file` can now carry both descriptor profiles and per-axis
  `grid_axes` bin/bounds specs for structural or physical grid experiments.
- `cvt` now has an initial warm-up/freeze runtime path with nearest-centroid
  archive insertion.
- QD runs now emit archive-state artifacts alongside the legacy summary/log
  files: `archive_history.jsonl`, `archive_cells.csv`, `archive_summary.json`,
  `qd_metrics.json`, and `grid_layout.json` or `centroids.json`.
- QD runs now also emit visualization files from those artifacts:
  `coverage_vs_generation.png`, `best_quality_vs_generation.png`,
  `qd_score_vs_generation.png`, plus grid heatmaps or CVT projection plots for
  the final archive state.
- `scripts/backend_comparison_report.py` now skips QD sidecar summaries during
  per-problem loading and emits a dedicated QD archive metrics section when
  `revolution_qd` runs are present.
- `scripts/archive_baseline.py` now preserves QD archive sidecars in archived
  summary payloads, including the generated QD plots, so candidate-core
  archives do not silently drop archive state.
- QD success-side fill/backfill now has dedicated operators:
  `M-T` for targeted descriptor mutation and `C-D` for diverse cross-cell
  fusion.
- broader benchmark expansion and completion-grade live smokes are still staged
  work.
- `revolution` now accepts the existing `cvdp` subset path in
  `scripts/run_backend.py`, and the feature branch includes a manifest-based
  `RealBench` module adapter for future dataset drops under
  `data/bench/RealBench`.
- The detailed status and validation record lives in
  `docs/revolution_qd_map_elites_implementation_plan.md`.

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
  --fs_max_evaluations 64 \
  --seed 42
```

CodeEvolve phase 1 is intentionally scoped to `RTLLM` and
`VerilogEval-Spec-to-RTL` and keeps close to the upstream islands-based search
structure while reusing REvolution's evaluator and artifact pipeline.

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
  --codeevolve_max_evaluations 72 \
  --seed 42
```

`scripts/run_funsearch.py` is a convenience wrapper for
`run_backend.py --backend funsearch`.
Use `scripts/backend_comparison_report.py` to combine multiple backend experiment roots into one markdown comparison table.
Use `scripts/run_backend_ablation.py` to launch matched backend sets over shared
benchmark suites and emit a comparison report automatically. The ablation runner
now accepts `--backends revolution funsearch eoh codeevolve` and derives
fairness schedules per backend while preserving backend-specific mechanics.
Use `--problems` to constrain the sweep to a small problem subset when doing
live smoke validation of a new backend.

Example (experimental REvolution QD grid run):

```bash
python scripts/run_backend.py \
  --backend revolution \
  --search_mode revolution_qd \
  --qd_archive_type grid \
  --qd_grid_axes g_A g_T \
  --benchmarks RTLLM \
  --problems Prob001_accu \
  --api_backend vllm \
  --vllm_host host.docker.internal \
  --vllm_port 8000 \
  --model_name /project/cad-team/LX_Semicon/models/openai-gpt-oss-120b \
  --max_tokens 128000 \
  --population_size 4 \
  --num_generations 2
```

`run_backend.py` strict/accelerated evaluation controls:
- `--evaluation_mode strict_ablation|search_accelerated`:
  - `strict_ablation` (default): full syntax + functionality + synthesis/PPA for every candidate.
  - `search_accelerated`: runs syntax/functionality for all candidates and throttles synthesis.
- `--accelerated_synthesis_top_k <int>`: in `search_accelerated`, only the top-K functional candidates per batch are synthesized (deterministic shortest-code policy).

FunSearch feedback controls:
- `--fs_feedback_policy off|fail_only|always` (default `off`).
- `--fs_feedback_sample_probability <0..1>`.

CodeEvolve controls:
- `--codeevolve_num_islands`, `--codeevolve_num_epochs`, `--codeevolve_init_pop`
- `--codeevolve_exploration_rate`, `--codeevolve_selection_policy`
- `--codeevolve_meta_prompting`, `--codeevolve_num_inspirations`
- `--codeevolve_migration_topology`, `--codeevolve_migration_interval`, `--codeevolve_migration_rate`
- `--codeevolve_max_evaluations`, `--codeevolve_max_llm_calls`, `--codeevolve_max_runtime_seconds`
- Practical note for reasoning-heavy vLLM models: prefer a large `--max_tokens`
  budget first, then tune `--diff_max_tokens` only after verifying the model is
  not truncating JSON envelopes. CodeEvolve diff runs now auto-promote the
  default diff cap on large-context vLLM endpoints so the overall generation
  budget is not silently undercut.

### Multi-problem evolution (`scripts/run_evolution.py`)

This script distributes problems across worker processes and executes the full evolutionary loop. Key arguments:

- `--benchmarks` / `--problems`: control which suites and problem IDs run.
- `--num_workers`: worker count (processes in `problem` mode, candidate-evaluation threads in `candidate` mode).
- `--multiprocessing_mode`: `problem` (default) or `candidate` to switch between multi-problem and per-problem parallelism.
- `--population_size`, `--num_generations`: evolutionary dynamics.
- `--strategy_selection`: choose meta-strategy (`random`, `epsilon-greedy`, `ucb`).
- `--generation_mode`: request whole-file or diff-based offspring generation. (`whole` mode works by generating entire snippets of code from scratch whereas `diff` mode is able to edit snippets of code with an editing format. Weaker models may have trouble adhering to `diff` mode formatting resulting errors and lower performance, `whole` mode is recommended for general purpose use.)
- `--diff_apply_policy`: diff matching strictness (`strict`, `hybrid`, `fuzzy`; default `hybrid`).
- `--diff_max_tokens`: lower per-request generation cap for diff offspring (default `1024`).
- `--diff_compact_context/--no-diff_compact_context`: control prompt context compaction in diff mode.
- `--diff_similarity_threshold`, `--diff_fuzzy_margin`: fuzzy fallback controls for diff hunk matching.
- `--population_pool_mode`: dual or single pool scheduling. (`dual` mode is the default)
- `--api_backend`: Specifies the API backend to use for LLM calls.
  - Default: `openai`
  - Choices: `openai`, `openrouter`, `deepseek`, `gemini`, `vllm`
- `--model_name`: The specific model identifier to use (e.g., `gpt-4.1-mini`).
- `--vllm_host`, `--vllm_port`: Specify host/port for a local vLLM server (only used if `--api_backend` is `vllm`).
- `--evaluation_mode`: use `gen0` for the new latency-optimised initial-generation scorer or `standard` for full evolution.
- `--cvdp_jsonl`, `--cvdp_categories`, `--cvdp_simulation_timeout_s`: enable CVDP dataset integration and control pytest/cocotb timeout (default 120s).
- `--save_path`: override default run save path with a custom one, must be a full absolute path.

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

Latency-only Gen0 sampling (no simulation or synthesis) for a single problem:

```bash
python scripts/run_evolution.py \
  --benchmarks VerilogEval-Spec-to-RTL \
  --problems Prob001_zero \
  --evaluation_mode gen0 \
  --population_size 16 \
  --num_workers 1
```

Add `--gen0_evaluate_best` to run the same search but also execute the functional testbench, synthesis, and OpenROAD PPA flow for the top-ranked candidate. The resulting logs are collated under `Gen0/best_candidate/` alongside a metadata summary:

```bash
python scripts/run_evolution.py \
  --benchmarks VerilogEval-Spec-to-RTL \
  --problems Prob001_zero \
  --evaluation_mode gen0 \
  --gen0_evaluate_best \
  --population_size 16
```

Custom prompt exploration without a benchmark folder is also supported. Provide a standalone text file and Gen0 mode will treat it as the problem description, skipping benchmark discovery entirely:

```bash
python scripts/run_evolution.py \
  --evaluation_mode gen0 \
  --gen0_prompt_file path/to/custom_prompt.txt \
  --population_size 16 \
  --model_name gpt-4.1-mini
```

The prompt name defaults to the file stem; override it with `--gen0_prompt_name`. Because no benchmark assets exist, `--gen0_evaluate_best` is ignored in this mode.

#### Configuration files

`run_backend.py`, `run_evolution.py`, `run_one_shot.py`, and
`run_backend_ablation.py` accept a `--config path/to/config.yaml` (or `.json`)
flag. The file provides defaults for any CLI option and can contain only the
parameters you wish to override; explicit CLI arguments always take precedence.
Example templates live in `data/configs/` and mirror the available flags for
each script, including `data/configs/codeevolve_default.yaml` for reproducible
CodeEvolve runs.

Every run now records configuration in two files:
- `<timestamp>_config.yaml`: flat runnable arguments (directly reusable with `--config`).
- `<timestamp>_config_meta.yaml`: provenance metadata (originating CLI arguments, original config path, and source config values when present).

Backward compatibility is preserved: legacy nested snapshots containing `resolved_arguments` are still accepted as config input.

### Archiving experiment runs (`scripts/archive_baseline.py`)

Use `archive_baseline.py` to snapshot completed runs (single model runs or ablation roots) into `baselines/` with:
- copied summary/report files,
- copied run config snapshots (`*_config.yaml|yml|json`),
- a compressed `raw_results.tar.xz`,
- `manifest.json` metadata and archive index entries (`index.csv`, `index.jsonl`).

Single-run archive example:

```bash
python scripts/archive_baseline.py \
  --run-dir exp/stub-model \
  --archive-root baselines
```

Ablation-root archive example:

```bash
python scripts/archive_baseline.py \
  --run-dir exp/ablation/ablation_pop10_gen20_20260212_115506 \
  --archive-root baselines
```

Default candidate-core archive mode keeps only candidate code/thought/feedback in `raw_results.tar.xz` while preserving copied configs/summaries:

```bash
python scripts/archive_baseline.py \
  --run-dir exp/stub-model \
  --archive-root baselines
```

Optional full artifact mode (keeps all non-summary raw outputs):

```bash
python scripts/archive_baseline.py \
  --run-dir exp/stub-model \
  --archive-root baselines \
  --artifact-mode full
```

The script enforces reproducibility: it fails if no run config snapshots are found under `--run-dir`.

### Diff mode benchmark harness (`scripts/run_diff_mode_benchmark.py`)

This script runs matched `whole` and `diff` experiments on hard tasks and writes:
- `results.json`: aggregate token/runtime/pass-rate comparison.
- `results.md`: markdown summary report.
- `diff_failure_catalog.json`: grouped `*_diff_apply_error.json` reasons and examples.

By default it runs the renewal-plan validation matrix with matched seeds:
- RTLLM hard set (6): `Prob026_asyn_fifo`, `Prob033_freq_divbyfrac`, `Prob034_freq_divbyodd`, `Prob032_freq_divbyeven`, `Prob018_float_multi`, `Prob010_radix2_div`
- VerilogEval-Spec-to-RTL hard set (6): `Prob149_ece241_2013_q4`, `Prob095_review2015_fsmshift`, `Prob099_m2014_q6c`, `Prob062_bugs_mux2`, `Prob155_lemmings4`, `Prob156_review2015_fancytimer`
- CVDP medium set (6): deterministic `cid002/cid003` selection by largest prompt length (`input` field).

Use `--selection_profile baseline_hard` to switch back to baseline-pass-rate-driven hard selection.

Example:

```bash
python scripts/run_diff_mode_benchmark.py \
  --model_name /models/openai-gpt-oss-120b \
  --api_backend vllm \
  --vllm_host vllm \
  --vllm_port 8888 \
  --seeds 1 2 \
  --population_size 4 \
  --num_generations 2
```

### Diff robustness diagnostics (`scripts/run_diff_mode_diagnostics.py`)

Run repeated real-LLM stress checks over curated diff-failure cases (escaping, duplicate anchors, minimal context, long-file edits):

```bash
python scripts/run_diff_mode_diagnostics.py \
  --model_name /models/openai-gpt-oss-120b \
  --api_backend vllm \
  --vllm_host vllm \
  --vllm_port 8888 \
  --repeat_per_case 3
```

### Backend ablation orchestrator (`scripts/run_backend_ablation.py`)

Example strict-ablation sweep across all non-CVDP suites, two seeds, and automatic report output:

```bash
python scripts/run_backend_ablation.py \
  --api_backend vllm \
  --vllm_host vllm \
  --vllm_port 8888 \
  --model_name /models/openai-gpt-oss-120b \
  --evaluation_mode strict_ablation \
  --max_evaluations 1 \
  --seeds 42 43 \
  --num_workers 8
```

The script enforces fairness checks before launching runs:
- shared model/sampling/toolchain options must match across backends,
- strict-ablation mode is required for comparison runs,
- primary budget axis (`total_candidates_evaluated`) must match.

Use `--dry_run` to validate and print all generated backend commands without executing live runs.

Each ablation invocation also writes top-level snapshots under `save_root`:
- `<timestamp>_ablation_config.yaml`
- `<timestamp>_ablation_config_meta.yaml`

#### Running CVDP Benchmarks
> **⚠️ CVDP support is experimental.**
> CVDP integration is currently tested only on the non-agentic, non-commercial subsets (`cid002`, `cid003`).
> When running inside Docker, CVDP evaluations may encounter filesystem or dependency issues that do not appear in host runs.

The script uses special logic to handle the CVDP benchmark. To run CVDP, you must include `cvdp` in the `--benchmarks` argument. This is due to the fact that CVDP benchmarks are based around `.jsonl` files while other benchmark files are based around simple text files. We currently only support non-agentic non-commercial subset of the CVDP benchmarks (`cid002`, `cid003`).
- Running a batch (all problems in a category): To run all problems from the JSONL file that match one or more categories, use the --cvdp_categories flag.
```bash
# Run all CVDP problems matching the 'cid002' category
python scripts/run_evolution.py \
  --benchmarks cvdp \
  --cvdp_categories cid002 \
  --model_name gpt-4.1-mini \
  --num_workers 10
```
- Running individual problems: To run one or more specific CVDP problems by their ID, provide them using the `--problems` argument.
```bash
# Run only two specific CVDP problem IDs
python scripts/run_evolution.py \
  --benchmarks cvdp \
  --cvdp_categories cid002 cid003 \
  --problems cvdp_copilot_64b66b_decoder_0001 cvdp_copilot_16qam_mapper_0001 \
  --cvdp_simulation_timeout_s 120 \
  --model_name gpt-4.1-mini \
  --num_workers 2 \
  --population_size 10 \
  --num_generations 5
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

Runs write artifacts under `exp/<model>/<benchmark>/<problem>/`. Each generation now has per-candidate folders such as `Gen5/prob_sample3_M-F/` that contain `code.sv`, `thought.txt`, optional diff artifacts, and any feedback files. Generation-wide log files (`generation_log.jsonl`) and `<problem>_summary.json` live alongside the `Gen*` directories.

In Gen0 mode, the top candidate is also mirrored to `Gen0/best_candidate/` for quick inspection. When `--gen0_evaluate_best` is enabled this directory includes the optional evaluation logs and a `best_candidate_metadata.json` file that records the source folder, score, and end-to-end status.

Use `scripts/gen0_report_generator.py --experiment_path exp/<run>/<model>` to audit those snapshots in bulk. The report flags compilation, simulation, and synthesis outcomes and can emit a Markdown summary with `--save_markdown`.

## Report Generation and Utilities

- `scripts/evolutionary_report_generator.py`: turn a problem directory into a Markdown report with candidate-level PPA stats.
- `scripts/gen0_report_generator.py`: scan `Gen0/best_candidate` snapshots and summarise syntax, simulation, and PPA outcomes (use `--save_markdown` to export a table).
- `scripts/archive_baseline.py`: archive run roots into reproducible baseline packages with manifest, copied configs, summary files, and compressed artifacts.
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
