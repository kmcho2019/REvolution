# T32 Tables

Status: pre-registered.

| Table | Purpose |
| --- | --- |
| `holdout_screen_v0_subset.yaml` | Frozen VerilogEval holdout subset reused from T30/T31. |
| `run_matrix.csv` | Comparator roots, fixed runtime parameters, and pending T32 arm. |

Expected result tables after execution:

- per-problem live metrics for classic, T26, T31, and T32;
- aggregate live deltas versus classic plus direct comparison discussion versus
  T26/T31;
- candidate-level raw PPA/family rows used to regenerate figures;
- canonical RTL/netlist/family duplicate accounting;
- Pareto archive validation output for T32;
- copied `/v1/models` preflight metadata.
