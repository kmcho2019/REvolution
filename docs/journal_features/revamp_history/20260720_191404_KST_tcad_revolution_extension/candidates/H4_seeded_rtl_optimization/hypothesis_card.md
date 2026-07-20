# H4 Hypothesis Card: Seeded RTL Optimization

## Falsifiable hypothesis

The promoted REvolution extension can optimize functionally valid but
suboptimal RTL more reliably and effectively than one-shot rewriting and the
conference method applied without optimization-specific structure.

## Paper role

This is a scope/generalization contribution, not a substitute for a promoted
algorithmic contribution.

## Proposed task

Initialize the success population with valid seed RTL and preserve an explicit
contract. Evaluate seed-relative PPA improvement and functionality retention.

## Benchmark plan

- primary optimization benchmark with suboptimal/optimized RTL pairs;
- generated first-valid REvolution seeds on a frozen RTLLM subset;
- optional larger hierarchical stress subset after the core result is stable.

## Smallest decisive screen

Eight optimization tasks:

1. unchanged seed;
2. one-shot LLM optimization;
3. conference REvolution initialized from seed;
4. best promoted extension initialized from seed.

## Promotion gate

- functionality preservation at least 90% for accepted candidates;
- seed-relative PPA improvement on at least 60% of tasks;
- promoted method beats one-shot and conference initialization on mean PPA gain
  or valid-PPA efficiency;
- gains survive the hardened evaluation flow.

## Retirement gate

Retire as a main contribution if one-shot optimization matches the full system
or improvements disappear under hardened/cross-flow evaluation.
