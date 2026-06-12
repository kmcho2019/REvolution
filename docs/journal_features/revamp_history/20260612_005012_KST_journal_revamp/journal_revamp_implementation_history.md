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
