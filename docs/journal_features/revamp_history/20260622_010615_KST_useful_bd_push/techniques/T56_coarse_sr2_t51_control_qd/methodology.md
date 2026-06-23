# T56 Coarse SR2 T51-Control QD Methodology

Status: completed; `T0 diagnostic_retire_coarse_sr2_geometry`.

## Question

T55 showed that two-axis SR-PCA geometry creates more front-slot lane hits than
T54, but the exact method still loses classic and T51 on the promotion
metrics. T56 isolates the geometry effect from the T54 front-slot parent lane.

T56 asks: if T51 keeps its normal `nsga2_global_rank` parent selection but uses
the same coarser two-axis archive as T55, does the archive geometry improve
HV, HV-AUC, valid-PPA yield, or raw front breadth without the fixed 10 percent
front-slot parent lane?

## Method Delta

T56 keeps T51 fixed:

- hard/tuning 13-problem surface;
- seed `1001`;
- local vLLM model and 128k token budgets;
- `code_individual` representation;
- `single_thought_operator`;
- grid-quantile archive with warmup `4`;
- `elite_pareto_slot` with `qd_max_elites_per_cell=2`;
- champion lane `0.80`;
- `qd_parent_selection=nsga2_global_rank`;
- no two-parent fusion;
- no repair.

T56 changes only descriptor axes:

- T51: implicit `sr_pca_0`, `sr_pca_1`, `sr_pca_2`;
- T56: explicit `--qd_descriptor_axes sr_pca_0 sr_pca_1`.

T56 deliberately removes T55's `front_slot_lane_nsga2` parent lane. If it
improves T51, coarse geometry is a useful archive substrate. If it loses T51,
T55's better slot-hit counter was not enough to justify this geometry line.

## Leakage Rules

The descriptor axes come from the frozen non-PPA SR-PCA profile. T56 must not
use final PPA, reference PPA, fitness, hypervolume, Pareto-front labels,
problem identity, corpus, model identity, or test pass rate as descriptor or
schedule inputs.

PPA enters only after candidate evaluation for archive retention, parent
ranking, and offline reporting.

## Comparator Surface

Use the T47 through T55 hard/tuning surface:

- benchmarks: RTLLM and VerilogEval-Spec-to-RTL;
- problems: the 13 entries in `tables/hard_tuning_subset.yaml`;
- seed: `1001`;
- model: local vLLM `openai/gpt-oss-120b`;
- token budgets: `128000` max tokens and diff max tokens;
- classic comparator: T47 `classic_revolution` hard/tuning root;
- QD comparators: T51 and T55 first, then T52 through T54 for family context.

Do not change the subset after seeing T56 outcomes.

## Required Measurements

Report:

- emitted `descriptor_axes`, proving exactly `sr_pca_0` and `sr_pca_1`;
- mean HV and HV-AUC deltas versus matched classic;
- valid-PPA count, front points, unique PPA points, and reference-beating
  candidates versus classic, T51, and T55;
- active archive coverage and final active archive member count;
- classic-covered valid-PPA design losses;
- 50 percent yield warnings where classic has at least 10 passing samples;
- direct raw area-power PPA-front panels for all 13 problems;
- Phase 03.1 `qd_ppa_viewer/` with honest classic projection.

## Acceptance Signals

T56 can advance only if it:

- preserves every classic-covered valid-PPA design;
- avoids a new 50 percent valid-PPA yield warning where classic has at least
  10 passing samples;
- improves T51 on at least two of mean HV, HV-AUC, valid-PPA count, front
  points, unique PPA points, or reference-beating count;
- does not lose T55's front-point recovery by more than one point.

If T56 loses T51 on HV/HV-AUC/yield and does not improve front breadth, retire
coarse SR2 geometry as a primary live path and move to exact T11 runtime
projection or learned auxiliary archive lanes.

## Measured Outcome

T56 preserved every classic-covered valid-PPA design, but it failed the
promotion signals:

- Mean HV: `0.082056` versus classic `0.092601`.
- Mean HV-AUC: `0.069095` versus classic `0.082020`.
- Valid PPA: `231` versus classic `257`.
- PPA front points: `22` versus classic `30`.
- Unique PPA points: `66` versus classic `87`.
- Reference-beating candidates: `35` versus classic `46`.
- Yield warnings: `4`.

Against T51, T56 loses HV (`-0.007196`), HV-AUC (`-0.016359`), best score
(`-0.024855`), valid PPA (`-35`), unique PPA (`-9`), and reference-beating
candidates (`-8`) while adding only one front point.

This retires coarse SR2 archive geometry as a primary follow-up path. T55's
slot-hit improvement was a mechanism signal, but T56 shows the geometry itself
does not improve the stronger T51 baseline.
