# Archive Stagnation Activation Probe Report

Status: `diagnostic_negative_not_promoted`.

## Conclusion

`masterrtl_archive_stagnation_activation_8x5` should not be promoted to the
final full-RTLLM comparison. It preserves all eight screened problems, but it
does not come close to classic on the headline PPA-front metrics.

The result is still useful because it tests a materially different timing
mechanism from fixed delayed activation. The trigger was exercised, but it was
too conservative and too late to recover the classic gap under this budget.

## Key Numbers

| Backend | Mean HV | Mean Pareto Points | Mean Ref-Beating | HV Wins |
| --- | ---: | ---: | ---: | ---: |
| `classic_revolution_8x5` | `0.1406` | `3.25` | `8.00` | `5` |
| `masterrtl_aux_archive_high_exploit_8x5` | `0.1339` | `1.75` | `4.00` | `1` |
| `masterrtl_aux_archive_adaptive_sparse_front_8x5` | `0.0946` | `2.38` | `4.88` | `0` |
| `masterrtl_delayed_archive_activation_8x5` | `0.1324` | `2.00` | `6.00` | `1` |
| `masterrtl_archive_stagnation_activation_8x5` | `0.1089` | `2.00` | `5.62` | `1` |

Stagnation activation loses classic by `-22.58%` mean HV:

- classic: `0.1406447841`;
- stagnation activation: `0.1088883095`;
- absolute delta: `-0.0317564746`.

Removing `Prob135_m2014_q6b` does not change the conclusion:

- classic no-Prob135 mean HV: `0.1607368961`;
- stagnation no-Prob135 mean HV: `0.1244437822`;
- relative delta: `-22.58%`.

## Per-Problem Read

Stagnation activation ties or improves HV on four problems:

- `Prob015_multi_pipe_8bit`: tie at zero HV;
- `Prob024_fsm`: `+0.001157`;
- `Prob116_m2014_q3`: tie;
- `Prob153_gshare`: `+0.001972`.

It loses the main aggregate contributors:

- `Prob041_traffic_light`: `-0.172915`;
- `Prob045_alu`: `-0.075038`;
- `Prob049_signal_generator`: `-0.009228`.

The large `Prob041_traffic_light` and `Prob045_alu` losses are enough to make
the arm clearly outside the registered `1-2%` promotion tolerance.

## Mechanism Check

The stagnation trigger was exercised but only lightly:

- `49` archive-history rows were written;
- `7` rows had `qd_archive_pressure_active=true`;
- `7` rows had `qd_archive_stagnation_triggered=true`;
- activation appeared on `3/8` problems:
  `Prob015_multi_pipe_8bit`, `Prob049_signal_generator`, and
  `Prob116_m2014_q3`;
- `34` rows stayed in `phase="delayed"`.

This means the arm was not a total no-op, but most problems remained in the
delayed/passive state for most of the run. The strong `Prob153_gshare` point
did not come from active archive pressure, because that problem never triggered
the stagnation gate.

## Interpretation

Measured stagnation is a cleaner anti-gaming trigger than fixed activation
generation because it uses only scheduler-visible archive growth. However, this
specific patience-2 rule does not help the current MasterRTL auxiliary archive
family. It performs worse than both fixed high-exploit and fixed delayed
activation:

- high-exploit mean HV: `0.1339`;
- delayed activation mean HV: `0.1324`;
- stagnation activation mean HV: `0.1089`.

This closes the simple MasterRTL auxiliary archive timing family for now:
fixed high-exploit, front-breadth, depth-only, adaptive sparse-front, fixed
delayed activation, and measured stagnation activation have all failed to
produce a spend-ready QD arm.

The next preliminary candidate should be materially different. The best next
lane is validated MasterRTL pretrained model-state descriptors, with strict
upstream-weight loading, schema assertions, and generated-candidate
non-collapse checks before any live run.

## Visual Inspection

The generated standard pairwise Pareto plots are useful for detailed analysis,
but at least one inspected plot has a clipped legend and is not
presentation-ready as-is:

- `pareto_analysis/problems/RTLLM/Prob041_traffic_light/pairwise_fronts.png`

The package therefore includes a simpler inspected summary figure:

- `figures/archive_stagnation_summary.png`

That figure clearly shows aggregate mean HV and paired per-problem HV deltas.

## Artifacts

- `figures/archive_stagnation_summary.png`
- `tables/stagnation_aggregate_backend_metrics.csv`
- `tables/stagnation_backend_problem_metrics.csv`
- `tables/stagnation_vs_classic_problem_deltas.csv`
- `tables/ppa_candidates.csv`
- `tables/reference_ppa_metrics.csv`
- Completed analysis source:
  `exp/useful_bd_push/prelim_archive_stagnation_activation_20260626_031337_UTC/live/final_analysis_with_archive_stagnation_activation`

## Validation Notes

The live run completed `8/8` problems in `1433.52s`. Both preregistered
validators passed with no output:

- `scripts/validate_pareto_front_run.py`;
- `scripts/validate_single_thought_operator_run.py`.

Targeted Pareto and PPA-distribution reports completed without warnings. The
full design-space feature bundle was not rerun because prior packages already
showed that source-aligned feature recovery can dominate runtime after the
decision tables are complete.
