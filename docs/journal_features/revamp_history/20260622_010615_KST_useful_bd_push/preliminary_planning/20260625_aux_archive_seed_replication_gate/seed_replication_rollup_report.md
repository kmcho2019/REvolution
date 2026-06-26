# Seed Replication Rollup

Status: `diagnostic_negative_not_promoted`.

## Conclusion

The high-exploit auxiliary archive mechanism does not survive the
seed-replication gate as a final RTLLM candidate. Classic wins the
three-seed mean HV comparison, and the no-Prob135 robustness slice
is also negative.

## Key Numbers

- Classic three-seed mean HV: `0.144182`
- Aux three-seed mean HV: `0.126138`
- Relative HV delta: `-12.51%`
- Relative HV delta without Prob135: `-18.25%`
- Aux seed-level HV wins: `0/3`

## Interpretation

`Prob135_m2014_q6b` was a one-seed positive swing, not a stable
mechanism signal. The current auxiliary archive geometry should not
be promoted to the full RTLLM comparison. The next QD attempt should
change coupling pressure, for example by using an adaptive archive
pressure schedule, rather than retuning the same MasterRTL geometry.

## Artifacts

- `tables/seed_pair_metrics.csv`
- `tables/seed_pair_robustness.csv`
- `tables/problem_seed_deltas.csv`
- `figures/seed_hv_pairs.png`
- `figures/seed_hv_delta_robustness.png`
- `figures/problem_mean_hv_delta.png`
