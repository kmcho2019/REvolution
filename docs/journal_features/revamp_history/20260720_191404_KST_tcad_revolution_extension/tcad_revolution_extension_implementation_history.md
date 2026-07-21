# REvolution TCAD Extension Program History

Record program-level decisions, candidate state transitions, baseline hashes,
final-suite freezes, integration choices, paper-claim changes, and blockers.
Candidate-specific commands and results belong in each candidate history.

## Session start

- Branch: `feat/journal-workshop-exp-20260720`.
- HEAD at launch: `9104aff2cdb6d5dff9ef75044b92a03b653d21b9`.
- Dirty state at launch: clean tracked tree; five pre-existing untracked paths
  remain outside this goal: `.devcontainer/devcontainer-lock.json`,
  `codex_latest_thread_20260709_1536.txt`, `docs/feature_history/new_bundle/`,
  `20260703_121857_KST_natural_qd_push/20260707_2005_code_logs.md`, and
  `20260703_121857_KST_natural_qd_push/suite_variant_campaign/suite_campagin_initial_message.md`.
- Toolchain: project Python 3.11.15 through `uv` 0.11.23; host Python 3.10.12;
  Icarus 12.0; Yosys 0.54+29 (`7b0c1fe49`); OpenROAD
  `v2.0-22560-gb571c4b471`; Verilator 5.030; ruff 0.12.7; ty 0.0.61;
  pyright 1.1.403.
- Model/API configuration hash: historical seed-1001 configuration SHA-256
  `a738ae9784137aaf6c02f29bfaa947e212f2eb348116e0d5ccec3e26b5e509ce`;
  `openai/gpt-oss-120b` at `20.0.0.103:8000`, 131072 context, was reachable on
  2026-07-20. `localhost:8888` was not reachable.
- Baseline artifact root:
  `exp/useful_bd_push/pcn_v3_experiments_20260701/live/rtllm_full_5seed/classic_revolution_8x5`;
  all 250 problem-seed summaries are present.
- Development manifest hash: `PENDING`; no new program role is frozen.
- Holdout manifest hash: legacy `data/configs/holdout_reference_subset.yaml`
  SHA-256 `4c3cab68f5cb58a7e85c0c17204cb57a72f462138dbb3e4f271fe97620f69812`;
  eligibility remains under contamination audit.
- Final manifest hash: legacy `data/configs/journal_seed_manifest.yaml` SHA-256
  `3f319e325d0fe8578ed54c565ad8f90affdd51935b06411cdd77e796a99e0629`;
  seeds 1001-1005 are prior-exposed and cannot be the new program's
  development-disjoint confirmation role.

## Decision log

| Date | Decision | Evidence | Consequence |
| --- | --- | --- | --- |
| 2026-07-20 | Import the supplied program bundle as `PROPOSED`, flatten its program files to the goal root, and do not activate it yet. | Source ZIP SHA-256 `88a931485fa38f90cee7a4e804950a594c43c2900907067794191ab87e4f3d09`; `intake_review.md`. | Candidate ideas remain unchanged pending claims, novelty, and gate review. |
| 2026-07-20 | Reframe the scaffold as an audit-driven, bounded discovery program rather than a fixed H1-H4 execution queue. | Owner direction; completed QD/Pareto negative map; revised plan and draft claims contract. | The program now distinguishes PAPER_CANDIDATE, VIABLE, RETIRED, and BLOCKED candidates; uses sequential waves; and finishes JOURNAL_READY, PORTFOLIO_READY, or PIVOT_REQUIRED. Live experiments remain on hold pending contract acceptance and baseline freeze. |
| 2026-07-20 | Complete the first internal conference-method audit and related-work collision pass. | Conference paper at `6d81985f`; classic code at `9104aff2`; completed QD, F41, single-thought, PCN, and no-C-F evidence; six primary related-work papers. | H1-H4 remain `PROPOSED` but are not promotable as written. The audit prioritizes missing component evidence and one possible stage-aware failure correction; no live treatment is authorized. |
| 2026-07-20 | Accept and verify the required findings from an external conference-audit review. | First 600-second attempt timed out; bounded retry returned `WARN`. Review and dispositions are in `reviews/20260720_claude_conference_audit.md`. Git history shows both major paper/code divergences predate the initial submission. | Narrow the whole-loop support claim, document verification and survivor mismatches, pin related-work evidence, calibrate negative-map wording, and keep all candidates `PROPOSED` pending re-review. |
| 2026-07-20 | Close the conference-method audit gate after external `PASS`. | Re-review verified all required corrections, optional precision fixes, cited local numbers, and candidate holds. It identified no blocking issue. | Mark `conference_method_audit.md` `REVIEWED`; keep baseline/statistics gates open and all candidates `PROPOSED`. Describe the conference baseline as offspring-count-matched because initialization and feedback calls were not matched. |
| 2026-07-20 | Freeze the classic baseline, statistical protocol, benchmark roles, holdout, and resource ceilings before treatment evidence. | Canonical five-seed reports reproduce fixed-denominator classic HV `0.103802` and HV-AUC `0.086982`; three synthesis/PPA replays agree exactly; the representative ranking is classic-only; the CVDP holdout excludes 58 prior outcome or manifest-exposed tasks. External methodology closure returned `PASS`. | Activate candidate ranking. Raw area/power/period remain non-imputed secondary evidence; confirmation uses fresh seeds 61001-61005; the holdout is described only as repository-evidence-disjoint functionality evidence. |
| 2026-07-20 | Regenerate classic operator telemetry and the canonical five-seed no-C-F comparison before proposing new operator mechanisms. | `component_evidence_audit.md`; 500 problem-seed logs, 24,000 candidates, fixed-denominator HV/AUC, clustered intervals, and resource totals. | Treat per-operator rates as descriptive. Advance H5 M-F-only failed-pool routing to review; retain no-C-F as retrospective support and uniform allocation only as a deferred diagnostic. |

## Component Evidence And Candidate Ranking

- Reporting commit: `b93d1d02d1ceaa6da35158ffe117f089c21bc592`.
- Policy-trajectory reporting commit:
  `7106c4dfb2b120a81bf0386005f952a1072a9162`.
- Classic and no-C-F each contribute 250 complete generation logs and 12,000
  candidate records. The reporting tool preserves exact failure statuses and
  does not infer causal operator effects from adaptive logs.
- M-F has the highest descriptive failed-parent functionality and valid-PPA
  rates. H5 tests this observation through one static operator-role constraint;
  it adds no prompt, reward, stage score, gate, or fallback.
- Classic UCB assigns M-F 20.3% of 3,966 failed-parent requests and does not
  sustain its generation-2 share increase. Mean policy distance from uniform
  falls from 17.6% in generation 1 to 7.1% in generation 5. The proposed static
  role constraint is therefore not already implemented by classic adaptation.
- Canonical no-C-F deltas are final HV `+0.003044`, HV-AUC `+0.007747`, valid PPA
  `+2/230`, and functionality `+3/230`. Final-HV direction is mixed by seed and
  the clustered interval crosses zero. Because current roles and gates postdate
  these outcomes, this is historical support rather than a candidate result.
- Internal architecture review found that H5 can subclass `EoHEngine`, narrow
  `fail_strats` and its statistics map, and inherit the complete classic
  generation loop. A generic classic fail-operator option and a copied
  generation method are both rejected.
- `candidate_ranking.md` provisionally selects H5 alone for Wave 1. H7 is a
  deferred allocation diagnostic. H5 remains `PROPOSED` until novelty and
  EDA-methodology reviews close; no live run is authorized by this draft.
- Independent statistics review found a problem-clustered M-F functional-yield
  association of `+0.0643`, CI `[+0.0179, +0.1199]`, while valid-PPA yield is
  unresolved at `+0.0270`, CI `[-0.0126, +0.0781]`. It rejected the original
  outcome-disjunctive H5 gate and retrospective H6 `VIABLE` label. H5 now uses
  per-seed valid-PPA coverage as its sole development benefit and treats repair
  yield as mechanism telemetry.
- External candidate-ranking review returned `FAIL` on the draft because the
  conference audit retained stale no-C-F numbers, H6 had a retroactive
  `VIABLE` label, H7 occupied a wave despite zero hardware grounding, H1-H3/H8
  state files drifted, and the UCB trajectory had not been checked. All findings
  were accepted; closure review remains required before H5 becomes `READY`.
- The 600-second external closure re-read every disposition, returned package
  `PASS`, and independently rated H5 novelty/naturalness `ACCEPT`. It found no
  blocking COEVO collision, post-hoc gate, claim inconsistency, or isolation
  flaw at design time. The reviewer retained a 1/2 novelty warning and required
  the separate hardware/EDA and post-diff reviews.
- Hardware/EDA review initially deferred H5 because all EoH operators receive
  feedback, M-I also targets correctness, conditional yield was confounded,
  stage/pool telemetry was incomplete, and descendant HV credit was ambiguous.
  The card now tests exact M-F-only routing, gates on unconditional direct
  valid-PPA repairs per fixed budget, freezes exhaustive lineage/stage/pool
  fields, and removes descendant credit. Focused closure returned `ACCEPT`.
- H5 reached `READY` at 11/14 as the sole Wave-1 mechanism. No H5 treatment code
  or result existed at this transition; implementation isolation and telemetry
  conformance remain open code gates.

## Scaffold Revision Review

- Reviewer: external Claude Code 2.1.215, read-only plan mode, high effort.
- Scope: complete scaffold diff and current directory; no implementation files.
- Verdict: `WARN`; no `FAIL`-level contradiction.
- Accepted findings: require full-suite evidence for `VIABLE`; preregister
  development-disjoint confirmation seeds and the statistical method; audit
  holdout eligibility; reconcile program resource ceilings; confront retired
  single-thought evidence; align W/L/T, state, and H4 terminology.
- Accepted cleanup: make the shared candidate contract canonical and shorten the
  four repeated candidate goal templates.
- Deferred observation: root plan, TODO, and launch template necessarily repeat
  a small amount of workflow because they serve charter, tracking, and launch
  roles. Cross-document consistency is checked before activation.
- Follow-up review: external Claude Code 2.1.215 re-read the revised scaffold and
  returned `PASS` with every prior required finding resolved. Its remaining
  non-blocking observations were to expose practical margins/metric floors
  directly in the manifest, which was accepted, and to migrate H1-H4 into the
  canonical hypothesis template before `READY`, which is already enforced by
  the candidate contract because those files remain `PROPOSED` seed sketches.
- Activation decision: the owner approved the revised workflow and directed the
  root goal to launch on a dedicated branch. `program_claims_contract.md`
  revision 1 now governs discovery and candidate evidence. The goal may perform
  the audit and baseline setup immediately; live candidate experiments remain
  blocked until the intake pre-live gates are frozen.

## Baseline Freeze

- Claims contract revision 2 SHA-256:
  `8d0cb721981fa2805b0e44e46490371ff8eb70794d08d742a46c11a9976bde9b`.
- Baseline contract revision 2 SHA-256:
  `805d24a5352f06c5573c4f405bead3026315d561fb69901cb6a9b61911370aea`.
- Program manifest revision 2 SHA-256:
  `95d6ad5019e8cdd73cb064675556066ee35a35ef2204edbc71e74bf6593534d7`.
- Holdout eligibility audit SHA-256:
  `85606bddaf2ac34f345bd2efa7f69934fef7dc104a0a8b94e465e2b67990f789`.
- External baseline review SHA-256:
  `edc3dbef699a72c389399361501bfac8a94e1664036b4c6c55aa2d7cfae1af64`.
- Canonical generated reports:
  `exp/tcad_revolution_extension/baseline_20260720/historical_classic_5seed`.
- Synthesis/PPA replay artifacts:
  `exp/tcad_revolution_extension/baseline_20260720/synthesis_determinism`.
- Review trail: two broad external attempts produced no evidence after timeout;
  the constrained initial review returned `FAIL`, all findings were accepted,
  and the focused closure review returned `PASS`.
- No candidate implementation or treatment result existed at freeze time.

## Pre-Implementation Contract Clarification

Independent candidate reviews found terminology and scope ambiguities before
any H5 treatment was implemented or run. Revision 3 changes no numeric gate:
it names RTL-simulation functionality accurately, limits the saturated
representative stage to activation/regression evidence, permits smoke and
holdout seed roles in candidate manifests, marks CVDP as non-reference-PPA, and
states that the per-candidate ceiling covers discovery rather than confirmation
or holdout.

- Claims contract revision 3 SHA-256:
  `74f2fea3ac839ba1b8395923e8b037e77109d3ae94005809f53a35d9e3ab0d1e`.
- Baseline contract revision 3 SHA-256:
  `f580c1cf91666dfbdaeb8c15de6d0116107b195407bcdd772c3643b48ca0f105`.
- Program manifest revision 3 SHA-256:
  `ce9434b86c0b6a58fa5cc59616378865001a8c611c214c0ea8b001440f151e84`.
- Experiment manifest template SHA-256:
  `c1caefe86b5f2ff042959dcbb06fbc51305f410b7a0a91c5e60e2a5b11475b40`.

## H5 Implementation And Pre-Smoke Freeze

- H5 implementation commit:
  `59acb11def38d12466cca425c6828bba25f98dc8`.
- The implementation adds one fixed experimental search mode and one isolated
  subclass. It narrows failed-pool operators to M-F and inherits classic
  success evolution, evaluation, selection, and survivor behavior.
- Classic algorithm SHA-256 remains
  `78ebc901be4197f7d10a27097328a5f54a1fa60aeb72a999ad6dc3b661236655`;
  default configuration SHA-256 remains
  `cd44c8de823b9843339718cd8116d325f35a11188b38103553dcc2cbc8c0a34b`.
- Validation closed with 76 focused tests, 1,073 broader tests, 4 skips, one
  separately recorded legacy hanging report-test deselection, Ruff, Pyright,
  focused `ty`, diff checks, and independent code and telemetry reviews.
- Program manifest revision 4 records only that historical classic artifacts
  are context and margin evidence, not admissible H5 mechanism controls. It
  changes no metric, seed, benchmark, budget, or outcome gate. SHA-256:
  `1ace858fdaf2bc3a9468526a48293d674afac7badaa726592d3a72a0b624be34`.
- Frozen smoke config SHA-256:
  `20c8b3daf931b0b322568af61c9fa8a4ff85ab5da5fdcf56568cc8471702d490`.
- Frozen smoke manifest SHA-256:
  `b663c89673bd3b8a336d3ef36253a7774f11550bc9421a374994dc2446792fb9`.
- No H5 live result existed when these code and smoke gates froze.

## H5 Technical Smoke

- Frozen raw root:
  `exp/tcad_revolution_extension/h5_failed_parent_repair/wave1/smoke_seed42`.
- Fresh sequential classic and H5 runs completed all three frozen problems at
  seed 42 with exact 16-candidate problem budgets and no stopped generation or
  infrastructure failure.
- Saved configs differ only by search mode and artifact root. Classic used all
  five failed operators; every H5 failed-parent request used M-F; success-side
  operators remained classic.
- The strict mechanism report and an independent replay accepted all lineage,
  stages, PPA artifacts, and pool transitions. Independent smoke audit session
  `019f80e8-a363-7af3-81bd-43094e71a965` returned `PASS`.
- Observed direct valid-PPA repairs were 1 classic and 4 H5. The normalized
  delta `+0.0625` is recorded only as smoke telemetry and does not promote H5.
- H5 advances from `IMPLEMENTED` to `SMOKE_VALIDATED`. The representative
  probe may be frozen next; no full-suite or paper claim is authorized.

## H5 Representative Preregistration

- Froze the baseline-selected eight-problem manifest, development seeds 1001
  and 1002, 8-by-5 candidate budget, matched sequential arms, exact mechanism
  report, canonical PPA/HV/HV-AUC reports, and clustered paired statistics.
- Shared config SHA-256:
  `b3c85757e2d18b3fa94d00f8decfd44c6468fdc0139a2bd93bced3b7c8997169`.
- Representative manifest SHA-256:
  `0dcbc2f1012a06d5aac3f0ed64abbdfecc87ee902b174fcd096128af3fe0266f`.
- A preregistration audit initially rejected the generic two-seed statistics
  command because it omitted HV-AUC, the H5 repair endpoint, zero-PPA units,
  and resource-ceiling validation. The accepted correction adds one isolated,
  tested H5 probe validator and a directly checkable prompt checksum manifest.
- A first closure review caught treatment-dependent normalized-PPA imputation.
  The final implementation uses only locked classic scores, adds a distinguishing
  regression test, and received preregistration `PASS`.
- This saturated representative set is diagnostic. Performance cannot promote
  or retire H5; only invalid mechanism, budget, code, or infrastructure can
  stop it before the frozen two-seed full suite.
- No representative treatment output existed at preregistration.

## H5 Representative Evidence And Reporting Closure

- Fresh matched classic and H5 runs completed all eight frozen representative
  tasks at development seeds 1001 and 1002 with exact 48-candidate budgets.
- H5-minus-classic mean deltas were unconditional repair rate `+0.0052083`,
  final HV `-0.0014420`, HV-AUC `+0.0076497`, valid-PPA sample yield
  `+0.0299479`, and best normalized PPA `-0.0115159`. RTL-simulation
  functionality and valid-PPA coverage tied at `16/16`.
- Repair-rate direction was positive in both seeds. Final-HV and HV-AUC seed
  directions were mixed. The representative stage remains diagnostic and did
  not classify H5.
- A reporting-only closure added per-seed, sensitivity, resource, missing-unit,
  and pool-trajectory evidence. It registered the undefined
  calls-to-first-improvement metric as a non-gating protocol deviation rather
  than introducing a post-hoc definition.
- Independent audit session `019f8152-17e0-72c1-89a9-40eeb2a1868e` initially
  rejected incomplete reporting and missing-unit paths. After focused fixes,
  14 tests, Ruff, Pyright, and `ty` passed and the reviewer returned `PASS`.
  No live arm was rerun.

## H5 Full-Suite Development Freeze

- Froze a 50-task full run with the locked 46 reference-complete PPA headline,
  fresh sequential classic controls, seeds 1001 and 1002, and the unchanged
  8-by-5 candidate budget.
- The benefit endpoint is the all-50 unconditional fail-origin valid-PPA repair
  rate and must be positive in each seed. Final HV, HV-AUC, 46-task valid-PPA
  coverage, and RTL-simulation functionality use only the pre-existing frozen
  margins.
- Missing H5 units are explicit zero-valued method failures, reduce treatment
  candidate totals, and force `RETIRED`. Resource parity uses total calls,
  tokens, and arm wall time. The stage cannot return `PAPER_CANDIDATE`.
- Full manifest SHA-256:
  `10cdf1eedbb560c6b36b5b7197490d2fe7f0bd5f48510c2b330574f575e9da9e`.
- No full-suite arm had launched at freeze time. The first broad external
  review timed out without evidence; a focused 600-second retry verified all
  pins, scopes, failure paths, and gates and returned `PASS`. Full-suite launch
  is authorized after committing and rechecking the frozen tree.

## H5 Full-Suite Evidence

- Four fresh sequential arms completed all 50 RTLLM tasks at seeds 1001 and
  1002. Each arm emitted exactly 2,400 candidates; all 200 arm units completed
  with no missing unit, exclusion, or rerun.
- H5 direct valid-PPA repairs improved 36 to 41 and 37 to 40. Pooled deltas were
  repair rate +0.001667, final HV46 +0.006678, HV-AUC46 +0.004498, valid-PPA
  coverage -0.010870, and RTL functionality50 -0.010000. All reported
  confidence intervals included zero.
- Exact operator telemetry passed: all 1,561 H5 failed-parent requests used M-F,
  classic used all five failed EoH operators, and both arms retained classic
  successful-parent operators.
- The frozen reporter emitted `VIABLE` after netting signed coverage deficits
  across seeds. The generated package is preserved under
  `candidates/H5_role_aligned_failed_repair/full_suite_probe`.

## H5 Contract Audit And Wave-1 Closure

- A post-run independent evidence audit found that the reporter implemented an
  aggregate coverage rule inconsistent with the accepted per-seed contract.
  Seed 1001 valid-PPA coverage fell from 34/46 to 32/46, exceeding the frozen
  one-problem margin. Seed 1002's one-problem gain cannot offset that failure.
- A second internal reviewer corrected its initial reporter-level `VIABLE`
  reading after contract arbitration. A focused read-only `claude -p` audit
  independently confirmed the same precedence and `FAIL / RETIRED` verdict.
- Cumulative H5 discovery spend was 11,232 candidates, 22,466 calls,
  69,289,552 tokens, 6,056 synthesis evaluations, and 6.231970 endpoint-arm
  hours. These exceed every frozen per-candidate ceiling because the preregistered
  ladder failed to count all mandatory matched control arms.
- The within-full-suite comparison remains mechanically matched, but H5 cannot
  receive a contract-compliant promotion. Its governing outcome is `RETIRED`;
  no revision, confirmation, holdout, combination, or integration is authorized.
- Mechanism interpretation is narrow: the repair increase is concentrated and
  primarily syntax-stage. Most PPA uplift comes from `Prob036_edge_detect`,
  which made no failed-parent request in either arm or seed, so repair routing
  does not causally explain the observed HV direction.
- Wave 1 closes without a finalist. Before Wave 2 live spend, freeze a
  prospective methodology addendum that reconciles every stage and fresh
  control with the existing per-candidate ceilings. Do not reopen H5 as an
  operator ratio, mixture, no-C-F interaction, or nearby prompt variant.

## Wave 2 Methodology Freeze

- Claims-contract revision 4 and program-manifest version 5 froze
  prospectively before any Wave-2 candidate treatment. Wave 1 and H5 remain
  governed by revision 3 and manifest version 4.
- The Wave-2 ladder is exactly one fresh three-design smoke pair followed by
  fresh classic/treatment full-suite pairs at seeds 1001 and 1002. The weakly
  transferring representative probe is omitted prospectively rather than
  relabeled or used as evidence.
- Pair-equal arm envelopes total 9,696 candidates, 20,600 calls, 65,406,676
  tokens, 5,714 synthesis starts, and 20,542 endpoint-arm seconds. Raw H5
  resource evidence and smoke generation logs reproduce every cap.
- The program remainder subtracts H5's audited 11,232 candidates, 22,466 calls,
  69,289,552 tokens, 6,056 synthesis starts, and 22,435.092 seconds before any
  Wave-2 admission.
- One locked append-only ledger enforces the exact six-arm order, one active
  candidate, cumulative candidate/wave/program projections, the fixed 21-day
  UTC window, exact decimal wall accounting, timeout retirement, and unique
  arm-bound accounting/evidence artifacts.
- Shared coverage logic requires both development seeds, evaluates the
  one-design margin independently per seed and surface, and sums catastrophic
  losses without offsetting gains.
- Internal methodology session
  `019f82d3-76f5-7b41-ba68-e45c314004f8` and code session
  `019f830b-339c-7743-bfab-0b4cc9da2054` each rejected earlier drafts, then
  returned `PASS` after serialization, parser, timeout, and lock fixes. A final
  600-second read-only Claude closure review independently returned `PASS`.
- Validation passed 37 focused tests, Ruff, Pyright, `ty`, YAML parsing, all 13
  manifest hash checks, and byte-identical smoke/edit-premise reproductions.
  An undeselected repository test attempt stalled in the previously documented
  backend-comparison report test; a 300-second deselected attempt reached about
  70 percent while still progressing and timed out. No model-backed run was
  launched.
- Admission implementation commit:
  `d3b0ebd3ac3c6162357a450320d8a5f5a85c94c5`.
- Claims-contract revision 4 SHA-256:
  `38799411baad7673005a229f14e610feb39bf63dbb55010a18b7a90c9e2b0d8f`.
- Wave-2 methodology SHA-256:
  `7152a84e764b1e7ad50a4f4622d747344b2e99e4e9c2d8f465d0267f84ef5e7d`.
- Program-manifest version 5 SHA-256:
  `980135a9e5890804277ef18758a8f05253e93315983832ba120d8f38cf62cfdc`.

## H9 Proposal Review And Retirement

- H9 opened Wave 2 by isolating a single proposed change: replace every
  post-initialization whole-output EoH request with the existing strict-diff
  protocol. No source, config, worksheet, admission event, model call, or
  synthesis run was created.
- Independent novelty review returned `BLOCK`. AlphaEvolve already applies
  generated deltas to parent programs inside evolutionary search and includes
  Verilog optimization; CodeEvolve explicitly supports diff evolution and
  full-code rewrite. H9 therefore scored `0` for novelty and `9/14` overall.
- Independent methodology review returned `BLOCK`. It found that compact C-F
  context omits the second parent, strict application still accepts an
  empty-search append, and no terminal reporter or six-arm worksheet existed.
- A read-only audit of all 4,000 post-Gen0 classic offspring showed that H9's
  frozen premise did not generalize across parent roles. The 1,900
  success-origin one-parent rows retained rho `-0.250869`, while 1,658
  fail-origin rows reversed to rho `+0.060274`; successful failed-parent repairs
  were broader on average than unsuccessful repairs.
- The 600-second external `claude -p` review returned no substantive output and
  is recorded as unavailable, not agreement.
- H9 is `RETIRED` before live spend. Global diff ablations and patch-policy
  variants are closed. A role-conditioned scope policy would be a distinct
  candidate requiring its own novelty and clean-isolation review.
