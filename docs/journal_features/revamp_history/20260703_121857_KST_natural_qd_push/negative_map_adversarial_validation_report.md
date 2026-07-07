# Natural QD Push Negative-Map Adversarial Validation Report

Validation date: 2026-07-07.
Rubric: `natural_qd_push_plan.md`, `goal_template.md`, and
`docs/journal_features/journal_narrative.md`.

## Verdict

PASS.

The active `natural_qd_push` goal satisfies its alternative outcome:
after the registered follow-ups, no natural QD/MAP-Elites extension
stronger than the V2/N03b characterization was found, and the campaign
has a clean, operator-fair, seed-honest decision map that is complete
enough to guide the TCAD manuscript.

## Evidence Checked

- `followup_decision_map.md`, `central_comparison_report.md`, `README.md`,
  `natural_qd_push_implementation_todo.md`,
  `natural_qd_push_implementation_history.md`, `lanes/README.md`, and
  `lanes/lane_registry.csv`.
- N04, N02/N02b, N07a/N07b/N07c, N09, and N10 lane reports,
  methodologies, operator contracts, and validation artifacts.
- `p3_full_rtllm/five_seed_verdict.md`, `p3b_closure.md`,
  `p3c_closure.md`, canonical statistics notes, and existing review
  files including `reviews/claude_post_n10_decision_map_20260707.md`.
- Operator-contract artifacts across the tree; no nonzero
  `single_thought_count` or failed operator-contract row was found in
  headline comparisons.
- Code organization evidence: the only new natural-mechanism module is
  the small `src/revolution/qd_natural/` implementation; no PCN-style
  core-loop drift is needed for the decision map.

## Findings

1. Persistence threshold is met before the broad negative conclusion:
   measured lane packages span cell retention/capacity, parent selection,
   budget shape, initialization, descriptor, and corrected-suite
   revalidation families.
2. The priority follow-ups were handled in evidence order: N04 measured
   and retired for front/anytime loss; N02b retired for exploration-tax;
   N07a/N07c closed negative; N07b gate-blocked by extraction failure;
   N09 and N10 kept as diagnostics but not escalated; N08 blocked because
   there is no winner pair; compact_8d and held-out confirmation remain
   paper decisions.
3. Headline comparisons preserve operator fairness:
   `qd_operator_kind=eoh_strategies`,
   `representation_kind=code_individual`, and `single_thought_count=0`.
   Contaminated June-22 numbers are used only as forensics, not mechanism
   evidence.
4. Failed or retired lanes record cause class, evidence, and retirement
   rationale in the lane reports and the decision map.
5. The map does not overclaim a Branch A/B suite win. The central report
   states that REF_WIN/REF_PARITY fail, maps the result to the Branch-C
   floor, and carries the 46-vs-50-scope caveat for coverage/statistics.
6. The docs are organized enough for manuscript use. The decision map is
   linked from the root README, lane index, central comparison report,
   dashboard, TODO, and history.

## Missing Or Weak Evidence

- `git diff main` was not re-executed inside the review environment, so
  empty core-loop diffs are corroborated by direct file inspection and
  prior independent reviews.
- N04's no-escalation decision rests on one 6x7 seed. This is acceptable
  because it declines further spend on a large co-primary HV-AUC loss,
  not because it claims a replicated mechanism failure.
- The suite packaging uses a recorded versioned exception instead of a
  literal `ppa_completeness.csv`.
- The +5% gate failure is supported by interim and canonical-direction
  evidence; the fail direction is not in doubt.

## Reward-Hacking Or Intent Risks

Overall risk is low. The record is self-adverse: the full-suite +5% gate
failure is foregrounded, compact_8d's failed validation is disclosed,
and N09/N10 are demoted despite beating classic because they trail V2.
Future non-trio descriptor promotion claims would need an operator-mix
control, but that is not relevant to this negative map because those arms
do not promote.

## Required Fixes Before PASS

None.

## Residual Non-Blocking Paper Decisions

- Compact_8d swap: use as a qualified descriptor-health or appendix
  option unless the manuscript pays for full 5-seed contract treatment.
- Held-out confirmation: optional because the suite +5% gate did not
  fire; it should confirm screening-scale characterization only.
- Raw `20260707_2005_code_logs.md`: remains an untracked local restart
  transcript/source log. It is not a curated result artifact and is left
  uncommitted to avoid adding a bulky raw transcript to the manuscript
  evidence tree.
- When writing the manuscript, keep the 46-vs-50 coverage/statistics
  caveat from `p3_full_rtllm/canonical_statistics/read_note.md`.
