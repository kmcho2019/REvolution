# Final Negative-Map Validation Pass

Recording note: this read-only PASS output has been copied into the canonical
validation report and logged in `useful_bd_push_implementation_history.md`.

I now have everything needed. Let me record the verification findings before rendering the verdict.

I verified:
- **Headline numbers are reproducible** against the regenerated underlying data files (not just summaries): AURORA T99 `0.1201` vs `0.1406`, T100 `0.1566` vs `0.1903`, DeepGate T95 `0.1153`, RF/DeepGate T96 `0.1199` — all match the central report and selection-status exactly, including the literal classic-perspective win/loss/tie counts.
- **Headline artifacts physically exist** — `qd_ppa_viewer/` and `direct_ppa_pareto/` bundles are present on disk for T95/T96/T99/T100.
- **Prior PASS_WITH_ACTIONS items are genuinely closed** — README indexes T01–T100 with correct paths/tiers; T99 has local methodology/results/manifest; figure-completeness inventory exists and marks headline reps figure-backed; registry points T88–T96 at real `preliminary_planning/` packages.
- **One minor residual**: the identical `classic_revolution_8x5` seed-1001 comparator carries slightly different *secondary* metrics across packages (`mean_hv_auc` `0.123942` vs `0.126034`; `yield_warning_count` 1 vs 2), but the **headline** `mean_global_ppa_hv` (`0.14064478406`) and Pareto breadth (`3.25`) are bit-identical everywhere — and those secondary metrics are explicitly declared out of headline scope.

---

# Final Negative-Map Validation — Verdict: `PASS`

The negative-map claim is rigorous enough for the current goal (pause broad live spend on the tested families and present a rigorous negative map, without overclaiming that QD/MAP-Elites is impossible). All five PASS conditions are met, the prior `PASS_WITH_ACTIONS` action items are closed in the working tree, and the headline evidence is reproducible from the underlying data rather than from implementer summary.

## Evidence checked (not just summaries)

| Check | Result |
| --- | --- |
| Headline HV/win-loss reproducible from data | ✓ `method_seed_summary.csv` for AURORA/DeepGate/RF-DeepGate/T100 match the central report and selection status exactly |
| Headline figures/viewers exist on disk | ✓ `qd_ppa_viewer/` + `direct_ppa_pareto/` present for T95/T96/T99/T100 |
| Registry → real evidence packages | ✓ T88–T96 point to `preliminary_planning/`; T99/T100 have local entry points |
| Anti-gaming columns literal | ✓ `classic_hv_win/loss/tie` regenerated from the classic perspective |

## Why PASS

1. **Scope preserved.** Every surface (central report conclusion, stop-condition audit §Policy, completion-gap audit §Current Claim) restricts the claim to "tested descriptor/coupling families under tested budgets" and explicitly refuses the stronger "QD is impossible/useless" claim. No overextension in either direction.

2. **Core method families represented with real results.** Simple/control (T22 random descriptor); synthesis/netlist (T04/T19/T20 SR); learned/projection with real *live* matched 8×5 screens (Qwen canonical, DeepGate T94/T95, AURORA T99); archive-coupling (aux-archive 3-seed replication, FG-QDM T85–T100, T17 passive Pareto). Far more than 10 real packages (T01–T100) with methodology/results/tier decisions.

3. **No positive claim overextended.** Final RTLLM shortlist is explicitly empty; every representative is `category_representative_not_promoted` or diagnostic. Single-seed near-misses (T83, aux archive) were replicated → negative (0/3 seed wins). Smoke-only T100 is explicitly not promoted despite the highest absolute QD mean HV; the mixed-scope HV table is labeled "not a promotion ranking."

4. **Anti-gaming checks visible.** Missing-reference exclusion (post-T26 correction + `ppa_completeness.csv`); yield drops exposed (T96 Prob015/Prob045); pretrained honesty (official DeepGate bridges, MasterRTL Area-head retired, T08/T09/T10/T16 labeled proxy closures not true reproductions); literal classic-perspective win/loss; passive-archive QD-side-only vs classic `not_available` labeled.

5. **Remaining gaps caveated, not hidden.** `completion_gap_audit.md` carries an explicit "Evidence Still Missing" table; passive-archive classic projection `not_available` is labeled per-row in the inventory and central guardrails; secondary aggregates (QD-score AUC, coverage AUC, unique-front-family, Pareto-spread) are declared out of headline scope; legacy/partial rows (Qwen, T83/T88, aux archive) are flagged. The open TODO items (#92, #97–99) are scoped as documented limitations the headline claim does not rely on.

## Non-blocking observations (recommended before manuscript, not required for this verdict)

- **Secondary-metric drift on the shared classic comparator.** The same `classic_revolution_8x5` seed-1001 run reports `mean_hv_auc` `0.123942` in the AURORA package vs `0.126034` in the DeepGate/runtime-screen packages, and `yield_warning_count` 1 vs 2. The headline `mean_global_ppa_hv`/Pareto are identical, and these metrics are out of headline scope, so the negative map is unaffected — but reconcile the HV-AUC recomputation path (or note it as per-package recomputation) before any manuscript table cites HV-AUC.
- **Validation artifact finalized.** Per the implementer's own rerun protocol,
  `useful_bd_push_subagent_validation_report.md` has been replaced with this
  clean `PASS` and the result is logged in
  `useful_bd_push_implementation_history.md`.

These are quality/traceability polish, not missing experiments or hidden negatives. The negative-map package is rigorous enough for the stated goal: **`PASS`**.
