# T58 T51 T11-PCA4 Front-Slot QD Methodology

Status: completed; `T0 diagnostic_no_promotion`.

## Question

T57 showed that changing only T51's grid-quantile cut points is not enough.
T44 through T46 showed that T11 graph descriptors have real local signal but
were weak as the primary archive substrate in the older sparse-warmup live
lineage.

T58 asks whether the stronger T51 code-individual, single-thought emitter can
use the frozen T11 PCA4 graph projection as the archive geometry while keeping
T51's yield-preserving front-slot mechanics.

This is a cross-lane mechanism test, not another graph-axis dimensionality
sweep.

## Method Delta From T51

T58 keeps T51 fixed:

- hard/tuning 13-problem surface;
- seed `1001`;
- local vLLM model and 128k token budgets;
- `code_individual` representation;
- `single_thought_operator`;
- `grid_quantile` archive with warmup `4`;
- `elite_pareto_slot` with `qd_max_elites_per_cell=2`;
- champion lane `0.80`;
- `qd_parent_selection=nsga2_global_rank`;
- no two-parent fusion;
- no repair.

T58 changes only the descriptor profile:

- T51: `sr_pca_3d` from the frozen synthesis-response profile file.
- T58: `t11_runtime_pca4_graph` from `data/configs/qd_descriptor_profiles.yaml`.

The T58 axes are:

- `t11_runtime_pca_0`;
- `t11_runtime_pca_1`;
- `t11_runtime_pca_2`;
- `t11_runtime_pca_3`.

Those axes are computed online from non-PPA Yosys graph metrics using the
frozen PCA coefficients already registered by T46.

## Leakage Rules

T58 does not use final PPA, reference PPA, hypervolume, Pareto rank, classic
results, test pass rate, or final front labels as descriptor inputs.

PPA enters only after candidate evaluation for archive quality, local
front-slot retention, NSGA-II parent selection, and offline reporting. The
descriptor itself uses graph metrics available from the candidate netlist.

## Comparator Surface

Use the T47 through T57 hard/tuning surface:

- benchmarks: RTLLM and VerilogEval-Spec-to-RTL;
- problems: the 13 entries in `tables/hard_tuning_subset.yaml`;
- seed: `1001`;
- model: local vLLM `openai/gpt-oss-120b`;
- token budgets: `128000` max tokens and diff max tokens;
- classic comparator: T47 `classic_revolution` hard/tuning root;
- primary off-mode comparator: T51 `code_thought_front_slot_qd`;
- learned-descriptor context: T46 `t11_runtime_pca4_graph_qd`;
- latest archive-mechanics context: T57 `t51_adaptive_rebin_qd`.

Do not change the subset after seeing T58 outcomes.

## Required Measurements

Report:

- descriptor probe output and emitted archive axes;
- mean HV and HV-AUC deltas versus matched classic;
- deltas versus T51 for valid-PPA count, HV, HV-AUC, aggregate front points,
  unique PPA points, reference-beating candidates, and active archive members;
- deltas versus T46 to determine whether the T51 emitter rescues the learned
  projection substrate;
- classic-covered valid-PPA design losses;
- 50 percent yield warnings where classic has at least 10 passing samples;
- direct raw area-power PPA-front panels for all 13 problems;
- full Phase 03.1 `qd_ppa_viewer/` with honest classic projection into the
  T58 archive space.

## Acceptance Signals

T58 can advance only if it:

- preserves every classic-covered valid-PPA design;
- improves T51 on at least two of mean HV, HV-AUC, front points, unique PPA
  points, reference-beating candidates, or active archive members;
- keeps T51 valid-PPA count within 10 percent;
- improves over T46 on aggregate HV or valid-PPA yield, proving the T51
  emitter changes the graph-projection outcome;
- includes direct raw PPA figures and the Phase 03.1 viewer.

If T58 loses T51 on HV/HV-AUC and front/yield evidence, retire this exact
learned-projection primary archive path. The follow-up should use graph
features as a secondary reporting/archive lane or move to a front-yield
protected emitter instead of another direct graph-coordinate variant.

## Measured Outcome

T58 completed seed `1001` on all 13 hard/tuning problems. It preserves every
classic-covered valid-PPA design and increases aggregate valid-PPA samples
from `257` to `266`, but it loses classic on mean HV (`0.076253` versus
`0.092601`), mean HV-AUC (`0.066233` versus `0.082020`), front points (`22`
versus `30`), unique PPA points (`71` versus `87`), and reference-beating
candidates (`34` versus `46`).

Against T51, T58 is also weaker on HV, HV-AUC, best score, unique PPA points,
and reference-beating candidates; valid-PPA count ties and front points improve
by only one. The T11 PCA4 archive geometry therefore does not rescue the T51
front-breadth blocker.

The pre-registered acceptance list included active archive members, but that
metric is not comparable between T51's three-axis `sr_pca_3d` archive and
T58's four-axis `t11_runtime_pca4_graph` archive. The one extra front point is
also too small to override the geometry-independent losses on HV, HV-AUC,
unique PPA points, and reference-beating candidates.

The bounded T46 comparison is three-problem-only. On the shared RTLLM problems,
T58 improves yield and mean best score versus T46 PCA4, but does not improve
front breadth. Treat this as evidence that the T51 emitter helps graph-axis
yield, not as evidence that graph PCA4 is a useful primary archive geometry.
