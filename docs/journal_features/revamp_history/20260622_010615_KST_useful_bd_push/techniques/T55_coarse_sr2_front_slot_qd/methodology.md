# T55 Coarse SR2 Front-Slot QD Methodology

Status: pre-registered; not launched.

## Question

T54 showed that a fixed non-elite front-slot parent lane is active but too
sparse to recover PPA-front breadth. It recorded only `4` front-slot hits from
`12` requests. T55 asks whether that failure is caused by over-partitioned
SR-PCA archive geometry: if the grid uses fewer descriptor axes, candidates
should collide in cells more often, giving `elite_pareto_slot` more local
alternatives to retain.

## Method Delta From T54

T55 keeps fixed:

- hard/tuning 13-problem surface;
- seed `1001`;
- local vLLM model and 128k token budgets;
- `code_individual` representation;
- `single_thought_operator`;
- SR-PCA descriptor profile and descriptor file;
- grid-quantile archive with warmup `4`;
- `elite_pareto_slot` with `qd_max_elites_per_cell=2`;
- champion lane `0.80`;
- `qd_parent_selection=front_slot_lane_nsga2`;
- no repair;
- no two-parent fusion.

T55 changes only the archive axes:

- T54: implicit `sr_pca_0`, `sr_pca_1`, `sr_pca_2`;
- T55: explicit `--qd_descriptor_axes sr_pca_0 sr_pca_1`.

The descriptor values are still SR-PCA features. The archive geometry is
coarser, so each descriptor cell should see more evaluated candidates and
should have more chances to retain one non-elite local-front slot.

## Leakage Rules

The two-axis archive uses only descriptor coordinates computed before PPA is
known. Evaluated PPA may affect post-evaluation archive retention and
NSGA-II parent ranking, as in T47 through T54. T55 must not use classic
results, held-out outcomes, problem identity, final PPA-front labels,
reference PPA, final hypervolume, fitness, or test pass rate as descriptor or
schedule inputs.

## Comparator Surface

Use the T47 through T54 hard/tuning surface:

- benchmarks: RTLLM and VerilogEval-Spec-to-RTL;
- problems: the 13 entries in `tables/hard_tuning_subset.yaml`;
- seed: start with `1001`;
- model: local vLLM `openai/gpt-oss-120b`;
- token budgets: `128000` max tokens and diff max tokens;
- classic comparator: T47 `classic_revolution` hard/tuning root;
- QD comparators: T51, T52, T53, and T54.

Do not change the subset after seeing T55 outcomes.

## Required Measurements

Report:

- occupied archive cells and active archive members versus T54;
- emitted `descriptor_axes`, proving the run used exactly `sr_pca_0` and
  `sr_pca_1`;
- front-slot lane request count and hit count versus T54;
- mean HV and HV-AUC deltas versus matched classic;
- valid-PPA count, aggregate front points, unique PPA points, and
  reference-beating candidates versus classic and T51 through T54;
- classic-covered valid-PPA design losses;
- 50 percent yield warnings where classic has at least 10 passing samples;
- direct raw area-power PPA-front panels for all 13 problems;
- Phase 03.1 `qd_ppa_viewer/` if archive artifacts support export.

## Acceptance Signals

T55 can advance only if it:

- preserves every classic-covered valid-PPA design;
- records more front-slot hits than T54;
- improves aggregate PPA-front points or unique PPA points versus T54;
- keeps valid-PPA count within 10 percent of T51;
- avoids a new 50 percent valid-PPA yield warning where classic has at least
  10 passing samples.

If T55 increases slot hits but still loses front breadth, retire coarse SR2
geometry as a slot-creation fix. If it improves front breadth while preserving
T51-class yield, run seed `1002` or a held-out screen before any useful-QD
claim.
