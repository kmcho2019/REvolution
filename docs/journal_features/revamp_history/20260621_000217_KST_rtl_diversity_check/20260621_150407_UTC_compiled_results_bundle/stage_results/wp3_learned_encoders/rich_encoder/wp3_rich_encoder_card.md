# WP3 Rich Encoder Diagnostic Card

- Family: `aurora_rich_implementation_linear_autoencoder_probe`
- Status: diagnostic-only replay probe.
- Training split: problem-held-out over all candidate rows.
- Input dimension: 37
- Forbidden fitting inputs: `area`, `power`, `eff_clk_period`, `fitness`, `ppa_hypervolume_contribution`, `valid_ppa`, `pareto_member`, `openroad_pass`, `archive_cell_id`, `problem_id`, `candidate_id`, `prompt_hash`, `model`, `model_id`
- Train candidates: 134643
- Holdout candidates: 69301
- Valid-PPA candidates for replay: 102736
- Replay rows: 10704
- Verdict: `diagnostic_only_no_proceed`

This probe trains frozen linear bottlenecks on implementation-side features only: RTL lexical counts, syntax/function/synthesis stages, available descriptor vectors, netlist motif ratios, style clusters, and hash availability flags. It evaluates utility only after freezing the encoder, through held-out quality-gated replay.
