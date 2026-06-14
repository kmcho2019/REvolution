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
