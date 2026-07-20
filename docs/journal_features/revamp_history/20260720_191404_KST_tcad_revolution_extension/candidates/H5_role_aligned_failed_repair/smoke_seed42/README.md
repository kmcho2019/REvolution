# H5 Seed-42 Technical Smoke

Outcome: `PASS`. This package records execution validity only.

## Scope

- Problems: `Prob002_adder_16bit`, `Prob025_sequence_detector`, `Prob043_RAM`.
- Seed: 42; population: 8; generations: 1; candidate budget: 16 per problem.
- Raw root:
  `exp/tcad_revolution_extension/h5_failed_parent_repair/wave1/smoke_seed42`.

## Gate Result

Both fresh arms completed all three problems with equal candidate and LLM-call
budgets. The strict report validated saved configs, lineage, exhaustive stage
states, operator contracts, PPA artifacts, and treatment pool trajectories.
An independent audit and a deterministic report replay both passed.

The observed direct valid-PPA repair counts are retained in
`gate_metrics.csv`, but no smoke metric is performance evidence. The allowed
conclusion is only that H5 activates exactly and can advance to the frozen
representative probe.

## Reproduction

Use `../execution_commands.md`. Gate-bearing output hashes are in
`artifact_manifest.md`.
