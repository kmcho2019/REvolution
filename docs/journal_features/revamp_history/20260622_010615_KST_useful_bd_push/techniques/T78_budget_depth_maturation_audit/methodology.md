# T78 Methodology

## Purpose

The discussion around classic REvolution raised a concrete concern: `12 x 3`
may be too wide and shallow for QD/MAP-Elites. Classic can exploit the PPA
objective immediately, while QD spends early budget filling archive cells and
only later can improve those cells.

T78 checks existing T75 logs for archive maturation. It is not a live ablation.

## Definitions

- **Budget shape**: the population-by-generation structure for a fixed
  candidate budget. `12 x 3` means one initial population plus three
  evolutionary generations, for about `48` candidates per design.
- **Archive maturation**: archive cells continue to be filled or replaced after
  warmup, so the QD mechanism is still changing when the run ends.
- **Occupied cell**: a MAP-Elites archive cell with at least one valid member.
- **Archive member**: a valid candidate kept in an occupied archive cell.
- **Replacement**: a later candidate replaces an existing cell member because
  it improves the local archive quality/front.
- **Front-slot traffic**: QD parent-selection requests and hits from the
  front-slot parent lane.

## Inputs

The audit reads the existing T75 hard/tuning artifacts:

`exp/useful_bd_push/t75_shape_density_front_pressure_20260624_024005_UTC/hard_tuning`

Used files:

- `final_analysis/evolutionary_reports/classic_revolution/generation_metrics.csv`;
- `final_analysis/evolutionary_reports/shape_density_front_pressure_qd/generation_metrics.csv`;
- per-problem `archive_history.jsonl` files from the live T75 QD run.

## Measurements

The script emits:

- per-generation classic and T75 QD yield/score curves;
- per-problem archive maturation rows;
- aggregate archive occupancy, member count, coverage, QD score, and
  front-slot traffic by generation;
- a pre-registered equal-budget shape recommendation table.

## Non-Claims

T78 does not claim that deeper budgets will make QD beat classic. It only
shows that the current `12 x 3` archive is still active late enough that a
fixed-total-budget shape ablation is justified.
