# T75 Methodology

## Hypothesis

T73 improved valid-PPA yield and archive occupancy but did not create enough
raw PPA-front material. T74 changed two-parent gating and regressed. T75 tests
the narrower mechanism: stronger local-front parent pressure inside the same
source-aligned shape-density archive.

## Descriptor

`source_aligned_shape_density_3d` uses source-aligned RTL metrics extracted
before PPA scoring:

| Axis | Definition | Source |
| --- | --- | --- |
| `source_aligned_masterrtl_branching` | MasterRTL graph edges divided by graph keys. | Open-Yosys MasterRTL SOG path from T69/T70. |
| `source_aligned_rtltimer_wire_density` | RTL-Timer SOG BOG wire declarations divided by lines. | Open-Yosys RTL-Timer path from T69/T70. |
| `source_aligned_rtltimer_dff_density` | RTL-Timer SOG BOG DFF references divided by lines. | Open-Yosys RTL-Timer path from T69/T70. |

The descriptor probe confirms the axes require `source_aligned_rtl` only. They
do not require PPA, synthesis, simulation, graph metrics, final fitness,
hypervolume, Pareto rank, or reference PPA.

## Archive Coupling

T75 uses `grid_quantile` with `elite_pareto_slot` cells and two elites per
cell. Parent selection remains `front_slot_lane_nsga2`, but T75 raises the
local-front slot lane from `0.10` to `0.30`.

Effective parent pressure under the registered settings:

- 30%: local per-cell front-slot candidate when one exists;
- remaining 70%: global NSGA-II pool;
- within that remaining pool, 80% champion lane and 20% non-champion rank/crowd
  sampling.

That keeps hill-climbing pressure while giving local front candidates enough
sampling probability to affect the next generation.

## Fixed Run Surface

- Model: local `openai/gpt-oss-120b` vLLM endpoint.
- Token budgets: `max_tokens=128000`, `diff_max_tokens=128000`.
- Seed: `1001`.
- Budget: `population_size=12`, `num_generations=3`.
- Subset: T72/T73/T74 13-problem hard/tuning subset.
- Evaluation: `strict_ablation`.
- Representation: `code_individual`.
- Operator: `single_thought_operator`.
- Repair: disabled.

## Anti-Gaming Rules

- No final PPA, reference PPA, fitness, HV, Pareto rank, or pass rate is used
  as an in-loop descriptor input.
- Missing candidate PPA is method-invalid. Missing reference PPA makes the
  design diagnostic-only for headline normalized comparisons.
- A T1+ claim must preserve every classic-covered problem on the same subset.
- Duplicates and invalid candidates cannot count as useful diversity.
- Yield-only gains are diagnostic unless the raw PPA front or HV/HV-AUC
  evidence also improves.

## Promotion Read

T75 can be considered useful only if the reference-complete matched package
shows no coverage loss and a meaningful improvement over T73 or classic in at
least one primary QD/PPA-front metric: HV, HV-AUC, raw Pareto points, unique
PPA points, Pareto-cell count, front spread, or valid-PPA yield without a
hidden front collapse.
