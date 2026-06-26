# Useful BD Push Completion Gap Audit

Status: active, not complete.

This audit maps the active goal to current evidence. It is not a sign-off
report. It identifies the remaining proof gaps before either a positive
useful-QD claim or a rigorous negative-map claim can be closed.

## Current Claim

The current supported claim is:

> No screened QD/MAP-Elites behavior-descriptor or archive-coupling method is
> promoted for full RTLLM spend. The branch has produced a useful negative map
> and several category representatives, but the final negative-map sign-off
> still needs common metric completeness and adversarial validation.

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

## Evidence Still Missing

| Requirement | Missing Or Weak Evidence | Required Closure |
| --- | --- | --- |
| Passive archive scoring for classic and every QD method | `tables/completion_gap_inventory.csv` shows recent T95/T96/T99/T100-style surfaces are covered, while Qwen, T83/T88, and auxiliary-archive replication are legacy/partial. | Either backfill legacy rows or label them as non-headline/representative-only in the final report. |
| Full metric set across headline methods | `tables/completion_gap_inventory.csv` records which representatives have HV-AUC, passive archive, completeness, direct PPA, and viewer coverage. QD-score AUC, coverage AUC, unique front-family, and Pareto-spread coverage are still uneven. | Add final-report caveats or backfill only for rows used as headline evidence. |
| Central comparison report | Current selection docs are operational; no single final report states the accepted claim. | Write a concise central report comparing category reps against classic and landing/manual QD where available. |
| Visualization policy for every completed result | Many packages have inspected figures, but a branch-wide figure-completeness inventory is missing. | Add a figure inventory that marks direct raw PPA PNG, Phase 03.1 viewer, and visual-inspection status by package. |
| Final adversarial validation | `useful_bd_push_subagent_validation_report.md` still says not run. | Run read-only adversarial review on the exact final claim and record PASS or action items. |
| Stop condition | The branch has enough negative evidence, but the anti-reward-hacking stop audit has not been written. | If no new mechanism is launched, write a stop-condition audit showing the broad negative map is rigorous and not premature. |

## Latest External Review

The periodic `claude -p` review at
`reviews/claude_periodic_review_20260626_completion_gap.md` returned
`PASS_WITH_ACTIONS`. Its high-severity findings were documentation-integrity
issues, not new experimental contradictions: T100 was missing from the
registry, the lineage ledger lagged T87-T100, and one selection-status
paragraph still named T97 as the current FG-QDM representative. These have
been corrected in the current working tree.

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

1. Add metric-completeness and figure-completeness inventories.
2. Write the central comparison report for the current negative-map claim.
3. Run a long read-only adversarial review after those inventories are present.
4. Launch another live run only if it changes the mechanism, not just one
   descriptor axis, and if it can plausibly improve memory-lane front
   contribution per LLM call.
