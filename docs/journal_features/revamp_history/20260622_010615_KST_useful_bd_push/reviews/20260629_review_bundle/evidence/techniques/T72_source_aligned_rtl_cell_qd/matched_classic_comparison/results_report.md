# T72 Matched Comparison Results

## Conclusion

T72 is a useful executable RTL-native descriptor result, but it is not a
promoted QD win.

The source-aligned MasterRTL/RTL-Timer cell map runs end to end and preserves
all classic-covered designs on the `13`-problem hard/tuning subset. The matched
reference-complete comparison still selects classic as the multi-objective
winner because T72 trails on mean hypervolume, HV wins, Pareto point count, and
reference-beating candidates.

Tier decision: `T1 near_classic_not_promoted`.

## Terminology

- Valid PPA candidate: a generated candidate with usable post-synthesis PPA
  metrics.
- Reference-complete problem: a problem with a valid benchmark reference
  `ppa.txt`. Problems without reference PPA are diagnostic-only for normalized
  improvement, HV, and HV-AUC.
- Hypervolume (HV): dominated volume in normalized improvement space versus
  the zero-improvement reference point. Higher is better.
- Pareto point: a non-dominated candidate under the active PPA objectives.
- Reference-beating candidate: a candidate that improves over the reference
  on the active PPA comparison used by the final-analysis bundle.

## Completeness Gate

All `13/13` problems are headline-eligible in this matched package:

- `13/13` have valid classic PPA candidates.
- `13/13` have valid T72 PPA candidates.
- `13/13` have valid reference PPA.
- `0/13` are `diagnostic_only`.

This avoids the missing-reference issue that invalidated earlier all-RTLLM
headline reads.

## Primary Metrics

| Metric | Classic | T72 |
| --- | ---: | ---: |
| Mean HV | 0.0926007600 | 0.0920035731 |
| HV wins | 9 | 4 |
| Mean Pareto points | 2.31 | 1.31 |
| Mean reference-beating candidates | 3.54 | 2.85 |
| Valid PPA samples | 257 | 233 |

The mean HV loss is small, about `0.65%`, so T72 is close on aggregate HV. The
front-breadth measures are less close: classic has more HV wins, more Pareto
points, and more reference-beating candidates.

## Problem-Level Read

T72 has useful local signals:

- positive HV deltas on `Prob024_fsm`, `Prob045_alu`,
  `Prob116_m2014_q3`, and `Prob153_gshare`;
- higher valid-PPA counts on `Prob004_adder_8bit`, `Prob024_fsm`,
  `Prob037_parallel2serial`, `Prob045_alu`, and
  `Prob049_signal_generator`;
- no design-level coverage loss versus classic.

The blockers are also clear:

- large negative HV movement on `Prob041_traffic_light`;
- front collapse on `Prob015_multi_pipe_8bit`;
- lower valid-PPA totals on VerilogEval-heavy rows, especially
  `Prob098_circuit7`, `Prob116_m2014_q3`, `Prob135_m2014_q6b`, and
  `Prob150_review2015_fsmonehot`.

## Interpretation

T72 answers the executability question for the source-aligned RTL-native lane:
MasterRTL/RTL-Timer descriptors can be computed inside live QD runs without
PPA leakage and without losing design coverage.

It does not yet answer the performance question positively. The current cell
map is too collapsed to create enough front material. Most problems use one or
two occupied cells, so the method behaves more like a constrained archive
variant than a broad illumination method.

## Next Step

Do not promote exact T72. A successor should keep the source-aligned
descriptor contract, but widen the archive signal before another live spend.
The strongest follow-up is a less-collapsed RTL-native cell map or a secondary
cell lane that keeps T72's coverage while improving front material.
