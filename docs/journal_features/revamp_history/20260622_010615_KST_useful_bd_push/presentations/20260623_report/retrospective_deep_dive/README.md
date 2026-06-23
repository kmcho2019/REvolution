# Retrospective Diversity Deep Dive

This note expands the short `../retrospective/` digest. It explains what the
PPA cluster and replay analyses actually did, which results were useful, and
how the Qwen3 and learned-BD probes were measured.

## Short Answer

The retrospective analyses found that RTL/netlist diversity is real and
measurable, but simple post-hoc diversity descriptors were not strong enough to
prove that diversity alone improves RTL PPA evolution.

The strongest retrospective lesson is more specific:

- PPA fronts often contain multiple implementation styles, but style labels do
  not explain the front better than shuffled labels.
- Counterfactual diversity replay beats random retention, but barely beats a
  best-fitness oracle after the corpus was expanded.
- Qwen3 embeddings carry some PPA-retention signal after preprocessing, but the
  best gains were small and still entangled with problem/corpus identity.
- Graph and implementation-feature descriptors are more promising than raw
  whole-file text embeddings, but they remain replay diagnostics, not live QD
  wins.

This is why the current presentation should frame the evidence as
`diagnostic`: diversity appears useful only when coupled to PPA-safe archive
pressure and front/yield accounting.

## Source Map

| Source | What It Contains | Why It Matters |
| --- | --- | --- |
| `../retrospective/` | Presentation-local summary tables, figures, and regeneration script. | Best compact package for slides. |
| `../../../../20260621_000217_KST_rtl_diversity_check/20260620_183839_UTC_derailed_initial_report/` | First PPA-cluster/replay report and figures. | Shows the first too-optimistic result that later failed broader checks. |
| `../../../../20260621_000217_KST_rtl_diversity_check/20260621_150407_UTC_compiled_results_bundle/` | Compiled final retrospective bundle with stage results. | Best source for final Qwen, DeepGate, AURORA, replay, and validation evidence. |
| `../../techniques/T06_qwen_projection_bd/` | Useful-BD Qwen common-audit package. | Documents raw and identifier-normalized Qwen behavior. |
| `../../techniques/T33_qwen3_preprocessing_ladder_bd/` | Qwen preprocessing ladder. | Tests canonical RTL, identifier-role RTL, Yosys netlist text, and pooled chunk embeddings. |
| `../../techniques/T34_qwen_pca_residual_bd/` | Qwen PCA-residual follow-up. | Tests whether removing dominant embedding axes fixes nuisance collapse. |
| `../../techniques/T07_deepgate_family_bd/` | DeepGate-family graph surrogate. | Shows graph encodings reduce same-problem collapse better than Qwen text. |
| `../../techniques/T13_aurora_incremental_autoencoder_bd/` | AURORA-style implementation-feature and bottleneck replay. | Shows raw implementation features help more than compressed autoencoder bottlenecks. |

## Terminology

PPA means power, performance, and area. In these reports, PPA front metrics use
valid synthesized candidates with area, power, and effective clock period when
available.

PPA front means the nondominated candidates for one problem under the active
PPA objectives. A candidate is on the front if no other candidate is at least
as good on every objective and strictly better on one objective.

Style cluster means a coarse implementation-style label such as
`wire_assign`, `register_sequential`, `arithmetic_additive`,
`arithmetic_multiply`, `control_if`, `control_case`, or `mux_ternary`. These
labels are not learned PPA labels. They are retrospective implementation-style
summaries from RTL/netlist structure.

PPA cluster analysis means: take the already generated valid-PPA candidates,
label each candidate by implementation style, compute the PPA front, and ask
whether the front is concentrated in one style or spans multiple styles.

Replay analysis means: do not generate new RTL. Instead, take an existing pool
of candidates and simulate what a retention rule would have kept. After the
retention set is frozen, score it with PPA metrics. Replay is useful for
screening descriptors, but it cannot prove that a live QD algorithm would have
generated the same candidates.

Farthest-first means: choose one candidate, then repeatedly add the candidate
that maximizes distance to the already selected set in a descriptor space.
This is a post-hoc proxy for diversity-preserving retention.

Common audit means: compare multiple descriptor choices on the same candidate
rows, same grouping keys, same retention fraction, and same PPA scoring code.

## What The PPA Cluster Analysis Did

The first cluster analysis asked whether implementation styles already
separate PPA-front behavior in historical RTLLM runs.

The pipeline was:

1. Build a candidate audit table from historical generated RTL, synthesized
   netlists, PPA metrics, and structural counts.
2. Keep valid-PPA candidates for each problem group.
3. Assign each candidate a style cluster using implementation-side features.
4. Compute each problem's PPA Pareto front.
5. Count how many style clusters appear on the front.
6. Compare that against shuffled labels to check whether the cluster/front
   relation is better than random label assignment.

The first derailed report looked encouraging on a narrow RTLLM slice:

| Gate | First Report Result | Later Interpretation |
| --- | ---: | --- |
| Analyzable groups | 29 | Too small and too RTLLM-specific. |
| Multi-cluster front rate | 13.8% | Not enough by itself. |
| Shuffled-label multi-cluster rate | 20.8% | Shuffled labels were higher, so cluster labels did not explain fronts. |
| Best diversity replay gain | 14.7% | Passed the old 10% gate only on the narrow slice. |

After the broader final retrospective, the picture changed:

| Gate | Final Broader Result | Decision |
| --- | ---: | --- |
| Analyzable valid-PPA groups | 697 | Much stronger sample. |
| Multi-cluster front rate | 48.8% | Descriptive only. |
| Shuffled-label multi-cluster rate | 56.0% | Fails explanatory test. |
| Best diversity replay HV gain over best-fitness replay | 1.35% | Too small to promote. |

The important correction is that "fronts can span multiple styles" is true,
but "these style clusters explain useful PPA front structure" was not
supported.

## What The Replay Analysis Measured

Replay was a counterfactual retention test. For each problem group, the audit
already had a pool of valid-PPA candidates. A policy selected a subset, then
the selected subset was scored.

The main policies were:

| Policy | Meaning |
| --- | --- |
| `oracle_best_fitness` | Keep the best scalar-fitness candidates. This is the hard baseline because classic REvolution already hill-climbs quality. |
| `oracle_motif_diversity` | Keep candidates that spread motif descriptors while still using the existing generated pool. |
| `oracle_style_diversity` | Keep candidates that spread style clusters. |
| `oracle_lexical_diversity` | Keep candidates spread by lexical/structural distance. |
| `random_seed_*` | Keep random subsets for a sanity baseline. |

The final replay table is:

| Replay Policy | Mean HV | Mean Best Fitness | Mean Style Clusters | Groups |
| --- | ---: | ---: | ---: | ---: |
| Motif diversity oracle | 0.042866 | 0.207097 | 1.472 | 697 |
| Style diversity oracle | 0.042432 | 0.207097 | 2.677 | 697 |
| Lexical diversity oracle | 0.042303 | 0.207097 | 2.545 | 697 |
| Best-fitness oracle | 0.042294 | 0.207097 | 1.462 | 697 |
| Random mean | about 0.0305 | about 0.142 | about 1.72 | 697 |

The useful lesson is subtle. Diversity replay clearly beats random retention,
so the descriptor spaces are not meaningless. But the best diversity replay
only improves mean HV by about 1.35% over best-fitness replay. That is not
enough to justify a claim that retrospective diversity alone gives a strong
PPA advantage.

## Helpful Figures

The most useful figures are:

| Figure | Location | What It Shows |
| --- | --- | --- |
| `retrospective_source_coverage.png` | `../retrospective/figures/` | The analysis was not tiny: ASP-DAC release, Auto-BD controls, and RTLLM gen-20 sources were all used. |
| `retrospective_gate_status.png` | `../retrospective/figures/` | D1/D2/D3/D5 failed; only interpretable regions passed. |
| `retrospective_replay_tradeoff.png` | `../retrospective/figures/` | Diversity policies increase style spread, but barely improve HV over best fitness. |
| `retrospective_cluster_case_study.png` | `../retrospective/figures/` | A concrete PPA-front example where multiple styles appear but do not cleanly explain the front. |
| `retrospective_early_diversity_vs_final_hv.png` | `../retrospective/figures/` | Early diversity has a weak noisy association with final HV, not a controlled predictor. |
| `retrospective_qwen_replay_delta.png` | `../retrospective/figures/` | Raw Qwen loses to lexical; identifier-normalized Qwen gains only modestly. |
| `qwen_replay_hypervolume.png` | `../../techniques/T06_qwen_projection_bd/figures/` | Qwen identifier-normalized replay is positive but below promotion strength. |
| `t33_raw_area_power_pareto_front.png` | `../../techniques/T33_qwen3_preprocessing_ladder_bd/figures/` | Direct PPA view showing selected points versus the valid-PPA front. |
| `deepgate_multi_problem_ppa_pareto_fronts.png` | `../../techniques/T07_deepgate_family_bd/figures/` | Graph-surrogate descriptors preserve some front material but do not beat lexical front hits. |
| `aurora_multi_problem_ppa_pareto_fronts.png` | `../../techniques/T13_aurora_incremental_autoencoder_bd/figures/` | Implementation features help slightly; compressed AURORA bottlenecks do not. |

The direct raw area-power figures are especially important because embedding
plots can look compelling while failing to preserve useful PPA-front points.

## Encoder And Learned-BD Retrospective

The encoder work happened in stages. The first retrospective said raw learned
encoders were blocked or diagnostic. The restarted pass then escalated through
real Qwen extraction, DeepGate/AIG setup, and AURORA-style bottlenecks.

### Qwen3 Common Audit

The common-audit Qwen run used `Qwen/Qwen3-Embedding-0.6B` on 768 valid-PPA
candidate rows sampled across 127 problems. It used 1024-dimensional normalized
embeddings and retained 50% of candidates per `(corpus, method, seed,
problem_id)` group.

Three text views were embedded:

| View | Preprocessing |
| --- | --- |
| `qwen_raw` | Raw RTL text truncated to 4096 characters. |
| `qwen_comment_stripped` | RTL with block and line comments removed. |
| `qwen_identifier_normalized` | RTL identifiers replaced by generic `id_N` tokens while Verilog keywords remain intact. |

The selection rule was farthest-first in each embedding space. It was compared
against lexical farthest-first, fitness-top, generation-prefix, and random
controls.

The main Qwen common-audit result was:

| Representation | Selected HV | HV vs Lexical | Selected Pareto Size | Unique Netlists | Unique Motifs |
| --- | ---: | ---: | ---: | ---: | ---: |
| Fitness top | 3.823248 | +3.28% | 300 | 52 | 44 |
| Qwen identifier-normalized | 3.825836 | +3.35% | 289 | 59 | 51 |
| Lexical farthest | 3.701827 | 0.00% | 283 | 60 | 54 |
| Qwen raw | 3.655540 | -1.25% | 294 | 57 | 50 |
| Random | 3.074167 | -16.96% | 303 | 59 | 50 |

This was encouraging but not decisive. Identifier-normalized Qwen matched the
fitness-top best-fitness result and improved HV over lexical by 3.35%, but it
lost motif diversity versus lexical and remained below the old 10% D3 utility
threshold.

The nuisance diagnostics explained why it was not promoted:

| Diagnostic | Value | Interpretation |
| --- | ---: | --- |
| Nearest-neighbor cosine mean | 0.979800 | Embeddings were very close overall. |
| Same-problem nearest-neighbor fraction | 0.933594 | Neighborhoods were dominated by problem identity. |
| Same-corpus nearest-neighbor fraction | 0.947917 | Corpus/source identity was also dominant. |
| Same canonical-netlist nearest fraction | 0.140625 | Nearest neighbors were not mostly duplicate netlists. |
| Same motif-signature nearest fraction | 0.188802 | Nearest neighbors were not mostly motif-equivalent. |
| Raw/comment cosine mean | 0.949326 | Comments had modest effect. |
| Raw/identifier cosine mean | 0.638890 | Identifier names strongly changed the embedding. |

So Qwen worked in the limited sense that it produced non-collapsed embeddings
with some retention signal. It did not work as a direct BD because the signal
was entangled with problem/corpus identity and did not improve the direct front
metrics enough.

### Qwen3 Preprocessing Ladder

T33 asked whether better preprocessing could turn Qwen into a useful BD. It
generated six text views for the same 768 candidates:

| View | Definition |
| --- | --- |
| `raw_rtl` | Original RTL text. |
| `commentless_rtl` | RTL after comment stripping. |
| `identifier_role_rtl` | Identifiers normalized by role, such as `input_0000`, `output_0000`, `wire_0000`, `reg_0000`, and `tmp_0000`. Verilog base-literal payloads such as `4'b0011` were preserved after a cache bug was fixed. |
| `canonical_rtl` | Identifier-role RTL serialized into compact one-statement-per-line canonical text. |
| `canonical_yosys_netlist` | Synthesized Yosys netlist text after comment/attribute stripping and role normalization. |
| `summary_plus_netlist` | Structural count summary prepended to the canonical Yosys netlist. |

Long netlist views were chunked into 4096-character chunks, embedded with
Qwen3, and pooled into one whole-design vector using square-root word-count
weighted mean pooling. Every final row was a 1024-dimensional embedding.

The preprocessing ladder fixed one problem and exposed another:

| View | Same Problem Fraction | Delta vs T06 | Selected HV | Delta vs Lexical |
| --- | ---: | ---: | ---: | ---: |
| Canonical Yosys netlist | 0.738281 | -0.195313 | 3.578191 | -3.34% |
| Summary plus netlist | 0.816406 | -0.117188 | 3.686043 | -0.43% |
| Canonical RTL | 0.894531 | -0.039063 | 3.799167 | +2.63% |
| Identifier-role RTL | 0.906250 | -0.027344 | 3.799118 | +2.63% |
| Commentless RTL | 0.937500 | +0.003906 | 3.772692 | +1.91% |
| Raw RTL | 0.942708 | +0.009115 | 3.655540 | -1.25% |

Netlist views reduced same-problem collapse the most, but lost selected HV.
RTL views improved HV modestly, but kept high same-problem collapse. No view
aligned all three goals: lower nuisance collapse, higher HV, and better direct
PPA-front retention.

The direct front metric made this clearer:

| Representation | All-Valid Front Hits | Selected Front Points | Unique PPA Points |
| --- | ---: | ---: | ---: |
| Commentless RTL | 123 | 130 | 180 |
| Lexical farthest | 122 | 127 | 183 |
| Fitness top | 122 | 122 | 159 |
| Summary plus netlist | 121 | 129 | 188 |
| Canonical RTL | 120 | 129 | 183 |
| Identifier-role RTL | 120 | 129 | 184 |
| Canonical Yosys netlist | 119 | 127 | 186 |

T33 was therefore a useful diagnostic, not a promotion.

### Qwen PCA-Residual Follow-Up

T34 removed dominant PCA components from Qwen views to test whether the
positive RTL signal could be kept while reducing nuisance collapse.

It did not solve the issue. The best residuals tied the T33 canonical-RTL HV
signal, but same-problem fractions stayed high:

| Representation | Selected HV | Delta vs Lexical | Front Hits | Same Problem |
| --- | ---: | ---: | ---: | ---: |
| Canonical RTL PC16 residual | 3.799167 | +2.63% | 122 | 0.895833 |
| Canonical RTL PC1 residual | 3.799167 | +2.63% | 121 | 0.907552 |
| Identifier-role RTL PC1 residual | 3.799167 | +2.63% | 120 | 0.898438 |
| Summary-plus-netlist PC4 residual | 3.570861 | -3.54% | 120 | 0.805990 |

The lower-collapse residuals were netlist-derived and lost HV. The higher-HV
residuals stayed high-collapse. This closed the simple PCA-residual path.

### DeepGate And Graph Retrospective

The true DeepGate3 path was attempted but did not reach a reliable full replay:
the compiled retrospective records 9 AIG exports, 6 latch-free parses, 3
embeddings, and tokenizer embeddings with pairwise cosine mean near 0.999971.
That was too collapsed and too small for a claim.

T07 then used a standard-cell graph surrogate: parse synthesized netlists into
cell graphs, encode graph structure with Weisfeiler-Lehman-style hashed colors
and graph statistics, then replay farthest-first retention.

The graph surrogate was one of the more useful replay signals:

| Representation | Selected HV | HV vs Lexical | Front Hits | Unique PPA | Same Problem |
| --- | ---: | ---: | ---: | ---: | ---: |
| Graph WL | 3.704413 | +0.07% | 120 | 185 | 0.635417 |
| Graph combo | 3.704413 | +0.07% | 120 | 185 | 0.720052 |
| Lexical farthest | 3.701827 | 0.00% | 122 | 183 | n/a |

This reduced same-problem collapse much more than Qwen and slightly improved
HV/unique PPA points, but it lost front hits versus lexical. The conclusion was
to keep graph encoders as a promising lane, not claim a DeepGate win.

### AURORA-Style Learned BDs

The AURORA-style probes tested frozen bottlenecks trained on implementation
features only. They excluded PPA, fitness, validity labels, Pareto labels,
problem id, corpus id, model, method, seed, and candidate id from fitting.

There were two families:

1. WP3 learned encoders in the 20260621 bundle:
   - AE2/AE3 over the common-audit descriptor vector.
   - Rich AE8/AE16 over a 37-dimensional implementation-feature set.
   - Problem-held-out split.
2. T13 useful-BD replay:
   - raw standardized implementation features;
   - PCA/linear-autoencoder bottlenecks;
   - RFF nonlinear bottlenecks;
   - incremental PCA-4 refresh.

The 20260621 WP3 result did not support promotion:

| Encoder | Holdout Metric | Result |
| --- | --- | --- |
| AE2 | Pareto gain over common audit | +0.36%, no canonical-netlist gain |
| AE3 | Pareto gain over common audit | 0.00% |
| Rich AE8 | HV gain over implementation baseline | 0.00%, Pareto -0.11% |
| Rich AE16 | HV gain over implementation baseline | -0.007%, Pareto -0.04% |

T13 was more informative. The raw implementation-feature vector was useful,
but the compressed bottlenecks were not:

| Representation | Selected HV | HV vs Lexical | Front Hits | Unique PPA | Same Problem |
| --- | ---: | ---: | ---: | ---: | ---: |
| Implementation features | 3.740943 | +1.06% | 120 | 186 | 0.867188 |
| Lexical farthest | 3.701827 | 0.00% | 122 | 183 | n/a |
| PCA4 bottleneck | 3.625712 | -2.06% | 118 | 184 | 0.809896 |
| RFF PCA2 bottleneck | 3.491803 | -5.67% | 116 | 181 | 0.548177 |

The repeated pattern is important: compression often reduces nuisance collapse,
but the reduced-collapse latent space loses PPA utility. The uncompressed
implementation features keep more PPA signal, but remain high-collapse and do
not improve direct front hits.

## How Retrospective Performance Was Measured

The retrospective metrics were deliberately separated into descriptor inputs
and post-selection scoring.

Descriptor inputs could use:

- RTL text;
- comment-stripped or canonical RTL;
- synthesized netlist text;
- implementation counts;
- graph statistics;
- motif/style signatures;
- frozen embeddings trained without PPA labels.

Descriptor inputs could not use:

- final area, power, or timing;
- reference PPA;
- scalar fitness;
- hypervolume;
- Pareto rank;
- pass/fail labels;
- problem id, corpus id, model id, method id, seed, or candidate id for fitting.

After a replay policy selected candidates, the scoring metrics were:

| Metric | Meaning |
| --- | --- |
| Selected HV | Hypervolume of selected candidates in normalized PPA-improvement space. |
| Selected Pareto size | Number of selected nondominated candidates. |
| Best fitness | Best scalar fitness retained by the selected set. |
| Unique canonical netlists | Deduplicated synthesized netlist families retained. |
| Unique motif signatures | Deduplicated motif signatures retained. |
| Front hits | Selected candidates that also belong to the all-valid area-power front. |
| Unique PPA points | Deduplicated selected raw PPA points. |
| Same-problem nearest fraction | Fraction of embedding nearest neighbors from the same problem. Lower is better when checking nuisance collapse. |
| Same-corpus nearest fraction | Fraction of nearest neighbors from the same source corpus. |

For Qwen/T33/T34/T07/T13, the common replay surface retained 50% of candidates
per `(corpus, method, seed, problem_id)` group. Most replay tables use 768
candidates, 682 valid-PPA rows, and 114 valid-PPA replay groups. That makes the
descriptor comparisons apples-to-apples, but still retrospective.

## What We Should Carry Forward

The retrospective work should not be read as "diversity does not matter."
It should be read as:

1. Generic style diversity is too weak as a causal explanation.
2. Best-fitness retention is a strong baseline because the historical search
   already hill-climbs PPA.
3. Raw learned embeddings mostly discover nuisance axes unless preprocessing
   and collapse checks are explicit.
4. Graph and implementation-response features are the most promising
   non-PPA descriptor inputs, but need live archive coupling and front/yield
   gates.
5. Any future learned-BD path needs a stronger objective than reconstruction:
   likely contrastive anti-problem/corpus training, front-family supervision
   that does not leak PPA into in-loop descriptors, or a hybrid with T26-style
   quality-safe archive pressure.

For the current report, the most defensible narrative is therefore:

The retrospective analyses explain why naive diversity was not enough. The
current QD/MAP-Elites line is still worth testing because T26-style methods do
not rely on diversity alone; they combine implementation-response archives
with champion-preserving quality pressure and direct PPA-front validation.
