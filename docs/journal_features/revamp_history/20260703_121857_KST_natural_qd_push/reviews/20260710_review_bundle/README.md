# 20260710 Senior Advisor Review Bundle

This bundle asks a senior advisor to decide whether the TCAD extension should
be written now as a QD characterization or reopened around a simpler method
with a credible full-suite performance path.

The short answer is:

> The natural-QD push was a successful, rigorous investigation, but it did not
> achieve its intended full-RTLLM final-HV win. QD should remain supporting
> evidence. The strongest immediate method candidate is descriptor-free
> Pareto REvolution; the highest-upside scale candidate is reference-seeded
> Pareto optimization of verified RTL.

## Reading Order

1. `briefing/cover_letter_to_senior_advisor.md`
2. `briefing/executive_summary.md`
3. `briefing/evidence_and_failure_analysis.md`
4. `briefing/journal_direction_shortlist.md`
5. `briefing/validation_and_claims_plan.md`
6. `briefing/technical_stack_and_infrastructure.md`
7. `briefing/advisor_questions.md`
8. `briefing/review_prompt.md`

## Supporting Material

- `evidence/governing/`: original intent, accepted claims contract, current
  findings, narrative posture, and conference-paper text.
- `evidence/results/`: current natural-QD comparison, suite registry, S07
  five-seed result, S32 closure, and adversarial negative-map validation.
- `evidence/operator_ablation/`: the existing five-seed C-F control result.
- `evidence/infrastructure/`: RealBench PPA state, experimental setup, and
  frozen V2 platform configuration.
- `source/`: selected small validators and analysis entry points, plus a map
  to the larger runtime modules left in the main repository.
- `references/`: literature links and a bundle inventory.
- `reviews/`: independent read-only review and bundle validation record.

## Scope

Snapshot date: 2026-07-10 UTC. Branch:
`feat/journal-qd-bd-exp-20260703`. Source HEAD before bundle creation:
`e05883d70d465bdd764dab6c14eec22c2456c795`.

The bundle is curated. It excludes raw `exp/` trees, model caches, repeated
per-seed plots, and the large untracked restart transcript. Canonical local
paths are recorded in `evidence/README.md` for deeper inspection.
