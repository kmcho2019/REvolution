# H8 Candidate Decision

## Outcome

`RETIRED`

Allowed outcomes: `PAPER_CANDIDATE`, `VIABLE`, `RETIRED`, `BLOCKED`.

## Proposed Mechanism

H8 proposed retaining failed candidates by their furthest completed
verification stage instead of treating every failure as one `-inf` class and
dropping old failed lineages.

## Decision Rationale

The conference audit identifies discarded verification-stage information as a
real limitation, but H8 does not supply a clean journal mechanism:

- COEVO already uses correctness-aware selection and repair state, narrowing
  the related-work delta for stage-aware failed-candidate retention.
- Classic hardcodes failed-population handling inside the monolithic generation
  loop. The reviewed implementation path would copy or broadly refactor that
  loop instead of adding one removable experimental mechanism.
- Fresh component evidence does not show that retaining later-stage failures
  improves distinct-design repair, valid-PPA coverage, or PPA search.

The card therefore failed novelty, simplicity, and premise review before
implementation. No source, config, worksheet, admission event, model call,
synthesis evaluation, or benchmark result was created for H8.

## Allowed Claim And Follow-Up Boundary

Allowed: classic REvolution discards verification-stage distinctions from
failed-candidate fitness and survivor retention, but the proposed H8 response
was not sufficiently differentiated or cleanly isolatable for this program.

Not allowed: stage-aware retention is ineffective, COEVO is equivalent to
REvolution, or H8 has experimental evidence. Reopening requires a distinct
hardware/CAD mechanism, fresh classic-only premise evidence, and an isolated
implementation boundary that keeps classic byte-identical.

## Evidence

- `../../conference_method_audit.md`
- `../../component_evidence_audit.md`
- `../../candidate_ranking.md`
- `../../reviews/20260720_claude_candidate_ranking_closure.md`
