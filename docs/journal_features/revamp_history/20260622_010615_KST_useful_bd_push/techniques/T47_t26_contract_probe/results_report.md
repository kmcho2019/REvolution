# T47 T26 Contract Probe Results

Status: not run.

## Current Decision

`pending_pre_registered`.

T47 is a guardrail package, not completed evidence. It exists to make the next
T26-family experiment answer the strongest current objections:

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
The remaining hard/tuning arms are still pending.

## Completion Gate

Do not assign a T1 or higher tier until live artifacts prove the acceptance
signals in `methodology.md`.

## Follow-Up If It Fails

If exact T26 fails the hard/tuning sanity probe, do not launch a held-out run.
Specify a narrower T26.1 variant or return to a different lane with a recorded
reason in `technique_lanes.md`.
