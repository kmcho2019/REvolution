# Journal Revamp — Consolidated Record

**What this is.** A single, detailed, evidence-sourced record of the whole
REvolution TCAD journal-revamp effort: the final architecture that was
built, every notable experiment and the paths explored, the major
decisions, and the organized experimental results — each linked to the
precise run directory so any number can be re-found and re-checked.

**How to read it.** §1 is the one-screen summary. §2 is what was built
(architecture). §3 is the experimental program organized by research
question, with precise paths. §4 is the decision log. §5 is the dead-ends
(closed paths). §6 is methodology/caveats. §7 is the master evidence index
(claim → path). §8 is the reproduction guide.

**Relationship to the other docs.** This is the consolidated complement to:
the topic-indexed findings dashboard (`docs/journal_features/13_findings_dashboard.md`,
findings F1–F24 / M1–M12), the chronological audit log
(`journal_revamp_implementation_history.md`, 65+ dated entries), the
manuscript spine (`docs/journal_features/17_manuscript_draft_spine.md`),
and the frozen claims contract (`docs/journal_features/journal_narrative.md`,
which wins on any conflict). Where a number here cites `exp/...`, that is
the raw artifact directory.

**Status as of 2026-06-16:** the ablations, characterization, and smooth-QD
contribution are complete and 5-seed-locked **on the tuning hard subset**.
The frozen narrative's QD-vs-classic FINAL gate on the 20-problem held-out
reference set was, by decision (2026-06-16), **NOT run** (the Branch-C-
confirmed outcome is a confirmatory negative; held-out is disclosed as a
stated limitation / future work — see §6 and F25). All QD-vs-classic and
smooth-QD numbers are therefore **tuning-set-scoped**. Remaining work: the
manuscript write-up into the Overleaf `journal_draft` (user-authored).

---

## 1. Executive summary

The conference REvolution drew five criticisms. The journal revamp answers
all five — as a rigorous **characterization** of *when* quality-diversity
(QD) / thought-level structure helps LLM-driven RTL search, plus **one
positive contribution** (a smooth QD integration at no significant quality
cost). The original aspiration — make the fancy QD build *beat* classic —
is **not** achieved and the evidence says it will not be; the honest,
defensible story is the characterization + the smooth-QD result.

| # | Conference criticism | Journal answer | Verdict (5-seed, sourced in §3/§7) |
|---|---|---|---|
| 1 | Weighted-sum PPA biases search | Pareto-front cells + NSGA-II selection (no scalar weight) | Answered as **no-significant-cost** (F23) |
| 2 | EoH operators arbitrary | One unified thought-operator | **Parity within QD** (F2) |
| 3 | Bandit claimed, never ablated | Bandit removed; operator ablated | **Ablation exists; parity** (F2) |
| 4 | Benchmarks too small | CVDP + RealBench (real e203 CPU) integrated | **Characterization**: LLM spec-comprehension is the binding limit at scale (F18–F21) |
| 5 | No diversity | QD MAP-Elites + BD trio + NSGA-II | **Diversity at no-significant-cost** (F23) |

**The four locked results (official `report_journal_statistics`, penalized
cluster-bootstrap = complete-case, 13 problems as clusters):**

- **F1 — the radical `thought_only` QD LOSES to classic.** qd_target −
  classic best-quality **−0.093**, CI **[−0.149, −0.036]**, sign-test
  p=1.3e-05. `exp/ablation_matrix/stats/final_5seed_F1_qt_vs_classic/`
- **F2 — operator unification at clean PARITY within QD.** qd_target −
  qd_six_operators **+0.001**, CI **[−0.008, +0.011]**, p=1.0, win-rate
  48.8%; robust in all 5 leave-one-seed-out folds (worst CI low −0.026 >
  −0.03). `exp/ablation_matrix/stats/final_5seed_F2_qt_vs_six/`
- **F23 — smooth QD (V2) adds diversity at no significant quality cost.**
  V2 (code_individual + NSGA-II global-rank selection) − classic
  **−0.016**, CI **[−0.045, +0.007]** (includes 0), p=0.17. NSGA-II is
  necessary: V1 (no NSGA-II) − classic −0.034, CI [−0.066, −0.009]
  (significantly worse); NSGA-II benefit V2 − V1 **+0.018**, CI [+0.005,
  +0.032] (entirely > 0).
  `exp/fast_iter/smooth_qd_{code_individual,nsga2}/stats_5seed_vs_classic/`
- **F18–F21 — at RealBench scale the limit is LLM spec-comprehension.**
  On dependency-complete e203 modules, valid candidates appear only on the
  2 smallest (<6 KB), classic ≥ QD; larger modules get 0 valid for both
  gpt-oss-120b and the stronger deepseek-v4-pro (narrows the mismatch,
  does not cross). `exp/fast_iter/capability_remap/`,
  `exp/fast_iter/deepseek_capability_probe/`

---

## 2. Final architecture (what was built)

The revamp extended the existing REvolution backend with a QD search mode
and a set of orthogonal, discriminated-union knobs. Framework code lives in
`src/revolution/`; the QD engine in `src/revolution/qd/engine.py`; the run
entry point is `scripts/run_backend.py`; statistics in
`scripts/report_journal_statistics.py` (+ `src/revolution/journal_stats.py`).

### 2.1 The search/QD knobs (each a small discriminated union)

| Flag | Choices (default first) | Meaning |
|---|---|---|
| `--search_mode` | `revolution` · `revolution_qd` | classic evolutionary search vs QD/MAP-Elites |
| `--representation_kind` | `code_individual` · `thought_only` | evolve code directly vs evolve a natural-language "thought" that is realized into code |
| `--qd_operator_kind` | `eoh_strategies` · `single_thought_operator` | the six-operator EoH suite vs one unified thought operator |
| `--qd_parent_selection` | `cell_crowded_tournament` · `nsga2_global_rank` | per-cell crowded tournament vs **global NSGA-II non-domination-rank + crowding** (added for smooth-QD V2) |
| `--qd_archive_type` | `grid` · `cvt` · `grid_quantile` | fixed grid · CVT (Voronoi) · quantile-rebinned grid |
| `--qd_cell_mode` | `scalar_elite` · `pareto_front` | one scalar elite per cell vs a bounded per-cell Pareto front (NSGA-II within the cell, ≤ `--qd_max_elites_per_cell`) |
| `--qd_rebinning_kind` | `disabled` · `ks_triggered` | static bins vs KS-test-triggered adaptive rebinning |
| `--qd_descriptor_profile` | `journal_logic_ff_width_3d` (frozen) · … | the behavioral-descriptor (BD) axes |
| `--qd_champion_lane_fraction` | float | fraction of parent draws reserved for archive champions (elitism) |
| `--qd_objectives` | e.g. `ppa` | objectives for the Pareto front / hypervolume |

Validation is opinionated (asserts in `engine.py:146–259`): unknown values
fail fast; `thought_only` requires `--code_samples_per_thought`.

### 2.2 The frozen behavioral-descriptor trio

`journal_logic_ff_width_3d` = `logic_depth`, `ff_depth`, `comb_width_log`
(`data/configs/qd_descriptor_profiles.yaml`). Frozen per the predeclared
bake-off rule (F12). Disclosure: `comb_width_log` correlates with area by
construction (a size proxy — diversity claim dropped for that axis;
logic_depth + ff_depth kept).

### 2.3 The five ablation arms (the matrix design)

Each arm changes exactly one factor from `qd_target` (the full radical
package) so the contrast is one-factor:

| Arm | search_mode / key flags | Isolates |
|---|---|---|
| `classic` | `revolution` (no QD) | the baseline |
| `classic_unified` | `revolution` + unified operator | operator unification **on the classic substrate** (Branch-C floor leg i) |
| `qd_six_operators` | `revolution_qd` + `eoh_strategies` + `thought_only` | the six-operator suite **within QD** |
| `qd_scalar_elites` | `revolution_qd` + `scalar_elite` cells | scalar cells vs Pareto cells |
| `qd_target` | `revolution_qd` + `single_thought_operator` + `thought_only` + `pareto_front` + `grid_quantile` + `journal_logic_ff_width_3d` + `ks_triggered` | the full package |

### 2.4 The smooth-QD arms (the positive contribution)

Built to salvage QD as a positive contribution by integrating it *smoothly*
into the classic baseline (design doc: `docs/journal_features/16_smooth_qd_integration_track.md`):

- **V1** — `revolution_qd` + `code_individual` (drops the harmful
  thought→code indirection) + `eoh_strategies` + `champion_lane 0.5` +
  `grid_quantile` + `pareto_front` + `journal_logic_ff_width_3d` +
  `cell_crowded_tournament`.
- **V2** — V1 + `nsga2_global_rank` (the only change: global NSGA-II
  selection). Implementation: `engine.py` `_nsga2_global_pool()` reuses
  `archive.ranked_front`; plumbed run_backend → backend → engine. Commit
  0ee4a8a983; test `tests/revolution/test_qd_archive.py::test_ranked_front_global_nsga2_ordering`.

### 2.5 RealBench (real-CPU) harness

The candidate-evaluation pipeline runs end-to-end on real e203 CPU modules:
verilator functional check → yosys + OpenROAD (Nangate45) PPA → post-synth
gate-level check → BD-trio descriptors. Four eval-wiring gaps were fixed to
get there (F16/M11): top-module resolution (emitted
`synthesis_top_module_names.json`), post-synth include/defines threading,
the e203 post-synth parser, and the verilator vcd-probe assert. Key code:
`src/revolution/runtime/candidate_evaluator.py`, `src/revolution/evaluation.py`,
`src/revolution/verilator_evaluation.py`, `scripts/build_realbench_manifest.py`.

### 2.6 Statistics & equivalence tooling

- `scripts/report_journal_statistics.py` — paired cluster-bootstrap
  (problems as clusters), penalized (gate-bearing, metric-floor imputation)
  AND complete-case mean/CI, leave-one-seed-out recomputation, sign tests.
  The default `mean_delta`/`bootstrap_ci_*` fields ARE the penalized
  statistic; `--gate-profile {reference_ppa,functional,none}` only toggles
  threshold pass/fail checks.
- `scripts/check_equivalence.py` — yosys formal equivalence spot-check
  (`equiv_make` / `equiv_simple` / `equiv_induct`; handles sequential).
- **Tool provenance (captured 2026-06-16, to ship with the config freeze):**
  Yosys 0.54+29 (git sha1 7b0c1fe49); Verilator 5.030 (2024-10-27 rev
  v5.030); Icarus Verilog 12.0 (stable, v12_0); OpenROAD v2.0-22560-gb571c4b471.
  Synthesis/PPA on Nangate45 (typical corner).

### 2.7 Locked configuration artifacts (`data/configs/`)

Revise only by version bump with recorded rationale:
`journal_seed_manifest.yaml` (debug seed 42; final seeds 1001–1005;
statistical unit = problem-seed pair), `fast_iteration_subset{,_v2,_v3}.yaml`,
`hard_iteration_subset.yaml`, `failure_regime_screen_subset.yaml`,
`qd_descriptor_profiles.yaml`, `realbench_{debug,final_26,large}_subset.yaml`,
`cvdp_{debug,final_30}_subset.yaml`.

---

## 3. The experimental program (organized by question)

Every result below is from COMPLETED runs only (a hard rule after two
partial-data misreads; see §6). Paths are precise run directories.

### 3.1 Core ablation matrix — does QD/the package beat classic? (F1, F2, F3, F9)

- **Design:** 5 arms × 5 seeds (1001–1005), 13-problem hard subset (RTLLM +
  VerilogEval-Spec-to-RTL), gpt-oss-120b via OpenRouter, pop 20 × 5 gens.
- **Runs:** `exp/ablation_matrix/{classic,classic_unified,qd_six_operators,qd_scalar_elites,qd_target}/seed_{1001..1005}/`
- **Stats:** `exp/ablation_matrix/stats/` (27 dirs), authoritative pooled:
  `final_5seed_F1_qt_vs_classic/`, `final_5seed_F2_qt_vs_six/`,
  `floorleg_classic_unified_pooled/`.

| Contrast | 5-seed pooled | CI | per-seed (1001→1005) | verdict |
|---|---|---|---|---|
| qd_target − classic (**F1**) | −0.093 | [−0.149, −0.036], p=1.3e-05 | −0.078/−0.101/−0.092/−0.097/−0.096 | QD **loses** |
| qd_target − qd_six_operators (**F2**) | +0.001 | [−0.008, +0.011], p=1.0 | +0.040/+0.006/−0.015/−0.023/−0.005 | **parity** |
| classic_unified − classic (**F3/F9**) | −0.092 | [−0.149, −0.037] | — | unified **worse on classic substrate** |

**Decisions:** (a) predeclared **Branch C** (narrowed claims + content
floor) — QD does not win, on evidence not assumption. (b) The operator
simplification is a **within-QD** parity result, NOT independent of QD
(F9 falsified the "independent simplification" hope): classic+unified loses
−0.092, so Branch-C floor leg (i) is not met. (c) F1's deficit is pure PPA
quality — functionality tied 9/9 on the genuine-hard intersection.

### 3.2 Smooth-QD — can QD be a positive contribution? (F22, F23)

- **Question:** the radical `thought_only` build loses (F1). Does a *smooth*
  integration (direct code + archive + principled selection) reach parity?
- **Runs:** `exp/fast_iter/smooth_qd_code_individual/seed_{1001..1005}/`
  (V1), `exp/fast_iter/smooth_qd_nsga2/seed_{1001..1005}/` (V2). Stats:
  `…/stats_5seed_vs_classic/` in each.

| Contrast | 5-seed pooled | CI | verdict |
|---|---|---|---|
| V1 (no NSGA-II) − classic | −0.034 | [−0.066, −0.009] | significantly worse |
| **V2 (NSGA-II) − classic** | **−0.016** | **[−0.045, +0.007]**, p=0.17 | **no significant cost** |
| NSGA-II benefit: V2 − V1 | +0.018 | [+0.005, +0.032] | NSGA-II **necessary**, demonstrated |

- **Mechanism:** removing the thought→code indirection (V1) recovers the
  bulk of the −0.10 radical-QD deficit; global NSGA-II selection (V2)
  closes most of the residual. Per-seed V2 is robust (−0.011/−0.034/−0.029/
  +0.007/−0.014, no outlier). Residual deficit localized to the
  exploitation-heavy PPA-margin problems (alu −0.153, parallel2serial
  −0.086 pooled) — a capability limit, not seed noise (so tight parity,
  CI low > −0.03, is unreachable by adding seeds).
- **Decision:** accept "QD/MAP-Elites as a no-significant-cost diversity
  augmentation (NSGA-II selection over an archive removes the weighted-sum
  bias #1 and adds behavioral diversity #5 at no significant quality cost
  vs a strong classic baseline)." This is the positive contribution. The
  3-seed → 5-seed extension was run (2026-06-16) to match the F1/F2
  evidentiary standard; it tightened the CI and made the NSGA-II benefit
  significant.

### 3.3 QD repair attempts — Fix A / Fix B / B′ (F10–F15)

Before smooth-QD, several repairs were screened on the fast subset to close
the QD-vs-classic gap directly:

| Fix | Idea | Run | Result (F#) |
|---|---|---|---|
| Fix A | champion-lane elitism alone | `exp/fast_iter/fixa_champion_lane/` | fails (F11) |
| Fix B | code-seeded archive | `exp/fast_iter/fixb_code_seeded/`, `exp/fast_iter/fixb_hard_subset/` | halves the FAST deficit, anchors on leaps (F10); does NOT transfer to hard (F15) |
| Fix B+A | combined | `exp/fast_iter/fixba_combined/` | champion lane HURTS; Fix B alone is the ceiling (F13) |
| B′ | hybrid | `exp/fast_iter/fixbprime_hybrid/` | worse than Fix B (F14) |
| k-ablation | k=2 | `exp/fast_iter/k_ablation_k2/` | (selection-pressure ablation) |

**Decision:** the direct repair path tops out below parity on the hard
subset (F15) → motivated the smooth-QD reframe (§3.2).

### 3.4 Descriptor / BD thesis — bake-off & profile freeze (F11, F12)

- **Runs:** `exp/fast_iter/bakeoff_{activity,graph_testability,simple_2d,verdict}/`,
  `exp/fast_iter/descriptor_correlation_{hard,v1}/`,
  `exp/fast_iter/warmup_patience_rc/`.
- **Result (F12):** no profile improves PPA; the cheap `simple_2d` control
  is the diversity-healthiest, and the frozen trio is NOT the most
  collapse-resistant. The trio was frozen anyway per the predeclared rule
  (no candidate qualified to displace it). Warmup-policy proof-of-firing
  (`warmup_patience_rc/`) showed quality unchanged → the BD **axes**, not
  the warmup policy, are binding.
- **Disclosure:** `comb_width_log` ~ area (size proxy); diversity claim
  dropped for that axis.

### 3.5 RealBench-scale capability — the storyline-decider (F16–F21)

- **Question (highest strategic leverage):** does QD pay off on
  large/real designs (the regime the small benchmarks were too small to
  expose)? If yes, criticisms #4 + #5 resolve together into a win.
- **Runs:** harness validation `exp/fast_iter/realbench_large_storyline/`;
  capability smokes `exp/fast_iter/{decode,midsize}_capability_smoke/`;
  the corrected storyline-decider `exp/fast_iter/capability_remap/`
  (`grade_mismatch_compare.json`); the stronger-model probe
  `exp/fast_iter/deepseek_capability_probe/`.
- **Result:** the harness runs end-to-end (F16/M11), but the LLM cannot
  produce functionally-valid candidates on the large modules. Corrected,
  isolated-re-eval decider (classic vs QD, 7 dependency-complete e203
  modules 4.7–53 KB): valid candidates only on the 2 smallest (<6 KB),
  classic 4 ≥ QD 2; larger modules (incl. decode 53 KB) 0 valid (**F20**).
  The deepseek-v4-pro probe narrows the mismatch (disp 21%→6%, branchslv
  25%→8%) but still 0 valid on the large modules → the ceiling is
  **model-general** (**F21**).
- **Decision:** the win-path is closed; fold in as a **characterization** —
  at real-CPU scale the binding limit is LLM spec-comprehension, not search
  structure (answers #4, bounds #5). The earlier parallel-run "0/7" was a
  contention artifact (M12), corrected by isolated re-eval (**F20**).

### 3.6 Root-cause diagnostics (why thought/QD underperforms)

- **Transcription poisoning (spec-exact regime):** a wrong interface index
  in the thought propagates to all realizations.
  `exp/fast_iter/hard_subset_42/qd/revolution/openai-gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob116_m2014_q3/Gen0/g000_thought_0001/`
- **Missing failure feedback:** fail-parent payload carried thought+status
  only; a propagation bug meant 0/20 prompts carried the diagnosis until
  the wrapper fix (commits ecb7615f5c, e77f9c5c8f).
- **Descriptor degeneracy:** 4/11 hard problems never exit warmup (all trio
  axes unique_count=1). `descriptor_health.json` under
  `exp/fast_iter/hard_subset_42/qd/…` and `…/fail_feedback_rb/variant/`.
- **Regime-sensitivity (F4):** thought/QD beats classic exactly where
  classic collapses (m2014_q6b 24% vs 3% pass) but loses on PPA-margin
  problems. Cross-substrate confirmation incl. `classic_unified` per-bench
  split (RTLLM −0.134 vs VerilogEval −0.038),
  `exp/ablation_matrix/stats/classic_unified_seed1001/`.
- **Deficit localization (F7):** ~3/13 problems carry 58–62% of the loss.

### 3.7 Case study + equivalence (F24)

- **Four artifacts** (sources verified extractable 2026-06-16): archive
  heatmap (Prob135_m2014_q6b grid_quantile frames/slides); thought lineage
  (`exp/fast_iter/rb_failure_regime_v2/variant/revolution/openai_gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob116_m2014_q3/`);
  scalar-vs-QD from evaluated history (classic vs qd generation_log.jsonl
  on hard_subset_42); failure panel
  (`exp/fast_iter/rb_failure_regime_v2/variant/revolution/openai_gpt-oss-120b/RTLLM/Prob045_alu/`).
- **Equivalence (F24, new):** the heatmap source Prob135 has a **don't-care
  reference** (`Y1 = 1'bx`), so its 8 cell solutions are testbench-valid but
  0/8 formally provable — out of the frozen "fully-specified problems only"
  scope. Harness validated on the fully-specified Prob150_review2015_fsmonehot
  → 1/1 PROVEN. **Decision:** split the artifact — Prob135 for the heatmap
  (disclose solutions as testbench-validated), a fully-specified problem for
  the equivalence pass-rate. Artifacts:
  `exp/fast_iter/hard_subset_42/qd/revolution/openai-gpt-oss-120b/VerilogEval-Spec-to-RTL/Prob{135_m2014_q6b,150_review2015_fsmonehot}/equivalence_spotcheck/`.

---

## 4. Major decisions log

1. **Branch C (narrowed claims + content floor)** — QD does not beat
   classic (F1, 5-seed); the paper is a characterization, not "we win."
2. **Operator simplification is within-QD only** — F2 parity holds within
   QD; F9 shows it costs −0.092 on the classic substrate, so the
   "independent simplification" floor leg is not met.
3. **Descriptor trio frozen** (`journal_logic_ff_width_3d`) per the
   predeclared bake-off rule; `comb_width_log` disclosed as a size proxy.
4. **Win-path closed** — RealBench-large does not deliver a QD win (F20);
   the model-strength probe confirms a model-general ceiling (F21).
5. **Smooth-QD accepted as the positive contribution** — V2 (NSGA-II) at no
   significant quality cost (F23); NSGA-II necessary; extended to 5 seeds.
6. **Frozen statistical rules** (from `journal_narrative.md`): parity =
   penalized cluster-bootstrap 95% CI entirely above −0.03; problems are
   clusters; the +0.03 best-quality WIN gate dropped as moot (we make no
   win claim); token-budget asymmetry disclosed, not matched.
7. **Equivalence scope = fully-specified problems only**; case-study
   equivalence artifact split (F24).
8. **Hard data-hygiene rule** — best-quality computed from COMPLETED runs
   only (after two partial-data misreads, §6).

---

## 5. Paths explored and closed (dead-ends, kept for honesty)

- **Direct QD repair (Fix A/B/B′)** — tops out below parity on hard (F15).
- **Radical `thought_only` + `single_thought_operator` (qd_target)** — the
  ambitious build; loses to classic (F1). Retained as the characterization
  anchor, not the pitch.
- **RealBench-large win-path** — closed (F20/F21); repurposed as the #4
  characterization.
- **Sophisticated descriptor profiles** — no profile beats the cheap
  control on diversity health or PPA (F12).
- **Champion-lane elitism as a standalone fix** — hurts (F11/F13).
- **"Operator simplification independent of QD"** — falsified (F9).
- **Unified-operator-as-a-win (2-seed read)** — did not replicate; settled
  at parity (F2).

---

## 6. Methodology, measurement, and caveats (M1–M12)

- **M2 — token-budget asymmetry:** QD/thought arms spend +12–38% tokens;
  disclosed (not matched). F1 is conservative because QD loses *despite*
  the extra budget. `exp/fast_iter/hard_subset_42/budget_parity/`.
- **M12 — parallel-eval contention:** heavy ~14-way runs spuriously fail
  valid candidates; CONFINED to heavy runs (core 12-way verified reliable
  by isolated re-eval: qd_target Prob116 9=9, Prob153 2=2). Finals use
  reliable eval; reported as a caveat. Caused the retracted "0/7" (F20).
- **F19 — include confound:** e203 candidates omitted `e203_defines.v` and
  died at preprocessing; fixed by force-including the entry header
  (disclosed as a benchmark-construction choice).
- **Feedback-LLM unreliability (M6):** the feedback model hallucinates
  verdicts ("testbench missing"); trust run status_counts / raw eval.
- **Two partial-data misreads (process lesson):** a mid-run −0.199 that
  recovered to 0.000 by run-end, and a "net-neutral" V2 read at 10/13 that
  reversed at 13/13. Hard rule adopted: read best-quality from COMPLETED
  runs only.
- **Power/MDE:** continuous MDE 0.12 at 13×5 (`exp/fast_iter/mde_hard_subset/`);
  the under-powered +0.03 win-gate was dropped (moot — no win claimed);
  effects reported descriptively with cluster-bootstrap CIs.
- **Contract compliance verified:** F1/F2 use the penalized (gate-bearing)
  statistic the frozen rule requires (penalized == complete-case here, no
  imputation triggered); F2 parity holds in all 5 LOSO folds.
- **Held-out final gate not run (F25) — disclosed limitation.** The
  narrative's QD-vs-classic final gate + branch decision are predeclared on
  the 20-problem held-out reference set; only the tuning hard subset was run.
  By decision (2026-06-16) the held-out gate was not executed (Branch-C-
  confirmed outcome = confirmatory negative). Consequence the manuscript
  carries: F1 (QD loses) and F23 (smooth-QD) are TUNING-SET-SCOPED, held-out
  is future work; the operator ablation F2 is unaffected (tuning-set protocol
  by design); the #1/#5 answers rest on the smooth-QD contribution (F23), not
  a held-out gate (Branch C floor leg (i) unmet, F9).

---

## 7. Master evidence index (claim → precise path)

| Claim / result | Number | Precise artifact path |
|---|---|---|
| F1 QD loses to classic | −0.093, CI [−0.149,−0.036] | `exp/ablation_matrix/stats/final_5seed_F1_qt_vs_classic/statistical_tests.json` |
| F2 operator parity within QD | +0.001, CI [−0.008,+0.011] | `exp/ablation_matrix/stats/final_5seed_F2_qt_vs_six/statistical_tests.json` |
| F3/F9 unified worse on classic | −0.092, CI [−0.149,−0.037] | `exp/ablation_matrix/stats/floorleg_classic_unified_pooled/` |
| Regime split (classic_unified per-bench) | RTLLM −0.134 / VerilogEval −0.038 | `exp/ablation_matrix/stats/classic_unified_seed1001/` |
| F23 V2 no significant cost | −0.016, CI [−0.045,+0.007] | `exp/fast_iter/smooth_qd_nsga2/stats_5seed_vs_classic/` |
| F23 V1 significantly worse | −0.034, CI [−0.066,−0.009] | `exp/fast_iter/smooth_qd_code_individual/stats_5seed_vs_classic/` |
| F18–F21 RealBench capability | classic ≥ QD; 0 valid large | `exp/fast_iter/capability_remap/grade_mismatch_compare.json` |
| F21 stronger-model probe | narrows, still 0 large | `exp/fast_iter/deepseek_capability_probe/` |
| F12 descriptor bake-off | no profile wins | `exp/fast_iter/bakeoff_verdict/`, `exp/fast_iter/descriptor_correlation_hard/` |
| F10–F15 QD repairs | Fix B halves fast, fails hard | `exp/fast_iter/fixb_hard_subset/`, `exp/fast_iter/fixbprime_hybrid/` |
| F24 equivalence (don't-care split) | Prob135 0/8, Prob150 1/1 | `…/VerilogEval-Spec-to-RTL/Prob{135_m2014_q6b,150_review2015_fsmonehot}/equivalence_spotcheck/` |
| Budget asymmetry (M2) | calls 1.125, tokens 1.253 | `exp/fast_iter/hard_subset_42/budget_parity/` |
| Raw ablation runs (all arms/seeds) | per-problem generation logs | `exp/ablation_matrix/<arm>/seed_<n>/revolution/openai_gpt-oss-120b/<suite>/<Prob>/generation_log.jsonl` |

All raw run roots: `exp/ablation_matrix/` (5 arms × 5 seeds), `exp/fast_iter/`
(~33 experiment dirs). The run ledger is `rerun_ledger.jsonl` in this folder.

---

## 8. Reproduction guide

- **Locked inputs:** seeds + subsets in `data/configs/journal_seed_manifest.yaml`,
  `…/fast_iteration_subset_v3.yaml`, `…/qd_descriptor_profiles.yaml`
  (revise only by version bump).
- **One ablation arm** (e.g. qd_target, one seed): `scripts/run_backend.py
  --backend revolution --benchmarks RTLLM VerilogEval-Spec-to-RTL
  --problems <13-subset> --model_name openai/gpt-oss-120b --api_backend
  openrouter --population_size 20 --num_generations 5 --seed <s>
  --search_mode revolution_qd --representation_kind thought_only
  --qd_operator_kind single_thought_operator --qd_cell_mode pareto_front
  --qd_archive_type grid_quantile --qd_descriptor_profile
  journal_logic_ff_width_3d --qd_rebinning_kind ks_triggered
  --save_path exp/ablation_matrix/qd_target/seed_<s>` (full flag set in the
  process args recorded in each run's `*_launch.log`).
- **Smooth-QD V1/V2:** the difference is exactly `--representation_kind
  code_individual` + `--qd_operator_kind eoh_strategies` +
  `--qd_champion_lane_fraction 0.5` and `--qd_parent_selection
  {cell_crowded_tournament|nsga2_global_rank}`. Launchers (gitignored):
  `exp/smooth_qd_*_launch.sh`.
- **Pooled stats:** `scripts/report_journal_statistics.py --pair
  "<seed>=<baseline>/revolution=<treatment>/revolution" … --output-dir
  <out> --gate-profile none` (the `mean_delta`/`bootstrap_ci_*` are the
  penalized statistic; `complete_case_*` reported alongside).
- **Equivalence:** `scripts/check_equivalence.py --gold <ref>.sv --gate
  <cand>.sv … --gold-top RefModule --gate-top TopModule --output-dir <out>`.

---

## 9. Goal-criteria scorecard (vs goal_template.md, 2026-06-16)

Honest status of each goal outcome / verification / completion criterion.
"SCOPED OUT" = a conscious documented-limitation decision, not a silent gap.

| Goal item | Status | Evidence / note |
|---|---|---|
| **(1)** QD-vs-classic on HELD-OUT statistics | **SCOPED OUT** | Ran on the tuning hard subset (F1 −0.093); the 20-problem held-out gate was not run by decision 2026-06-16 (Branch-C-confirmed = confirmatory negative). Disclosed limitation (F25, doc 17). |
| **(2)** Frozen, pre-registered BD profile + correlations + rationale | **MET** | journal_logic_ff_width_3d frozen (F12); descriptor-objective correlations measured (descriptor_correlation_hard); rationale + comb_width_log size-proxy disclosure in the narrative. |
| **(3)** CVDP + RealBench end-to-end on locked slices | **RealBench MET; CVDP infra-blocked** | RealBench MET (classic-vs-QD end-to-end on e203, F18–F21, `exp/fast_iter/capability_remap`). **CVDP: debug probe RAN (F26, 2026-06-16)** — the revolution+CVDP path works, but functional eval is 0% and **cannot be ground-truthed here** (dataset withholds the golden, the reference harness is Docker-based + Docker unavailable, per-candidate pytest.log is temp). So CVDP testing is **infra-blocked (cocotb harness validation), not compute-blocked**; #4 is carried by RealBench, CVDP stays integration-evidence-only. |
| **(4)** Manuscript per branch + 4 case-study artifacts | **PENDING** | Manuscript = the remaining deliverable (#15, user-authored). The 4 artifacts have verified source data; equivalence resolved (F24). |
| Verify: report_journal_statistics gates | **MET** | F1/F2 official + LOSO; `exp/ablation_matrix/stats/final_5seed_*`. |
| Verify: validate_journal_revamp_run.py exit 0 per root | **classic MET; QD FAIL** | classic seed_1001 PASS; qd_target seed_1001 FAIL (exit 1) on descriptor collapse — 4/13 problems (adder_8bit, circuit7, fsmonehot total-collapse; gshare zero-occupancy). This is the **characterized descriptor-degeneracy** phenomenon (M13), not a new bug — disclosed, not a clean gate pass. `exp/ablation_matrix/stats/validate_{classic,qd_target}_1001`. |
| Verify: descriptor health / correlation artifacts | **MET** | F12; descriptor_correlation_hard. |
| Verify: manifest/subset sha256 locks + ledger | **MET** | data/configs locks; rerun_ledger.jsonl. |
| Verify: four-persona v2 sign-off on full evidence+manuscript | **PENDING** | Narrative got four-persona sign-off; the full-package v2 sign-off needs the manuscript. |
| Completion: every TODO checked + spot-verified | **5 open** | 2 RentCon (deprioritized, non-gate-bearing), 2 CVDP (this row + criterion 3), 1 manuscript (#15). |

**Bottom line vs the goal:** the goal is substantially met **as a Branch-C
characterization + the smooth-QD positive contribution**, with two final-gate
items (held-out QD-vs-classic, CVDP end-to-end) consciously **scoped out as
documented limitations**, and the **manuscript (#15)** as the remaining
deliverable. The descriptor-collapse validator failure on QD is itself
evidence for the characterization (M13).

---

_Maintenance: refresh §1/§3/§7/§9 from `exp/ablation_matrix/stats/` and
`exp/fast_iter/*/stats_*` if any run is re-executed; keep finding IDs
(F#/M#) stable and aligned with doc 13._
