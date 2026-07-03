# N06 Research Memo — Descriptor Evidence Base (2026-07-03)

Question (user request 2026-07-03): can Smooth-QD V2 be improved by
behavioral descriptors that perform well empirically AND have solid
theoretical grounding? Evidence assembled from the F12 bake-off, the
theory-grounded descriptor program, the June-22 replay/live packages,
and the profile registry, with a regime flag on every result.

## Regime taxonomy (why most prior descriptor negatives do not bind V2)

- RADICAL: thought_only + single unified operator (F12 bake-off, M13).
- STO-LIVE: single_thought_operator live screens (T63-T87 family).
- CODE-EoH: code_individual + EoH suite, CVT archive — operator-fair,
  V2-adjacent (theory Stage 6/11, briefing 06/07 component runs).
- REPLAY: passive re-scoring of fixed candidates — descriptor-isolating
  (T01-T22, T36/T37).
- V2: the target platform. **No descriptor bake-off has ever run here.**

## Load-bearing findings

1. F12 ("no profile beats classic on PPA") ran RADICAL, on the fast
   6-problem subset. The June-18 briefing's own read: "descriptor/
   archive tweaks don't rescue quality — the deficit is in
   representation + operator, not the archive." It answered "can a BD
   rescue the broken substrate" (no), not "which BD maximizes V2".
2. The trio's collapse IS substrate-independent: F12 (14 collapses,
   worst of four), M13 (circuit7 5/5 seeds, fsmonehot 4/5), and the
   operator-fair CODE-EoH component run (ff_depth collapses 7/13,
   circuit7 occupied_cells=1). Structural causes: comb_width_log is a
   size proxy collinear with the area objective (diversity claim
   formally dropped at freeze); ff_depth has no variance on
   combinational/shallow-FSM designs; logic_depth is the one validated
   axis (M4: 31/32 agree with yosys ltp) but cannot hold a 3-D archive
   open alone on small control logic.
3. Collapse-health ranking (F12): simple_2d (2) > graph_testability
   (8) > activity (12) > trio (14). Median occupancy: graph_testability
   0.50 vs trio 0.12.
4. Operator-fair CODE-EoH: structural profiles (size_control,
   implemented_structural) beat both theory profiles on QD score, best
   quality, and Pareto breadth; theory_grounded_compact_8d had ZERO
   axis collapses on 13/13 with all centroids initialized (Stage 11)
   but trails structural on score; theory_grounded_full_20d is
   coverage-strong, score-weak, with unreliable Rent extraction
   (boundary-clamping 4/5 cases).
5. Replay (descriptor-isolating): SR ReLU PCA (T19) is the strongest
   signal on record (+16.82% mean HV, +65% HV-AUC vs lexical, beats
   the random control) but needs a new profile spec + synthesis pass +
   frozen holdout. Random control T22 is NOT weak (+75% front netlists,
   +35% HV-AUC vs lexical) — every challenger must beat random, not
   just the trio.
6. Excluded by the push rules: learned/pretrained encoders (MGVGA
   projection behind T36's +4.04% replay; Qwen/DeepGate lanes) and
   simulation-dependent activity axes (verilator-incompatible,
   12 collapses).

## Theoretical rationales of the viable families

- SCOAP testability (controllability/observability histograms):
  classic DFT theory; varies on exactly the small control logic where
  the trio collapses; orthogonal to size/PPA.
- Spectral connectivity (normalized-Laplacian entropy/lambda2):
  graph-partitioning theory; captures structural modularity.
- Cyclomatic complexity + reconvergent-fanout ratio: decision-structure
  and reconvergence theory; reviewer-legible; defined pre-synthesis.
- Cell-mix/size structural ratios: the honest control family — no
  semantic story, empirically strong under CODE-EoH.
- Operator-graph shape + wire/register density (source-aligned T73
  axes): retiming/topology proxies; yield-positive under STO-LIVE
  (294 vs 257 valid-PPA) with HV loss unresolved (regime-confounded).

## Conclusion feeding the registration

Run the first-ever V2-platform descriptor bake-off as pure single-factor
`--qd_descriptor_profile` swaps, wave 1 = three 3-D registered profiles
(graph_testability, size_control structural bar, random floor) against
the existing V2-trio 3-seed anchor; wave 2 = compact-8d theory profile,
which requires CVT pairing (two-factor; own paired control) and a
descriptor probe first. SR-PCA stays a registered follow-up idea, not a
wave-1 arm.
