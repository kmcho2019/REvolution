# Useful Diversity For RTL PPA Evolution

## Slide 1 - The Question

- Does diversity matter for RTL/Verilog evolution?
- Which diversity matters?
- Can QD/MAP-Elites improve PPA-centered search versus classic REvolution?

## Slide 2 - Short Answer

- Yes, but only for implementation-aware diversity.
- Exact T26 QD passes the PPA-first retention gate on full RTLLM.
- It improves aggregate HV, HV-AUC, and front count.
- It is not yet a broad decisive win because yield drops and outlier
  sensitivity remain.

## Slide 3 - Terms

- BD: behavior descriptor used to place candidates in a QD archive.
- QD/MAP-Elites: keep strong candidates across behavior regions.
- PPA: power, performance, and area; lower raw values are better.
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

## Slide 6 - What Worked Best

- SR raw descriptors capture implementation response.
- Pareto-front archive cells preserve alternate PPA tradeoffs.
- T26 keeps champion-style exploit pressure active.
- This is QD plus quality pressure, not novelty alone.

## Slide 7 - Full RTLLM Setup

- Benchmark: all 50 RTLLM problems.
- Seed and budget: seed 1001, population 12, generations 3.
- Model: local `openai/gpt-oss-120b`, 128k token budgets.
- Classic: `classic_revolution` with `eoh_strategies`.
- QD: exact T26, `sr_raw_conservative_exploit_qd`.

## Slide 8 - PPA-First Gate

- Hard gate: no classic-covered design loss.
- If classic has at least one valid PPA sample, QD must also have one.
- Functionality and valid-PPA rate drops are visible warnings.
- This fits the milestone goal: optimize PPA while preserving design coverage.

## Slide 9 - Headline Result

| Metric | Classic | Exact T26 QD | Delta |
| --- | ---: | ---: | ---: |
| Mean HV | 0.094435 | 0.104997 | +0.010562 |
| Mean HV-AUC | 0.080956 | 0.093353 | +0.012397 |
| Valid PPA | 1056 | 879 | -177 |
| PPA-front points | 61 | 69 | +8 |

## Slide 10 - Gate Result

- Hard retention failures: 0.
- Yield warnings: 4.
- Small-n labels: 6.
- `Prob006_adder_pipe_64bit` has no valid PPA in either arm.

## Slide 11 - Why This Is Not Overclaiming

- Per-problem HV: 4 QD wins, 15 losses, 31 ties.
- Per-problem HV-AUC: 5 QD wins, 16 losses, 29 ties.
- The aggregate HV win is strongly affected by `Prob040_synchronizer`.
- QD has fewer unique PPA points: 318 versus 352.

## Slide 12 - Answer The Two Questions

- Does diversity matter?
- Yes, enough to continue the QD/MAP-Elites line.
- Which diversity matters?
- Implementation-response diversity with quality-safe champion pressure.
- Which diversity does not suffice?
- Lexical, random, sparse, or unguarded novelty.

## Slide 13 - Decision

- Continue the QD/MAP-Elites research direction.
- Present the result as reviewable one-seed engineering evidence.
- Do not claim seed-stable significance yet.
- Next: multi-seed replication and T26.1 variants that reduce yield loss.

## Backup - Glossary Location

- Full terminology reference: `glossary.md`.
- Generated tables: `full_rtllm/tables/`.
- Raw candidate PPA data: `full_rtllm/data/full_ppa_candidates.csv`.
