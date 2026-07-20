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
