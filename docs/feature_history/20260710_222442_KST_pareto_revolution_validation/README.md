# Pareto REvolution TCAD Validation

Status: negative closure. The frozen two-seed full-RTLLM promotion gate failed
on final HV and functionality coverage. Seeds 1003-1005 and treatment variants
are not authorized.

## Purpose

This goal resolves one candidate from the 2026-07-10 senior-advisor bundle:
global Pareto parent and survivor selection on the classic REvolution
substrate, without descriptors or per-cell QD retention.

It is deliberately not a general search for another QD variant. The goal ends
with positive RTLLM development evidence, a supporting result, or a
reproducible negative closure under frozen gates. A paper-facing primary claim
is unavailable because no prior-run-disjoint VerilogEval task remains.

## Reading Order

1. `pareto_revolution_validation_plan.md`
2. `pareto_revolution_claims_addendum_v3.md`, then V2 for the full contract
3. `prelaunch_audits.md`
4. `execution_commands.md`
5. `smoke_seed42/README.md`
6. `full_rtllm_seed1001/README.md`
7. `full_rtllm_seed1002/README.md`
8. `full_rtllm_two_seed/README.md`
9. `pareto_revolution_validation_implementation_todo.md`
10. `restart_handoff.md`
11. `goal_template.md`
12. `pareto_revolution_validation_adversarial_prompt.md`
13. `pareto_revolution_validation_implementation_history.md`
14. `pareto_revolution_validation_subagent_validation_report.md`

Independent reviews live under `reviews/`. The 2026-07-11 scaffold trail was
`FAIL -> FAIL -> PASS`. The 2026-07-13 V1 prelaunch review returned FAIL and
drove V2; the V2 re-review returned PASS. V1 remains historical and cannot
govern a run. The implementation trail is also `FAIL -> PASS`.

## Upstream Decision

The source review bundle is:

`docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/reviews/20260710_review_bundle/`

The accepted `docs/journal_features/journal_narrative.md` revision 3 remains
unchanged. A versioned claims addendum is a hard pre-launch requirement.
