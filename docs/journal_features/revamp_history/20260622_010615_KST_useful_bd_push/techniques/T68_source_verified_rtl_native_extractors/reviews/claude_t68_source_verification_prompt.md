# Claude T68 Source-Verification Review Prompt

Read-only review. Do not edit files.

Review the current worktree on branch `feat/journal-useful-bd-exp-20260622`
for the useful-BD goal. Focus on:

- `GUIDELINES.md` and the implementation simplicity/commit rules.
- `docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/goal_template.md`
- `useful_bd_push_plan.md`
- `useful_bd_push_implementation_todo.md`
- `useful_bd_push_implementation_history.md`
- `best_current_techniques.md`
- `technique_lanes.md`
- `technique_lineage_ledger.md`
- `current_results_matrix.md`
- `techniques/T68_source_verified_rtl_native_extractors/`
- relevant T15/T60/T61/T62/T63/T64/T65/T66/T67 reports.

Evaluate whether T68 properly handles the user's concern that MasterRTL,
RTL-Timer, and SOG claims are meaningful only if the original repo
implementation, preprocessing, weights, and outputs are actually verified.

Check:

- Does T68 avoid overclaiming proxy features as upstream MasterRTL/RTL-Timer?
- Are the quantitative checks sufficient for a verification gate?
- Are blockers such as `read -verific`, missing RTL-Timer weights, zeroed
  TinyRocket labels, and wrapper/env issues stated clearly?
- Does the next-step recommendation follow the goal instead of giving up too
  early?
- Are docs, comments, figures, tables, and terminology easy to follow?
- Are the code/docs aligned with `GUIDELINES.md`: simple, clean, no excessive
  defensive fallbacks, no bloated abstractions, no back-compat clutter?
- Are there any anti-gaming or claim-evidence alignment issues?

Return findings first, ordered by severity. Include concrete file paths and
line references where possible. End with a short verdict: PASS, PASS WITH
LIMITATIONS, or FAIL.
