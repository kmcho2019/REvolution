# T24 SR Pareto Live Validation Methodology

## Purpose

T24 is the first live validation package after the T23 passive matrix. It tests
whether synthesis-response descriptors become more useful when paired with
bounded local Pareto retention and quality-aware parent sampling, rather than
one scalar elite per descriptor cell.

The method is not a new descriptor. It is an archive-coupling validation for
the strongest current synthesis-response leads:

- `T04` SR-RFF PCA: near-classic final quality with strong common-audit QD and
  local-front material;
- `T19` SR ReLU PCA: strongest final-HV and HV-AUC source, but with quality and
  coverage regressions;
- `T20` SR raw PCA: no-kernel ablation for the SR descriptor family.

## Algorithm

For each QD arm:

1. Extract the frozen non-PPA descriptor from the candidate synthesized netlist.
2. Assign the descriptor to a `grid_quantile` archive cell after an eight
   successful-candidate warm-up.
3. Keep up to five evaluated candidates per cell.
4. Rank candidates inside a cell by active PPA objectives, not scalar fitness:
   `g_P` and `g_A` for combinational designs, and `g_P`, `g_A`, `g_T` for
   sequential designs.
5. Insert candidates with `qd_cell_mode=pareto_front`; capacity overflow evicts
   the worst NSGA-II rank/crowding member.
6. Sample QD parents using `qd_parent_selection=nsga2_global_rank` with
   `qd_champion_lane_fraction=0.5`.
7. Generate new candidates with the same operators, prompts, model, seed,
   population, generations, evaluation mode, and timeouts as the control arms.

The champion lane is allowed because it samples evaluated parents after archive
insertion. It does not use PPA, hypervolume, Pareto rank, test pass rate, or
fitness as a behavior descriptor input.

## Fixed Development Screen

The first bounded live screen uses seed `1001`, population `12`, and three
generations. It uses three RTLLM problems from the frozen screening subset:

- `RTLLM/Prob045_alu`;
- `RTLLM/Prob041_traffic_light`;
- `RTLLM/Prob015_multi_pipe_8bit`.

These were selected before T24 execution because they cover arithmetic and
control strata and are already in `tables/frozen_screening_subset.csv`. A T1+
claim is not allowed from this three-problem screen alone.

## Comparator Arms

T24 must compare these arms under the same budget:

- `classic_revolution`;
- `landing_smooth_qd_manual_bd`;
- `random_descriptor_qd` from T22;
- `sr_raw_pca_qd` from T20;
- `sr_random_relu_pca_qd` from T19;
- `sr_rff_pca_qd` from T04.

Positive claims must beat the relevant comparator on the metric being claimed.
In particular, front-material or HV-AUC claims must compare against T22 random
descriptor, not only classic and manual BD.

## Promotion Gates

T24 can only become a T1 or higher result after the method:

- preserves every classic-covered design under the same live budget;
- avoids a 50 percent or larger relative functionality/synthesis-valid decline
  where the classic denominator is at least 10;
- improves or stays near classic on global PPA hypervolume, passive archive QD
  score, Pareto spread, unique front families, valid-PPA yield, or AUC metrics;
- beats `random_descriptor_qd` on the metric used for any positive claim;
- expands from the three-problem development screen to the full frozen subset
  before journal-facing promotion.

## Expected Artifacts

The live run should write under:

`exp/useful_bd_push/t24_sr_pareto_live_validation_20260621_184346_UTC/`

Required downstream artifacts:

- per-arm run roots and stdout/stderr logs;
- `/v1/models` preflight capture;
- exact command record;
- per-problem generation summaries;
- archive summaries with `cell_mode=pareto_front`;
- global Pareto archive CSVs;
- validation output from `scripts/validate_pareto_front_run.py`;
- central comparison tables and figures mirroring T23.

## Tier Status

Current tier: `T0 diagnostic`.

T24 completed the full six-arm live development-screen matrix. It validates the
archive mechanics and preserves all classic-covered designs, but it is not a
positive result because every QD arm loses too much best quality on
`Prob015_multi_pipe_8bit`.
