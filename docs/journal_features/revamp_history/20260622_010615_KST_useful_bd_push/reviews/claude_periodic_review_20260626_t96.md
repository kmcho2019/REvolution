I have enough to complete the review. Let me cross-check one numeric detail — whether T96's nearest sibling (T83) comparison is represented — by confirming T83's single-seed HV versus T96's.

The data is clear. Here is my review.

---

# Claude Periodic Review — T96 Checkpoint (RF/DeepGate Hybrid Delayed Probe)

**Scope:** read-only adversarial review of the useful-BD push at the T96 checkpoint. No files edited. (Note: `reviews/claude_periodic_review_20260626_t96.md` exists but is empty (0 bytes); per the read-only instruction I am returning this review inline rather than writing it.)

## Verdict: **pass-with-actions**

The push remains honest and on-mission: T96 is correctly **not promoted**, the selection status plainly states "no QD configuration is currently promoted," the headline comparison is genuinely reference-complete (no defaulted-reference loophole), and the pre-registered retire-if-loses rule was followed. The numbers I re-derived from the CSVs match the prose. But several findings — one of them a selective-comparison framing issue — should be tightened before this feeds colleague-facing review or final RTLLM selection.

## Answers to the six review questions

1. **Still aligned with the goal?** Yes. The goal sanctions "a rigorous negative map of failed technique families," and that is exactly what is accumulating. No premature sign-off; the Minimum-Goal-Completion and central-comparison TODO items are correctly still open. One soft drift (Finding C): T96 is, by its own decision text, "another minor axis substitution," which the strategy guidance warns against.
2. **Is T96 packaged honestly?** Mostly yes, with one real gap (Finding A): the package repeatedly frames T96 as *"improves over pure T95 DeepGate (0.1199 vs 0.1153)"* but never states that it **regresses against its nearest sibling T83 (0.1369 single-seed, same seed 1001)** — and that its own pre-registration required improvement over *both* T83 and T95. The reference-completeness claim is solid: all 8 problems `headline`, `reference_ppa_valid=yes`, both arms valid. No defaulted-reference issue.
3. **Selection docs — one rep per category + top-10 mean-HV?** Yes. 12 single-member category rows and a monotonic top-10 by mean HV. Two caveats (Findings D/E): the top-10 mixes single-seed and three-seed mean-HV values and ranks an **unreplicated** single-seed number (#1 `masterrtl_delayed_archive_activation_8x5` 0.1324) above replicated arms, when replication history shows single-seed numbers regress (~0.1339→0.1261). Minor naming drift (`rf_deepgate_hybrid_delayed_8x5` vs `T96_…`).
4. **Visualization/inspection sufficient for colleagues?** Partly. The strict non-browser viewer validation passed and the direct-PPA `Prob045_alu` figure is inspected and on-message. But (Finding B) the **20260625 review bundle is stale** (Jun 25, predates the entire T83–T96 sequence; the TODO refresh item is still open), and the `visual_parity_report.md` reference baselines are all `missing`, so it is a screenshot inventory, not a parity verification. The archive-hover smoke "found no occupied archive cell target" again (carried from T95).
5. **Bloat / over-defensive / hard to skim?** The *code* simplicity feedback from the prior review was acted on (FG-QDM credit constants / defensive metadata defaults — TODO checked). The *docs* are the sprawl risk: `current_selection_status.md` (297 lines) and `best_current_techniques.md` (350 lines) carry full per-T narrative, and the TODO is 733 lines despite its own skim rule. Not severe, but trending toward unskimmable.
6. **Next actions:** see action list below.

## Top findings (by severity)

**A — MEDIUM — T96's regression vs its nearest sibling T83 is omitted from every summary.** T96 = T83 with `rtltimer_wire_density` swapped for `deepgate_pool_pc0`, same coupling, same seed 1001. T83 scored 0.1369; T96 scored 0.1199 — the DeepGate axis made the RF-model-state descriptor *worse*. The pre-registration's decision rule explicitly demanded improvement "over **both** T83 and T95"; T96 failed the T83 leg outright, yet the results report, selection status, and best-techniques all narrate only the favorable T95 comparison. The conclusion (retire, don't promote) is still correct, so this is framing, not fabrication — but it reads as selective highlighting of the one win. This is the single most reviewer-vulnerable wording in the package.

**B — MEDIUM — Stale colleague-facing review bundle.** `reviews/20260625_review_bundle/` (and `.zip`) is dated Jun 25 and predates T83/T84/T85/T86/T87/T95/T96. The TODO item to "refresh or supersede the 20260625 review bundle … before using it for colleague-facing review" is unchecked. Anyone handed the bundle today gets a view that is ~13 negative screens out of date.

**C — LOW/MEDIUM — HV-win-count metric is asymmetric and the label overstates classic.** In `aggregate_backend_metrics.csv` classic `hypervolume_win_count = 6` but classic strictly wins only **3** problems (041/045/049); the other 3 are ties (015, 116, 135 — two are zero-HV combinational). Classic's count uses `≥` (wins+ties); T96's count uses strict `>` (=2). The convention is anti-gaming-*safe* (QD must strictly win), but reporting "HV Wins: classic 6 / T96 2" with two different operators is internally inconsistent and makes the gap look more lopsided than the real 3-win / 3-tie / 2-win split. T95's "7 vs 1" almost certainly shares this convention.

**D — LOW — Top-10 ranks an unreplicated single-seed number at #1.** `masterrtl_delayed_archive_activation_8x5` (0.1324, single seed) sits above the three-seed-replicated arms (0.1261, 0.1260). The doc flags it "single-seed," but given that the structurally similar high-exploit arm fell 0.1339→0.1261 under replication, the #1 slot is likely to evaporate on replication and should be annotated as such.

**E — LOW — >50% valid-PPA yield drops not surfaced as warnings.** `ppa_completeness.csv` shows QD valid-PPA collapses on Prob015 (24→10, −58%) and Prob045 (36→11, −69%) with classic ≥10 passing — the anti-gaming policy's yield-warning trigger. The requirement is scoped to *promoted* methods, so T96 (T0) does not strictly violate it, but a screen package that reports the raw counts without flagging the drop is leaving an honesty surface on the table.

**F — LOW — Doc skimmability debt** (see Q5). Per-T prose is accreting in the operational selection docs faster than it is being demoted to history.

## Concrete action list (most rigor-improving first)

1. **Add the T83 comparison to the T96 conclusion** (results report, selection status, best-techniques): state "T96 = T83 with DeepGate substituted for wire-density; single-seed HV 0.1199 vs T83 0.1369 — the DeepGate axis regressed the RF descriptor, and per pre-registration (improve over both T83 and T95) the T83 leg failed." This converts a soft spot into a clean negative result.
2. **Refresh/supersede the 20260625 review bundle** to cover through T96 (or mark it explicitly `SUPERSEDED — pre-T83`), and close the open TODO item, before any colleague-facing use.
3. **Report HV outcomes as wins/ties/losses** (3/3/2 for T96) or relabel the column "classic ≥ / QD strict-win," and apply the same fix retroactively to the T94/T95 rows so the timeline is consistent.
4. **Honor the goal's "materially different mechanism" bar for the next spend:** stop single-axis descriptor substitutions on the delayed-high-exploit schedule and run the already-pre-registered adaptive/stagnation-triggered archive-pressure arm, replicated at seeds 1002/1003 from the start (single-seed → replication regression is now a well-established pattern; don't pay full RTLLM budget on a single-seed clue).
5. **Add a yield-warning column** to the screen completeness surface so >50% valid-PPA drops (classic ≥10) are visible in every screen, not only in promoted-method gating.

## Claim wording to tighten

- **"improves over pure T95 DeepGate (`0.1199` vs `0.1153`)"** → add: *"…but regresses versus the sibling T83 (`0.1369`, same seed), so adding the DeepGate axis did not help the RF model-state descriptor."* (results_report.md, current_selection_status.md, best_current_techniques.md)
- **"HV Wins | classic 6 | T96 2"** → *"HV: classic 3 wins / 3 ties / 2 losses (ties counted to classic under the ≥ convention)."*
- **Top-10 row 1** `masterrtl_delayed_archive_activation_8x5` Read → append *"single-seed only; unreplicated, likely to regress under replication."*
- **Pre-registration decision-rule satisfaction** should be stated explicitly in the decision section: *"Pre-registered rule required clear improvement over both T83 and T95; T96 met neither classic nor T83 — retired as registered."* Right now the decision text only invokes the "minor axis substitution" half of the rule.

Net: the checkpoint is trustworthy and correctly negative; the actions above mainly close framing and freshness gaps, not correctness ones.
