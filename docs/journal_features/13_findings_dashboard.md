# 13. Findings Dashboard (searchable, topic-indexed)

**Purpose.** A single skimmable, searchable view of *what we have found
and how confident we are*, organized by topic rather than by time. This
is the orthogonal complement to the chronological audit log
(`revamp_history/.../journal_revamp_implementation_history.md`, 63+
dated entries) and the manuscript artifact index (doc 12). When a
finding cites `[H: YYYY-MM-DD HH:MM]` that is the history entry with the
full evidence; when it cites `exp/...` that is the raw artifact.

**Confidence legend.**
`CONFIRMED` replicated across seeds / multiple substrates ·
`MEASURED` single clean run, direction verified ·
`PRELIMINARY` one seed, replication pending ·
`MECHANISM-VERIFIED` process confirmed live, outcome tracked separately.

**Last refreshed:** 2026-06-13 11:15 KST (seeds 1001-1002 of the matrix
landed; F2 replicated, F5 downgraded, F7 confirmed). Refresh the tables
below from `exp/ablation_matrix/stats/` and `exp/fast_iter/*/stats/`
when new runs land; keep finding IDs stable.

---

## 1. Status at a glance

| Phase | Title | State |
| --- | --- | --- |
| P1 | QD repair | **CLOSED → Branch C.** All screens + ablation + parity fixes done; Fix B halved the FAST deficit but did NOT transfer to hard (F15) — realization-side parity path closed. Only win-path left: RealBench-large (#16). |
| P2 | BD / descriptor thesis | **In progress.** 4 profiles pre-registered (doc 11); bake-off queued behind matrix; mechanical verdict table ready. |
| P3 | Benchmark vetting | **Mostly done.** RealBench verilator-only (55/60). **RealBench QD-vs-classic is the STORYLINE-DECIDER (doc 14): the one experiment that could convert Branch C→A/B — QD diversity may only pay off on larger designs.** Debug pairs pending next OpenRouter slot. |
| P4 | Gates / freeze | **Tooling complete.** All slices locked. Open: MDE ratchet + budget-rule *decisions*, seed-42 debug gate, 5-seed finals. |
| P5 | Manuscript | **Kicked off.** Evidence map (doc 12) binds elements to artifacts; prose pending finals. |

**Win-path status (#16):** the eval pipeline is now FIXED and validated
END-TO-END (F16 RESOLVED) — the golden e203_exu_decode (53 KB) passes the
full runtime evaluate_candidate (pre-synth functional → yosys+OpenROAD
PPA → post-synth check → journal BD-trio descriptors), no LLM, status
`success`. The dependency-complete census (F17) shows decode + disp are
the large viable modules; the original biu/lsu subset was mostly
dependency-incomplete (the other reason the first run failed). **Only
open question left: can the LLM implement decode-class modules?** — now
cheap to settle with a 1-module OpenRouter smoke before committing to a
full QD-vs-classic large run. The PPA win-path test still stands: does QD
diversity pay off where designs have architectural room (vs F1/F15).

---

## 2. Headline findings

### F1 — QD does not beat classic on best-quality at this budget `CONFIRMED`
Every QD/unified arm loses to classic across both seeds (see §3.2).
Decision: predeclared **Branch C** (narrowed claims + content floor).
The deficit is *pure PPA quality* — functionality tied 9/9 on the
genuine-hard intersection. [H: 2026-06-12 21:45]

### F2 — Operator unification LICENSED at PARITY within QD `CONFIRMED` (3-seed pooled)
Within-QD pairing (`qd_target` vs `qd_six_operators`, both QD substrate
— the narrative's operator contrast). **Formal 3-seed pooled: +0.011,
13W/13L/12T, CI [−0.0059, +0.0302] — within the ±0.03 parity band and CI
low > −0.03 ⇒ PASSES "parity-or-better" at PARITY (not "better").**
Per-seed: 1001 +0.040 (better), 1002 +0.006 (parity), 1003 −0.015
(parity). The 2-seed read of "better" did NOT hold; the unified operator
is statistically EQUIVALENT to the six-operator suite within QD. Still a
valid simplification: one unified operator replaces the six arbitrary
EoH operators + unablated bandit (criticisms #2/#3) at **no cost within
QD** — but only within QD (F9: it costs −0.09 on the classic substrate).
`exp/ablation_matrix/stats/licensing_pooled` [H: 2026-06-13 20:10]

### F3 — Operator unification is SUBSTRATE-DEPENDENT `MEASURED`
The same unified operator is **worse** on the classic substrate
(`classic_unified` vs classic: −0.090/−0.102, both CIs below 0) but
**better** within QD (F2). Mechanism: the six hand-engineered operators
manufacture the exploration the archive supplies for free in QD. This is
the project's cleanest one-factor mechanistic result. [H: 2026-06-13 08:00]

### F4 — Regime-sensitivity is the central empirical thread `CONFIRMED` (3+ substrates)
Thought-style prompting is competitive on **spec-exact** problems and
weaker on **PPA-margin** problems — not uniformly weaker. Seen on:
(a) QD pass rates beat classic where classic collapses (m2014_q6b 24%
vs 3%); (b) failure-regime near-parity vs −0.13..−0.18 elsewhere;
(c) classic_unified per-benchmark: RTLLM −0.134 (0W/7L) vs VerilogEval
−0.038 (1W/2L/3T). Explains the conference result and scopes the journal
claim. [H: 2026-06-12 23:35], doc 12 §regime-split.

### F5 — Pareto vs scalar cells: small, seed-dependent `INCONCLUSIVE` (3 seeds)
qd_target − qd_scalar_elites (both vs classic): seed1001 +0.050,
seed1002 −0.026, seed1003 +0.014 (mean +0.013). 2 of 3 seeds favor
Pareto cells but the sign flips and the magnitude is within noise — no
robust attribution. Pareto cells are defensible as the principled
no-weighted-sum design (criticism #1), not as a measured performance
win. [H: 2026-06-13 08:00, 11:15, 20:10]

### F6 — Failure feedback repairs VALIDITY, not peak quality `MECHANISM-VERIFIED`
Full R-B mechanism (payload live-verified) moved pass rates exactly as
predicted — m2014_q3 3%→15%, circuit7 26%→62%, fsmonehot 21%→40% — yet
DEMOTED on best-quality (−0.086). Conclusion: the quality ceiling is set
by archive/selection on *valid* candidates → the P2 axis problem, not
the feedback problem. [H: 2026-06-12 21:45]

### F7 — The QD deficit is LOCALIZED, not diffuse `CONFIRMED` (2 seeds)
58% of the total best-quality loss vs classic concentrates in 3 of 13
problems (circuit7, alu, adder_8bit). circuit7 (−0.320) and adder_8bit
(−0.189) show IDENTICAL deltas across all four arms → no QD
configuration improves them at all (every arm stuck at the gen-0
seed). Meanwhile config genuinely moves others (multi_pipe_8bit:
qd_target +0.276 vs scalar −0.183; m2014_q6b: classic_unified ties,
six-op/target −0.199). Reading: "uniformly worse" is wrong — the
method is catastrophic on a specific intrinsic-limitation handful and
competitive-to-winning elsewhere, and the arm-variant problems are
where F2/F3 operator/cell choices act. Showcase + failure-panel
selection follows directly. Seed-1002 confirms: worst-3 = 62%
of loss (vs 58%), circuit7 + adder_8bit persistent. [H: 2026-06-13 09:35, 11:15]

---

### F9 — Branch C floor leg (i) FAILS the parity rule `CONFIRMED` (3 seeds)
`classic_unified` vs classic pooled (39 paired): −0.092, 4W/29L/6T,
CI [−0.149, −0.037] — CI low far below the −0.03 parity bar. Operator
unification is NOT an independent simplification win; it costs ~0.09 on
the classic substrate (only helps *within* QD, F2). Per the frozen
narrative this predeclares **venue reassessment IF the finals land in
Branch C** — making Fix B (closing the QD-vs-classic gap to reach
Branch B/A, where the floor leg is moot) load-bearing, not optional.
`exp/ablation_matrix/stats/floorleg_classic_unified_pooled` [H: 2026-06-13 13:40]

### F16 — RealBench-large eval pipeline FIXED + validated end-to-end `RESOLVED`
The invalid storyline run (0 valid candidates both arms) was an
eval-wiring bug, not a result. Bounded golden-decode probes (no LLM)
isolated FOUR gaps, each now fixed (commit f275b5a9c2):
1. Top module defaulted to `TopModule` — the runtime reads
   synthesis_top_module_names.json (absent in the RealBench root).
   FIX: the manifest builder now emits that file from the manifest
   top_module (single source of truth); backfilled to existing roots.
2. Post-synthesis functionality check did not thread include_dirs/
   defines, so a testbench that `include`s e203_defines.v and uses its
   macros in its own ports failed to compile vs the gate-level netlist.
   FIX: thread include_dirs/defines into `_check_synthesis_functionality`.
3. Post-synth pass parser only knew VerilogEval/RTLLM formats; the e203
   testbench emits `Total mismatched samples is N out of M`. FIX: mirror
   parse_mismatch_count's fallback so post-synth accepts the same runs as
   pre-synth.
4. VerilatorEvaluator lacked `enable_vcd_probe`; FIX: accept it and
   assert False (icarus_vcd dynamic metrics are incompatible with the
   verilator harness — fail loudly on misconfig).
**END-TO-END PROOF (M6):** the golden e203_exu_decode (53 KB, the
largest dependency-complete e203 module) now passes the FULL runtime
`evaluate_candidate` — pre-synth functional, yosys+OpenROAD synth+PPA
(area 714, power 2.55e-4), post-synth check, AND journal BD-trio
extraction (logic_depth 0, ff_depth 0, comb_width_log 6.51) — status
`success`, archiveable, benchmark golden intact. Earlier probe failures
were a mix of genuine missing-submodule deps (biu) and my probe passing
RELATIVE paths under the evaluator's cwd change (not an evaluator bug).
The ONLY remaining open question is now cheap to test: can the LLM
implement decode-class modules? (testable with a 1-module smoke). See
F17 for which modules are win-path-viable. [H: 2026-06-14 07:55]

### F17 — Dependency-complete e203 census defines the win-path subset `MEASURED`
Standalone verilator lint of all 40 e203 goldens with their manifest aux
shows 13/40 are dependency-complete; only 2 are ≥10 KB: **e203_exu_decode
(53 KB — the largest, validated end-to-end F16)** and e203_exu_disp
(14 KB). LEAF modules are complete; large INTEGRATION modules are NOT —
e203_biu/e203_core miss `e203_clkgate`, e203_lsu/e203_lsu_ctrl miss
`sirv_1cyc_sram_ctrl` (submodules instantiated but absent from aux_files).
Consequence: the original storyline subset (biu/ift2icb/lsu_ctrl) was
mostly dependency-INCOMPLETE — a second reason the F16 run failed.
SALVAGE: build the large win-path subset from dependency-complete modules
only. Near-misses (biu, core) are recoverable by adding `e203_clkgate`
(itself a complete 1.9 KB aux module) to their closure — a cheap way to
grow the large-sequential pool. NOTE for BD: decode is purely
combinational (ff_depth 0), so the subset must mix sequential modules for
the journal_logic_ff_width_3d trio to spread across all three axes.

### F18 — gpt-oss-120b CANNOT implement the largest module (decode) `MEASURED`
Bounded capability smoke (classic, gpt-oss-120b/OpenRouter, 8×gen,
seed 42) on e203_exu_decode: **24 candidates, 0 functionally valid.**
The candidates are 181–647 lines vs the 1234-line golden — i.e. ~half-
size or less, INCOMPLETE — and carry genuine Verilog errors (wire decls
inside procedural blocks, `unexpected endfunction`, duplicate ports,
`7'b???`, stray comma after `endmodule`). **Smoke VALIDITY confirmed
(M6):** re-evaluating a saved candidate through the validated
`evaluate_candidate` shows the testbench WAS found and it failed on the
candidate's OWN syntax — the "testbench file is missing" repeated in
`code_feedback.txt` is the FEEDBACK-LLM hallucinating (it misreads the
sim log), NOT a real eval bug; my F16 fixes hold. **Strategic
implication (the live risk to the win-path):** the win-path premise is
"QD pays off on LARGER designs with architectural room" — but the
largest dependency-complete module is LLM-INFEASIBLE, and the modules
the LLM might handle (≤14 KB, F17) sit in the same small-design regime
where QD already LOSES (F1/F15). The mid-size smoke (F19) maps exactly
where the model's ceiling falls. Process note: trust the run's
`status_counts`/raw eval for verdicts, never the feedback-LLM prose.
[H: 2026-06-14 09:10]

### F15 — Fix B does NOT transfer to the hard subset `MEASURED` (parity path closed)
Fix B hard-subset (seed 42, 20×5, 13 problems): −0.116 (1/10/2, CI
[−0.210,−0.037]) — vs frozen QD on the SAME subset ~−0.09 (matrix
qd_target −0.078/−0.101/−0.092). So Fix B is NOT better on the hard
subset; the fast-subset halving (−0.177→−0.087) was a fast-subset
ARTIFACT (that mix had refinement-amenable problems + 3 pre-existing
ties). On harder/more-architectural problems code-seeding anchors
(parallel2serial −0.486, fsmonehot −0.329, circuit7 −0.320 dominate;
multi_pipe +0.087 is the lone win). **Realization-side fixes do not
reach PPA parity on the real evaluation set — that path is closed.**
Remaining win-path: RealBench-large (task #16) or the characterization
framing. `exp/fast_iter/fixb_hard_subset/` [H: 2026-06-14 03:40]

### F14 — B′ hybrid worse; Fix B (all-seeded) is the ceiling `MEASURED`
B′ (fraction 0.5, half whole-regen leaps) = −0.141, WORSE than pure
Fix B −0.087; sub_64bit stayed anchored (flat ~0 vs classic 0.454 — the
leap samples did NOT recover it) and fewer seeded samples diluted the
refinement. Monotonic: more seeding is better (1.0 −0.087 > 0.5 −0.141
> 0.0 −0.177). **Fix B at fraction 1.0 is the optimum of this lever**;
anchoring on sub_64bit-class problems is intrinsic to thought→code
indirection, not fixable by sample mix. Deficit HALVED (−0.177→−0.087)
but NOT closed; parity not reached on the fast subset. Next: promote
Fix B to a hard-subset pair (confirm on the real set) + pivot to
RealBench-large (task #16) for an actual win. `exp/fast_iter/fixbprime_hybrid/`
[H: 2026-06-14 00:38]

### F13 — Champion lane HURTS; Fix B alone is the winning config `MEASURED`
Parity-fix ladder (vs classic, v3): frozen −0.177 → Fix A −0.167
(null) → **Fix B −0.087 (BEST, deficit halved)** → B+A −0.128 (A drags
B down). Adding the champion lane to B turned mux256to1v from a tie
into −0.330: concentration sacrifices the coverage that finds ties.
CORRECTS F11 — champion lane is not coupled-helpful, it is HARMFUL;
**Fix A / champion lane is ABANDONED.** Winning config = code-seeded
realization with NORMAL diverse parent selection. Remaining gap to
parity is the anchoring outliers (sub_64bit flat ~0 vs classic 0.30;
F10) → next experiment is hybrid B′ (split k samples: seeded refinement
+ whole-regen leaps). `exp/fast_iter/fixba_combined/` [H: 2026-06-13 23:40]

### F12 — Bake-off: no profile improves PPA; cheap control is diversity-healthiest `MEASURED`
Mechanical verdict (v3, quality-first rule): activity −0.103 (1/4/1) >
simple_2d −0.131 > trio −0.177 > graph_testability −0.186. **No profile
beats classic on PPA** — the descriptor choice is not the PPA lever
(consistent F6/F10: gap is indirection + selection, not axes). Diversity
health by COLLAPSE count: simple_2d (2) > graph_testability (8) >
activity (12) > trio (14) — the deliberately-cheap 2-axis control is the
most collapse-resistant; sophistication bought no diversity health.
Freeze is a DECISION (flagged, not auto-made): activity wins quality-
first but has high collapse; simple_2d/graph win diversity-health.
`exp/fast_iter/bakeoff_verdict` [H: 2026-06-13 22:40]

### F11 — Fix A (champion lane) alone fails `MEASURED` (coupling hypothesis SUPERSEDED by F13)
Champion lane alone: −0.167 (0/4/2) ≈ frozen target −0.177 — NO help,
and it HURT popcount255 (Fix B tied it, A lost −0.285). Reason: biasing
parents to the champion is pointless if realization then regenerates its
code from scratch (the indirection penalty still applies). So Fix A and
Fix B are NOT independent — A only pays off WITH B (pick the champion AND
refine its actual code). Combined B+A is the key parity config (queued
after bake-off). `exp/fast_iter/fixa_champion_lane/` [H: 2026-06-13 21:40]

### F10 — Fix B halves the deficit but anchors on leaps `MEASURED`
First intervention to MOVE the QD-vs-classic gap: code-seeded
realization scores −0.087 (0W/3L/3T, CI [−0.237,−0.002]) vs the
frozen-target −0.177 baseline on the same v3 subset — **deficit
halved**, 3 losses → ties. F8 signature partially restored
(mux256to1v champion climbs 0→0.305 at gen-2; frozen was flat). BUT a
new failure mode: on sub_64bit classic leaps to 0.454 at gen-1 while
Fix B stays ~0 — seeding ANCHORS to the parent architecture and blocks
the leap (−0.454 dominates the mean). Still DEMOTE alone; directionally
validated. Next: Fix A (running), combined B+A (reserve), and a hybrid
B′ (mix seeded refinement + whole-regen leap samples) to keep escape.
`exp/fast_iter/fixb_code_seeded/` [H: 2026-06-13 21:10]

### F8 — Why classic wins: champion never refined `MEASURED` (mechanism)
Generation trajectories (seed 1001): on losses QD's best NEVER improves
past gen-0 (adder flat 0.14, circuit7 flat 0.012, q6b flat −0.013) while
classic climbs — despite QD evaluating ≥ as many candidates. Two
confirmed causes: (M-i) parents sampled from diverse archive cells, not
the champion; (M-ii) thought-only regenerates code from scratch ("do not
refer to parent code") → no code-level hill-climbing. QD wins only on
architectural-leap problems (multi_pipe 0.254→0.512). Fix plan in doc 15:
thought-guided incremental realization (B), champion lane (A). The
deficit is tunable, not fundamental. [H: 2026-06-13 12:55]

## 3. Experiment result tables

### 3.1 Repair screens (fast subset, OpenRouter 32k, all DEMOTED)

| Screen | Factor | best-quality Δ | W/L/T | n | Note |
| --- | --- | --- | --- | --- | --- |
| k=2 | code_samples_per_thought 4→2 | −0.141 | 1/2/2 | 4 | degraded (5/6, stalls) |
| R-B fast | fail feedback | −0.177 | 0/4/2 | 6 | coverage-limited (empty fail pool) = baseline replication |
| R-C | warmup patience | −0.165 | 1/5/0 | 6 | fallback fired 4/6, no rescue |
| R-A′ | spec-first realization | −0.126 | 0/4/2 | 6 | coverage shadow |
| R-B regime (degraded) | fail feedback | −0.002 | 1/1/2 | 4 | payload bug found live |
| R-B regime v2 | fail feedback (full) | −0.086 | 0/2/2 | 4 | mechanism verified (F6) |

**Verdict:** all DEMOTE on quality → Branch C. Regime-scoped positives
(near-parity, pass-rate recovery) carried into the narrowed claim set.

### 3.2 Ablation matrix vs classic (best-quality; negative = arm worse)

| Arm | Isolates | seed 1001 | seed 1002 | seed 1003 |
| --- | --- | --- | --- | --- |
| classic_unified | unification on classic (Branch C floor) | −0.090 (1/9/3) | −0.102 (1/10/2) | −0.084 (2/10/1) |
| qd_six_operators | six ops within QD | −0.118 (2/10/1) | −0.130 (1/11/1) | −0.078 (1/10/2) |
| qd_scalar_elites | scalar vs pareto cells | −0.128 (1/10/2) | −0.075 (1/10/2) | −0.106 (0/11/2) |
| qd_target | the full package | −0.078 (3/8/2) | −0.100 (1/10/2) | running |

CIs (seed 1001): classic_unified [−0.156,−0.028], six_op [−0.179,−0.059],
scalar [−0.183,−0.075], target [−0.158,+0.008]. All exclude 0 except
qd_target (touches it) → every arm loses to classic, target least so.

### 3.3 Within-QD licensing (the operator headline contrast)

| Pairing | seed 1001 | seeds 1002-3 |
| --- | --- | --- |
| qd_target − qd_six_operators (both QD) | 1001 +0.040 / 1002 +0.006 / 1003 −0.015 | **3-seed pooled +0.011, CI [−0.006,+0.030] → PARITY (passes parity-or-better)** |

Positive = unified better. Seed-1001 CI above 0 → licensed (F2).
**The formal decision is the POOLED cluster-bootstrap across all seeds**
(narrative rule: pooled CI above −0.03 = parity, CI low > 0 = better),
emitted to `stats/licensing_pooled` by the helper once ≥2 seeds complete
— not the per-seed CIs above, which only track replication.

---

## 4. QD-gap root-cause dossier (Branch C content floor)

Three mechanisms, each with a verified exhibit (full paths in doc 12):

1. **Transcription poisoning** (spec-exact regime). The thought
   transcribes the spec wrongly (e.g. m2014_q3 interface indexing) and
   poisons all k realizations. [H: 2026-06-12 13:05]
2. **Missing failure feedback.** Fail parents reached the operator as
   {thought, status} only; the eval pipeline already named the defect.
   Fixed (`--qd_operator_fail_feedback_chars`); a propagation bug was
   found live (zero of 20 prompts carried the payload). [H: 13:05, 20:10]
3. **Descriptor degeneracy.** Journal trio collapses on 4/11 hard AND
   4/6 mid-size fast problems (all axes unique_count=1); R-C proved
   warmup policy cannot rescue degenerate axes. → the binding constraint
   is the *axes*, decided by the P2 bake-off. [H: 13:05, 18:30]

---

## 5. Infrastructure & methodology findings

| ID | Finding | Status |
| --- | --- | --- |
| M1 | OpenRouter robustness: SDK retries off + abandon-deadline + 32k completion cap + visible retries. Three stall layers, each masking the next. | `CONFIRMED` [H: 16:00, 16:50] |
| M2 | Budget parity CONFOUNDED toward QD: +12-38% completion tokens / calls at equal pop×gens. Disclosure required; finals need a budget-matching rule. | `CONFIRMED` [H: 15:40] |
| M3 | RealBench → verilator-only: identical 55/60 coverage, timing median 2.2s (10× fear wrong). Single upstream-matching harness. | `CONFIRMED` [H: 03:00] |
| M4 | logic_depth externally validated: 31/32 production candidates agree exactly with yosys ltp. | `CONFIRMED` [H: 23:55] |
| M5 | Descriptor trio survives redundancy bound (all axes \|r\|<0.8) but degenerates on small/mid designs → warmup-completion is the bake-off headline criterion. | `CONFIRMED` [H: 18:20] |
| M6 | Verification-before-verdict discipline caught 6 instrument/mechanism defects before they misled (empty pools, unreachable caps, dropped problems, template false-positive, hardcoded-empty feedback, licensing dir-vs-completion). | process note |
| M11 | **Candidate-eval path validated END-TO-END (closes the M10 gap).** M10 proved the standalone synth flow; M11 proves the actual runtime `evaluate_candidate` the QD/classic loop calls. Golden e203_exu_decode (53 KB) → status `success` through pre-synth functional + synth+PPA + post-synth check + journal BD-trio extraction, no LLM. Took 4 wiring fixes (F16) found by golden probing. Lesson reinforced (M6): validate the integration path, not just the component — M10's synth-only proof missed 3 of the 4 gaps. | `MEASURED` [H: 2026-06-14 07:55] |
| M10 | **Storyline-decider validated END-TO-END.** The full PPA flow (yosys+aux → OpenROAD floorplan → metrics) completes on the largest e203 module (alu_dpath 2143 cells): rc=0, design area 2525 µm², tns/wns/power extracted. M8's remaining unknown (OpenROAD-on-large) is CLEARED. Task #16 is confirmed-feasible plumbing, not a feasibility risk: relax manifest heuristic + thread aux through SynthesisEvaluator + re-lock subset + run QD-vs-classic. The win-path is technically viable. | `MEASURED` [H: 2026-06-14 04:15] |
| M9 | Bake-off occupancy tie-break is CONFOUNDED by collapse: a fully-collapsed 1-cell archive scores occ=1.00 (trio), gaming the metric. The per-axis COLLAPSE count is the truer diversity signal; the freeze tie-break should use it, not raw occupied/total. | `MEASURED` [H: 2026-06-13 22:40] |
| M8 | **Storyline-decider is FEASIBLE.** Large RealBench e203 modules synthesize cleanly in yosys with support files (alu_bjp 67, branchslv 587, alu_dpath 2143 cells, 0 errors) — `supports_synthesis: false` is a FALSE NEGATIVE from the `not support_files` heuristic, only 5/55 marked synthesizable. Unlock = relax heuristic + thread aux into SynthesisEvaluator (single-file today) + re-validate full yosys+OpenROAD+descriptor flow. Converts the storyline-decider from possibly-infeasible to feasible-pending-integration. | `MEASURED` [H: 2026-06-13 12:35] |
| M7 | Equivalence spot-check, COMPLETE picture: SOUND on fully-specified problems (adder_8bit candidate formally PROVEN vs ref — QD's solution genuinely correct, not testbench-lucky) but over-rejects on don't-care/unreachable inputs (q6b FSM testbench-pass yet NOT_PROVEN). Tool hardened on real data: separate gold/gate top names + submodule flatten. P4 spot-check scope = fully-specified problems, or care-set constraints. | `MEASURED` (2 real candidates) [H: 2026-06-13 11:55, 12:15] |

---

## 6. Open decisions & pending verdicts

**Pending verdicts (self-driving):**
- Ablation seeds 1002-1003 + qd_target/scalar 1002-3 → pooled operator decision (F2/F3)
- Bake-off triple → mechanical profile freeze (report_descriptor_bakeoff.py)
- Parity screens DONE: Fix B −0.087 (deficit halved, F10), Fix A −0.167 (no help alone, F11 — mechanisms coupled). **Combined B+A QUEUED after bake-off** (exp/queue_fixba_after_bakeoff.sh) = the key remaining parity experiment. If B+A reaches parity → hard-subset pair → Branch B; else consider hybrid B′ (preserve leap samples, fix the sub_64bit anchoring).

> **Operational reminder (run each wake):** `bash exp/run_licensing_pairings.sh`
> — idempotent; emits the within-QD `qd_six_operators` vs `qd_target`
> licensing pairing (the F2/F3 input) for every seed whose both roots
> exist. The matrix launcher does NOT emit this; it must be run separately.
> Then re-pull §3.3 from `exp/ablation_matrix/stats/licensing_*`.

**Strategic risk (NEW, F9):** Branch C floor leg (i) fails the parity
rule on the tuning ablation → venue reassessment is predeclared *if the
finals land in Branch C*. Mitigation path: Fix B + bake-off + RealBench
storyline must move the finals into Branch B/A (floor leg moot) or supply
an independent simplification win. This is now the project's central risk.

**Decisions requiring judgment at freeze (P4):**
- MDE ratchet: raise counts or drop the +0.03 best-quality gate (under-powered at 13×5; MDE 0.12). `exp/fast_iter/mde_hard_subset`
- Budget-matching rule for any positive QD claim (M2): token-equalized stopping vs disclosed asymmetry.
- Profile freeze: which of the 4 pre-registered profiles (or hybrid keeping logic_depth, M4).
- Equivalence spot-check scope (M7): restrict to fully-specified problems or add care-set/reachable-state constraints; do NOT report bare NOT_PROVEN on don't-care problems as a defect.

**Remaining execution:** CVDP/RealBench debug pairs · seed-42 debug gate · 5-seed finals (1001-1005) · manuscript.

---

## 7. Navigation map (where everything lives)

| Want… | Go to |
| --- | --- |
| **This** — current findings, organized by topic | doc 13 (here) |
| **Strategic posture** — contribution vs reviewer muster, the reframe | doc 14 |
| **Why classic wins + fix plan** — mechanism, ranked fixes | doc 15 |
| Chronological audit trail with full evidence | `revamp_history/.../journal_revamp_implementation_history.md` |
| Manuscript element → artifact path | doc 12 (evidence map) |
| Phase-grouped open/done checklist | `revamp_history/.../journal_revamp_implementation_todo.md` |
| Frozen claims/gates contract (wins on conflict) | `journal_narrative.md` |
| P1-P5 execution plan | `revamp_history/.../journal_revamp_plan.md` |
| Run ledger (machine-readable) | `revamp_history/.../rerun_ledger.jsonl` |
| Raw ablation stats | `exp/ablation_matrix/stats/<contrast>/` |
| Raw screen stats | `exp/fast_iter/<screen>/stats/` |
| Descriptor pre-registration | doc 11 |
| BD extractor validation vs literature | doc 10 |
| Fast-iteration instrument spec (G1-G5) | doc 09 |
