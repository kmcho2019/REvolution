Reading additional input from stdin...
OpenAI Codex v0.142.4
--------
workdir: /workspace
model: gpt-5.5
provider: openai
approval: never
sandbox: danger-full-access
reasoning effort: xhigh
reasoning summaries: none
session id: 019f26ff-9062-7c71-a758-8308d1846999
--------
user
Requesting READ-ONLY review (do not modify, create, or delete any files; do not run state-changing commands) of the natural_qd_push work on branch feat/journal-qd-bd-exp-20260703, following /workspace/GUIDELINES.md and the push contract at docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/natural_qd_push_plan.md. Scope: commits 6fa46cfc77..HEAD (git log/show/diff) — the periodic-review action batch (validator config pins, screen seed summary reporter, required curiosity gamma) and the P1 lane packages (lanes/N01_cell_retention_mode/, lanes/N05_warmup_init/, lanes/N06_descriptor_bakeoff/). Check specifically: (1) do the N01/N05 results_report.md conclusions follow from the packaged tables (recompute spot values from package CSVs); (2) is the N05 retirement justified under its own registered follow-up rule or premature; (3) GUIDELINES.md Implementation Simplicity Rules on scripts/validate_natural_qd_run.py, scripts/report_screen_seed_summary.py, src/revolution/qd_natural/engine.py; (4) any reward-hacking or overclaim risk in the N01 'retention ladder' interpretation given it is single-seed; (5) N06 registration quality: is the wave-1/wave-2 design sound and are the probes sufficient gates. End with verdict PASS, PASS_WITH_ACTIONS, or FAIL and a numbered action list. Be adversarial and specific; cite files/lines.
codex
I’ll keep this strictly read-only: git inspection, file reads, and CSV calculations only. I’m starting with the governing docs and the commit range so the review is tied to the registered contract.
exec
/bin/bash -lc 'pwd && git status --short --branch && git log --oneline --decorate 6fa46cfc77..HEAD' in /workspace
exec
/bin/bash -lc "sed -n '1,240p' GUIDELINES.md" in /workspace
 succeeded in 0ms:
# Repository Guidelines

## Where Things Are

The repo map, where-to-look-by-task index, project structure, canonical
entry points, command reference, and output/artifact orientation live in
[README.md](README.md) ("Repository Guide" section). This file keeps only
practices: the journal-revamp onboarding order below, coding style and
simplicity rules, testing, local validation, and commit standards.

## Journal Revamp Onboarding

- Journal-revamp onboarding (read in this order when implementing the TCAD goal):
  [docs/journal_features/revamp_ruminations_20260612.md](docs/journal_features/revamp_ruminations_20260612.md) is the original intent;
  [docs/journal_features/journal_narrative.md](docs/journal_features/journal_narrative.md) is the ACCEPTED claims contract (gates/branch rules frozen — it wins on any conflict);
  [docs/journal_features/13_findings_dashboard.md](docs/journal_features/13_findings_dashboard.md) is the START-HERE current-state view (topic-indexed findings F1–F7/M1–M7, result tables, open decisions, navigation map — refresh its tables as runs land);
  [docs/journal_features/14_narrative_posture_assessment.md](docs/journal_features/14_narrative_posture_assessment.md) is the strategic read (are we passing reviewer muster, the Branch-C/B-scoped reality, the operator-simplification spine, and the RealBench storyline-deciding experiment);
  in `docs/journal_features/revamp_history/20260612_005012_KST_journal_revamp/`: `goal_template.md` is the v2 objective, `journal_revamp_plan.md` the P1–P5 execution plan, `journal_revamp_implementation_todo.md` the phase-grouped checklist (sign-off requires every item checked and spot-verified), `journal_revamp_adversarial_prompt.md` the sign-off process, `journal_revamp_implementation_history.md` the chronological evidence log (append-only; doc 13 is its topic-indexed complement), `rerun_ledger.jsonl` the run ledger; `*_v1_initial.md` files are archived originals.
  Locked artifacts live in `data/configs/` (seed manifest, subsets, probe); revise only by version bump with recorded rationale.

## Coding Style & Naming Conventions
- Target Python 3.11+, 4-space indentation, and UTF-8 text files.
- Match the existing typed style: add type hints for new public interfaces and docstrings for non-trivial logic.
- Use `snake_case` for modules/functions/variables, `PascalCase` for classes, and `UPPER_SNAKE_CASE` for constants.
- Keep framework logic in `src/revolution/`; keep operational wrappers and reporting scripts in `scripts/`.
- When adding a new feature area, update the nearest detailed doc in `docs/` and also reflect the new entry points in `README.md` and this file so readers can find the right follow-on material quickly.
- Prefer extending existing report/artifact paths before inventing new top-level scripts or sidecar formats.
- For QD changes, keep grid and CVT behavior aligned where possible: shared config semantics, shared artifact naming, and shared reporting surfaces.

### Implementation Simplicity Rules
1. Write extremely simple, "skimmable" code.
2. Minimize possible states: fewer arguments; remove or narrow any state.
3. Use discriminated unions to reduce the states code can be in.
4. Exhaustively handle multi-type objects; fail on unknown types.
5. Don't write defensive code (+ fall-back, excessive back-compat); trust the types.
6. Assert when loading data; be opinionated about parameters — nothing optional unless strictly required.
7. Remove any changes that are not strictly required.
8. Bias for fewer lines of code; no complex or clever code.
9. Don't split into too many functions; early returns are great.
10. Use asserts instead of try/except or defaults when something must exist.
11. Never pass overrides unless strictly necessary; keep argument counts low; required arguments are never optional.
12. Use Google Python docstring format for public modules/classes/functions and non-obvious helpers; add concise comments only where they make intent easier to skim and maintain.

## Testing Guidelines
- Testing framework: `pytest` (configured in `pyproject.toml` with `tests/` as test root).
- Name files `test_<module>.py` and test functions `test_<behavior>`.
- Prefer fixtures/mocks for external binaries (`iverilog`, `yosys`, `openroad`) instead of hard runtime dependencies in unit tests.
- Add script-focused tests under `tests/scripts/` when CLI/report behavior changes.
- If a change touches archive artifacts, descriptor selection, or report packaging, add or update the closest matching QD test under `tests/revolution/` and `tests/scripts/`.

## Local Validation Checklist
- This worktree does not currently contain a checked-in `.github/workflows/` CI definition, so pre-push validation should use the local repo proxy checklist instead.
- Run `pytest` for the full test suite.
- Run `ruff check` at least on touched files; use a broader tree only when cleaning legacy lint debt intentionally.
- Run `python -m pyright` on the touched source modules. If repo-wide pyright still has pre-existing debt, record that explicitly instead of silently skipping typecheck.
- Run `uv tool run ty check <touched modules>` when type-cleanliness is part of
  the change review; record whether diagnostics are branch-local debt,
  older repo-wide debt, or tool-environment import resolution noise.
- For LLM-backed runtime changes, run a vLLM preflight (`curl http://<host>:<port>/v1/models`) and at least one bounded smoke command.
- Record blocked smoke results explicitly when the model endpoint is reachable but the run does not complete in a reasonable timeout.
- For reasoning-model vLLM experiments on the shared large-context endpoint, treat low token budgets as invalid research settings. Use `--max_tokens 128000` and `--diff_max_tokens 128000` unless the run is explicitly a tiny debugging smoke.

## Commit & Pull Request Guidelines
- Follow the repository’s Conventional Commit pattern: `feat(scope): ...`, `fix(scope): ...`, `docs: ...`, `test(scope): ...`, `chore(scope): ...`.
- Use clear scopes (for example: `gen0`, `llm`, `devcontainer`, `reporting`).
- Prefer concise, imperative subjects and keep the first line under ~72 characters when possible.
- Keep commit structure clean: `<type>(<scope>): <subject>` on line 1, one blank line, wrapped body text, optional labeled sections (`Tests:`, `Docs:`), and optional footers (`Signed-off-by:`).
- In commit bodies, explain what changed and why; use short wrapped paragraphs or simple `- ` bullets for grouped changes.
- When using `git commit -s`, do not manually add another `Signed-off-by:` line
  in the message body. Each commit should end with exactly one sign-off footer
  for the repository author identity.
- Use signed multi-line commits going forward; never single-line for new work:
```bash
git commit -s -m "docs: add completion goal" \
  -m "Explain why agents must use docs/specs.md before handoff." \
  -m "Keep the body wrapped so terminal git output stays readable."
```
- The "Golden Seven": blank line between subject and body; subject ≤ 50 chars, capitalized, no trailing period, imperative mood ("If applied, this commit will <subject>"); body wrapped at 72 chars; body explains what and why, not how (context, why this solution, side effects/breaking changes).
- Keep commits atomic: one logical change per commit — an "and" in the subject means split it.
- Immediately after committing, inspect the stored message (`git log --format=%B -n 1`) and confirm: no raw `\n` text, no malformed/missing `Signed-off-by`, proper `type(scope): subject` form.
- Preferred message template:
```text
feat(reporting): add reproducible experiment archiving for run outputs

Implement a repo-native archive utility for experiment tracking and
reproducibility.

Tests:
- add tests/scripts/test_archive_baseline.py
- validate single-run and ablation archive behavior

Docs:
- update README.md and docs/user_guide.md

Signed-off-by: Name <email>
```
- Avoid malformed headers or spacing issues (for example `feat (reporting)`, missing `:`, double spaces, or inconsistent scope casing).
- Before push/PR, review every new commit message:
- Check message body exactly as stored: `git log --format=%B -n 1 <commit>`.
- Check rendered commit metadata and spacing: `git show --pretty=fuller --no-patch <commit>`.
- Check for malformed content: raw `\n`, missing blank lines, trailing spaces, bad indentation, or malformed `type(scope): subject`.
- If reviewing a branch, run the same checks for each commit in `<base>..HEAD`.
- PRs should include: purpose of change, impacted configs/commands, test evidence, and relevant output paths (for example `exp/<model>/...`) when experiment flow is affected.

exec
/bin/bash -lc "sed -n '1,260p' docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/natural_qd_push_plan.md" in /workspace
 succeeded in 0ms:
# Natural QD Push Plan

Feature slug: `natural_qd_push`
Status: scaffold ready 2026-07-03; goal not yet activated.
Branch: `feat/journal-qd-bd-exp-20260703` (from `f786d9306b`).

## Outcome

Find at least one QD/MAP-Elites variant that is a natural, single-mechanism
extension of classic REvolution (EoH six-operator suite over
(thought, code, feedback) tuple individuals) and that beats matched classic
on mean PPA hypervolume and HV-AUC while matching or improving functionality
(every classic-covered design keeps at least one testbench-passing,
valid-PPA candidate). A rigorous, operator-fair negative map is the fallback
outcome only after the persistence policy below is exhausted.

## Source Of Truth

- Living checklist: `natural_qd_push_implementation_todo.md`
- Audit log: `natural_qd_push_implementation_history.md`
- Goal body: `goal_template.md`
- Sign-off rubric: `natural_qd_push_adversarial_prompt.md`
- Validator output: `natural_qd_push_subagent_validation_report.md`
- Inherited binding policies: see `README.md` table (June-22 push docs).
- Frozen claims contract: `docs/journal_features/journal_narrative.md`
  (rev 3 ACCEPTED — wins on any conflict; gates below restate it).
- Platform definition: `docs/journal_features/16_smooth_qd_integration_track.md`
  (Smooth-QD V2), findings in `docs/journal_features/13_findings_dashboard.md`.

## Why This Push Exists (founding analysis, 2026-07-03)

1. **The June-22 negative map is operator-contaminated.** Nearly every live
   QD arm from T31 onward (T49-T59, T63-T67, T72-T75, T83-T87, T94-T100, the
   aux-archive family, and the entire 20260629 full RTLLM suite) ran
   `--qd_operator_kind single_thought_operator` while classic ran the full
   EoH `eoh_strategies` stack. The corrected 20260630 reruns moved every
   re-tested arm up 30-46 retention points (DeepGate delayed 57.5% -> 93.5%
   of classic HV; MasterRTL activation 62.3% -> 91.6%; Qwen PCA3 43.1% ->
   89.5%). Source: `../20260622_010615_KST_useful_bd_push/RTLLM_full_suite/
   20260630/{README.md,method_configs.md,report.md}`. Consequence: prior
   negative verdicts must not be cited against a descriptor or archive
   mechanism unless the run was operator-fair (T24-T30, T32, T38-T48 were).
2. **The corrected suite is unfinished.** `full_suite_method_summary.csv`
   shows the three strongest contaminated arms were never re-run cleanly
   (`masterrtl_rf_leafid_structural_eoh_8x5`, `rf_deepgate_hybrid_eoh_8x5`,
   `aurora_raw_impl_compact_eoh_8x5` all `not_started`).
3. **PCN-v3 is dead and diagnostic.** The single-seed full-RTLLM "win"
   (103.4% of classic) failed 5-seed replication (clean_pcn_vs_classic
   -0.0021, p=0.19; PCN-no-CF vs classic-no-CF -0.0065) and was confounded
   by disabling the C-F crossover operator. Memory-refine events were a
   small minority (332/4266) with no method-level HV advantage. Colleague
   reviews read the stagnation trigger and credit/activation threshold
   stack as arbitrary bolt-on complexity. This push must not reproduce that
   mechanism signature (see Natural-Extension Criterion).
4. **The parity platform already exists.** Smooth-QD V2 (code individuals +
   full EoH suite + champion refinement + NSGA-II non-domination-rank parent
   selection over the grid-quantile BD-trio archive) reached statistical
   parity with classic on 5 seeds (quality delta -0.016, CI [-0.045,+0.007],
   functionality tied; F23). The job is parity -> win, one mechanism at a
   time, under operator-fair conditions.
5. **Where classic still wins:** Pareto-front breadth and valid-PPA yield,
   concentrated on exploitation-heavy problems (alu, parallel2serial).
   Corrected QD arms lose HV mainly through yield/coverage, not descriptor
   quality. Winning mechanisms must add front material without taxing yield.

## Classic Baselines To Reuse (operator-fair, verified before reuse)

Classic arms were always `eoh_strategies`, so existing classic run roots are
reusable evidence. Pin exact run roots + recomputed metrics in `tables/`
during P0; never launch a duplicate classic arm when a matched one exists.

| Scope | Classic mean HV | HV-AUC | Notes |
| --- | --- | --- | --- |
| Frozen 8-design 8x5, seed 1001 | 0.1406 | - | screening comparator |
| Frozen 8-design 8x5, seeds 1001-1003 | 0.1442 | - | replication bar |
| Matched classic 6x7 (T79) | 0.1701 | - | depth comparator |
| Full RTLLM 46 ref-complete, seed 1001 | 0.0997 | 0.0899 | 20260630 |
| Full RTLLM 46 ref-complete, 5-seed | 0.10380 | 0.08680 | cov 32.8/46 |
| classic_no_cf, full RTLLM 5-seed | 0.10685 | 0.09459 | C-F control |

Reference-complete rule: RTLLM excludes `Prob006_adder_pipe_64bit`,
`Prob013_multi_booth_8bit`, `Prob018_float_multi`, `Prob040_synchronizer`
(missing reference `ppa.txt`; 50 -> 46). Every run package ships
`ppa_completeness.csv`.

## Lessons Table (pitfall -> binding rule)

| Prior pitfall | Rule in this push |
| --- | --- |
| QD arms ran `single_thought_operator` vs classic EoH | Operator-contract gate: every compared pair audited, `single_thought_count=0` both arms, `qd_operator_kind=eoh_strategies` pinned in every QD config |
| PCN "win" traced to disabled C-F crossover | `--eoh_success_operator_set` matched across compared arms; any arm touching operator sets is also compared to `classic_no_cf` |
| Single-seed promotion and single-seed kills | No verdict on any arm within +-5% of classic from one seed; 3-seed screen before promote/kill, 5-seed full suite before claims |
| Bolt-on memory + hand-tuned triggers (PCN-v3) | Natural-Extension Criterion below; no stagnation/credit/activation gates |
| Early "win" flipped by missing reference PPA | Headline metrics only on reference-complete paired subsets |
| HV-AUC recomputation drift across packages | One canonical HV-AUC implementation in shared reporting, regression-tested against stored 20260630 tables |
| thought-only representation dragged QD down | `representation_kind=code_individual` everywhere; thought-as-representation lanes are out of scope |
| 800-line TODO, engine.py bloat (~90 qd params, PCN modes inline) | TODO hard cap 200 lines; no new engine.py scheduler modes; config-first lanes; new code in a small dedicated module/subpackage |

## Natural-Extension Criterion (binding definition of "not too technical")

A lane is admissible only if all hold:

1. Its mechanism is describable in at most two sentences as an extension of
   the conference algorithm ("REvolution, but the population is a MAP-Elites
   archive with X").
2. It adds at most two new tunable knobs beyond the V2 platform, none of
   which is a runtime trigger (no stagnation, credit, EMA, activation, or
   front-gap thresholds).
3. It changes exactly one mechanism relative to the V2 platform
   (single-factor discipline); combinations only from measured single-factor
   winners, pre-registered.
4. Operator stack, representation, prompts, budgets, evaluation flow, and
   token limits are identical to matched classic.
5. It corresponds to a published QD concept (MAP-Elites, MOME per-cell
   fronts, CVT, curiosity/novelty-weighted selection) rather than a bespoke
   heuristic schedule.

## Candidate Lanes (initial portfolio; registry in `lanes/lane_registry.csv`)

Platform for all lanes: Smooth-QD V2 exact configuration (pinned in P0).
Every lane states: mechanism (one sentence), prior evidence, knobs, gates.

- **N01 per-cell Pareto slots.** V2 with `qd_cell_mode=elite_pareto_slot`
  (bounded per-cell front, slot count 1 then 2). Evidence: T36/T37 replay
  +4.04% HV (best replay tier reached, never run live operator-fair); F5
  Pareto-vs-scalar +0.013 inconclusive-positive. Matches the frozen thesis
  sentence ("bounded per-cell Pareto fronts instead of scalar replacement").
- **N02 Pareto-biased parent sampling.** V2 selection, but upsample
  evaluated nondominated members of local cell fronts and underfilled cells
  (curiosity weighting). Evidence: idea backlog "Smooth-QD-v2 Pareto-biased
  parent sampling", untried; extends V2's NSGA-II selection with one weight.
- **N03 archive parent lane.** V2 with a fixed fraction of parents drawn
  from archive front slots (`qd_front_slot_lane_fraction` in {0.10, 0.30});
  no triggers. Evidence: T54/T75 precedent existed only under the
  contaminated operator; never measured operator-fair.
- **N04 budget shape.** Best-of-N01..N03 (or V2 if none leads) at 6x7 vs
  matched classic 6x7 (0.1701 exists); optionally 4x11 with a new matched
  classic arm. Evidence: T78 shows archives mature late (9/13 fill at
  gen>=2); T79's negative used the contaminated T75 arm and does not bind.
- **N05 warmup initialization.** V2 with archive pressure starting after a
  fixed generation g0 (standard MAP-Elites random-init phase; one knob, not
  a trigger). Evidence: T39 sparse-yield warmup was an operator-fair
  positive ablation (fixed multi-pipe coverage). Yield-protection lane.
- **N06 descriptor bake-off (conditional).** Only if N01-N03 stall and only
  under the narrative's predeclared bake-off rule: transparent source-level
  structural axes (T73 shape-density family: branching, wire/DFF density)
  vs the frozen trio, operator-fair, with T22-style random-descriptor
  control and collapse diagnostics. No pretrained-weight descriptors.
- **N07 corrected-suite completion (due diligence).** Screen the three
  never-rerun corrected arms' descriptor profiles operator-fair at 8-design
  scale before dismissing them (rf_leafid structural, aurora raw-impl
  compact, rf_deepgate hybrid). Lowest priority; encoder-flavored lanes do
  not headline this push.
- **N08 combination arm.** Pre-registered merge of single-factor winners
  only (e.g., N01 slots + N02 sampling), run after their individual reads.

Controls always available: matched classic (reused), V2 platform (P0 run),
`classic_no_cf` (when operator sets are touched), random-descriptor control
(when any descriptor claim is made).

## Evaluation Surface

- Model: `openai/gpt-oss-120b` via vLLM `http://20.0.0.103:8000/v1`
  (preflight verified 2026-07-03, `max_model_len=131072`). Preflight and
  record `/v1/models` before every live batch; `--max_tokens 128000
  --diff_max_tokens 128000 --vllm_min_model_len 128000`; temperature 1.0,
  top_p 1.0. Correction 2026-07-03 (periodic review F-1): screen runs
  use `strict_ablation` evaluation — the June-25 screen comparator's
  surface — not `search_accelerated` (which the June-12 matrix used);
  ruling recorded in `tables/v2_platform_config.md` before the anchor
  relaunch. Evaluation mode must always match the compared classic arm.
- Screening: the June-22 frozen 8-design 8x5 surface (pin the exact
  manifest from `preliminary_planning/20260625_encoder_config_screening/`
  tables into `tables/` here during P0, before any run). Seed ladder:
  1001 -> add 1002/1003 when within +-5% of classic -> full RTLLM 46
  ref-complete seed 1001 -> seeds 1001-1005.
- Final gates (frozen contract): held-out reference set + statistical
  protocol from `journal_narrative.md` (problem-seed pairs, cluster
  bootstrap, penalized imputation).
- Primary metrics: mean global PPA hypervolume, HV-AUC, per-design coverage
  (functionality), valid-PPA yield, Pareto points / front families.
  Never average fitness as primary evidence.
- HV-AUC: canonicalize one implementation in shared reporting during P0
  (port the 20260630 computation; regression-test equality on stored
  tables; then all packages use the shared path).
- Run outputs: `exp/natural_qd_push/<lane>/<timestamp>/...`; per-run
  vLLM preflight capture, full command line, `ppa_completeness.csv`,
  operator-contract audit output.

## Gates

Screening (8-design 8x5 vs matched classic):

- Hard gate: retain every classic-covered design (>=1 valid functional PPA
  candidate). Coverage loss = kill, with diagnosis.
- Kill: 3-seed mean HV < 0.95x matched classic, or valid-PPA yield decline
  >=50% on units where classic has >=10 passing samples.
- Iterate: within [0.95x, 1.02x] — requires a diagnosis note and either a
  registered follow-up variant or a documented retirement.
- Promote to full RTLLM: 3-seed mean HV >= matched classic 3-seed AND
  HV-AUC >= classic AND coverage retained, pre-registered before the run.

Final (frozen contract, unchanged): mean per-unit
`log((HV_t+1e-9)/(HV_b+1e-9)) >= log(1.05)` with cluster CI low > 0;
best-quality and win-rate gates per `journal_narrative.md`; functionality
`NEW_OK`/coverage >= classic; Branch B additionally needs the utility
metric >= 0.25. Seeds 1001-1005; debug seed 42 is never evidence.

## Hard Constraints

- Operator parity: `qd_operator_kind=eoh_strategies` and
  `classic_operator_kind=eoh_strategies` pinned in every config;
  `--eoh_success_operator_set` matched across compared arms; the
  operator-contract audit (ported to `scripts/` in P0) must report
  `single_thought_count=0` for both arms of every headline comparison.
- `representation_kind=code_individual` everywhere.
- Descriptor inputs never include final PPA, reference PPA, fitness, HV,
  Pareto rank, test pass rate, or problem identity. (Per-cell Pareto
  retention/selection may use evaluated PPA — selection is not a
  descriptor.)
- Model, subset, seeds, prompts, budgets, timeouts, and evaluation flow
  fixed unless a versioned exception is recorded before running. Freeze
  subsets before reading outcomes. Invalid candidates and duplicates never
  count as diversity.
- No new scheduler modes or lane logic inside `src/revolution/qd/engine.py`;
  PCN code paths stay untouched and unused.
- Contaminated June-22 numbers are never cited as evidence against a
  mechanism; only operator-fair runs count either way.

## Persistence Policy (anti premature-stop)

- Attempt at least 8 lane packages spanning at least 4 mechanism families
  (cell retention, parent selection, budget shape, initialization,
  descriptor, revalidation) before any broad negative conclusion.
- Every kill records: cause class (yield-loss | front-loss |
  exploration-tax | descriptor-collapse | mechanism-inert), the evidence,
  and at least one follow-up idea (inherited backlog rule).
- No lane is abandoned on a single seed when within +-5% of classic.
- Blocked-stop only after three concrete attempts hit the same blocker,
  with commands, artifacts, missing input, and the exact next decision.
- The push does not stop because one lane is weak; it stops on a validated
  win (screen + full suite + contract gates) or an exhausted portfolio with
  an adversarial PASS on the negative map.

## Code Organization

- Config-first: N01/N03/N04/N05 should need no new framework code (existing
  `qd_cell_mode`, lane-fraction, budget, warmup knobs). Verify before
  writing any code; prefer a config + validator over a new module.
- New mechanisms (N02 sampling weight) go in a small dedicated module under
  `src/revolution/qd/` (e.g., `parent_sampling.py`) or a
  `src/revolution/qd_natural/` subpackage subclassing `QDEngine` — never
  inline additions to `engine.py` loop bodies (the PCN anti-pattern; the
  `auto_bd/` subpackage is the precedent to copy).
- Promote `audit_operator_contract.py` from the June-22 docs tree into
  `scripts/` as a tracked, tested validator; add
  `scripts/validate_natural_qd_run.py` (operator contract, token budgets,
  seed, descriptor profile, archive config vs registration) with tests
  under `tests/scripts/`.
- Tests: extend `tests/revolution/test_qd_*` for any touched behavior;

 succeeded in 22042ms:
## feat/journal-qd-bd-exp-20260703
 M docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/natural_qd_push_implementation_todo.md
?? .devcontainer/devcontainer-lock.json
?? docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/reviews/codex_second_opinion_20260703_p1.md
f186b45f13 (HEAD -> feat/journal-qd-bd-exp-20260703) docs(qd): Package P1 reads; retire N05; queue chain 2
f239b925ba docs(qd): Upgrade N06 to active descriptor bake-off
c1e020b16b docs(qd): Refresh anchor package via new tooling
a08a7577f1 fix(qd): Require explicit curiosity gamma flag
8084a41605 feat(qd): Add screen seed summary reporter
751815dbc2 feat(qd): Add config pins to the run validator

codex
The worktree is dirty, but the dirty paths are outside the core files I’m about to inspect, so I’ll review the committed `6fa46cfc77..HEAD` state and call out that boundary if it matters. Next I’m pulling the lane packages, script diffs, and exact report/table paths before doing the arithmetic checks.
exec
/bin/bash -lc "sed -n '261,520p' docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/natural_qd_push_plan.md" in /workspace
 succeeded in 0ms:
  mock EDA binaries. Run pytest (focused), `ruff check`, `python -m
  pyright` on touched modules; record results in history.
- No imports from untracked directories (`exp/`, ad-hoc checkouts); every
  script and config a run needs is tracked in git.
- Keep grid and CVT semantics aligned when touching shared archive code
  (GUIDELINES.md); follow Implementation Simplicity Rules (asserts, few
  knobs, no defensive fallbacks).

## Deltas Vs Inherited Contracts

1. Screening kill bar is 0.95x on 3-seed mean HV (June-22 used single-seed
   reads); single-seed near-ties are never verdicts.
2. HV-AUC joins mean HV as a co-primary screening metric once the canonical
   implementation lands.
3. Lane admissibility adds the Natural-Extension Criterion (June-22 allowed
   arbitrary mechanism complexity).
4. Technique IDs are `N##` in `lanes/` here; the June-22 T-series is closed.
5. The in-loop BD-input exclusion is clarified: it binds descriptors, not
   per-cell Pareto retention/selection (which the frozen thesis mandates).

## Execution Phases

- **P0 Foundations (no live spend except the V2 anchor).** Pin the
  8-design manifest + classic run roots into `tables/`; pin the exact V2
  platform config; port + test the operator-contract auditor; canonicalize
  HV-AUC (regression-test vs 20260630 tables); write
  `validate_natural_qd_run.py`; run V2 on the screen (seed 1001, then
  1002/1003 — it is expected within +-5%) to anchor all lane deltas.
- **P1 Single-factor screens.** N01, N02, N03, N05 at 8x5 seed 1001;
  seed-replicate near-ties; per-lane package (methodology, commands,
  figures incl. direct raw PPA Pareto PNG, tables, tier decision) per the
  inherited visualization policy.
- **P2 Shape and follow-ups.** N04 budget shape for the current leader;
  registered follow-up variants from P1 diagnoses; N06/N07 only per their
  conditions.
- **P3 Confirmation.** Pre-registered best arm (or N08 combination) on
  full RTLLM 46 ref-complete seed 1001, then seeds 1001-1005, vs reused
  classic 5-seed baselines; contract statistics; held-out gate if the
  5-seed read clears the screen bars.
- **P4 Synthesis.** Refresh `13_findings_dashboard.md` tables and the
  June-22 `technique_lineage_ledger.md` closure note; central comparison
  report here; adversarial validation PASS; presentation pack only after
  the verdict is stable.

## Completion Gates

- [ ] P0 artifacts exist: pinned manifests/baselines, V2 anchor runs,
      canonical HV-AUC with regression test, tracked operator auditor,
      run validator with tests.
- [ ] >=8 lane packages across >=4 families, each operator-audited, with
      figures, tables, tier decision, and follow-up/retirement rationale.
- [ ] At least one arm promoted and run at full RTLLM 5-seed, or the
      persistence policy exhausted with documented diagnoses.
- [ ] Headline claims use reference-complete paired subsets, canonical
      HV-AUC, and cluster statistics; no contaminated numbers cited.
- [ ] Functionality: no promoted arm loses any classic-covered design;
      yield warnings visible where triggered.
- [ ] Code: no `engine.py` core-loop edits; new code small, typed, tested;
      pytest/ruff/pyright recorded; no untracked imports.
- [ ] Docs: lane registry current; TODO within cap; history complete;
      dashboard refreshed; commits atomic, signed, message-verified.
- [ ] Adversarial validator returns PASS in
      `natural_qd_push_subagent_validation_report.md`.

## Risks And Blockers

- vLLM endpoint contention/downtime: preflight per batch; record blocked
  smokes explicitly; never switch endpoints mid-comparison.
- V2 platform drift vs current code: P0 anchor run exposes it early; if V2
  no longer reproduces parity, fix or re-pin before any lane run.
- All single-factor lanes land in [0.95x, 1.02x]: expected hard case —
  budget shape (N04) and the pre-registered combination (N08) are the
  designed escalations; descriptor bake-off (N06) after that.
- Seed variance at 8x5 (temperature 1.0) can absorb real +2-4% effects:
  that is why kills also require 3 seeds and why HV-AUC co-reads.
- Compute budget: reuse classic baselines aggressively; new classic arms
  only for new shapes (4x11) with prior registration.

exec
/bin/bash -lc 'find docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes -maxdepth 3 -type f | sort' in /workspace
 succeeded in 0ms:
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/lane_registry.csv
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N01_cell_retention_mode/commands.md
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N01_cell_retention_mode/methodology.md
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N01_cell_retention_mode/results_report.md
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N02_curiosity_sampling/methodology.md
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N03_archive_parent_lane/commands.md
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N03_archive_parent_lane/methodology.md
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/commands.md
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/methodology.md
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/results_report.md
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N06_descriptor_bakeoff/methodology.md
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N06_descriptor_bakeoff/probes/probe_journal_graph_testability_3d.json
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N06_descriptor_bakeoff/probes/probe_random_hash_3d.json
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N06_descriptor_bakeoff/probes/probe_size_control_3d.json
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N06_descriptor_bakeoff/research_memo.md

exec
/bin/bash -lc 'git diff --stat 6fa46cfc77..HEAD && git diff --name-only 6fa46cfc77..HEAD' in /workspace
exec
/bin/bash -lc "git log --format='%H%x00%s%x00%B%x00END' 6fa46cfc77..HEAD" in /workspace
 succeeded in 0ms:
ae83252bf3c180269f892d660edee12c47c467ef docs(qd): Adopt codex second-opinion review channel docs(qd): Adopt codex second-opinion review channel

User-adopted practice: at each periodic review point, run
codex --yolo exec with an explicit READ-ONLY review prompt alongside
claude -p, so an independent model guards against shared blind spots
(the June-22 contamination survived several same-channel reviews).
Recorded in the standing-validation TODO and history; first trial is
running over the review-action batch and P1 packages. Also syncs the
N05 TODO line with its retirement outcome.

Signed-off-by: Kyumin Cho <kmcho@postech.ac.kr>
 END
f186b45f1384bec22966d8c4cc5c3cf7241251db docs(qd): Package P1 reads; retire N05; queue chain 2 docs(qd): Package P1 reads; retire N05; queue chain 2

Seed-1001 P1 results: the N01 attribution ladder shows retention
capacity monotone in mean HV (classic 0.14064 -> scalar cells 0.14683
-> one front slot 0.15709 -> V2 Pareto-5 cells 0.17376), isolating
per-cell Pareto retention as the largest single contributor to the V2
win; N05 shows warmup deviations lose in both directions, so the lane
is retired as a positive validation of the platform value. All arms
audit clean with coverage 8/8 and config-pinned validations. The N02
smoke cleared the natural engine for its full screen, N06 wave-1
probes resolve PPA-free, and chain 2 (N06 wave-1, N03 on the amended
card, N02a) is running.

Signed-off-by: Kyumin Cho <kmcho@postech.ac.kr>
 END
f239b925bab98b5c5c7381b7de4b3daed01096ac docs(qd): Upgrade N06 to active descriptor bake-off docs(qd): Upgrade N06 to active descriptor bake-off

At user request, research whether V2 improves via empirically
strong, theoretically grounded descriptors. The evidence memo finds
that no descriptor bake-off has ever run on the V2 platform: F12's
negative verdict is radical-regime evidence, while the trio's
collapse is substrate-independent (ff_depth collapses on 7/13
problems even operator-fair; comb_width_log is a formal size proxy).

Register the first V2-platform bake-off: wave 1 as pure profile swaps
(journal_graph_testability_3d as the SCOAP/reconvergence/cyclomatic
semantic challenger, size_control_3d as the structural bar, a random
floor per the T22 lesson), wave 2 as theory_grounded_compact_8d on
CVT with a paired trio-CVT control, an offline probe step before any
spend, and SR ReLU PCA as the registered follow-up.

Signed-off-by: Kyumin Cho <kmcho@postech.ac.kr>
 END
c1e020b16b6b5d4686cd25fb969848e733904b91 docs(qd): Refresh anchor package via new tooling docs(qd): Refresh anchor package via new tooling

Regenerate three_seed_summary.csv through the tracked reporter
(values identical to the review's independent recomputation) and
revalidate all three anchor seeds under the strengthened validator
with the full V2 config-pin set; per-seed LLM-call totals now sit in
the run_validation reports. Record the exact commands in the anchor
command card.

Signed-off-by: Kyumin Cho <kmcho@postech.ac.kr>
 END
a08a7577f13ec00d49b0de1b4d1f106f3574884c fix(qd): Require explicit curiosity gamma flag fix(qd): Require explicit curiosity gamma flag

Periodic review F-9: a defaulted --qd_curiosity_gamma could
silently run lane N02a when the flag was forgotten. The flag is now
required with, and only valid for, search_mode=revolution_qd_natural
(config error otherwise), and the N02 draw-distribution test uses a
single random.choices call.

Signed-off-by: Kyumin Cho <kmcho@postech.ac.kr>
 END
8084a416055b47ea72a73e7c9172fcca3b98a0ec feat(qd): Add screen seed summary reporter feat(qd): Add screen seed summary reporter

Periodic review F-3: the headline three-seed table had no tracked
generator. Add scripts/report_screen_seed_summary.py, which emits the
per-seed + mean comparison table from the packaged aggregate and
canonical HV-AUC CSVs, so every lane package reproduces its summary
through one tracked path.

Tests:
- synthetic two-seed case
- regression pinning the tracked p0_v2_anchor package to the exact
  3-seed means (0.14418... / 0.16284... / 112.9)

Signed-off-by: Kyumin Cho <kmcho@postech.ac.kr>
 END
751815dbc2665c5c2c509dd03e0190d5d6cd91a5 feat(qd): Add config pins to the run validator feat(qd): Add config pins to the run validator

Periodic review F-2/F-7: the unfaithful first anchor showed that
registered-card-vs-run config drift is the error class our tooling
must catch, and per-arm LLM-call budgets were asserted rather than
evidenced. The validator now checks repeatable --expect-config
KEY=VALUE pins against the run's resolved *_revolution_config.yaml
and reports per-problem plus total llm_api_calls in the JSON report.

Tests:
- config pin match/mismatch/missing-key cases
- llm_api_calls totals in the clean-run report

Signed-off-by: Kyumin Cho <kmcho@postech.ac.kr>
 END

 succeeded in 3960ms:
 .../pareto_analysis/aggregate_backend_metrics.csv  |  13 +
 .../pareto_analysis/backend_problem_metrics.csv    |  33 +
 .../RTLLM/Prob015_multi_pipe_8bit/front_3d.png     | Bin 0 -> 429537 bytes
 .../Prob015_multi_pipe_8bit/pairwise_fronts.png    | Bin 0 -> 234510 bytes
 .../problems/RTLLM/Prob024_fsm/pairwise_fronts.png | Bin 0 -> 78943 bytes
 .../Prob041_traffic_light/pairwise_fronts.png      | Bin 0 -> 92749 bytes
 .../problems/RTLLM/Prob045_alu/pairwise_fronts.png | Bin 0 -> 75997 bytes
 .../RTLLM/Prob049_signal_generator/front_3d.png    | Bin 0 -> 415688 bytes
 .../Prob049_signal_generator/pairwise_fronts.png   | Bin 0 -> 214774 bytes
 .../Prob116_m2014_q3/pairwise_fronts.png           | Bin 0 -> 65900 bytes
 .../Prob135_m2014_q6b/pairwise_fronts.png          | Bin 0 -> 65840 bytes
 .../Prob153_gshare/front_3d.png                    | Bin 0 -> 464560 bytes
 .../Prob153_gshare/pairwise_fronts.png             | Bin 0 -> 263246 bytes
 .../package/pareto_analysis/report.md              |  73 ++
 .../package/pareto_analysis/summary.json           | 629 +++++++++++++++++
 .../data/best_candidate_by_backend_problem.csv     |  33 +
 .../ppa_distribution/data/ppa_candidates.csv       | 783 +++++++++++++++++++++
 .../data/reference_ppa_metrics.csv                 |   9 +
 .../absolute/area_vs_effective_clock_period.png    | Bin 0 -> 316405 bytes
 .../absolute/power_vs_area.png                     | Bin 0 -> 251309 bytes
 .../absolute/power_vs_effective_clock_period.png   | Bin 0 -> 287690 bytes
 .../gain/area_vs_effective_clock_period.png        | Bin 0 -> 294672 bytes
 .../Prob015_multi_pipe_8bit/gain/power_vs_area.png | Bin 0 -> 256648 bytes
 .../gain/power_vs_effective_clock_period.png       | Bin 0 -> 269820 bytes
 .../RTLLM/Prob024_fsm/absolute/power_vs_area.png   | Bin 0 -> 218885 bytes
 .../RTLLM/Prob024_fsm/gain/power_vs_area.png       | Bin 0 -> 233032 bytes
 .../absolute/power_vs_area.png                     | Bin 0 -> 306829 bytes
 .../Prob041_traffic_light/gain/power_vs_area.png   | Bin 0 -> 323176 bytes
 .../RTLLM/Prob045_alu/absolute/power_vs_area.png   | Bin 0 -> 168568 bytes
 .../RTLLM/Prob045_alu/gain/power_vs_area.png       | Bin 0 -> 173756 bytes
 .../absolute/area_vs_effective_clock_period.png    | Bin 0 -> 251748 bytes
 .../absolute/power_vs_area.png                     | Bin 0 -> 294727 bytes
 .../absolute/power_vs_effective_clock_period.png   | Bin 0 -> 300637 bytes
 .../gain/area_vs_effective_clock_period.png        | Bin 0 -> 247971 bytes
 .../gain/power_vs_area.png                         | Bin 0 -> 316853 bytes
 .../gain/power_vs_effective_clock_period.png       | Bin 0 -> 295643 bytes
 .../Prob116_m2014_q3/absolute/power_vs_area.png    | Bin 0 -> 141103 bytes
 .../Prob116_m2014_q3/gain/power_vs_area.png        | Bin 0 -> 153707 bytes
 .../Prob135_m2014_q6b/absolute/power_vs_area.png   | Bin 0 -> 139546 bytes
 .../Prob135_m2014_q6b/gain/power_vs_area.png       | Bin 0 -> 154092 bytes
 .../absolute/area_vs_effective_clock_period.png    | Bin 0 -> 367480 bytes
 .../Prob153_gshare/absolute/power_vs_area.png      | Bin 0 -> 225862 bytes
 .../absolute/power_vs_effective_clock_period.png   | Bin 0 -> 313262 bytes
 .../gain/area_vs_effective_clock_period.png        | Bin 0 -> 334264 bytes
 .../Prob153_gshare/gain/power_vs_area.png          | Bin 0 -> 226256 bytes
 .../gain/power_vs_effective_clock_period.png       | Bin 0 -> 291123 bytes
 .../package/ppa_distribution/report.md             |  29 +
 .../package/ppa_distribution/summary.json          | 127 ++++
 .../package/tables/hv_auc.csv                      |  33 +
 .../package/tables/operator_contract.csv           |   5 +
 .../tables/run_validation_elite_pareto_slot_2.json |  31 +
 .../tables/run_validation_scalar_elite.json        |  31 +
 .../N01_cell_retention_mode/results_report.md      |  39 +
 .../pareto_analysis/aggregate_backend_metrics.csv  |  13 +
 .../pareto_analysis/backend_problem_metrics.csv    |  33 +
 .../RTLLM/Prob015_multi_pipe_8bit/front_3d.png     | Bin 0 -> 460786 bytes
 .../Prob015_multi_pipe_8bit/pairwise_fronts.png    | Bin 0 -> 227196 bytes
 .../problems/RTLLM/Prob024_fsm/pairwise_fronts.png | Bin 0 -> 75242 bytes
 .../Prob041_traffic_light/pairwise_fronts.png      | Bin 0 -> 85917 bytes
 .../problems/RTLLM/Prob045_alu/pairwise_fronts.png | Bin 0 -> 75952 bytes
 .../RTLLM/Prob049_signal_generator/front_3d.png    | Bin 0 -> 403372 bytes
 .../Prob049_signal_generator/pairwise_fronts.png   | Bin 0 -> 201677 bytes
 .../Prob116_m2014_q3/pairwise_fronts.png           | Bin 0 -> 66549 bytes
 .../Prob135_m2014_q6b/pairwise_fronts.png          | Bin 0 -> 66386 bytes
 .../Prob153_gshare/front_3d.png                    | Bin 0 -> 436877 bytes
 .../Prob153_gshare/pairwise_fronts.png             | Bin 0 -> 227056 bytes
 .../package/pareto_analysis/report.md              |  73 ++
 .../package/pareto_analysis/summary.json           | 629 +++++++++++++++++
 .../data/best_candidate_by_backend_problem.csv     |  33 +
 .../ppa_distribution/data/ppa_candidates.csv       | 748 ++++++++++++++++++++
 .../data/reference_ppa_metrics.csv                 |   9 +
 .../absolute/area_vs_effective_clock_period.png    | Bin 0 -> 299968 bytes
 .../absolute/power_vs_area.png                     | Bin 0 -> 236601 bytes
 .../absolute/power_vs_effective_clock_period.png   | Bin 0 -> 308473 bytes
 .../gain/area_vs_effective_clock_period.png        | Bin 0 -> 276620 bytes
 .../Prob015_multi_pipe_8bit/gain/power_vs_area.png | Bin 0 -> 250540 bytes
 .../gain/power_vs_effective_clock_period.png       | Bin 0 -> 285197 bytes
 .../RTLLM/Prob024_fsm/absolute/power_vs_area.png   | Bin 0 -> 222996 bytes
 .../RTLLM/Prob024_fsm/gain/power_vs_area.png       | Bin 0 -> 244310 bytes
 .../absolute/power_vs_area.png                     | Bin 0 -> 284303 bytes
 .../Prob041_traffic_light/gain/power_vs_area.png   | Bin 0 -> 300488 bytes
 .../RTLLM/Prob045_alu/absolute/power_vs_area.png   | Bin 0 -> 162453 bytes
 .../RTLLM/Prob045_alu/gain/power_vs_area.png       | Bin 0 -> 167702 bytes
 .../absolute/area_vs_effective_clock_period.png    | Bin 0 -> 251813 bytes
 .../absolute/power_vs_area.png                     | Bin 0 -> 246809 bytes
 .../absolute/power_vs_effective_clock_period.png   | Bin 0 -> 289950 bytes
 .../gain/area_vs_effective_clock_period.png        | Bin 0 -> 239582 bytes
 .../gain/power_vs_area.png                         | Bin 0 -> 292218 bytes
 .../gain/power_vs_effective_clock_period.png       | Bin 0 -> 294067 bytes
 .../Prob116_m2014_q3/absolute/power_vs_area.png    | Bin 0 -> 138689 bytes
 .../Prob116_m2014_q3/gain/power_vs_area.png        | Bin 0 -> 151498 bytes
 .../Prob135_m2014_q6b/absolute/power_vs_area.png   | Bin 0 -> 134922 bytes
 .../Prob135_m2014_q6b/gain/power_vs_area.png       | Bin 0 -> 149313 bytes
 .../absolute/area_vs_effective_clock_period.png    | Bin 0 -> 242162 bytes
 .../Prob153_gshare/absolute/power_vs_area.png      | Bin 0 -> 190477 bytes
 .../absolute/power_vs_effective_clock_period.png   | Bin 0 -> 237572 bytes
 .../gain/area_vs_effective_clock_period.png        | Bin 0 -> 236858 bytes
 .../Prob153_gshare/gain/power_vs_area.png          | Bin 0 -> 171709 bytes
 .../gain/power_vs_effective_clock_period.png       | Bin 0 -> 243284 bytes
 .../package/ppa_distribution/report.md             |  29 +
 .../package/ppa_distribution/summary.json          | 127 ++++
 .../N05_warmup_init/package/tables/hv_auc.csv      |  33 +
 .../package/tables/operator_contract.csv           |   5 +
 .../package/tables/run_validation_warmup_16.json   |  26 +
 .../package/tables/run_validation_warmup_4.json    |  26 +
 .../lanes/N05_warmup_init/results_report.md        |  28 +
 .../lanes/N06_descriptor_bakeoff/methodology.md    |  96 +++
 .../probes/probe_journal_graph_testability_3d.json |  77 ++
 .../probes/probe_random_hash_3d.json               |  77 ++
 .../probes/probe_size_control_3d.json              |  77 ++
 .../lanes/N06_descriptor_bakeoff/research_memo.md  |  79 +++
 .../lanes/lane_registry.csv                        |   2 +-
 .../natural_qd_push_implementation_history.md      |  71 ++
 .../natural_qd_push_implementation_todo.md         |  23 +-
 .../p0_v2_anchor/commands.md                       |  24 +
 .../replication/seed_1002/run_validation.json      |  22 +
 .../replication/seed_1003/run_validation.json      |  22 +
 .../p0_v2_anchor/tables/run_validation.json        |  22 +
 .../p0_v2_anchor/tables/three_seed_summary.csv     |   4 +-
 .../reviews/codex_second_opinion_20260703_p1.md    | 401 +++++++++++
 scripts/report_screen_seed_summary.py              | 123 ++++
 scripts/run_backend.py                             |  22 +-
 scripts/validate_natural_qd_run.py                 |  51 +-
 tests/revolution/test_qd_natural_engine.py         |   4 +-
 tests/scripts/test_report_screen_seed_summary.py   | 106 +++
 tests/scripts/test_validate_natural_qd_run.py      |  43 +-
 126 files changed, 5009 insertions(+), 17 deletions(-)
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N01_cell_retention_mode/package/pareto_analysis/aggregate_backend_metrics.csv
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N01_cell_retention_mode/package/pareto_analysis/backend_problem_metrics.csv
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N01_cell_retention_mode/package/pareto_analysis/problems/RTLLM/Prob015_multi_pipe_8bit/front_3d.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N01_cell_retention_mode/package/pareto_analysis/problems/RTLLM/Prob015_multi_pipe_8bit/pairwise_fronts.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N01_cell_retention_mode/package/pareto_analysis/problems/RTLLM/Prob024_fsm/pairwise_fronts.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N01_cell_retention_mode/package/pareto_analysis/problems/RTLLM/Prob041_traffic_light/pairwise_fronts.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N01_cell_retention_mode/package/pareto_analysis/problems/RTLLM/Prob045_alu/pairwise_fronts.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N01_cell_retention_mode/package/pareto_analysis/problems/RTLLM/Prob049_signal_generator/front_3d.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N01_cell_retention_mode/package/pareto_analysis/problems/RTLLM/Prob049_signal_generator/pairwise_fronts.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N01_cell_retention_mode/package/pareto_analysis/problems/VerilogEval-Spec-to-RTL/Prob116_m2014_q3/pairwise_fronts.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N01_cell_retention_mode/package/pareto_analysis/problems/VerilogEval-Spec-to-RTL/Prob135_m2014_q6b/pairwise_fronts.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N01_cell_retention_mode/package/pareto_analysis/problems/VerilogEval-Spec-to-RTL/Prob153_gshare/front_3d.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N01_cell_retention_mode/package/pareto_analysis/problems/VerilogEval-Spec-to-RTL/Prob153_gshare/pairwise_fronts.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N01_cell_retention_mode/package/pareto_analysis/report.md
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N01_cell_retention_mode/package/pareto_analysis/summary.json
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N01_cell_retention_mode/package/ppa_distribution/data/best_candidate_by_backend_problem.csv
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N01_cell_retention_mode/package/ppa_distribution/data/ppa_candidates.csv
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N01_cell_retention_mode/package/ppa_distribution/data/reference_ppa_metrics.csv
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N01_cell_retention_mode/package/ppa_distribution/figures/all_backends/RTLLM/Prob015_multi_pipe_8bit/absolute/area_vs_effective_clock_period.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N01_cell_retention_mode/package/ppa_distribution/figures/all_backends/RTLLM/Prob015_multi_pipe_8bit/absolute/power_vs_area.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N01_cell_retention_mode/package/ppa_distribution/figures/all_backends/RTLLM/Prob015_multi_pipe_8bit/absolute/power_vs_effective_clock_period.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N01_cell_retention_mode/package/ppa_distribution/figures/all_backends/RTLLM/Prob015_multi_pipe_8bit/gain/area_vs_effective_clock_period.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N01_cell_retention_mode/package/ppa_distribution/figures/all_backends/RTLLM/Prob015_multi_pipe_8bit/gain/power_vs_area.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N01_cell_retention_mode/package/ppa_distribution/figures/all_backends/RTLLM/Prob015_multi_pipe_8bit/gain/power_vs_effective_clock_period.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N01_cell_retention_mode/package/ppa_distribution/figures/all_backends/RTLLM/Prob024_fsm/absolute/power_vs_area.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N01_cell_retention_mode/package/ppa_distribution/figures/all_backends/RTLLM/Prob024_fsm/gain/power_vs_area.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N01_cell_retention_mode/package/ppa_distribution/figures/all_backends/RTLLM/Prob041_traffic_light/absolute/power_vs_area.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N01_cell_retention_mode/package/ppa_distribution/figures/all_backends/RTLLM/Prob041_traffic_light/gain/power_vs_area.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N01_cell_retention_mode/package/ppa_distribution/figures/all_backends/RTLLM/Prob045_alu/absolute/power_vs_area.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N01_cell_retention_mode/package/ppa_distribution/figures/all_backends/RTLLM/Prob045_alu/gain/power_vs_area.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N01_cell_retention_mode/package/ppa_distribution/figures/all_backends/RTLLM/Prob049_signal_generator/absolute/area_vs_effective_clock_period.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N01_cell_retention_mode/package/ppa_distribution/figures/all_backends/RTLLM/Prob049_signal_generator/absolute/power_vs_area.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N01_cell_retention_mode/package/ppa_distribution/figures/all_backends/RTLLM/Prob049_signal_generator/absolute/power_vs_effective_clock_period.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N01_cell_retention_mode/package/ppa_distribution/figures/all_backends/RTLLM/Prob049_signal_generator/gain/area_vs_effective_clock_period.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N01_cell_retention_mode/package/ppa_distribution/figures/all_backends/RTLLM/Prob049_signal_generator/gain/power_vs_area.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N01_cell_retention_mode/package/ppa_distribution/figures/all_backends/RTLLM/Prob049_signal_generator/gain/power_vs_effective_clock_period.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N01_cell_retention_mode/package/ppa_distribution/figures/all_backends/VerilogEval-Spec-to-RTL/Prob116_m2014_q3/absolute/power_vs_area.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N01_cell_retention_mode/package/ppa_distribution/figures/all_backends/VerilogEval-Spec-to-RTL/Prob116_m2014_q3/gain/power_vs_area.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N01_cell_retention_mode/package/ppa_distribution/figures/all_backends/VerilogEval-Spec-to-RTL/Prob135_m2014_q6b/absolute/power_vs_area.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N01_cell_retention_mode/package/ppa_distribution/figures/all_backends/VerilogEval-Spec-to-RTL/Prob135_m2014_q6b/gain/power_vs_area.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N01_cell_retention_mode/package/ppa_distribution/figures/all_backends/VerilogEval-Spec-to-RTL/Prob153_gshare/absolute/area_vs_effective_clock_period.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N01_cell_retention_mode/package/ppa_distribution/figures/all_backends/VerilogEval-Spec-to-RTL/Prob153_gshare/absolute/power_vs_area.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N01_cell_retention_mode/package/ppa_distribution/figures/all_backends/VerilogEval-Spec-to-RTL/Prob153_gshare/absolute/power_vs_effective_clock_period.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N01_cell_retention_mode/package/ppa_distribution/figures/all_backends/VerilogEval-Spec-to-RTL/Prob153_gshare/gain/area_vs_effective_clock_period.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N01_cell_retention_mode/package/ppa_distribution/figures/all_backends/VerilogEval-Spec-to-RTL/Prob153_gshare/gain/power_vs_area.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N01_cell_retention_mode/package/ppa_distribution/figures/all_backends/VerilogEval-Spec-to-RTL/Prob153_gshare/gain/power_vs_effective_clock_period.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N01_cell_retention_mode/package/ppa_distribution/report.md
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N01_cell_retention_mode/package/ppa_distribution/summary.json
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N01_cell_retention_mode/package/tables/hv_auc.csv
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N01_cell_retention_mode/package/tables/operator_contract.csv
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N01_cell_retention_mode/package/tables/run_validation_elite_pareto_slot_2.json
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N01_cell_retention_mode/package/tables/run_validation_scalar_elite.json
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N01_cell_retention_mode/results_report.md
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/package/pareto_analysis/aggregate_backend_metrics.csv
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/package/pareto_analysis/backend_problem_metrics.csv
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/package/pareto_analysis/problems/RTLLM/Prob015_multi_pipe_8bit/front_3d.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/package/pareto_analysis/problems/RTLLM/Prob015_multi_pipe_8bit/pairwise_fronts.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/package/pareto_analysis/problems/RTLLM/Prob024_fsm/pairwise_fronts.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/package/pareto_analysis/problems/RTLLM/Prob041_traffic_light/pairwise_fronts.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/package/pareto_analysis/problems/RTLLM/Prob045_alu/pairwise_fronts.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/package/pareto_analysis/problems/RTLLM/Prob049_signal_generator/front_3d.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/package/pareto_analysis/problems/RTLLM/Prob049_signal_generator/pairwise_fronts.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/package/pareto_analysis/problems/VerilogEval-Spec-to-RTL/Prob116_m2014_q3/pairwise_fronts.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/package/pareto_analysis/problems/VerilogEval-Spec-to-RTL/Prob135_m2014_q6b/pairwise_fronts.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/package/pareto_analysis/problems/VerilogEval-Spec-to-RTL/Prob153_gshare/front_3d.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/package/pareto_analysis/problems/VerilogEval-Spec-to-RTL/Prob153_gshare/pairwise_fronts.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/package/pareto_analysis/report.md
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/package/pareto_analysis/summary.json
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/package/ppa_distribution/data/best_candidate_by_backend_problem.csv
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/package/ppa_distribution/data/ppa_candidates.csv
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/package/ppa_distribution/data/reference_ppa_metrics.csv
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/package/ppa_distribution/figures/all_backends/RTLLM/Prob015_multi_pipe_8bit/absolute/area_vs_effective_clock_period.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/package/ppa_distribution/figures/all_backends/RTLLM/Prob015_multi_pipe_8bit/absolute/power_vs_area.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/package/ppa_distribution/figures/all_backends/RTLLM/Prob015_multi_pipe_8bit/absolute/power_vs_effective_clock_period.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/package/ppa_distribution/figures/all_backends/RTLLM/Prob015_multi_pipe_8bit/gain/area_vs_effective_clock_period.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/package/ppa_distribution/figures/all_backends/RTLLM/Prob015_multi_pipe_8bit/gain/power_vs_area.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/package/ppa_distribution/figures/all_backends/RTLLM/Prob015_multi_pipe_8bit/gain/power_vs_effective_clock_period.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/package/ppa_distribution/figures/all_backends/RTLLM/Prob024_fsm/absolute/power_vs_area.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/package/ppa_distribution/figures/all_backends/RTLLM/Prob024_fsm/gain/power_vs_area.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/package/ppa_distribution/figures/all_backends/RTLLM/Prob041_traffic_light/absolute/power_vs_area.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/package/ppa_distribution/figures/all_backends/RTLLM/Prob041_traffic_light/gain/power_vs_area.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/package/ppa_distribution/figures/all_backends/RTLLM/Prob045_alu/absolute/power_vs_area.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/package/ppa_distribution/figures/all_backends/RTLLM/Prob045_alu/gain/power_vs_area.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/package/ppa_distribution/figures/all_backends/RTLLM/Prob049_signal_generator/absolute/area_vs_effective_clock_period.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/package/ppa_distribution/figures/all_backends/RTLLM/Prob049_signal_generator/absolute/power_vs_area.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/package/ppa_distribution/figures/all_backends/RTLLM/Prob049_signal_generator/absolute/power_vs_effective_clock_period.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/package/ppa_distribution/figures/all_backends/RTLLM/Prob049_signal_generator/gain/area_vs_effective_clock_period.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/package/ppa_distribution/figures/all_backends/RTLLM/Prob049_signal_generator/gain/power_vs_area.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/package/ppa_distribution/figures/all_backends/RTLLM/Prob049_signal_generator/gain/power_vs_effective_clock_period.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/package/ppa_distribution/figures/all_backends/VerilogEval-Spec-to-RTL/Prob116_m2014_q3/absolute/power_vs_area.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/package/ppa_distribution/figures/all_backends/VerilogEval-Spec-to-RTL/Prob116_m2014_q3/gain/power_vs_area.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/package/ppa_distribution/figures/all_backends/VerilogEval-Spec-to-RTL/Prob135_m2014_q6b/absolute/power_vs_area.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/package/ppa_distribution/figures/all_backends/VerilogEval-Spec-to-RTL/Prob135_m2014_q6b/gain/power_vs_area.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/package/ppa_distribution/figures/all_backends/VerilogEval-Spec-to-RTL/Prob153_gshare/absolute/area_vs_effective_clock_period.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/package/ppa_distribution/figures/all_backends/VerilogEval-Spec-to-RTL/Prob153_gshare/absolute/power_vs_area.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/package/ppa_distribution/figures/all_backends/VerilogEval-Spec-to-RTL/Prob153_gshare/absolute/power_vs_effective_clock_period.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/package/ppa_distribution/figures/all_backends/VerilogEval-Spec-to-RTL/Prob153_gshare/gain/area_vs_effective_clock_period.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/package/ppa_distribution/figures/all_backends/VerilogEval-Spec-to-RTL/Prob153_gshare/gain/power_vs_area.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/package/ppa_distribution/figures/all_backends/VerilogEval-Spec-to-RTL/Prob153_gshare/gain/power_vs_effective_clock_period.png
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/package/ppa_distribution/report.md
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/package/ppa_distribution/summary.json
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/package/tables/hv_auc.csv
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/package/tables/operator_contract.csv
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/package/tables/run_validation_warmup_16.json
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/package/tables/run_validation_warmup_4.json
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/results_report.md
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N06_descriptor_bakeoff/methodology.md
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N06_descriptor_bakeoff/probes/probe_journal_graph_testability_3d.json
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N06_descriptor_bakeoff/probes/probe_random_hash_3d.json
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N06_descriptor_bakeoff/probes/probe_size_control_3d.json
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N06_descriptor_bakeoff/research_memo.md
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/lane_registry.csv
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/natural_qd_push_implementation_history.md
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/natural_qd_push_implementation_todo.md
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/p0_v2_anchor/commands.md
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/p0_v2_anchor/replication/seed_1002/run_validation.json
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/p0_v2_anchor/replication/seed_1003/run_validation.json
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/p0_v2_anchor/tables/run_validation.json
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/p0_v2_anchor/tables/three_seed_summary.csv
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/reviews/codex_second_opinion_20260703_p1.md
scripts/report_screen_seed_summary.py
scripts/run_backend.py
scripts/validate_natural_qd_run.py
tests/revolution/test_qd_natural_engine.py
tests/scripts/test_report_screen_seed_summary.py
tests/scripts/test_validate_natural_qd_run.py

codex
I’ve got the governing constraints now. The plan’s hard gates matter here: single-seed reads can diagnose, but kills/promotions require the registered seed ladder unless a lane is clearly outside the near-tie band under its own rules.
exec
/bin/bash -lc 'nl -ba docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N01_cell_retention_mode/results_report.md' in /workspace
 succeeded in 0ms:
     1	# N01 Cell Retention Mode — Seed-1001 Result (2026-07-03)
     2	
     3	Runs: `exp/natural_qd_push/n01_cell_retention_20260703_053243_UTC/`
     4	(both arms 8/8 coverage; operator contracts pass, zero single-thought,
     5	zero M-T; config-pinned validations pass; package under `package/`).
     6	
     7	## Read (frozen 8-design 8x5, seed 1001; comparators from the anchor)
     8	
     9	| Arm | Cell retention | Mean HV | vs classic | vs V2 | Pareto pts |
    10	| --- | --- | --- | --- | --- | --- |
    11	| classic | population (no archive) | 0.14064 | - | -19.1% | 3.25 |
    12	| N01b scalar_elite | 1 scalar elite/cell | 0.14683 | +4.4% | -15.5% | 3.375 |
    13	| N01a elite_pareto_slot_2 | champion + 1 front slot | 0.15709 | +11.7% | -9.6% | 3.125 |
    14	| V2 anchor | bounded Pareto front (<=5) | 0.17376 | +23.5% | - | 2.625 |
    15	
    16	## Interpretation (single seed; attribution, not promotion)
    17	
    18	- **Retention capacity is monotone in mean HV on this seed**: classic
    19	  0.1406 -> scalar cells 0.1468 -> one front slot 0.1571 -> 5-elite
    20	  Pareto cells 0.1738. This is the cleanest mechanism-attribution
    21	  ladder the program has produced: archive+NSGA-II selection alone
    22	  (+4.4%) and per-cell Pareto retention (+8.7 points more) both
    23	  contribute; the frozen thesis's "bounded per-cell Pareto fronts
    24	  instead of scalar replacement" carries most of the margin.
    25	- Pareto POINTS run the other way (3.375 -> 3.125 -> 2.625): richer
    26	  cells concentrate front mass into dominating designs rather than
    27	  many shallow points. HV is the gate metric; breadth is reported.
    28	- Neither arm approaches the promotion bar (>2% over V2), as expected —
    29	  these are attribution controls, not challengers.
    30	
    31	## Tier decision
    32	
    33	Both arms: diagnostic keepers (attribution controls). No promotion, no
    34	kill (both beat classic with coverage retained). Registered follow-up
    35	(per card, only after a 3-seed read if pursued): a capacity ablation
    36	ABOVE 5 (pareto_front, max 7) is the natural probe of where the
    37	retention curve saturates — new card required before any launch.
    38	Seed replication for the attribution ladder is queued behind the
    39	challenger lanes (N06/N03/N02) on budget priority.

exec
/bin/bash -lc 'nl -ba docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/results_report.md' in /workspace
 succeeded in 0ms:
     1	# N05 Warmup Length — Seed-1001 Result (2026-07-03)
     2	
     3	Runs: `exp/natural_qd_push/n05_warmup_init_20260703_053243_UTC/`
     4	(both arms 8/8 coverage; operator contracts pass; config-pinned
     5	validations pass; package under `package/`).
     6	
     7	## Read (frozen 8-design 8x5, seed 1001)
     8	
     9	| Arm | Warmup successes | Mean HV | vs classic | vs V2 | Pareto pts |
    10	| --- | --- | --- | --- | --- | --- |
    11	| N05a warmup_4 | 4 | 0.14927 | +6.1% | -14.1% | 2.75 |
    12	| V2 anchor | 8 (platform) | 0.17376 | +23.5% | - | 2.625 |
    13	| N05b warmup_16 | 16 | 0.16383 | +16.5% | -5.7% | 2.0 |
    14	
    15	## Interpretation and tier decision
    16	
    17	Deviating from the platform's warmup 8 in EITHER direction costs HV on
    18	this seed (-14.1% shorter, -5.7% longer), with no coverage effect.
    19	Cause class: mechanism-inert-at-platform-optimum — the quantile-freeze
    20	length matters, and 8 already sits near the optimum for this budget
    21	shape; there is no path to the promotion bar here. Per the registered
    22	follow-up rule ("if neither direction improves on V2, retire rather
    23	than scanning more values"): **lane retired** at seed-1001 evidence
    24	strength, recorded as a positive tuning validation of the platform
    25	value rather than a mechanism discovery. Follow-up idea (backlog, not
    26	registered): warmup interacts with budget shape — revisit only inside
    27	N04 if the depth arm (6x7) is run, where warmup 8 covers a different
    28	fraction of the run.

exec
/bin/bash -lc 'nl -ba docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N01_cell_retention_mode/methodology.md && nl -ba docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/methodology.md' in /workspace
 succeeded in 0ms:
     1	# N01 Cell Retention Mode — Pre-Registration (2026-07-03)
     2	
     3	Status: registered before any run; blocked on the P0 V2 anchor package.
     4	
     5	## Mechanism (single factor: `qd_cell_mode` + its paired capacity)
     6	
     7	REvolution-QD, but each archive cell retains candidates under a
     8	different rule than the platform's bounded per-cell Pareto front:
     9	
    10	- **N01a `elite_pareto_slot_2`**: each cell keeps its scalar champion
    11	  plus one bounded non-dominated front slot
    12	  (`--qd_cell_mode elite_pareto_slot --qd_max_elites_per_cell 2`) —
    13	  the T36/T37 one-bounded-front-slot semantic.
    14	- **N01b `scalar_elite`**: each cell keeps only its scalar champion
    15	  (`--qd_cell_mode scalar_elite --qd_max_elites_per_cell 1`) — the
    16	  retention-ablation control.
    17	
    18	Everything else is byte-identical to the pinned V2 anchor command
    19	(`../../tables/v2_platform_config.md`), which runs `pareto_front` with
    20	5 elites per cell.
    21	
    22	## Natural-Extension Criterion check
    23	
    24	1. One sentence each: "V2, but cells keep champion + one front slot"
    25	   / "V2, but cells keep one elite". 2. Knobs changed: `qd_cell_mode`
    26	   (+ paired `qd_max_elites_per_cell`) — one mechanism, no triggers.
    27	   3. Single factor vs V2. 4. Operators/representation/budget/eval
    28	   identical. 5. Published concepts: MAP-Elites scalar cells; bounded
    29	   per-cell fronts (MOME-family).
    30	
    31	## Prior evidence
    32	
    33	- T36/T37 (replay, `T2_replay_candidate`): one bounded front slot
    34	  +4.04% HV vs lexical baseline; never run live under `eoh_strategies`
    35	  (T51-T59 live family used `single_thought_operator` — contaminated,
    36	  not citable as negative evidence).
    37	- F5 (radical config, 5-seed): pareto_front vs scalar_elite +0.013,
    38	  seed-dependent, inconclusive — N01b re-answers this on the V2
    39	  platform, operator-fair.
    40	
    41	## Descriptor inputs / leakage
    42	
    43	Frozen trio `journal_logic_ff_width_3d` (logic_depth, ff_depth,
    44	comb_width_log) unchanged; no PPA/fitness/HV/rank/pass-rate/problem-id
    45	inputs. Cell retention uses evaluated PPA for within-cell selection —
    46	selection, not a descriptor (plan delta 5).
    47	
    48	## Surface, comparators, gates
    49	
    50	- Surface: frozen 8-design 8x5 screen (`../../tables/screen_manifest.csv`),
    51	  seed 1001 first; seeds 1002/1003 per the +-5% ladder.
    52	- Comparators: pinned classic (0.14064478405974706 seed-1001;
    53	  0.14418173149368419 3-seed) and the V2 anchor (P0).
    54	- Gates: plan "Gates" section verbatim (kill <0.95x classic 3-seed mean
    55	  HV or coverage loss; promote >= classic 3-seed HV and HV-AUC with
    56	  coverage retained). Verdicts also read the N01x-vs-V2 delta to
    57	  attribute the retention effect.
    58	
    59	## Artifacts (per arm)
    60	
    61	`exp/natural_qd_push/n01_cell_retention_<UTC>/live/<arm>/seed_<s>/` with
    62	preflight capture + launch log; package under this directory: commands,
    63	`ppa_candidates`-level tables, operator audit
    64	(`scripts/audit_operator_contract.py`), run validation
    65	(`scripts/validate_natural_qd_run.py --arm qd`), canonical HV-AUC
    66	(`scripts/report_hv_auc.py`), direct raw PPA Pareto PNG first, tier
    67	decision, follow-up-or-retirement note.
    68	
    69	## Registered follow-up rule
    70	
    71	If N01a leads V2 and classic on seed 1001, replicate before any wider
    72	capacity sweep; a capacity ablation (`elite_pareto_slot` max 3) may be
    73	registered only after the 3-seed read, as a new card.
     1	# N05 Warmup Initialization — Pre-Registration (2026-07-03)
     2	
     3	Status: registered before any run; blocked on the P0 V2 anchor package.
     4	
     5	## Mechanism (single factor: quantile-freeze warmup length)
     6	
     7	REvolution-QD, but the grid-quantile archive freezes its bin boundaries
     8	after a different number of buffered successes:
     9	`--qd_grid_quantile_warmup_successes {4 | 16}` (arms N05a / N05b) vs
    10	the platform's 8. A shorter warmup starts archive-structured pressure
    11	earlier; a longer one gives boundary estimation more evidence before
    12	binning (the standard MAP-Elites random-init phase length — a fixed
    13	schedule, not a trigger). Everything else identical to the pinned V2
    14	anchor command.
    15	
    16	## Natural-Extension Criterion check
    17	
    18	1. "V2, but the archive's init phase is shorter (or longer)." 2. Knob:
    19	   one integer, fixed schedule, no runtime trigger. 3. Single factor vs
    20	   V2. 4. Operators/representation/budget/eval identical. 5. Published
    21	   concept: MAP-Elites initialization-phase length.
    22	
    23	## Prior evidence
    24	
    25	T39 (operator-fair, `T0_positive_ablation`): shortening warmup 8 -> 4
    26	fixed multi-pipe coverage in the sparse-yield family — the only
    27	warmup-family read taken under `eoh_strategies`, and it was positive on
    28	the yield/coverage axis. Never read on the V2 platform.
    29	
    30	## Descriptor inputs / leakage
    31	
    32	Frozen trio unchanged; warmup uses success counts only (no PPA-derived
    33	descriptor inputs).
    34	
    35	## Surface, comparators, gates
    36	
    37	Same as N01/N03: frozen 8-design 8x5, seed ladder 1001 -> 1002/1003;
    38	comparators = pinned classic + V2 anchor; plan gates verbatim, with
    39	special attention to the coverage hard gate (this is the
    40	yield-protection lane — a win that costs any classic-covered design is
    41	still a kill).
    42	
    43	## Artifacts (per arm)
    44	
    45	`exp/natural_qd_push/n05_warmup_init_<UTC>/live/<arm>/seed_<s>/` plus
    46	the standard package (operator audit, run validation, canonical HV-AUC,
    47	direct raw PPA Pareto PNG, tier decision, follow-up note).
    48	
    49	## Registered follow-up rule
    50	
    51	Pick at most one direction (shorter or longer) from seed 1001; if
    52	neither moves HV or coverage relative to V2 beyond noise, retire the
    53	lane as mechanism-inert rather than scanning more values.

exec
/bin/bash -lc 'nl -ba docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N01_cell_retention_mode/package/tables/hv_auc.csv && nl -ba docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/package/tables/hv_auc.csv' in /workspace
 succeeded in 0ms:
     1	backend,problem,circuit_type,hv_final,hv_auc
     2	classic_revolution_8x5,Prob015_multi_pipe_8bit,sequential,0,0
     3	classic_revolution_8x5,Prob024_fsm,combinational,0.144729433844,0.124225836722
     4	classic_revolution_8x5,Prob041_traffic_light,combinational,0.310100217865,0.247459694989
     5	classic_revolution_8x5,Prob045_alu,combinational,0.252356392667,0.224868446679
     6	classic_revolution_8x5,Prob049_signal_generator,sequential,0.0191988404409,0.0161314760327
     7	classic_revolution_8x5,Prob116_m2014_q3,combinational,0.398422797928,0.378175751295
     8	classic_revolution_8x5,Prob135_m2014_q6b,combinational,0,0
     9	classic_revolution_8x5,Prob153_gshare,sequential,0.000350589733405,0.000129712855621
    10	elite_pareto_slot_2,Prob015_multi_pipe_8bit,sequential,0.000976452289862,9.76452289862e-05
    11	elite_pareto_slot_2,Prob024_fsm,combinational,0.340631842352,0.21306850172
    12	elite_pareto_slot_2,Prob041_traffic_light,combinational,0.290652505447,0.226042737836
    13	elite_pareto_slot_2,Prob045_alu,combinational,0.20595240686,0.193754234575
    14	elite_pareto_slot_2,Prob049_signal_generator,sequential,0.0191140773484,0.017459289876
    15	elite_pareto_slot_2,Prob116_m2014_q3,combinational,0.398422797928,0.398422797928
    16	elite_pareto_slot_2,Prob135_m2014_q6b,combinational,0,0
    17	elite_pareto_slot_2,Prob153_gshare,sequential,0.000955798047039,0.0004535870038
    18	scalar_elite,Prob015_multi_pipe_8bit,sequential,0,0
    19	scalar_elite,Prob024_fsm,combinational,0.269002189553,0.196890835158
    20	scalar_elite,Prob041_traffic_light,combinational,0.287139251997,0.245055646333
    21	scalar_elite,Prob045_alu,combinational,0.200086083185,0.175132721073
    22	scalar_elite,Prob049_signal_generator,sequential,0.0209152930631,0.014748778087
    23	scalar_elite,Prob116_m2014_q3,combinational,0.397440414508,0.397377202073
    24	scalar_elite,Prob135_m2014_q6b,combinational,0,0
    25	scalar_elite,Prob153_gshare,sequential,5.58276755488e-05,2.42020790387e-05
    26	smooth_qd_v2_8x5,Prob015_multi_pipe_8bit,sequential,0,0
    27	smooth_qd_v2_8x5,Prob024_fsm,combinational,0.340631842352,0.238442289646
    28	smooth_qd_v2_8x5,Prob041_traffic_light,combinational,0.408417211329,0.296758061002
    29	smooth_qd_v2_8x5,Prob045_alu,combinational,0.231821801696,0.205658561798
    30	smooth_qd_v2_8x5,Prob049_signal_generator,sequential,0.00997131828859,0.00965758889264
    31	smooth_qd_v2_8x5,Prob116_m2014_q3,combinational,0.398422797928,0.3980773057
    32	smooth_qd_v2_8x5,Prob135_m2014_q6b,combinational,0,0
    33	smooth_qd_v2_8x5,Prob153_gshare,sequential,0.000845050463025,0.000685475096293
     1	backend,problem,circuit_type,hv_final,hv_auc
     2	classic_revolution_8x5,Prob015_multi_pipe_8bit,sequential,0,0
     3	classic_revolution_8x5,Prob024_fsm,combinational,0.144729433844,0.124225836722
     4	classic_revolution_8x5,Prob041_traffic_light,combinational,0.310100217865,0.247459694989
     5	classic_revolution_8x5,Prob045_alu,combinational,0.252356392667,0.224868446679
     6	classic_revolution_8x5,Prob049_signal_generator,sequential,0.0191988404409,0.0161314760327
     7	classic_revolution_8x5,Prob116_m2014_q3,combinational,0.398422797928,0.378175751295
     8	classic_revolution_8x5,Prob135_m2014_q6b,combinational,0,0
     9	classic_revolution_8x5,Prob153_gshare,sequential,0.000350589733405,0.000129712855621
    10	smooth_qd_v2_8x5,Prob015_multi_pipe_8bit,sequential,0,0
    11	smooth_qd_v2_8x5,Prob024_fsm,combinational,0.340631842352,0.238442289646
    12	smooth_qd_v2_8x5,Prob041_traffic_light,combinational,0.408417211329,0.296758061002
    13	smooth_qd_v2_8x5,Prob045_alu,combinational,0.231821801696,0.205658561798
    14	smooth_qd_v2_8x5,Prob049_signal_generator,sequential,0.00997131828859,0.00965758889264
    15	smooth_qd_v2_8x5,Prob116_m2014_q3,combinational,0.398422797928,0.3980773057
    16	smooth_qd_v2_8x5,Prob135_m2014_q6b,combinational,0,0
    17	smooth_qd_v2_8x5,Prob153_gshare,sequential,0.000845050463025,0.000685475096293
    18	warmup_16,Prob015_multi_pipe_8bit,sequential,0,0
    19	warmup_16,Prob024_fsm,combinational,0.340631842352,0.238442289646
    20	warmup_16,Prob041_traffic_light,combinational,0.332588235294,0.311997857661
    21	warmup_16,Prob045_alu,combinational,0.225130652474,0.177908972994
    22	warmup_16,Prob049_signal_generator,sequential,0.0146216334483,0.0122853507126
    23	warmup_16,Prob116_m2014_q3,combinational,0.397336787565,0.397252849741
    24	warmup_16,Prob135_m2014_q6b,combinational,0,0
    25	warmup_16,Prob153_gshare,sequential,0.000327098738581,3.27098738581e-05
    26	warmup_4,Prob015_multi_pipe_8bit,sequential,0,0
    27	warmup_4,Prob024_fsm,combinational,0.202690021896,0.126362214576
    28	warmup_4,Prob041_traffic_light,combinational,0.35630573711,0.231184822077
    29	warmup_4,Prob045_alu,combinational,0.218364399763,0.191411090085
    30	warmup_4,Prob049_signal_generator,sequential,0.0180545386927,0.0140844473499
    31	warmup_4,Prob116_m2014_q3,combinational,0.398422797928,0.398422797928
    32	warmup_4,Prob135_m2014_q6b,combinational,0,0
    33	warmup_4,Prob153_gshare,sequential,0.000327098738581,9.81296215743e-05

exec
/bin/bash -lc 'nl -ba docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N01_cell_retention_mode/package/pareto_analysis/aggregate_backend_metrics.csv && nl -ba docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/package/pareto_analysis/aggregate_backend_metrics.csv' in /workspace
 succeeded in 0ms:
     1	backend,benchmark,problem_count,pareto_valid_problem_count,mean_hypervolume,mean_pareto_point_count,mean_reference_beating_count,hypervolume_win_count
     2	classic_revolution_8x5,ALL,8,8,0.14064478405974706,3.25,8.0,2
     3	classic_revolution_8x5,RTLLM,5,5,0.1452769769634218,3.6,10.6,1
     4	classic_revolution_8x5,VerilogEval-Spec-to-RTL,3,3,0.13292446255362253,2.6666666666666665,3.6666666666666665,1
     5	elite_pareto_slot_2,ALL,8,8,0.15708823503393493,3.125,8.25,2
     6	elite_pareto_slot_2,RTLLM,5,5,0.17146545685939565,3.8,11.8,1
     7	elite_pareto_slot_2,VerilogEval-Spec-to-RTL,3,3,0.13312619865816705,2.0,2.3333333333333335,1
     8	scalar_elite,ALL,8,8,0.14682988249771348,3.375,6.875,1
     9	scalar_elite,RTLLM,5,5,0.1554285635596774,3.4,10.0,1
    10	scalar_elite,VerilogEval-Spec-to-RTL,3,3,0.1324987473944403,3.3333333333333335,1.6666666666666667,0
    11	smooth_qd_v2_8x5,ALL,8,8,0.17376375275693837,2.625,7.875,3
    12	smooth_qd_v2_8x5,RTLLM,5,5,0.1981684347330043,3.0,10.2,2
    13	smooth_qd_v2_8x5,VerilogEval-Spec-to-RTL,3,3,0.13308928279682847,2.0,4.0,1
     1	backend,benchmark,problem_count,pareto_valid_problem_count,mean_hypervolume,mean_pareto_point_count,mean_reference_beating_count,hypervolume_win_count
     2	classic_revolution_8x5,ALL,8,8,0.14064478405974706,3.25,8.0,3
     3	classic_revolution_8x5,RTLLM,5,5,0.1452769769634218,3.6,10.6,2
     4	classic_revolution_8x5,VerilogEval-Spec-to-RTL,3,3,0.13292446255362253,2.6666666666666665,3.6666666666666665,1
     5	smooth_qd_v2_8x5,ALL,8,8,0.17376375275693837,2.625,7.875,4
     6	smooth_qd_v2_8x5,RTLLM,5,5,0.1981684347330043,3.0,10.2,2
     7	smooth_qd_v2_8x5,VerilogEval-Spec-to-RTL,3,3,0.13308928279682847,2.0,4.0,2
     8	warmup_16,ALL,8,8,0.1638295312339896,2.0,6.5,1
     9	warmup_16,RTLLM,5,5,0.1825944727137136,2.2,9.4,1
    10	warmup_16,VerilogEval-Spec-to-RTL,3,3,0.13255462876778296,1.6666666666666667,1.6666666666666667,0
    11	warmup_4,ALL,8,8,0.1492705742659306,2.75,7.0,0
    12	warmup_4,RTLLM,5,5,0.15908293949228033,3.0,10.0,0
    13	warmup_4,VerilogEval-Spec-to-RTL,3,3,0.13291663222201439,2.3333333333333335,2.0,0

codex
The package tables match the high-level numbers at first glance, but two review questions hinge on framing: N01 is written as attribution, while N05 is treated as retirement against V2 rather than the plan’s classic promotion gate. I’m checking the exact CSV arithmetic and then the registered card language.
exec
/bin/bash -lc 'git status --short --branch && git log --oneline --decorate --graph --max-count=12' in /workspace
exec
/bin/bash -lc 'nl -ba docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/p0_v2_anchor/tables/three_seed_summary.csv' in /workspace
 succeeded in 0ms:
     1	seed,baseline_mean_hv,treatment_mean_hv,treatment_over_baseline_pct,baseline_mean_hv_auc,treatment_mean_hv_auc,baseline_coverage,treatment_coverage,baseline_pareto_pts,treatment_pareto_pts
     2	1001,0.14064478405974706,0.17376375275693837,123.5,0.123873865,0.143659910,8/8,8/8,3.25,2.625
     3	1002,0.15936940200276137,0.17179976188570917,107.8,0.129962880,0.151323348,8/8,8/8,2.125,2.0
     4	1003,0.13253100841854415,0.1429425878468403,107.9,0.111401655,0.129256461,8/8,8/8,2.875,3.125
     5	mean,0.14418173149368418,0.16283536749649596,112.9,0.121746133,0.141413240,,,,

exec
/bin/bash -lc "python - <<'PY'
import csv
from pathlib import Path
root = Path('docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes')
for lane in ['N01_cell_retention_mode', 'N05_warmup_init']:
    rows = [r for r in csv.DictReader((root / lane / 'package/tables/hv_auc.csv').open())]
    means = {}
    for backend in sorted({r['backend'] for r in rows}):
        subset = [r for r in rows if r['backend'] == backend]
        means[backend] = (sum(float(r['hv_final']) for r in subset) / len(subset), sum(float(r['hv_auc']) for r in subset) / len(subset))
    classic = means['classic_revolution_8x5']
    v2 = means['smooth_qd_v2_8x5']
    print(lane)
    for backend, (hv, auc) in means.items():
        print(f'  {backend}: vs classic hv={(hv/classic[0]-1)*100:.3f}% auc={(auc/classic[1]-1)*100:.3f}%; vs V2 hv={(hv/v2[0]-1)*100:.3f}% auc={(auc/v2[1]-1)*100:.3f}%')
    print()
PY" in /workspace
 succeeded in 0ms:
N01_cell_retention_mode
  classic_revolution_8x5: vs classic hv=0.000% auc=0.000%; vs V2 hv=-19.060% auc=-13.773%
  elite_pareto_slot_2: vs classic hv=11.691% auc=5.884%; vs V2 hv=-9.597% auc=-8.699%
  scalar_elite: vs classic hv=4.398% auc=3.859%; vs V2 hv=-15.500% auc=-10.446%
  smooth_qd_v2_8x5: vs classic hv=23.548% auc=15.973%; vs V2 hv=0.000% auc=0.000%

N05_warmup_init
  classic_revolution_8x5: vs classic hv=0.000% auc=0.000%; vs V2 hv=-19.060% auc=-13.773%
  smooth_qd_v2_8x5: vs classic hv=23.548% auc=15.973%; vs V2 hv=0.000% auc=0.000%
  warmup_16: vs classic hv=16.485% auc=14.826%; vs V2 hv=-5.717% auc=-0.988%
  warmup_4: vs classic hv=6.133% auc=-2.969%; vs V2 hv=-14.096% auc=-16.333%


exec
/bin/bash -lc "python - <<'PY'
import csv
from pathlib import Path
root = Path('docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes')
for lane in ['N01_cell_retention_mode', 'N05_warmup_init']:
    hv_path = root / lane / 'package/tables/hv_auc.csv'
    agg_path = root / lane / 'package/pareto_analysis/aggregate_backend_metrics.csv'
    rows = list(csv.DictReader(hv_path.open()))
    print(lane)
    for backend in sorted({r['backend'] for r in rows}):
        subset = [r for r in rows if r['backend'] == backend]
        mean_hv = sum(float(r['hv_final']) for r in subset) / len(subset)
        mean_auc = sum(float(r['hv_auc']) for r in subset) / len(subset)
        print(f'  hv_auc mean {backend}: hv={mean_hv:.12f} auc={mean_auc:.12f}')
    for r in csv.DictReader(agg_path.open()):
        if r['benchmark'] == 'ALL':
            print(f\"  aggregate {r['backend']}: hv={float(r['mean_hypervolume']):.12f} pts={float(r['mean_pareto_point_count']):.6f} cov={r['pareto_valid_problem_count']}/{r['problem_count']}\")
    print()
PY" in /workspace
 succeeded in 0ms:
N01_cell_retention_mode
  hv_auc mean classic_revolution_8x5: hv=0.140644784060 auc=0.123873864822
  hv_auc mean elite_pareto_slot_2: hv=0.157088235034 auc=0.131162349271
  hv_auc mean scalar_elite: hv=0.146829882498 auc=0.128653673100
  hv_auc mean smooth_qd_v2_8x5: hv=0.173763752757 auc=0.143659910267
  aggregate classic_revolution_8x5: hv=0.140644784060 pts=3.250000 cov=8/8
  aggregate elite_pareto_slot_2: hv=0.157088235034 pts=3.125000 cov=8/8
  aggregate scalar_elite: hv=0.146829882498 pts=3.375000 cov=8/8
  aggregate smooth_qd_v2_8x5: hv=0.173763752757 pts=2.625000 cov=8/8

N05_warmup_init
  hv_auc mean classic_revolution_8x5: hv=0.140644784060 auc=0.123873864822
  hv_auc mean smooth_qd_v2_8x5: hv=0.173763752757 auc=0.143659910267
  hv_auc mean warmup_16: hv=0.163829531234 auc=0.142240003829
  hv_auc mean warmup_4: hv=0.149270574266 auc=0.120195437705
  aggregate classic_revolution_8x5: hv=0.140644784060 pts=3.250000 cov=8/8
  aggregate smooth_qd_v2_8x5: hv=0.173763752757 pts=2.625000 cov=8/8
  aggregate warmup_16: hv=0.163829531234 pts=2.000000 cov=8/8
  aggregate warmup_4: hv=0.149270574266 pts=2.750000 cov=8/8


 succeeded in 5172ms:
## feat/journal-qd-bd-exp-20260703
 M docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/reviews/codex_second_opinion_20260703_p1.md
?? .devcontainer/devcontainer-lock.json
* ae83252bf3 (HEAD -> feat/journal-qd-bd-exp-20260703) docs(qd): Adopt codex second-opinion review channel
* f186b45f13 docs(qd): Package P1 reads; retire N05; queue chain 2
* f239b925ba docs(qd): Upgrade N06 to active descriptor bake-off
* c1e020b16b docs(qd): Refresh anchor package via new tooling
* a08a7577f1 fix(qd): Require explicit curiosity gamma flag
* 8084a41605 feat(qd): Add screen seed summary reporter
* 751815dbc2 feat(qd): Add config pins to the run validator
* 6fa46cfc77 docs(qd): Apply periodic review doc actions
* d67bd320b9 docs(qd): Record 3-seed V2 screen win over classic
* 3dd78d575f docs(qd): Package V2 anchor seed-1001 result
* 8d8f382995 docs(qd): Add lane command cards; sequence N03 on N01a
* 70abe23478 docs(qd): Register anchor packaging and N02 status

codex
The recomputation confirms the report tables’ mean HV and Pareto-point values. The N05 detail that stands out is HV-AUC: `warmup_16` is only -0.99% vs V2 on AUC while +14.8% vs classic, which makes the retirement rationale more delicate than the prose suggests.
exec
/bin/bash -lc 'nl -ba docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N06_descriptor_bakeoff/methodology.md' in /workspace
 succeeded in 0ms:
     1	# N06 Descriptor Bake-Off — Pre-Registration (2026-07-03)
     2	
     3	Status: UPGRADED from conditional to active at user request (2026-07-03,
     4	"research whether V2 improves via empirically strong, theoretically
     5	grounded descriptors"); evidence base in `research_memo.md`. Contract
     6	basis: the narrative freezes the trio "unless a bake-off winner beats
     7	it under the predeclared rule" — this is that predeclared bake-off, run
     8	for the first time on an operator-fair platform. Blocked on: P1 chain
     9	completion (endpoint discipline) and the offline descriptor probe step.
    10	
    11	## Mechanism (single factor per wave-1 arm: `--qd_descriptor_profile`)
    12	
    13	REvolution-QD V2, but the archive's behavior space is a different
    14	registered descriptor profile. Wave 1 (pure single-factor swaps on the
    15	pinned V2 anchor command, grid_quantile unchanged, all axes 3-D):
    16	
    17	- **N06b `journal_graph_testability_3d`** — cyclomatic complexity +
    18	  reconvergent-sink ratio + SCOAP signal smoothness. The semantic
    19	  challenger: decision-structure/testability theory; held the archive
    20	  open where the trio collapsed (F12 occupancy 0.50 vs 0.12); its only
    21	  negative read was quality under the RADICAL substrate.
    22	- **N06c `size_control_3d`** — the structural control bar: beat theory
    23	  profiles on QD score/quality/breadth under operator-fair CODE-EoH;
    24	  no semantic story by design.
    25	- **N06d random-descriptor control** — the falsification floor (T22
    26	  precedent: random is not weak); uses the registered deterministic
    27	  random profile from the T86 legality work (probe confirms the exact
    28	  profile name before launch).
    29	
    30	Wave 2 (registered now, launched only after wave-1 reads):
    31	
    32	- **N06a `theory_grounded_compact_8d`** — SCOAP histograms + Laplacian
    33	  spectral entropy; zero axis collapses on 13/13 operator-fair. 8-D
    34	  axes require `--qd_archive_type cvt` (grid-quantile cells are not
    35	  meaningful at 8-D with 16 cells), making it two-factor vs V2.
    36	  Versioned criterion note (the N03 pattern): N06a is therefore paired
    37	  with its own control arm `v2_trio_cvt` (trio descriptors on CVT,
    38	  same cells) so the descriptor effect is attributed from
    39	  N06a-vs-v2_trio_cvt, not vs the grid V2 anchor.
    40	
    41	## Probe step (before any live spend)
    42	
    43	Run the descriptor probe (June-25 pattern) for every arm profile:
    44	resolve axes with `requires_ppa=false`, confirm extraction on a sample
    45	of existing V2-anchor candidates, confirm archive mechanics
    46	(grid-quantile binning for 3-D arms; CVT centroid init for 8-D), and
    47	record the probe JSONs under this lane before launch. Any axis that
    48	fails to resolve or collapses on the probe sample kills that arm before
    49	spend.
    50	
    51	## Natural-Extension Criterion check
    52	
    53	1. "V2, but the archive bins designs by testability/decision structure
    54	   (or cell mix, or random control) instead of depth/width." 2. Knobs:
    55	   the profile name (wave 2 adds archive type, with its paired
    56	   control). 3. Single factor per wave-1 arm. 4. Operators,
    57	   representation, budgets, evaluation identical; descriptor inputs
    58	   contain no PPA/fitness/HV/rank/pass-rate/problem-id (all wave-1
    59	   axes are RTL/netlist-structural; SCOAP/Laplacian are graph
    60	   quantities). 5. Published concepts: SCOAP testability, spectral
    61	   graph connectivity, cyclomatic/reconvergence structure, MAP-Elites
    62	   random-descriptor control.
    63	
    64	## Surface, comparators, gates
    65	
    66	Frozen 8-design 8x5 screen, seed ladder 1001 -> 1002/1003. Comparators:
    67	the V2 anchor (trio, 3 seeds, mean HV 0.16284 / HV-AUC 0.14141) and
    68	pinned classic. Plan gates verbatim, plus lane-specific reads:
    69	- A challenger profile is interesting only if it beats BOTH the V2 trio
    70	  anchor AND the N06d random floor on mean HV/HV-AUC with coverage
    71	  retained; beating the trio alone is not a descriptor claim (T22
    72	  lesson).
    73	- Archive-health co-read per arm: axis-collapse count and occupied
    74	  cells from `descriptor_health` artifacts; a profile that wins HV but
    75	  collapses is reported as an optimization result, not a diversity
    76	  result.
    77	- Promotion interplay: the registered promotion-arm rule (V2 unless a
    78	  lane beats it by >2% on both metrics) applies unchanged.
    79	
    80	## Artifacts (per arm)
    81	
    82	`exp/natural_qd_push/n06_descriptor_bakeoff_<UTC>/live/<arm>/seed_<s>/`
    83	plus the standard package (operator audit, run validation with
    84	`--expect-config qd_descriptor_profile=<name>`, canonical HV-AUC,
    85	seed-summary via the tracked reporter, direct raw PPA Pareto PNG,
    86	descriptor-health tables, tier decision, follow-up note).
    87	
    88	## Registered follow-ups (not wave-1 arms)
    89	
    90	- SR ReLU PCA (T19 family): strongest descriptor-isolating replay
    91	  signal on record (+16.82% HV); requires a new frozen-projection
    92	  profile spec, a synthesis pass, and a frozen holdout — register as
    93	  its own card only if wave 1 produces no >2% winner.
    94	- `source_aligned_shape_density_3d` (T73 axes): yield-positive under
    95	  STO-LIVE; a candidate wave-2 arm if wave 1 shows descriptor traction
    96	  but the specific profiles stall.

exec
/bin/bash -lc 'nl -ba docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N06_descriptor_bakeoff/research_memo.md' in /workspace
 succeeded in 0ms:
     1	# N06 Research Memo — Descriptor Evidence Base (2026-07-03)
     2	
     3	Question (user request 2026-07-03): can Smooth-QD V2 be improved by
     4	behavioral descriptors that perform well empirically AND have solid
     5	theoretical grounding? Evidence assembled from the F12 bake-off, the
     6	theory-grounded descriptor program, the June-22 replay/live packages,
     7	and the profile registry, with a regime flag on every result.
     8	
     9	## Regime taxonomy (why most prior descriptor negatives do not bind V2)
    10	
    11	- RADICAL: thought_only + single unified operator (F12 bake-off, M13).
    12	- STO-LIVE: single_thought_operator live screens (T63-T87 family).
    13	- CODE-EoH: code_individual + EoH suite, CVT archive — operator-fair,
    14	  V2-adjacent (theory Stage 6/11, briefing 06/07 component runs).
    15	- REPLAY: passive re-scoring of fixed candidates — descriptor-isolating
    16	  (T01-T22, T36/T37).
    17	- V2: the target platform. **No descriptor bake-off has ever run here.**
    18	
    19	## Load-bearing findings
    20	
    21	1. F12 ("no profile beats classic on PPA") ran RADICAL, on the fast
    22	   6-problem subset. The June-18 briefing's own read: "descriptor/
    23	   archive tweaks don't rescue quality — the deficit is in
    24	   representation + operator, not the archive." It answered "can a BD
    25	   rescue the broken substrate" (no), not "which BD maximizes V2".
    26	2. The trio's collapse IS substrate-independent: F12 (14 collapses,
    27	   worst of four), M13 (circuit7 5/5 seeds, fsmonehot 4/5), and the
    28	   operator-fair CODE-EoH component run (ff_depth collapses 7/13,
    29	   circuit7 occupied_cells=1). Structural causes: comb_width_log is a
    30	   size proxy collinear with the area objective (diversity claim
    31	   formally dropped at freeze); ff_depth has no variance on
    32	   combinational/shallow-FSM designs; logic_depth is the one validated
    33	   axis (M4: 31/32 agree with yosys ltp) but cannot hold a 3-D archive
    34	   open alone on small control logic.
    35	3. Collapse-health ranking (F12): simple_2d (2) > graph_testability
    36	   (8) > activity (12) > trio (14). Median occupancy: graph_testability
    37	   0.50 vs trio 0.12.
    38	4. Operator-fair CODE-EoH: structural profiles (size_control,
    39	   implemented_structural) beat both theory profiles on QD score, best
    40	   quality, and Pareto breadth; theory_grounded_compact_8d had ZERO
    41	   axis collapses on 13/13 with all centroids initialized (Stage 11)
    42	   but trails structural on score; theory_grounded_full_20d is
    43	   coverage-strong, score-weak, with unreliable Rent extraction
    44	   (boundary-clamping 4/5 cases).
    45	5. Replay (descriptor-isolating): SR ReLU PCA (T19) is the strongest
    46	   signal on record (+16.82% mean HV, +65% HV-AUC vs lexical, beats
    47	   the random control) but needs a new profile spec + synthesis pass +
    48	   frozen holdout. Random control T22 is NOT weak (+75% front netlists,
    49	   +35% HV-AUC vs lexical) — every challenger must beat random, not
    50	   just the trio.
    51	6. Excluded by the push rules: learned/pretrained encoders (MGVGA
    52	   projection behind T36's +4.04% replay; Qwen/DeepGate lanes) and
    53	   simulation-dependent activity axes (verilator-incompatible,
    54	   12 collapses).
    55	
    56	## Theoretical rationales of the viable families
    57	
    58	- SCOAP testability (controllability/observability histograms):
    59	  classic DFT theory; varies on exactly the small control logic where
    60	  the trio collapses; orthogonal to size/PPA.
    61	- Spectral connectivity (normalized-Laplacian entropy/lambda2):
    62	  graph-partitioning theory; captures structural modularity.
    63	- Cyclomatic complexity + reconvergent-fanout ratio: decision-structure
    64	  and reconvergence theory; reviewer-legible; defined pre-synthesis.
    65	- Cell-mix/size structural ratios: the honest control family — no
    66	  semantic story, empirically strong under CODE-EoH.
    67	- Operator-graph shape + wire/register density (source-aligned T73
    68	  axes): retiming/topology proxies; yield-positive under STO-LIVE
    69	  (294 vs 257 valid-PPA) with HV loss unresolved (regime-confounded).
    70	
    71	## Conclusion feeding the registration
    72	
    73	Run the first-ever V2-platform descriptor bake-off as pure single-factor
    74	`--qd_descriptor_profile` swaps, wave 1 = three 3-D registered profiles
    75	(graph_testability, size_control structural bar, random floor) against
    76	the existing V2-trio 3-seed anchor; wave 2 = compact-8d theory profile,
    77	which requires CVT pairing (two-factor; own paired control) and a
    78	descriptor probe first. SR-PCA stays a registered follow-up idea, not a
    79	wave-1 arm.

exec
/bin/bash -lc 'nl -ba docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/lane_registry.csv' in /workspace
 succeeded in 0ms:
     1	lane_id,slug,family,mechanism,new_knobs,status,notes
     2	N01,cell_retention_mode,cell_retention,"V2 with qd_cell_mode swapped: N01a elite_pareto_slot (max 2; T36 one-front-slot semantic); N01b scalar_elite control","qd_cell_mode (+paired capacity)",registered_draft,"V2 platform already runs pareto_front(5); T36/T37 replay +4.04% never live operator-fair; F5 +0.013 inconclusive"
     3	N02,pareto_biased_parent_sampling,parent_selection,"V2 selection upsampling local-front and underfilled-cell members","sampling_weight",registered_draft,"idea backlog item; untried; needs small module + focused tests"
     4	N03,archive_parent_lane,parent_selection,"fixed fraction of parents drawn from archive front slots","lane_fraction (0.10/0.30)",registered_draft,"T54/T75 precedent contaminated; never measured operator-fair"
     5	N04,budget_shape,budget_shape,"leader (or V2) at 6x7 vs matched classic 6x7; 4x11 conditional","none (shape choice)",registered_draft,"T78 late maturation support; T79 negative bound to contaminated T75 arm"
     6	N05,warmup_init,initialization,"archive pressure starts after fixed generation g0","warmup_generations",registered_draft,"T39 operator-fair positive ablation; yield-protection lane"
     7	N06,descriptor_bakeoff,descriptor,"first V2-platform descriptor bake-off: wave 1 = journal_graph_testability_3d / size_control_3d / random floor as pure profile swaps; wave 2 = theory_grounded_compact_8d on CVT with paired trio-CVT control","profile choice (wave 2 + archive type)",registered_active,"upgraded at user request 2026-07-03; F12 negative is RADICAL-regime-confounded; trio collapse is substrate-independent; see research_memo.md"
     8	N07,corrected_suite_completion,revalidation,"operator-fair screen of three never-rerun corrected profiles","none",conditional,"due diligence; lowest priority; encoder lanes do not headline"
     9	N08,combination_arm,combination,"pre-registered merge of measured single-factor winners","inherited only",blocked_on_p1,"only from single-factor winners; pre-register before any run"

exec
/bin/bash -lc 'for f in docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N06_descriptor_bakeoff/probes/*.json; do echo "$f"; nl -ba "$f" | sed -n '"'1,130p'; done" in /workspace
 succeeded in 0ms:
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N06_descriptor_bakeoff/probes/probe_journal_graph_testability_3d.json
     1	{
     2	  "axes": [
     3	    "rtl_cyclomatic_total_log",
     4	    "reconv_sink_ratio",
     5	    "scoap_signal_smoothness"
     6	  ],
     7	  "requirements": {
     8	    "requires_ppa": false,
     9	    "requires_synthesis": false,
    10	    "requires_formal": false,
    11	    "requires_rtl_metrics": true,
    12	    "requires_dynamic_metrics": false,
    13	    "requires_graph_metrics": true,
    14	    "requires_source_aligned_rtl": false,
    15	    "requires_source_aligned_rf_timing": false,
    16	    "requires_auto_bd_hash": false,
    17	    "requires_auto_bd_motif": false,
    18	    "requires_auto_bd_stage_dumps": false,
    19	    "requires_auto_bd_sr_pca": false,
    20	    "requires_auto_bd_sr_vq": false,
    21	    "requires_qwen_rtl_embedding": false,
    22	    "requires_deepgate_pooled_embedding": false
    23	  },
    24	  "summary": [
    25	    {
    26	      "name": "rtl_cyclomatic_total_log",
    27	      "source_tool": "yosys_ast",
    28	      "transform": "log1p",
    29	      "requires_ppa": false,
    30	      "requires_synthesis": false,
    31	      "requires_simulation": false,
    32	      "requires_graph_metrics": false,
    33	      "requires_source_aligned_rtl": false,
    34	      "requires_source_aligned_rf_timing": false,
    35	      "requires_auto_bd_motif": false,
    36	      "requires_auto_bd_stage_dumps": false,
    37	      "requires_auto_bd_sr_pca": false,
    38	      "requires_auto_bd_sr_vq": false,
    39	      "requires_qwen_rtl_embedding": false,
    40	      "requires_deepgate_pooled_embedding": false
    41	    },
    42	    {
    43	      "name": "reconv_sink_ratio",
    44	      "source_tool": "yosys_graph",
    45	      "transform": "identity",
    46	      "requires_ppa": false,
    47	      "requires_synthesis": false,
    48	      "requires_simulation": false,
    49	      "requires_graph_metrics": true,
    50	      "requires_source_aligned_rtl": false,
    51	      "requires_source_aligned_rf_timing": false,
    52	      "requires_auto_bd_motif": false,
    53	      "requires_auto_bd_stage_dumps": false,
    54	      "requires_auto_bd_sr_pca": false,
    55	      "requires_auto_bd_sr_vq": false,
    56	      "requires_qwen_rtl_embedding": false,
    57	      "requires_deepgate_pooled_embedding": false
    58	    },
    59	    {
    60	      "name": "scoap_signal_smoothness",
    61	      "source_tool": "yosys_graph",
    62	      "transform": "identity",
    63	      "requires_ppa": false,
    64	      "requires_synthesis": false,
    65	      "requires_simulation": false,
    66	      "requires_graph_metrics": true,
    67	      "requires_source_aligned_rtl": false,
    68	      "requires_source_aligned_rf_timing": false,
    69	      "requires_auto_bd_motif": false,
    70	      "requires_auto_bd_stage_dumps": false,
    71	      "requires_auto_bd_sr_pca": false,
    72	      "requires_auto_bd_sr_vq": false,
    73	      "requires_qwen_rtl_embedding": false,
    74	      "requires_deepgate_pooled_embedding": false
    75	    }
    76	  ]
    77	}
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N06_descriptor_bakeoff/probes/probe_random_hash_3d.json
     1	{
     2	  "axes": [
     3	    "random_hash_0",
     4	    "random_hash_1",
     5	    "random_hash_2"
     6	  ],
     7	  "requirements": {
     8	    "requires_ppa": false,
     9	    "requires_synthesis": true,
    10	    "requires_formal": false,
    11	    "requires_rtl_metrics": false,
    12	    "requires_dynamic_metrics": false,
    13	    "requires_graph_metrics": false,
    14	    "requires_source_aligned_rtl": false,
    15	    "requires_source_aligned_rf_timing": false,
    16	    "requires_auto_bd_hash": true,
    17	    "requires_auto_bd_motif": false,
    18	    "requires_auto_bd_stage_dumps": false,
    19	    "requires_auto_bd_sr_pca": false,
    20	    "requires_auto_bd_sr_vq": false,
    21	    "requires_qwen_rtl_embedding": false,
    22	    "requires_deepgate_pooled_embedding": false
    23	  },
    24	  "summary": [
    25	    {
    26	      "name": "random_hash_0",
    27	      "source_tool": "auto_bd_hash",
    28	      "transform": "identity",
    29	      "requires_ppa": false,
    30	      "requires_synthesis": true,
    31	      "requires_simulation": false,
    32	      "requires_graph_metrics": false,
    33	      "requires_source_aligned_rtl": false,
    34	      "requires_source_aligned_rf_timing": false,
    35	      "requires_auto_bd_motif": false,
    36	      "requires_auto_bd_stage_dumps": false,
    37	      "requires_auto_bd_sr_pca": false,
    38	      "requires_auto_bd_sr_vq": false,
    39	      "requires_qwen_rtl_embedding": false,
    40	      "requires_deepgate_pooled_embedding": false
    41	    },
    42	    {
    43	      "name": "random_hash_1",
    44	      "source_tool": "auto_bd_hash",
    45	      "transform": "identity",
    46	      "requires_ppa": false,
    47	      "requires_synthesis": true,
    48	      "requires_simulation": false,
    49	      "requires_graph_metrics": false,
    50	      "requires_source_aligned_rtl": false,
    51	      "requires_source_aligned_rf_timing": false,
    52	      "requires_auto_bd_motif": false,
    53	      "requires_auto_bd_stage_dumps": false,
    54	      "requires_auto_bd_sr_pca": false,
    55	      "requires_auto_bd_sr_vq": false,
    56	      "requires_qwen_rtl_embedding": false,
    57	      "requires_deepgate_pooled_embedding": false
    58	    },
    59	    {
    60	      "name": "random_hash_2",
    61	      "source_tool": "auto_bd_hash",
    62	      "transform": "identity",
    63	      "requires_ppa": false,
    64	      "requires_synthesis": true,
    65	      "requires_simulation": false,
    66	      "requires_graph_metrics": false,
    67	      "requires_source_aligned_rtl": false,
    68	      "requires_source_aligned_rf_timing": false,
    69	      "requires_auto_bd_motif": false,
    70	      "requires_auto_bd_stage_dumps": false,
    71	      "requires_auto_bd_sr_pca": false,
    72	      "requires_auto_bd_sr_vq": false,
    73	      "requires_qwen_rtl_embedding": false,
    74	      "requires_deepgate_pooled_embedding": false
    75	    }
    76	  ]
    77	}
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N06_descriptor_bakeoff/probes/probe_size_control_3d.json
     1	{
     2	  "axes": [
     3	    "wire_count_log_est",
     4	    "assign_count",
     5	    "ctrl_depth_est"
     6	  ],
     7	  "requirements": {
     8	    "requires_ppa": false,
     9	    "requires_synthesis": false,
    10	    "requires_formal": false,
    11	    "requires_rtl_metrics": true,
    12	    "requires_dynamic_metrics": false,
    13	    "requires_graph_metrics": false,
    14	    "requires_source_aligned_rtl": false,
    15	    "requires_source_aligned_rf_timing": false,
    16	    "requires_auto_bd_hash": false,
    17	    "requires_auto_bd_motif": false,
    18	    "requires_auto_bd_stage_dumps": false,
    19	    "requires_auto_bd_sr_pca": false,
    20	    "requires_auto_bd_sr_vq": false,
    21	    "requires_qwen_rtl_embedding": false,
    22	    "requires_deepgate_pooled_embedding": false
    23	  },
    24	  "summary": [
    25	    {
    26	      "name": "wire_count_log_est",
    27	      "source_tool": "rtl_estimator",
    28	      "transform": "identity",
    29	      "requires_ppa": false,
    30	      "requires_synthesis": false,
    31	      "requires_simulation": false,
    32	      "requires_graph_metrics": false,
    33	      "requires_source_aligned_rtl": false,
    34	      "requires_source_aligned_rf_timing": false,
    35	      "requires_auto_bd_motif": false,
    36	      "requires_auto_bd_stage_dumps": false,
    37	      "requires_auto_bd_sr_pca": false,
    38	      "requires_auto_bd_sr_vq": false,
    39	      "requires_qwen_rtl_embedding": false,
    40	      "requires_deepgate_pooled_embedding": false
    41	    },
    42	    {
    43	      "name": "assign_count",
    44	      "source_tool": "rtl_text",
    45	      "transform": "identity",
    46	      "requires_ppa": false,
    47	      "requires_synthesis": false,
    48	      "requires_simulation": false,
    49	      "requires_graph_metrics": false,
    50	      "requires_source_aligned_rtl": false,
    51	      "requires_source_aligned_rf_timing": false,
    52	      "requires_auto_bd_motif": false,
    53	      "requires_auto_bd_stage_dumps": false,
    54	      "requires_auto_bd_sr_pca": false,
    55	      "requires_auto_bd_sr_vq": false,
    56	      "requires_qwen_rtl_embedding": false,
    57	      "requires_deepgate_pooled_embedding": false
    58	    },
    59	    {
    60	      "name": "ctrl_depth_est",
    61	      "source_tool": "yosys_ast",
    62	      "transform": "identity",
    63	      "requires_ppa": false,
    64	      "requires_synthesis": false,
    65	      "requires_simulation": false,
    66	      "requires_graph_metrics": false,
    67	      "requires_source_aligned_rtl": false,
    68	      "requires_source_aligned_rf_timing": false,
    69	      "requires_auto_bd_motif": false,
    70	      "requires_auto_bd_stage_dumps": false,
    71	      "requires_auto_bd_sr_pca": false,
    72	      "requires_auto_bd_sr_vq": false,
    73	      "requires_qwen_rtl_embedding": false,
    74	      "requires_deepgate_pooled_embedding": false
    75	    }
    76	  ]
    77	}

codex
N06’s registration has the right high-level controls: random floor, structural bar, and a paired CVT control for the 8-D wave. The probe artifacts are lighter than the methodology promises, so I’m checking whether they actually prove extraction/collapse health or only declare profile requirements.
exec
/bin/bash -lc 'nl -ba scripts/report_screen_seed_summary.py' in /workspace
 succeeded in 0ms:
     1	#!/usr/bin/env python3
     2	"""Emit the per-seed screen summary table from packaged analysis outputs.
     3	
     4	One row per seed plus a mean row, generated from the tracked
     5	``aggregate_backend_metrics.csv`` (pareto analysis) and canonical
     6	``hv_auc.csv`` of each seed package — the reproducible path for tables
     7	like ``p0_v2_anchor/tables/three_seed_summary.csv`` (periodic review
     8	action F-3: no hand-copied numbers).
     9	"""
    10	
    11	from __future__ import annotations
    12	
    13	import argparse
    14	import csv
    15	from pathlib import Path
    16	
    17	FIELDS = [
    18	    "seed",
    19	    "baseline_mean_hv",
    20	    "treatment_mean_hv",
    21	    "treatment_over_baseline_pct",
    22	    "baseline_mean_hv_auc",
    23	    "treatment_mean_hv_auc",
    24	    "baseline_coverage",
    25	    "treatment_coverage",
    26	    "baseline_pareto_pts",
    27	    "treatment_pareto_pts",
    28	]
    29	
    30	
    31	def parse_seed_spec(spec: str) -> tuple[str, Path, Path]:
    32	    seed, aggregate_csv, hv_auc_csv = spec.split(":", 2)
    33	    return seed, Path(aggregate_csv), Path(hv_auc_csv)
    34	
    35	
    36	def read_aggregate(path: Path, backend: str) -> dict[str, str]:
    37	    with path.open(newline="", encoding="utf-8") as handle:
    38	        rows = [
    39	            row
    40	            for row in csv.DictReader(handle)
    41	            if row["backend"] == backend and row["benchmark"] == "ALL"
    42	        ]
    43	    assert len(rows) == 1, (path, backend)
    44	    return rows[0]
    45	
    46	
    47	def mean_hv_auc(path: Path, backend: str) -> float:
    48	    with path.open(newline="", encoding="utf-8") as handle:
    49	        values = [
    50	            float(row["hv_auc"])
    51	            for row in csv.DictReader(handle)
    52	            if row["backend"] == backend
    53	        ]
    54	    assert values, (path, backend)
    55	    return sum(values) / len(values)
    56	
    57	
    58	def main(argv: list[str] | None = None) -> int:
    59	    parser = argparse.ArgumentParser(description=__doc__)
    60	    parser.add_argument(
    61	        "--seed",
    62	        action="append",
    63	        required=True,
    64	        type=parse_seed_spec,
    65	        help="SEED:aggregate_backend_metrics.csv:hv_auc.csv (repeatable).",
    66	    )
    67	    parser.add_argument("--baseline", required=True)
    68	    parser.add_argument("--treatment", required=True)
    69	    parser.add_argument("--output", type=Path, required=True)
    70	    args = parser.parse_args(argv)
    71	
    72	    rows: list[dict[str, str]] = []
    73	    base_hv_total = treat_hv_total = base_auc_total = treat_auc_total = 0.0
    74	    for seed, aggregate_csv, hv_auc_csv in args.seed:
    75	        base = read_aggregate(aggregate_csv, args.baseline)
    76	        treat = read_aggregate(aggregate_csv, args.treatment)
    77	        base_hv = float(base["mean_hypervolume"])
    78	        treat_hv = float(treat["mean_hypervolume"])
    79	        base_auc = mean_hv_auc(hv_auc_csv, args.baseline)
    80	        treat_auc = mean_hv_auc(hv_auc_csv, args.treatment)
    81	        base_hv_total += base_hv
    82	        treat_hv_total += treat_hv
    83	        base_auc_total += base_auc
    84	        treat_auc_total += treat_auc
    85	        rows.append(
    86	            {
    87	                "seed": seed,
    88	                "baseline_mean_hv": base["mean_hypervolume"],
    89	                "treatment_mean_hv": treat["mean_hypervolume"],
    90	                "treatment_over_baseline_pct": f"{treat_hv / base_hv * 100:.1f}",
    91	                "baseline_mean_hv_auc": f"{base_auc:.9f}",
    92	                "treatment_mean_hv_auc": f"{treat_auc:.9f}",
    93	                "baseline_coverage": f"{base['pareto_valid_problem_count']}/{base['problem_count']}",
    94	                "treatment_coverage": f"{treat['pareto_valid_problem_count']}/{treat['problem_count']}",
    95	                "baseline_pareto_pts": base["mean_pareto_point_count"],
    96	                "treatment_pareto_pts": treat["mean_pareto_point_count"],
    97	            }
    98	        )
    99	    count = len(rows)
   100	    rows.append(
   101	        {
   102	            "seed": "mean",
   103	            "baseline_mean_hv": f"{base_hv_total / count:.17g}",
   104	            "treatment_mean_hv": f"{treat_hv_total / count:.17g}",
   105	            "treatment_over_baseline_pct": f"{treat_hv_total / base_hv_total * 100:.1f}",
   106	            "baseline_mean_hv_auc": f"{base_auc_total / count:.9f}",
   107	            "treatment_mean_hv_auc": f"{treat_auc_total / count:.9f}",
   108	            "baseline_coverage": "",
   109	            "treatment_coverage": "",
   110	            "baseline_pareto_pts": "",
   111	            "treatment_pareto_pts": "",
   112	        }
   113	    )
   114	    args.output.parent.mkdir(parents=True, exist_ok=True)
   115	    with args.output.open("w", newline="", encoding="utf-8") as handle:
   116	        writer = csv.DictWriter(handle, fieldnames=FIELDS, lineterminator="\n")
   117	        writer.writeheader()
   118	        writer.writerows(rows)
   119	    return 0
   120	
   121	
   122	if __name__ == "__main__":
   123	    raise SystemExit(main())

exec
/bin/bash -lc 'wc -l scripts/validate_natural_qd_run.py scripts/report_screen_seed_summary.py src/revolution/qd_natural/engine.py && nl -ba scripts/validate_natural_qd_run.py' in /workspace
 succeeded in 0ms:
  168 scripts/validate_natural_qd_run.py
  123 scripts/report_screen_seed_summary.py
  109 src/revolution/qd_natural/engine.py
  400 total
     1	#!/usr/bin/env python3
     2	"""Validate one natural-QD-push run root against the push run contract.
     3	
     4	Checks, per the natural_qd_push plan (2026-07-03):
     5	
     6	- every manifest ``(benchmark, problem)`` maps to exactly one problem dir
     7	  with a non-empty ``generation_log.jsonl`` under the run root;
     8	- zero ``single_thought_operator`` candidates; classic arms use only the
     9	  EoH suite; QD arms may additionally emit ``M-T`` (the QD engine's
    10	  thought-mutation lane under ``eoh_strategies`` — the 20260630 corrected
    11	  suite accepted it, and the audit CSV keeps its count visible);
    12	- QD arms (``--arm qd``) carry ``archive_summary.json`` and
    13	  ``qd_metrics.json`` in every problem dir; classic arms
    14	  (``--arm classic``) carry neither;
    15	- every ``--expect-config KEY=VALUE`` matches the run's resolved
    16	  ``*_revolution_config.yaml`` (the registered-card-vs-run guard that
    17	  the unfaithful first anchor showed is needed);
    18	- per-problem and total ``llm_api_calls`` are reported (budget-parity
    19	  visibility; informational, not a gate).
    20	
    21	Writes a JSON report and exits nonzero on any violation.
    22	"""
    23	
    24	from __future__ import annotations
    25	
    26	import argparse
    27	import csv
    28	import json
    29	from pathlib import Path
    30	
    31	import yaml
    32	
    33	EOH_STRATEGIES = frozenset({"M-S", "M-R", "M-I", "C-F", "M-E", "M-F"})
    34	ALLOWED_BY_ARM = {
    35	    "classic": EOH_STRATEGIES | {"initial"},
    36	    "qd": EOH_STRATEGIES | {"initial", "M-T"},
    37	}
    38	QD_ARTIFACTS = ("archive_summary.json", "qd_metrics.json")
    39	
    40	
    41	def load_manifest(path: Path) -> list[tuple[str, str]]:
    42	    with path.open(newline="", encoding="utf-8") as handle:
    43	        rows = list(csv.DictReader(handle))
    44	    assert rows
    45	    return [(row["benchmark"], row["problem"]) for row in rows]
    46	
    47	
    48	def problem_dirs(run_root: Path) -> dict[tuple[str, str], Path]:
    49	    """Map (benchmark, problem) to its problem dir via generation logs."""
    50	    found: dict[tuple[str, str], Path] = {}
    51	    for log_path in sorted(run_root.rglob("generation_log.jsonl")):
    52	        problem_dir = log_path.parent
    53	        key = (problem_dir.parent.name, problem_dir.name)
    54	        assert key not in found, f"duplicate problem dir for {key}"
    55	        found[key] = problem_dir
    56	    return found
    57	
    58	
    59	def config_errors(run_root: Path, expected: list[str]) -> list[str]:
    60	    """Check KEY=VALUE expectations against the resolved run config."""
    61	    if not expected:
    62	        return []
    63	    config_paths = sorted(run_root.rglob("*_revolution_config.yaml"))
    64	    if not config_paths:
    65	        return ["no *_revolution_config.yaml under run root"]
    66	    config = yaml.safe_load(config_paths[0].read_text(encoding="utf-8"))
    67	    assert isinstance(config, dict)
    68	    errors: list[str] = []
    69	    for item in expected:
    70	        key, _, want = item.partition("=")
    71	        assert want, f"--expect-config needs KEY=VALUE, got {item!r}"
    72	        if key not in config:
    73	            errors.append(f"config key {key!r} missing")
    74	        elif str(config[key]) != want:
    75	            errors.append(f"config {key}={config[key]!r}, expected {want!r}")
    76	    return errors
    77	
    78	
    79	def llm_call_totals(problem_dirs: dict[tuple[str, str], Path]) -> dict[str, int]:
    80	    """Sum generation-log llm_api_calls per problem (budget visibility)."""
    81	    totals: dict[str, int] = {}
    82	    for (_, problem), problem_dir in sorted(problem_dirs.items()):
    83	        lines = (problem_dir / "generation_log.jsonl").read_text(encoding="utf-8")
    84	        rows = [json.loads(line) for line in lines.splitlines() if line.strip()]
    85	        totals[problem] = sum(int(row["llm_api_calls"]) for row in rows)
    86	    totals["TOTAL"] = sum(totals.values())
    87	    return totals
    88	
    89	
    90	def strategy_errors(problem_dir: Path, arm: str) -> list[str]:
    91	    """Aggregate per-generation strategy counts and flag forbidden ones."""
    92	    allowed = ALLOWED_BY_ARM[arm]
    93	    lines = (problem_dir / "generation_log.jsonl").read_text(encoding="utf-8")
    94	    rows = [json.loads(line) for line in lines.splitlines() if line.strip()]
    95	    if not rows:
    96	        return [f"{problem_dir.name}: empty generation_log.jsonl"]
    97	    errors: list[str] = []
    98	    for row in rows:
    99	        counts = row["strategy_counts_this_generation"]
   100	        assert isinstance(counts, dict)
   101	        for strategy, count in counts.items():
   102	            if strategy not in allowed and int(count) > 0:
   103	                errors.append(
   104	                    f"{problem_dir.name}: generation {row['generation']} used"
   105	                    f" forbidden strategy {strategy!r} ({count}x)"
   106	                )
   107	    return errors
   108	
   109	
   110	def main(argv: list[str] | None = None) -> int:
   111	    parser = argparse.ArgumentParser(description=__doc__)
   112	    parser.add_argument("--run-root", type=Path, required=True)
   113	    parser.add_argument("--manifest", type=Path, required=True)
   114	    parser.add_argument("--arm", choices=["classic", "qd"], required=True)
   115	    parser.add_argument(
   116	        "--expect-config",
   117	        action="append",
   118	        default=[],
   119	        help="KEY=VALUE to assert against the resolved run config YAML.",
   120	    )
   121	    parser.add_argument("--output", type=Path, required=True)
   122	    args = parser.parse_args(argv)
   123	    assert args.run_root.is_dir(), args.run_root
   124	
   125	    manifest = load_manifest(args.manifest)
   126	    found = problem_dirs(args.run_root)
   127	    errors: list[str] = []
   128	    errors.extend(config_errors(args.run_root, args.expect_config))
   129	
   130	    for key in manifest:
   131	        if key not in found:
   132	            errors.append(f"missing problem dir for {key[0]}/{key[1]}")
   133	    for key in found:
   134	        if key not in manifest:
   135	            errors.append(f"unexpected problem dir {key[0]}/{key[1]}")
   136	
   137	    for key, problem_dir in sorted(found.items()):
   138	        if key not in manifest:
   139	            continue
   140	        errors.extend(strategy_errors(problem_dir, args.arm))
   141	        for artifact in QD_ARTIFACTS:
   142	            present = (problem_dir / artifact).is_file()
   143	            if args.arm == "qd" and not present:
   144	                errors.append(f"{key[1]}: missing QD artifact {artifact}")
   145	            if args.arm == "classic" and present:
   146	                errors.append(f"{key[1]}: classic arm has QD artifact {artifact}")
   147	
   148	    report = {
   149	        "run_root": str(args.run_root),
   150	        "arm": args.arm,
   151	        "manifest": str(args.manifest),
   152	        "checked_problems": len(manifest),
   153	        "found_problems": len(found),
   154	        "expected_config": list(args.expect_config),
   155	        "llm_api_calls": llm_call_totals(
   156	            {key: path for key, path in found.items() if key in set(manifest)}
   157	        ),
   158	        "errors": errors,
   159	        "status": "fail" if errors else "pass",
   160	    }
   161	    args.output.parent.mkdir(parents=True, exist_ok=True)
   162	    args.output.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
   163	    print(f"validate_natural_qd_run: {report['status']} ({len(errors)} error(s))")
   164	    return 1 if errors else 0
   165	
   166	
   167	if __name__ == "__main__":
   168	    raise SystemExit(main())

exec
/bin/bash -lc 'nl -ba src/revolution/qd_natural/engine.py' in /workspace
 succeeded in 0ms:
     1	"""Lane N02: cell-curiosity weighted NSGA-II parent draws.
     2	
     3	``NaturalQDEngine`` changes exactly one mechanism relative to the
     4	Smooth-QD V2 platform: one-parent draws from the NSGA-II global pool
     5	are weighted by inverse archive-cell occupancy instead of uniform.
     6	Pool construction, champion lane, operators, and the C-F two-parent
     7	path are inherited unchanged from ``QDEngine``.
     8	"""
     9	
    10	from __future__ import annotations
    11	
    12	import random
    13	from collections import Counter
    14	from typing import Any, cast
    15	
    16	from revolution.algorithm import Heuristic
    17	from revolution.qd.archive import ranked_front
    18	from revolution.qd.engine import QDEngine
    19	from revolution.qd.types import ArchiveMember
    20	
    21	
    22	def curiosity_pool(
    23	    members_with_cells: list[tuple[str, ArchiveMember]],
    24	    objective_names: tuple[str, ...],
    25	    pool_size: int,
    26	    gamma: float,
    27	) -> tuple[list[Heuristic], list[float]]:
    28	    """NSGA-II-ranked parent pool with inverse-cell-occupancy draw weights.
    29	
    30	    Pool construction mirrors ``QDEngine._nsga2_global_pool`` (doc 16,
    31	    smooth-QD V2): rank every success member by global non-domination
    32	    rank, crowding distance, insertion index, and candidate id, then
    33	    keep the top ``pool_size``. Each kept member's draw weight is
    34	    ``(1 / occupancy(cell)) ** gamma`` with occupancy counted over the
    35	    full success archive, so members in under-populated cells are drawn
    36	    more often.
    37	
    38	    Args:
    39	        members_with_cells: ``(cell_id, member)`` pairs from
    40	            ``success_archive.members()``.
    41	        objective_names: Maximize-form objective keys for ranking.
    42	        pool_size: Pool cap (the V2 rule uses ``population_size``).
    43	        gamma: Curiosity exponent; must be positive (0 would silently
    44	            reproduce plain V2 — run that as the V2 arm instead).
    45	
    46	    Returns:
    47	        Parallel lists: pool payloads and their draw weights.
    48	    """
    49	    assert gamma > 0.0
    50	    assert pool_size >= 1
    51	    if not members_with_cells:
    52	        return [], []
    53	    occupancy = Counter(cell_id for cell_id, _ in members_with_cells)
    54	    cell_by_candidate = {
    55	        member.candidate_id: cell_id for cell_id, member in members_with_cells
    56	    }
    57	    ranked = ranked_front(
    58	        [member for _, member in members_with_cells], objective_names
    59	    )
    60	    ranked.sort(
    61	        key=lambda item: (
    62	            item.pareto_rank,
    63	            -item.crowding_distance,
    64	            item.member.insertion_index,
    65	            item.member.candidate_id,
    66	        )
    67	    )
    68	    kept = ranked[:pool_size]
    69	    pool = [cast(Heuristic, item.member.payload) for item in kept]
    70	    weights = [
    71	        (1.0 / occupancy[cell_by_candidate[item.member.candidate_id]]) ** gamma
    72	        for item in kept
    73	    ]
    74	    return pool, weights
    75	
    76	
    77	class NaturalQDEngine(QDEngine):
    78	    """QDEngine with curiosity-weighted one-parent draws (lane N02)."""
    79	
    80	    def __init__(self, *, qd_curiosity_gamma: float, **kwargs: Any) -> None:
    81	        super().__init__(**kwargs)
    82	        assert qd_curiosity_gamma > 0.0
    83	        assert self.qd_parent_selection == "nsga2_global_rank", (
    84	            "N02 curiosity draws compose only with nsga2_global_rank"
    85	        )
    86	        self.qd_curiosity_gamma = float(qd_curiosity_gamma)
    87	
    88	    def _sample_success_parents(self, count: int) -> list[Heuristic]:
    89	        pool, weights = curiosity_pool(
    90	            list(self.success_archive.members()),
    91	            self._objective_names(),
    92	            self.population_size,
    93	            self.qd_curiosity_gamma,
    94	        )
    95	        if not pool:
    96	            return super()._sample_success_parents(count)
    97	        champion_lane_fraction = self._active_champion_lane_fraction()
    98	        champion = (
    99	            self._global_best_success_member()
   100	            if champion_lane_fraction > 0.0
   101	            else None
   102	        )
   103	        parents: list[Heuristic] = []
   104	        for _ in range(count):
   105	            if champion is not None and random.random() < champion_lane_fraction:
   106	                parents.append(champion)  # champion lane: refine the best
   107	            else:
   108	                parents.append(random.choices(pool, weights=weights, k=1)[0])
   109	        return parents

exec
/bin/bash -lc 'git diff 6fa46cfc77..HEAD -- scripts/validate_natural_qd_run.py scripts/report_screen_seed_summary.py src/revolution/qd_natural/engine.py scripts/run_backend.py tests/scripts/test_validate_natural_qd_run.py tests/scripts/test_report_screen_seed_summary.py tests/revolution/test_qd_natural_engine.py' in /workspace
 succeeded in 0ms:
diff --git a/scripts/report_screen_seed_summary.py b/scripts/report_screen_seed_summary.py
new file mode 100644
index 0000000000..bdab4caae1
--- /dev/null
+++ b/scripts/report_screen_seed_summary.py
@@ -0,0 +1,123 @@
+#!/usr/bin/env python3
+"""Emit the per-seed screen summary table from packaged analysis outputs.
+
+One row per seed plus a mean row, generated from the tracked
+``aggregate_backend_metrics.csv`` (pareto analysis) and canonical
+``hv_auc.csv`` of each seed package — the reproducible path for tables
+like ``p0_v2_anchor/tables/three_seed_summary.csv`` (periodic review
+action F-3: no hand-copied numbers).
+"""
+
+from __future__ import annotations
+
+import argparse
+import csv
+from pathlib import Path
+
+FIELDS = [
+    "seed",
+    "baseline_mean_hv",
+    "treatment_mean_hv",
+    "treatment_over_baseline_pct",
+    "baseline_mean_hv_auc",
+    "treatment_mean_hv_auc",
+    "baseline_coverage",
+    "treatment_coverage",
+    "baseline_pareto_pts",
+    "treatment_pareto_pts",
+]
+
+
+def parse_seed_spec(spec: str) -> tuple[str, Path, Path]:
+    seed, aggregate_csv, hv_auc_csv = spec.split(":", 2)
+    return seed, Path(aggregate_csv), Path(hv_auc_csv)
+
+
+def read_aggregate(path: Path, backend: str) -> dict[str, str]:
+    with path.open(newline="", encoding="utf-8") as handle:
+        rows = [
+            row
+            for row in csv.DictReader(handle)
+            if row["backend"] == backend and row["benchmark"] == "ALL"
+        ]
+    assert len(rows) == 1, (path, backend)
+    return rows[0]
+
+
+def mean_hv_auc(path: Path, backend: str) -> float:
+    with path.open(newline="", encoding="utf-8") as handle:
+        values = [
+            float(row["hv_auc"])
+            for row in csv.DictReader(handle)
+            if row["backend"] == backend
+        ]
+    assert values, (path, backend)
+    return sum(values) / len(values)
+
+
+def main(argv: list[str] | None = None) -> int:
+    parser = argparse.ArgumentParser(description=__doc__)
+    parser.add_argument(
+        "--seed",
+        action="append",
+        required=True,
+        type=parse_seed_spec,
+        help="SEED:aggregate_backend_metrics.csv:hv_auc.csv (repeatable).",
+    )
+    parser.add_argument("--baseline", required=True)
+    parser.add_argument("--treatment", required=True)
+    parser.add_argument("--output", type=Path, required=True)
+    args = parser.parse_args(argv)
+
+    rows: list[dict[str, str]] = []
+    base_hv_total = treat_hv_total = base_auc_total = treat_auc_total = 0.0
+    for seed, aggregate_csv, hv_auc_csv in args.seed:
+        base = read_aggregate(aggregate_csv, args.baseline)
+        treat = read_aggregate(aggregate_csv, args.treatment)
+        base_hv = float(base["mean_hypervolume"])
+        treat_hv = float(treat["mean_hypervolume"])
+        base_auc = mean_hv_auc(hv_auc_csv, args.baseline)
+        treat_auc = mean_hv_auc(hv_auc_csv, args.treatment)
+        base_hv_total += base_hv
+        treat_hv_total += treat_hv
+        base_auc_total += base_auc
+        treat_auc_total += treat_auc
+        rows.append(
+            {
+                "seed": seed,
+                "baseline_mean_hv": base["mean_hypervolume"],
+                "treatment_mean_hv": treat["mean_hypervolume"],
+                "treatment_over_baseline_pct": f"{treat_hv / base_hv * 100:.1f}",
+                "baseline_mean_hv_auc": f"{base_auc:.9f}",
+                "treatment_mean_hv_auc": f"{treat_auc:.9f}",
+                "baseline_coverage": f"{base['pareto_valid_problem_count']}/{base['problem_count']}",
+                "treatment_coverage": f"{treat['pareto_valid_problem_count']}/{treat['problem_count']}",
+                "baseline_pareto_pts": base["mean_pareto_point_count"],
+                "treatment_pareto_pts": treat["mean_pareto_point_count"],
+            }
+        )
+    count = len(rows)
+    rows.append(
+        {
+            "seed": "mean",
+            "baseline_mean_hv": f"{base_hv_total / count:.17g}",
+            "treatment_mean_hv": f"{treat_hv_total / count:.17g}",
+            "treatment_over_baseline_pct": f"{treat_hv_total / base_hv_total * 100:.1f}",
+            "baseline_mean_hv_auc": f"{base_auc_total / count:.9f}",
+            "treatment_mean_hv_auc": f"{treat_auc_total / count:.9f}",
+            "baseline_coverage": "",
+            "treatment_coverage": "",
+            "baseline_pareto_pts": "",
+            "treatment_pareto_pts": "",
+        }
+    )
+    args.output.parent.mkdir(parents=True, exist_ok=True)
+    with args.output.open("w", newline="", encoding="utf-8") as handle:
+        writer = csv.DictWriter(handle, fieldnames=FIELDS, lineterminator="\n")
+        writer.writeheader()
+        writer.writerows(rows)
+    return 0
+
+
+if __name__ == "__main__":
+    raise SystemExit(main())
diff --git a/scripts/run_backend.py b/scripts/run_backend.py
index 053ba26e06..10f08e29d4 100644
--- a/scripts/run_backend.py
+++ b/scripts/run_backend.py
@@ -484,7 +484,11 @@ def _build_backend(
             qd_champion_lane_fraction=args.qd_champion_lane_fraction,
             qd_front_slot_lane_fraction=args.qd_front_slot_lane_fraction,
             qd_parent_selection=args.qd_parent_selection,
-            qd_curiosity_gamma=args.qd_curiosity_gamma,
+            qd_curiosity_gamma=(
+                args.qd_curiosity_gamma
+                if args.qd_curiosity_gamma is not None
+                else 1.0
+            ),
             qd_memory_classic_fraction=args.qd_memory_classic_fraction,
             qd_memory_refine_fraction=args.qd_memory_refine_fraction,
             qd_memory_rescue_fraction=args.qd_memory_rescue_fraction,
@@ -1127,10 +1131,10 @@ def _build_parser() -> tuple[argparse.ArgumentParser, argparse.ArgumentParser]:
     parser.add_argument(
         "--qd_curiosity_gamma",
         type=float,
-        default=1.0,
+        default=None,
         help=(
-            "Inverse-cell-occupancy draw exponent for "
-            "search_mode=revolution_qd_natural (lane N02)."
+            "Inverse-cell-occupancy draw exponent; required with (and only "
+            "valid for) search_mode=revolution_qd_natural (lane N02)."
         ),
     )
     parser.add_argument("--qd_parent_selection", type=str, default="cell_crowded_tournament",
@@ -1402,6 +1406,16 @@ def main(argv: list[str] | None = None) -> int:
         print(f"Configuration error: {exc}")
         return 2
 
+    if args.backend == "revolution" and (
+        (args.search_mode == "revolution_qd_natural")
+        != (args.qd_curiosity_gamma is not None)
+    ):
+        print(
+            "Configuration error: --qd_curiosity_gamma is required with, and "
+            "only valid for, search_mode=revolution_qd_natural."
+        )
+        return 2
+
     if (
         args.backend == "revolution"
         and args.search_mode in {"revolution_qd", "revolution_qd_natural"}
diff --git a/scripts/validate_natural_qd_run.py b/scripts/validate_natural_qd_run.py
index ebbe684fae..3221dc9f41 100644
--- a/scripts/validate_natural_qd_run.py
+++ b/scripts/validate_natural_qd_run.py
@@ -11,7 +11,12 @@ Checks, per the natural_qd_push plan (2026-07-03):
   suite accepted it, and the audit CSV keeps its count visible);
 - QD arms (``--arm qd``) carry ``archive_summary.json`` and
   ``qd_metrics.json`` in every problem dir; classic arms
-  (``--arm classic``) carry neither.
+  (``--arm classic``) carry neither;
+- every ``--expect-config KEY=VALUE`` matches the run's resolved
+  ``*_revolution_config.yaml`` (the registered-card-vs-run guard that
+  the unfaithful first anchor showed is needed);
+- per-problem and total ``llm_api_calls`` are reported (budget-parity
+  visibility; informational, not a gate).
 
 Writes a JSON report and exits nonzero on any violation.
 """
@@ -23,6 +28,8 @@ import csv
 import json
 from pathlib import Path
 
+import yaml
+
 EOH_STRATEGIES = frozenset({"M-S", "M-R", "M-I", "C-F", "M-E", "M-F"})
 ALLOWED_BY_ARM = {
     "classic": EOH_STRATEGIES | {"initial"},
@@ -49,6 +56,37 @@ def problem_dirs(run_root: Path) -> dict[tuple[str, str], Path]:
     return found
 
 
+def config_errors(run_root: Path, expected: list[str]) -> list[str]:
+    """Check KEY=VALUE expectations against the resolved run config."""
+    if not expected:
+        return []
+    config_paths = sorted(run_root.rglob("*_revolution_config.yaml"))
+    if not config_paths:
+        return ["no *_revolution_config.yaml under run root"]
+    config = yaml.safe_load(config_paths[0].read_text(encoding="utf-8"))
+    assert isinstance(config, dict)
+    errors: list[str] = []
+    for item in expected:
+        key, _, want = item.partition("=")
+        assert want, f"--expect-config needs KEY=VALUE, got {item!r}"
+        if key not in config:
+            errors.append(f"config key {key!r} missing")
+        elif str(config[key]) != want:
+            errors.append(f"config {key}={config[key]!r}, expected {want!r}")
+    return errors
+
+
+def llm_call_totals(problem_dirs: dict[tuple[str, str], Path]) -> dict[str, int]:
+    """Sum generation-log llm_api_calls per problem (budget visibility)."""
+    totals: dict[str, int] = {}
+    for (_, problem), problem_dir in sorted(problem_dirs.items()):
+        lines = (problem_dir / "generation_log.jsonl").read_text(encoding="utf-8")
+        rows = [json.loads(line) for line in lines.splitlines() if line.strip()]
+        totals[problem] = sum(int(row["llm_api_calls"]) for row in rows)
+    totals["TOTAL"] = sum(totals.values())
+    return totals
+
+
 def strategy_errors(problem_dir: Path, arm: str) -> list[str]:
     """Aggregate per-generation strategy counts and flag forbidden ones."""
     allowed = ALLOWED_BY_ARM[arm]
@@ -74,6 +112,12 @@ def main(argv: list[str] | None = None) -> int:
     parser.add_argument("--run-root", type=Path, required=True)
     parser.add_argument("--manifest", type=Path, required=True)
     parser.add_argument("--arm", choices=["classic", "qd"], required=True)
+    parser.add_argument(
+        "--expect-config",
+        action="append",
+        default=[],
+        help="KEY=VALUE to assert against the resolved run config YAML.",
+    )
     parser.add_argument("--output", type=Path, required=True)
     args = parser.parse_args(argv)
     assert args.run_root.is_dir(), args.run_root
@@ -81,6 +125,7 @@ def main(argv: list[str] | None = None) -> int:
     manifest = load_manifest(args.manifest)
     found = problem_dirs(args.run_root)
     errors: list[str] = []
+    errors.extend(config_errors(args.run_root, args.expect_config))
 
     for key in manifest:
         if key not in found:
@@ -106,6 +151,10 @@ def main(argv: list[str] | None = None) -> int:
         "manifest": str(args.manifest),
         "checked_problems": len(manifest),
         "found_problems": len(found),
+        "expected_config": list(args.expect_config),
+        "llm_api_calls": llm_call_totals(
+            {key: path for key, path in found.items() if key in set(manifest)}
+        ),
         "errors": errors,
         "status": "fail" if errors else "pass",
     }
diff --git a/tests/revolution/test_qd_natural_engine.py b/tests/revolution/test_qd_natural_engine.py
index 40f1a5edea..cec1eae7d8 100644
--- a/tests/revolution/test_qd_natural_engine.py
+++ b/tests/revolution/test_qd_natural_engine.py
@@ -104,8 +104,6 @@ def test_draw_distribution_respects_weights() -> None:
     ]
     pool, weights = curiosity_pool(members, ("g_P", "g_A"), 4, 1.0)
     random.seed(1001)
-    draws = Counter(
-        random.choices(pool, weights=weights, k=4000)[i] for i in range(4000)
-    )
+    draws = Counter(random.choices(pool, weights=weights, k=4000))
     # sparse cell weight 1.0 vs 1/3 each: expect ~2000 sparse draws of 4000
     assert 1700 < draws["payload-s1"] < 2300
diff --git a/tests/scripts/test_report_screen_seed_summary.py b/tests/scripts/test_report_screen_seed_summary.py
new file mode 100644
index 0000000000..066605cd2f
--- /dev/null
+++ b/tests/scripts/test_report_screen_seed_summary.py
@@ -0,0 +1,106 @@
+from __future__ import annotations
+
+import csv
+import importlib.util
+import sys
+from pathlib import Path
+
+import pytest
+
+_REPO_ROOT = Path(__file__).resolve().parent.parent.parent
+_SCRIPT_PATH = _REPO_ROOT / "scripts" / "report_screen_seed_summary.py"
+_SPEC = importlib.util.spec_from_file_location("report_screen_seed_summary", _SCRIPT_PATH)
+assert _SPEC is not None and _SPEC.loader is not None
+report_screen_seed_summary = importlib.util.module_from_spec(_SPEC)
+sys.modules.setdefault("report_screen_seed_summary", report_screen_seed_summary)
+_SPEC.loader.exec_module(report_screen_seed_summary)
+
+_ANCHOR = (
+    _REPO_ROOT
+    / "docs"
+    / "journal_features"
+    / "revamp_history"
+    / "20260703_121857_KST_natural_qd_push"
+    / "p0_v2_anchor"
+)
+
+
+def _write_aggregate(path: Path, rows: list[tuple[str, str, str, str, str]]) -> None:
+    fields = [
+        "backend",
+        "benchmark",
+        "problem_count",
+        "pareto_valid_problem_count",
+        "mean_hypervolume",
+        "mean_pareto_point_count",
+    ]
+    with path.open("w", newline="", encoding="utf-8") as handle:
+        writer = csv.writer(handle)
+        writer.writerow(fields)
+        for backend, count, valid, hv, pts in rows:
+            writer.writerow([backend, "ALL", count, valid, hv, pts])
+
+
+def _write_hv_auc(path: Path, rows: list[tuple[str, float]]) -> None:
+    with path.open("w", newline="", encoding="utf-8") as handle:
+        writer = csv.writer(handle)
+        writer.writerow(["backend", "problem", "hv_final", "hv_auc"])
+        for index, (backend, value) in enumerate(rows):
+            writer.writerow([backend, f"p{index}", "0", str(value)])
+
+
+def test_synthetic_two_seed_summary(tmp_path: Path) -> None:
+    for seed, base_hv, treat_hv in (("7", "0.10", "0.12"), ("8", "0.20", "0.18")):
+        _write_aggregate(
+            tmp_path / f"agg{seed}.csv",
+            [("base", "8", "8", base_hv, "3.0"), ("treat", "8", "7", treat_hv, "2.0")],
+        )
+        _write_hv_auc(
+            tmp_path / f"auc{seed}.csv",
+            [("base", 0.05), ("base", 0.15), ("treat", 0.2)],
+        )
+    output = tmp_path / "summary.csv"
+    assert (
+        report_screen_seed_summary.main(
+            [
+                "--seed", f"7:{tmp_path / 'agg7.csv'}:{tmp_path / 'auc7.csv'}",
+                "--seed", f"8:{tmp_path / 'agg8.csv'}:{tmp_path / 'auc8.csv'}",
+                "--baseline", "base",
+                "--treatment", "treat",
+                "--output", str(output),
+            ]
+        )
+        == 0
+    )
+    rows = {row["seed"]: row for row in csv.DictReader(output.open())}
+    assert rows["7"]["treatment_over_baseline_pct"] == "120.0"
+    assert rows["7"]["treatment_coverage"] == "7/8"
+    assert rows["8"]["treatment_over_baseline_pct"] == "90.0"
+    assert float(rows["mean"]["baseline_mean_hv"]) == pytest.approx(0.15)
+    assert float(rows["mean"]["treatment_mean_hv"]) == pytest.approx(0.15)
+    assert rows["mean"]["treatment_over_baseline_pct"] == "100.0"
+
+
+def test_regression_against_tracked_anchor_package(tmp_path: Path) -> None:
+    seeds = [
+        ("1001", _ANCHOR / "pareto_analysis" / "aggregate_backend_metrics.csv", _ANCHOR / "tables" / "hv_auc.csv"),
+        ("1002", _ANCHOR / "replication" / "seed_1002" / "pareto_analysis" / "aggregate_backend_metrics.csv", _ANCHOR / "replication" / "seed_1002" / "hv_auc.csv"),
+        ("1003", _ANCHOR / "replication" / "seed_1003" / "pareto_analysis" / "aggregate_backend_metrics.csv", _ANCHOR / "replication" / "seed_1003" / "hv_auc.csv"),
+    ]
+    for _, aggregate_csv, hv_auc_csv in seeds:
+        assert aggregate_csv.is_file() and hv_auc_csv.is_file()
+    output = tmp_path / "summary.csv"
+    argv = []
+    for seed, aggregate_csv, hv_auc_csv in seeds:
+        argv += ["--seed", f"{seed}:{aggregate_csv}:{hv_auc_csv}"]
+    argv += [
+        "--baseline", "classic_revolution_8x5",
+        "--treatment", "smooth_qd_v2_8x5",
+        "--output", str(output),
+    ]
+    assert report_screen_seed_summary.main(argv) == 0
+    rows = {row["seed"]: row for row in csv.DictReader(output.open())}
+    assert rows["mean"]["baseline_mean_hv"] == "0.14418173149368418"
+    assert rows["mean"]["treatment_mean_hv"] == "0.16283536749649596"
+    assert rows["mean"]["treatment_over_baseline_pct"] == "112.9"
+    assert rows["1001"]["treatment_over_baseline_pct"] == "123.5"
diff --git a/tests/scripts/test_validate_natural_qd_run.py b/tests/scripts/test_validate_natural_qd_run.py
index bde7739f23..c742f7e508 100644
--- a/tests/scripts/test_validate_natural_qd_run.py
+++ b/tests/scripts/test_validate_natural_qd_run.py
@@ -36,7 +36,11 @@ def _write_problem(
     problem_dir.mkdir(parents=True)
     lines = [
         json.dumps(
-            {"generation": generation, "strategy_counts_this_generation": counts}
+            {
+                "generation": generation,
+                "strategy_counts_this_generation": counts,
+                "llm_api_calls": sum(counts.values()),
+            }
         )
         for generation, counts in enumerate(strategy_counts)
     ]
@@ -79,6 +83,43 @@ def test_clean_qd_run_passes(tmp_path: Path) -> None:
     report = json.loads(output.read_text(encoding="utf-8"))
     assert report["status"] == "pass"
     assert report["errors"] == []
+    assert report["llm_api_calls"] == {"Prob024_fsm": 14, "TOTAL": 14}
+
+
+def test_expect_config_matches_and_mismatches(tmp_path: Path) -> None:
+    run_root = tmp_path / "run"
+    _write_problem(
+        run_root, "RTLLM", "Prob024_fsm", [{"initial": 8}], qd_artifacts=True
+    )
+    config_dir = run_root / "openai_gpt-oss-120b"
+    (config_dir / "20260703_x_revolution_config.yaml").write_text(
+        "qd_num_cells: 16\nqd_max_elites_per_cell: 5\nseed: 1001\n",
+        encoding="utf-8",
+    )
+    manifest = tmp_path / "manifest.csv"
+    _write_manifest(manifest, [("RTLLM", "Prob024_fsm")])
+    output = tmp_path / "report.json"
+    ok = validate_natural_qd_run.main(
+        [
+            "--run-root", str(run_root), "--manifest", str(manifest),
+            "--arm", "qd", "--output", str(output),
+            "--expect-config", "qd_num_cells=16",
+            "--expect-config", "seed=1001",
+        ]
+    )
+    assert ok == 0
+    bad = validate_natural_qd_run.main(
+        [
+            "--run-root", str(run_root), "--manifest", str(manifest),
+            "--arm", "qd", "--output", str(output),
+            "--expect-config", "qd_num_cells=64",
+            "--expect-config", "qd_missing_key=1",
+        ]
+    )
+    assert bad == 1
+    report = json.loads(output.read_text(encoding="utf-8"))
+    assert any("qd_num_cells" in error for error in report["errors"])
+    assert any("qd_missing_key" in error for error in report["errors"])
 
 
 def test_thought_mutation_allowed_for_qd_forbidden_for_classic(

exec
/bin/bash -lc "nl -ba scripts/run_backend.py | sed -n '470,500p;1120,1140p;1398,1418p'" in /workspace
 succeeded in 0ms:
   470	            qd_operator_kind=args.qd_operator_kind,
   471	            qd_operator_one_parent_fraction=args.qd_operator_one_parent_fraction,
   472	            qd_operator_archive_context_size=args.qd_operator_archive_context_size,
   473	            qd_operator_fail_feedback_chars=args.qd_operator_fail_feedback_chars,
   474	            qd_operator_two_parent_allow_intra_bin=args.qd_operator_two_parent_allow_intra_bin,
   475	            qd_rebinning_kind=args.qd_rebinning_kind,
   476	            qd_rebinning_recent_generations=args.qd_rebinning_recent_generations,
   477	            qd_rebinning_min_archive_members=args.qd_rebinning_min_archive_members,
   478	            qd_rebinning_cooldown_generations=args.qd_rebinning_cooldown_generations,
   479	            qd_rebinning_base_p_threshold=args.qd_rebinning_base_p_threshold,
   480	            representation_kind=args.representation_kind,
   481	            code_samples_per_thought=args.code_samples_per_thought,
   482	            qd_thought_code_seeded=args.qd_thought_code_seeded,
   483	            qd_seed_sample_fraction=args.qd_seed_sample_fraction,
   484	            qd_champion_lane_fraction=args.qd_champion_lane_fraction,
   485	            qd_front_slot_lane_fraction=args.qd_front_slot_lane_fraction,
   486	            qd_parent_selection=args.qd_parent_selection,
   487	            qd_curiosity_gamma=(
   488	                args.qd_curiosity_gamma
   489	                if args.qd_curiosity_gamma is not None
   490	                else 1.0
   491	            ),
   492	            qd_memory_classic_fraction=args.qd_memory_classic_fraction,
   493	            qd_memory_refine_fraction=args.qd_memory_refine_fraction,
   494	            qd_memory_rescue_fraction=args.qd_memory_rescue_fraction,
   495	            qd_memory_probe_fraction=args.qd_memory_probe_fraction,
   496	            qd_memory_min_cell_credit=args.qd_memory_min_cell_credit,
   497	            qd_memory_front_gap_epsilon=args.qd_memory_front_gap_epsilon,
   498	            qd_memory_min_valid_ppa=args.qd_memory_min_valid_ppa,
   499	            qd_memory_trigger=args.qd_memory_trigger,
   500	            qd_memory_target_front_size=args.qd_memory_target_front_size,
  1120	    )
  1121	    parser.add_argument("--qd_seed_sample_fraction", type=float, default=1.0,
  1122	        help="Fraction of k samples that are seeded vs whole-regen leaps (B\u2032 hybrid; 1.0=pure Fix B).")
  1123	    parser.add_argument("--qd_champion_lane_fraction", type=float, default=0.0,
  1124	        help="Fraction of QD parents drawn from the global best (doc 15 Fix A champion lane).")
  1125	    parser.add_argument(
  1126	        "--qd_front_slot_lane_fraction",
  1127	        type=float,
  1128	        default=0.10,
  1129	        help="Fraction of front-slot lane parent requests under front_slot_lane_nsga2.",
  1130	    )
  1131	    parser.add_argument(
  1132	        "--qd_curiosity_gamma",
  1133	        type=float,
  1134	        default=None,
  1135	        help=(
  1136	            "Inverse-cell-occupancy draw exponent; required with (and only "
  1137	            "valid for) search_mode=revolution_qd_natural (lane N02)."
  1138	        ),
  1139	    )
  1140	    parser.add_argument("--qd_parent_selection", type=str, default="cell_crowded_tournament",
  1398	        return 2
  1399	
  1400	    parser, config_parser = _build_parser()
  1401	    try:
  1402	        args, config_from_file, raw_argv = parse_args_with_config(
  1403	            parser, config_parser, argv=argv
  1404	        )
  1405	    except ConfigError as exc:
  1406	        print(f"Configuration error: {exc}")
  1407	        return 2
  1408	
  1409	    if args.backend == "revolution" and (
  1410	        (args.search_mode == "revolution_qd_natural")
  1411	        != (args.qd_curiosity_gamma is not None)
  1412	    ):
  1413	        print(
  1414	            "Configuration error: --qd_curiosity_gamma is required with, and "
  1415	            "only valid for, search_mode=revolution_qd_natural."
  1416	        )
  1417	        return 2
  1418	

exec
/bin/bash -lc 'for f in docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N01_cell_retention_mode/package/tables/run_validation_*.json docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/package/tables/run_validation_*.json docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/p0_v2_anchor/tables/run_validation.json docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/p0_v2_anchor/replication/seed_1002/run_validation.json docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/p0_v2_anchor/replication/seed_1003/run_validation.json; do echo "$f"; nl -ba "$f" | sed -n '"'1,120p'; done" in /workspace
exec
/bin/bash -lc "rg -n \"_revolution_config\\.yaml|revolution_config\" -S scripts src tests | head -50" in /workspace
 succeeded in 241ms:
     1	{
     2	  "run_root": "exp/natural_qd_push/p0_v2_anchor_20260703_041511_UTC/live/smooth_qd_v2_8x5/seed_1001",
     3	  "arm": "qd",
     4	  "manifest": "docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/tables/screen_manifest.csv",
     5	  "checked_problems": 8,
     6	  "found_problems": 8,
     7	  "expected_config": [
     8	    "qd_num_cells=16",
     9	    "qd_grid_quantile_warmup_successes=8",
    10	    "qd_max_elites_per_cell=5",
    11	    "qd_cell_mode=pareto_front",
    12	    "qd_parent_selection=nsga2_global_rank",
    13	    "qd_operator_kind=eoh_strategies",
    14	    "representation_kind=code_individual",
    15	    "evaluation_mode=strict_ablation",
    16	    "seed=1001"
    17	  ],
    18	  "llm_api_calls": {
    19	    "Prob015_multi_pipe_8bit": 96,
    20	    "Prob024_fsm": 96,
    21	    "Prob041_traffic_light": 96,
    22	    "Prob045_alu": 96,
    23	    "Prob049_signal_generator": 96,
    24	    "Prob116_m2014_q3": 96,
    25	    "Prob135_m2014_q6b": 96,
    26	    "Prob153_gshare": 96,
    27	    "TOTAL": 768
    28	  },
    29	  "errors": [],
    30	  "status": "pass"
    31	}
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/p0_v2_anchor/replication/seed_1002/run_validation.json
     1	{
     2	  "run_root": "exp/natural_qd_push/p0_v2_anchor_20260703_041511_UTC/live/smooth_qd_v2_8x5/seed_1002",
     3	  "arm": "qd",
     4	  "manifest": "docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/tables/screen_manifest.csv",
     5	  "checked_problems": 8,
     6	  "found_problems": 8,
     7	  "expected_config": [
     8	    "qd_num_cells=16",
     9	    "qd_grid_quantile_warmup_successes=8",
    10	    "qd_max_elites_per_cell=5",
    11	    "qd_cell_mode=pareto_front",
    12	    "qd_parent_selection=nsga2_global_rank",
    13	    "qd_operator_kind=eoh_strategies",
    14	    "representation_kind=code_individual",
    15	    "evaluation_mode=strict_ablation",
    16	    "seed=1002"
    17	  ],
    18	  "llm_api_calls": {
    19	    "Prob015_multi_pipe_8bit": 96,
    20	    "Prob024_fsm": 96,
    21	    "Prob041_traffic_light": 96,
    22	    "Prob045_alu": 96,
    23	    "Prob049_signal_generator": 96,
    24	    "Prob116_m2014_q3": 96,
    25	    "Prob135_m2014_q6b": 96,
    26	    "Prob153_gshare": 96,
    27	    "TOTAL": 768
    28	  },
    29	  "errors": [],
    30	  "status": "pass"
    31	}
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/p0_v2_anchor/replication/seed_1003/run_validation.json
     1	{
     2	  "run_root": "exp/natural_qd_push/p0_v2_anchor_20260703_041511_UTC/live/smooth_qd_v2_8x5/seed_1003",
     3	  "arm": "qd",
     4	  "manifest": "docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/tables/screen_manifest.csv",
     5	  "checked_problems": 8,
     6	  "found_problems": 8,
     7	  "expected_config": [
     8	    "qd_num_cells=16",
     9	    "qd_grid_quantile_warmup_successes=8",
    10	    "qd_max_elites_per_cell=5",
    11	    "qd_cell_mode=pareto_front",
    12	    "qd_parent_selection=nsga2_global_rank",
    13	    "qd_operator_kind=eoh_strategies",
    14	    "representation_kind=code_individual",
    15	    "evaluation_mode=strict_ablation",
    16	    "seed=1003"
    17	  ],
    18	  "llm_api_calls": {
    19	    "Prob015_multi_pipe_8bit": 96,
    20	    "Prob024_fsm": 96,
    21	    "Prob041_traffic_light": 96,
    22	    "Prob045_alu": 96,
    23	    "Prob049_signal_generator": 96,
    24	    "Prob116_m2014_q3": 96,
    25	    "Prob135_m2014_q6b": 96,
    26	    "Prob153_gshare": 96,
    27	    "TOTAL": 768
    28	  },
    29	  "errors": [],
    30	  "status": "pass"
    31	}

exec
/bin/bash -lc "find exp/natural_qd_push -path '*_revolution_config.yaml' -maxdepth 8 2>/dev/null | head -80" in /workspace
 succeeded in 775ms:
scripts/validate_natural_qd_run.py:16:  ``*_revolution_config.yaml`` (the registered-card-vs-run guard that
scripts/validate_natural_qd_run.py:63:    config_paths = sorted(run_root.rglob("*_revolution_config.yaml"))
scripts/validate_natural_qd_run.py:65:        return ["no *_revolution_config.yaml under run root"]
tests/scripts/test_validate_natural_qd_run.py:95:    (config_dir / "20260703_x_revolution_config.yaml").write_text(
tests/scripts/test_run_backend.py:787:    generated_configs = sorted(model_root.glob("*_revolution_config.yaml"))
tests/scripts/test_run_backend.py:822:    assert sorted(modified_model_root.glob("*_revolution_config.yaml"))
tests/scripts/test_archive_baseline.py:191:        / f"{run_started}_revolution_config.yaml"
scripts/validate_grid_quantile_run.py:179:    paths = sorted((run_root / mode).rglob("*_revolution_config.yaml"))

 succeeded in 2871ms:
exp/natural_qd_push/p0_v2_anchor_20260703_041010_UTC_INTERRUPTED_UNFAITHFUL/live/smooth_qd_v2_8x5/seed_1001/openai_gpt-oss-120b/20260703_041024_revolution_config.yaml
exp/natural_qd_push/p0_v2_anchor_20260703_041511_UTC/live/smooth_qd_v2_8x5/seed_1001/openai_gpt-oss-120b/20260703_041525_revolution_config.yaml
exp/natural_qd_push/p0_v2_anchor_20260703_041511_UTC/live/smooth_qd_v2_8x5/seed_1002/openai_gpt-oss-120b/20260703_044209_revolution_config.yaml
exp/natural_qd_push/p0_v2_anchor_20260703_041511_UTC/live/smooth_qd_v2_8x5/seed_1003/openai_gpt-oss-120b/20260703_050447_revolution_config.yaml
exp/natural_qd_push/n01_cell_retention_20260703_053243_UTC/live/elite_pareto_slot_2/seed_1001/openai_gpt-oss-120b/20260703_053245_revolution_config.yaml
exp/natural_qd_push/n01_cell_retention_20260703_053243_UTC/live/scalar_elite/seed_1001/openai_gpt-oss-120b/20260703_055509_revolution_config.yaml
exp/natural_qd_push/n05_warmup_init_20260703_053243_UTC/live/warmup_4/seed_1001/openai_gpt-oss-120b/20260703_061830_revolution_config.yaml
exp/natural_qd_push/n05_warmup_init_20260703_053243_UTC/live/warmup_16/seed_1001/openai_gpt-oss-120b/20260703_064128_revolution_config.yaml
exp/natural_qd_push/n02_smoke_20260703_053243_UTC/live/curiosity_g10_smoke/seed_42/openai_gpt-oss-120b/20260703_070306_revolution_config.yaml
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/graph_testability_3d/seed_1001/openai_gpt-oss-120b/20260703_070922_revolution_config.yaml
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/size_control_3d/seed_1001/openai_gpt-oss-120b/20260703_073330_revolution_config.yaml
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/20260703_075757_revolution_config.yaml

codex
On code shape, `qd_natural/engine.py` stays small and targeted. The validator is also simple, but one guard is weaker than it looks: it reads only the first resolved config under a run root, so the config-pin promise depends on the current one-config layout.
exec
/bin/bash -lc "nl -ba scripts/validate_grid_quantile_run.py | sed -n '150,230p'" in /workspace
 succeeded in 0ms:
   150	    synthesis_ppa = 0
   151	    if log_path.is_file():
   152	        for row in _load_jsonl(log_path):
   153	            counts = row.get("status_counts_this_generation", {})
   154	            assert isinstance(counts, dict)
   155	            for status, count in counts.items():
   156	                if status not in FUNCTIONALITY_FAIL_STATUSES:
   157	                    functionality += int(count)
   158	            synthesis_ppa += int(counts.get("success", 0))
   159	        return {"functionality": functionality, "synthesis_ppa": synthesis_ppa}
   160	
   161	    summary = _load_json(summary_path)
   162	    total = int(summary.get("total_candidates_generated", 0))
   163	    rates = summary.get("accumulated_success_rates", {})
   164	    assert isinstance(rates, dict)
   165	    functionality = round(total * float(rates.get("functionality", 0.0)))
   166	    synthesis_ppa = round(
   167	        total
   168	        * float(
   169	            rates.get(
   170	                "synthesis_ppa",
   171	                rates.get("total_synthesis_ppa", 0.0),
   172	            )
   173	        )
   174	    )
   175	    return {"functionality": functionality, "synthesis_ppa": synthesis_ppa}
   176	
   177	
   178	def _mode_config(run_root: Path, mode: str) -> dict[str, Any]:
   179	    paths = sorted((run_root / mode).rglob("*_revolution_config.yaml"))
   180	    if not paths:
   181	        return {}
   182	    return _load_yaml(paths[-1])
   183	
   184	
   185	def _manifest_settings(run_root: Path) -> dict[str, str]:
   186	    path = run_root / "hard_iteration_manifest.txt"
   187	    if not path.is_file():
   188	        return {}
   189	    settings = {}
   190	    for line in path.read_text(encoding="utf-8").splitlines():
   191	        if "=" not in line:
   192	            continue
   193	        key, value = line.split("=", 1)
   194	        settings[key] = value
   195	    return settings
   196	
   197	
   198	def _expected_problem_names(subset_config: Path) -> list[str]:
   199	    config = _load_yaml(subset_config)
   200	    return [str(item["problem"]) for item in config["selected_problems"]]
   201	
   202	
   203	def _setting_errors(
   204	    *,
   205	    classic_config: dict[str, Any],
   206	    grid_config: dict[str, Any],
   207	) -> list[str]:
   208	    errors = []
   209	    if not classic_config:
   210	        errors.append("missing classic resolved run config")
   211	    if not grid_config:
   212	        errors.append("missing grid_quantile resolved run config")
   213	    for mode_name, config in (
   214	        ("classic", classic_config),
   215	        ("grid_quantile_journal_bd", grid_config),
   216	    ):
   217	        if not config:
   218	            continue
   219	        for key, expected in ACCEPTANCE_SETTINGS.items():
   220	            if int(config.get(key, -1)) != expected:
   221	                errors.append(f"{mode_name}.{key} does not match {expected}")
   222	    if classic_config and classic_config.get("search_mode") != "revolution":
   223	        errors.append("classic search_mode is not revolution")
   224	    if grid_config and grid_config.get("search_mode") != "revolution_qd":
   225	        errors.append("grid_quantile search_mode is not revolution_qd")
   226	    if grid_config and grid_config.get("qd_archive_type") != "grid_quantile":
   227	        errors.append("grid_quantile qd_archive_type is not grid_quantile")
   228	    if grid_config and grid_config.get("qd_descriptor_profile") != "journal_logic_ff_width_3d":
   229	        errors.append("grid_quantile descriptor profile is not journal_logic_ff_width_3d")
   230	    if grid_config and int(grid_config.get("qd_grid_quantile_warmup_successes", -1)) != 8:

exec
/bin/bash -lc 'rg -n "descriptor_health|axis-collapse|axis collapse|occupied_cells|collapse" docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N06_descriptor_bakeoff exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC 2>/dev/null | head -100' in /workspace
exec
/bin/bash -lc 'find exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC -maxdepth 5 -type f 2>/dev/null | sort | head -200' in /workspace
exec
/bin/bash -lc 'rg -n "journal_graph_testability_3d|size_control_3d|random_hash_3d|theory_grounded_compact_8d|v2_trio_cvt|requires_ppa|descriptor_profile" -S src scripts data docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push | head -200' in /workspace
 succeeded in 912ms:
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/launch_graph_testability_3d_seed1001.log
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/launch_random_hash_3d_seed1001.log
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/launch_size_control_3d_seed1001.log
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/graph_testability_3d/seed_1001/openai_gpt-oss-120b/20260703_070922_revolution_config_meta.yaml
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/graph_testability_3d/seed_1001/openai_gpt-oss-120b/20260703_070922_revolution_config.yaml
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/graph_testability_3d/seed_1001/openai_gpt-oss-120b/20260703_070922_revolution_run_log.txt
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/graph_testability_3d/seed_1001/openai_gpt-oss-120b/20260703_070922_revolution_scheduler_telemetry_events.jsonl
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/graph_testability_3d/seed_1001/openai_gpt-oss-120b/20260703_070922_revolution_scheduler_telemetry.json
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/graph_testability_3d/seed_1001/openai_gpt-oss-120b/20260703_070922_revolution_summary_results.txt
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/20260703_075757_revolution_config_meta.yaml
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/20260703_075757_revolution_config.yaml
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/20260703_075757_revolution_run_log.txt
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/size_control_3d/seed_1001/openai_gpt-oss-120b/20260703_073330_revolution_config_meta.yaml
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/size_control_3d/seed_1001/openai_gpt-oss-120b/20260703_073330_revolution_config.yaml
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/size_control_3d/seed_1001/openai_gpt-oss-120b/20260703_073330_revolution_run_log.txt
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/size_control_3d/seed_1001/openai_gpt-oss-120b/20260703_073330_revolution_scheduler_telemetry_events.jsonl
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/size_control_3d/seed_1001/openai_gpt-oss-120b/20260703_073330_revolution_scheduler_telemetry.json
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/size_control_3d/seed_1001/openai_gpt-oss-120b/20260703_073330_revolution_summary_results.txt
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/preflight_graph_testability_3d_seed1001_20260703_070921_UTC.json
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/preflight_random_hash_3d_seed1001_20260703_075755_UTC.json
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/preflight_size_control_3d_seed1001_20260703_073327_UTC.json

 succeeded in 1321ms:
  "--qd_descriptor_profile",
scripts/build_auto_bd_run_matrix.py:356:            str(METHOD_CONFIGS[arm_name].parent / "descriptor_profile.yaml"),
scripts/build_auto_bd_run_matrix.py:361:            "--qd_descriptor_profile",
scripts/build_auto_bd_run_matrix.py:364:            str(METHOD_CONFIGS[arm_name].parent / "descriptor_profile_random_relu.yaml"),
scripts/build_auto_bd_run_matrix.py:369:            "--qd_descriptor_profile",
scripts/build_auto_bd_run_matrix.py:372:            str(METHOD_CONFIGS[arm_name].parent / "descriptor_profile_rff.yaml"),
scripts/build_auto_bd_run_matrix.py:377:            "--qd_descriptor_profile",
scripts/build_auto_bd_run_matrix.py:380:            str(METHOD_CONFIGS[arm_name].parent / "descriptor_profile.yaml"),
scripts/validate_two_tier_fail_pool_run.py:133:        if summary.get("descriptor_profile") != "journal_logic_ff_width_3d":
scripts/validate_two_tier_fail_pool_run.py:134:            errors.append("descriptor_profile is not journal_logic_ff_width_3d")
scripts/build_hard_iteration_subset.py:37:        "qd_descriptor_profile": "implemented_structural_compact_3d",
scripts/build_hard_iteration_subset.py:42:        "qd_descriptor_profile": "implemented_structural_fixed_5d",
scripts/build_hard_iteration_subset.py:47:        "qd_descriptor_profile": "size_control_3d",
data/configs/hard_iteration_subset_qd_archive_tuning.yaml:70:    qd_descriptor_profile: size_control_3d
data/configs/hard_iteration_subset_qd_archive_tuning.yaml:74:    qd_descriptor_profile: size_control_3d
data/configs/hard_iteration_subset_qd_archive_tuning.yaml:78:    qd_descriptor_profile: size_control_3d
data/configs/hard_iteration_subset_qd_archive_tuning.yaml:83:    qd_descriptor_profile: size_control_3d
data/configs/hard_iteration_subset_qd_archive_tuning.yaml:88:    qd_descriptor_profile: size_control_3d
scripts/report_common_evaluation_contract.py:58:    "descriptor_profile",
scripts/report_common_evaluation_contract.py:320:    descriptor_profile = archive["descriptor_profile"]
scripts/report_common_evaluation_contract.py:328:            "descriptor_profile": descriptor_profile,
scripts/report_common_evaluation_contract.py:376:        "descriptor_profile": descriptor_profile,
scripts/report_common_evaluation_contract.py:589:        "descriptor_profile": archive["descriptor_profile"],
data/configs/hard_iteration_subset.yaml:66:    qd_descriptor_profile: implemented_structural_compact_3d
data/configs/hard_iteration_subset.yaml:70:    qd_descriptor_profile: implemented_structural_fixed_5d
data/configs/hard_iteration_subset.yaml:74:    qd_descriptor_profile: size_control_3d
data/configs/hard_iteration_subset.yaml:78:    qd_descriptor_profile: theory_grounded_full_20d
data/configs/hard_iteration_subset.yaml:82:    qd_descriptor_profile: theory_grounded_compact_8d
scripts/validate_pareto_front_run.py:192:        if summary.get("descriptor_profile") != "journal_logic_ff_width_3d":
scripts/validate_pareto_front_run.py:193:            errors.append("descriptor_profile is not journal_logic_ff_width_3d")
scripts/run_qd_theory_grounded_smoke_vllm.sh:142:    theory_grounded_compact_8d)
scripts/run_qd_theory_grounded_smoke_vllm.sh:150:    size_control_3d)
scripts/run_qd_theory_grounded_smoke_vllm.sh:224:      "size_control_3d"
scripts/run_qd_theory_grounded_smoke_vllm.sh:226:      "theory_grounded_compact_8d"
scripts/run_qd_theory_grounded_smoke_vllm.sh:327:    CMD+=("--qd_descriptor_profile" "${profile}")
scripts/backend_comparison_report.py:48:    qd_descriptor_profile: str | None
scripts/backend_comparison_report.py:497:            f"{row.qd_descriptor_profile or 'N/A'} | {axes} | "
scripts/backend_comparison_report.py:877:                qd_descriptor_profile=(
scripts/backend_comparison_report.py:878:                    qd_descriptor_health.get("descriptor_profile")
scripts/backend_comparison_report.py:879:                    if isinstance(qd_descriptor_health.get("descriptor_profile"), str)
scripts/backend_comparison_report.py:881:                        qd_archive_summary.get("descriptor_profile")
scripts/backend_comparison_report.py:882:                        if isinstance(qd_archive_summary.get("descriptor_profile"), str)
scripts/run_qd_theory_followup_vllm.sh:171:    size_control_3d)
scripts/run_qd_theory_followup_vllm.sh:179:    theory_grounded_compact_8d)
scripts/run_qd_theory_followup_vllm.sh:267:  "size_control_3d"
scripts/run_qd_theory_followup_vllm.sh:269:  "theory_grounded_compact_8d"
scripts/run_qd_theory_followup_vllm.sh:293:    CMD+=("--qd_descriptor_profile" "${profile}")
scripts/validate_grid_quantile_run.py:228:    if grid_config and grid_config.get("qd_descriptor_profile") != "journal_logic_ff_width_3d":
scripts/validate_grid_quantile_run.py:435:    if space.get("descriptor_profile") != "journal_logic_ff_width_3d":
scripts/validate_grid_quantile_run.py:436:        errors.append("descriptor_profile is not journal_logic_ff_width_3d")
scripts/run_qd_theory_followup_manifest.py:333:        "--qd_descriptor_profile",
data/configs/qd_theory_followup_broad_matrix.json:27:      "name": "size_control_3d",
data/configs/qd_theory_followup_broad_matrix.json:35:      "name": "theory_grounded_compact_8d",
scripts/run_qd_retrospective_redo_vllm.sh:20:    wire_ctrl_assign_3d grid + size_control_3d CVT + hybrid_phys_seq CVT + activity_control_3d grid
scripts/run_qd_retrospective_redo_vllm.sh:250:cvt_size_control|cvt_size_control|revolution_qd|cvt|size_control_3d
scripts/run_qd_retrospective_redo_vllm.sh:320:  while IFS='|' read -r mode_label backend_label search_mode archive_type descriptor_profile; do
scripts/run_qd_retrospective_redo_vllm.sh:350:      CMD+=("--qd_descriptor_profile" "${descriptor_profile}")
src/revolution/runtime/candidate_evaluator.py:177:        descriptor_profile: str | None = None,
src/revolution/runtime/candidate_evaluator.py:215:        resolved_profile = descriptor_profile
src/revolution/runtime/candidate_evaluator.py:217:            resolved_profile = problem_spec.default_descriptor_profile
src/revolution/runtime/candidate_evaluator.py:218:        self.descriptor_profile = resolved_profile
src/revolution/runtime/candidate_evaluator.py:221:            profile_name=self.descriptor_profile,
src/revolution/runtime/realbench_adapter.py:141:    descriptor_profile = "hybrid_phys_seq" if quality_mode == "ppa" else "rtl_core"
src/revolution/runtime/realbench_adapter.py:157:        default_descriptor_profile=descriptor_profile,
src/revolution/runtime/problem_spec.py:58:    default_descriptor_profile: str = "rtl_core"
src/revolution/runtime/problem_spec.py:70:def _default_descriptor_profile(
src/revolution/runtime/problem_spec.py:150:        default_descriptor_profile=_default_descriptor_profile(
src/revolution/runtime/problem_spec.py:201:        default_descriptor_profile=_default_descriptor_profile(
src/revolution/qd/engine.py:111:_ARCHIVE_ONLY_DESCRIPTOR_PROFILES = {"journal_logic_ff_width_3d"}
src/revolution/qd/engine.py:180:        qd_descriptor_profile: str | None = None,
src/revolution/qd/engine.py:356:        self.qd_descriptor_profile = qd_descriptor_profile
src/revolution/qd/engine.py:591:        return self.qd_descriptor_profile not in _ARCHIVE_ONLY_DESCRIPTOR_PROFILES
src/revolution/qd/engine.py:624:                profile_name=self.qd_descriptor_profile,
src/revolution/qd/engine.py:655:            profile_name=self.qd_descriptor_profile,
src/revolution/qd/engine.py:672:            profile_name=self.qd_descriptor_profile,
src/revolution/qd/engine.py:1930:                descriptor_profile=self.qd_descriptor_profile,
src/revolution/qd/engine.py:1947:            descriptor_profile=self.qd_descriptor_profile,
src/revolution/qd/engine.py:1957:                descriptor_profile=self.qd_descriptor_profile,
src/revolution/qd/descriptors.py:20:    requires_ppa: bool = False
src/revolution/qd/descriptors.py:278:    "g_P": DescriptorDefinition("g_P", "ppa", requires_ppa=True),
src/revolution/qd/descriptors.py:279:    "g_A": DescriptorDefinition("g_A", "ppa", requires_ppa=True),
src/revolution/qd/descriptors.py:280:    "g_T": DescriptorDefinition("g_T", "ppa", requires_ppa=True),
src/revolution/qd/descriptors.py:322:def default_descriptor_profile_path() -> Path:
src/revolution/qd/descriptors.py:329:        / "qd_descriptor_profiles.yaml"
src/revolution/qd/descriptors.py:340:    profile_path = Path(path) if path is not None else default_descriptor_profile_path()
src/revolution/qd/descriptors.py:347:def load_descriptor_profiles(path: str | Path | None = None) -> dict[str, list[str]]:
src/revolution/qd/descriptors.py:462:    profiles = load_descriptor_profiles(descriptor_file)
src/revolution/qd/descriptors.py:747:        "requires_ppa": any(registry[axis].requires_ppa for axis in axes),
src/revolution/qd/descriptors.py:803:            "requires_ppa": registry[axis].requires_ppa,
src/revolution/qd/__init__.py:30:    load_descriptor_profiles,
src/revolution/qd/__init__.py:78:    "load_descriptor_profiles",
src/revolution/qd/successful_candidate_catalog.py:43:    "descriptor_profile",
src/revolution/qd/successful_candidate_catalog.py:113:    descriptor_profile: str | None
src/revolution/qd/successful_candidate_catalog.py:129:    descriptor_profile: str | None
src/revolution/qd/successful_candidate_catalog.py:353:def _descriptor_profile_from_summary_payload(summary_payload: dict[str, Any]) -> str | None:
src/revolution/qd/successful_candidate_catalog.py:354:    direct_value = summary_payload.get("descriptor_profile")
src/revolution/qd/successful_candidate_catalog.py:362:        profile = qd_config.get("descriptor_profile") or qd_config.get("qd_descriptor_profile")
src/revolution/qd/successful_candidate_catalog.py:365:    profile = backend_details.get("descriptor_profile")
src/revolution/qd/successful_candidate_catalog.py:552:    descriptor_profile = _descriptor_profile_from_summary_payload(summary_payload)
src/revolution/qd/successful_candidate_catalog.py:553:    if descriptor_profile is None:
src/revolution/qd/successful_candidate_catalog.py:554:        archive_summary_profile = archive_summary.get("descriptor_profile")
src/revolution/qd/successful_candidate_catalog.py:556:            descriptor_profile = archive_summary_profile
src/revolution/qd/successful_candidate_catalog.py:557:    if descriptor_profile is None:
src/revolution/qd/successful_candidate_catalog.py:558:        archive_space_profile = archive_space.get("descriptor_profile")
src/revolution/qd/successful_candidate_catalog.py:560:            descriptor_profile = archive_space_profile
src/revolution/qd/successful_candidate_catalog.py:593:        descriptor_profile=descriptor_profile,
src/revolution/qd/successful_candidate_catalog.py:634:        descriptor_profile=context.descriptor_profile,
src/revolution/qd/successful_candidate_catalog.py:1122:        "descriptor_profile": record.descriptor_profile,
src/revolution/qd/feature_space_analysis.py:19:from revolution.qd.descriptors import load_descriptor_profiles
src/revolution/qd/feature_space_analysis.py:733:    profiles = load_descriptor_profiles(descriptor_file)
src/revolution/qd/artifacts.py:271:    descriptor_profile: str | None,
src/revolution/qd/artifacts.py:329:        "descriptor_profile": descriptor_profile,
src/revolution/qd/artifacts.py:395:        "descriptor_profile": descriptor_profile,
src/revolution/qd/artifacts.py:462:    descriptor_profile: str | None,
src/revolution/qd/artifacts.py:470:    payload["descriptor_profile"] = descriptor_profile
src/revolution/qd/artifacts.py:486:    descriptor_profile: str | None,
src/revolution/qd/artifacts.py:494:        descriptor_profile=descriptor_profile,
src/revolution/qd/artifacts.py:670:        f"- descriptor_profile: `{payload.get('descriptor_profile')}`",
src/revolution/qd/artifacts.py:787:    descriptor_profile: str | None,
src/revolution/qd/artifacts.py:840:        "descriptor_profile": descriptor_profile,
src/revolution/qd/artifacts.py:913:        f"- descriptor_profile: `{payload.get('descriptor_profile')}`",
data/configs/qd_descriptor_profiles.yaml:51:  size_control_3d:
data/configs/qd_descriptor_profiles.yaml:116:  theory_grounded_compact_8d:
data/configs/qd_descriptor_profiles.yaml:150:  journal_graph_testability_3d:
scripts/run_hard_iteration_qd_vllm.sh:284:        f"{prefix}_QD_DESCRIPTOR_PROFILE",
scripts/run_hard_iteration_qd_vllm.sh:285:        mode_cfg.get("qd_descriptor_profile", ""),
scripts/run_hard_iteration_qd_vllm.sh:577:  descriptor_profile_var="MODE_${upper_mode}_QD_DESCRIPTOR_PROFILE"
scripts/run_hard_iteration_qd_vllm.sh:607:  descriptor_profile="${!descriptor_profile_var}"
scripts/run_hard_iteration_qd_vllm.sh:717:    echo "mode.${mode_name}.qd_descriptor_profile=${descriptor_profile}"
scripts/run_hard_iteration_qd_vllm.sh:778:    CMD+=("--qd_descriptor_profile" "${descriptor_profile}")
src/revolution/backends/revolution_backend.py:71:    qd_descriptor_profile: str | None = None
src/revolution/backends/revolution_backend.py:218:                qd_descriptor_profile=self.config.qd_descriptor_profile,
src/revolution/backends/revolution_backend.py:292:                "default_descriptor_profile": self.context.problem_spec.default_descriptor_profile,
src/revolution/backends/revolution_backend.py:341:                    "descriptor_profile": self.config.qd_descriptor_profile,
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N06_descriptor_bakeoff/probes/probe_random_hash_3d.json:8:    "requires_ppa": false,
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N06_descriptor_bakeoff/probes/probe_random_hash_3d.json:29:      "requires_ppa": false,
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N06_descriptor_bakeoff/probes/probe_random_hash_3d.json:46:      "requires_ppa": false,
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N06_descriptor_bakeoff/probes/probe_random_hash_3d.json:63:      "requires_ppa": false,
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N06_descriptor_bakeoff/probes/probe_size_control_3d.json:8:    "requires_ppa": false,
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N06_descriptor_bakeoff/probes/probe_size_control_3d.json:29:      "requires_ppa": false,
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N06_descriptor_bakeoff/probes/probe_size_control_3d.json:46:      "requires_ppa": false,
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N06_descriptor_bakeoff/probes/probe_size_control_3d.json:63:      "requires_ppa": false,
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N06_descriptor_bakeoff/probes/probe_journal_graph_testability_3d.json:8:    "requires_ppa": false,
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N06_descriptor_bakeoff/probes/probe_journal_graph_testability_3d.json:29:      "requires_ppa": false,
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N06_descriptor_bakeoff/probes/probe_journal_graph_testability_3d.json:46:      "requires_ppa": false,
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N06_descriptor_bakeoff/probes/probe_journal_graph_testability_3d.json:63:      "requires_ppa": false,
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N06_descriptor_bakeoff/methodology.md:11:## Mechanism (single factor per wave-1 arm: `--qd_descriptor_profile`)
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N06_descriptor_bakeoff/methodology.md:17:- **N06b `journal_graph_testability_3d`** — cyclomatic complexity +
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N06_descriptor_bakeoff/methodology.md:22:- **N06c `size_control_3d`** — the structural control bar: beat theory
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N06_descriptor_bakeoff/methodology.md:32:- **N06a `theory_grounded_compact_8d`** — SCOAP histograms + Laplacian
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N06_descriptor_bakeoff/methodology.md:37:  with its own control arm `v2_trio_cvt` (trio descriptors on CVT,
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N06_descriptor_bakeoff/methodology.md:39:  N06a-vs-v2_trio_cvt, not vs the grid V2 anchor.
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N06_descriptor_bakeoff/methodology.md:44:resolve axes with `requires_ppa=false`, confirm extraction on a sample
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N06_descriptor_bakeoff/methodology.md:84:`--expect-config qd_descriptor_profile=<name>`, canonical HV-AUC,
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N06_descriptor_bakeoff/research_memo.md:40:   quality, and Pareto breadth; theory_grounded_compact_8d had ZERO
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N06_descriptor_bakeoff/research_memo.md:74:`--qd_descriptor_profile` swaps, wave 1 = three 3-D registered profiles
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/natural_qd_push_implementation_history.md:302:  swaps journal_graph_testability_3d (semantic challenger: SCOAP/
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/natural_qd_push_implementation_history.md:304:  size_control_3d (structural bar that beat theory under CODE-EoH) +
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/natural_qd_push_implementation_history.md:306:  theory_grounded_compact_8d (zero axis collapses operator-fair) on

 succeeded in 2869ms:
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N06_descriptor_bakeoff/methodology.md:20:  open where the trio collapsed (F12 occupancy 0.50 vs 0.12); its only
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N06_descriptor_bakeoff/methodology.md:33:  spectral entropy; zero axis collapses on 13/13 operator-fair. 8-D
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N06_descriptor_bakeoff/methodology.md:48:fails to resolve or collapses on the probe sample kills that arm before
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N06_descriptor_bakeoff/methodology.md:73:- Archive-health co-read per arm: axis-collapse count and occupied
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N06_descriptor_bakeoff/methodology.md:74:  cells from `descriptor_health` artifacts; a profile that wins HV but
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N06_descriptor_bakeoff/methodology.md:75:  collapses is reported as an optimization result, not a diversity
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N06_descriptor_bakeoff/research_memo.md:26:2. The trio's collapse IS substrate-independent: F12 (14 collapses,
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N06_descriptor_bakeoff/research_memo.md:28:   operator-fair CODE-EoH component run (ff_depth collapses 7/13,
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N06_descriptor_bakeoff/research_memo.md:29:   circuit7 occupied_cells=1). Structural causes: comb_width_log is a
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N06_descriptor_bakeoff/research_memo.md:41:   axis collapses on 13/13 with all centroids initialized (Stage 11)
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N06_descriptor_bakeoff/research_memo.md:54:   12 collapses).
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N06_descriptor_bakeoff/research_memo.md:60:  the trio collapses; orthogonal to size/PPA.
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/RTLLM/Prob041_traffic_light/archive_space_report.md:6:- occupied_cells: `0`
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/RTLLM/Prob041_traffic_light/archive_space_report.md:24:- collapsed_axes: `none`
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/RTLLM/Prob041_traffic_light/archive_space_report.md:32:- `random_hash_0`: intended=4, effective=0, boundaries=[], collapsed=False
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/RTLLM/Prob041_traffic_light/archive_space_report.md:33:- `random_hash_1`: intended=4, effective=0, boundaries=[], collapsed=False
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/RTLLM/Prob041_traffic_light/archive_space_report.md:34:- `random_hash_2`: intended=4, effective=0, boundaries=[], collapsed=False
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob153_gshare/archive_space_report.md:6:- occupied_cells: `0`
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob153_gshare/archive_space_report.md:24:- collapsed_axes: `none`
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob153_gshare/archive_space_report.md:32:- `random_hash_0`: intended=4, effective=0, boundaries=[], collapsed=False
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob153_gshare/archive_space_report.md:33:- `random_hash_1`: intended=4, effective=0, boundaries=[], collapsed=False
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob153_gshare/archive_space_report.md:34:- `random_hash_2`: intended=4, effective=0, boundaries=[], collapsed=False
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/RTLLM/Prob041_traffic_light/archive_space.json:4:  "occupied_cells": 0,
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/RTLLM/Prob041_traffic_light/archive_space.json:19:      "collapsed": false,
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/RTLLM/Prob041_traffic_light/archive_space.json:27:      "collapsed": false,
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/RTLLM/Prob041_traffic_light/archive_space.json:35:      "collapsed": false,
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/RTLLM/Prob041_traffic_light/archive_space.json:76:  "collapsed_axes": [],
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob153_gshare/archive_space.json:4:  "occupied_cells": 0,
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob153_gshare/archive_space.json:20:      "collapsed": false,
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob153_gshare/archive_space.json:28:      "collapsed": false,
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob153_gshare/archive_space.json:36:      "collapsed": false,
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob153_gshare/archive_space.json:78:  "collapsed_axes": [],
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/RTLLM/Prob041_traffic_light/qd_metrics.json:10:  "occupied_cells": 0,
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/RTLLM/Prob041_traffic_light/qd_metrics.json:47:  "descriptor_health_files": {
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/RTLLM/Prob041_traffic_light/qd_metrics.json:48:    "json": "descriptor_health.json",
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/RTLLM/Prob041_traffic_light/qd_metrics.json:49:    "report": "descriptor_health_report.md"
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/RTLLM/Prob041_traffic_light/qd_metrics.json:61:    "occupied_cells": 0,
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/RTLLM/Prob041_traffic_light/qd_metrics.json:128:      "collapsed_axes": [],
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/RTLLM/Prob041_traffic_light/qd_metrics.json:151:      "occupied_cells": 0,
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/RTLLM/Prob041_traffic_light/qd_metrics.json:218:        "collapsed_axes": [],
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/RTLLM/Prob041_traffic_light/qd_metrics.json:250:  "collapsed_axes": [],
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob153_gshare/descriptor_health_report.md:8:- collapsed_axes: `none`
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob153_gshare/descriptor_health_report.md:23:- collapsed_axes: `none`
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob153_gshare/descriptor_health_report.md:33:- collapsed_in_archive: `False`
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob153_gshare/descriptor_health_report.md:39:- collapsed_in_archive: `False`
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob153_gshare/descriptor_health_report.md:45:- collapsed_in_archive: `False`
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob153_gshare/qd_metrics.json:11:  "occupied_cells": 0,
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob153_gshare/qd_metrics.json:48:  "descriptor_health_files": {
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob153_gshare/qd_metrics.json:49:    "json": "descriptor_health.json",
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob153_gshare/qd_metrics.json:50:    "report": "descriptor_health_report.md"
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob153_gshare/qd_metrics.json:63:    "occupied_cells": 0,
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob153_gshare/qd_metrics.json:130:      "collapsed_axes": [],
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob153_gshare/qd_metrics.json:154:      "occupied_cells": 0,
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob153_gshare/qd_metrics.json:221:        "collapsed_axes": [],
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob153_gshare/qd_metrics.json:253:  "collapsed_axes": [],
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/RTLLM/Prob041_traffic_light/archive_summary.json:10:  "occupied_cells": 0,
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/RTLLM/Prob041_traffic_light/archive_summary.json:47:  "descriptor_health_files": {
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/RTLLM/Prob041_traffic_light/archive_summary.json:48:    "json": "descriptor_health.json",
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/RTLLM/Prob041_traffic_light/archive_summary.json:49:    "report": "descriptor_health_report.md"
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/RTLLM/Prob041_traffic_light/archive_summary.json:70:  "collapsed_axes": [],
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob153_gshare/descriptor_health.json:13:  "occupied_cells": 0,
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob153_gshare/descriptor_health.json:21:  "collapsed_axes": [],
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob153_gshare/descriptor_health.json:52:      "collapsed_in_archive": false
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob153_gshare/descriptor_health.json:83:      "collapsed_in_archive": false
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob153_gshare/descriptor_health.json:114:      "collapsed_in_archive": false
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob153_gshare/archive_summary.json:11:  "occupied_cells": 0,
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob153_gshare/archive_summary.json:48:  "descriptor_health_files": {
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob153_gshare/archive_summary.json:49:    "json": "descriptor_health.json",
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob153_gshare/archive_summary.json:50:    "report": "descriptor_health_report.md"
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob153_gshare/archive_summary.json:71:  "collapsed_axes": [],
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/RTLLM/Prob041_traffic_light/grid_quantile_occupancy_evolution.html:183:const DATA = {"archive_type":"grid_quantile","visualization_version":2,"axes":["random_hash_0","random_hash_1","random_hash_2"],"axis_details":[{"name":"random_hash_0","effective_bins":0,"quantile_boundaries":[],"intervals":[],"collapsed":false},{"name":"random_hash_1","effective_bins":0,"quantile_boundaries":[],"intervals":[],"collapsed":false},{"name":"random_hash_2","effective_bins":0,"quantile_boundaries":[],"intervals":[],"collapsed":false}],"axis_layout":{},"render_axis_indices":[],"render_shape":[],"effective_shape":[],"intended_shape":[4,4,4],"collapsed_axes":[],"active_axis_names":[],"slice_axis":null,"slice_count":0,"visualization_mode":"skipped","skip_reason":"grid_quantile visualizer supports 2- or 3-axis profiles","quality_min":0.32911099007504235,"quality_max":0.32911099007504235,"frames":[{"frame_index":0,"generation":0,"initialized":false,"phase":"warmup","occupied_cells":0,"num_cells":0,"coverage":0.0,"best_quality":null,"mean_quality":null,"qd_score":0.0,"new_filled_cells":0,"replaced_cells":0,"sample_count":1,"cells":[],"samples":[{"candidate_id":"a5cceced-6e74-4ca4-8ea8-a8c4cb333f23","generation":0,"quality_score":0.32911099007504235,"decision":"warmup_buffered","cell_id":"warmup:1","indices":[0,0,0],"render_indices":[],"current":true}],"changed_cell_ids":[]},{"frame_index":1,"generation":0,"initialized":false,"phase":"final_clean","occupied_cells":0,"num_cells":0,"coverage":0.0,"best_quality":null,"mean_quality":null,"qd_score":0.0,"new_filled_cells":0,"replaced_cells":0,"sample_count":1,"cells":[],"samples":[{"candidate_id":"a5cceced-6e74-4ca4-8ea8-a8c4cb333f23","generation":0,"quality_score":0.32911099007504235,"decision":"warmup_buffered","cell_id":"warmup:1","indices":[0,0,0],"render_indices":[],"current":false}],"changed_cell_ids":[],"final_clean_frame":true}]};
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/RTLLM/Prob041_traffic_light/grid_quantile_occupancy_evolution.html:470:  const pct = total ? `${Math.round((frame.occupied_cells || 0) / total * 100)}%` : "0%";
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/RTLLM/Prob041_traffic_light/grid_quantile_occupancy_evolution.html:471:  document.getElementById("covVal").textContent = `${frame.occupied_cells || 0} / ${total} (${pct})`;
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob153_gshare/grid_quantile_occupancy_evolution.html:183:const DATA = {"archive_type":"grid_quantile","visualization_version":2,"axes":["random_hash_0","random_hash_1","random_hash_2"],"axis_details":[{"name":"random_hash_0","effective_bins":0,"quantile_boundaries":[],"intervals":[],"collapsed":false},{"name":"random_hash_1","effective_bins":0,"quantile_boundaries":[],"intervals":[],"collapsed":false},{"name":"random_hash_2","effective_bins":0,"quantile_boundaries":[],"intervals":[],"collapsed":false}],"axis_layout":{},"render_axis_indices":[],"render_shape":[],"effective_shape":[],"intended_shape":[4,4,4],"collapsed_axes":[],"active_axis_names":[],"slice_axis":null,"slice_count":0,"visualization_mode":"skipped","skip_reason":"grid_quantile visualizer supports 2- or 3-axis profiles","quality_min":0.00041505128253621393,"quality_max":0.00041505128253621393,"frames":[{"frame_index":0,"generation":0,"initialized":false,"phase":"warmup","occupied_cells":0,"num_cells":0,"coverage":0.0,"best_quality":null,"mean_quality":null,"qd_score":0.0,"new_filled_cells":0,"replaced_cells":0,"sample_count":1,"cells":[],"samples":[{"candidate_id":"f367dbf4-19e3-446f-bff9-c2cba11d308b","generation":0,"quality_score":0.00041505128253621393,"decision":"warmup_buffered","cell_id":"warmup:1","indices":[0,0,0],"render_indices":[],"current":true}],"changed_cell_ids":[]},{"frame_index":1,"generation":0,"initialized":false,"phase":"final_clean","occupied_cells":0,"num_cells":0,"coverage":0.0,"best_quality":null,"mean_quality":null,"qd_score":0.0,"new_filled_cells":0,"replaced_cells":0,"sample_count":1,"cells":[],"samples":[{"candidate_id":"f367dbf4-19e3-446f-bff9-c2cba11d308b","generation":0,"quality_score":0.00041505128253621393,"decision":"warmup_buffered","cell_id":"warmup:1","indices":[0,0,0],"render_indices":[],"current":false}],"changed_cell_ids":[],"final_clean_frame":true}]};
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob153_gshare/grid_quantile_occupancy_evolution.html:470:  const pct = total ? `${Math.round((frame.occupied_cells || 0) / total * 100)}%` : "0%";
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob153_gshare/grid_quantile_occupancy_evolution.html:471:  document.getElementById("covVal").textContent = `${frame.occupied_cells || 0} / ${total} (${pct})`;
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/RTLLM/Prob041_traffic_light/grid_quantile_visualization_manifest.json:9:  "occupied_cells": 0,
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/RTLLM/Prob041_traffic_light/grid_quantile_visualization_manifest.json:25:  "collapsed_axes": [],
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob153_gshare/grid_quantile_visualization_manifest.json:9:  "occupied_cells": 0,
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob153_gshare/grid_quantile_visualization_manifest.json:25:  "collapsed_axes": [],
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/RTLLM/Prob041_traffic_light/grid_quantile_evolution_data.json:15:      "collapsed": false
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/RTLLM/Prob041_traffic_light/grid_quantile_evolution_data.json:22:      "collapsed": false
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/RTLLM/Prob041_traffic_light/grid_quantile_evolution_data.json:29:      "collapsed": false
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/RTLLM/Prob041_traffic_light/grid_quantile_evolution_data.json:41:  "collapsed_axes": [],
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/RTLLM/Prob041_traffic_light/grid_quantile_evolution_data.json:55:      "occupied_cells": 0,
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/RTLLM/Prob041_traffic_light/grid_quantile_evolution_data.json:88:      "occupied_cells": 0,
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob153_gshare/grid_quantile_evolution_data.json:15:      "collapsed": false
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob153_gshare/grid_quantile_evolution_data.json:22:      "collapsed": false
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob153_gshare/grid_quantile_evolution_data.json:29:      "collapsed": false
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob153_gshare/grid_quantile_evolution_data.json:41:  "collapsed_axes": [],
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob153_gshare/grid_quantile_evolution_data.json:55:      "occupied_cells": 0,
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob153_gshare/grid_quantile_evolution_data.json:88:      "occupied_cells": 0,
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/graph_testability_3d/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob135_m2014_q6b/Gen5/Prob135_m2014_q6b_sample8_C-F/code_feedback.txt:8:- The current expression is a two‑level combinational network (AND/OR/XOR). This is already minimal for binary‑encoded FSMs, but the XOR gate (`y[2] ^ y[1]`) adds a gate‑level delay. Mapping the entire expression onto a single LUT (in an FPGA) or a multi‑input NAND/NOR tree (in ASIC) can collapse the two levels into one physical stage, shortening the critical path.
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob153_gshare/grid_quantile_layout.json:4:  "occupied_cells": 0,
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob153_gshare/grid_quantile_layout.json:20:      "collapsed": false,
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob153_gshare/grid_quantile_layout.json:28:      "collapsed": false,
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob153_gshare/grid_quantile_layout.json:36:      "collapsed": false,
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob153_gshare/grid_quantile_layout.json:78:  "collapsed_axes": [],
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob153_gshare/archive_history.jsonl:1:{"generation": 0, "archive_type": "grid_quantile", "cell_mode": "pareto_front", "max_elites_per_cell": 5, "objective_names": ["g_P", "g_A", "g_T"], "occupied_cells": 0, "total_archive_members": 0, "archive_member_count": 0, "fail_pool_size": 7, "success_pool_size": 1, "mean_front_size": 0.0, "max_front_size": 0, "global_pareto_size": 1, "success_parent_requests": 0, "qd_scheduler_mode": "map_elites", "qd_parent_selection": "nsga2_global_rank", "front_slot_lane_fraction": 0.1, "front_slot_lane_parent_requests": 0, "front_slot_lane_parent_hits": 0, "sparse_front_trigger_batches": 0, "sparse_front_trigger_parent_requests": 0, "sparse_front_trigger_champion_lane_fraction": 0.65, "two_parent_attempts": 0, "two_parent_fallbacks": 0, "qd_two_parent_probability": 0.5, "qd_two_parent_gate": "none", "two_parent_gate_attempts": 0, "two_parent_gate_accepts": 0, "two_parent_gate_rejects": 0, "num_cells": 0, "fill_target_cells": 1, "qd_improve_backfill_fraction": 0.2, "coverage": 0.0, "coverage_fail_share": null, "p_fail_cap": null, "qd_score": 0, "best_quality": null, "mean_quality": null, "new_filled_cells": 0, "new_archive_members": 0, "replaced_cells": 0, "runtime_seconds": 304.50332593917847, "qd_rebinning_kind": "ks_triggered", "qd_rebinning_recent_generations": 3, "qd_rebinning_min_archive_members": 20, "qd_rebinning_cooldown_generations": 3, "qd_rebinning_base_p_threshold": 0.05, "total_rebin_count": 0, "last_rebin_generation": null, "last_corrected_p_threshold": null, "rebin_cooldown_remaining": 0, "last_rebin_axes": [], "rebin_recent_sample_count": 1, "rebin_replay_member_count": 1, "qd_grid_quantile_adaptive_warmup_successes": 0, "qd_grid_quantile_adaptive_warmup_generation": 1, "qd_adaptive_warmup_champion_lane_fraction": null, "qd_archive_activation_generation": 0, "qd_archive_activation_stagnation_generations": 0, "qd_archive_stagnation_triggered": false, "qd_archive_pressure_active": true, "representation_kind": "code_individual", "code_samples_per_thought": 4, "thought_population_size": 8, "base_code_sample_budget_per_generation": 8, "repair_kind": "none", "repair_max_attempts_per_sample": 0, "repair_max_attempts_per_thought": 0, "grid_quantile_geometry": {"initialized": false, "effective_shape": [], "active_effective_axes": 0, "collapsed_axes": [], "quantile_boundaries_hash": null, "warmup_successes": 8, "warmup_buffer_size": 1, "intended_num_cells": 64}, "best_g_P": 0.0, "best_g_A": 0.0, "best_g_T": 0.0, "mean_g_P": 0.0, "mean_g_A": 0.0, "mean_g_T": 0.0}
exp/natural_qd_push/n06_descriptor_bakeoff_20260703_070921_UTC/live/random_hash_3d/seed_1001/openai_gpt-oss-120b/RTLLM/Prob041_traffic_light/descriptor_health_report.md:8:- collapsed_axes: `none`

codex
The N06 “probe” files under the lane are profile metadata, not sampled extraction evidence. That is useful for the PPA-leakage gate, but it does not satisfy the methodology’s own collapse/extraction preflight gate before spend.
exec
/bin/bash -lc "nl -ba docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/natural_qd_push_implementation_history.md | sed -n '260,360p'" in /workspace
 succeeded in 0ms:
   260	- Periodic `claude -p` adversarial review launched (due at ~12 commits);
   261	  output will land in `reviews/claude_periodic_review_20260703_p0.md`.
   262	
   263	## 2026-07-03 15:50 KST - Periodic Review: PASS_WITH_ACTIONS (8 actions)
   264	
   265	- Review recorded at `reviews/claude_periodic_review_20260703_p0.md`.
   266	  The reviewer independently recomputed all six per-seed means (exact
   267	  match), verified operator contracts, registration ordering,
   268	  quarantine, and the engine-untouched diffstat. Verdict:
   269	  PASS_WITH_ACTIONS; no evidence-integrity violation.
   270	- Interpretation softening (review F-6, adopted): the V2 screen win is
   271	  CONSISTENT WITH the operator-contamination thesis but does not
   272	  isolate it — representation and evaluation surface also differ from
   273	  the F1 radical arm; the clean operator isolation remains the 20260630
   274	  same-seed reruns. Narrative-facing text must use the softened form.
   275	- Reviewer-surfaced strengthener: at seed 1003 V2 loses fsm (0.1459 vs
   276	  0.2652) yet still wins the seed overall — direct rebuttal to
   277	  fsm-jackpot dependence; use in the lane report and any deck.
   278	- Budget-parity observation (F-7): per-arm initial_count varies
   279	  (30/22/25 vs 20/22/22) with flipping direction — reads as
   280	  retry/yield variance; per-arm LLM-call totals from scheduler
   281	  telemetry join the standard package via the validator extension.
   282	- Actions being executed: plan strict_ablation correction note (F-1);
   283	  validator extension for config-vs-registration + LLM-call totals
   284	  (F-2/F-7); tracked seed-summary generator (F-3); N03 card consistency
   285	  + versioned criterion note (F-4); TODO syncs (F-5); commit-subject
   286	  length + cards-before-code practice going forward (F-8); N02 test
   287	  draw fix + required gamma + figure-fix TODO line (F-9).
   288	
   289	## 2026-07-03 16:40 KST - N06 Upgraded to Active (descriptor research)
   290	
   291	- User request: research empirically-strong, theoretically-grounded
   292	  descriptors for V2. Evidence deep-dive completed and condensed into
   293	  `lanes/N06_descriptor_bakeoff/research_memo.md`.
   294	- Decisive finding: NO descriptor bake-off has ever run on the V2
   295	  platform. F12's "no profile beats classic" is RADICAL-regime
   296	  evidence (the June-18 briefing itself attributed the deficit to
   297	  representation+operator, not the archive). What DOES transfer is the
   298	  trio's collapse: confirmed in three regimes, incl. operator-fair
   299	  CODE-EoH (ff_depth collapses 7/13); comb_width_log is a formal size
   300	  proxy (diversity claim dropped at freeze).
   301	- Registered wave structure (methodology.md): wave 1 = pure profile
   302	  swaps journal_graph_testability_3d (semantic challenger: SCOAP/
   303	  reconvergence/cyclomatic; F12 occupancy 0.50 vs trio 0.12) +
   304	  size_control_3d (structural bar that beat theory under CODE-EoH) +
   305	  random floor (T22 lesson: random is not weak); wave 2 =
   306	  theory_grounded_compact_8d (zero axis collapses operator-fair) on
   307	  CVT with a paired trio-CVT control (versioned two-factor note, N03
   308	  pattern). Probe step before any spend. SR ReLU PCA (T19, +16.82% HV
   309	  replay, beats random) stays a registered follow-up requiring a
   310	  frozen-projection spec.
   311	- Sequencing: N06 wave 1 launches after the P1 chain frees the
   312	  endpoint, alongside whatever N03/N02 steps their dependencies allow.
   313	
   314	## 2026-07-03 17:20 KST - P1 Reads: Retention Ladder; N05 Retired; Chain 2 Up
   315	
   316	- P1 chain completed exit 0 (all four screen arms + N02 smoke).
   317	  Packages: `lanes/N01_cell_retention_mode/package/`,
   318	  `lanes/N05_warmup_init/package/`; all operator contracts pass
   319	  (single_thought=0, M-T=0), coverage 8/8 everywhere, config-pinned
   320	  validations pass for all four arms.
   321	- N01 seed-1001 attribution ladder (mean HV): classic 0.14064 ->
   322	  scalar_elite 0.14683 (+4.4%) -> elite_pareto_slot_2 0.15709
   323	  (+11.7%) -> V2 pareto_front(5) 0.17376 (+23.5%). Retention capacity
   324	  monotone in HV; Pareto POINTS monotone the other way (3.375 -> 3.125
   325	  -> 2.625). Both arms diagnostic keepers; no challenger to V2.
   326	- N05 seed-1001: warmup 4 = 0.14927 (-14.1% vs V2), warmup 16 =
   327	  0.16383 (-5.7%); both directions lose, coverage unaffected. Lane
   328	  RETIRED per its registered rule (cause: platform-optimum; positive
   329	  tuning validation of warmup 8). Backlog note: revisit only inside
   330	  N04 depth shapes.
   331	- N02 smoke: `revolution_qd_natural` ran live cleanly (107 s, config
   332	  shows gamma 1.0 + nsga2_global_rank, archive artifacts written) —
   333	  N02a full screen cleared for chain 2.
   334	- N06 wave-1 probes recorded (`lanes/N06_descriptor_bakeoff/probes/`):
   335	  all three profiles resolve with requires_ppa=false
   336	  (graph_testability: rtl+graph metrics; size_control: rtl-text only;
   337	  random_hash: synthesis hash). Random control runs via explicit
   338	  `--qd_descriptor_axes random_hash_0..2` (profile not in the locked
   339	  YAML; no YAML edit needed).
   340	- Chain 2 launched sequentially: N06b graph_testability_3d, N06c
   341	  size_control_3d, N06d random_hash_3d, N03a/b front-slot lanes
   342	  (0.10/0.30 on elite_pareto_slot(2) per the amended card), N02a
   343	  curiosity gamma 1.0 — all seed 1001 with per-arm preflights.
   344	
   345	## 2026-07-03 17:45 KST - Second-Opinion Review Channel Adopted (codex)
   346	
   347	- User-adopted practice: alongside the periodic `claude -p` review, run
   348	  `codex --yolo exec "Requesting READ-ONLY review of <scope> following
   349	  GUIDELINES.md and the push plan ..."` for an independent second
   350	  opinion; outputs land under `reviews/`. Prompts must state read-only
   351	  and demand a PASS/FAIL verdict with numbered actions.
   352	- First trial launched now (codex-cli 0.142.4) over the review-action
   353	  batch + P1 packages (6fa46cfc77..HEAD), with spot-recompute of the
   354	  N01/N05 report numbers, the N05 retirement justification, GUIDELINES
   355	  simplicity of the three new scripts, single-seed overclaim risk in
   356	  the retention-ladder wording, and N06 registration quality as the
   357	  focus questions. Output:
   358	  `reviews/codex_second_opinion_20260703_p1.md`.

exec
/bin/bash -lc 'rg -n "probe|N06|descriptor" docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/natural_qd_push_implementation_todo.md docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/natural_qd_push_implementation_history.md docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/reviews/codex_second_opinion_20260703_p1.md' in /workspace
 succeeded in 0ms:
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/natural_qd_push_implementation_history.md:65:  descriptor-input exclusions, Branch A/B/C rules, Branch-B utility
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/natural_qd_push_implementation_history.md:289:## 2026-07-03 16:40 KST - N06 Upgraded to Active (descriptor research)
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/natural_qd_push_implementation_history.md:292:  descriptors for V2. Evidence deep-dive completed and condensed into
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/natural_qd_push_implementation_history.md:293:  `lanes/N06_descriptor_bakeoff/research_memo.md`.
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/natural_qd_push_implementation_history.md:294:- Decisive finding: NO descriptor bake-off has ever run on the V2
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/natural_qd_push_implementation_history.md:311:- Sequencing: N06 wave 1 launches after the P1 chain frees the
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/natural_qd_push_implementation_history.md:334:- N06 wave-1 probes recorded (`lanes/N06_descriptor_bakeoff/probes/`):
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/natural_qd_push_implementation_history.md:338:  `--qd_descriptor_axes random_hash_0..2` (profile not in the locked
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/natural_qd_push_implementation_history.md:340:- Chain 2 launched sequentially: N06b graph_testability_3d, N06c
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/natural_qd_push_implementation_history.md:341:  size_control_3d, N06d random_hash_3d, N03a/b front-slot lanes
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/natural_qd_push_implementation_history.md:356:  the retention-ladder wording, and N06 registration quality as the
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/natural_qd_push_implementation_todo.md:74:- [ ] N06 descriptor bake-off — UPGRADED to active at user request
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/natural_qd_push_implementation_todo.md:75:      (2026-07-03): wave-1 probe step then
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/natural_qd_push_implementation_todo.md:79:      `lanes/N06_descriptor_bakeoff/`.
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/reviews/codex_second_opinion_20260703_p1.md: binary file matches (found "\0" byte around offset 34036)

exec
/bin/bash -lc "git show --stat --oneline --decorate HEAD && git show --format=fuller --no-patch HEAD && git log --format='%h %s' 6fa46cfc77..HEAD" in /workspace
exec
/bin/bash -lc "git diff -- docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/reviews/codex_second_opinion_20260703_p1.md | sed -n '1,220p'" in /workspace
 succeeded in 172ms:
diff --git i/docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/reviews/codex_second_opinion_20260703_p1.md w/docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/reviews/codex_second_opinion_20260703_p1.md
index 61f9bbf55a..0c2e08fd6a 100644
--- i/docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/reviews/codex_second_opinion_20260703_p1.md
+++ w/docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/reviews/codex_second_opinion_20260703_p1.md
@@ -399,3 +399,2903 @@ a08a7577f1 fix(qd): Require explicit curiosity gamma flag
 8084a41605 feat(qd): Add screen seed summary reporter
 751815dbc2 feat(qd): Add config pins to the run validator
 
+codex
+The worktree is dirty, but the dirty paths are outside the core files I’m about to inspect, so I’ll review the committed `6fa46cfc77..HEAD` state and call out that boundary if it matters. Next I’m pulling the lane packages, script diffs, and exact report/table paths before doing the arithmetic checks.
+exec
+/bin/bash -lc "sed -n '261,520p' docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/natural_qd_push_plan.md" in /workspace
+ succeeded in 0ms:
+  mock EDA binaries. Run pytest (focused), `ruff check`, `python -m
+  pyright` on touched modules; record results in history.
+- No imports from untracked directories (`exp/`, ad-hoc checkouts); every
+  script and config a run needs is tracked in git.
+- Keep grid and CVT semantics aligned when touching shared archive code
+  (GUIDELINES.md); follow Implementation Simplicity Rules (asserts, few
+  knobs, no defensive fallbacks).
+
+## Deltas Vs Inherited Contracts
+
+1. Screening kill bar is 0.95x on 3-seed mean HV (June-22 used single-seed
+   reads); single-seed near-ties are never verdicts.
+2. HV-AUC joins mean HV as a co-primary screening metric once the canonical
+   implementation lands.
+3. Lane admissibility adds the Natural-Extension Criterion (June-22 allowed
+   arbitrary mechanism complexity).
+4. Technique IDs are `N##` in `lanes/` here; the June-22 T-series is closed.
+5. The in-loop BD-input exclusion is clarified: it binds descriptors, not
+   per-cell Pareto retention/selection (which the frozen thesis mandates).
+
+## Execution Phases
+
+- **P0 Foundations (no live spend except the V2 anchor).** Pin the
+  8-design manifest + classic run roots into `tables/`; pin the exact V2
+  platform config; port + test the operator-contract auditor; canonicalize
+  HV-AUC (regression-test vs 20260630 tables); write
+  `validate_natural_qd_run.py`; run V2 on the screen (seed 1001, then
+  1002/1003 — it is expected within +-5%) to anchor all lane deltas.
+- **P1 Single-factor screens.** N01, N02, N03, N05 at 8x5 seed 1001;
+  seed-replicate near-ties; per-lane package (methodology, commands,
+  figures incl. direct raw PPA Pareto PNG, tables, tier decision) per the
+  inherited visualization policy.
+- **P2 Shape and follow-ups.** N04 budget shape for the current leader;
+  registered follow-up variants from P1 diagnoses; N06/N07 only per their
+  conditions.
+- **P3 Confirmation.** Pre-registered best arm (or N08 combination) on
+  full RTLLM 46 ref-complete seed 1001, then seeds 1001-1005, vs reused
+  classic 5-seed baselines; contract statistics; held-out gate if the
+  5-seed read clears the screen bars.
+- **P4 Synthesis.** Refresh `13_findings_dashboard.md` tables and the
+  June-22 `technique_lineage_ledger.md` closure note; central comparison
+  report here; adversarial validation PASS; presentation pack only after
+  the verdict is stable.
+
+## Completion Gates
+
+- [ ] P0 artifacts exist: pinned manifests/baselines, V2 anchor runs,
+      canonical HV-AUC with regression test, tracked operator auditor,
+      run validator with tests.
+- [ ] >=8 lane packages across >=4 families, each operator-audited, with
+      figures, tables, tier decision, and follow-up/retirement rationale.
+- [ ] At least one arm promoted and run at full RTLLM 5-seed, or the
+      persistence policy exhausted with documented diagnoses.
+- [ ] Headline claims use reference-complete paired subsets, canonical
+      HV-AUC, and cluster statistics; no contaminated numbers cited.
+- [ ] Functionality: no promoted arm loses any classic-covered design;
+      yield warnings visible where triggered.
+- [ ] Code: no `engine.py` core-loop edits; new code small, typed, tested;
+      pytest/ruff/pyright recorded; no untracked imports.
+- [ ] Docs: lane registry current; TODO within cap; history complete;
+      dashboard refreshed; commits atomic, signed, message-verified.
+- [ ] Adversarial validator returns PASS in
+      `natural_qd_push_subagent_validation_report.md`.
+
+## Risks And Blockers
+
+- vLLM endpoint contention/downtime: preflight per batch; record blocked
+  smokes explicitly; never switch endpoints mid-comparison.
+- V2 platform drift vs current code: P0 anchor run exposes it early; if V2
+  no longer reproduces parity, fix or re-pin before any lane run.
+- All single-factor lanes land in [0.95x, 1.02x]: expected hard case —
+  budget shape (N04) and the pre-registered combination (N08) are the
+  designed escalations; descriptor bake-off (N06) after that.
+- Seed variance at 8x5 (temperature 1.0) can absorb real +2-4% effects:
+  that is why kills also require 3 seeds and why HV-AUC co-reads.
+- Compute budget: reuse classic baselines aggressively; new classic arms
+  only for new shapes (4x11) with prior registration.
+
+exec
+/bin/bash -lc 'find docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes -maxdepth 3 -type f | sort' in /workspace
+ succeeded in 0ms:
+docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/lane_registry.csv
+docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N01_cell_retention_mode/commands.md
+docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N01_cell_retention_mode/methodology.md
+docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N01_cell_retention_mode/results_report.md
+docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N02_curiosity_sampling/methodology.md
+docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N03_archive_parent_lane/commands.md
+docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N03_archive_parent_lane/methodology.md
+docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/commands.md
+docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/methodology.md
+docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/results_report.md
+docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N06_descriptor_bakeoff/methodology.md
+docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N06_descriptor_bakeoff/probes/probe_journal_graph_testability_3d.json
+docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N06_descriptor_bakeoff/probes/probe_random_hash_3d.json
+docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N06_descriptor_bakeoff/probes/probe_size_control_3d.json
+docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N06_descriptor_bakeoff/research_memo.md
+
+exec
+/bin/bash -lc 'git diff --stat 6fa46cfc77..HEAD && git diff --name-only 6fa46cfc77..HEAD' in /workspace
+exec
+/bin/bash -lc "git log --format='%H%x00%s%x00%B%x00END' 6fa46cfc77..HEAD" in /workspace
+ succeeded in 0ms:
+ae83252bf3c180269f892d660edee12c47c467ef docs(qd): Adopt codex second-opinion review channel docs(qd): Adopt codex second-opinion review channel
+
+User-adopted practice: at each periodic review point, run
+codex --yolo exec with an explicit READ-ONLY review prompt alongside
+claude -p, so an independent model guards against shared blind spots
+(the June-22 contamination survived several same-channel reviews).
+Recorded in the standing-validation TODO and history; first trial is
+running over the review-action batch and P1 packages. Also syncs the
+N05 TODO line with its retirement outcome.
+
+Signed-off-by: Kyumin Cho <kmcho@postech.ac.kr>
+ END
+f186b45f1384bec22966d8c4cc5c3cf7241251db docs(qd): Package P1 reads; retire N05; queue chain 2 docs(qd): Package P1 reads; retire N05; queue chain 2
+
+Seed-1001 P1 results: the N01 attribution ladder shows retention
+capacity monotone in mean HV (classic 0.14064 -> scalar cells 0.14683
+-> one front slot 0.15709 -> V2 Pareto-5 cells 0.17376), isolating
+per-cell Pareto retention as the largest single contributor to the V2
+win; N05 shows warmup deviations lose in both directions, so the lane
+is retired as a positive validation of the platform value. All arms
+audit clean with coverage 8/8 and config-pinned validations. The N02
+smoke cleared the natural engine for its full screen, N06 wave-1
+probes resolve PPA-free, and chain 2 (N06 wave-1, N03 on the amended
+card, N02a) is running.
+
+Signed-off-by: Kyumin Cho <kmcho@postech.ac.kr>
+ END
+f239b925bab98b5c5c7381b7de4b3daed01096ac docs(qd): Upgrade N06 to active descriptor bake-off docs(qd): Upgrade N06 to active descriptor bake-off
+
+At user request, research whether V2 improves via empirically
+strong, theoretically grounded descriptors. The evidence memo finds
+that no descriptor bake-off has ever run on the V2 platform: F12's
+negative verdict is radical-regime evidence, while the trio's
+collapse is substrate-independent (ff_depth collapses on 7/13
+problems even operator-fair; comb_width_log is a formal size proxy).
+
+Register the first V2-platform bake-off: wave 1 as pure profile swaps
+(journal_graph_testability_3d as the SCOAP/reconvergence/cyclomatic
+semantic challenger, size_control_3d as the structural bar, a random
+floor per the T22 lesson), wave 2 as theory_grounded_compact_8d on
+CVT with a paired trio-CVT control, an offline probe step before any
+spend, and SR ReLU PCA as the registered follow-up.
+
+Signed-off-by: Kyumin Cho <kmcho@postech.ac.kr>
+ END
+c1e020b16b6b5d4686cd25fb969848e733904b91 docs(qd): Refresh anchor package via new tooling docs(qd): Refresh anchor package via new tooling
+
+Regenerate three_seed_summary.csv through the tracked reporter
+(values identical to the review's independent recomputation) and
+revalidate all three anchor seeds under the strengthened validator
+with the full V2 config-pin set; per-seed LLM-call totals now sit in
+the run_validation reports. Record the exact commands in the anchor
+command card.
+
+Signed-off-by: Kyumin Cho <kmcho@postech.ac.kr>
+ END
+a08a7577f13ec00d49b0de1b4d1f106f3574884c fix(qd): Require explicit curiosity gamma flag fix(qd): Require explicit curiosity gamma flag
+
+Periodic review F-9: a defaulted --qd_curiosity_gamma could
+silently run lane N02a when the flag was forgotten. The flag is now
+required with, and only valid for, search_mode=revolution_qd_natural
+(config error otherwise), and the N02 draw-distribution test uses a
+single random.choices call.
+
+Signed-off-by: Kyumin Cho <kmcho@postech.ac.kr>
+ END
+8084a416055b47ea72a73e7c9172fcca3b98a0ec feat(qd): Add screen seed summary reporter feat(qd): Add screen seed summary reporter
+
+Periodic review F-3: the headline three-seed table had no tracked
+generator. Add scripts/report_screen_seed_summary.py, which emits the
+per-seed + mean comparison table from the packaged aggregate and
+canonical HV-AUC CSVs, so every lane package reproduces its summary
+through one tracked path.
+
+Tests:
+- synthetic two-seed case
+- regression pinning the tracked p0_v2_anchor package to the exact
+  3-seed means (0.14418... / 0.16284... / 112.9)
+
+Signed-off-by: Kyumin Cho <kmcho@postech.ac.kr>
+ END
+751815dbc2665c5c2c509dd03e0190d5d6cd91a5 feat(qd): Add config pins to the run validator feat(qd): Add config pins to the run validator
+
+Periodic review F-2/F-7: the unfaithful first anchor showed that
+registered-card-vs-run config drift is the error class our tooling
+must catch, and per-arm LLM-call budgets were asserted rather than
+evidenced. The validator now checks repeatable --expect-config
+KEY=VALUE pins against the run's resolved *_revolution_config.yaml
+and reports per-problem plus total llm_api_calls in the JSON report.
+
+Tests:
+- config pin match/mismatch/missing-key cases
+- llm_api_calls totals in the clean-run report
+
+Signed-off-by: Kyumin Cho <kmcho@postech.ac.kr>
+ END
+
+ succeeded in 3960ms:
+ .../pareto_analysis/aggregate_backend_metrics.csv  |  13 +
+ .../pareto_analysis/backend_problem_metrics.csv    |  33 +
+ .../RTLLM/Prob015_multi_pipe_8bit/front_3d.png     | Bin 0 -> 429537 bytes
+ .../Prob015_multi_pipe_8bit/pairwise_fronts.png    | Bin 0 -> 234510 bytes
+ .../problems/RTLLM/Prob024_fsm/pairwise_fronts.png | Bin 0 -> 78943 bytes
+ .../Prob041_traffic_light/pairwise_fronts.png      | Bin 0 -> 92749 bytes
+ .../problems/RTLLM/Prob045_alu/pairwise_fronts.png | Bin 0 -> 75997 bytes

 succeeded in 338ms:
ae83252bf3 (HEAD -> feat/journal-qd-bd-exp-20260703) docs(qd): Adopt codex second-opinion review channel
 .../natural_qd_push_implementation_history.md      |  15 +
 .../natural_qd_push_implementation_todo.md         |  15 +-
 .../reviews/codex_second_opinion_20260703_p1.md    | 401 +++++++++++++++++++++
 3 files changed, 428 insertions(+), 3 deletions(-)
commit ae83252bf3c180269f892d660edee12c47c467ef
Author:     Kyumin Cho <kmcho@postech.ac.kr>
AuthorDate: Fri Jul 3 08:02:41 2026 +0000
Commit:     Kyumin Cho <kmcho@postech.ac.kr>
CommitDate: Fri Jul 3 08:02:41 2026 +0000

    docs(qd): Adopt codex second-opinion review channel
    
    User-adopted practice: at each periodic review point, run
    codex --yolo exec with an explicit READ-ONLY review prompt alongside
    claude -p, so an independent model guards against shared blind spots
    (the June-22 contamination survived several same-channel reviews).
    Recorded in the standing-validation TODO and history; first trial is
    running over the review-action batch and P1 packages. Also syncs the
    N05 TODO line with its retirement outcome.
    
    Signed-off-by: Kyumin Cho <kmcho@postech.ac.kr>
ae83252bf3 docs(qd): Adopt codex second-opinion review channel
f186b45f13 docs(qd): Package P1 reads; retire N05; queue chain 2
f239b925ba docs(qd): Upgrade N06 to active descriptor bake-off
c1e020b16b docs(qd): Refresh anchor package via new tooling
a08a7577f1 fix(qd): Require explicit curiosity gamma flag
8084a41605 feat(qd): Add screen seed summary reporter
751815dbc2 feat(qd): Add config pins to the run validator

codex
I’m checking whether the N01 ladder is broad or carried by a few problems. That matters because a monotone mean on one seed can still be a fragile attribution story if it comes from isolated HV jackpots.
exec
/bin/bash -lc "python - <<'PY'
import csv
from pathlib import Path
for lane in ['N01_cell_retention_mode', 'N05_warmup_init']:
    path = Path('docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes') / lane / 'package/tables/hv_auc.csv'
    rows = list(csv.DictReader(path.open()))
    by = {(r['backend'], r['problem']): r for r in rows}
    problems = sorted({r['problem'] for r in rows})
    backends = sorted({r['backend'] for r in rows})
    print(lane)
    if lane.startswith('N01'):
        pairs = [('scalar_elite','classic_revolution_8x5'),('elite_pareto_slot_2','scalar_elite'),('smooth_qd_v2_8x5','elite_pareto_slot_2'),('smooth_qd_v2_8x5','classic_revolution_8x5')]
    else:
        pairs = [('warmup_4','smooth_qd_v2_8x5'),('warmup_16','smooth_qd_v2_8x5'),('warmup_16','classic_revolution_8x5')]
    for a,b in pairs:
        print(f'  {a} minus {b}')
        total=0
        wins=0
        for p in problems:
            diff=float(by[(a,p)]['hv_final'])-float(by[(b,p)]['hv_final'])
            total+=diff
            if diff>0: wins+=1
            print(f'    {p}: {diff:+.12f}')
        print(f'    mean diff {total/len(problems):+.12f}; wins {wins}/{len(problems)}')
    print()
PY" in /workspace
 succeeded in 0ms:
N01_cell_retention_mode
  scalar_elite minus classic_revolution_8x5
    Prob015_multi_pipe_8bit: +0.000000000000
    Prob024_fsm: +0.124272755709
    Prob041_traffic_light: -0.022960965868
    Prob045_alu: -0.052270309482
    Prob049_signal_generator: +0.001716452622
    Prob116_m2014_q3: -0.000982383420
    Prob135_m2014_q6b: +0.000000000000
    Prob153_gshare: -0.000294762058
    mean diff +0.006185098438; wins 2/8
  elite_pareto_slot_2 minus scalar_elite
    Prob015_multi_pipe_8bit: +0.000976452290
    Prob024_fsm: +0.071629652799
    Prob041_traffic_light: +0.003513253450
    Prob045_alu: +0.005866323675
    Prob049_signal_generator: -0.001801215715
    Prob116_m2014_q3: +0.000982383420
    Prob135_m2014_q6b: +0.000000000000
    Prob153_gshare: +0.000899970371
    mean diff +0.010258352536; wins 6/8
  smooth_qd_v2_8x5 minus elite_pareto_slot_2
    Prob015_multi_pipe_8bit: -0.000976452290
    Prob024_fsm: +0.000000000000
    Prob041_traffic_light: +0.117764705882
    Prob045_alu: +0.025869394836
    Prob049_signal_generator: -0.009142759060
    Prob116_m2014_q3: +0.000000000000
    Prob135_m2014_q6b: +0.000000000000
    Prob153_gshare: -0.000110747584
    mean diff +0.016675517723; wins 2/8
  smooth_qd_v2_8x5 minus classic_revolution_8x5
    Prob015_multi_pipe_8bit: +0.000000000000
    Prob024_fsm: +0.195902408508
    Prob041_traffic_light: +0.098316993464
    Prob045_alu: -0.020534590971
    Prob049_signal_generator: -0.009227522152
    Prob116_m2014_q3: +0.000000000000
    Prob135_m2014_q6b: +0.000000000000
    Prob153_gshare: +0.000494460730
    mean diff +0.033118968697; wins 3/8

N05_warmup_init
  warmup_4 minus smooth_qd_v2_8x5
    Prob015_multi_pipe_8bit: +0.000000000000
    Prob024_fsm: -0.137941820456
    Prob041_traffic_light: -0.052111474219
    Prob045_alu: -0.013457401933
    Prob049_signal_generator: +0.008083220404
    Prob116_m2014_q3: +0.000000000000
    Prob135_m2014_q6b: +0.000000000000
    Prob153_gshare: -0.000517951724
    mean diff -0.024493178491; wins 1/8
  warmup_16 minus smooth_qd_v2_8x5
    Prob015_multi_pipe_8bit: +0.000000000000
    Prob024_fsm: +0.000000000000
    Prob041_traffic_light: -0.075828976035
    Prob045_alu: -0.006691149222
    Prob049_signal_generator: +0.004650315160
    Prob116_m2014_q3: -0.001086010363
    Prob135_m2014_q6b: +0.000000000000
    Prob153_gshare: -0.000517951724
    mean diff -0.009934221523; wins 1/8
  warmup_16 minus classic_revolution_8x5
    Prob015_multi_pipe_8bit: +0.000000000000
    Prob024_fsm: +0.195902408508
    Prob041_traffic_light: +0.022488017429
    Prob045_alu: -0.027225740193
    Prob049_signal_generator: -0.004577206993
    Prob116_m2014_q3: -0.001086010363
    Prob135_m2014_q6b: +0.000000000000
    Prob153_gshare: -0.000023490995
    mean diff +0.023184747174; wins 2/8


exec
/bin/bash -lc "nl -ba docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N01_cell_retention_mode/package/pareto_analysis/backend_problem_metrics.csv | sed -n '1,80p'" in /workspace
 succeeded in 0ms:
     1	backend,benchmark,problem,objective_count,candidate_count,pareto_point_count,hypervolume,reference_beating_count,best_area_improvement,best_power_improvement,best_period_improvement,problem_dir
     2	classic_revolution_8x5,RTLLM,Prob015_multi_pipe_8bit,3,17,8,0.0,0,0.3510204081632653,-0.14699331848552327,0.402439024390244,/workspace/exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/live/classic_revolution_8x5/seed_1001/openai_gpt-oss-120b/RTLLM/Prob015_multi_pipe_8bit
     3	smooth_qd_v2_8x5,RTLLM,Prob015_multi_pipe_8bit,3,15,9,0.0,0,0.36428571428571427,0.08129175946547884,0.402439024390244,/workspace/exp/natural_qd_push/p0_v2_anchor_20260703_041511_UTC/live/smooth_qd_v2_8x5/seed_1001/openai_gpt-oss-120b/RTLLM/Prob015_multi_pipe_8bit
     4	elite_pareto_slot_2,RTLLM,Prob015_multi_pipe_8bit,3,17,6,0.0009764522898626566,1,0.3877551020408163,0.4086859688195991,0.39024390243902446,/workspace/exp/natural_qd_push/n01_cell_retention_20260703_053243_UTC/live/elite_pareto_slot_2/seed_1001/openai_gpt-oss-120b/RTLLM/Prob015_multi_pipe_8bit
     5	scalar_elite,RTLLM,Prob015_multi_pipe_8bit,3,12,4,0.0,0,0.3877551020408163,0.05902004454342983,0.26829268292682934,/workspace/exp/natural_qd_push/n01_cell_retention_20260703_053243_UTC/live/scalar_elite/seed_1001/openai_gpt-oss-120b/RTLLM/Prob015_multi_pipe_8bit
     6	classic_revolution_8x5,RTLLM,Prob024_fsm,2,4,2,0.14472943384422896,3,0.3695652173913043,0.4633093525179856,0.0,/workspace/exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/live/classic_revolution_8x5/seed_1001/openai_gpt-oss-120b/RTLLM/Prob024_fsm
     7	smooth_qd_v2_8x5,RTLLM,Prob024_fsm,2,10,1,0.3406318423522052,6,0.4782608695652174,0.7122302158273381,0.0,/workspace/exp/natural_qd_push/p0_v2_anchor_20260703_041511_UTC/live/smooth_qd_v2_8x5/seed_1001/openai_gpt-oss-120b/RTLLM/Prob024_fsm
     8	elite_pareto_slot_2,RTLLM,Prob024_fsm,2,10,1,0.3406318423522052,5,0.4782608695652174,0.7122302158273381,0.0,/workspace/exp/natural_qd_push/n01_cell_retention_20260703_053243_UTC/live/elite_pareto_slot_2/seed_1001/openai_gpt-oss-120b/RTLLM/Prob024_fsm
     9	scalar_elite,RTLLM,Prob024_fsm,2,11,2,0.2690021895527056,6,0.43478260869565216,0.6215827338129496,0.0,/workspace/exp/natural_qd_push/n01_cell_retention_20260703_053243_UTC/live/scalar_elite/seed_1001/openai_gpt-oss-120b/RTLLM/Prob024_fsm
    10	classic_revolution_8x5,RTLLM,Prob041_traffic_light,2,13,2,0.31010021786492376,12,0.32941176470588235,0.992037037037037,0.0,/workspace/exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/live/classic_revolution_8x5/seed_1001/openai_gpt-oss-120b/RTLLM/Prob041_traffic_light
    11	smooth_qd_v2_8x5,RTLLM,Prob041_traffic_light,2,18,2,0.40841721132897607,14,0.4117647058823529,0.992037037037037,0.0,/workspace/exp/natural_qd_push/p0_v2_anchor_20260703_041511_UTC/live/smooth_qd_v2_8x5/seed_1001/openai_gpt-oss-120b/RTLLM/Prob041_traffic_light
    12	elite_pareto_slot_2,RTLLM,Prob041_traffic_light,2,22,6,0.29065250544662313,20,0.3941176470588235,0.9875617283950617,0.0,/workspace/exp/natural_qd_push/n01_cell_retention_20260703_053243_UTC/live/elite_pareto_slot_2/seed_1001/openai_gpt-oss-120b/RTLLM/Prob041_traffic_light
    13	scalar_elite,RTLLM,Prob041_traffic_light,2,22,5,0.28713925199709506,18,0.3058823529411765,0.9914506172839507,0.0,/workspace/exp/natural_qd_push/n01_cell_retention_20260703_053243_UTC/live/scalar_elite/seed_1001/openai_gpt-oss-120b/RTLLM/Prob041_traffic_light
    14	classic_revolution_8x5,RTLLM,Prob045_alu,2,34,4,0.25235639266706095,34,0.2543820224719101,0.9921052631578947,0.0,/workspace/exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/live/classic_revolution_8x5/seed_1001/openai_gpt-oss-120b/RTLLM/Prob045_alu
    15	smooth_qd_v2_8x5,RTLLM,Prob045_alu,2,29,1,0.23182180169524935,29,0.23370786516853934,0.9919298245614034,0.0,/workspace/exp/natural_qd_push/p0_v2_anchor_20260703_041511_UTC/live/smooth_qd_v2_8x5/seed_1001/openai_gpt-oss-120b/RTLLM/Prob045_alu
    16	elite_pareto_slot_2,RTLLM,Prob045_alu,2,29,3,0.20595240685984628,29,0.20764044943820226,0.9918771929824561,0.0,/workspace/exp/natural_qd_push/n01_cell_retention_20260703_053243_UTC/live/elite_pareto_slot_2/seed_1001/openai_gpt-oss-120b/RTLLM/Prob045_alu
    17	scalar_elite,RTLLM,Prob045_alu,2,22,3,0.20008608318549184,22,0.20179775280898876,0.9915350877192983,0.0,/workspace/exp/natural_qd_push/n01_cell_retention_20260703_053243_UTC/live/scalar_elite/seed_1001/openai_gpt-oss-120b/RTLLM/Prob045_alu
    18	classic_revolution_8x5,RTLLM,Prob049_signal_generator,3,5,2,0.019198840440895218,4,0.425531914893617,0.46038543897216266,0.27906976744186046,/workspace/exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/live/classic_revolution_8x5/seed_1001/openai_gpt-oss-120b/RTLLM/Prob049_signal_generator
    19	smooth_qd_v2_8x5,RTLLM,Prob049_signal_generator,3,2,2,0.00997131828859078,2,0.18085106382978725,0.46038543897216266,0.13953488372093023,/workspace/exp/natural_qd_push/p0_v2_anchor_20260703_041511_UTC/live/smooth_qd_v2_8x5/seed_1001/openai_gpt-oss-120b/RTLLM/Prob049_signal_generator
    20	elite_pareto_slot_2,RTLLM,Prob049_signal_generator,3,7,3,0.019114077348440933,4,0.425531914893617,0.46038543897216266,0.27906976744186046,/workspace/exp/natural_qd_push/n01_cell_retention_20260703_053243_UTC/live/elite_pareto_slot_2/seed_1001/openai_gpt-oss-120b/RTLLM/Prob049_signal_generator
    21	scalar_elite,RTLLM,Prob049_signal_generator,3,5,3,0.020915293063094455,4,0.425531914893617,0.46038543897216266,0.27906976744186046,/workspace/exp/natural_qd_push/n01_cell_retention_20260703_053243_UTC/live/scalar_elite/seed_1001/openai_gpt-oss-120b/RTLLM/Prob049_signal_generator
    22	classic_revolution_8x5,VerilogEval-Spec-to-RTL,Prob116_m2014_q3,2,6,1,0.39842279792746116,6,0.4,0.9960569948186528,0.0,/workspace/exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/live/classic_revolution_8x5/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob116_m2014_q3
    23	smooth_qd_v2_8x5,VerilogEval-Spec-to-RTL,Prob116_m2014_q3,2,8,1,0.39842279792746116,8,0.4,0.9960569948186528,0.0,/workspace/exp/natural_qd_push/p0_v2_anchor_20260703_041511_UTC/live/smooth_qd_v2_8x5/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob116_m2014_q3
    24	elite_pareto_slot_2,VerilogEval-Spec-to-RTL,Prob116_m2014_q3,2,4,1,0.39842279792746116,4,0.4,0.9960569948186528,0.0,/workspace/exp/natural_qd_push/n01_cell_retention_20260703_053243_UTC/live/elite_pareto_slot_2/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob116_m2014_q3
    25	scalar_elite,VerilogEval-Spec-to-RTL,Prob116_m2014_q3,2,3,2,0.397440414507772,3,0.4,0.9939896373056996,0.0,/workspace/exp/natural_qd_push/n01_cell_retention_20260703_053243_UTC/live/scalar_elite/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob116_m2014_q3
    26	classic_revolution_8x5,VerilogEval-Spec-to-RTL,Prob135_m2014_q6b,2,4,1,0.0,1,0.0,0.9931390134529148,0.0,/workspace/exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/live/classic_revolution_8x5/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob135_m2014_q6b
    27	smooth_qd_v2_8x5,VerilogEval-Spec-to-RTL,Prob135_m2014_q6b,2,4,1,0.0,0,-0.2,0.9924215246636772,0.0,/workspace/exp/natural_qd_push/p0_v2_anchor_20260703_041511_UTC/live/smooth_qd_v2_8x5/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob135_m2014_q6b
    28	elite_pareto_slot_2,VerilogEval-Spec-to-RTL,Prob135_m2014_q6b,2,3,1,0.0,0,-0.2,0.9908520179372198,0.0,/workspace/exp/natural_qd_push/n01_cell_retention_20260703_053243_UTC/live/elite_pareto_slot_2/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob135_m2014_q6b
    29	scalar_elite,VerilogEval-Spec-to-RTL,Prob135_m2014_q6b,2,4,1,0.0,0,-0.2,0.9908520179372198,0.0,/workspace/exp/natural_qd_push/n01_cell_retention_20260703_053243_UTC/live/scalar_elite/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob135_m2014_q6b
    30	classic_revolution_8x5,VerilogEval-Spec-to-RTL,Prob153_gshare,3,11,6,0.00035058973340645937,4,0.08991735537190082,0.3592677345537757,0.11999999999999995,/workspace/exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/live/classic_revolution_8x5/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob153_gshare
    31	smooth_qd_v2_8x5,VerilogEval-Spec-to-RTL,Prob153_gshare,3,6,4,0.0008450504630242517,4,0.06214876033057851,0.2951945080091533,0.10666666666666662,/workspace/exp/natural_qd_push/p0_v2_anchor_20260703_041511_UTC/live/smooth_qd_v2_8x5/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob153_gshare
    32	elite_pareto_slot_2,VerilogEval-Spec-to-RTL,Prob153_gshare,3,15,4,0.0009557980470399864,3,0.07768595041322314,0.31578947368421056,0.14666666666666664,/workspace/exp/natural_qd_push/n01_cell_retention_20260703_053243_UTC/live/elite_pareto_slot_2/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob153_gshare
    33	scalar_elite,VerilogEval-Spec-to-RTL,Prob153_gshare,3,11,7,5.5827675548915465e-05,2,0.03768595041322314,0.19221967963386732,0.14666666666666664,/workspace/exp/natural_qd_push/n01_cell_retention_20260703_053243_UTC/live/scalar_elite/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob153_gshare

exec
/bin/bash -lc "nl -ba docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/package/pareto_analysis/backend_problem_metrics.csv | sed -n '1,80p'" in /workspace
 succeeded in 0ms:
     1	backend,benchmark,problem,objective_count,candidate_count,pareto_point_count,hypervolume,reference_beating_count,best_area_improvement,best_power_improvement,best_period_improvement,problem_dir
     2	classic_revolution_8x5,RTLLM,Prob015_multi_pipe_8bit,3,17,8,0.0,0,0.3510204081632653,-0.14699331848552327,0.402439024390244,/workspace/exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/live/classic_revolution_8x5/seed_1001/openai_gpt-oss-120b/RTLLM/Prob015_multi_pipe_8bit
     3	smooth_qd_v2_8x5,RTLLM,Prob015_multi_pipe_8bit,3,15,9,0.0,0,0.36428571428571427,0.08129175946547884,0.402439024390244,/workspace/exp/natural_qd_push/p0_v2_anchor_20260703_041511_UTC/live/smooth_qd_v2_8x5/seed_1001/openai_gpt-oss-120b/RTLLM/Prob015_multi_pipe_8bit
     4	warmup_4,RTLLM,Prob015_multi_pipe_8bit,3,19,8,0.0,0,0.3877551020408163,0.05902004454342983,0.4268292682926829,/workspace/exp/natural_qd_push/n05_warmup_init_20260703_053243_UTC/live/warmup_4/seed_1001/openai_gpt-oss-120b/RTLLM/Prob015_multi_pipe_8bit
     5	warmup_16,RTLLM,Prob015_multi_pipe_8bit,3,8,4,0.0,0,0.36428571428571427,-0.0144766146993318,0.3170731707317073,/workspace/exp/natural_qd_push/n05_warmup_init_20260703_053243_UTC/live/warmup_16/seed_1001/openai_gpt-oss-120b/RTLLM/Prob015_multi_pipe_8bit
     6	classic_revolution_8x5,RTLLM,Prob024_fsm,2,4,2,0.14472943384422896,3,0.3695652173913043,0.4633093525179856,0.0,/workspace/exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/live/classic_revolution_8x5/seed_1001/openai_gpt-oss-120b/RTLLM/Prob024_fsm
     7	smooth_qd_v2_8x5,RTLLM,Prob024_fsm,2,10,1,0.3406318423522052,6,0.4782608695652174,0.7122302158273381,0.0,/workspace/exp/natural_qd_push/p0_v2_anchor_20260703_041511_UTC/live/smooth_qd_v2_8x5/seed_1001/openai_gpt-oss-120b/RTLLM/Prob024_fsm
     8	warmup_4,RTLLM,Prob024_fsm,2,9,1,0.20269002189552704,4,0.32608695652173914,0.6215827338129496,0.0,/workspace/exp/natural_qd_push/n05_warmup_init_20260703_053243_UTC/live/warmup_4/seed_1001/openai_gpt-oss-120b/RTLLM/Prob024_fsm
     9	warmup_16,RTLLM,Prob024_fsm,2,13,1,0.3406318423522052,9,0.4782608695652174,0.7122302158273381,0.0,/workspace/exp/natural_qd_push/n05_warmup_init_20260703_053243_UTC/live/warmup_16/seed_1001/openai_gpt-oss-120b/RTLLM/Prob024_fsm
    10	classic_revolution_8x5,RTLLM,Prob041_traffic_light,2,13,2,0.31010021786492376,12,0.32941176470588235,0.992037037037037,0.0,/workspace/exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/live/classic_revolution_8x5/seed_1001/openai_gpt-oss-120b/RTLLM/Prob041_traffic_light
    11	smooth_qd_v2_8x5,RTLLM,Prob041_traffic_light,2,18,2,0.40841721132897607,14,0.4117647058823529,0.992037037037037,0.0,/workspace/exp/natural_qd_push/p0_v2_anchor_20260703_041511_UTC/live/smooth_qd_v2_8x5/seed_1001/openai_gpt-oss-120b/RTLLM/Prob041_traffic_light
    12	warmup_4,RTLLM,Prob041_traffic_light,2,22,2,0.35630573710965874,19,0.4,0.992037037037037,0.0,/workspace/exp/natural_qd_push/n05_warmup_init_20260703_053243_UTC/live/warmup_4/seed_1001/openai_gpt-oss-120b/RTLLM/Prob041_traffic_light
    13	warmup_16,RTLLM,Prob041_traffic_light,2,14,2,0.33258823529411763,14,0.3352941176470588,0.992037037037037,0.0,/workspace/exp/natural_qd_push/n05_warmup_init_20260703_053243_UTC/live/warmup_16/seed_1001/openai_gpt-oss-120b/RTLLM/Prob041_traffic_light
    14	classic_revolution_8x5,RTLLM,Prob045_alu,2,34,4,0.25235639266706095,34,0.2543820224719101,0.9921052631578947,0.0,/workspace/exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/live/classic_revolution_8x5/seed_1001/openai_gpt-oss-120b/RTLLM/Prob045_alu
    15	smooth_qd_v2_8x5,RTLLM,Prob045_alu,2,29,1,0.23182180169524935,29,0.23370786516853934,0.9919298245614034,0.0,/workspace/exp/natural_qd_push/p0_v2_anchor_20260703_041511_UTC/live/smooth_qd_v2_8x5/seed_1001/openai_gpt-oss-120b/RTLLM/Prob045_alu
    16	warmup_4,RTLLM,Prob045_alu,2,24,1,0.21836439976345356,24,0.2202247191011236,0.9915526315789474,0.0,/workspace/exp/natural_qd_push/n05_warmup_init_20260703_053243_UTC/live/warmup_4/seed_1001/openai_gpt-oss-120b/RTLLM/Prob045_alu
    17	warmup_16,RTLLM,Prob045_alu,2,21,1,0.2251306524738813,21,0.22696629213483147,0.9919122807017543,0.0,/workspace/exp/natural_qd_push/n05_warmup_init_20260703_053243_UTC/live/warmup_16/seed_1001/openai_gpt-oss-120b/RTLLM/Prob045_alu
    18	classic_revolution_8x5,RTLLM,Prob049_signal_generator,3,5,2,0.019198840440895218,4,0.425531914893617,0.46038543897216266,0.27906976744186046,/workspace/exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/live/classic_revolution_8x5/seed_1001/openai_gpt-oss-120b/RTLLM/Prob049_signal_generator
    19	smooth_qd_v2_8x5,RTLLM,Prob049_signal_generator,3,2,2,0.00997131828859078,2,0.18085106382978725,0.46038543897216266,0.13953488372093023,/workspace/exp/natural_qd_push/p0_v2_anchor_20260703_041511_UTC/live/smooth_qd_v2_8x5/seed_1001/openai_gpt-oss-120b/RTLLM/Prob049_signal_generator
    20	warmup_4,RTLLM,Prob049_signal_generator,3,7,3,0.018054538692762384,3,0.425531914893617,0.46038543897216266,0.27906976744186046,/workspace/exp/natural_qd_push/n05_warmup_init_20260703_053243_UTC/live/warmup_4/seed_1001/openai_gpt-oss-120b/RTLLM/Prob049_signal_generator
    21	warmup_16,RTLLM,Prob049_signal_generator,3,6,3,0.014621633448363902,3,0.425531914893617,0.46038543897216266,0.27906976744186046,/workspace/exp/natural_qd_push/n05_warmup_init_20260703_053243_UTC/live/warmup_16/seed_1001/openai_gpt-oss-120b/RTLLM/Prob049_signal_generator
    22	classic_revolution_8x5,VerilogEval-Spec-to-RTL,Prob116_m2014_q3,2,6,1,0.39842279792746116,6,0.4,0.9960569948186528,0.0,/workspace/exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/live/classic_revolution_8x5/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob116_m2014_q3
    23	smooth_qd_v2_8x5,VerilogEval-Spec-to-RTL,Prob116_m2014_q3,2,8,1,0.39842279792746116,8,0.4,0.9960569948186528,0.0,/workspace/exp/natural_qd_push/p0_v2_anchor_20260703_041511_UTC/live/smooth_qd_v2_8x5/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob116_m2014_q3
    24	warmup_4,VerilogEval-Spec-to-RTL,Prob116_m2014_q3,2,5,1,0.39842279792746116,5,0.4,0.9960569948186528,0.0,/workspace/exp/natural_qd_push/n05_warmup_init_20260703_053243_UTC/live/warmup_4/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob116_m2014_q3
    25	warmup_16,VerilogEval-Spec-to-RTL,Prob116_m2014_q3,2,4,2,0.39733678756476687,4,0.4,0.9935751295336787,0.0,/workspace/exp/natural_qd_push/n05_warmup_init_20260703_053243_UTC/live/warmup_16/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob116_m2014_q3
    26	classic_revolution_8x5,VerilogEval-Spec-to-RTL,Prob135_m2014_q6b,2,4,1,0.0,1,0.0,0.9931390134529148,0.0,/workspace/exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/live/classic_revolution_8x5/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob135_m2014_q6b
    27	smooth_qd_v2_8x5,VerilogEval-Spec-to-RTL,Prob135_m2014_q6b,2,4,1,0.0,0,-0.2,0.9924215246636772,0.0,/workspace/exp/natural_qd_push/p0_v2_anchor_20260703_041511_UTC/live/smooth_qd_v2_8x5/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob135_m2014_q6b
    28	warmup_4,VerilogEval-Spec-to-RTL,Prob135_m2014_q6b,2,4,1,0.0,0,-0.2,0.9924215246636772,0.0,/workspace/exp/natural_qd_push/n05_warmup_init_20260703_053243_UTC/live/warmup_4/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob135_m2014_q6b
    29	warmup_16,VerilogEval-Spec-to-RTL,Prob135_m2014_q6b,2,4,1,0.0,0,-0.2,0.9908520179372198,0.0,/workspace/exp/natural_qd_push/n05_warmup_init_20260703_053243_UTC/live/warmup_16/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob135_m2014_q6b
    30	classic_revolution_8x5,VerilogEval-Spec-to-RTL,Prob153_gshare,3,11,6,0.00035058973340645937,4,0.08991735537190082,0.3592677345537757,0.11999999999999995,/workspace/exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/live/classic_revolution_8x5/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob153_gshare
    31	smooth_qd_v2_8x5,VerilogEval-Spec-to-RTL,Prob153_gshare,3,6,4,0.0008450504630242517,4,0.06214876033057851,0.2951945080091533,0.10666666666666662,/workspace/exp/natural_qd_push/p0_v2_anchor_20260703_041511_UTC/live/smooth_qd_v2_8x5/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob153_gshare
    32	warmup_4,VerilogEval-Spec-to-RTL,Prob153_gshare,3,9,5,0.0003270987385819925,1,0.07768595041322314,0.31578947368421056,0.11999999999999995,/workspace/exp/natural_qd_push/n05_warmup_init_20260703_053243_UTC/live/warmup_4/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob153_gshare
    33	warmup_16,VerilogEval-Spec-to-RTL,Prob153_gshare,3,2,2,0.0003270987385819925,1,0.0971900826446281,0.32265446224256294,0.013333333333333345,/workspace/exp/natural_qd_push/n05_warmup_init_20260703_053243_UTC/live/warmup_16/seed_1001/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob153_gshare

exec
/bin/bash -lc 'nl -ba docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N01_cell_retention_mode/package/tables/operator_contract.csv && nl -ba docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/package/tables/operator_contract.csv' in /workspace
 succeeded in 0ms:
     1	method_key,candidate_count,initial_count,single_thought_count,eoh_strategy_count,other_strategy_count,status
     2	classic_revolution_8x5,191,20,0,171,0,pass
     3	elite_pareto_slot_2,221,27,0,194,0,pass
     4	scalar_elite,174,24,0,150,0,pass
     5	smooth_qd_v2_8x5,196,30,0,166,0,pass
     1	method_key,candidate_count,initial_count,single_thought_count,eoh_strategy_count,other_strategy_count,status
     2	classic_revolution_8x5,191,20,0,171,0,pass
     3	smooth_qd_v2_8x5,196,30,0,166,0,pass
     4	warmup_16,151,19,0,132,0,pass
     5	warmup_4,209,25,0,184,0,pass

codex
The per-problem split shows why I would soften N01: the scalar-to-slot step is broad, but the final slot-to-V2 gain is mainly traffic_light and alu, with several ties/losses. That supports “diagnostic signal,” not a stable ladder claim yet.
exec
/bin/bash -lc "python - <<'PY'
import subprocess
log = subprocess.check_output(['git','log','--format=%h%x00%s','6fa46cfc77..HEAD'], text=True)
for line in log.splitlines():
    h,s = line.split('\\0',1)
    print(f'{h} {len(s):2d} {s}')
PY" in /workspace
exec
/bin/bash -lc "git log --format='%h%n%B%n---END---' 6fa46cfc77..HEAD | rg -n '\\\\n|Signed-off-by|"'^docs'"\\(|"'^feat'"\\(|"'^fix'"\\(|"'^---END---'"'" in /workspace
exec
/bin/bash -lc "rg -n \"class NaturalQDEngine|curiosity_pool|qd_curiosity_gamma|random\\.choices|single_thought|config_paths\\[0\\]|mkdir|write_text|DictWriter|Any|default=\\[\\]\" scripts/validate_natural_qd_run.py scripts/report_screen_seed_summary.py src/revolution/qd_natural/engine.py scripts/run_backend.py" in /workspace
 succeeded in 0ms:
scripts/run_backend.py:487:            qd_curiosity_gamma=(
scripts/run_backend.py:488:                args.qd_curiosity_gamma
scripts/run_backend.py:489:                if args.qd_curiosity_gamma is not None
scripts/run_backend.py:954:        choices=["eoh_strategies", "single_thought_operator"],
scripts/run_backend.py:1088:        choices=["eoh_strategies", "single_thought_operator"],
scripts/run_backend.py:1132:        "--qd_curiosity_gamma",
scripts/run_backend.py:1411:        != (args.qd_curiosity_gamma is not None)
scripts/run_backend.py:1414:            "Configuration error: --qd_curiosity_gamma is required with, and "
scripts/report_screen_seed_summary.py:114:    args.output.parent.mkdir(parents=True, exist_ok=True)
scripts/report_screen_seed_summary.py:116:        writer = csv.DictWriter(handle, fieldnames=FIELDS, lineterminator="\n")
src/revolution/qd_natural/engine.py:14:from typing import Any, cast
src/revolution/qd_natural/engine.py:22:def curiosity_pool(
src/revolution/qd_natural/engine.py:77:class NaturalQDEngine(QDEngine):
src/revolution/qd_natural/engine.py:80:    def __init__(self, *, qd_curiosity_gamma: float, **kwargs: Any) -> None:
src/revolution/qd_natural/engine.py:82:        assert qd_curiosity_gamma > 0.0
src/revolution/qd_natural/engine.py:86:        self.qd_curiosity_gamma = float(qd_curiosity_gamma)
src/revolution/qd_natural/engine.py:89:        pool, weights = curiosity_pool(
src/revolution/qd_natural/engine.py:93:            self.qd_curiosity_gamma,
src/revolution/qd_natural/engine.py:108:                parents.append(random.choices(pool, weights=weights, k=1)[0])
scripts/validate_natural_qd_run.py:8:- zero ``single_thought_operator`` candidates; classic arms use only the
scripts/validate_natural_qd_run.py:66:    config = yaml.safe_load(config_paths[0].read_text(encoding="utf-8"))
scripts/validate_natural_qd_run.py:118:        default=[],
scripts/validate_natural_qd_run.py:161:    args.output.parent.mkdir(parents=True, exist_ok=True)
scripts/validate_natural_qd_run.py:162:    args.output.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")

exec
/bin/bash -lc 'rg -n "PASS|FAIL|validate_natural_qd_run|report_screen_seed_summary|ruff|pyright|pytest|ty check" docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/natural_qd_push_implementation_history.md docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/p0_v2_anchor/commands.md docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N01_cell_retention_mode/commands.md docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/commands.md' in /workspace
 succeeded in 0ms:
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/p0_v2_anchor/commands.md:37:uv run python scripts/validate_natural_qd_run.py \
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/p0_v2_anchor/commands.md:51:uv run python scripts/report_screen_seed_summary.py \
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/p0_v2_anchor/commands.md:61:uv run python scripts/validate_natural_qd_run.py --run-root "$V2" \
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/natural_qd_push_implementation_history.md:130:  03e3c48475 (`scripts/validate_natural_qd_run.py`). 18 focused tests
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/natural_qd_push_implementation_history.md:131:  pass; ruff and pyright clean on touched files.
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/natural_qd_push_implementation_history.md:229:- Pre-registered screening promote gate: PASS on all three conditions.
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/natural_qd_push_implementation_history.md:263:## 2026-07-03 15:50 KST - Periodic Review: PASS_WITH_ACTIONS (8 actions)
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/natural_qd_push_implementation_history.md:269:  PASS_WITH_ACTIONS; no evidence-integrity violation.
docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/natural_qd_push_implementation_history.md:351:  and demand a PASS/FAIL verdict with numbered actions.

 succeeded in 527ms:
2:docs(qd): Adopt codex second-opinion review channel
12:Signed-off-by: Kyumin Cho <kmcho@postech.ac.kr>
14:---END---
16:docs(qd): Package P1 reads; retire N05; queue chain 2
29:Signed-off-by: Kyumin Cho <kmcho@postech.ac.kr>
31:---END---
33:docs(qd): Upgrade N06 to active descriptor bake-off
49:Signed-off-by: Kyumin Cho <kmcho@postech.ac.kr>
51:---END---
53:docs(qd): Refresh anchor package via new tooling
62:Signed-off-by: Kyumin Cho <kmcho@postech.ac.kr>
64:---END---
66:fix(qd): Require explicit curiosity gamma flag
74:Signed-off-by: Kyumin Cho <kmcho@postech.ac.kr>
76:---END---
78:feat(qd): Add screen seed summary reporter
91:Signed-off-by: Kyumin Cho <kmcho@postech.ac.kr>
93:---END---
95:feat(qd): Add config pins to the run validator
108:Signed-off-by: Kyumin Cho <kmcho@postech.ac.kr>
110:---END---

 succeeded in 549ms:
ae83252bf3 51 docs(qd): Adopt codex second-opinion review channel
f186b45f13 53 docs(qd): Package P1 reads; retire N05; queue chain 2
f239b925ba 51 docs(qd): Upgrade N06 to active descriptor bake-off
c1e020b16b 48 docs(qd): Refresh anchor package via new tooling
a08a7577f1 46 fix(qd): Require explicit curiosity gamma flag
8084a41605 42 feat(qd): Add screen seed summary reporter
751815dbc2 46 feat(qd): Add config pins to the run validator

codex
One packaging issue is emerging: N05’s validator reports use the strengthened validator but pass only a small subset of expected config pins. That weakens the “config-pinned validations pass” claim compared with N01/P0, which include operator, representation, evaluation, parent selection, and cell-count pins.
exec
/bin/bash -lc "nl -ba docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N01_cell_retention_mode/commands.md | sed -n '1,130p'" in /workspace
 succeeded in 0ms:
     1	# N01 Launch Commands (registered; launch only after the anchor package)
     2	
     3	Base = the pinned V2 anchor command (`../../tables/v2_platform_config.md`)
     4	with `BASE=exp/natural_qd_push/n01_cell_retention_<UTC>` and a fresh
     5	recorded preflight. Single-factor deltas:
     6	
     7	- N01a `elite_pareto_slot_2`: replace
     8	  `--qd_cell_mode pareto_front --qd_max_elites_per_cell 5` with
     9	  `--qd_cell_mode elite_pareto_slot --qd_max_elites_per_cell 2`;
    10	  `--save_path "${BASE}/live/elite_pareto_slot_2/seed_1001"`.
    11	- N01b `scalar_elite`: replace with
    12	  `--qd_cell_mode scalar_elite --qd_max_elites_per_cell 1`;
    13	  `--save_path "${BASE}/live/scalar_elite/seed_1001"`.
    14	
    15	Package per the P0 chain (`../../p0_v2_anchor/commands.md` shape) with
    16	backend_run entries classic + V2 anchor + the arm; audits and run
    17	validation mandatory before any read.

exec
/bin/bash -lc "nl -ba docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/p0_v2_anchor/commands.md | sed -n '1,90p'" in /workspace
exec
/bin/bash -lc "nl -ba docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/natural_qd_push_plan.md | sed -n '130,230p'" in /workspace
 succeeded in 0ms:
     1	# P0 V2 Anchor — Packaging Commands (registered before results)
     2	
     3	Run root (seed 1001): `exp/natural_qd_push/p0_v2_anchor_20260703_041511_UTC/
     4	live/smooth_qd_v2_8x5/seed_1001`
     5	Classic comparator root (reused, no relaunch):
     6	`exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/live/
     7	classic_revolution_8x5/seed_1001`
     8	Subset config: `../../20260622_010615_KST_useful_bd_push/
     9	preliminary_planning/20260625_encoder_config_screening/tables/
    10	prelim_screen_subset.yaml`
    11	
    12	```bash
    13	PUSH=docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push
    14	PKG=$PUSH/p0_v2_anchor
    15	SUBSET=docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260625_encoder_config_screening/tables/prelim_screen_subset.yaml
    16	CLASSIC=exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/live/classic_revolution_8x5/seed_1001
    17	V2=exp/natural_qd_push/p0_v2_anchor_20260703_041511_UTC/live/smooth_qd_v2_8x5/seed_1001
    18	
    19	uv run python scripts/report_pareto_analysis.py \
    20	  --backend_run classic_revolution_8x5="$CLASSIC" \
    21	  --backend_run smooth_qd_v2_8x5="$V2" \
    22	  --subset-config "$SUBSET" --output-dir "$PKG/pareto_analysis"
    23	
    24	uv run python scripts/report_ppa_distribution.py \
    25	  --backend_run classic_revolution_8x5="$CLASSIC" \
    26	  --backend_run smooth_qd_v2_8x5="$V2" \
    27	  --subset-config "$SUBSET" --output-dir "$PKG/ppa_distribution"
    28	
    29	uv run python scripts/report_hv_auc.py \
    30	  --ppa-candidates "$PKG/ppa_distribution/data/ppa_candidates.csv" \
    31	  --num-generations 5 --output "$PKG/tables/hv_auc.csv"
    32	
    33	uv run python scripts/audit_operator_contract.py \
    34	  --ppa-candidates "$PKG/ppa_distribution/data/ppa_candidates.csv" \
    35	  --output "$PKG/tables/operator_contract.csv"
    36	
    37	uv run python scripts/validate_natural_qd_run.py \
    38	  --run-root "$V2" --manifest "$PUSH/tables/screen_manifest.csv" \
    39	  --arm qd --output "$PKG/tables/run_validation.json"
    40	```
    41	
    42	Reads, registered before results: the anchor is expected within +-5% of
    43	classic mean HV 0.14064478405974706 (V2 parity platform). The recompute
    44	of the classic side doubles as the pinned-baseline verification. Any
    45	`single_thought_count != 0` or run-validation failure voids the package.
    46	
    47	Post-review additions (periodic review F-2/F-3/F-7, 2026-07-03):
    48	
    49	```bash
    50	# tracked generator for tables/three_seed_summary.csv (F-3)
    51	uv run python scripts/report_screen_seed_summary.py \
    52	  --seed 1001:$PKG/pareto_analysis/aggregate_backend_metrics.csv:$PKG/tables/hv_auc.csv \
    53	  --seed 1002:$PKG/replication/seed_1002/pareto_analysis/aggregate_backend_metrics.csv:$PKG/replication/seed_1002/hv_auc.csv \
    54	  --seed 1003:$PKG/replication/seed_1003/pareto_analysis/aggregate_backend_metrics.csv:$PKG/replication/seed_1003/hv_auc.csv \
    55	  --baseline classic_revolution_8x5 --treatment smooth_qd_v2_8x5 \
    56	  --output $PKG/tables/three_seed_summary.csv
    57	
    58	# strengthened per-seed validation: V2 config pins + LLM-call totals
    59	# (--expect-config for num_cells/warmup/max_elites/cell_mode/parent_
    60	# selection/operator_kind/representation/evaluation_mode/seed)
    61	uv run python scripts/validate_natural_qd_run.py --run-root "$V2" \
    62	  --manifest "$PUSH/tables/screen_manifest.csv" --arm qd \
    63	  --expect-config qd_num_cells=16 ... --expect-config seed=1001 \
    64	  --output "$PKG/tables/run_validation.json"
    65	```
    66	
    67	All three seeds revalidated pass under the config pins; the summary CSV
    68	was regenerated by the tracked script (generic baseline_/treatment_
    69	column names) with values identical to the review's recomputation.

 succeeded in 0ms:
   130	  (curiosity weighting). Evidence: idea backlog "Smooth-QD-v2 Pareto-biased
   131	  parent sampling", untried; extends V2's NSGA-II selection with one weight.
   132	- **N03 archive parent lane.** V2 with a fixed fraction of parents drawn
   133	  from archive front slots (`qd_front_slot_lane_fraction` in {0.10, 0.30});
   134	  no triggers. Evidence: T54/T75 precedent existed only under the
   135	  contaminated operator; never measured operator-fair.
   136	- **N04 budget shape.** Best-of-N01..N03 (or V2 if none leads) at 6x7 vs
   137	  matched classic 6x7 (0.1701 exists); optionally 4x11 with a new matched
   138	  classic arm. Evidence: T78 shows archives mature late (9/13 fill at
   139	  gen>=2); T79's negative used the contaminated T75 arm and does not bind.
   140	- **N05 warmup initialization.** V2 with archive pressure starting after a
   141	  fixed generation g0 (standard MAP-Elites random-init phase; one knob, not
   142	  a trigger). Evidence: T39 sparse-yield warmup was an operator-fair
   143	  positive ablation (fixed multi-pipe coverage). Yield-protection lane.
   144	- **N06 descriptor bake-off (conditional).** Only if N01-N03 stall and only
   145	  under the narrative's predeclared bake-off rule: transparent source-level
   146	  structural axes (T73 shape-density family: branching, wire/DFF density)
   147	  vs the frozen trio, operator-fair, with T22-style random-descriptor
   148	  control and collapse diagnostics. No pretrained-weight descriptors.
   149	- **N07 corrected-suite completion (due diligence).** Screen the three
   150	  never-rerun corrected arms' descriptor profiles operator-fair at 8-design
   151	  scale before dismissing them (rf_leafid structural, aurora raw-impl
   152	  compact, rf_deepgate hybrid). Lowest priority; encoder-flavored lanes do
   153	  not headline this push.
   154	- **N08 combination arm.** Pre-registered merge of single-factor winners
   155	  only (e.g., N01 slots + N02 sampling), run after their individual reads.
   156	
   157	Controls always available: matched classic (reused), V2 platform (P0 run),
   158	`classic_no_cf` (when operator sets are touched), random-descriptor control
   159	(when any descriptor claim is made).
   160	
   161	## Evaluation Surface
   162	
   163	- Model: `openai/gpt-oss-120b` via vLLM `http://20.0.0.103:8000/v1`
   164	  (preflight verified 2026-07-03, `max_model_len=131072`). Preflight and
   165	  record `/v1/models` before every live batch; `--max_tokens 128000
   166	  --diff_max_tokens 128000 --vllm_min_model_len 128000`; temperature 1.0,
   167	  top_p 1.0. Correction 2026-07-03 (periodic review F-1): screen runs
   168	  use `strict_ablation` evaluation — the June-25 screen comparator's
   169	  surface — not `search_accelerated` (which the June-12 matrix used);
   170	  ruling recorded in `tables/v2_platform_config.md` before the anchor
   171	  relaunch. Evaluation mode must always match the compared classic arm.
   172	- Screening: the June-22 frozen 8-design 8x5 surface (pin the exact
   173	  manifest from `preliminary_planning/20260625_encoder_config_screening/`
   174	  tables into `tables/` here during P0, before any run). Seed ladder:
   175	  1001 -> add 1002/1003 when within +-5% of classic -> full RTLLM 46
   176	  ref-complete seed 1001 -> seeds 1001-1005.
   177	- Final gates (frozen contract): held-out reference set + statistical
   178	  protocol from `journal_narrative.md` (problem-seed pairs, cluster
   179	  bootstrap, penalized imputation).
   180	- Primary metrics: mean global PPA hypervolume, HV-AUC, per-design coverage
   181	  (functionality), valid-PPA yield, Pareto points / front families.
   182	  Never average fitness as primary evidence.
   183	- HV-AUC: canonicalize one implementation in shared reporting during P0
   184	  (port the 20260630 computation; regression-test equality on stored
   185	  tables; then all packages use the shared path).
   186	- Run outputs: `exp/natural_qd_push/<lane>/<timestamp>/...`; per-run
   187	  vLLM preflight capture, full command line, `ppa_completeness.csv`,
   188	  operator-contract audit output.
   189	
   190	## Gates
   191	
   192	Screening (8-design 8x5 vs matched classic):
   193	
   194	- Hard gate: retain every classic-covered design (>=1 valid functional PPA
   195	  candidate). Coverage loss = kill, with diagnosis.
   196	- Kill: 3-seed mean HV < 0.95x matched classic, or valid-PPA yield decline
   197	  >=50% on units where classic has >=10 passing samples.
   198	- Iterate: within [0.95x, 1.02x] — requires a diagnosis note and either a
   199	  registered follow-up variant or a documented retirement.
   200	- Promote to full RTLLM: 3-seed mean HV >= matched classic 3-seed AND
   201	  HV-AUC >= classic AND coverage retained, pre-registered before the run.
   202	
   203	Final (frozen contract, unchanged): mean per-unit
   204	`log((HV_t+1e-9)/(HV_b+1e-9)) >= log(1.05)` with cluster CI low > 0;
   205	best-quality and win-rate gates per `journal_narrative.md`; functionality
   206	`NEW_OK`/coverage >= classic; Branch B additionally needs the utility
   207	metric >= 0.25. Seeds 1001-1005; debug seed 42 is never evidence.
   208	
   209	## Hard Constraints
   210	
   211	- Operator parity: `qd_operator_kind=eoh_strategies` and
   212	  `classic_operator_kind=eoh_strategies` pinned in every config;
   213	  `--eoh_success_operator_set` matched across compared arms; the
   214	  operator-contract audit (ported to `scripts/` in P0) must report
   215	  `single_thought_count=0` for both arms of every headline comparison.
   216	- `representation_kind=code_individual` everywhere.
   217	- Descriptor inputs never include final PPA, reference PPA, fitness, HV,
   218	  Pareto rank, test pass rate, or problem identity. (Per-cell Pareto
   219	  retention/selection may use evaluated PPA — selection is not a
   220	  descriptor.)
   221	- Model, subset, seeds, prompts, budgets, timeouts, and evaluation flow
   222	  fixed unless a versioned exception is recorded before running. Freeze
   223	  subsets before reading outcomes. Invalid candidates and duplicates never
   224	  count as diversity.
   225	- No new scheduler modes or lane logic inside `src/revolution/qd/engine.py`;
   226	  PCN code paths stay untouched and unused.
   227	- Contaminated June-22 numbers are never cited as evidence against a
   228	  mechanism; only operator-fair runs count either way.
   229	
   230	## Persistence Policy (anti premature-stop)

exec
/bin/bash -lc "nl -ba docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/commands.md | sed -n '1,140p'" in /workspace
 succeeded in 0ms:
     1	# N05 Launch Commands (registered; launch only after the anchor package)
     2	
     3	Base = the pinned V2 anchor command with
     4	`BASE=exp/natural_qd_push/n05_warmup_init_<UTC>` and a fresh recorded
     5	preflight. Single-factor deltas:
     6	
     7	- N05a warmup 4: replace `--qd_grid_quantile_warmup_successes 8` with
     8	  `4`; `--save_path "${BASE}/live/warmup_4/seed_1001"`.
     9	- N05b warmup 16: replace with `16`;
    10	  `--save_path "${BASE}/live/warmup_16/seed_1001"`.
    11	
    12	Package per the P0 chain; audits and run validation mandatory; coverage
    13	hard gate is the primary read for this lane.

exec
/bin/bash -lc "nl -ba docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/natural_qd_push_plan.md | sed -n '230,270p'" in /workspace
 succeeded in 0ms:
   230	## Persistence Policy (anti premature-stop)
   231	
   232	- Attempt at least 8 lane packages spanning at least 4 mechanism families
   233	  (cell retention, parent selection, budget shape, initialization,
   234	  descriptor, revalidation) before any broad negative conclusion.
   235	- Every kill records: cause class (yield-loss | front-loss |
   236	  exploration-tax | descriptor-collapse | mechanism-inert), the evidence,
   237	  and at least one follow-up idea (inherited backlog rule).
   238	- No lane is abandoned on a single seed when within +-5% of classic.
   239	- Blocked-stop only after three concrete attempts hit the same blocker,
   240	  with commands, artifacts, missing input, and the exact next decision.
   241	- The push does not stop because one lane is weak; it stops on a validated
   242	  win (screen + full suite + contract gates) or an exhausted portfolio with
   243	  an adversarial PASS on the negative map.
   244	
   245	## Code Organization
   246	
   247	- Config-first: N01/N03/N04/N05 should need no new framework code (existing
   248	  `qd_cell_mode`, lane-fraction, budget, warmup knobs). Verify before
   249	  writing any code; prefer a config + validator over a new module.
   250	- New mechanisms (N02 sampling weight) go in a small dedicated module under
   251	  `src/revolution/qd/` (e.g., `parent_sampling.py`) or a
   252	  `src/revolution/qd_natural/` subpackage subclassing `QDEngine` — never
   253	  inline additions to `engine.py` loop bodies (the PCN anti-pattern; the
   254	  `auto_bd/` subpackage is the precedent to copy).
   255	- Promote `audit_operator_contract.py` from the June-22 docs tree into
   256	  `scripts/` as a tracked, tested validator; add
   257	  `scripts/validate_natural_qd_run.py` (operator contract, token budgets,
   258	  seed, descriptor profile, archive config vs registration) with tests
   259	  under `tests/scripts/`.
   260	- Tests: extend `tests/revolution/test_qd_*` for any touched behavior;
   261	  mock EDA binaries. Run pytest (focused), `ruff check`, `python -m
   262	  pyright` on touched modules; record results in history.
   263	- No imports from untracked directories (`exp/`, ad-hoc checkouts); every
   264	  script and config a run needs is tracked in git.
   265	- Keep grid and CVT semantics aligned when touching shared archive code
   266	  (GUIDELINES.md); follow Implementation Simplicity Rules (asserts, few
   267	  knobs, no defensive fallbacks).
   268	
   269	## Deltas Vs Inherited Contracts
   270	

codex
I’m now narrowing the final findings to things that would change the branch before push: under-pinned N05 validation, over-strong N01 wording, N05 retirement framing, and N06 probe sufficiency. The new reporter and natural engine look acceptable under the simplicity rules.
exec
/bin/bash -lc "nl -ba tests/revolution/test_qd_natural_engine.py | sed -n '1,150p'" in /workspace
 succeeded in 0ms:
     1	from __future__ import annotations
     2	
     3	from collections import Counter
     4	
     5	import pytest
     6	
     7	from revolution.qd.types import ArchiveMember
     8	from revolution.qd_natural import curiosity_pool
     9	from revolution.qd_natural.engine import NaturalQDEngine
    10	
    11	
    12	def _member(
    13	    candidate_id: str, g_p: float, g_a: float, insertion_index: int
    14	) -> ArchiveMember:
    15	    return ArchiveMember(
    16	        candidate_id=candidate_id,
    17	        descriptors=(0.0,),
    18	        quality_score=(g_p + g_a) / 2.0,
    19	        objectives={"g_P": g_p, "g_A": g_a},
    20	        payload=f"payload-{candidate_id}",
    21	        insertion_index=insertion_index,
    22	    )
    23	
    24	
    25	def test_empty_archive_returns_empty_pool() -> None:
    26	    assert curiosity_pool([], ("g_P", "g_A"), 4, 1.0) == ([], [])
    27	
    28	
    29	def test_pool_keeps_nsga2_order_and_cap() -> None:
    30	    members = [
    31	        ("cell_a", _member("dominated", 0.1, 0.1, 0)),
    32	        ("cell_a", _member("front_left", 0.9, 0.2, 1)),
    33	        ("cell_b", _member("front_right", 0.2, 0.9, 2)),
    34	    ]
    35	    pool, weights = curiosity_pool(members, ("g_P", "g_A"), 2, 1.0)
    36	    # Rank 1 = the two front members; the dominated one is trimmed by the cap.
    37	    assert pool == ["payload-front_left", "payload-front_right"]
    38	    assert len(weights) == 2
    39	
    40	
    41	def test_weights_favor_underpopulated_cells() -> None:
    42	    # crowded cell has 3 members, sparse cell has 1; all mutually non-dominated
    43	    members = [
    44	        ("crowded", _member("c1", 0.9, 0.1, 0)),
    45	        ("crowded", _member("c2", 0.8, 0.2, 1)),
    46	        ("crowded", _member("c3", 0.7, 0.3, 2)),
    47	        ("sparse", _member("s1", 0.1, 0.95, 3)),
    48	    ]
    49	    pool, weights = curiosity_pool(members, ("g_P", "g_A"), 4, 1.0)
    50	    by_payload = dict(zip(pool, weights, strict=True))
    51	    assert by_payload["payload-s1"] == pytest.approx(1.0)
    52	    for crowded_id in ("c1", "c2", "c3"):
    53	        assert by_payload[f"payload-{crowded_id}"] == pytest.approx(1.0 / 3.0)
    54	
    55	
    56	def test_gamma_scales_the_bias() -> None:
    57	    members = [
    58	        ("crowded", _member("c1", 0.9, 0.1, 0)),
    59	        ("crowded", _member("c2", 0.8, 0.2, 1)),
    60	        ("sparse", _member("s1", 0.1, 0.95, 2)),
    61	    ]
    62	    _, weights_half = curiosity_pool(members, ("g_P", "g_A"), 3, 0.5)
    63	    _, weights_full = curiosity_pool(members, ("g_P", "g_A"), 3, 1.0)
    64	    # gamma=0.5 softens the crowded-cell penalty relative to gamma=1.0
    65	    assert weights_half[0] == pytest.approx((1.0 / 2.0) ** 0.5)
    66	    assert weights_full[0] == pytest.approx(0.5)
    67	    assert weights_half[0] > weights_full[0]
    68	
    69	
    70	def test_gamma_must_be_positive() -> None:
    71	    with pytest.raises(AssertionError):
    72	        curiosity_pool([], ("g_P",), 1, 0.0)
    73	
    74	
    75	def test_occupancy_counts_full_archive_not_pool() -> None:
    76	    # The dominated member is trimmed from the pool but still counts toward
    77	    # its cell's occupancy.
    78	    members = [
    79	        ("cell_a", _member("front", 0.9, 0.9, 0)),
    80	        ("cell_a", _member("dominated", 0.1, 0.1, 1)),
    81	    ]
    82	    pool, weights = curiosity_pool(members, ("g_P", "g_A"), 1, 1.0)
    83	    assert pool == ["payload-front"]
    84	    assert weights[0] == pytest.approx(0.5)
    85	
    86	
    87	def test_engine_subclasses_qd_engine_and_requires_nsga2() -> None:
    88	    from revolution.qd import QDEngine
    89	
    90	    assert issubclass(NaturalQDEngine, QDEngine)
    91	    # The override composes only with the V2 selection rule; the ctor
    92	    # assertion is exercised end-to-end by the backend engine-selection test.
    93	    assert NaturalQDEngine._sample_success_parents is not QDEngine._sample_success_parents
    94	
    95	
    96	def test_draw_distribution_respects_weights() -> None:
    97	    import random
    98	
    99	    members = [
   100	        ("crowded", _member("c1", 0.9, 0.1, 0)),
   101	        ("crowded", _member("c2", 0.8, 0.2, 1)),
   102	        ("crowded", _member("c3", 0.7, 0.3, 2)),
   103	        ("sparse", _member("s1", 0.1, 0.95, 3)),
   104	    ]
   105	    pool, weights = curiosity_pool(members, ("g_P", "g_A"), 4, 1.0)
   106	    random.seed(1001)
   107	    draws = Counter(random.choices(pool, weights=weights, k=4000))
   108	    # sparse cell weight 1.0 vs 1/3 each: expect ~2000 sparse draws of 4000
   109	    assert 1700 < draws["payload-s1"] < 2300

exec
/bin/bash -lc "nl -ba tests/scripts/test_run_backend.py | sed -n '760,850p'" in /workspace
 succeeded in 0ms:
   760	
   761	    save_path = tmp_path / "run_a"
   762	    rc = run_backend_main(
   763	        [
   764	            "--backend",
   765	            "revolution",
   766	            "--benchmarks",
   767	            "RTLLM",
   768	            "--problems",
   769	            "Prob001_accu",
   770	            "--api_backend",
   771	            "vllm",
   772	            "--model_name",
   773	            "stub-model",
   774	            "--save_path",
   775	            str(save_path),
   776	            "--total_worker_slots",
   777	            "1",
   778	            "--population_size",
   779	            "2",
   780	            "--num_generations",
   781	            "1",
   782	        ]
   783	    )
   784	    assert rc == 0
   785	
   786	    model_root = save_path / "revolution" / "stub-model"
   787	    generated_configs = sorted(model_root.glob("*_revolution_config.yaml"))
   788	    assert generated_configs
   789	    generated_config = generated_configs[-1]
   790	    generated_payload = yaml.safe_load(generated_config.read_text(encoding="utf-8"))
   791	    assert generated_payload["save_path"] == str(save_path)
   792	    assert generated_payload["strategy_selection"] == "ucb"
   793	    assert generated_payload["total_worker_slots"] == 1
   794	    assert generated_payload["max_active_problems"] == 1
   795	    assert generated_payload["max_workers_per_problem"] == 1
   796	    assert "parallelism_mode" not in generated_payload
   797	    assert "num_workers" not in generated_payload
   798	    assert "candidate_workers" not in generated_payload
   799	
   800	    generated_meta = generated_config.with_name(f"{generated_config.stem}_meta.yaml")
   801	    assert generated_meta.exists()
   802	    meta_payload = yaml.safe_load(generated_meta.read_text(encoding="utf-8"))
   803	    assert meta_payload["command_line_arguments"]
   804	
   805	    # Rerun using generated config directly.
   806	    rc_generated = run_backend_main(["--config", str(generated_config)])
   807	    assert rc_generated == 0
   808	
   809	    # Copy and edit generated config, then rerun with modified settings.
   810	    modified_config = tmp_path / "modified_backend_config.yaml"
   811	    modified_payload = dict(generated_payload)
   812	    modified_payload["save_path"] = str(tmp_path / "run_b")
   813	    modified_payload["population_size"] = 3
   814	    modified_config.write_text(
   815	        yaml.safe_dump(modified_payload, sort_keys=True),
   816	        encoding="utf-8",
   817	    )
   818	
   819	    rc_modified = run_backend_main(["--config", str(modified_config)])
   820	    assert rc_modified == 0
   821	    modified_model_root = tmp_path / "run_b" / "revolution" / "stub-model"
   822	    assert sorted(modified_model_root.glob("*_revolution_config.yaml"))
   823	
   824	
   825	def test_run_backend_translates_legacy_parallelism_config_keys(
   826	    monkeypatch, tmp_path, capsys
   827	):
   828	    def fake_discover(args):
   829	        return [("RTLLM", "Prob001_accu", args)]
   830	
   831	    def fake_worker(payload):
   832	        benchmark, problem, args, _task_index = payload
   833	        model_name_cleaned = args.model_name.replace("/", "_")
   834	        problem_dir = (
   835	            Path(_effective_save_path(args))
   836	            / model_name_cleaned
   837	            / benchmark
   838	            / problem
   839	        )
   840	        problem_dir.mkdir(parents=True, exist_ok=True)
   841	        log_path = problem_dir / "problem_run.log"
   842	        log_path.write_text("fake worker log\n", encoding="utf-8")
   843	        return ("ok", str(log_path))
   844	
   845	    monkeypatch.setattr("scripts.run_backend._discover_tasks", fake_discover)
   846	    monkeypatch.setattr("scripts.run_backend.run_problem_worker", fake_worker)
   847	
   848	    config_path = tmp_path / "legacy_backend_config.yaml"
   849	    config_path.write_text(
   850	        yaml.safe_dump(

exec
/bin/bash -lc 'rg -n "qd_curiosity_gamma|revolution_qd_natural|Configuration error" tests/scripts/test_run_backend.py scripts/run_backend.py tests/revolution/test_qd_natural_engine.py' in /workspace
 succeeded in 0ms:
scripts/run_backend.py:487:            qd_curiosity_gamma=(
scripts/run_backend.py:488:                args.qd_curiosity_gamma
scripts/run_backend.py:489:                if args.qd_curiosity_gamma is not None
scripts/run_backend.py:833:        choices=["revolution", "revolution_qd", "revolution_qd_natural"],
scripts/run_backend.py:1132:        "--qd_curiosity_gamma",
scripts/run_backend.py:1137:            "valid for) search_mode=revolution_qd_natural (lane N02)."
scripts/run_backend.py:1397:        print(f"Configuration error: {exc}")
scripts/run_backend.py:1406:        print(f"Configuration error: {exc}")
scripts/run_backend.py:1410:        (args.search_mode == "revolution_qd_natural")
scripts/run_backend.py:1411:        != (args.qd_curiosity_gamma is not None)
scripts/run_backend.py:1414:            "Configuration error: --qd_curiosity_gamma is required with, and "
scripts/run_backend.py:1415:            "only valid for, search_mode=revolution_qd_natural."
scripts/run_backend.py:1421:        and args.search_mode in {"revolution_qd", "revolution_qd_natural"}
scripts/run_backend.py:1425:            f"Configuration error: search_mode={args.search_mode} does not support "

exec
/bin/bash -lc "git diff 6fa46cfc77..HEAD -- tests/scripts/test_run_backend.py scripts/run_backend.py | sed -n '1,260p'" in /workspace
 succeeded in 1098ms:
diff --git a/scripts/run_backend.py b/scripts/run_backend.py
index 053ba26e06..10f08e29d4 100644
--- a/scripts/run_backend.py
+++ b/scripts/run_backend.py
@@ -484,7 +484,11 @@ def _build_backend(
             qd_champion_lane_fraction=args.qd_champion_lane_fraction,
             qd_front_slot_lane_fraction=args.qd_front_slot_lane_fraction,
             qd_parent_selection=args.qd_parent_selection,
-            qd_curiosity_gamma=args.qd_curiosity_gamma,
+            qd_curiosity_gamma=(
+                args.qd_curiosity_gamma
+                if args.qd_curiosity_gamma is not None
+                else 1.0
+            ),
             qd_memory_classic_fraction=args.qd_memory_classic_fraction,
             qd_memory_refine_fraction=args.qd_memory_refine_fraction,
             qd_memory_rescue_fraction=args.qd_memory_rescue_fraction,
@@ -1127,10 +1131,10 @@ def _build_parser() -> tuple[argparse.ArgumentParser, argparse.ArgumentParser]:
     parser.add_argument(
         "--qd_curiosity_gamma",
         type=float,
-        default=1.0,
+        default=None,
         help=(
-            "Inverse-cell-occupancy draw exponent for "
-            "search_mode=revolution_qd_natural (lane N02)."
+            "Inverse-cell-occupancy draw exponent; required with (and only "
+            "valid for) search_mode=revolution_qd_natural (lane N02)."
         ),
     )
     parser.add_argument("--qd_parent_selection", type=str, default="cell_crowded_tournament",
@@ -1402,6 +1406,16 @@ def main(argv: list[str] | None = None) -> int:
         print(f"Configuration error: {exc}")
         return 2
 
+    if args.backend == "revolution" and (
+        (args.search_mode == "revolution_qd_natural")
+        != (args.qd_curiosity_gamma is not None)
+    ):
+        print(
+            "Configuration error: --qd_curiosity_gamma is required with, and "
+            "only valid for, search_mode=revolution_qd_natural."
+        )
+        return 2
+
     if (
         args.backend == "revolution"
         and args.search_mode in {"revolution_qd", "revolution_qd_natural"}

codex
**Verdict: PASS_WITH_ACTIONS**

**Findings**

1. N06 registration design is mostly sound, but the probe gate is not satisfied. The methodology requires sampled extraction, archive mechanics, and collapse checks before spend ([methodology.md](/workspace/docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N06_descriptor_bakeoff/methodology.md:41)). The committed probe JSONs only show profile requirements/axis metadata, not sample values, occupied cells, or collapse results ([probe_journal_graph_testability_3d.json](/workspace/docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N06_descriptor_bakeoff/probes/probe_journal_graph_testability_3d.json:1)). History then records N06 live launch after these metadata probes ([history](/workspace/docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/natural_qd_push_implementation_history.md:334)). Treat N06 results as gated/quarantined until a real probe artifact exists.

2. N05 “config-pinned validations pass” is weaker than the contract. The plan requires operator, representation, evaluation flow, budgets, and related config parity ([plan](/workspace/docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/natural_qd_push_plan.md:211), [plan](/workspace/docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/natural_qd_push_plan.md:221)). N05 validation only pins warmup, cell mode, max elites, and seed ([run_validation_warmup_16.json](/workspace/docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/package/tables/run_validation_warmup_16.json:7)). Re-run/package N05 validation with the same full pin set used by P0/N01.

3. N05 retirement is misframed. The final-HV table supports “both warmup deviations trail V2” ([results_report.md](/workspace/docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/results_report.md:17)), but `warmup_16` is still +16.5% HV and +14.8% HV-AUC vs classic, with 8/8 coverage; its HV-AUC is only -0.99% vs V2 from the package CSVs. Saying “no path to the promotion bar” ([results_report.md](/workspace/docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/results_report.md:21)) conflicts with the plan’s classic-based promotion gate ([plan](/workspace/docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/natural_qd_push_plan.md:200)). Either retire it explicitly as “no V2 improvement” or run seeds 1002/1003 before closing it as a candidate.

4. N01 arithmetic checks out, but the ladder wording overclaims for one seed. I recomputed the means: classic 0.1406448, scalar 0.1468299, slot-2 0.1570882, V2 0.1737638, matching the report ([aggregate_backend_metrics.csv](/workspace/docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N01_cell_retention_mode/package/pareto_analysis/aggregate_backend_metrics.csv:2)). But V2 beats classic on only 3/8 problems, and the slot-2 to V2 gain is mainly traffic_light/alu. So “cleanest mechanism-attribution ladder” and “carries most of the margin” ([results_report.md](/workspace/docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N01_cell_retention_mode/results_report.md:20)) should be softened to “single-seed diagnostic signal.”

5. `validate_natural_qd_run.py` has one simplicity/rigor issue: it reads only the first `*_revolution_config.yaml` found ([validate_natural_qd_run.py](/workspace/scripts/validate_natural_qd_run.py:63)). Assert exactly one config, or validate every config found. The reporter and `qd_natural/engine.py` are small and readable; no blocking simplicity issues there.

**Action List**

1. Add real N06 probe artifacts: sampled descriptor extraction, PPA-free proof, axis values, collapse counts, occupied cells, and pass/fail per profile before using N06 live results.

2. Repackage N05 run validations with full expected config pins.

3. Revise N05 retirement language, or replicate `warmup_16` to 3 seeds if treating it under the classic promotion gate.

4. Soften N01 retention-ladder claims to single-seed attribution only; no narrative claim before replication.

5. Tighten `validate_natural_qd_run.py` config discovery to assert one resolved config or check all resolved configs.
tokens used
141,017
**Verdict: PASS_WITH_ACTIONS**

**Findings**

1. N06 registration design is mostly sound, but the probe gate is not satisfied. The methodology requires sampled extraction, archive mechanics, and collapse checks before spend ([methodology.md](/workspace/docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N06_descriptor_bakeoff/methodology.md:41)). The committed probe JSONs only show profile requirements/axis metadata, not sample values, occupied cells, or collapse results ([probe_journal_graph_testability_3d.json](/workspace/docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N06_descriptor_bakeoff/probes/probe_journal_graph_testability_3d.json:1)). History then records N06 live launch after these metadata probes ([history](/workspace/docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/natural_qd_push_implementation_history.md:334)). Treat N06 results as gated/quarantined until a real probe artifact exists.

2. N05 “config-pinned validations pass” is weaker than the contract. The plan requires operator, representation, evaluation flow, budgets, and related config parity ([plan](/workspace/docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/natural_qd_push_plan.md:211), [plan](/workspace/docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/natural_qd_push_plan.md:221)). N05 validation only pins warmup, cell mode, max elites, and seed ([run_validation_warmup_16.json](/workspace/docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/package/tables/run_validation_warmup_16.json:7)). Re-run/package N05 validation with the same full pin set used by P0/N01.

3. N05 retirement is misframed. The final-HV table supports “both warmup deviations trail V2” ([results_report.md](/workspace/docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/results_report.md:17)), but `warmup_16` is still +16.5% HV and +14.8% HV-AUC vs classic, with 8/8 coverage; its HV-AUC is only -0.99% vs V2 from the package CSVs. Saying “no path to the promotion bar” ([results_report.md](/workspace/docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N05_warmup_init/results_report.md:21)) conflicts with the plan’s classic-based promotion gate ([plan](/workspace/docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/natural_qd_push_plan.md:200)). Either retire it explicitly as “no V2 improvement” or run seeds 1002/1003 before closing it as a candidate.

4. N01 arithmetic checks out, but the ladder wording overclaims for one seed. I recomputed the means: classic 0.1406448, scalar 0.1468299, slot-2 0.1570882, V2 0.1737638, matching the report ([aggregate_backend_metrics.csv](/workspace/docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N01_cell_retention_mode/package/pareto_analysis/aggregate_backend_metrics.csv:2)). But V2 beats classic on only 3/8 problems, and the slot-2 to V2 gain is mainly traffic_light/alu. So “cleanest mechanism-attribution ladder” and “carries most of the margin” ([results_report.md](/workspace/docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N01_cell_retention_mode/results_report.md:20)) should be softened to “single-seed diagnostic signal.”

5. `validate_natural_qd_run.py` has one simplicity/rigor issue: it reads only the first `*_revolution_config.yaml` found ([validate_natural_qd_run.py](/workspace/scripts/validate_natural_qd_run.py:63)). Assert exactly one config, or validate every config found. The reporter and `qd_natural/engine.py` are small and readable; no blocking simplicity issues there.

**Action List**

1. Add real N06 probe artifacts: sampled descriptor extraction, PPA-free proof, axis values, collapse counts, occupied cells, and pass/fail per profile before using N06 live results.

2. Repackage N05 run validations with full expected config pins.

3. Revise N05 retirement language, or replicate `warmup_16` to 3 seeds if treating it under the classic promotion gate.

4. Soften N01 retention-ladder claims to single-seed attribution only; no narrative claim before replication.

5. Tighten `validate_natural_qd_run.py` config discovery to assert one resolved config or check all resolved configs.
