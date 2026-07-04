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
