# Sub-Agent Prelaunch Review

Date: 2026-06-22 UTC

Reviewer: delegated adversarial planning sub-agent.

## Main Findings

- Create a milestone package with navigation, report, slides, command cards,
  frozen problem manifest, claim gates, and launch checklist before any broad
  RTLLM run.
- Pre-register the RTLLM experiment before launch: exact problems, seeds,
  budget, model, endpoint, method arm, classic arm, failure handling, and
  promotion gates.
- Do not claim global "diversity matters" from current evidence alone. Safer
  wording: scoped evidence shows some implementation-aware diversity mechanisms
  are competitive or diagnostic.
- T26/T27/T30 support `T1 near_classic`; T28 blocks a clean `T2` because
  front-family breadth is worse than classic and SR raw.
- Exact T26 is cleaner for confirmatory RTLLM launch because it is already
  audited. T26.1/gated variants should be exploratory unless pre-registered,
  screened, and tested.
- Required tables include problem manifest, run manifest,
  method-problem-seed metrics, validity funnel, candidate PPA points, family
  metrics, comparison deltas, and claim gates.
- Required visuals include raw area-power Pareto panels, paired HV/HV-AUC
  deltas, validity funnels, per-problem panels, and Phase 03.1/full direct-PPA
  viewer bundles for live QD arms.

## Action Taken

The milestone package now includes the report/deck scaffold, RTLLM 50-problem
manifest, command templates, and adversarial rubric. Remaining gates are
tracked in the central TODO.
