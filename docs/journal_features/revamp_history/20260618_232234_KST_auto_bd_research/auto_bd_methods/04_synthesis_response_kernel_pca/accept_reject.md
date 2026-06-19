# Synthesis-Response Kernel PCA Decision

Decision: reject `sr_raw_pca_qd` as the selected final method. Reject
`sr_random_relu_pca_qd` after seed-3 screening as a selected final
method.

Current status: seed-1 development evaluated for `sr_raw_pca_qd` and
`sr_random_relu_pca_qd`; seed-3 main screening evaluated for
`sr_random_relu_pca_qd`.

## Raw PCA Evidence

- Seed-1 development Gate 0: pass.
- Covered problems: 6.
- Missing classic-covered problems: 0.
- Valid PPA: 209/288, equal to classic REvolution.
- Valid-PPA rate delta versus classic: 0 percentage points.
- Mean best fitness: 0.2404 versus 0.2671 for classic.
- Fitness W/T/L versus classic: 0/5/1.
- Mean hypervolume: 0.1208 versus 0.1245 for classic.
- Hypervolume W/T/L versus classic: 1/4/1.
- Unique canonical netlists: 74 versus 70 for classic.
- Unique motif signatures: 48 versus 43 for classic.
- PPA-front unique netlists: 14 versus 12 for classic.
- Common-audit occupied cells: 12, equal to classic.
- Common-audit QD score: 1.9663 versus 2.3163 for classic.
- Method report: `seed1_artifact_report.md`.
- Coverage artifact:
  `../../auto_bd_gate0_coverage_seed1_sr_raw_pca_qd.json`.
- Centralized report: `../../auto_bd_seed1_centralized_report.md`.

Decision: reject as a selected final method; keep as the first projected
synthesis-response baseline.

Reason: Gate 0 passes and diversity improves modestly, but PPA/HV does
not improve over classic and PPA-front unique-netlist uplift is only
about 16.7 percent, below the 20 percent target.

## Random ReLU PCA Evidence

- Seed-1 development Gate 0: pass.
- Covered problems: 6.
- Missing classic-covered problems: 0.
- Valid PPA: 197/288 versus 209/288 for classic REvolution.
- Valid-PPA rate delta versus classic: -4.17 percentage points.
- Mean best fitness: 0.2536 versus 0.2671 for classic.
- Fitness W/T/L versus classic: 1/4/1.
- Mean hypervolume: 0.1454 versus 0.1245 for classic.
- Hypervolume W/T/L versus classic: 2/3/1.
- Unique canonical netlists: 68 versus 70 for classic.
- Unique motif signatures: 44 versus 43 for classic.
- PPA-front unique netlists: 11 versus 12 for classic.
- Common-audit occupied cells: 10 versus 12 for classic.
- Common-audit QD score: 2.3765 versus 2.3163 for classic.
- Method report: `sr_random_relu_seed1_artifact_report.md`.
- Coverage artifact:
  `../../auto_bd_gate0_coverage_seed1_sr_random_relu_pca_qd.json`.
- Centralized report: `../../auto_bd_seed1_centralized_report.md`.

Decision: seed-1 promoted to seed-3 screening only.

Reason: the result passes the hard coverage gate, keeps valid-PPA drop
within the 5 percentage-point seed-1 tolerance, avoids scalar-fitness
collapse, and improves mean HV by about 16.8 percent. It is not a final
candidate because PPA-front unique netlists regress, common-audit
coverage regresses, and valid-PPA count drops by 12 candidates.

Seed-3 promotion condition: retain Gate 0 coverage and HV/PPA-quality
uplift while recovering diversity. If PPA-front unique netlists or
common-audit coverage remain below classic, frame ReLU PCA as a PPA/HV
ablation rather than the selected Auto-BD method.

## Random ReLU PCA Seed-3 Evidence

- Seed-3 Gate 0: pass, 3/3 seeds, 13/13 classic-covered problems each
  seed.
- Average valid PPA: 635.3/1560 versus 735.0/1560 for classic.
- Valid-PPA rate delta versus classic: -6.39 percentage points.
- Mean best fitness: 0.2691 versus 0.2776 for classic.
- Fitness W/T/L versus classic: 4/31/4.
- Mean hypervolume: 0.1222 versus 0.1202 for classic.
- Hypervolume W/T/L versus classic: 8/20/11.
- PPA-front unique netlists: 58.0 versus 54.0 for classic.
- Unique canonical netlists: 300.0 versus 323.7 for classic.
- Unique motif signatures: 217.7 versus 239.3 for classic.
- Common-audit occupied cells: 38.0 versus 39.3 for classic.
- Common-audit QD score: 8.0503 versus 8.0494 for classic.
- Centralized reports:
  `../../auto_bd_seed3_seed1001_centralized_report.md`,
  `../../auto_bd_seed3_seed1002_centralized_report.md`, and
  `../../auto_bd_seed3_seed1003_centralized_report.md`.
- Aggregate report: `../../auto_bd_seed3_screening_report.md`.

Decision: reject as the selected final method and do not promote to
seed-5 final evaluation.

Reason: Gate 0 still passes, but the seed-3 sign-off bar is not met.
The valid-PPA rate drop exceeds 5 percentage points, mean fitness is
lower than classic, HV improves by only about 1.6 percent rather than the
predeclared 5 percent target, and diversity recovery is too small:
PPA-front unique netlists improve by about 7.4 percent, below the 20
percent target, while unique canonical netlists and common-audit cells
regress.

## Remaining Evidence

- `ANHV@1.5`.
- Learned-BD scatter and descriptor/PPA correlation plots.
- Fixed PPA-grid coverage/occupancy reporting.

## Acceptance Bar

Future projected methods are final candidates only if they:

- covers every classic-covered problem,
- has valid-PPA rate drop <= 5 percentage points versus classic,
- avoids scalar fitness collapse,
- improves strict HV or `ANHV@1.5` by at least 5 percent paired versus
  classic, or gives a documented comparable PPA-quality gain,
- improves Pareto-front unique netlists by at least 20 percent,
- holds at seed-3 before any seed-5 final run.

If it improves diversity while losing too much PPA or repair robustness,
keep it as an ablation rather than the selected journal method.

## Next Use

Use `sr_random_relu_pca_qd` as an ablation. Do not run seed-5 for it
under the current evidence. If compute permits, try `sr_rff_pca_qd` only
as a kernel control after fixed PPA-grid reporting is available and keep
the same fitting/leakage rules.
