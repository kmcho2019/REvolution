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
- `--search_mode revolution|revolution_qd` for the `revolution` backend
- shared model/benchmark options (`--benchmarks`, `--problems`, `--model_name`, `--api_backend`, `--save_path`)
- shared parallelism controls:
  - `--total_worker_slots <int>`
  - `--max_active_problems <int>`
  - `--max_workers_per_problem <int>`
- backend-specific controls (`--population_size`, `--num_generations`, `--strategy_selection`, `--fs_*`, `--eoh_*`, `--codeevolve_*`)
- shared evaluation controls:
  - `--evaluation_mode strict_ablation|search_accelerated`
  - `--accelerated_synthesis_top_k <int>` (used in `search_accelerated`)
- deterministic run controls (`--seed` with per-worker derived seeds)

`cvdp` benchmark support in `run_backend.py` is now enabled for `--backend revolution`
and `--backend eoh`. On this branch, the `revolution_qd` path uses the existing
JSONL-backed `cid002` / `cid003` subset and currently validates best through
focused tests plus bounded live-smoke attempts.
CodeEvolve phase 1 still targets `RTLLM` and `VerilogEval-Spec-to-RTL`
only; multi-file codebase tasks and CodeEvolve-specific `cvdp` adapters remain
deferred.

`RealBench` support in `run_backend.py` is currently manifest-driven and limited
to module-level tasks:

- point `--realbench_root` at a dataset root containing `module_manifest.json`
- keep `--realbench_subset module`
- expected manifest entry fields include `problem_name`, `prompt_path`,
  `test_sv_path`, optional `ref_sv_path`, optional `ppa_path`, `top_module`,
  and capability flags such as `supports_formal` / `supports_synthesis`
- fixture coverage exists on this branch, but there is still no checked-in
  dataset under `data/bench/RealBench`, so live RealBench smoke runs remain
  blocked until that dataset is added
- there is also a separate remote GitHub branch named `realbench` intended to
  land fuller RealBench benchmark/problem-analysis integration, but that branch
  is not merged into `wip/journal-extension-2026` yet

By default outputs are isolated by backend under `<save_path>/<backend>/...` (`--backend_subdir` can be disabled if needed).

In the default `elastic` mode, each active problem keeps one base slot and can
borrow extra evaluation threads when the global pool has spare capacity. That
lets long-running problems scale up after shorter problems finish without
having to pre-commit the run to a fixed problem/process split.

QD-mode controls on the `revolution` backend currently include:

- archive selection: `--qd_archive_type grid|cvt`
- descriptor selection:
  `--qd_descriptor_profile`,
  `--qd_descriptor_axes`,
  `--qd_descriptor_file`
- quality weighting:
  `--qd_quality_mode auto|ppa|functional_only`,
  `--qd_alpha`, `--qd_beta`, `--qd_gamma`
- per-phase generation-mode overrides:
  `--qd_fail_generation_mode`,
  `--qd_seed_generation_mode`,
  `--qd_backfill_generation_mode`,
  `--qd_refine_generation_mode`,
  `--qd_crossover_generation_mode`

Current feature status:

- `grid` is the active first runtime path and now has archive, scheduler, and
  benchmark-aware phase-mode runtime wiring.
- `cvt` now has an initial runtime path with warm-up buffering, frozen scaling,
  and nearest-centroid insertion over configured CVT axes.
- success-side QD fill/backfill now has dedicated operators:
  `M-T` for targeted descriptor mutation and `C-D` for diverse archive fusion.
- `auto` per-phase generation-mode selection now consults
  `ProblemSpec.phase_generation_defaults`, while explicit CLI/config overrides
  still take precedence.
- `success_view` in the grid runtime now samples from archive elites plus a
  small bounded per-cell reservoir of recent successful occupants.
- `qd_descriptor_file` may now define both `profiles:` and `grid_axes:` so the
  same YAML can control descriptor selection and per-axis grid bin/bounds
  settings.
- The current retrospective-analysis-driven profile ladder is:
  - immediate grid profile:
    `implemented_structural_compact_3d`
  - immediate CVT/control profile:
    `implemented_structural_fixed_5d`
  - early-stage runtime-supported retrospective profiles:
    `size_control_3d`, `timing_control_3d`
  - richer follow-on runtime-supported controls:
    `wire_assign_if_3d`, `size_sharing_3d`, `wire_ctrl_assign_3d`,
    `wire_if_math_3d`, `wire_always_ternary_3d`, `assign_always_math_3d`
  - experimental theory-grounded profiles:
    `theory_grounded_full_20d`, `theory_grounded_compact_8d`
  - exploratory activity profiles:
    `activity_size_3d`, `activity_control_3d`
- The theory-grounded profile combines AST cyclomatic complexity, Rent
  analysis, reconvergence, SCOAP histogram percentages, and normalized
  Laplacian descriptors through the new `graph_metrics` runtime payload. The
  raw `rent_exponent` metric is still emitted for analysis, but
  `theory_grounded_full_20d` now uses `rent_exponent_confidence_gated` so
  low-sample or clamped Rent fits shrink toward a neutral descriptor value.
  Treat it as a CVT-first research profile rather than a default replacement
  for the structural ladder.
- `theory_grounded_compact_8d` is the reduced follow-on candidate from the
  first hard-subset collapse pass. It keeps the strongest non-collapsed SCOAP
  and spectral axes and is now the first profile to try when you want a
  smaller theory-grounded CVT study on the hard subset. Under the tuned
  `16 / 4 / 0.25 / 2` CVT policy it improved theory-only stability,
  synthesis rate, and mean hypervolume versus the earlier 20D theory run, but
  it still trails the structural controls on archive QD score, elite quality,
  and pareto breadth.
- CVT archives that never hit `qd_cvt_warmup_successes` now finalize from the
  available warmup buffer at run end. That keeps low-success problems from
  ending with empty, permanently uninitialized CVT artifacts.
- When `qd_grid_axes` is omitted, grid mode now honors
  `qd_descriptor_profile`, so the compact structural profile above is actually
  enough to reproduce the retrospective refresh configuration.
- The fixed redo under
  `/tmp/qd_rich20x5_redo_full_fixed/20260314_115920` is now the main
  comparative reference for practical QD backend guidance on this branch; the
  earlier `/tmp/qd_rich20x5_refresh_v2` snapshots are still useful as
  intermediate history, but they should not be treated as the latest backend
  recommendation source.
- QD problem directories now also emit `descriptor_health.json` and
  `descriptor_health_report.md`, which summarize per-axis unique count,
  nonzero fraction, and collapse behavior over archive-handled successful
  candidates and the current archive elites.
- `scripts/backend_comparison_report.py` now renders those diagnostics in a
  dedicated `QD Descriptor Health` section, and `scripts/archive_baseline.py`
  preserves them when packaging QD runs for later review.
- `scripts/run_qd_retrospective_redo_vllm.sh` now encodes the long-budget
  `/tmp/qd_rich20x5`-style redo workflow as a tracked repo script instead of a
  loose command notebook.
- `scripts/run_backend_qd_smoke_vllm.sh` provides a repeatable QD smoke matrix
  for `grid` and `cvt` with `--suite rtllm|verilogeval`,
  `--policy whole-heavy|diff-heavy`, and `--dry-run`, and now defaults to a
  `128000`-token budget on the shared reasoning-model vLLM endpoint.
- `scripts/run_qd_theory_grounded_smoke_vllm.sh` provides a dedicated
  theory-grounded CVT harness with:
  - `--mode theory-only` for direct validation of
    `theory_grounded_full_20d`
  - `--mode compare` for side-by-side bounded smokes against
    `implemented_structural_fixed_5d`, `size_control_3d`,
    `theory_grounded_full_20d`, and `theory_grounded_compact_8d`
  - `--suite rtllm|verilogeval|matrix`, `--policy whole-heavy|diff-heavy`,
    and `--dry-run`
- `scripts/report_qd_rent_calibration.py` provides a manifest-driven offline
  calibration path for Rent analysis. Start from
  `data/configs/qd_theory_rent_calibration_example.json`, then point each case
  at an RTL file, top module, and optional stored RentCon output paths.
- `scripts/report_qd_rent_reference_validation.py` provides a synthesized-
  netlist validation path for Rent analysis. Point it at a prior experiment
  root that contains passing `code.syn.v` outputs and it will:
  - stage one passing synthesized netlist per problem into `exp/`
  - generate placed DEF files with OpenROAD
  - run the native RentCon binary plus the repo-native extractor
  - emit `final_analysis/rent_reference_validation_report.{json,md}` with raw
    versus confidence-gated accuracy/runtime deltas and plots
  Start with:
  `/workspace/.venv/bin/python scripts/report_qd_rent_reference_validation.py --run_root <hard_subset_run_root> --output_root exp/qd_rent_reference_validation_example --workers 1`
  Use `--workers 1` by default on this branch because the local RentCon binary
  is unstable on many OpenROAD-generated DEFs and sequential runs are more
  reproducible.
- `scripts/run_qd_theory_followup_vllm.sh` provides a bounded multi-problem
  CVT follow-up matrix over:
  - `implemented_structural_fixed_5d`
  - `size_control_3d`
  - `theory_grounded_full_20d`
  - `theory_grounded_compact_8d`
  Start with:
  `VLLM_HOST=host.docker.internal VLLM_PORT=8000 bash scripts/run_qd_theory_followup_vllm.sh --suite rtllm --dry-run`
- `scripts/run_qd_theory_followup_manifest.py` provides a manifest-driven
  broader matrix runner. Start from
  `data/configs/qd_theory_followup_broad_matrix.json`, then use:
  `python scripts/run_qd_theory_followup_manifest.py --manifest data/configs/qd_theory_followup_broad_matrix.json --dry-run`
- `scripts/report_qd_theory_followup.py` scans the resulting run root,
  summarizes profile outcomes, writes
  `recommended_theory_profile.json`, and also writes
  `theory_promotion_decision.json` from pairwise control deltas plus
  non-collapsed theory axes.
  Example:
  `python scripts/report_qd_theory_followup.py --run_root /tmp/qd_theory_followup/<run_tag> --output_dir /tmp/qd_theory_followup/<run_tag>/theory_followup_report`
- `scripts/run_evolution_smoke_vllm.sh` now uses the same `128000` token floor
  and forwards `--diff_max_tokens 128000` so whole-mode and diff-mode smokes
  are not accidentally evaluated under truncation-prone budgets.
- `scripts/run_backend.py` prints a warning when a large-context vLLM endpoint
  is paired with sub-`128000` `max_tokens` or `diff_max_tokens`. Treat that
  warning as an experiment-validity issue, not cosmetic noise.
- Bounded completion-grade smokes for both grid and CVT now complete on RTLLM
  and VerilogEval.
- Those small-budget smokes are only reachability checks; on larger
  RTLLM/VerilogEval problems, `128-256` completion-token budgets still leave
  the archive empty, so use materially larger token budgets for meaningful QD
  experiments.
- Earlier moderate-budget comparison runs that used `max_tokens=1024` on the
  shared reasoning-model vLLM endpoint should be treated as configuration-
  invalid for research conclusions. For this model family, use
  `--max_tokens 128000` and `--diff_max_tokens 128000` before drawing
  conclusions about archive fill, operator quality, or benchmark difficulty.
- Preliminary fixed `20 x 5` RTLLM/VerilogEval experiments give the following
  immediate recommendation ladder:
  - prefer `cvt` over `grid` for general-purpose QD runs
  - use `implemented_structural_fixed_5d` when the priority is final
    score/frontier quality
  - use `size_control_3d` when the priority is archive health, coverage, and
    QD score
  - use `implemented_structural_compact_3d` as the preferred grid control
  - keep classic `revolution` in serious comparisons because it still remains
    the safest non-QD baseline on some harder tasks
- The authoritative detailed status lives in
  `docs/revolution_qd_map_elites_implementation_plan.md`.
- The runtime behavior, file map, and trace-level walkthrough live in
  `docs/qd_map_elites_guide.md`.

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

`scripts/run_funsearch.py` is a convenience wrapper that injects
`--backend funsearch` and accepts the same shared elastic parallelism flags as
`run_backend.py`.

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
- `--problems <ids...>`: optional problem subset forwarded to every backend run, useful for live smoke checks
- `--revolution_population_size`, `--funsearch_initial_population_size`, `--eoh_population_size`, `--eoh_operators`, `--codeevolve_num_islands`, `--codeevolve_init_pop`: preferred schedule knobs used to derive candidate budgets
- `--rtl_simulation_timeout_s`, `--synthesis_timeout_s`, `--post_synthesis_simulation_timeout_s`: shared timeout knobs propagated to every backend command

The ablation runner propagates budget metadata to per-problem summaries (`run_budget.primary_budget_axis`, evaluation/call caps), which the backend comparison report consumes for fairness diagnostics.

### 3.2 Evolutionary runs (`scripts/run_evolution.py`)

This script distributes problems across worker processes and executes the multi-generation loop.

Essential arguments:

- `--benchmarks <names>`: select suites from `data/bench` (default: all).
- `--problems <ids>`: restrict to specific problems (optional).
- `--total_worker_slots <int>`: total run-wide worker budget.
- `--max_active_problems <int>`: cap how many problems can stay active at once.
- `--max_workers_per_problem <int>`: per-problem cap for borrowed evaluation threads.
- older config files that still use `num_workers`, `candidate_workers`, or `multiprocessing_mode` are translated to the elastic controls with warnings
- `--population_size <int>` / `--num_generations <int>`: evolutionary parameters.
- `--search_mode {revolution,revolution_qd}`: use the canonical backend runner for the experimental QD path; `run_evolution.py` forwards QD configs to `run_backend.py`.
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
- `--rtl_simulation_timeout_s <int>` / `--synthesis_timeout_s <int>` / `--post_synthesis_simulation_timeout_s <int>`: shared timeout controls for RTL compile/sim, synthesis/OpenROAD, and post-synthesis compile/sim.
- `--cvdp_jsonl <path>` / `--cvdp_categories <list>` / `--cvdp_simulation_timeout_s <int>`: enable CVDP dataset support (`bench/cvdp/...`) and control pytest/cocotb timeout (default 120 seconds).

Example (dual-pool UCB search):

```bash
python scripts/run_evolution.py \
  --benchmarks VerilogEval-Spec-to-RTL RTLLM \
  --model_name meta-llama/llama-3.3-70b-instruct \
  --api_backend openrouter \
  --total_worker_slots 32 \
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
  --total_worker_slots 1
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

Legacy `num_workers`, `candidate_workers`, and `multiprocessing_mode` fields
still load from config files. They are translated with explicit warnings to the
new elastic controls. New snapshots and manifests record only the resolved
elastic fields so the effective run capacity is clear after the fact.

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

### 3.3.1 Hard iteration subset baseline and matrix

The repo now includes a dedicated hard-subset workflow for RTLLM plus
VerilogEval-Spec-to-RTL iteration testing:

- `scripts/run_hard_iteration_one_shot_vllm.sh`: resumable vanilla one-shot
  baseline runner that skips completed problems, batches pending ones, and
  polls the configured endpoint before each batch.
- `scripts/build_hard_iteration_subset.py`: freeze the balanced hard subset
  from one-shot summaries, benchmark gate-count CSVs, and reference PPA-derived
  circuit typing.
- `scripts/run_hard_iteration_qd_vllm.sh`: run the long-budget `classic`,
  `grid_struct`, `cvt_struct`, and `cvt_size_control` matrix from the frozen
  subset config. The runner now also supports config-defined `matrix_modes`
  plus per-mode overrides for `qd_num_cells`,
  `qd_cvt_warmup_successes`, `qd_fill_target_fraction`, and
  `qd_cell_reservoir`, so the same wrapper can drive bounded archive-tuning
  sweeps without shell edits.
- The March 2026 hard-subset archive-tuning screen selected the current
  `cvt_size_control` pack as the balanced default for this workflow:
  `qd_archive_type=cvt`, `qd_num_cells=16`,
  `qd_cvt_warmup_successes=4`, `qd_fill_target_fraction=0.25`, and
  `qd_cell_reservoir=2`.
  `warmup2` is better only when raw synthesis rate is prioritized over archive
  quality, while `fill50` and `dense24` were not strong enough to replace the
  balanced default.
- `scripts/report_hard_iteration_analysis.py`: generate the post-run markdown
  report plus machine-readable summary for classic-vs-QD hard-subset results.
- `scripts/report_pareto_analysis.py`: generate per-problem Pareto-front
  figures plus aggregate hypervolume/frontier tables for backend comparisons.
- `scripts/report_qd_feature_space.py`: generate the deeper post-run QD
  feature-space report with successful-candidate tables, collapse diagnostics,
  regression summaries, and PCA/t-SNE plots.
- `scripts/report_final_analysis_bundle.py`: generate the formal
  `final_analysis/` bundle for a finished hard-subset run root.
- `scripts/report_qd_problem_histograms.py`: backfill per-problem CVT feature
  histograms with projected centroid/division overlays plus cumulative
  generation-history panels under each problem's `qd_feature_histograms/`
  subdirectory.

Typical flow:

```bash
HARD_ONE_SHOT_VLLM_HOST=host.docker.internal \
HARD_ONE_SHOT_VLLM_PORT=8000 \
HARD_ONE_SHOT_SAVE_PATH=exp/hard_iteration_one_shot_rerun_<date> \
bash scripts/run_hard_iteration_one_shot_vllm.sh

python scripts/build_hard_iteration_subset.py \
  --one-shot-root exp/hard_iteration_one_shot_rerun_<date> \
  --output-config data/configs/hard_iteration_subset.yaml \
  --output-csv baselines/hard_iteration_subset_vanilla_openai_gpt_oss_120b.csv

HARD_SUBSET_VLLM_HOST=host.docker.internal \
HARD_SUBSET_VLLM_PORT=8000 \
bash scripts/run_hard_iteration_qd_vllm.sh \
  --config data/configs/hard_iteration_subset.yaml \
  --mode matrix

python scripts/report_final_analysis_bundle.py \
  --run-root exp/hard_iteration_qd/<timestamp> \
  --subset-config data/configs/hard_iteration_subset.yaml

python scripts/report_hard_iteration_analysis.py \
  --subset-config data/configs/hard_iteration_subset.yaml \
  --backend_run classic=exp/hard_iteration_qd/<timestamp>/classic \
  --backend_run grid_struct=exp/hard_iteration_qd/<timestamp>/grid_struct \
  --backend_run cvt_struct=exp/hard_iteration_qd/<timestamp>/cvt_struct \
  --backend_run cvt_size_control=exp/hard_iteration_qd/<timestamp>/cvt_size_control \
  --output-dir exp/hard_iteration_qd/<timestamp>/analysis

python scripts/report_pareto_analysis.py \
  --subset-config data/configs/hard_iteration_subset.yaml \
  --backend_run classic=exp/hard_iteration_qd/<timestamp>/classic \
  --backend_run grid_struct=exp/hard_iteration_qd/<timestamp>/grid_struct \
  --backend_run cvt_struct=exp/hard_iteration_qd/<timestamp>/cvt_struct \
  --backend_run cvt_size_control=exp/hard_iteration_qd/<timestamp>/cvt_size_control \
  --output-dir exp/hard_iteration_qd/<timestamp>/pareto_analysis

python scripts/report_qd_feature_space.py \
  --subset-config data/configs/hard_iteration_subset.yaml \
  --backend_run classic=exp/hard_iteration_qd/<timestamp>/classic \
  --backend_run grid_struct=exp/hard_iteration_qd/<timestamp>/grid_struct \
  --backend_run cvt_struct=exp/hard_iteration_qd/<timestamp>/cvt_struct \
  --backend_run cvt_size_control=exp/hard_iteration_qd/<timestamp>/cvt_size_control \
  --output-dir exp/hard_iteration_qd/<timestamp>/feature_analysis

python scripts/report_qd_problem_histograms.py \
  --run-root exp/hard_iteration_qd/<timestamp>
```

The post-run analysis surfaces have different roles:

- Stage 3 raw comparison: `exp/hard_iteration_qd/<run_tag>/hard_iteration_backend_comparison.md`
  - emitted directly by `scripts/run_hard_iteration_qd_vllm.sh`
  - shows the side-by-side backend comparison for the completed matrix run
- Formal bundle: `exp/hard_iteration_qd/<run_tag>/final_analysis/`
  - emitted by `scripts/report_final_analysis_bundle.py`
  - recreates the reference post-run layout with:
    - `backend_comparison.md`
    - `hard_iteration_analysis/`
    - `pareto_analysis/`
    - `feature_analysis/` when QD backends are present
    - `evolutionary_reports/`
  - writes top-level `report.md` and `summary.json` to index those sections
- Stage 4 final analysis: `exp/hard_iteration_qd/<run_tag>/analysis/report.md` plus `analysis/summary.json`
  - emitted by `scripts/report_hard_iteration_analysis.py`
  - summarizes aggregate backend performance, per-problem winners, and the recommendation fields:
    - `overall`
    - `score_qd`
    - `archive_qd`
    - `multi_objective`
  - `summary.json` is the machine-readable version of that final writeup surface
- Pareto / multi-objective analysis: `exp/hard_iteration_qd/<run_tag>/pareto_analysis/report.md` plus `pareto_analysis/summary.json`
  - emitted by `scripts/report_pareto_analysis.py`
  - summarizes per-problem Pareto hypervolume, frontier size, reference-beating counts, and backend-comparison front figures
- Deep QD feature-space analysis: `exp/hard_iteration_qd/<run_tag>/feature_analysis/report.md` plus `feature_analysis/summary.json`
  - emitted by `scripts/report_qd_feature_space.py`
  - summarizes successful-candidate feature variability, collapse behavior,
    regression outputs, and PCA/t-SNE projections
  - also writes `qd_successful_candidates.csv` and `recommended_profile.json`

Use a fresh post-fix one-shot root for the freeze step. Do not reuse any
pre-path-fix 2026-03-17 smoke or baseline outputs.

For resumed hard-subset one-shot baselines, set
`HARD_ONE_SHOT_BATCH_SIZE=0` when you want one `run_one_shot.py` invocation to
cover all remaining pending problems for a benchmark. This is useful when a
small fixed batch is being held open by one slow problem and you want freed
workers to keep pulling more pending work.

Example late-resume command:

```bash
HARD_ONE_SHOT_VLLM_HOST=host.docker.internal \
HARD_ONE_SHOT_VLLM_PORT=8000 \
HARD_ONE_SHOT_SAVE_PATH=exp/hard_iteration_one_shot_rerun_<date> \
HARD_ONE_SHOT_NUM_WORKERS=8 \
HARD_ONE_SHOT_BATCH_SIZE=0 \
bash scripts/run_hard_iteration_one_shot_vllm.sh \
  --benchmarks VerilogEval-Spec-to-RTL
```

### 3.4 Output inspection

Both scripts create a hierarchy under `exp/<model>/<benchmark>/<problem>/`:

- `Gen0/`, `Gen1/`, …: per-generation folders with `candidate_<idx>_thought.txt`, `candidate_<idx>.sv`, logs, and diff artefacts. In Gen0 runs the best artefact is also mirrored to `Gen0/best_candidate/` along with an evaluation summary when `--gen0_evaluate_best` is used.
- `generation_log.jsonl`: append-only record of every candidate with status, metrics, strategy metadata, and reward signals.
- `<problem>_summary.json`: final summary with champion metrics, runtime statistics, and token usage.
- `problem_run.log`: merged stdout/stderr captured by `StreamRedirector` from each worker process.

## 4. Utility scripts

- `scripts/evolutionary_report_generator.py`: generate Markdown reports summarising a run (`--experiment_path path/to/exp/...`).
- `scripts/backend_comparison_report.py`: combine multiple backend experiment roots into one side-by-side markdown report with pass/fail emojis, per-problem status, designs-with-any-pass counts, solved-only score/PPA deltas (including aggregate `PPA Delta (A/P/T)` and `Avg PPA Delta`) with regression checks, budget/fairness diagnostics, Pareto / multi-objective sections, and an extra QD archive section when `revolution_qd` summaries plus `archive_summary.json` sidecars are present. The loader now ignores `archive_summary.json` as a per-problem summary so QD runs are not double-counted (`--backend_run revolution=<path> --backend_run funsearch=<path> --backend_run eoh=<path> --backend_run codeevolve=<path>`).
- `scripts/run_backend_ablation.py`: one-command ablation sweep runner for REvolution/FunSearch/EoH/CodeEvolve plus optional comparison report generation, multi-seed loops (`--seeds`), strict fairness checks, selectable primary budget axis (`candidate_evaluations|llm_calls|dual_gate`), backend selection via `--backends`, and command validation via `--dry_run`.
  - Also writes top-level snapshots under `save_root` as `<timestamp>_ablation_config.yaml` and `<timestamp>_ablation_config_meta.yaml`.
- `scripts/run_backend.py`: backend-agnostic run orchestration for REvolution/FunSearch/EoH/CodeEvolve comparisons.
- `scripts/run_funsearch.py`: shortcut wrapper for FunSearch backend runs.
- `scripts/run_hard_iteration_one_shot_vllm.sh`: resumable one-shot hard-subset baseline harness for RTLLM and VerilogEval-Spec-to-RTL.
- `scripts/build_hard_iteration_subset.py`: turn one-shot summaries plus benchmark metadata into a frozen balanced hard-subset config and baseline CSV.
- `scripts/run_hard_iteration_qd_vllm.sh`: run the `classic`, `grid_struct`, `cvt_struct`, and `cvt_size_control` long-budget matrix from the frozen hard-subset config.
- `scripts/report_hard_iteration_analysis.py`: summarize hard-subset classic-vs-QD runs into a markdown report plus JSON recommendations.
- `scripts/report_pareto_analysis.py`: summarize hard-subset backend runs into Pareto-front figures plus per-backend hypervolume and frontier-size tables.
- `scripts/report_qd_feature_space.py`: summarize finished QD backend roots into successful-candidate tables, collapse diagnostics, regression outputs, and embedding plots.
- `scripts/report_final_analysis_bundle.py`: generate the formal `final_analysis/` directory for a finished hard-subset run root.
- `scripts/report_qd_problem_histograms.py`: emit per-problem CVT successful-candidate histograms, projected centroid/division overlays, and cumulative history views into `qd_feature_histograms/` under each problem directory.
- `data/configs/qd_descriptor_profiles_hard_iteration_large.yaml`: dedicated large-profile follow-up descriptor config for the hard-subset workflow, using the frozen `hard_iteration_large_struct10d` profile and coarse grid bins.
- `scripts/archive_baseline.py`: archive run roots into reproducible packages (`manifest.json`, copied configs/summaries, and compressed raw artifacts`). QD runs keep `archive_history.jsonl`, `archive_cells.csv`, `archive_summary.json`, `qd_metrics.json`, `grid_layout.json` or `centroids.json`, `archive_space.json`, `archive_space_report.md`, and the generated QD plots in the archived summary set so archive state is preserved even in `candidate_core` mode.
- QD candidate directories now also include `qd_archive_event.json` for every
  archive-handled successful candidate.
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
- **Timeout cleanup semantics**: RTL and synthesis timeouts now terminate the full subprocess tree for `iverilog`, `vvp`, `yosys`, and `openroad`. Reports identify the timed-out stage.
- **Old runs may still leak**: runs created before the subprocess-tree cleanup fix can leave orphaned EDA processes behind; clean them up manually before re-running comparisons.
- **LLM request stalls**: the shared OpenAI-compatible client now defaults to a 600-second request timeout instead of the previous effectively multi-hour timeout. If a model endpoint is slow but healthy, increase it deliberately instead of relying on a giant implicit default.
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
- Use `Prob144_conwaylife` when you specifically need a timeout-stress benchmark for evaluator cleanup and backend smoke validation. The primary real stress sample is `tests/fixtures/prob144_conwaylife_timeout/epoch22_timeout_cur_state_next_state.sv`, sourced from the historical leaked run at `Gen22/Prob144_conwaylife_epoch22_island1/code.sv`.
- When altering prompts or evaluation hooks, regenerate reports for a known run and confirm metrics match expectations.
- The summary JSON exposes `all_*_passed` sets to count how many unique candidates cleared each evaluation stage—use these to spot regressions in compilation or synthesis rates.

Suggested all-backend timeout smoke:

```bash
timeout 3600 python scripts/run_backend_ablation.py \
  --backends revolution funsearch eoh codeevolve \
  --benchmarks VerilogEval-Spec-to-RTL \
  --problems Prob144_conwaylife \
  --api_backend vllm \
  --vllm_host host.docker.internal \
  --vllm_port 8000 \
  --model_name /project/cad-team/LX_Semicon/models/openai-gpt-oss-120b \
  --evaluation_mode strict_ablation \
  --max_evaluations 6 \
  --primary_budget_axis candidate_evaluations \
  --rtl_simulation_timeout_s 60 \
  --synthesis_timeout_s 45 \
  --post_synthesis_simulation_timeout_s 45 \
  --temperature 0.7 \
  --top_p 0.95 \
  --max_tokens 16384 \
  --total_worker_slots 1 \
  --max_workers_per_problem 1 \
  --save_root /tmp/prob144_conwaylife_timeout_smoke
```

Suggested live single-sample timeout regression:

```bash
RUN_LIVE_EDA_SMOKE=1 pytest -q \
  tests/revolution/test_prob144_timeout_live.py \
  -k primary_timeout_stress
```

## 7. Customisation checklist

- **Prompt profile**: clone `data/prompts/default` and pass `prompt_profile` / `prompt_root` when instantiating `EoHEngine` programmatically to experiment with alternative instructions.
- **Strategy tweaks**: extend the `strategies` dictionary in `algorithm.py` to add new genetic operators. Remember to ship matching templates.
- **EDA overrides**: instantiate `EoHEngine` manually if you need to point to custom PDKs or different synthesis timeouts.
- **Benchmark additions**: drop new problems under `data/bench/<suite>` with `{problem}_test.sv`, `{problem}_ref.sv`, and update `synthesis_top_module_names.json`.

With the above steps you can reproduce the published experiments, validate changes locally, and extend the framework to new problem domains.
