# H5 Technical Smoke Audit

- Date: 2026-07-20
- Reviewer: independent read-only explorer
- Review session: `019f80e8-a363-7af3-81bd-43094e71a965`
- Raw root:
  `exp/tcad_revolution_extension/h5_failed_parent_repair/wave1/smoke_seed42`
- Verdict: `PASS`

## Findings

No technical finding was identified. Fifteen classic and fourteen treatment
compilation-error messages map exactly to expected failed candidate outcomes;
they are not worker or infrastructure failures.

## Independent Checks

- Runtime snapshots differ only in `search_mode` and `save_path`.
- Every problem/arm has eight initial and eight generation-1 candidates. All 96
  IDs are unique and all required lineage and hardware-stage fields validate.
- Classic failed-parent operators are M-E 1, M-F 1, M-I 2, M-R 2, and M-S 2.
  All nine treatment failed-parent requests are M-F.
- Both arms use only the classic success set. All 31 classic and 30 treatment
  successes have complete synthesis, post-synthesis, PPA, and report artifacts.
- Treatment pool trajectories are `0/8 -> 0/8`, `8/0 -> 5/3`, and
  `1/7 -> 0/8`; each generation outcome is `completed`.
- The strict mechanism package and backend report reproduce byte-for-byte.
- Classic engine and default-config hashes remain frozen.

## Disposition

The representative probe is technically admissible. The smoke repair delta,
PPA values, and backend winner label are non-inferential and cannot promote or
retire H5.
