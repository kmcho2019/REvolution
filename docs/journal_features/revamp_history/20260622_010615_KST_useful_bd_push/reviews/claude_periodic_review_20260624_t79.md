# Claude Periodic Review: T79 Rollup Freshness

Timestamp: `2026-06-24 08:00 UTC`

Command class: `claude -p`, read-only, `timeout 900`.

## Scope

The review inspected the useful-BD rollup docs, the T79 package, recent commit
messages, and the project guidance in `AGENTS.md`/`GUIDELINES.md`.

## Result

PASS on T79 package honesty; FAIL on parent-rollup freshness before the
follow-up patch.

The reviewer found that the T79 package was numerically consistent and honest:
exact T75 loses matched classic on mean Pareto HV at `12x3`, `8x5`, and `6x7`.
It also found that parent rollup docs still described T79 as pending.

## Main Findings

- T79 package truthfulness is strong: `results_report.md`, `README.md`, and
  the copied final-analysis tables agree on the diagnostic-negative result.
- Parent rollups needed refresh: `best_current_techniques.md`,
  `technique_lanes.md`, `research_strategy_recommendations.md`,
  `useful_bd_push_plan.md`, and `useful_bd_push_implementation_todo.md` still
  described T79 as open.
- The generated recommendation labels `score_qd` and `archive_qd` were too
  easy to misread as QD wins. They needed a best-among-QD-only caveat.
- The T79 README undersold the viewer package by calling the full Phase 03.1
  viewer a remaining gap even though schema-complete viewer bundles exist.
- Commit hygiene was judged strong: signed, atomic, conventional commits with
  clear bodies and no malformed raw newline text.
- The only untracked unrelated file was `.devcontainer/devcontainer-lock.json`.

## Follow-Up Applied

- Marked T79 complete and diagnostic-negative in the parent rollups.
- Checked the T79 budget-shape TODO items as complete with the negative result
  noted.
- Added a caveat that generated QD recommendation labels are diagnostic
  best-among-QD metadata, not evidence that QD beat classic.
- Reworded the viewer status to say the Phase 03.1 bundles exist and pass
  strict schema validation; only strict Playwright interaction validation on
  arbitrary T79 subsets remains as a harness caveat.

## Recommended Next Actions

1. Keep T79 as the source of truth for exact T75 budget-shape evidence.
2. Do not reopen exact T75 on budget-shape grounds unless a new shape is
   registered separately.
3. Shift live QD spending toward changed descriptor/coupling mechanisms, such
   as raw/retrained RTL-native descriptors or source-faithful timing/power
   model flows.
