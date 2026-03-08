# CodeEvolve Implementation Notes

## Purpose

This document cross-walks the vendored `science-codeevolve` project and paper
against the REvolution integration implemented on this branch. It is the
companion document to `CodeEvolve_IMPLEMENTATION_PLAN.md` and focuses on
fidelity, repo-fit, and maintainability decisions.

## Source Material

- Paper markdown: `/workspace/ablation/CodeEvolve/CodeEvolve_2510.14150v3.md`
- Paper PDF: `/workspace/ablation/CodeEvolve/CodeEvolve_2510.14150v3.pdf`
- Vendored repo: `/workspace/ablation/CodeEvolve/science-codeevolve`
- Original integration plan:
  `/workspace/ablation/CodeEvolve/CodeEvolve_IMPLEMENTATION_PLAN_original.md`

## Repo-Fit Analysis

- Upstream CodeEvolve is a general code-evolution framework, not an RTL-native
  runner.
- Its runtime expects a problem directory with evaluator scripts and an initial
  source tree; REvolution instead exposes benchmark/problem contexts and a
  candidate evaluator API.
- Upstream declares Python `>=3.13.5`, while this repository targets Python
  3.11.
- The strongest reusable asset for this repo is the algorithm shape, not the
  upstream runtime shell.

## Alignment with the Original Plan

### Implemented as planned

- Native `codeevolve` backend integrated into REvolution
- Phase-1 scope limited to `RTLLM` and `VerilogEval-Spec-to-RTL`
- New prompt profile and config template added
- `run_backend.py`, `run_backend_ablation.py`, `run_evolution.py`, and
  `archive_baseline.py` updated for CodeEvolve support
- Docs and tests added

### Intentional divergences from upstream CodeEvolve

- No direct use of upstream CLI/process orchestration
- No checkpoint/resume in phase 1
- No embeddings or MAP-Elites in phase 1
- No copied benchmark sandbox trees or upstream `input/src/init_program.py`
  packaging model
- No multi-file program editing in phase 1
- Prompt construction is adapted to REvolution prompt-store templates and
  summary artifacts rather than upstream `PromptSampler` chat message objects

### Review-driven corrections after the first implementation pass

- The initial phase-1 seed program was too weak relative to the original plan.
  It now derives a module stub from the benchmark prompt interface for both
  RTLLM-style and VerilogEval-style prompts.
- CodeEvolve epoch metrics originally overstated `meta_prompt_failures` by
  counting initialization/exploration steps where no meta-prompt was attempted.
  The accounting now tracks only real attempts.
- Generation statistics now include explicit per-epoch stage pass counts instead
  of only coarse success-rate aggregates.
- Duplicate program-registration bookkeeping was reduced to keep the large
  backend file from drifting internally.

## Phase-1 Preserved Mechanics

- Islands-based search
- Separate solution and prompt populations
- Exploration vs exploitation split
- Inspiration-based crossover
- Meta-prompting during exploration
- Ancestor-depth exploitation context
- Migration topology, interval, and rate
- Optional exploration scheduler
- Higher-is-better fitness orientation

## Phase-1 Deferred or Adapted

- Direct CLI/process orchestration
- Checkpointing
- MAP-Elites
- Embeddings
- Multi-file codebase editing
- Upstream benchmark packaging and sandbox-copy workflow
- Distinct exploration/exploitation LLM ensembles from upstream; REvolution
  currently uses its existing LLM service model and sampling controls

## Maintainability Assessment

### What looks acceptable

- `src/revolution/backends/registry.py` is a small, low-risk abstraction that
  removes repeated hardcoded backend metadata from runners
- The ablation runner refactor is justified by the requirement to support more
  than three backends and future comparison backends
- Reusing REvolution's evaluator, artifact writer, and diff applier keeps the
  new backend aligned with the rest of the repository

### Main tech-debt risk

- `src/revolution/backends/codeevolve_backend.py` is large and now owns task
  adaptation, prompt building, search control, migration bookkeeping, and
  summary writing in one file

### Current recommendation

- Do not split the backend further during phase 1 just to introduce new layers
  of indirection
- If phase 2 adds another CodeEvolve-style domain adapter or more prompt logic,
  split along concrete seams only:
  - task adapter
  - prompt/context builder
  - island/program bookkeeping helpers

## Live Smoke Findings

- Live endpoint confirmed at `http://host.docker.internal:8000/v1/models`
- Served model used for preliminary smoke:
  `/project/cad-team/LX_Semicon/models/openai-gpt-oss-120b`
- `RTLLM` whole mode succeeded under a 2-evaluation smoke when `max_tokens`
  was raised back to the default 2048 budget
- `VerilogEval-Spec-to-RTL` whole mode succeeded under the smaller 1024-token
  smoke budget
- `VerilogEval-Spec-to-RTL` diff mode initially failed for backend-side reasons
  and then passed after two narrow cleanups:
  - the diff applier now accepts the logical file name `code.sv` in addition to
    the concrete run-artifact path
  - non-initializing CodeEvolve prompts no longer include `seed_code`, which
    had been distracting the model away from the actual parent candidate
- `RTLLM` diff mode remains less stable with this served model under tiny smoke
  budgets; generation 1 could pass, but generation 2 still produced empty or
  malformed responses in some runs
- 128k completion-budget reruns on the same endpoint clarified causality:
  - `RTLLM` whole still succeeded
  - `VerilogEval-Spec-to-RTL` diff still succeeded
  - `RTLLM` diff still failed, but the failure shifted from apparent truncation
    concerns to genuine syntax/empty-response issues
- Conclusion from the reruns: the earlier live fixes remain justified and do
  not appear to be papering over an artificially low completion budget
- Additional smoke analysis exposed one more runner-level issue: CodeEvolve diff
  offspring were still using the generic `--diff_max_tokens 1024` cap even when
  the user set a much larger `--max_tokens` budget for a reasoning-oriented
  vLLM model. That made the live diff path look worse than intended.
- Fix applied:
  - promote CodeEvolve diff-generation token caps to match `--max_tokens` on
    large-context vLLM runs when the default diff cap was left unchanged
  - tighten CodeEvolve prompt text to stress single-driver RTL, exact interface
    preservation, and correctness-first repairs
- Result of the follow-up smoke rerun:
  - `RTLLM` diff improved from syntax/format failure to a valid diff candidate
    that compiled and simulated, though the generation-2 candidate still failed
    functionality
  - `VerilogEval-Spec-to-RTL` diff remained fully successful after the change

## Concrete Follow-Ups

- Compare current prompt templates against upstream mock/reference configs and
  document any deliberate remaining prompt-shape differences
- Run a slightly wider live matrix before treating CodeEvolve as publishable in
  backend comparison figures:
  - 3 to 5 `RTLLM` problems in whole mode
  - 3 to 5 `VerilogEval-Spec-to-RTL` problems in whole and diff modes
- Decide whether the shared reasoning-model endpoint should always be validated
  first with `--max_tokens 128000`, then down-tuned only after format stability
  is demonstrated
- Revisit `RTLLM` diff-mode prompt stability only if diff-mode RTL ablations
  become a required publishable result
- Revisit backend file splitting only if phase-2 scope expands

## Execution Commands Used for Preliminary Smoke

- `python scripts/run_backend.py --backend codeevolve --benchmarks RTLLM --problems Prob001_accu --api_backend vllm --vllm_host host.docker.internal --vllm_port 8000 --model_name /project/cad-team/LX_Semicon/models/openai-gpt-oss-120b --save_path /workspace/exp/codeevolve_smoke/rtllm_whole_2048 --num_workers 1 --candidate_workers 0 --evaluation_mode strict_ablation --temperature 0.7 --top_p 0.95 --max_tokens 2048 --generation_mode whole --prompt_profile codeevolve --seed 42 --codeevolve_num_islands 1 --codeevolve_num_epochs 2 --codeevolve_init_pop 1 --codeevolve_exploration_rate 0.2 --codeevolve_max_evaluations 2 --codeevolve_max_runtime_seconds 900`
- `python scripts/run_backend.py --backend codeevolve --benchmarks VerilogEval-Spec-to-RTL --problems Prob001_zero --api_backend vllm --vllm_host host.docker.internal --vllm_port 8000 --model_name /project/cad-team/LX_Semicon/models/openai-gpt-oss-120b --save_path /workspace/exp/codeevolve_smoke/verilogeval_whole --num_workers 1 --candidate_workers 0 --evaluation_mode strict_ablation --temperature 0.7 --top_p 0.95 --max_tokens 1024 --generation_mode whole --prompt_profile codeevolve --seed 42 --codeevolve_num_islands 1 --codeevolve_num_epochs 2 --codeevolve_init_pop 1 --codeevolve_exploration_rate 0.2 --codeevolve_max_evaluations 2 --codeevolve_max_runtime_seconds 900`
- `python scripts/run_backend.py --backend codeevolve --benchmarks VerilogEval-Spec-to-RTL --problems Prob001_zero --api_backend vllm --vllm_host host.docker.internal --vllm_port 8000 --model_name /project/cad-team/LX_Semicon/models/openai-gpt-oss-120b --save_path /workspace/exp/codeevolve_smoke/verilogeval_diff_promptfix --num_workers 1 --candidate_workers 0 --evaluation_mode strict_ablation --temperature 0.7 --top_p 0.95 --max_tokens 1024 --generation_mode diff --prompt_profile codeevolve --seed 42 --codeevolve_num_islands 1 --codeevolve_num_epochs 2 --codeevolve_init_pop 1 --codeevolve_exploration_rate 0.2 --codeevolve_max_evaluations 2 --codeevolve_max_runtime_seconds 900`
- `python scripts/run_backend.py --backend codeevolve --benchmarks RTLLM --problems Prob001_accu --api_backend vllm --vllm_host host.docker.internal --vllm_port 8000 --model_name /project/cad-team/LX_Semicon/models/openai-gpt-oss-120b --save_path /workspace/exp/codeevolve_smoke_128k/rtllm_whole --num_workers 1 --candidate_workers 0 --evaluation_mode strict_ablation --temperature 0.7 --top_p 0.95 --max_tokens 128000 --generation_mode whole --prompt_profile codeevolve --seed 42 --codeevolve_num_islands 1 --codeevolve_num_epochs 2 --codeevolve_init_pop 1 --codeevolve_exploration_rate 0.2 --codeevolve_max_evaluations 2 --codeevolve_max_runtime_seconds 900`
- `python scripts/run_backend.py --backend codeevolve --benchmarks RTLLM --problems Prob001_accu --api_backend vllm --vllm_host host.docker.internal --vllm_port 8000 --model_name /project/cad-team/LX_Semicon/models/openai-gpt-oss-120b --save_path /workspace/exp/codeevolve_smoke_128k/rtllm_diff --num_workers 1 --candidate_workers 0 --evaluation_mode strict_ablation --temperature 0.7 --top_p 0.95 --max_tokens 128000 --generation_mode diff --prompt_profile codeevolve --seed 42 --codeevolve_num_islands 1 --codeevolve_num_epochs 2 --codeevolve_init_pop 1 --codeevolve_exploration_rate 0.2 --codeevolve_max_evaluations 2 --codeevolve_max_runtime_seconds 900`
- `python scripts/run_backend.py --backend codeevolve --benchmarks VerilogEval-Spec-to-RTL --problems Prob001_zero --api_backend vllm --vllm_host host.docker.internal --vllm_port 8000 --model_name /project/cad-team/LX_Semicon/models/openai-gpt-oss-120b --save_path /workspace/exp/codeevolve_smoke_128k/verilogeval_diff --num_workers 1 --candidate_workers 0 --evaluation_mode strict_ablation --temperature 0.7 --top_p 0.95 --max_tokens 128000 --generation_mode diff --prompt_profile codeevolve --seed 42 --codeevolve_num_islands 1 --codeevolve_num_epochs 2 --codeevolve_init_pop 1 --codeevolve_exploration_rate 0.2 --codeevolve_max_evaluations 2 --codeevolve_max_runtime_seconds 900`

## Validation Snapshot

- `.venv/bin/python -m pytest tests/revolution/test_codeevolve_backend.py tests/revolution/test_diff_apply.py`
- `.venv/bin/python -m pytest`
- `.venv/bin/python -m ruff check src/revolution/backends/codeevolve_backend.py src/revolution/runtime/diff_apply.py tests/revolution/test_codeevolve_backend.py tests/revolution/test_diff_apply.py`
- `.venv/bin/python -m pyright src/revolution/backends/codeevolve_backend.py src/revolution/runtime/diff_apply.py`
