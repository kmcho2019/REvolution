# H5 Candidate Decision

Current state: `SMOKE_VALIDATED`; the representative probe is complete and the
full-suite development probe is frozen but not launched.

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
- Representative: technical `PASS`; all 32 arm units completed, the registered
  mechanism activated, and reporting closure passed independent audit.
- Full-suite: preregistered; internal and external reviews returned `PASS`; no
  arm has launched.
- Confirmation and holdout: not started.

## Primary And Secondary Results

On the 16 representative problem-seed pairs, mean H5-minus-classic final HV was
`-0.001442`, HV-AUC was `+0.007650`, and valid-PPA sample yield was `+0.029948`.
Both arms reached RTL-simulation functionality and valid-PPA coverage on all
16 pairs. Final-HV direction was negative at seed 1001 and positive at seed
1002. This saturated, prior-exposed representative stage is diagnostic and
carries no performance classification.

## Mechanism Findings

Across the representative probe, direct valid-PPA repairs were 31 for classic
and 35 for H5. The unconditional repair-rate delta was positive at both seeds:
`+0.0078125` at 1001 and `+0.0026042` at 1002, pooled `+0.0052083` with
problem-clustered 95% CI `[-0.0052083, +0.015625]`. Every H5 failed-parent
request used M-F and success-side evolution remained classic. This is the
registered mechanism signal, not a suite-scale benefit claim.

## Naturalness And Novelty Assessment

## Code And Documentation Assessment

The treatment remains one fixed search-mode discriminant and one isolated
subclass. The classic engine and default configuration retain their frozen
hashes. The reporting closure adds no mechanism state. Fourteen focused tests,
Ruff, Pyright, `ty`, and the independent closure audit pass.

## Review Findings And Dispositions

See the post-diff, smoke, preregistration, and reporting reviews under
`../../reviews/`. The reporting audit initially failed incomplete evidence and
missing-unit paths, then returned `PASS` after tested closure. No live arm was
rerun for that reporting revision.

## Decision Rationale

The representative technical gate is satisfied and its registered mechanism
direction is positive in both development seeds. H5 therefore advances to the
frozen two-seed full-suite probe. It remains `PENDING`: representative HV/AUC
directions cannot confer `VIABLE` or rescue a future full-suite final-HV loss.

## Allowed Claim And Paper Role

Allowed now: on the frozen representative diagnostic set, M-F-only failed-pool
routing increased direct valid-PPA repair rate in both seeds while preserving
saturated coverage; final-HV direction was mixed. Do not generalize this to
full RTLLM or call H5 a journal contribution before the suite gate.

## Portfolio And Negative-Map Updates

`extension_portfolio.md` records H5 as representative-validated and still
pending. The negative map remains unchanged until a full-suite terminal
decision exists.
