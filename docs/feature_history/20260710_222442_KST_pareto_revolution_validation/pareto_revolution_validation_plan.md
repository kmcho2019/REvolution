# Pareto REvolution TCAD Validation Plan

Status: execution approved by the user on 2026-07-13. Claims addendum V2 passed
independent prelaunch re-review; V3 records its optional precision fixes.

Execution note: all 156 VerilogEval-Spec-to-RTL tasks have prior evaluated
outcomes in an archived conference run. The reviewed disjoint-holdout rule is
not weakened. Plan-table Stage 6 is unavailable, so this campaign cannot
produce a paper-facing primary win; see
`pareto_revolution_claims_addendum_v2.md` and
`pareto_revolution_claims_addendum_v3.md` and `prelaunch_audits.md`.

Feature slug: `pareto_revolution_validation`

## Outcome

Decisively test one evidence-derived journal candidate:

> Replace classic REvolution's scalar-weighted successful-parent and
> successful-survivor selection with global NSGA-II rank and crowding, without
> MAP-Elites descriptors or per-cell retention.

The goal finishes with exactly one of these evidence packages:

1. **Positive development evidence**: the frozen method passes the five-seed
   full-RTLLM gates against fresh matched classic REvolution.
2. **Supporting result**: the method improves a secondary surface or reaches
   parity but does not pass every full-RTLLM gate.
3. **Negative closure**: a preregistered stop or promotion gate fails; the method is
   closed without metric substitution or a follow-up knob scan.

Completing this goal resolves this candidate. It does not by itself mean that
the full TCAD extension is complete. Reference-seeded large-design
optimization is a separate possible goal after this one closes.

## Source Of Truth

Read these sources in order before implementation or experimental work:

1. `docs/journal_features/revamp_ruminations_20260612.md`
2. `docs/journal_features/journal_narrative.md`
3. `docs/journal_features/13_findings_dashboard.md`
4. `docs/journal_features/14_narrative_posture_assessment.md`
5. `docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/reviews/20260710_review_bundle/README.md`
6. This plan and its living checklist.

`journal_narrative.md` revision 3 remains the accepted historical claims
contract. Do not edit it to fit a new result. Before any evidence run, add a
versioned Pareto-REvolution claims addendum and pass an independent pre-launch
review.

Goal-local files:

- Living checklist: `pareto_revolution_validation_implementation_todo.md`
- History: `pareto_revolution_validation_implementation_history.md`
- Launch text: `goal_template.md`
- Final rubric: `pareto_revolution_validation_adversarial_prompt.md`
- Final review: `pareto_revolution_validation_subagent_validation_report.md`

## Evidence Basis

The natural-QD campaign found the following:

- Five-seed classic full RTLLM: final HV `0.103802`, HV-AUC46 `0.086982`,
  valid-PPA coverage `164/230`.
- Five-seed Smooth-QD V2: final HV `0.098801`, HV-AUC46 `0.087428`, coverage
  `166/230`.
- Five-seed S07 capacity3: final HV `0.102481`, HV-AUC46 `0.088031`, coverage
  `165/230`.
- No tested QD arm beat classic final HV at five seeds.
- Earlier 13-problem tuning ablation isolated a positive V2-versus-V1 NSGA-II
  effect, but global Pareto selection without descriptor cells has not been
  isolated on full RTLLM.

That earlier NSGA-II effect came from a rank/crowding-truncated global pool,
uniform draws, and a champion lane. It did not test the binary tournament used
here. The prior result motivates Pareto selection but does not demonstrate this
exact parent-selection rule.

The hypothesis is that global Pareto selection is useful, while descriptor
assignment and bounded per-cell survival impose an avoidable tax under a
shallow, expensive search budget.

The null is equally acceptable: global Pareto selection does not recover
classic final HV or valid-PPA coverage. A negative result closes the candidate.

One existing reporting inconsistency must be resolved before launch. S07's
seed-1001 package reports classic successful-candidate coverage as `33/46`,
while the later S32 package reports `24/46` for the same classic root and the
same HV/HV-AUC. The likely difference is successful-candidate coverage versus
reference-beating coverage. Neither value may be used as a gate until one
canonical reanalysis reproduces the definitions below.

The revision-3 `data/configs/holdout_reference_subset.yaml` is also no longer
untouched for this candidate. Nine of its RTLLM tasks are in the 46-task full
RTLLM surface and have been used repeatedly in the natural-QD campaign. Keep it
as a legacy validation manifest only. The complete VerilogEval inventory audit
found prior evaluated outcomes for all 156 tasks, so no replacement holdout is
frozen and paper-facing primary-win language is unavailable.

## Frozen Method Contract

### Preserved Conference Machinery

- Direct-code Thought/Code/Feedback individuals.
- Dual Fail and Success populations.
- Classic EoH operators only: `M-F`, `M-S`, `M-E`, `M-R`, `M-I`, and `C-F`.
- The classic UCB operator policy, prompts, feedback, model, sampling settings,
  population, generations, evaluator, and candidate-evaluation budget.
- `classic_operator_kind=eoh_strategies` and
  `eoh_success_operator_set=classic`; `single_thought_operator`, `M-T`, and
  `C-D` are forbidden.

### One Changed Mechanism

Use one discriminated search mode, provisionally `revolution_pareto`. Do not
add independent booleans or tunable rank/crowding parameters.

For every problem:

1. For a reference-complete task, convert each successful current candidate to
   maximize-form normalized PPA gains against the reference. For a
   reference-incomplete task, use negative raw active PPA metrics. Pareto rank
   and normalized crowding are invariant to positive affine per-axis scaling,
   so this is equivalent to using any fixed positive normalization and avoids
   the classic synthetic-reference magnitude affecting population selection.
2. Use active objectives `g_P,g_A` for combinational designs and
   `g_P,g_A,g_T` for sequential designs.
3. Rank the fixed current Success population once per generation. Select
   successful parents by standard binary tournament over Pareto rank ascending
   and crowding distance descending. For each tournament, sample two distinct
   contestants uniformly with `random.sample` from the run-seeded Python RNG;
   a singleton pool wins directly. Break
   exact ties by the unique insertion index in the ranked list. Candidate UUID
   is audit metadata and never decides selection. For `C-F`, run a
   second tournament after excluding the first winner. Disable `C-F` when fewer
   than two Success candidates exist, matching classic.
4. Select successful survivors by standard NSGA-II environmental selection:
   add complete fronts in rank order, then truncate the boundary front by
   crowding distance. The candidate set is exactly the previous Success pool
   plus all new offspring. Rank every successful candidate first. If fewer
   successful candidates exist than the population cap, fill remaining slots
   from unsuccessful new offspring by the existing seeded-shuffle then
   score-descending order. Previous Fail candidates are not retained, matching
   classic. Both classic and Pareto place valid successes before failures
   because failed scalar scores are `-inf`. The changed mechanisms are scalar
   ordering and the explicit champion lane among successes. The step-3 unique
   insertion index also orders equal crowding distances at boundary-front
   truncation.
5. Build the delivered global Pareto front post hoc from the full evaluated
   successful-candidate history. It is reporting-only and never becomes a
   parent source or survivor store.

For RTLLM and VerilogEval in this goal, assert that `status == "success"`
implies post-synthesis functionality, `ppa_success`, and every active PPA
metric. A violation is an invalid run, not another selectable state or a
fallback to scalar selection. Functional-only benchmark modes are unsupported
by `revolution_pareto` in this goal.

The only RTLLM `ProblemSpec` entries with `circuit_type == "unknown"` are
`Prob006_adder_pipe_64bit`, `Prob013_multi_booth_8bit`,
`Prob018_float_multi`, and `Prob040_synchronizer`. Resolve exactly this frozen
set as sequential because each reference RTL contains clocked state. Reject
every other unknown type. Never inherit a synthetic-reference fallback.

Distinct candidate ids remain separate during search even when objective
vectors tie. Delivered-front reports deduplicate identical objective vectors
and report both objective-vector and normalized-code duplicate counts.

The weighted scalar score may remain in unchanged feedback text and UCB reward
accounting for this one-factor experiment. It must not affect successful-parent
or successful-survivor selection. The method claim is therefore
"Pareto-aware population selection," not "weighted scalar fitness is absent
from every control path."

### Forbidden Method Drift

- No descriptor, grid, CVT, cell, archive-capacity, warmup, rebinning, memory,
  emitter, trigger, credit, or stagnation mechanism.
- No new prompt or evolutionary operator.
- No parent-only, survivor-only, tournament-size, or tie-break sweep.
- No S07 combination, descriptor follow-up, or capacity continuation.
- No adaptive fallback to scalar selection after a run begins.
- No change to primary metrics after reading results.

## Implementation Boundaries

Expected code shape:

- Put Pareto-specific code under `src/revolution/pareto_revolution/`.
- Reuse `active_ppa_objectives`, `compute_ppa_gains`, `ranked_front`, and the
  current evaluated-history reporting surfaces.
- Keep `src/revolution/algorithm.py` byte-for-byte unchanged. Isolate the
  experimental generation engine under `src/revolution/pareto_revolution/`
  and prove classic dispatch and seeded behavior remain unchanged.
- Add one thin backend/CLI dispatch value. Do not expose method-internal knobs.
- Add focused tests under `tests/revolution/` and, only if report behavior
  changes, `tests/scripts/`.
- Reuse existing reporting and validation scripts. Add one small validator
  only if current validators cannot assert the Pareto/operator contract.

Canonical planning and evidence live in this goal directory. Raw runs live
under `exp/pareto_revolution_validation/` and remain untracked. Do not import
from `exp/` or any untracked file.

Leave these unrelated untracked files untouched:

- `.devcontainer/devcontainer-lock.json`
- `codex_latest_thread_20260709_1536.txt`
- `docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/20260707_2005_code_logs.md`
- `docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/suite_variant_campaign/suite_campagin_initial_message.md`

## Current Locked Inputs

Reverify these hashes at activation. A changed locked artifact requires a
version bump and recorded rationale, not an in-place update.

| Artifact | SHA-256 at scaffold time |
| --- | --- |
| `docs/journal_features/journal_narrative.md` | `aee1d8b7c2e3a5f54adf6003e8ca8ce988d393809152afa0d51dd737c05d3d8c` |
| `data/configs/journal_seed_manifest.yaml` | `3f319e325d0fe8578ed54c565ad8f90affdd51935b06411cdd77e796a99e0629` |
| Legacy `data/configs/holdout_reference_subset.yaml` | `4c3cab68f5cb58a7e85c0c17204cb57a72f462138dbb3e4f271fe97620f69812` |
| `docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/RTLLM_full_suite/20260630/tables/rtllm_reference_complete_manifest.yaml` | `92d6ad2981b04a8aed531ca04ca1ac085bb9fb6fee866ada2a4bf397ee52497b` |

Historical descriptive families (not gate comparators):

- Classic: `exp/useful_bd_push/pcn_v3_experiments_20260701/live/rtllm_full_5seed/classic_revolution_8x5/seed_<seed>`
- V2: `exp/natural_qd_push/p3_v2_full_rtllm_20260703_101258_UTC/live/smooth_qd_v2_8x5/seed_<seed>`

## Comparator Contract

- Fresh matched classic REvolution is the only promotion and final-gate
  comparator.
- Existing Smooth-QD V2 is a descriptive full-RTLLM mechanism comparator. It
  cannot substitute for classic or relax a gate.
- Classic plus a post-hoc Pareto report is not a new arm. The same classic run
  supplies that reporting-only control.
- Existing classic-without-C-F evidence may be canonically reanalyzed as
  supporting context, but this goal does not launch a fresh no-C-F arm or
  change the Pareto arm's classic operator set.
- Historical classic and V2 roots are descriptive checks only. Their vLLM
  server revision cannot be proven identical, so they cannot satisfy a gate.
- The overlapping revision-3 holdout is legacy descriptive evidence only. It
  cannot promote the method or satisfy the paper-facing gate.

## Pre-Launch Freeze

No LLM-backed evidence run may start until all items below are recorded:

1. A method and claims addendum defining the exact selection algorithm,
   comparator, metrics, gates, and allowed language.
2. An independent read-only review returns PASS on that addendum.
3. A zero-compute audit counts, where logs permit, globally nondominated
   candidates discarded by classic scalar survival and QD per-cell survival.
   Missing historical state is reported, not reconstructed by assumption.
4. A canonical report recomputes S07 and S32's shared classic seed-1001 root and
   resolves the `33/46` versus `24/46` coverage discrepancy. The same input root
   must produce the same coverage under every future package.
5. Record the completed VerilogEval inventory audit proving that every one of
   the 156 source tasks has a prior evaluated outcome. Do not relax the
   disjointness rule, substitute tasks, or retain a pending holdout gate.
6. The 50-task RTLLM run surface, 46-task reference-complete headline manifest,
   four-task circuit-type mapping, seeds, comparator policy, and hashes are
   frozen in the V2 config.
7. Comparator compatibility is proven for model, prompt/operator set, budget,
   toolchain, measurement semantics, and code revision. Rerun a comparator if
   compatibility cannot be established.
8. Unit, integration, classic-regression, operator-contract, and artifact tests
   pass at the frozen implementation commit.
9. The local vLLM endpoint reports `openai/gpt-oss-120b` with at least 131072
   context. Evidence runs use `max_tokens=128000` and
   `diff_max_tokens=128000`.

Do not launch a long run while a server restart or endpoint shutdown is
pending. Every live run gets a restart handoff after launch and a packaged
closure immediately after completion.

## Experimental Flow

Full RTLLM is the triage surface because the prior eight-design screen had weak
transfer. Small runs are for technical validation only.

| Stage | Scope | Purpose and decision |
| --- | --- | --- |
| 0 | Zero compute | Freeze claims, code, configs, manifests, baselines, and hashes. |
| 1 | Unit and deterministic integration tests | Prove Pareto semantics and unchanged classic behavior. |
| 2 | Seed 42, `Prob003_adder_32bit`, `Prob025_sequence_detector`, and `Prob006_adder_pipe_64bit`, 8x5 | Exercise normalized 2-axis, normalized 3-axis, and raw 3-axis paths; technical evidence only, with no performance inference. |
| 3 | Full 50-task RTLLM, seed 1001, 8x5 | Gate on the locked 46 reference-complete tasks. |
| 4 | Full RTLLM, seed 1002 | Run only if seed 1001 passes its stop rule. |
| 5 | Full RTLLM, seeds 1003-1005 | Run only if the registered two-seed promotion gate passes. |
| 6 | Prior-run-disjoint held-out evidence | Unavailable: all 156 VerilogEval tasks have prior evaluated outcomes. |

Infrastructure failures may be corrected and rerun with the same frozen
method. Method failures stand. Screens, partial task subsets, or favorable
seeds cannot replace a failed suite gate.

## Quantitative Gates

### Frozen Metric Definitions

- **Final HV**: global hypervolume from every evaluated successful candidate in
  the generation logs, using the accepted reference-normalized active axes and
  zero-improvement reference point.
- **Valid-PPA coverage**: number of problem-seed units whose full evaluated
  history contains at least one testbench-passing, post-synthesis-passing
  candidate with valid values for every active PPA axis. It does not require a
  positive gain or positive HV.
- **Functional any-pass**: number of problem-seed units with at least one
  testbench-passing candidate, whether or not synthesis/PPA later succeeds.
- **Reference-beating coverage**: units with at least one candidate contributing
  positive reference-normalized front material. Report this separately; never
  label it simply "coverage."
- **HV-AUC46**: fixed-denominator trajectory metric over the 46 reference-PPA
  tasks. It remains secondary.

The canonical reporter must emit reason-coded unit rows from which all five
metrics can be recomputed. A report that changes a metric definition without a
versioned pre-launch addendum blocks the run.

### Correctness Gates

- Changing scalar `score` while objectives stay fixed must not change Pareto
  parent or survivor decisions.
- Active objective axes must match the accepted sequential/combinational rule.
  Resolve only the four frozen RTLLM unknowns as sequential; every other
  unknown circuit type fails explicitly.
- Population size, parent arity, uniqueness, and full evaluated-candidate
  logging must be exact.
- Classic mode must pass existing tests plus a seeded selection-regression
  test, and the frozen classic engine hash must remain unchanged.
- Pareto evidence logs must contain zero `single_thought_operator`, `M-T`, and
  `C-D` candidates and only the frozen EoH operator set.
- The post-hoc Pareto archive must be reproducible from generation logs and
  must not affect search state.
- The same baseline root must reproduce identical metric and coverage values in
  every package.

### Budget Gates

- Primary budget: candidate evaluator invocations, matched exactly per problem.
- Report LLM calls and total tokens. A skew beyond +/-10% marks the comparison
  budget-asymmetric and blocks promotion until an infrastructure cause is
  corrected under the same frozen method.
- If the skew persists and is method-inherent, close as budget-asymmetric
  supporting or negative evidence. Do not tune prompts, parents, or accounting
  to erase it.
- Use the accepted missing-treatment-as-loss, reason-code, and full-history
  rules from `journal_narrative.md`.

### Full-RTLLM Gates

All HV and valid-PPA coverage gates use the locked 46-problem manifest. Run and
report all 50 tasks, with the four reference-incomplete tasks excluded only
from normalized PPA claims. Functional any-pass is gated over all 50 tasks and
also reported on the 46-task subset.

- **Seed-1001 stop**: stop if Pareto final mean HV is below 90% of matched
  classic, if valid-PPA coverage is at least four problems below classic, or
  if any correctness/budget gate fails.
- **Two-seed promotion**: mean final HV must be at least matched classic and
  aggregate valid-PPA coverage and functional any-pass must each be at least
  matched classic.
- **Five-seed full-RTLLM promotion**: mean final HV must be strictly greater
  than matched classic; aggregate valid-PPA coverage and functional any-pass
  must remain at least matched classic. Exact final-HV parity is supporting.
  Publish paired cluster statistics, per-seed deltas, leave-one-seed-out
  sensitivity, and per-problem maps before deciding.

HV-AUC is secondary and can never rescue a failed final-HV gate.

### Paper-Facing Gate

No paper-facing held-out gate is available in this campaign. Passing the
five-seed full-RTLLM gate yields positive development evidence, not `REF_WIN`
or a headline journal claim. A later goal requires a genuinely fresh benchmark
and the separate `NEW_OK` evidence required by revision 3.

## Required Evidence Package

- Versioned claims addendum and reviewed mechanism card.
- Frozen config snapshots, manifest hashes, comparator roots, code commit, tool
  versions, vLLM preflights, and rerun-ledger entries.
- Per-run validation and operator-contract reports.
- Full-history final HV, fixed-denominator HV-AUC, valid-PPA coverage, yield,
  Pareto cardinality, per-axis wins, calls, tokens, and wall time.
- Canonical paired statistics and per-problem/seed tables.
- Post-hoc delivered Pareto fronts with source candidate ids.
- At least one positive and one negative mechanism case if the data contain
  them; every showcased candidate receives the accepted equivalence and
  synthesis-determinism checks.
- A plain-language final decision that preserves negative evidence.
- Updates to `README.md`, `docs/journal_features/13_findings_dashboard.md`, and
  the nearest journal history/navigation docs after results land.

## Validation Commands

Exact touched paths are resolved during implementation. At minimum run:

```bash
uv run pytest tests/revolution tests/scripts
uv run ruff check src/revolution/pareto_revolution \
  src/revolution/backends/revolution_backend.py scripts/run_backend.py \
  tests/revolution tests/scripts
uv run python -m pyright src/revolution/pareto_revolution \
  src/revolution/backends/revolution_backend.py
uv tool run ty check src/revolution/pareto_revolution \
  src/revolution/backends/revolution_backend.py
git diff --check
```

Run the full `pytest` suite before final sign-off. Record pre-existing or tool
environment diagnostics explicitly; do not silently skip them.

## Audit Cadence

- Independent method-card review before the first live run.
- Read-only code and direction audit before seed 1001.
- Another read-only audit after every roughly 10 commits or before each new
  evidence stage, whichever comes first. A `claude -p` review may use a
  5-10 minute timeout; record timeouts and use the repository's independent
  Codex review path when needed.
- Final adversarial review must inspect raw evidence and git history, not trust
  the implementer summary.

## Completion Rules

The goal may receive adversarial PASS on a positive, supporting, or negative
outcome only when the correct preregistered path is complete and reproducible.
PASS judges research integrity and completion, not whether the method won.

The goal is not complete while a required run is live, an evidence package is
unvalidated, a dashboard is stale, or a gate is decided from an unregistered
metric.

## Blocked Stop Condition

After three concrete attempts fail for the same external blocker, stop and
record every command, artifact, error, and partial result. State the exact
resource or decision needed to continue. Valid blockers include an unavailable
128k vLLM endpoint, irrecoverable fresh comparator artifacts, or unavailable
verification infrastructure.

A method missing a performance gate is not blocked. It is a completed negative
or supporting result and must be closed as such.
