# 13. Findings Dashboard (searchable, topic-indexed)

**Purpose.** A single skimmable, searchable view of *what we have found
and how confident we are*, organized by topic rather than by time. This
is the orthogonal complement to the chronological audit log
(`revamp_history/.../journal_revamp_implementation_history.md`, 63+
dated entries) and the manuscript artifact index (doc 12). When a
finding cites `[H: YYYY-MM-DD HH:MM]` that is the history entry with the
full evidence; when it cites `exp/...` that is the raw artifact. For
**readable summary reports** of the headline experiments (per-problem
cross-arm bundles + isolated-grade per-task tables), see
`revamp_history/.../experiment_reports_index.md`.

**Confidence legend.**
`CONFIRMED` replicated across seeds / multiple substrates ·
`MEASURED` single clean run, direction verified ·
`PRELIMINARY` one seed, replication pending ·
`MECHANISM-VERIFIED` process confirmed live, outcome tracked separately.

**MAJOR UPDATE 2026-07-08 — suite-first natural_qd_push continuation
(`revamp_history/20260703_121857_KST_natural_qd_push/suite_variant_campaign/`):**
- Small-screen transfer is now treated as weak. The new campaign uses
  full RTLLM probes directly, with screens only for debugging/extraction.
- S01 capacity7 and S02 warmup16 are two-seed full-suite negatives for
  the primary target.
- S03 elite-pareto slot 2 was promoted after a two-seed signal, but the
  five-seed confirmation closed below classic on all primary gates:
  `0.100278` HV vs classic `0.103802`, `0.085114` HV-AUC46 vs classic
  `0.086982`, and `163/230` coverage vs classic `164/230`. It is only a
  secondary V2 final-HV recovery (`0.100278` vs V2 `0.098801`).
- S20 cell-crowded parent selection seed 1001 is a clean config-only
  negative for the primary HV target: `0.089752` HV / `0.082324`
  HV-AUC46 / `33/46` coverage versus matched classic `0.111401` /
  `0.090551` / `33/46` and V2 `0.096767` / `0.083539` / `32/46`.
  Complete seed 1002 before retiring it.
- Next queue: S20 seed 1002, then S21 scalar-elite retention before more
  capacity or warmup scans. A read-only audit recorded WARN, not FAIL:
  naturalness/operator parity are intact, but command templates and doc
  navigation needed this refresh.

**MAJOR UPDATE 2026-07-04 — the natural_qd_push campaign
(`revamp_history/20260703_121857_KST_natural_qd_push/`,
`central_comparison_report.md` there) supersedes several findings
below on operator-fair evidence:**
- **F33 (CONFIRMED, 3/3 seeds, operator-fair): the natural QD
  extension (Smooth-QD V2, faithful config incl. qd_num_cells 16 /
  warmup 8 / 5-elite Pareto cells) BEATS classic at screening scale:
  +12.9% mean HV, +16.2% canonical HV-AUC, coverage kept.** First
  replicated QD win in the program; the F1-era loss was the
  thought_only+single_thought substrate, not the archive.
- **F34 (MEASURED, 5 seeds): at full-suite scale V2 is HV-parity
  (95.2%; canonical CI spans zero), HV-AUC tie, coverage EDGE (166 vs
  164), and Branch-B utility 0.413 vs the 0.25 bar** — the diversity
  contribution (criticism #5) now has measured content; the +5% gate
  remains unmet (suite outcomes are LLM-capability-bound, consistent
  with F18-F32).
- **F35 (MEASURED, 7 profile/geometry combos): descriptor choice is a
  functionality/diversity/health dial, not an HV dial**; archive
  health anti-correlates with HV; only testability semantics lift
  coverage (random-floor falsification held); compact_8d ties trio HV
  with ~4x collapse resistance (M13 answer; swap candidate).
- **F36 (MEASURED, N04 follow-up): deeper equal-candidate budget shape
  is not the missing win lever for faithful V2.** At 6x7 on the frozen
  eight-design screen, V2 reaches final-HV parity/slight edge vs the
  verified classic comparator (101.1%, coverage kept) but loses HV-AUC
  (90.5%) and Pareto breadth. No 4x11 spend is justified.
- **F37 (MEASURED, N02b follow-up): curiosity-weighted parent sampling
  is a clean negative.** Gamma 1.0 lost gshare coverage; gamma 0.5
  recovered valid-PPA coverage but landed below classic (91.5% HV,
  92.5% HV-AUC) and far below V2 (74.0% HV, 79.7% HV-AUC). Do not scan
  gamma without a new mechanism card.
- **F38 (MEASURED, N07 due diligence): corrected-suite descriptor-only
  variants are not the missing win lever.** V2-faithful source-aligned
  RF timing and implemented structural compact both retain 8/8 coverage
  but close below classic (90.7% and 88.1% HV); descriptor paths that
  smoke-clear can still collapse on live generated candidates, while the
  RF/DeepGate hybrid arm fails the extraction gate before any live spend.
- **F39 (MEASURED, N09 follow-up): larger per-cell Pareto capacity is
  diagnostic, not a win lever.** Capacity 7 beats classic on mean
  HV/AUC (113.3% / 114.5%) but trails V2 (91.7% / 98.7%) and reduces
  Pareto breadth, so the V2 capacity of five is not the limiting factor.
- **F40 (MEASURED, N10 follow-up): SR-ReLU PCA is a clean descriptor
  result but not the missing win lever.** The frozen T19 artifact has no
  overlap with the 8-design screen and fresh ST-NOD extraction passed,
  but the live V2-faithful screen only beats classic (111.5% HV,
  108.3% HV-AUC) while trailing V2 (90.3% HV, 93.3% HV-AUC), with
  lower valid-PPA yield/front breadth and one all-axis collapse.
- Post-N10 decision map:
  `revamp_history/20260703_121857_KST_natural_qd_push/followup_decision_map.md`
  records the operator-fair negative map for N04/N02b/N07/N09/N10 and
  stops further one-knob screens unless a new mechanism card is
  registered. The formal negative-map adversarial validation report in
  the same directory records PASS for the exhausted-portfolio alternative
  outcome.
- The June-22 T-series negative map is OPERATOR-CONTAMINATED and must
  not be cited against archive/descriptor mechanisms (corrected
  reruns recover 30-46 retention points).

**Last refreshed:** 2026-07-08 (suite-first natural_qd_push full-RTLLM
continuation through S20 seed 1001; next S20 seed 1002/S21);
previously 2026-07-07 (natural_qd_push F36-F40 follow-ups, post-N10 negative-map PASS);
previously 2026-06-16 (held-out gap found, F25). The ablations +
characterization + smooth-QD are complete and 5-seed-locked **on the
tuning hard subset** — correctly scoped for the ablations (F2/F3), but the
frozen narrative's final gate on the **20-problem held-out reference set**
was, BY DECISION (2026-06-16), NOT run — the expected Branch-C-confirmed
outcome does not change the story, so the results are reported scoped as
tuning-set results with the held-out confirmation **disclosed as a stated
limitation / future work** (F25, doc 17 Disclosures). The remaining work is
the manuscript (#15). Finding IDs are stable.

---

## 0. Bottom line (read this first)

The journal is a rigorous **CHARACTERIZATION** of when QD/thought-level
structure helps LLM RTL search, plus **one positive contribution** — and
every answer to the five conference criticisms is evidence-backed:

- **F1 — the radical `thought_only` QD LOSES to classic** (5-seed −0.093,
  cluster-bootstrap CI [−0.149, −0.036], sign-test p=1.3e-05). Reported
  honestly, not hidden.
  Source: `exp/ablation_matrix/stats/final_5seed_F1_qt_vs_classic/statistical_tests.json`.
- **F2 — operator unification at clean PARITY within QD** (5-seed +0.001,
  CI [−0.008, +0.011], p=1.0, robust in all 5 leave-one-seed-out folds) —
  the missing operator ablation (criticisms #2/#3).
  Source: `exp/ablation_matrix/stats/final_5seed_F2_qt_vs_six/statistical_tests.json`.
- **F23 — SMOOTH-QD (V2 = code_individual + NSGA-II selection) adds
  diversity at NO significant quality cost** vs classic (5-seed −0.016, CI
  [−0.045, +0.007]); NSGA-II is necessary (V2−V1 +0.018, CI [+0.005,
  +0.032]). The positive contribution answering #1 (no scalar weight) + #5
  (diversity). Source: `exp/fast_iter/smooth_qd_nsga2/stats_5seed_vs_classic/`
  and `exp/fast_iter/smooth_qd_code_individual/stats_5seed_vs_classic/`.
- **F18–F21, F28, F30–F31 — on harder/newer benchmarks QD never beats
  classic; the limit is LLM capability, not search.** Two benchmarks:
  **RealBench e203** — a genuine capability ceiling: 0 valid on the 5 larger
  modules for every arm; on the 2 smallest classic 4 ≥ V2 3 > qd_target 2
  (F18–F21, F28; deepseek-v4-pro also 0 on large). **CVDP** — the initial 0/9
  was an interface-wiring confound (F30, fixed); with the fix the LLM solves
  **9/10 easy and 7/10 medium tasks, with classic = V2 on both** — QD adds no
  value even in the capable-but-hard regime; the sweet-spot hypothesis is
  falsified (F31/F32). So across the spectrum QD ties (small/easy) or is
  capped (hard), never wins. Sources: `exp/fast_iter/capability_remap/`,
  `exp/cvdp_easy_fixed/grade_cvdp_easy.json`, `exp/fast_iter/deepseek_capability_probe/`.

**Where to read more:** doc 17 = the paper's story (abstract /
contributions / results synthesis, with every number + source path); §2
below = per-finding detail (F1–F32, M1–M14); doc 14 = the candid
reviewer-muster read; doc 12 = claim→artifact-path map. Full chronology in
`revamp_history/.../journal_revamp_implementation_history.md`.

---

## 1. Status at a glance

| Phase | Title | State |
| --- | --- | --- |
| P1 | QD repair | **CLOSED → Branch C (now evidence-decided).** All screens + ablation + parity fixes done; Fix B halved the FAST deficit but did NOT transfer to hard (F15). The last win-path lever — RealBench-large (#16) — does NOT deliver a win: isolated re-eval shows valid candidates only on the 2 smallest e203 modules with classic 4 ≥ QD 2, and 0 valid on the larger ones (F20; the parallel run's "0/7" was an artifact, M12). So no QD PPA-win at scale. Branch C is the conclusion on evidence, not assumption. |
| P2 | BD / descriptor thesis | **DONE.** Bake-off complete (F12); profile FROZEN to the trio per the predeclared rule (§6). NEW: smooth-QD track (doc 16, F22) tests QD as a parity+diversity augmentation. |
| P3 | Benchmark vetting | **DONE.** RealBench verilator-only (55/60). Storyline-decider CONCLUDED: QD does not win at scale (F20); stronger-model probe closer-but-still-0 (F21). |
| P4 | Gates / freeze | **DONE.** All freeze decisions settled (profile, MDE, budget rule, equivalence scope — §6). 5-seed finals COMPLETE; F1/F2 locked (§0/§2). |
| P5 | Manuscript | **Ready to write.** Spine (doc 17) carries every confirmed 5-seed number + source path; evidence base + case study de-risked (F24); lives in journal_draft Overleaf submodule (user-authored). |

**Win-path status (#16): CONCLUDED — QD does not win (F20).**
The full investigation ran its course: infra fixed + validated end-to-end
(F16/M11), dependency-complete census (F17), a missing-include confound
caught and fixed (F19), AND a parallel-eval reliability artifact caught
and worked around with isolated re-eval (M12). The corrected,
authoritative storyline-decider (isolated re-eval, classic vs QD, 7
modules): **the LLM produces valid candidates only on the 2 SMALLEST
modules (<6 KB); classic 4 valid ≥ QD 2; larger modules (incl. decode
53 KB) 0 valid** (F20). QD shows more behavioral diversity but converts
it into FEWER valid candidates (diverse-but-wrong). So **QD does not beat
classic at RealBench scale**: the buildable modules are back in the small
regime where classic already wins (F1), and the large-design regime is
LLM-infeasible. The "QD beats classic on RealBench-large PPA" headline is
unsupported. **This is not a wasted leg:** it converts criticism #4 into
a real RealBench-scale result and extends the regime-sensitivity thread
(F4) — the binding limit at real-CPU scale is LLM spec-comprehension.
**Probe CONCLUDED (F21):** the deepseek-v4-pro capability probe narrowed
the mismatch (disp 21%→6%, branchslv 25%→8%) but still produced 0 valid on
the large modules → the ceiling is MODEL-GENERAL, not gpt-oss-120b-specific.
Win-path stays closed.
**The finals are the CHARACTERIZATION paper (Branch C), now decided on
evidence, not assumption.**

---

## 2. Headline findings

### F1 — QD does not beat classic on best-quality at this budget `CONFIRMED` (5-seed)
**5-SEED FINALS (official report_journal_statistics): qd_target −
classic pooled −0.093, cluster-bootstrap CI [−0.149, −0.036], 13
clusters, sign-test p=1.3e-05 — the radical thought_only QD
SIGNIFICANTLY loses.** _(Source:
exp/ablation_matrix/stats/final_5seed_F1_qt_vs_classic; DIY matches to 4dp.)_ (Earlier 2-3 seed reads −0.08..−0.13 confirmed.)
Every QD/unified arm loses to classic (see §3.2).
Decision: predeclared **Branch C** (narrowed claims + content floor).
The deficit is *pure PPA quality* — functionality tied 9/9 on the
genuine-hard intersection. [H: 2026-06-12 21:45]

### F2 — Operator unification at clean PARITY within QD `CONFIRMED` (5-seed)
**5-SEED FINALS (official): qd_target − qd_six_operators pooled +0.001,
cluster-bootstrap CI [−0.008, +0.011], sign-test p=1.0, win-rate 48.8%
(coin-flip) — dead-on PARITY, well within ±0.03 (tighter than the
3-seed).** _(Source: exp/ablation_matrix/stats/final_5seed_F2_qt_vs_six.)_
**Contract-compliant per journal_narrative.md §decision-rule: the
penalized (gate-bearing) CI == complete-case (no floor-imputation
triggered), CI low −0.008 > −0.03 ⇒ passes the frozen parity rule; and
LOSO penalized parity holds in ALL 5 leave-one-seed-out folds (worst,
drop-1001, CI low −0.026 > −0.03) — robust to any single seed.** The unified
operator = the six-operator suite + un-ablated bandit, within QD, at no
cost — the ablation criticisms #2/#3 demanded, confirmed at 5 seeds.
_(Original 3-seed entry below.)_
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

### F18 — decode capability smoke: 0/24 valid, but CONFOUNDED `SUPERSEDED by F19`
**CORRECTION (2026-06-14 ~09:30):** the "0 valid → capability-blocked"
reading below was measured through a CONFOUNDED harness — candidates
omit `\`include "e203_defines.v"` and died at preprocessing on undefined
macros, masking their real logic (see F19 for the confound + fix). The
0/24 count is real, but the *interpretation* (LLM-incapable) was
premature; decode candidates DID also carry genuine syntax/incompleteness
errors, but the clean signal awaits the post-fix re-map. Original entry
retained below for the audit trail.

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

### F19 — The smokes were CONFOUNDED by a missing-include; harness fixed `MEASURED`
The mid-size smoke (6 dependency-complete EXU modules, 4.7–14 KB) also
returned **0/6 valid each** — which looked like a comprehensive
capability wall. M6 ground-truthing overturned the interpretation: the
small wbck candidates are *plausible, complete* implementations that
fail **only** because they use `E203_XLEN` without `\`include
"e203_defines.v"`. The e203 modules depend on a project-global defines
header; verilator preprocesses each file independently, so a candidate
resolves the macros only if it includes the header — the LLM is told to
(prompt line 67) but routinely omits the one line, failing every
candidate at preprocessing. **Fix (commit d289e1c226):** classify aux
into module-sources vs defines-headers; force-include the entry header
into the candidate file for both functional and synth compiles
(`item.code`/archive stay raw). Validated: goldens still pass; saved
wbck candidates now COMPILE and reach functional eval. **TRUE signal
(post-fix):** candidates compile but are functionally WRONG — wbck gets
6610/16021 mismatches (~41%), and *all candidates get the identical
mismatch count*, i.e. a SYSTEMATIC same spec-misread (the F7/F4
mechanism), not random noise. So the capability concern is genuine, but
its magnitude was over-stated by the artifact. Disclosed methodology
choice: force-including the design's global header makes the e203 task
("implement the logic") comparable to the self-contained VerilogEval/
RTLLM problems. [H: 2026-06-14 09:30]

**RE-MAP RESULT (post-fix, classic, 2026-06-14 09:55) — [PARTLY CORRECTED
by M12/F20]:** the parallel run reported all 7 modules 0/8 valid, all
`failed_functionality`. **This count is UNRELIABLE** — isolated re-eval
(F20) recovers 4 valid classic candidates the parallel run spuriously
failed under contention (M12). What IS robust here: the fix worked
(candidates COMPILE and reach simulation, not syntax/include), and the
LARGER modules genuinely get 0 valid even in isolation. The valid
candidates appear only on the 2 smallest modules — see F20 for the
corrected counts. The QD arm (`exp/fast_iter/capability_remap/qd`)
is running to settle the actual win-path hypothesis — does diverse
thought-level search break the classic monoculture error (all classic
candidates share the identical mismatch) and get closer to correct? See
F20. [H: 2026-06-14 09:55]

### F32 — CVDP medium tier (capable-but-hard): classic 7/10 = V2 7/10; sweet-spot hypothesis FALSIFIED `MEASURED`
The decisive test of the F29 "capable-but-hard sweet spot" — the one regime
where QD's diversity could plausibly help. Fixed-prompt medium CVDP (classic +
smooth-QD V2, 10 smallest-context tasks, seed 42, pop20×5gen), isolated-graded
(`exp/cvdp_medium_fixed/grade_cvdp_medium.json`): **classic solves 7/10, V2
solves 7/10 — and they solve the EXACT SAME 7, miss the SAME 3** (bus_arbiter,
fifo_async, neuromorphic_array). Medium IS genuinely the capable-but-hard
regime (7/10 vs easy's 9/10 — the LLM solves fewer), and **even there QD does
not help**: V2 found no solution classic missed. **The sweet-spot hypothesis
is FALSIFIED.** Combined with small (F1 lose / F23 no-cost), easy-CVDP (9/10
tie, F31), and hard-RealBench (capability ceiling, F28), this completes the
picture: **QD never beats classic across the ENTIRE difficulty spectrum** —
the capable-but-hard regime included. QD is a no-significant-cost diversity
augmentation, never a winner. Caveat: any-pass (30-sample, seed 42); a finer
pass-rate comparison wasn't run, but the identical solved set is a strong
negative for "QD finds solutions classic misses." [H: 2026-06-16]

### F31 — Fixed CVDP (easy tier): LLM solves 9/10; classic = V2 (QD doesn't help in the capable regime) `MEASURED`
With the F30 fix, the fixed-prompt easy-tier run (classic + smooth-QD V2, 10
tasks, seed 42, pop20×5gen), graded by isolated re-eval (M14 mitigation,
`exp/grade_cvdp_isolated.py` → `grade_cvdp_easy.json`; early-exit any-pass,
30-candidate sample, 25s process-group-killed timeout): **classic solves 9/10
tasks, smooth-QD V2 solves 9/10 — a TIE** (both miss only perfect_squares).
**Two conclusions:** (1) **F30 confirmed at scale** — the LLM is highly
capable on easy CVDP once it sees the interface (9/10), so the prior 0/9–0/10
was entirely the wiring confound, not capability. (2) **QD does NOT help in
the capable regime** — classic = V2 = 9/10; diversity adds no value when the
LLM already solves the task (consistent with F1). **The hoped-for
"capable-but-hard sweet spot" (F29) did not materialize**: easy CVDP is
*capable-and-easy* (both solve it). So across the difficulty spectrum QD never
beats classic — small (F1/F23 tie/no-cost), easy-CVDP (9/10 tie),
hard-RealBench (capability ceiling, F28). Caveat: any-pass within a 30-sample,
seed 42 (debug); a finer pass-rate comparison wasn't run (M14 + hanging-sim
intractability), but the any-pass tie is robust. [H: 2026-06-16]

### F30 — CVDP "capability ceiling" was an INTERFACE-WIRING CONFOUND (F19-class); fixed `MEASURED`
**The CVDP 0-valid results (F27 medium 0/9, easy probe 0/10) are NOT a
capability ceiling — they are a prompt-wiring artifact.** `build_cvdp_problem_context`
set `problem_description = input.prompt` ONLY, dropping `input.context` — the
buggy module to edit AND its **exact port/parameter interface** the cocotb
harness drives. The model never saw the interface → invented port names
(`binary`/`gray`/`N`) while the harness drives `binary_in`/`gray_out`/`WIDTH`
→ every candidate failed on **interface mismatch regardless of logic**.
**Proof chain:** (1) a probe candidate had CORRECT logic
(`gray = binary ^ (binary>>1)`) but wrong ports; (2) a hand-written
correct-interface solution PASSES the harness (returncode 0 — so the harness
is sound and CAN pass); (3) with the fix, candidates now emit the correct
interface (`binary_in`/`gray_out`/`WIDTH` confirmed in the re-run). **Fix
(committed):** thread `input.context` source files into the prompt with a
preserve-the-interface instruction + regression test. **Consequence: the
CVDP "capability ceiling" framing in F27/F28/§0 is RETRACTED pending the
fixed re-run** — CVDP is testable and likely largely solvable; a fixed re-run
gives the TRUE classic-vs-QD signal (the capable-but-hard regime). **RealBench
(F18–F21) is UNAFFECTED** — those are genuinely large designs with a real
ceiling (the interface is provided there). **END-TO-END CONFIRMED:** with
the fix, the LLM's own binary_to_gray candidate is correct + lint-clean +
right-interface AND PASSES the cocotb harness in isolated re-eval (rc=0) —
so CVDP is solvable; the ceiling was the confound. (Note M14: the in-run
CVDP functional eval still under-reports that pass — grade CVDP by isolated
re-eval, à la F20.) This is the THIRD eval-wiring confound caught by
ground-truthing a surprising 0 (cf. F19, M12) — the M6 discipline earned its
keep again. [H: 2026-06-16]

### F29 — Why the framework fails at scale: search amplifies capability; correctness is near-binary `ANALYSIS`
Synthesis of the harder-benchmark results (F18–F21, F27, F28) into a
root-cause + future-work map (manuscript limitations/future-work content).
**Mechanism:** (1) classic and QD are a SEARCH/REFINEMENT layer on top of LLM
generation — they amplify capability the base model already has, which on
hard designs is **~0 functionally-valid seeds** (model-general: deepseek-v4-pro
also 0, F21). (2) RTL functional correctness is **near-binary with no
climbable gradient**: the best *failing* candidates on the unsolved RealBench
modules are 20–100% mismatched (min-mismatch fracs {0.21, 0.25, 0.33–0.41,
0.66–0.88, 1.0}) — a chasm, not a slope. So QD's diversity yields
*diverse-wrongness*, not correctness; there are no partial-success stepping
stones to recombine. **Binding constraint = base-model spec-comprehension +
the discontinuous correctness landscape, NOT the search algorithm** — which is
why #4 is correctly framed as a capability characterization.
**Future-work levers (by leverage):** (1) ~~CVDP capable-regime test~~ **DONE
— sweet-spot FALSIFIED (F31/F32):** after the F30 interface fix, classic = V2
on both easy (9/10) and medium (7/10, the genuine capable-but-hard regime) —
QD found no solution classic missed, so the hypothesized sweet spot does not
exist for this model. (2) **stronger base model** on the hard benchmarks
(does the ceiling lift?); (3) **hierarchical / decomposition generation** —
the real framework fix for "too large for one-shot," a genuine method
contribution; (4) **richer functional feedback** (detailed cocotb failure →
targeted repair) — climbs the gradient only where mismatch is already small.
[H: 2026-06-16]

### F28 — Smooth-QD V2 on RealBench: 3 valid, classic ≥ V2 > qd_target (gap closed) `MEASURED`
Closed the one experimental gap (user-greenlit 2026-06-16): smooth-QD V2
(code_individual + NSGA-II, our chosen method) on the same 7 dependency-
complete e203 modules as the classic + qd_target arms (pop8×1gen, seed 42),
graded by isolated re-eval (`exp/grade_mismatch_v2.py` → `grade_mismatch_v2.json`,
the M12 mitigation). **TOTAL valid: classic 4 ≥ qd_v2 3 > qd_target 2** — all
valids on the 2 SMALLEST modules (alu_csrctrl, alu_rglr); **0 valid on all 5
larger modules (wbck/branchslv/disp/longpwbck/decode) for EVERY arm.** So V2
beats the radical qd_target (consistent with V2 being the better QD form) but
**still does not beat classic**; the capability ceiling on the large modules
dominates all arms. Nuance: V2 got CLOSER on longpwbck (min-mismatch 0.66 vs
classic 0.86 / qd_target 0.88 — diversity narrowing the gap) but not valid.
Caveat (per F20): the small modules have weak coverage, so the robust reading
is "no method beats classic; all tie at 0 on the large modules," not the
precise 4/3/2. **This completes the #4 story: on BOTH harder benchmarks
(RealBench + CVDP, F27) our chosen method V2 does NOT beat classic — the
binding limit is LLM capability, not search.** [H: 2026-06-16]

### F27 — CVDP debug probe: 0/9 functional pass `MEASURED` — but CORRECTED by F30 (interface-wiring confound, not capability)
The user-greenlit CVDP debug-seed probe (seed 42, pop20×5gen, 9 tasks after
pruning the context-overflowing perceptron_0006) completed cleanly (no
overflow on the 9). **Result: 0/9 functional pass for ALL THREE arms —
classic 0, qd_target 0, qd_v2 0** (`exp/cvdp_debug_probe/{classic,qd_target,
qd_v2}`, `stats_*`). Per-task all zero. So on this newer/harder benchmark,
QD's diversity cannot manifest an advantage because **no candidate clears
the functional bar** — the binding limit is LLM spec-comprehension, not
search. **This MIRRORS the RealBench capability ceiling (F18–F21): criticism
#4 ("benchmarks too small") is now answered by TWO independent harder
benchmarks** (real-CPU e203 + CVDP cocotb design tasks), both showing the
gpt-oss-120b capability wall. Validation level: the cocotb harness is
confirmed to compile candidates + run the functional assertions (F26: 7/12
reached assertions + failed), but **no PASS has been observed** (CVDP
withholds goldens; a hand-written-correct-solution pass-confirmation is the
residual validation). **Task-consistency cross-check (rules out a "broken
task" explanation):** sync_lifo's spec says reset active-high; the cocotb
test's `reset_dut(active=False)` drives reset high-then-low = an active-high
pulse — consistent with the spec (the "active low" code comment is a
misleading copy-paste, the behavior is correct). So a spec-following
candidate is reset correctly; the 0/9 is genuine difficulty, not a
task-polarity artifact. Also disclose: perceptron_0006 excluded (exceeded
gpt-oss-120b's 131k window at Gen2 — itself a #4 size signal). [H: 2026-06-16]

### F26 — CVDP harness is OPERATIONAL locally; the probe's 0% is GENUINE difficulty `MEASURED`
User greenlit a debug-seed CVDP probe (2026-06-16). **First-ever
revolution+CVDP run** — all prior CVDP runs used the CodeEvolve baseline.
**The path runs and the cocotb functional harness WORKS LOCALLY** (NOT
Docker-blocked — `test_runner.py` uses `cocotb_tools.runner` with
`SIM=icarus`; the evaluator correctly localizes the `.env`
`VERILOG_SOURCES`/`PYTHONPATH` from container paths). Ground-truthed by
re-running all 12 classic seed-42 candidates through the harness:
**5/12 COMPILE_FAIL (iverilog exit 2), 7/12 compiled + ran the cocotb test
then FUNCTIONAL-FAIL, 0 pass.** The 7 func-fails prove the harness reaches
the functional assertions. **So the 0% is GENUINE**, not a harness
artifact: `cvdp_copilot_generic_nbit_counter_0039` is a hard multi-mode
counter (binary/Johnson/Gray/Ring + typedef-enum) and the tiny pop4×2gen run
produced syntax errors + functionally-wrong solutions. **(Corrects this
finding's first version, which wrongly concluded "infra-blocked / can't
ground-truth".)** Invocation gotcha: CVDP needs `--cvdp_categories all`
(else `select_cvdp_ids` throws and `_discover_tasks` asserts). **Consequence:
CVDP IS testable** — a real classic-vs-QD CVDP comparison is feasible (run
the proper debug probe with adequate budget). Early #4-relevant signal: CVDP
is genuinely HARDER than RTLLM/VerilogEval (classic scored 0% on a hard task
at small budget). `exp/cvdp_probe_precheck/classic`. [H: 2026-06-16]

### F25 — Held-out final gate not run; tuning-set-scoped by decision `SCOPED — documented limitation`
The frozen narrative requires the QD-vs-classic FINAL gate + the branch
decision "Evaluated on the held-out/fresh final sets after the 5-seed runs"
(journal_narrative.md L224/L232); the 13-problem hard subset is explicitly
a TUNING set whose numbers are "reported scoped as tuning-set results."
**Reality:** the 5-seed F1 (QD-vs-classic) AND F23 (smooth-QD) ran on the
hard subset (tuning). The 20-problem held-out reference set
(`data/configs/holdout_reference_subset.yaml`, seed 7777, disjoint from
hard+fast) has **0 runs.** So goal criterion (1) — "QD-vs-classic resolved
on HELD-OUT statistics; never a tuning-set headline" — is **NOT met.** (F2's
operator ablation on the hard subset IS correct — the ablation protocol is
predeclared on the tuning set and "never enters held-out gate statistics.")
**DECISION (2026-06-16, user): the held-out final gate will NOT be run** —
the expected outcome (Branch C confirmed, QD loses −0.093 on tuning → near-
certain on held-out) does not change the story, so the multi-day compute is
not justified for a confirmatory negative. The QD-vs-classic + smooth-QD
results are therefore reported **scoped as tuning-set (hard-subset)
results** — which the narrative explicitly permits ("hard-subset final
numbers are reported scoped as tuning-set results") — with the **held-out
confirmation disclosed as a stated limitation / future work** in the
manuscript (see doc 17 Disclosures). **Caveat the paper MUST carry:** Branch
C floor leg (i) requires the operator simplification "independent of QD's
fate" — F9 falsified that (within-QD only); the manuscript leans on the new
smooth-QD contribution (F23) for the #1/#5 legs and discloses the held-out
gate as unrun. This is now a documented limitation, not an open task.
[H: 2026-06-16]

### F24 — Case-study equivalence needs a fully-specified problem `MEASURED`
The narrative's case-study artifact "archive heatmap with equivalence-
checked Pareto solutions" needs TWO source problems, not one. The
predeclared heatmap source Prob135_m2014_q6b has a DON'T-CARE reference
(`default: Y1 = 1'bx` for y in {6,7}), so its 8 archive/cell solutions are
testbench-valid but NOT formally equivalence-provable: yosys returns 0/8
PROVEN (all NOT_PROVEN, "1 unproven $equiv cell" — candidates pick concrete
values in the don't-care region). This is exactly the case the frozen scope
rule anticipates ("equivalence spot-check on fully-specified problems
only", doc 12). HARNESS VALIDATED: on the fully-specified
Prob150_review2015_fsmonehot (0 don't-cares, sequential FSM),
scripts/check_equivalence.py proves 1/1 EQUIV (equiv_induct handles state).
RECOMMENDATION for the manuscript: keep Prob135 for the multi-cell archive
heatmap (disclose its solutions as testbench-validated — spec has a
don't-care, formal equivalence out of scope), and report the equivalence
pass-rate on a fully-specified problem (Prob150, 1/1). Artifacts:
`exp/fast_iter/hard_subset_42/qd/revolution/openai-gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob{135_m2014_q6b,150_review2015_fsmonehot}/equivalence_spotcheck`. [H: 2026-06-16]

### F23 — Smooth QD: NO SIGNIFICANT quality cost vs classic (5-seed) `MEASURED`
The smooth-integration salvage works, now confirmed at 5 seeds (matching
the F1/F2 standard — the evidentiary asymmetry is closed). Two-step: V1
(code_individual, drop indirection) recovers -0.10 -> SIGNIFICANTLY worse
(5-seed -0.034, CI [-0.066,-0.009], entirely <0); **V2 (V1 + NSGA-II
global-rank selection) is statistically INDISTINGUISHABLE from classic —
5-seed pooled -0.016, cluster-bootstrap CI [-0.045,+0.007] (includes 0),
sign-test p=0.17.** The +2 seeds TIGHTENED the CI ([-0.077,+0.014] ->
[-0.045,+0.007]) and moved the mean toward 0 (-0.026 -> -0.016); per-seed
V2 is robust (-0.011/-0.034/-0.029/+0.007/-0.014, no outlier). **NSGA-II
is NECESSARY and its benefit is now STATISTICALLY DEMONSTRATED: V2 - V1
+0.018, CI [+0.005,+0.032], entirely >0.** The CI still does NOT clear the
frozen tight-parity bar (low > -0.03) because the residual variance is
localized to the exploitation-heavy PPA-margin problems (alu -0.153,
parallel2serial -0.086 pooled; F7) — a capability limit, not a seed-count
one (confirms "variance, not mean, is the limiter"). **Supportable claim:
"QD + NSGA-II diversity augmentation at NO statistically significant
quality cost vs a strong classic baseline (CI includes 0),"** answering
#1 (principled selection, no scalar weight) + #5 (diversity) — a positive,
honestly-hedged contribution, NOT "demonstrated tight parity." Official
5-seed: penalized == complete-case (no imputation). `exp/fast_iter/smooth_qd_{code_individual,nsga2}/stats_5seed_vs_classic` [H: 2026-06-16 ~07:00 5-SEED FINAL]

### F22 — Smooth QD (code_individual) NEAR-PARITY; V2 implemented `MEASURED`
The smooth-integration thesis is substantially VINDICATED. Full 13-problem
V1 (code_individual + eoh operators + champion lane 0.5 + BD-trio archive)
vs classic seed 1001, best-quality delta: **MEAN -0.032 (3W/3L/7T),
10/13 within the parity band** - a dramatic improvement over thought_only
QD (-0.08..-0.13, F1) and right at the frozen parity boundary. The ENTIRE
deficit is 3 exploitation-heavy PPA-margin problems (alu -0.256,
parallel2serial -0.150, multi_pipe -0.052); the other 10 are tied (7) or
better (3). So removing the thought->code indirection recovered nearly
all the lost performance - the indirection WAS the main culprit (F7/F8).
Whether V1 PASSES the frozen rule (cluster-bootstrap CI low > -0.03) is
borderline given the alu outlier; the launcher's paired CI is the verdict
(single seed; finals need multi-seed). **V2 (NSGA-II global-rank
selection, IMPLEMENTED commit 0ee4a8a983, doc 16) is queued** - it
prefers high-quality rank-1 individuals, directly targeting the 3
exploitation problems that are V1's whole residual. If V2 closes them ->
parity-or-better -> a genuine POSITIVE QD contribution (parity + diversity,
answering #1 + #5). `exp/fast_iter/smooth_qd_code_individual` [H: 2026-06-14 15:30]

### F21 — Stronger-model probe: closer but still 0 valid (leans model-general) `MEASURED`
**VERDICT (isolated re-eval, classic arm, 12 candidates/module):**
deepseek-v4-pro vs gpt-oss-120b — decode (53 KB) 0 valid, 100% vs 100%
(unchanged, hopeless for both); disp (14 KB) 0 valid, **6.35%** vs 21%;
branchslv (5.9 KB) 0 valid, **7.69%** vs 25%. So a stronger model gets
MUCH CLOSER on the mid/small modules (mismatch ~3× lower) but STILL
produces 0 functionally-valid candidates, and the largest module is
unchanged. **Read:** leans MODEL-GENERAL — the win-path does NOT cleanly
reopen (0 valid → no PPA comparison). BUT the 6–8% mismatch on disp/
branchslv is close, so more v4-pro attempts on the *closest* modules
MIGHT cross to valid — a remaining (uncertain) lever, not a hard wall.
The largest-module ceiling (decode 100% both) is genuinely model-general.
Manuscript value: a model-strength GRADIENT (capability improves with
model strength but doesn't cross the validity threshold on real CPU
modules) — strengthens the criticism-#4 characterization either way.
`exp/fast_iter/deepseek_capability_probe` [H: 2026-06-14 14:00]

### F21-orig — Stronger-model probe (deepseek-v4-pro): launched `SUPERSEDED by verdict above`
F18-F20 established the capability ceiling for **gpt-oss-120b**. Open
question (user-prompted): is the ceiling MODEL-SPECIFIC or model-general?
Probe (`exp/fast_iter/deepseek_capability_probe`, classic arm,
deepseek-v4-pro via the direct DeepSeek API, low 2-way concurrency to
protect the running gpt-oss finals): the 3 modules gpt-oss FAILED —
decode (53 KB, 100% mismatch), disp (14 KB, 21% — closest), branchslv
(5.9 KB, 25%). **Pre-registered interpretation (M6):** (a) if v4-pro
produces ≥1 functionally-valid candidate on a module gpt-oss got 0 on
(esp. decode/disp) → capability GAIN → the RealBench-large win-path
REOPENS → run DeepSeek QD-vs-classic on the viable modules (potential
Branch A/B); (b) if v4-pro also gets 0 valid on those → the ceiling is
MODEL-GENERAL → strengthens the characterization (large-CPU RTL is hard
for current LLMs, not just a weak model). CAVEAT: isolated-re-verify any
"valid" v4-pro candidate (M12 lesson) before trusting it; small modules
have weak coverage (F20). Note: any DeepSeek gate-bearing comparison runs
DeepSeek on BOTH arms (same-provider rule). [H: 2026-06-14 13:40]

### F20 — Storyline-decider (CORRECTED, isolated re-eval): QD does not win `MEASURED`
The parallel run's "0/7" was a SECOND artifact (see M12: 14-way
contention caused spurious failures). The authoritative measurement is
ISOLATED, deterministic re-eval of every saved candidate, both arms
(`grade_mismatch_compare.json`). True per-module valid-candidate counts
(of 16 attempts each), classic vs QD:

| module | KB | classic | QD | best mismatch (both) |
| --- | --- | --- | --- | --- |
| decode | 53 | 0 | 0 | ~100% |
| disp | 14 | 0 | 0 | ~21% |
| longpwbck | 7.5 | 0 | 0 | ~85% |
| branchslv | 5.9 | 0 | 0 | ~25% |
| **alu_csrctrl** | 5.6 | **2** | **1** | 0% (valid) |
| wbck | 4.8 | 0 | 0 | ~33% |
| **alu_rglr** | 4.7 | **2** | **1** | 0% (valid) |

Totals: classic 4 valid, QD 2 valid. **Findings:** (1) the LLM produces
valid candidates ONLY on the 2 SMALLEST modules (<6 KB) — the larger
modules (decode/disp/longpwbck/branchslv/wbck) get 0 valid even in
isolation; (2) where comparison is possible, **classic ≥ QD** (4 vs 2) —
QD does NOT win; (3) QD shows MORE behavioral diversity (more distinct
mismatch values, e.g. disp 7 vs 4; alu_rglr 6 vs 4) but converts it into
FEWER valid candidates — diverse-but-wrong, not closer-to-correct (best
mismatch is ~identical across arms per module). **Win-path verdict
(unchanged in conclusion, corrected in evidence):** QD does not beat
classic at RealBench scale; the buildable modules are back in the small
regime where classic already wins (F1), and the large-design regime is
LLM-infeasible (decode 0 valid, 100% mismatch). CAVEAT: small modules
have weak coverage (alu_csrctrl only 27 compared samples vs wbck 16021),
so their "valid" is weak evidence — the strongest reading is the
gradient, not the 4-vs-2 count. [H: 2026-06-14 10:35]

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
| qd_target | the full package | −0.078 (3/8/2) | −0.100 (1/10/2) | −0.092 (1/9/3) |

CIs (seed 1001): classic_unified [−0.156,−0.028], six_op [−0.179,−0.059],
scalar [−0.183,−0.075], target [−0.158,+0.008] (touched 0 at 1 seed).
**5-SEED POOLED (official): qd_target − classic −0.093, CI
[−0.149,−0.036], sign-test p=1.3e-05 — every arm loses to classic,
qd_target least so but clearly (CI excludes 0). Per-seed: −0.078 /
−0.101 / −0.092 / −0.097 / −0.096 (seeds 1001-1005, all <0).**

### 3.3 Within-QD licensing (the operator headline contrast)

| Pairing | seed 1001 | seeds 1002-3 |
| --- | --- | --- |
| qd_target − qd_six_operators (both QD) | +0.040 / +0.006 / −0.015 / −0.023 / −0.005 (1001-1005) | **5-SEED pooled +0.001, CI [−0.008,+0.011], p=1.0, win-rate 48.8% → clean PARITY (coin-flip; tighter than 3-seed +0.011/[−0.006,+0.030])** |

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
| M12 | **Parallel evaluation UNDER-COUNTS valid candidates (contention) — THREAT TO VALIDITY.** The capability_remap run (14 worker slots, 7 modules × heavy synth) marked deterministically-VALID candidates as `failed_functionality`; isolated re-eval recovers them (classic 4 valid vs the run's 0 — F20). The functional eval is deterministic (verilator seeds `$urandom` stably; verified 3× identical), so the failures are ENVIRONMENTAL: concurrent verilator C++ builds + yosys/OpenROAD exhaust CPU/memory and spuriously fail. **Implications:** (1) final QD-vs-classic gates MUST use reliable eval — cap worker counts and/or isolated re-verification of best candidates; never trust raw parallel-run valid counts. (2) Prior parallel runs (F1/F2/F15 core comparisons) may carry similar noise — load-dependent. **SCOPE NOW VERIFIED (2026-06-14 11:00): M12 is CONFINED to heavy-load runs; the core is reliable.** Isolated re-eval of the core ablation matrix's highest-asymmetry cases EXACTLY matches the run: qd_target Prob116 9=9, Prob153 2=2 (VerilogEval). The RTLLM Prob045 "discrepancy" (run 21 vs isolated 0) is a re-eval-tool artifact (testbench `$readmemh` of a `.dat` file absent in my tempdir) and is reverse-direction (not M12). So the core small-problem results (12-way, light iverilog jobs) were NOT corrupted; only the 14-way HEAVY e203 synth run (capability_remap) was. The finals should still use reliable eval as a precaution (cap workers / isolated re-verify best candidates), and any isolated re-verify tool must co-locate benchmark data files. Caught by M6 ground-truthing of an F20 contradiction. | `MEASURED` [H: 2026-06-14 10:35, 11:00] |
| M13 | **`validate_journal_revamp_run.py` mechanically CONFIRMS structural descriptor degeneracy on QD finals (5-seed).** classic seed_1001 PASSES (coverage 13/13, config+seed snapshot, telemetry occ 0.39); **ALL 5 qd_target seeds FAIL (exit 1)** on fatal descriptor collapse. **Cross-seed pattern: circuit7 collapses in 5/5 seeds and fsmonehot in 4/5** (structural collapsers — FSM/one-hot designs where logic_depth/ff_depth/comb_width barely vary, occupied_cells=1, all 3 axes collapsed); adder_8bit / gshare / m2014_q3 collapse sporadically (1/5 each, zero-occupancy or all-axes). So ~2/13 problems structurally collapse the frozen trio across seeds — the SAME degeneracy the root-cause dossier + F12 characterize, now mechanically + reproducibly confirmed. **Consequence:** the verification-surface "validate exit 0 per run root" is met for classic but NOT for QD — disclosed as the characterized phenomenon (the collapse IS the finding), not a hidden gate failure. Artifacts: `exp/ablation_matrix/stats/validate_{classic,qd_target}_{1001..1005}`. | `CONFIRMED` (5-seed) [H: 2026-06-16] |
| M14 | **In-run CVDP functional eval UNDER-REPORTS (grade by isolated re-eval).** The fixed binary_to_gray run reported functionality=0.0, yet the run's own correct candidate PASSES the cocotb harness in isolated re-eval (rc=0). The in-run CVDP functional path under-counts passes (M12-class); the feedback-LLM "provided testbench is missing" is the M6 hallucination (the harness is present + sound, F26). **Implication:** CVDP classic-vs-QD comparisons must be graded by ISOLATED re-eval (materialize harness + pytest per candidate), NOT the run's reported counts — the discipline F20 used for RealBench. | `MEASURED` [H: 2026-06-16] |
| M15 | **RealBench reference PPA GENERATED — closes the PPA gap M8/M10/M11 proved feasible but left un-run.** Reference PPA never existed (0 `_ppa.txt` vs RTLLM's 46) → `ref_ppa_metric` empty → `quality_mode=functional_only`, so PPA-improvement was uncomputable; the golden synthesizes cleanly (proven), so this was an un-run generation step, not a limitation. `scripts/generate_realbench_reference_ppa.py` synthesizes each golden via the candidate Yosys+OpenROAD flow → **34/34 synth-capable e203 modules** get valid power+area (area 5–26,433 µm², power 1.6e-6–1.3 W; files are local — the RealBench tree is git-ignored/regenerated). **Two harness bugs surfaced that still block full PPA *scoring*:** (a) the post-synth functional gate errors on `TIMESCALEMOD`/`WIDTHTRUNC` for a subset of modules (blocks candidate PPA; biu/clk_ctrl/clkgate fail, alu_csrctrl/decode pass), (b) STA timing degenerate (`tns/wns=0`, clock unconstrained) so improvement is power+area-only. Manifest `ppa_path` wiring + subset re-lock deferred (locked-artifact version bump). **UPDATE (2026-06-18) — the two harness bugs are FIXED:** (a) verilator `--timescale-override` kills TIMESCALEMOD; (b) `_create_sdc_file` rewritten (it discarded the clock whenever a license-header `;` preceded the module → STA unconstrained), so regenerating all 34 references **23/34 now carry real timing** (biu eff_clk 0.6 ns, ifu 2.56 ns). A third bug also fixed: the post-synth func check now compiles the `sirv_gnrl_*` aux deps. **Bug 4 (gate-level sim of sequential modules mismatches, biu 50/222) RESOLVED via an explicit acceptance policy:** `--x-initial`/`--x-assign` were tried and all give the identical mismatch (not X-init), so rather than per-module gate debugging, RealBench now accepts candidate PPA on the **pre-synth RTL functional gate + synthesis + a non-degeneracy sanity check** (rejects yosys stub-outs: non-zero power/area, non-empty netlist, area ≥ 5% of reference) instead of the gate-level re-sim. New per-benchmark flag `gate_level_functional_recheck` (False for realbench). **Candidate PPA scoring now works for ALL synthesizable e203 modules** (biu reaches status=success end-to-end). Tests: `test_synthesis_sdc_clock`, `test_candidate_evaluator::test_passes_synthesis_sanity_rejects_stubs`, `test_benchmark_capabilities`; all existing eval/verilator/capability tests pass. Policy documented prominently in [`realbench_reference_ppa.md`](realbench_reference_ppa.md) §0. | `MEASURED` [H: 2026-06-18] |
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
- MDE ratchet: **RESOLVED 2026-06-14 → keep 13×5; DROP the +0.03 best-quality WIN gate as moot.** The under-power (MDE 0.12) only bites a small POSITIVE-win claim, which we are NOT making (QD loses, F1). For the actual claims the design is adequately powered: F1 deficit is reported descriptively with cluster-bootstrap CIs; F2 within-QD parity uses the one-sided bound (CI low > −0.03) and the 3-seed pooled already passed tight (CI [−0.006,+0.030]), so 5 seeds only tightens it. No count ratchet (saves budget); the +0.03 win-gate is removed from the decision criteria — effects + CIs are reported descriptively. `exp/fast_iter/mde_hard_subset`
- Budget-matching rule (M2): **RESOLVED → disclose asymmetry; no token-matched re-runs.** F1 (QD loses) holds DESPITE QD's +12–38% token advantage → conservative, disclosure suffices (and sharpens the deficit). F2 is within-QD (unified vs six operators); verify the two arms' token comparability and disclose. No token-equalized stopping needed for a non-positive result.
- Profile freeze: **RESOLVED 2026-06-14 → `journal_logic_ff_width_3d` (the fallback trio) is FROZEN.** Applied the predeclared rule (narrative §"Why the descriptor axes mean something") to the bake-off (F12/descriptor_bakeoff.json): rank by best-quality delta, winner must also pass occupancy≥0.25 + collapse gates + per-axis design meaning, ELSE the trio stays. Outcome: **activity** ranks 1st on quality (−0.103) but its axes collapse on 3–5/6 problems (fails collapse gate) and need dynamic icarus_vcd metrics (verilator-incompatible, see VerilatorEvaluator assert); **simple_2d** (−0.131, collapse-healthy) carries only code-size proxies (wire/assign counts), not the architectural BD thesis; **graph_testability** is worst on quality. No candidate wins → the trio stays, as the rule prescribes. **Disclosures for the manuscript:** (a) `comb_width_log` = log(1+comb cell count) correlates with the area objective by construction → name it a size proxy and DROP its diversity claim (keep logic_depth + ff_depth as the diversity axes); (b) honestly report that the chosen thesis profile is NOT the most collapse-resistant (simple_2d collapses least, F12) — sophistication did not buy diversity health, which is itself a characterization finding.
- Equivalence spot-check scope (M7): **RESOLVED → restrict to fully-specified problems.** Bare NOT_PROVEN on don't-care problems is not a defect (the flow over-rejects on don't-cares); the spot-check runs only where NOT_PROVEN is meaningful, and don't-care problems are noted as a method limitation rather than a false defect.

**Remaining execution:** CVDP/RealBench debug pairs · seed-42 debug gate · 5-seed finals (1001-1005) · manuscript.

---

## 7. Navigation map (where everything lives)

| Want… | Go to |
| --- | --- |
| **This** — current findings, organized by topic | doc 13 (here) |
| **Strategic posture** — contribution vs reviewer muster, the reframe | doc 14 |
| **Why classic wins + fix plan** — mechanism, ranked fixes | doc 15 |
| **Smooth QD integration track** — design/specs, NSGA-II selection, variant ladder | doc 16 |
| **Manuscript draft spine** — abstract/contributions/results synthesis for Overleaf | doc 17 |
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
