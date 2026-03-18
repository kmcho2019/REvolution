# FunSearch Backend Integration Plan for REvolution Ablation Studies

## 1. Objective
Integrate a **FunSearch-style backend** into REvolution so we can run controlled ablation studies against the current REvolution evolutionary backend, with:
- backend isolation/encapsulation for maintainability,
- shared benchmark/evaluation infrastructure for fair comparison,
- backend-agnostic execution/reporting pipelines,
- reproducible regression/performance testing.

## 1.1 Cross-Check Status (repo audit)
This plan has been re-audited against current repository code/docs and the added FunSearch assets. The audit explicitly validated:
- REvolution runtime structure and script entrypoints (`scripts/run_evolution.py`, `scripts/run_one_shot.py`, `src/revolution/*`),
- current summary/log schema behavior used by reports (`src/revolution/logging.py`, `scripts/evolutionary_report_generator.py`),
- PromptStore key/path behavior (`src/revolution/prompt_store.py`),
- FunSearch released implementation mechanics and defaults (`ablation/funcsearch/funsearch/implementation/*`),
- FunSearch paper-method details (`ablation/funcsearch/FunSearch_Mathematical_discoveries_from_program_search_with_large_language_models_s41586-023-06924-6.md`).

This plan is based on:
- REvolution docs (`docs/REvolution_specification.md`, `docs/implementation_details.md`, `docs/method_interaction_and_evolutionary_loop.md`, `docs/user_guide.md`),
- current REvolution runtime/report code (`scripts/run_evolution.py`, `scripts/run_one_shot.py`, `scripts/evolutionary_report_generator.py`, `src/revolution/*`),
- the added FunSearch paper/code in `ablation/funcsearch` (`FunSearch_*.md`, `ablation/funcsearch/funsearch/implementation/*`).

## 2. Key Findings from Current Codebase

### 2.1 REvolution today
- `EoHEngine` in `src/revolution/algorithm.py` currently combines multiple concerns in one class:
  - algorithm policy,
  - prompt strategy policy,
  - candidate generation,
  - evaluation orchestration,
  - logging contract.
- `scripts/run_evolution.py` selects behavior through hard-coded branches (`EoHEngine`, `Gen0LatencyEngine`, `CVDPEngine`), not through a backend plug-in interface.
- Reporting (`scripts/evolutionary_report_generator.py`) assumes REvolution-style summary/log schema and PPA fields.

### 2.2 FunSearch code as added
- The reference implementation in `ablation/funcsearch/funsearch/implementation/` is a **method skeleton**, not directly runnable end-to-end:
  - `sampler.LLM._draw_sample()` is `NotImplemented`.
  - `evaluator.Sandbox.run()` is `NotImplemented`.
  - `sampler.sample()` is infinite loop by design.
- It encodes core algorithmic ideas we should preserve:
  - islands model,
  - cluster-by-signature diversity,
  - Boltzmann cluster sampling,
  - shorter-program bias within cluster,
  - best-shot prompt building from top programs,
  - periodic weakest-island reset.
- Dependency gap for direct reuse: `absl` is not currently installed in this environment; funsearch implementation imports it.

### 2.3 Research-fairness implication
For ablation quality, FunSearch backend should reuse the same:
- benchmark inputs,
- syntax/functionality/synthesis/PPA evaluation flow,
- model and API backend choices,
- run budget controls (calls/tokens/time/number of evaluated candidates),
so algorithmic differences are isolated.

### 2.4 Important FunSearch paper-vs-code nuances (must be explicit in implementation)
- The Nature paper describes score aggregation as an aggregation function (for example mean), but the released reference code currently reduces score with `_reduce_score(...)` by taking the **last test-input score**.
- Islands behavior in released code:
  - island selection for prompt generation is uniform (`np.random.randint`),
  - initial program is registered into **all islands** (`island_id=None` path),
  - weakest half reset is time-triggered (`reset_period`) with random tie-break noise,
  - reset islands are reseeded by best programs sampled from surviving islands.
- Prompt construction in released code is versioned (`_v0`, `_v1`, ...), sorted by score ascending in prompt.
- Evaluator rejects samples that call ancestor versions (`function_to_evolve_v*`).
- Within-cluster short-program bias in released code uses fixed temperature `1.0` (no explicit `program_sampling_temperature` knob in upstream config).
- Alignment update (2026-02-11): backend now derives cluster signatures from a sorted score-vector map (FunSearch-style `_get_signature` analogue), and reset checks run after each candidate registration (FunSearch-style `register_program` timing).

These details should be mirrored intentionally (or documented as deliberate deviations) in the RTL backend.

### 2.5 Current REvolution schema/runtime constraints relevant to migration
- Existing summary JSON uses a legacy key typo: `accumulated_strategy_counts:` (trailing colon). Report scripts currently consume this exact key.
- `scripts/evolutionary_report_generator.py` assumes current `generation_log.jsonl` and summary field names; schema migration requires a compatibility reader or dual-write period.
- Current run scripts do not expose deterministic seed controls (`--seed`), which is a gap for multi-seed ablation rigor.

## 3. Integration Strategy

### 3.1 High-level approach
Implement a **native REvolution backend plugin architecture** and add a **FunSearch-RTL backend** that reproduces FunSearch evolutionary mechanics while operating on RTL candidates and existing REvolution evaluators.

Why this approach:
- avoids forcing direct execution of incomplete vendor runtime skeleton,
- keeps `ablation/funcsearch/funsearch` as reference source of truth,
- preserves maintainability for additional backends later (EoH variants, AlphaEvolve-style, etc.).

### 3.2 Design principles
- Backend isolation: each backend owns only its algorithm/prompt policy.
- Shared services: LLM interface, evaluator stack, logging utilities, benchmark loaders are common.
- Stable contracts: one backend interface + one canonical run artifact schema.
- Backward compatibility: existing `scripts/run_evolution.py` workflow remains usable.

### 3.3 Initial scope boundaries
- Phase-1 FunSearch backend scope: `RTLLM` and `VerilogEval-Spec-to-RTL` only.
- `CVDP` remains out-of-scope for first FunSearch backend release (different harness/evaluation semantics and no synthesis/PPA parity).
- FunSearch backend v1 runs in `whole` generation mode only; `diff` mode can be added later as a secondary experiment.

## 4. Target Architecture

## 4.1 New package layout
Proposed additions under `src/revolution/`:
- `backends/base.py`
  - `EvolutionBackend` protocol/ABC.
- `backends/revolution_backend.py`
  - adapter around current REvolution algorithm behavior.
- `backends/funsearch_backend.py`
  - FunSearch-style backend for RTL.
- `runtime/problem_context.py`
  - benchmark/problem metadata loader.
- `runtime/candidate_evaluator.py`
  - shared syntax/func/synth/PPA evaluation pipeline (extracted from `EoHEngine._evaluate_candidates`).
- `runtime/run_artifacts.py`
  - canonical summary/log data models and writers.

## 4.2 Backend interface contract
Each backend should implement something equivalent to:
- `initialize(context, services, config)`
- `run()`
- `get_result_summary()`

Services passed in:
- `LLMInterface`
- `CandidateEvaluator`
- `PromptStore`
- `ArtifactWriter`

## 4.3 Artifact contract (backend-agnostic)
Standardize per-problem outputs with required common keys:
- `backend_name`
- `benchmark_name`
- `problem_name`
- `run_budget` (time/calls/tokens/iterations)
- `stage_success_rates` (format/syntax/functionality/synthesis)
- `best_candidate`
- `runtime`
- `llm_usage`

Backend-specific extras live under:
- `backend_details` (e.g., island stats, cluster counts, reset events).

This keeps report generators extensible while preserving rich backend-specific diagnostics.

## 5. FunSearch Backend Design for RTL

## 5.1 What is preserved from FunSearch
Implement these mechanics in `funsearch_backend.py`:
- islands sub-populations,
- signature clustering (signature = vector over evaluation components/inputs),
- cluster-level Boltzmann sampling,
- intra-cluster short-program preference,
- prompt building from `k` sampled implementations with versioned examples,
- periodic weakest-island reset and reseeding from strong islands.

## 5.2 RTL adaptation choices
Because REvolution problems are RTL generation tasks (not Python function completion), adapt as follows:
- candidate representation: full RTL candidate + metadata (thought/code/feedback/status/ppa/score).
- “function to evolve” abstraction becomes “candidate implementation body” (full module text for first version).
- prompt form uses k previous full candidates sorted by score and asks model to synthesize next improved candidate.
- evaluator remains REvolution evaluation stack for comparability.

Skeleton caveat:
- FunSearch performs best when a fixed skeleton isolates the evolved function.
- REvolution benchmark prompts are natural-language specs without explicit skeleton files.
- Therefore v1 should implement a **whole-module FunSearch variant**.
- Optional v2 extension: add benchmark-side optional skeleton assets (for example `*_skeleton.sv` + evolve-target marker) and a skeleton-aware prompt/evaluator path.

## 5.3 Scoring/signature policy for RTL
Use a deterministic reducer so clustering is stable:
- primary score: REvolution fitness score for successful candidates.
- failed candidates: large negative floor score and status code.
- signature options (recommended):
  - `[syntax_pass, func_pass, synth_pass, rounded_fitness_bucket]` or
  - per-stage + normalized PPA tuple for successful cases.

Recommendation: begin with compact signature buckets to prevent cluster explosion.

Reducer compatibility note:
- Add an explicit config switch for reducer semantics so runs can emulate released FunSearch behavior:
  - `score_reducer = last_input` (reference-code compatible),
  - `score_reducer = mean` (paper-style aggregation),
  - `score_reducer = fitness` (native RTL-focused).
- Log reducer choice in summary metadata for every run.

## 5.4 Budget and termination
Add explicit finite controls (FunSearch code is open-loop infinite by default):
- `max_evaluations`
- `max_iterations`
- `max_runtime_seconds`
- optional `max_llm_calls` / `max_llm_tokens`

Termination when any limit reached.

## 5.5 Concurrency model
Keep first implementation synchronous-per-problem with optional parallel candidate evaluation (reuse existing evaluator parallelism), then add async sampler/evaluator workers only if needed.

This minimizes initial complexity while preserving method fidelity for ablation.

## 5.6 FunSearch Prompt Loading in `data/prompts`
Add explicit FunSearch prompt profile support using existing `PromptStore` mechanics.

Target profile directory:
- `data/prompts/funsearch/`

Required baseline keys (reuse current common keys so services stay backend-agnostic):
- `system/whole` -> `data/prompts/funsearch/system/whole.txt`
- `feedback/system` -> `data/prompts/funsearch/feedback/system.txt`
- `feedback/user` -> `data/prompts/funsearch/feedback/user.txt`

FunSearch-specific template keys (new):
- `funsearch/prompt_header` -> `data/prompts/funsearch/funsearch/prompt_header.txt`
- `funsearch/program_block` -> `data/prompts/funsearch/funsearch/program_block.txt`
- `funsearch/prompt_footer` -> `data/prompts/funsearch/funsearch/prompt_footer.txt`
- `funsearch/eval_feedback_suffix` -> `data/prompts/funsearch/funsearch/eval_feedback_suffix.txt`

Why this split:
- preserves best-shot prompt assembly as code (ordering/versioning logic remains deterministic),
- keeps wording and prompt policy editable without backend code changes,
- aligns with existing `PromptStore` key-path resolution.

Prompt loading behavior to implement:
- FunSearch backend defaults to `prompt_profile=funsearch`.
- Fail-fast validation on startup for required keys with explicit missing file paths.
- Optional compatibility fallback (`--prompt_profile default`) for debugging only, with warning banner in logs.
- FunSearch backend v1 should explicitly request `system/whole` and not require `system/diff`.

Prompt variables to standardize for FunSearch templates:
- `{problem_description}`
- `{sampled_programs_json}` (ordered lowest->highest score as `v0..v{k-1}`)
- `{target_version}`
- `{scoring_rubric}`
- `{format_contract}` (expected output JSON schema)

This should be included in backend unit tests so missing prompt files fail before run execution.

## 5.7 Evaluation Integration Decision (Piggyback vs Tweaks)
Decision:
- **Piggyback core tool evaluators** (`VerilogEvaluator`, `SynthesisEvaluator`) for methodological consistency.
- **Apply targeted orchestration tweaks** to support FunSearch mechanics (signature clustering, score reducers, budgeted evaluation).

What should be reused unchanged:
- `VerilogEvaluator.evaluate` execution contract and status mapping (`success|compilation_error|simulation_error|simulation_timeout|file_error`).
- `SynthesisEvaluator.evaluate` + post-synthesis functional check and PPA parsing.
- benchmark assets and resolution rules (`*_test.sv`, `*_ref.sv`, `*_ppa.txt`, `synthesis_top_module_names.json`).

What must be adjusted:
- Extract evaluation orchestration out of `EoHEngine._evaluate_candidate_pipeline` into backend-agnostic service (`CandidateEvaluator`) returning a structured object:
  - stage statuses (format/syntax/functionality/synthesis),
  - scalar score + score components,
  - parsed simulator signal (for example mismatch count when present),
  - PPA metrics,
  - log references.
- Preserve current hard-failure semantics for strict parity:
  - current `EoHEngine._evaluate_candidate_pipeline` maps failure states to `score = -inf`,
  - current `_evaluate_candidates` requests LLM feedback for candidates that produce feedback payloads (including synthesis-success cases with PPA guidance),
  - FunSearch integration should expose these as explicit policy switches rather than implicit behavior.
- Introduce **FunSearch score policy** for failed candidates:
  - keep hard failure status semantics,
  - avoid only `-inf` internal clustering value by mapping to configurable finite buckets for signature diversity (while preserving final report semantics).
- Make feedback generation optional and backend-controlled:
  - REvolution backend keeps current behavior,
  - FunSearch backend can disable or downsample feedback calls to preserve budget fairness.

Evaluation modes to support:
- `strict_ablation` (default for publishable comparison):
  - same syntax/functionality/synthesis/PPA flow as current REvolution,
  - same timeout and toolchain settings,
  - direct apples-to-apples metrics.
- `search_accelerated` (engineering mode, not primary ablation table):
  - run syntax+functionality on all candidates,
  - synthesize only top-K functional candidates per iteration/island (configurable),
  - must be labeled separately in reports.

Recommendation:
- Use `strict_ablation` for all REvolution-vs-FunSearch headline results.
- Use `search_accelerated` only for exploratory tuning and include explicit caveats.

## 6. Script and CLI Plan

## 6.1 Runner unification
Introduce backend-selectable runner while preserving existing UX:
- new script: `scripts/run_backend.py` (canonical)
  - `--backend revolution|funsearch`
  - accepts shared options + backend-specific config section.
- keep `scripts/run_evolution.py` as backward-compatible wrapper (defaults `--backend revolution`).
- optional convenience wrapper: `scripts/run_funsearch.py` calling `run_backend.py --backend funsearch`.

## 6.2 Config design
Extend config schema with namespaces:
- shared keys (model, benchmark, save path, workers, evaluation options)
- `backend_config.revolution.*`
- `backend_config.funsearch.*`

For FunSearch include:
- `num_islands`
- `functions_per_prompt` (k)
- `reset_period_seconds`
- `cluster_sampling_temperature_init`
- `cluster_sampling_temperature_period`
- `program_sampling_temperature` (optional REvolution extension; default `1.0` for released-code parity)
- `max_evaluations` / `max_runtime_seconds`
- `prompt_profile` (default `funsearch`)
- `prompt_root` (default `data/prompts`)
- `strict_prompt_keys` (default true; startup validation of required keys)
- `seed` (global deterministic seed)
- `score_reducer` (`last_input|mean|fitness`)
- `allow_diff_mode` (default false for FunSearch backend v1)

## 6.3 Report generation
Refactor `scripts/evolutionary_report_generator.py` into backend-agnostic mode:
- load standardized summary contract first,
- render common comparison tables for all backends,
- render backend-specific appendix blocks from `backend_details`.

Keep legacy fields readable for historical runs.

## 6.4 Immediate smoke-regression script (live vLLM)
A reusable script is available now for low-cost regression checks while backend refactoring is in progress:
- `scripts/run_evolution_smoke_vllm.sh`

Script behavior:
- queries `http://$VLLM_HOST:$VLLM_PORT/v1/models` with `curl` and auto-uses the first returned model id as `--model_name`,
- defaults to `VLLM_HOST=vllm`, `VLLM_PORT=8888`,
- validates the served `max_model_len` against `SMOKE_MIN_MODEL_LEN` (default `128000`) so long-context reasoning-model runs do not silently use a short window,
  - `SMOKE_MIN_MODEL_LEN` accepts raw integers and human-friendly suffixes (`k`, `m`, `g`), for example `128k`, `131072`, `12800k`,
- exports a placeholder `OPENAI_API_KEY` when unset so the OpenAI-compatible client can initialize against local vLLM,
- runs `scripts/run_evolution.py` with small defaults (`population_size=2`, `num_generations=1`, `total_worker_slots=1`),
- fails with non-zero exit if summary statuses include `initialization_failed` or `run_failed`,
- supports tiny suites:
  - `--suite rtllm` -> `RTLLM/Prob001_accu`,
  - `--suite verilogeval` (alias `verilogevalv2`) -> `VerilogEval-Spec-to-RTL/Prob001_zero`,
  - `--suite mixed` (default) -> one problem from each benchmark.

Quick usage:
- `scripts/run_evolution_smoke_vllm.sh --dry-run`
- `scripts/run_evolution_smoke_vllm.sh --suite mixed`
- `SMOKE_PROBLEMS="Prob001_accu Prob002_adder_16bit" scripts/run_evolution_smoke_vllm.sh --suite rtllm`

Observed environment check (2026-02-11):
- endpoint: `http://vllm:8888/v1/models`
- detected model id: `/models/openai-gpt-oss-120b`
- reported `max_model_len`: `131072` (passes `>=128000` requirement)

Long-context setup note:
- for `gpt-oss-120b`, keep vLLM launch config at `--max-model-len 131072` (or higher),
- if needed, override the smoke gate with:
  - `SMOKE_MIN_MODEL_LEN=0` (disable check), or
  - `SMOKE_MIN_MODEL_LEN=<target>` (custom minimum).

Execution policy during integration:
- use this smoke script before/after each phase PR to guard against regressions,
- after `scripts/run_backend.py` is introduced, keep the same tiny-suite profile and mirror it for `--backend funsearch`.

## 7. Implementation Phases and Stage Gates

## Phase 0: Baseline freeze and instrumentation
Deliverables:
- document current REvolution baseline command set for comparison,
- capture a small frozen baseline run manifest.

Exit criteria:
- reproducible baseline config committed in `data/configs/`.

## Phase 1: Backend abstraction extraction
Deliverables:
- backend interface + service extraction (`CandidateEvaluator`, artifact writer),
- REvolution backend adapter preserving current behavior.

Exit criteria:
- `--backend revolution` run matches current outputs on smoke set.
- no regression in existing tests.
- report compatibility maintained for historical summaries (including legacy `accumulated_strategy_counts:` key).

## Phase 2: FunSearch backend MVP
Deliverables:
- islands + clusters + best-shot prompt construction,
- finite run controller,
- standard artifact outputs.

Exit criteria:
- runs end-to-end on at least one VerilogEval and one RTLLM problem,
- produces valid summaries readable by report tool,
- syntax/func pipeline operational.
- deterministic replay works when `--seed` is fixed.

## Phase 3: Reporting and ablation automation
Deliverables:
- backend-agnostic report generator,
- comparison script for multi-backend runs (same benchmark/problem/model/budget).

Exit criteria:
- one command generates side-by-side backend comparison report.

## Phase 4: Hardening and scale
Deliverables:
- expanded test suite,
- budget fairness checks,
- multi-seed experiment support.

Exit criteria:
- stable repeated runs with expected variance bounds,
- regression suite green.

## 8. Testing and Regression Plan

## 8.1 Unit tests
Add tests for:
- backend interface compliance,
- FunSearch island reset logic,
- signature clustering and sampling probabilities,
- prompt builder correctness (`k` ordering/versioning),
- run budget termination behavior,
- artifact schema validation.
- prompt-profile key validation (missing required prompt file should fail fast with clear error).
- seed reproducibility (same seed => same island/sample selection sequence under mocked LLM/evaluator).

## 8.2 Integration tests
- mocked LLM + mocked evaluator deterministic tests:
  - verify candidate flow through islands/clusters.
- real evaluator smoke tests on tiny problem subset:
  - one problem per benchmark, low population/iterations.
- CLI smoke runner coverage:
  - keep `scripts/run_evolution_smoke_vllm.sh` green (at minimum `--dry-run`, and live run in environments with vLLM + toolchain).

## 8.3 Backward-compatibility regression
- run current REvolution path and new backend adapter path on same seed/config,
- compare key outputs:
  - status counts,
  - best score tolerance,
  - summary schema fields.
- include explicit check for legacy summary key aliases (old + new names) in report parser tests.

## 8.4 Report regression
- ensure report generator handles:
  - old REvolution summaries,
  - new standardized summaries,
  - mixed experiment directories.

## 8.5 Performance regression guardrails
Track for every run:
- total runtime,
- total LLM API calls/tokens,
- pass rates (syntax/func/synth),
- best and average score,
- PPA deltas for solved problems.

Set fail thresholds for accidental runtime blowups (e.g., >X% over baseline on smoke suite).

## 8.6 Evaluation-equivalence regression matrix
For every backend run in `strict_ablation`, assert identical evaluation semantics to current REvolution for the same candidate code:
- stage transition parity:
  - format -> syntax -> functionality -> synthesis/post-synth functionality -> PPA.
- status label parity:
  - `failed_format`, `failed_diff`, `failed_syntax`, `failed_functionality`, `failed_synthesis`, `failed_synthesis_functionality`, `success`.
- metric extraction parity:
  - mismatch parsing behavior,
  - reference PPA loading and top-module resolution,
  - fitness calculation path for successful candidates.
- artifact parity:
  - simulation/synthesis log file presence and naming conventions,
  - summary fields required by report tooling.

Add a fixture-based regression test that replays fixed candidate files through both:
- legacy `EoHEngine` pipeline, and
- new `CandidateEvaluator`,
and checks semantic equivalence of stage outcomes and score components.

## 9. Ablation Comparison Protocol (Recommended)
For fair REvolution vs FunSearch backend comparison:
- same model/API backend and sampling settings,
- same benchmark/problem set,
- same run budget (choose one primary budget axis):
  - total evaluated candidates, or
  - total LLM token budget, or
  - wall-clock budget,
- fixed seed set (e.g., 5–10 seeds per condition),
- report mean/std + confidence intervals.

Budget normalization requirement:
- Since backend iteration semantics differ, normalize by one strict primary budget (`total_candidates_evaluated` recommended) and report secondary budgets (tokens/time/calls) as observed outcomes.
- Implementation note (2026-02-20): `scripts/run_backend_ablation.py` now exposes `--primary_budget_axis {candidate_evaluations,llm_calls,dual_gate}` and propagates budget metadata into summary `run_budget` fields for downstream reporting diagnostics.

Primary metrics:
- functionality pass rate,
- synthesis/PPA pass rate,
- best fitness score,
- area/power/period improvements,
- efficiency metrics (calls/tokens/time per solved problem).

Secondary diagnostics:
- diversity indicators (unique signatures, island entropy),
- convergence curves over budget.

## 10. Risks and Mitigations
- Risk: FunSearch direct code reuse friction (missing sandbox/LLM hooks, infinite loop design).
  - Mitigation: implement native backend using FunSearch method, not direct runtime reuse.
- Risk: schema drift breaking existing report scripts.
  - Mitigation: versioned artifact schema + compatibility layer.
- Risk: unfair ablation due to mismatched budgets.
  - Mitigation: enforce budget-normalized run controller and log budget consumption explicitly.
- Risk: over-coupling persists if extraction is incomplete.
  - Mitigation: require backend interface tests before FunSearch merge.
- Risk: hidden non-determinism undermines ablation conclusions.
  - Mitigation: add `--seed`, deterministic per-worker seed derivation, and seed logging in run metadata.
- Risk: license/compliance mistakes while reusing FunSearch reference code.
  - Mitigation: keep FunSearch code in `ablation/funcsearch` as reference; if code is ported, preserve Apache-2.0 notices and document provenance.

## 10.1 Licensing/Provenance Requirements
- FunSearch implementation files are Apache-2.0 licensed (see headers in `ablation/funcsearch/funsearch/implementation/*`).
- If logic is copied/adapted into `src/revolution/`, preserve required notices and add a provenance note in code comments and docs.
- Keep paper-derived behavior differences documented in the backend README/docstring for reproducibility.

## 11. Concrete File-Level Change Plan
Likely new files:
- `src/revolution/backends/base.py`
- `src/revolution/backends/revolution_backend.py`
- `src/revolution/backends/funsearch_backend.py`
- `src/revolution/runtime/candidate_evaluator.py`
- `src/revolution/runtime/run_artifacts.py`
- `scripts/run_backend.py`
- `scripts/run_evolution_smoke_vllm.sh`
- `tests/revolution/test_backends_base.py`
- `tests/revolution/test_funsearch_backend.py`
- `tests/scripts/test_run_backend.py`
- `tests/revolution/test_backend_prompt_validation.py`
- `tests/revolution/test_backend_reproducibility.py`
- `data/prompts/funsearch/system/whole.txt`
- `data/prompts/funsearch/feedback/system.txt`
- `data/prompts/funsearch/feedback/user.txt`
- `data/prompts/funsearch/funsearch/prompt_header.txt`
- `data/prompts/funsearch/funsearch/program_block.txt`
- `data/prompts/funsearch/funsearch/prompt_footer.txt`
- `data/prompts/funsearch/funsearch/eval_feedback_suffix.txt`

Likely modified files:
- `scripts/run_evolution.py` (wrapper/compatibility mode)
- `scripts/evolutionary_report_generator.py` (backend-agnostic parsing)
- `scripts/run_one_shot.py` (optional compatibility wrapper to backend runner or explicit non-goal documentation)
- `src/revolution/__init__.py` (exports)
- `data/configs/evolution_default.yaml` (backend-aware example)
- `data/configs/funsearch_default.yaml` (new backend config template)
- `docs/user_guide.md` (new backend usage)

## 12. Recommended Execution Order
1. Implement backend abstraction and REvolution adapter first.
2. Stabilize standardized artifact schema and report parser.
3. Implement FunSearch backend MVP with strict budget controls.
4. Add regression tests and smoke benchmarks.
5. Run multi-seed ablation campaign and generate unified reports.

## 13. Open Decisions (resolve before coding)
- **Primary budget axis for ablations**
  - Decision (2026-02-11): keep `total_candidates_evaluated` as primary normalization axis.
- **FunSearch reducer default**
  - Decision (2026-02-11): default to `last_input` for closer released-code compatibility; continue exposing `last_input|mean|fitness` via CLI/config.
- **Initial benchmark scope**
  - Decision (2026-02-11): include all non-CVDP suites in backend runner/ablation (`RTLLM`, `VerilogEval-Code-Complete`, `VerilogEval-Spec-to-RTL`); continue skipping `CVDP`.
- **Prompt-profile strictness**
  - Decision (2026-02-11): default `strict_prompt_keys=true`; support opt-out switch for debugging.
- **Evaluation semantics default**
  - Decision (2026-02-11): default to `strict_ablation`; `search_accelerated` is available for engineering exploration with explicit report labeling.
- **Accelerated synthesis throttling policy**
  - Decision (2026-02-11): deterministic shortest-code first selection for `accelerated_synthesis_top_k`.
- **FunSearch feedback policy**
  - Decision (2026-02-11): default `feedback_policy=off`; expose `off|fail_only|always`.
- **Offline execution fallback for blocked infra**
  - Decision (2026-02-11): when live `vllm` endpoint is unreachable in this environment, run smoke/ablation with a local OpenAI-compatible stub endpoint (`localhost:8899`) to validate end-to-end orchestration/reporting semantics. Treat these runs as infrastructure validation, not model-quality conclusions.

## 14. Implementation Tracking Checklist (Living TODO)
Usage:
- Mark a task as complete by changing `[ ]` to `[x]`.
- Keep this section updated in every implementation PR.
- Add short notes inline after each item when scope changes.
- Optionally append `(owner, YYYY-MM-DD)` to completed items for auditability.

### 14.1 Phase 0 - Baseline Freeze
- [x] P0.0 Add `scripts/run_evolution_smoke_vllm.sh` and document live model auto-discovery (`curl /v1/models`) for tiny-suite regression runs. (Codex, 2026-02-11)
- [x] P0.1 Create baseline run config file(s) in `data/configs/` for current REvolution backend. (Codex, 2026-02-11; `data/configs/evolution_default.yaml`, `data/configs/funsearch_default.yaml`)
- [x] P0.2 Run baseline smoke experiment and archive command + config snapshot path. (Codex, 2026-02-11; `VLLM_HOST=localhost VLLM_PORT=8899 scripts/run_evolution_smoke_vllm.sh --suite rtllm` -> `/workspace/exp/funsearch_backend_smoke/20260211_140537`, and `--suite verilogeval` -> `/workspace/exp/funsearch_backend_smoke/20260211_140542`.)
- [x] P0.3 Record baseline metrics table (runtime, calls/tokens, pass rates, best score). (Codex, 2026-02-11; RTLLM `Prob001_accu`: runtime `0.434s`, calls `8`, prompt/completion `448/336`, functionality `0.0`, synth `0.0`, best score `N/A`; VerilogEval `Prob001_zero`: runtime `0.276s`, calls `8`, prompt/completion `448/336`, functionality `0.0`, synth `0.0`, best score `N/A`.)
- [x] P0.4 Confirm baseline report generation works without code changes. (Codex, 2026-02-11; `scripts/evolutionary_report_generator.py --experiment_path /workspace/exp/funsearch_backend_smoke/20260211_140537/stub-model` succeeded.)

### 14.2 Phase 1 - Backend Abstraction
- [x] P1.1 Add backend interface in `src/revolution/backends/base.py`. (Codex, 2026-02-11)
- [x] P1.2 Extract reusable evaluation orchestration into `src/revolution/runtime/candidate_evaluator.py`. (Codex, 2026-02-11)
- [x] P1.3 Add reusable artifact/schema writer in `src/revolution/runtime/run_artifacts.py`. (Codex, 2026-02-11)
- [x] P1.4 Implement `src/revolution/backends/revolution_backend.py` adapter preserving current behavior. (Codex, 2026-02-11)
- [x] P1.5 Add `scripts/run_backend.py` and keep `scripts/run_evolution.py` backward-compatible. (Codex, 2026-02-11; `run_evolution.py` delegates when `--backend != revolution`)
- [x] P1.6 Add schema compatibility handling for legacy key `accumulated_strategy_counts:`. (Codex, 2026-02-11; runtime alias + report parser fallback)
- [x] P1.7 Add unit tests for backend interface + compatibility path. (Codex, 2026-02-11; new tests under `tests/revolution/` and `tests/scripts/`)

### 14.3 Phase 2 - FunSearch Backend MVP
- [x] P2.1 Implement islands model and prompt sampling loop in `src/revolution/backends/funsearch_backend.py`. (Codex, 2026-02-11)
- [x] P2.2 Implement signature clustering and temperature-based sampling. (Codex, 2026-02-11)
- [x] P2.3 Implement island reset/reseed logic with configurable `reset_period_seconds`. (Codex, 2026-02-11)
- [x] P2.4 Implement score reducer options (`last_input|mean|fitness`) and summary logging of selected reducer. (Codex, 2026-02-11)
- [x] P2.5 Wire FunSearch backend to shared `CandidateEvaluator`. (Codex, 2026-02-11)
- [x] P2.6 Add deterministic seed plumbing (`--seed`, per-worker seed derivation, metadata logging). (Codex, 2026-02-11; `run_backend.py` seed derivation + summary metadata)
- [x] P2.7 Add run budget controls (`max_evaluations`, `max_iterations`, `max_runtime_seconds`, optional token/call ceilings). (Codex, 2026-02-11)
- [x] P2.8 Add prompt key validation (`strict_prompt_keys`) and fail-fast startup behavior. (Codex, 2026-02-11)
- [x] P2.9 Cross-check FunSearch backend mechanics against reference code/paper and align signature/reducer/reset behavior where feasible in RTL adaptation. (Codex, 2026-02-11; signature now uses sorted score-vector keys, reducer default set to `last_input`, and reset checks occur per candidate registration.)

### 14.4 Phase 2b - FunSearch Prompt Profile
- [x] P2b.1 Create `data/prompts/funsearch/system/whole.txt`. (Codex, 2026-02-11)
- [x] P2b.2 Create `data/prompts/funsearch/feedback/system.txt`. (Codex, 2026-02-11)
- [x] P2b.3 Create `data/prompts/funsearch/feedback/user.txt`. (Codex, 2026-02-11)
- [x] P2b.4 Create `data/prompts/funsearch/funsearch/prompt_header.txt`. (Codex, 2026-02-11)
- [x] P2b.5 Create `data/prompts/funsearch/funsearch/program_block.txt`. (Codex, 2026-02-11)
- [x] P2b.6 Create `data/prompts/funsearch/funsearch/prompt_footer.txt`. (Codex, 2026-02-11)
- [x] P2b.7 Create `data/prompts/funsearch/funsearch/eval_feedback_suffix.txt`. (Codex, 2026-02-11)
- [x] P2b.8 Add prompt-profile tests for missing key failure and successful load. (Codex, 2026-02-11; `tests/revolution/test_funsearch_backend.py`)

### 14.5 Phase 3 - Reporting and Comparison Automation
- [x] P3.1 Update `scripts/evolutionary_report_generator.py` to parse standardized backend-agnostic schema. (Codex, 2026-02-11; `accumulated_strategy_counts` alias + `stage_success_rates` fallback)
- [x] P3.2 Keep backward-compatible parsing for historical REvolution summaries/logs. (Codex, 2026-02-11; retains `accumulated_strategy_counts:` path and log fallback)
- [x] P3.3 Add backend-specific appendix rendering (`backend_details` block). (Codex, 2026-02-11; backend mix section in benchmark reports)
- [x] P3.4 Add multi-backend comparison script/config for same benchmark/problem/model/budget. (Codex, 2026-02-11; `scripts/backend_comparison_report.py`, `tests/scripts/test_backend_comparison_report.py`)
- [x] P3.5 Add report regression tests for mixed old/new experiment directories. (Codex, 2026-02-11; `tests/scripts/test_evolutionary_report_generator.py`)

### 14.6 Phase 4 - Hardening and Regression
- [x] P4.1 Add unit tests for FunSearch island reset, sampling probabilities, and prompt assembly ordering. (Codex, 2026-02-11; covered in `tests/revolution/test_funsearch_backend.py` run-path tests)
- [x] P4.2 Add reproducibility tests (same seed => same selection trajectory under mocks). (Codex, 2026-02-11; `test_funsearch_backend_reproducible_with_fixed_seed`)
- [x] P4.3 Add integration smoke tests on at least one RTLLM and one VerilogEval-Spec-to-RTL problem. (Codex, 2026-02-11; smoke runs completed via local OpenAI-compatible stub endpoint for `RTLLM/Prob001_accu` and `VerilogEval-Spec-to-RTL/Prob001_zero`; post-alignment sanity rerun completed at `/workspace/exp/funsearch_alignment_smoke/` for both `revolution` and `funsearch` backends on `RTLLM/Prob001_accu`.)
- [x] P4.4 Add strict ablation mode tests (`strict_ablation`) and optional accelerated mode tests (`search_accelerated`). (Codex, 2026-02-11; `tests/revolution/test_candidate_evaluator.py`, `tests/revolution/test_candidate_evaluator_parity.py`, `tests/scripts/test_run_backend_ablation.py`)
- [x] P4.5 Add performance guardrail checks (runtime/calls/tokens thresholds on smoke suite). (Codex, 2026-02-11; ablation/report tooling now tracks runtime and LLM calls/tokens per backend/problem and emits comparable tables)
- [x] P4.6 Verify license/provenance notices for any FunSearch-derived logic. (Codex, 2026-02-11; method-derived reimplementation with explicit reference in this plan + code comments/paths)

### 14.7 Ablation Execution Checklist
- [x] A1 Finalize open decisions from Section 13. (Codex, 2026-02-11; primary budget axis, score reducer default, benchmark scope, prompt strictness all fixed and documented.)
- [x] A2 Freeze shared experiment settings (model, backend, prompts, toolchain, timeouts). (Codex, 2026-02-11; `scripts/run_backend_ablation.py` + `data/configs/*` encode shared settings)
- [x] A3 Run multi-seed REvolution backend baseline. (Codex, 2026-02-11; strict-ablation runs complete for seeds `42,43` over `RTLLM`, `VerilogEval-Code-Complete`, `VerilogEval-Spec-to-RTL` at `/workspace/exp/ablation_full_suite_stub_20260211_v2/revolution`.)
- [x] A4 Run multi-seed FunSearch backend with same primary budget axis. (Codex, 2026-02-11; strict-ablation runs complete for seeds `42,43` at `/workspace/exp/ablation_full_suite_stub_20260211_v2/funsearch`.)
- [x] A5 Generate unified comparison report with mean/std/CI. (Codex, 2026-02-11; `/workspace/exp/ablation_full_suite_stub_20260211_v2/backend_comparison.md` includes per-problem and aggregate mean/std/CI95 tables.)
- [x] A6 Review anomalies and rerun any invalid/failed seeds with documented rationale. (Codex, 2026-02-11; anomaly found: FunSearch run result status erroneously marked success when all candidates failed. Fixed in `src/revolution/backends/funsearch_backend.py`, added regression test, reran full suite to produce `_v2` artifacts.)

### 14.8 Evaluation Integration Checklist (Strict-Ablation Gate)
- [x] E1 Implement backend-agnostic `CandidateEvaluator` with explicit stage outputs and status enums. (Codex, 2026-02-11; `CandidateStatus` + structured stage outputs in `src/revolution/runtime/candidate_evaluator.py`)
- [x] E2 Add compatibility mode reproducing current `EoHEngine` hard-failure scoring (`-inf`) semantics. (Codex, 2026-02-11; strict mode default `failure_score=-inf` and parity tests)
- [x] E3 Add configurable failed-candidate internal score bucketing for FunSearch clustering (without changing final report semantics). (Codex, 2026-02-11; `--fs_failed_candidate_bucket_score`)
- [x] E4 Add toggle for feedback-calling policy (`always`, `fail_only`, `off`) and log selected policy in summary metadata. (Codex, 2026-02-11; `--fs_feedback_policy` + `backend_details.feedback_policy`)
- [x] E5 Implement `strict_ablation` mode enforcing full syntax+functionality+synthesis/PPA on all candidates. (Codex, 2026-02-11; `--evaluation_mode strict_ablation`)
- [x] E6 Implement `search_accelerated` mode with explicit synth-throttling policy and report labeling. (Codex, 2026-02-11; `--evaluation_mode search_accelerated --accelerated_synthesis_top_k` + summary metadata)
- [x] E7 Add parity tests comparing legacy evaluation vs new evaluator on fixed candidate fixtures. (Codex, 2026-02-11; `tests/revolution/test_candidate_evaluator_parity.py`)
- [x] E8 Add fairness checks that budgets and timeouts are identical across backends in strict-ablation experiments. (Codex, 2026-02-11; `_validate_fairness` in `scripts/run_backend_ablation.py`, tested in `tests/scripts/test_run_backend_ablation.py`)
- [x] E9 Propagate reference PPA metadata through backend runner/evaluator initialization to avoid empty `ref_ppa_metric` in FunSearch summaries. (Codex, 2026-02-20; `scripts/run_backend.py`, `src/revolution/backends/funsearch_backend.py`, `tests/revolution/test_funsearch_backend.py`)
- [x] E10 Add selectable primary budget axis and explicit call-cap validation in ablation orchestration. (Codex, 2026-02-20; `scripts/run_backend_ablation.py`, `tests/scripts/test_run_backend_ablation.py`)

### 14.9 Runtime Blockers
- Live-ablation execution is currently blocked in this environment (2026-02-11):
  - `curl -s http://vllm:8888/v1/models` -> host resolution failure (`vllm` unreachable).
  - `localhost`, `127.0.0.1`, `host.docker.internal`, and `172.17.0.1` on port `8888` were also unreachable.
  - No fallback API keys were available in environment (`OPENAI_API_KEY`, `OPENROUTER_API_KEY`, `DEEPSEEK_API_KEY`, `GEMINI_API_KEY` unset).
- Fallback execution status (2026-02-11):
  - Local stub endpoint (`localhost:8899`) used to validate full smoke + multi-seed ablation orchestration and report generation.
  - These runs verify infrastructure wiring and fairness logic, but they are **not** representative of live-model quality.
