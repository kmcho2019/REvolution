# T53 Sparse-Front Trigger QD Hard/Tuning Probe Package

Classic root: `exp/useful_bd_push/t47_t26_contract_probe_20260622_203146_UTC/hard_tuning/classic_revolution`
T53 Sparse-Front Trigger QD root: `exp/useful_bd_push/t53_sparse_front_trigger_20260623_045328_UTC/hard_tuning/code_thought_sparse_front_trigger_qd`

## Headline

- Claim status: `T0 diagnostic_not_promoted`.
- Mean HV delta: `-0.006808`.
- Mean HV-AUC delta: `-0.011009`.
- Mean best-score delta: `0.062507`.
- Classic-covered valid-PPA losses: `0`.
- Yield warnings: `2`.
- Success-parent requests: `0`.
- sparse front trigger batches: `25`.
- sparse front trigger parent requests: `25`.
- Two-parent attempts: `0`.

## Aggregate Metrics

| Method | Rows | Problems | Mean HV | Mean HV-AUC | Mean Best | Valid PPA | Front Points |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Classic | 13 | 13 | 0.092601 | 0.082020 | 0.227928 | 257 | 30 |
| T53 sparse-front trigger QD | 13 | 13 | 0.085793 | 0.071011 | 0.290435 | 239 | 22 |

## Files

- `tables/t53_problem_seed_metrics.csv`
- `tables/t53_aggregate_metrics.csv`
- `tables/t53_comparison_deltas.csv`
- `tables/t53_validity_gates.csv`
- `tables/t53_operator_counters.csv`
- `data/t53_ppa_candidates.csv`
- `figures/t53_hv_delta_heatmap.png`
- `figures/t53_metric_delta_summary.png`
- `figures/t53_validity_funnel.png`
- `figures/t53_front_counts.png`
- `figures/t53_operator_counters.png`
- `figures/t53_direct_ppa_fronts_seed*.png`

## Discipline

This package compares a hard/tuning screen against the T47 classic
roots. It is not a held-out RTLLM claim. The direct PPA-front plots are
reader-facing supplements; they do not replace the Phase 03.1 viewer if
T53 Sparse-Front Trigger QD advances to a larger archive-backed run.

## Decision

T53 is retired as a direct T51/T52 follow-up. It preserves every
classic-covered design and improves best score, but classic still wins HV,
HV-AUC, valid-PPA count, front breadth, unique PPA, and reference-beating
candidates. The sparse-front trigger fired 25 times, so the negative result is
not a no-op.
