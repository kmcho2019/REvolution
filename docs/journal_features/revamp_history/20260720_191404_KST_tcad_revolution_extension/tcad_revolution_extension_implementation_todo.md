# REvolution TCAD Extension Program TODO

Line limit: 140 lines. Move experiment detail to the program history and
candidate histories.

## Program setup

- [ ] Resolve every activation blocker in `intake_review.md`.
- [ ] Freeze a versioned claims addendum or replacement contract.
- [ ] Record branch, HEAD, dirty state, toolchain, model, and artifact roots.
- [ ] Freeze the conference baseline contract.
- [ ] Freeze development, holdout, and final problem manifests.
- [ ] Freeze reference-complete and candidate-missing policies.
- [ ] Create experiment registry and claim/evidence ledger.

## Candidate decisions

- [ ] H1 hypothesis card passes novelty and naturalness gates.
- [ ] H1 reaches PROMOTED, RETIRED, or BLOCKED.
- [ ] H2 hypothesis card passes novelty and naturalness gates.
- [ ] H2 reaches PROMOTED, RETIRED, or BLOCKED.
- [ ] H3 novelty audit clears related-work overlap.
- [ ] H3 reaches PROMOTED, RETIRED, or BLOCKED if pursued.
- [ ] H4 benchmark/task extension is implemented and documented.

## Integration

- [ ] Select only promoted components.
- [ ] Run isolated and pairwise interaction ablations.
- [ ] Select the smallest non-regressing integrated method.
- [ ] Freeze final method and configuration before final-suite run.
- [ ] Run final reference-complete suite and seed confirmation.

## Code and docs

- [ ] Code remains simple, typed, narrow-state, and free of problem branches.
- [ ] Required data uses asserts; no silent defaults.
- [ ] Focused tests cover selection, reward, missing data, and determinism.
- [ ] `uv run ruff check`, `python -m pyright`, `uv tool run ty check`, and
  repository tests pass.
- [ ] Methodology, configuration, and reproduction docs are complete.
- [ ] Paper figures and tables are script-generated from raw artifacts.

## Evidence and paper

- [ ] Claim/evidence ledger has no unsupported core claims.
- [ ] Negative and retired candidates are documented.
- [ ] Conference-to-journal delta table is complete.
- [ ] Limitations and threats to validity are explicit.
- [ ] Adversarial sub-agent returns PASS.
