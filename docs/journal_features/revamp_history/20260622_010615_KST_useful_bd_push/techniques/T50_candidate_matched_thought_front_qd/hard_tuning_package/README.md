# T50 Candidate-Matched Thought Front Hard/Tuning Probe Package

Classic root: `exp/useful_bd_push/t47_t26_contract_probe_20260622_203146_UTC/hard_tuning/classic_revolution`
T50 Candidate-Matched Thought Front root: `exp/useful_bd_push/t50_candidate_matched_thought_front_20260623_020738_UTC/hard_tuning/candidate_matched_thought_front_qd`

## Headline

- Scope: partial `12/13` hard/tuning screen. `Prob153_gshare` did not
  produce a T50 problem directory.
- Claim status: `diagnostic_rejected_for_promotion`.
- Mean HV delta: `-0.026686`.
- Mean HV-AUC delta: `-0.029095`.
- Mean best-score delta: `0.063433`.
- Classic-covered valid-PPA losses: `0`.
- Yield warnings: `10`.
- generated thought count: `44`.
- generated code sample count: `132`.
- Success-parent requests: `0`.
- Two-parent attempts: `0`.

## Aggregate Metrics

| Method | Rows | Problems | Mean HV | Mean HV-AUC | Mean Best | Valid PPA | Front Points |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Classic | 12 | 12 | 0.100303 | 0.088848 | 0.237868 | 244 | 26 |
| T50 candidate-matched thought front QD | 12 | 12 | 0.073617 | 0.059753 | 0.301301 | 156 | 18 |

## Files

- `tables/t50_problem_seed_metrics.csv`
- `tables/t50_aggregate_metrics.csv`
- `tables/t50_comparison_deltas.csv`
- `tables/t50_validity_gates.csv`
- `tables/t50_operator_counters.csv`
- `tables/t50_family_comparison_12_problem_subset.csv`
- `tables/t50_family_deltas_12_problem_subset.csv`
- `data/t50_ppa_candidates.csv`
- `figures/t50_hv_delta_heatmap.png`
- `figures/t50_metric_delta_summary.png`
- `figures/t50_validity_funnel.png`
- `figures/t50_front_counts.png`
- `figures/t50_operator_counters.png`
- `figures/t50_direct_ppa_fronts_seed*.png`

## Discipline

This package compares a hard/tuning screen against the T47 classic
roots. It is not a held-out RTLLM claim. The direct PPA-front plots are
reader-facing supplements; they do not replace the Phase 03.1 viewer if
T50 Candidate-Matched Thought Front advances to a larger archive-backed run.

The package uses derived summary fields from `generation_log.jsonl` for T50
problem roots that produced archive artifacts but missed final summary files.
