# TCAD REvolution Extension Research Goal Scaffold

Status: `ACTIVE_WAVE_1`; baseline, statistics, benchmark roles, holdout, and
resource ceilings froze on 2026-07-20 before treatment evidence. H5 is the sole
Wave-1 candidate and passed its pre-implementation reviews.

This scaffold is a bounded research-discovery program for finding natural,
reviewer-defensible extensions of the ASP-DAC 2026 REvolution method. It starts
from an audit of the conference algorithm, generates candidate mechanisms from
documented weaknesses, and evaluates the strongest candidates through separate
falsifiable loops. It does not assume that the four imported candidates are the
right answer.

## Start here

1. Read the frozen `baseline_contract.md` and `program_claims_contract.md`.
2. Use `intake_review.md` for provenance and pre-live gate closure.
3. Use `tcad_revolution_extension_plan.md` as the durable program charter.
4. Use the reviewed `conference_method_audit.md` to rank implementation work.
5. Read `component_evidence_audit.md` and `candidate_ranking.md` before opening
   a candidate.
6. Track active work in `tcad_revolution_extension_implementation_todo.md`.
7. Keep every proposed and tested direction in `extension_portfolio.md`.
8. Use `shared/candidate_goal_contract.md` for each implementation loop.

## Program flow

1. Freeze and reproduce classic REvolution.
2. Audit its operators, populations, objectives, adaptation, verification, and
   evaluation scope against code, conference claims, later evidence, and current
   related work.
3. Propose several natural responses to the audited weaknesses. A proposal must
   have a hardware/CAD rationale, a clear REvolution-specific delta, and an
   isolatable mechanism. It must not be a parameter scan or heuristic patch.
4. Rank proposals with independent scientific and novelty reviews; evaluate at
   most two waves of no more than three distinct mechanisms each.
5. Implement candidates one at a time in isolated experimental modules.
6. Audit code before live spend, run a bounded smoke, then a representative
   probe. Non-catastrophic candidates advance to a frozen full-suite probe.
7. Record each candidate as `PAPER_CANDIDATE`, `VIABLE`, `RETIRED`, or `BLOCKED`.
8. Confirm only the strongest one or two candidates with five preregistered,
   development-disjoint seeds and a disjoint holdout.
9. Finish with a minimal journal thesis or an explicit evidence-backed pivot.

## Seed ideas, not a required queue

The H1-H4 directories are starting hypotheses supplied with the original
bundle. They must pass the same audit as any new idea. The program does not
require H1 and H2 to run, does not require every seed idea to be implemented,
and may add stronger candidates discovered by the conference-method audit. H5
is the sole Wave-1 algorithmic card. H6 records retrospective no-C-F evidence,
and H7 records a deferred UCB diagnostic outside the candidate state machine.

## Candidate state machine

`PROPOSED -> READY -> IMPLEMENTED -> SMOKE_VALIDATED -> SUITE_EVALUATED`

A nominated finalist then enters `CONFIRMING`. Proposal review may retire an
idea before implementation, and a named external blocker may stop any state.

Every evaluated candidate ends as exactly one of:

- `PAPER_CANDIDATE`: modest or larger suite-scale evidence supports a primary
  or supporting journal claim at the level defined by the claims contract.
- `VIABLE`: the mechanism is natural and useful, but the evidence does not
  license a headline claim.
- `RETIRED`: evidence or review rejects the mechanism for this program.
- `BLOCKED`: a named external resource prevents a scientific decision.

Negative and near-miss results are valid completion. They must inform the next
hypothesis rather than trigger weaker gates or post-hoc tuning.
