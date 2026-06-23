# T50 Results Report

Status: seed `1001` partially completed and packaged.

Tier: `T0 diagnostic_rejected_for_promotion`.

T50 tested whether T49's thought-only role separation could recover PPA-front
material after restoring the visible evaluated-code candidate budget and
widening the per-cell Pareto cap. It did not. T50 has the best mean best-score
value among the T47-T50 QD variants on the completed 12-problem subset, but it
loses the primary QD metrics: HV, HV-AUC, valid-PPA count, unique PPA points,
and reference-beating candidates.

## Run Audit

- Run root:
  `exp/useful_bd_push/t50_candidate_matched_thought_front_20260623_020738_UTC/hard_tuning`
- vLLM preflight accepted `openai/gpt-oss-120b` with
  `max_model_len=131072`.
- Planned screen: 13 hard/tuning problems from the T47 surface.
- Completed screen: 12 problems. `VerilogEval-Spec-to-RTL/Prob153_gshare`
  did not produce a problem directory.
- The run produced archive artifacts and generation logs, but missed final
  per-problem summary files for most completed problems. The package therefore
  derives the small summary subset needed for tables from `generation_log.jsonl`
  without editing raw run artifacts.
- Packaged comparison:
  `hard_tuning_package/`

## Seed 1001 Metrics

The table below compares the completed 12-problem subset against the matched
classic root. It excludes `Prob153_gshare`.

| Metric | Classic | T50 | Delta |
| --- | ---: | ---: | ---: |
| Mean HV | 0.100303 | 0.073617 | -0.026686 |
| Mean HV-AUC | 0.088848 | 0.059753 | -0.029095 |
| Mean best score | 0.237868 | 0.301301 | +0.063433 |
| Valid PPA candidates | 244 | 156 | -88 |
| PPA-front points | 26 | 18 | -8 |
| Unique PPA points | 79 | 47 | -32 |
| Reference-beating candidates | 45 | 26 | -19 |

Gate checks:

- Classic-covered valid-PPA losses: `0`.
- Yield warnings: `10`.
- Generated candidates: classic `576`, T50 `336`.
- Observed counters from latest QD snapshots: `44` thoughts, `132` code
  samples, `0` success-parent requests, and `0` two-parent attempts.

## T47-T50 Family Comparison

On the same 12 completed problems:

- T50 has the highest mean best score (`0.301301`), slightly above T49
  (`0.295131`).
- T50 loses mean HV to T47, T48, and T49 by `20.6%`, `24.2%`, and `21.8%`.
- T50 loses HV-AUC to T47, T48, and T49 by `8.5%`, `27.3%`, and `33.7%`.
- T50 loses valid-PPA count to T47, T48, and T49 by `55`, `54`, and `65`
  candidates.
- T50 has one more front point than T49, but loses unique PPA points by `24`;
  that is not a meaningful front-recovery win.

Tables:

- `tables/t50_family_comparison_12_problem_subset.csv`
- `tables/t50_family_deltas_12_problem_subset.csv`

## Visuals

- Direct supplement:
  `visualizations/direct_ppa_pareto/index.html`
- Screenshot:
  `visualizations/direct_ppa_pareto/screenshot.png`
- Source figures:
  `hard_tuning_package/figures/`

Manual inspection found the HTML supplement readable and coherent. The figures
make the main blocker visible: T50's best-score improvement is not accompanied
by broader PPA-front material.

## Phase 03.1 Viewer

The full Phase 03.1 `qd_ppa_viewer/` bundle is not exported for T50 because
the live run is incomplete and missed final summary artifacts. The direct raw
PPA supplement is included as the reader-facing visualization.

## Conclusion

T50 answers the immediate T49 follow-up: visible candidate-budget restoration
and wider per-cell Pareto retention do not rescue the thought-only
role-separated emitter. T50 should not receive seed `1002`, held-out spend, or
full RTLLM launch. The useful signal is narrower: role-separated thought
generation can improve best-score pressure, but it needs a different mechanism
for valid-yield and front preservation before it can support a QD/MAP-Elites
effectiveness claim.
