# DRAFT — Discussion + Conclusion (for adaptation into the Overleaf journal_draft)

Draft content for the author to adapt — not the final paper, not pushed to
Overleaf. Calibrated to the frozen claims contract (`journal_narrative.md`) and
the findings (doc 13, esp. F29's mechanism analysis). Pairs with the Results
draft (`draft_results_section.md`).

---

## 6. Discussion

### 6.1 Why quality-diversity does not win — a mechanism

Across every regime we tested, quality-diversity ties or is capped by classic
search but never beats it. The mechanism is consistent. Search — whether
classic evolution or QD — is a refinement layer over the base model's
generation; it can only amplify capability the model already has, and it needs
*stepping stones*: partially-correct candidates to recombine, refine, or
diversify toward a solution. Two regimes deny it that foothold from opposite
directions. Where the model is **capable** (small benchmarks, easy/medium CVDP),
classic search already finds correct solutions, so the archive's extra diversity
has nothing to add — quality-diversity ties. Where the model is **incapable**
(large real-CPU modules), no arm produces functionally-valid candidates at all,
and functional correctness in RTL is effectively discontinuous — the best
failing candidates miss 20–100% of test vectors, a chasm rather than a climbable
gradient — so diversity yields *diverse-but-wrong* designs, not closer-to-correct
ones. The "capable-but-hard" middle, where partial successes might let diversity
find solutions a scalar search misses, did not materialize for the model studied:
the medium cocotb tier is hard enough that the model solves only some tasks, yet
quality-diversity solves exactly the same set classic does. The binding
constraint is therefore base-model spec-comprehension and the discontinuous
correctness landscape, not the search structure.

### 6.2 What the operator simplification establishes

Independently of QD's competitive fate, the operator result is a clean
simplification: a single thought-level operator reproduces the behavior of a
six-operator hand-engineered suite and its un-ablated selection bandit, within
QD, at no measured cost. The conference design's operator-selection degree of
freedom can be removed. The result is substrate-dependent — on the classic
substrate the same simplification costs quality, because the archive supplies the
exploration the operators otherwise manufacture — which is itself informative
about *where* hand-engineered operator diversity earns its keep.

### 6.3 On the value of a negative, characterized result

We deliberately frame this as a characterization rather than a victory. The
pre-registration, paired statistics, disclosed measurement model, and the
evaluation artifacts we caught and corrected are themselves contributions: one
of them (the CVDP interface confound) turned an apparent capability ceiling into
a working benchmark on which the model solves most tasks, and would otherwise
have been published as a false null. We report the smooth-QD result as
*no-significant-cost* rather than a win, scope the operator claim to within-QD,
and disclose that the QD-vs-classic deltas are on a tuning subset with the
held-out gate left as future work. We believe this honesty is the right posture
for a result whose value is knowing *when* the machinery helps.

### 6.4 Future work

The mechanism analysis points to where progress would have to come from, in
rough order of leverage. **Base-model capability** is the binding limit on hard
designs; a stronger or RTL-specialized model is the most direct lever, and would
also test whether quality-diversity can help once valid stepping stones exist.
**Hierarchical / decompositional generation** — generating and verifying
sub-modules and composing them — directly attacks the "too large for one-shot"
failure on real CPUs and is a genuine method extension rather than a bigger
model. **Richer functional feedback** (detailed simulation-mismatch traces fed
back for targeted repair) can help climb the correctness gradient where it is
shallow, on easier problems. On the evaluation side, running the predeclared
20-problem held-out gate would convert the tuning-set-scoped deltas to held-out
ones, and a finer per-task pass-rate comparison (beyond any-pass) across more
seeds would sharpen the CVDP characterization.

## 7. Conclusion

We studied quality-diversity for LLM-driven RTL generation and found that,
integrated smoothly — direct-code individuals, Pareto-front cells, and NSGA-II
selection — it is a principled, no-significant-cost diversity augmentation that
removes two biasing degrees of freedom from the conference design and supplies a
missing operator ablation, but does not beat classic search on quality or
functional pass rate in any regime we tested, including a newer benchmark where
the model is demonstrably capable. The binding constraint at harder-benchmark
scale is the language model's spec-comprehension, not the search structure. The
contribution is a rigorous, honestly-scoped account of when quality-diverse,
thought-level structure helps LLM RTL search — and the reproducible,
artifact-disclosed methodology that makes such an account trustworthy.
