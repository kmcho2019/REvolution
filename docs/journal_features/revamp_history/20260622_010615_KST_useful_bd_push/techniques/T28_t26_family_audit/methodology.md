# T28 T26 Family Audit Methodology

Status: completed canonical/family audit package for the T26 active lead.

## Purpose

T28 answers the duplicate-accounting gap left by T27. T27 showed that T26
beats classic on live HV, HV-AUC, and best score, but it could only count
unique PPA tuples. T28 checks whether those live candidates represent distinct
RTL and synthesized-netlist implementations or whether the apparent diversity
is mostly duplicate code.

T28 is an audit package, not a new behavior descriptor and not a new live run.
It reads completed live artifacts under `exp/useful_bd_push/` and writes tables
and figures under this technique directory.

## Source Runs

| Source | Methods |
| --- | --- |
| `t24_sr_pareto_live_validation_20260621_184346_UTC` | Classic, manual BD, random descriptor, SR raw PCA QD. |
| `t25_guarded_sr_raw_pareto_qd_20260621_210402_UTC` | Guarded SR raw Pareto QD. |
| `t26_sr_raw_conservative_exploit_qd_20260621_213249_UTC` | Conservative exploit SR raw QD. |

The audit uses the same fixed three-problem development screen as T24-T27:

- `Prob045_alu`
- `Prob041_traffic_light`
- `Prob015_multi_pipe_8bit`

## Definitions

`RTL hash`: SHA-256 of `code.sv` after removing comments and collapsing
whitespace.

`Netlist hash`: SHA-256 of `code.syn.v` after the same text normalization.

`Family hash`: SHA-256 of a synthesized-Verilog cell-type histogram, for
example `AND2_X1:31|INV_X1:52|MUX2_X1:8`. This is a structural family proxy,
not a formal graph-isomorphism proof.

`Front family`: a distinct family hash among candidates on the candidate-level
PPA Pareto front.

## Algorithm

`scripts/package_t28_t26_family_audit.py` joins each problem's
`generation_log.jsonl` candidate IDs with the PPA rows in
`population_ppa_details`. For every valid-PPA candidate, it asserts that
`code.sv` and `code.syn.v` exist, computes RTL/netlist/family hashes, and
computes the candidate-level Pareto front from normalized PPA improvements.

This audit intentionally uses candidate-level Pareto fronts. T27 used a
deduplicated PPA-tuple front, so T27 and T28 front counts can differ when
multiple distinct implementations land on the same PPA point.

The package also builds two explicit PPA-front figures from the same candidate
table and emits a scoped Phase 03.1 `qd_ppa_viewer` bundle. The viewer compares
Classic against T26 in PPA space and uses T26's native SR-PCA archive as the
archive source. Classic is not projected into that archive because SR-PCA
coordinates are T26-native synthesis-response descriptors, not a shared
post-hoc coordinate system for classic.

## Leakage Policy

All T28 metrics are post-hoc audit metrics. They are never used as in-loop
behavior descriptors, parent-selection rewards, archive coordinates, or live
search signals.

## Limitations

The family hash is a cell-type histogram. It is stronger than a PPA-tuple
proxy, but weaker than canonical graph isomorphism over mapped netlists. A
future stronger audit can add graph-canonical hashes or motif hashes if needed.

T28 does not answer holdout behavior. It only evaluates the already-completed
development-screen live runs.

## Reproducibility

Run command:

`commands/package_family_audit.md`

Generated tables:

- `tables/family_candidate_rows.csv`
- `tables/family_problem_metrics.csv`
- `tables/family_aggregate_metrics.csv`
- `tables/family_comparison_deltas.csv`
- `tables/family_method_manifest.csv`

Generated figures:

- `figures/family_aggregate_counts.png`
- `figures/family_problem_front_counts.png`
- `figures/ppa_pareto_fronts_area_power.png`
- `figures/ppa_pareto_fronts_improvement.png`

Generated visualization:

- `visualizations/qd_ppa_viewer/index.html`
- `visualizations/qd_ppa_viewer_source/final_analysis/`
