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

## 2026-06-12 12:00 KST

Fast-iteration instrument formalized as a GATED workstream (user
request): requirements, signoff gates, and mechanical validation added.

- Doc 09 gained the instrument spec: requirements R1-R6 (speed, PPA
  signal flow, discrimination margin, screening validity, stability,
  honesty), quantitative gates G1-G5 (arm wall <= 6000 s and no problem
  > 50% of arm wall; every problem >= 6 valid-PPA candidates per arm;
  quality IQR >= 0.02 on >= 4/6 problems; sign agreement with the
  hard-subset seed-42 ordering on the predeclared calibration pair with a
  +/-0.02 inconclusive band; cross-seed verdict stability on seeds
  42/1001), PROMOTE / DEMOTE / INCONCLUSIVE decision bands (+/-0.02 on
  the paired best-quality delta; inconclusive escalates to the hard
  subset), and a calibration protocol. Revisions only by version bump
  with recorded rationale; the subset is never tuned on a variant's
  results.
- Added `scripts/validate_fast_iteration_pair.py` (+5 tests): checks
  G1-G3 from run artifacts (scheduler telemetry wall, per-problem
  runtimes, distinct successful candidates with PPA metrics from
  generation logs ∪ final population, score IQR) and maps a stats JSON to
  the verdict bands; writes `fast_iter_gate_report.json/md`.
- First real-data reading (pop-10 pilot classic arm; collection-path
  evidence only since that pilot's QD arm hit the divisibility
  constraint): G1a passes (4159 s) but `Prob108_rule90` alone is ~100% of
  arm wall (G1b prune candidate), `Prob016_fixed_point_adder` and
  `Prob108_rule90` are under the 6-candidate PPA-flow floor (G2), and
  only one problem clears the 0.02 IQR floor (G3) at 10-candidate
  populations. Decision deferred to the corrected pop-12 pair currently
  running; likely outcome is `fast_iteration_subset_v2` replacing
  `Prob108_rule90` via the deterministic rule.
- Scaffold plan gained workstream F2; TODO gained the four calibration
  items (pop-12 pair gates, G4 vs hard subset, G5 seed-1001 pair,
  signoff-or-v2 decision).

## 2026-06-12 13:00 KST

Verilator v4.036 -> v5.030 replacement (validated before replacing):

- Findings: upstream RealBench pins `verilator=5.030`
  (exp/RealBench/conda_env.yml) and its per-task Makefile needs v5-only
  flags (`--binary`, `--timing`, `--coverage-line`); our image pinned
  v4.036 (July 2020). Grep over src/scripts/tests/configs confirms no
  REvolution evaluator invokes verilator, so the swap is zero-risk. The
  formal leg of `run_verify.py` needs JasperGold (commercial) and stays
  permanently out of scope.
- Validation first, in a temp prefix: built v5.030 from source and ran
  the OFFICIAL `make compile run` flow on five tasks spanning every
  iverilog failure class. All five pass with 0 mismatches: aes_sbox
  (0/1535), aes_key_expand_128 (const-array exclusion, 0/177),
  sd_data_serial_host (procedural-wire exclusion, 0/15301), e203_biu
  (SVA exclusion, 0/222), and sdc_controller (0/23932) - whose golden
  mismatched 21,852 samples under the strict iverilog harness, proving
  that exclusion was harness-dialect semantics, not a bad golden
  (direct evidence for the manuscript's RealBench disclosure).
- Replacement: Dockerfile section 6 now builds v5.030 (help2man added -
  without it verilator's `make install` dies after binaries but before
  the data files, leaving a broken install that still reports a
  version). With sudo granted in the running container, v5.030 was also
  rebuilt and installed live into /usr/local (replacing v4.036 in
  place), verified by `verilator --version` and a no-overrides official
  flow run - the live container matches the image definition exactly,
  so no rebuild is required.

## 2026-06-12 15:00 KST

Scaffold v2 refactor (user-directed honest reassessment): the v1 goal/plan/
adversarial-prompt documents predate execution and no longer reflect where
the real gaps are. All three were archived verbatim with ARCHIVED banners
(`goal_template_v1_initial.md`, `journal_revamp_plan_v1_initial.md`,
`journal_revamp_adversarial_prompt_v1_initial.md`) and replaced by v2
documents grounded in `revamp_ruminations_20260612.md` (original intent)
and the accepted claims contract:

- `goal_template.md` v2: completion-phase objective acknowledging phase-0
  foundations as done and naming the five remaining fronts (QD repair, BD
  thesis, benchmark vetting incl. the Verilator-5 60-task re-sweep, gate
  experiments, manuscript) with binding anti-fudge rules.
- `journal_revamp_plan.md` v2: phases P1-P5 with open questions answered
  in-line (what counts as closed, what happens when no fix works, axis
  redundancy bounds, end-to-end-not-loaders definitions, freeze ordering);
  the narrative wins on any conflict.
- `journal_revamp_adversarial_prompt.md` v2: sign-off hardened to artifact
  verification - hard preconditions (EVERY TODO item checked AND >=5
  spot-verified against artifacts; claims-contract diff integrity; ledger
  coverage; tuning/evidence disjointness), mechanical gate re-runs, and
  five intent pillars verified in evidence. Sign-off without all of these
  is structurally impossible.
- TODO restructured by v2 phases with 8 new items from the v2 plan (QD
  logging fix, ablation matrix, descriptor-objective correlation, profile
  pre-registration, MDE artifact, final-slice builds, equivalence tooling,
  tool provenance); the 42-item completed phase-0 log is preserved
  verbatim at the bottom.

## 2026-06-12 16:00 KST

goal_template v2.1 (user-directed evidence audit of v2's strong claims):

- Audit findings: v2's "Phase-0 DONE" overstated three things. (1) CVDP
  and RealBench have loaders/harnesses/smokes but NO completed end-to-end
  evolutionary run (the ruminations define integration as end-to-end runs
  with passing candidates). (2) The fast-iteration instrument is not
  signed off: the pop-10 pilot failed G1b/G2/G3 and G4/G5 calibration is
  pending. (3) Narrative acceptance carries open pre-freeze obligations
  (QD k-sample logging fix, MDE artifact, retention update after the
  verilator-5 re-sweep). The scheduler 46% figure is synthetic-replay
  only until live occupancy lands. Genuinely done: capability model,
  locked subsets/probe, statistics/validator/ledger/seed-manifest,
  Verilator 5.030 validation, four-persona narrative acceptance.
- Rewrote goal_template.md in the paste-ready /goal contract format of
  .skills/goal-scaffold (outcome, verification surface, constraints,
  boundaries, iteration policy, blocked stop condition), linking the plan,
  TODO, history, ledger, ruminations, and narrative, with the honest
  starting state stated inline so the implementer cannot inherit the
  overstatement. Intent-coverage soft spots named during the audit (CVDP
  no-reference PPA rating is conditionally covered via the absolute-only
  opt-in; per-suite summaries are covered by the per-benchmark statistics
  breakdown) are recorded here as explicit decisions.

## 2026-06-12 17:00 KST

P1 calibration: pop-12 fast-subset pair completed (classic 4795s, QD
4937s, both rc=0; ledgered). Instrument gate report
(exp/fast_iter/fast_iter_20260612b/gate): G1a passes both arms; G1b/G2/G3
FAIL identically to the pilot — Prob108_rule90 consumes ~100% of each
arm's wall, Prob016_fixed_point_adder and rule90 under the 6-candidate
PPA-flow floor, discrimination 1/6. Decision per the calibration
protocol: cut fast_iteration_subset_v2 excluding both problems on
instrument properties (wall dominance, PPA flow) — never on variant
results — and re-run the calibration pair.

First QD-vs-classic reproduction signal (directional only; instrument
not signed off): functionality at perfect parity (6/6 ties) while QD
loses ALL paired PPA units — best-quality mean delta -0.143 (0W/5L,
penalized), avg-PPA -0.202, hypervolume log-delta -0.029, and one
missing-treatment unit (QD produced no valid-PPA candidate where classic
did). The gap is PPA-quality-specific, not pass-rate. Root-cause
hypothesis queue for P1: (1) ideation-diversity collapse — pop 12 with
thought-only k=4 yields only 3 distinct thoughts/generation vs classic's
12 independent candidates; (2) identify the missing-treatment problem
and its archive/descriptor artifacts; (3) repair/k budget accounting on
these runs (wall parity suggests budgets comparable).

Also: the /goal launch of goal_template v2.1 failed the 4000-char limit
(4414 after the user's adversarial-prompt-path addition); template
compressed below the limit without dropping any section.

## 2026-06-12 18:30 KST

P1 continuation: instrument v2 + the blocking QD logging fix.

- Subset builder gained `--exclude-problems` (instrument-property
  exclusions only) and `--subset-name`; generated
  `data/configs/fast_iteration_subset_v2.yaml` excluding Prob108_rule90
  (wall dominance + PPA flow + missing-treatment) and
  Prob016_fixed_point_adder (PPA flow). Deterministic replacements:
  Prob105_rotate100, Prob017_fixed_point_substractor (still 3/3 per
  benchmark, 3 seq / 3 comb). v2 calibration pair relaunched detached
  (exp/fast_iter/fast_iter_v2_20260612, classic arm started 06:19:58).
- QD thought-mode generation logging now records ALL evaluated code
  samples (`all_samples`) at both call sites instead of representatives
  + fail parents, closing the narrative's pre-finals engine obligation;
  regression test asserts 2 thoughts x k=2 logs 4 samples including
  non-representatives. Pyright: 2 pre-existing errors at engine.py
  587-588 (KS-rebinning scipy attribute types) recorded as prior debt,
  untouched by this change; 55 QD tests pass.

## 2026-06-12 19:30 KST

Instrument v2 pair completed (classic 732s, QD 1154s - the pair now runs
in ~31 min vs ~2.7h; rule90 removal achieved R1). Two checker semantic
fixes from real data, recorded in doc 09: G1b dominance is now measured
against the SUM of per-problem runtimes (problems run concurrently, so
every problem looked dominant vs the wall), and G3 discrimination is
measured on the BASELINE arm only (variant spread collapse is comparison
signal, not instrument failure). With corrected semantics v2 passes G1
fully; G2 fails only on Prob017_fixed_point_substractor (both arms under
the PPA-flow floor) and G3 baseline is 3/6 vs floor 4. Cut
fast_iteration_subset_v3 swapping in Prob019_sub_64bit; v3 pair launched
detached (exp/fast_iter/fast_iter_v3_20260612). QD signal persists on
v2: best-quality 0W/4L/1T at -0.103 with functionality parity - the QD
arm also ran 1.58x classic wall at equal candidate budget, noted for
budget-symmetry accounting.

## 2026-06-12 20:30 KST

P2 first descriptor-objective evidence (exploratory, from the v1/v2
fast-pair QD archives on disk, n=38 pooled members): |r| vs g_P/g_A/g_T:
logic_depth 0.23/0.17/0.14 (healthy); ff_depth 0.94/0.73/0.67 with
spread only 0..3 (the redundancy suspect is ff_depth on these problems,
NOT comb_width_log at 0.37/0.33/0.33). METHOD CAVEAT recorded: pooling
across problems inflates r via problem-level effects - the formal P2
analysis must compute within-problem correlations and aggregate by
cluster, and needs hard-subset data (fast-subset problems are
PPA-headroom-easy with shallow FF structure). Lead candidate profile to
pre-register stays {logic_depth, ff_depth, rent_exponent} with the
2-axis control; the bake-off decides.

Also: held-out 20-problem reference EVIDENCE set locked (commit
81e6edcec1; stratified seed-7777 rule, no functionality filter,
exclusion list embedded). v3 pair in flight: classic arm finished in
10 min (sub_64bit fast); QD arm running since 07:41.

## 2026-06-12 22:00 KST

Instrument v3 PASSES G1-G3. v3 pair: classic 598s, QD 1055s, G1/G2 clean
on all six problems. G3 recalibrated pre-signoff with data-backed
rationale (doc 09): retained-IQR is selection-compressed (the two
largest-margin problems showed IQR 0.000), so G3 now uses the
best-minus-median quality gap >= 0.02 on >= 4/6 baseline problems -
which also correctly fails the genuinely saturated problems (pe,
popcount255). v3 gate report: exp/fast_iter/fast_iter_v3_20260612/gate
(PASSED; screening verdict for the QD target remains DEMOTE, the
expected known-gap signal G4 must reproduce). Chained completion runs
launched detached: seed-1001 v3 pair (G5), then the hard-subset seed-42
classic-vs-QD pair at 20x5 (G4 + P1 reproduction + MDE variance).
Note: the seed-1001 pair restarted over a ~2-minute partial launch
killed by a pkill that matched its own command line; summaries come
entirely from the fresh run.

## 2026-06-12 23:00 KST

External-tooling decision + ltp online cross-check landed: in-loop
descriptors stay in-process; `ltp -noff` appended to the evaluator's
existing yosys script with `logic_depth_ltp` / `logic_depth_ltp_delta`
emitted per candidate (ground truth: depth 4 vs ltp 4, delta 0; earlier
probe silence was the -q flag suppressing yosys logs). RentCon stays an
offline pinned-dependency reference; KaHyPar fallback only. Visualizer
compatibility adopted as a standing plan rule with a three-item risk
register (all-samples logging semantics, profile-agnostic axes, additive
side metrics). G5 seed-1001 pair: classic arm done rc=0 in ~11 min, QD
arm in flight; hard-subset G4/P1 pair queued behind it.

## 2026-06-13 00:00 KST

G5 stability PASSES: the v3 instrument gives the same verdict sign on
seeds 42 and 1001 (DEMOTE; best-quality -0.0855 vs -0.1884, both
0W/5L/1T, both pairs passing G1-G3). Instrument sign-off now pends only
G4 (hard-subset seed-42 sign agreement); the hard-subset 20x5 pair is
running. The QD-target gap is now reproduced across four completed
pairs with zero QD wins on any paired PPA unit - the repair phase
starts from an unusually consistent failure signature: PPA-quality
losses at functionality parity, QD wall 1.5-1.8x classic at equal
candidate budget, retained-spread collapse, and only 3 distinct
thoughts per generation at pop 12 / k=4.

## 2026-06-13 00:45 KST

Formal P2 correlation script landed
(scripts/report_descriptor_objective_correlation.py + tests): Pearson r
WITHIN each problem, median-|r| aggregation across problems, min-sample
floor, archive-bias caveat embedded. First run on the three tuning QD
roots FLIPS the exploratory pooled verdicts: logic_depth = REDUNDANT
(median |r| >= 0.8; mechanistically plausible - combinational depth IS
the critical-path/timing axis), ff_depth and comb_width_log = OK. This
is exactly why pooled correlation was disallowed. Decision deferred to
hard-subset data (richer problems, 13 vs 6; pair running since 08:56)
before any profile action; if confirmed, the bake-off's candidate
profiles need a timing-decoupled depth variant (e.g., depth normalized
by cell count) or logic_depth's diversity claim is dropped per the
predeclared bound. Hard-subset G4/P1 pair separately confirmed launched
(earlier chain step-2 never started - the wrapper died in the pkill
incident and step-1 survived as an orphan; 'RUNNING' checks now use
artifacts, not pgrep self-matches).

## 2026-06-13 01:30 KST

Visualizer-compatibility risk register: items (a) and (c) CLOSED with
evidence. Grep audit of every population_ppa_details consumer:
pareto_analysis (HV pool) is the fix's intended beneficiary; the
backend comparison report and statistics now see symmetric evaluated
histories for both arms; the three validate_*_run.py audits collect
details without count invariants; plot/catalog scripts tolerate more
rows; the Pareto visualizer and per-problem histograms read archive
artifacts and never touch generation-log details. Additive
logic_depth_ltp* metrics are name-filtered by descriptor-axis
selection. Item (b) (profile-agnostic axis rendering) stays open and
gates any P2 profile swap. Hard-subset pair progress: 2/13 classic
problems at ~30 min.

## 2026-06-13 02:15 KST

RentCon build reconnaissance: the vendored source (UCSD 2008) bundles
MLPart - real min-cut partitioning, the classic-methodology Rent
reference we want. Build under g++ 11 fails on (1) the bundled gsl's
ancient configure and (2) pre-C++11 header leniency (strcasecmp needs
<strings.h>). Porting recipe recorded in the TODO; port deferred to a
dedicated offline session (P2, off the critical path). Hard-subset
pair: 7/13 classic problems at ~75 min.

## 2026-06-13 03:00 KST

MDE analysis script landed (scripts/report_mde_analysis.py + tests):
seeded simulation faithful to the gate machinery (cluster bootstrap,
CI-low>0). PRELIMINARY run on fast-pair variance (sd_problem=0.116,
sd_seed=0.078, 6 problems - small sample): continuous MDE 0.08 at 20x5
(gate threshold +0.03 is under-powered), 0.12 at 13x5; binary MDE ~20pp
at 30 tasks x 5 seeds (the +5pp CVDP gate with CI-low>0 is likely
infeasible), no MDE within grid at 10 tasks. This confirms the round-1
statistics persona's warning. Per the predeclared ratchet, the
freeze-time decision (re-run on hard-subset variance first) is: raise
counts where affordable, otherwise the affected gate DROPS its claim -
thresholds are not retuned. Hard-subset pair: classic arm done rc=0 in
52 min; QD arm in flight (4/13 at first check).

## 2026-06-13 04:00 KST

GPU HANDOFF DIRECTIVE (user): a lab colleague needs the GPU serving
gpt-oss-120b. Effective immediately: NO new local-vLLM runs. The
in-flight hard-subset QD arm (the last running job, final problem)
completes, then the GPU is formally handed off with a visible canary
file /workspace/GPU_7_FREE_<timestamp> created only after verifying no
REvolution process is alive. Fallback for all subsequent LLM runs:
--api_backend openrouter with OPENROUTER_API_KEY from .env (presence
verified non-echoing; openai/gpt-oss-120b is available via OpenRouter,
keeping the model family). FAIRNESS NOTE recorded: provider-side
serving differences are acceptable for fast-subset screening, but any
gate-bearing comparison must run BOTH arms on the same provider, and a
provider switch before finals must be recorded in the ledger and the
tool-provenance statement.

## 2026-06-13 04:30 KST

OpenRouter validation step 1 PASSED: openai/gpt-oss-120b responds
correctly via OpenRouter (exact requested content, finish_reason=stop,
sane usage; key loaded from .env, never printed). Step 2 (performance
parity) protocol, to run AFTER the GPU handoff so the card is not
re-occupied: a bounded gen-0-style probe on 3 fast-subset problems x 8
samples via --api_backend openrouter, comparing functionality rates
against the same problems' local-vLLM gen-0 rates already on disk from
the v3 pairs. Tolerance: coarse not-broken + same-ballpark check (small
N); any systematic gap is recorded and triggers the same-provider rule
for all comparisons. The hard-subset QD arm is still on its final
problem; handoff canary follows its completion.

## 2026-06-13 05:00 KST

INCIDENT, corrected within one iteration: a premature GPU_7_FREE canary
was created and immediately REMOVED. Root cause: pgrep -f with BRE
alternation ('a\|b') in an ERE context matched nothing and reported
zero processes while the QD arm was alive (now verified: 9 workers,
final problems including gshare). Liveness checks now use plain ERE
('a|b') and the canary is only written after a verified-empty audit
plus the launcher's own 'all done' line.

Second discovery from the same audit: the running 'hard subset' pair is
actually an 11-problem HYBRID - the sed/regex launcher surgery left
Prob048_pe and Prob011_multi_16bit (fast-subset strays) in and dropped
four hard problems (adder_8bit, multi_pipe_8bit, fsm, parallel2serial).
Consequences, decided per the no-new-local-runs directive: (1) G4 is
evaluated on the 9-problem GENUINE-hard intersection (sign agreement on
ordering is the gate's intent; the intersection is recorded honestly as
such); (2) the two stray problems are excluded from the G4/P1 analysis
(they are tuning-instrument problems); (3) the four missing hard
problems are NOT rerun locally - if a full 13-problem reference is
needed later it runs via OpenRouter under the same-provider-both-arms
rule. Launcher templates get generated from problem lists in configs,
never sed surgery, going forward.

## 2026-06-13 06:00 KST

OpenRouter parity probe PASSES (step 2 of the fallback validation):
gen-0 probe, 3 fast-subset problems x 8 samples of openai/gpt-oss-120b
via OpenRouter, evaluated locally. Functionality 0.875 (multi_16bit) /
1.0 (popcount255) / 1.0 (rotate100), pooled 23/24 = 96% vs the ~1.0
local-vLLM reference; syntax 100% everywhere; run ledgered
(exp/openrouter_parity_probe). Verdict: not broken, same ballpark -
cleared for fast-subset screening. The same-provider-both-arms rule
still governs anything gate-bearing; the tool-provenance statement
must name the provider per run. Probe ran concurrently with the QD arm
since it never touches the local GPU (sequencing correction noted).
QD arm: still on its final problems (9 workers).

## 2026-06-13 07:15 KST — CONVERGENCE MILESTONE

Hard-subset pair completed (classic_rc=0 qd_rc=0, ledgered). GPU
formally handed off: canary /workspace/GPU_7_FREE_20260612_121425
created after the launcher's own completion line plus a
self-match-proof process audit (pgrep bracket pattern).

G4 PASSES on the 9-problem genuine-hard intersection (strays pe and
multi_16bit excluded): best-quality mean delta -0.0803, 2W/7L/0T,
missing_t=0 - same sign as both fast-subset verdicts. INSTRUMENT v3
FULLY SIGNED OFF (G1-G5). Every subsequent repair candidate gets a
~30-minute trustworthy screen on OpenRouter.

P1 reproduction is formal: the QD target loses on genuine hard
problems at 20x5 (seed 42). Functionality ties 9/9 - on this subset at
this budget the deficit is PURE PPA QUALITY, not solved counts. QD
recorded its first two problem wins (identify which two as the lead
diagnostic for what QD does right). Next: MDE re-run on hard-subset
variance, correlation re-run on hard-subset archives, k-ablation pair
on OpenRouter via the generated launcher.

## 2026-06-13 07:45 KST

Post-convergence analyses + first OpenRouter repair screen:

- MDE on hard-subset variance: continuous MDE ~0.12 at 13x5 and 20x3 -
  the +0.03 best-quality gate stays under-powered at planned scales;
  freeze-time ratchet input archived (exp/fast_iter/mde_hard_subset).
- Descriptor correlation on hard-subset archives: ALL THREE axes OK -
  logic_depth's fast-subset REDUNDANT verdict was a small-n artifact;
  the trio passes the redundancy bound on the best available data
  (exp/fast_iter/descriptor_correlation_hard). Bake-off still compares
  pre-registered profiles, but nothing forces replacement.
- QD's two hard-subset wins: Prob049_signal_generator and
  Prob135_m2014_q6b - lead diagnostics for what the archive does right.
- k=2 ablation pair launched on OpenRouter via the generated launcher
  (exp/fast_iter/k_ablation_k2; classic arm 12:16:01) - the first
  screened repair candidate on the signed-off instrument, isolating the
  ideation-diversity hypothesis (6 thoughts/gen at k=2 vs 3 at k=4).

## 2026-06-12 13:05 KST — P1 mechanistic diagnosis (hard-subset-42 artifacts)

Systematic pass over the QD arm's per-problem artifacts
(exp/fast_iter/hard_subset_42/qd; tables reproduced in the analysis
below) found three distinct failure regimes:

1. Realization pass-rate collapse on spec-exact problems (the big
   losses). QD evaluated exactly 120 samples/problem (30 thoughts x 4)
   with zero repair (repair_kind=none everywhere). Functional pass
   rates: m2014_q3 3% (4/120) vs classic 68 valid logged; alu 15% vs
   classic ~100%. Mechanism, verified on
   m2014_q3 Gen0/g000_thought_0001: the thought TRANSCRIBES the spec
   and gets it wrong - it re-declared `input [3:0] x` with its own bit
   mapping while the spec's Karnaugh map indexes x[1]..x[4], then
   stated SOP product terms over the wrong indices; all 4 realizations
   followed the thought (33/100 mismatches) even though the K-map is
   present in the realization prompt and the template already says the
   problem description is authoritative. One bad transcription poisons
   all k samples; classic never transcribes (code prompts answer the
   spec directly).
2. No actionable failure feedback in thought space. fail_pool parents
   ARE selected (15/30 thoughts on m2014_q3) but
   _format_parent_for_single_thought_operator serializes only
   {thought, evaluation_status:"failed"} - no failure stage, no
   mismatch counts, no error excerpt (engine.py ~1750). The model
   repeats the same misunderstanding for 5 generations. Classic's
   operators carry parent code + feedback.
3. Archive degeneracy on small designs. 4/11 problems never exited
   grid-quantile warmup (every observation warmup_buffered; pe 30/30,
   circuit7 11/11, fsmonehot 15/15; m2014_q3 only 3 valid
   observations) because all three journal-trio axes collapsed
   (unique_count=1). Those problems ran with no functioning archive;
   coverage misleadingly reports 1.0 on a 1-cell space. Direct P2
   coupling: the trio is degenerate exactly on small hard problems.

Inverse evidence: where the machinery worked, QD won - m2014_q6b
(+0.088) is the only problem with a healthy 6-cell archive; QD's pass
rate also BEATS classic exactly where classic collapses (m2014_q6b
24% vs 3%, fsmonehot 21% vs 2%, fsm 12% vs 0%), i.e. thought-mode
ideation is genuinely stronger on under-determined problems and
weaker on spec-exact transcription problems.

Screened repair agenda (one factor per screen, fast subset):
R-A' spec-first realization prompt-profile variant; R-B failure
feedback in fail-parent thought payloads; R-C collapsed-axis warmup
fallback; R-D k=2 (already running on OpenRouter).

## 2026-06-12 13:40 KST — R-B implemented and queued

- feat(qd) ecb7615f5c: --qd_operator_fail_feedback_chars (default 0 =
  frozen-target behavior unchanged) adds failure_stage + truncated
  failure_feedback to failed parent payloads in the single-thought
  operator; new journal_thought_only_failfb prompt profile permits the
  feedback and directs re-derivation of interfaces/indexing/value
  tables from the spec. Tests: opt-in truncation + negative-budget
  rejection + existing exclusion tests green (11 passed); ruff clean;
  pyright debt limited to 2 pre-existing scipy-stub errors.
- R-B screen launcher generated from the locked v3 subset
  (exp/fail_feedback_rb_launch.sh, OpenRouter both arms) and QUEUED
  behind the running k2 pair via exp/queue_after_k2.sh (waits for the
  k2 launcher process to exit, warns if 'all done' is missing).
- Remaining screened candidates: R-A' spec-first realization template,
  R-C collapsed-axis warmup fallback (engine; doubles as the P2 fix
  for trio degeneracy on small designs).

## 2026-06-12 13:55 KST — R-C implemented; screen chain three deep

- feat(qd) eae4a2bbd8 (amended subject): GridQuantileArchive gains
  warmup_max_buffer (default 0 = frozen behavior). When the warmup
  buffer hits the cap without viable quantile geometry, the collapsed
  space initializes in-run (mode warmup_patience_fallback) so cell
  elites, operator archive context, and ks-rebinning can operate -
  directly fixes the 4/11 hard-subset problems that buffered all run.
  Full tests/revolution suite green (472 passed, 4 skipped).
- R-C screen launcher generated (exp/warmup_patience_rc_launch.sh,
  frozen target + --qd_grid_quantile_warmup_max_buffer 16) and queued
  behind R-B on a completion-marker watcher (exp/queue_after_rb.sh
  greps for 'all done' in exp/fail_feedback_rb.log; process-based
  wait would fire early since R-B has not started).
- k2 pair status: classic arm 5/6 problems done in ~9 min;
  Prob011_multi_16bit hung at gen 1 in an OpenRouter request since
  12:23 (client envelope: 600 s request timeout, 15 retries with
  backoff - recoverable). Decision recorded: do not kill; if still
  stalled next check, either accept a 5-problem classic arm (drop the
  problem pairwise) or relaunch. OpenRouter wall times invalidate the
  local-vLLM G1a calibration; screens are judged on quality-delta
  bands, and any runtime gating on API-side runs needs an OpenRouter
  re-baseline first (instrument caveat).

## 2026-06-12 14:10 KST — stall root-caused; chain four deep

- k2 classic-arm stall root cause: AsyncOpenAI retries internally
  (default 2) before our 15-attempt loop sees the exception, so one
  hung OpenRouter provider blocks 3x the 600 s request timeout per
  loop attempt with zero retry evidence in the launch log; three
  sockets sat ESTAB for 38+ min. fix(llm) c12eb80369 pins client
  max_retries=0 (we own retry/backoff; fast failure lets OpenRouter
  re-route to a healthy provider).
- Pre-registered fallback executed: killed the stuck classic arm at
  12:57 (rc=143; pattern 'save_path ...clas[s]ic' to avoid pkill
  self-match). Five classic problems were already complete; the k2
  screen therefore pairs 5/6 problems (Prob011_multi_16bit unpaired,
  excluded by paired stats; recorded as a screen caveat). The variant
  arm relaunched at 12:57:38 as a fresh process under the fixed
  client. Later screens run fresh classic arms and are unaffected.
- R-A' implemented: journal_thought_only_specfirst profile - the
  realization template now instructs spec-first re-derivation of
  interfaces, indexing, tables, and equations, treating thought_spec
  transcriptions as an untrusted paraphrase; thought template
  untouched (one factor). Launcher exp/specfirst_ra_launch.sh queued
  behind R-C on its completion marker (exp/queue_after_rc.sh).
- Screen chain: k2 variant (RUNNING) -> R-B fail feedback -> R-C
  warmup patience -> R-A' spec-first; each one-factor vs the frozen
  target, all OpenRouter, seeds 42, locked v3 subset.

## 2026-06-12 14:30 KST — P4 builder exclusions; visualizer risk-b check

- feat(cvdp) 87a1914d79 (amended): build_cvdp_debug_subset gains a
  repeatable --exclude-config flag loading ids from locked manifests,
  filtering before the seeded shuffle, and recording exclusion
  provenance - the predeclared mechanism for the fresh 30-task final
  slice (seed 1337, debug ids excluded). 6 tests green.
- Visualizer risk item b checked at code level: 3-axis profiles render
  profile-agnostically (preferred order only for the journal trio,
  natural-order fallback otherwise, honest 2d downgrade on degenerate
  axes). Gap: 2-axis profiles skip with a recorded reason - rendering
  must be extended before the 2-axis control arm ships in the P2
  bake-off. TODO updated accordingly.
- k2 variant arm healthy under the retry fix (continuous file output
  since 12:57; no stalls).

## 2026-06-12 14:50 KST — P2 profiles pre-registered

- doc 11_descriptor_profile_preregistration.md registers the four
  bake-off profiles before any bake-off run: the initial trio,
  journal_graph_testability_3d (rtl_cyclomatic_total_log,
  reconv_sink_ratio, scoap_signal_smoothness - NEW),
  activity_control_3d (existing), journal_simple_2d
  (wire_count_log_est, assign_count - NEW 2-axis control). New
  entries added additively to data/configs/qd_descriptor_profiles.yaml
  and validated through load_descriptor_profiles +
  _validate_descriptor_axes.
- Predeclared one extra bake-off measurement (warmup-completion rate
  and per-axis collapse counts), motivated by the P1 finding that the
  trio cannot form quantile boundaries on small designs. Selection
  still happens only by the narrative's frozen rule.
- k2 variant arm: 4/6 problems done; sub_64bit and multi_16bit at
  gen 1 and progressing (no stalls under the retry fix).

## 2026-06-12 15:15 KST — k2 screen verdict: DEMOTE (degraded screen)

- The OpenRouter stall recurred on the k2 VARIANT arm (10 ESTAB
  connections, 36 min, zero timeout warnings). Root cause deeper than
  SDK retries: OpenRouter keep-alive bytes defeat httpx read timeouts
  on non-streaming requests, so the 600 s SDK timeout never fires on
  a glacial provider. fix(llm) 4a9e6d9355 wraps all three completion
  call sites in asyncio.wait_for(request_timeout_seconds) with
  TimeoutError added to the retry-caught set; also fixed a
  pre-existing leak where six tests stubbed global asyncio.sleep via
  raw pytest.MonkeyPatch() (never undone), exposed by the new
  deadline test. Suite green (474 passed).
- Variant arm killed per the same pre-registered fallback (rc=143 at
  14:01:56); launcher completed stats + both ledger appends.
- k2 verdict on the DEGRADED screen (4 paired; sub_64bit imputed as
  loss; multi_16bit unpaired - both heavies lost to stalls, an honest
  limitation): penalized mean best-quality delta -0.141, paired-only
  -0.063, 1W/2L/2T; popcount255 -0.262 dominates. Against the k=4
  baselines (-0.086/-0.188) there is no credible improvement signal:
  DEMOTE k=2 as a standalone repair. The ideation-diversity
  hypothesis alone does not close the gap.
- R-B screen (failure feedback) auto-started behind k2 with both the
  retry fix and the hard deadline in effect.

## 2026-06-12 15:40 KST — budget parity measured: CONFOUNDED toward QD

- scripts/report_budget_parity.py (+3 tests) reads both arms'
  per-problem summary accounting and emits per-problem + aggregate
  variant/classic ratios with a +/-10% parity verdict.
- Hard-subset-42 pair: api_calls ratio 1.125, completion_tokens 1.253,
  prompt_tokens 0.703 -> CONFOUNDED
  (exp/fast_iter/hard_subset_42/budget_parity). At equal pop x gens
  the QD target consumed ~25% more completion tokens than classic and
  still lost: the P1 deficit holds a fortiori under compute
  accounting, but the asymmetry must be disclosed, every promoted-fix
  hard-subset pair must ship this artifact, and the finals freeze
  must pick a budget-matching rule (e.g. token-budget-equalized
  stopping) if any positive QD claim is to survive review.
- R-B screen progressing fast under the deadline fix (classic arm
  4/6 done in 12 min; sub_64bit completed where it previously hung).

## 2026-06-12 16:00 KST — deadline v2 (abandon semantics); R-B relaunched clean

- The R-B classic arm stalled AGAIN with the asyncio.wait_for deadline
  active and zero timeout lines: wait_for awaits the cancelled task,
  and anyio/httpx cleanup can hang forever on a dead-but-open socket -
  the timer fired but the await never returned. fix(llm) 397bb0d6fe
  replaces it with asyncio.wait + cancel WITHOUT awaiting: raise
  TimeoutError immediately, abandon the orphan (it dies when the
  client closes). Test simulates a task that swallows its first
  cancel; suite green (38 passed).
- Operational incident (pkill discipline rule extended): a compound
  command that killed the old R-B tree AND relaunched it self-matched
  - pkill saw the relaunch text 'fail_feedback_rb_launch.sh' in the
  same command line and killed the shell mid-sequence (exit 144),
  leaving the original stalled processes orphaned and the launcher
  dead (which would have silently broken the R-C/R-A' chain). RULE:
  kill commands run SOLO - never in a compound that mentions the
  target name verbatim.
- Recovery: orphans killed (solo bracket-pattern pkill), partial
  artifacts wiped, R-B relaunched fresh at 14:47:01 into the same log
  so the queue_after_rb.sh watcher still chains R-C -> R-A'. All
  screen arms from here run with abandon-deadline semantics.

## 2026-06-12 16:20 KST — 2-axis visualizer rendering landed

- feat(qd) 6eaed4f274: 2-axis descriptor spaces render through the
  existing 3-axis pipeline via a virtual single-bin '(flat)' slice
  axis (axis_indices None entry maps to bin 0); collapsed second
  axis still skips honestly; 3-axis layouts byte-identical. 49 tests
  green including the end-to-end engine visualization test. The
  pre-registered journal_simple_2d control arm is unblocked.
- R-B screen (clean relaunch) healthy at 13 min: pe and mux256to1v
  done; multi_16bit and sub_64bit at gen 0 - the abandon-deadline's
  first real-world test rides on these two.

## 2026-06-12 16:50 KST — root cause of the recurring stalls: 128k ceiling

- py-spy stack dumps + per-problem log inspection resolved the
  recurring gen-1 stall: with --max_tokens 128000 NO OpenRouter
  provider finishes the heavy problems' requests (multi_16bit,
  sub_64bit - big parent-code prompts) inside the 600 s deadline, so
  the retry loop ground on invisibly: worker stdout is BLOCK-BUFFERED
  when redirected to problem_run.log, hiding every retry line. The
  same problems completed fine on local vLLM (multi_16bit 1463 s);
  observed real completions average 2-4k tokens.
- fix(llm) 5922e6bbc7 (amended): generated launchers now pin a 32k
  completion ceiling on OpenRouter (128k retained for local vLLM per
  the research-setting rule), export PYTHONUNBUFFERED=1, and the
  retry print flushes. Recorded as a provider-forced instrument
  deviation; gate-bearing comparisons keep both arms at the same
  provider and budget.
- All three queued launchers regenerated in place (watcher chain
  paths unchanged); stalled R-B killed (solo pkill), artifacts wiped,
  relaunched clean under the 32k cap.

## 2026-06-12 17:10 KST — 32k cap validated operationally; effect measured

- R-B classic arm under the 32k cap: ALL 6/6 problems completed in
  14 minutes, rc=0, ZERO retry lines - including multi_16bit and
  sub_64bit which never finished on OpenRouter at 128k across three
  prior arms. The cap is operationally confirmed as the stall fix.
- Cap-effect measurement (classic@32k vs k2's classic@128k, same
  seed/config, single-seed run-to-run comparison so provider variance
  is entangled): mean best-quality delta -0.035 over 5 comparable
  problems, dominated by sub_64bit -0.153; mux256to1v and rotate100
  identical; pe -0.005; popcount255 -0.019. Instrument consequence:
  WITHIN-pair deltas remain valid (both arms share provider and cap);
  cross-era comparisons to local-vLLM 128k baselines (k=4 -0.086 /
  -0.188) carry this caveat. Screen PROMOTE/DEMOTE bands judge the
  pair-internal delta and stay sound.
- R-B variant arm started 15:33:34 under the cap.

## 2026-06-12 17:30 KST — screen-coverage gap found; failure-regime subset locked

- Live mechanism probe on the R-B variant arm: parent sources were
  seed 19 / archive 52 / fail_pool 0 across six problems - the v3
  fast subset (selected for min functionality 0.6) keeps the fail
  pool empty, so FAILURE-PATH candidates never fire there. The
  imminent R-B fast-screen verdict is therefore COVERAGE-LIMITED:
  a null delta cannot refute the hypothesis (the arms differ only in
  dormant machinery). Instrument limitation recorded: the v3 subset
  screens always-on mechanisms (operators, archive, realization
  prompts); failure-path mechanisms need the failure regime.
- Locked data/configs/failure_regime_screen_subset.yaml (v1): the
  five VerilogEval hard-subset problems with QD pass rates 3-26%
  from the diagnosis (m2014_q3, review2015_fsm, alu, fsmonehot,
  circuit7), pop 12 x 3 gens, 32k cap, primary readouts include
  per-arm pass rates and fail_pool parent counts.
- exp/rb_failure_regime_launch.sh generated and QUEUED at the chain
  tail (exp/queue_after_ra.sh watches the R-A' completion marker).
  Chain: R-B fast (variant finishing) -> R-C -> R-A' -> R-B
  failure-regime.

## 2026-06-12 17:55 KST — R-B fast verdict; chain rolling clean

- R-B fast screen complete - the FIRST clean 6/6-paired screen (both
  arms rc=0, no imputed losses, ledgered). Verdict: mean best-quality
  delta -0.177, 0W/4L/2T -> DEMOTE on this subset, WITH the
  pre-recorded coverage caveat: fail_pool was empty (mechanism
  dormant), so this measures the frozen QD target with inert R-B
  machinery. Properly read, it is a REPLICATION of the baseline QD
  deficit under the new regime (OpenRouter + 32k): -0.177 sits in
  the band of the local-vLLM 128k baselines (-0.086 / -0.188),
  i.e. the gap transfers across provider and budget - useful
  instrument evidence. R-B's decisive test remains the queued
  failure-regime screen where the fail pool populates.
- Chain self-driving: R-C auto-started 15:57:33; its classic arm
  completed rc=0 in 8 minutes; variant running. Remaining: R-C ->
  R-A' -> R-B failure-regime.

## 2026-06-12 18:20 KST — R-C cap corrected pre-verdict; trio degeneracy widens

- Coverage pre-check before the R-C verdict (same discipline that
  caught the R-B gap): the R-B variant archives (identical frozen
  target) show the fast subset accumulates only 11-12 archive
  observations at pop 12 x 3, so the queued R-C patience cap of 16
  was UNREACHABLE - a guaranteed-null screen. The cap was scaled for
  the 20x5 hard subset (~30 observations). R-C killed mid-variant
  (solo pkills), launcher regenerated with warmup_max_buffer=10
  (>= warmup_successes 8, < 12 observations, leaving 1-2 archive-
  enabled generations), artifacts wiped, relaunched clean at
  16:16:55. Chain intact.
- MAJOR P2 finding from the same archives: the journal trio is
  degenerate on 4/6 fast-subset problems TOO (pe, mux256to1v,
  popcount255, rotate100: all three axes collapsed, every observation
  warmup_buffered) - and these are mid-size 150-3000-gate PPA-margin
  designs, not the small spec-exact problems from the hard-subset
  diagnosis. Even the two problems that initialized carry one
  collapsed axis each (multi_16bit: logic_depth; sub_64bit:
  ff_depth) with 2-4 occupied cells. The trio's degeneracy is the
  dominant archive pathology across BOTH subsets; the bake-off's
  warmup-completion readout is now the headline criterion, and the
  graph/testability + activity + 2-axis profiles must be judged
  primarily on it.

## 2026-06-12 18:45 KST — R-C cap 10 -> 8 (exposure arithmetic)

- Observation-flow arithmetic from live archives: at pop 12 x k 4 only
  ~3 valid thought-representatives reach the archive per generation
  (~11-12 over the whole fast run), so cap 10 fires around gen 2-3
  and the fallback is live for barely the final generation. Cap 8
  (= warmup_successes, the earliest legal firing point) roughly
  doubles the live window. R-C killed/relaunched once more BEFORE any
  verdict (exposure engineering; the PROMOTE/DEMOTE rule is
  untouched). Honest limitation recorded: even at cap 8 the fast
  budget yields only ~1-2 archive-enabled generations - if the
  verdict is INCONCLUSIVE, R-C's real trial is the hard-subset 20x5
  promotion pair (~30 observations, cap 16).

## 2026-06-12 18:30 KST — R-C verdict: DEMOTE (mechanism live, no rescue)

- Proof of firing: 4/6 variant problems initialized via
  warmup_patience_fallback (multi_16bit 3 cells, pe 1, popcount255 2,
  rotate100 1); sub_64bit and mux256to1v initialized normally this
  run (16 and 4 cells - collapse is sampling-dependent at this
  budget). The engine feature works in production.
- Quality: mean best-quality delta -0.165, 1W/5L -> DEMOTE as a
  standalone repair. With the fallback demonstrably live, a 1-3-cell
  archive operating for the final generation(s) provides no usable
  diversity pressure. This strengthens the P2 conclusion: when the
  trio is degenerate, no warmup policy rescues the archive - the
  axes themselves are the problem. The patience flag stays default-
  off in the target; it remains valuable as liveness/metrics hygiene
  and for late-variance problems, and appropriate at hard-subset
  scale (cap 16) where observation flow is real.
- Screen ledger so far: k=2 DEMOTE, R-B fast = baseline replication
  (coverage-limited), R-C DEMOTE. Remaining: R-A' (always-on,
  running since 17:13:08) and R-B failure-regime (queued). If
  neither PROMOTEs, P1 proceeds per the predeclared Branch C
  narrowing with its content floor, and the load-bearing fix moves
  to the P2 bake-off (trio degeneracy), which is fully tooled.

## 2026-06-12 18:50 KST — ablation-matrix readiness audit; arm-2 gap

- Audited the predeclared 5-arm matrix (narrative §ablation) for
  runnability: arm 1 classic, arm 3 full-QD-with-six-operators
  (--qd_operator_kind eoh_strategies), arm 4 scalar elites
  (--qd_cell_mode scalar_elite), and arm 5 the frozen target are all
  launchable today. ARM 2 (classic + unified operator, the Branch C
  floor leg i) has NO engine support: single_thought_operator exists
  only on the QD path; classic EoHEngine cannot bypass the
  six-strategy suite.
- Arm-2 design spec (one factor: replace the six strategy prompts
  with the unified operator; nothing else changes): hoist
  _format_parent_for_single_thought_operator and the archive-free
  core of _create_prompt_single_thought_operator from QDEngine into
  EoHEngine (QDEngine keeps archive-context injection on top); add
  classic_operator_kind config/CLI ('eoh_strategies' default |
  'single_thought_operator'); in the classic offspring path, when
  unified: skip UCB-softmax strategy selection, draw parents from
  the existing success/fail pools with arity 1 or 2 at the target's
  one_parent_fraction 0.5 (mirroring the QD target operator policy),
  label strategy 'single_thought_operator' in logs. Charged
  evaluations unchanged. Regression tests: unified-classic bypasses
  strategy selection; prompt contains no parent code/feedback;
  default path byte-identical.
- R-A' variant arm started 17:31:28 (classic rc=0 in 18 min).

## 2026-06-12 19:20 KST — arm 2 landed; R-A' verdict; final screen running

- feat(classic) 25c0beb898: classic_operator_kind implements ablation
  arm 2 (classic + unified operator) per the recorded spec - pool
  allocation and weighted parent draw unchanged, UCB-softmax and the
  six strategy prompts bypassed, one whole-mode unified prompt per
  offspring, no bandit attribution, default path byte-identical.
  Full suite green (483 passed). ALL FIVE predeclared ablation arms
  are now runnable.
- R-A' fast verdict: mean best-quality delta -0.126, 0W/4L/2T ->
  DEMOTE as a standalone fast-subset repair (slightly above the
  -0.177 baseline replication, within single-seed noise). Coverage
  note: the high-pass-rate subset leaves little transcription
  failure for spec-first realization to fix; if the failure-regime
  R-B shows pass-rate recovery, an R-A' failure-regime screen is the
  natural follow-up (launcher generator + locked subset ready).
- R-B failure-regime screen auto-started 17:59:16 (the last queued
  screen; the one whose mechanism coverage is guaranteed).

## 2026-06-12 19:40 KST — failure-regime R-B: mechanism live-verified

- Mid-run probe of the failure-regime variant arm: parent sources
  seed 12 / fail_pool 8 / archive 7, and ALL 8 fail_pool thought
  prompts carry the failure_feedback payload - the R-B machinery
  fires on this subset exactly as designed (vs 0 fail_pool draws on
  the fast subset). Whatever the verdict, the screen is informative.
- Classic baseline on the regime (recorded pre-verdict): m2014_q3
  best 0.347 (classic cruises), circuit7 0.012, fsmonehot 0.001,
  fsm -0.279 (classic struggles where QD pass rates led in the
  diagnosis).

## 2026-06-12 20:10 KST — R-B payload bug found live; degraded screen near parity

- Live-probe correction: my earlier 'mechanism live-verified' note
  matched the TEMPLATE text, not the payload. Re-checking for the
  JSON key showed ZERO of twenty fail_pool prompts carried
  failure_feedback: _build_all_fail_parent hardcoded feedback="" on
  thought-level wrappers, so parent.feedback was always empty even
  though per-sample analyses existed on disk. fix(qd) e77f9c5c8f
  propagates the first non-empty sample feedback onto the wrapper
  (+regression test; a stale test asserting the old thought-purity
  behavior updated deliberately; 484 passed).
- The DEGRADED screen (failure_stage + spec-re-derivation
  instruction, no feedback evidence) still scored mean -0.0022,
  1W/1L/2T on 4 problems - near PARITY with classic on the failure
  regime, against -0.13..-0.18 fast-subset deficits. Pass rates:
  m2014_q3 3%->8%, fsmonehot 21%->29%. The regime itself plus half
  the mechanism removes most of the gap; the full-mechanism test
  (rb_failure_regime_v2: fixed engine, v2 subset with alu restored,
  fresh classic arm) launched.

## 2026-06-12 21:45 KST — SCREEN PHASE CLOSED; ablation matrix launched

- rb_failure_regime_v2 (full mechanism, payload live-verified, alu
  restored): pass rates moved exactly as the mechanism predicts -
  m2014_q3 3%->15% (5x, converting the catastrophic loss into an
  exact best-quality TIE), circuit7 26%->62%, fsmonehot 21%->40%,
  fsm 12%->17%, alu regressed 15%->2% (its sampled feedback was
  PPA-flavored - misdirection case for the dossier). Quality verdict:
  mean -0.086, 0W/2L/2T (circuit7 -0.320 dominates; alu unpaired) ->
  DEMOTE by the predeclared bands. Conclusion: failure feedback
  repairs candidate VALIDITY, not peak quality - the quality ceiling
  is set by archive/selection behavior on valid candidates, which is
  the P2 axis problem.
- Screen ledger FINAL: k=2 DEMOTE, R-C DEMOTE (fired), R-A' DEMOTE,
  R-B fast = replication, R-B failure-regime DEMOTE (fired, with
  regime-scoped positives). P1 proceeds per predeclared Branch C
  with the strongest root-cause dossier of the project.
- The predeclared 5-arm ablation matrix LAUNCHED (exp/ablation_matrix,
  15 runs, seeds 1001-1003, hard subset 20x5, 32k cap, parity
  artifact per contrast). Classic seed-1001 arm started.

## 2026-06-12 22:10 KST — P2 bake-off staged behind the matrix

- Three bake-off pair launchers generated from the locked v3 subset
  (graph_testability, activity, simple_2d - the trio's pair is the
  existing R-B-fast baseline replication) and QUEUED behind the
  ablation matrix (exp/queue_bakeoff_after_matrix.sh waits for the
  'matrix all done' marker, then runs the three pairs sequentially).
- feat(reporting): report_descriptor_bakeoff.py applies the frozen
  rule mechanically (delta -> occupancy tie-break -> 0.25 floor) and
  surfaces warmup-completion + collapse counts as the pre-registered
  headline evidence. The freeze decision will cite the generated
  table.
- Ablation matrix healthy: classic seed-1001 on all 13 hard-subset
  problems since 20:40:49.

## 2026-06-12 22:40 KST — P4 fresh slice locked; disjointness verified

- data/configs/cvdp_final_30_subset.yaml locked: seed 1337, 6 medium
  tasks per category across the 5 categories (per-category 5 yields
  only 25 - recorded), debug ids excluded with provenance, dataset
  sha256 embedded. Disjoint from the debug slice (verified empty
  intersection).
- Holdout disjointness audit: the 20-problem held-out reference
  subset intersects NEITHER the 13-problem hard subset NOR the
  6-problem fast v3 subset (both intersections empty) - the holdout
  remains valid for final gates despite being locked before v3
  existed.
- Ablation matrix: classic seed-1001 ~70% done (65 generation-log
  lines over 13 problems, zero retries, 4127 files in 5 min).

## 2026-06-12 23:35 KST — first matrix contrast: unification not free

- classic_unified vs classic, seed 1001 (13/13 paired, no
  imputations): mean best-quality delta -0.090, 1W/9L/3T. Parity:
  api_calls ratio 0.999 (excellent), completion tokens 1.201 (+20%,
  unified emits longer outputs) - the loss direction is a-fortiori
  valid under the extra tokens. Reading for Branch C floor leg (i):
  the parity-or-better claim FAILS on this seed - removing the
  six-strategy suite costs ~0.09 on the classic substrate; the
  one-factor attribution itself (the floor's real content) is now
  measured. Seeds 1002-1003 confirm.
- Regime pattern repeats a third time: unified ties/wins exactly on
  the spec-exact VerilogEval problems (m2014_q3, m2014_q6b,
  fsmonehot ties; fsm +0.096) and loses on the RTLLM PPA-margin
  problems (circuit7 -0.320, alu -0.294, adder -0.190). Thought-style
  prompting is regime-sensitive, not uniformly weaker - manuscript
  framing for both the operator section and the Branch C claims.
- qd_six_operators seed 1001 (the operator-claim licensing contrast)
  started 22:29:03; classic_unified arm completed in 51 min.

## 2026-06-12 23:55 KST — ltp cross-validation closed with run data

- Audited the rb_failure_regime_v2 artifacts for the online yosys
  ltp cross-check: logic_depth_ltp_delta persisted on 32 candidates
  with 31x delta=0.0 (exact agreement with yosys's independent
  longest-topological-path) and 1x delta=1.0 (the documented
  buffer-skip liberty). The P2 cross-validation item is closed on
  production evidence rather than a synthetic probe. Manuscript
  measurement-model section gains this as the logic_depth
  external-validation citation (evidence map updated implicitly via
  this entry).
- Matrix: qd_six_operators seed-1001 mid-run (zero retries).

## 2026-06-13 00:55 KST — verilator golden sweep launched in parallel

- Realization: the 60-task golden re-sweep is CPU-only while the
  ablation matrix is OpenRouter-latency-bound, so they can overlap
  with negligible interference (sweep runs nice -15, single job;
  matrix runtimes are not gate-bearing and the budget axis is
  candidate evaluations). Launched
  build_realbench_manifest --validate --verilator-fallback into a
  NEW root (data/bench/RealBench_v2_sweep) - the locked v1 manifest
  at data/bench/RealBench stays untouched until subsets are
  re-locked from the reviewed v2.
- Baseline for comparison: v1 manifest validates 38/60 tasks under
  iverilog. The fallback should recover a meaningful share of the
  22 exclusions (dialect/assertion mismatches), each marked
  functional_harness_kind=verilator_testbench for runtime dispatch.
- Matrix: qd_six_operators seed-1001 at gen 2-3 on stragglers
  (~2 h arm; the six-operator QD arm is the most expensive), zero
  retries.

## 2026-06-13 01:30 KST — sweep verdict: 17/22 recovered; fresh-26 locked

- Golden sweep (overlapped with the matrix, niced): 55/60 validated -
  38 iverilog (identical to v1, environment consistent) + 17
  verilator rescues (marked verilator_testbench for runtime
  dispatch); 5 goldens compile-broken in both harnesses
  (e203_extend_csr, e203_exu_alu_muldiv, e203_srams,
  sd_fifo_rx/tx_filler). Coverage 63% -> 92%. v2 manifest at
  data/bench/RealBench_v2_sweep (sha 6b5bb5cb...); locked v1 runtime
  root untouched pending the retention-table EDA-persona re-review.
- RealBench builder gains --exclude-config (CVDP-pattern);
  data/configs/realbench_final_26_subset.yaml locked from v2
  (seed 1337, debug excluded, disjoint, all families).
- Matrix: qd_six_operators seed-1001 still running (~2h arm).

## 2026-06-13 01:50 KST — qd_six_operators vs classic measured

- qd_six_operators vs classic, seed 1001 (13/13 paired): mean
  -0.118, 2W/10L/1T; parity GOOD on the cost axes that matter
  (calls 1.06, completion 0.955). Per-benchmark: RTLLM -0.129,
  VerilogEval -0.105 - thought-mode-with-six-prompts loses on both
  regimes, unlike the unified operator's regime split.
- NOTE for the operator headline: the narrative's licensing contrast
  is WITHIN QD (six-operator suite vs unified operator, both on the
  QD substrate) = qd_six_operators vs qd_target pairing per seed,
  NOT vs classic. The matrix launcher only emits vs-classic stats;
  when qd_target seed-1001 lands, run the extra pairing manually:
  report_journal_statistics --pair
  "1001=ROOT/qd_six_operators/seed_1001/revolution=ROOT/qd_target/seed_1001/revolution"
  (and equivalents for seeds 1002-1003), plus budget parity.
- qd_scalar_elites seed-1001 started 00:24:22; six-op arm took 115
  min (the matrix's most expensive, as expected).

## 2026-06-13 02:15 KST — narrative retention update + EDA re-review

- RealBench disclosure rewritten per the predeclared pre-freeze
  update path: dual-harness capability-model description (strict
  iverilog primary; verilator 5.030 dispatch per manifest entry,
  matching upstream's Verilator-5 target), v2 retention 55/60
  (aes 6/6, sdc 12/14, e203 37/40; 38+17 split), 5 exclusions with
  recorded reasons, same-recorded-harness-both-arms rule. v1 text in
  git history.
- Focused EDA-persona re-review of the section, findings recorded:
  ACCEPT with one REQUIRED addition (applied): verilator two-state
  semantics can under-detect X-propagation mismatches vs four-state
  iverilog, and the 17 rescued tasks lack an iverilog cross-check by
  construction - pass claims there are scoped to two-state semantics
  and the retention table marks harness per task. Reviewed and
  retained: per-task harness fixed across arms (no within-pair
  asymmetry), difficulty-proxy comparison, subset labeling rule.
- Remaining before v2 promotion to the runtime root: re-lock the
  12-task debug subset and the long-model probe from the v2 pool
  (pool changed 38->55, so the seeded selections change - do this
  deliberately next wake, diffing old vs new slices).

## 2026-06-13 02:40 KST — harness simplification: verilator-first probe

- Decision discussion (user): the dual-harness design is
  path-dependent complexity - iverilog-primary existed only because
  the environment shipped verilator 4.038 at integration time; with
  5.030 in place, verilator-only matches the upstream RealBench flow
  exactly, removes the per-task dispatch state, and unifies the
  two-state caveat. Agreed contingent on two measurements: (1)
  verilator-first coverage of ALL 60 goldens (the fallback sweep only
  tried verilator on the 22 iverilog failures), (2) per-task timing
  (per-candidate verilation is ~10x iverilog on mid-size modules -
  the finals budget multiplier must be known, and a too-slow tail
  becomes a predeclared evaluable-within-budget retention rule, not
  a reason to keep two engines).
- feat: --primary-harness verilator sweep mode with
  harness_duration_s recorded in every path; v3 sweep launched niced
  into data/bench/RealBench_v3_verilator (locked roots untouched).
- Matrix: qd_scalar_elites seed-1001 finishing.

## 2026-06-13 03:00 KST — HARNESS FLIP EXECUTED: RealBench is verilator-only

- v3 verilator-primary sweep results settled both gates decisively:
  coverage 55/60 IDENTICAL to dual-harness (validated pools equal as
  sets; the 5 exclusions are the same tasks, one now failing as
  golden-mismatch 2182 rather than compile), and timing demolished
  the 10x fear - median 2.2 s, p90 11.1 s, max 23.9 s per golden;
  fresh-26 sums to 90 s. Per-candidate verilation is
  iverilog-comparable at module scale.
- Flip executed: v3 manifest promoted to the runtime root
  (data/bench/RealBench, sha 1e920b58...; v1 root preserved as
  RealBench_v1_iverilog); fresh-26 re-anchored to v3 (identical 26
  names verified) as v2 of its lock; debug-12 names CARRIED FORWARD
  with recorded rationale (a re-draw over the 55-task pool keeps
  only 3/12 and collides with the locked fresh-26 - disjointness
  preserved by carrying forward; all 12 remain validated under v3).
- Narrative disclosure simplified to the single-harness text: one
  simulator family (upstream's), uniform two-state caveat, per-task
  durations recorded. The dual-harness dispatch machinery remains in
  the codebase (harmless, tested) but no manifest entry exercises
  the iverilog path for RealBench anymore.

## 2026-06-13 03:20 KST — post-flip verification and cleanup

- Both locked RealBench slices resolve fully against the promoted
  verilator-only root (debug-12 and fresh-26: every task
  harness-validated). Superseded v2_sweep root removed (12 MB; its
  sha and findings live in the history); v1_iverilog root retained
  as the archived pre-flip state.
- Matrix: qd_scalar_elites seed-1001 at gen 4-5 stragglers, zero
  retries; bake-off watcher confirmed alive.

## 2026-06-13 08:00 KST — OPERATOR LICENSING: unification helps WITHIN QD

- Within-QD licensing pairing (the narrative's actual operator
  contrast), seed 1001: qd_target (unified operator) vs
  qd_six_operators, both on the QD substrate. Delta (target - six)
  = +0.040, 5W/3L/5T, cluster-bootstrap 95% CI [+0.0007, +0.090] -
  ENTIRELY ABOVE 0. By the predeclared rule (CI low > 0 = "better"),
  the unified operator is statistically better than the six-operator
  suite within QD on this seed. Empirically direction-verified
  (multi_pipe_8bit six=0.243 target=0.512). The operator-unification
  headline is LICENSED within QD (pending seeds 1002-1003 for the
  pooled decision; qd_target_seed1002 not yet run).
- Substrate-dependence is the mechanistic story: the SAME unified
  operator is WORSE than six operators on the CLASSIC substrate
  (classic_unified vs classic: -0.090 seed1001 / -0.102 seed1002,
  both CIs below 0) but BETTER than six operators within QD. Reading:
  the six hand-engineered operators manufacture the exploration that
  the archive supplies for free in QD; remove the archive and you
  need them back. Coherent one-factor attribution - exactly what the
  matrix was built to produce.
- All QD/unified arms vs classic, both seeds (best-quality, loses):
  classic_unified -0.090/-0.102, qd_six_operators -0.118/-0.130,
  qd_scalar_elites -0.128 (call ratio 1.39 - most confounded),
  qd_target -0.078 (best QD arm, 3W, +38% calls). Branch C holds
  across seeds: the package does not beat classic at this budget.
- Scalar-vs-pareto cells: qd_scalar_elites -0.128 vs qd_target
  -0.078 (both vs classic, seed 1001) -> pareto cells contribute
  ~+0.05 within the package, a positive component attribution for
  the Pareto-front design.

## 2026-06-13 08:20 KST — bake-off verdict tool real-data-validated

- report_descriptor_bakeoff.py smoke-run against a real trio-profile
  archive set (rb_failure_regime_v2 variant): correctly extracts
  warmup-completion 40%, median occupancy 0.12, per-axis collapse
  counts (logic_depth 1, ff_depth 2, comb_width_log 1), and fires the
  occupancy-floor FAIL flag (0.12 < 0.25). The P2 verdict is now a
  single validated command when the three bake-off pairs land - no
  artifact-shape surprises.
- Foreshadowing: the trio FAILS the 0.25 occupancy floor on this
  subset, consistent with M5/F6 (trio degeneracy). The formal bake-off
  uses the v3 fast subset, but the direction is clear - the
  alternative profiles need only clear the floor the trio cannot.
- Matrix: qd_scalar_elites seed-1002 near complete (zero retries);
  qd_target seed-1002 not yet started, so the seed-1002 licensing
  replication (F2) is ~2 arms out.

## 2026-06-13 08:40 KST — debug-pair readiness probe (zero LLM)

- Confirmed both end-to-end debug slices build through their adapters
  without any LLM call: CVDP-10 (3/3 sampled contexts build from the
  locked dataset) and RealBench-12 (4/4 sampled specs build). Key
  check: every sampled RealBench debug task resolves
  functional_harness_kind=verilator_testbench, so the carried-forward
  debug-12 runs under the single clean harness post-flip - the
  iverilog path is not exercised. Task #14 is de-risked at task-load;
  only the runtime question (does a run produce a passing candidate)
  remains and needs an OpenRouter slot after the matrix+bake-off.
- Matrix: qd_scalar_elites seed-1002 finishing (gshare straggler,
  zero retries); qd_target seed-1002 next, then the seed-1002
  licensing replication of F2.

## 2026-06-13 09:15 KST — licensing-helper completion bug caught + fixed

- The licensing helper (added last wake) gated on DIRECTORY existence,
  which a just-started arm satisfies. It fired the seed-1002 pairing
  against a 0/13-complete qd_target, producing a garbage paired_count=0
  delta -0.327 - which, uncaught, would have read as F2 FAILING to
  replicate with an inverted sign. Caught immediately by checking
  paired_count, not the 'done' message (M6 discipline).
- Fix: completion now requires each root to have the full hard-subset
  count (13) of per-problem '{Prob}_summary.json' files. Subtlety
  recorded: the per-problem completion summary is filename
  Prob*_summary.json; a PATH-glob also matches QD artifacts like
  global_pareto_summary.json (10 false positives) - the helper uses
  -name (filename) match. Premature seed-1002 output discarded.
- Seed-1001 licensing (F2) intact and unaffected: paired=13,
  +0.040, 5/3/5, CI [+0.0007, +0.090]. qd_target seed-1002 in
  progress (0/13); F2 replication still pending its completion.

## 2026-06-13 09:35 KST — F7: deficit localization (seed-1001 cross-arm)

- Per-problem best-quality delta vs classic across all 4 seed-1001
  arms. The aggregate -0.08..-0.13 decomposes into a localized
  structure: 3/13 problems carry 58% of the negative mass
  (circuit7 -0.320, alu -0.277, adder_8bit -0.189). circuit7 and
  adder_8bit show byte-identical deltas across ALL arms -> every QD
  configuration converges to the same candidate (no improvement over
  the gen-0 seed); these are intrinsic-limitation problems.
- Arm-INVARIANT losers (config doesn't matter): circuit7, alu,
  adder_8bit, fsm, traffic_light. Arm-VARIANT (config moves the
  needle, i.e. where F2/F3 act): multi_pipe_8bit (target +0.276 /
  scalar -0.183), m2014_q6b (c_unified ties / six-op -0.199),
  review2015_fsm (c_unified +0.096 win / scalar -0.125). Three
  problems are pure ties for all arms (m2014_q3, fsmonehot, partly
  q6b).
- Manuscript impact: F1 "QD loses" sharpened to "QD is catastrophic
  on ~3 intrinsic-limitation problems and competitive/winning
  elsewhere"; failure panel = circuit7/adder (arm-invariant),
  operator-effect showcase = multi_pipe_8bit/m2014_q6b (arm-variant).
  Recorded F7 in doc 13. Seed 1002 will confirm the localization.

## 2026-06-13 11:15 KST — seed-1002 lands: F2 replicates, F5 inverts, F7 holds

- F2 (operator licensing) REPLICATES. Pooled 2-seed (the formal rule):
  qd_target - qd_six_operators = +0.024, CI [+0.0035, +0.0465] above 0
  -> "better". Per-seed 1002 +0.006 (parity; gshare excluded as
  missing_baseline -> conservatively understates unified). No sign
  reversal. M6 caught the 12/13 paired count - the unpaired unit is
  the predeclared conservative missing-baseline exclusion, not a bug.
- F5 (pareto vs scalar cells) DOWNGRADED to INCONCLUSIVE. seed 1002
  inverts seed 1001: target -0.100 vs scalar -0.075 (scalar better
  by 0.025), opposite of seed-1001's +0.05 for pareto. Cell-mode
  effect is within seed noise at this budget - honest retraction of
  the earlier positive reading.
- F7 (localization) CONFIRMED across 2 seeds: seed-1002 worst-3 carry
  62% of loss (seed-1001 58%); circuit7 and adder_8bit persistent in
  the worst-3.
- F3 (substrate dependence) reinforced: unified BETTER within QD
  (pooled +0.024) vs WORSE on classic (-0.102 seed1002 confirms
  -0.090 seed1001).
- All seed-1002 vs-classic: classic_unified -0.102, six_op -0.130,
  scalar -0.075, target -0.100. Matrix moved to seed 1003 (classic
  arm started 10:58).

## 2026-06-13 11:55 KST — M7: equivalence over-rejects on don't-cares

- Ran check_equivalence on a real archive elite (m2014_q6b, QD's
  +0.088 win problem) vs the benchmark reference. Two findings:
  (1) tool bug - benchmark convention is candidate=TopModule vs
  reference=RefModule, so a single --top gave a false NOT_PROVEN;
  fixed with --gold-top/--gate-top (commit 3a0cd12779, the synthetic
  smoke test used the same name both sides and hid it).
  (2) Methodology (M7): even with correct names the testbench-passing
  elite is NOT_PROVEN - m2014_q6b is a 6-state FSM in a 3-bit
  encoding (2 unreachable codes), and yosys combinational equiv
  over-rejects on those don't-care/unreachable inputs. So formal
  equivalence is the WRONG oracle for don't-care problems; the
  don't-care-aware testbench is correct. P4 equivalence spot-check
  must be scoped to fully-specified problems or use care-set
  constraints - recorded in the dashboard open-decisions. Caught now
  rather than at the P4 freeze.

## 2026-06-13 13:40 KST — Branch C floor leg (i) FAILS parity rule (3 seeds)

- classic_unified seed-1003 landed (13/13 paired, M6 clean): -0.084,
  CI [-0.154,-0.022]. Floor leg now 3-seed consistent: -0.090/-0.102/
  -0.084. POOLED 3-seed (the formal rule, 39 paired): delta -0.092,
  4W/29L/6T, CI [-0.1487,-0.0370]
  (stats/floorleg_classic_unified_pooled).
- IMPLICATION (frozen-narrative consequence, surfaced not resolved):
  Branch C floor leg (i) is "the unified-operator one-factor ablation
  showing parity-or-better (a real simplification result independent
  of QD's fate)"; the predeclared rule requires the CI entirely above
  -0.03. CI low -0.149 << -0.03 -> FAILS. On the classic substrate,
  unifying the six operators COSTS ~0.09; the simplification is NOT an
  independent win. The only positive operator result is the WITHIN-QD
  contrast (F2: unified >= six within QD, pooled CI above 0) - but
  that is entangled with QD, exactly what floor leg (i) was meant to
  be independent of.
- The narrative predeclares: if floor leg (i) is not achieved, Branch
  C triggers venue reassessment instead of a TCAD submission. This is
  CONDITIONAL: the floor leg only binds IF the FINAL held-out gates
  land in Branch C (row 5). It is moot if the finals land in Branch
  B-scoped/B/A.
- CONSEQUENCE for strategy: Fix B (code-seeded realization, queued) is
  now LOAD-BEARING, not just storyline-strengthening. If Fix B closes
  the QD-vs-classic gap -> finals can land in Branch B/A where the
  floor leg is moot, and the operator story stands as the within-QD
  F2 result. If Fix B fails -> floor leg (i) is unmet and venue
  reassessment is the predeclared path. The bake-off (descriptor
  value) and RealBench storyline (M8) carry the same load.

## 2026-06-13 14:00 KST — Fix A built; parity screens reprioritized

- feat(qd) 766bee94dc: Fix A champion lane
  (--qd_champion_lane_fraction, default 0.0) draws a fraction of QD
  parents from the global-best member instead of pure diverse-cell
  sampling - the second confirmed why-classic-wins mechanism (F8
  parent-selection dilution). Both load-bearing fixes (B code-seeded,
  A champion lane) now built, opt-in, one-factor screenable; suite
  green.
- REPRIORITIZED the post-matrix queue (F9 made the parity fixes
  project-critical, so they should not wait behind the P2 bake-off):
  killed the two old watchers, created exp/queue_priority_after_matrix.sh
  = matrix-done -> Fix B (code_seeded) -> Fix A (champion 0.5) ->
  bake-off triple. Combined B+A launcher generated and held in
  reserve (run only if B and A are individually partial - keeps the
  attribution one-factor). Screen each vs classic on the +/-0.02
  bands AND the F8 signature (does the champion now climb past
  gen-0).
- Matrix: qd_six_operators seed-1003 running; ~2 arms to go before
  the priority screens fire.

## 2026-06-13 20:10 KST — MATRIX COMPLETE; F2 downgrades to PARITY

- qd_target seed-1003 done; ablation matrix ALL DONE (15 runs). The
  priority queue (Fix B -> Fix A -> bake-off) watcher is alive and
  fires within its 300s poll.
- FORMAL 3-seed pooled F2 (the operator headline): +0.0107,
  13W/13L/12T, CI [-0.0059, +0.0302]. CI low -0.006 spans 0 -> NOT
  "better"; but > -0.03 -> PASSES parity-or-better at PARITY. The
  2-seed "better" (CI above 0) did NOT replicate: seed-1003 came in
  -0.015 (4/6/3), pulling the pool down. HONEST headline correction:
  the unified operator is statistically EQUIVALENT to the
  six-operator suite within QD - a no-cost simplification (removes
  criticisms #2/#3), not an improvement. Combined with F9 (costs
  -0.09 on classic), the operator story is "one operator suffices
  WITHIN QD at no cost," entangled with QD.
- F5 final (3 seeds): pareto vs scalar = +0.050/-0.026/+0.014 (mean
  +0.013); 2/3 lean pareto but sign flips, within noise -> stays
  INCONCLUSIVE; pareto defensible as principled (criticism #1) not a
  measured win.
- F1 reconfirmed: qd_target vs classic -0.078/-0.101/-0.092 all 3
  seeds.
- NET: with the matrix done, the journal's standing positives are
  (a) operator simplification at PARITY within QD (F2), (b) the
  principled Pareto/no-weighted-sum design (F1-criticism answer).
  Both are "no-cost" not "win." Whether there is a performance WIN
  hinges entirely on the now-firing Fix B/A parity screens and the
  bake-off/RealBench storyline. The stakes from F9 are unchanged and
  now sharper: parity (Branch B) is the realistic ceiling unless
  Fix B/A move the needle.

## 2026-06-13 21:10 KST — Fix B verdict: deficit HALVED, anchoring regression (F10)

- Fix B (code-seeded realization) screen done. Mechanism verified live
  first (M6): 188 seeded-realization prompts carrying real parent_code
  vs 84 whole-regen fallbacks - code-seeding genuinely active, no
  repeat of the R-B payload bug.
- Verdict vs classic (fast v3): -0.087, 0W/3L/3T, CI [-0.237,-0.002].
  Still DEMOTE on the strict +/-0.02 band BUT the first intervention
  to materially move the gap: the frozen-target baseline replication
  on this subset was -0.177, so Fix B HALVES the deficit, converting
  mux256to1v/popcount255/rotate100 losses into ties.
- F8 signature partially restored: mux256to1v champion climbs
  0->0.305 at gen-2 (frozen target was flat); multi_16bit/pe show
  weak gen0->1 climbs. So code-seeding does restore some code-level
  hill-climbing.
- NEW failure mode (anchoring): sub_64bit - classic leaps to 0.454 at
  gen-1 (a better architecture) while Fix B stays ~0 because seeding
  from the parent code anchors it to the worse architecture and
  blocks the leap. This single problem (-0.454) dominates Fix B's
  mean. The flip side of the indirection penalty: refinement restored,
  but architectural escape suppressed.
- Implications: (a) Fix A (champion lane) running now - attacks the
  other mechanism, may stack. (b) Combined B+A (held in reserve) now
  worth running given B is partial-positive. (c) B' hybrid idea: keep
  a fraction of samples whole-regen (leap) alongside seeded
  (refinement) so escape is preserved - the k=4 budget already mixes
  84 whole + 188 seeded, but a deliberate per-thought split could
  balance it. Logged for the post-screen decision.
- NET: viability needle MOVED for the first time. Parity (Branch B)
  now looks reachable with B+A and/or B' tuning; the -0.45 anchoring
  outlier is the specific thing to fix next.

## 2026-06-13 21:40 KST — Fix A null alone; mechanisms coupled (F11); B+A queued

- Fix A (champion lane 0.5) vs classic: -0.167, 0W/4/2 - essentially
  the frozen-target -0.177, NO help. It even HURT popcount255 (Fix B
  tied it at 0.000; Fix A lost -0.285).
- Mechanistic reading (clean): champion lane is useless WITHOUT
  code-seeding - picking the champion as parent is pointless if the
  realization then regenerates its code from scratch (indirection
  penalty intact). So Fix A and Fix B are NOT independent; A only
  pays off stacked with B. This also explains the popcount harm:
  concentrating on a champion you can't refine wastes budget diverse
  sampling would have spent finding the tie.
- DECISION: run the combined B+A (champion lane refining the
  champion's actual code) as the key parity experiment. Queued after
  the bake-off (exp/queue_fixba_after_bakeoff.sh) to not disrupt the
  running P2 bake-off; B+A lands ~2h out. If B+A reaches parity ->
  hard-subset pair -> Branch B. If still short, the named obstacle is
  the sub_64bit anchoring (F10) -> hybrid B' (split k samples between
  seeded refinement and whole-regen leaps).
- Parity-fix ladder so far (vs classic, v3): frozen -0.177; Fix B
  -0.087 (halved); Fix A -0.167 (null); B+A pending.

## 2026-06-13 22:10 KST — bake-off pair 1 (graph_testability): coverage yes, quality no

- graph_testability vs classic: quality -0.186 (0/5/1) - NOT better
  than the trio (-0.177). BUT archive health much better:
  warmup-complete 67% (trio 40%), median occupancy 0.50 (trio 0.12,
  which FAILS the 0.25 floor). So the graph/testability profile
  ESCAPES the trio degeneracy (M5) - it maintains a populated, diverse
  archive where the naive trio collapses - without improving PPA.
- Early P2 read (partial - activity + simple_2d still pending): the
  diversity contribution (criticism #5) may be salvageable as a
  COVERAGE claim (graph_testability holds the archive open) rather
  than a PPA-win claim. The trio itself fails the occupancy floor, so
  it cannot support a diversity claim. Formal bake-off verdict
  deferred to the full 3-profile mechanical table
  (report_descriptor_bakeoff) once all pairs land.

## 2026-06-13 22:40 KST — bake-off verdict (F12) + occupancy confound (M9)

- Full 3-profile bake-off done; report_descriptor_bakeoff verdict
  (exp/fast_iter/bakeoff_verdict). Quality-first ranking: activity
  -0.103 (1/4/1, the only profile with a win) > simple_2d -0.131 >
  trio -0.177 > graph_testability -0.186.
- F12 headline: NO profile improves PPA over classic (all -0.10..-0.19)
  - the descriptor choice is NOT the PPA lever, consistent with
  F6/F10 (gap is indirection + archive/selection). Diversity health
  by collapse count: simple_2d 2 < graph_testability 8 < activity 12
  < trio 14 - the cheap 2-axis control is the MOST collapse-resistant;
  descriptor sophistication bought no diversity health.
- M9 (metric flaw): the occupancy tie-break (occupied/total) is gamed
  by collapse - the trio reads occ=1.00 because it collapses to one
  fully-occupied cell. The collapse count is the truer signal. The
  freeze tie-break should use collapse, not raw occupancy.
- DECISION FLAGGED (not auto-made): profile freeze is hard-to-reverse.
  By the frozen quality-first rule activity wins, but (a) it has high
  collapse (12), (b) no profile improves PPA, (c) the diversity claim
  is best supported by simple_2d/graph_testability (low collapse).
  Recommend: freeze decision should weigh collapse-health for the
  DIVERSITY claim separately from the (null) PPA ranking, and ideally
  be re-checked on RealBench-large designs (where the trio's small-
  design collapse may not bind). Surfacing for the team.

## 2026-06-13 23:40 KST — B+A verdict: champion lane HURTS (F13); Fix B alone wins

- Combined B+A (mechanism verified live: 164 seeded prompts + champion
  concentration) vs classic: -0.128, 0W/4/2, CI [-0.238,-0.023].
- SURPRISE: B+A (-0.128) is WORSE than Fix B alone (-0.087). The
  champion lane, even with code-seeding, drags B down - mux256to1v
  went from a TIE under B alone to -0.330 under B+A. Concentration
  sacrifices the coverage that was finding ties.
- This CORRECTS the F11 hypothesis ("A only pays off with B"). Actual
  finding: champion lane is HARMFUL (alone null+popcount harm; with B,
  -0.04 worse). Fix A / champion lane is ABANDONED.
- WINNING CONFIG: Fix B alone (-0.087) = code-seeded realization with
  normal diverse parent selection. Halves the frozen deficit; the
  diversity (diverse parents) does useful work finding ties, so don't
  concentrate.
- Remaining gap to parity = the anchoring outliers (sub_64bit B+A flat
  -0.02->-0.0 vs classic 0.30; champion lane did NOT fix anchoring,
  expected). Named next experiment: hybrid B' - split each thought's
  k=4 samples between seeded (refinement) and whole-regen (leap) so
  architectural escape is preserved alongside refinement. This
  directly targets the sub_64bit/mux anchoring.
- Parity ladder: frozen -0.177; A -0.167; B -0.087 (best); B+A -0.128.
  Branch B (parity) not yet reached; Fix B + B' hybrid is the path.

## 2026-06-14 00:00 KST — B' hybrid built and launched

- feat(qd) 582c168d7f: --qd_seed_sample_fraction splits a thought's
  k samples between seeded realization (refinement) and whole-regen
  (leap); default 1.0 = pure Fix B. Per-sample prompt tracked so
  snapshots stay M6-verifiable. Champion lane (Fix A) abandoned per
  F13 (it hurt). 66 neighbor tests green.
- B' screen launched directly (OpenRouter now free after matrix +
  bake-off + B/A/B+A): frozen target + --qd_thought_code_seeded
  --qd_seed_sample_fraction 0.5 vs classic on v3 (exp/fixbprime_hybrid,
  classic arm 23:42). Hypothesis: 0.5 keeps 2/4 samples as leaps,
  recovering the sub_64bit architectural leap that pure Fix B anchored
  away, while keeping refinement on the rest -> push below Fix B's
  -0.087 toward parity.
- Parity ladder: frozen -0.177; A -0.167; B -0.087 (current best);
  B+A -0.128; B' pending.

## 2026-06-14 00:38 KST — B' worse (F14); Fix B is the ceiling; promote Fix B

- B' hybrid (fraction 0.5) vs classic: -0.141, 1W/4/1 - WORSE than
  pure Fix B (-0.087). sub_64bit still anchored (B' [-0.02->-0.0] vs
  classic ->0.454): the 2 whole-regen leap samples did NOT find the
  better architecture, and halving the seeded samples diluted the
  refinement that helped elsewhere (mux256to1v lost its tie again).
- Monotonic in seed fraction: 1.0 -0.087 > 0.5 -0.141 > 0.0 ~-0.177.
  So Fix B at fraction 1.0 (all samples code-seeded, diverse parents)
  is the OPTIMUM of this lever. No further fraction tuning warranted.
- Mechanistic conclusion: anchoring on sub_64bit-class problems is
  INTRINSIC to thought->code indirection - thought-only QD cannot
  express the specific low-level architecture classic's direct code
  evolution finds, regardless of seeded/leap sample mix. The residual
  -0.087 is the floor of realization-side fixes.
- DECISIONS: (1) Fix B alone is the frozen parity config. (2) Stop
  realization-side fraction tuning (trend is clear). (3) PROMOTE Fix B
  to a hard-subset pair to confirm the deficit-halving on the real
  evaluation set (vs the -0.086/-0.188 baselines). (4) Re-elevate the
  RealBench-large storyline (task #16) as the path to an actual WIN,
  since small-problem PPA parity is unreachable via realization fixes.
- Final fast-subset parity ladder: frozen -0.177 | A -0.167 | B+A
  -0.128 | B' -0.141 | Fix B -0.087 (BEST).

## 2026-06-14 00:40 KST — Fix B hard-subset confirmation pair launched

- Launched the Fix B promotion experiment on the real evaluation set:
  classic vs frozen-target+--qd_thought_code_seeded, hard subset (13
  problems), seed 42, 20pop x 5gen - directly comparable to the
  original hard_subset_42 baselines (-0.086 best-quality / the
  -0.188 fast verdicts). exp/fixb_hard_subset, classic arm 00:40.
  ~3h (classic ~1h + Fix B QD arm ~2h).
- Purpose: confirm the fast-subset deficit-halving (-0.177->-0.087)
  holds on the hard subset. If Fix B roughly halves the hard-subset
  deficit too, that is the manuscript's "code-seeded realization
  materially narrows the QD-vs-classic gap" result (Branch B-leaning
  on PPA, still not a win). If it doesn't transfer, the realization
  fix is fast-subset-specific and the PPA story stays Branch C.
- Next gates: Fix B hard-subset verdict (~3h) + the still-pending
  RealBench-large storyline (task #16) for an actual win.

## 2026-06-14 03:40 KST — Fix B does NOT transfer to hard subset (F15)

- Fix B hard-subset confirmation (seed 42, 20x5, 13 problems) vs
  classic: -0.116, 1W/10L/2T, CI [-0.210,-0.037]. Frozen QD on the
  same subset (matrix qd_target) is -0.078/-0.101/-0.092 (~-0.09).
- CONCLUSION: Fix B is NOT better than frozen on the hard subset; the
  fast-subset deficit-halving (-0.177->-0.087) did NOT transfer. It
  was a fast-subset artifact - that mix had refinement-amenable
  problems and 3 pre-existing ties. On the hard subset the
  architectural/anchoring losers dominate (parallel2serial -0.486,
  fsmonehot -0.329, circuit7 -0.320; multi_pipe +0.087 the lone win).
- STRATEGIC: the realization-side parity path is CLOSED. Fix B is a
  fast-subset improvement that does not generalize. Combined with the
  matrix (F1/F2-parity/F9 floor-leg fail) and bake-off (F12 no PPA
  win), the journal's PPA story is firmly "QD loses to classic by
  ~0.09-0.12 on the real set; realization fixes don't close it."
- The ONLY remaining path to a performance WIN over classic is
  RealBench-large (task #16). Otherwise the journal is a
  characterization paper (Branch C / B-scoped): operator parity (F2),
  coverage-diversity (F12), regime-sensitivity (F4), honest
  root-cause (F7/F8/F10/F15). Surfacing the task-#16 decision as now
  load-bearing for whether ANY win exists.
- Fix B (--qd_thought_code_seeded) stays in the codebase as the best
  realization config and a documented fast-subset result; not a
  general parity fix.

## 2026-06-14 04:15 KST — storyline-decider validated end-to-end (M10)

- After F15 (realization parity closed), validated the ONLY remaining
  win-path (RealBench-large, task #16) end-to-end via a manual probe
  that does NOT touch load-bearing SynthesisEvaluator:
  1. yosys (ref.yosys.tcl + aux reads + DISABLE_SV_ASSERTION) on
     e203_exu_alu_dpath (2143 cells) -> mapped 191KB netlist, rc=0.
  2. real ref.openroad.tcl on that netlist -> rc=0, COMPLETES the
     floorplan: design area 2525 u^2, tns -10.94, wns -0.21, power
     reported (timing unmet at the 10ps max-effort constraint, same
     for both arms - expected; metrics extract cleanly).
- M10: the M8 OpenROAD-on-large unknown is CLEARED. The full PPA flow
  works on large e203 designs. Task #16 is no longer a feasibility
  question - it is confirmed-feasible PLUMBING: (1) relax the
  supports_synthesis heuristic, (2) thread aux/support files +
  per-task defines into SynthesisEvaluator (additive, aux default
  ()), (3) wire aux through candidate_evaluator, (4) re-lock a
  synthesis-capable large-module subset, (5) run QD-vs-classic.
- STRATEGIC: after the F15 negative (realization parity doesn't
  transfer), this is the positive counterweight - the win-path over
  classic is technically alive and now low-risk to build. The hard
  unknowns (yosys + OpenROAD on large designs) are both confirmed.
  Task #16 go/no-go is now a pure cost/value call, not a feasibility
  gamble. Probe artifacts in /tmp/orprobe (yosys.log, openroad.log).

## 2026-06-14 05:00 KST — task #16 step 1 DONE: synth aux-threading (validated)

- Decision: built the win-path (task #16) rather than defer a 4th time -
  F15 closed realization parity, M10 confirmed RealBench-large is
  feasible, the user keeps asking "what's next/what fixes", and the
  remaining work is reversible additive plumbing.
- feat(synth) 2ba630bab9: SynthesisEvaluator gains aux_files/
  include_dirs/defines (all default empty -> byte-identical behavior
  for VerilogEval/RTLLM single-file tasks); ref.yosys.tcl gains
  __DEFINES__/__INCDIRS__/__AUX_READ__ placeholders. Validated on the
  REAL flow (not a probe): e203_exu_alu_dpath (2143 cells) + support +
  DISABLE_SV_ASSERTION -> synth_success + OpenROAD floorplan. Full
  suite green (739 passed, 4 skipped) - zero regression on the
  load-bearing synthesis path.
- REMAINING task #16 steps (next cron fire continues): (2) relax the
  manifest supports_synthesis heuristic to allow support_files;
  (3) wire aux_files/defines from the RealBench problem spec through
  candidate_evaluator -> SynthesisEvaluator (the runtime path QD runs
  use); (4) re-lock a synthesis-capable large-module RealBench subset;
  (5) run QD-vs-classic on RealBench-large with PPA + Pareto-coverage
  readouts (the storyline-decider). Stopped at the tested step-1
  boundary rather than rush step 3 (another load-bearing path) at the
  end of a long turn.

## 2026-06-14 05:30 KST — task #16 steps 1-3 done; step-4 synth sweep launched

- Steps 1-3 of the win-path built, tested, committed:
  - step 1 (2ba630bab9): SynthesisEvaluator + ref.yosys.tcl aux/define
    threading (739 tests green; real-flow validated on alu_dpath).
  - step 3 (b8affae671): candidate_evaluator forwards aux/defines to
    runtime synthesis (87 targeted tests).
  - step 2 (6d40cee6e1): --validate-synthesis marks supports_synthesis
    truthfully via the real flow (replaces the false-negative
    heuristic).
- step 4 LAUNCHED (background, niced): synthesis-validation sweep on
  the e203_hbirdv2 family into data/bench/RealBench_v4_synth - runs
  the real yosys+OpenROAD flow on each golden to produce a TRUE
  synth-capable large-module set. ~30-60 min CPU. Locked roots
  untouched (new root).
- REMAINING: step 4b (lock a large-module subset from the v4
  synth-validated set) + step 5 (run QD-vs-classic on RealBench-large,
  the storyline-decider). Next fire gates the sweep and proceeds.

## 2026-06-14 06:10 KST — STORYLINE-DECIDER LAUNCHED (task #16 step 5)

- Step 4 result: v4 synth-validation sweep marked 34/40 e203 modules
  supports_synthesis=true, including large architectural blocks
  (exu_decode 54KB, biu, ift2icb, lsu_ctrl, core/cpu/exu). Cores synth
  in 66-84s (too slow for an evolutionary loop); picked large-but-fast
  (2-3s) blocks.
- Step 4b: locked data/configs/realbench_large_subset.yaml - 4 large
  e203 blocks (decode/biu/ift2icb/lsu_ctrl, 38-54KB), all
  synth+harness validated in RealBench_v4_synth.
- Step 5 LAUNCHED: classic vs QD(frozen target + Fix B code-seeded,
  the best realization config) on the large subset, seed 42, pop 12 x
  3 gens, --realbench_root RealBench_v4_synth
  (exp/fast_iter/realbench_large_storyline, classic arm 06:10). THE
  test of whether QD diversity pays off on large designs with
  architectural room - the only remaining path to beating classic
  (F1/F15 closed small-problem parity). Readouts: best-quality delta
  + per-problem; descriptor health (do the journal axes finally
  NON-degenerate on large designs, vs M5 collapse on small ones).
- ~hours (large-module synth+OpenROAD per candidate). Gate on
  completion.

## 2026-06-14 06:45 KST — storyline-decider run INVALID (F16); decision point

- The launched large-module run produced 0 valid candidates on BOTH
  arms (classic 0/48 each). Investigated rather than concluded:
  - Root cause: RealBench adapter reads top module from
    synthesis_top_module_names.json (VerilogEval convention) which the
    RealBench root lacks -> defaults to 'TopModule' not e203_biu ->
    every candidate fails compile on name mismatch. Plus functional
    candidate eval needs aux/defines (config.v/e203_defines.v)
    threaded like synthesis (steps 1-3) - candidate feedback cites
    undefined E203 macros.
  - So the run is INVALID (eval-wiring), NOT a QD-vs-classic result.
    Killed it (was burning OpenRouter on a broken comparison).
- PROCESS LESSON: I validated SYNTHESIS on the golden (M10) but did
  NOT validate the candidate FUNCTIONAL eval on a RealBench-large
  module before launching the full run. The M6 'verify mechanism
  before verdict' discipline applies to runs, not just screens - I
  should have run one candidate (or the golden) through the functional
  eval first.
- OPEN STRATEGIC QUESTION (the real risk, beyond wiring): even with
  correct top-module + aux wiring, can the LLM implement 40KB e203 CPU
  blocks (BIU, decode) correctly AT ALL? The candidate feedback shows
  real structural errors (ifdef-in-ternary, multi-driver, submodule
  interface mismatches) beyond the macro/wiring issues. If the LLM
  cannot produce a single functionally-valid large-module candidate,
  the PPA-win storyline-decider is impossible regardless of wiring -
  you cannot compare PPA when nothing passes.
- DECISION SURFACED (not auto-pursued): (A) invest in fixing RealBench
  functional-eval wiring (top-module resolution + functional aux/
  defines) THEN validate the golden through functional eval THEN
  re-run - accepting the LLM-capability risk; or (B) accept that the
  large-module win-path is likely blocked by LLM capability and commit
  to the characterization framing (operator parity F2, coverage-
  diversity F12, regime-sensitivity F4, honest root-cause F7/F8/F15).
  Recommend a BOUNDED next step: fix wiring + validate the GOLDEN
  through functional eval (cheap, no LLM) - if the golden can't pass,
  it's a harness limit; if it passes, the question is purely LLM
  capability, testable with a small smoke before any full run.

## 2026-06-14 07:10 KST — F16 fully root-caused; salvage path identified

- Bounded golden probes (no LLM) fully characterized the large-module
  blocker chain:
  1. Top module defaults to 'TopModule' (adapter reads missing
     synthesis_top_module_names.json) instead of the manifest
     top_module. Fix: use manifest top_module. Small.
  2. Functional macros (E203_XLEN etc.) RESOLVE once the support
     incdir is passed - the golden `include "e203_defines.v"` finds it
     with +incdir+support. Verilator preprocesses PER FILE (unlike
     yosys read_verilog -defer's shared context), which is why M10
     synthesis worked on the same aux but functional eval did not.
     My VerilatorEvaluator likely mis-passed the incdir; small fix.
  3. REAL blocker: large INTEGRATION modules have incomplete
     dependency closure. e203_biu instantiates sirv_gnrl_icb_arbt/
     buffer/splt which are NOT in its manifest aux_files -> cannot
     compile or synthesize standalone. LEAF modules (e203_exu_alu_dpath,
     M10-validated 2143 cells) ARE dependency-complete.
- SALVAGE PATH (makes the win-path tractable without a full
  dependency-closure project): build the large subset ONLY from
  dependency-complete large modules - those whose GOLDEN passes the
  functional+synthesis eval standalone. alu_dpath qualifies; biu does
  not. Validate each large candidate-module's golden first, keep the
  complete ones.
- Remaining after salvage: (a) top-module fix + incdir fix (small),
  (b) re-pick subset to dependency-complete large modules, (c) the
  OPEN LLM-CAPABILITY RISK (can the model implement even a complete
  large module correctly? - the only way to know is a small smoke on
  one complete large module once wiring is fixed).
- This is a precisely-costed decision now: ~2 small wiring fixes + a
  golden-validation re-pick + a 1-module LLM smoke, THEN decide on the
  full run. Recommend doing the bounded smoke before any multi-hour
  run (M6). Surfaced for the user; not auto-pursued further tonight.

## 2026-06-14 07:55 KST — F16 RESOLVED: RealBench-large eval pipeline validated end-to-end

- Continued the F16 train of thought with bounded golden probes (no LLM)
  and FIXED the large-module eval pipeline. Commit f275b5a9c2.
- Four wiring gaps, each isolated by probing the golden e203_exu_decode:
  1. Top module defaulted to 'TopModule' (runtime reads
     synthesis_top_module_names.json, absent in the RealBench root).
     FIX: manifest builder emits it from the manifest top_module (single
     source of truth); backfilled to RealBench, _v1_iverilog, _v4_synth.
  2. Post-synthesis functionality check did not thread include_dirs/
     defines -> the e203 testbench (which `include`s e203_defines.v and
     uses its macros in its own ports) failed to compile vs the
     gate-level netlist. FIX: thread include_dirs/defines into
     _check_synthesis_functionality + caller.
  3. Post-synth pass parser only knew VerilogEval (`Mismatches: 0`) and
     RTLLM (`Your Design Passed`); the e203 harness emits `Total
     mismatched samples is N out of M`. FIX: mirror
     parse_mismatch_count's fallback so post-synth accepts the same
     passing runs as pre-synth.
  4. VerilatorEvaluator lacked enable_vcd_probe (passed by the candidate
     evaluator). FIX: accept it, assert False (icarus_vcd dynamic
     metrics incompatible with the verilator harness -> fail loudly).
- END-TO-END PROOF (M11): golden e203_exu_decode (53 KB, largest
  dependency-complete e203 module) passes the full runtime
  evaluate_candidate -> status `success`, synth+synth_func+ppa all True,
  PPA area 714 / power 2.55e-4, journal BD trio extracted (logic_depth 0,
  ff_depth 0, comb_width_log 6.51), archiveable, benchmark golden intact.
- Two earlier-probe red herrings cleared: the biu macro failure was
  genuine missing submodule deps (not an evaluator bug); the decode macro
  failure in my first probe was my own RELATIVE incdir/aux paths under
  the evaluator's cwd=out_dir change (absolute paths compile fine).
- Dependency-complete census (F17): 13/40 e203 goldens lint clean
  standalone with manifest aux; only 2 are >=10 KB (decode 53 KB, disp
  14 KB). Large integration modules (biu/core/lsu) miss submodules
  (e203_clkgate, sirv_1cyc_sram_ctrl) -> the original storyline subset was
  mostly dependency-incomplete (the other reason that run failed).
  Salvage: build the large win-path subset from dependency-complete
  modules; near-misses (biu, core) recoverable by adding e203_clkgate.
- Contamination incident + recovery: my first integration probe used the
  benchmark golden.v directly as the candidate code_file_path, so
  synthesis overwrote it with the netlist. Restored decode's v4_synth
  golden.v from the clean v3 copy (54374 B, Nuclei header); scanned all
  v4_synth goldens for the Yosys header -> only decode was hit, now
  clean. In a real run the candidate path is per-candidate in the run
  dir, so this is a test-harness-only hazard; probes now use a temp file.
- Validation: ruff + pyright clean on touched modules; pytest -k
  'verilator or synthesis or realbench or candidate_eval' -> 59 passed.
- REMAINING open question (now cheap): can the LLM implement decode-class
  modules? Settle with a 1-module OpenRouter smoke before any full
  QD-vs-classic large run. Infra risk is retired; capability risk stands.

## 2026-06-14 08:50 KST — LLM-capability smoke LAUNCHED (decode, bounded)

- Acting on the F16/M11 result (golden decode validated end-to-end), and
  per the pre-stated plan (golden-success unlocks a 1-module smoke before
  any full run), launched a bounded LLM-capability smoke:
  exp/decode_capability_smoke_launch.sh -> exp/fast_iter/decode_capability_smoke.
- Config: classic arm only, e203_exu_decode ONLY, gpt-oss-120b via
  OpenRouter, population 8 x 2 generations, seed 42, max_tokens 64000
  (generous to avoid truncation masking capability on a 1234-line module),
  --realbench_root data/bench/RealBench_v4_synth.
- OpenRouter preflight passed (models 200; gpt-oss-120b reachable; a
  PREFLIGHT_OK completion returned content + reasoning, cost ~8e-5).
- The single question: does ANY of the 8+ attempts produce a
  functionally-valid decode (passes the 100000-sample equivalence)? If
  zero pass, the large-module win-path is LLM-capability-blocked and the
  finals commit to the characterization framing (Branch C, doc 14). If
  any pass, a full QD-vs-classic large run is justified.
- Running in the background (harness-tracked); result will be recorded
  here on completion.

## 2026-06-14 ~09:00 KST — decode smoke: health confirmed + PRE-REGISTERED criteria

- Smoke confirmed actively generating (not stalled): run_backend process
  multi-threaded, 18 established OpenRouter TCP connections, etime
  climbing. Empty per-problem log is expected — with max_tokens 64000 on
  a reasoning model emitting a ~1234-line module, each of the 8 attempts
  (4 parallel) takes several minutes; first generation still in flight.
- PRE-REGISTERED interpretation (decided BEFORE the result, to avoid
  post-hoc rationalization — M6 discipline). Of the 8 classic gen-0
  attempts at e203_exu_decode:
  * PASS (LLM-capable): >=1 attempt is FUNCTIONALLY VALID (status
    success, 0 mismatches over the 100000-sample equivalence). Even 1/8
    proves the model CAN implement a decode-class module -> a full
    QD-vs-classic large run is justified; proceed to build a
    dependency-complete large subset (mix sequential modules so the
    journal_logic_ff_width_3d BD spreads; decode is comb-only).
  * WEAK (marginal): 0 functionally valid BUT >=1 COMPILES (syntactically
    plausible decode RTL, fails only on mismatches). The model produces
    structurally-reasonable decode but not bit-exact -> win-path is
    marginal; options: larger token budget, more attempts, or a smaller
    dependency-complete module (disp 14KB) as the headline.
  * FAIL (LLM-blocked): 0 compile / structurally broken output -> the
    model cannot produce decode-class RTL; the large-module win-path is
    dead. Commit the finals to the characterization framing (Branch C,
    doc 14) — already the evidence-supported posture.
- Note on cost/latency: 64000-token budget is generous (chosen so
  truncation cannot masquerade as incapability). If the smoke PASSES, the
  full run's budget should be re-calibrated (the decode golden is
  ~15-18k tokens of code; 32-40k may suffice and run far faster).

## 2026-06-14 09:10 KST — F18: decode capability smoke = decisive NEGATIVE (valid)

- decode (53KB, largest dependency-complete) capability smoke completed
  (rc=0, ~11 min, 57 LLM calls, ~$0.10): 24 candidates across 3
  generations, status_counts = failed_* for ALL, 0 functionally valid.
  "No functionally correct and synthesizable solution found."
- Candidate sizes 181-647 lines vs golden 1234 -> the model produces
  INCOMPLETE decoders (~half-size), with genuine syntax errors (wire
  decls inside procedural/function blocks, unexpected endfunction,
  duplicate ports, 7'b???, stray comma after endmodule).
- VALIDITY (M6, critical): the code_feedback.txt prose repeatedly claims
  "the testbench file is missing" - this looked like the F16 bug
  resurfacing. Ground-truthed it: re-ran a saved candidate through the
  validated evaluate_candidate -> the testbench WAS found; the candidate
  failed on ITS OWN syntax (failed_syntax, `unexpected wire` at line
  347). So "testbench missing" is the FEEDBACK-LLM hallucinating, not a
  real eval bug. The F16 fixes hold; the smoke is a VALID capability test.
  Lesson: for verdicts trust the run's status_counts / raw evaluator
  output, NEVER the LLM-generated feedback prose.
- Strategic read: the win-path's premise (QD diversity pays off on
  LARGER designs with architectural room) is now at real risk. The
  largest dependency-complete module is LLM-infeasible. The modules the
  model might handle (<=14KB) are adjacent to the small-problem regime
  where QD already LOSES (F1/F15). A genuine capability-vs-design-space
  squeeze.
- NEXT (running): mid-size capability smoke (F19) on the 6 dependency-
  complete EXU modules 4.7-14KB (disp/longpwbck/branchslv/alu_csrctrl/
  wbck/alu_rglr), all golden-validated end-to-end first (M6; confirms the
  F16 fixes generalize beyond decode - they do, 6/6 golden success). Maps
  the model's exact ceiling. If even disp (14KB) fails, the large-module
  win-path is capability-blocked and the finals commit to characterization
  (Branch C). Note: all 6 are combinational (ff_depth 0) - a BD-spread
  problem for journal_logic_ff_width_3d even if they pass.

## 2026-06-14 09:30 KST — F19: the smokes were CONFOUNDED; harness fixed

- Both capability smokes (decode F18; mid-size 6 EXU modules) returned 0
  valid, which looked like a comprehensive LLM-capability wall. M6
  ground-truthing overturned the interpretation for the small modules.
- The wbck candidates are plausible, COMPLETE implementations that fail
  ONLY because they use E203_XLEN without `include "e203_defines.v"`.
  The e203 modules depend on a project-global defines header; verilator
  preprocesses per-file, so a candidate resolves the macros only if it
  includes the header. The prompt tells the LLM to (line 67) but it
  routinely omits the line -> every candidate dies at preprocessing,
  masking its logic.
- FIX (commit d289e1c226): classify aux into module-sources vs
  defines-headers (no module decl); force-include the ENTRY header
  (e203_defines.v, not the config.v it transitively pulls in) into the
  candidate file used for BOTH functional (verilator per-file) and synth
  (yosys reads candidate before aux) compiles. item.code and the
  archived code_file_path stay raw for metrics/feedback/M6.
- Validated: goldens still pass (they self-include); saved wbck
  candidates now COMPILE and reach functional eval. ruff+pyright clean;
  59 targeted tests pass.
- TRUE signal (post-fix): candidates compile but are functionally WRONG.
  wbck: 6610/16021 mismatches (~41%), and ALL candidates get the
  IDENTICAL mismatch count -> a systematic same spec-misread (the
  F7/F4 mechanism), not random. So the win-path capability concern is
  genuine, but its magnitude was over-stated by the artifact.
- Correction to F18: the decode 0/24 is real but was measured through
  the confounded harness; decode candidates also had genuine syntax/
  incompleteness errors, but the clean signal awaits the re-map.
- Honest re-map LAUNCHED: exp/fast_iter/capability_remap, all 7
  dependency-complete modules (decode + 6 mid-size), classic, post-fix.
- Disclosed methodology choice (must appear in the paper): force-
  including the design's global defines header makes the e203 task
  (implement the logic) comparable to the self-contained VerilogEval/
  RTLLM problems, instead of also testing "remember the CPU's global
  include boilerplate."
- Lesson (M6 reinforced): a 0/N capability result MUST be ground-truthed
  before interpretation - twice now the LLM-feedback prose ("testbench
  missing") and an aggregate 0-count nearly drove a wrong verdict.

## 2026-06-14 10:10 KST — F20: storyline-decider SETTLED; win-path RETIRED

- Honest post-fix storyline-decider complete. Classic re-map: 7
  dependency-complete e203 modules (4.7-53KB), 0/7 valid, all
  failed_functionality. QD arm (same budget/seed, journal BD profile,
  thought_only + code_samples_per_thought 4): ALSO 0/7 valid, all
  failed_functionality (16 candidates/module).
- CONCLUSION: both classic and QD produce structurally-valid but
  functionally-WRONG implementations of every dependency-complete e203
  module. QD's diverse thought-level search does NOT break the classic
  monoculture spec-misread. The "QD beats classic on RealBench-large
  PPA" headline is impossible (no valid candidate to compare PPA on).
  The win-path is RETIRED on honest evidence (F19 removed the include
  confound; the failure is genuine functional incorrectness).
- This is CONTENT, not a null. It converts conference criticism #4
  (benchmarks too small) into a real RealBench-scale result and extends
  the regime-sensitivity thread (F4): at real-CPU scale the binding
  bottleneck is the LLM's systematic spec-comprehension, NOT search
  structure or operator design. It also bounds the diversity claim (#5):
  diversity cannot rescue a spec-comprehension bottleneck.
- Strategic docs updated: dashboard win-path block -> RETIRED; P1 ->
  Branch C evidence-decided; doc 14 recommendation -> win-path done,
  characterization paper is the evidence-decided conclusion.
- Graded mismatch comparison (classic monoculture vs QD diversity in
  mismatch space; does either get closer to correct?) running in
  background -> grade_mismatch_compare.json. Refinement only; does not
  change the verdict.
- The journal's posture is now firmly: a rigorous CHARACTERIZATION paper
  answering criticisms #1-3 (bias removal + the missing ablation) and #4
  (RealBench-scale capability finding), with #5 (diversity) bounded
  honestly. No "we win" claim - and now we KNOW, having run the decider.

## 2026-06-14 10:35 KST — M12 + F20 CORRECTION: parallel-eval artifact; QD still doesn't win

- CORRECTION to the 10:10 F20 entry. The "0/7 valid both arms" was a
  SECOND artifact. The graded mismatch refinement surfaced a
  contradiction: isolated re-eval of saved candidates showed classic
  alu_csrctrl + alu_rglr each have valid candidates (status=success, 0
  mismatch, synth+ppa) that the parallel RUN marked failed_functionality.
- Diagnosis (M6): the functional eval is DETERMINISTIC (verilator seeds
  $urandom stably; same candidate re-eval'd 3x gives identical 0/27). The
  failed candidate even self-includes e203_defines.v (not the F19
  confound). Fix committed 09:48:47, before the run (09:49:20). So the
  cause is ENVIRONMENTAL: the parallel run (14 worker slots, 7 modules x
  heavy verilator C++ build + yosys/OpenROAD) spuriously failed valid
  candidates under resource contention. = M12.
- CORRECTED authoritative numbers (isolated, deterministic re-eval of all
  16 candidates/module, both arms): valid candidates appear ONLY on the 2
  smallest modules - alu_csrctrl (5.6KB): classic 2 / QD 1; alu_rglr
  (4.7KB): classic 2 / QD 1. All larger modules (decode 53KB, disp 14KB,
  longpwbck, branchslv, wbck): 0 valid both arms. Totals classic 4, QD 2.
- CONCLUSION (unchanged, corrected evidence): QD does NOT beat classic at
  RealBench scale. classic 4 >= QD 2. QD shows MORE behavioral diversity
  (more distinct mismatch values: disp 7 vs 4, alu_rglr 6 vs 4) but
  converts it into FEWER valid candidates - diverse-but-wrong, not
  closer-to-correct (per-module best mismatch ~identical across arms). The
  buildable modules are small (back in the regime where classic wins, F1);
  the large regime is LLM-infeasible (decode 100% mismatch).
- CAVEAT: small modules have weak test coverage (alu_csrctrl only 27
  compared samples vs wbck 16021). So the gradient is the robust reading,
  not the precise 4-vs-2 count.
- M12 is a THREAT TO VALIDITY for the finals: final QD-vs-classic gates
  MUST use reliable eval (cap worker counts AND/OR isolated re-verify best
  candidates). Prior parallel runs (F1/F2/F15) may carry load-dependent
  noise (they produced scores, so less severe) - the finals must
  re-verify rather than trust raw parallel valid counts.
- Lesson (M6, third time): a 0/N capability/run result MUST be
  ground-truthed before interpretation. The graded refinement (almost
  skipped as "nice-to-have") is what caught this verdict-overturning
  artifact. Never trust an aggregate count without spot re-eval.
- Docs reconciled: F20 rewritten with the table; M12 added; dashboard
  status block + P1 + doc 14 recommendation corrected from "0/7" to
  "classic >= QD, valid only on smallest modules"; F19 re-map paragraph
  flagged. Strategic conclusion (characterization paper) stands.

## 2026-06-14 11:00 KST — M12 SCOPE VERIFIED: confined to heavy runs; CORE is reliable

- Assessed whether M12 (parallel-eval under-counting) corrupted the CORE
  characterization results (F1/F2/F15), which are the paper's spine. It
  did NOT.
- Method: isolated, deterministic re-eval of the core ablation matrix
  candidates, targeting the highest-signal cases (lowest qd_target valid
  counts = most likely to reveal spurious failures if M12 were present).
- Results (run success vs isolated success, exact):
  * qd_target Prob116_m2014_q3 (VerilogEval): run 9 = isolated 9. MATCH.
  * qd_target Prob153_gshare (VerilogEval): run 2 = isolated 2. MATCH.
  -> The core run was RELIABLE; the low qd_target counts are GENUINE
  (QD really produces fewer valid candidates on these), not M12 artifacts.
- The one apparent discrepancy (RTLLM Prob045_alu: run 21 vs isolated 0)
  is a RE-EVAL-TOOL artifact, not M12: the RTLLM testbench does
  $readmemh("Prob045_alu_reference.dat") which is absent in my tempdir, so
  every candidate errors in isolation. The run had the .dat co-located.
  Also reverse-direction (run > isolated), the OPPOSITE of M12 (which
  makes runs find FEWER). So RTLLM core is not M12-affected either.
- CONCLUSION: M12's catastrophe is CONFINED to the 14-way HEAVY e203 synth
  run (capability_remap). The core (12-way, small problems, light iverilog
  functional + light synth) was not corrupted. The characterization spine
  (F1 QD-loses, F2 operator parity, F15) stands on reliable measurement.
- Precautions retained for the FINALS (task #9): use reliable eval (cap
  worker counts and/or isolated re-verify best candidates); any isolated
  re-verify tool MUST co-locate benchmark data files (.dat etc.).
- Net effect of this whole investigation: the win-path verdict was
  corrected (F20: QD does not win, on clean evidence) AND the core results
  were stress-tested and found robust. The journal's characterization
  posture is now on firmer evidentiary ground than before.

## 2026-06-14 11:20 KST — Descriptor profile FROZEN (task #6): trio stays, per rule

- Applied the predeclared bake-off freeze rule (journal_narrative.md
  §"Why the descriptor axes mean something") to the bake-off data
  (F12 / exp/fast_iter/bakeoff_verdict/descriptor_bakeoff.json).
- Rule: rank candidate profiles by QD-vs-classic paired best-quality
  delta; winner must ALSO pass occupancy>=0.25 median + collapse gates +
  plain-language design meaning per axis; ELSE the fallback trio stays.
- Data: best-quality delta activity -0.103 > simple_2d -0.131 > trio
  -0.177 > graph -0.186 (none beats classic). Collapse (M9, lower=better):
  simple_2d 2 < graph 8 < activity 12 < trio 14. Occupancy floor: all pass.
- Application: activity ranks 1st on quality but its 3 axes collapse on
  3-5/6 problems (fails collapse gate) AND require dynamic icarus_vcd
  metrics incompatible with the verilator harness; simple_2d is
  collapse-healthy but its axes (wire_count_log_est, assign_count) are
  code-size proxies, not the architectural BD thesis; graph_testability is
  worst on quality. No candidate qualifies as a winner.
- DECISION: FREEZE journal_logic_ff_width_3d (logic_depth, ff_depth,
  comb_width_log) - the fallback trio - exactly as the rule prescribes.
- Manuscript disclosures (predeclared): (a) comb_width_log correlates with
  area by construction -> name it a size proxy, drop its diversity claim,
  keep logic_depth + ff_depth as the diversity axes (the precise
  correlation number to be reported from the descriptor report); (b) the
  frozen thesis profile is NOT the most collapse-resistant (simple_2d is)
  - BD sophistication did not buy diversity health (a characterization
  finding, F12), to be stated honestly rather than hidden.
- This is a rule-driven decision (not free judgment): the predeclared
  rule + data force the trio. The one judgment (simple_2d's axes lack
  thesis design-meaning) is documented transparently.
- Unblocks the finals' descriptor config (task #9). The locked
  data/configs/qd_descriptor_profiles.yaml is unchanged (it holds all
  profiles); the FROZEN CHOICE for finals = journal_logic_ff_width_3d.

## 2026-06-14 11:35 KST — Remaining finals decisions SETTLED (MDE, budget, equiv)

- User opted to keep going autonomously (settle decisions -> finals ->
  manuscript, committing budget as needed). Settled the 3 remaining P4
  freeze decisions; all simplify because QD does NOT win, which moots the
  power/budget concerns for a positive claim:
  1. MDE ratchet -> keep 13x5; DROP the +0.03 best-quality WIN gate as
     moot. Under-power (MDE 0.12) only bites a small positive-win claim,
     which we aren't making. F1 deficit reported descriptively with
     cluster-bootstrap CIs; F2 within-QD parity uses the one-sided bound
     (CI low > -0.03), already passed tight at 3-seed pooled
     ([-0.006,+0.030]); 5 seeds only tightens. No count ratchet (saves
     budget).
  2. Budget-matching (M2) -> disclose asymmetry; no token-matched re-runs.
     F1 holds DESPITE QD's +12-38% token advantage (conservative); F2 is
     within-QD, verify token comparability + disclose.
  3. Equivalence spot-check (M7) -> restrict to fully-specified problems;
     don't-care NOT_PROVEN noted as a method limitation, not a defect.
- Net: ALL freeze decisions are now resolved (profile=trio, MDE, budget,
  equiv). The only remaining execution is the 5-seed finals (#9) and the
  manuscript (#15). Next: build + launch the finals (seeds 1004-1005 for
  the F1/F2 arms) replicating the matrix arm configs exactly, with the
  M12 safeguard (isolated re-verification of best candidates).

## 2026-06-14 13:40 KST — F21: stronger-model (deepseek-v4-pro) capability probe LAUNCHED

- User suggestion: if gpt-oss-120b fails on hard tasks (RealBench), try a
  stronger model - DeepSeek, available via API + .env. Excellent idea: the
  F18-F20 ceiling is gpt-oss-120b-SPECIFIC; a stronger model could reopen
  the win-path.
- Confirmed access: .env has DEEPSEEK_API_KEY; run_backend supports
  --api_backend deepseek (base_url api.deepseek.com); direct API offers
  deepseek-v4-pro (flagship, reasoning) + deepseek-v4-flash. Preflight on
  v4-pro returned content (DSV4_OK) + reasoning tokens.
- Probe: exp/fast_iter/deepseek_capability_probe, classic arm,
  deepseek-v4-pro, on the 3 modules gpt-oss FAILED - decode (53KB, 100%
  mismatch), disp (14KB, 21% closest), branchslv (5.9KB, 25%). pop 6,
  1 gen, max_tokens 64000, seed 42. LOW concurrency (2-way) to avoid
  contending with the running gpt-oss finals (M12).
- PRE-REGISTERED interpretation (M6, decided before result):
  * GAIN: v4-pro gets >=1 valid on a gpt-oss-0 module (esp decode/disp)
    -> win-path REOPENS -> DeepSeek QD-vs-classic on the viable modules
    (potential Branch A/B headline). Same-provider rule: DeepSeek on BOTH
    arms.
  * MODEL-GENERAL: v4-pro also 0 valid -> ceiling is not just a weak
    model; large-CPU RTL is hard for current LLMs -> strengthens the
    characterization.
- CAVEAT: isolated-re-verify any "valid" v4-pro candidate (M12) before
  trusting; small modules have weak coverage (alu_csrctrl 27 samples, F20).
- This does NOT change the gpt-oss-120b core results (F1/F2 finals running
  separately); it tests model-generality of the RealBench-large ceiling.
  If DeepSeek reopens the win-path, the journal story could shift from
  pure characterization toward a scale-dependent win - a major upside.
- Two background jobs now: gpt-oss finals (bo03wrum8), DeepSeek probe
  (bbnvi9ucq). Both notify on completion.

## 2026-06-14 14:00 KST — F21 verdict (DeepSeek) + F22 launched (smooth QD)

- F21 DeepSeek probe VERDICT (isolated re-eval, classic, 12 cand/module):
  deepseek-v4-pro vs gpt-oss-120b: decode 0 valid 100% vs 100% (unchanged);
  disp 0 valid 6.35% vs 21%; branchslv 0 valid 7.69% vs 25%. A stronger
  model gets MUCH closer on mid/small modules (~3x lower mismatch) but
  STILL 0 valid; largest module unchanged/hopeless. Leans MODEL-GENERAL
  (win-path doesn't cleanly reopen - no valid candidate = no PPA compare),
  but the 6-8% on disp/branchslv is close -> more attempts MIGHT cross
  (uncertain lever). Manuscript value: a model-strength GRADIENT
  strengthens the criticism-#4 characterization.
- F22 SMOOTH QD (user idea) LAUNCHED. Realization: ALL prior QD arms used
  representation_kind=thought_only (the radical break blamed for the loss,
  F7/F8). The default representation_kind=code_individual (DIRECT code) was
  NEVER tested as a QD arm. The smooth config -
  revolution_qd + code_individual + eoh_strategies (classic operators) +
  qd_champion_lane_fraction 0.5 + frozen BD-trio archive - is classic's
  quality machinery WITH a MAP-Elites diversity overlay, removing the
  indirection while keeping the archive (F12: archive is not the PPA
  lever). Hypothesis: classic-parity quality + diversity -> salvages QD as
  a POSITIVE contribution (parity+diversity, not "QD wins quality").
  Running: code_individual QD seed 1001 vs existing classic seed 1001 on
  the 13-problem fast subset (exp/fast_iter/smooth_qd_code_individual,
  ba2bipcz3, low concurrency to protect the finals). Config validated
  (accepted: code_individual + revolution_qd + eoh + champion lane 0.5).
- Synthesis of the two user ideas: (1) stronger model (DeepSeek) eases but
  does not remove the large-module ceiling; (2) smooth QD integration is
  the more promising path to a POSITIVE QD contribution on the small
  benchmarks where candidates ARE valid. If F22 reaches parity, the
  journal gains a real QD contribution beyond pure characterization.
- Three jobs tonight: gpt-oss finals (bo03wrum8, running), DeepSeek probe
  (bbnvi9ucq, DONE), smooth-QD (ba2bipcz3, running).

## 2026-06-14 14:15 KST — Smooth QD integration track DESIGN DOC (doc 16)

- User refined the smooth-integration idea: drop thought_only + unified
  operator; build on light MAP-Elites overlay + Pareto cells + NSGA-II
  non-domination-RANK selection (fill rank 1,2,... to a cap, crowding-
  distance tie-break within the cut-off rank). Keep classic performance;
  answer methodological criticisms (#1 weighted-sum bias, #5 diversity).
  Keep code un-convoluted; record specs in detail.
- Wrote docs/journal_features/16_smooth_qd_integration_track.md: design
  principles, a variant ladder (V0 classic baseline; V1 = code_individual
  overlay = the running F22; V2 = +NSGA-II global rank selection, spec'd;
  V3 = overlay-weighting knobs), the NSGA-II selection algorithm spec,
  a codebase-support inventory, a minimal flag-gated implementation plan
  (<=1 flag + 1 helper, reusing pareto_analysis.dominates/pareto_ranks +
  engine._crowded_tournament), the evaluation protocol (vs classic,
  frozen parity rule, M12 reliable eval, same provider), and the reframed
  POSITIVE contribution ("QD as a parity-quality diversity augmentation").
- Codebase inventory confirms the building blocks EXIST: code_individual
  representation (default, untested as QD), pareto_front cells,
  dominates/pareto_ranks (non-domination), _crowded_tournament (crowding).
  V1 needs ZERO new code; V2 needs ~1 flag + ~1 helper (clean).
- SEQUENCING decision: get V1's result first. If V1 reaches parity, the
  core thesis is proven with no new code and V2 only strengthens the
  methodology story; if V1 has a residual gap, V2 (better selection) is
  the rescue. Do NOT implement V2 before V1's result (avoid premature/
  convoluted code). thought_only + unified operator are dropped per user.

## 2026-06-14 14:30 KST — F22 PRELIMINARY signal (3/13): code_individual QD ~ parity

- Early best-quality read on the first 3 completed V1 problems (from
  generation_ppa.best_score, max across gens), code_individual-QD vs the
  existing classic seed 1001:
  * Prob004_adder_8bit: QD +0.330 = classic +0.330 -> +0.000 (PARITY)
  * Prob024_fsm:        QD +0.683 = classic +0.683 -> +0.000 (PARITY)
  * Prob015_multi_pipe_8bit: QD +0.027 vs classic +0.236 -> -0.209
  mean -0.070 (driven entirely by Prob015); 2/3 EXACT parity.
- STRONG preliminary support for the user's smooth-integration thesis:
  removing the thought_only indirection (code_individual) + keeping
  classic operators + champion lane (0.5) + the BD archive recovers
  classic-PARITY on most problems - vs thought_only QD which lost
  EVERYWHERE (F1 -0.08..-0.13). The indirection WAS the main culprit.
- Residual deficit is CONCENTRATED on a PPA-margin problem (Prob015
  pipelined multiplier), consistent with F4 regime-sensitivity (QD weaker
  where exploitation matters more than exploration). This is exactly the
  pattern V2 (NSGA-II global rank selection, preferring high-quality
  rank-1) or champion-lane-fraction tuning (more exploitation) could
  address.
- CAVEAT: only 3/13 problems; success-count proxy showed QD with fewer
  total successes (expected - QD trades exploitation for exploration).
  The full 13-problem paired delta (computed when V1 finishes) is the
  decision metric; isolated re-verify best candidates (M12) before final.
- Implication for the track (doc 16): if the full V1 lands near parity
  with a concentrated PPA-margin deficit, V2 (NSGA-II selection) is
  warranted as a targeted fix for those problems - and the residual is a
  diagnosable, addressable pattern, not a diffuse failure.

## 2026-06-14 14:45 KST — F22 fuller read (8/13): closer but not parity; V2 warranted

- The rosy 3/13 read (2/3 exact parity) was optimistically partial. Fuller
  8/13 best-quality read (generation_ppa.best_score, max across gens),
  code_individual-QD vs classic seed 1001:
  TIE: Prob004 +0.000, Prob024 +0.000, Prob098 +0.000
  QD+: Prob041 +0.006, Prob049 +0.004
  QD-: Prob015 -0.052, Prob037 -0.150, Prob045_alu -0.256
  MEAN -0.056 (2W/3L/3T), 5/8 within the parity band.
- READ: code_individual-QD is CLEARLY better than thought_only QD
  (F1 -0.08..-0.13) - removing the indirection helped a lot - but is NOT
  yet at parity. The residual deficit is CONCENTRATED on 3 PPA-margin /
  exploitation-heavy problems (alu, parallel2serial, multi_pipe), the same
  F4/F7 regime where the archive's diversity-exploration costs
  exploitation. NOT a diffuse failure.
- IMPLICATION: V2 (NSGA-II global non-domination-rank selection, doc 16)
  is WARRANTED - it preferentially selects high-quality rank-1
  individuals, directly targeting the exploitation deficit on those
  problems. Alternatively/additionally, raising qd_champion_lane_fraction
  (more exploitation) is a cheap knob. The user's NSGA-II idea is
  well-motivated by this exact residual pattern.
- CAVEATS: single seed; run-reported best_score (not yet isolated
  re-verified, though V1 ran at low 3-way concurrency so M12 risk is low);
  8/13 problems (full 13 + the launcher's proper cluster-bootstrap CI
  pending - the CI, not the mean, is the frozen parity verdict, and at
  -0.056 mean with high per-problem variance the CI low COULD still be
  within -0.03). Decide V2-as-rescue vs V2-as-strengthener on the proper
  stats.
- NEXT: let V1 finish (full 13 + stats_vs_classic_1001 paired CI), then
  implement V2 cleanly per doc 16 (1 flag + 1 helper + unit test).

## 2026-06-14 15:15 KST — V2 (NSGA-II global selection) IMPLEMENTED

- Implemented the smooth-QD V2 selection mode (doc 16, user-proposed),
  commit 0ee4a8a983. Flag qd_parent_selection={cell_crowded_tournament
  (default), nsga2_global_rank}. The nsga2 mode ranks ALL success
  members by global non-domination rank + crowding (reusing the existing
  archive.ranked_front - no new ranking math), fills rank-by-rank to
  population_size with a crowding tie-break, then draws parents (champion
  lane still applies). Routed in _sample_success_parents and
  _sample_two_success_parents. Plumbed run_backend -> revolution_backend
  -> RevolutionEngine. Kept minimal per doc 16 (1 flag + 1 helper +
  branch), well within the "don't convolute" budget.
- Validation: new unit test test_ranked_front_global_nsga2_ordering
  (global rank assignment + crowding boundary tie-break) PASSES; 227 QD
  tests pass (no regression); ruff clean; no NEW pyright errors (3
  pre-existing: scipy KS .statistic/.pvalue + a tuple[()] at engine 2740).
  CLI exposes --qd_parent_selection with choices.
- NOT launched yet: queued behind the running gpt-oss finals (bo03wrum8)
  + smooth-QD V1 (ba2bipcz3) to avoid M12 contention/budget overlap. When
  the queue frees, run V2 (code_individual + nsga2_global_rank) vs classic
  seed 1001 on the fast subset, same config as V1, per doc 16 eval
  protocol; isolated re-verify best candidates.
- Motivation recap: V1 (8/13) landed at -0.056 with the deficit
  concentrated on exploitation-heavy PPA-margin problems; V2's preference
  for high-quality rank-1 individuals directly targets that residual.

## 2026-06-14 15:30 KST — F22 V1 FULL verdict: code_individual-QD near-parity (-0.032)

- Full 13-problem V1 best-quality delta (generation_ppa.best_score) vs
  classic seed 1001: MEAN -0.032 (3W/3L/7T), 10/13 within parity band.
  Deficit entirely on 3 exploitation-heavy PPA-margin problems:
  Prob045_alu -0.256, Prob037_parallel2serial -0.150, Prob015_multi_pipe
  -0.052. Other 10: 7 ties (incl. the hard m2014_q3, fsm, gshare, fsmonehot
  at 0.000/+0.034) + 3 small wins (traffic_light +0.006, signal_generator
  +0.004, gshare +0.034).
- VERDICT: the smooth-integration thesis is substantially vindicated.
  Dropping thought_only (-> code_individual) recovered nearly all the lost
  performance: -0.10 (thought_only QD, F1) -> -0.032 (code_individual QD).
  The indirection WAS the main culprit (F7/F8). V1 is at the parity
  boundary; whether it PASSES the frozen rule (cluster-bootstrap CI low
  > -0.03) is borderline (the alu -0.256 outlier widens the CI) - the
  launcher's paired CI is the formal verdict; single seed.
- V2 (NSGA-II global-rank selection) is the targeted next step: it prefers
  high-quality rank-1 individuals, directly addressing the 3 exploitation
  problems that ARE V1's entire residual. Implemented (0ee4a8a983),
  launcher ready (exp/smooth_qd_nsga2_launch.sh), queued behind V1+finals.
- If V2 closes the residual -> parity-or-better -> a genuine POSITIVE QD
  contribution: "QD as a parity-quality diversity augmentation" answering
  criticisms #1 (weighted-sum bias, via NSGA-II) + #5 (diversity). This is
  the salvage the user proposed, now within reach.

## 2026-06-14 15:50 KST — V1 formal verdict + V2 (NSGA-II) LAUNCHED

- V1 done (rc=0). Formal paired stats (single seed 1001,
  stats_vs_classic_1001): best_quality mean_delta -0.0332,
  avg_ppa_improvement -0.0428, hypervolume -0.0155, functional_any_pass
  +0.000 (TIE), valid_ppa_any_pass +0.000 (TIE); 13 paired, 0 missing.
  KEY: V1 TIES classic on functionality (pass rate) - the deficit is
  PURELY PPA quality, and small (-0.033). Hypervolume -0.016 (better than
  best_quality) shows the archive's diversity gives reasonable coverage.
  Single seed; the cluster-bootstrap CI across seeds is the formal parity
  verdict (finals-level); the -0.033 mean is at the parity boundary.
- V2 (NSGA-II global-rank selection) LAUNCHED (bxogb4n9v),
  exp/fast_iter/smooth_qd_nsga2/seed_1001. Verified the novel
  nsga2_global_rank path runs cleanly in a real generation loop (config
  confirms qd_parent_selection=nsga2_global_rank + code_individual; no
  errors) - validates V2 end-to-end beyond the unit test. Same config as
  V1 except the selection mode, so V1-vs-V2 isolates it. Stats vs classic
  AND vs V1 emitted on completion. Low 3-way concurrency (finals still
  running). isolated re-verify best candidates after (M12).
- Hypothesis under test: NSGA-II's preference for high-quality rank-1
  individuals closes V1's residual on the 3 exploitation problems (alu,
  parallel2serial, multi_pipe) -> parity-or-better -> positive QD
  contribution. Verdict pending V2 completion (~1.5-2.5h at 3-way).

## 2026-06-14 16:10 KST — V2 (NSGA-II) interim 5/13: MIXED, not a clean win

- Early V2 vs V1 vs classic (5/13 problems, best-quality):
  Prob004 tie; Prob024 tie; Prob015_multi_pipe (residual) V2 -0.004 vs cls
  / +0.048 vs V1 -> NSGA-II CLOSED this residual; Prob037_parallel2serial
  (residual) V2 -0.228 vs cls / -0.078 vs V1 -> NSGA-II did NOT help, got
  WORSE than V1; Prob041_traffic_light V2 -0.044 vs V1 -> regressed.
- READ: NSGA-II global-rank selection REDISTRIBUTES the deficit rather than
  uniformly closing it - helps multi_pipe but regresses parallel2serial +
  traffic_light. Net on these 5 ~ wash-or-slightly-worse vs V1. The global
  rank preference may over-exploit, losing the cell-diversity that helped
  some problems. The DECISIVE Prob045_alu (-0.256, biggest residual) is
  NOT yet done - it's the swing; if NSGA-II closes alu, V2 swings to a win.
- IMPLICATION (interim): if V2 does not clearly beat V1, then V1 (the
  simpler code_individual overlay, -0.033, no selection change) is the
  better/simpler contribution - the indirection-removal was the big win,
  and NSGA-II may be an unnecessary complication. Decide on the full V2
  verdict (esp. alu) + the proper paired CI. CAVEAT: single seed, 5/13.
- Doc 16 V3 (champion-lane / overlay-weight tuning) remains as a fallback
  knob if neither V1 nor V2 cleanly reaches parity.

## 2026-06-14 16:25 KST — V2 (NSGA-II) DECISIVE (10/13): net-neutral vs V1

- V2 vs V1 vs classic, 10/13 (alu landed - the swing):
  alu: V2-cls -0.017 vs V1-cls -0.256 (+0.238 vs V1) -> NSGA-II CLOSED the
    biggest residual (preferring high-quality rank-1 worked here).
  multi_pipe: +0.048 vs V1 -> helped.
  BUT parallel2serial -0.069 vs V1 (worse); m2014_q6b -0.199 vs V1 (was
    PARITY in V1, now a big deficit - NSGA-II over-exploited, lost the
    cell-diversity that found the right spec-exact approach);
    traffic_light -0.014.
  NET: MEAN V2-classic -0.0444 vs MEAN V1-classic -0.0448 (same 10) -> a
  WASH. NSGA-II REDISTRIBUTES the deficit (exploitation gains traded for
  diversity losses) but does NOT improve the net.
- VERDICT: NSGA-II global-rank selection is net-neutral vs the simpler
  cell-crowded-tournament. So V1 (code_individual overlay, near-parity
  -0.033, NO selection change) is the BETTER contribution - same
  performance, simpler. The big win was the indirection removal (user's
  first idea); NSGA-II (user's second idea) is a clean ABLATION showing
  principled global selection trades exploitation for diversity
  (net-neutral) - a methodological data point, not the headline.
- DECISION: do NOT pursue V3 (hybrid/tuning) - V1 already achieves
  near-parity with the simplest change; per the "don't convolute code"
  rule, V1 is the contribution. Keep V2's nsga2_global_rank flag (it's a
  clean, tested option + a reportable ablation) but default stays
  cell_crowded_tournament. Both are now validated, behind one flag.
- NEXT: let V2 finish (3 left: gshare/fsm/fsmonehot, all parity in V1 ->
  net unlikely to change) + its proper CI; then the smooth-QD
  contribution = V1, needing multi-seed confirmation (finals-level) once
  the queue frees. CAVEAT: single seed.

## 2026-06-14 18:00 KST — CORRECTION: V2 (NSGA-II) is BETTER than V1 (full 13/13)

- RETRACTS the 16:25 "V2 net-neutral / V1 is the contribution" entry,
  which was based on a PREMATURE 10/13 read. The full 13/13 (V2 run
  complete, rc=0) and proper paired stats REVERSE it:
  * V2-classic best_quality -0.0109 (functional TIE, hypervolume -0.0035)
    vs V1-classic -0.0318. V2-V1 = +0.0223 (V2 BETTER).
  * V2 within parity band 12/13 vs V1 10/13.
- Why the 10/13 read was wrong: m2014_q6b read as V2 -0.199 mid-run but
  RECOVERED to +0.000 by run-end (the generation_ppa.best_score was from
  incomplete generations - the run found the good candidate late). Plus
  V2's late problems (fsm151 +0.096) favored it. So the 10/13 subset
  under-counted V2. SECOND time partial-run data misled a verdict (cf.
  F20); lesson reinforced: compute best-quality only from FULLY completed
  runs, never mid-generation.
- CORRECTED per-problem V2-V1 (13/13): alu +0.238 (V2 closed the biggest
  residual), multi_pipe +0.048, fsm151 +0.096 (V2 wins); parallel2serial
  -0.069, gshare -0.027, traffic_light -0.014 (V2 small losses); rest tie.
  Net V2 clearly ahead. The ONLY remaining real V2 deficit is
  parallel2serial (-0.219 vs classic) - likely an intrinsic-limitation
  problem (F7 localized-deficit pattern).
- CORRECTED CONCLUSION: NSGA-II global-rank selection (the user's 2nd
  idea) DOES help - V2 reaches NEAR-PARITY (-0.011, functional tie),
  better than V1 (-0.032). So the smooth-QD contribution is V2 (NSGA-II)
  - it both answers criticism #1 (principled selection) AND gives the
  best performance. V1 (code_individual alone) is the necessary first
  step (drops indirection); V2 adds the selection that closes alu.
- IMPLICATION: multi-seed BOTH V1 and V2 (seeds 1002-1003) to confirm
  (a) smooth-QD reaches parity, (b) V2 > V1 is robust (the single-seed
  V2>V1 is driven by alu +0.238 - could be seed-specific; needs seeds).
  CAVEAT: single seed; the alu win must replicate.

## 2026-06-14 18:05 KST — smooth-QD multi-seed confirmation LAUNCHED

- After the V2-is-better correction, launched the combined multi-seed
  confirmation (bn94s0so5): V1 (cell_crowded_tournament) AND V2
  (nsga2_global_rank) for seeds 1002+1003, low 3-way concurrency
  alongside the finals. Emits 3-seed pooled cluster-bootstrap CIs vs
  classic for both -> (a) does smooth-QD reach parity, (b) is V2>V1 robust
  (the +0.022 / alu +0.238 must replicate across seeds, not seed-1001
  luck). exp/smooth_qd_multiseed_launch.sh.
- This is the formal verdict step for the QD contribution (V2). Single
  seed showed near-parity (-0.011); 3-seed pooled CI low > -0.03 = parity
  claim holds. CAVEAT: best_quality from COMPLETED runs only (the
  partial-run lesson, twice-learned: F20 + the V2 10/13 error).

## 2026-06-14 ~18:40 KST — Manuscript draft spine (doc 17) for the compute wait

- Runs mid-flight (multi-seed bn94s0so5 on run 1/4; finals 3/10) - no new
  results to act on, and partial-run data is off-limits (the F20 + V2-10/13
  lesson). Used the wait for forward progress on the DELIVERABLE (#15):
  drafted docs/journal_features/17_manuscript_draft_spine.md - abstract,
  contribution list, results synthesis (claim->evidence->number), case
  study, predeclared disclosures, and the gating-before-submission list.
- It is a SPINE for the author to adapt into the journal_draft Overleaf
  submodule (LaTeX), NOT the paper itself. Single-seed numbers marked
  [seed1001]; pooled-CI-dependent claims marked [CONFIRM]. Grounded in the
  frozen narrative + doc 12 (evidence map) + doc 13/14/16. Honest framing:
  characterization spine + the positive smooth-QD parity contribution.
- Linked from the dashboard navigation. This accelerates the paper: once
  the multi-seed + finals CIs land, the numbers slot in and the spine
  ports to LaTeX, then the four-persona adversarial sign-off.

## 2026-06-14 ~19:30 KST — V1 seed 1002 (early): parity is SEED-SENSITIVE

- V1 (code_individual, cell-tournament) seed 1002 vs classic 1002, 13/13
  (lower bound, run wrapping up): MEAN -0.0553 (1W/8L/4T), 9/13 parity.
  WORSE than seed 1001's -0.033. Worst: parallel2serial -0.469 (vs -0.150
  on 1001), m2014_q6b -0.151 (vs 0 on 1001), traffic_light -0.066.
- READ: the smooth-QD parity is SEED-SENSITIVE - single-seed 1001 (-0.033)
  was optimistic; 2-seed V1 mean ~-0.044. Per-problem deltas swing widely
  across seeds (the multi-seed confirmation is doing exactly its job:
  revealing variance the single seed hid). This is V1 (the baseline
  variant); V2 (NSGA-II, the contribution, -0.011 on seed 1001) replication
  on seeds 1002-1003 is the decisive data, plus the pooled
  cluster-bootstrap CI (problems as clusters) - the FORMAL verdict, which
  accounts for this variance.
- EXPECTATION MANAGEMENT: the parity claim may land as "within the parity
  band by the pooled CI" rather than a tight -0.01; or it may not pass the
  -0.03 bar if the variance is large. Honest either way - the contribution
  framing ("parity-quality diversity augmentation") needs the pooled CI low
  > -0.03; if it lands marginally outside, the framing becomes "near-parity
  (CI [...]) with a localized residual," still a positive principled result
  vs the radical build's -0.10. CAVEAT: lower bound (13/13 data, finishing);
  V2 1002/1003 + pooled CI pending.

## 2026-06-14 ~20:30 KST — V2 seed 1002 (13/13-data LB): V2>V1 REPLICATES

- V2 (NSGA-II) seed 1002 vs V1 vs classic (13/13-data lower bound, rc
  pending): V2-classic -0.0354, V1-classic -0.0537, V2-V1 +0.0183.
  -> NSGA-II's advantage over V1 REPLICATES (seed 1001 was +0.022). Robust
  across both seeds, though the per-problem driver shifts (alu drove
  seed 1001: V2 +0.238 vs V1; parallel2serial drives seed 1002: V2 -0.371
  vs V1 -0.469 = +0.098). Net V2>V1 holds.
- Both variants are seed-sensitive on the ABSOLUTE delta: V2 seed1001
  -0.011, seed1002 -0.035 -> 2-seed V2 mean ~-0.023 (WITHIN the +-0.03
  parity band). V1: -0.032/-0.054 -> ~-0.043.
- READ: the contribution (V2) is tracking toward parity - 2-seed mean
  -0.023 inside the band, and NSGA-II robustly beats the cell-tournament
  baseline. Whether the pooled cluster-bootstrap CI low clears -0.03 is
  the formal verdict (seed 1003 pending); seed-sensitivity means the CI
  could span -0.03 - if so the framing is "near-parity (CI [...]) with a
  localized residual," still a positive principled result. CAVEAT: V2 1002
  is a 13/13-data lower bound (final could be slightly better); seed 1003
  + the stats step give the verdict.

## 2026-06-15 ~02:00 KST — 3-seed V1 baseline: NSGA-II is NECESSARY for parity

- 3-seed V1 (code_individual, cell-tournament) vs classic: seed1001
  -0.032, seed1002 -0.054, seed1003 -0.050 (13/13-data LB) -> pooled mean
  -0.045 (n=39, 28/39 within parity). V1 ALONE does NOT reach parity
  (-0.045 outside the -0.03 band).
- V2 (NSGA-II) beats V1 by ~+0.020 each seed (+0.022/+0.018 on 1001/1002)
  -> PROJECTED V2 3-seed pooled ~-0.025 (at the parity edge). So NSGA-II
  is NECESSARY, not optional: indirection-removal (V1) recovers -0.10 ->
  -0.045; NSGA-II selection (V2) closes the remainder to ~-0.025. This
  firmly settles the earlier flip-flop (V1-is-contribution was wrong on
  both data and now on 3-seed trajectory): the contribution is
  code_individual + NSGA-II together.
- FORMAL VERDICT still pending: V2 seed 1003 (run 4/4, not started) +
  the pooled cluster-bootstrap CI. The -0.025 projection is at the parity
  boundary, so the CI low could land just inside or just outside -0.03 ->
  framing is either "parity" or "near-parity (CI [...]) with a localized
  residual (parallel2serial)". Both positive vs the radical -0.10.
- CAVEAT: V1 1003 is a 13/13-data lower bound; V2 1003 pending; the
  projection assumes V2-V1 ~+0.02 holds on seed 1003.
- Finals at 6/10 arms.

## 2026-06-15 ~05:30 KST — Smooth-QD 3-seed pooled CI VERDICT (conservative LB)

- 3-seed pooled cluster-bootstrap (problems as clusters, 10k resamples,
  my DIY ahead of the launcher's official stats; V2 1003 at 13/13-data
  = conservative lower bound):
  * V2 (NSGA-II): mean -0.0263, 95% CI [-0.0768, +0.0135], n=39.
    -> NO SIGNIFICANT DIFFERENCE from classic (CI includes 0), BUT does
    NOT meet the frozen tight-parity bar (CI low -0.077 < -0.03). The CI
    is WIDE due to high cross-problem variance (the localized residual,
    esp. parallel2serial -0.2..-0.5; F7 pattern).
  * V1 (cell-tournament): mean -0.0444, CI [-0.0955, -0.0072] -> entirely
    < 0 = SIGNIFICANTLY WORSE than classic. Confirms NSGA-II is necessary.
- HONEST VERDICT (calibrating down from the single-seed optimism): the
  smooth-QD contribution (V2) is NOT a demonstrated TIGHT parity by the
  frozen rule (CI low doesn't clear -0.03). The supportable claim is
  weaker but still POSITIVE:
  "QD/MAP-Elites + NSGA-II selection as a diversity augmentation at NO
  STATISTICALLY SIGNIFICANT quality cost vs classic (3-seed pooled CI
  includes 0), closing the gap from the radical thought_only build (-0.10,
  significantly worse) and the cell-tournament variant (-0.044,
  significantly worse)." The variance is LOCALIZED (a few
  intrinsic-limitation problems), so per-problem most are at/near parity.
- CAVEAT: conservative LB (V2 1003 wrapping up) - the mean may improve
  slightly but the CI WIDTH (variance-driven) won't, so the
  not-tight-parity / no-significant-difference verdict is robust. The
  launcher's official report_journal_statistics CI (on V2 1003 rc=0) is
  the authoritative number; this DIY cluster-bootstrap is a faithful
  estimate.
- MANUSCRIPT IMPACT: doc 14/17 framing must say "no significant
  difference / near-parity with localized variance," NOT "demonstrated
  parity." Still answers #1 (principled selection) + #5 (diversity) with
  a no-significant-cost result - a defensible positive contribution, just
  honestly hedged. Consider: more seeds would tighten the CI if a
  stronger claim is needed (the variance, not the mean, is the limiter).

## 2026-06-15 ~06:30 KST — Smooth-QD multi-seed COMPLETE; verdict FINAL

- All 4 multi-seed runs rc=0 (V1+V2 seeds 1002-1003). Official launcher
  pooled stats (report_journal_statistics, 39 paired) CONFIRM my DIY
  cluster-bootstrap to 3 dp:
  * V2 (NSGA-II): best_quality -0.0247, CI [-0.075,+0.015] (includes 0,
    functional TIE 0.000, hypervolume -0.0197). = statistically
    INDISTINGUISHABLE from classic; NOT tight parity (CI low < -0.03).
  * V1 (cell-tournament): -0.0449, CI [-0.096,-0.007] (entirely <0,
    functional TIE). = significantly worse -> NSGA-II NECESSARY.
- VERDICT FINAL (no longer LB): the smooth-QD contribution is "QD +
  NSGA-II diversity augmentation at NO statistically significant quality
  cost vs a strong classic baseline (3-seed CI includes 0, functional
  tie), with NSGA-II selection necessary." Answers #1 (principled
  selection) + #5 (diversity). Honest, positive, hedged (not "tight
  parity" - variance localized to ~1 problem, parallel2serial).
- Task #18 multi-seed leg DONE. Remaining for #18: (optional) more seeds
  to chase tight parity IF wanted (variance is the limiter, not the mean);
  fold the verdict into the manuscript (#15, spine already calibrated).
- USER DECISION OUTSTANDING: accept "no significant cost" (recommended -
  defensible TCAD contribution) vs +2 seeds for a potential tight-parity
  claim. Docs (F23/doc14/doc17) calibrated to the "no significant cost"
  framing.

## 2026-06-15 ~14:00 KST — 5-SEED FINALS verdict: F1 + F2 confirmed; SCIENCE LOCKED

- All 10 finals arms effectively done (qd_target 1005 at 13/13-data, the
  last, wrapping up = conservative LB). Authoritative 5-seed pooled
  cluster-bootstrap (problems as clusters):
  * F1 (qd_target - classic): mean -0.0955, CI [-0.152,-0.038], n=65 ->
    entirely <0 = radical thought_only QD SIGNIFICANTLY LOSES. Confirms
    the conference-criticism reality at 5 seeds (was -0.08..-0.13, 2-3
    seeds).
  * F2 (qd_target - qd_six_operators): mean -0.0022, CI [-0.012,+0.009],
    n=64 -> tight, within +-0.03, CI low > -0.03 = PASSES PARITY cleanly
    (tighter than the 3-seed [-0.006,+0.030]). The operator-unification
    ablation (criticisms #2/#3) confirmed at 5 seeds.
- SCIENCE NOW LOCKED (the complete authoritative result set):
  * F1 (5-seed): radical QD loses (-0.096, CI<0).
  * F2 (5-seed): operator parity within QD (-0.002, CI [-0.012,+0.009]).
  * Smooth-QD (3-seed, F23): V2/NSGA-II no significant quality cost vs
    classic (-0.025, CI [-0.075,+0.015] includes 0; NSGA-II necessary).
  * Characterization: F3 substrate, F4 regime-sensitivity, F7 localization,
    F18-F21 RealBench-scale capability, M1-M12 methodology.
- The journal story is complete + honest: a rigorous CHARACTERIZATION
  (when/why QD helps, answering criticisms #1-4 with the missing ablation
  + RealBench-scale finding) PLUS a POSITIVE smooth-QD contribution
  (no-significant-cost diversity augmentation via NSGA-II).
- CAVEAT: qd_target 1005 is a 13/13-data LB; the launcher's official 5-seed
  stats + the final qd_target 1005 will confirm, but the CIs are
  unambiguous (F1 entirely <0; F2 tight within +-0.03). Only the manuscript
  write-up (#15, spine ready) remains.

## 2026-06-15 ~17:10 KST — FINALS rc=0; official 5-seed F1/F2 confirmed

- bo03wrum8 completed (exit 0): qd_target seed 1005 done rc=0 17:04:38,
  "matrix all done". All 5 seeds (1001-1005) of all arms complete.
- Recomputed from COMPLETED data (1005 no longer a 13/13 LB) AND ran the
  OFFICIAL report_journal_statistics 5-seed pooled. Both agree to 4dp:
  * F1 qd_target - classic best_quality -0.093, cluster-bootstrap CI
    [-0.149,-0.036], 13 clusters, sign-test p=1.3e-05, win-rate 21%.
    Per-seed -0.078/-0.101/-0.092/-0.097/-0.096 (all <0). QD SIGNIFICANTLY
    LOSES. (LB had read -0.096; final -0.093 - 1005 improved at run-end.)
  * F2 qd_target - qd_six_operators best_quality +0.001, cluster-bootstrap
    CI [-0.008,+0.011], 13 clusters, sign-test p=1.0, win-rate 48.8%
    (coin-flip). DEAD-ON PARITY. (LB read -0.002; final +0.001.)
    Per-seed +0.040/+0.006/-0.015/-0.023/-0.005.
  * Source: exp/ablation_matrix/stats/final_5seed_F1_qt_vs_classic and
    final_5seed_F2_qt_vs_six (official tool, all runs rc=0).
- Propagated official numbers + provenance (sign-test p, win-rate, source
  paths) across docs 12, 13, 17. LB numbers retired; verdicts UNCHANGED
  (the LB was a sound conservative estimate).
- SCIENCE FULLY LOCKED with official authoritative numbers. The only
  remaining work is the manuscript write-up (#15, user's Overleaf) and the
  standing user decision on whether to add +2 smooth-QD seeds.

## 2026-06-15 ~17:11 KST — DECISION: extend smooth-QD to 5 seeds (queue now free)

- Context: with the finals done (above), the only evidentiary ASYMMETRY
  left is that the headline POSITIVE result (smooth-QD V2/NSGA-II) rests on
  3 seeds while the characterization (F1/F2) rests on 5. A reviewer would
  flag the uneven seed support on the central positive claim.
- The constraint that previously deferred this (protect the finals'
  compute) is gone. Launched exp/smooth_qd_5seed_launch.sh (bg b8uiq09yz):
  V1 (cell_crowded_tournament) AND V2 (nsga2_global_rank) at seeds 1004,
  1005, MATCHED 3-way concurrency to the existing 1001-1003 smooth-QD runs
  (eval-condition consistency; avoids M12), then 5-seed pooled vs classic
  (1001-1005) for both arms -> exp/fast_iter/smooth_qd_*/stats_5seed_vs_classic.
- Purpose: bring V2's "no significant quality cost vs classic" verdict and
  the V1-vs-V2 "NSGA-II necessary" ablation to the same 5-seed standard as
  F1/F2. This STRENGTHENS an already-publishable 3-seed result; it does not
  rescue it. Does NOT change the locked F1/F2/F18-21 science.
- On completion: read 5-seed smooth-QD pooled, update F23 (doc 13), the
  posture (doc 14), and the spine (doc 17) from 3-seed to 5-seed; this also
  resolves the standing user "+2 seeds vs accept" decision in the robust
  direction. User can stop b8uiq09yz to accept the 3-seed result instead.

## 2026-06-15 ~20:00 KST — Contract-compliance verification of F1/F2 stats

- Pre-manuscript de-risk: confirmed the official F1/F2 numbers satisfy the
  FROZEN decision rule in journal_narrative.md (penalized cluster-bootstrap
  95% CI of the best-quality delta, parity = CI entirely above -0.03).
- report_journal_statistics ALWAYS computes the penalized (gate-bearing)
  mean/CI as the default `mean_delta`/`bootstrap_ci_*` fields; --gate-profile
  only toggles threshold pass/fail checks. So the numbers already in the
  docs ARE the penalized statistic. Verified penalized == complete-case for
  both F1 and F2 (no missing-treatment floor-imputation was triggered).
- F2 (operator parity): penalized CI [-0.0076,+0.0114], CI low > -0.03 PASS.
  LOSO penalized (leave-one-seed-out) parity holds in ALL 5 folds:
  drop-1001 [-0.0255,+0.0082], drop-1002 [-0.0135,+0.0109], drop-1003
  [-0.0028,+0.0121], drop-1004 [-0.0065,+0.0220], drop-1005 [-0.0081,
  +0.0154]. Worst fold CI low -0.0255 > -0.03 -> robust to any single seed.
- F1 (QD vs classic): penalized == complete-case -0.0927, CI
  [-0.1491,-0.0357], entirely <0 (loss), unchanged.
- Recorded in doc 13 (F2) + doc 12 (landed verdict). No verdict change; this
  CONFIRMS the operator-parity claim meets the frozen contract's exact
  decision rule and its robustness check. No code/data change.

## 2026-06-16 ~07:00 KST — Smooth-QD 5-SEED verdict: headline confirmed + strengthened

- b8uiq09yz done (exit 0): V1+V2 seeds 1004,1005 all rc=0; both arms now
  5-seed (1001-1005). Official report_journal_statistics 5-seed pooled vs
  classic (penalized == complete-case; DIY matches to 4dp):
  * V2 (NSGA-II, HEADLINE) - classic: -0.0161, CI [-0.045,+0.007],
    sign-test p=0.17 -> NO significant quality cost (CI includes 0). The +2
    seeds TIGHTENED the CI ([-0.077,+0.014] -> [-0.045,+0.007]) and moved
    the mean toward 0 (-0.026 -> -0.016). Per-seed robust:
    -0.011/-0.034/-0.029/+0.007/-0.014 (no outlier).
  * V1 (no NSGA-II) - classic: -0.0337, CI [-0.066,-0.009], entirely <0 ->
    significantly worse. NSGA-II necessary.
  * NSGA-II benefit (V2 - V1): +0.0176, CI [+0.005,+0.032], entirely >0 ->
    now STATISTICALLY DEMONSTRATED (not just "V1 worse vs classic").
  * Residual V2 deficit localized to PPA-margin problems: alu -0.153,
    parallel2serial -0.086 (pooled) -> a capability limit, not seed noise.
    Confirms "variance, not mean, is the limiter": tight parity (CI low >
    -0.03) is unreachable by adding seeds.
  Source: exp/fast_iter/smooth_qd_{code_individual,nsga2}/stats_5seed_vs_classic.
- IMPACT: the headline POSITIVE contribution now rests on 5 seeds, matching
  the F1/F2 characterization standard -> the evidentiary asymmetry is
  CLOSED. The standing user "+2 seeds vs accept" decision is RESOLVED: extra
  seeds improved the estimate (tighter CI, demonstrated NSGA-II benefit) but
  "no significant cost" remains the correct, final framing (not tight
  parity). Propagated to F23 (doc 13), posture (doc 14), spine (doc 17).
- The full evidence base is now LOCKED at 5 seeds: F1 (QD loses), F2
  (operator parity), F23 (smooth-QD no significant cost), F18-21 (RealBench
  capability). Only the manuscript write-up (#15, user's Overleaf) remains.

## 2026-06-16 ~08:00 KST — F24: case-study equivalence feasibility (don't-care split)

- Pre-manuscript de-risk on the case-study artifact "archive heatmap with
  equivalence-checked Pareto solutions". Ran scripts/check_equivalence.py
  (yosys equiv_make/equiv_simple/equiv_induct) on the predeclared source
  Prob135_m2014_q6b archive (8 cell solutions vs RefModule).
- RESULT: 0/8 PROVEN (all NOT_PROVEN, "1 unproven $equiv cell"). Cause is
  NOT a harness bug: the Prob135 reference has a DON'T-CARE output
  (default: Y1 = 1'bx for {y,w} >= 0xc, i.e. y in {6,7}). Candidates emit
  concrete values there -> testbench-valid (testbench only exercises
  specified inputs) but not formally equivalent to an x-output spec. This
  is exactly the case journal_narrative.md's frozen scope rule anticipates:
  "equivalence spot-check on fully-specified problems only" (doc 12).
- HARNESS VALIDATED on a fully-specified problem: Prob150_review2015_fsmonehot
  (0 don't-cares, sequential FSM) -> 1/1 PROVEN. equiv_induct handles state.
  So the tool is correct; the Prob135 result is a property of its spec.
- ACTION: case-study artifact SPLIT (recorded F24, doc 13; doc 12 + doc 17
  case-study sections). Prob135 -> archive heatmap (disclose solutions as
  testbench-validated, spec has a don't-care). Fully-specified problem
  (Prob150) -> the equivalence pass-rate the narrative requires. No single
  hard-subset VerilogEval problem is both multi-cell AND fully specified.
- Artifacts: exp/fast_iter/hard_subset_42/qd/.../Prob{135_m2014_q6b,
  150_review2015_fsmonehot}/equivalence_spotcheck/ (gitignored run outputs).

## 2026-06-16 ~10:00 KST — BLOCKER FOUND (F25): held-out final gate not yet run

- Re-reviewed state against goal_template.md (user opened it). Goal criterion
  (1) requires "QD-vs-classic resolved on HELD-OUT statistics ... never a
  tuning-set headline." The frozen narrative (journal_narrative.md L224/L232)
  requires the final gate + branch decision "Evaluated on the held-out/fresh
  final sets after the 5-seed runs"; the hard subset is explicitly a TUNING
  set.
- FINDING: the 5-seed F1 (QD-vs-classic) and F23 (smooth-QD) ran on the
  13-problem HARD SUBSET (= hard_iteration_subset.yaml, the tuning set). The
  20-problem held-out reference set (data/configs/holdout_reference_subset.yaml,
  seed 7777, disjoint from hard+fast: 9 RTLLM + 11 VerilogEval) has 0 runs.
  So the QD-vs-classic FINAL verdict is currently tuning-set-only -> goal
  criterion (1) NOT met. This corrects earlier "all experiments complete"
  statements (the ablations are complete + correctly scoped; the held-out
  FINAL GATE is the missing layer). F2 operator ablation on the hard subset
  remains correct (ablation protocol is predeclared on the tuning set).
- The ablation matrix arm configs are in exp/finals_matrix_1004_1005_launch.sh
  (classic = --backend revolution, no extra flags; qd_target = the full QD
  flag set; smooth-QD V2 = code_individual + eoh + champion_lane 0.5 +
  nsga2_global_rank). Held-out runs reuse these verbatim, swapping only the
  --problems list (the 20 held-out) and --save_path.
- Caveat surfaced: Branch C floor leg (i) requires the operator
  simplification independent of QD (F9 falsified -> within-QD only), so the
  frozen narrative predeclares venue reassessment unless the new smooth-QD
  contribution (F23) is accepted as carrying #1/#5. This is a strategic
  (venue) decision, not just compute.
- NEXT: surfaced to the user for scope confirmation before committing the
  multi-day held-out run (recorded F25, doc 13).

## 2026-06-16 ~10:30 KST — DECISION (user): do NOT run held-out gate; document the gap

- Following F25, asked the user how to scope the held-out final gate
  (classic+qd_target+V2 / classic+qd_target only / don't run). User chose
  DON'T RUN; document the gap.
- Rationale: the expected outcome is Branch C confirmed (QD loses -0.093 on
  the tuning subset -> near-certain to lose on the 20-problem held-out too),
  so the ~2-3-day held-out run is a confirmatory negative that does not
  change the story. The narrative explicitly permits reporting hard-subset
  numbers "scoped as tuning-set results."
- Documented as a DISCLOSED LIMITATION (not a hidden gap):
  * F25 reframed BLOCKER -> "SCOPED - documented limitation" (doc 13).
  * Added to doc 17 "Disclosures the paper MUST carry": QD-vs-classic (F1) +
    smooth-QD (F23) are tuning-set-scoped; held-out is future work; the
    operator ablation F2 is unaffected (tuning-set by protocol); Branch C
    floor leg (i) unmet (F9) so #1/#5 rest on the smooth-QD contribution.
  * Added to the consolidated record §1 status + §6 caveats; corrected the
    dashboard "all experiments complete" header; corrected the todo
    "5-seed final publication experiments" item.
- No runs launched. The manuscript (#15) is the remaining work; it must
  carry the held-out limitation honestly.

## 2026-06-16 ~11:30 KST — Completed goal-criteria audit; scorecard + M13

- Continued the goal_template.md re-review beyond criterion (1). Findings:
  * Criterion (2) descriptor profile: MET (F12).
  * Criterion (3) CVDP + RealBench end-to-end: RealBench MET (F18-21,
    capability_remap classic-vs-QD on e203); CVDP NOT run end-to-end (smoke
    only, exp/codeevolve_cvdp_*_smoke) -> same class as the held-out gate.
  * Criterion (4) manuscript + 4 case-study artifacts: manuscript PENDING
    (#15); artifacts ready (F24).
  * Verification surface: report_journal_statistics MET; descriptor
    health/correlation MET; manifest/seed locks + ledger MET;
    validate_journal_revamp_run.py -> classic PASS, qd_target FAIL (M13);
    four-persona v2 sign-off on full package PENDING (needs manuscript).
- M13 (NEW): ran validate_journal_revamp_run.py on the finals. classic
  seed_1001 PASS; qd_target seed_1001 FAIL (exit 1) on fatal descriptor
  collapse on 4/13 problems (adder_8bit, circuit7, fsmonehot all-axes;
  gshare zero-occupancy). This MECHANICALLY confirms the descriptor-
  degeneracy characterization (F12/root-cause dossier); the verification-
  surface "exit 0 per root" is met for classic, not QD - disclosed as the
  characterized phenomenon. Artifacts:
  exp/ablation_matrix/stats/validate_{classic,qd_target}_1001.
- Added a Goal-criteria scorecard (consolidated record §9): goal
  substantially MET as a Branch-C characterization + smooth-QD, with held-out
  (criterion 1) and CVDP end-to-end (criterion 3) SCOPED OUT as documented
  limitations, and the manuscript (#15) the remaining deliverable.
- CVDP end-to-end is the one same-class item still awaiting a user decision
  (recommend scope-out + document, consistent with held-out; #4 carried by
  RealBench). Surfaced to the user.

## 2026-06-16 ~12:00 KST — M13 upgraded to 5-seed; CVDP end-to-end scoped out

- Ran validate_journal_revamp_run.py on qd_target seeds 1001-1005 (cheap, no
  LLM). ALL 5 FAIL (exit 1) on descriptor collapse. Cross-seed pattern:
  circuit7 collapses 5/5, fsmonehot 4/5 (structural collapsers - FSM/one-hot
  designs where the trio axes barely vary); adder_8bit/gshare/m2014_q3
  sporadic 1/5. So ~2/13 problems structurally collapse the frozen trio
  across seeds. M13 upgraded MEASURED -> CONFIRMED (5-seed); this is robust
  evidence for the descriptor-degeneracy characterization (F12/root-cause).
  Artifacts: exp/ablation_matrix/stats/validate_qd_target_{1001..1005}.
- CVDP end-to-end (goal criterion 3): the user did not object to the
  recommended scope-out (surfaced last turn), so FINALIZED as SCOPED OUT -
  same confirmatory class as the held-out gate; criticism #4 is carried by
  the RealBench-scale result (F18-21). Documented in the §9 scorecard and
  doc 17 Disclosures (CVDP = integration evidence, end-to-end = future work).
- State: the goal is met AS SCOPED (Branch-C characterization + smooth-QD),
  with held-out (crit 1) and CVDP end-to-end (crit 3) as documented
  limitations. The only remaining deliverable is the manuscript (#15,
  user-authored). Autonomous experimental + verification work is complete.

## 2026-06-16 ~13:00 KST — CVDP debug probe (user greenlit): functional harness is the blocker (F26)

- User chose "Yes - debug-seed probe first" for CVDP. Ran the FIRST-EVER
  revolution+CVDP run (all prior CVDP runs used the CodeEvolve baseline).
- The path RUNS: classic seed-42 on cvdp_copilot_generic_nbit_counter_0039,
  pop4 x 2gen, 12 candidates, format/diff/syntax pass, reference-PPA + summary
  emitted (exp/cvdp_probe_precheck/classic). Invocation gotcha recorded: CVDP
  needs --cvdp_categories all (else select_cvdp_ids throws NoneType ->
  _discover_tasks asserts the id missing).
- BUT 0% functionality. CANNOT be ground-truthed here: dataset withholds the
  golden (output.response empty); reference harness is Docker-based
  (__OSS_SIM_IMAGE__) and Docker is UNAVAILABLE; per-candidate pytest.log is
  in a cleaned-up temp run_root. cocotb IS installed; the evaluator runs
  pytest locally. So genuine-difficulty vs harness-false-negative is
  UNRESOLVED.
- CONCLUSION (F26): CVDP functional testing is INFRA-blocked (cocotb harness
  validation), NOT compute-blocked. A meaningful classic-vs-QD CVDP
  comparison needs the harness validated/fixed first (F16-style, and with NO
  golden to validate against). This corrects the earlier "CVDP = confirmatory
  negative like held-out" framing: CVDP is a DIFFERENT, harder benchmark with
  an open outcome, but its eval harness is the binding constraint here.
- Did NOT proceed to the full 3-arm probe (would just produce more
  un-ground-truthable 0%s). Recorded F26, updated the §9 scorecard + doc 17.
  Decision point surfaced to the user: invest in CVDP harness validation
  (F16-style, uncertain payoff given no-Docker/no-golden) vs keep CVDP as
  integration-evidence-only. #4 remains carried by RealBench.

## 2026-06-16 ~16:00 KST — CVDP harness validated (F26 corrected); debug probe launched

- Ground-truthed the CVDP cocotb harness (re-ran all 12 classic probe
  candidates): 5/12 compile-fail, 7/12 compile+func-fail, 0 pass. The 7
  func-fails prove the harness compiles + runs the cocotb test locally
  (iverilog, SIM=icarus; NOT Docker). So F26's first conclusion
  ("infra-blocked") was WRONG -> corrected: the harness is operational and
  the 0% is GENUINE difficulty (generic_nbit_counter_0039 is a hard
  multi-mode counter). CVDP IS testable.
- De-risked the QD-on-CVDP path: qd_target 1-task pre-check ran clean (rc=0),
  produced archive_summary/qd_metrics/descriptor_health; occupied_cells=0
  because 0 candidates passed functionality on the hard task (archive only
  admits valid candidates) -> correct behavior, not a QD failure.
- Invocation gotcha recorded: CVDP runs need --cvdp_categories all (else
  select_cvdp_ids throws -> _discover_tasks asserts the id missing).
- LAUNCHED the user-greenlit debug-seed probe: classic + qd_target +
  smooth-QD V2 on the 10-task locked CVDP debug subset, seed 42, pop20x5gen,
  8-wide concurrency (moderate, to avoid M12 synth contention), then pairwise
  functional-any-pass stats. exp/cvdp_debug_probe; launcher
  exp/cvdp_debug_probe_launch.sh. Expect signal on the easier tasks (passes),
  ties at 0 on the hardest. On completion: read functional-any-pass deltas
  (classic vs qd_target, classic vs V2); if informative, scale to 5 seeds.

## 2026-06-16 ~17:30 KST — CVDP probe: perceptron_0006 context overflow; pruned to 9 tasks

- The classic arm completed 9/10 tasks but STALLED on cvdp_copilot_perceptron_0006:
  the Gen2 prompt hit 114303 input tokens (+32768 output) > gpt-oss-120b's
  131072 window -> repeated 400 context-length errors. The backend retried the
  (non-retryable) 400 fifteen times with up to 4096s (68-min) backoff -> a
  multi-hour stall. Killed the run.
- Root cause: NOT the task context (perceptron_0006's raw input is only ~5k
  tokens); it's accumulated population/candidate context at Gen2 (perceptron
  candidates are large) overflowing the window. Only perceptron_0006 bloated;
  the other 9 tasks completed. Two robustness gaps noted (backend, out of probe
  scope): (a) non-retryable 400s should not be retried with huge backoff;
  (b) prompts should be truncated to the model window.
- #4-relevant finding: CVDP tasks are large enough that some overflow
  gpt-oss-120b's 131k window during evolution - concrete evidence CVDP is a
  bigger/harder benchmark than RTLLM/VerilogEval.
- ACTION: prune perceptron_0006; relaunch qd_target + qd_v2 on the remaining 9
  CVDP debug tasks (seed 42), reuse the completed classic 9-task summaries for
  the comparison. exp/cvdp_debug_probe2.

## 2026-06-16 ~18:30 KST — CVDP debug probe DONE: 0/9 both arms (F27)

- probe2 (qd_target + qd_v2 on the 9 viable tasks, reusing classic 9) completed
  rc=0, no context overflow. RESULT: 0/9 functional pass for ALL THREE arms
  (classic 0, qd_target 0, qd_v2 0); per-task all zero.
- INTERPRETATION (F27): on CVDP (newer/harder cocotb design tasks),
  gpt-oss-120b clears the functional bar on 0/9 tasks at pop20x5gen -> QD's
  diversity cannot manifest an advantage (nothing valid to diversify). This
  MIRRORS the RealBench capability ceiling (F18-21). So criticism #4 is now
  answered by TWO independent harder benchmarks (e203 + CVDP), both showing
  the LLM-capability wall, not a search-structure limit.
- Validation level: harness confirmed to compile + run cocotb assertions
  (F26, 7/12 reached assertions); no PASS observed (CVDP withholds goldens).
  Residual validation = hand-write one correct solution + confirm PASS
  (attempting next, time-boxed). Recorded F27, scorecard updated.

## 2026-06-16 ~19:30 KST — Close the gap: smooth-QD V2 vs classic on RealBench (user-greenlit)

- User chose to close the one experimental gap: smooth-QD V2 (code_individual
  + NSGA-II, our chosen method) was never run on RealBench (only classic +
  qd_target were, F20). Then move on to manuscript artifact prep.
- LAUNCHED V2 on the same 7 dependency-complete e203 modules, same budget/seed
  as the classic + qd_target arms (pop8 x 1gen, seed 42, RealBench_v4_synth,
  max_tokens 64000). exp/fast_iter/capability_remap/qd_v2; launcher
  exp/capability_remap_v2_launch.sh.
- On completion: grade V2's candidates with exp/grade_mismatch_compare.py
  (isolated re-eval per candidate = the M12 mitigation; reliable regardless of
  run concurrency), compare valid counts + min-mismatch to classic (4 valid,
  small modules only) and qd_target (2 valid). EXPECTATION: V2 also bounded by
  the capability ceiling (~0-2 valid, 0 on large) -> confirms no method beats
  classic on RealBench; completes the #4 "our chosen method on both harder
  benchmarks" story. Then: manuscript artifact prep (tables + case-study figs).

## 2026-06-16 ~20:00 KST — Gap closed: smooth-QD V2 on RealBench (F28)

- V2 (code_individual + NSGA-II) ran on the 7 e203 modules (pop8x1gen, seed
  42), graded by isolated re-eval (exp/grade_mismatch_v2.py). TOTAL valid:
  classic 4 >= qd_v2 3 > qd_target 2 - all valids on the 2 smallest modules
  (alu_csrctrl, alu_rglr); 0 valid on all 5 larger modules for every arm.
- V2 > qd_target (the radical thought_only) is consistent with V2 being the
  better QD form; V2 < classic (still doesn't beat it). V2 got closer on
  longpwbck (min-mismatch 0.66 vs classic 0.86) - diversity narrowing the gap
  but not crossing. Caveat: small-module coverage is weak (F20), so the robust
  reading is "no method beats classic; all 0 on large", not the precise 4/3/2.
- COMPLETES the #4 story: on BOTH harder benchmarks (RealBench F28 + CVDP
  F27), our chosen method V2 does NOT beat classic; the binding limit is LLM
  capability, not search. Recorded F28; updated §0 + scorecard.
- NEXT (per user plan): manuscript artifact prep (result tables + RealBench/
  CVDP capability table + 4 case-study figures).

## 2026-06-16 ~20:30 KST — Manuscript artifact prep (tables + figures)

- Per the user plan (after closing the V2-on-RealBench gap), began manuscript
  artifact prep -> docs/journal_features/manuscript_artifacts/ (drop-in for the
  Overleaf; mechanical generation, not prose).
- scripts/build_manuscript_tables.py -> tables.tex: Table 1 (5-seed hard-subset
  contrasts F1/F2/F23/F3 with CIs + sign-p, read from the stats JSONs) and
  Table 2 (RealBench+CVDP capability counts from the grading artifacts).
- scripts/build_manuscript_figures.py -> figures/: scalar_vs_qd_Prob135.pdf
  (classic 0.035 vs QD 0.123 trajectory) + archive_heatmap_Prob135.png (the
  healthy 6-cell archive, logic_depth x comb_width_log, best 0.123). Both
  verified sensible.
- README.md documents artifacts, regeneration commands, caption caveats
  (comb_width_log size-proxy; Prob135 is a regime-positive case not the
  aggregate), and the 2 still-bespoke figures (thought-lineage Prob116,
  failure panel Prob045) with source dirs.
- Both scripts pass ruff. Manuscript (#15) now has reproducible drop-in
  tables + 2 of 4 case-study figures; the bespoke 2 + the prose are the
  user's to finish in Overleaf.

## 2026-06-16 ~21:00 KST — Root-cause-at-scale analysis (F29) + CVDP easy-tier probe launched

- Recorded F29 (ANALYSIS): why classic AND QD fail on harder benchmarks. The
  framework is a search/refinement layer that amplifies base-LLM capability;
  on hard designs the base LLM yields ~0 valid seeds (model-general, F21), and
  RTL correctness is near-binary (best failing candidates 20-100% mismatched -
  a chasm, not a climbable gradient), so QD diversity = diverse-wrongness with
  no stepping stones. Binding constraint = base capability + discontinuous
  landscape, not search. This is the manuscript's future-work/limitations
  content.
- Highest-leverage future-work lever, LAUNCHED: CVDP EASY tier (the dataset
  has 162 easy tasks; we only tested medium = 0/9). Tests classic vs smooth-QD
  V2 on 10 smallest-context easy tasks (seed 42, pop20x5gen, 8-wide), the one
  untested CAPABLE-BUT-HARD regime where QD's diversity could help. If V2 >=
  classic there, #4 gains a "QD helps where the LLM is capable" result.
  exp/cvdp_easy_probe; launcher exp/cvdp_easy_probe_launch.sh.
- On completion: read functional-any-pass (classic vs V2). Other levers
  (stronger model, hierarchical generation, richer feedback) recorded in F29
  as future work.

## 2026-06-16 ~22:00 KST — F30: CVDP "ceiling" was an interface-wiring confound; FIXED

- Ground-truthing the easy-tier 0/10 (classic 0/10 even on trivial
  binary_to_gray) exposed an F19-class confound. build_cvdp_problem_context
  set problem_description = input.prompt ONLY, dropping input.context (the
  buggy module to edit + its exact interface binary_in/gray_out/WIDTH). The
  model invented port names (binary/gray/N) -> every candidate failed the
  cocotb harness on INTERFACE MISMATCH regardless of logic.
- Proof: (1) a probe candidate had correct logic (gray=bin^(bin>>1)) but wrong
  ports; (2) a hand-written correct-interface solution PASSES the harness
  (rc=0 -> harness sound, CAN pass); (3) with the fix, candidates now emit the
  correct interface (binary_in/gray_out/WIDTH confirmed in the re-run).
- FIX (committed): thread input.context source files into the prompt +
  preserve-interface instruction + regression test (6/6 CVDP tests pass; ruff
  + pyright clean on the module). Killed the confounded easy probe.
- CONSEQUENCE: F27/F28/§0 CVDP "capability ceiling" is RETRACTED pending the
  fixed re-run -> CVDP is testable + likely largely solvable; the fixed re-run
  gives the true classic-vs-QD signal (the capable-but-hard regime). RealBench
  (F18-21) UNAFFECTED (interface provided there; real large-design ceiling).
- Live re-validation (binary_to_gray, fixed): candidates now have the correct
  interface; functional pass-rate confirmation + the full fixed CVDP re-run
  (classic vs V2, easy+medium) are the next steps.

## 2026-06-16 ~22:30 KST — F30 end-to-end confirmed; M14 (run under-reports CVDP)

- Live re-validation (binary_to_gray, fixed prompt): the LLM's candidate is
  correct + lint-clean + right-interface (binary_in/gray_out/WIDTH) AND PASSES
  the cocotb harness in ISOLATED re-eval (rc=0). So F30 is confirmed end-to-end:
  CVDP is solvable; the "capability ceiling" was the interface confound.
- M14 (NEW): the IN-RUN CVDP functional eval reported functionality=0.0 for
  that same isolated-passing candidate -> the in-run path under-reports passes
  (M12-class). The feedback-LLM "testbench missing" is the M6 hallucination
  (harness is present + sound). IMPLICATION: CVDP classic-vs-QD must be graded
  by ISOLATED re-eval (per-candidate harness materialization + pytest), like
  F20 for RealBench - NOT the run's counts.
- NEXT: write a CVDP isolated-grading script (analogue of grade_mismatch_compare.py)
  + run the fixed classic-vs-V2 easy-tier comparison, grade by isolation -> the
  TRUE QD-vs-classic signal in the capable-but-hard regime (the original goal of
  the easy-tier probe, now unblocked by the F30 fix).

## 2026-06-16 ~23:30 KST — F31: fixed CVDP easy tier — classic 9/10 = V2 9/10 (QD doesn't help in capable regime)

- Ran fixed-prompt classic + smooth-QD V2 on the 10 easy CVDP tasks (seed 42,
  pop20x5gen), graded by isolated re-eval (exp/grade_cvdp_isolated.py, after
  fixing it: process-group kill + 25s timeout + early-exit any-pass + 30-cap;
  the first grader stalled for an hour on hanging sims with ineffective
  timeouts -> orphan vvp zombies).
- RESULT: classic solves 9/10, V2 solves 9/10 (both miss only perfect_squares)
  -> grade_cvdp_easy.json. F30 CONFIRMED AT SCALE (LLM is capable on easy CVDP
  with the interface; the 0/9-0/10 was the confound). And QD does NOT help in
  the capable regime: classic = V2 = 9/10 (consistent with F1).
- The "capable-but-hard sweet spot" (F29 hypothesis) did NOT materialize: easy
  CVDP is capable-and-easy. So across the difficulty spectrum QD ties (small/
  easy) or is capped (hard RealBench), never wins. Recorded F31; rewrote the
  convoluted §0 #4 bullet cleanly; updated the §9 scorecard.
- CVDP thread CLOSED: F30 (confound found+fixed+tested) + F31 (capable-regime
  tie). Net: a stronger, coherent #4 story (QD doesn't win on a newer working
  benchmark either), with a real bug fix shipped (fix(cvdp) commit).

## 2026-06-16 ~23:55 KST — CVDP MEDIUM tier (fixed): the actual capable-but-hard test

- Correcting my prior "medium re-run = low value" call: easy CVDP was
  capable-AND-easy (both 9/10, tie — no room for QD). The MEDIUM tier is the
  genuine capable-but-hard regime (LLM may solve SOME but not all) -> the one
  place QD's diversity could actually help (the F29 sweet-spot hypothesis).
  So it IS the highest-value remaining experiment.
- LAUNCHED classic + smooth-QD V2 (fixed prompt, F30) on 10 smallest-context
  medium tasks (scrambler, fifo_async, factorial, bus_arbiter, neuromorphic_
  array, ...; seed 42, pop20x5gen). Selected by prompt+module size < ~6k
  tokens to avoid context overflow (the F30 fix lengthens prompts by adding
  input.context, so overflow risk rises on larger designs - perceptron
  excluded). exp/cvdp_medium_fixed; launcher exp/cvdp_medium_fixed_launch.sh.
- On completion: grade by isolated re-eval (exp/grade_cvdp_isolated.py).
  OUTCOMES: if the LLM solves some-but-not-all AND V2 > classic -> the
  long-sought "QD helps in the capable-but-hard regime" result (flips #4 to a
  positive). If V2 = classic -> reinforces "QD never wins" across the full
  spectrum. Either way it's the decisive test of the remaining open hypothesis.

## 2026-06-17 ~00:30 KST — F32: CVDP medium (capable-but-hard) — 7/10 tie; sweet-spot FALSIFIED

- Graded the fixed medium-tier run by isolated re-eval: classic 7/10, V2 7/10,
  solving the EXACT SAME 7 tasks and missing the SAME 3 (bus_arbiter,
  fifo_async, neuromorphic_array). exp/cvdp_medium_fixed/grade_cvdp_medium.json.
- Medium is genuinely the capable-but-hard regime (7/10 < easy 9/10), and even
  there QD ties classic -> the F29 sweet-spot hypothesis is FALSIFIED. QD found
  no solution classic missed.
- COMPLETES the #4/QD characterization across the FULL spectrum: small (F1
  lose / F23 no-cost), easy CVDP (9/10 tie), medium CVDP capable-but-hard (7/10
  tie), hard RealBench (capability ceiling). QD is a no-significant-cost
  diversity augmentation, NEVER a winner anywhere tested. Recorded F32; updated
  §0 + the sweet-spot note (F29). Caveat: any-pass, seed 42 (debug); finer
  pass-rate not run but identical solved-set is a strong negative.
- The CVDP arc end-to-end: integration confound found (F30) + fixed + tested,
  then easy (F31) + medium (F32) -> CVDP is a working benchmark on which QD
  ties classic. Net: a real bug fix shipped + a clean, complete #4 story.

## 2026-06-17 ~01:00 KST — Drafted the manuscript Results section (user-requested)

- User chose "draft a manuscript section". Wrote a prose DRAFT of the Results
  section -> docs/journal_features/manuscript_artifacts/draft_results_section.md
  (for the author to adapt into Overleaf; NOT pushed there).
- Structure: 5.1 setup; 5.2 operator simplification (F2, substrate-dependent
  F3); 5.3 smooth-QD no-significant-cost + NSGA-II necessary (F23); 5.4 radical
  QD loses + regime sensitivity (F1/F4/F7); 5.5 harder-benchmark capability
  (RealBench F18-21/F28 + CVDP F30/F31/F32); 5.6 summary; + predeclared
  Limitations (F25 held-out, M2 budget, eval artifacts, M13, CVDP granularity).
- Calibrated to the frozen narrative (no-significant-cost not win; tuning-set-
  scoped per F25). All numbers verified against doc 13 / tables.tex. Listed in
  the manuscript_artifacts README.

## 2026-06-17 ~01:30 KST — Drafted Abstract+Contributions and Discussion+Conclusion

- Continued the manuscript-section drafting (user-directed). Added to
  docs/journal_features/manuscript_artifacts/ (drafts for the author; NOT pushed
  to Overleaf):
  * draft_abstract_contributions.md — polished Abstract + 5-item Contributions,
    incorporating the completed CVDP arc (F30-F32); supersedes the doc-17 spine
    sketch.
  * draft_discussion_conclusion.md — Discussion (§6.1 why QD doesn't win, the
    F29 mechanism; §6.2 operator simplification; §6.3 negative-result framing;
    §6.4 future work) + Conclusion (§7).
- All calibrated to the frozen narrative; numbers verified. Listed in the
  manuscript_artifacts README. Remaining draftable sections: Methods (stats
  protocol, benchmarks, eval-reliability disclosures) and Introduction.

## 2026-06-17 ~02:00 KST — Drafted Methods + Introduction; core manuscript narrative complete

- Added draft_methods_section.md (§3: framework/knobs, frozen descriptors,
  benchmarks/locked subsets, paired-cluster-bootstrap protocol + parity rule,
  functional eval + reliability disclosures + tool versions) and
  draft_introduction_section.md (§1: context, the conference REvolution, the
  five criticisms, the characterization framing).
- The manuscript draft package now covers the FULL core narrative: Introduction,
  Methods, Results, Discussion, Conclusion, Abstract, Contributions (+ tables.tex
  Tables 1-2 + 2 case-study figures). All drafts in manuscript_artifacts/, for
  the author to adapt into Overleaf (NOT pushed there), calibrated to the frozen
  narrative, numbers verified.
- Deliberately NOT drafted (author-owned): Related Work (needs real citations -
  avoided to not fabricate references), the 2 bespoke figures (thought-lineage,
  failure panel), and final Overleaf assembly/refinement.

## 2026-06-17 ~02:30 KST — Repo hygiene: cleared 35k unreachable loose objects

- The git gc warning printed on every commit (~50x this session) was from
  unreachable pre-amend commit objects accumulating (35,180 loose objects).
  Removed the stale .git/gc.log and ran `git gc --prune=now`: loose objects
  35,180 -> 0, HEAD unchanged (fb33e132), branch + all reachable commits
  intact (git fsck clean). Future commits no longer print the warning.
  Safe maintenance only — no content or history change.

## 2026-06-17 ~17:00 KST — Generated human-readable experiment reports + index

- Generated readable summary reports for the headline experiments behind the
  consolidated-record §7 evidence index, so the per-problem / per-task results
  can be inspected without reading raw JSON.
- QD/ablation comparisons (F1, F2, F3/F9, F23-V2, F23-V1): cross-arm
  `backend_comparison.md` bundles via `scripts/report_final_analysis_bundle.py`
  on seed 1001 (representative; pooled gate stats stay in each
  `statistical_tests.md`). All five confirm `classic` as multi-objective winner.
  Written to each comparison's `…/final_analysis_seed1001/`.
- CVDP/RealBench: authoritative isolated-grade per-task tables. Added a new
  committed reporting script `scripts/render_grade_summary.py` (+ test
  `tests/scripts/test_render_grade_summary.py`, 3 cases, pytest/ruff/pyright
  clean) that renders the grade JSONs (auto-detects CVDP vs RealBench schema,
  merges disjoint arms). Produced `grade_realbench_summary.md` (classic 4 /
  qd_v2 3 / qd 2 valid of 112; F29 chasm visible in the `best` column),
  `grade_cvdp_easy_summary.md` (9/10 = 9/10), `grade_cvdp_medium_summary.md`
  (7/10 = 7/10, identical task-by-task).
- KEY CAVEAT enforced in the reports + index: for CVDP/RealBench the in-run
  `report_generator` functional column under-reports (M12/M14); the
  isolated-grade summary is authoritative. The in-run `report_generator`
  per-benchmark tables were also generated (syntax/synth/PPA value) but flagged.
- Indexed everything in a new committed doc
  `revamp_history/.../experiment_reports_index.md` (finding -> report path ->
  headline number -> what-to-look-for + regenerate commands); added pointers
  from consolidated-record §7 and doc 13's header.
- The generated reports live next to runs under `exp/` (git-ignored, like the
  runs); the committed artifacts are the renderer, its test, the index, and the
  pointers. No experimental conclusions changed — this is presentation only.

## 2026-06-18 — Colleague progress briefing (v2-journal-vs-classic) assembled

- Built a self-contained weekly briefing for colleagues at
  `revamp_history/.../20260618_briefing/` (README.md + exp_artifacts/).
- Recovered the original "v2 journal proposal vs classic" evidence from the
  per-feature journal worktrees (`.worktrees/journal-*`, `qd-theory-grounded-*`)
  via 4 parallel extraction agents reading each run's `backend_comparison.md` /
  `final_analysis`. Confirmed the integrated v2 run
  (`journal-ks-adaptive-rebinning/.../journal_adaptive_rebinning_hard_subset/20260513_153507`,
  13-prob hard subset, pop20/gen5/seed42, 240 calls/design): classic +27.6%
  score / +34.5% PPA / HV 0.104 vs v2 +15.6% / +19.1% / HV 0.063.
- Copied 20 report files into `20260618_briefing/exp_artifacts/` (numbered
  01–10: integrated v2, the 5 component ablations, the Rent's-exponent BD
  variant, the landing smooth-QD V1/V2, the locked 5-seed F1, CVDP/RealBench)
  with an index README mapping each to its source worktree path + significance.
- Key accuracy note logged for the briefing: the integrated ks-adaptive arm uses
  `representation_kind=code_individual` (default) + single thought-operator; the
  *thought-only* piece is isolated in 02 and run rigorously as the 5-seed
  `qd_target` (−0.093 best-quality). The component analysis localizes the
  regression to thought-only (raises pass@1 67.9 vs 49.7 but lowers PPA +21.9 vs
  +37.0 — blocks code hill-climbing) + the single operator (fails the func gate,
  −0.186); the archive is benign (quantile binning individually wins).
- Briefing presents the landing progression (v2 −0.093 → smooth V1 −0.034 →
  smooth V2 −0.016 parity) and a where-next / narrative section. All numbers
  spot-verified against the copied artifacts; all relative links resolve.
  Presentation/synthesis only — no new experiments, no conclusions changed.

## 2026-06-18 — RealBench reference PPA: diagnosis + generation started (M15)

- Diagnosed why RealBench produced no PPA-improvement scores. Root cause:
  reference PPA was never generated — the engine reads it only from
  pre-synthesized `<root>/<problem>_ppa.txt` (algorithm.py:_calculate_reference_ppa);
  RTLLM ships 46 such files, RealBench shipped 0. Proved (hands-on Yosys→OpenROAD)
  the golden synthesizes cleanly (alu_csrctrl area 225 µm² / power 1.11e-4 W), so
  this was an un-run generation step, not a limitation — operationalizing the
  feasibility M8/M10/M11 had shown.
- Added `scripts/generate_realbench_reference_ppa.py`: synthesizes each golden via
  the SAME candidate Yosys+OpenROAD path (`_run_synthesis` + `_parse_ppa_log` with
  the candidate evaluator's aux/define resolution), writes the canonical
  `tns,wns,eff_clk_period,power,area` file. Generated **34/34 synth-capable e203
  modules** (RealBench_v4_synth), 0 failures; valid non-zero power+area
  (area 5–26,433 µm², power 1.6e-6–1.3 W). Files are local — the RealBench tree is
  git-ignored/regenerated — so the committed deliverables are the script + docs.
- Surfaced two harness bugs that still block full PPA SCORING (documented, not
  fixed this pass): (a) the post-synth functional gate errors on
  TIMESCALEMOD/WIDTHTRUNC for a subset of modules (blocks candidate PPA), (b) STA
  timing is degenerate (tns/wns=0, clock unconstrained) so PPA-improvement is
  power+area-only. Also confirmed the low functional solve rate is GENUINE model
  difficulty (no F30-style prompt/interface confound).
- Docs: new `docs/journal_features/realbench_reference_ppa.md` (diagnosis,
  process, consumption paths, remaining work incl. manifest ppa_path version bump
  + folding generation into build_realbench_manifest.py); doc 13 finding M15.
