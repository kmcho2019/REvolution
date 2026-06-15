# 12. Manuscript Evidence Map (P5 kickoff)

Status: living index started 2026-06-12; refreshed 2026-06-14 after the
investigation arc closed (win-path retired F20, core verified reliable
M12, all freeze decisions settled). Maps each planned manuscript element
to its evidence paths so the P5 rewrite cites artifacts, not memory.
Only the 5-seed finals numbers remain pending. The manuscript itself
lives in the journal_draft Overleaf submodule — author there against
this map; the frozen claims contract is journal_narrative.md.

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

## RealBench-scale capability finding (criticism #4, NEW central result)

The conference reviewers' "benchmarks too small" critique is answered at
real-CPU scale — and the answer is a *characterization*, not a win
(F18-F20, M11-M12 in doc 13; history 2026-06-14).
- Harness: the candidate eval pipeline runs end-to-end on real e203 CPU
  modules (yosys+OpenROAD PPA + post-synth check + BD descriptors);
  validated on the golden e203_exu_decode (53 KB), no LLM (M11).
- Storyline-decider (classic vs QD, 7 dependency-complete e203 modules
  4.7-53 KB, gpt-oss-120b, isolated deterministic re-eval): valid
  candidates appear ONLY on the 2 smallest modules (<6 KB), classic 4
  >= QD 2; the larger modules (incl. decode) get 0 valid. QD shows more
  behavioral diversity but converts it into fewer valid candidates
  (diverse-but-wrong). exp/fast_iter/capability_remap/grade_mismatch_compare.json.
- Manuscript framing: at real-CPU scale the binding limit is the LLM's
  systematic spec-comprehension, NOT search structure or operator
  design - extends the regime-sensitivity thread (below) and bounds the
  diversity claim (#5). Disclose the two artifacts caught + fixed en
  route (missing-include confound F19; parallel-eval contention M12).

## Methodology threats & resolutions (methods / threats-to-validity)

- M12 parallel-eval contention: heavy 14-way runs spuriously fail valid
  candidates; CONFINED to heavy runs (core 12-way small-problem eval
  verified reliable: isolated re-eval matches run exactly, qd_target
  Prob116 9=9, Prob153 2=2). Finals use reliable eval; report as a
  measurement caveat. (doc 13 M12)
- Include confound F19: e203 candidates omit the e203_defines.v include
  -> die at preprocessing; fixed by force-including the design's entry
  header (disclosed benchmark-construction choice making e203 comparable
  to self-contained VerilogEval/RTLLM).
- Feedback-LLM is unreliable for verdicts ("testbench missing"
  hallucination); trust run status_counts / raw eval. (doc 13 M6)

## Landed verdicts (were pending at kickoff)

- Operator-claim licensing (F2): qd_target vs qd_six_operators POOLED
  5-seed +0.001, CI [-0.008,+0.011] -> clean PARITY (sign-test p=1.0,
  win-rate 48.8% coin-flip, well within +-0.03; supersedes the 3-seed
  +0.011/[-0.006,+0.030]; the 2-seed "better" did not replicate).
  CONTRACT-COMPLIANT: penalized (gate-bearing) CI == complete-case (no
  floor-imputation), CI low -0.008 > -0.03; LOSO penalized parity holds
  in all 5 leave-one-seed-out folds (worst -0.026 > -0.03). Within-QD only;
  unified worse on the classic substrate (F3/F9).
  exp/ablation_matrix/stats/ (5-seed finals 1001-1005).
- Branch C floor leg (i) (F9): classic_unified vs classic pooled -0.092,
  CI [-0.149,-0.037] -> FAILS the parity rule; the simplification is
  NOT independent of QD. Predeclares venue reassessment if finals land
  Branch C. exp/ablation_matrix/stats/floorleg_classic_unified_pooled.
- Bake-off + profile freeze: FROZEN journal_logic_ff_width_3d (the trio)
  per the predeclared rule (no candidate qualifies). Disclosures:
  comb_width_log~area (size proxy, drop diversity claim, keep
  logic_depth+ff_depth); trio not most collapse-resistant (F12).
- Finals decisions settled: keep 13x5 + drop the +0.03 win-gate (moot);
  disclose token asymmetry (no matching); equivalence spot-check on
  fully-specified problems only.

## Pending (only the finals numbers remain)

- 5-seed finals LANDED (seeds 1004-1005 -> exp/ablation_matrix,
  bo03wrum8): pooled F1 qd_target - classic -0.093, CI [-0.149,-0.036],
  sign-test p=1.3e-05 (QD loses, all 5 seeds <0); F2 qd_target -
  qd_six_operators +0.001, CI [-0.008,+0.011], p=1.0 (clean parity,
  coin-flip). OFFICIAL (report_journal_statistics, all runs rc=0;
  exp/ablation_matrix/stats/final_5seed_*); DIY cluster-bootstrap matches
  to 4dp. F4 is a descriptive per-benchmark split (already
  characterized above), not a separate pool. This was the LAST evidence
  input before the write-up; the manuscript spine (doc 17) now carries
  the confirmed numbers.
