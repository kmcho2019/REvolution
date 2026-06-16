# 17. Manuscript draft spine (for adaptation into the Overleaf journal_draft)

**What this is.** A draft of the manuscript's *spine* — abstract,
contribution list, and the results synthesis — written against the frozen
claims contract (`journal_narrative.md`), the evidence map (doc 12), and
the findings (doc 13). It is NOT the paper; it is content for the author
to adapt into the `journal_draft` Overleaf submodule (LaTeX). **Numbers
marked `[seed1001]` are single-seed and `[CONFIRM]` awaits the running
multi-seed / finals pooled cluster-bootstrap CIs — do not publish until
confirmed.** The frozen narrative wins on any conflict.

---

## Abstract (draft)

LLM-driven evolutionary RTL generation has been shown to improve PPA, but
prior systems (incl. our conference REvolution) rely on a scalarized PPA
objective, a hand-engineered operator suite with an un-ablated bandit, and
small single-module benchmarks — leaving open *when* the added machinery
helps. We study quality-diversity (QD/MAP-Elites) for LLM RTL search and
report a characterization plus a positive, principled contribution.
**(1)** Replacing the scalar objective with Pareto-front archive cells and
**global NSGA-II non-domination-rank selection** removes the weighted-sum
bias and supplies behavioral diversity **at no statistically significant quality
cost** vs a strong direct-code baseline `[5-seed pooled −0.016,
cluster-bootstrap CI [−0.045,+0.007], includes 0, p=0.17; NSGA-II benefit
demonstrated, V2−V1 +0.018 CI [+0.005,+0.032]; V1 alone significantly
worse]`. **(2)** A single unified thought-level
operator matches the six-operator EoH suite + bandit within QD at no cost
`[5-seed pooled +0.001, CI [−0.008,+0.011], p=1.0 — clean parity]`, supplying the operator
ablation prior work lacked. **(3)** We characterize *regime-sensitivity*:
thought/QD search is competitive on spec-exact problems and weaker on
PPA-margin ones, with a mechanism, explaining (not apologizing for) the
mixed conference result. **(4)** At real-CPU (RealBench e203) scale, the
binding limit is the LLM's *spec-comprehension*, not search structure —
candidates compile but are functionally wrong; a stronger model narrows
but does not cross the gap. We release a pre-registered, paired-statistics
evaluation harness and disclose the measurement caveats (token-budget
asymmetry; an eval-concurrency artifact we caught and corrected).

## Contributions (draft list)

1. **Smooth QD integration at no significant quality cost (the positive
   result).** Direct-code individuals + a MAP-Elites archive + global
   NSGA-II non-domination-rank selection (crowding tie-break) = a
   diversity-preserving augmentation of classic search, statistically
   indistinguishable from the classic baseline `[5-seed pooled −0.016, CI
   [−0.045,+0.007], includes 0 — no significant difference, not tight
   parity; NSGA-II benefit demonstrated (V2−V1 +0.018, CI [+0.005,+0.032]),
   V1 alone significantly worse]`. Answers
   conference criticisms #1 (weighted-sum bias) and #5 (no diversity) with
   a no-significant-cost result (not just implemented).
2. **The operator ablation prior work lacked (#2/#3).** One unified
   thought-operator = the six-operator suite + un-ablated bandit, within
   QD, at parity `[5-seed pooled +0.001, CI [−0.008,+0.011], F2]`; substrate-dependent (F3).
3. **Regime-sensitivity characterization (#4 partial, central thread).**
   When thought/QD helps vs not, across substrates, with a mechanism (F4,
   F7 — the deficit is localized to intrinsic-limitation problems).
4. **RealBench-scale capability finding (#4).** The bottleneck at real-CPU
   scale is LLM spec-comprehension; characterized with a model-strength
   gradient (gpt-oss-120b → deepseek-v4-pro: closer, still 0 valid on the
   large modules) (F18–F21).
5. **A rigorous, pre-registered evaluation methodology + disclosed
   caveats** (paired cluster-bootstrap, frozen gates, the parallel-eval
   reliability artifact M12 + its isolated-re-eval mitigation, budget
   asymmetry M2).

## Results synthesis (per planned section — claim → evidence → number)

- **Smooth-QD (headline positive).** code_individual QD removes the
  thought→code indirection that sank the radical build (−0.093, 5-seed CI
  [−0.149,−0.036]) → V1 5-seed −0.034, still significantly worse, CI
  [−0.066,−0.009]; adding NSGA-II selection closes most of the residual →
  **V2 5-seed pooled −0.016, cluster-bootstrap CI [−0.045,+0.007] —
  statistically indistinguishable from classic (CI includes 0, p=0.17),
  not tight parity (CI low < −0.03), variance localized** to the PPA-margin
  problems (alu −0.153, parallel2serial −0.086). NSGA-II's benefit is
  statistically demonstrated (V2−V1 +0.018, CI [+0.005,+0.032] entirely
  >0). Per-seed V2 robust (no outlier). Functional tie. Table: per-problem
  delta vs classic; ablation V1 (cell tournament) vs V2 (NSGA-II). Source:
  `exp/fast_iter/smooth_qd_{code_individual,nsga2}/stats_5seed_vs_classic`
  (official, penalized == complete-case).
  Source: `exp/fast_iter/smooth_qd_{code_individual,nsga2}` + doc 16.
- **Operator parity (F2).** **5-seed pooled +0.001, CI [−0.008,
  +0.011]**, sign-test p=1.0, win-rate 48.8% (coin-flip) — dead-on parity,
  well within ±0.03 (tighter than the 3-seed +0.011/[−0.006,+0.030]).
  Source: `exp/ablation_matrix/stats/final_5seed_F2_qt_vs_six` (official).
- **Substrate dependence (F3).** classic_unified vs classic −0.090/−0.102.
- **Regime-sensitivity (F4).** Pass-rate wins where classic collapses
  (m2014_q6b 24% vs 3%) vs PPA-margin losses; classic_unified per-bench
  RTLLM −0.134 vs VerilogEval −0.038. Source: doc 12 §regime-split.
- **Localized deficit (F7).** ~3/13 problems carry 58–62% of the loss.
- **RealBench-scale capability (F18–F21).** 0 valid candidates on the
  large e203 modules (both gpt-oss-120b and deepseek-v4-pro); v4-pro
  narrows the mismatch (disp 21%→6%, branchslv 25%→8%) but does not cross.
  Source: `exp/fast_iter/{capability_remap,deepseek_capability_probe}`.
- **Methodology (M1, M2, M12).** OpenRouter robustness; budget asymmetry
  (+12–38% tokens — disclose; F1 conservative because QD loses *despite*
  it); the parallel-eval contention artifact caught by ground-truthing +
  isolated re-eval (confined to heavy runs; core verified reliable).

## Case study (four artifacts, per the narrative §"What the case study must show")

Archive heatmap (Prob135_m2014_q6b, healthy 6-8 cell archive); a
thought/lineage crossing descriptor cells; the scalar-vs-QD comparison from
full evaluated history; one predeclared failure panel (a structurally-
collapsed descriptor axis). NOTE (F24): the equivalence-checked-solutions
claim is SPLIT from the Prob135 heatmap — Prob135 has a don't-care
reference (0/8 formally provable; testbench-valid only), so report the
equivalence pass-rate on the fully-specified Prob150_review2015_fsmonehot
(1/1 PROVEN, harness-validated), per the frozen "fully-specified problems
only" scope. Disclose Prob135 solutions as testbench-validated.

## Disclosures the paper MUST carry (predeclared)

- `comb_width_log` correlates with area by construction → named a size
  proxy; diversity claim dropped for that axis (keep logic_depth, ff_depth).
- The frozen descriptor trio is NOT the most collapse-resistant profile
  (simple_2d is) — sophistication didn't buy diversity health (F12).
- Two evaluation artifacts caught and corrected mid-study (include-confound
  F19; parallel-eval contention M12) — disclosed as methodology rigor.
- **Held-out final gate not run (F25).** The QD-vs-classic verdict (F1) and
  the smooth-QD headline (F23) are computed on the 13-problem hard subset,
  which the narrative scopes as a TUNING set; the predeclared 20-problem
  held-out reference gate (`data/configs/holdout_reference_subset.yaml`) was
  NOT executed (decision 2026-06-16: the Branch-C-confirmed outcome is a
  confirmatory negative not worth the multi-day compute). All QD-vs-classic
  and smooth-QD numbers must be stated as **tuning-set-scoped**, with the
  held-out confirmation named as **future work**. The operator ablation (F2)
  is unaffected — its protocol is predeclared on the tuning set. Branch C
  floor leg (i) ("simplification independent of QD") is not met (F9), so the
  paper rests the #1/#5 answers on the smooth-QD contribution (F23), not on
  a held-out QD-vs-classic gate.
- **CVDP end-to-end probe in progress (F26).** A debug-seed probe
  (2026-06-16) validated the revolution+CVDP cocotb harness as operational
  locally (iverilog+cocotb; ground-truthed) — the early 0% pass rate is
  genuine task difficulty (CVDP is harder than RTLLM/VerilogEval), not a
  harness artifact. A real classic-vs-QD CVDP comparison is feasible and is
  the unblocked next step; until it lands, CVDP results are stated as
  preliminary/integration evidence with criticism #4 also carried by the
  RealBench-scale result (F18–F21).

## Open before submission (gating)

- ~~Multi-seed pooled CI for the smooth-QD claim~~ DONE (5-seed, F23):
  V2 −0.016 CI [−0.045,+0.007] no significant cost (CI includes 0);
  NSGA-II benefit V2−V1 +0.018 CI [+0.005,+0.032]. Matches F1/F2 standard.
- ~~5-seed finals pooled F1/F2~~ DONE (official, all runs rc=0): F1
  −0.093 CI [−0.149,−0.036] p=1.3e-05 (QD loses); F2 +0.001 CI
  [−0.008,+0.011] p=1.0 (parity). F4 is descriptive (per-benchmark split,
  doc 12), not a separate pool.
- Then port this spine into the Overleaf LaTeX, build the tables/figures
  from the cited artifact paths, and run the four-persona adversarial
  sign-off (`journal_revamp_adversarial_prompt.md`).
