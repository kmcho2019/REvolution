# Narrative Adversarial Review — Rounds 2 and 3 (2026-06-12)

## Round 2 (narrative revision 2)

All four personas: **BLOCK**, but every round-1 issue except two was judged
RESOLVED. Consolidated round-2 blocks and fixes applied:

1. Branch table non-monotone at `REF_PARITY` + exactly-1-task deficit
   (fell to Branch C while a 2-task deficit reached Branch B-scoped) —
   flagged independently by editor, Reviewer 2, and statistics personas.
   FIX: row 4 condition changed to "(`REF_WIN` or `REF_PARITY`) and not
   `NEW_OK`" with an explicit monotonicity statement.
2. Operator-ablation contradiction: claims table promised a QD-substrate
   six-vs-unified contrast while the matrix only had classic+unified; no
   seeds or parity criterion. FIX: added the full-QD six-operator arm
   (`qd_operator_kind=eoh_strategies`) as the explicit licensing contrast,
   protocol seeds 1001–1003, and a predeclared parity criterion (penalized
   cluster CI entirely above −0.03; parity = within ±0.03) shared with
   Branch C floor leg (i).
3. EDA: eff_clk_period disclosure incomplete (piecewise: 0.0 when WNS ≥ 0,
   pinned for combinational; reg2reg-only constraints, no I/O delays) and
   per-unit axis composition undeclared for combinational units. FIX:
   measurement model now states the piecewise definition, constraint
   scope, and the axis-composition rule (avg-PPA drops the degenerate
   period axis; HV computed over the two non-degenerate axes for
   combinational units — drop, never zero-fill — identical in both arms).
4. Reviewer 2: gate-bearing HV/Pareto pool and per-unit definition absent
   from the contract; real implementation asymmetry found (QD thought-mode
   generation logs record representatives + fail parents only, omitting
   k−1 evaluated samples, while classic logs all successful candidates).
   FIX: pool declared as full evaluated successful-candidate history for
   both arms; the QD logging gap is named as a predeclared prerequisite
   engine fix before finals (log every evaluated sample's PPA details);
   HV definition pinned (reference-normalized improvement space,
   zero-improvement reference point).
5. Statistics: LOSO claimed but not implemented (only per-seed
   complete-case means). FIX: `report_journal_statistics.py` now
   recomputes the penalized gate statistic leave-one-seed-out (floor
   re-resolved within each replicate, the correct counterfactual) emitted
   as `leave_one_seed_out_penalized`, plus epsilon-sensitivity rows
   (1e-6/1e-12) for the HV log-ratio; regression test added.
6. Smaller predeclaration gaps closed: CVDP 30-task selection rule pinned
   (seeded category-stratified, seed 1337, debug ids excluded); RealBench
   probe sufficiency conditions stated inline; `REF_WIN` avg-PPA clause
   names its statistic; Branch B utility metric tightened to
   non-domination + strict improvement with a ≥0.25 fraction requirement;
   missing-baseline text aligned with the implementation (conservative
   exclusion, reported by count).

## Round 3 (narrative revision 3)

- TCAD editor: **SIGNOFF** (both round-2 issues resolved; table verified
  monotone by enumeration).
- Hardware/EDA methodology: **SIGNOFF** (disclosures verified
  implementation-faithful against evaluation.py/flow.tcl; advisory
  clarification on combinational HV wording).
- Reproducibility/statistics: **SIGNOFF** (LOSO verified by independent
  recomputation including the floor-re-resolution case; epsilon rows
  verified; advisory notes recorded).
- Skeptical Reviewer 2: **BLOCK** on one residual clause — "period
  coordinate fixed at 0" for combinational HV contradicted the
  implementation's drop-to-2D (numerically material: zero-filled 3D HV
  collapses to 0). Also: `qd_operator_kind` value corrected to
  `eoh_strategies`; regression-test request.

Round-3 fixes applied in narrative revision 3: combinational HV clause
rewritten to the two-non-degenerate-axes rule (matching the avg-PPA
convention and the code); operator-kind value corrected; status header
documents the HV robustness artifacts; multi-pair LOSO + epsilon test
added (`test_multi_pair_emits_loso_and_epsilon_sensitivity`).

## Round 4 (focused Reviewer 2 re-check) — SIGNOFF

Reviewer 2 verified all three round-3 fixes against the implementation
(`objective_metrics_for_reference` drop-to-2D at the same 1e-12 threshold
as the avg-PPA path; `eoh_strategies` literal accepted by the engine
validator; epsilon-sensitivity + zero-HV-count robustness artifacts and
per-replicate LOSO floor re-resolution implemented and pinned by the
passing regression test) and found no new contradictions.
**VERDICT: SIGNOFF.**

## Final status

All four personas have signed off: TCAD editor (round 3), hardware/EDA
methodology (round 3), reproducibility/statistics (round 3), skeptical
Reviewer 2 (round 4). The narrative (revision 3) is ACCEPTED as the claims
contract per the goal spec. Gate thresholds, branch rules, pool
definitions, and budget rules are now frozen pending the predeclared
pre-freeze artifacts (MDE analysis, descriptor report, held-out set
construction, QD logging fix).

## Predeclared implementation obligations extracted from review

- Engine fix before finals: QD thought-mode generation logs must record
  every evaluated code sample's PPA details (k−1 samples currently
  omitted) so both arms' evaluated histories are structurally identical.
- MDE analysis artifact before the freeze (one-way ratchet: counts may
  rise, never fall; infeasible gate → claim dropped).
- Yosys equivalence spot-check tooling for showcased candidates + sampled
  10% of archive elites.
- Descriptor-objective correlation quantification in the pre-freeze
  descriptor report.
- Build the 20-problem held-out reference-PPA set (excluding hard-subset
  AND fast-iteration-subset problems) and the 30-task fresh CVDP final
  slice (seed 1337 rule).