# T25 Guarded SR Raw Pareto QD Methodology

## Purpose

T25 is the immediate follow-up to the complete T24 live matrix. T24 showed that
local Pareto cells run end to end and preserve all classic-covered problems,
but every QD arm lost too much `Prob015_multi_pipe_8bit` best quality. SR raw
kept the strongest multi-pipe front material and the best ALU gain, while
manual BD kept the strongest traffic-light best score.

T25 tests whether the SR raw descriptor can keep that useful front material
while reducing risky exploration pressure during the improve phase.

## Algorithm

T25 keeps the T24 SR raw descriptor and archive mechanics:

1. Extract frozen synthesis-response raw PCA descriptor values from successful
   synthesized netlists.
2. Initialize a `grid_quantile` archive after eight successful candidates.
3. Store up to five candidates per cell with `qd_cell_mode=pareto_front`.
4. Rank archive members by active PPA objectives for retention and global
   parent selection.
5. Sample parents with `qd_parent_selection=nsga2_global_rank`.

T25 changes only the parent-schedule guard:

- `qd_fill_target_fraction=0.10`: switch from fill to improve mode after a
  small number of occupied cells, so the run does not keep spending most of
  its budget on archive expansion after a basic descriptor scaffold exists.
- `qd_improve_backfill_fraction=0.05`: keep a small improve-phase backfill lane
  for QD exploration, but spend almost all success-parent budget on refinement.
- `qd_two_parent_probability=0.25`: reduce disruptive two-parent fusion while
  retaining some recombination.
- `qd_champion_lane_fraction=0.50`: keep the same champion lane as T24; this is
  not strengthened in T25, so the ablation isolates the schedule guard.

The behavior descriptor remains PPA-free. PPA objectives are used only after
evaluation for Pareto archive insertion and parent selection, matching the T17
and T24 archive-coupling methodology.

## Fixed Development Screen

The live screen is identical to T24:

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

T25 compares directly against the completed T24 rows:

- classic REvolution;
- landing Smooth-QD/manual BD;
- random descriptor QD;
- SR raw T24 unguarded Pareto QD.

The primary question is not whether T25 beats classic on one cherry-picked
problem. The first screen asks whether the guarded schedule reduces the
multi-pipe best-quality and traffic-light validity failures while keeping SR
raw's ALU gain and front material.

## Promotion Gates

T25 can only become `T1` or higher if it:

- preserves all three classic-covered designs;
- avoids a 50 percent or larger relative functionality/synthesis-validity
  decline where the classic denominator is at least 10;
- improves or stays near classic on global PPA hypervolume and best quality;
- beats random and manual BD on the metric used for any positive QD claim;
- avoids duplicate/invalid-candidate diversity claims.

Any result that only improves best score while losing front material, or only
fills cells while losing multi-pipe quality, stays `T0 diagnostic`.

## Expected Artifacts

The pre-registered live root is:

`exp/useful_bd_push/t25_guarded_sr_raw_pareto_qd_20260621_210402_UTC/`

Required artifacts:

- `/v1/models` preflight capture;
- exact live command in `commands/live_screen_v0.md`;
- per-problem summaries and archive files;
- Pareto archive validation output;
- comparison table against T24 classic/manual/random/SR raw;
- readable figures with visual inspection notes;
- `results_report.md` with a T0/T1/T2/T3 tier decision.

## Current Status

Current tier: `planned`.

No result has been run yet. This package is a pre-registered method card and
command specification for the next live experiment.
