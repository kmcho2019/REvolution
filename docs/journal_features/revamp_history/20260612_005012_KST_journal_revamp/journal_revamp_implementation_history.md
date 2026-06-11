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

## 2026-06-12 03:30 KST

RealBench integration milestone (workstream A):

- Dataset facts (exp/RealBench, MIT license, IPRC-DIP): 60 module tasks
  (aes=6, sdc=14, e203_hbirdv2=40) plus 4 system tasks (not integrated).
  Prompts ship gpg-encrypted; `make -C exp/RealBench decrypt` (passphrase in
  the upstream Makefile) produces the `.md` specs. Each task's
  `verification/` dir is self-contained: `{module}_testbench.sv` (top module
  name varies per task), `{module}_stimulus_gen.sv`, `{module}_ref.sv`
  (golden renamed `ref_<module>`), bundled dependency/defines `.v` sources,
  and a verilator-5-targeted Makefile. Installed verilator is 4.038 (no
  `--binary`/`--timing`), so the official flow cannot run here; the
  integration uses the framework's strict iverilog path instead.
- Added `scripts/build_realbench_manifest.py`: deterministic manifest-tree
  generator (prompt text mirrors upstream `generate_problem.py` family
  defines notes; `test.sv` = testbench + stimulus + ref concatenation;
  `golden.v` kept out of the compile set to avoid module-name collision with
  candidates; `support/*.v` copied per task; per-entry size signals for the
  future long-model probe; tree-level manifest sha256). `--validate` runs
  every golden through the harness and records `harness_validated` /
  `harness_failure_reason` per entry.
- Evaluator extensions: `VerilogEvaluator.evaluate` gained `include_dirs`
  (`-I`) and `defines` (`-D`); `CandidateEvaluator` resolves
  `problem_spec.aux_files` into extra compile units + include dirs and
  `metadata.compile_defines` into `-D` flags; mismatch parsing extracted to
  `parse_mismatch_count` with a fallback for the VerilogEval-v1-style
  `Total mismatched samples is N out of M` summary that e203 testbenches
  emit (RTLLM/VerilogEval behavior unchanged: primary `Mismatches:` protocol
  takes precedence).
- e203 dialect fix: support sources guard SV assertions behind upstream's
  `DISABLE_SV_ASSERTION`; manifest entries for the family carry
  `compile_defines: [DISABLE_SV_ASSERTION]`. This plus the protocol fallback
  moved golden validation from 7/60 to 38/60 tasks
  (aes=3, sdc=4, e203=31). The 22 excluded tasks have recorded reasons:
  iverilog cannot parse some sdc/aes harness constructs (const array init,
  malformed-statement SV, procedural drives of implicit wires), and 7 tasks
  run but their goldens mismatch (assertion/X-check-dependent behavior,
  including sdc_controller). Exclusions stay in the manifest as
  `harness_validated: false` so coverage claims remain honest.
- Locked debug subset `data/configs/realbench_debug_subset.yaml`
  (12 tasks, seed 42): aes 3 (all validated aes), sdc 4, e203 5 via
  deterministic depth-by-depth top-up; embeds the manifest sha256.
- Repo decision: `data/bench/RealBench/` is generated and gitignored
  (~12 MB, rebuildable deterministically); the generator, locked subset, and
  docs are tracked.
- Docs updated: README utilities, user_guide section 4, module_structure,
  GUIDELINES.md (CLAUDE/AGENTS symlink target) Where-To-Look and commands.
- Validation: full pytest 644 passed / 4 skipped; ruff + pyright clean on
  touched files; golden determinism spot-checked (two identical replays per
  sampled task) and the full sweep is itself a deterministic replay artifact.

## 2026-06-12 05:00 KST

Scheduler telemetry + throughput gate milestone (workstream B):

- Telemetry: `ElasticSlotCoordinator` now records an event log
  (open/close/lease/lease_end with monotonic timestamps, batch size,
  target vs granted workers) into Manager-backed shared state;
  `summarize_scheduler_telemetry` aggregates wall time, busy-worker
  integral, mean occupancy, peak busy workers, and per-problem active
  seconds / lease counts / busy worker-seconds / requested-vs-granted
  shortfall seconds. `run_backend.py` writes
  `<ts>_<backend>_scheduler_telemetry.json` plus a raw events JSONL next to
  the run log. `CandidateEvaluator` counts candidates evaluated, RTL
  simulation timeouts, synthesis failures, and (structurally zero today)
  evaluator retries; `revolution_backend` embeds the counters in
  `backend_details.evaluator_telemetry`.
- Scheduling policy fix: extra-slot granting is now fair-share capped
  (`total_worker_slots // active_problems` workers per problem) instead of
  first-come-takes-all, so an early lease cannot drain the pool while a
  sibling starts a long batch single-handed; the cap widens automatically as
  problems close. Two pre-existing tests encoding the greedy policy were
  updated with comments.
- Negative result, recorded deliberately: a bounded re-poll ("wait briefly
  for a fuller grant") was implemented and measured HARMFUL on the replay
  gate (-6.1% to -10.5% vs the fixed baseline) because all problems poll and
  short batches stall instead of finishing and releasing slots (convoy). The
  mechanism was removed; per-generation re-leasing plus fair-share granting
  captures the win without waiting.
- Gate harness: `scripts/run_scheduler_replay_benchmark.py` replays one
  seeded heterogeneous workload (8 problems, 3 generations, two
  synthesis-heavy long-tail problems, think-time between batches) through
  the real pool/coordinator machinery under `fixed` (static equal split,
  the goal's fixed per-problem worker baseline) and `elastic` policies,
  asserting identical candidate-outcome digests.
- Gate result (scale 0.5, 16 slots): fixed 19.52s vs elastic 10.54s ->
  46.0% wall-clock reduction with `outcomes_match=true`; elastic mean
  occupancy 0.658, heavy problems ramp to 8 workers after short problems
  close. Evidence archived at
  `revamp_history/20260612_005012_KST_journal_revamp/scheduler_gate_report_20260612.json`.
  Caveat recorded: at very small scales (0.12) constant pool/Manager
  overheads compress the measured gain (~21%); the gate is defined at
  scale 0.5 where modeled latencies dominate, mirroring minutes-scale real
  evaluations.
- Validation: full pytest 653 passed / 4 skipped; ruff + pyright clean on
  touched modules. Live-run occupancy telemetry on a real vLLM run is
  deferred to the seed-42 debug gate, which will exercise the same writer.

## 2026-06-12 06:00 KST

Validation and statistics surfaces milestone (workstream E):

- `src/revolution/journal_stats.py`: paired problem-seed statistics —
  seeded percentile bootstrap CIs, exact two-sided sign test, win rate over
  non-tied pairs, and the goal-spec rule that missing treatment data where
  the baseline succeeded counts as a treatment loss. Gate evaluators encode
  the predeclared thresholds for reference-PPA suites (+0.03 best quality,
  +0.05 avg PPA, +5% hypervolume, CI low > 0, 60% win rate, valid-PPA count)
  and functional suites (+5 points pass rate, CI low > 0).
- `scripts/report_journal_statistics.py`: joins classic/QD run roots via the
  same loader as `backend_comparison_report.py` (identical metric semantics),
  pools problem-seed units across repeated `--pair <seed>=<base>=<treat>`
  arguments, and emits `paired_deltas.csv` (per-unit status records
  `missing_treatment_counted_as_loss` explicitly), `statistical_tests.json`
  (with per-benchmark family breakdown so CVDP functional metrics never
  blend with reference-normalized suites), and `statistical_tests.md`.
  Percent metrics are converted to fraction scale at load so the gate
  thresholds are evaluated exactly as predeclared.
- `scripts/validate_journal_revamp_run.py`: validates one run root against
  locked subset configs (coverage per benchmark), config-snapshot presence
  and expected seed, scheduler-telemetry presence/health, and QD per-problem
  artifacts (`archive_summary.json`, `qd_metrics.json`,
  `descriptor_health.json`), nonzero archive occupancy, and no total
  descriptor collapse. JSON+MD reports, nonzero exit on failure.
- `data/configs/journal_seed_manifest.yaml`: pre-registered seed manifest —
  debug seed 42 (never publication evidence), final seeds 1001-1005 frozen
  before any final-gate run.
- `scripts/journal_rerun_ledger.py`: append-only JSONL ledger
  (`revamp_history/.../rerun_ledger.jsonl`) recording purpose, run root,
  seeds, git commit, and config-snapshot sha for every journal-relevant
  launch.
- Validation: full pytest 667 passed / 4 skipped; ruff + pyright clean on
  all new modules; 14 new tests cover bootstrap determinism, sign-test
  exactness, missing-as-loss accounting, gate thresholds, synthetic run-tree
  joins, and validator failure modes.

## 2026-06-12 08:30 KST

Journal narrative + adversarial review milestone (workstream F), and the
statistics revisions it forced:

- Wrote `docs/journal_features/journal_narrative.md` and ran three full
  adversarial review rounds with four personas (TCAD editor, skeptical
  Reviewer 2, EDA methodology, reproducibility/statistics). Round-1: all
  blocked (16 consolidated issues). Round-2: all round-1 issues resolved
  except narrow consensus defects. Round-3: editor, EDA, and statistics
  personas SIGNED OFF; Reviewer 2 blocked on one hypervolume
  axis-composition clause, fixed in revision 3 (round-4 focused re-check
  pending). Records: `narrative_review_round1.md`,
  `narrative_review_round2_round3.md`.
- The review forced real statistics upgrades (now implemented + tested):
  cluster bootstrap (problems as clusters, seed replicates intact),
  penalized gate statistics (missing-treatment floor imputation as the
  gate-bearing analysis, complete-case beside), TOST-style equivalence for
  Branch B (±0.03 CI containment + pair-count floor), HV log-ratio gate
  statistic with epsilon sensitivity, win-rate gates with non-tied floor +
  sign-test p, true leave-one-seed-out on the penalized statistic.
- The narrative now predeclares: the PPA measurement model (floorplan-stage
  proxies, piecewise eff-clk, reg2reg-only constraints, per-circuit-type
  axis composition), final benchmark scales (20-problem held-out
  reference set; 30 fresh CVDP; 26 fresh RealBench), an exhaustive
  monotone branch-decision table, a component-attribution ablation matrix
  with seeds and parity criterion, budget currency (candidate evaluations,
  ±10% auxiliary skew rule), candidate-pool declarations (with the QD k−1
  logging gap named as a pre-finals engine fix), oracle-overfitting
  equivalence spot-checks, and the RealBench harness disclosure.

## 2026-06-12 09:00 KST

Fast-iteration validation set (user-requested, recorded as standing
infrastructure):

- Problem: hard-subset comparisons (13 problems, 20 pop x 5 gens) cost
  ~1,560 candidate evaluations and hours of wall-clock per arm, and its
  low-functionality problems rarely produce valid-PPA samples — the wrong
  instrument for quick "did this variant help PPA?" checks.
- Added `scripts/build_fast_iteration_subset.py` + locked
  `data/configs/fast_iteration_subset.yaml` + guide
  `docs/journal_features/09_fast_iteration_validation_set.md`.
  Deterministic rule over the 202-problem one-shot pool (sha256
  provenance): functionality >= 0.6, gates in [150, 3000], hard-subset
  excluded, top gate-count per (benchmark x circuit-type) bucket, top-up
  capped at 3 per benchmark. Result: 6 problems (PE/MAC, rule90,
  mux256to1v, fixed-point adder, popcount255, multi_16bit) — 3/3 per
  benchmark, 3 sequential / 3 combinational, all classic PPA-headroom
  design spaces with 0.8-1.0 one-shot functionality.
- Recommended budget embedded in the config: pop 10 x 3 gens, k=4, long
  token budgets, elastic 12 slots — ~240 candidate evals per arm (~15% of
  the hard-subset matrix) with high PPA-sample flow.
- Honesty: tuning/dev artifact only; never publication evidence; the
  future held-out final set must exclude these 6 problems plus the 13
  hard-subset problems (now also recorded in the narrative's
  contamination-control section).
