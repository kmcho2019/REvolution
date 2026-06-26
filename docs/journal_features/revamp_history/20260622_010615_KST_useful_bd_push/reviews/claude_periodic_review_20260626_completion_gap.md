I've completed a thorough read of all required files plus the registry, the results-matrix tail, and the most-referenced new reporting script. Here is the review.

---

# Periodic Read-Only Review — Useful-BD Push

## Verdict: `PASS_WITH_ACTIONS`

The research claims themselves are honest and well-guarded: the headline numbers are internally consistent across `useful_bd_push_plan.md`, `current_selection_status.md`, `best_current_techniques.md`, `completion_gap_audit.md`, and `technique_registry.csv`; "no QD arm promoted for full RTLLM spend" is stated everywhere; and the classic loopholes (missing-reference PPA, smoke-only promotion, single-seed overclaiming, yield collapse) are explicitly defended. No overclaim rises to `FAIL`.

It is **not** a clean `PASS` because two of the documents the review names — `technique_registry.csv` and `technique_lineage_ledger.md` — are materially out of sync with the latest state, and `current_selection_status.md` contradicts itself about the current FG-QDM representative. These are documentation-integrity defects that would mislead a colleague about how far the search has gone.

---

## Findings, ordered by severity

### HIGH — would mislead a colleague about status

**H1. `T100` is missing from `technique_registry.csv`, the declared source of truth.**
The registry has 99 data rows and stops at `T99`. Yet `techniques/T100_front_credit_rf_leafid_fg_qdm_memory/` exists, and T100 is cited as the current FG-QDM category representative, **Rank 1** of the overall top-10 mean-HV table (`current_selection_status.md:66`), and Rank 9 of `best_current_techniques.md:19`. `technique_lineage_ledger.md:353` calls the registry "the chronological source of truth for package IDs and paths" — so the single most-cited recent result is invisible from the canonical index. (Side note: the directory slug `T100_front_credit_rf_leafid_fg_qdm_memory` differs from the doc config key `T100_fg_qdm_rf_leafid_front_credit_12x3`; a registry row is exactly where those should be reconciled.) This is also why `completion_gap_audit.md:26` can say "T01-T100 family packages" while the registry stops at T99 (cosmetic knock-on).

**H2. `technique_lineage_ledger.md` (the "skim-first process map") lags by ~14 techniques.**
It contains **zero** mentions of `T88`, `T99`, or `T100`; its Result Ledger table and Mermaid lineage graph stop at `T86` (archive lane) and `T84` (RTL-native lane). It omits:
- `T87` RTL-native FG-QDM,
- **`T88` — the three-seed replication that is the actual reason T83 is blocked**,
- the entire `T89–T96` DeepGate / RF-DeepGate bridge lineage,
- `T97`/`T98` front-credit FG-QDM,
- `T99` live AURORA, and
- `T100`, the current FG-QDM representative.

A colleague skimming this file as intended would conclude the search ended at T86, would not know the DeepGate lane exists, and would not see that T83's near-classic single seed was overturned by replication. (For contrast, `technique_lanes.md` *does* mention T100 and is reasonably current — so the staleness is specific to the lineage ledger.)

### MEDIUM — overclaiming-adjacent, but partly caveated

**H3. `current_selection_status.md` contradicts itself on the FG-QDM representative.**
The header "Current Category Representatives" table (line 53) and the FG-QDM Contribution Audit closing paragraph (lines 243–252) both name **T100**. But the "Front-Guarded QD-Memory Candidate" section (line 300) still states: *"Decision: T97 replaces T85 as the current front-guarded memory category representative."* Two different reps in one document. The T97 sentence is stale.

**H4. The "Top 10 Overall QD Configs By Mean HV" table ranks across non-comparable baselines.**
Rank 1 = T100 (`0.1566`, three-problem smoke vs classic `0.1903`) is read as "best overall observed QD mean HV" (lines 66, 77). But absolute mean HV is not comparable between the three-problem smoke surface (classic `0.1903`) and the eight-design surface (classic `0.1406`). By *relative* gap to its own matched classic, T100 is actually the **worst** of the leading arms (−17.7%), while single-seed T83 is −2.6%. The table is mitigated — a mandatory Scope column, an explicit "not interchangeable" warning, and repeated "operational, not a paper claim" language — so this is guarded, not naked. But "best overall observed QD mean-HV result" plus a Rank-1 slot still invites a skim-level misread. This is the one residual loophole-style risk under review Q4.

**H5. Registry state drift for T97/T98.** Both are `current_smoke_result` in the registry even though T100 now supersedes T97 as the FG-QDM rep. Minor bookkeeping, same root cause as H1/H3.

### LOW — nits

**H6.** `useful_bd_push_plan.md` lists the DeepCell reference twice (lines 442 and 444). Cosmetic.

---

## Answers to the review questions

1. **Plan honesty on T95/T96/T99/T100 and T08/T09/T10/T12/T16/T18 closure — mostly yes.** The plan's "Current Research State" and "Current Validation Target" carry all of these with correct negative/representative framing, and importantly the plan tracks **T100** (not the older T97) as the FG-QDM rep. The closures of the six scaffolds are confirmed in the registry (`T0_retrospective_*_not_promoted` / `_retired`). The lag is in the lineage ledger (H2) and registry (H1), not the plan.

2. **`completion_gap_audit.md` correctly scopes remaining work — yes.** Its six "Evidence Still Missing" rows (passive-archive inventory; full metric set incl. QD-score AUC, coverage AUC, unique-front-family, Pareto-spread; central comparison report; figure-completeness inventory; adversarial validation; stop-condition audit) map cleanly onto the open todos (`useful_bd_push_implementation_todo.md:90–92, 225, 502–506, 744, 758–759`). It should add one item: "re-sync registry + lineage ledger" (H1/H2).

3. **selection_status vs best_current_techniques consistency — consistent on numbers and on "no promotion."** Category reps, the `0.1406 / 0.1903 / 0.1442 / 0.1701` baselines, and per-arm HV values all agree. The only defect is *inside* selection_status (H3), not between the two files.

4. **Loophole exposure — well-guarded.** Missing-reference handled (reference-complete subset; the four no-reference RTLLM designs named in `best_current_techniques.md:310–312`). Smoke-only promotion blocked (T100 rep-only). Single-seed overclaiming corrected by T88 replication. Yield collapse surfaced (T96 `24→10`/`36→11`; T44 >50% gate; T85/T87 zero valid-PPA memory children). Residual risk: the cross-surface ranking in H4.

5. **Skimmability — mixed.** Plan, selection_status, best_current_techniques, and completion_gap_audit are current and skimmable. The lineage ledger (H2) is stale, and the T97/T100 contradiction (H3) is exactly the buried inconsistency this question targets.

6. **Simplicity / no defensive sprawl — looks good on the visible surface.** `scripts/report_common_evaluation_contract.py` (659 lines) is built from small single-purpose functions (`read_csv`, `parse_metric`, `passive_metrics`, `summary_rows`, …), with **no try/except cascades** (it uses `None`-returns and sentinels, consistent with GUIDELINES rule #10), and its `not_available` behavior is honest reporting rather than runtime fallback. The periodic-review-flagged "defensive metadata defaults / FG-QDM credit constants" were addressed (`todo:741` checked). Caveats: two hygiene todos remain open (`todo:231–233`, shared-surface consolidation + docstrings), and I did not diff the FG-QDM/descriptor runtime hooks themselves — only the exporter.

7. **Next 3–5 actions** — see below.

---

## Concrete wording changes to avoid overclaiming

- `current_selection_status.md:300` — replace *"T97 replaces T85 as the current front-guarded memory category representative"* with *"T97 superseded T85; **T100** is now the front-guarded memory category representative (see the FG-QDM Contribution Audit below)."*
- `current_selection_status.md:64–66, 77` — drop "best overall observed QD mean HV" framing, or rename the metric column to **"absolute mean HV (NOT comparable across smoke vs 8-design surfaces)"** and add a second sort key on *relative delta to matched classic*. As written, Rank 1 reads as "the best QD result" when it has the widest relative loss.
- `completion_gap_audit.md:26` — keep "T01-T100" only after T100 is actually added to the registry; otherwise change to "T01–T99 plus the T100 FG-QDM package."

---

## Live-run judgment

**Do not launch another live run now; close metrics/figures/comparison/adversarial first.** The branch's own gates already say this: the 20260626 front-memory replay gate and FG-QDM contribution audit conclude that another run is only justified if it materially raises memory-lane **front-add-per-LLM-call**, and no such mechanism is currently specified. Every outstanding closure item — registry/ledger sync (H1, H2), the passive-archive + full-metric completeness inventory, the central negative-map comparison report, the figure inventory, the read-only adversarial validation (`useful_bd_push_subagent_validation_report.md` still says *not run*), and the anti-reward-hacking stop-condition audit — costs zero GPU budget and is exactly what converts the current honest-but-unsigned negative map into a defensible sign-off. Spend there before any further vLLM budget.

**Priority order:** (1) add the T100 row to the registry and extend the lineage ledger through T87–T100, emphasizing T88 replication and the T89–T96 DeepGate lane; (2) fix the T97/T100 contradiction and mark T97/T98 superseded; (3) build the passive-archive + metric-completeness inventory; (4) write the central comparison report + figure inventory and re-label the top-10 table; (5) run the final adversarial validation and the stop-condition audit.
