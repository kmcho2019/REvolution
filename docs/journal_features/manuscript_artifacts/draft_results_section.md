# DRAFT — Results section (for adaptation into the Overleaf journal_draft)

**What this is.** A prose draft of the manuscript's Results section, written
against the frozen claims contract (`journal_narrative.md`, which wins on any
conflict) and the confirmed findings (doc 13). It is draft content for the
author to adapt — *not* the final paper and *not* pushed to Overleaf. Numbers
trace to the cited run directories (see `tables.tex` for Tables 1–2 and the
master evidence index in the consolidated record §7). All best-quality deltas
are penalized cluster-bootstrap (problems as clusters) computed by
`report_journal_statistics`. **Scope caveat to carry (F25):** the QD-vs-classic
and smooth-QD deltas are on the 13-problem hard subset, which the protocol
scopes as a *tuning* set; the predeclared 20-problem held-out gate was not run
(see Limitations), so these are reported as tuning-set-scoped results with
per-problem deltas published.

---

## 5. Results

### 5.1 Setup

We evaluate on the 13-problem RTLLM + VerilogEval-Spec-to-RTL hard subset over
five seeds (1001–1005), with gpt-oss-120b via OpenRouter at a fixed population
and generation budget (Section [Methods]). Best-quality is the per-problem
reference-normalized synthesis-stage PPA of an arm's best functionally-valid
candidate; we report paired deltas with 95% cluster-bootstrap confidence
intervals, treating problems as clusters, and adopt the predeclared parity
rule: two arms are equivalent when the interval lies entirely above $-0.03$.
Table 1 summarizes the headline contrasts; Table 2 the harder-benchmark
capability results.

### 5.2 The operator suite can be replaced by a single operator (criticisms #2/#3)

The conference system used six hand-engineered EoH prompt operators selected by
an un-ablated bandit. Replacing them, within QD, with a single unified
thought-operator leaves best-quality unchanged: pooled across five seeds the
unified arm differs from the six-operator suite by $+0.001$ (95% CI
$[-0.008, +0.011]$; sign-test $p=1.0$; win-rate 48.8%), well inside the parity
band and robust in every leave-one-seed-out fold (worst-fold CI low $-0.026 >
-0.03$). This supplies the operator ablation prior work lacked and shows the
operator-selection degree of freedom can be removed at no measured cost. The
result is, however, *substrate-dependent*: the same simplification on the
classic (non-QD) substrate costs $-0.092$ (CI $[-0.149, -0.037]$) — the archive
supplies the exploration the hand-engineered operators otherwise manufacture,
so the simplification is licensed only within QD.

### 5.3 Pareto-cell QD with principled selection matches classic at no significant cost (criticisms #1/#5)

Replacing the scalarized PPA objective with bounded per-cell Pareto fronts and
**global NSGA-II non-domination-rank selection** removes the weighted-sum bias
(criticism #1) and supplies behavioral diversity (criticism #5) while remaining
statistically indistinguishable from a strong direct-code baseline: pooled
five-seed best-quality delta $-0.016$ (95% CI $[-0.045, +0.007]$, includes 0;
$p=0.17$). The principled-selection component is necessary, not incidental: with
per-cell tournament selection alone the deficit is significant ($-0.034$, CI
$[-0.066, -0.009]$), and NSGA-II's contribution is itself significant
($+0.018$, CI $[+0.005, +0.032]$, entirely above 0). We therefore claim a
*no-significant-cost* diversity augmentation, not a tight-parity or win result;
the residual variance is concentrated on a small number of exploitation-heavy,
PPA-margin problems (e.g. alu, parallel2serial) where the archive's exploration
yields no quality benefit.

### 5.4 The radical thought-only build loses — and why (criticism #4, regime sensitivity)

The most aggressive configuration — thought-level individuals with the unified
operator over the Pareto archive — loses to classic search at this budget
($-0.093$, CI $[-0.149, -0.036]$, sign-test $p=1.3\times10^{-5}$). The deficit
is pure PPA quality, not functionality (the arms tie on functional pass on the
genuine-hard intersection), and it is *localized*: roughly three
intrinsic-limitation problems carry 58–62% of the loss. The mechanism is
regime-sensitivity (Fig. [scalar-vs-QD]): thought/QD search is competitive on
spec-exact and under-determined problems — where it raises functional pass rates
exactly where classic collapses (e.g. m2014\_q6b 24% vs 3%) — and weaker on
PPA-margin problems where there is little architectural room to maneuver. The
archive heatmap for a healthy case (Fig. [heatmap], Prob135) shows a six-cell
Pareto front spanning logic-depth and combinational-size descriptors; we caption
the combinational-size axis as a size proxy (it correlates with area by
construction) and rest the diversity claim on the logic-depth and FF-depth axes.

### 5.5 At real-CPU and newer-benchmark scale, the limit is model capability, not search (criticism #4)

We integrate two harder benchmarks the conference benchmarks could not reach
(Table 2). On **RealBench** (real e203 CPU modules), functionally-valid
candidates appear only on the two smallest dependency-complete modules — classic
4, smooth-QD V2 3, radical QD 2 — and *no* arm produces a single valid candidate
on any of the five larger modules; a stronger model (deepseek-v4-pro) narrows
the functional mismatch but still crosses none. The binding limit is the LLM's
spec-comprehension, not the search structure: candidates compile but are
functionally wrong, and QD converts its larger behavioral diversity into
*diverse-but-wrong* designs rather than closer-to-correct ones.

On **CVDP** (newer cocotb design tasks) the same null initially appeared, but
ground-truthing revealed it as an evaluation-harness confound rather than a
capability limit: the task's reference interface was omitted from the prompt, so
every candidate failed on port-name mismatch regardless of logic. After
correcting the prompt construction, the model solves 9/10 easy and 7/10 medium
tasks — yet classic and smooth-QD V2 solve the *identical* set on each tier
(9/10 and 7/10), QD adding no task classic could not already solve. The medium
tier is genuinely the "capable-but-hard" regime in which diversity might be
expected to pay off; that it does not closes the hypothesis. Across the full
difficulty spectrum, then, quality-diversity ties or is capped — never wins.

### 5.6 Summary

Quality-diversity, integrated smoothly (direct-code individuals, Pareto cells,
NSGA-II selection), is a no-significant-cost diversity augmentation that removes
two biasing degrees of freedom from the conference design (the scalar weight and
the operator-selection bandit) and supplies a missing operator ablation; the
radical thought-only variant loses, for an identified and localized reason; and
on harder benchmarks the binding constraint is model capability, not search.
This is a characterization of *when* the added machinery helps — and a candid
account of when it does not — rather than a claim that it wins.

---

## Limitations to carry into the Discussion (predeclared)

- **Held-out gate not run (F25).** Best-quality results are tuning-set-scoped;
  the 20-problem held-out reference gate is named as future work.
- **Token-budget asymmetry (M2).** QD/thought arms spend more tokens at equal
  population×generations; F1 is conservative because QD loses despite this.
- **Eval-reliability artifacts caught and corrected:** an include-confound and a
  parallel-eval contention effect on RealBench (isolated re-eval), the CVDP
  interface confound (fixed), and an in-run CVDP under-report (isolated grading).
- **Descriptor degeneracy (M13):** the frozen trio collapses on ~2/13 problems
  across seeds; the diversity claim is scoped accordingly.
- **CVDP comparison granularity:** any-pass per task at a single (debug) seed; a
  finer pass-rate comparison and more seeds are future work.
