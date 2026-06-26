# T12 Lineage Repair BD Methodology

## Intent

Represent candidates by how they arise and how edits repair or alter structure.
The intended question was whether QD should explore productive lineage regions
rather than only static netlist coordinates.

T12 is evaluated as a retrospective synthesis. Later live packages already
tested the practical lineage/repair mechanisms:

| Mechanism | Evidence package | Role |
| --- | --- | --- |
| Direct fail-pool repair text | `T31_sr_raw_fail_feedback_repair_qd` | Tests whether fail feedback repairs the T30/T26 holdout warning. |
| Thought role separation and bounded repair | `T49_thought_k_role_separated_repair_qd` | Tests role-separated repair on the hard/tuning screen. |
| Code-individual front-slot recovery | `T51_code_thought_front_slot_qd` | Establishes the best recovery base in this lineage. |
| Short feedback on the T51 base | `T59_t51_feedback_front_slot_qd` | Tests whether fail-pool feedback fixes T51's front-breadth blocker. |

## Inputs

- Candidate lineage metadata: parent id, operator id, mutation prompt, edit
  summary, generation index, and retry count.
- Structural before/after features from parent and child netlists.
- Non-PPA operational statuses such as parse and synthesis extraction status
  for funnel accounting.

In-loop BD inputs exclude final PPA, reference PPA, fitness, hypervolume,
Pareto labels, and functional test pass labels. Validity statuses may be used
for reporting and gating, but not as a hidden reward.

## Intended Descriptor Boundary

The original T12 descriptor boundary remains useful for future work:

- parent-child structural distance;
- edit class counts over already-observed ancestors;
- operator novelty relative to prior candidates from the same benchmark;
- repair distance after parse/synthesis failure, reported separately from
  reward;
- descendant branching factor and age computed only from already-generated
  candidates;
- static child descriptor summary from a PPA-free structural feature set.

Run an ablation without any validity-derived coordinates to check whether the
descriptor is merely sorting by survival.

## Retrospective Method

The retrospective asks:

1. Does direct repair feedback improve valid-PPA yield or PPA-front breadth?
2. Does role separation preserve classic-covered problems without losing front
   material?
3. Does adding short fail-pool feedback to the best recovery base improve the
   QD-relevant metrics?
4. Is a fresh lineage-repair live run materially different from the measured
   T31/T49/T51/T59 lineage?

The answer is recorded in:

- `tables/t12_lineage_evidence_matrix.csv`
- `tables/t12_gate_decision.csv`
- `figures/t12_t31_holdout_live_aggregate.png`
- `figures/t12_t49_metric_delta_summary.png`
- `figures/t12_t51_metric_delta_summary.png`
- `figures/t12_t59_metric_delta_summary.png`

## Future Variant Boundary

Do not run another same-budget fail-feedback text tweak. A future T12-family
method must be source-level and lane-explicit. It should report, per repair or
front-rescue lane, generated count, valid-PPA count, local-front additions,
global-front additions, and final-front contribution.
