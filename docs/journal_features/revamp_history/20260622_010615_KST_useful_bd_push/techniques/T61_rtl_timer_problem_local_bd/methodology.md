# T61 RTLTimer Problem-Local Timing-Risk BD Methodology

Status: first problem-local timing-risk proxy audit packaged; live RTLTimer
extraction still pending.

## Intent

T61 is the immediate ablation after T60. T60 used global timing-risk quantile
cells over all full-RTLLM candidates, which can mix problem identity with
descriptor structure. T61 keeps the same RTLTimer-style proxy features but
assigns timing-risk cells separately within each problem.

The goal is to test whether problem-local timing-risk bins make the RTL-native
descriptor lane more useful before spending on a live QD run.

## Descriptor Inputs

Inputs are candidate RTL and method/problem metadata from the full RTLLM family
audit. The extractor counts RTL text features that approximate timing-risk
morphology:

- control constructs;
- pipeline events;
- arithmetic, shift, comparison, and logic operators;
- RHS operator depth;
- identifier fanout;
- timing-risk entropy and an aggregate timing-risk score.

The descriptor excludes final PPA, reference PPA, fitness, hypervolume,
Pareto rank, and test pass labels. Pareto-front labels are used only after
feature extraction for reporting.

## Archive Mapping

T61 maps candidates into a 4x4 grid over:

1. timing-risk score;
2. control/pipeline ratio.

Unlike T60, the two axes are binned independently per problem. This is a
problem-local passive archive probe, not an in-loop active archive.

## Promotion Rules

T61 cannot be promoted as a live method because no new QD run was launched.
It can justify a future live method only if it shows stronger front-cell or
archive-coverage evidence than T60 without relying on defaulted-reference PPA
or hidden duplicate collapse.

## Expected Follow-Up

If problem-local timing-risk cells remain promising, implement true RTLTimer or
MasterRTL/SOG extraction and pair the resulting problem-local cells with T51 or
T26-family archive machinery in a small fixed-budget live screen.
