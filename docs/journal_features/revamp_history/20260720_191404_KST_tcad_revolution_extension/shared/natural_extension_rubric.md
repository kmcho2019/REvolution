# Natural Extension Rubric

## Hard rejection conditions

Reject the candidate before live experiments if any condition is true:

1. It requires problem IDs, benchmark names, or manually selected per-design
   thresholds in the search path.
2. It uses hidden tests, final-suite outcomes, or reference PPA to guide search.
3. Its claimed novelty is already the central method of closely related work
   and no clear REvolution-specific delta exists.
4. It changes model, budget, evaluator, or problem coverage in the primary
   comparison without a paired control.
5. Its mechanism cannot be isolated by an ablation.
6. It adds many knobs without a preregistered, problem-independent choice.

## Scored criteria

Score each item 0, 1, or 2. Require at least 8/10.

1. **Conference continuity**: directly extends an existing REvolution state,
   population, feedback, strategy, or evaluation mechanism.
2. **Generality**: applies across combinational, sequential, and control-heavy
   RTL without per-problem changes.
3. **Mechanistic clarity**: states why the change should affect PPA or validity
   and exposes measurements that can falsify the explanation.
4. **Implementation simplicity**: one narrow code path, limited public knobs,
   typed states, and no unrelated refactor.
5. **Paper value**: supports a substantive algorithm, reliability, or
   generalization contribution beyond additional experiments.

## Required written decision

Record the score, hard-gate result, related-work delta, and reviewer objections
before moving a candidate to `READY`.
