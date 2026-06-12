# 12. Manuscript Evidence Map (P5 kickoff)

Status: living index started 2026-06-12 after the P1 screen phase
closed. Maps each planned manuscript element to its evidence paths so
the P5 rewrite cites artifacts, not memory. Update as the ablation
matrix, bake-off, and finals land.

## Branch context

P1 screens all DEMOTED on the quality bands -> predeclared Branch C
(narrowed claims + content floor), with two regime-scoped positives to
carry into the narrowed claim set:
- failure-regime near-parity (degraded R-B: -0.0022, 1W/1L/2T;
  full R-B: -0.086 with circuit7 dominating; both
  exp/fast_iter/rb_failure_regime*/stats).
- pass-rate recovery under failure feedback (m2014_q3 3%->15%,
  circuit7 26%->62%, fsmonehot 21%->40%; per-problem
  thought_evaluation.json under exp/fast_iter/rb_failure_regime_v2/).

## Root-cause dossier (method/results sections)

1. Transcription poisoning (spec-exact regime):
   exp/fast_iter/hard_subset_42/qd/.../Prob116_m2014_q3/Gen0/
   g000_thought_0001/ (wrong interface indexing in thought, all four
   realizations follow it; K-map present in realization prompt).
   History entry 2026-06-12 13:05.
2. Missing failure feedback: engine.py fail-parent payload before
   ecb7615f5c (thought + status only) vs the evaluation pipeline's
   own diagnosis (code_feedback.txt naming the exact defect);
   propagation bug found live (e77f9c5c8f) - zero of twenty prompts
   carried the payload until the wrapper fix.
3. Descriptor degeneracy: 4/11 hard problems never exit warmup (all
   trio axes unique_count=1); 4/6 mid-size fast problems likewise
   (descriptor_health.json under exp/fast_iter/hard_subset_42/qd and
   exp/fast_iter/fail_feedback_rb/variant). R-C proof-of-firing run:
   exp/fast_iter/warmup_patience_rc/variant archive_space.json
   (warmup_patience_fallback on 4/6) with quality unchanged ->
   axes, not warmup policy, are binding.

## Case-study artifacts (four planned)

- Archive heatmap with equivalence-checked solutions: best source =
  Prob135_m2014_q6b (the only healthy 6-cell archive, QD +0.088;
  exp/fast_iter/hard_subset_42/qd/.../Prob135_m2014_q6b/
  grid_quantile_* visualization artifacts); equivalence via
  scripts/check_equivalence.py.
- Thought lineage: m2014_q3 failure-regime v2 chain (gen-1 fail_pool
  thought with feedback -> 3/4-success child;
  exp/fast_iter/rb_failure_regime_v2/variant/.../Prob116_m2014_q3/).
- Evaluated-history scalar comparison: generation_log.jsonl
  (all-samples logging fix) classic vs QD on hard_subset_42.
- Failure panel: alu feedback-misdirection case (PPA-flavored
  feedback on functional failures, pass rate 15%->2%;
  rb_failure_regime_v2/variant/.../Prob045_alu/).

## Measurement-model section inputs

- Budget parity: exp/fast_iter/hard_subset_42/budget_parity
  (CONFOUNDED toward QD: calls 1.125, completion tokens 1.253) +
  per-contrast artifacts under exp/ablation_matrix/stats/*/
  budget_parity once the matrix lands.
- Instrument: docs/journal_features/09_fast_iteration_validation_set.md
  (G1-G5, recalibrations) + provider-deviation record (32k cap,
  history 2026-06-12 16:50/17:10) + screen-coverage doctrine
  (failure_regime_screen_subset.yaml rationale).
- MDE/power: exp/fast_iter/mde_hard_subset (continuous MDE 0.12 at
  13x5; +0.03 gate under-powered -> ratchet decision at freeze).
- Descriptor evidence: exp/fast_iter/descriptor_correlation_hard
  (all trio axes OK on redundancy) + doc 11 pre-registration +
  bake-off table (scripts/report_descriptor_bakeoff.py output, when
  the queued pairs land).

## Regime-split observation (cross-substrate, manuscript central thread)

Thought-style prompting is regime-sensitive, not uniformly weaker.
Three independent substrates show the same split:
1. QD target vs classic (hard_subset_42): QD's pass rates beat classic
   exactly where classic collapses (m2014_q6b 24% vs 3%, fsmonehot
   21% vs 2%, fsm 12% vs 0%) and QD's only wins are there.
2. Failure-regime screens: near-parity overall (degraded -0.0022)
   vs -0.13..-0.18 on PPA-margin fast problems.
3. Classic substrate ablation (classic_unified seed 1001 formal
   per-benchmark split): RTLLM (PPA-margin) -0.134 0W/7L/0T vs
   VerilogEval (spec-exact) -0.038 1W/2L/3T
   (exp/ablation_matrix/stats/classic_unified_seed1001).

## Pending slots (fill when verdicts land)

- Ablation matrix per-contrast tables: exp/ablation_matrix/stats/.
- Operator-claim licensing contrast: qd_six_operators vs qd_target.
- Branch C floor leg (i): classic_unified vs classic.
- Bake-off decision table + profile freeze rationale.
- Finals (5-seed) gate statistics and branch decision.
