# RF Leaf-ID Structural Delayed Probe Results

Status: completed diagnostic; not promoted for full RTLLM spend.

## Definitions

- Hypervolume, or HV: normalized Pareto-front volume dominated by valid PPA
  candidates. Higher is better.
- Pareto point: a valid PPA candidate that is not dominated by another valid
  candidate on the reported objectives.
- Reference-beating candidate: a valid candidate that beats the benchmark
  reference PPA on at least one normalized objective used by the Pareto report.
- Headline-paired comparison: both classic and QD have valid candidate PPA and
  the benchmark reference PPA is valid for the design.

## Run

- Run root:
  `exp/useful_bd_push/prelim_rf_leafid_structural_delayed_20260626_052350_UTC/live/`
- QD backend:
  `masterrtl_rf_leafid_structural_delayed_8x5/seed_1001`
- Baseline:
  `classic_revolution_8x5/seed_1001` from
  `prelim_encoder_config_screen_20260625_134902_UTC`
- Subset:
  `../20260625_encoder_config_screening/tables/prelim_screen_subset.yaml`
- Budget:
  `population_size=8`, `num_generations=5`
- Model:
  `openai/gpt-oss-120b`
- Token budget:
  `max_tokens=128000`, `diff_max_tokens=128000`

## Method Read

T83 keeps the validated MasterRTL RF timing model-state path, but changes how
the signal is used. T82 used the exact RF timing-state profile and found that
`path_count` often collapsed. T83 instead uses:

```text
source_aligned_rf_timing_leaf_ids
source_aligned_masterrtl_branching
source_aligned_rtltimer_wire_density
```

This is a pretrained MasterRTL model-state experiment because the RF timing
leaf-ID metric comes from the saved MasterRTL RF timing model path validated in
T81 and exposed through the T82 runtime hook. It is not a scalar MasterRTL PPA
prediction experiment, and it should not be described as proof that the
MasterRTL predictor is accurate on our generated RTL.

## Headline Metrics

| Metric | Classic | T83 QD | Delta |
| --- | ---: | ---: | ---: |
| Mean HV | `0.1406447841` | `0.1369410338` | `-0.0037037503` |
| Mean Pareto points | `3.25` | `2.00` | `-1.25` |
| Mean reference-beating candidates | `8.00` | `4.50` | `-3.50` |
| HV wins | `5/8` | `3/8` | `-2` |

The all-design mean HV gap is only `-2.63%`, which is much closer to classic
than T82. That near-classic signal is not robust enough for promotion.

## Robustness Check

Removing `Prob135_m2014_q6b`, the problem that supplies the largest T83 win,
changes the mean HV comparison to:

| Subset | Problems | Classic mean HV | T83 mean HV | Relative delta |
| --- | ---: | ---: | ---: | ---: |
| Without `Prob135_m2014_q6b` | `7` | `0.1607368961` | `0.1281299195` | `-20.29%` |

This means the apparent near-tie depends heavily on one VerilogEval problem.
On the RTLLM-only slice, T83 is also clearly weaker than classic:
`0.0995` mean HV versus classic `0.1453`.

## Descriptor Health

The descriptor path is valid but not uniformly healthy. RF leaf-ID breadth
remains noncollapsed on `5/8` screened problems, while the RF leaf axis
collapses in archive entries for:

- `Prob045_alu`
- `Prob116_m2014_q3`
- `Prob135_m2014_q6b`

The full table is in `tables/descriptor_health_summary.csv`. T83 improves the
coupling question over T82 by removing the known collapsed `path_count` axis,
but it does not fully solve RF model-state collapse.

## Visual Inspection

- `figures/rf_leafid_structural_delayed_summary.png` was inspected and is the
  reader-facing summary figure.
- The generated per-problem PPA figures under
  `analysis/pareto_analysis/problems/` are diagnostic. Their point clouds are
  readable, but several titles are clipped by the long backend names.

## Decision

Do not promote exact T83 to the full RTLLM comparison.

T83 is useful evidence because it shows that a validated pretrained MasterRTL
model-state coordinate can run in the live QD archive and can get close to
classic on one seed. The result is not strong enough to spend full RTLLM
budget because:

- mean HV is still below classic;
- Pareto breadth and reference-beating counts are substantially lower;
- the strongest aggregate support depends on `Prob135_m2014_q6b`;
- RTLLM-only mean HV is clearly negative;
- RF leaf-ID collapse still appears on `3/8` screened problems.

The next candidate should not simply retune T83. It should either combine RF
model-state as a secondary diagnostic in a more front-preserving mechanism, or
move to a different encoder/BD lane with a validated noncollapse and
classic-like exploitation contract.
