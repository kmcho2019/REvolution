# WP3 Learned Encoder Diagnostic Card

- Family: `aurora_linear_autoencoder_probe`
- Status: diagnostic-only replay probe.
- Fitting input: `common_audit_descriptor_vector` only.
- Forbidden fitting inputs: `area`, `power`, `timing_or_clock_period`, `fitness`, `ppa_hypervolume_contribution`, `valid_ppa`, `problem_id`, `candidate_id`
- Train candidates: 2120
- Holdout candidates: 1682
- Encoder hash: `698d32b4214ee015c3cab1620b43b4bfc57a1cb78d3a611dc2a26faebc00e8ef`
- Train reconstruction MSE: 0.00480922
- Holdout reconstruction MSE: 0.00962343
- Verdict: `diagnostic_only_no_proceed`

This probe tests whether a small frozen bottleneck over existing implementation vectors improves quality-gated novelty replay on held-out problems. It does not train on PPA labels and does not support active method promotion by itself.
