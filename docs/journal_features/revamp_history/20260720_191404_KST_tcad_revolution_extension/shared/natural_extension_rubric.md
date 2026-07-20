# Natural Extension Rubric

## Hard Rejection Conditions

Reject a proposal before live experiments when any condition is true:

1. It is not tied to an evidence-backed conference weakness or scope gap.
2. It requires problem IDs, benchmark names, or per-design thresholds in search.
3. It uses hidden tests, final outcomes, or reference PPA to guide search.
4. It changes model, budget, evaluator, or coverage without a paired control.
5. It is a generic algorithm transplant with no REvolution-specific mechanism.
6. Closely related work already contains the claimed central contribution and
   no clear delta remains.
7. Its causal mechanism cannot be isolated or measured.
8. It depends on fallback ladders, many optional states, or compatibility modes.
9. It adds more than two knobs without an accepted simplicity exception.
10. It is an adjacent parameter scan, stacked near-misses, or a renamed retired
    mechanism.

## Scored Criteria

Score each item 0, 1, or 2. Require at least 11/14, with no zero for conference
continuity, evidence-backed need, hardware/CAD grounding, novelty, or
simplicity.

1. **Conference continuity:** directly corrects or extends a documented classic
   state, population, operator, feedback, objective, or task boundary.
2. **Evidence-backed need:** code, ablation, baseline, or reviewer evidence shows
   why the current component warrants attention.
3. **Hardware/CAD grounding:** the mechanism follows RTL functionality,
   synthesis behavior, PPA tradeoffs, or a defensible search principle.
4. **Generality:** it applies across design classes without per-problem behavior.
5. **Mechanistic clarity:** telemetry and a control can falsify the causal story.
6. **Implementation simplicity:** one narrow typed path, little state, at most
   two knobs, no fallback, and clean removal if retired.
7. **Novelty and paper value:** the related-work delta supports a substantive
   algorithmic, reliability, or generalization contribution.

## Review Procedure

At least two independent read-only reviews must challenge the card before it
becomes `READY`: one TCAD novelty/naturalness review and one hardware/EDA or
methodology review. The owner records each finding as `ACCEPT`, `REJECT`, or
`DEFER` with evidence. Reviewer agreement is not a substitute for checking code,
artifacts, and primary literature.
