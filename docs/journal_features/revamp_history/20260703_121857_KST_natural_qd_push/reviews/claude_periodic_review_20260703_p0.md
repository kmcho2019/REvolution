The write to the review file wasn't permitted, so here is the full review inline — it can be dropped verbatim into `reviews/claude_periodic_review_20260703_p0.md`.

# Periodic Adversarial Review — natural_qd_push, P0 + early P1

**Scope:** commits `6ccf0376ba..d67bd320b9` (12 commits) on `feat/journal-qd-bd-exp-20260703` plus the push docs. **Method note:** pytest/ruff/pyright execution was not permitted in this session; code findings are from reading sources and tests, numeric findings from independent recomputation of the packaged CSVs. The history's recorded green test/lint results were not re-run.

## What was verified (evidence, not implementer summary)

- **The headline numbers reproduce.** I recomputed all six per-seed means in `p0_v2_anchor/tables/three_seed_summary.csv` by hand from the tracked per-seed `hv_auc.csv` tables: classic 0.14064478/0.15936940/0.13253101 and V2 0.17376375/0.17179976/0.14294259 all match exactly, and the classic recomputes equal the pinned `tables/classic_baselines.csv` values digit-for-digit. The hand-typing near-miss the history admits was genuinely fixed.
- **Operator contract green as claimed.** All three seeds: `single_thought_count=0` both arms, zero M-T (`other_strategy_count=0`), `run_validation.json` pass, manifests 8/8.
- **Registration-before-results holds.** Pins (ded7363e38) precede the anchor; the packaging chain (70abe23478) was registered with an "expected within ±5%" read that the actual +23.5% then contradicted — the honest direction of surprise; N01/N03/N05 cards (3035b09c2e) and command cards (8d8f8995) precede the P1 launches; the promotion-arm rule sits in `results_report.md` before any P1 read.
- **Quarantine discipline is real.** `exp/natural_qd_push/p0_v2_anchor_20260703_041010_UTC_INTERRUPTED_UNFAITHFUL/` exists as documented, and ae24e98ec7 names the three infidelities (16/8/5 vs 64/20/1) instead of burying them.
- **Engine-untouched rule holds.** The range diffstat shows no change to `src/revolution/qd/engine.py` or `algorithm.py`. New code — `qd_natural/` (118 lines), two `pareto_analysis.py` primitives, small backend/CLI wiring — is assert-based, typed, skimmable, no defensive fallbacks. `curiosity_pool` mirrors `QDEngine._nsga2_global_pool` ordering line-for-line (engine.py:2231–2256, 2300–2338); the only behavioral delta is the weighted draw, and the `super()` delegation on an empty archive reproduces V2 cold-start rather than masking errors. The `report_hv_auc.py` regression test asserts 138 rows against the stored 20260630 tables at 1e-9.
- **No contaminated June-22 number is cited as mechanism evidence** — every appearance (plan, cards, registry) cites them only as contamination evidence and marks them "not citable"; T54/T75/T79 negatives are explicitly disqualified in the N03 card.
- **The 3-seed statement is properly scoped** (screening-scale, P3 gates enumerated, fsm-jackpot caveat kept). Bonus not yet exploited in the docs: at seed 1003 V2 **loses fsm** (0.1459 vs 0.2652) and still wins overall — the strongest available rebuttal to single-problem dependence.
- **Runtime evidence exists:** per-seed preflight captures and launch logs under `p0_v2_anchor_20260703_041511_UTC/` (seed-1001 log shows the preflight banner and the recorded 1450 s); the N02 smoke uses debug seed 42 and is labeled never-evidence.

## Findings

**F-1 (medium) — Plan/pin conflict on the evaluation surface, plan never amended.** `natural_qd_push_plan.md` (Evaluation Surface, ~line 167) mandates `search_accelerated` "as in the June-22 screens", but `tables/v2_platform_config.md:36-40` correctly rules that the June-25 screen comparator ran `strict_ablation` and all screen runs use that. The ruling is right and was recorded before relaunch, but the plan is the contract and now carries a factually wrong sentence a later reader could "enforce". Amend with a dated correction note, not a silent edit.

**F-2 (medium) — The run validator implements less than the plan registered.** The plan's Code Organization section specifies `validate_natural_qd_run.py` check "operator contract, token budgets, seed, descriptor profile, archive config vs registration". The shipped validator checks manifest agreement, strategy counts, and QD-artifact presence only. The missing archive-config-vs-registration check is exactly the error class that produced the unfaithful first anchor — which was caught by human re-derivation, not tooling.

**F-3 (medium) — The headline 3-seed table has no tracked generator.** The history calls `three_seed_summary.csv` "scripted", but no generator exists in `scripts/` or the push tree (grep finds only prose mentions). The numbers verify — I recomputed them — but "no hand-copied numbers" deserves a reproducible path: track the summarizer or record its exact command in `p0_v2_anchor/commands.md`.

**F-4 (low) — N03 card internally inconsistent after its amendment.** `lanes/N03_archive_parent_lane/methodology.md` lines 14–20 correctly rebase N03 on N01a, but line 26 still claims "Single factor vs V2" and line 46 still says "The N03x-vs-V2 delta attributes the lane effect". Also, the frozen criterion binds "exactly one mechanism changed vs the pinned V2 platform" — N03-on-N01a differs from V2 by two; the sensible sequencing rule needs a versioned criterion note, not an implicit deviation.

**F-5 (low) — Stale TODO lane descriptions.** `natural_qd_push_implementation_todo.md:47` ("slot count 1; then 2") and `:55` ("fixed g0") describe the pre-correction N01/N05 definitions, contradicting the registered cards; line 21's "recompute verification still pending" is stale for the three screen rows (only the 6x7 row remains).

**F-6 (low) — "Directly confirms the operator-contamination thesis" over-attributes.** History 15:10 and commit d67bd320b9 compare against F1 (-0.093), but two other factors changed vs F1: representation (code_individual vs thought_only) and surface/evaluation mode. The clean operator-isolation evidence remains the 20260630 same-seed reruns; the V2 win is *consistent with* the thesis. Soften in narrative-facing text via a follow-up note.

**F-7 (low) — Initial-phase budget parity asserted, not evidenced.** `operator_contract.csv` shows per-arm `initial_count` diverging (V2 30 vs classic 20 at seed 1001; 22/22 at 1002; 25/22 at 1003). The direction flips across seeds, so this reads as retry/yield variance rather than systematic extra budget — but no package artifact proves LLM-call parity. Add per-arm total LLM-call counts (in the scheduler telemetry) to the standard package; this also partially discharges F-2.

**F-8 (info) — Commit hygiene nits.** Five subjects exceed the rubric's own ≤50-char line (ded7363e38 51, ffe818814c 54, ae24e98ec7 53, 3182602524 52, 8d8f8995 54); two subjects join two actions ("…; sequence N03 on N01a", "…packaging and N02 status"). Bodies, wrapping, and single sign-offs are otherwise exemplary. N02's pre-registration card landed in the same commit as its implementation (3182602524) — registration-before-*results* holds since no run existed, but committing cards ahead of code (as done for N01/N03/N05) gives git-history proof; keep that ordering.

**F-9 (info) — Code polish.** `test_qd_natural_engine.py:107-108` calls `random.choices(k=4000)` 4000 times and indexes — statistically valid but ~16M draws; one call suffices. `revolution_backend.py:101` gives `qd_curiosity_gamma` a default (1.0), so a forgotten flag silently runs N02a instead of failing loudly (Simplicity Rules 6/11). The figure title/legend collision fix is promised in `results_report.md` but tracked nowhere actionable.

## Verdict

**PASS_WITH_ACTIONS** — no evidence-integrity violation, no gate gaming, no contaminated-number citation, no single-seed verdict, engine.py untouched, and the flagship 3-seed claim is scoped, pre-gated, and independently reproducible from tracked artifacts. All findings are correctable contract-hygiene and tooling-completeness items.

**Actions:**
1. Amend the plan's Evaluation Surface with a dated correction note adopting the strict_ablation ruling (F-1).
2. Extend `validate_natural_qd_run.py` to check archive-config flags vs the registered card and per-arm LLM-call/token budgets, or record an explicit scope-reduction decision (F-2, F-7).
3. Track the three-seed summary generator or its exact command (F-3).
4. Fix the two stale "vs V2" lines in the N03 card and add a versioned note for the N03-on-N01a criterion deviation (F-4).
5. Sync TODO lines 21/47/55 with the corrected lane definitions and completed verifications (F-5).
6. Add a history note softening "directly confirms" to "consistent with" for the contamination-thesis interpretation (F-6).
7. Commit future lane cards before their implementation commits; keep subjects ≤50 chars (F-8).
8. Optional: single-call draw test, required `--qd_curiosity_gamma` under `revolution_qd_natural`, TODO line for the figure legend fix (F-9).
