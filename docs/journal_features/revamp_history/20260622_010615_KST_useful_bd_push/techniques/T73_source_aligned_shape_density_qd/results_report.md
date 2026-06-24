# T73 Results Report

## Current Tier

`screening_diagnostic_not_promoted`.

T73 has a valid bounded live vLLM screen, but it must not be used as evidence
that QD/MAP-Elites beats classic REvolution until matched classic metrics are
packaged on the reference-complete subset.

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

## What Is Not Answered

The live screen does not prove better PPA, better HV, or better QD utility.
It has not yet been compared against matched classic REvolution with
reference-complete headline metrics. Because `Prob151_review2015_fsm` has zero
archive members, the next comparison must report both all-problem and
successful-problem subsets instead of hiding the failure.

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

Package a matched classic comparison with reference-complete headline metrics.
Promote T73 only if it preserves classic-covered designs and improves
front-material or HV/HV-AUC evidence without relying on missing-reference or
duplicate diversity artifacts.
