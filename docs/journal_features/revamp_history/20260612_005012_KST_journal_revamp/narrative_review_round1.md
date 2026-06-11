# Narrative Adversarial Review — Round 1 (2026-06-12)

Narrative draft: `docs/journal_features/journal_narrative.md` (first version).
All four personas returned **BLOCK**. Full verdicts are summarized below;
the revision plan maps every blocking issue to a concrete fix. Per the goal
spec, the narrative cannot be accepted until all personas sign off.

## Verdicts

- TCAD editor: BLOCK (4 blocking issues)
- Skeptical Reviewer 2: BLOCK (6 blocking issues)
- Hardware/EDA methodology: BLOCK (4 blocking issues)
- Reproducibility/statistics: BLOCK (6 blocking issues)

## Consolidated blocking issues and the revision plan

### Statistics machinery (code changes in `journal_stats.py` / `report_journal_statistics.py`)

1. Flat pooled bootstrap over problem-seed pairs ignores problem-level
   clustering (≈13 effective clusters, not 65 units) → anti-conservative
   CIs on every CI-low>0 gate. FIX: cluster bootstrap resampling problems
   (clusters) with seed replicates intact; leave-one-seed-out sensitivity
   table.
2. Branch B "CI includes 0" is not equivalence. FIX: predeclared
   equivalence rule — 95% cluster-bootstrap CI entirely within ±0.03
   best-quality delta, plus minimum non-tied pair count; Branch B reuses
   Branch A's +5% HV gate for its coverage leg.
3. Missing-as-loss only reached win rate/sign test, not the gated mean/CI.
   FIX: penalized (floor-imputed) statistics are the gate-bearing primary;
   complete-case reported as secondary; ledger gains failure-reason codes
   (infra vs method).
4. Hypervolume statistic ambiguous/unstable (per-unit ratios, baseline-0
   excluded). FIX: predeclare primary statistic = cluster-bootstrap mean of
   per-unit log((HV_t + eps)/(HV_b + eps)), eps=1e-9, missing treatment
   imputed HV_t=0; report b=0/t=0 unit counts separately; gate mean ≥
   log(1.05) with CI low > 0.
5. No power/MDE analysis. FIX: MDE estimation from retrospective hard-subset
   archives before the freeze; publish per-gate MDE; counts may be raised,
   never lowered.
6. Win-rate gate trivially satisfiable. FIX: require ≥10 non-tied pairs and
   exact sign-test p < 0.05 alongside the 60% rate.

### Claims / narrative structure

7. Branch C re-counts conference contribution #1 and rests on
   infrastructure. FIX: Branch C content floor — unified-operator
   parity-or-better evidence plus transferable root-cause analysis of why
   diversity pressure fails; otherwise venue reassessment is predeclared.
8. Branch lattice non-exhaustive (mixed/partial outcomes land perversely).
   FIX: exhaustive outcome table with A-first precedence at boundaries and
   per-suite partial mappings.
9. Multi-factor headline confound (archive + operator + representation +
   dual-population fate unstated). FIX: predeclared minimal ablation matrix
   (classic+unified-operator arm; QD-with-scalar-cells arm; dual-population
   fate stated) licensing each headline component.
10. Budget currency undeclared. FIX: matched axis = candidate evaluations
    (evaluator invocations); LLM calls and tokens reported for both arms
    with predeclared max skew (±10%); skew breach demotes the claim.
11. Final benchmark scale undeclared; +5pp CVDP gate infeasible at 10
    tasks. FIX: predeclared final scales — CVDP 30 fresh medium tasks
    (disjoint from the 10-task debug slice), RealBench all validated tasks
    minus the 12-task debug slice (26 fresh), hard subset 13 (tuning-set,
    scoped) plus a 20-problem held-out reference-PPA set disjoint from the
    hard subset; MDE may raise counts.
12. Coverage/HV candidate pool undeclared; retained-set comparisons favor
    archives. FIX: per-metric pool declaration — search-behavior ("visited")
    claims use full evaluated history for both arms; deliverable claims use
    end-of-run sets and say so.

### EDA methodology

13. PPA measurement model undisclosed (floorplan-stage flow, 10 ps uniform
    clock, eff_clk_period = 0.01 − WNS, ideal interconnect, probabilistic
    power, single corner). FIX: measurement-model paragraph; all claim
    language scoped to "synthesis-stage PPA proxies".
14. RealBench harness substitution and family-skewed retention (aes 3/6,
    sdc 4/14, e203 31/40) undisclosed. FIX: explicit disclosure; per-family
    retention table; retained-vs-excluded difficulty-proxy comparison from
    manifest size signals; claim surface renamed "harness-validated
    RealBench module subset".
15. Oracle overfitting (search optimizes against reused testbench
    stimulus). FIX: predeclared yosys equivalence spot-checks for showcased
    candidates plus a sampled fraction of archive elites on
    reference-bearing suites; language downgraded where unverified.
16. `comb_width_log` is log combinational cell count (size proxy), not
    datapath width. FIX: axis justification rewritten as combinational
    size; descriptor-vs-objective correlation quantified in the pre-freeze
    descriptor report.

## Round-2 plan

Implement statistics fixes (1-6) in code with tests; rewrite the narrative
incorporating 7-16; re-run all four personas on the revised narrative.
