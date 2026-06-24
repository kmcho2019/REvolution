# T79 Results Report

## Tier Decision

`pre_registered_not_run`.

T79 is a protocol package, not a result package. It freezes the subset,
budget-shape matrix, methods, endpoint preflight, and reporting gates before
any T79 live outcome.

## Pre-Run Evidence

| Item | Status |
| --- | --- |
| Primary subset frozen | complete |
| Equal-candidate shape matrix | complete |
| vLLM preflight | complete |
| Command parser/task-count validation | complete |
| Live arms | not run |
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

## Non-Claims

No budget-shape result is claimed yet. T79 does not prove that deeper budgets
help QD. It only makes the live test auditable.

## Required Completion Package

After live execution, this package must add:

- one row per method/shape/problem with validity and PPA metrics;
- aggregate paired HV/HV-AUC/front metrics;
- validity gate table;
- direct raw area-power Pareto figures;
- Phase 03.1 viewer bundles for completed QD arms with archive artifacts;
- visual inspection notes;
- final tier decision.
