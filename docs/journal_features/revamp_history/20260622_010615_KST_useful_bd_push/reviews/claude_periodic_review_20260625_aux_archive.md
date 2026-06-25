# Claude Periodic Review 20260625 Aux Archive

Command: `timeout 900 claude -p "$(cat docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/reviews/claude_periodic_review_20260625_aux_archive_prompt.md)"`

Started: `2026-06-25T23:09:47Z`

---
# Claude Periodic Review — Useful-BD / QD / MAP-Elites Push

**Timestamp:** 2026-06-25 · read-only · branch `feat/journal-useful-bd-exp-20260622` · HEAD `01ff032823`

## Verdict: **PASS_WITH_ACTIONS**

The push is **honest, rigorous, and appropriately negative**. Pretrained-encoder claims hold up under code-level scrutiny (the single most important question), metric hygiene is strong, and commits/coding follow `AGENTS.md`. It is **not** yet finished enough to select final full-RTLLM QD configs, and the colleague-facing review bundle has a staleness gap that would mislead a reviewer. None of the findings indicate dishonesty; they are scope/power/packaging gaps to close before sign-off.

---

## Answers to the seven questions

**Q1 — Plan finished enough to pick final RTLLM configs? → No.** Every screened QD arm loses classic. The strongest (`masterrtl_aux_archive_high_exploit_8x5`) is **−4.78%** mean HV (0.1339 vs 0.1406), and that "lead" is carried by one problem (below). Front-breadth and depth follow-ups regress to **−19.3%** and **−27.7%**. All single-seed. See hard-data gaps.

**Q2 — Pretrained encoder claims honest? → Yes (strong).** Code-traced lane by lane:
- **Qwen** — genuinely loaded + live-wired: `src/revolution/qwen_descriptor_evaluator.py:113-128` instantiates `SentenceTransformer("Qwen/Qwen3-Embedding-0.6B")` and is invoked from `qd/engine.py` and `runtime/candidate_evaluator.py`. The only real neural `from_pretrained` in the live runtime. Honestly reported as **losing** the screen (0.1108 vs 0.1406).
- **DeepGate** — real `python-deepgate` `load_pretrained()` + forward pass, but **only in offline probes**; disclosed as covering 2/8 (generated) → 5/8 (transition) problems and not promoted. The live T07 lane is explicitly relabeled a "standard-cell graph surrogate."
- **MasterRTL/RTL-Timer** — pretrained XGBoost/RF heads genuinely load in the T76 gate (`verify_masterrtl_pretrained_models.py`), and are **explicitly rejected** as BDs (T77: Area head collapses all 19 candidates to one leaf). The live `masterrtl_structural_mix` arm extracts **count/structural features only** (`source_aligned_descriptor_evaluator.py:230-269`) — no model loaded — and the docs say so.
- **Aurora (T13)** — labeled `not_pretrained`, from-scratch PCA/RFF on the run's own features. Honest.
- **Graph-contrastive MGVGA (T11)** — explicitly "approximates … **without external model dependencies**." Honest.
- **Synthesized-netlist (T07/T14, hash/motif)** — deterministic SHA-256 / count features with self-describing axis names (`random_hash_*`, `source_tool="auto_bd_hash"`). Honest.

One naming nuance worth a reader caveat (not a downgrade): the live arm carries the word "MasterRTL" and the hash axes say "random" — the code/T76-T77-T80 trail makes clear these are the SOG **parser's counts**, not the tree model.

**Q3 — Docs avoid overclaiming after the negatives? → Mostly yes, two slips.** Every probe README and the presentation say "diagnostic, not promoted," and the slides literally include a "Why This Is Not Overclaiming" panel and a "do not say QD beats classic" guard. The two slips are (a) the aux high-exploit "best screened QD arm" headline rests on one problem (see C2), and (b) the Qwen probe's decisive HV numbers are prose-only/imported (see C4).

**Q4 — Metrics used consistently? → Yes, with two caveats.** `metrics_and_acceptance.md` and the presentation rigorously separate `candidate_ppa_missing` vs `reference_ppa_missing`, use reference-complete paired subsets (46-problem and 31-problem headline), and report HV / HV-AUC / PPA-front consistently; the all-50 view is explicitly tagged "Legacy … not the claim-safe headline." Caveats: the "matched classic" is **not one canonical run** across probe families (C1), and per-problem domination isn't surfaced (C2).

**Q5 — Next direction sound, or repeating failed tweaks? → Currently repeating failed tweaks.** `suggested_decisive_experiment.md` proposes `qd_rtl_native_structural_mix` (T72/T75/T80 lane) on `8x5`/`6x7` — the exact mechanism and shapes the three newest probes already ran and lost. See Recommended next experiments for genuinely new bets.

**Q6 — Follows `AGENTS.md`? → Yes.** Live source is simple and opinionated: assert-heavy (7/9/6 asserts in the three core files), `getattr` without defaults, no back-compat/fallback clutter (the one `try/except` in `descriptors.py:341` re-raises as `KeyError`). Commits are signed, atomic, conventional (`docs(qd): …`), subjects ≤50 chars, wrapped bodies, single `Signed-off-by`. Minor TODO staleness (below).

**Q7 — Visualizations sufficient? → For diagnostics yes; for sign-off no.** Each probe has HV-delta + mean-HV-by-backend figures. Missing for a positive/sign-off claim: a multi-seed / statistical-significance figure, viewer **parity baseline** screenshots (all three marked `missing` in `qd_ppa_viewer/visual_parity_report.md`), and presentation-grade per-problem Pareto panels (current ones flagged "formal audit output, not presentation-ready").

---

## Critical findings (by severity)

**C1 — Single-seed power + non-canonical classic baseline make sub-1% deltas uninterpretable.** All 8 probes are seed-1001, n=8, no CIs. Worse, the "matched classic 8x5" is **two physically different live runs**: encoder-screen/aux probes use classic HV **0.1406** (`encoder_config_screening/live_screen_results.md:30`), while T79's own classic 8x5 is **0.1414** (`T79/results_report.md:87`) — same 8 designs, same seed, same shape, but temperature 1.0 ⇒ ~**0.0008** run-to-run spread. That spread is the same magnitude as several headline micro-gains: MasterRTL front-slot "+0.0009 over plain mix," "8x5 is least-negative shape," "edges out the plain MasterRTL arm." **Those sub-claims are inside the classic baseline's own noise band.** The large negatives (−4.78%, −19%, −28%) are robustly outside it and stand.

**C2 — The aux high-exploit "best screened QD arm" headline is carried by one problem.** Verified in `aux_archive_problem_deltas.csv`: `Prob135_m2014_q6b` flips from classic HV 0.0 → aux 0.1986, contributing ≈+0.025 to the mean and offsetting Prob041 (−0.159) and Prob045 (−0.082). On RTLLM-only the aux arm is the **worst** of all arms. This is never quantified in the probe reports, yet it props up the "narrows the gap / best QD mechanism" framing now propagated into `best_current_techniques.md:11` and `research_strategy_recommendations.md:183`. Anti-loophole rule "cannot be promoted from one cherry-picked problem" is being respected for *promotion* but not for the *headline*.

**C3 — The colleague-facing review bundle omits the three newest negatives, so its "decisive experiment" recommends already-failed mechanisms.** `reviews/20260625_review_bundle/` contains no `aux_archive_*` probe; its `suggested_decisive_experiment.md` offers `qd_rtl_native_structural_mix` on `8x5`/`6x7` and frames "auxiliary archive / staged exploitation" as still-worth-trying — exactly the high-exploit (−4.78%), front-breadth (−19.3%), and depth (−27.7%) runs that already failed on those shapes. A bundle-only reviewer is steered toward exhausted bets.

**C4 — Qwen probe's decisive evidence is prose-only and imported; one impossible number unflagged.** The no-promote HV figures (`0.1108` vs `0.1406`, Pareto 1.62 vs 3.25) in `qwen_live_screen_probe_report.md:42-44` appear in **no table/JSON/CSV** in that package (they live in the separate encoder screen). The probe also reports an off-diagonal cosine **max 1.0073 > 1.0** without flagging the numerical impossibility. The *conclusion* (don't promote) is correct and corroborated elsewhere, but the probe doesn't stand on its own evidence.

**C5 — Next-direction risk: confirmation re-run, not a new mechanism.** Beyond C3, the strategy docs themselves now say the simple-depth-only path is closed and front-breadth is "too costly" — yet the only concrete forward plan is more front-slot/exploitation/budget-shape tuning of the same MasterRTL geometry.

---

## Hard-data gaps before final RTLLM config selection

1. **Multi-seed variance.** No arm has ≥2 seeds. Given C1, ≥3 seeds on the frozen 8-design screen are required before any "least-negative / best-QD" ordering is trustworthy; report paired CIs or a sign test.
2. **One canonical matched-classic baseline** per budget shape, reused across probe families (or report all classic runs and their spread). Reconcile 0.1406 vs 0.1414.
3. **Per-problem dominance disclosure** (C2): every aggregate HV claim needs a "remove top problem → delta" robustness line.
4. **DeepGate coverage** still 2/8–5/8; not spend-ready. Needs cone extraction / caching / faster converter before it's a live arm candidate.
5. **Budget shapes `4x11` and `16x2`** named in the strategy (`research_strategy_recommendations.md:66-67`) were never run; the depth question is only half-answered.
6. **Pretrained MasterRTL timing/power flows** (toggle-rate / timing-DAG) remain blocked; only the (collapsed) Area head was gated.

---

## Recommended next experiments (1–3)

1. **Seed-replication gate (do first, cheap):** rerun classic + the aux high-exploit arm at seeds 1002/1003 on the frozen 8-design screen. Decision rule: if the −4.78% gap is within paired noise *and* survives Prob135 removal, the arm is dead — stop tuning this geometry. This directly resolves C1/C2 and prevents wasted full-RTLLM spend.
2. **A genuinely new coupling, not new geometry:** the failure mode across T44–T80 is consistent — QD improves yield/occupancy but loses front HV. Test an *adaptive* mechanism (the strategy's own "increase diversity pressure only when classic stagnates / a near-front cell exists") so the archive pays evaluation cost only when classic is stuck, rather than a constant exploration tax. This is the one architecture in the strategy doc not yet run.
3. **Decision experiment with a stop clause:** if (1) and (2) both lose under reference-complete multi-seed comparison, invoke the honest off-ramp already drafted in `suggested_decisive_experiment.md:99-103` and write the **rigorous negative map** the goal explicitly accepts as a valid outcome — rather than another front-slot variant.

---

## Documentation & visualization fixes

- **Refresh / re-zip the review bundle** to include the three 2026-06-25 aux-archive negatives, and rewrite `suggested_decisive_experiment.md` so it doesn't recommend already-failed mechanisms (C3).
- **Add the Prob135 robustness caveat** to the aux high-exploit report, `best_current_techniques.md:11`, and `research_strategy_recommendations.md:183` (C2).
- **Fix the Qwen probe** to cite the actual screen tables (not prose) and flag/clip the cosine > 1.0 (C4).
- **Add one multi-seed / statistical-gate figure** and **supply the three missing viewer parity baseline screenshots**; upgrade per-problem Pareto panels to presentation-grade (titles vs legends) before any positive sign-off (Q7).
- **Reconcile classic 0.1406 vs 0.1414** with a one-line note that they are distinct nondeterministic runs (C1).

---

## Commit & coding-practice observations

- **Commits: clean.** Signed, atomic, conventional, well-wrapped bodies, correct sign-off; the recent packaging series (`c43e975`…`01ff032`) is exemplary. Matches `AGENTS.md` Golden Seven.
- **Code: compliant.** Live descriptor/evaluator files are short (182/285/752 lines), assert-heavy, opinionated (`getattr` w/o defaults), no defensive back-compat. Aligns with the Implementation Simplicity Rules.
- **TODO staleness (minor):** `useful_bd_push_implementation_todo.md` leaves the entire **Commit Hygiene** section (585-587) and several **Common Evaluation Surface** infra items (76-82) unchecked though clearly done, while `useful_bd_push_subagent_validation_report.md` exists despite its TODO (580-581) being unchecked. Skim accuracy would improve if these were reconciled.

**Bottom line:** trustworthy, well-instrumented negative-results program with no encoder dishonesty and excellent metric discipline. Before any final RTLLM config is chosen, close the single-seed/noise gap (C1), surface the one-problem dominance (C2), and refresh the reviewer-facing bundle + decisive-experiment plan so it stops pointing at already-failed geometry (C3/C5).

---

Exit status: `0`
Finished: `2026-06-25T23:23:01Z`
