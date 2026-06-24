# T75 Results Report

Status: pending live run.

## Current State

T75 is pre-registered but not executed. No result claim is allowed yet.

## Required Headline Table

When the run completes, report at least:

| Method | Mean HV | HV wins | Mean Pareto points | Valid-PPA samples | Covered problems | Tier |
| --- | ---: | ---: | ---: | ---: | ---: | --- |
| Classic | pending | pending | pending | pending | pending | pending |
| T73 | pending | pending | pending | pending | pending | context |
| T74 | pending | pending | pending | pending | pending | context |
| T75 | pending | pending | pending | pending | pending | pending |

## Required Decision

Assign exactly one tier after packaging:

- `T0 diagnostic_regression_not_promoted`;
- `T0 positive_diagnostic_not_promoted`;
- `T1 near_classic_not_promoted`;
- `T2 candidate_for_holdout`;
- `T3 promoted_useful_qd`.

Do not assign T1+ unless every classic-covered problem remains covered and the
reference-complete matched comparison supports the claim without missing
reference-PPA leakage.
