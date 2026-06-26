I have enough to write the review. All evidence is gathered and cross-checked. Here is my read-only adversarial review.

```text
## Verdict
PASS_WITH_ACTIONS
```

The T83/T84/T85 work itself is honest: all three are correctly tiered negative, nothing below classic is promoted, pretrained-model claims hold up, and the anti-gaming rules (no PPA/HV in-loop, reference-complete paired subsets, validity disclosure) are respected. The problems are **documentation currency, package completeness, and one over-precise win claim** — not false science. Nothing here authorizes an expensive run on bad evidence, so this is not a FAIL; but several tracking artifacts now misrepresent state to a colleague and should be fixed before the next live spend.

Direct answers to the framing questions: **Q1 — honest, not prematurely narrowed** (category representatives + top-10 are maintained; encoder lanes kept alive as placeholders; T85 deliberately broke out of the MasterRTL-archive family). **Q3 — yes, with one nuance** (below). **Q6 — pretrained claims are accurate** (MasterRTL RF, Qwen3, DeepGate all verified real, all explicitly not promoted).

```text
## Critical Findings
```

- **P1 — Registry row for T85 is stale and contradicts the completed negative smoke.** `techniques/technique_registry.csv:86` still reads `...,archive_coupling_search_policy,implemented_preregistered_pending_smoke,pending_live_result`. But `current_selection_status.md:111-138` and the history record **two** completed smokes with a negative warmup-4 result (classic mean HV `0.1903` vs T85 `0.1375`). The ledger calls the registry the source of truth, so a colleague reading only the CSV would think T85 is unrun. Should read e.g. `T0_smoke_negative_not_promoted`. (T83/T84 rows at csv:84-85 are correctly tiered `T0_..._not_promoted`.)

- **P1 — No open TODO names the next materially-different lane; the strategy doc and lineage ledger lag ~T82–T84.** The fixed-MasterRTL-auxiliary-archive and RF-leaf-ID families are now exhausted (status.md:106-109 "next candidate should be materially different"), yet `useful_bd_push_implementation_todo.md` has every "next lane" item checked off and no live forward pointer past the T85 decision. `research_strategy_recommendations.md` (lines ~188-247) does not mention T81–T85 at all; `technique_lineage_ledger.md` shows T84 as `pre_registered_not_run` and has **no T85 node**. This is a process gap immediately before an expensive run.

- **P2 — "Classic wins all three HV comparisons" overstates by one; Prob015 is a 0.0/0.0 HV tie.** `backend_problem_metrics.csv` shows classic HV `0.0` and FG-QDM HV `0.0` on `Prob015_multi_pipe_8bit`; the win is real only on Prob041/Prob045. Both `current_selection_status.md:131` and `T85/README.md:18` say "wins all three." The negative decision is unaffected (mean HV gap is driven by the other two designs, and FG-QDM also has fewer Pareto points on Prob015: 1 vs 5), but the phrasing should be "wins 2/3, ties 1/3 (both HV 0.0)."

- **P2 — Stale, untracked 20260625 review bundle sits in the tree and predates T83–T85.** `reviews/20260625_review_bundle/` (400 files) plus `20260625_review_bundle.zip` and `.zip.sha256` are all untracked and reflect a pre-T81 picture. A colleague browsing it gets a state that is five techniques and several negatives out of date. The extracted directory is also redundant with the zip.

- **P3 — Pretrained-claim minor blemishes (substance is honest).** MasterRTL RF is a genuinely loaded upstream `rfr_model.pkl` (RandomForestRegressor, real nonconstant leaf IDs, collapsed `path_count` honestly disclosed as the reason T83 exists), but it is provenance-pinned by git commit only, not a `.pkl` sha256, while docs repeatedly say "verified pretrained." Also `T83/tables/preflight_models_20260626_rf_leafid.txt` is mislabeled — it is a vLLM `/v1/models` LLM listing, not RF-load evidence. Qwen3 (`Qwen/Qwen3-Embedding-0.6B`, byte-verified nonconstant) and DeepGate2 (sha256-pinned v2.0.1 weights, real Yosys AIGs, honest 2/8 & 5/8 coverage) are clean and correctly "not spend-ready."

- **P3 — Empty review placeholder.** `reviews/claude_periodic_review_20260626_t85.md` is 0 bytes (its `_prompt.md` exists). The T85 periodic review was started but never produced.

```text
## Next Technique Recommendation
```

The fixed-MasterRTL archive-pressure family (high-exploit, front-breadth, depth, adaptive-sparse-front, delayed-activation, stagnation) and the RF-leaf-ID family (T82/T83/T84) are exhausted. T85 broke to a genuinely new *mechanism* (passive memory, not optimizer — the architecture the goal_template explicitly endorses) but paired it with the **collapse-prone SR PCA-3D descriptor**, and its own methodology says "a future T85 continuation must change the mechanism or descriptor materially."

- **Primary — FG-QDM continuation that (a) runs the random-memory control its own acceptance gate already requires, and (b) swaps SR-PCA for a verified discriminative descriptor.** `T85/methodology.md:54-59` lists "the SR memory variant beats a random-memory control in the same scheduler" as an acceptance signal that was never run. Running random-descriptor FG-QDM is cheap and decisive: if SR memory ≈ random memory, that *hardens the negative map* into a publishable "descriptor identity does not matter for QD-as-memory" result; if it beats random, pair the memory mechanism with the one verified, cross-problem-discriminative descriptor available (DeepGate transition-AIG or the nonconstant RF leaf-ID axes). Mechanism and verified descriptor have each been validated separately and never combined.
- **Alternative 1 — Budget-shape / regime ablation (`4x11`, `16x2`).** Registered under T79 but never run at these shapes (strategy doc notes this). Classic is described as a "strong *small-budget* hill climber"; QD memory may only pay off at larger evaluation budgets where classic plateaus. This is orthogonal to the descriptor axis entirely and directly answers "when does diversity matter."
- **Alternative 2 — DeepGate cone-extraction coverage fix, then screen.** DeepGate is the only verified pretrained encoder structurally different from MasterRTL counts, but transition-AIG covers just 5/8 designs. Cone extraction / caching (already named as the next escalation in status.md:84) unlocks the largest designs and converts an exploratory bridge into a screenable arm.

```text
## Coding / Maintainability Review
```

- **`src/revolution/qd/engine.py` — FG-QDM is functional and well-gated, but carries a lot of un-tuned heuristic state for a first negative smoke (GUIDELINES rules 2, 5, 7, 8).** Structurally it does follow the rules: `QDSchedulerMode`/`QDParentSelection` are discriminated `Literal`s, `__init__` is opinionated and asserts hard (lines 399-441 raise on every invalid combination), no broad try/except. But two parallel credit ladders — `_update_qd_memory_insert_stats` (engine.py:1288-1319) and `_update_qd_memory_parent_credit` (1321-1359) — each hard-code ~5 magic credit constants (1.0/0.75/0.60/0.45/0.20 and 1.0/0.70/0.55/0.25/0.10/0.0), and `_memory_cell_weight` (2234-2250) stacks four bonus terms with six more magic constants (`+0.75`, `+0.35`, `0.05*…` capped `0.30`, `0.25*…`, `(0.05+credit)**2`). None of this tuning is justified by evidence and it all shipped for an arm that lost. For a *negative* result this is premature complexity; before any T85 continuation it should be simplified to one credit rule or the constants justified.
- **Defensive access against rule 5.** `_attach_front_guarded_metadata` (4069-4075) always sets `cand.qd_memory_lane` and the parent fields, yet `_front_guarded_lane_counts` (4084) reads `getattr(cand, "qd_memory_lane", "classic")` and the insert/credit paths use `getattr(..., False/None)` throughout. The types are guaranteed by the attach step — these defaults hide bugs rather than prevent them; prefer direct attribute access (the code already `assert lane in lanes` one line later).
- **Tests are adequate for Stage 0 but shallow on the new logic.** `tests/revolution/test_qd_engine.py` adds four FG-QDM tests (`requires_matching_parent_selection`, `preserves_primary_pool`, `updates_parent_cell_credit`, `writes_summary_fields`) plus CLI parser coverage in `test_run_backend.py`. They cover wiring and validation but not the cooldown trigger (engine.py:1352-1358), the lane-fallback-to-classic path (4038-4049), or `front_rescue` slot selection. Acceptable for a smoke; add cooldown/fallback coverage if T85 continues.

```text
## Reporting / Visualization Review
```

- **The probe package is sufficient to support the negative decision; the technique package is not.** `preliminary_planning/20260626_front_guarded_qd_memory_probe/analysis/` has a real Pareto report, per-problem pairwise/3D fronts, a PPA-distribution figure tree, and honest visual-inspection notes (`warmup4_visual_inspection_notes.md` even flags the over-long auto-generated titles and recommends a short `FG-QDM` slide label). That is enough evidence for "do not promote."
- **`techniques/T85_front_guarded_qd_memory/` is under-packaged vs. T83/T84.** It has README, methodology, commands, artifacts_manifest, but **no `results_report.md` and empty `tables/` (no `figures/` at all)** — T83 and T84 both ship a results_report; the goal_template requires every numbered package to carry "report... figures... tier." The README "Evidence Package" list omits a results report. The evidence exists in the probe dir; it just needs to be packaged/linked at the technique level.
- **Minor currency note:** the `goal_template.md` "Current priority" paragraph (lines 28-35) still names T75–T79 as the frontier — stale, like the strategy doc and ledger.

```text
## Action Items
```

1. Fix `technique_registry.csv:86` — change T85 to a completed-negative tier (e.g. `T0_smoke_negative_not_promoted` / `classic_wins_three_problem_mean_hv`).
2. Correct the "wins all three HV comparisons" claim in `current_selection_status.md:131` and `T85/README.md:18` to "wins 2/3, ties 1/3 (Prob015 HV 0.0 both)."
3. Package the T85 technique result: add `techniques/T85_front_guarded_qd_memory/results_report.md` + `figures/` (or explicit links to the probe analysis) and a tier line.
4. Add an open TODO item naming the next materially-different lane (random-memory FG-QDM control + verified-descriptor swap is the recommended first run), and close/demote the exhausted MasterRTL-archive and RF-leaf-ID subtree items.
5. Refresh `research_strategy_recommendations.md` and `technique_lineage_ledger.md` to fold in T81–T85 (ledger has no T85 node and shows T84 as not-run); update `goal_template.md` "Current priority."
6. Remove or regenerate the untracked `reviews/20260625_review_bundle/` (+ zip + sha256); it predates T83–T85 and the extracted tree duplicates the zip. Either bump it to a 20260626 bundle or delete the working-tree copy.
7. Produce the started-but-empty `reviews/claude_periodic_review_20260626_t85.md` (this review can seed it) so the periodic-review trail is complete.
8. Before any T85 continuation, simplify the FG-QDM credit logic in `engine.py` (collapse the two magic-number ladders; drop the defensive `getattr` defaults), and relabel `T83/tables/preflight_models_20260626_rf_leafid.txt`, which is a vLLM model listing, not RF-load proof.
9. Lower priority: add a `.pkl` sha256 pin (not just the git-commit pin) for the MasterRTL `rfr_model.pkl` so "verified pretrained" is literally true.

A note on scope: I did not run `pytest`/`ruff`/`pyright` (this is a read-only review and the working tree is clean — T85 is fully committed, only the untracked review artifacts above remain). If you want, I can re-run the suite or draft the specific doc/registry edits for items 1–7.
