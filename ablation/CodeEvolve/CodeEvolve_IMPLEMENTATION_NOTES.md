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

## Concrete Follow-Ups

- Run a real-model smoke test on `RTLLM`
- Run a real-model smoke test on `VerilogEval-Spec-to-RTL`
- Compare current prompt templates against upstream mock/reference configs and
  document any deliberate remaining prompt-shape differences
- Revisit backend file splitting only if phase-2 scope expands

## Validation Snapshot

- `.venv/bin/python -m pytest`
- `.venv/bin/python -m ruff check src/revolution/backends/codeevolve_backend.py scripts/run_backend.py scripts/run_backend_ablation.py scripts/archive_baseline.py tests/revolution/test_codeevolve_backend.py tests/scripts/test_run_backend.py tests/scripts/test_run_backend_ablation.py tests/scripts/test_archive_baseline.py`
- `.venv/bin/python -m pyright src/revolution/backends/codeevolve_backend.py scripts/run_backend.py scripts/run_backend_ablation.py scripts/archive_baseline.py`
