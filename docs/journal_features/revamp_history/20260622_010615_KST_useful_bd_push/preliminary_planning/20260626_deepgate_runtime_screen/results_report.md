# T94 DeepGate Runtime Screen Results

## Method

`deepgate_pooled_pc3_8x5` uses the official DeepGate-derived pooled descriptor
axes frozen in T92 and first live-smoked in T93:

```text
deepgate_pool_pc0
deepgate_pool_pc1
deepgate_pool_pc2
```

The QD arm ran the frozen eight-design preliminary subset with the same
`8x5`, seed `1001`, model, token budget, and reference-complete comparison
surface used by the current preliminary screen.

## Completeness

The corrected completeness table shows all eight problems are headline
comparisons:

```text
classic_valid_ppa=yes
qd_valid_ppa=yes
reference_ppa_valid=yes
comparison_status=headline
```

This result is therefore not affected by the previous missing-reference-PPA
bug.

## Aggregate Result

| Method | Mean HV | Mean Pareto points | Mean ref-beating | HV wins |
| --- | ---: | ---: | ---: | ---: |
| `classic_revolution_8x5` | `0.1406` | `3.25` | `8.00` | `6` |
| `deepgate_pooled_pc3_8x5` | `0.1040` | `1.75` | `4.50` | `2` |

RTLLM-only is worse for DeepGate:

| Method | Mean HV | Mean Pareto points | Mean ref-beating | HV wins |
| --- | ---: | ---: | ---: | ---: |
| `classic_revolution_8x5` | `0.1453` | `3.60` | `10.60` | `4` |
| `deepgate_pooled_pc3_8x5` | `0.0866` | `1.60` | `6.00` | `1` |

VerilogEval is close on mean HV but not on front breadth:

| Method | Mean HV | Mean Pareto points | Mean ref-beating | HV wins |
| --- | ---: | ---: | ---: | ---: |
| `classic_revolution_8x5` | `0.1329` | `2.67` | `3.67` | `2` |
| `deepgate_pooled_pc3_8x5` | `0.1330` | `2.00` | `2.00` | `1` |

## Per-Problem Read

DeepGate only wins or ties HV on narrow cases:

- `Prob024_fsm`: slight DeepGate HV win, `0.1454` versus `0.1447`.
- `Prob116_m2014_q3`: HV tie, `0.3984` versus `0.3984`, with fewer
  DeepGate ref-beating candidates.
- `Prob153_gshare`: small DeepGate HV win, `0.0007` versus `0.0004`, but fewer
  Pareto points and ref-beating candidates.

Classic clearly wins the larger RTLLM front-material cases:

- `Prob041_traffic_light`: classic HV `0.3101` versus DeepGate `0.0997`.
- `Prob045_alu`: classic HV `0.2524` versus DeepGate `0.1813`.
- `Prob049_signal_generator`: classic HV `0.0192` versus DeepGate `0.0068`.
- `Prob015_multi_pipe_8bit`: both HVs are zero, but classic has more Pareto
  points, `8` versus `2`.

## Interpretation

This is a screened negative result for the current DeepGate runtime profile.
The model path is real enough to run live and emit archive descriptors, but
the present coupling does not create enough PPA-front material to challenge
classic REvolution.

Keep DeepGate in the colleague-facing presentation as the strongest actual
pretrained synthesized-netlist encoder lane attempted so far. Present it
honestly as evidence that pretrained netlist embeddings can be made
operational, not as evidence that the current QD use of those embeddings wins.

## Visualizations

The full Phase 03.1-compatible viewer exists at:

```text
visualizations/qd_ppa_viewer/index.html
```

Strict schema/control/data validation passes and the inspected compare-mode
render is at:

```text
visualizations/qd_ppa_viewer/screenshot.png
```

Classic candidates were not projected into DeepGate archive cells in this
viewer export. The export used `--no-classic-descriptor-recovery` to avoid
silently recomputing official DeepGate descriptors for classic candidates
outside the registered T94 run. The PPA/Pareto comparison remains
reference-complete and paired; the archive side should be read as DeepGate's
native archive only.

The direct PPA supplement exists at:

```text
visualizations/direct_ppa_pareto/index.html
```

## Next Step

Do not spend full RTLLM budget on exact `deepgate_pooled_pc3_8x5`. A valid
next DeepGate attempt must change the coupling, for example by using DeepGate
as an auxiliary memory coordinate, a front-slot diagnostic coordinate, or a
posthoc family-retention analysis rather than the same archive pressure.
