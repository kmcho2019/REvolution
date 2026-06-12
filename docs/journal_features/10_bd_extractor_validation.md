# 10. BD Extractor Validation (logic_depth, ff_depth, rent_exponent)

Code-level audit of the behavior-descriptor extractors against their
literature definitions (2026-06-12), with ground-truth tests in
`tests/revolution/test_graph_descriptor_evaluator.py`.

## Complexity grounding (the NP-hardness question)

Longest path is NP-hard in general graphs (Hamiltonian-path reduction) but
linear-time in DAGs. Both depth extractors are sound because they reduce
the netlist to a DAG first: `logic_depth` cuts at FF outputs (sequential
feedback never enters the walk), and `ff_depth` builds the FF-to-FF graph
then condenses strongly connected components before the longest-path pass
over the topological order. No heuristic approximation of an NP-hard
problem is involved.

## logic_depth — levels of logic between sequential/IO boundaries

Definition matched: max count of non-buffer combinational cells on any
path from {PI, FF-Q} to {PO, FF-D} (standard timing "logic levels").
Ground truth: 4-op chain = 4; buffers skipped; 1500-stage chain exact.

Defects found and FIXED:
- Recursive traversal hit Python's recursion limit on deep chains
  (observed depths already reach 254; RealBench-class designs exceed
  1000). Now iterative.
- Memo poisoning under combinational cycles: values computed from
  cycle-truncated walks were cached and reused for cycle-free paths.
  Now taint-aware: cycle-cut results are never memoized.

Documented liberties: buffer cells contribute 0 (delay-weighted depth is
out of scope); combinational-cycle edges contribute depth 0 at the cut
point (yosys-synthesized netlists rarely contain them).

## ff_depth — sequential (pipeline) depth on PI→PO data paths

Definition matched: max number of register stages on any PI-to-PO DATA
dependency path; cyclic register groups (counters/accumulators) are
SCC-collapsed and contribute their register count once, never unrolled.
Ground truth: 3-stage pipeline = 3; accumulator (data-reachable loop) = 1.

Defects FIXED: same recursion-limit and memo-poisoning issues as
logic_depth in the source-tracing walk (now iterative + taint-aware).

Documented liberties: control ports (clk/en/arst...) are excluded from
dependency tracing, so an enable-only-reachable register reports 0 (test
pins this); SCC weight = register count in the component (alternative:
count once), chosen to preserve monotonicity with pipeline width.

## rent_exponent — Rent's rule T = t·B^p

Method: recursive spectral (Fiedler) bisection collects (region size,
boundary crossings) points; per-size averaging; log-log least squares;
slope clamped to [0,1] with `rent_clamped_flag`; confidence gating from
sample counts and R².

Documented liberties vs classic Rent studies:
1. Boundary CONNECTION crossings approximate terminal counts (a net
   fanning out across the cut counts once per crossing edge, not once per
   net) — hyperedge-vs-edge simplification.
2. The whole-circuit point (Region II territory) is included; mitigation
   is the sigma-improving tail-trim retaining ≥75% of points, not the
   literature's exclude-regions->1/3 rule.
3. Spectral bisection replaces min-cut partitioning (KL/FM); recognized
   but produces somewhat higher-variance points.
Ground truth: deterministic across runs; chain topology < dense
reconvergent topology in p; bounds respected. These liberties make
rent_exponent suitable as a RELATIVE diversity axis (its role here), not
for absolute comparison with published Rent exponents — the manuscript
must say so if the axis is adopted.

## comb_width_log

log1p(combinational cell count): a SIZE proxy, not datapath width
(already corrected in the narrative); prime redundancy suspect vs g_A by
construction; subject to the P2 correlation disqualification bound.
