# EoH Backend Integration Plan Doc (Updated for CVDP + Fitness Orientation + Real‑LLM Testing)

## Summary
Create a new planning document in `ablation/EoH/` that specifies how to integrate an **EoH backend** alongside **revolution** and **funsearch**, with explicit support for **RTLLM, VerilogEval, and CVDP** benchmarks. The plan will also add a **real‑LLM testing track** (vLLM endpoint at `http://host.docker.internal:8000/v1/models`) and ensure **fitness maximization** consistent with existing backends.

**Decisions locked:**
- Backend name/profile: **`eoh`**
- Generation modes: **whole + diff**
- Default operators: **E1/E2/M1/M2/M3**
- Objective orientation: **maximize fitness** (higher is better)

## Current Status (2026-03-03)
Implementation has started and completed the core integration milestones.

### Milestones Completed
- Added `src/revolution/backends/eoh_backend.py` with:
  - typed `EoHBackendConfig`
  - whole/diff generation support
  - default operator schedule `E1/E2/M1/M2/M3`
  - fitness maximization and `-inf` handling for failed/non-finite candidates
  - run artifacts and summary integration matching backend report expectations
- Added shared diff utility `src/revolution/runtime/diff_apply.py` and integrated it into EoH backend diff mode.
- Added CVDP runtime extraction in `src/revolution/runtime/cvdp_evaluator.py`:
  - reusable `CVDPEvaluator`
  - JSONL record/id helpers (`load_cvdp_record`, `select_cvdp_ids`, `build_cvdp_problem_context`)
- Updated `scripts/run_backend.py`:
  - backend choice now includes `eoh`
  - added `--eoh_*` flags
  - added CVDP flags (`--cvdp_jsonl`, `--cvdp_categories`, `--cvdp_simulation_timeout_s`)
  - CVDP task discovery/evaluation path enabled for backend `eoh`
  - prompt profile default now resolves to `eoh` for backend `eoh`
- Updated `scripts/run_backend_ablation.py`:
  - includes EoH as a third backend
  - adds fairness schedule derivation for EoH (`budget = 2*pop + gen*pop*|operators|`)
  - includes EoH in comparison report generation
- Added prompt profile `data/prompts/eoh/` with required system/feedback/operator templates.
- Added/updated tests:
  - `tests/revolution/test_eoh_backend.py`
  - `tests/revolution/test_diff_apply.py`
  - `tests/revolution/test_cvdp_evaluator.py`
  - updated `tests/scripts/test_run_backend.py`
  - updated `tests/scripts/test_run_backend_ablation.py`
- Updated docs:
  - `docs/user_guide.md`
  - `docs/REvolution_specification.md`

### Validation Snapshot
- Targeted 3.11 test run passed:
  - `31 passed` across new/updated runtime/backend/script tests.
- Command used:
  - `uv run --python 3.11 --with pytest --with pyyaml python -m pytest -q tests/revolution/test_diff_apply.py tests/revolution/test_eoh_backend.py tests/revolution/test_cvdp_evaluator.py tests/scripts/test_run_backend.py tests/scripts/test_run_backend_ablation.py`

## TODO List + Milestones
- [x] Backend module + config
- [x] Prompt profile + templates
- [x] Diff apply utility extraction
- [x] CVDP evaluator extraction + integration
- [x] run_backend + ablation script support
- [x] unit tests
- [ ] real‑LLM smoke tests
- [ ] full ablation sweep
- [x] docs updates

## Decision Log
- Backend name/profile locked to `eoh`.
- Whole + diff generation enabled in v1.
- Operator defaults: `E1/E2/M1/M2/M3`.
- Fitness objective remains maximization (no score sign flip applied because current evaluator scoring already maps better candidates to higher score).
- CVDP integration is functionality-focused (no synthesis/PPA stage in CVDP evaluator).

## Important API/Interface Changes
- New backend class: `EoHBackend`
- New config dataclass: `EoHBackendConfig`
- New CLI flags `--eoh_*`
- New prompt profile `data/prompts/eoh/*`
- New CVDP evaluator module and optional CLI flags

## Assumptions
- CandidateEvaluator score orientation is already compatible with maximize-higher-better behavior for backend selection.
- CVDP evaluator extraction is behaviorally aligned with the existing CVDP harness workflow (pytest/cocotb driven), while remaining backend-agnostic.
