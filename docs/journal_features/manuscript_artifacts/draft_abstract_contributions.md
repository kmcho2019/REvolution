# DRAFT — Abstract + Contributions (for adaptation into the Overleaf journal_draft)

Draft content for the author to adapt — *not* the final paper, *not* pushed to
Overleaf. Calibrated to the frozen claims contract (`journal_narrative.md`) and
the confirmed findings (doc 13). Numbers trace to `tables.tex` / consolidated
record §7. Supersedes the spine sketch in doc 17 §Abstract/§Contributions
(this version incorporates the completed CVDP arc, F30–F32).

---

## Abstract

LLM-driven evolutionary RTL generation can improve power, performance, and area
(PPA), but existing systems — including our conference REvolution — rely on a
scalarized PPA objective, a hand-engineered operator suite chosen by an
un-ablated selection bandit, and small single-module benchmarks, leaving open
the question of *when* the added search machinery actually helps. We present a
rigorous characterization of quality-diversity (QD / MAP-Elites) for LLM RTL
search, together with one positive, principled contribution.
**(1)** Replacing the scalar objective with bounded per-cell Pareto fronts and
global NSGA-II non-domination-rank selection removes the weighted-sum bias and
supplies behavioral diversity at no statistically significant quality cost
versus a strong direct-code baseline (five-seed pooled $-0.016$, 95% CI
$[-0.045, +0.007]$; the NSGA-II selection component is necessary — without it
the deficit is significant).
**(2)** A single unified thought-level operator matches the six-operator suite
within QD at no measured cost ($+0.001$, CI $[-0.008, +0.011]$), supplying the
operator ablation prior work lacked.
**(3)** We characterize *regime-sensitivity*: the most aggressive thought-only
configuration loses to classic search ($-0.093$, CI $[-0.149, -0.036]$) for a
localized, mechanistically-explained reason rather than uniformly.
**(4)** On two harder benchmarks the binding constraint is the model's
spec-comprehension, not the search structure: at real-CPU (e203) scale no method
produces valid candidates on the larger modules; and on a newer cocotb benchmark
— after identifying and fixing an evaluation-harness confound that had
masqueraded as a capability ceiling — the model is capable (solving 9/10 easy
and 7/10 medium tasks) yet quality-diversity ties classic on every tier,
including the "capable-but-hard" regime where diversity was expected to pay off.
We release a pre-registered, paired-statistics evaluation harness and disclose
the measurement caveats. The contribution is an honest account of *when*
quality-diverse, thought-level structure helps LLM-driven RTL search — and when
it does not — rather than a claim that it wins.

## Contributions

1. **Smooth quality-diversity at no significant quality cost (the positive
   result).** Direct-code individuals, a MAP-Elites archive of bounded per-cell
   Pareto fronts, and global NSGA-II non-domination-rank selection form a
   diversity-preserving augmentation of classic search that is statistically
   indistinguishable from a strong baseline (5-seed $-0.016$, CI $[-0.045,
   +0.007]$; NSGA-II necessary, $+0.018$ benefit, CI $[+0.005, +0.032]$). This
   converts conference criticisms #1 (weighted-sum bias) and #5 (no diversity)
   from "implemented, value unproven" to "no-significant-cost, principled."
2. **The operator ablation prior work lacked (#2/#3).** A single unified
   thought-operator equals the six-operator EoH suite plus its un-ablated
   bandit, within QD, at parity (5-seed $+0.001$, CI $[-0.008, +0.011]$,
   leave-one-seed-out robust); the simplification is licensed within QD but
   costs $-0.092$ on the classic substrate, with a clean mechanism.
3. **A regime-sensitivity characterization (#4, central thread).** When
   thought/QD search helps versus not — competitive on spec-exact problems,
   weaker on PPA-margin ones — with a mechanism and a deficit localized to a
   few intrinsic-limitation problems, explaining (not apologizing for) the mixed
   conference result.
4. **A harder-benchmark capability finding, with a corrected confound (#4).**
   Integrating real-CPU (e203 RealBench) and newer (CVDP cocotb) benchmarks, we
   show the binding limit at scale is LLM spec-comprehension, not search; and we
   diagnose and fix an evaluation-harness interface confound that had made a
   capable benchmark look like a capability ceiling — after which quality-
   diversity is shown to tie classic across the difficulty spectrum, including
   the capable-but-hard regime.
5. **A pre-registered, reproducible evaluation methodology with disclosed
   caveats:** paired cluster-bootstrap statistics, frozen gates and decision
   rules, and an explicit account of the measurement artifacts we caught and
   corrected (token-budget asymmetry; a parallel-eval contention effect; the
   CVDP interface confound; descriptor degeneracy).
