# Claude Periodic Review Prompt: T96 Checkpoint

Please perform a read-only adversarial review of the current useful-BD push.
Do not edit files. Focus on whether the current work still follows the
original goal intent and the repository guidance.

Read these first:

- `AGENTS.md`
- `GUIDELINES.md` if present
- `docs/journal_features/revamp_ruminations_20260612.md`
- `docs/journal_features/journal_narrative.md`
- `docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/goal_template.md`
- `docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/useful_bd_push_implementation_todo.md`
- `docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/useful_bd_push_implementation_history.md`
- `docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/current_selection_status.md`
- `docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/best_current_techniques.md`
- `docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260626_rf_deepgate_hybrid_delayed_probe/results_report.md`
- `docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260626_rf_deepgate_hybrid_delayed_probe/logs/validation_log.md`

Review questions:

1. Are we still aligned with the original goal, or have we drifted into
   loopholes, weak claims, or premature sign-off?
2. Is the latest T96 result packaged honestly, with reference-complete
   comparison rules and no defaulted-reference issue?
3. Do the current selection docs correctly maintain one representative per
   encoder/config category and a top-10 mean-HV shortlist?
4. Are the visualization artifacts and inspection notes sufficient for a
   colleague-facing discussion?
5. Are there signs that experiment code or docs are becoming bloated,
   over-defensive, or hard to skim, relative to the simplicity guidance?
6. What are the next 3-5 concrete actions that would most improve the rigor
   of the final RTLLM candidate selection?

Please return:

- verdict: pass, pass-with-actions, or fail;
- top findings ordered by severity;
- concrete action list;
- any claim wording that should be tightened.
