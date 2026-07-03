# SR Pareto Validation Matrix Methodology

## Intent

Compare the current synthesis-response leads against the required controls on a
single validation surface:

- classic REvolution;
- landing Smooth-QD/manual BD;
- T22 random descriptor control;
- T19 SR ReLU PCA;
- T04 SR-RFF PCA.

This is a passive validation package, not a new live method. Its purpose is to
decide which descriptor/archive-coupling combination should receive the next
bounded live run.

## Inputs

- Central seed-1001 replay report:
  `exp/useful_bd_push/central_replay_20260621_165000_UTC/auto_bd_seed1_central_report.json`
- T17 passive local-Pareto audit aggregate table:
  `exp/useful_bd_push/t17_mome_pareto_audit_20260621_175500_UTC/tables/aggregate.csv`

No descriptor is fitted or changed in this package. The package only joins
existing metrics and local-Pareto retention evidence.

## Matrix Construction

The packaging script selects five methods and joins:

1. final seed-1001 replay metrics from the central leaderboard;
2. anytime metrics from the central replay;
3. scalar-cell and bounded local-Pareto retention metrics from the T17 audit.

The selected methods are fixed in
`scripts/package_useful_bd_validation_matrix.py` as `FOCUS_METHODS`.

The matrix reports:

- final mean HV and HV AUC;
- final best fitness and best-fitness AUC as secondary diagnostics;
- valid-PPA candidates;
- common-audit occupied cells and QD score;
- local-Pareto retained candidates;
- local global Pareto points;
- local PPA-front unique netlists;
- local PPA-grid occupied cells;
- deltas versus classic and T22 random descriptor.

## Acceptance Interpretation

This package cannot promote a method by itself because the local-Pareto
evidence is passive over already generated candidates. It can justify a next
live run when a method:

- preserves classic-covered problems in the underlying replay;
- beats T22 random descriptor on the metric being claimed;
- has an interpretable non-PPA descriptor;
- shows enough local-Pareto front material to make archive coupling plausible.

## Current Role

T23 supports two separate conclusions:

- `T04` SR-RFF is still the cleanest `T1 near_classic` validation candidate;
- `T19` SR ReLU is the strongest HV/HV-AUC source but still needs a
  quality-safe archive or parent schedule.

The next experimental method should be a bounded live local-Pareto variant over
SR-RFF or SR-ReLU, not another passive replay table.
