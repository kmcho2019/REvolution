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
bias and supplies behavioral diversity **at quality parity** with a strong
direct-code baseline `[CONFIRM: seed1001 best_quality −0.011, functional
tie, 12/13 within the parity band]`. **(2)** A single unified thought-level
operator matches the six-operator EoH suite + bandit within QD at no cost
`[seed-pooled +0.011, CI within ±0.03 — parity]`, supplying the operator
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

1. **Smooth QD integration that reaches parity (the positive result).**
   Direct-code individuals + a MAP-Elites archive + global NSGA-II
   non-domination-rank selection (crowding tie-break) = a
   diversity-preserving augmentation of classic search, at quality parity
   `[CONFIRM]`. Answers conference criticisms #1 (weighted-sum bias) and
   #5 (no diversity) with a *demonstrated* (not just implemented) result.
2. **The operator ablation prior work lacked (#2/#3).** One unified
   thought-operator = the six-operator suite + un-ablated bandit, within
   QD, at parity `[seed-pooled, F2]`; substrate-dependent (F3).
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

- **Smooth-QD parity (headline positive).** code_individual QD removes the
  thought→code indirection that sank the radical build (−0.10 → −0.033
  `[seed1001]`); adding NSGA-II selection closes the exploitation residual
  (alu +0.238 vs the cell-tournament variant) → best_quality −0.011,
  functional tie, hypervolume −0.0035, 12/13 within parity `[seed1001;
  CONFIRM multi-seed 1002-1003 running, bn94s0so5]`. Residual ≈ 1
  intrinsic-limitation problem (parallel2serial). Table: per-problem
  delta vs classic; ablation V1 (cell tournament) vs V2 (NSGA-II).
  Source: `exp/fast_iter/smooth_qd_{code_individual,nsga2}` + doc 16.
- **Operator parity (F2).** Pooled 3-seed +0.011, CI [−0.006, +0.030].
  Source: `exp/ablation_matrix/stats/licensing_pooled` `[CONFIRM 5-seed
  finals bo03wrum8]`.
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

Archive heatmap w/ equivalence-checked Pareto solutions; a thought/lineage
crossing descriptor cells; the scalar-vs-QD comparison from full evaluated
history; one predeclared failure panel (a structurally-collapsed
descriptor axis). Best source problem: Prob135_m2014_q6b (healthy archive).

## Disclosures the paper MUST carry (predeclared)

- `comb_width_log` correlates with area by construction → named a size
  proxy; diversity claim dropped for that axis (keep logic_depth, ff_depth).
- The frozen descriptor trio is NOT the most collapse-resistant profile
  (simple_2d is) — sophistication didn't buy diversity health (F12).
- Two evaluation artifacts caught and corrected mid-study (include-confound
  F19; parallel-eval contention M12) — disclosed as methodology rigor.

## Open before submission (gating)

- Multi-seed pooled CI for the smooth-QD parity claim (running).
- 5-seed finals pooled F1/F2/F4 (running).
- Then port this spine into the Overleaf LaTeX, build the tables/figures
  from the cited artifact paths, and run the four-persona adversarial
  sign-off (`journal_revamp_adversarial_prompt.md`).
