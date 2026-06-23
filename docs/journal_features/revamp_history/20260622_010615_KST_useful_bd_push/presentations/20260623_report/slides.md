# Useful Diversity For RTL PPA Evolution

## Slide 1 - The Question

- Does diversity matter for RTL/Verilog evolution?
- Which diversity matters?
- Can QD/MAP-Elites improve PPA-centered search versus classic REvolution?

## Slide 2 - Short Answer

- Not proven yet; the current status is diagnostic.
- Exact T26 QD passes the PPA-first retention gate on full RTLLM.
- It adds PPA-front points, but paired HV is net-negative.
- The aggregate HV win depends on defaulted-reference `Prob040_synchronizer`.

## Slide 3 - Terms

- BD: behavior descriptor used to place candidates in a QD archive.
- QD/MAP-Elites: keep strong candidates across behavior regions.
- PPA: power, area, and timing when reference timing exists; lower is better.
- Valid PPA: candidate with usable synthesis/PPA metrics.
- PPA-front point: nondominated valid PPA candidate.

## Slide 4 - Metrics And Gates

- HV: volume covered by nondominated normalized PPA improvements.
- HV-AUC: area under the HV-over-generations curve.
- Classic-covered problem: classic has at least one valid PPA sample.
- Retention gate: QD must also have at least one valid PPA sample.
- Yield warning: at least 50% count drop when classic has 10 or more samples.

## Slide 5 - What Failed

- Identifier-heavy embeddings cluster by corpus artifacts.
- Random or weak descriptors can look broad without improving PPA.
- Aggressive local Pareto archives can disrupt hill climbing.
- Sparse graph axes can create archive sparsity and yield loss.

## Slide 6 - Retrospective Scale

- ASP-DAC release archive: 170057 candidates, 90058 valid PPA artifacts.
- Auto-BD controls: 23400 candidates, 10343 valid PPA artifacts.
- RTLLM gen-20 history: 10413 candidates, 2335 valid PPA artifacts.
- Retrospective verdict: interpretable diversity, not active utility.

## Slide 7 - Retrospective Takeaway

- Early lexical diversity vs final HV: rho 0.300, uncontrolled.
- Multi-cluster fronts: 48.8%, below shuffled labels at 56.0%.
- Best diversity replay HV gain over best-fitness retention: 1.35%.
- Qwen common-audit replay: +3.35% HV vs lexical, diagnostic only.

## Slide 8 - What Worked Best

- Synthesis-response raw descriptors capture implementation response.
- Pareto-front archive cells preserve alternate PPA tradeoffs.
- T26 keeps champion-style exploit pressure active.
- This is QD plus quality pressure, not novelty alone.
- This does not isolate descriptor-only causality.

## Slide 9 - Full RTLLM Setup

- Benchmark: all 50 RTLLM problems.
- Seed and budget: seed 1001, population 12, generations 3.
- Model: local `openai/gpt-oss-120b`, 128k token budgets.
- Classic: `classic_revolution` with `eoh_strategies`.
- QD: exact T26, `sr_raw_conservative_exploit_qd`.

## Slide 10 - PPA-First Gate

- Hard gate: no classic-covered design loss.
- If classic has at least one valid PPA sample, QD must also have one.
- Functionality and valid-PPA rate drops are visible warnings.
- This fits the milestone goal: optimize PPA while preserving design coverage.

## Slide 11 - Headline Result

| Metric | Classic | Exact T26 QD | Delta |
| --- | ---: | ---: | ---: |
| Mean HV | 0.094435 | 0.104997 | +0.010562 |
| Mean HV-AUC | 0.080956 | 0.093353 | +0.012397 |
| Mean best score | 0.260455 | -0.798824 | -1.059279 |
| Valid PPA | 1056 | 879 | -177 |
| PPA-front points | 61 | 69 | +8 |

Screen-excluded still includes `Prob040`; excluding both screen problems and
`Prob040` flips mean HV delta to `-0.006927`.

## Slide 12 - Budget Parity

| Metric | Classic | Exact T26 QD |
| --- | ---: | ---: |
| Generated candidates | 2400 | 2400 |
| LLM API calls | 4801 | 4800 |
| Mean calls/problem | 96.02 | 96.00 |
| Runtime seconds | 83328.15 | 84516.21 |

## Slide 13 - Gate Result

- Hard retention failures: 0.
- Yield warnings: 4.
- Small-n labels: 6.
- `Prob006_adder_pipe_64bit` has no valid PPA in either arm.

## Slide 14 - Why This Is Not Overclaiming

- Per-problem HV: 4 QD wins, 15 losses, 31 ties.
- Per-problem HV-AUC: 5 QD wins, 16 losses, 29 ties.
- The aggregate HV win is strongly affected by `Prob040_synchronizer`.
- Without `Prob040`, mean HV delta is -0.009465.
- QD has fewer unique PPA points: 318 versus 352.
- Family-proxy front count matches front-point count: 69 versus 61.
- But QD has fewer summed family proxies: 311 versus 341.
- QD also has fewer reference-beating family proxies: 129 versus 179.

## Slide 15 - Visual Reading Path

- HV scatter: paired per-problem direction and outlier dependence.
- Win/loss heatmap: where QD wins, loses, or ties by problem.
- Validity funnel: the yield cost behind the front-point signal.
- Front counts and raw PPA fronts: whether extra front material is visible.

## Slide 16 - Answer The Two Questions

- Does diversity matter?
- Not proven by this one-seed package.
- Which diversity matters?
- A T26-style implementation-response archive bundle with quality pressure.
- Which diversity does not suffice?
- Lexical, random, sparse, or unguarded novelty.

## Slide 17 - Decision

- Continue only as a controlled T26-family follow-up.
- Present the result as diagnostic one-seed engineering evidence.
- Do not claim useful-QD or seed-stable significance yet.
- Next: multi-seed replication and T26.1 variants that reduce yield loss.

## Backup - Glossary Location

- Full terminology reference: `glossary.md`.
- Recommended figures: funnel, front counts, HV scatter, and PPA fronts.
- Generated tables: `full_rtllm/tables/`.
- Raw candidate PPA data: `full_rtllm/data/full_ppa_candidates.csv`.
- Full Phase 03.1 viewer: `full_rtllm/visualizations/qd_ppa_viewer/`.
- Direct raw PPA supplement: `full_rtllm/visualizations/direct_ppa_pareto/`.
- Full family-proxy audit: `full_rtllm/family_audit/`.
