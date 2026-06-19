# Auto-BD Seed-1 Promotion Decisions

Status: predeclared seed-3 screening decision from seed-1 development artifacts.

## Baseline MDE/Power Review

- Development problem-seed pairs: `6`
- Assessment: Seed-1 development evidence is underpowered for final claims; use only for Gate 0, robustness, and screening promotion.
- Seed-3 screening seeds: `[1001, 1002, 1003]`
- Seed-5 final preferred seeds: `[1001, 1002, 1003, 1004, 1005]`
- Effect policy: Final sign-off requires predeclared practical effect thresholds plus paired problem-seed statistics; seed-1 apparent wins are exploratory.

## Predeclared Thresholds

| Gate | Threshold |
| --- | --- |
| Gate 0 | cover every classic-covered problem; >5% problem-seed misses is high risk |
| Gate 1 | <= 5 pp drop in functionality, synthesis, OpenROAD, and valid-PPA rates |
| Gate 2 | >=10% mean fitness/HV uplift or positive fitness/HV W/L |
| Gate 3 | >=15% QD score, >=20% coverage, or >=25% unique-netlist uplift |
| Equivalence | fitness margin 0.03 |

## Promotion Decisions

| Method | Role | Gate 0 | Gate 1 | Gate 2 | Func Drop pp | Valid Drop pp | Fitness W/T/L | HV W/T/L | Decision | Reason |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `classic_revolution` | classic_baseline | PASS | PASS | PASS | 3.47 | 3.47 | 0/6/0 | 0/6/0 | RETAIN_AS_COMPARATOR | Required baseline comparator for seed-3 screening. |
| `landing_smooth_qd_manual_bd` | manual_bd_baseline | PASS | PASS | PASS | 0.00 | 0.00 | 0/5/1 | 0/4/2 | RETAIN_AS_COMPARATOR | Required baseline comparator for seed-3 screening. |
| `random_descriptor_qd` | screening_control | PASS | PASS | PASS | 2.08 | 2.08 | 0/6/0 | 2/3/1 | PROMOTE_TO_SEED3 | Passes development Gate 0, Gate 1, and Gate 2 screening gates. |
| `simple_yosys_stat_bd` | screening_control | PASS | FAIL | PASS | 6.25 | 6.25 | 0/5/1 | 1/3/2 | DO_NOT_PROMOTE | Fails Gate 1 robustness: functionality_drop is 6.25 pp. |
| `netlist_motif_occupancy` | auto_bd_method | PASS | FAIL | FAIL | 9.38 | 9.38 | 0/4/2 | 1/3/2 | DO_NOT_PROMOTE | Fails Gate 1 robustness: functionality_drop is 9.38 pp. |
| `synthesis_trajectory_nod` | auto_bd_method | PASS | PASS | PASS | 4.86 | 4.86 | 0/5/1 | 2/3/1 | PROMOTE_TO_SEED3 | Passes development Gate 0, Gate 1, and Gate 2 screening gates. |
| `synthesis_trajectory_motif_nod` | auto_bd_method | PASS | FAIL | FAIL | 7.29 | 7.29 | 0/5/1 | 0/5/1 | DO_NOT_PROMOTE | Fails Gate 1 robustness: functionality_drop is 7.29 pp. |
| `sr_raw_pca_qd` | auto_bd_method | PASS | PASS | FAIL | 3.47 | 3.47 | 0/5/1 | 1/4/1 | DO_NOT_PROMOTE | Fails Gate 2 screening signal versus classic REvolution. |
| `sr_random_relu_pca_qd` | auto_bd_method | PASS | FAIL | PASS | 7.64 | 7.64 | 1/4/1 | 2/3/1 | DO_NOT_PROMOTE | Fails Gate 1 robustness: functionality_drop is 7.64 pp. |
| `sr_rff_pca_qd` | auto_bd_method | PASS | FAIL | FAIL | 7.64 | 7.64 | 0/6/0 | 0/5/1 | DO_NOT_PROMOTE | Fails Gate 1 robustness: functionality_drop is 7.64 pp. |
| `sr_vq_codebook_qd` | auto_bd_method | PASS | FAIL | FAIL | 15.62 | 15.62 | 0/5/1 | 1/3/2 | DO_NOT_PROMOTE | Fails Gate 1 robustness: functionality_drop is 15.62 pp. |

## Seed-3 Screening Arms

- `classic_revolution`
- `landing_smooth_qd_manual_bd`
- `random_descriptor_qd`
- `synthesis_trajectory_nod`

## Source

- Central report JSON: `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_seed1_centralized_report.json`
