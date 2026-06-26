# Periodic Read-Only Review Prompt

You are performing a read-only adversarial review of the active useful-BD
push in `/workspace`.

Do not edit files. Inspect the current repository state and give concrete
feedback. Prioritize issues that would mislead a colleague or reviewer about
whether QD/MAP-Elites behavior descriptors are useful for RTL PPA evolution.

Read at least these files:

- `AGENTS.md`
- `docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/useful_bd_push_plan.md`
- `docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/useful_bd_push_implementation_todo.md`
- `docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/completion_gap_audit.md`
- `docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/current_selection_status.md`
- `docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/current_results_matrix.md`
- `docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/best_current_techniques.md`
- `docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/technique_lanes.md`
- `docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/technique_lineage_ledger.md`
- `docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/common_evaluation_contract.md`

Review questions:

1. Does the current plan honestly reflect the latest T95/T96/T99/T100 and
   T08/T09/T10/T12/T16/T18 closure state?
2. Does `completion_gap_audit.md` correctly identify what remains before a
   positive useful-QD claim or rigorous negative-map sign-off?
3. Are `current_selection_status.md` and `best_current_techniques.md`
   consistent about category representatives, top-10 mean HV, and the fact
   that no QD arm is promoted for full RTLLM spend?
4. Are any claims still vulnerable to missing-reference PPA, smoke-only
   promotion, single-seed overclaiming, or validity/yield-collapse loopholes?
5. Is the documentation easy enough to skim for a colleague, or is key status
   buried in stale or contradictory sections?
6. Based on AGENTS/GUIDELINES, are recent source/reporting changes likely to
   remain simple, modular, and free of excessive defensive fallback behavior?
7. What are the next 3-5 concrete actions that would most improve rigor before
   another live run or final sign-off?

Return:

- `PASS`, `PASS_WITH_ACTIONS`, or `FAIL`.
- Findings ordered by severity with file references.
- Any concrete wording changes needed to avoid overclaiming.
- A short judgment on whether another live run is justified now or whether
  metric/figure/comparison/adversarial closure should come first.
