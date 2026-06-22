# T31 Tables

Status: pre-registered.

| Table | Purpose |
| --- | --- |
| `holdout_screen_v0_subset.yaml` | Frozen VerilogEval holdout subset reused from T30. |
| `run_matrix.csv` | Comparator roots, fixed runtime parameters, and pending T31 arm. |

Expected result tables after execution:

- per-problem live metrics for classic, T26, and T31;
- aggregate live deltas versus both classic and T26;
- candidate-level raw PPA/family rows used to regenerate figures;
- canonical RTL/netlist/family duplicate accounting;
- Pareto archive validation output for T31;
- copied `/v1/models` preflight metadata.
