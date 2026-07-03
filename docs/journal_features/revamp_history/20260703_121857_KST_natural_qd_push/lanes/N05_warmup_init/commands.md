# N05 Launch Commands (registered; launch only after the anchor package)

Base = the pinned V2 anchor command with
`BASE=exp/natural_qd_push/n05_warmup_init_<UTC>` and a fresh recorded
preflight. Single-factor deltas:

- N05a warmup 4: replace `--qd_grid_quantile_warmup_successes 8` with
  `4`; `--save_path "${BASE}/live/warmup_4/seed_1001"`.
- N05b warmup 16: replace with `16`;
  `--save_path "${BASE}/live/warmup_16/seed_1001"`.

Package per the P0 chain; audits and run validation mandatory; coverage
hard gate is the primary read for this lane.
