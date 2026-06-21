# WP3 Learned Encoder Diagnostic Card

- Family: `aurora_linear_autoencoder_probe`
- Status: diagnostic-only replay probe.
- Fitting input: `common_audit_descriptor_vector` only.
- Forbidden fitting inputs: `area`, `power`, `timing_or_clock_period`, `fitness`, `ppa_hypervolume_contribution`, `valid_ppa`, `problem_id`, `candidate_id`
- Train candidates: 2120
- Holdout candidates: 1682
- Encoder hash: `3334e92d9fb1a61b2a93437cc389ed4a9bca176062e66ce7ab892269dfe0dbe1`
- Train reconstruction MSE: 0.0085099
- Holdout reconstruction MSE: 0.0182717
- Verdict: `diagnostic_only_no_proceed`

This probe tests whether a small frozen bottleneck over existing implementation vectors improves quality-gated novelty replay on held-out problems. It does not train on PPA labels and does not support active method promotion by itself.
