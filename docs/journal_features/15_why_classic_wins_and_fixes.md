# 15. Why Classic Wins — Mechanism and Fix Plan

**Purpose.** A data-grounded causal diagnosis of the QD-vs-classic
best-quality deficit (F1) and a ranked, concrete plan to reach parity.
Written 2026-06-13 from the ablation-matrix generation trajectories. The
deficit is **mechanistic and tunable, not fundamental** — this is the
constructive answer to "can we make the journal direction at least match
classic."

## The decisive evidence: QD never refines its champion

Per-generation cumulative best quality, classic vs `qd_target`, seed 1001
(same problems, same budget; `(gen, cum_best, n_evaluated)`):

| Problem | classic | qd_target |
| --- | --- | --- |
| adder_8bit | gen1 **0.33**, holds | flat **0.14** all 6 gens (n=19–20/gen) |
| circuit7 | 0.012 → **0.332** at gen3 | flat **0.012** all 6 gens |
| m2014_q6b | 0.123 → **0.186** | flat **−0.013** all 6 gens |
| multi_pipe_8bit | 0.072 → 0.236 | **0.254 → 0.512** at gen3 (QD wins) |

**The pattern**: on the losses, QD's best candidate *never improves past
generation 0* — it evaluates 18–20 candidates per generation and not one
beats its own gen-0 seed. Classic, evaluating *fewer* candidates (7–19),
reliably climbs. So the deficit is **not** an effort/budget shortfall
(QD spends ≥ as much; M2 confirms +20–38% tokens). It is that **QD's
offspring do not incrementally improve the winner.**

## Two confirmed mechanisms

**M-i. Parent-selection dilution (coverage pressure pulls effort off the
champion).** QD samples parents from diverse archive *cells*, not the
champion: adder_8bit offspring came from `archive` (25) + `seed` (5),
none targeted at "improve the current best." MAP-Elites spends budget
filling/maintaining diverse cells — on small problems with no real
design-space breadth (F7) that is pure tax with no coverage payoff.

**M-ii. Indirection penalty (thought-only regenerates code from scratch).**
The thought-only realization template explicitly says *"Do not read or
refer to parent code."* Code is re-derived from the thought every time,
so a good candidate's accumulated low-level PPA optimizations are
**discarded each generation**; only the architectural thought survives.
There is no code-level hill-climbing by design. Classic's M-R (refactor),
M-I (improve), M-S (simplify) operate *directly on the winning code* and
refine it incrementally.

Together: QD keeps generating fresh alternative architectures (most
worse) for diverse cells, and even when it revisits a good idea it
rebuilds the code from scratch rather than refining it — so the champion
stalls.

## This sharpens the regime story (F4), it doesn't contradict it

`multi_pipe_8bit` is the tell: QD wins (0.254→0.512) because the gain
there is an **architectural leap** (re-pipelining), exactly what
thought-level exploration is good at. QD loses on adder/circuit7 because
those gains are **code-level refinement** of a fixed architecture
(bit-level/structural tweaks) — which thought-only cannot express.

> **Refined thesis:** thought-level QD excels at architectural leaps and
> fails at code-level refinement, because it evolves the spec and rebuilds
> the implementation. Classic excels at refinement and lacks structured
> diversity. The journal win condition is to give QD *both* — keep
> thought-level exploration AND add code-level refinement.

## Fix plan (ranked by expected leverage)

**Fix B — Thought-guided incremental realization (biggest lever).** Let
the realization start from the parent candidate's best *code* (diff-mode)
instead of whole-mode regeneration, with the thought steering direction.
Restores the code-level hill-climbing classic has and QD threw away.
Tension: relaxes thought-only "purity" (conference contribution #1) —
frame as a *journal refinement* ("thought-guided incremental
realization"), not a retreat. One-factor screenable on the signed-off
fast instrument exactly like R-A′/R-B. **Try first.**

**Fix A — Champion lane (elitist parent selection).** Reserve a fraction
of each generation's budget to refine the current global-best (and/or
per-cell best) rather than pure diverse sampling. Standard
elitist/directional MAP-Elites enhancement; concentrates effort on the
winner while keeping coverage. Tunable in the parent-selection path.

**Fix C — Budget reallocation (k and exploration fraction).** Lower k
(fewer discarded realizations per thought) and/or reduce the
diversity/exploration fraction, redirecting budget to champion
refinement. (k=2 screen DEMOTED but was degraded; re-screen cleanly with
Fix B in place.)

**Fix D — Two-phase / interleaved.** Architectural-exploration phase (QD
as-is) followed by an elitist refinement phase (Fix A+B) on the archive's
best cells. Keeps the diversity/coverage claims and adds the refinement
that wins on PPA.

## Recommended order

1. **Fix B** as a one-factor fast-subset screen (highest leverage, cleanest
   to isolate). If it reaches PROMOTE, hard-subset pair.
2. **Fix A** (champion lane), independently and stacked with B.
3. Re-screen **Fix C** with B/A in place.
4. If B or A reach parity on the hard subset → re-open Branch A/B; the
   "loses to the prior version" problem dissolves. If they reach parity
   AND the RealBench large-design experiment (doc 14, M8) shows a QD
   diversity win, the journal has both a competitive-PPA story and a
   diversity-pays-off-at-scale story.

## Honest caveat

Parity is *achievable in principle* by these fixes, but Fixes B and D
relax the strict thought-only/pure-QD design. The team should accept that
the winning journal configuration is likely **thought-level exploration +
code-level refinement + elitist coverage**, not pure thought-only QD —
which is a *better, more defensible* method than the original, not a
concession.
