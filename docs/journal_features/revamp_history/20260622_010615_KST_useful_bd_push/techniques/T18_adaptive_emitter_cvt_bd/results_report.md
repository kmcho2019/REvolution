# T18 Adaptive Emitter CVT BD Results Report

Status: `T0 retrospective_retired`.

## Question

Should we spend another live run on an adaptive-emitter/CVT method, or do the
measured archive-adaptation and front-emitter packages already rule out the
current form of the idea?

## Headline Result

Do not run exact T18. It is retired as a small archive/schedule-tweak family.

T57 tests the archive-geometry half and T32 tests the emitter-schedule half.
Neither produces claim-safe PPA-front evidence:

| Source | Mechanism | Main read |
| --- | --- | --- |
| `T57` | Adaptive grid-quantile rebinning | Mean HV drops from classic `0.092601` to `0.075811`; HV-AUC drops from `0.082020` to `0.070421`; rebin checks occur but rebin events stay at `0`. |
| `T32` | Front-preserving emitter schedule | Valid-PPA and unique-PPA counters improve versus T31, but T32 does not preserve T26's P135 quality/HV signal and remains at zero holdout mean HV. |

## Evidence Matrix

The machine-readable summary is in `tables/t18_evidence_matrix.csv`.

| Source | Classic HV | Method HV | HV Delta | Classic valid PPA | Method valid PPA | Classic front | Method front | Decision |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| `T57` | 0.092601 | 0.075811 | -0.016790 | 257 | 245 | 30 | 23 | Fails archive-adaptation gate. |
| `T32` | 0.000000 | 0.000000 | 0.000000 | 103 | 67 | 3 | 3 | Fails T26-quality preservation gate. |

T32's aggregate comparison to classic is not the whole story because the
holdout line was trying to preserve T26's positive P135 signal. It did not:
T26 holdout mean HV was `0.066206`, while T32 remained at `0.000000`.

## Visual Evidence

- `figures/t18_t57_rebinning_counters.png` shows the T57 rebinning mechanism
  reached checks but no actual rebin events.
- `figures/t18_t32_holdout_live_aggregate.png` shows T32's count recovery does
  not recover the T26 HV/quality signal.

These are copied, renamed source figures. The original full packages remain in
`T57_t51_adaptive_rebin_qd/` and
`T32_sr_raw_front_preserving_emitter_qd/`.

## Gate Decision

The machine-readable gate table is in `tables/t18_gate_decision.csv`.

| Gate | Result | Reason |
| --- | --- | --- |
| Archive adaptation actuates | Fail | T57 records `26` checks and `0` rebin events. |
| Headline HV improves | Fail | T57 loses mean HV by `0.016790`. |
| Front breadth improves | Fail | T57 loses front points and unique PPA points. |
| Front emitter preserves quality | Fail | T32 does not preserve T26's holdout HV/quality signal. |
| Validity signal is useful | Partial | T32 improves some yield/breadth counters versus T31. |

## Conclusion

T18 answers the adaptive-emitter/CVT question negatively for the current
method family. Archive-boundary adaptation without changed candidate creation
did not actuate or improve PPA-front metrics, and a small front-preserving
emitter nudge improved some counters without recovering the decisive quality
signal.

Do not spend a live run on exact T18. The only reasonable continuation is a
materially different source-level repair or front-rescue emitter that logs
per-lane valid-PPA yield, local-front additions, global-front additions, and
final-front contribution.
