# Paste-Ready Goal Template v2.1

Status: v2.1 (2026-06-12). v1 archived as `goal_template_v1_initial.md`;
the v2 draft overstated foundation completeness and was corrected after an
evidence audit (see the implementation history). Use this text when
starting the completion-phase goal (3887 chars, fits the 4000 limit):

```text
/goal Objective: Complete the REvolution TCAD journal revamp on branch
feat/journal-revamp-20260612-005012-kst so that code, experiments,
reports, and manuscript support the same claims under the ACCEPTED claims
contract docs/journal_features/journal_narrative.md (frozen; wins on any conflict). Execute
the phase plan docs/.../
20260612_005012_KST_journal_revamp/journal_revamp_plan.md (P1-P5), track
journal_revamp_implementation_todo.md (phase-grouped; sign-off requires
EVERY item checked and spot-verified), and log evidence in
journal_revamp_implementation_history.md plus rerun_ledger.jsonl.
Original intent: docs/journal_features/revamp_ruminations_20260612.md.

Starting — foundations landed WITH open conditions, verify
before relying on them: capability model, locked subsets/probe, scheduler
telemetry + fair-share (46% on synthetic replay; live occupancy still
unproven), cluster-bootstrap statistics/validator/ledger/seed-manifest,
Verilator 5.030 (official flow validated 5/5), narrative accepted by four
personas. NOT yet true: no end-to-end evolutionary run has completed on
CVDP or RealBench; the fast-iteration instrument is NOT signed off (pilot
failed G1b/G2/G3; G4/G5 pending; v2 subset likely); narrative acceptance
carries open pre-freeze obligations (QD k-sample logging fix, MDE
artifact, RealBench retention update after the verilator-5 re-sweep).

Outcome (what must be true at the end): (1) QD-vs-classic resolved on
held-out statistics via the narrative branch table — win, equivalence
with coverage edge, or Branch C with its content floor; never a
tuning-set headline. (2) A frozen, pre-registered BD descriptor profile
with quantified descriptor-objective correlations, bake-off evidence, and
a plain-language design-space rationale in the narrative. (3) CVDP and
RealBench evidenced by end-to-end evolutionary runs on locked slices
(CVDP PPA absolute-only; RealBench scoped to the harness-validated
subset with the v5 re-sweep retention table); model arm frozen by the
locked probe, symmetrically. (4) Manuscript updated in resources/journal_draft
per the selected branch with the four case-study artifacts.

Verification surface: validate_journal_revamp_run.py exit 0 per run
root; report_journal_statistics.py gate booleans + paired_deltas.csv;
validate_fast_iteration_pair.py reports; descriptor-health and
correlation artifacts; manifest/subset sha256 locks; ledger entries with
config hashes; the v2 adversarial prompt (docs/.../20260612_005012_KST_journal_revamp/journal_revamp_adversarial_prompt.md) executed with all four personas
returning sign_off.

Constraints: thresholds/branch rules/pools/budget rules never revised
after final runs begin; locked artifacts change only by version bump
with recorded rationale; tuning (hard subset, fast subset, debug slices)
disjoint from evidence sets; missing data penalized-as-loss; budget
symmetry = candidate evaluations with ±10% auxiliary skew reported;
conference_submission_paper frozen; never print DEEPSEEK_API_KEY;
preserve unrelated worktree changes; GUIDELINES.md practices (simplicity
rules, signed multi-line atomic commits, post-commit inspection).

Boundaries: src/revolution + scripts + tests for code; data/configs for
locks; docs/journal_features for planning; exp/ for runs; local vLLM
first (--max_tokens 128000 --diff_max_tokens 128000); DeepSeek only as
the predeclared symmetric escalation arm.

Iteration policy: screen every candidate change on the fast-iteration
instrument once signed off (PROMOTE/DEMOTE/INCONCLUSIVE); promote to
hard subset on PROMOTE only; record negative results; root-cause from
artifacts before changing code; new method ideas go in the history
before large experiments.

Completion: every TODO item checked and spot-verified; all narrative
gates mechanically evaluated; four-persona v2 adversarial sign-off on
the full evidence-plus-manuscript package.
```
