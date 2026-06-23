# T72 Results Report

## Status

T72 passed a bounded hard/tuning live screen after fixing the MasterRTL
runtime scratch-directory race.

## Run

- Run root:
  `exp/useful_bd_push/t72_source_aligned_rtl_cell_20260623_204847_UTC/hard_tuning/`
- Commit:
  `f2b15d59c9b536b5c883579138eac4b9405e0b68`
- Started: `2026-06-23T20:48:47Z`
- Finished: `2026-06-23T21:21:45Z`
- Exit status: `0`
- Final run size: `107M`
- Filesystem after run: `3.5T` free on `/workspace`, `87%` used

## What Passed

- `13/13` hard/tuning problems ended with `success` summary status.
- `13/13` problems produced `archive_summary.json`.
- `13/13` problems produced `global_pareto_summary.json`.
- `13/13` problems produced `descriptor_health.json`.
- `scripts/validate_single_thought_operator_run.py` passed with the frozen
  T72 subset.
- `scripts/validate_pareto_front_run.py` passed with the frozen T72 subset.

The compact per-problem table is:

```text
tables/t72_live_screen_status.csv
```

## Caveats

The first live attempt at
`t72_source_aligned_rtl_cell_20260623_202136_UTC` exposed a real runtime bug:
parallel MasterRTL analyzer calls shared PyVerilog scratch files in the
MasterRTL source directory. Commit `f2b15d59c9` fixed this by running the
upstream analyzer from each candidate-local parse directory.

The fixed run still had one recovered vLLM timeout during
`Prob153_gshare`. The retry completed and the problem ended with `success`, so
this is a runtime note rather than a failed problem.

The result is not a classic-vs-QD headline comparison. It shows that the
source-aligned RTL-native descriptor lane can run end to end on the bounded
screen. A comparison claim still requires matched classic/QD metric packaging,
direct PPA-front plots, and Phase 03.1 visualization export.

## Initial Assessment

The run supports continuing the MasterRTL/RTL-Timer lane because it removes
the prior executability concern and gets valid PPA-producing candidates on all
screen problems. The descriptor health files also show sparse archive
coverage: most problems occupy one of sixteen cells, with one problem reaching
two cells. That means T72 is an executable baseline for RTL-native descriptors,
but the next variant should focus on improving cell spread or using a less
collapsed second axis.
