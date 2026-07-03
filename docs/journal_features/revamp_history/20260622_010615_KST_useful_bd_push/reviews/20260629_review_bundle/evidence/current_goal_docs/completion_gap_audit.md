# Useful BD Push Completion Gap Audit

Status: clean negative-map validation recorded.

This audit maps the active goal to current evidence. It is not a sign-off
report for a positive useful-QD claim. It records why the current branch can
close a rigorous negative-map claim while preserving residual limitations for
future manuscript work.

## Current Claim

The current supported claim is:

> No screened QD/MAP-Elites behavior-descriptor or archive-coupling method is
> promoted for full RTLLM spend. The branch has produced a useful negative map
> and several category representatives. Final adversarial validation returned
> a clean `PASS`.

Do not claim that QD is useless in general. The narrower result is that the
tested descriptor and coupling families have not yet beaten matched classic
REvolution on reference-complete PPA-front evidence.

## Evidence Already Strong

| Requirement | Current Evidence | Status |
| --- | --- | --- |
| Attempt at least 10 real technique packages | T01-T100 family packages and preliminary screens | satisfied |
| Include simple, synthesis/netlist, learned/projection, and archive-coupling methods | T22 random control, T04/T19/T20 SR, T33/Qwen/T95 DeepGate/T99 AURORA, T85-T100 FG-QDM | satisfied |
| Preserve method-local methodology, tables, figures, reports, and tier decisions | T01-T22 scaffold closures plus T23-T100 packages | mostly satisfied |
| Maintain category representatives | `preliminary_planning/current_selection_status.md` | satisfied |
| Maintain top 10 by mean HV | `preliminary_planning/current_selection_status.md` | satisfied |
| Keep the chronological registry current | `techniques/technique_registry.csv` includes T100 | satisfied |
| Keep the skim-first lineage current | `technique_lineage_ledger.md` includes T87-T100 | satisfied |
| Avoid missing-reference headline comparisons | RTLLM correction and reference-complete screen tables | satisfied for recent headline screens |
| Avoid promoting smoke-only results | T100 remains category representative only | satisfied |

## Residual Limitations

| Requirement | Missing Or Weak Evidence | Required Closure |
| --- | --- | --- |
| Passive archive scoring for classic and every QD method | `tables/completion_gap_inventory.csv` shows recent T95/T96/T99/T100-style surfaces are covered, while Qwen, T83/T88, and auxiliary-archive replication are legacy/partial. | Legacy and selection-context rows are labeled non-headline in the central report; no secondary-metric aggregate uses them. |
| Full metric set across headline methods | `tables/completion_gap_inventory.csv` records which representatives have HV-AUC, passive archive, completeness, direct PPA, and viewer coverage. QD-score AUC, coverage AUC, unique front-family, and Pareto-spread coverage are still uneven. | Keep uneven legacy coverage caveated unless a future manuscript table needs those rows as headline evidence. |
| Central comparison report | `central_comparison_report.md` states the current negative-map claim and compares category representatives against classic. | Final validation returned clean `PASS` for the negative-map claim. |
| Visualization policy for every completed result | `tables/figure_completeness_inventory.csv` marks direct PPA artifacts, Phase 03.1 viewer presence, and visual-inspection notes for T01-T100 paths. Headline representatives T95/T96/T99/T100 are figure-backed. | Keep the inventory updated; older non-headline rows with `no` remain visible gaps, not headline negative-map evidence. |
| Final adversarial validation | `useful_bd_push_subagent_validation_report.md` records the clean final `PASS` verdict. | Satisfied for the current negative-map claim. |
| Stop condition | `stop_condition_audit.md` records that broad live-spend stop criteria are satisfied for the tested families. | The clean final validation accepted the stop condition at claim level. |

## Latest External Review

The periodic `claude -p` review at
`reviews/claude_periodic_review_20260626_completion_gap.md` returned
`PASS_WITH_ACTIONS`. Its high-severity findings were documentation-integrity
issues, not new experimental contradictions: T100 was missing from the
registry, the lineage ledger lagged T87-T100, and one selection-status
paragraph still named T97 as the current FG-QDM representative. These have
been corrected in the current working tree.

The final negative-map validation at
`useful_bd_push_subagent_validation_report.md` returned clean `PASS`. Earlier
documentation-integrity findings were addressed before that pass:
evidence-status tiers are explicit, inventory/context rows are synchronized,
stale validation references are replaced, and T99 has local
methodology/results/manifest entry points. The HV-bookkeeping review also led
to regenerated common tables with literal classic-perspective win/loss columns
and clarified T95/T100 report wording.

## Current Category Representatives

Use `preliminary_planning/current_selection_status.md` as the authoritative
selection document. The short read is:

- `T100_fg_qdm_rf_leafid_front_credit_12x3` is the best FG-QDM smoke by mean
  HV, but classic still wins the matched smoke.
- `T83_rf_leafid_structural_delayed_qd` and
  `masterrtl_aux_archive_high_exploit_8x5` are the closest MasterRTL
  model-state/archive clues, but replicated evidence is negative.
- `T95_deepgate_delayed_high_exploit_8x5` is the best pure DeepGate
  representative.
- `T96_rf_deepgate_hybrid_delayed_8x5` is the best RF/DeepGate hybrid
  representative, but it regresses versus sibling T83.
- `T99_aurora_raw_impl_delayed_qd` is the best AURORA/raw implementation
  representative.
- `qwen_canonical_rtl_pca3_8x5` remains the Qwen representative despite weak
  mean HV.

## Next Valid Actions

1. Commit the clean validation package and generated inventories.
2. Launch another live run only if it changes the mechanism, not just one
   descriptor axis, and if it can plausibly improve memory-lane front
   contribution per LLM call.
