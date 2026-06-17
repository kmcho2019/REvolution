# DRAFT — Introduction section (for adaptation into the Overleaf journal_draft)

Draft content for the author to adapt — not the final paper, not pushed to
Overleaf. Calibrated to the frozen claims contract and the findings. Pairs with
the Abstract/Contributions draft (avoid duplicating the contribution wording
verbatim when assembling).

---

## 1. Introduction

Large language models have made it possible to search the space of register-
transfer-level (RTL) designs by generation rather than by hand, and recent
evolutionary systems have shown that iteratively proposing, evaluating, and
recombining LLM-generated RTL can improve power, performance, and area (PPA)
beyond a single prompt. Our own conference system, REvolution, is one such
system: it evolves designs through LLM-driven operators, scores candidates by a
scalarized PPA objective, and selects among a suite of hand-engineered prompt
operators using an adaptive bandit.

That work drew several pointed criticisms that this paper sets out to address
directly. First, a *scalarized* PPA objective bakes a fixed weighting into the
search and can hide trade-offs that a designer would want to see. Second, the
six prompt operators were chosen by hand and their selection bandit was never
ablated, so it is unclear whether the machinery earns its complexity. Third, and
relatedly, the claimed benefit of adaptive operator selection was asserted
rather than measured. Fourth, the benchmarks were small, single-module designs,
leaving open whether any of the search structure matters at the scale and
difficulty of real hardware. Fifth, the system produced no explicit notion of
*diversity* among candidates, despite diversity being a plausible source of its
value.

A natural response to the first and fifth criticisms is quality-diversity
(QD / MAP-Elites): replace the scalar objective with an archive of behaviorally
diverse, Pareto-optimal solutions. The appeal is clear — no weighted-sum bias,
explicit diversity, and a structure that *could* pay off precisely on the larger,
more architecturally open designs the small-benchmark criticism was about. The
central question of this paper is whether that appeal survives contact with
rigorous, pre-registered evaluation: *when* does quality-diverse, thought-level
structure actually help LLM-driven RTL search, and when does it not?

Our answer is a characterization rather than a triumph, and it is more useful for
it. We find that a *smooth* integration of quality-diversity — direct-code
individuals, bounded per-cell Pareto fronts, and principled NSGA-II selection —
is a no-significant-cost diversity augmentation that removes the scalar-weight and
operator-selection degrees of freedom and supplies the operator ablation prior
work lacked; that the most aggressive thought-only variant loses to classic
search, for a localized and mechanistically-explained reason; and that on two
harder benchmarks — real-CPU e203 modules and a newer cocotb suite — the binding
constraint is the language model's spec-comprehension, not the search structure.
Along the way we identify and fix an evaluation-harness confound that had made
one capable benchmark look like a capability ceiling, and we release a
pre-registered, paired-statistics evaluation harness with the measurement caveats
disclosed. The contributions are summarized in Section [Contributions]; the rest
of the paper presents the method (Section 3), the results (Section 5), and a
discussion of why quality-diversity ties but does not win across the difficulty
spectrum (Section 6).
