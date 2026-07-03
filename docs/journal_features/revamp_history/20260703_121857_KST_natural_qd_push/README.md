# Natural QD Push (2026-07-03)

Goal-scaffold root for the July 2026 push to find a natural QD/MAP-Elites
extension of classic REvolution that beats classic on HV and HV-AUC while
matching or improving functionality. Branch: `feat/journal-qd-bd-exp-20260703`.

## Current State

- Scaffold created 2026-07-03; goal not yet activated.
- Founding analysis complete: the June-22 push's negative map (T01-T100) is
  operator-contaminated (QD arms ran `single_thought_operator` vs classic's
  `eoh_strategies`); corrected reruns swing QD retention up 30-46 points.
- Platform: Smooth-QD V2 (code individuals + full EoH suite + champion
  refinement + NSGA-II selection over the BD-trio archive) is at statistical
  parity with classic. This push runs single-factor upgrades on that platform.
- PCN-v3 (stagnation-triggered auxiliary memory) is retired: 5-seed negative,
  C-F confounded, and rejected by colleagues as a bolt-on. Its mechanism
  signature is banned by the adversarial rubric here.

## Top-Level Docs

| File | Role |
| --- | --- |
| `original_thoughts.md` | The user's founding intent, verbatim and unorganized — read for intent, not as a contract. |
| `natural_qd_push_plan.md` | The contract: lessons, lanes, gates, phases. |
| `natural_qd_push_implementation_todo.md` | Living checklist (hard line cap). |
| `natural_qd_push_implementation_history.md` | Append-only audit log. |
| `goal_template.md` | Compact `/goal` body. |
| `natural_qd_push_adversarial_prompt.md` | Sign-off rubric (PASS/FAIL). |
| `natural_qd_push_subagent_validation_report.md` | Validator output. |

## Inherited Binding Policies (do not duplicate; reference these)

All under `../20260622_010615_KST_useful_bd_push/`:

| Doc | Binding content |
| --- | --- |
| `anti_reward_hacking_policy.md` | Registration-before-results, stop rules. |
| `metrics_and_acceptance.md` | Metric definitions, T0-T3 tiers. |
| `common_evaluation_contract.md` | Result schema, promotion schema. |
| `code_organization_policy.md` | Placement, self-containment, forbidden. |
| `visualization_reporting_policy.md` | Figure gates, report content. |
| `phase_03_1_visualization_contract.md` | Viewer bundle layout. |
| `vllm_runtime_guide.md` | Endpoints, preflight, 128k token rule. |

Deltas vs those policies are listed in `natural_qd_push_plan.md`
("Deltas Vs Inherited Contracts"). The frozen claims contract
`docs/journal_features/journal_narrative.md` wins on any conflict.

## Conventions

- Lane packages live in `lanes/N##_<slug>/` here (methodology, results,
  figures, tables), numbered `N01..` to avoid colliding with the June-22
  T-series. Registry: `lanes/lane_registry.csv`; approachable per-lane
  summary with standings tables: `lanes/README.md` (refresh on every
  lane read).
- Run outputs: `exp/natural_qd_push/<lane>/<timestamp>/...` (gitignored).
- Reused classic baselines are pinned in `tables/` before the first live run.
