# T79 Results Report

## Tier Decision

`one_arm_complete`.

T79 is still primarily a protocol package. It freezes the subset,
budget-shape matrix, methods, endpoint preflight, and reporting gates. The
classic `12x3` arm has now completed, but no comparison result is claimed
until the matched QD and deeper-shape arms finish or a blocked continuation is
recorded.

## Pre-Run Evidence

| Item | Status |
| --- | --- |
| Primary subset frozen | complete |
| Equal-candidate shape matrix | complete |
| vLLM preflight | complete |
| Command parser/task-count validation | complete |
| Live arms | `2/6` complete, `1/6` running |
| Final analysis bundle | pending |
| Direct PPA figures | pending |
| Phase 03.1 viewer | pending for completed QD arms |

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
| `classic_revolution_8x5` | running | pending | `48` | pending | pending |

The completed arm lives under
`exp/useful_bd_push/t79_budget_shape_ablation_20260624_043841_UTC/live`.
The tracked arm ledger is `tables/t79_live_arm_status.csv`.

## Validator Status

The completed `12x3` pair passes:

```text
uv run python scripts/validate_pareto_front_run.py ... --classic-mode classic_revolution_12x3 --pareto-qd-mode shape_density_front_pressure_qd_12x3 --require-full-subset
uv run python scripts/validate_single_thought_operator_run.py ... --classic-mode shape_density_front_pressure_qd_12x3 --eoh-mode shape_density_front_pressure_qd_12x3 --unified-mode shape_density_front_pressure_qd_12x3 --require-full-subset
```

## Non-Claims

No budget-shape result is claimed yet. T79 does not prove that deeper budgets
help QD, and the completed classic arm alone does not compare QD against
classic. It only makes the live test auditable.

## Required Completion Package

After live execution, this package must add:

- one row per method/shape/problem with validity and PPA metrics;
- aggregate paired HV/HV-AUC/front metrics;
- validity gate table;
- direct raw area-power Pareto figures;
- Phase 03.1 viewer bundles for completed QD arms with archive artifacts;
- visual inspection notes;
- final tier decision.
