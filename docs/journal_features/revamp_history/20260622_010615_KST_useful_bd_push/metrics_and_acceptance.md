# Metrics And Acceptance

Average fitness and average best PPA are not primary comparison metrics for
this push. They hide the reason to use QD: finding a broader set of valid,
high-quality implementation alternatives. They may be reported as secondary
diagnostics only.

## Core Terms

- `candidate`: one generated RTL design attempt.
- `syntax-valid`: parses under the fixed frontend.
- `functional`: passes the benchmark functional test.
- `synthesis-valid`: produces a mapped netlist under the fixed synthesis flow.
- `valid-PPA`: has usable area, power, and timing metrics.
- `canonical netlist`: normalized synthesized netlist used for duplicate
  accounting.
- `BD`: behavior descriptor used for archive cell assignment.
- `active archive`: the archive used by the method during search.
- `passive archive`: a common audit archive filled after the fact by all
  methods, including classic REvolution, with identical cell definitions.
- `PPA front`: nondominated set over normalized area, power, and timing
  objectives after functional and synthesis validity.
- `candidate_ppa_missing`: a candidate did not produce usable area, power, and
  timing metrics for the evaluated method.
- `reference_ppa_missing`: the benchmark/reference `ppa.txt` is absent,
  malformed, or intentionally defaulted.
- `reference-complete paired subset`: problems where the benchmark reference
  PPA is valid and both compared methods are evaluated under the same fixed
  budget.

## Mandatory Funnels

Every result table must report counts for:

1. generated;
2. syntax-valid;
3. functional;
4. synthesis-valid;
5. valid-PPA;
6. unique canonical netlists among valid-PPA candidates;
7. Pareto-front candidates among unique valid-PPA netlists.

No method may claim useful diversity from invalid candidates, duplicate
netlists, or candidates without PPA.

## PPA Completeness Rule

Separate missing candidate PPA from missing reference PPA:

- Missing candidate PPA is counted as an invalid/non-PPA candidate for that
  method and remains visible in the funnel.
- Missing reference PPA makes that design ineligible for headline normalized
  improvement, HV, HV-AUC, and direct classic-vs-QD aggregate claims.
- Designs with missing reference PPA may appear in inventory, raw diagnostic
  plots, and appendix tables, but must be labeled `reference_missing` and
  `diagnostic_only`.

Direct classic-vs-QD claims must use the reference-complete paired subset. Do
not use defaulted reference PPA in headline aggregates.

Each new run package must include a completeness table:

| problem | classic_valid_ppa | qd_valid_ppa | reference_ppa_valid | comparison_status |
| --- | --- | --- | --- | --- |
| `Prob040_synchronizer` | yes | yes | no | `diagnostic_only` |

Use the committed helper to generate it:

```bash
uv run python scripts/report_ppa_completeness.py \
  --ppa-candidates path/to/ppa_candidates.csv \
  --reference-ppa-metrics path/to/reference_ppa_metrics.csv \
  --classic-method classic_or_classic_revolution \
  --qd-method qd_method_key \
  --reference-missing-problem RTLLM:Prob040_synchronizer \
  --output path/to/tables/ppa_completeness.csv
```

## Primary QD Metrics

Use these as the headline metrics:

- `global_ppa_hypervolume`: hypervolume of the global nondominated PPA front
  after converting area, power, and timing to normalized maximize objectives.
- `passive_archive_qd_score`: sum of nonnegative normalized quality over
  occupied cells in the same passive archive for every method.
- `passive_archive_coverage`: fraction of passive archive cells occupied by
  unique valid-PPA netlists.
- `pareto_cell_count`: number of passive archive cells containing at least one
  PPA-front candidate.
- `pareto_spread`: normalized descriptor-space spread of PPA-front candidates,
  reported with nearest-neighbor distance and convex-hull or bounding-box
  volume when dimensions permit.
- `unique_front_families`: count of distinct canonical netlist, motif, or
  codebook families represented on the PPA front.
- `valid_ppa_yield`: valid-PPA candidates per generated candidate and per wall
  clock hour.
- `retained_classic_coverage`: fraction of problems where the method preserves
  at least one classic-covered valid-PPA solution.
- `functionality_rate`: functional candidates divided by generated candidates.
- `synthesis_valid_rate`: synthesis-valid candidates divided by generated
  candidates.
- `yield_warning_min_baseline_passes`: minimum classic baseline passing
  samples needed before a relative functionality, synthesis-valid, or
  valid-PPA decline is treated as a meaningful yield warning. This push uses
  `10`.

## Secondary Metrics

Report these but do not use them alone for promotion:

- best fitness / best quality;
- mean fitness among valid-PPA candidates;
- mean best area, power, or timing;
- archive entropy;
- duplicate rate;
- wall-clock runtime and descriptor extraction cost;
- model dependency/setup cost.

## Efficiency Metrics

For live runs, report curves against valid-PPA evaluations and wall time:

- hypervolume AUC;
- QD-score AUC;
- coverage AUC;
- best-quality AUC;
- valid-PPA yield AUC.

This prevents a method from looking good only because it eventually catches up
after spending much more evaluation budget.

## Continuous / Grid-Free Audit

For descriptors where grid resolution can bias results, compute at least one
grid-free audit:

- Continuous QD score over sampled target descriptor points;
- objective-distance hypervolume over target tolerance tradeoffs;
- Vendi score or nearest-neighbor diversity over PPA-front descriptors.

These audits are secondary to the fixed passive archive, but they help argue
that a method explores a broader Pareto region rather than a lucky grid.

## Effectiveness Tiers

`T0 diagnostic`:

- method runs and produces interpretable artifacts;
- loses clearly on primary metrics or fails validity/duplicate guardrails.

`T1 near_classic`:

- within 2 percent relative loss, or within paired noise, on global PPA
  hypervolume and best quality;
- preserves every classic-covered design in the fixed compared subset: if
  classic has at least one valid functional PPA candidate for that design under
  the same evolutionary budget, the method must also have at least one;
- reports any 50 percent or larger functionality, synthesis-valid, or
  valid-PPA yield drop as a visible warning when the classic baseline has at
  least 10 passing samples for the corresponding stage;
- improves or matches at least one diversity metric such as coverage,
  Pareto-cell count, or unique front families.

`T2 useful_bd`:

- produces a reproducible positive delta on at least one primary QD metric
  against classic or landing Smooth-QD;
- does not regress global PPA hypervolume or best quality beyond the `T1`
  tolerance;
- has no unaccounted duplicate, invalid-candidate, or leakage issue.

`T3 strong_win`:

- improves a primary metric by at least 10 percent or wins across multiple
  seeds/problems with paired statistical support;
- passes all guardrails and has a clean methodology package.

## Anti-Loophole Rules

- A method cannot be promoted from one cherry-picked problem.
- A method cannot be promoted by improving only average fitness.
- A method cannot be promoted by filling cells with duplicate canonical
  netlists.
- A method cannot be promoted from defaulted or missing-reference PPA headline
  metrics.
- A method cannot be promoted if it loses any classic-covered design in the
  fixed compared subset.
- A method with a 50 percent or larger functionality, synthesis-valid, or
  valid-PPA yield drop can be promoted only as a PPA-first tradeoff: the report
  must label the warning, preserve every classic-covered design, and justify
  the claim with PPA hypervolume, front, archive, or best-quality evidence.
- If classic has fewer than 10 passing samples for that stage, the relative
  decline gate is too sensitive to noise. Report raw counts and mark the unit
  `small_n_validity`; do not promote or reject a method from that rate alone.
- A method cannot use PPA, fitness, hypervolume, Pareto rank, reference PPA, or
  test pass rate as an in-loop descriptor input.
- A method cannot change subset, budget, prompts, model, token budget, or
  synthesis flow after seeing results unless the change is recorded as a new
  version and prior results remain visible.

## Required Tables

The central comparison report must include:

- one row per method/problem/seed with all primary metrics;
- one row per problem in `ppa_completeness.csv` with `classic_valid_ppa`,
  `qd_valid_ppa`, `reference_ppa_valid`, and `comparison_status`;
- one row per method/problem/seed for the validity funnel;
- passive archive metrics for classic, landing Smooth-QD, and each BD method;
- per-problem deltas versus classic and landing Smooth-QD;
- aggregate paired summaries with confidence intervals or bootstrap intervals;
- a holdout subset table if screening subsets were used.

## What Counts As A Useful Gain

After the classic-covered design gate is met and yield warnings are visible, a
method may be useful even if average fitness does not improve. A `T2` claim may
come from any clearly documented primary metric improvement:

- larger global PPA hypervolume;
- broader passive archive coverage;
- higher passive archive QD score;
- more Pareto-front cells;
- broader PPA-front descriptor spread;
- more unique implementation families on the front;
- better hypervolume, QD-score, or coverage AUC at the same evaluation budget;
- better valid-PPA yield without losing classic-covered designs.
