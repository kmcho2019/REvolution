# T73 Results Report

## Current Tier

`T0 positive_diagnostic_not_promoted`.

T73 now has a reference-complete matched classic comparison. It is useful
evidence for the source-aligned RTL-native lane because it preserves coverage
and improves valid-PPA yield, but it is not a promoted QD/MAP-Elites win.

## What Is Answered So Far

The pre-run audit answers a narrower descriptor-design question:

Does T72 fail partly because its source-aligned descriptor cells collapse?

Yes. On the fixed T72 run, the live archive occupied a mean of only `1.0769`
fixed cells per problem. The second T72 axis,
`rtltimer_state_timing_class`, had one unique value for every problem in the
archive-event replay.

Does T73 offer a plausible source-aligned fix without PPA leakage?

Yes, as a screen candidate. The three T73 axes are derived only from
MasterRTL/RTL-Timer source-aligned counts. A posthoc problem-local quantile
projection over the same T72 candidates gives a mean of `5.6923` occupied
cells per problem and a minimum of `2`.

Does T73 run end-to-end on the hard/tuning subset?

Mostly. The `20260623_232844_UTC` live screen completed in `1706.23` seconds
with no tracebacks. Registered validation passes:

- single-thought operator validation: `valid=True`, `failure_count=0`;
- Pareto-front validation: `valid=True`, `failure_count=0`,
  `max_front_size_seen=2`.

The compact package records `624` candidate files, `294` PPA reports, and
`85` archive members. The summary has `12/13` successful problems. The one
failed problem is `VerilogEval-Spec-to-RTL/Prob151_review2015_fsm`, which has
a complete problem root but zero archive members.

The best-score summary is:

| Problem | Status | Best Score | Archive Members |
| --- | --- | ---: | ---: |
| `Prob004_adder_8bit` | success | `0.381544` | `2` |
| `Prob015_multi_pipe_8bit` | success | `0.023107` | `9` |
| `Prob024_fsm` | success | `0.500234` | `8` |
| `Prob037_parallel2serial` | success | `0.097923` | `7` |
| `Prob041_traffic_light` | success | `0.403821` | `15` |
| `Prob045_alu` | success | `0.407022` | `15` |
| `Prob049_signal_generator` | success | `0.263803` | `3` |
| `Prob098_circuit7` | success | `0.012006` | `2` |
| `Prob116_m2014_q3` | success | `0.465352` | `6` |
| `Prob135_m2014_q6b` | success | `0.263617` | `3` |
| `Prob150_review2015_fsmonehot` | success | `0.329686` | `2` |
| `Prob151_review2015_fsm` | failed |  | `0` |
| `Prob153_gshare` | success | `0.135603` | `13` |

## Matched Classic Comparison

The matched comparison package lives at:

```text
matched_classic_comparison/
```

It compares T73 against the T47 classic seed `1001` run on the same
`13`-problem hard/tuning subset. All problems have valid reference PPA and
both methods have at least one valid candidate-PPA row, so there are no
missing-reference headline exclusions.

Primary metrics:

| Metric | Classic | T73 |
| --- | ---: | ---: |
| Mean HV | `0.0926007600` | `0.0890223082` |
| HV wins | `8` | `5` |
| Mean Pareto points | `2.31` | `1.46` |
| Mean reference-beating candidates | `3.54` | `3.69` |
| Valid PPA samples | `257` | `294` |

The mean HV loss is about `3.86%`, outside the strict `2%` near-classic HV
threshold. T73 therefore stays below promotion even though it improves valid
PPA yield and reference-beating count.

## Remaining Caveats

The matched comparison does not prove better PPA, better HV, or better QD
utility. It shows that the source-aligned shape-density cells are executable
and yield-positive, while classic still owns the multi-objective Pareto read.

`Prob151_review2015_fsm` is a special caveat: final analysis finds three T73
candidate-PPA rows, but the live archive summary failed and has zero archive
members. Treat it as a preserved candidate-PPA problem with an archive-health
failure, not as a clean archive success.

Operator caveat: the run disables QD crossover/fusion with
`qd_two_parent_probability=0.0`, but keeps the inherited
`qd_operator_one_parent_fraction=0.90`. Archive parent arity counts are
`31` initial/no-parent, `50` one-parent, and `4` two-parent prompt
descendants. T73 is therefore not a strict one-parent ablation.

## Figure Inspection

`figures/t73_descriptor_occupancy_audit.png` was inspected after regeneration.
The figure is readable at full width, uses conventional grouped bars, labels
T72 fixed-grid occupancy separately from T73 observed-range and local-quantile
projections, and makes the descriptor-collapse fix visually clear.

## Next Required Step

Do not rerun exact T73 as-is. The next source-aligned RTL-native follow-up
should keep the valid-yield and occupancy gains, but change archive coupling
so extra cells create more front material. A T74 hybrid should combine T73
shape-density cells with a stronger front-slot lane, then compare directly
against T72/T73/classic on the same reference-complete subset.
