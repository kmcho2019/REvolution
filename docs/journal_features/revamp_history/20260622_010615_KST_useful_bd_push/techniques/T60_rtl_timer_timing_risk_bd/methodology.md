# T60 RTLTimer Timing-Risk BD Methodology

Status: first diagnostic proxy audit packaged; live RTLTimer extraction still
pending.

## Intent

Use RTLTimer-style timing-risk and path-structure features as behavior
descriptors for QD/MAP-Elites. The goal is not to use RTLTimer as a direct PPA
predictor. The goal is to define archive cells that preserve meaningfully
different RTL implementation families while the evolutionary loop still
optimizes PPA after normal evaluation.

## Inputs

- Candidate RTL and fixed benchmark metadata.
- Yosys AST/RTLIL or RTLTimer-compatible preprocessing output.
- Register, signal, operator, and path-structure features extracted before
  final synthesis/PPA evaluation.

Descriptor inputs exclude final PPA, reference PPA, fitness, hypervolume,
Pareto labels, and test pass labels.

## Descriptor Family

Extract a timing-risk vector with:

- estimated combinational depth distributions between sequential boundaries;
- high-fanout signal and control-gating counts;
- mux/control depth, arithmetic-chain depth, and comparator-chain depth;
- pipeline distance from inputs to registers and registers to outputs;
- register-endpoint path-shape histograms;
- timing-sensitive operator-chain patterns such as multiply-add, shift-add,
  compare-mux, and mux-arithmetic cascades;
- unsupported-construct and preprocessing-failure funnel counts.

The first T60 package uses a lightweight proxy extractor in
`scripts/package_rtl_timer_timing_risk_audit.py`. It counts RTL text features
that approximate the bullets above and is used only as a screening audit over
existing candidates. A promoted T60/T61 method should replace this proxy with
true RTLTimer or MasterRTL/SOG preprocessing before a live QD run.

## Archive Mapping

Run two mappings before live promotion:

1. A 2D grid over timing-risk entropy and pipeline/control-depth ratio.
2. A CVT archive over the full normalized timing-risk vector.

Use the same passive archive and direct PPA-front reporting as prior live QD
methods. Pair the descriptor first with the T51 code-thought front-slot
machinery or the T26/T30 conservative archive machinery, not with a new
emitter, so the descriptor effect remains isolated.

## Validity And PPA Completeness

Every package must include `tables/ppa_completeness.csv`:

| Column | Meaning |
| --- | --- |
| `problem` | Benchmark problem id. |
| `classic_valid_ppa` | Whether classic produced at least one candidate PPA. |
| `qd_valid_ppa` | Whether this QD arm produced at least one candidate PPA. |
| `reference_ppa_valid` | Whether benchmark `ppa.txt` exists and parses. |
| `comparison_status` | `headline`, `diagnostic_only`, or `candidate_missing`. |

Missing candidate PPA is counted as invalid for that method. Missing reference
PPA makes the design diagnostic-only for normalized improvement, HV, and
HV-AUC headline comparisons.

## Promotion Gate

T60 can advance only if it:

- preserves every classic-covered design on the fixed compared subset;
- uses only reference-complete paired problems for direct classic-vs-QD
  headline claims;
- improves or matches front material, archive coverage, or HV/HV-AUC versus
  classic/T51 without hidden duplicate collapse;
- includes raw area-power Pareto figures and the Phase 03.1 viewer when archive
  artifacts exist.

## Expected Artifacts

- `tables/rtl_timer_features.csv`
- `tables/ppa_completeness.csv`
- `tables/timing_risk_archive_metrics.csv`
- `tables/validity_funnel.csv`
- `figures/timing_risk_projection.png`
- `figures/raw_area_power_fronts.png`
- `figures/visual_inspection_notes.md`
- `visualizations/direct_ppa_pareto/`
- `visualizations/qd_ppa_viewer/` for live QD archive runs.
