# T73 Matched Comparison Results

## Conclusion

T73 is a useful positive diagnostic for the RTL-native lane, but it is not a
promoted QD/MAP-Elites win.

The source-aligned shape-density archive runs end to end, preserves all
classic-covered problems on the `13`-problem hard/tuning subset, and produces
more valid PPA candidates than classic. The matched reference-complete
comparison still selects classic as the multi-objective winner because T73
trails on mean hypervolume, HV wins, and Pareto point count.

Tier decision: `T0 positive_diagnostic_not_promoted`.

## Terminology

- Valid PPA candidate: a generated candidate with usable post-synthesis PPA
  metrics.
- Reference-complete problem: a problem with a valid benchmark reference
  `ppa.txt`. Problems without reference PPA are diagnostic-only for normalized
  improvement, HV, HV-AUC, and direct classic-vs-QD claims.
- Hypervolume (HV): dominated volume in normalized PPA-improvement space
  versus the zero-improvement reference point. Higher is better.
- Pareto point: a non-dominated candidate under the active PPA objectives.
- Reference-beating candidate: a candidate that improves over the benchmark
  reference on the active PPA comparison used by the final-analysis bundle.

## Completeness Gate

All `13/13` problems are headline-eligible in this matched package:

- `13/13` have valid classic PPA candidates.
- `13/13` have valid T73 PPA candidates.
- `13/13` have valid reference PPA.
- `0/13` are `diagnostic_only`.

This keeps the earlier missing-reference RTLLM issue out of the headline
comparison.

## Primary Metrics

| Metric | Classic | T73 |
| --- | ---: | ---: |
| Mean HV | 0.0926007600 | 0.0890223082 |
| HV wins | 8 | 5 |
| Mean Pareto points | 2.31 | 1.46 |
| Mean reference-beating candidates | 3.54 | 3.69 |
| Valid PPA samples | 257 | 294 |

T73's mean HV is about `3.86%` below classic, so it does not meet the strict
`2%` near-classic HV threshold. It does preserve coverage and improves two
secondary signals: valid-PPA samples and reference-beating candidate count.

## Problem-Level Read

T73 has useful local signals:

- positive HV deltas on `Prob024_fsm`, `Prob037_parallel2serial`,
  `Prob045_alu`, `Prob116_m2014_q3`, and `Prob153_gshare`;
- higher valid-PPA counts on `Prob004_adder_8bit`, `Prob024_fsm`,
  `Prob037_parallel2serial`, `Prob041_traffic_light`, `Prob045_alu`,
  `Prob049_signal_generator`, `Prob116_m2014_q3`, and
  `Prob135_m2014_q6b`;
- no design-level valid-PPA coverage loss versus classic.

The blockers are also clear:

- a large negative HV delta on `Prob041_traffic_light`;
- weaker front breadth: `1.46` mean Pareto points versus classic `2.31`;
- archive failure on `Prob151_review2015_fsm`, even though generation logs
  contain three T73 valid-PPA candidates for that problem.

## Interpretation

T73 fixes part of T72's descriptor-collapse issue: the archive has much better
cell occupancy on several problems and the final-analysis bundle recommends
T73 for score/QD/archive signals. That is useful evidence for the
source-aligned RTL-native lane.

It does not yet answer the performance question positively. The improved
valid-PPA yield does not translate into enough front breadth or mean HV, and
the `Prob041_traffic_light` regression is too large to ignore.

## Next Step

Do not promote exact T73. The next source-aligned RTL-native method should
keep the yield and archive-occupancy gains, but change the coupling so new
cells create front material instead of mostly extra valid samples. A natural
follow-up is a T74 hybrid that keeps T73 shape-density cells as a secondary
archive lane while restoring T72/T51-style front-slot pressure on known
near-front families.
