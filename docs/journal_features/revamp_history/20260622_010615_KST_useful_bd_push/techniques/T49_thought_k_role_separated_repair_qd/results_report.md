# T49 Results Report

Status: seed `1001` completed and packaged.

Tier: `T0 mixed_diagnostic`.

T49 tested whether thought-level role separation plus bounded sample-local
repair could recover the hard/tuning contract where T47 and T48 were weak. The
answer is mixed: T49 preserves at least one valid-PPA candidate for every
classic-covered problem and improves best score, but it loses mean HV,
valid-PPA volume, and PPA-front coverage.

## Pre-Registered Claim

The method will test whether thought-level role separation and bounded
sample-local repair can improve the T47/T48 hard/tuning contract without using
PPA, pass rate, or front labels as behavior-descriptor inputs.

## Current Tier

`T0 mixed_diagnostic`

T49 should not be promoted as a QD lead. The useful signal is diagnostic:
thought separation can improve some local best-score outcomes, but this
configuration does not maintain enough front coverage.

## Run Audit

- Run root:
  `exp/useful_bd_push/t49_thought_k_role_separated_repair_20260623_003408_UTC/hard_tuning`
- vLLM preflight accepted `openai/gpt-oss-120b` with
  `max_model_len=131072`.
- The launch uses the pre-registered T49 settings from
  `commands/hard_tuning_sanity.md`.
- Runtime: `3270.46` seconds.
- Summary:
  `thought_k_role_separated_repair_qd/seed_1001/openai_gpt-oss-120b/20260623_003433_revolution_summary_results.txt`
- Scheduler telemetry:
  `thought_k_role_separated_repair_qd/seed_1001/openai_gpt-oss-120b/20260623_003433_revolution_scheduler_telemetry.json`
- Packaged comparison:
  `hard_tuning_package/`

## Seed 1001 Metrics

| Metric | Classic | T49 | Delta |
| --- | ---: | ---: | ---: |
| Mean HV | 0.092601 | 0.086897 | -0.005704 |
| Mean HV-AUC | 0.082020 | 0.083147 | +0.001127 |
| Mean best score | 0.227928 | 0.295131 | +0.067203 |
| Valid PPA candidates | 257 | 231 | -26 |
| PPA-front points | 30 | 20 | -10 |
| Unique PPA points | 87 | 76 | -11 |
| Reference-beating candidates | 46 | 40 | -6 |

Gate checks:

- Classic-covered valid-PPA losses: `0`.
- Yield warnings: `6`.
- Generated candidates: classic `624`, T49 `465`.
- Observed thought/code sample counters: `30` thoughts and `90` code samples
  in the latest per-problem metric snapshots. These are not full repair-success
  counters.
- Success-parent requests and two-parent attempts are both `0`, as expected
  for the single-thought operator.

## Cohort Notes

- RTLLM: T49 has higher valid-PPA count (`145` versus `122`) and slightly
  higher HV-AUC, but lower mean HV, best score, front points, unique PPA
  points, and reference-beating count.
- VerilogEval-Spec-to-RTL: T49 has a large best-score lift, but loses valid-PPA
  volume and does not materially improve front coverage.

## Visuals

- Direct supplement:
  `visualizations/direct_ppa_pareto/index.html`
- Screenshot:
  `visualizations/direct_ppa_pareto/screenshot.png`
- Source package figures:
  `hard_tuning_package/figures/`

Manual inspection found the figures readable and coherent. The direct
area-power panels are sparse in several problems, which supports the diagnostic
conclusion rather than a promotion claim.

## Conclusion

T49 answers a narrow question: role-separated thought generation can preserve
basic classic coverage and improve some local best-score behavior under a
smaller generated-candidate budget. It does not show that this repair framing is
the right QD/MAP-Elites behavior descriptor or emitter. The next variant should
target front preservation directly before any larger RTLLM run.
