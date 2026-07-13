# Pareto REvolution TCAD Validation Implementation History

Unbounded journal for `pareto_revolution_validation`. Record notable
decisions, commands, outputs, experiments, failures, blockers, commits, and
validation evidence. Do not rewrite earlier entries when conclusions change.

## 2026-07-10 - Scaffold Draft

- Branch: `feat/journal-qd-bd-exp-20260703`.
- Starting HEAD: `eb3e918d9726a07a4497fc1b46831c8c1b4552dd`.
- Goal directory:
  `docs/feature_history/20260710_222442_KST_pareto_revolution_validation/`.
- Read the repository guidelines, journal onboarding sources, current
  natural-QD goal and closure history, senior-advisor bundle, current engine
  selection code, ranking primitives, runner wiring, validators, and locked
  manifests.
- Generated the six standard goal-scaffold files with the local
  `goal-scaffold` helper, then replaced the generic drafts with this
  repository-specific contract.
- Registered one method rather than a portfolio: global Pareto parent and
  survivor selection on the classic REvolution substrate, with a post-hoc
  reporting-only Pareto front.
- Preserved EoH operators and explicitly forbade the failed single-thought
  path, QD descriptors/cells, and further capacity or warmup scans.
- Defined completion as a primary positive, supporting result, or negative
  closure. This prevents an open-ended search from treating failure as a
  reason to mutate the goal.
- Added a held-out requirement for any paper-facing positive. Full RTLLM is
  the direct screening surface because it has already been heavily observed.
- No goal was activated and no benchmark process was launched.
- A bounded read-only `claude -p` audit of the draft scaffold timed out with
  exit code 124 and no output. It is not counted as a verdict. The mandatory
  pre-launch addendum review remains open.
- Manual consistency review found that S07 seed 1001 reports `33/46` classic
  successful-candidate coverage while S32 reports `24/46` for the same classic
  root and identical HV/HV-AUC. The plan now makes canonical coverage
  reanalysis a pre-launch gate and separates valid-PPA, functional-any-pass,
  and reference-beating coverage.

### Existing Dirty State Excluded From This Goal

- `.devcontainer/devcontainer-lock.json`
- `codex_latest_thread_20260709_1536.txt`
- `docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/20260707_2005_code_logs.md`
- `docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/suite_variant_campaign/suite_campagin_initial_message.md`

### Draft Decision Needing Review

The main arm applies standard rank/crowding to both successful-parent and
successful-survivor selection. A parent-only or survivor-only split is not
part of the initial campaign. If an advisor requires that attribution, revise
the claims addendum before activation, not after seeing live results.

## 2026-07-10 - Scaffold Validation

- Seven goal-local Markdown files are present, including all six standard
  scaffold files and the local README.
- The living TODO is 113 lines, below its 120-line limit.
- `goal_template.md` is 3355 characters and its objective body does not repeat
  the `/goal` prefix.
- The authored goal docs are ASCII and contain no generic `TODO:`, `TBD`, or
  `FIXME` placeholders.
- All required source/navigation files exist.
- SHA-256 checks passed for the accepted narrative, seed manifest, held-out
  manifest, and 46-problem RTLLM manifest recorded in the plan.
- `git diff --cached --check` passed.
- No Pareto goal, `run_backend.py`, or benchmark process is active.
- No pytest, ruff, pyright, or ty run was needed because this change contains
  planning documentation only and does not alter Python source.

## 2026-07-11 - Long-Timeout Claude Review

- Re-ran the read-only scaffold audit with `claude -p` and a 900-second bound.
- The process completed normally after about nine minutes and returned `FAIL`
  with three blocking and four optional findings.
- Preserved the complete output at
  `reviews/20260711_claude_readonly_review.md`.

### Finding Disposition

1. **Held-out overlap: accepted and strengthened.** The revision-3 holdout has
   nine RTLLM tasks inside the repeatedly observed 46-task full-suite surface.
   Keep that manifest as legacy descriptive evidence. Before implementation,
   deterministically freeze a new 20-task, prior-run-disjoint VerilogEval set
   for the candidate's paper-facing gate. This is stronger than computing
   promotion on only the 37 non-overlap RTLLM tasks because it preserves the
   full-suite development read and gives the final claim a fresh problem set.
2. **Method edge states: accepted.** Pin negative raw active PPA objectives for
   the four reference-incomplete RTLLM tasks; assert that every Success record
   has post-synthesis functionality and complete PPA; fully specify the
   survivor candidate set and failed-offspring fill order.
3. **Unregistered-arm wording: accepted.** Any unregistered evidence arm now
   causes adversarial FAIL.
4. **Prior NSGA-II mechanism mismatch: accepted.** Disclose that the earlier
   positive used truncated-pool uniform draws plus a champion lane, not this
   binary tournament. Pin without-replacement tournaments and the `C-F`
   second-winner rule.
5. **Parent+survivor approval: accepted.** Name the bundling decision in the
   pre-activation approval checklist.
6. **Method-inherent budget skew: accepted.** Persistent skew closes as
   budget-asymmetric supporting or negative evidence instead of blocking
   forever.
7. **Gate name: accepted.** Rename it five-seed full-RTLLM promotion.

- No goal or benchmark was launched while resolving the review.

## 2026-07-11 - Focused Claude Re-Review

- Ran a second 900-second read-only review against the revised worktree.
- The review confirmed all three original blockers and four optional findings
  were resolved, then returned `FAIL` on one new blocking ambiguity in the
  fresh-holdout selection rule.
- Preserved the output at
  `reviews/20260711_claude_readonly_rereview.md`.
- Accepted the blocker: the plan now pins the reference-synthesis inventory,
  proportional largest-remainder allocation, lexical ordering and tie break,
  exact per-bucket `random.Random` seed string, shuffle/take procedure, and
  freeze-time run-root audit.
- Accepted the remaining optional precision fixes: survivor crowding ties use
  the registered stable tie rule; the QD prohibition exempts historical V2
  descriptive roots; selected holdout tasks cannot be replaced after freeze.
- No goal or benchmark was launched.

## 2026-07-11 - Final Claude Activation Audit

- Ran a third 900-second read-only audit after pinning the complete holdout
  selection procedure.
- Verdict: `PASS`, with no blocking findings. The audit states that every prior
  blocker is resolved and the scaffold is ready to activate after committing
  the reviewed files.
- Preserved the output at
  `reviews/20260711_claude_final_activation_audit.md`.
- Addressed its remaining documentation suggestions: named the concrete
  exclusion sources, defined fewer than 20 eligible tasks as a blocked freeze,
  and refreshed the README review trail.
- The goal remains unactivated. The experimental sub-agent report remains
  `PENDING`; this PASS validates only the planning contract.

## 2026-07-11 - Review Revision Validation

- Review trail contains three preserved outputs with verdicts
  `FAIL -> FAIL -> PASS`.
- `goal_template.md` is 3942 characters and does not repeat the `/goal` prefix
  in its objective body.
- The living TODO is 117 lines, below its 120-line limit.
- The accepted narrative and locked manifest hashes remain unchanged.
- Authored contract documents remain ASCII; the review files preserve Claude's
  Unicode output verbatim.
- `git diff --cached --check` passed after removing extra EOF blank lines from
  the captured reviews.
- No goal, Claude, `run_backend.py`, or benchmark process remains active.
- No Python validation was needed because this revision changes planning and
  review documentation only.

## 2026-07-13 - Execution Approval And Scope Audit

- The user approved one ablation of classic weighted-sum population selection
  against descriptor-free NSGA-II parent and survivor selection. The user also
  required the classic core engine to remain intact.
- Re-read the required journal onboarding sources in order and mapped the
  request to the reviewed Pareto REvolution candidate.
- Confirmed the local endpoint at `20.0.0.103:8000` serves
  `openai/gpt-oss-120b` with `max_model_len=131072`.
- Confirmed all five registered classic and V2 comparator roots contain 50
  problem summaries and retain the frozen `8 x 5`, EoH, strict-evaluation,
  direct-code platform.
- Found that the fresh-holdout premise is infeasible: an archived conference
  root contains evaluated summaries for all 156 VerilogEval-Spec-to-RTL tasks.
  No exclusion was relaxed and no replacement holdout was invented. Claims
  addendum V1 limits this experiment to RTLLM development evidence.
- Canonically reproduced the S07/S32 shared classic seed-1001 root as 33/46
  valid-PPA coverage, 26/46 weak reference-beating coverage, and 24/46
  positive-HV coverage. The old discrepancy was an unlabeled metric switch.
- Historical classic logs do not record every retained population, so exact
  generation-level nondominated-survivor discard counts are unavailable. This
  is recorded rather than reconstructed by assumption.
- Drafted the frozen RTLLM experiment manifest, restart handoff, prelaunch
  audit, and claims addendum before implementation or live evidence.
- `src/revolution/algorithm.py` is unchanged; its activation hash is
  `78ebc901be4197f7d10a27097328a5f54a1fa60aeb72a999ad6dc3b661236655`.

## 2026-07-13 - V1 Prelaunch Review And V2 Contract

- Ran a read-only `claude -p` prelaunch review with a 900-second timeout. It
  completed after approximately ten minutes and returned `FAIL` with three
  blockers. Preserved the finding record at
  `reviews/20260713_claude_prelaunch_review.md`.
- Accepted the circuit-type blocker. The four reference-incomplete RTLLM tasks
  are also the exact four loaded as `unknown`; each reference RTL contains
  clocked state. V2 freezes all four as sequential and requires every other
  unknown type to fail.
- Accepted the smoke blocker. Replaced `Prob024_fsm`, whose proxy timing is
  zero, with `Prob025_sequence_detector` and added
  `Prob006_adder_pipe_64bit`. The three-task check now covers normalized
  two-axis, normalized three-axis, and negative-raw three-axis objectives.
- Accepted the stage blocker. The unavailable paper-facing evidence is
  plan-table Stage 6, not RTLLM seed-1002 Stage 4. The infeasible holdout is a
  completed audit finding rather than a pending prelaunch requirement.
- Accepted the unique-insertion-index tie rule, corrected the success-versus-
  failure disclosure, recorded the historical seed-1001 HV diagnostic, and
  required fresh matched classic runs because historical vLLM revision parity
  cannot be established.
- Rejected the optional suggestion to add hooks to the classic engine because
  the user explicitly requires the conference engine to remain intact. V2
  requires `src/revolution/algorithm.py` to remain byte-for-byte unchanged.
- Drafted claims addendum V2 and
  `data/configs/pareto_revolution_rtllm_ablation_v2.yaml`. No implementation or
  benchmark launched before independent V2 re-review.

## 2026-07-13 - V2 Prelaunch PASS

- Ran the independent V2 re-review with a 900-second bound. It completed after
  approximately twelve minutes and returned `PASS` with no blockers. Preserved
  the full output at `reviews/20260713_claude_v2_rereview.md`.
- The reviewer independently reproduced the four missing-reference tasks and
  their clocked RTL, all three smoke objective paths, the 156/156 holdout
  infeasibility, tie semantics, classic mechanism disclosure, fresh-comparator
  requirement, and frozen classic engine hash.
- Accepted all six optional precision findings. Addendum V3 freezes technical-
  only `8 x 5` smoke semantics, uniform run-seeded tournament draws, strict
  five-seed HV improvement for a positive label, and copied-loop provenance.
  It also refreshes the handoff. No treatment or gate-bearing metric changed
  after evidence because no implementation or benchmark exists yet.

## 2026-07-13 - Isolated Pareto Implementation

- Commit `f376236d6e` adds `revolution_pareto`, with all selection logic under
  `src/revolution/pareto_revolution/` and thin backend/CLI dispatch.
- `src/revolution/algorithm.py` remains byte-identical at SHA-256
  `78ebc901be4197f7d10a27097328a5f54a1fa60aeb72a999ad6dc3b661236655`.
- CLI validation requires dual pools, EoH strategies, the classic
  success-operator set, strict-ablation evaluation, and code individuals. The
  engine repeats the method-critical pool, operator, RTLLM, and synthesis
  assertions.
- Successful parents use one generation-level Pareto ranking and uniform
  two-contestant tournaments. `C-F` excludes its first winner from the second
  tournament. Successful survivors use rank, crowding, and insertion order;
  new failures fill any remaining population slots by the classic ordering.
- Objectives reuse `compute_ppa_gains`, `active_ppa_objectives`, and
  `ranked_front`. Reference-incomplete tasks use negative raw active PPA.
  Descriptors, cells, archives, and QD operators are absent.

### Copied-Loop Provenance

The override follows `EoHEngine.evolve_one_generation` at commit
`9702534157`, lines 3773-4145:

- classic lines 3773-3867 map to Pareto lines 48-125; fixed dual/EoH state
  removes the unreachable single-pool and single-thought branches;
- classic lines 3869-3950 map to Pareto lines 127-165; only lines 3888-3921,
  weighted successful-parent choice, become Pareto lines 139-142;
- classic lines 3952-4046 map to Pareto lines 167-221 and preserve request
  execution, evaluation, scalar reward, and UCB accounting;
- classic lines 4048-4129 become Pareto lines 223-236, replacing successful
  survivor selection while preserving pool redivision;
- classic lines 4131-4145 map to Pareto lines 238-251 and preserve generation
  logging and completion behavior.

Thus the only runtime-reachable treatment differences under the asserted
contract are successful-parent and successful-survivor selection. Scalar score
still drives feedback and UCB reward, exactly as disclosed.

### Validation

- Focused pytest: `48 passed` across the Pareto, backend, and runner tests.
- Ruff, pyright, and ty passed on the touched source and test surfaces.
- Broader `tests/revolution tests/scripts`: `1029 passed, 4 skipped, 4 failed`.
  All four failures predate and are outside this change. The fixture in
  `test_candidate_evaluator_parity.py` lacks
  `_extract_candidate_descriptor_values`, so unchanged `algorithm.py:1295`
  raises `AttributeError`. A focused rerun reproduced `3 passed, 4 failed`.
- No benchmark process was launched. Stable boundary-front truncation,
  post-hoc front reproduction, seeded classic equivalence, and the live smoke
  remain explicit open gates.

Correction: pyright and ty passed the touched source modules; they were not
run over the monkeypatched test modules. Focused pytest and ruff covered the
test surfaces. This narrows the earlier wording without changing a result.

## 2026-07-13 - Implementation Audit FAIL And Resolution

- Ran a read-only `claude -p` audit with a 900-second bound against commits
  `f376236d6e` and `3f5f3c999d`. It completed after about thirteen minutes and
  returned `FAIL`. The complete output is preserved at
  `reviews/20260713_claude_implementation_review.md`.
- The reviewer found no treatment drift, classic-core change, QD state,
  fallback behavior, provenance error, or method-level defect. It judged the
  implementation a natural controlled extension, but identified four frozen
  pre-evidence requirements that were not yet complete.

### Blocking-Finding Disposition

1. Accepted the stale parity-fixture finding. Commit `21b662441b` supplies the
   required descriptor-extraction method on two test-only `SimpleNamespace`
   fixtures. All seven strict-ablation parity cases now pass. Classic source
   remains untouched.
2. Accepted the missing-test finding. Commit `0bb3fbc51d` adds stable
   boundary-front truncation and population-cap coverage, survivor scalar
   invariance, exact seeded classic parent/survivor regression, repeatable
   generation-log Pareto reconstruction, and all four CLI rejection cases.
3. Accepted the smoke-axis finding. The same commit freezes each smoke task's
   resolved circuit type, reference availability, and `2/3/3` active-axis
   count in the isolated selection module. Runtime fails on any mismatch.
4. Accepted the command-freeze finding. `execution_commands.md` pins the code,
   hashes, preflight, shared arguments, all smoke/full problems, sequential arm
   commands, output roots, report chain, rerun posture, and mechanical gates.

Accepted one optional item because it directly strengthens the frozen CLI
contract: tests now reject the non-classic success set, accelerated evaluation,
and thought representation as well as single-thought operators. Did not adopt
the optional constructor test, extra engine state, cosmetic print parity, or
test-fixture score rewrite; none closes a registered behavioral gap and each
would add churn.

### Validation After Resolution

- Strict-ablation parity: `7 passed`.
- Focused Pareto/backend/runner/parity selection: `58 passed` before the final
  CLI parameter expansion; the targeted final pair then passed `50` tests.
- Full repository proxy, `tests/revolution tests/scripts`:
  `1039 passed, 4 skipped` in `360.52s`.
- Ruff passed all touched source/tests. Pyright and ty passed
  `src/revolution/pareto_revolution/`.
- `git diff --check` passed and the classic engine SHA-256 remains
  `78ebc901be4197f7d10a27097328a5f54a1fa60aeb72a999ad6dc3b661236655`.
- No LLM-backed benchmark has launched. Independent re-review remains required
  before the seed-42 technical smoke.

## 2026-07-13 - Implementation Re-Review PASS

- Re-ran the independent implementation audit with a 900-second bound after
  commits `21b662441b`, `0bb3fbc51d`, and `f0d56f746d`.
- It completed after about eight minutes and returned `PASS` with no blockers.
  The complete output is preserved at
  `reviews/20260713_claude_implementation_rereview.md`.
- The reviewer independently confirmed all four prior blockers resolved, the
  full 50-task ordering and commands consistent, all pins exact, classic core
  byte-identical, and no treatment or QD-state drift.
- PASS authorizes only the seed-42 technical smoke after a fresh 128k endpoint
  preflight. It approves no performance claim.

## 2026-07-13 - Seed-42 Technical Smoke

- Fresh preflight passed for `openai/gpt-oss-120b`, `max_model_len=131072`.
- Ran classic and Pareto sequentially on the three frozen problems with seed
  42, population 8, five evolution generations, whole mode, strict evaluation,
  EoH operators, and 128k token limits.
- Classic completed in `682.73s`; Pareto completed in `648.29s`. Each arm has
  three summaries, 18 generation rows, 144 evaluated candidates, and 288 LLM
  calls. Runtime configs differ only by `save_path` and `search_mode`.
- Total tokens are 946218 classic and 938212 Pareto (`-0.8461%` skew). Both
  arms have functional any-pass `3/3` and valid-PPA coverage `2/3`.
- Generated candidates contain only initial and classic EoH strategies. No
  single-thought, `M-T`, or `C-D` candidate appears.
- Pareto metadata records the frozen circuit type and objective source for all
  three problems, descriptors false, and delivered front post-hoc only.
- `Prob006_adder_pipe_64bit` produced functional candidates but no valid
  post-synthesis PPA in either arm. The live smoke therefore asserted its raw
  3-axis contract but did not evaluate raw objective values for a successful
  candidate. The unit test covers that arithmetic; no task was substituted.
- Packaged the pair under
  `exp/pareto_revolution_validation/packages/smoke_seed_42/` and preserved
  compact tracked results under `smoke_seed42/`. Metrics are technical-only;
  no promotion or performance inference was made.
