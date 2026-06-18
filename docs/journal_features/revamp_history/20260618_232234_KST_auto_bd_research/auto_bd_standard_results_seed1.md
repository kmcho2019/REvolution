# Auto-BD Standard Results Seed-1 Index

Status: preliminary development-subset artifact index.

Centralized report:

- `auto_bd_seed1_centralized_report.md`
- `auto_bd_seed1_centralized_report.json`

Hybrid ablation report:

- `auto_bd_seed1_hybrid_ablation_report.md`
- `auto_bd_seed1_hybrid_ablation_report.json`

Generated with:

```bash
UV_LINK_MODE=copy uv run --active python scripts/build_auto_bd_standard_results.py
```

Each arm writes the standard schema under:

```text
exp/auto_bd_research/development_preliminary_seed1/<arm>/seed_1001/standard_results/
```

The standard directory contains:

```text
candidates.parquet
elites.parquet
archive_snapshots.parquet
per_generation_metrics.parquet
per_problem_metrics.parquet
descriptor_vectors.parquet
netlist_hashes.parquet
method_summary.json
run_manifest.json
```

## Common Audit Space

The seed-1 artifact pass uses a fixed post-hoc common audit archive for all
arms:

- axes: `motif_logic_ratio`, `motif_control_ratio`,
  `motif_arith_ratio`, `motif_diversity`
- bins per axis: 4
- total cells per problem: 256
- cell id prefix: `audit_motif4:`

This audit space is not the internal descriptor for every method. It is the
fixed cross-method diversity surface required by the controlling plan.

## Seed-1 Summary

| Arm | Candidates | Valid PPA | Unique Netlists | Unique Motifs | Audit Cells | Audit QD |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `classic_revolution` | 288 | 209 | 70 | 43 | 12 | 2.3163 |
| `landing_smooth_qd_manual_bd` | 288 | 219 | 61 | 33 | 9 | 1.8526 |
| `random_descriptor_qd` | 288 | 213 | 64 | 41 | 8 | 1.7008 |
| `simple_yosys_stat_bd` | 288 | 201 | 62 | 45 | 11 | 2.0779 |
| `netlist_motif_occupancy` | 288 | 192 | 64 | 37 | 8 | -3.0274 |
| `synthesis_trajectory_nod` | 288 | 205 | 72 | 52 | 11 | -2.0643 |
| `synthesis_trajectory_motif_nod` | 288 | 198 | 77 | 45 | 16 | 1.7144 |

## Artifact Paths

- `classic_revolution`:
  `exp/auto_bd_research/development_preliminary_seed1/classic_revolution/seed_1001/standard_results/`
- `landing_smooth_qd_manual_bd`:
  `exp/auto_bd_research/development_preliminary_seed1/landing_smooth_qd_manual_bd/seed_1001/standard_results/`
- `random_descriptor_qd`:
  `exp/auto_bd_research/development_preliminary_seed1/random_descriptor_qd/seed_1001/standard_results/`
- `simple_yosys_stat_bd`:
  `exp/auto_bd_research/development_preliminary_seed1/simple_yosys_stat_bd/seed_1001/standard_results/`
- `netlist_motif_occupancy`:
  `exp/auto_bd_research/development_preliminary_seed1/netlist_motif_occupancy/seed_1001/standard_results/`
- `synthesis_trajectory_nod`:
  `exp/auto_bd_research/development_preliminary_seed1/synthesis_trajectory_nod/seed_1001/standard_results/`
- `synthesis_trajectory_motif_nod`:
  `exp/auto_bd_research/development_preliminary_seed1/synthesis_trajectory_motif_nod/seed_1001/standard_results/`

## Interpretation Notes

- This is a seed-1 development artifact index, not a final method result.
- Gate 0 remains the first hard filter; all listed arms passed the current
  development seed-1 Gate 0 check against classic REvolution.
- Audit QD is computed in the fixed motif audit space above. It should be
  interpreted with valid-PPA coverage, canonical-netlist uniqueness,
  motif-signature uniqueness, and later PPA/hypervolume reports.
- The collector merges classic REvolution candidate fitness from
  `generation_log.jsonl` `population_ppa_details`, because classic logs do
  not emit QD archive events.
- `synthesis_trajectory_motif_nod` is an ST-NOD ablation, not a promoted
  seed-3 arm. Its accept/reject decision lives in
  `auto_bd_methods/03_synthesis_trajectory_nod/hybrid_ablation_accept_reject.md`.
