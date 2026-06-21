# MOME Pareto Archive BD Results Report

Status: completed passive diagnostic package.

Tier: `T0 diagnostic`.

## Terminology

- `scalar_cell_elite`: one retained candidate per common-audit cell, selected by
  finite fitness.
- `bounded_local_pareto`: up to four nondominated valid-PPA candidates per
  common-audit cell, pruned by crowding distance when needed.
- `common-audit cell`: the fixed motif-ratio passive archive cell used to compare
  all methods on the same descriptor grid.
- `PPA-front unique netlists`: distinct canonical netlists on the global
  nondominated PPA front after retention.

## Setup

The audit replays the seed-1001 standard-result Parquet tables from the
20260618 Auto-BD run. `/aux` is read-only source evidence. New generated outputs
were written locally under:

`exp/useful_bd_push/t17_mome_pareto_audit_20260621_175500_UTC/`

The committed T17 package mirrors the CSV tables and PNG figures needed for the
journal record.

## Evidence Tables

- `tables/source_manifest.csv`
- `tables/aggregate.csv`
- `tables/deltas.csv`
- `tables/problem_metrics.csv`
- `tables/retained_candidates.csv`

## Figures

- `figures/mome_retention_hypervolume.png`
- `figures/mome_global_pareto_points.png`
- `figures/mome_vs_scalar_deltas.png`
- `figures/mome_retained_candidates_heatmap.png`
- `figures/visual_inspection_notes.md`

## Main Results

Bounded local-Pareto retention exposes much more front material than one
scalar elite per cell, but it does not by itself create a decisive hypervolume
win. This is a useful archive-coupling diagnostic, not a promoted optimization
result.

| Method | Scalar HV | Local-Pareto HV | HV Delta | Scalar PPA-front nets | Local-Pareto PPA-front nets | Grid-cell delta |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| Classic | 0.124485 | 0.124485 | 0.000000 | 6 | 10 | 0 |
| Manual BD | 0.105879 | 0.105879 | 0.000000 | 7 | 11 | 1 |
| SR ReLU PCA | 0.145298 | 0.145428 | 0.000130 | 6 | 11 | 2 |
| SR-RFF PCA | 0.122151 | 0.122184 | 0.000033 | 6 | 14 | 2 |
| ST-NOD+motif | 0.120397 | 0.120397 | 0.000000 | 8 | 14 | 2 |

The best front-diversity signal is `sr_rff_pca_qd`: bounded local-Pareto
retention increases retained candidates from 10 to 23, global Pareto points from
6 to 19, PPA-front unique netlists from 6 to 14, PPA-grid cells from 7 to 9, and
unique canonical netlists from 10 to 18. Its HV delta is only +0.027%, so the
result is not a standalone win.

`sr_random_relu_pca_qd` remains the strongest HV source in this replay: bounded
local-Pareto retention gives mean HV 0.145428 versus classic scalar HV 0.124485.
That advantage belongs to the underlying SR ReLU method plus existing generated
candidates, not to the T17 retention rule alone.

## Interpretation

The user hypothesis is supported as a direction: pure QD cell coverage can lose
against classic because classic keeps climbing on high-quality candidates, while
one-elite MAP-Elites can discard useful tradeoff candidates in the same cell.
Keeping local nondominated sets recovers those tradeoffs without using scalar
weighted fitness as the descriptor.

The evidence is not yet enough for `T1 near_classic` because this is passive
retention over already generated candidates. It does not prove that live parent
sampling from local Pareto fronts will generate better descendants under the
same budget.

## Next Step

Run a bounded live variant on the strongest descriptor family:

- descriptor: `sr_rff_pca_qd` or `sr_random_relu_pca_qd`;
- archive mode: local Pareto fronts with capacity 4;
- parent schedule: 50% local Pareto crowded tournament, 30% underfilled-cell
  exploration, 20% global nondominated-front sampling;
- comparison: same subset, prompts, endpoint, seeds, budget, and validity gates
  as the seed-1001 development run.

This is the right escalation path before abandoning QD archive coupling.
