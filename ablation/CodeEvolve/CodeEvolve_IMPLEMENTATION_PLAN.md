# CodeEvolve Backend Implementation Plan

## Summary

Implement a native `codeevolve` backend inside REvolution for backend ablation
studies. Phase 1 targets `RTLLM` and `VerilogEval-Spec-to-RTL` only, keeps the
vendored `science-codeevolve` tree read-only, and integrates through the
existing backend, ablation, reporting, and archive workflows.

This file is the living execution log for the integration. It now reflects both
the implementation work and the post-implementation review pass against
`CodeEvolve_IMPLEMENTATION_PLAN_original.md`.

## Status

- Review status: phase-1 implementation reviewed, tightened, and live-smoke
  validated on 2026-03-08
- Branch: `feat/CodEvolve-ablation-backend`
- Canonical path: `/workspace/ablation/CodeEvolve/CodeEvolve_IMPLEMENTATION_PLAN.md`
- Overall verdict: mostly aligned with the original phase-1 goals, with a small
  set of intentional divergences from upstream CodeEvolve and one review-driven
  fidelity fix added after the first implementation pass
- Code-level phase-1 verdict: implemented for the planned REvolution surfaces;
  preliminary live execution validation is now complete and remaining items are
  prompt-fidelity and broader-scale follow-up work

## Audit Verdict

### What matches the original plan

- Native REvolution backend implemented as `codeevolve`
- Phase-1 benchmark scope constrained to `RTLLM` and `VerilogEval-Spec-to-RTL`
- Prompt profile, config template, CLI flags, and runner delegation added
- Ablation orchestration generalized to a backend registry and includes
  CodeEvolve fairness scheduling
- Archive/report flows accept `codeevolve` outputs without a separate side path
- Tests, docs, and implementation notes were added as planned

### Intentional phase-1 divergences that remain acceptable

- No direct use of upstream CLI/process runner, checkpointing, embeddings, or
  MAP-Elites
- No multiprocessing island workers; islands execute in-process per problem
- No multi-file problem packaging; phase 1 remains single-file RTL only
- Prompt construction is adapted to REvolution's prompt-store model rather than
  upstream `PromptSampler` objects and OpenAI-chat message assembly
- Diff application uses REvolution's existing structured single-file diff path
  instead of upstream raw SEARCH/REPLACE text handling

### Review-driven issues found and addressed

- Fixed CodeEvolve epoch metrics so `meta_prompt_failures` counts only actual
  failed meta-prompt attempts, not initialization steps
- Improved the phase-1 seed program generation so RTL seed stubs now derive the
  module interface from benchmark prompt text instead of always emitting a bare
  top-module shell
- Added explicit per-epoch stage pass counts so generation statistics now match
  the planned reporting contract more closely
- Deduplicated internal program-registration bookkeeping to reduce avoidable
  drift inside the large backend file

### Maintainability assessment

- The backend registry abstraction is small and justified; it reduces hardcoded
  backend branching in runners without introducing a heavy framework layer
- The ablation refactor is proportionate to the requirement to support more than
  three backends and future backends such as `cvdp`-style or RealBench-style
  integrations
- The main tech-debt risk is that
  `/workspace/src/revolution/backends/codeevolve_backend.py` is now large. That
  is acceptable for phase 1 because the original plan explicitly preferred a
  self-contained backend, but phase 2 should split only if the task-adapter or
  prompt-building surface expands further

## Stage Tracker

### Stage 0: Audit and Scope Lock

- [x] repo/backend/ablation architecture audited
- [x] integration mode fixed to native backend
- [x] phase-1 scope fixed to RTLLM + VerilogEval
- [x] canonical naming fixed to `CodeEvolve`
- [x] implementation branch created

### Stage 1: Core Backend Surface

- [x] create CodeEvolve notes crosswalk
- [x] add `CodeEvolveBackend` and `CodeEvolveBackendConfig`
- [x] add prompt profile under `data/prompts/codeevolve/`
- [x] add reproducible config template at `data/configs/codeevolve_default.yaml`
- [x] export backend/config from package entry points
- [x] add `run_backend.py` support for `--backend codeevolve`
- [x] add `run_evolution.py` delegation for `codeevolve` and `codeevolve_*`

### Stage 2: Ablation and Artifact Plumbing

- [x] replace hardcoded ablation backend list with registry-driven orchestration
- [x] add `--backends` selection in `run_backend_ablation.py`
- [x] add CodeEvolve fairness schedule derivation
- [x] propagate CodeEvolve budget caps for candidate and LLM-call fairness modes
- [x] generalize archive ablation-root detection using registered backends
- [x] keep comparison report interface stable while accepting `codeevolve=<path>`

### Stage 3: Fidelity and Maintainability Review Pass

- [x] compare implementation against `CodeEvolve_IMPLEMENTATION_PLAN_original.md`
- [x] compare implementation shape against vendored upstream CodeEvolve runtime
- [x] tighten meta-prompt accounting to reflect real attempts only
- [x] derive phase-1 RTL seed stubs from benchmark interface text
- [x] add per-epoch stage pass counts to generation statistics
- [x] reduce internal bookkeeping duplication in the backend implementation

### Stage 4: Validation and Regression Checks

- [x] backend-focused test coverage added
- [x] runner/ablation/archive/report/delegation coverage added
- [x] targeted CodeEvolve validation run completed
- [x] full repository test suite completed
- [x] Ruff checks completed on touched files
- [x] Pyright checks completed on touched files
- [x] real-model smoke run against live `vllm` for `RTLLM`
- [x] real-model smoke run against live `vllm` for `VerilogEval-Spec-to-RTL`
- [x] investigate and fix live diff-application mismatch found during smoke
- [x] rerun repository-wide regression suite after live-driven fixes

### Stage 5: Deferred Follow-Ups

- [ ] compare current `codeevolve` prompt profile against upstream mock config
      behavior and document any deliberate remaining prompt-shape differences
- [ ] evaluate whether checkpoint/resume is worth adding for long ablation sweeps
- [ ] design a multi-file task adapter contract before RealBench-style support
- [ ] add a future `cvdp`/codebase-task adapter only after phase-1 RTL results
      are stable
- [ ] split `codeevolve_backend.py` only if phase-2 work materially expands the
      task-adapter or prompt-building surface

## Exact Remaining TODO List

- [ ] Compare the current `codeevolve` prompt profile against upstream mock
      config behavior and document any deliberate prompt-shape differences that
      remain after phase 1.
- [ ] Run a slightly larger live matrix before using CodeEvolve in published
      ablation charts:
      - 3 to 5 RTLLM problems in whole mode at the default 2048-token cap
      - 3 to 5 VerilogEval problems in both whole and diff modes
- [ ] Investigate RTLLM diff-mode stability for this served model under tiny
      budgets; second-generation responses were still brittle due empty or
      malformed completions even after prompt cleanup.
- [ ] Decide whether phase 2 should keep the backend self-contained or split
      the task adapter into a separate module before adding more domains.

## Fidelity Deviations

- No direct use of the vendored CodeEvolve CLI or multiprocessing island
  workers.
- No checkpoint/resume in v1.
- No MAP-Elites, embeddings, or copied sandbox codebases in v1.
- No Python `input/src/init_program.py` problem packaging; REvolution RTL
  benchmarks use a native task adapter.
- Exploration/exploitation prompt construction is adapted to REvolution prompt
  templates rather than upstream `PromptSampler` chat-history objects.
- Diff editing uses REvolution's existing single-file JSON diff contract and
  diff applier instead of upstream raw SEARCH/REPLACE text handling.
- Multi-file codebase tasks are deferred.
- Live-smoke follow-up changed one small interoperability detail: the shared
  diff applier now accepts the logical single-file name `code.sv` in addition
  to the concrete run-artifact path when selecting a JSON diff edit block.

## Validation Log

- Planning pass completed against the repository architecture and the original
  CodeEvolve integration proposal.
- Added a central backend metadata registry with prompt-profile and CVDP
  capability helpers for shared runner/archive logic.
- Added the native `CodeEvolveBackend`, prompt profile, and `run_backend.py`
  parser/build support for `codeevolve`.
- Refactored `run_backend_ablation.py` around a backend-command registry, added
  CodeEvolve fairness scheduling, generalized archive ablation detection, and
  extended `run_evolution.py` delegation for `codeevolve_` configs.
- Added backend, runner, ablation, archive, comparison-report, and delegation
  coverage for the new `codeevolve` path.
- Review pass findings were applied:
  - benchmark prompt-derived seed module skeletons
  - corrected meta-prompt failure accounting
  - per-epoch stage pass counts in generation statistics
  - deduplicated internal program-registration bookkeeping
- Validation completed before live smoke:
  - `.venv/bin/python -m pytest tests/revolution/test_codeevolve_backend.py`
  - `.venv/bin/python -m pytest`
  - `.venv/bin/python -m ruff check src/revolution/backends/codeevolve_backend.py tests/revolution/test_codeevolve_backend.py`
  - `.venv/bin/python -m pyright src/revolution/backends/codeevolve_backend.py`
  - `.venv/bin/python -m ruff check src/revolution/backends/codeevolve_backend.py scripts/run_backend.py scripts/run_backend_ablation.py scripts/archive_baseline.py tests/revolution/test_codeevolve_backend.py tests/scripts/test_run_backend.py tests/scripts/test_run_backend_ablation.py tests/scripts/test_archive_baseline.py`
  - `.venv/bin/python -m pyright src/revolution/backends/codeevolve_backend.py scripts/run_backend.py scripts/run_backend_ablation.py scripts/archive_baseline.py`
- Live endpoint verified on 2026-03-08:
  - `curl http://host.docker.internal:8000/v1/models`
  - served model:
    `/project/cad-team/LX_Semicon/models/openai-gpt-oss-120b`
- Live smoke commands executed:
  - `python scripts/run_backend.py --backend codeevolve --benchmarks RTLLM --problems Prob001_accu --api_backend vllm --vllm_host host.docker.internal --vllm_port 8000 --model_name /project/cad-team/LX_Semicon/models/openai-gpt-oss-120b --save_path /workspace/exp/codeevolve_smoke/rtllm_whole --num_workers 1 --candidate_workers 0 --evaluation_mode strict_ablation --temperature 0.7 --top_p 0.95 --max_tokens 1024 --generation_mode whole --prompt_profile codeevolve --seed 42 --codeevolve_num_islands 1 --codeevolve_num_epochs 2 --codeevolve_init_pop 1 --codeevolve_exploration_rate 0.2 --codeevolve_max_evaluations 2 --codeevolve_max_runtime_seconds 900`
  - `python scripts/run_backend.py --backend codeevolve --benchmarks VerilogEval-Spec-to-RTL --problems Prob001_zero --api_backend vllm --vllm_host host.docker.internal --vllm_port 8000 --model_name /project/cad-team/LX_Semicon/models/openai-gpt-oss-120b --save_path /workspace/exp/codeevolve_smoke/verilogeval_whole --num_workers 1 --candidate_workers 0 --evaluation_mode strict_ablation --temperature 0.7 --top_p 0.95 --max_tokens 1024 --generation_mode whole --prompt_profile codeevolve --seed 42 --codeevolve_num_islands 1 --codeevolve_num_epochs 2 --codeevolve_init_pop 1 --codeevolve_exploration_rate 0.2 --codeevolve_max_evaluations 2 --codeevolve_max_runtime_seconds 900`
  - `python scripts/run_backend.py --backend codeevolve --benchmarks RTLLM --problems Prob001_accu --api_backend vllm --vllm_host host.docker.internal --vllm_port 8000 --model_name /project/cad-team/LX_Semicon/models/openai-gpt-oss-120b --save_path /workspace/exp/codeevolve_smoke/rtllm_diff_2048 --num_workers 1 --candidate_workers 0 --evaluation_mode strict_ablation --temperature 0.7 --top_p 0.95 --max_tokens 2048 --generation_mode diff --prompt_profile codeevolve --seed 42 --codeevolve_num_islands 1 --codeevolve_num_epochs 2 --codeevolve_init_pop 1 --codeevolve_exploration_rate 0.2 --codeevolve_max_evaluations 2 --codeevolve_max_runtime_seconds 900`
  - `python scripts/run_backend.py --backend codeevolve --benchmarks VerilogEval-Spec-to-RTL --problems Prob001_zero --api_backend vllm --vllm_host host.docker.internal --vllm_port 8000 --model_name /project/cad-team/LX_Semicon/models/openai-gpt-oss-120b --save_path /workspace/exp/codeevolve_smoke/verilogeval_diff_promptfix --num_workers 1 --candidate_workers 0 --evaluation_mode strict_ablation --temperature 0.7 --top_p 0.95 --max_tokens 1024 --generation_mode diff --prompt_profile codeevolve --seed 42 --codeevolve_num_islands 1 --codeevolve_num_epochs 2 --codeevolve_init_pop 1 --codeevolve_exploration_rate 0.2 --codeevolve_max_evaluations 2 --codeevolve_max_runtime_seconds 900`
  - `python scripts/run_backend.py --backend codeevolve --benchmarks RTLLM --problems Prob001_accu --api_backend vllm --vllm_host host.docker.internal --vllm_port 8000 --model_name /project/cad-team/LX_Semicon/models/openai-gpt-oss-120b --save_path /workspace/exp/codeevolve_smoke/rtllm_whole_2048 --num_workers 1 --candidate_workers 0 --evaluation_mode strict_ablation --temperature 0.7 --top_p 0.95 --max_tokens 2048 --generation_mode whole --prompt_profile codeevolve --seed 42 --codeevolve_num_islands 1 --codeevolve_num_epochs 2 --codeevolve_init_pop 1 --codeevolve_exploration_rate 0.2 --codeevolve_max_evaluations 2 --codeevolve_max_runtime_seconds 900`
- Live smoke outcomes:
  - RTLLM whole at 2048 tokens produced a passing second-generation candidate:
    `/workspace/exp/codeevolve_smoke/rtllm_whole_2048/codeevolve/_project_cad-team_LX_Semicon_models_openai-gpt-oss-120b/RTLLM/Prob001_accu/Prob001_accu_summary.json`
  - VerilogEval whole passed under the short 1024-token budget:
    `/workspace/exp/codeevolve_smoke/verilogeval_whole/codeevolve/_project_cad-team_LX_Semicon_models_openai-gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob001_zero/Prob001_zero_summary.json`
  - VerilogEval diff passed after two live-driven cleanups:
    `/workspace/exp/codeevolve_smoke/verilogeval_diff_promptfix/codeevolve/_project_cad-team_LX_Semicon_models_openai-gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob001_zero/Prob001_zero_summary.json`
  - RTLLM diff remained brittle on this served model under a tiny 2-evaluation
    smoke budget; generation 1 could pass, but generation 2 still sometimes
    failed due empty or malformed model replies.
- Live-driven code cleanups applied:
  - `src/revolution/runtime/diff_apply.py` now accepts logical single-file edit
    names such as `code.sv` when matching JSON diff payloads to artifact files
  - `src/revolution/backends/codeevolve_backend.py` no longer includes
    `seed_code` in non-initializing prompts, which reduced diff-mode confusion
    between the seed stub and the actual parent candidate
- Post-fix validation completed:
  - `.venv/bin/python -m pytest tests/revolution/test_codeevolve_backend.py tests/revolution/test_diff_apply.py`
  - `.venv/bin/python -m pytest`
  - `.venv/bin/python -m ruff check src/revolution/backends/codeevolve_backend.py src/revolution/runtime/diff_apply.py tests/revolution/test_codeevolve_backend.py tests/revolution/test_diff_apply.py`
  - `.venv/bin/python -m pyright src/revolution/backends/codeevolve_backend.py src/revolution/runtime/diff_apply.py`
