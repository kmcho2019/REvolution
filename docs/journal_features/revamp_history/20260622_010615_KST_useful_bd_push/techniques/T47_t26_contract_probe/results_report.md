# T47 T26 Contract Probe Results

Status: hard/tuning packaged; diagnostic.

## Current Decision

`diagnostic_t26_not_holdout_ready`.

T47 is completed diagnostic evidence, not positive final evidence. It exists to
make the next T26-family experiment answer the strongest current objections:

- default-reference `Prob040_synchronizer` cannot carry a headline HV win;
- paired HV must not be net-negative after default-reference quarantine;
- `best_score` must be reported beside HV and front counts;
- family-proxy/front-netlist counts cannot be treated as independent wins when
  they equal the PPA-front count.

## Pre-Run Table Check

`probe_problem_matrix.csv` contains 92 planned rows for the hard/tuning and
held-out phases. All 92 rows have `reference_available`. The known repaired
default-reference problems in `default_reference_quarantine.csv` are not in
the T47 probe, so the planned screen avoids the `Prob040_synchronizer`
headline-reference failure mode from the one-seed RTLLM package.

## Preflight Check

`preflight_models_20260622_203146_UTC.json` records the local vLLM endpoint at
`20.0.0.103:8000`. The endpoint reports `openai/gpt-oss-120b` with
`max_model_len=131072`, so the planned 128k token budgets are valid.

## Hard/Tuning Run Status

`classic_revolution` seed `1001` completed with return code `0` at
`2026-06-22T20:57:52Z`. It produced 13 of 13 expected problem summaries under
`exp/useful_bd_push/t47_t26_contract_probe_20260622_203146_UTC/hard_tuning/`.
`classic_revolution` seed `1002` completed with return code `0` at
`2026-06-22T21:52:23Z` and produced 13 of 13 expected problem summaries.
`sr_raw_conservative_exploit_qd` seed `1001` completed with return code `0` at
`2026-06-22T21:26:45Z` and produced 13 of 13 expected archive summaries.
`sr_raw_conservative_exploit_qd` seed `1002` completed with return code `0` at
`2026-06-22T22:20:55Z` and produced 13 of 13 expected archive summaries.

The matched two-seed hard/tuning run passed:

```bash
uv run python scripts/validate_pareto_front_run.py \
  --run-root exp/useful_bd_push/t47_t26_contract_probe_20260622_203146_UTC/hard_tuning \
  --subset-config data/configs/hard_iteration_subset.yaml \
  --classic-mode classic_revolution \
  --pareto-qd-mode sr_raw_conservative_exploit_qd \
  --require-full-subset
```

## Hard/Tuning Package Result

The package lives in `hard_tuning_package/`. It compares two matched seeds
across 13 hard/tuning problems and keeps RTLLM and VerilogEval rows visible.

Headline deltas for exact T26 QD versus classic:

- mean HV delta: `-0.015483`;
- mean HV-AUC delta: `-0.018435`;
- mean best-score delta: `+0.024728`;
- valid-PPA candidates: `428` versus `538`;
- total PPA-front points: `53` versus `61`;
- classic-covered valid-PPA losses: `0`;
- yield warnings: `4`;
- small-n labels: `4`.

This does not clear the T47 hard/tuning gate for a held-out exact-T26 launch.
The positive best-score movement is useful, but it is not enough to override
negative paired HV/HV-AUC and lower valid-PPA yield. The front-count evidence
is mixed: mean relative per-problem front delta is positive, but aggregate
front points are lower because losses concentrate on larger-front problems.

## Completion Gate

Do not assign a T1 or higher tier. Exact T26 should not move directly to the
held-out dry run from this package.

## Follow-Up If It Fails

Specify a narrower T26.1 variant or return to a different lane with a recorded
reason in `technique_lanes.md`. The next variant should preserve the aggregate
best-score gain while directly targeting valid-PPA yield and HV/HV-AUC
retention.
