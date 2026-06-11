# Journal Revamp Implementation History

## 2026-06-12 00:50 KST

Created the revamp scaffold for the TCAD journal-extension push.

- Branch: `feat/journal-revamp-20260612-005012-kst`.
- Base branch: `wip/journal-extension-2026`.
- Manuscript setup commit: `26c3d79264`
  (`docs(journal): add manuscript submodules`).
- Scaffold directory:
  `docs/journal_features/revamp_history/20260612_005012_KST_journal_revamp/`.
- Top-level goal spec:
  `docs/journal_features/08_journal_revamp_goal.md`.

Initial decisions captured:

- Treat `conference_submission_paper` as frozen submitted source.
- Use `journal_draft` for TCAD manuscript work.
- Treat `/workspace/.worktrees/realbench_integration_draft` as reference only.
- CVDP headline metric is functional pass rate.
- CVDP PPA, if added, is absolute-only unless a vetted reference protocol is
  introduced later.
- Final claims require 5 fixed seeds; seed 42 is debug only.
- Scheduler throughput is a required workstream, with a 25 percent wall-clock
  improvement gate on a fixed replay or bounded smoke harness.
- DeepSeek `deepseek-v4-pro` is a predeclared capability-escalation arm for
  long RealBench-style tasks. Its `DEEPSEEK_API_KEY` must come from `.env` and
  must never be printed, committed, or copied into artifacts.
- A locked RealBench long-model probe must decide whether local vLLM is
  sufficient or whether final RealBench claims need a symmetric DeepSeek arm.
- Added explicit read-only links to the frozen ASP-DAC paper sources so the
  implementer can understand the original local-search, scalar-PPA,
  prompt-operator, UCB-softmax, and benchmark/result claims before rewriting
  journal methodology or experiments.
- Added a ruminations coverage audit. The plan is suitable as a starting goal
  because each major rumination now maps to a method change, evidence gate, or
  claim-narrowing rule; the main risk is scope rather than missing intent.
- Added `/workspace/baselines` as a retrospective resource for FunSearch,
  CodeEvolve, and EoH-style RTL comparisons. These archives should inform
  reviewer-facing experiment planning, but final claims require fair rerun or
  revalidation under the revamp gates.
- Added explicit implementation and git practice guardrails to the scaffold:
  canonical runner usage, scoped staging, tests/lint/typecheck expectations,
  manuscript submodule discipline, signed Conventional Commits, and secret
  hygiene.
- Added a method-evolution rule: the seven current journal-extension pillars are
  allowed to change if a new idea validates well, improves or preserves the
  quantitative gates, and creates a stronger journal narrative.

Next implementation checkpoint:

- Add links from the journal-feature index docs.
- Start benchmark capability schema and scheduler telemetry design.

## 2026-06-12 01:30 KST

Read the frozen ASP-DAC sources (`main.tex`, intro, method, experiments,
result table) before any methodology edits. Confirmed the original claims being
extended: local-search motivation, Thought/Code/Feedback individuals, scalar
weighted PPA fitness, dual-population loop, six prompt operators, UCB-softmax
selection, VerilogEval/RTLLM evidence, and the 200-sample ablation.

Inspected `/workspace/baselines` (FunSearch, CodeEvolve, EoH archives plus the
hard-subset vanilla CSV). Decision: keep them as retrospective context for
narrative and reviewer planning; any baseline that enters a final TCAD table
must be rerun under the locked revamp manifests, seeds, model policy, token
budgets, scheduler policy, and statistics. No rerun is scheduled until the
final benchmark/seed manifests are frozen.

Implemented the benchmark capability model (workstream A foundation):

- Added `src/revolution/runtime/benchmark_capabilities.py`: per-problem
  `BenchmarkCapabilities` snapshot (functional/synthesis/post-synth/reference
  PPA support, `ppa_mode`, harness kind, workload class, top module,
  clock/reset metadata, aux files, timeout, license tag, suppression notes)
  resolved from suite-family defaults plus per-problem facts.
- CVDP hard rule encoded: reference-normalized PPA requests are suppressed
  with an explicit note (`reference_normalized_ppa_suppressed`); CVDP can only
  be `absolute_only` (synthesis opt-in) or `none`.
- `problem_spec.py` and `realbench_adapter.py` now derive
  `supports_synthesis`, `supports_reference_ppa`, and `quality_mode` from the
  capability snapshot instead of `benchmark_name.lower()` switches; behavior
  for existing suites is unchanged and covered by tests.
- `build_cvdp_problem_spec` gained an explicit `enable_synthesis` opt-in for
  the future absolute-only CVDP PPA path.
- Run summaries now embed `backend_details.problem_spec.benchmark_capabilities`
  via `revolution_backend._annotate_summary` so reports can read what each
  suite may legitimately claim.
- Tests: new `tests/revolution/test_benchmark_capabilities.py` plus extended
  `test_problem_spec.py` / `test_realbench_adapter.py` covering capability
  metadata and no-reference PPA suppression.

Validation: full `pytest` (631 passed, 4 skipped), `ruff check` clean on
touched files, `pyright` clean on the three touched runtime modules.

Deferred: user-facing docs pass (README/user_guide/module_structure) for the
capability model is intentionally batched with the CVDP/RealBench end-to-end
integration milestone so benchmark docs land once, coherently.

## 2026-06-12 02:00 KST

CVDP integration milestone (workstream A):

- Dataset profile (cvdp_v1.0.2 no-commercial): 302 records across cid002 (94),
  cid003 (78), cid004 (55), cid007 (40), cid016 (35); 140 medium / 162 easy.
- `select_cvdp_ids` now supports full-dataset discovery: an empty filter or
  the `all` sentinel selects every record (difficulty labels such as `medium`
  were already usable because they live in the same `categories` list).
  `--cvdp_categories` help text documents this; default filter unchanged.
- Added `scripts/build_cvdp_debug_subset.py`: deterministic, category-balanced
  locked subset builder (per-category seeded shuffle over sorted eligible ids,
  seed recorded; dataset sha256 provenance embedded). Generated the locked
  debug manifest `data/configs/cvdp_debug_subset.yaml`:
  10 medium tasks, 2 per challenge category, seed 42.
- Bounded harness smoke (no LLM): ran `CVDPEvaluator` end-to-end on locked
  task `cvdp_copilot_kogge_stone_adder_0007` with a stub DUT in this
  container. Harness materialization, src/.env rewrite, pytest+cocotb run,
  and classification all worked: status `failed_functionality` with
  format/syntax stages true — a clean classified failure, not an
  environment/dependency error. cocotb 2.0.0.dev0 and pytest 8.4.1 confirmed
  in `.venv`; the evaluator bypasses the upstream docker-compose path by
  running pytest directly.
- DeepSeek preflight: `.env` loaded with non-echoing shell test;
  `DEEPSEEK_API_KEY` confirmed present (length-only check, value never
  printed). This satisfies the credential-preflight item of the debug gate.
- Validation: ruff clean on touched files; pyright clean on touched modules;
  focused pytest for cvdp evaluator + subset builder (9 passed) and
  `tests/scripts/test_run_backend.py` (28 passed).

Remaining CVDP item: absolute-only PPA path is intentionally deferred until
synthesis reliability on CVDP DUTs is demonstrated; the capability model
already exposes the `enable_synthesis` opt-in and clamps reference-normalized
claims.
