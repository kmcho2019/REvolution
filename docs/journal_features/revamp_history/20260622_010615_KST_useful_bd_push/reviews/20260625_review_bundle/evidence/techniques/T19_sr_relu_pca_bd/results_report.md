# SR ReLU PCA BD Results Report

Status: current replay package for `sr_random_relu_pca_qd`.

Tier decision: `T0 diagnostic`, high-priority HV lead.

## Terminology

- `SR ReLU PCA`: fixed random-ReLU projection over PPA-free
  synthesis-response features, followed by frozen PCA descriptor axes.
- `mean hypervolume`: average per-problem PPA hypervolume at the final
  generation on the compared subset.
- `HV AUC`: area under the generation-by-generation mean-hypervolume curve;
  this captures anytime behavior, not only the final generation.
- `common-audit QD score`: passive archive score on the shared audit grid used
  for cross-method comparison.
- `PPA-front unique netlists`: distinct canonical netlists on the final
  nondominated PPA front after archive retention.

## Setup

This package re-scores the historical seed-1 Auto-BD
`sr_random_relu_pca_qd` standard-result artifacts with the current useful-BD
metric policy. The compared methods are classic REvolution, landing
Smooth-QD/manual BD, and SR ReLU PCA on the same six-problem development
subset, seed `1001`, model `openai/gpt-oss-120b`, and 288 generated candidates
per method.

The central replay source is:

`exp/useful_bd_push/central_replay_20260621_165000_UTC/`

## Tables

- `tables/gate_matrix.csv`
- `tables/validity_funnel.csv`
- `tables/validity_gate.csv`
- `tables/leaderboard_comparison.csv`
- `tables/archive_metrics.csv`
- `tables/per_problem_deltas_vs_classic.csv`
- `tables/per_problem_ppa_diversity.csv`
- `tables/metric_deltas_vs_classic.csv`
- `tables/descriptor_correlations.csv`

## Figures

- `figures/seed1_mean_hypervolume.png`
- `figures/seed1_common_audit_coverage.png`
- `figures/seed1_ppa_grid_coverage.png`
- `figures/seed1_common_audit_cells_heatmap.png`
- `figures/seed1_metric_deltas_vs_classic.png`
- `figures/seed1_validity_funnel.png`
- `figures/duplicate_accounting.png`

Visual inspection notes are in `figures/visual_inspection_notes.md`.

## Key Results

| Metric | Classic | SR ReLU PCA | Delta |
| --- | ---: | ---: | ---: |
| Mean hypervolume | 0.1245 | 0.1454 | +16.82% |
| Mean best fitness | 0.2671 | 0.2536 | -5.04% |
| HV AUC | 0.0728 | 0.1202 | +65.24% |
| Best-fitness AUC | 0.2327 | 0.2369 | +1.82% |
| Valid-PPA candidates | 209 | 197 | -5.74% |
| PPA-front unique netlists | 12 | 11 | -8.33% |
| Unique canonical netlists | 70 | 68 | -2.86% |
| Unique motif signatures | 43 | 44 | +2.33% |
| Common-audit occupied cells | 12 | 10 | -16.67% |
| Common-audit QD score | 2.3163 | 2.3765 | +2.60% |

Gate 0 passes: SR ReLU PCA covers all six classic-covered problems. The
small-n caveat is not active because classic has 209 passing samples for
functionality, synthesis, and valid PPA. The 50 percent collapse gate is
enforced and passes: all three pass rates decline by only 5.74% relative to
classic.

Per-problem HV is better than classic on two problems:
`VerilogEval-Spec-to-RTL/Prob021_mux256to1v` and
`VerilogEval-Spec-to-RTL/Prob030_popcount255`. It ties three problems and loses
one, `RTLLM/Prob011_multi_16bit`. The Prob021 gain is large enough to dominate
the aggregate HV improvement, so follow-up validation must check whether the
effect survives another seed or a holdout subset.

## Interpretation

SR ReLU PCA is the clearest evidence so far that an automatic
synthesis-response descriptor can change the explored PPA region in a useful
direction. It improves final mean HV, HV AUC, common-audit QD score, and motif
signature count without a functionality or synthesis collapse.

It is not a clean promotion result. Final mean best fitness regresses by about
5%, PPA-front unique netlists decline, and common-audit occupied cells decline.
That combination means the descriptor may be finding a better tradeoff region
for a small subset of problems while narrowing other archive coverage.

The result should therefore be treated as an escalation target:

- keep SR ReLU PCA in the synthesis-response automatic-BD lane;
- validate the Prob021 and Prob030 wins under another seed or holdout subset;
- combine SR ReLU with the `T17` local-Pareto archive rule;
- add a quality-safe parent schedule before any live MAP-Elites claim.

## Conclusion

`T19_sr_relu_pca_bd` answers the "do any useful BDs exist?" question more
positively than the earlier negative map, but still only as a diagnostic lead.
The method beats classic on final mean HV and anytime HV AUC under the current
seed-1001 replay, and it preserves every classic-covered design.

It does not yet answer the stronger journal question that QD/MAP-Elites gives a
broader or more reliable Pareto-front exploration advantage under the same
budget. The quality and coverage losses mean the next step should be a bounded
SR ReLU plus local-Pareto live variant, not a claim that SR ReLU alone solves
the BD problem.
