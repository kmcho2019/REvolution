# H4: Seeded RTL Optimization

Status: `RETIRED`. This is the unrun proposal snapshot; no algorithmic finalist
qualified for the generalization stage.

## Conference Scope Gap

The conference evidence is primarily specification-to-RTL generation. A useful
CAD optimizer should also improve valid but suboptimal RTL while preserving its
observable contract.

## Falsifiable Hypothesis

A separately confirmed algorithmic `PAPER_CANDIDATE` produces more functionally
equivalent seed-relative PPA improvements than one-shot rewriting and seeded
classic REvolution at equal budget.

## Program Role

This is a task/generalization contribution, not a substitute for an algorithmic
extension. Do not implement it before at least one algorithmic candidate reaches
confirmation or the owner explicitly selects optimization as a separate paper
direction after novelty review.

## Proposed Task

- Initialize the success population with valid suboptimal RTL.
- Freeze an explicit functional contract and seed-relative PPA reference.
- Count only changed descendants that pass the required functional/equivalence
  gate as optimization successes.
- Keep unchanged seeds in the baseline table but exclude them from improvement
  counts.

## Required Controls

1. unchanged seed;
2. one-shot LLM optimization;
3. seeded classic REvolution;
4. seeded confirmed algorithmic paper candidate.

Use a current RTL optimization benchmark plus a separately frozen RTLLM-derived
set only when contamination and reference roles are explicit.

## Validation Posture

- Every accepted optimized artifact must pass the stated functional/equivalence
  contract; there is no 90% correctness allowance for claimed artifacts.
- Report task coverage separately from conditional correctness.
- Require seed-relative PPA improvement, changed-equivalent descendant yield,
  final HV where defined, and matched calls/tokens/synthesis cost.
- Apply the shared role-specific `VIABLE` and `PAPER_CANDIDATE` gates.

## Retirement Conditions

Retire as a paper contribution when one-shot or seeded classic matches the
confirmed algorithmic candidate, changes fail equivalence, gains disappear
under hardened PPA, or current optimization systems remove the claimed novelty.

## Main Reviewer Risk

Seeding and RTL-to-RTL optimization are already crowded contributions. H4 is
valuable only as convincing generalization of a distinct confirmed mechanism.
