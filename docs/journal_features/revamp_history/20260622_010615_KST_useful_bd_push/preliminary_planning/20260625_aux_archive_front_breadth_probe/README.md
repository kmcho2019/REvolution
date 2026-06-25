# Auxiliary Archive Front-Breadth Probe

This package preregisters the follow-up to
`20260625_aux_archive_high_exploit_probe/`.

## Question

Can the best-HV auxiliary archive setting recover Pareto-front breadth without
falling back to the weaker descriptor-only behavior?

## Candidate

`masterrtl_aux_archive_front_breadth_8x5`

This arm keeps the same MasterRTL structural archive cells as the high-exploit
probe, but changes parent pressure:

- champion lane drops from `0.90` to `0.80`;
- parent selection changes from global NSGA-II only to
  `front_slot_lane_nsga2`;
- front-slot parent lane rises to `0.20`;
- improve-phase backfill rises from `0.05` to `0.10`.

The run is only successful if it narrows or preserves the high-exploit HV
signal while improving Pareto point count, unique/front material, or
reference-beating candidates.

## Status

Preregistered. Use the same frozen eight-design `8x5` screen as the other
preliminary candidates.

## Files

- `preregistration.md`: hypothesis, command shape, gates, and expected read.
