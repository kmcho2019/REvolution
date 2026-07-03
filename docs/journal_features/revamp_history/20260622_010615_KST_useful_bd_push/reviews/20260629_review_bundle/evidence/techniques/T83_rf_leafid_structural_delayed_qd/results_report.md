# T83 Results Report

Status: completed diagnostic; not promoted.

The frozen eight-design screen is packaged under
`../../preliminary_planning/20260626_rf_leafid_structural_delayed_probe/`.

## Result

T83 runs RF timing leaf-ID model-state breadth as one archive coordinate,
beside MasterRTL branching and RTLTimer wire density, with archive pressure
delayed until generation `3`.

| Metric | Classic | T83 QD |
| --- | ---: | ---: |
| Mean HV | `0.1406` | `0.1369` |
| Mean Pareto points | `3.25` | `2.00` |
| Mean reference-beating candidates | `8.00` | `4.50` |
| HV wins | `5/8` | `3/8` |

The `-2.63%` mean-HV gap is the nearest recent pretrained-model-state result,
but it is not robust. Removing `Prob135_m2014_q6b` makes the HV gap
`-20.29%`, and the RTLLM-only mean HV is `0.0995` versus classic `0.1453`.

## Descriptor Validity

This result uses the validated T81/T82 MasterRTL RF timing path. It does not
use direct scalar MasterRTL PPA predictions as archive coordinates. The RF
leaf-ID axis remains noncollapsed on `5/8` screened problems, but collapses in
archive entries on `3/8` problems.

## Decision

Do not promote exact T83 to the full RTLLM comparison. Keep it as evidence
that RF model-state descriptors can run live and sometimes approach classic,
but require a stronger front-preserving coupling before spending larger RTLLM
budget.
