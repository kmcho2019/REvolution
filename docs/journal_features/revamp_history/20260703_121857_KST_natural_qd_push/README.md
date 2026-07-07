# Natural QD Push (2026-07-03)

Goal-scaffold root for the July 2026 push to find a natural QD/MAP-Elites
extension of classic REvolution that beats classic on HV and HV-AUC while
matching or improving functionality. Branch: `feat/journal-qd-bd-exp-20260703`.

## Current State (2026-07-07; follow-ups N04/N02b/N07a/N07c/N09/N10 measured)

- HEADLINE: the two-scale story. The faithful V2 platform BEATS classic
  at screening scale (+12.9% HV, +16.2% HV-AUC, 3/3 seeds,
  `p0_v2_anchor/`) — the first replicated operator-fair QD win in the
  program — and lands at no-cost parity with a coverage edge at
  full-suite scale (95.2% HV, 100.5% AUC, 166 vs 164 designs,
  `p3_full_rtllm/five_seed_verdict.md`); the frozen +5% gate fails at
  suite scale, where outcomes are LLM-capability-bound.
- Start here: `lanes/README.md` (both-scale standings), then the plan
  and history. Screen/follow-up arms plus suite probes are measured,
  operator-audited, and config-pinned; both periodic dual reviews
  (claude -p, codex) verified the campaign with zero blocking findings.
- Founding-analysis context: the June-22 negative map was
  operator-contaminated (corrected reruns swing 30-46 points); PCN-v3
  is retired (5-seed negative, C-F confounded) and its mechanism
  signature is banned by the adversarial rubric here.
- Follow-up update: N04 6x7 budget shape is now measured. Faithful V2
  reaches final-HV parity/slight edge against the verified T79 classic
  6x7 comparator (101.1%) with coverage retained, but loses HV-AUC
  (90.5%) and Pareto breadth, so no 4x11 or 6x7 seed ladder is justified.
- Follow-up update: N02b gamma 0.5 is now measured and retired. It
  recovers valid-PPA coverage after gamma 1.0 lost gshare, but falls
  below classic (91.5% HV, 92.5% HV-AUC) and far below V2 (74.0% HV,
  79.7% HV-AUC), so curiosity weighting is a clean negative.
- Open by design: N07 due diligence has probe-only pre-registration.
  N07a and N07c now have closed negative live reads under the V2-faithful
  descriptor-only rule; N07b failed its DeepGate extraction gate, so the
  corrected-suite descriptor due-diligence lane is closed.
- Follow-up update: N09 Pareto capacity is now measured. Raising
  `qd_max_elites_per_cell` from 5 to 7 beats classic on mean HV/AUC
  but trails V2 on both metrics and reduces Pareto breadth, so capacity
  above five is diagnostic only and does not escalate.
- Follow-up update: N10 SR-ReLU PCA is now measured. The descriptor
  smoke transferred better than N07a/N07c and coverage stayed 8/8, but
  the live screen beats classic only (`0.15683` mean HV, +11.5%) and
  trails V2 (`90.3%` HV, `93.3%` HV-AUC) with lower valid-PPA yield and
  Pareto breadth, so it is diagnostic only and does not escalate.
- Decision map: `followup_decision_map.md` closes the current
  single-knob follow-up portfolio for manuscript synthesis. Do not open
  another capacity/gamma/warmup/budget/descriptor scan without a new
  mechanism card and pre-recorded gate.
- Closure review: `negative_map_adversarial_validation_report.md`
  records PASS for the exhausted-portfolio alternative outcome. The
  remaining compact_8d and held-out items are paper decisions, not
  blockers for this goal's follow-up campaign.

## Top-Level Docs

| File | Role |
| --- | --- |
| `original_thoughts.md` | The user's founding intent, verbatim and unorganized — read for intent, not as a contract. |
| `natural_qd_push_plan.md` | The contract: lessons, lanes, gates, phases. |
| `natural_qd_push_implementation_todo.md` | Living checklist (hard line cap). |
| `natural_qd_push_implementation_history.md` | Append-only audit log. |
| `followup_decision_map.md` | Post-N10 operator-fair map of follow-up results, stop rules, and remaining paper decisions. |
| `negative_map_adversarial_validation_report.md` | Formal PASS review for the exhausted-portfolio alternative outcome. |
| `goal_template.md` | Compact `/goal` body. |
| `natural_qd_push_adversarial_prompt.md` | Sign-off rubric (PASS/FAIL). |
| `natural_qd_push_subagent_validation_report.md` | Canonical validator output; includes the post-N10 negative-map PASS addendum. |

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
