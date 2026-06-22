# T30 T26 Holdout Front Audit Methodology

## Purpose

T30 is a holdout audit for the current SR-family lead, not a new descriptor.
T26 conservative-exploit SR raw is the best current archive-coupling lead on
the three-problem RTLLM development screen: T27 supports it on live HV/HV-AUC,
T28 shows its valid candidates are not duplicate collapse, and T29 shows that a
simple front-recovery schedule interpolation fails.

The next rigorous step is to test whether T26's signal survives on a frozen
holdout screen before designing a T31 repair/yield emitter. This prevents the
search from overfitting to `Prob045_alu`, `Prob041_traffic_light`, and
`Prob015_multi_pipe_8bit`.

## Holdout Screen

The holdout problems are the three entries already frozen in
`../../tables/holdout_screening_subset.csv`:

- `VerilogEval-Spec-to-RTL/Prob150_review2015_fsmonehot`
- `VerilogEval-Spec-to-RTL/Prob098_circuit7`
- `VerilogEval-Spec-to-RTL/Prob135_m2014_q6b`

This package must not replace these problems after seeing T30 outcomes.
Replacement remains governed by `../../screening_subset_selection.md`.

## Compared Arms

T30 runs two arms with identical model, seed, prompts, operators, budget, and
evaluation flow:

1. `classic_revolution`: classic REvolution baseline using `eoh_strategies`.
2. `sr_raw_conservative_exploit_qd`: the exact T26 method:
   - SR raw PCA descriptor;
   - `grid_quantile` archive;
   - `qd_cell_mode=pareto_front`;
   - `qd_max_elites_per_cell=5`;
   - `qd_parent_selection=nsga2_global_rank`;
   - `qd_champion_lane_fraction=0.80`;
   - `qd_two_parent_probability=0.00`;
   - `qd_fill_target_fraction=0.25`;
   - `qd_improve_backfill_fraction=0.20`.

T30 does not use final PPA, reference PPA, fitness, hypervolume, Pareto rank,
or pass rate as behavior-descriptor inputs. PPA is used only after evaluation
for local Pareto retention, parent selection, and offline reporting.

## Fixed Runtime

- seed: `1001`
- model: `openai/gpt-oss-120b`
- endpoint: `20.0.0.103:8000`
- population: `12`
- generations: `3`
- evaluation mode: `strict_ablation`
- token budgets: `--max_tokens 128000 --diff_max_tokens 128000`
- worker policy: `--total_worker_slots 12 --max_active_problems 3`
  `--max_workers_per_problem 4`

## Primary Questions

1. Does T26 preserve every classic-covered holdout design under the same
   budget?
2. Does T26 remain near-classic or better on direct PPA-front/HV evidence, not
   only on final best score?
3. Does T26's valid candidate pool remain non-duplicative on canonical RTL,
   synthesized netlist, and cell-family hashes?
4. If T26 fails holdout, is the failure dominated by valid-yield collapse,
   front-material loss, duplicate collapse, or weak final quality?

## Promotion Gates

T30 can support T26 as `T1` or higher only if:

- T26 has at least one valid functional PPA candidate for every holdout design
  where classic has at least one valid functional PPA candidate;
- T26 does not have a 50 percent or larger relative functionality or
  synthesis-validity drop where the classic denominator is at least 10;
- direct PPA-front plots and family-front tables do not reveal hidden duplicate
  collapse;
- any positive claim is made on HV, HV-AUC, front material, valid-PPA yield,
  or family-front evidence, not average fitness alone.

## Required Artifacts

- `/v1/models` preflight capture;
- exact live commands in `commands/live_holdout_v0.md`;
- per-problem summaries, generation logs, archive cells, archive summaries,
  and global Pareto summaries;
- Pareto archive validation for the T26 arm;
- direct raw PPA-front figures with conventional lower-left-better axes,
  candidate zoom, and normalized PPA-front figures;
- canonical RTL/netlist/family duplicate audit tables;
- `results_report.md` with a T0/T1/T2/T3 tier decision;
- visual inspection notes.

## Current Status

Current tier: `T1 near-classic` holdout support with a P098 yield warning.

Do not change the compared arms or holdout problem list after seeing live
results. Any repair/yield emitter must become a separate T31 package.
