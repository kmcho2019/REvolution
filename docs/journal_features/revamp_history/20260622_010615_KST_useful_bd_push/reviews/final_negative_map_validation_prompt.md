# Final Negative-Map Validation Prompt

You are a read-only adversarial validation reviewer for the useful-BD push.
Do not edit files.

Use the rubric in:

- `docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/useful_bd_push_adversarial_prompt.md`

Validate this current claim:

> No screened QD/MAP-Elites behavior-descriptor or archive-coupling method is
> promoted for full RTLLM spend. The branch has enough evidence to pause broad
> live spend on the tested families and present a rigorous negative map, while
> avoiding the stronger claim that QD/MAP-Elites is impossible or useless.

Read at least:

- `AGENTS.md`
- `docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/central_comparison_report.md`
- `docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/stop_condition_audit.md`
- `docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/completion_gap_audit.md`
- `docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/tables/completion_gap_inventory.csv`
- `docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/current_selection_status.md`
- `docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/technique_lineage_ledger.md`
- `docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/technique_registry.csv`
- `docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/useful_bd_push_implementation_todo.md`

Return `PASS`, `PASS_WITH_ACTIONS`, or `FAIL`.

`PASS` means the negative-map claim is rigorous enough for the current goal:
the scope is preserved, the core method families are represented, no positive
claim is overextended, anti-gaming checks are visible, and remaining gaps are
properly caveated rather than hidden.

If the verdict is not `PASS`, list concrete required fixes with file paths.
