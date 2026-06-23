# T67 RTL-Native Seeded Thought QD Methodology

Status: pre-registered; result pending.

## Question

T63 showed that RTL-native state/pipeline cells can improve some
front-material diagnostics versus T51. T66 showed that using the same cells for
front-slot parent pressure and low-rate gated fusion improves yield and best
score, but still loses classic on HV, HV-AUC, and front points. The gated
fusion path also did not trigger, so T66 did not actually test useful
descriptor-compatible recombination.

T67 asks whether the RTL-native descriptor is more useful when it guides a
source-preserving thought/code generator. The intended mechanism is to keep
classic-like hill-climbing on successful parent RTL while maintaining a
PPA-free RTL implementation-family archive.

## Method Delta From T63/T66

T67 keeps the T63/T66 hard/tuning surface fixed:

- hard/tuning 13-problem subset;
- seed `1001`;
- local vLLM model `openai/gpt-oss-120b`;
- `128000` max-token and diff-token budgets;
- `grid_quantile` archive with warmup `4`;
- `elite_pareto_slot` with `qd_max_elites_per_cell=2`;
- champion lane `0.80`;
- descriptor profile `fused_rtl_state_pipeline_2d`;
- no two-parent fusion;
- no bounded local repair.

T67 changes the generation representation:

- T63/T66 use direct `code_individual` candidates;
- T67 uses `thought_only` with `code_samples_per_thought=3`;
- T67 enables `qd_thought_code_seeded`;
- T67 sets `qd_seed_sample_fraction=0.67`, which gives two seeded
  parent-code refinements plus one whole-regeneration leap when parent code is
  available;
- T67 keeps `qd_parent_selection=nsga2_global_rank` so this run isolates the
  source-preserving realization change rather than repeating T66's front-slot
  parent lane.

## Descriptor Definition

T67 uses `fused_rtl_state_pipeline_2d`:

| Axis | Source | Intent |
| --- | --- | --- |
| `state_control_ratio` | RTL-native graph/source metrics | state/control structure |
| `control_pipeline_ratio` | RTL-native graph/source metrics | control and pipeline/register balance |

The descriptor must not use final PPA, reference PPA, fitness, hypervolume,
Pareto rank, classic results, problem identity, or test pass rate as in-loop
BD inputs.

## Why This Is Not Another Parent-Knob Sweep

T51 showed that direct code individuals recover yield better than earlier
thought-only variants, but T50 showed that thought-only itself lost front and
yield evidence when code samples were regenerated from scratch. T67 tests the
missing middle: use thought-level architectural diversity, but realize most
samples by refining the best successful parent RTL.

The first run deliberately avoids bounded repair. If T67 loses because too many
seeded samples stay invalid, a later ablation may add a capped repair selector.
That later variant must be registered separately and report extra repair
budget explicitly.

## Comparator Surface

Use the same 13-problem hard/tuning surface as T47 through T66:

- benchmarks: RTLLM and VerilogEval-Spec-to-RTL;
- problems: `tables/hard_tuning_subset.yaml`;
- seed: `1001`;
- classic comparator: T47 `classic_revolution`;
- thought-only control: T50;
- code-level archive control: T51;
- RTL-native controls: T63 and T66.

Do not change the subset after seeing T67 outcomes.

## Required Measurements

Report:

- descriptor probe output and emitted archive axes;
- generated thought count and generated code-sample count;
- seeded versus whole-regeneration sample counts if the logs expose them;
- mean HV and HV-AUC deltas versus matched classic;
- deltas versus T50, T51, T63, and T66 for valid-PPA count, front points,
  unique PPA points, reference-beating candidates, and active archive members;
- classic-covered valid-PPA design losses;
- 50 percent yield warnings where classic has at least 10 passing samples;
- `ppa_completeness.csv` with reference-complete headline eligibility;
- direct raw area-power PPA-front panels for all 13 problems;
- full Phase 03.1 `qd_ppa_viewer/` if archive artifacts are available.

## Acceptance Signals

T67 can advance only if it:

- preserves every classic-covered valid-PPA design;
- has no missing/defaulted-reference headline claim;
- improves T50 on valid-PPA count and at least one front metric, showing that
  seeded realization fixed the thought-only regeneration failure mode;
- matches or improves T63/T66 on aggregate front points, unique PPA points, or
  reference-beating candidates;
- keeps T51 valid-PPA count within 10 percent;
- includes direct raw PPA figures and a Phase 03.1 viewer or a documented
  archive-artifact omission.

If T67 only improves best score while losing front/HV/yield evidence, mark it
`T0`. If it preserves T51-like yield while improving T63/T66 front material, it
becomes the next candidate for a bounded repair-selector ablation or seed
`1002`.
