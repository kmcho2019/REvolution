# SR ReLU PCA BD Methodology

## Intent

Test whether a fixed random-ReLU projection over non-PPA synthesis-response
features gives MAP-Elites a more useful behavior descriptor than hand-selected
CAD axes or the RFF control from `T04_autoqd_mmd_synthesis_bd`.

This package is the chronological `T19` package because the method was already
run in the 20260618 Auto-BD sweep but had not been represented in the current
useful-BD push.

## Inputs

- Candidate RTL from the standard REvolution run path.
- Yosys synthesis-response features: final stats, motif occupancy,
  ST-NOD trajectory swings, per-stage motif ratios, and per-stage cell-count
  deltas.
- A frozen fitting corpus from the seed-1001 development artifacts.
- Fixed benchmark metadata needed to join candidates to problems and runs.

Descriptor fitting and descriptor assignment exclude PPA, reference PPA,
fitness, hypervolume, test pass percentage, problem ID, and final evaluation
labels.

## Descriptor Algorithm

For each candidate:

```text
z = robust_scale(raw_synthesis_response_features)
h = relu(Wz + b)
bd = PCA_3(h)
```

The random feature map is frozen before evaluation:

- random feature type: ReLU;
- random feature count: 128;
- random feature seed: `20260618`;
- descriptor axes: `sr_pca_0`, `sr_pca_1`, and `sr_pca_2`;
- archive type in the historical run: `grid_quantile`;
- cell mode: Pareto front;
- max elites per cell: 5.

The method differs from `T04` as follows:

- `T04` uses random Fourier features before PCA.
- `T19` uses a fixed random ReLU map before PCA.
- Both use the same raw synthesis-response schema and the same PPA-free fitting
  discipline, so their replay comparison isolates the nonlinear map choice.

## Current Replay Scope

The completed package re-scores the historical
`sr_random_relu_pca_qd` seed-1001 standard-result artifacts with the current
useful-BD policy. It compares classic REvolution, landing Smooth-QD/manual BD,
and SR ReLU PCA on the same six-problem development subset, same seed, same
model, same candidate budget, and same central passive audit surface used by
the `T01` to `T06` packages.

This is replay evidence, not a new live run. It is valid for method triage and
for deciding which lane deserves a live follow-up.

## Archive And Parent Coupling

The historical run used the descriptor for archive placement and kept a
Pareto-front cell mode. Parent selection was still close to the existing
Smooth-QD machinery and did not implement the newer local-Pareto parent
schedule proposed after `T17`.

That distinction matters: T19 measures the descriptor's replay behavior, while
the next live variant should test whether local-Pareto parent sampling can keep
SR ReLU's hypervolume advantage without losing best-fitness and audit coverage.

## Acceptance Interpretation

SR ReLU PCA should not be accepted merely because it beats classic on one
aggregate metric. It becomes a validation candidate only if it preserves every
classic-covered design, avoids a functionality/synthesis collapse, and improves
QD/Pareto-front evidence without an unacceptable quality regression.

In the current replay, it passes the validity gates and has strong HV evidence,
but it remains a `T0 diagnostic` because final best fitness, PPA-front unique
netlists, and common-audit occupied cells decline relative to classic.

## Expected Follow-Up

The next method should not be another plain SR ReLU replay. It should combine
this descriptor with one of:

- bounded local-Pareto cell retention from `T17`;
- a quality-safe parent schedule with underfilled-cell exploration;
- an SR-RFF/SR-ReLU ensemble descriptor;
- an ST-NOD plus SR-ReLU hybrid that keeps the transparent synthesis-response
  interpretation while recovering audit coverage.
