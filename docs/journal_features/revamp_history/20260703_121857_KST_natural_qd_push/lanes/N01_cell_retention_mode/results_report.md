# N01 Cell Retention Mode — Seed-1001 Result (2026-07-03)

Runs: `exp/natural_qd_push/n01_cell_retention_20260703_053243_UTC/`
(both arms 8/8 coverage; operator contracts pass, zero single-thought,
zero M-T; config-pinned validations pass; package under `package/`).

## Read (frozen 8-design 8x5, seed 1001; comparators from the anchor)

| Arm | Cell retention | Mean HV | vs classic | vs V2 | Pareto pts |
| --- | --- | --- | --- | --- | --- |
| classic | population (no archive) | 0.14064 | - | -19.1% | 3.25 |
| N01b scalar_elite | 1 scalar elite/cell | 0.14683 | +4.4% | -15.5% | 3.375 |
| N01a elite_pareto_slot_2 | champion + 1 front slot | 0.15709 | +11.7% | -9.6% | 3.125 |
| V2 anchor | bounded Pareto front (<=5) | 0.17376 | +23.5% | - | 2.625 |

## Interpretation (single seed; attribution, not promotion)

- **Retention capacity is monotone in mean HV on this seed**: classic
  0.1406 -> scalar cells 0.1468 -> one front slot 0.1571 -> 5-elite
  Pareto cells 0.1738. This is the cleanest mechanism-attribution
  ladder the program has produced: archive+NSGA-II selection alone
  (+4.4%) and per-cell Pareto retention (+8.7 points more) both
  contribute; the frozen thesis's "bounded per-cell Pareto fronts
  instead of scalar replacement" carries most of the margin.
- Pareto POINTS run the other way (3.375 -> 3.125 -> 2.625): richer
  cells concentrate front mass into dominating designs rather than
  many shallow points. HV is the gate metric; breadth is reported.
- Neither arm approaches the promotion bar (>2% over V2), as expected —
  these are attribution controls, not challengers.

## Tier decision

Both arms: diagnostic keepers (attribution controls). No promotion, no
kill (both beat classic with coverage retained). Registered follow-up
(per card, only after a 3-seed read if pursued): a capacity ablation
ABOVE 5 (pareto_front, max 7) is the natural probe of where the
retention curve saturates — new card required before any launch.
Seed replication for the attribution ladder is queued behind the
challenger lanes (N06/N03/N02) on budget priority.
