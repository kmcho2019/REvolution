# Sub-Agent Packaging Review

Reviewer: Lovelace sub-agent.
Date: 2026-06-22 UTC.
Status: initial `FAIL`, follow-up `PASS` after resolution.

## Blockers Reported

- The package over-answered which diversity matters. The experiment plan
  correctly says the full RTLLM comparison tests the T26 bundle and does not
  isolate descriptor effects from champion-biased exploitation, but the report
  and deck made the Q2 answer too definitive.
- Required family-breadth evidence was absent from the full RTLLM package. The
  package reports `unique_ppa_points`, not `unique_front_families` or
  `unique_front_netlists`.
- Budget parity was incomplete. Generated candidate counts were visible, but
  no table reported LLM calls, tokens, or runtime.
- Final presentation/report validation had not been recorded as passed.

## Resolution Plan

- Scope the Q2 answer to evidence for the T26 implementation-response archive
  bundle, not descriptor-only causality.
- Add `full_rtllm/tables/full_budget_parity.csv` with runtime, LLM-call,
  token, and generated-candidate counts derived from the existing per-problem
  summary JSON files.
- Label family-breadth evidence as a follow-up gap for the full 50-problem
  package. Keep the current presentation claim on HV, HV-AUC, valid-PPA
  retention, PPA-front points, and unique PPA points.
- Keep the Phase 03.1 viewer as a documented follow-up unless archive-viewer
  claims are made.

## Follow-Up Review

Reviewer: Volta sub-agent.
Date: 2026-06-22 UTC.
Status: `PASS` for the scoped PPA-first presentation claim.

- The report and slides now scope Question 2 to the T26
  implementation-response archive bundle instead of descriptor-only causality.
- The package records matched generated-candidate, LLM-call, token, and
  runtime parity in `full_rtllm/tables/full_budget_parity.csv`.
- Family-breadth, descriptor-causality, and Phase 03.1 viewer claims are
  documented as follow-ups, not current wins.
