# DRAFT — Methods section (for adaptation into the Overleaf journal_draft)

Draft content for the author to adapt — not the final paper, not pushed to
Overleaf. Calibrated to the frozen claims contract (`journal_narrative.md`) and
the architecture/protocol in the consolidated record §2/§6/§8. Pairs with the
Results draft.

---

## 3. Method

### 3.1 Search framework and the quality-diversity configuration

We extend the REvolution evolutionary backend with a quality-diversity (QD)
search mode controlled by a small set of orthogonal, discriminated-union knobs,
so that each comparison isolates a single factor. The relevant axes are: the
search mode (classic evolution vs QD/MAP-Elites); the individual representation
(direct code vs a natural-language "thought" realized into code); the operator
set (a six-operator EoH suite with an adaptive selection bandit vs a single
unified thought-operator); the archive (a quantile-rebinned behavioral grid
with bounded per-cell Pareto fronts); and parent selection (per-cell crowded
tournament vs global NSGA-II non-domination-rank with crowding tie-break). Our
proposed configuration ("smooth QD") uses direct-code individuals, the
quantile grid with per-cell Pareto fronts, and global NSGA-II selection; the
radical configuration studied for characterization uses thought-level
individuals with the unified operator.

### 3.2 Behavioral descriptors

Cells are indexed by a frozen three-axis behavioral-descriptor profile:
combinational logic depth, flip-flop (sequential) depth, and a log
combinational-size term. We pre-registered four candidate profiles and froze
this trio by a predeclared bake-off rule. We disclose that the
combinational-size axis correlates with area by construction and treat it as a
size proxy; the diversity claim rests on the logic-depth and FF-depth axes. We
also disclose that the frozen trio is not the most collapse-resistant profile we
measured, and that it degenerates (all axes single-valued) on roughly two of the
hard-subset problems across seeds.

### 3.3 Benchmarks and locked subsets

We evaluate on four suite families. The primary comparisons use a 13-problem
RTLLM + VerilogEval-Spec-to-RTL **hard subset**, scoped as a *tuning* set, with
a disjoint 20-problem **held-out reference set** drawn seed-fixed from
non-hard-subset problems and reserved for the final gate (see Limitations).
**RealBench** contributes seven dependency-complete e203 CPU modules
(4.7–53 KB), validated end-to-end against the golden design. **CVDP** (a
non-commercial cocotb benchmark) contributes easy- and medium-tier design tasks;
CVDP is scored on functional pass rate with PPA reported absolute-only, per its
capability model. All subsets, seeds (debug seed 42, never evidence; final seeds
1001–1005), and manifests are version-locked with hashes.

### 3.4 Metrics and statistical protocol

The primary metric is per-problem best-quality: the reference-normalized
synthesis-stage PPA of an arm's best functionally-valid candidate, with PPA
proxies measured by Yosys + OpenROAD on Nangate45 (typical corner). We also
report functional pass rate and, on CVDP/RealBench where reference-normalized
PPA is suppressed, functional validity. All comparisons are paired and pooled
across five seeds with 95% confidence intervals from a cluster bootstrap that
treats problems as clusters; gate-bearing statistics are penalized
(missing-treatment-where-baseline-succeeds imputed at the metric floor). The
predeclared decision rule for any parity-or-better claim is that the penalized
95% CI of the best-quality delta lie entirely above $-0.03$ (equivalence within
$\pm0.03$; superiority requires CI low $>0$); we additionally report
leave-one-seed-out recomputations. Thresholds, pools, and branch rules were
frozen before final runs.

### 3.5 Functional evaluation and reliability

Functional correctness is checked with Verilator (5.030) for RTLLM/RealBench and
with cocotb + Icarus Verilog (12.0) for CVDP; synthesis uses Yosys (0.54+29) and
OpenROAD (v2.0-22560). Because heavy concurrent evaluation can spuriously fail
valid candidates under resource contention, all capability-sensitive comparisons
on the harder benchmarks are graded by deterministic isolated re-evaluation
(one candidate per process group, short timeout), rather than the in-run
counts. We disclose the evaluation artifacts identified and corrected during the
study: a missing-include preprocessing confound and a parallel-eval contention
effect on RealBench; an interface confound in the CVDP prompt construction (the
reference module interface was omitted, inducing port-name mismatches) which we
fixed; and an in-run CVDP functional under-report addressed by isolated grading.
Tool versions ship with the configuration freeze for reproducibility.
