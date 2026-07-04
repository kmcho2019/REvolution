# Natural QD Push Plan

Feature slug: `natural_qd_push`
Status: run phase COMPLETE 2026-07-04 (P0-P3c, 27 operator-fair
runs); P4 synthesis in progress. Verdicts: screening-scale QD win
(V2 +12.9% HV, 3/3 seeds), suite-scale HV parity with coverage edge,
Branch-B utility 0.413 (bar 0.25), descriptor dial characterized at
both scales. See lanes/README.md and p3_full_rtllm/.
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
- Gate-before-launch (added 2026-07-04, watch c8/c9): any health- or
  evidence-gated launch requires its semantic gate ruling recorded
  BEFORE the gated run fires; automated existence checks alone do not
  satisfy a registered gate.

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
