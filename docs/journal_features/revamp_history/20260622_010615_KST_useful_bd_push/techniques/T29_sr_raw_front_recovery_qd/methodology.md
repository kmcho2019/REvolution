# T29 SR Raw Front Recovery QD Methodology

## Purpose

T29 is the direct live follow-up to the T26/T27/T28 evidence and the direct
PPA-front visualization audit. T26 restored hill-climbing pressure and beat
classic on aggregate live HV/HV-AUC, but T28 and the direct-front audit show a
real front-material blocker: T26 has fewer candidate-level and family-level
rank-1 PPA-front options than classic and T24 SR raw, especially on
`Prob015_multi_pipe_8bit`.

T29 tests whether a small, pre-registered return of SR raw exploration can
recover front material without losing the champion-biased quality pressure that
made T26 promising.

## Algorithm

T29 keeps the same behavior descriptor and archive substrate as T26:

1. Use the frozen SR raw PCA descriptor profile.
2. Use `grid_quantile` archive initialization after eight successful samples.
3. Store up to five candidates per cell with `qd_cell_mode=pareto_front`.
4. Use NSGA-II global parent ranking over evaluated archive members.
5. Use PPA only after evaluation for local Pareto retention and parent
   selection. PPA, hypervolume, Pareto rank, reference PPA, test pass rate, and
   final fitness are not descriptor inputs.

T29 changes only the parent-source pressure:

- `qd_champion_lane_fraction=0.60`: keep a majority champion-refinement lane
  but reserve a fixed 40% of archive-parent draws for nonchampion NSGA-II
  archive members.
- `qd_two_parent_probability=0.20`: reintroduce limited archive fusion after
  T26 removed crossover entirely. This is intentionally far below T24 SR raw's
  0.50 setting.
- `qd_fill_target_fraction=0.25`: keep the T24/T26 fill target so the run does
  not prematurely abandon archive filling.
- `qd_improve_backfill_fraction=0.20`: keep the default improve-phase
  backfill lane; this is not the active ablation lever.

This is not a descriptor reset and not a scalar-fitness hill climber. It is a
front-recovery parent-source ablation between T24 SR raw and T26 conservative
exploit:

| Lever | T24 SR raw | T26 conservative exploit | T29 front recovery |
| --- | ---: | ---: | ---: |
| Champion lane | 0.50 | 0.80 | 0.60 |
| Two-parent probability | 0.50 | 0.00 | 0.20 |
| Fill target fraction | 0.25 default | 0.25 | 0.25 |
| Improve backfill fraction | 0.20 default | 0.20 | 0.20 |

## Fixed Development Screen

The live screen is identical to T24/T25/T26:

- seed: `1001`
- model: `openai/gpt-oss-120b`
- endpoint: `20.0.0.103:8000`
- population: `12`
- generations: `3`
- evaluation mode: `strict_ablation`
- token budgets: `--max_tokens 128000 --diff_max_tokens 128000`
- problems:
  - `RTLLM/Prob045_alu`
  - `RTLLM/Prob041_traffic_light`
  - `RTLLM/Prob015_multi_pipe_8bit`

## Comparator Set

T29 must compare against:

- T24 classic REvolution;
- T24 landing Smooth-QD/manual BD;
- T24 random descriptor QD;
- T24 unguarded SR raw Pareto QD;
- T25 guarded SR raw Pareto QD;
- T26 conservative exploit SR raw.

The direct front audit in
`../../visualization_audits/20260621_direct_ppa_fronts/` is the visual
baseline for the front-shape question.

## Promotion Gates

T29 can become `T1` or higher only if it:

- preserves all three classic-covered designs;
- avoids a 50 percent or larger relative functionality/synthesis-validity
  decline where the classic denominator is at least 10;
- improves candidate-level or family-level front material versus T26 on the
  fixed screen without collapsing the T26 HV/HV-AUC signal;
- beats random and manual BD on the metric used for any positive QD claim;
- reports duplicate/canonical family accounting before claiming broader
  diversity;
- includes direct raw and normalized PPA-front figures.

If T29 recovers front points but loses T26's live HV/HV-AUC and best-quality
pressure, it stays `T0 diagnostic`. If it keeps T26's HV/HV-AUC while improving
front material, it becomes a `T1 near_classic` candidate that still needs
holdout or multi-seed validation.

## Expected Artifacts

The live root will be:

`exp/useful_bd_push/t29_sr_raw_front_recovery_qd_<RUN_TS>/`

Required artifacts:

- `/v1/models` preflight capture;
- exact live command in `commands/live_screen_v0.md`;
- per-problem summaries, generation logs, archive cells, archive summaries,
  and global Pareto summaries;
- Pareto archive validation output;
- comparison tables against T24/T25/T26 controls;
- direct PPA-front figures, family/duplicate figures, and visual inspection
  notes;
- `results_report.md` with a T0/T1/T2/T3 tier decision.

## Current Status

Current tier: pending.

This package is pre-registered before the live run. Do not change the parameter
values above after seeing T29 results; create a T30 package for any follow-up
variant.
