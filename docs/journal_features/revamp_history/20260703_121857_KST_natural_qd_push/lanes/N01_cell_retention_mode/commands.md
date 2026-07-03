# N01 Launch Commands (registered; launch only after the anchor package)

Base = the pinned V2 anchor command (`../../tables/v2_platform_config.md`)
with `BASE=exp/natural_qd_push/n01_cell_retention_<UTC>` and a fresh
recorded preflight. Single-factor deltas:

- N01a `elite_pareto_slot_2`: replace
  `--qd_cell_mode pareto_front --qd_max_elites_per_cell 5` with
  `--qd_cell_mode elite_pareto_slot --qd_max_elites_per_cell 2`;
  `--save_path "${BASE}/live/elite_pareto_slot_2/seed_1001"`.
- N01b `scalar_elite`: replace with
  `--qd_cell_mode scalar_elite --qd_max_elites_per_cell 1`;
  `--save_path "${BASE}/live/scalar_elite/seed_1001"`.

Package per the P0 chain (`../../p0_v2_anchor/commands.md` shape) with
backend_run entries classic + V2 anchor + the arm; audits and run
validation mandatory before any read.
