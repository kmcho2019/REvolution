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

## Interpretation (single-seed diagnostic signal; attribution, not promotion)

- **Retention capacity is monotone in mean HV on this seed**: classic
  0.1406 -> scalar cells 0.1468 -> one front slot 0.1571 -> 5-elite
  Pareto cells 0.1738. Read as a single-seed diagnostic signal, not a
  narrative claim (codex review action 4): at the problem level V2
  beats classic on only 3/8 designs, and the slot-2 -> V2 gain is
  concentrated in traffic_light and alu, so the ladder's shape needs
  seed replication before any paper-facing attribution statement.
  Within this seed, archive+NSGA-II selection alone (+4.4%) and
  per-cell Pareto retention (the remaining margin) both contribute.
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

Figure inspection (2026-07-05, validation-v2 obs 6): the package's
pairwise-front PNGs (`package/pareto_analysis/problems/*/
pairwise_fronts.png`) were reviewed at packaging time; fronts and
markers are legible and match the tables. Cause classes (obs 4):
N01a/N01b = attribution-control keepers, no kill class applicable.
