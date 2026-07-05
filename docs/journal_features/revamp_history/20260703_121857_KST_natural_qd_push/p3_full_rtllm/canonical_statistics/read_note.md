# Canonical Statistics Read Note (2026-07-04)

`scripts/report_journal_statistics.py`, 5 seed pairs, V2 vs the reused
classic roots, gate-profile none. Scope caveat: the loader pairs ALL 50
RTLLM problems (250 problem-seed units), i.e. it INCLUDES the four
missing-reference designs the 46-scoped verdict excludes — this run
complements, not replaces, `../five_seed_verdict.md`; both reads agree.

Key rows (treatment minus baseline, cluster-bootstrap CIs):

- hypervolume: +0.0035, CI [-0.0089, +0.0210], 45W/48L/157T, p=0.84 —
  canonical confirmation of HV PARITY (the +5% gate form is a log-ratio
  on the reference set; nothing here approaches it, consistent with the
  verdict).
- functional_any_pass: +0.020, CI [-0.004, +0.048], 8W/3L non-tied —
  the coverage/functionality edge in canonical form.
- valid_ppa_any_pass: +0.012, 5W/2L — same direction.
- best_quality / avg_ppa_improvement penalized means (-0.54 / -0.35)
  are dominated by 2 missing-treatment units imputed at the metric
  floor (the frozen penalization rule); complete-case deltas are
  +0.038 / +0.226 with 47% win rates — the honest statement is
  "penalized-gate negative on 2 lost units, complete-case neutral",
  and the 2 lost units are the per-unit flip side of V2's net +2
  coverage (different specific designs lost/gained per seed).

Disposition: the P4 canonical-statistics obligation (todo checkbox;
review action) is discharged; the interim contract-form log-ratio in
the verdict remains the 46-scoped reference-complete read, and both
are cited together in the central report.

## Branch-B utility metric (added 2026-07-04)

Computed by the tracked `scripts/report_branch_b_utility.py` (frozen
definition; canonical dominates() semantics; QD-only-covered units
count, per the note in the script docstring):

- **V2: 0.413 (95/230 units; 91 nondominated-improving + 4 QD-only)**
- **N03b: 0.391 (90/230; 89 + 1)**

Both clear the contract's >=0.25 utility bar by wide margins. Branch B
itself stays unreachable (its HV log-ratio leg failed), but this is
the campaign's strongest full-scale positive: on two of every five
units the QD archive offers a valid, non-dominated ALTERNATIVE design
improving at least one PPA axis over classic's best — the concrete,
contract-defined content of the diversity contribution (criticism #5),
delivered at HV parity with a coverage edge.

## Scope-sign note (2026-07-04, adversarial-validation addendum)

The canonical 50-problem HV delta (+0.0035) owes its POSITIVE sign
entirely to the four missing-reference designs the 46-scoped verdict
excludes (Prob013_multi_booth's 0.876 jackpot, which V2 wins in 3/5
seeds, contributes +0.0035 of the mean by itself). Restricted to the
common 230-unit 46-scope, the same paired_deltas.csv yields -0.0050,
exactly matching the packaged tables (0.098801 - 0.103802). Parity is
unaffected (both CIs straddle zero), but any citation of the canonical
delta must carry this scope note.

## Canonical gate-profile run (2026-07-04, punch-list item 3)

`report_journal_statistics.py --gate-profile reference_ppa` over the
five P3 pairs now records the frozen-gate outcome canonically:
**gate(reference_ppa): FAIL** (`gate_profile/statistical_tests.{md,
json}`), superseding the interim log-ratio implementation as the
citable gate evidence. Scope caveat unchanged (50-problem pairing;
the frozen gates nominally target the held-out reference set, which
is scoped out) — the canonical FAIL, the interim FAIL, and the
46-scope arithmetic all agree in direction.

Precision addendum: the canonical gate table's 50-scope log-ratio MEAN
(0.2698) clears the 0.0488 bar while its CI-low (-0.4981) fails it —
versus the interim 46-scope mean of +0.0298. The mean's scope
sensitivity is the multi_booth/epsilon effect documented above; the
gate outcome (FAIL, CI-low < 0) is identical under every computation.

Clarifier: `bootstrap_seed=42` in statistical_tests.json is the
canonical script's RESAMPLING RNG seed (its CLI default), not an
experiment seed — the banned debug seed 42 rule applies to live runs
only.
