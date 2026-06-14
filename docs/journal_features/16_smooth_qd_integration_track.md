# 16. Smooth QD Integration Track — design & specs

**Status:** OPEN design track started 2026-06-14 (user-initiated). Goal:
salvage QD/MAP-Elites as a POSITIVE contribution by integrating it
*smoothly* into the classic REvolution baseline, instead of the radical
`thought_only` break that loses to classic (F1/F15). Records the design,
variant ladder, the NSGA-II selection spec, the implementation plan
(kept deliberately minimal), and the evaluation protocol. The frozen
claims contract (`journal_narrative.md`) still wins on any conflict; this
track may *propose* a contribution but cannot change frozen gates.

## 1. Motivation & diagnosis recap

The journal QD version changed THREE things at once vs classic:
1. **Representation:** `thought_only` (thought→code indirection).
2. **Search/selection:** MAP-Elites archive *replacing* classic's
   population + elitist selection.
3. **Operators:** one unified operator replacing the EoH suite + bandit.

Diagnosis (F7/F8/F12): the damage is from **(1) indirection** (the
thought poisons all k realizations; the champion is never refined
directly) and the **selection-dilution in (2)**. The BD/archive itself
is NOT the PPA lever (F12). So the *actual QD contribution* (archive +
behavioral-descriptor diversity, Pareto-structured cells) was never the
problem — it was dragged down by the representation/selection changes
bundled with it.

**User design intent (2026-06-14):**
- DROP `thought_only` + unified operator if they don't pull their weight.
- KEEP/BUILD ON: a *light* MAP-Elites overlay + Pareto cells + an
  **NSGA-II non-domination-rank selection** (fill rank 1, then rank 2, …
  to a sampling-size cap; within the cut-off rank, tie-break by crowding
  distance, preferring higher distance).
- Target: do NOT undermine classic performance, but answer the
  methodological criticisms (weighted-sum bias #1, no-diversity #5) with
  principled multi-objective selection + diversity coverage.
- Keep the code from becoming convoluted; reuse existing machinery.

## 2. Design principles

- **Classic quality path stays intact.** Direct-code individuals
  (`representation_kind=code_individual`), classic multi-operator suite
  (`qd_operator_kind=eoh_strategies`), champion refinement preserved
  (`qd_champion_lane_fraction>0`). This protects the performance that the
  radical version lost.
- **QD is an OVERLAY, not a replacement.** The MAP-Elites archive +
  BD trio provide diversity coverage and Pareto-structured cells; they
  augment selection rather than dictating it alone.
- **Principled selection replaces scalar fitness.** NSGA-II
  non-domination rank + crowding distance answers criticism #1
  (weighted-sum bias) without a scalar PPA weight, and supplies the
  diversity pressure of criticism #5 — while staying close to a strong
  EA selection regime (so performance need not collapse).
- **Minimal, flag-gated code.** Reuse `pareto_analysis.dominates` /
  `pareto_ranks` and `engine._crowded_tournament`; add at most ONE new
  selection mode behind a flag. No new representation, no new operator.

## 3. Variant ladder (each compared to the SAME classic baseline)

- **V0 — classic baseline.** `exp/ablation_matrix/classic` (exists). The
  performance bar all variants must match (parity) or beat.
- **V1 — code_individual QD overlay (RUNNING, F22).**
  `revolution_qd + code_individual + eoh_strategies +
  qd_champion_lane_fraction 0.5 + pareto_front cells + BD trio`.
  Drops thought_only + unified operator; keeps classic machinery + the
  archive. `exp/fast_iter/smooth_qd_code_individual` (seed 1001 vs
  classic seed 1001). **This is the cheapest test of the whole thesis:**
  if V1 reaches parity, the indirection was indeed the culprit and QD
  survives as a parity+diversity contribution with NO new code.
- **V2 — V1 + NSGA-II global non-domination-rank selection (SPEC below;
  needs implementation).** Replaces the per-cell crowded-tournament parent
  sampling with global NSGA-II rank+crowding selection. Tests the user's
  specific selection idea. Gate it behind V1's result (only build if V1
  shows a residual gap that better selection could close, OR to
  strengthen the methodological story even at V1 parity).
- **V3 (optional) — overlay weighting knobs.** If V1/V2 are close but not
  parity: tune `qd_champion_lane_fraction`, archive parent fraction, or
  number of BD cells (lighter overlay). No structural change.

## 4. NSGA-II global rank selection — detailed spec (V2)

**Intent.** Select the parent pool by classic NSGA-II environmental
selection applied across the archive's full membership, not scalar
fitness and not only per-cell Pareto.

**Algorithm (per generation, to fill a parent pool of size N):**
1. Collect the candidate set S = all successful archive members
   (optionally union the current generation's successes).
2. Compute the non-domination fronts of S over the objective vector
   (the QD objectives, e.g. PPA components — the SAME objective space the
   Pareto cells already use). Reuse `pareto_analysis` (fast-non-dominated
   sort = repeatedly peel `non_dominated` sets, assigning rank 1,2,…).
3. Add whole fronts in rank order (rank 1, then 2, …) to the pool until
   adding the next front would exceed N.
4. For the boundary front that doesn't fully fit: compute crowding
   distance within that front and take the highest-distance members to
   reach exactly N (reuse the crowding logic behind `_crowded_tournament`).
5. Draw parents from the pool (uniform, or rank-weighted) for the
   operator. The MAP-Elites cells remain as the DIVERSITY OVERLAY (they
   still gate archive insertion / coverage reporting) but no longer drive
   parent selection alone.

**Crowding distance (standard NSGA-II):** per objective, sort the front,
assign boundary points ∞, interior points the normalized neighbor gap
sum; prefer larger distance (less crowded → more diverse).

**Why this is a "smooth" change.** It swaps ONLY the parent-selection
rule; representation (direct code), operators (EoH suite), evaluation,
and the archive structure are unchanged. It is the classic multi-objective
EA selection — a well-understood regime unlikely to collapse performance.

## 5. Codebase support inventory (what exists vs what's needed)

EXISTS (reuse, do not reinvent):
- `representation_kind=code_individual` (direct code) — DEFAULT, untested
  as a QD arm. Enables V1 with no code change.
- `qd_operator_kind=eoh_strategies` (classic multi-operator suite).
- `qd_champion_lane_fraction` (champion refinement / elitism).
- `qd_cell_mode=pareto_front` + `qd_max_elites_per_cell` (per-cell Pareto).
- `pareto_analysis.dominates`, `pareto_analysis` non-dominated set,
  `pareto_ranks` (non-domination ranking).
- `engine._crowded_tournament` (crowding-distance-aware selection),
  `_sample_success_parents` / `_sample_two_success_parents` (current
  per-cell parent sampling — the insertion point for V2).

NEEDS IMPLEMENTATION (V2 only, minimal):
- A global fast-non-dominated-sort + crowding selection over the archive
  membership (compose the existing `dominates`/crowding helpers).
- One flag, e.g. `--qd_parent_selection {cell_crowded_tournament,
  nsga2_global_rank}` (default = current behavior), routing
  `_sample_success_parents` to the new path when set.
- Pool-size cap parameter (default = population_size).

## 6. Implementation plan (clean, gated, reversible)

1. **First, get V1's result** (running). If V1 reaches parity, the core
   thesis is proven with ZERO new code — V2 then only *strengthens the
   methodology story*, not rescues performance.
2. **V2 implementation (only when warranted):** add the single selection
   flag + one helper `_nsga2_global_pool(members, pool_size)` in engine.py
   that (a) fast-non-dominated-sorts via `pareto_analysis`, (b) fills by
   rank, (c) crowding-trims the boundary front. Route
   `_sample_success_parents` through it under the flag. ≤ ~60 lines,
   reusing existing dominators/crowding. No new files unless the helper
   grows; if it does, put it in `pareto_analysis.py` (its natural home).
3. **Tests:** unit-test the global pool on a tiny synthetic objective set
   (front ordering + crowding tie-break correctness) under
   `tests/revolution/`.
4. **No convolution rule:** if V2 needs more than one flag + one helper,
   stop and re-spec — it means the abstraction is wrong.

## 7. Evaluation protocol

- **Baseline:** the existing classic arm (same seeds, same 13-problem
  fast subset, same budget — pop 20 × 5 gen, 32768 tokens). Same provider
  both arms (OpenRouter gpt-oss-120b) per the standing rule.
- **Parity criterion (frozen):** pooled cluster-bootstrap best-quality
  delta, CI low > −0.03 = parity; CI low > 0 = better (F2 rule).
- **Diversity readout:** archive BD coverage + # distinct
  equivalence-checked solutions (the contribution's positive claim),
  reported alongside parity.
- **M12 RELIABLE EVAL (mandatory):** isolated re-verify the best
  candidate per arm/problem before trusting counts; cap concurrency.
  Never trust raw parallel-run valid counts at high worker counts.
- **Sequence:** V1 (seed 1001) → if parity, extend seeds for power; build
  V2 only per §6.1.

## 8. Reframed contribution (if V1/V2 reach parity)

> "Quality-diversity as a *diversity-preserving augmentation* of a strong
> direct-code evolutionary RTL search: NSGA-II non-domination-rank
> selection over a MAP-Elites archive removes the weighted-sum PPA bias
> (#1) and supplies behavioral diversity (#5) **at quality parity with
> the classic baseline** — not a quality win, but a principled,
> no-cost methodological upgrade plus diverse equivalent solutions."

This is honest and POSITIVE: it does not claim "QD beats classic on
quality"; it claims parity + a cleaner objective handling + diversity.
It directly answers criticisms #1 and #5 without the indirection that
sank the radical version.

## 9. Decision log & open questions

- 2026-06-14: track opened; V1 (code_individual overlay) launched as the
  cheapest test (F22). thought_only + unified operator are droppable per
  user; this track does not use them.
- OPEN: does V1 reach parity? (pending) — decides whether V2 is a rescue
  or a methodology-strengthener.
- OPEN: pool-draw rule in V2 (uniform vs rank-weighted) — pick after V1.
- OPEN: should the archive cells stay grid_quantile or simplify to a
  pure NSGA-II population with BD only for reporting? Keep cells for now
  (the diversity coverage claim needs them); revisit if V2 underperforms.
- CONSTRAINT: keep ≤ one new flag + one helper (§6); re-spec if larger.
