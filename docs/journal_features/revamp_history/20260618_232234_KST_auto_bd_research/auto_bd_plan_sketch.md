# Research Task: Automatic Behavior Descriptors for RTL PPA Evolution

## 1. Goal Statement

The goal of this research task is to develop and evaluate **automatic behavior descriptor discovery methods** for RTL PPA evolution, with the aim of replacing or improving upon the current hand-designed Smooth-QD v2 behavior descriptors: **combinational logic depth, FF depth, and log combinational gate count**.

The current manual BDs are simple and interpretable, but they may appear arbitrary and may not capture the most meaningful diversity in RTL implementation behavior. This task should investigate whether automatically discovered or hardware-native descriptors can produce **more diverse, higher-quality RTL implementations** while preserving the existing REvolution/Smooth-QD ability to repair functionality, pass synthesis, and obtain valid PPA. This is aligned with the current Smooth-QD direction, where the archive is useful but should be improved without breaking the code-level search substrate. The prior journal work showed that the aggressive v2 redesign underperformed classic REvolution, while the landing Smooth-QD variant restored parity by keeping code individuals and six EoH operators while adding QD structure. 

The research question is:

> **Can automatic behavior descriptors derived from RTL, synthesized netlists, synthesis trajectories, or learned implementation-behavior embeddings improve Smooth-QD RTL PPA evolution compared with both original REvolution and Smooth-QD v2 using manual BDs?**

The final result should not only answer “which method gives the best PPA,” but also whether the method preserves functional repair ability, improves archive diversity, discovers genuinely different RTL/netlist implementation styles, and provides a descriptor that reviewers will find defensible rather than arbitrary. 

---

## 2. Research Philosophy

The person should be free to explore multiple directions, but the default thesis should be:

> **For RTL PPA evolution, behavior should mean implementation behavior under synthesis, not raw program text, not final PPA, and not arbitrary scalar statistics.**

AutoQD is a useful inspiration because it learns behavior descriptors from occupancy-measure embeddings rather than relying on hand-coded BDs. AURORA is useful because it learns descriptors through unsupervised dimensionality reduction over raw behavior observations. VQ-Elites is useful because it learns a structured, quantized behavior-space grid instead of requiring a manually designed MAP-Elites grid. ([OpenReview][1])

However, the method should not be a direct port of robotics QD. The RTL-specific contribution should be that **candidate behavior is defined by synthesized netlist motifs, synthesis-stage transformations, sequential cone structure, or implementation-style codebooks**.

---

## 3. Required Baselines

Every proposed Auto-BD method must be compared against these baselines:

### Baseline A — Original REvolution

Original REvolution-style evolutionary RTL search:

```text
- code individuals
- fail pool for functionality repair
- success pool for PPA optimization
- six EoH operators
- no MAP-Elites archive
```

### Baseline B — Smooth-QD v2 Manual-BD Baseline

Current journal version of Smooth-QD:

```text
- code individuals
- six EoH operators
- MAP-Elites / QD archive
- manual BDs:
    1. combinational logic depth
    2. FF depth
    3. log combinational gate count
```

This is the main baseline the new Auto-BD method must improve or meaningfully complement.

### Baseline C — Random Descriptor QD

Negative control:

```text
- same Smooth-QD infrastructure
- random descriptor / random projection / random cell assignment
- same evaluation budget
```

This is required to prove that any gain is not simply from stochastic archive noise.

### Baseline D — Simple Yosys-Statistic BD

Strong simple baseline:

```text
- gate count
- FF count
- mux count
- arithmetic-cell count
- fanout statistics
- logic-level histogram
```

This checks whether a simple synthesis-statistics descriptor is already sufficient before moving to more complicated learned encoders. The task-spec notes already identify REvolution, Smooth-QD v2, random descriptor QD, and simple Yosys-stat QD as the required comparison set. 

---

## 4. Candidate Directions to Explore

The researcher should start simple and increase complexity only when simple methods fail to meet the quantitative goal.

### Direction 1 — Netlist Motif Occupancy Descriptor

This should be the first serious method.

For each valid RTL candidate:

```text
1. Generate synthesized netlist using Yosys.
2. Extract netlist graph objects:
   - gates
   - FFs
   - constants
   - PIs / POs
   - muxes
   - arithmetic cells
   - fanin / fanout
   - logic levels
   - sequential boundaries

3. Extract local motifs:
   - k-hop neighborhoods
   - short pathlets
   - PI-to-PO cones
   - FF-to-FF cones
   - mux-heavy regions
   - arithmetic-heavy regions
   - reconvergent fanout structures

4. Convert motif distribution into a fixed-length vector.
5. Project to a low-dimensional BD or assign to archive cells.
```

This is the most direct AutoQD-inspired method: treat the netlist as an “occupancy distribution” over hardware motifs.

### Direction 2 — Synthesis-Trajectory Descriptor

This is the direction I would prioritize as the likely journal-worthy method.

Instead of describing only the final netlist, describe **how the RTL transforms through synthesis**:

```text
RTL source
→ RTLIL lowering
→ process/fsm/memory handling
→ generic cell mapping
→ optimization
→ ABC/AIG optimization
→ technology mapping
→ final synthesized netlist
```

Possible trajectory features:

```text
- logic collapse ratio
- mux introduction/removal ratio
- arithmetic preservation/decomposition ratio
- depth shrink/growth
- fanout/reconvergence change
- FF-cone balance
- shallow-wide vs deep-narrow transformation
- control-heavy vs arithmetic-heavy evolution
```

This has the best novelty story because it is not just “use an autoencoder.” It says: **for generated RTL, behavior is the synthesis response**.

### Direction 3 — AURORA-Style Netlist Autoencoder

After the motif and trajectory descriptors are working, try a learned encoder:

```text
Input options:
- Yosys JSON graph
- AIG graph
- techmapped gate graph
- motif histogram
- synthesis-stage histogram sequence

Model options:
- MLP over statistics
- graph autoencoder
- GNN with pooling
- lightweight graph transformer
```

Use the latent vector as the BD after PCA, UMAP, random projection, CVT, or quantile binning. This should be attempted only after the simple motif method exists.

### Direction 4 — VQ-Elites-Style Codebook Descriptor

Learn a discrete codebook of implementation styles:

```text
netlist / trajectory vector z
→ encoder
→ nearest codebook entry
→ archive cell
```

This may be more interpretable than a continuous latent space because each codebook entry can be labeled post hoc:

```text
mux-heavy
arithmetic-heavy
sequential-heavy
shallow-parallel
compact-serialized
control-dominated
logic-collapsed
```

### Direction 5 — New RTL-Native Algorithm

The person is free to propose a genuinely new algorithm if it fits the domain better than AutoQD/AURORA/VQ-Elites. Good examples:

```text
- Descriptor based on synthesis-response contrast:
  candidates are diverse if synthesis transforms them differently.

- Descriptor based on equivalence-class splitting:
  group functionally equivalent candidates by structurally distinct netlist forms.

- Descriptor based on implementation-style codebook:
  learn a finite vocabulary of hardware strategies across successful candidates.

- Descriptor based on parent-child transformation:
  archive not only what the candidate is, but what kind of mutation caused useful PPA movement.

- Descriptor based on Pareto-front role:
  classify candidates by whether they tend to improve area, power, timing, or robustness.
```

But any new algorithm must still satisfy the same evaluation and anti-hack gates.

---

## 5. Recommended Main Method Name

I would give them this as the **initial target method**, while allowing expansion:

> **ST-NOD: Synthesis-Trajectory Netlist Occupancy Descriptor**

One-line definition:

> ST-NOD describes each RTL candidate by the distribution of synthesized netlist motifs it creates and by how those motifs transform across Yosys synthesis stages.

This combines the strongest parts of the AutoQD/AURORA/VQ-Elites idea but makes the contribution hardware-specific. The existing task draft already identifies “Synthesis-Trajectory Netlist Occupancy Descriptor” as the strongest combined direction and frames the core insight as “implementation behavior under synthesis,” not text, final PPA, or arbitrary depth/count scalars. 

---

## 6. Benchmark Subset Requirement

The researcher should select a benchmark subset from **RTLLM** and **VerilogEval**, but not cherry-pick only easy or saturated problems. RTLLM is appropriate because it provides natural-language RTL design descriptions and testbenches, while VerilogEval v2 supports specification-to-RTL tasks, which matches the intended LLM RTL-generation setting. ([GitHub][2])

Use three subsets:

```text
Development subset:
  - 4–6 problems
  - fast simulation and synthesis
  - at least one combinational and one sequential design

Main evaluation subset:
  - 12–20 problems
  - balanced between RTLLM and VerilogEval
  - balanced between combinational and sequential tasks

Held-out validation subset:
  - 6–10 problems
  - not used for descriptor tuning
  - used only after method selection
```

The subset should include combinational arithmetic, combinational control, sequential modules, FSM-like modules, problems with nontrivial PPA variation, and problems where at least some valid PPA candidates can be produced. Avoid all-trivial tasks and all-impossible tasks. 

---

## 7. Fitness Definition

Use the existing REvolution/Smooth-QD fitness definition:

```text
Sequential circuits:
  fitness = average PPA improvement ratio over power, area, and effective clock period

Combinational circuits:
  fitness = average improvement ratio over power and area only
```

Do **not** put PPA directly into the behavior descriptor. PPA is the optimization objective, not the BD. The existing task draft explicitly separates fitness from descriptors and states that PPA metrics should be used as fitness rather than directly as BD. 

---

## 8. Required Metrics

The researcher must report four classes of metrics.

### A. Correctness and Pipeline Robustness

```text
- functionality pass %
- synthesis pass %
- OpenROAD/PnR success %
- % of problems with at least one valid PPA
- average number of valid PPA candidates per problem
- syntax failure count
- testbench failure count
- synthesis failure count
- OpenROAD failure count
- timeout count
```

These show whether the method hurts evolutionary functionality repair.

### B. PPA Optimization Quality

```text
- best fitness per problem
- average best fitness
- median best fitness
- top-k average fitness
- PPA hypervolume
- best power improvement
- best area improvement
- best timing improvement for sequential designs
- anytime curve: best fitness vs evaluations
```

### C. QD Archive Quality

```text
- archive coverage
- QD score
- mean elite fitness
- median elite fitness
- occupied cells
- improved cells over time
- archive entropy
- unique elite count
- QD score vs evaluations
- coverage vs evaluations
```

### D. Descriptor Quality and Interpretability

```text
- correlation with manual BDs
- correlation with PPA metrics
- stability under signal renaming
- stability under formatting-only RTL changes
- nearest-neighbor structural similarity
- unique synthesized netlist hash count
- motif enrichment per archive region
- examples of qualitatively different RTL/netlist strategies
```

The descriptor should not collapse into gate count, depth, or PPA. If the learned descriptor is almost perfectly correlated with one manual BD, it is not a compelling Auto-BD result. 

---

## 9. Quantitative Sign-Off Gates

A method can be considered a serious journal candidate only if it passes the following gates.

```text
Gate 1 — No major robustness regression
  Compared with Smooth-QD v2:
  - functionality pass rate does not drop by >5 percentage points
  - synthesis pass rate does not drop by >5 percentage points
  - valid-PPA problem coverage does not drop
  - OpenROAD success does not noticeably regress

Gate 2 — Optimization uplift
  Must satisfy at least one:
  - ≥10% relative improvement in average best fitness
  - ≥10% relative improvement in PPA hypervolume
  - ≥2 additional benchmark problems with positive PPA improvement
  - statistically better anytime best-fitness curve under the same budget

Gate 3 — QD uplift
  Must satisfy at least one:
  - ≥15% relative improvement in QD score
  - ≥20% relative improvement in archive coverage
  - ≥25% more unique synthesized elite netlists

Gate 4 — Descriptor non-arbitrariness
  Must satisfy:
  - no near-perfect correlation with manual BDs
  - meaningful nearest-neighbor structural similarity
  - stability under renaming/formatting perturbations
  - interpretable archive regions after post-hoc analysis

Gate 5 — Journal defensibility
  Must contain a hardware-specific insight:
  - synthesized netlist motif distribution
  - synthesis trajectory
  - sequential cone structure
  - implementation-style codebook
  - optimization response under Yosys
```

The previous task draft already proposes essentially these gates, including no >5pp robustness drop, ≥10% fitness/HV uplift, ≥15–20% QD/coverage uplift, ≥25% more unique synthesized elite netlists, and descriptor-region explainability. 

---

## 10. Required Per-Method Subdirectory

Each implemented methodology should have its own subdirectory. I would require this structure:

```text
auto_bd_methods/
  00_random_descriptor/
    method_card.md
    config.yaml
    extractor.py
    archive_adapter.py
    experiments/
    results/
    accept_reject.md

  01_yosys_stat_bd/
    method_card.md
    config.yaml
    extractor.py
    archive_adapter.py
    experiments/
    results/
    accept_reject.md

  02_netlist_motif_occupancy/
    method_card.md
    config.yaml
    extractor.py
    archive_adapter.py
    experiments/
    results/
    accept_reject.md

  03_synthesis_trajectory_bd/
    method_card.md
    config.yaml
    extractor.py
    archive_adapter.py
    experiments/
    results/
    accept_reject.md

  04_aurora_netlist_autoencoder/
    method_card.md
    config.yaml
    model.py
    train_encoder.py
    extractor.py
    archive_adapter.py
    experiments/
    results/
    accept_reject.md

  05_vq_elites_netlist_codebook/
    method_card.md
    config.yaml
    model.py
    train_codebook.py
    extractor.py
    archive_adapter.py
    experiments/
    results/
    accept_reject.md

  99_final_selected_method/
    final_method_spec.md
    final_experiment_config.yaml
    final_results/
    paper_section_draft.md
```

Each folder must be self-contained enough that someone can later reconstruct:

```text
what was tried
why it was tried
how it was implemented
what benchmark subset was used
what the quantitative result was
why it was accepted or rejected
```

---

## 11. Required Method Card Template

Each method must include a `method_card.md` with:

```markdown
# Method Name

## 1. Motivation
What problem with manual BDs does this method address?

## 2. Core Idea
What is the behavior observation?
Why is it meaningful for RTL/netlist/PPA evolution?

## 3. Input Artifacts
- RTL source?
- Yosys JSON?
- AIG?
- techmapped netlist?
- OpenROAD artifacts?
- synthesis-stage dumps?

## 4. Descriptor Extraction Algorithm
Exact algorithm or pseudocode.

## 5. Archive Integration
How is the descriptor converted into MAP-Elites coordinates?
Grid? quantile bins? CVT? VQ codebook? PCA?

## 6. Hyperparameters
All descriptor, training, binning, and archive parameters.

## 7. Expected Advantage
Why should this outperform manual BDs?

## 8. Risks
Possible descriptor leakage, collapse, instability, overfitting, cost.

## 9. Implementation Status
Complete / partial / failed.

## 10. Experimental Setup
Benchmark subset, seeds, budget, LLM model, synthesis/OpenROAD settings.

## 11. Results
Robustness, PPA, QD archive, descriptor-quality metrics.

## 12. Accept / Reject Decision
Accepted, rejected, or needs more evidence.

## 13. Reason
Concrete explanation based on quantitative gates.
```

The existing task spec already requires method cards with method name, motivation, input artifacts, descriptor extraction algorithm, archive insertion rule, hyperparameters, expected advantage, risks, implementation status, experimental results, accept/reject decision, and reason for accept/reject. 

---

## 12. Anti-Hack Requirements

To avoid “finishing” the task through a backdoor hack, enforce these constraints:

```text
1. Same evaluation budget across methods.
2. Same LLM model across methods.
3. Same benchmark subset for all compared methods.
4. Same simulation/synthesis/OpenROAD timeout.
5. Same Smooth-QD substrate unless the method explicitly declares otherwise.
6. No use of final PPA, reference PPA, or fitness as the BD.
7. No tuning on held-out validation set.
8. No discarding hard problems after seeing results.
9. No reporting average PPA only over valid candidates without reporting valid coverage.
10. No counting duplicate netlists as separate diversity.
11. Every elite must have a canonical synthesized-netlist hash.
12. Every failed method must still be documented.
```

I would make this explicit:

> A method that improves average PPA by producing fewer valid candidates is not automatically a success. It must also preserve functionality/synthesis/OpenROAD robustness and improve either QD quality or structurally meaningful diversity.

This is important because prior descriptor/archive variants sometimes showed misleading apparent score/PPA edges when averaged over fewer scorable designs, so valid-candidate robustness and archive diversity must be first-class metrics. 

---

## 13. Recommended Iteration Order

Give them this order:

```text
Phase 0 — Reproduction
  1. Reproduce original REvolution baseline.
  2. Reproduce Smooth-QD v2 manual-BD baseline.
  3. Confirm same budget, same benchmark subset, same evaluation pipeline.

Phase 1 — Controls
  4. Implement random descriptor QD.
  5. Implement simple Yosys-stat BD.
  6. Run on the 4–6 problem development subset.

Phase 2 — First serious Auto-BD
  7. Implement netlist motif occupancy descriptor.
  8. Add canonical netlist hashing.
  9. Add descriptor stability tests.
  10. Run dev subset and write accept/reject card.

Phase 3 — Main hardware-native method
  11. Implement synthesis-stage artifact dumping.
  12. Implement synthesis-trajectory descriptor.
  13. Compare motif-only vs trajectory-motif descriptor.

Phase 4 — Learned descriptor variants
  14. Implement simple PCA/random projection over motif/trajectory vectors.
  15. Implement AURORA-style autoencoder only if Phase 2/3 is promising.
  16. Implement VQ/codebook descriptor only after stable embeddings exist.

Phase 5 — Final selection
  17. Select best method by predeclared gates.
  18. Run main subset with at least 3 seeds.
  19. Run held-out validation.
  20. Produce final method card, plots, tables, and paper-section draft.
```

This matches the recommended order in the existing task plan: reproduce baselines, add random and Yosys-stat descriptors, implement motif descriptor, then synthesis-trajectory descriptor, and only afterward try AURORA-style and VQ/codebook variants. 

---

## 14. Final Deliverables

The final deliverable should include:

```text
1. benchmark subset selection report
2. baseline reproduction report
3. method directory for every implemented Auto-BD variant
4. method cards for every variant
5. descriptor extraction code
6. archive integration code
7. experiment scripts
8. raw logs and candidate artifacts
9. summary tables
10. anytime curves
11. archive visualizations
12. canonical netlist hash analysis
13. representative RTL/netlist examples
14. final accept/reject recommendation
15. draft journal methodology section for the selected method
```

The existing task document already lists these deliverables and emphasizes that rejected methods should remain documented, which is important for later journal writing and ablation discussion. 

---

## 15. Final Selection Rule

The final selected method should not be the most complicated method. It should be the method with the best balance of:

```text
- PPA improvement
- QD archive quality
- valid candidate robustness
- descriptor interpretability
- hardware-domain novelty
- implementation complexity
- journal defensibility
```

A simple hardware-native descriptor that clearly works is better than a complex neural descriptor with unstable gains. 

---

## 16. Short Version to Give the Researcher

You can give them this as the actual task paragraph:

> **Your task is to develop automatic behavior descriptors for Smooth-QD RTL PPA evolution. The current Smooth-QD v2 archive uses manually chosen BDs: combinational logic depth, FF depth, and log combinational gate count. These are interpretable but may appear arbitrary and may not capture meaningful implementation diversity. You should explore AutoQD-inspired, AURORA-inspired, VQ-Elites-inspired, and new RTL-native descriptor methods, starting from simple Yosys/netlist statistics and gradually moving toward motif-distribution, synthesis-trajectory, autoencoder, and codebook-based descriptors. Each method must be implemented in its own subdirectory with a method card, exact specification, rationale, experimental results, and final accept/reject decision. Every method must be compared against original REvolution, Smooth-QD v2 with manual BDs, random-descriptor QD, and simple Yosys-stat QD under the same budget. A method can be accepted as a journal candidate only if it preserves functionality/synthesis/valid-PPA robustness, improves PPA or hypervolume, improves QD archive quality or unique synthesized elite diversity, and yields descriptor regions explainable by concrete RTL/netlist/synthesis motifs. The preferred initial target is a Synthesis-Trajectory Netlist Occupancy Descriptor, where RTL behavior is defined by the motifs it creates and how those motifs transform through synthesis.**

[1]: https://openreview.net/forum?id=FNnJIf4ymV&utm_source=chatgpt.com "AutoQD: Automatic Discovery of Diverse Behaviors with..."
[2]: https://github.com/hkust-zhiyao/RTLLM?utm_source=chatgpt.com "GitHub - hkust-zhiyao/RTLLM: An open-source benchmark ..."

# Addendum: Report Generation and Visualization Requirement

## 13. Report Generation and Visualization Infrastructure

In addition to implementing Auto-BD methods, the researcher must develop a **standardized report generation and visualization pipeline**. This pipeline should make it easy to inspect, compare, and judge each proposed Auto-BD method both individually and against all other methods.

The purpose is to avoid ad hoc evaluation. Every method should produce the same core tables, plots, archive visualizations, descriptor analyses, and accept/reject summaries, so that we can quickly determine whether the method is genuinely promising or only appears good because of selective reporting.

This requirement should be treated as part of the method implementation itself. A proposed Auto-BD method is not considered complete until its report and visualizations are generated successfully from raw experiment artifacts.

---

## 13.1 Per-Method Report Requirement

Each method subdirectory must include a report-generation entry point.

Recommended structure:

```text
auto_bd_methods/
  02_netlist_motif_occupancy/
    method_card.md
    config.yaml
    extractor.py
    archive_adapter.py

    experiments/
      raw_runs/
      processed/

    reports/
      generate_report.py
      report_config.yaml
      report.md
      report.html
      summary.json
      tables/
        robustness_summary.csv
        ppa_summary.csv
        qd_summary.csv
        descriptor_summary.csv
        per_problem_summary.csv
        signoff_gate_summary.csv
      figures/
        robustness_funnel.png
        best_fitness_anytime.png
        ppa_hypervolume_anytime.png
        qd_score_anytime.png
        archive_coverage_anytime.png
        archive_heatmap.png
        descriptor_scatter.png
        manual_bd_correlation_heatmap.png
        ppa_correlation_heatmap.png
        netlist_uniqueness_bar.png
        per_problem_win_loss.png
      examples/
        representative_elites.md
        representative_netlists/
        representative_rtl/
      accept_reject.md
```

The report should be generated by a single command, for example:

```bash
python auto_bd_methods/02_netlist_motif_occupancy/reports/generate_report.py \
  --method-dir auto_bd_methods/02_netlist_motif_occupancy \
  --baseline-dir baselines/smooth_qd_v2_manual_bd \
  --out auto_bd_methods/02_netlist_motif_occupancy/reports/
```

The report generator must consume raw logs or standardized processed artifacts and regenerate all tables and plots. Manually edited result tables should not be accepted as final evidence.

---

## 13.2 Per-Method Report Contents

Each method-level report must contain the following sections.

### A. One-Page Executive Summary

This should be the first page of the report.

```text
Method name:
Method family:
  random descriptor / Yosys-stat / motif occupancy / synthesis trajectory /
  AURORA-style encoder / VQ codebook / other

Core idea:
Input artifacts:
Descriptor dimensionality:
Archive binning rule:
Evaluation subset:
Number of seeds:
Evaluation budget:
Main result:
Final verdict:
  accept / reject / needs more evidence
Reason:
```

This section should make it possible to understand the method and its result in less than one minute.

---

### B. Sign-Off Gate Dashboard

The report must include a pass/fail dashboard for the quantitative gates.

Example:

| Gate       |                Requirement |        Result |  Pass? | Comment                                 |
| ---------- | -------------------------: | ------------: | -----: | --------------------------------------- |
| Robustness |    functionality drop ≤5pp |        −2.1pp |   Pass | no major repair regression              |
| Robustness |        synthesis drop ≤5pp |        −1.4pp |   Pass | acceptable                              |
| PPA        |      avg best fitness +10% |         +6.2% |   Fail | not enough                              |
| PPA        |                PPA HV +10% |        +12.8% |   Pass | primary win                             |
| QD         |      archive coverage +20% |        +24.5% |   Pass | meaningful diversity gain               |
| QD         | unique elite netlists +25% |        +31.0% |   Pass | not duplicate inflation                 |
| Descriptor |      stable under renaming |   cosine 0.97 |   Pass | stable                                  |
| Descriptor | non-collapsed vs manual BD | max corr 0.62 |   Pass | not just gate count/depth               |
| Final      |                  accepted? |             — | Accept | HV + diversity gain, no robustness drop |

This is important because the existing task already defines robustness, optimization, QD, descriptor, and journal-defensibility gates; the report should make the gate status visible rather than buried in text. 

---

### C. Robustness and Pipeline Health Visualizations

The report must include plots that show whether the method damages the RTL-evolution pipeline.

Required plots:

```text
1. Candidate funnel plot:
   generated candidates
   → syntax pass
   → functionality pass
   → synthesis pass
   → OpenROAD/PnR success
   → valid PPA

2. Failure breakdown stacked bar:
   syntax failure
   testbench failure
   synthesis failure
   OpenROAD failure
   timeout

3. Per-problem valid-PPA heatmap:
   rows = benchmark problems
   columns = methods/seeds
   value = valid PPA count or valid-PPA rate
```

The funnel plot is especially important. It prevents the method from looking good by producing fewer but cherry-picked valid candidates. A method that improves average PPA while sharply reducing valid-PPA coverage should be flagged automatically.

---

### D. PPA Optimization Visualizations

The report must include both aggregate and per-problem PPA views.

Required plots:

```text
1. Anytime best-fitness curve:
   x-axis = evaluations or LLM calls
   y-axis = best fitness so far

2. PPA hypervolume curve:
   x-axis = evaluations or LLM calls
   y-axis = PPA hypervolume

3. Per-problem win/loss/tie chart:
   compare against REvolution and Smooth-QD v2 manual-BD baseline

4. Power/area/timing improvement bar chart:
   separate power, area, and timing improvement
   for combinational circuits, omit or gray out timing

5. Best candidate scatter:
   area improvement vs power improvement
   optionally timing encoded by marker size or separate plot
```

The report should include **mean, median, and per-problem values**. Do not allow only global averages, because a method can look good by winning heavily on one problem while failing many others.

---

### E. QD Archive Visualizations

Because the whole point is Auto-BD for QD, the report must make the archive visually inspectable.

Required plots:

```text
1. Archive occupancy heatmap:
   occupied cells across descriptor dimensions

2. Elite-fitness heatmap:
   cell color = best elite fitness in that region

3. Archive coverage over time:
   x-axis = evaluations
   y-axis = occupied-cell percentage

4. QD score over time:
   x-axis = evaluations
   y-axis = QD score

5. Archive entropy over time:
   shows whether archive is balanced or collapsed

6. Cell-improvement timeline:
   number of cells improved per generation

7. Pareto-front scatter:
   area/power/timing trade-off among elites
```

For descriptors with more than two dimensions, the report should use either:

```text
- pairwise descriptor projections,
- PCA/UMAP projection only for visualization,
- per-axis marginal histograms,
- top occupied cell tables,
- or separate 2D slices.
```

The current Smooth-QD framing already emphasizes that the diversity/Pareto archive is the deliverable classic REvolution does not provide, and that archive/diversity metrics such as coverage, frontier spread, and descriptor occupancy should be reported as primary, not secondary. 

---

### F. Descriptor Quality and Interpretability Visualizations

Each Auto-BD method must include visualizations that explain what the descriptor actually captures.

Required plots/tables:

```text
1. Correlation heatmap:
   learned/automatic BD dimensions vs manual BDs
   manual BDs = comb depth, FF depth, log comb gate count

2. Correlation heatmap:
   BD dimensions vs PPA metrics
   PPA = area, power, timing, fitness, hypervolume contribution

3. Descriptor scatter:
   candidate points in descriptor space
   color by fitness, validity, problem, or motif family

4. Motif enrichment table:
   for each archive region/codebook entry:
     overrepresented motifs
     underrepresented motifs
     representative elite IDs

5. Nearest-neighbor examples:
   for several candidates, show nearest neighbors in BD space
   and whether their synthesized netlists are structurally similar

6. Stability test table:
   original RTL vs renamed RTL vs formatting-only modified RTL
   descriptor distance should remain small

7. Duplicate/canonical-netlist analysis:
   number of unique canonical synthesized netlists
   duplicate rate per archive cell
   same-netlist-across-multiple-cells count
```

This is where the method becomes journal-defensible. The report should answer:

> “What kind of RTL/netlist implementation behavior does this descriptor separate?”

Not just:

> “Did the metric improve?”

---

### G. Representative Elite Examples

Each method report should include a small gallery of representative designs.

For example:

```text
1. Best area elite
2. Best power elite
3. Best timing elite
4. Best hypervolume-contributing elite
5. Most unusual descriptor-region elite
6. Best elite from a sparsely occupied region
7. Representative failed candidate, if useful
```

For each representative elite, include:

```text
- problem name
- seed
- generation/evaluation index
- archive cell/codebook ID
- descriptor vector
- functionality/synthesis/OpenROAD status
- area/power/timing values
- fitness
- comparison to reference/golden
- canonical netlist hash
- short RTL diff or summary
- netlist motif summary
- reason this elite is representative
```

This section will be useful later for the paper. It can produce qualitative figures showing that Auto-BD discovers different implementation strategies, not just random archive cells.

---

## 13.3 Centralized Cross-Method Report Requirement

In addition to per-method reports, the researcher must implement a centralized report generator that compiles all tested methods into a single comparison report.

Recommended structure:

```text
auto_bd_reports/
  compile_all_methods.py
  report_config.yaml
  methods.yaml

  centralized_report/
    report.md
    report.html
    summary.json
    tables/
      method_leaderboard.csv
      signoff_gate_matrix.csv
      robustness_comparison.csv
      ppa_comparison.csv
      qd_comparison.csv
      descriptor_quality_comparison.csv
      compute_cost_comparison.csv
      per_problem_win_loss_matrix.csv
    figures/
      method_leaderboard_radar.png
      signoff_gate_matrix.png
      ppa_hypervolume_comparison.png
      best_fitness_anytime_all_methods.png
      qd_score_anytime_all_methods.png
      archive_coverage_all_methods.png
      per_problem_win_loss_heatmap.png
      robustness_funnel_all_methods.png
      unique_netlist_comparison.png
      descriptor_correlation_summary.png
```

The centralized report should be generated with a command like:

```bash
python auto_bd_reports/compile_all_methods.py \
  --methods-yaml auto_bd_reports/methods.yaml \
  --baseline revolution,smooth_qd_v2_manual_bd \
  --out auto_bd_reports/centralized_report/
```

The centralized report must include all attempted methods, including rejected methods. Rejected methods are important because the existing task already requires every method card to record motivation, results, accept/reject decision, and reason for rejection; the centralized report should make those failed attempts visible and searchable. 

---

## 13.4 Centralized Report Contents

The centralized report should contain the following.

### A. Method Leaderboard

A sortable table:

| Method                  | Family       | Robustness | Avg Best Fitness | PPA HV | QD Score | Coverage | Unique Netlists | Descriptor Quality | Verdict       |
| ----------------------- | ------------ | ---------: | ---------------: | -----: | -------: | -------: | --------------: | -----------------: | ------------- |
| REvolution              | baseline     |       pass |                — |      — |        — |        — |               — |                  — | baseline      |
| Smooth-QD manual BD     | baseline     |       pass |            1.00× |  1.00× |    1.00× |    1.00× |           1.00× |             manual | baseline      |
| Random BD               | control      |  pass/fail |                … |      … |        … |        … |               … |                low | reject        |
| Yosys-stat BD           | simple       |          … |                … |      … |        … |        … |               … |             medium | accept/reject |
| Motif occupancy BD      | AutoQD-style |          … |                … |      … |        … |        … |               … |               high | accept/reject |
| Synthesis-trajectory BD | RTL-native   |          … |                … |      … |        … |        … |               … |               high | accept/reject |
| AURORA encoder BD       | learned      |          … |                … |      … |        … |        … |               … |                TBD | accept/reject |
| VQ codebook BD          | codebook     |          … |                … |      … |        … |        … |               … |                TBD | accept/reject |

This table should be the first thing advisors or reviewers can inspect.

---

### B. Sign-Off Gate Matrix

A compact binary/colored matrix:

```text
rows = methods
columns = gates
cell = pass / fail / warning / not tested
```

Columns:

```text
functionality robustness
synthesis robustness
valid-PPA coverage
OpenROAD robustness
average best fitness uplift
PPA hypervolume uplift
QD score uplift
archive coverage uplift
unique elite netlist uplift
descriptor non-collapse
renaming/formatting stability
interpretability
compute cost acceptable
final accepted
```

This prevents vague claims such as “method looks promising” without showing which gate it actually passed.

---

### C. Cross-Method Anytime Curves

The centralized report must overlay methods on the same plots:

```text
1. best fitness vs evaluations
2. PPA hypervolume vs evaluations
3. QD score vs evaluations
4. archive coverage vs evaluations
5. functionality pass rate vs generation
6. synthesis pass rate vs generation
```

The curves should include confidence bands when multiple seeds are available.

---

### D. Per-Problem Win/Loss Matrix

Use a heatmap:

```text
rows = benchmark problems
columns = methods
value = normalized improvement over Smooth-QD manual BD
```

Separate versions:

```text
- best fitness
- PPA hypervolume
- valid-PPA count
- QD score
- unique elite netlists
```

This is important because a method may be excellent on arithmetic-heavy tasks but weak on FSM-like tasks. The centralized report should expose such regimes.

---

### E. Method-Family Comparison

Group methods by family:

```text
- baseline
- random/control
- simple structural statistics
- motif occupancy
- synthesis trajectory
- learned continuous latent
- VQ/codebook
- other RTL-native
```

Report:

```text
mean performance by family
best method per family
failure mode by family
compute cost by family
descriptor interpretability by family
```

This helps decide whether the journal story should be “learned Auto-BD wins” or “simple hardware-native synthesis trajectory wins.”

---

### F. Compute and Runtime Cost Comparison

Every method should report overhead.

Required metrics:

```text
descriptor extraction time per candidate
encoder training time, if any
archive insertion time
report generation time
extra storage per candidate
total disk usage per method
OpenROAD/synthesis reuse rate
failed extraction count
```

A method that gives a small PPA improvement but massively increases runtime or storage should be marked as high-risk unless the performance gain is very strong.

---

## 13.5 Standardized Data Schema

To make per-method and centralized reports possible, every method should emit a common artifact schema.

Recommended files:

```text
results/
  candidates.parquet
  elites.parquet
  archive_snapshots.parquet
  per_generation_metrics.parquet
  per_problem_metrics.parquet
  descriptor_vectors.parquet
  descriptor_metadata.json
  ppa_metrics.parquet
  robustness_metrics.json
  netlist_hashes.parquet
  representative_examples.json
  method_summary.json
```

Minimum required fields in `candidates.parquet`:

```text
method_name
method_family
problem_id
benchmark_source
seed
generation
candidate_id
parent_id
operator_name
valid_syntax
valid_functionality
valid_synthesis
valid_openroad
valid_ppa
area
power
timing_or_clock_period
fitness
ppa_hypervolume_contribution
descriptor_vector
archive_cell_id
canonical_netlist_hash
rtl_path
netlist_path
log_path
failure_reason
```

Minimum required fields in `method_summary.json`:

```json
{
  "method_name": "...",
  "method_family": "...",
  "status": "accepted|rejected|needs_more_evidence",
  "main_claim": "...",
  "benchmark_subset": "...",
  "num_problems": 0,
  "num_seeds": 0,
  "budget_per_problem": 0,
  "robustness": {},
  "ppa": {},
  "qd": {},
  "descriptor_quality": {},
  "compute_cost": {},
  "signoff_gates": {},
  "key_figures": [],
  "key_tables": [],
  "representative_examples": []
}
```

The key point: every method must emit enough standardized data that the centralized report can run without custom parsing logic for each method.

---

## 13.6 Report Quality Gates

Add a new sign-off gate:

```text
Gate 6 — Report Reproducibility and Visualization Completeness

A method is not considered complete unless:
1. per-method report generation runs from raw/processed artifacts with one command,
2. report.md and report.html are generated,
3. required tables are generated as CSV files,
4. required figures are generated as PNG/SVG files,
5. summary.json is generated,
6. centralized report successfully includes the method,
7. all plotted numbers trace back to saved raw artifacts,
8. accept/reject decision is visible in both per-method and centralized reports.
```

A method that has promising numbers but no reproducible report should be marked:

```text
status = needs_more_evidence
reason = report artifacts incomplete
```

---

## 13.7 Anti-Hack Rules for Reporting

Add these reporting-specific anti-hack rules:

```text
1. The report generator must include all problems in the declared subset.
2. Failed candidates must appear in robustness/failure plots.
3. Invalid candidates must not silently disappear from denominator-sensitive metrics.
4. Per-problem results must be shown alongside averages.
5. All baselines must use the same reporting pipeline.
6. Any excluded run must be listed with a reason.
7. Any manually corrected run must be listed in a measurement-disclosure section.
8. Figures must be generated by script, not manually edited.
9. The centralized report must include rejected methods.
10. The final selected method must be selected from the centralized report, not from informal notes.
```

This is especially important because prior Smooth-QD analysis showed that apparent PPA gains can be misleading when averaged over fewer scorable or functionally valid designs; the reporting system should make this failure mode visible automatically. 

---

## 13.8 Recommended Visualization Checklist

For every method, require this checklist.

```text
Per-method report must include:

[ ] one-page method summary
[ ] sign-off gate dashboard
[ ] robustness funnel
[ ] failure breakdown bar plot
[ ] valid-PPA per-problem heatmap
[ ] best-fitness anytime curve
[ ] PPA hypervolume anytime curve
[ ] power/area/timing improvement plot
[ ] per-problem win/loss chart
[ ] QD score anytime curve
[ ] archive coverage anytime curve
[ ] archive occupancy heatmap
[ ] elite-fitness archive heatmap
[ ] archive entropy curve
[ ] descriptor scatter plot
[ ] descriptor-vs-manual-BD correlation heatmap
[ ] descriptor-vs-PPA correlation heatmap
[ ] unique netlist hash analysis
[ ] representative elite examples
[ ] final accept/reject rationale
```

For the centralized report:

```text
Centralized report must include:

[ ] method leaderboard
[ ] sign-off gate matrix
[ ] all-method robustness comparison
[ ] all-method best-fitness anytime curves
[ ] all-method PPA hypervolume curves
[ ] all-method QD score curves
[ ] all-method archive coverage curves
[ ] per-problem win/loss heatmap
[ ] unique netlist comparison
[ ] descriptor-quality comparison
[ ] compute-cost comparison
[ ] final recommendation table
```

---

## 13.9 Updated Final Deliverables

Replace the old final-deliverables section with this expanded version.

```text
The researcher should deliver:

1. Benchmark subset selection report
2. Reproduced REvolution baseline results
3. Reproduced Smooth-QD v2 manual-BD baseline results
4. Auto-BD method cards for every attempted method
5. Descriptor extraction code
6. Archive integration code
7. Experiment scripts
8. Raw logs and candidate artifacts
9. Standardized result files:
   - candidates.parquet
   - elites.parquet
   - archive_snapshots.parquet
   - per_generation_metrics.parquet
   - per_problem_metrics.parquet
   - descriptor_vectors.parquet
   - method_summary.json
10. Per-method report generator for every method
11. Per-method report.md and report.html for every method
12. Per-method summary tables
13. Per-method visualizations
14. Per-method representative RTL/netlist examples
15. Per-method accept_reject.md
16. Centralized report generator
17. Centralized cross-method report.md and report.html
18. Centralized leaderboard table
19. Centralized sign-off gate matrix
20. Centralized cross-method plots
21. Final selected-method recommendation
22. Draft journal methodology section
23. Draft journal ablation/failure-analysis section
```

---

## 13.10 Updated Short Task Paragraph

You can add this to the short version you give the researcher:

> **In addition to implementing each Auto-BD method, you must build a standardized report-generation and visualization pipeline. Every proposed method must have its own subdirectory containing a method card, implementation, experiment artifacts, generated report, tables, figures, representative RTL/netlist examples, and an accept/reject decision. The report must include robustness funnels, PPA anytime curves, PPA hypervolume curves, QD score and archive coverage curves, archive heatmaps, descriptor correlation plots, unique netlist analysis, and representative elite examples. You must also implement a centralized report generator that compiles all attempted methods — including rejected methods — into a single leaderboard, sign-off gate matrix, cross-method plots, per-problem win/loss heatmaps, and final recommendation table. A method is not considered complete unless both its per-method report and the centralized comparison report can be regenerated from saved artifacts by script.**

This addition would make the task much harder to “hack” because the person cannot just report one good number. They have to show the full pipeline behavior, full archive behavior, per-problem trends, descriptor interpretability, and final accept/reject logic in a consistent format.
