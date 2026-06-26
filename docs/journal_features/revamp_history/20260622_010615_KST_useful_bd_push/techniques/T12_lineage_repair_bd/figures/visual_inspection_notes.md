# T12 Visual Inspection Notes

Inspected on 2026-06-26.

## `t12_t31_holdout_live_aggregate.png`

- Renders correctly.
- The T26-only mean HV and HV-AUC signal is visually clear.
- The plot supports the conclusion that direct fail-feedback did not preserve
  the T26 holdout quality signal.

## `t12_t49_metric_delta_summary.png`

- Renders correctly.
- Best score and HV-AUC gains are legible.
- The negative HV, valid-PPA, and front bars make the mixed diagnostic result
  easy to explain.

## `t12_t51_metric_delta_summary.png`

- Renders correctly.
- The figure clearly shows T51 as a recovery base: HV-AUC, best score, and
  valid PPA improve while HV and front breadth remain negative.

## `t12_t59_metric_delta_summary.png`

- Renders correctly.
- The plot makes the short-feedback failure clear: best score improves, but
  HV, HV-AUC, valid PPA, and front breadth all decline versus classic.
