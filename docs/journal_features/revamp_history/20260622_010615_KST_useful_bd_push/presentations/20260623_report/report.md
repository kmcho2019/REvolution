# Does Diversity Matter For RTL PPA Evolution?

Status: one-seed full RTLLM milestone landed on 2026-06-22 UTC.

Primary package:
`presentations/20260623_report/full_rtllm/`

Merged run root:
`exp/useful_bd_push/rtllm_milestone_full_20260622_142254_UTC/merged_ref_default_fix_v0`

## Executive Answer

Question 1: Does diversity matter?

Yes, but only in a scoped and PPA-first sense. The full RTLLM milestone gives
reviewable evidence that the T26-family QD/MAP-Elites line should not be
dropped: exact T26 preserves every classic-covered design, improves aggregate
mean PPA hypervolume by `0.010562` (+11.18%), improves aggregate mean HV-AUC by
`0.012397` (+15.31%), and produces more total PPA-front points (`69` versus
`61`) at the same one-seed, 12x3 budget.

This is not yet a broad decisive win. Per-problem HV has `4` QD wins, `15`
QD losses, and `31` ties. The aggregate HV result is strongly affected by
`Prob040_synchronizer`; without that problem, mean HV delta is `-0.009465` and
mean HV-AUC delta is `-0.007588`. QD also has lower valid-PPA yield (`879`
versus `1056`) and fewer unique PPA points (`318` versus `352`). The correct
claim level is therefore `reviewable useful-QD evidence`, not seed-stable proof
or `strong_win`.

Question 2: Which diversity matters?

The useful diversity appears to be implementation-response diversity coupled
to quality-safe archive pressure. The best current pattern is not "more novelty"
by itself. It is an SR raw descriptor/archive bundle that keeps champion-style
hill climbing active while using QD/MAP-Elites to preserve alternative
implementation responses. Lexical, identifier, random, overly sparse graph, and
unguarded local-Pareto diversity have repeatedly failed or produced yield loss
without enough PPA evidence.

## Definitions

Valid functional PPA candidate: a generated candidate that reaches the
synthesis/PPA stage and contributes PPA metrics used by the Pareto analysis.
This is stricter than syntax pass and functionality pass alone.

Classic-covered problem: an RTLLM problem where the classic REvolution arm has
at least one valid functional PPA candidate under the same budget.

PPA-first retention gate: for this milestone, QD passes the hard gate if every
classic-covered problem also has at least one valid QD PPA candidate. Larger
functionality or valid-PPA rate drops are reported as yield warnings rather
than automatic blockers.

Yield warning: a functionality or valid-PPA count drop of at least 50% when the
classic denominator is at least 10. Smaller denominators are labeled small-n
because the rate is too sensitive to noise.

PPA hypervolume, or HV: the hypervolume of nondominated normalized improvement
points. Improvement is `(reference - candidate) / abs(reference)` for area,
power, and effective clock period when timing reference data exists, otherwise
area and power. Negative improvements are clipped to zero before hypervolume is
computed.

HV-AUC: the area under the PPA-HV-over-generations curve. It rewards earlier
discovery of useful front points, not only final population quality.

PPA-front point: a nondominated valid PPA candidate in the normalized
improvement space for one problem and method.

Unique PPA point: a deduplicated normalized PPA-improvement point. This catches
duplicate collapse even when many candidates are valid.

## Full RTLLM Protocol

The comparison used all 50 RTLLM problems from
`bench/RTLLM/*_prompt.txt`, seed `1001`, population `12`, generations `3`, and
`openai/gpt-oss-120b` on the local vLLM endpoint with 128k token budgets.

Classic arm:
`classic_revolution` with `eoh_strategies`.

QD arm:
exact T26, `sr_raw_conservative_exploit_qd`, with grid-quantile SR raw
descriptors, Pareto-front archive cells, `qd_fill_target_fraction=0.25`,
`qd_improve_backfill_fraction=0.20`, `qd_champion_lane_fraction=0.80`,
NSGA-II global-rank parent selection, and two-parent fusion disabled.

Exact T26 was selected before seeing full RTLLM results. The screen favored it
because it was the only screened QD arm with positive mean HV and it improved
HV-AUC, despite visible yield warnings on the development screen.

## Result Summary

| Cohort | Metric | Classic | Exact T26 QD | Delta |
| --- | ---: | ---: | ---: | ---: |
| All RTLLM | Mean HV | 0.094435 | 0.104997 | +0.010562 |
| All RTLLM | Mean HV-AUC | 0.080956 | 0.093353 | +0.012397 |
| All RTLLM | Valid PPA | 1056 | 879 | -177 |
| All RTLLM | PPA-front points | 61 | 69 | +8 |
| All RTLLM | Unique PPA points | 352 | 318 | -34 |
| Screen-excluded | Mean HV | 0.088690 | 0.103015 | +0.014325 |
| Screen-excluded | Mean HV-AUC | 0.075581 | 0.093051 | +0.017470 |
| Screen-excluded | Valid PPA | 989 | 845 | -144 |
| Screen-excluded | PPA-front points | 52 | 62 | +10 |

Retention gate:

- hard retention failures: `0`;
- yield warnings: `4`;
- small-n labels: `6`;
- `Prob006_adder_pipe_64bit` has no valid PPA in either arm, so it is not a
  classic-covered loss.

Yield warnings are concentrated on `Prob041_traffic_light`, `Prob043_RAM`,
`Prob044_ROM`, and `Prob045_alu`. These warnings matter, but they no longer
invalidate the method under the relaxed PPA-first policy because exact T26 keeps
at least one valid PPA sample on every classic-covered problem.

## Evidence Interpretation

The result argues that QD/MAP-Elites is still worth pursuing for RTL PPA
evolution. Exact T26 can find PPA-front structure that classic misses, and it
does so without losing design-level coverage. That is enough to justify the
research direction and a stronger follow-up run.

The result does not prove that exact T26 is already the final algorithm. The
negative screen subset, lower valid-PPA yield, fewer unique PPA points, and
outlier-sensitive HV mean show that the method still needs tuning. The most
useful next variants should preserve the PPA-front gains while reducing yield
loss and avoiding reliance on a single large-problem win.

The most promising technical direction remains T26/T26.1-style conservative
exploit pressure: keep the QD archive, but bias sampling toward archive
champions and near-front candidates so the method can hill-climb without
collapsing into average-fitness-only REvolution.

## Provenance And Repair Notes

The original exact T26 full run produced 47 usable problem summaries. Three
problems, `Prob013_multi_booth_8bit`, `Prob018_float_multi`, and
`Prob040_synchronizer`, exposed missing-reference PPA handling in RTLLM. The
code was fixed to use the documented high default reference when a benchmark
PPA file is absent, then those three problems were rerun in
`sr_raw_conservative_exploit_qd_ref_default_fix`.

The committed package uses a merged symlink root so the 47 original QD problem
directories remain unchanged and only the three repaired problem directories
come from the repair run. This keeps the result auditable while allowing the
full 50-problem package to be generated.

## Artifact Index

- `full_rtllm/README.md`: generated package summary.
- `full_rtllm/tables/full_problem_metrics.csv`: one row per method/problem.
- `full_rtllm/tables/full_aggregate_metrics.csv`: all, screen, and
  screen-excluded aggregate metrics.
- `full_rtllm/tables/full_comparison_deltas.csv`: paired QD-minus-classic
  deltas.
- `full_rtllm/tables/full_validity_gates.csv`: retention, warning, and small-n
  labels.
- `full_rtllm/data/full_ppa_candidates.csv`: raw candidate-level PPA data for
  regenerating the direct PPA-front figures.
- `full_rtllm/figures/`: generated PNG figures.
- `full_rtllm/figures/visual_inspection_notes.md`: manual visual inspection
  notes for the generated figures.

## Conclusion

The full one-seed RTLLM milestone answers the two core questions with useful
but bounded evidence. Diversity matters when it is implementation-aware and
kept under quality pressure. The best current diversity signal is the T26
implementation-response archive family, not generic embedding, lexical,
random, or sparsity-seeking diversity.

For the presentation, the defensible message is:
QD/MAP-Elites should continue because exact T26 beats classic on aggregate
PPA-HV, HV-AUC, and PPA-front count while preserving every classic-covered
problem. The honest caveat is that the gain is uneven, one-seed, and
outlier-sensitive, with visible yield loss. The next milestone should be
multi-seed replication plus T26.1-style variants that target yield recovery and
less outlier-dependent front improvement.
