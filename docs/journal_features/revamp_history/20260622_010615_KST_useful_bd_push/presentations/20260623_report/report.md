# Does Diversity Matter For RTL PPA Evolution?

Status: one-seed full RTLLM milestone landed on 2026-06-22 UTC.

Primary package:
`presentations/20260623_report/full_rtllm/`

Merged run root:
`exp/useful_bd_push/rtllm_milestone_full_20260622_142254_UTC/merged_ref_default_fix_v0`

## Executive Answer

Question 1: Does diversity matter?

Yes, but only in a scoped and PPA-first sense. The full RTLLM milestone gives
reviewable evidence that the T26-family QD/MAP-Elites line should not be
dropped: exact T26 preserves every classic-covered design, improves aggregate
mean PPA hypervolume by `0.010562` (+11.18%), improves aggregate mean HV-AUC by
`0.012397` (+15.31%), and produces more total PPA-front points (`69` versus
`61`) at the same one-seed, 12x3 budget.

This is not yet a broad decisive win. Per-problem HV has `4` QD wins, `15`
QD losses, and `31` ties. The aggregate HV result is strongly affected by
`Prob040_synchronizer`; without that problem, mean HV delta is `-0.009465` and
mean HV-AUC delta is `-0.007588`. QD also has lower valid-PPA yield (`879`
versus `1056`) and fewer unique PPA points (`318` versus `352`). The correct
claim level is therefore `reviewable useful-QD evidence`, not seed-stable proof
or `strong_win`.

Question 2: Which diversity matters?

The current evidence supports the T26 implementation-response archive bundle,
not a descriptor-only causal claim. The useful pattern appears to be
implementation-response diversity coupled to quality-safe archive pressure. The
best current pattern is not "more novelty" by itself. It is a
synthesis-response raw descriptor/archive bundle that keeps champion-style hill
climbing active while using QD/MAP-Elites to preserve alternative
implementation responses. Lexical, identifier, random, overly sparse graph, and
unguarded local-Pareto diversity have repeatedly failed or produced yield loss
without enough PPA evidence.

## Definitions

This section gives the short reading definitions. The fuller audience glossary
is in `glossary.md`.

Behavior descriptor, or BD: a numeric summary used to place an RTL candidate
into a QD archive. A valid BD for this study cannot use final PPA, fitness,
hypervolume, Pareto rank, reference PPA, or test pass rate as an in-loop input.

QD/MAP-Elites: an optimization strategy that retains strong candidates across
multiple behavior regions instead of keeping only one globally best candidate.
Candidates are mapped into archive cells by their BD.

PPA: power, performance, and area. Area and power are always active in this
package. Effective clock period is active when the reference timing data is
available.

Valid functional PPA candidate: a generated candidate that reaches the
synthesis/PPA stage and contributes PPA metrics used by the Pareto analysis.
This is stricter than syntax pass and functionality pass alone.

Classic-covered problem: an RTLLM problem where the classic REvolution arm has
at least one valid functional PPA candidate under the same budget.

PPA-first retention gate: for this milestone, QD passes the hard gate if every
classic-covered problem also has at least one valid QD PPA candidate. Larger
functionality or valid-PPA rate drops are reported as yield warnings rather
than automatic blockers.

Yield warning: a functionality or valid-PPA count drop of at least 50% when the
classic denominator is at least 10. Smaller denominators are labeled small-n
because the rate is too sensitive to noise.

PPA hypervolume, or HV: the hypervolume of nondominated normalized improvement
points. Improvement is `(reference - candidate) / abs(reference)` for area,
power, and effective clock period when timing reference data exists, otherwise
area and power. Negative improvements are clipped to zero before hypervolume is
computed.

HV-AUC: the area under the PPA-HV-over-generations curve. It rewards earlier
discovery of useful front points, not only final population quality.

PPA-front point: a nondominated valid PPA candidate in the normalized
improvement space for one problem and method.

Unique PPA point: a deduplicated normalized PPA-improvement point. This catches
duplicate collapse even when many candidates are valid.

One-seed paired engineering evidence: a same-seed, same-budget comparison
across many problems. It can justify continuing or tuning a method, but it does
not prove seed-stable statistical significance.

## Retrospective Diversity Analysis

Before the full RTLLM T26 run, we ran a broad retrospective pass across prior
branches and copied worktree artifacts to test whether PPA clusters or PPA
distributions were already explained by simple diversity metrics. The largest
source was the ASP-DAC 2026 release archive under
`exp/diversity_check/aspdac2026_submission_source/`, especially the
`deepseek_clean_results`, `gpt-4.1-mini_clean_results`,
`llama3_clean_results`, and `llama3_baseline_clean_results` run roots. The
self-contained retrospective bundle is:

`docs/journal_features/revamp_history/20260621_000217_KST_rtl_diversity_check/20260621_150407_UTC_compiled_results_bundle/`

The presentation-local digest is in `retrospective/`. It includes source
tables, regenerated summary figures, a regeneration script, and visual
inspection notes.

### Retrospective Scope

| Source | Candidate rows | Valid PPA artifacts | Why it matters |
| --- | ---: | ---: | --- |
| ASP-DAC release | 170057 | 90058 | Largest retrospective source; includes RTLLM and VerilogEval-Spec-to-RTL runs from DeepSeek, GPT-4.1-mini, and Llama-family roots. |
| Auto-BD controls | 23400 | 10343 | Prior paired QD/control evidence for random, Yosys-stat, ST-NOD, synthesis-response, and VQ descriptors. |
| RTLLM gen-20 | 10413 | 2335 | Older broad RTLLM REvolution corpus with generation history and motif vectors. |

The table uses the retrospective `candidate_count` convention from
`corpus_coverage.csv`. The ASP-DAC source also records `170131` code
artifacts; that is an artifact-count convention difference, not a different
experiment.

![Retrospective source coverage](retrospective/figures/retrospective_source_coverage.png)

### What The Retrospective Asked

The retrospective was not a live QD run. It asked whether existing RTL/netlist
style regions, lexical distances, motif descriptors, Qwen embeddings,
DeepGate-style graph embeddings, or AURORA-style learned bottlenecks could
explain or reconstruct useful PPA-front structure after candidates had already
been generated.

Retrospective terms:

| Term | Definition |
| --- | --- |
| Oracle replay | A post-hoc retention policy that chooses from an already generated candidate pool to test whether a diversity rule would have retained useful points. |
| Common audit | A fixed post-hoc descriptor and metric surface used to compare candidates without changing the original generation process. |
| Motif/style/lexical oracle | A replay policy that prioritizes structural motif spread, RTL style-cluster spread, or lexical distance after candidates already exist. |
| DeepGate3/AIG | A graph-encoder path over And-Inverter Graph representations of synthesized logic. |
| AURORA-style linear AE | An unsupervised bottleneck over implementation-side features with PPA fields excluded from the encoder inputs. |

| Gate | Result | Main evidence | Interpretation |
| --- | --- | --- | --- |
| D1 early diversity predicts final PPA | FAIL | Early lexical distance vs final HV had `rho=0.300`, but only as uncontrolled single-run problem-level evidence. | Weak post-hoc signal, not a controlled predictor. |
| D2 clusters explain PPA front | FAIL | `48.8%` of valid-PPA groups had multi-cluster fronts; shuffled labels reached `56.0%`. | Style clusters were not better than label randomization for front explanation. |
| D3 diversity replay beats fitness | FAIL | Best diversity replay improved HV by `1.35%` over best-fitness retention. | Too small for the old strong utility threshold and not enough to promote a method. |
| D4 live intervention | NOT RUN | No prospective intervention was launched in the retrospective goal. | Retrospective evidence alone could not justify an active claim. |
| D5 descriptors beat controls | FAIL | 20260618 Auto-BD controls did not show robust PPA uplift over classic/manual baselines. | More descriptor capacity did not fix yield/PPA robustness. |
| D6 interpretable regions | PASS | Style regions such as arithmetic, control, mux, wire, and sequential RTL were stable enough to describe. | Diversity is measurable and interpretable, but only as illumination. |

![Retrospective utility gates](retrospective/figures/retrospective_gate_status.png)

### PPA Cluster And Replay Findings

The clearest failure mode is visible in the replay table: style diversity can
retain more style regions, but the HV improvement over best-fitness retention
is tiny.

| Replay policy | Mean HV | Mean style clusters | Takeaway |
| --- | ---: | ---: | --- |
| Motif diversity oracle | 0.042866 | 1.472 | Best replay HV, but only `1.35%` over best-fitness oracle. |
| Style diversity oracle | 0.042432 | 2.677 | Much broader style coverage without meaningful HV gain. |
| Lexical diversity oracle | 0.042303 | 2.545 | Similar HV to best fitness despite more lexical spread. |
| Best-fitness oracle | 0.042294 | 1.462 | Hard to beat retrospectively because fitness already preserves useful points. |
| Random mean | 0.030529 | 1.717 | Random retention is clearly worse, so the replay is not vacuous. |

![Replay HV and style clusters](retrospective/figures/retrospective_replay_tradeoff.png)

The case-study plot below shows why the old cluster story was useful but
insufficient. It is a two-dimensional area-power projection of a PPA front
computed in the active PPA space, so timing can make some projected front
points look dominated in 2D. The plot applies tiny deterministic marker
offsets only to separate overlapping style markers. In an RTLLM example,
multiple implementation styles appear on the projected front, but no single
style cleanly explains the front. That supports an illumination claim, not a
causal descriptor claim.

![PPA front by implementation style](retrospective/figures/retrospective_cluster_case_study.png)

The early-diversity scatter tells the same story at problem level: the
association exists, but it is weak and noisy.

![Early diversity versus final HV](retrospective/figures/retrospective_early_diversity_vs_final_hv.png)

### Encoder And Learned-BD Retrospective

The restart also escalated beyond simple lexical/style clusters.

| Encoder family | Evidence | Retrospective decision |
| --- | --- | --- |
| Qwen3 embedding | Common-audit replay ranked `768` candidates, covering `682` valid-PPA rows across `114` valid-PPA replay groups. Identifier-normalized Qwen gained `3.35%` HV versus lexical farthest; raw Qwen lost `1.25%`. Fitness-top retention was similarly positive, so the result is not embedding-specific. | Diagnostic only; useful for later preprocessing studies, but not a promotion gate pass. |
| DeepGate3/AIG | AIG export and tokenizer probes ran, but the bounded tokenizer path produced only `3` nontrivial embeddings with cosine mean near `0.999971`. | No-proceed in that form; sequential/latch handling and collapse remained blockers. |
| AURORA-style linear AE | AE2/AE3 and richer AE8/AE16 bottlenecks excluded PPA fields and used problem splits, but held-out HV/Pareto gains were near-zero, mixed, or negative. | Diagnostic only; no finetuning or in-loop learned BD claim justified. |

![Frozen Qwen replay delta](retrospective/figures/retrospective_qwen_replay_delta.png)

### Retrospective Conclusion For The Current Claim

The retrospective answer to Question 1 was negative: generic implementation
diversity was measurable, but did not by itself explain or improve PPA quality
under the old post-hoc gates. That is why the current presentation should not
claim that arbitrary diversity matters.

The retrospective answer to Question 2 was also restrictive: lexical/style
clusters, raw random descriptors, generic learned bottlenecks, and collapsed
graph embeddings were not enough. The current positive T26 result is therefore
better framed as a prospective matched-budget test of a specific
implementation-response archive bundle with quality pressure. The retrospective
evidence is the reason this report avoids descriptor-only causality and
family-breadth overclaims.

## Full RTLLM Protocol

The comparison used all 50 RTLLM problems from
`bench/RTLLM/*_prompt.txt`, seed `1001`, population `12`, generations `3`, and
`openai/gpt-oss-120b` on the local vLLM endpoint with 128k token budgets.

Classic arm:
`classic_revolution` with `eoh_strategies`.

QD arm:
exact T26, `sr_raw_conservative_exploit_qd`, with grid-quantile
synthesis-response raw (SR raw) descriptors, Pareto-front archive cells,
`qd_fill_target_fraction=0.25`, `qd_improve_backfill_fraction=0.20`,
`qd_champion_lane_fraction=0.80`, NSGA-II global-rank parent selection, and
two-parent fusion disabled.

Exact T26 was selected before seeing full RTLLM results. The screen favored it
because it was the only screened QD arm with positive mean HV and it improved
HV-AUC, despite visible yield warnings on the development screen. The full
run therefore evaluates the selected T26 bundle; it does not isolate whether
the descriptor, archive policy, or champion-biased exploitation is the sole
cause of the gain.

## Result Summary

| Cohort | Metric | Classic | Exact T26 QD | Delta |
| --- | ---: | ---: | ---: | ---: |
| All RTLLM | Mean HV | 0.094435 | 0.104997 | +0.010562 |
| All RTLLM | Mean HV-AUC | 0.080956 | 0.093353 | +0.012397 |
| All RTLLM | Valid PPA | 1056 | 879 | -177 |
| All RTLLM | PPA-front points | 61 | 69 | +8 |
| All RTLLM | Unique PPA points | 352 | 318 | -34 |
| Screen-excluded | Mean HV | 0.088690 | 0.103015 | +0.014325 |
| Screen-excluded | Mean HV-AUC | 0.075581 | 0.093051 | +0.017470 |
| Screen-excluded | Valid PPA | 989 | 845 | -144 |
| Screen-excluded | PPA-front points | 52 | 62 | +10 |

Budget parity:

- generated candidates: classic `2400`, exact T26 QD `2400`;
- LLM API calls: classic `4801`, exact T26 QD `4800`;
- mean LLM API calls per problem: classic `96.02`, exact T26 QD `96.00`;
- total runtime seconds from per-problem summaries: classic `83328.147096`,
  exact T26 QD `84516.206077`.

The exact table is in `full_rtllm/tables/full_budget_parity.csv`.

Retention gate:

- hard retention failures: `0`;
- yield warnings: `4`;
- small-n labels: `6`;
- `Prob006_adder_pipe_64bit` has no valid PPA in either arm, so it is not a
  classic-covered loss.

Yield warnings are concentrated on `Prob041_traffic_light`, `Prob043_RAM`,
`Prob044_ROM`, and `Prob045_alu`. These warnings matter, but they no longer
invalidate the method under the relaxed PPA-first policy because exact T26 keeps
at least one valid PPA sample on every classic-covered problem.

## Evidence Interpretation

The result argues that QD/MAP-Elites is still worth pursuing for RTL PPA
evolution. Exact T26 can find PPA-front structure that classic misses, and it
does so without losing design-level coverage. That is enough to justify the
research direction and a stronger follow-up run.

The result does not prove that exact T26 is already the final algorithm. The
negative screen subset, lower valid-PPA yield, fewer unique PPA points, and
outlier-sensitive HV mean show that the method still needs tuning. The full
RTLLM package also does not include unique front-family or canonical netlist
family breadth. Those family metrics remain a follow-up audit before any claim
that exact T26 expands implementation-family diversity across the full suite.
Prior T28-family evidence already warned that exact T26 can trail classic on
implementation-family breadth, so this package treats family breadth as an
unresolved risk rather than an omitted win.
The most useful next variants should preserve the PPA-front gains while
reducing yield loss and avoiding reliance on a single large-problem win.

The most promising technical direction remains T26/T26.1-style conservative
exploit pressure: keep the QD archive, but bias sampling toward archive
champions and near-front candidates so the method can hill-climb without
collapsing into average-fitness-only REvolution.

## Provenance And Repair Notes

The original exact T26 full run produced 47 usable problem summaries. Three
problems, `Prob013_multi_booth_8bit`, `Prob018_float_multi`, and
`Prob040_synchronizer`, exposed missing-reference PPA handling in RTLLM. The
code was fixed to use the documented high default reference when a benchmark
PPA file is absent, then those three problems were rerun in
`sr_raw_conservative_exploit_qd_ref_default_fix`.

The committed package uses a merged symlink root so the 47 original QD problem
directories remain unchanged and only the three repaired problem directories
come from the repair run. This keeps the result auditable while allowing the
full 50-problem package to be generated.

## Artifact Index

- `full_rtllm/README.md`: generated package summary.
- `full_rtllm/tables/full_problem_metrics.csv`: one row per method/problem.
- `full_rtllm/tables/full_aggregate_metrics.csv`: all, screen, and
  screen-excluded aggregate metrics.
- `full_rtllm/tables/full_comparison_deltas.csv`: paired QD-minus-classic
  deltas.
- `full_rtllm/tables/full_validity_gates.csv`: retention, warning, and small-n
  labels.
- `full_rtllm/tables/full_budget_parity.csv`: runtime, LLM-call, token, and
  generated-candidate parity.
- `full_rtllm/data/full_ppa_candidates.csv`: raw candidate-level PPA data for
  regenerating the direct PPA-front figures.
- `full_rtllm/figures/`: generated PNG figures.
- `full_rtllm/figures/visual_inspection_notes.md`: manual visual inspection
  notes for the generated figures.

## Conclusion

The full one-seed RTLLM milestone answers the two core questions with useful
but bounded evidence. Diversity matters enough to keep the QD/MAP-Elites line
alive when it is implementation-aware and kept under quality pressure. The best
current evidence supports the T26 implementation-response archive bundle, not
generic embedding, lexical, random, or sparsity-seeking diversity.

For the presentation, the defensible message is:
QD/MAP-Elites should continue because exact T26 beats classic on aggregate
PPA-HV, HV-AUC, and PPA-front count while preserving every classic-covered
problem under matched generated-candidate and LLM-call budgets. The honest
caveat is that the gain is uneven, one-seed, and outlier-sensitive, with
visible yield loss and no full-suite implementation-family audit yet. The next
milestone should be multi-seed replication plus T26.1-style variants that
target yield recovery and less outlier-dependent front improvement.
