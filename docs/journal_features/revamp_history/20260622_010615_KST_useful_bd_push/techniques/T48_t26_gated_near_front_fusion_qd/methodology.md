# T48 Gated Near-Front Fusion Methodology

Status: implementation ready; no live run has been launched.

## Question

T47 showed that exact T26 is not held-out-ready on the contract hard/tuning
gate. It keeps useful best-score pressure, but loses mean HV, mean HV-AUC,
valid-PPA samples, and aggregate PPA-front points versus classic.

T48 asks whether a narrow T26.1 parent gate can recover some front/HV signal
without repeating the validity loss seen in ungated fusion variants.

## Method Delta From T47

T48 keeps T47 fixed except for low-probability, gated two-parent fusion:

- SR raw PCA descriptor profile: `sr_pca_3d`;
- `grid_quantile` archive with warmup successes `8`;
- local `pareto_front` cell mode with up to `5` elites per cell;
- `qd_fill_target_fraction=0.25`;
- `qd_improve_backfill_fraction=0.20`;
- `qd_champion_lane_fraction=0.80`;
- `qd_parent_selection=nsga2_global_rank`;
- `qd_operator_kind=eoh_strategies`;
- `representation_kind=code_individual`;
- `qd_two_parent_probability=0.10`;
- parent gate: `qd_two_parent_gate=near_front_descriptor`.

The gate is intentionally narrow. When a two-parent request occurs, the
candidate pair is accepted only if:

1. both parents are valid archive members;
2. both are rank `1` or rank `2` under the existing global NSGA-II rank;
3. their squared SR-PCA descriptor distance is at most `6.75`, the diagonal of
   one `sr_pca_3d` grid cell with three axes and width `1.5`.

If no compatible pair is available, T48 falls back to the existing one-parent
success-parent path and records the fallback. The default gate value must
remain `none` so exact T26 behavior is unchanged.

## Why This Is Not A Blind Knob Nudge

T29 and T32 already showed that simply reintroducing two-parent fusion can hurt
quality. T48 changes the parent-source rule: fusion is allowed only for
near-front, descriptor-compatible archive parents. The method therefore tests a
specific hypothesis about local recombination, not a generic probability sweep.

## Leakage Rules

The gate uses only archive state, existing non-PPA descriptor values, and
existing NSGA-II ranks over evaluated archive objectives. It does not use
reference PPA, final hypervolume, test pass rate, problem identity, or
post-hoc front labels as behavior-descriptor inputs. PPA still enters after
evaluation for archive quality, local Pareto retention, and reporting, matching
the T47 archive contract.

## Comparator Surface

Use the T47 hard/tuning surface:

- benchmarks: RTLLM and VerilogEval-Spec-to-RTL;
- problems: the 13 entries in `data/configs/hard_iteration_subset.yaml`;
- seeds: `1001` and `1002`;
- model: local vLLM `openai/gpt-oss-120b`;
- token budgets: `128000` max tokens and diff max tokens;
- classic comparator: T47 `classic_revolution` hard/tuning roots.

Do not change the subset after seeing T48 outcomes.

## Required Implementation Counters

The run summary must report:

- two-parent requests;
- gate attempts;
- gate accepts;
- gate rejects;
- one-parent fallbacks;
- descendants from accepted two-parent fusion;
- valid-PPA and front contribution from accepted-fusion descendants.

## Acceptance Signals

T48 can advance only if it:

- preserves every classic-covered valid-PPA design on the T47 hard/tuning
  surface;
- improves mean HV or mean HV-AUC versus T47 exact T26, or improves aggregate
  PPA-front points without lowering valid-PPA yield below T47;
- keeps mean best-score delta non-negative versus classic or within the
  `0.03` parity margin;
- avoids new yield warnings beyond T47's four warnings, except where the
  classic denominator is too small for a stable gate;
- includes direct raw area-power PPA-front figures and the raw candidate data
  needed to regenerate them.

If T48 only improves a ratio by reducing candidate count, mark it `T0`. If it
improves T47 on HV/HV-AUC or front points while preserving coverage and yield,
promote it to a deeper held-out dry run.
