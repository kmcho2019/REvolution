I've reviewed the full package and cross-checked its claims against the underlying T26/T27/T28/T30 evidence and the launch-readiness state on disk. Findings below.

## Bottom line

The package is a well-disciplined **pre-registration scaffold**, not yet an answer. Its own claim framework (`tables/claim_gates.md`) is sound and the RTLLM plan is mostly fair. But (a) the current evidence supports only `T1 near_classic` — every audit says so explicitly — while the report prose drifts toward a stronger read; and (b) the plan as written has two structural flaws (single seed; descriptor-vs-policy confound) that will prevent it from cleanly answering either headline question even if HV wins.

## Can it answer the two questions?

**Q1 — does diversity matter? Not cleanly, as designed.** The biggest issue is internal tension the package under-states: the lead method **wins by exploiting, not by diversifying**. T26 uses `champion_lane_fraction=0.80`, `two_parent_probability=0.00` (no crossover), and on the canonical diversity metric it *loses badly to classic* — T28 reports **9 front families vs classic's 19 (-52.6%)** and **9 front netlists vs 21 (-57.1%)** (`techniques/T28_t26_family_audit/results_report.md:56-60`). So the honest current story is "an SR-PCA archive scaffold doesn't hurt, and lifts HV/best-score when coupled to strong hill-climbing pressure" — which is nearly the opposite of a "diversity matters" headline. A positive RTLLM HV result would still not establish that *diversity* (rather than the exploit policy) caused it.

**Q2 — which diversity? Partially, and confounded.** The package names "implementation-aware / synthesis-response descriptor diversity coupled to a quality-safe archive," which is plausible. But T26 changed **both** the descriptor (SR-PCA) **and** the search policy (champion lane + no crossover) relative to the T24/T25 failures. Nothing isolates the descriptor's contribution, and the planned 2-arm RTLLM run (classic vs one T26-family bundle) cannot disentangle them either. As designed, Q2 is answered at the bundle level, not the mechanism level.

## Claim-safety of the classic-vs-T26-family plan

Genuinely good: matched `COMMON_ARGS` (same seed/model/budget/eval flow) for both arms; non-PPA BD descriptor (SR-PCA); selection-timing gate; covered-design + validity-collapse gates; small-n labeling; and T28's honesty note that classic is *not* rendered in SR-PCA archive space.

Overclaim / soundness risks:

1. **Single seed (1001) + temperature 1.0 / top_p 1.0.** Per-problem deltas are confounded by LLM sampling noise with no replication. The planned "bootstrap intervals" resample *over problems* (n=1 seed each), so they describe the cross-problem spread but cannot establish run-to-run stability — yet `claim_gates.md:24` defines `strong_win` as "statistically stable." That level is unreachable as planned. Either add ≥3 seeds (at least on the screen + a problem subset) or explicitly forbid any significance/stability language.
2. **Front-family deficit will likely recur at scale.** Because the headline diversity metric currently favors classic, this must be a *first-class* reported figure, not buried. Presenting an HV win while omitting the family-front comparison would be the single largest credibility risk.
3. **Descriptor↔policy confound** (above) — decide before launch: either scope the claim to "this bundle vs classic," or add a control arm (e.g., classic-operator + champion-lane policy, or SR-raw without the champion lane).
4. **Screening circularity.** The 3 screen problems (ALU, traffic_light, multi_pipe) are the same ones T26 was developed on *and* are inside the 50-problem full set (not held out). Selection is mildly circular and the 50-problem aggregate is not screen-independent. Label screen problems in the aggregate and also report a screen-excluded aggregate.
5. **Budget-parity is asserted on pop×gen, not LLM calls.** QD archive backfill/injection can change the effective evaluation count. Verify and log per-arm total LLM calls / eval count so "same budget" is demonstrated, not assumed.
6. **Tier inflation in prose.** T27, T28, and T30 *all* say `T1 near_classic` and explicitly **not** `T2 useful_qd`; T30 holdout shows competitive best-score but **no raw-PPA-front broadening and ~zero holdout HV gain**. `report.md:14-17` ("improves live HV/HV-AUC … holdout best score support") reads more bullish than the gates permit. Pin the report/slide claim level to `near_classic` until RTLLM lands.

## Missing artifacts before launch

- **`reviews/claude_prelaunch_review.md` is 0 bytes.** `adversarial_validation.md:31-34` requires an independent third-party review *or* a recorded command-failure note — neither is present. Gate 1 is unsatisfied.
- **No screening has run** (no `exp/useful_bd_push/rtllm_milestone_screen_*`), and **`tables/method_lineage_selection.md` does not exist.** The selection-timing gate requires the QD arm to be locked, with screen evidence recorded, *before* the full run. Currently the full run cannot legitimately launch.
- **`original_thought.txt` is staged in git but absent from the working tree** — provenance lost; restore or unstage.
- **No multi-seed in the pre-registration** — needed for any stability claim (see risk 1).
- **No control/ablation arm** to separate descriptor from policy (see risk 3) — decide scope or add the arm before freezing the plan.
- Expected-post-run-but-pre-registered tables absent: `rtllm_problem_method_metrics.csv`, `rtllm_aggregate_deltas.csv`, `validity_gate_table.csv` (fine to be empty now; flag so they aren't forgotten).

## Visualization / table requirements

The planned figure set (`figures/README.md`) is appropriate; strengthen it:

- **Front-family count + delta (classic vs QD) as a first-class figure**, not just HV. The schema already has `unique_front_families`/`unique_front_netlists` — surface them visually, since this is the adverse metric.
- **Win/loss heatmap must carry validity and family columns**, not HV alone, so a per-problem HV win that comes with a family/yield loss (the traffic-light pattern: -3.48% best, -25 valid-PPA pts) is visible rather than masked.
- **Valid-PPA funnel with absolute counts + denominators and small-n labels** per `planned_metric_schema.csv` (`small_n_validity`), so yield collapses are legible.
- **Pareto panels colored by implementation family**, showing only valid, non-duplicate rank-1 markers — this makes T28's "fewer distinct front markers" point checkable.
- **Per-arm evaluation-count + runtime parity table** to substantiate "same budget."
- **Bootstrap-CI tables must state the resampling unit** (over 50 problems, 1 seed) to avoid implying seed-level significance.
- **Archive coverage / QD-score + the Phase 03.1 `qd_ppa_viewer` bundle** for the QD arm, keeping classic out of SR-PCA space (per T28).
- Every figure still needs its required **visual-inspection note** (`claim_gates.md:16`); none exist yet.

One framing suggestion for the deck: lead the conclusion with "the archive scaffold is *quality-safe and HV-positive but not yet diversity-positive on the PPA front*," which is exactly what the evidence supports and pre-empts the most obvious reviewer attack.
