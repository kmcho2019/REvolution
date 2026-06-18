# ST-NOD Motif-Trajectory Hybrid Seed-1 Ablation

Status: generated from the seed-1 development run and centralized
hybrid-ablation report.

## Source

- Method arm: `synthesis_trajectory_motif_nod`
- Descriptor profile: `stnod_motif_trajectory_9d`
- Run root:
  `exp/auto_bd_research/development_preliminary_seed1/synthesis_trajectory_motif_nod/seed_1001`
- Standard result root:
  `exp/auto_bd_research/development_preliminary_seed1/synthesis_trajectory_motif_nod/seed_1001/standard_results`
- Central report:
  `../../auto_bd_seed1_hybrid_ablation_report.md`
- Gate 0 artifact:
  `../../auto_bd_gate0_coverage_seed1_synthesis_trajectory_motif_nod.json`

## Gate 0

| Metric | Value |
| --- | ---: |
| Gate 0 | PASS |
| Covered classic problems | 6 |
| Missing classic problems | 0 |

## Seed-1 Summary

| Metric | Value |
| --- | ---: |
| Candidates | 288 |
| Valid PPA candidates | 198 |
| Valid PPA rate | 68.75% |
| Mean best fitness | 0.2380 |
| Fitness W/T/L vs classic | 0/5/1 |
| Mean hypervolume | 0.1204 |
| Hypervolume W/T/L vs classic | 0/5/1 |
| Unique canonical netlists | 77 |
| Unique motif signatures | 45 |
| PPA-front unique netlists | 20 |
| Common-audit occupied cells | 16 |
| Common-audit QD score | 1.7144 |
| Runtime seconds | 3322.35 |
| LLM API calls | 576 |

## Motif-Only / Trajectory-Only Comparison

| Method | Valid PPA | Mean Fitness | Mean HV | Unique Netlists | Unique Motifs | Audit Cells | Audit QD |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `netlist_motif_occupancy` | 192 | 0.2350 | 0.0606 | 64 | 37 | 8 | -3.0274 |
| `synthesis_trajectory_nod` | 205 | 0.2511 | 0.1208 | 72 | 52 | 11 | -2.0643 |
| `synthesis_trajectory_motif_nod` | 198 | 0.2380 | 0.1204 | 77 | 45 | 16 | 1.7144 |

The hybrid improves common-audit coverage and unique canonical netlists,
but it does not improve seed-1 PPA/HV over the trajectory-only ST-NOD arm.
It is therefore a useful diversity ablation, not a better promoted
candidate.
