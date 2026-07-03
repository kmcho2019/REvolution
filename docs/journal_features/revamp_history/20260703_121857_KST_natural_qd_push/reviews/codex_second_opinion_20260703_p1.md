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

