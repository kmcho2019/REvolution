# DeepGate Transition Bridge Report

## Answer

The transition abstraction improves AIG exportability for sequential generated
RTL, but it does not yet produce a usable DeepGate embedding corpus. The
official DeepGate parser remains the blocker.

## Method

For latch-bearing AIGs, the transform rewrites:

- original primary inputs plus latch state literals as new primary inputs;
- original primary outputs plus latch next-state literals as new outputs;
- latch count to zero;
- existing AND definitions unchanged.

This represents one-cycle transition logic. It is an honest hardware-native
descriptor candidate because it exposes the combinational logic around state
instead of silently dropping flip-flops.

## Header Smoke

| Problem | Original AAG | Transition AAG | Read |
| --- | --- | --- | --- |
| `Prob015_multi_pipe_8bit` | `aag 1255 19 69 17 1167` | `aag 1255 88 0 86 1167` | Export fixed, still too large. |
| `Prob024_fsm` | `aag 79 3 9 1 67` | `aag 79 12 0 10 67` | Bounded candidate. |
| `Prob041_traffic_light` | `aag 542 3 73 11 466` | `aag 542 76 0 84 466` | Export fixed, parser slow at medium size. |
| `Prob049_signal_generator` | `aag 163 2 13 5 148` | `aag 163 15 0 18 148` | Bounded candidate. |
| `Prob153_gshare` | `aag 10479 27 645 8 9807` | `aag 10479 672 0 653 9807` | Too large. |

## Run Outcome

Three transition runs were attempted:

1. `--max-aig-vars 700 --max-per-backend-problem 3`;
2. `--max-aig-vars 300 --max-per-backend-problem 3`;
3. `--max-aig-vars 200 --max-per-backend-problem 1`.

All were manually interrupted after the official DeepGate parser entered its
topological-sort path for generated transition AIGs. The bottleneck is not the
pretrained model load and not Yosys export; it is parser/order computation.

## Decision

Do not promote transition DeepGate to a live QD arm. The next valid DeepGate
bridge should be one of:

- cone-level extraction around state and output signals;
- a faster AIG-to-DeepGate graph converter that bypasses the current parser
  bottleneck;
- a compact transition summary that compares DeepGate embeddings against
  simple AIG statistics before live spending.
