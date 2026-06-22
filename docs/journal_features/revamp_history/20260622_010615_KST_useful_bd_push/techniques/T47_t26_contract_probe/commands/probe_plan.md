# T47 Probe Command Plan

Status: command plan only. Do not run final-style evidence from this file
without first recording the exact timestamped run root.

## Preflight

```bash
curl http://20.0.0.103:8000/v1/models \
  > docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T47_t26_contract_probe/tables/preflight_models_<timestamp>.json
```

## Hard/Tuning Sanity Probe

Run classic and exact T26 on the frozen hard/tuning subset for seeds `1001` and
`1002`. Use `128000` token budgets and write under:

`exp/useful_bd_push/t47_t26_contract_probe_<timestamp>/hard_tuning/`

Required comparator arms:

- `classic_revolution`
- `sr_raw_conservative_exploit_qd`

Optional arm, only after code review and focused tests:

- `t26_1_role_separated_conservative_exploit_qd`

## Held-Out Dry Run

Run only after the method is frozen by the hard/tuning sanity probe. Use
`data/configs/holdout_reference_subset.yaml`, one seed, no repair/tuning, and
the same token budgets.

## Packaging Commands

After a run exists, package:

- problem/method metric table;
- default-reference quarantine table;
- direct raw area-power PPA figures;
- full Phase 03.1 `qd_ppa_viewer/` if QD archive artifacts exist;
- visual inspection notes.

The result report must not use final TCAD language until `journal_stats` gates
are run on the contract-aligned final scale.
