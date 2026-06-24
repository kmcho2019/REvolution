# T79 Results Report

## Tier Decision

`T0 diagnostic_negative`.

T79 is a completed live budget-shape ablation for the T75
`shape_density_front_pressure_qd` arm. The result is diagnostic-negative:
deeper equal-candidate budgets did not make this QD method beat matched
classic on the primary PPA-front metrics.

## Execution Evidence

| Item | Status |
| --- | --- |
| Primary subset frozen | complete |
| Equal-candidate shape matrix | complete |
| vLLM preflight | complete |
| Command parser/task-count validation | complete |
| Live arms | `6/6` complete |
| Final analysis bundle | complete |
| Direct PPA figures | complete |
| Phase 03.1 viewer | schema-complete with Playwright caveats |

The preflight at `tables/preflight_models_20260624_042959_UTC.txt` reports:

```text
openai/gpt-oss-120b max_model_len=131072
```

The dry parser/task-count validator reports:

```text
T79 command matrix parses and maps to 8 tasks per arm.
```

## Completed Arm Inventory

| Arm | Status | Problems | Samples/Problem | Wall Seconds | Peak Busy Workers |
| --- | --- | ---: | ---: | ---: | ---: |
| `classic_revolution_12x3` | complete | `8/8` | `48` | `1250.64` | `18` |
| `shape_density_front_pressure_qd_12x3` | complete | `8/8` | `48` | `1217.14` | `18` |
| `classic_revolution_8x5` | complete | `8/8` | `48` | `1377.83` | `23` |
| `shape_density_front_pressure_qd_8x5` | complete | `8/8` | `48` | `1589.42` | `18` |
| `classic_revolution_6x7` | complete | `8/8` | `48` | `1481.27` | `16` |
| `shape_density_front_pressure_qd_6x7` | complete | `8/8` | `48` | `1964.23` | `18` |

The completed arm lives under
`exp/useful_bd_push/t79_budget_shape_ablation_20260624_043841_UTC/live`.
The tracked arm ledger is `tables/t79_live_arm_status.csv`.

## Final Analysis

The full ignored run bundle is under:

```text
exp/useful_bd_push/t79_budget_shape_ablation_20260624_043841_UTC/live/final_analysis
```

The tracked package copies the key outputs into:

- `reports/final_analysis/`
- `tables/final_analysis/`
- `figures/final_analysis/`

Top-level generated labels from `reports/final_analysis/report.md`:

| Recommendation | Backend |
| --- | --- |
| Overall | `classic_revolution_6x7` |
| Score-oriented QD | `shape_density_front_pressure_qd_12x3` |
| Archive-health QD | `shape_density_front_pressure_qd_8x5` |
| Multi-objective | `classic_revolution_12x3` |
| Pareto winner | `classic_revolution_12x3` |

The QD-specific rows are best-among-QD diagnostic labels only. They are not
promotion evidence, and they should not be quoted without the matched classic
comparison. `Score-oriented QD` comes from the generated bundle heuristic; the
T79 shape decision uses the matched HV/front table below, where `8x5` is the
least negative QD shape and classic still wins every headline category.

Matched shape-pair summary:

| Shape | Classic HV | QD HV | QD - Classic HV | Classic Points | QD Points | QD - Classic Ref-Beating | QD - Classic Synthesis |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `12x3` | `0.1864` | `0.1060` | `-0.0804` | `2.25` | `2.25` | `-3.25` | `+0.0521` |
| `8x5` | `0.1414` | `0.1231` | `-0.0183` | `2.62` | `1.62` | `-2.25` | `-0.0313` |
| `6x7` | `0.1701` | `0.1194` | `-0.0507` | `2.62` | `2.00` | `-3.00` | `-0.0885` |

Interpretation:

- `8x5` is the least negative QD shape by mean HV, but it still loses matched
  classic on HV, Pareto points, reference-beating candidates, synthesis yield,
  and best score.
- `6x7` helps classic more than QD: it is the overall best score/yield backend
  but the QD `6x7` arm has the largest synthesis drop versus matched classic.
- QD archive coverage did not convert into PPA-front gain. The highest QD
  archive coverage mean is `8x5` at `0.2982`, but its mean HV delta is still
  `-0.0183`.
- This does not refute QD/MAP-Elites generally; it says exact T75's
  source-aligned shape-density archive pressure is not sufficient under this
  one-seed, eight-design, fixed-48-candidate test.

## Validator Status

The completed `12x3` pair passes:

```text
uv run python scripts/validate_pareto_front_run.py ... --classic-mode classic_revolution_12x3 --pareto-qd-mode shape_density_front_pressure_qd_12x3 --require-full-subset
uv run python scripts/validate_single_thought_operator_run.py ... --classic-mode shape_density_front_pressure_qd_12x3 --eoh-mode shape_density_front_pressure_qd_12x3 --unified-mode shape_density_front_pressure_qd_12x3 --require-full-subset
```

The completed `8x5` pair passes:

```text
uv run python scripts/validate_pareto_front_run.py ... --classic-mode classic_revolution_8x5 --pareto-qd-mode shape_density_front_pressure_qd_8x5 --require-full-subset
uv run python scripts/validate_single_thought_operator_run.py ... --classic-mode shape_density_front_pressure_qd_8x5 --eoh-mode shape_density_front_pressure_qd_8x5 --unified-mode shape_density_front_pressure_qd_8x5 --require-full-subset
```

The completed `6x7` pair passes:

```text
uv run python scripts/validate_pareto_front_run.py ... --classic-mode classic_revolution_6x7 --pareto-qd-mode shape_density_front_pressure_qd_6x7 --require-full-subset
uv run python scripts/validate_single_thought_operator_run.py ... --classic-mode shape_density_front_pressure_qd_6x7 --eoh-mode shape_density_front_pressure_qd_6x7 --unified-mode shape_density_front_pressure_qd_6x7 --require-full-subset
```

## Visual Inspection

- Clean aggregate figures:
  `figures/final_analysis/summary_mean_hypervolume.png`,
  `figures/final_analysis/summary_yield_and_score.png`, and
  `figures/final_analysis/summary_archive_coverage_vs_hv_delta.png`.
- The static direct PPA/Pareto supplement is
  `visualizations/direct_ppa_pareto/index.html`.
- Raw per-problem Pareto figures are copied under
  `figures/final_analysis/pareto_fronts/`. They are useful diagnostics, but
  several have crowded legends and should not be treated as final slide
  figures without layout cleanup.
- Phase 03.1 QD/PPA viewers are under
  `visualizations/qd_ppa_viewer/{12x3,8x5,6x7}/`. All three passed strict
  schema validation. Non-strict Playwright rendered screenshots, but strict
  Playwright interaction checks reported expected validation-subset and sparse
  archive hover warnings.

## Non-Claims

T79 is one seed on eight reference-complete designs. It does not prove that
deeper budgets are globally bad for QD, or that QD/MAP-Elites is wrong. It
does show that this exact T75 implementation should not be promoted as a
positive QD result without a changed descriptor/coupling mechanism.

## Remaining Follow-Up

- Presentation-specific figure cleanup pass for crowded per-problem Pareto
  plots if those plots are promoted to slides.
- Optional viewer test harness improvement so strict Playwright can validate
  arbitrary reference-complete subsets instead of expecting the built-in
  `RTLLM/Prob004_adder_8bit` validation problem.
