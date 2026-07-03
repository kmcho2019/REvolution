# N03 Launch Commands (registered; launch only after the anchor package)

Base = the pinned V2 anchor command with
`BASE=exp/natural_qd_push/n03_archive_parent_lane_<UTC>` and a fresh
recorded preflight.

Dependency (recorded before any launch): `_front_slot_pool()` returns
slots only under `qd_cell_mode=elite_pareto_slot` (engine.py:2258), so
a bare "V2 + lane fraction" arm would silently draw nothing. N03
therefore runs on the N01a cell mode, is sequenced after N01a's
seed-1001 read (and is re-registered instead if N01a is a kill):

- N03a fraction 0.10: add
  `--qd_parent_selection front_slot_lane_nsga2
  --qd_front_slot_lane_fraction 0.10
  --qd_cell_mode elite_pareto_slot --qd_max_elites_per_cell 2`;
  `--save_path "${BASE}/live/front_slot_lane_010/seed_1001"`.
- N03b fraction 0.30: same with `0.30`;
  `--save_path "${BASE}/live/front_slot_lane_030/seed_1001"`.

Because N03 changes cell mode AND selection relative to V2, its
verdicts read against BOTH the V2 anchor and the N01a arm (which
isolates the cell-mode factor); the N03-vs-N01a delta is the lane
effect. Package per the P0 chain; audits and run validation mandatory.
