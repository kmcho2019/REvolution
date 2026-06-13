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
| P1 | QD repair | **CLOSED → Branch C** (narrowed claims). Screens all DEMOTED; ablation matrix running for component attribution. |
| P2 | BD / descriptor thesis | **In progress.** 4 profiles pre-registered (doc 11); bake-off queued behind matrix; mechanical verdict table ready. |
| P3 | Benchmark vetting | **Mostly done.** RealBench verilator-only (55/60). **RealBench QD-vs-classic is the STORYLINE-DECIDER (doc 14): the one experiment that could convert Branch C→A/B — QD diversity may only pay off on larger designs.** Debug pairs pending next OpenRouter slot. |
| P4 | Gates / freeze | **Tooling complete.** All slices locked. Open: MDE ratchet + budget-rule *decisions*, seed-42 debug gate, 5-seed finals. |
| P5 | Manuscript | **Kicked off.** Evidence map (doc 12) binds elements to artifacts; prose pending finals. |

**Running now:** 5-arm ablation matrix seed 1003 (`classic` arm; seeds
1001-1002 complete); bake-off chain queued behind it. **No engineering
blockers on any track.**

---

## 2. Headline findings

### F1 — QD does not beat classic on best-quality at this budget `CONFIRMED`
Every QD/unified arm loses to classic across both seeds (see §3.2).
Decision: predeclared **Branch C** (narrowed claims + content floor).
The deficit is *pure PPA quality* — functionality tied 9/9 on the
genuine-hard intersection. [H: 2026-06-12 21:45]

### F2 — Operator unification is LICENSED within QD `REPLICATED` (2 seeds; 1003 pending)
Within-QD pairing (`qd_target` vs `qd_six_operators`, both on the QD
substrate — the narrative's actual operator contrast). **Pooled 2-seed
(the formal rule): +0.024, CI [+0.0035, +0.0465] entirely above 0 →
"better".** Per-seed: 1001 +0.040 (CI>0, better), 1002 +0.006 (CI
[−0.030,+0.043], parity — `gshare` excluded as missing_baseline, which
conservatively understates the unified arm). Direction positive both
seeds, no reversal. Seed 1003 → formal 3-seed pool.
`exp/ablation_matrix/stats/licensing_{pooled,sixop_vs_target_seed*}`
[H: 2026-06-13 11:15]

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

### F5 — Pareto vs scalar cells: SEED-DEPENDENT, not robust `INCONCLUSIVE`
Seed 1001 favored Pareto cells (`qd_target` −0.078 vs `qd_scalar_elites`
−0.128, +0.05) but seed 1002 INVERTS it (target −0.100 vs scalar
−0.075, −0.025). The cell-mode contribution is within seed noise at
this budget — no robust positive attribution. Honest downgrade from the
earlier seed-1001 reading; seed 1003 may break the tie but the effect
is small either way. [H: 2026-06-13 08:00, 11:15]

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
| classic_unified | unification on classic (Branch C floor) | −0.090 (1/9/3) | −0.102 (1/10/2) | running |
| qd_six_operators | six ops within QD | −0.118 (2/10/1) | −0.130 (1/11/1) | running |
| qd_scalar_elites | scalar vs pareto cells | −0.128 (1/10/2) | −0.075 (1/10/2) | running |
| qd_target | the full package | −0.078 (3/8/2) | −0.100 (1/10/2) | running |

CIs (seed 1001): classic_unified [−0.156,−0.028], six_op [−0.179,−0.059],
scalar [−0.183,−0.075], target [−0.158,+0.008]. All exclude 0 except
qd_target (touches it) → every arm loses to classic, target least so.

### 3.3 Within-QD licensing (the operator headline contrast)

| Pairing | seed 1001 | seeds 1002-3 |
| --- | --- | --- |
| qd_target − qd_six_operators (both QD) | **+0.040 (5/3/5), CI [+0.001,+0.090]** | 1002 +0.006 (4/4/4); **pooled +0.024, CI [+0.004,+0.047]** |

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
| M7 | Equivalence spot-check, COMPLETE picture: SOUND on fully-specified problems (adder_8bit candidate formally PROVEN vs ref — QD's solution genuinely correct, not testbench-lucky) but over-rejects on don't-care/unreachable inputs (q6b FSM testbench-pass yet NOT_PROVEN). Tool hardened on real data: separate gold/gate top names + submodule flatten. P4 spot-check scope = fully-specified problems, or care-set constraints. | `MEASURED` (2 real candidates) [H: 2026-06-13 11:55, 12:15] |

---

## 6. Open decisions & pending verdicts

**Pending verdicts (self-driving):**
- Ablation seeds 1002-1003 + qd_target/scalar 1002-3 → pooled operator decision (F2/F3)
- Bake-off triple → mechanical profile freeze (report_descriptor_bakeoff.py)

> **Operational reminder (run each wake):** `bash exp/run_licensing_pairings.sh`
> — idempotent; emits the within-QD `qd_six_operators` vs `qd_target`
> licensing pairing (the F2/F3 input) for every seed whose both roots
> exist. The matrix launcher does NOT emit this; it must be run separately.
> Then re-pull §3.3 from `exp/ablation_matrix/stats/licensing_*`.

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
