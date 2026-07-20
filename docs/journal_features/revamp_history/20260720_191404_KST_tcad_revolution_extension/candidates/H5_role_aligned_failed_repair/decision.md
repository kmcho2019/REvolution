# H5 Candidate Decision

Current state: `SMOKE_VALIDATED`; the representative probe is pending.

## Outcome

`PENDING`

Allowed outcomes: `PAPER_CANDIDATE`, `VIABLE`, `RETIRED`, `BLOCKED`.

## Frozen Hypothesis And Gates

See `hypothesis_card.md`. The card reached `READY` before implementation.

## Evidence By Stage

- Code gate: `PASS` at implementation commit
  `59acb11def38d12466cca425c6828bba25f98dc8`.
- Technical smoke: `PASS`; three problems, seed 42, 16 candidates per
  problem/arm, fresh matched control, exact H5 activation, complete telemetry,
  and no infrastructure failure.
- Representative, full-suite, confirmation, and holdout: not started.

## Primary And Secondary Results

The smoke produced three functional and valid-PPA designs in each arm. Classic
generated 31 valid-PPA candidates and H5 generated 30. These are execution and
catastrophic-failure checks only; the smoke carries no performance decision.

## Mechanism Findings

Classic issued eight failed-parent requests across all five failed operators;
H5 issued nine and every one used M-F. Direct valid-PPA repairs were one for
classic and four for H5, an observed mean normalized delta of `+0.0625`. This
small, stochastic smoke value is not promotion evidence and does not alter a
gate.

## Naturalness And Novelty Assessment

## Code And Documentation Assessment

The treatment is one fixed search-mode discriminant and one isolated subclass.
It inherits classic success evolution, survivor selection, evaluation, and
generation logic. The classic engine and default configuration retain their
frozen hashes. Focused tests, the broad suite excluding one separately recorded
legacy hang, Ruff, Pyright, focused `ty`, and three independent reviews pass.

## Review Findings And Dispositions

See the three post-diff review records under `../../reviews/`. All blocking
code and evidence-readiness findings closed before live spend. The independent
post-smoke audit in `../../reviews/20260720_h5_smoke_audit.md` returned `PASS`.

## Decision Rationale

The technical gate is satisfied, so the frozen representative probe is
admissible. No scientific outcome is available before the suite ladder.

## Allowed Claim And Paper Role

## Portfolio And Negative-Map Updates
