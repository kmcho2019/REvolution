# Useful Diversity For RTL PPA Evolution

## Slide 1 - The Question

- Does diversity matter for RTL/Verilog evolution?
- Which diversity matters?
- Can QD/MAP-Elites beat classic REvolution on PPA-centered metrics?

## Slide 2 - Short Answer

- Diversity is useful only when it is implementation-aware.
- Naive diversity often preserves novelty while losing valid PPA or quality.
- The best current lead is T26-family SR raw QD with conservative exploit
  pressure, currently `T1 near_classic`.

## Slide 3 - What Failed

- Identifier-heavy embeddings cluster by problem/corpus artifacts.
- Random or weak descriptors can look broad without improving PPA.
- Aggressive local Pareto archives can disrupt hill climbing.
- High-dimensional graph axes can create archive sparsity and yield loss.

## Slide 4 - What Worked Best So Far

- SR raw descriptors capture non-PPA implementation response.
- Local Pareto archive material is useful when champion pressure remains.
- T26 restores hill-climbing pressure while preserving QD archive behavior.
- T27/T30 provide the current near-classic support.
- T28 still warns that exact T26 loses front-family breadth versus classic.

## Slide 5 - Why Full RTLLM Is Needed

- Three-problem screens are not enough for colleagues or reviewers.
- RTLLM has 50 benchmark problems from `bench/RTLLM/*_prompt.txt`.
- We need paired, same-budget classic versus QD evidence across the suite.

## Slide 6 - Experiment Design

- Classic arm: REvolution baseline with `eoh_strategies`.
- QD arm: selected T26-family variant after screening.
- Budget: seed 1001, population 12, generations 3.
- Model: `openai/gpt-oss-120b`, 128k token budgets.
- Metrics: HV, HV-AUC, valid-PPA yield, front/family breadth, archive metrics.

## Slide 7 - Screening Before Full Run

- Exact T26 is the fallback.
- T26.1 low-fusion tests `qd_two_parent_probability=0.10`.
- Gated T26.1 is allowed only after narrow code and tests.
- Selection happens before seeing full RTLLM results.

## Slide 8 - Presentation Figures

- Paired HV delta distribution.
- HV-AUC delta distribution.
- Win/loss heatmap.
- Valid-PPA funnel.
- Classic-vs-QD HV scatter.
- Representative raw area-power Pareto fronts.

## Slide 9 - Claim Guardrails

- No average-fitness-only claim.
- No invalid or duplicate samples counted as useful diversity.
- No hidden classic-covered design loss.
- Small-n validity rates are labeled, not overinterpreted.
- One-seed results cannot be presented as seed-stable significance.

## Slide 10 - Decision

- If T26-family wins paired PPA metrics safely: continue QD/MAP-Elites line.
- If it only wins narrow cases: report scoped usefulness.
- If it fails broadly: keep the negative map and pivot method families.
