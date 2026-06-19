# VQ Implementation Codebook Decision

Decision: reject `sr_vq_codebook_qd` as a seed-3 promotion candidate;
keep it as a documented VQ/codebook ablation.

## Evidence

- Seed-1 development Gate 0: pass.
- Covered problems: 6.
- Missing classic-covered problems: 0.
- Valid PPA: 174/288 versus 209/288 for classic REvolution.
- Valid-PPA rate delta versus classic: -15.62 percentage points.
- Functionality/synthesis/OpenROAD rate delta versus classic:
  -15.62 percentage points.
- Mean best fitness: 0.2105 versus 0.2671 for classic.
- Fitness W/T/L versus classic: 0/5/1.
- Mean hypervolume: 0.1110 versus 0.1245 for classic.
- Hypervolume W/T/L versus classic: 1/3/2.
- Fixed PPA-grid coverage: 0.0599 versus 0.0703 for classic.
- PPA-front unique netlists: 13 versus 12 for classic.
- Unique canonical netlists: 45 versus 70 for classic.
- Unique motif signatures: 30 versus 43 for classic.
- Common-audit occupied cells: 9 versus 12 for classic.
- Common-audit QD score: 0.8485 versus 2.3163 for classic.
- Method report: `seed1_artifact_report.md`.
- Coverage artifact:
  `../../auto_bd_gate0_coverage_seed1_sr_vq_codebook_qd.json`.
- Centralized report: `../../auto_bd_seed1_centralized_report.md`.

## Rationale

The method satisfies the hard coverage gate, so the fixed codebook does
not completely break repair/PPA coverage on any development problem.
However, it fails the seed-1 robustness gate by a wide margin. The
15.62 percentage-point drop in functionality, synthesis, OpenROAD, and
valid-PPA rates is too large to justify seed-3 compute.

The diversity story is also weak. PPA-front unique netlists improve only
slightly, while unique canonical netlists, motif signatures,
common-audit occupied cells, common-audit QD score, mean best fitness,
and mean hypervolume all regress versus classic REvolution.

## Next Use

Keep the implementation and fitting artifact as a VQ/codebook ablation.
Do not run seed-3 for `sr_vq_codebook_qd` under the current evidence.
If revisiting codebooks later, require a new method card with a concrete
hypothesis for avoiding the large robustness drop before launching more
compute.
