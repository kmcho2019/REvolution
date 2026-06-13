# Journal Narrative: REvolution TCAD Extension

Status: revision 3, **ACCEPTED** — all four adversarial personas signed
off (TCAD editor, hardware/EDA methodology, and reproducibility/statistics
in round 3; skeptical Reviewer 2 in round 4 after the hypervolume
axis-composition clause fix). Review records:
`revamp_history/20260612_005012_KST_journal_revamp/narrative_review_round1.md`
and `narrative_review_round2_round3.md` (rounds 2–4).
This narrative is the claims contract: it is written before final
experiments, and after final runs begin no gate threshold, branch rule,
pool definition, or budget rule below may change. The hypervolume gate's
robustness artifacts are the epsilon-sensitivity rows and zero-HV unit
counts shipped beside it; LOSO tables recompute the penalized gate
statistics with the imputation floor re-resolved within each replicate.

## One-paragraph thesis

RTL optimization is not a single-score hill climb. Useful RTL variants for
the same specification occupy structurally different design regions and
trade power, area, and timing differently, so a search that collapses
candidates onto one weighted PPA scalar discards design-space structure.
The journal extension recasts REvolution as thought-level, quality-diverse,
Pareto-aware design-space search: the unit of evolution is an
architecture-level thought whose RTL realizations are evaluated into a
MAP-Elites archive over RTL behavior descriptors, with bounded per-cell
Pareto fronts instead of scalar replacement. Evidence comes from locked
benchmark slices across four suite families (RTLLM, VerilogEval, CVDP, and
a harness-validated RealBench module subset), under cluster-bootstrap
paired statistics with pre-registered seeds, on synthesis-stage PPA
proxies whose measurement model is fully disclosed.

## Measurement model (what every PPA number means)

All PPA values are **synthesis-stage proxies**, not signoff results:
Yosys + OpenROAD on Nangate45 (typical corner only), flow terminated at
floorplan — no placement, CTS, routing, or parasitic estimation. Timing
uses a uniform maximum-effort 10 ps clock constraint applied via
`create_clock` on regex-detected clock ports only (register-to-register
paths; no input/output delay constraints, so purely combinational paths
are unconstrained — identically for both arms). "Effective clock period"
is the **piecewise** proxy: `0.01 ns − WNS` when WNS < 0, and `0.0` when
WNS ≥ 0 — in particular it is pinned to 0.0 for combinational designs.
Consequently the per-unit axis composition is predeclared: the avg-PPA
gate averages power/area/period for sequential units and power/area only
for combinational units (the degenerate period axis is dropped, never
zero-filled, identically for both arms); the hypervolume objective space
uses per-axis reference-normalized improvement coordinates with the
zero-improvement reference point, and for combinational units the
hypervolume is computed over the two non-degenerate axes (power/area —
the period axis is dropped exactly as in the avg-PPA rule, matching the
implementation; it is never zero-filled, which would collapse the volume
to zero), identically in both arms. Power is probabilistic-activity power
without back-annotated switching. These
proxies are used for *relative, within-problem, method-vs-method*
comparison under paired statistics; the manuscript will say
"synthesis-stage PPA proxies" wherever a PPA claim appears, will report
absolute raw values beside normalized gains, and will not claim that
generated designs beat engineered references in any signoff sense
(reference designs are non-optimized benchmark goldens; the paired design
mostly cancels this, and the text says so). A clock-sensitivity spot check
(case-study Pareto set re-evaluated at 0.5/1/2 ns) is a predeclared
appendix artifact, as is a tool-provenance statement (exact yosys /
OpenROAD / iverilog versions) and a duplicate-synthesis determinism check
on sampled candidates.

Functional pass is testbench mismatch counting (VerilogEval-v2 protocol),
plus the existing post-synthesis gate-level re-simulation on
reference-bearing suites. Because the search optimizes against reused
testbench stimulus, testbench-passing is not equivalence: the predeclared
mitigation is a Yosys equivalence spot-check on every showcased candidate
(case studies, archive figures) and on a sampled 10% of archive elites in
reference-bearing suites, with the equivalence pass rate reported. Claim
language outside those checks is "testbench-passing variants."

## Benchmarks and their claim surfaces

| Suite | Claim surface | Final evidence scale (predeclared) |
| --- | --- | --- |
| RTLLM + VerilogEval-Spec-to-RTL | Reference-normalized synthesis-stage PPA + pass rate | 13-problem hard subset (tuning set, scoped as such) **plus a 20-problem held-out set** drawn seed-fixed from non-hard-subset problems, never touched by repair/tuning |
| CVDP (non-commercial, cocotb harness) | Functional pass rate only; any PPA absolute-only (capability model enforces suppression of reference-normalized PPA) | 30 fresh medium tasks, category-balanced, **disjoint from the 10-task debug slice**, selected by the same seeded category-stratified rule as the debug slice (`build_cvdp_debug_subset.py`, seed 1337, debug ids excluded) |
| RealBench, harness-validated module subset | Functional pass rate; family-scoped absolute PPA only where single-file synthesis is valid | All validated tasks excluding the 12-task debug slice (26 fresh); debug-slice results reported separately as tuning data |

RealBench disclosure (revised 2026-06-13 pre-freeze, per the
predeclared retention-update path; v1 text archived in git history):
evaluation uses a per-task functional harness behind the capability
model. The primary harness is strict iverilog built from the upstream
verification sources (testbench + stimulus + renamed golden reference
compiled together; e203 sources use upstream's `DISABLE_SV_ASSERTION`
switch). Tasks whose golden fails iverilog but passes the strict
Verilator 5.030 harness (`--binary --timing`, same mismatch parsing)
are dispatched to verilator via `functional_harness_kind` recorded per
manifest entry — matching the official RealBench flow's Verilator-5
target. Under the v2 sweep manifest, 55 of 60 module tasks pass golden
validation (aes 6/6, sdc 12/14, e203 37/40; 38 iverilog + 17
verilator); the 5 exclusions carry recorded per-task compile failures
in both harnesses. Within any paired comparison both arms evaluate
every task under the same recorded harness. Caveat (EDA re-review
2026-06-13): verilator's two-state evaluation can under-detect
X-propagation mismatches relative to four-state iverilog, and the 17
verilator-dispatched tasks have no iverilog cross-check by
construction; functional pass claims on those tasks are therefore
scoped to two-state semantics, and the manuscript's retention table
marks the harness per task. The
manuscript reports this retention table, a retained-vs-excluded
difficulty-proxy comparison using the manifest's size signals, and labels
every claim "harness-validated RealBench module subset" — never bare
"RealBench". Final RealBench model arm (local vLLM vs DeepSeek) is decided
by the locked 8-task long-model probe
(`data/configs/realbench_long_model_probe.yaml`) under the sufficiency
conditions predeclared in the goal spec's Model And Budget Rules (local
fails on >10% length failures, <25% of probe tasks with any syntactically
valid candidate, or <15% functional-pass tasks while DeepSeek reaches
≥30%), applied symmetrically to both methods.

Final scales above are floors justified by a minimum-detectable-effect
(MDE) analysis from retrospective hard-subset variance, to be archived
before the freeze; MDE results may raise counts or seeds, never lower
them. If a gate is shown infeasible at any affordable scale, the gate's
claim is dropped — the threshold is not retuned.

## From conference claims to journal claims

The ASP-DAC paper contributed: Thought/Code/Feedback individuals; a
dual-population loop with six prompt operators; UCB-softmax operator
selection; scalar weighted PPA fitness; VerilogEval/RTLLM evidence. The
journal method keeps the thought-level representation (as inherited
machinery, not new contribution), replaces scalar fitness with a
QD/Pareto archive, replaces the six operators and bandit with one unified
thought operator, and replaces dual-population scheduling with
archive-phase scheduling inside QD (classic arms retain the original
dual-population loop; the journal method's fate of each conference
component is stated explicitly in the method section).

| Critique of the conference method | Journal response | Evidence artifact |
| --- | --- | --- |
| Weighted PPA averages hide Pareto structure. | Bounded per-cell Pareto fronts, no scalar replacement. | Hypervolume log-ratio gate, Pareto cardinality, paired PPA deltas, per-cell front artifacts. |
| Six prompt operators look arbitrary. | One unified thought operator; the selection degree of freedom is removed. | **One-factor ablation within QD**: full QD with the six-operator suite vs full QD with the unified operator — the unambiguous licensing contrast for the operator claim (see ablation matrix for arms, seeds, and decision rule). |
| Bandit benefits claimed without ablation. | No bandit claim; adaptive-selection language scoped to the conference configuration. | Manuscript diff; no bandit in final configs. |
| Benchmarks small. | CVDP + harness-validated RealBench subset behind a declarative capability model. | Locked manifests with hashes, per-task validation records, family-scoped reporting. |
| No diversity pressure. | MAP-Elites with descriptor-health gating; profile pre-registered and frozen. | Occupancy/entropy/collapse, descriptor-objective correlation, profile bake-off with predeclared decision rule. |

### Component-attribution ablation matrix (predeclared)

The headline comparison (classic vs full QD) changes several factors at
once; each headline component is licensed by its own arm, all run on the
hard subset at the debug budget:

| Arm | Isolates |
| --- | --- |
| classic (conference config) | baseline |
| classic + unified operator (six operators removed, nothing else changed) | operator unification on the classic substrate (Branch C floor leg i) |
| full QD with the six-operator suite (`qd_operator_kind=eoh_strategies`) | operator unification within QD — **the licensing contrast for the operator headline claim** |
| QD archive with scalar elites (`cell_mode=scalar_elite`) | Pareto-cell contribution within QD |
| full QD (Pareto cells + unified operator + thought-only k=4) | the package |

Ablation protocol (predeclared): hard subset, debug budget, seeds
1001–1003 (three of the final seeds; ablations license component
attribution on the tuning set and never enter held-out gate statistics).
Decision rule for every "parity-or-better" ablation claim, including
Branch C floor leg (i): the penalized cluster-bootstrap 95% CI of the
best-quality delta lies entirely above −0.03 (parity = within ±0.03;
better = CI low > 0), computed by the same `journal_stats` machinery as
the main gates. No headline sentence may attribute a win to a component
whose arm did not support it. If the ablation budget forces a choice, the
QD-six-operator arm has priority (it guards the operator claim), then the
classic+unified arm (it guards Branch C).

## Budget and honesty rules

- **Matched budget axis: candidate evaluations** (evaluator invocations,
  the dominant wall-clock cost). Repair attempts and each of the k=4 code
  samples per thought are charged against it. LLM calls and total tokens
  are reported for every arm; if either auxiliary axis skews beyond ±10%
  between compared arms, the comparison is flagged and the affected claim
  demoted to "budget-asymmetric, exploratory."
- Missing data: missing treatment where baseline succeeded is a treatment
  loss, imputed at the metric floor into the gate statistics. Missing
  baseline where treatment succeeded is excluded from gate statistics and
  reported by count — a deliberately conservative asymmetry (it can only
  understate the treatment), matching the implementation exactly. Every
  missing unit requires a recorded reason code (infrastructure failure →
  rerun before gating; method failure → loss stands) in the rerun ledger.
- Candidate pools are declared per metric: **search-behavior claims**
  ("visited", case-study artifact 3) use the full evaluated history of
  both arms; **deliverable claims** (what the engineer gets) use end-of-run
  retained sets and are labeled as such. Retained-set comparisons are never
  used for "visited" claims because archives retain by construction.
  **The gate-bearing hypervolume and Pareto-cardinality statistics use the
  full evaluated successful-candidate history of both arms**, extracted
  from the per-generation logs by the same loader for both. Known
  prerequisite (predeclared implementation item before finals): QD
  thought-mode generation logs currently record per-thought
  representatives plus fail parents, omitting the other k−1 evaluated code
  samples; the engine logging is extended to record every evaluated
  sample's PPA details so the two arms' histories are structurally
  identical. Per-unit hypervolume is computed in reference-normalized
  improvement space against the zero-improvement reference point, with
  the axis-composition rule from the measurement model.
- CVDP PPA, if reported, is absolute-only (enforced in code by the
  capability model); CVDP's headline is functional pass rate.
- Scheduler evidence: fair-share elastic leasing achieved a 46% wall-clock
  reduction over a fixed per-problem split on a deterministic replay gate
  with identical candidate outcomes — measured on synthetic modeled
  latencies at scale 0.5 (the gain compresses to ~21% at small scale where
  constant overheads dominate); live-run occupancy from the seed-42 gate
  accompanies this number wherever it appears. The scheduler and rerun
  ledger are experimental-setup material, not headline contributions.

## Statistical protocol

The statistical unit is the problem-seed pair; **problems are clusters**.
All CIs are cluster bootstraps (resampling problems with seed replicates
intact, 95%, seeded). Gate-bearing statistics are **penalized**:
missing-treatment units are imputed at the metric floor (pass metrics: 0;
quality/PPA: worst observed value across both arms; hypervolume: imputed
HV=0 inside the log-ratio). Complete-case statistics are reported beside
them, never as the gate. The hypervolume gate statistic is the mean of
per-unit log((HV_t+1e-9)/(HV_b+1e-9)) ≥ log(1.05) with cluster CI low > 0;
zero-HV unit counts are reported. Win-rate gates require ≥10 non-tied
pairs and exact sign-test p < 0.05 in addition to the 60% rate.
Leave-one-seed-out and per-seed sensitivity tables ship with
`statistical_tests.json`. Branch A's conjunctive gates bound headline
type-I error; per-benchmark breakdown tables are labeled descriptive.
Seeds: debug 42 (never evidence), finals 1001–1005, pre-registered in
`data/configs/journal_seed_manifest.yaml`.

Contamination control: repair/tuning and descriptor exploration use the
hard subset, the fast-iteration validation subset
(`data/configs/fast_iteration_subset.yaml`, a 6-problem quick-loop tuning
artifact), and the debug slices only. Final gates run on the held-out
reference-PPA set — which excludes the hard-subset AND fast-subset
problems — plus fresh CVDP tasks and fresh RealBench tasks (tables
above). Hard-subset final numbers are reported scoped as tuning-set
results with per-problem deltas published.

## Predeclared branch decision (exhaustive, with precedence)

Evaluated on the held-out/fresh final sets after the 5-seed runs. Define:

- `REF_WIN` = all reference-PPA gates pass (penalized cluster-bootstrap
  best-quality mean ≥ +0.03 with CI low > 0; penalized avg-PPA mean ≥
  +0.05 under the predeclared axis-composition rule; hypervolume log-ratio
  gate; win rate ≥ 60% with ≥10 non-tied pairs and sign p < 0.05;
  valid-PPA count ≥ classic).
- `REF_PARITY` = equivalence on best quality (95% cluster CI entirely
  within ±0.03, ≥10 non-tied pairs) AND hypervolume log-ratio gate passes
  (same threshold as `REF_WIN` — coverage is never awarded a weaker bar).
- `NEW_OK` = QD functional any-pass count ≥ classic on CVDP **and** on the
  RealBench validated subset (ties allowed).
- `NEW_DEFICIT_MINOR` = QD trails classic by ≤1 task per suite.

Decision table (first matching row wins; row order is the precedence):

| # | Condition | Headline |
| --- | --- | --- |
| 1 | `REF_WIN` and `NEW_OK` | **Branch A**: quality-diverse thought evolution beats scalar evolution on quality and coverage. |
| 2 | `REF_WIN` and `NEW_DEFICIT_MINOR` | **Branch A-scoped**: A's reference-PPA claims in full; new-suite claims stated as parity-with-deficit, deficit quantified in the abstract. |
| 3 | `REF_PARITY` and `NEW_OK` | **Branch B**: equivalent best quality at margin 0.03, superior Pareto coverage at the same +5% gate; supported by the predeclared utility metric — fraction of problem-seed units where the QD archive contains a testbench-passing candidate that classic's best does **not dominate** and that strictly improves ≥1 PPA axis; the Branch B headline requires this fraction ≥ 0.25, otherwise row 4 applies. |
| 4 | (`REF_WIN` or `REF_PARITY`) and not `NEW_OK` | **Branch B-scoped**: reference-PPA claims as established by the matching definition (win or parity); new suites reported as integration evidence with every deficit stated; no breadth headline. |
| 5 | anything else | **Branch C** (below). |

The table is monotone by construction: rows are checked top-down, and any
outcome at least as good as a higher row's condition fires at or above
that row (a smaller new-suite deficit can never map to a worse branch
than a larger one — `NEW_DEFICIT_MINOR` outcomes that miss rows 1–3 land
in row 4 alongside larger deficits, never below them).

Boundary rules: thresholds are ≥/≤ exactly as written (win rate exactly
60% satisfies `REF_WIN`'s clause; rows are checked top-down so A-family
rows take precedence over B). If descriptor gates fail on every profile
including the fallback trio, diversity claims are dropped entirely and
rows 1–4 may still fire on their PPA/pass legs with descriptor language
removed; this is the only descriptor-failure path.

**Branch C content floor.** Branch C is publishable only with: (i) the
unified-operator one-factor ablation showing parity-or-better (a real
simplification result independent of QD's fate), (ii) a transferable
root-cause analysis of why archive-driven diversity pressure failed on RTL
descriptor spaces (descriptor health, occupancy, parent-selection and
budget-accounting evidence), and (iii) the benchmark/statistics
infrastructure as supporting material only. The thought-level
representation is conference contribution #1 and is never re-counted as
journal delta. If (i) or (ii) is not achieved, Branch C triggers venue
reassessment instead of a TCAD submission — predeclared now.

## Why the descriptor axes mean something (to be finalized at freeze)

The initial hypothesis trio: **logic depth** (combinational depth between
state boundaries — timing pressure), **FF depth** (sequential staging —
pipelining/architecture), and **combinational size**
(`comb_width_log` is log(1+combinational cell count), a size proxy — not
datapath width; the manuscript names it accurately). Because combinational
size correlates with the area objective by construction, the pre-freeze
descriptor report must quantify descriptor-objective correlation per axis;
an axis that is effectively a re-parameterized objective is replaced or
the diversity claim for it is dropped. The profile bake-off decision rule
is predeclared: candidate profiles are ranked first by the QD-vs-classic
paired best-quality delta on the tuning set, tie-broken by median occupied
cell fraction, then by mean descriptor-objective |correlation| (lower
better); the winner must also pass the occupancy (≥0.25 median) and
collapse gates and carry a plain-language design meaning for each axis, or
the fallback trio stays.

## What the case study must show

One problem, four artifacts: (1) archive heatmap with per-cell Pareto
fronts, two structurally different equivalence-checked solutions
annotated; (2) a thought lineage crossing descriptor cells; (3) the
scalar-search comparison built from **full evaluated history** of both
arms (visited, not retained); (4) one predeclared failure panel — a task
family with a structurally collapsed descriptor axis, shown and explained
rather than hidden.
