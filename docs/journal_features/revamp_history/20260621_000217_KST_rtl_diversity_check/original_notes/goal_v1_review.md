Q: We came up with an intial goal/plan to actually answer the two questions. Do you think you can review it and help to fill in any holes or any considerations that we may have missed before? Additioanl details you think we need to include loop holes for validation et cetera. Try to review based on combined_goal_plan_spec_v1.md

==============
A:
Overall: **this is a strong plan**. It correctly pivots away from “try more Auto-BD variants” and toward the prior scientific question: **does implementation diversity actually matter for RTL PPA evolution?** It also correctly treats the 20260618 Auto-BD results as negative/control evidence rather than as promising methods to rerun. The plan defines layered diversity — `D_code`, `D_struct`, `D_synth`, `D_ppa`, `D_lineage` — and explicitly says useful diversity must either contribute to the PPA Pareto front or produce useful descendants, not merely increase archive occupancy.

My main recommendation is: **keep the plan, but tighten the claim hierarchy, statistical controls, descriptor-fitting leakage rules, and the proceed/no-proceed gates.** The current plan is already good, but it still has a few loopholes where an implementer could produce an attractive report that does not really answer whether diversity is useful.

---

# 1. High-level assessment

I would grade the current plan as:

```text
Research framing:              A-
Practical execution plan:       B+/A-
Anti-hack validation:           B+
Report/visualization spec:      A-
Statistical rigor:              B
Causal claim protection:        B-
Remaining loophole risk:        medium, fixable
```

The strongest parts are:

1. **The plan asks the right prior question.** It does not assume QD helps. It asks whether diversity is predictive, reconstructive, or useful before adding more AutoQD/AURORA/VQ machinery.

2. **The plan uses the negative Auto-BD results correctly.** The previous random, Yosys-stat, motif, ST-NOD, PCA/RFF, and VQ/codebook variants are treated as mixed/negative evidence, not as fresh promising baselines.

3. **The diversity definition is much better than “different code.”** The plan explicitly rejects functional diversity and defines useful diversity as implementation diversity under functional equivalence.

4. **The experiment set is well chosen.** Cluster contribution, oracle downsampling, early-diversity prediction, parent-child jump analysis, and shadow archive replay are exactly the right first experiments before any new live QD run.

5. **The adversarial validation prompt is strong.** It already catches many common failure modes: archive occupancy-only claims, invalid-candidate leakage, unclear corpus coverage, small-subset overclaiming, uncontrolled live runs, and premature Qwen/DeepGate/AURORA promotion.

The biggest thing to fix is this:

> The current plan can still accidentally let **descriptive diversity** count as evidence for **useful diversity**.

That distinction should be made stricter.

---

# 2. Most important missing piece: define claim levels

Right now, the plan says the report should state whether diversity is “predictive, reconstructive, descriptive-only, or inconclusive.” That is good, but I would make this a formal claim hierarchy.

Add this section:

```markdown
## Claim Hierarchy

The report must classify every diversity result into exactly one of the
following claim levels.

### Level 0 — Descriptive Diversity
The corpus contains multiple implementation clusters or descriptor regions.

This does not imply diversity helps search.

Example evidence:
- multiple clusters exist
- archive occupancy is nonzero
- Pareto front has candidates with different descriptor values

Allowed claim:
"RTL candidates occupy multiple implementation regions."

Not allowed:
"Diversity helps PPA evolution."

### Level 1 — Reconstructive Diversity
Given a fixed historical candidate pool, diversity-aware subset selection
reconstructs a better Pareto front or HV than scalar top-k or random selection
at equal candidate budget.

Allowed claim:
"Diversity would have helped retain a better design set from this pool."

Not allowed:
"Diversity would improve online evolution."

### Level 2 — Predictive Diversity
Early diversity predicts later best fitness, HV, valid-PPA count, Pareto-front
expansion, or descendant quality after controlling for valid candidate count,
problem, seed, method, and budget.

Allowed claim:
"Early implementation diversity is associated with later PPA outcomes."

Not allowed:
"Diversity causally improves search."

### Level 3 — Lineage / Mechanistic Diversity
Diverse parents or descriptor jumps are shown to produce useful descendants,
Pareto-front members, or later high-quality lineages.

Allowed claim:
"Diversity appears to act as a stepping-stone mechanism in these runs."

### Level 4 — Active Causal Diversity
A prospective diversity-pressure intervention improves HV, best fitness,
valid-PPA-safe Pareto quality, or descendant yield under the same LLM/evaluation
budget without robustness regression.

Allowed claim:
"Diversity pressure improves RTL PPA evolution in this setting."

### Level 5 — Method Claim
A concrete diversity/QD/Auto-BD algorithm improves over landing Smooth-QD
manual-BD under frozen budget, seeds, benchmark subset, and reporting gates.

Allowed claim:
"Our method improves RTL PPA evolution."
```

Then add this rule:

```text
Paper-facing claims must not use a higher claim level than the evidence supports.
```

This is the single best protection against overclaiming.

---

# 3. Tighten the proceed-to-Auto-BD rule

The current plan says to proceed if **at least two D gates pass**. That is too permissive.

For example, `D2 multi_cluster_front` + `D6 interpretable_regions` could pass even if diversity is only descriptive. That should not be enough to justify Auto-BD.

I would replace the rule with:

```markdown
## Proceed / No-Proceed Decision Rule

Proceed to full Auto-BD only if:

1. At least one utility gate passes:
   - D1 early_predictive, or
   - D3 replay_retention, or
   - D4 prospective_moderate_diversity, or
   - D5 real_beats_random

AND

2. At least one meaning/interpretability gate passes:
   - D2 multi_cluster_front, or
   - D6 interpretable_regions

AND

3. The evidence is not explained solely by valid candidate count, duplicate
   suppression, or benchmark/problem imbalance.

If only D2 and D6 pass:
  conclusion = descriptive / illumination only.
  Do not proceed to Auto-BD as an optimization method.

If only D3 passes:
  conclusion = reconstructive.
  Consider reporting/archive use, but do not claim causal search improvement.

If D1 or D4 passes:
  conclusion = predictive or active evidence.
  Proceed to quality-gated diversity or Auto-BD follow-up.

If no gate passes:
  deprioritize Auto-BD and focus on classic REvolution/Smooth-QD operator or
  repair improvements.
```

This makes the decision much more defensible.

---

# 4. Add stricter statistical controls

The plan already says D1 should control for valid candidate count, problem, and seed. That is good. I would make the regression and statistical protocol explicit.

Add:

```markdown
## Statistical Analysis Protocol

Primary unit:
- problem × seed × method × run

Primary controls:
- valid candidate count
- valid-PPA candidate count
- total evaluated candidates
- method
- problem
- seed
- model
- prompt policy
- evaluation budget

Preferred models:
1. Mixed-effects regression:
   final_HV ~ early_diversity + valid_PPA_count + method + budget
              + (1 | problem) + (1 | seed)

2. Paired fixed-effect regression:
   final_HV ~ early_diversity + valid_PPA_count
              + C(problem) + C(seed) + C(method)

3. Rank-based robustness check:
   Spearman correlation within each problem,
   then summarize sign and magnitude across problems.

Required reporting:
- coefficient sign
- confidence interval
- bootstrap interval
- p-value or permutation p-value
- number of analyzable problem/seed/method groups
- number excluded and why
- sensitivity with and without valid candidate count
- sensitivity with and without outlier problems
```

Also add:

```markdown
## Multiple Testing Rule

Because many descriptors and diversity metrics are tested, the report must
separate exploratory from confirmatory claims.

- Exploratory findings may guide follow-up.
- Final claims must either use predeclared primary metrics or be validated on
  a held-out corpus/subset.
- If many descriptor families are compared, use Holm correction, Benjamini-
  Hochberg FDR, or clearly mark results as exploratory.
```

Without this, the report can accidentally cherry-pick the one descriptor/metric that correlates with HV.

---

# 5. Add minimum sample-size gates

The D gates need minimum data requirements. Otherwise a gate can pass on too few analyzable problems.

Add:

```markdown
## Minimum Evidence Requirements

A D gate cannot be marked PASS unless minimum coverage is satisfied.

For D1 early_predictive:
- at least 8 analyzable problems, preferably 12+
- at least 3 seeds or independent runs when available
- at least 20 valid-PPA candidates per problem across the analyzed runs,
  unless explicitly labeled low-data/preliminary

For D2 multi_cluster_front:
- at least 8 analyzable problems
- at least 5 valid-PPA candidates per problem
- at least 3 Pareto-front candidates per problem, or the problem is excluded
  from D2 with reason

For D3 replay_retention:
- at least 8 analyzable problems
- equal candidate budgets across retention policies
- random-selection baseline repeated with at least 20 random seeds

For D4 prospective_moderate_diversity:
- at least 3 seeds
- same LLM, prompt policy, budget, and subset
- same validity/PPA evaluation flow

For D5 real_beats_random:
- identical archive mechanics
- identical candidate pool or paired live-run budget
- random descriptor repeated over at least 5 descriptor seeds if offline,
  or at least 3 run seeds if online
```

This will stop small convenience subsets from becoming “evidence.”

---

# 6. Clarify historical-corpus confounding

The plan correctly says historical runs may differ in model, prompt, seeds, and budgets. But this needs to become an analysis rule.

Add:

```markdown
## Historical Corpus Pairing And Confound Policy

Historical corpora may be unpaired across method, model, prompt, seed, and
budget. Therefore, conclusions must be stratified.

Corpus strata:
1. Fully paired:
   same problem, seed, model, prompt policy, budget, and evaluator

2. Partially paired:
   same problem and evaluator, but different seed or budget

3. Unpaired:
   different problem mix, model, prompt policy, or evaluator

Claim rules:
- Active comparative claims should use fully paired data.
- Predictive/descriptive analyses may use partially paired or unpaired data,
  but must include method/model/budget controls.
- Unpaired corpora cannot support "method A is better than method B" claims.
- Unpaired corpora can support "diversity exists" or "descriptor correlates
  with PPA within this corpus" claims.
```

This matters because the plan wants to use read-only historical roots, Auto-BD standard results, old `exp/` roots, archived baselines, and possibly `aspdac2026-paper` artifacts. That is good, but the report must not treat all these artifacts as one clean experiment.

---

# 7. Strengthen descriptor fitting and leakage controls

The plan already has leakage rules. I would add a specific rule for PCA, clustering, UMAP, k-means, Qwen projection, and DeepGate projection.

The main loophole is this:

> If you fit PCA/clusters on the whole corpus, including final candidates, then use the resulting clusters to claim “early diversity predicts final HV,” you may have a post-hoc leakage problem.

Add:

```markdown
## Descriptor Fitting And Projection Leakage Policy

Every descriptor must be labeled as one of:

1. intrinsic:
   no fitting required, e.g., manual BD, Yosys-stat, raw motif vector

2. frozen-pretrained:
   frozen model, no corpus fitting, e.g., Qwen embedding before PCA

3. fitted-unsupervised:
   PCA, k-means, VQ, UMAP, scaler, or clustering fitted on a declared corpus

4. post-hoc visualization only:
   embedding/projection fitted after the full run only for visualization

For predictive claims:
- any fitted projection, scaler, or clustering must be fitted only on data
  available before the prediction cutoff, or on a separate training/dev corpus.
- if fitted on the full corpus, it may be used for descriptive/reconstructive
  analysis only, not predictive claims.

For search-method claims:
- descriptor fitting artifacts must be frozen before the live run.
- each candidate must record descriptor_version, scaler_hash, projection_hash,
  cluster_hash, and fitting_corpus_hash.

UMAP/t-SNE:
- visualization only by default.
- cannot be used for quantitative diversity metrics unless its fitting protocol,
  random seed, and stability are validated.
```

This is very important for Qwen and DeepGate3. The encoder itself may be frozen, but the projection/clustering over embeddings is often not.

---

# 8. Improve the oracle downsampling test

The oracle downsampling test is excellent, but it can be misleading if it is too oracle-like. I would split it into two versions.

Add:

```markdown
## Oracle Downsampling Variants

Run two versions.

### E2a: Oracle Reconstructive Downsampling

Allowed information:
- final PPA
- final valid-PPA status
- final descriptor values

Purpose:
- upper bound on whether diversity can reconstruct a better front from an
  existing pool.

Claim level:
- reconstructive only.

### E2b: Online-Available Downsampling

Allowed information:
- information available at candidate insertion time
- no future descendants
- no final-run global statistics unless predeclared
- no held-out/future-fitted projection

Purpose:
- approximate whether an online archive could have made the same retention
  decision.

Claim level:
- closer to method evidence.

Retention policies:
- scalar top-k
- random
- PPA Pareto top-k
- quality + canonical hash diversity
- quality + motif diversity
- quality + ST-NOD diversity
- quality + embedding diversity
- diversity-only, for diagnosis only

Equal-budget rule:
- all selectors retain exactly k candidates per problem/seed/method.
- sweep k values: 5, 10, 20, 50 if data allows.
```

Also add:

```text
Report quality-only vs quality+diversity, not diversity-only alone.
```

This will avoid proving that diversity keeps different candidates while sacrificing quality.

---

# 9. Strengthen D2 multi-cluster-front gate

Current D2 says the front should contain candidates from at least two structural clusters in ≥60% of analyzable problems. That can be too easy if clusters are arbitrary.

Add:

```markdown
## D2 Multi-Cluster Front Strengthening

D2 PASS requires:

1. Pareto front contains candidates from at least two structural clusters in
   >=60% of analyzable problems.

2. At least two clusters have nontrivial contribution:
   - each contributes >=10% of Pareto-front candidates, or
   - each contributes >=5% of hypervolume contribution, or
   - each owns a distinct objective extreme such as best area, best power,
     or best timing.

3. The result beats random cluster labels:
   - compare against random cluster assignment with the same number and size
     distribution of clusters.

4. Cluster assignments are stable:
   - bootstrap adjusted Rand index, or
   - repeated clustering stability check, or
   - motif/semantic explanation for deterministic clusters.
```

This prevents arbitrary k-means from manufacturing “multi-cluster” evidence.

---

# 10. Strengthen D5 real descriptor beats random

The plan already has `D5 real_beats_random`, which is crucial. I would define it more precisely.

Add:

```markdown
## D5 Real Descriptor Beats Random: Required Controls

A real descriptor beats random only if:

1. Same candidate pool or same live-run budget.
2. Same archive mechanics.
3. Same number of descriptor dimensions or same number of cells.
4. Same common-audit space.
5. Same retained candidate budget.
6. Same validity denominator.
7. Random descriptor is repeated over multiple random seeds.
8. Improvement holds on PPA/HV or valid-PPA-safe front quality, not only
   internal archive occupancy.

Reject D5 if:
- real descriptor improves internal coverage only;
- real descriptor has lower valid-PPA count and the gain disappears after
  validity normalization;
- real descriptor uses more cells or easier binning than random.
```

This is directly motivated by the previous Auto-BD runs, where random descriptors and real descriptors sometimes produced archive/diversity signals without robust PPA gains.

---

# 11. Add “validity-normalized diversity” metrics

A huge theme from the negative Auto-BD result is that some methods reorganized archives but hurt the valid-PPA funnel. The new report should include metrics that make this unavoidable.

Add:

```markdown
## Validity-Normalized Diversity Metrics

For every descriptor family, report:

- diversity among all generated candidates
- diversity among syntax-valid candidates
- diversity among functionally valid candidates
- diversity among synthesis-valid candidates
- diversity among valid-PPA candidates
- diversity among Pareto-front candidates

Also report efficiency metrics:

- valid_PPA_per_occupied_cell
- HV_per_valid_PPA_candidate
- Pareto_front_members_per_valid_PPA_candidate
- unique_motif_signatures_per_valid_PPA_candidate
- common_audit_QD_per_valid_PPA_candidate

Interpretation:
- high all-candidate diversity but low valid-PPA diversity means the descriptor
  encourages invalid variety.
- high valid-PPA diversity but low HV means diversity is decorative.
- high valid-PPA diversity and high HV/front contribution means diversity is
  useful.
```

This is one of the most important additions.

---

# 12. Add “diversity efficiency frontier” visualization

The report already has many good plots. Add one more that directly addresses the previous failure.

```markdown
## Required Visualization: Diversity Efficiency Frontier

For each method/descriptor family, plot:

x-axis:
  valid-PPA rate or valid-PPA candidate count

y-axis:
  PPA hypervolume, best fitness, or common-audit QD score

marker:
  descriptor family

color:
  method family or corpus source

Interpretation:
- upper-right = useful diversity / quality
- upper-left = high quality but low valid throughput
- lower-right = robust but low quality
- lower-left = reject
```

Also include:

```text
PPA HV vs common-audit diversity, with point size = valid-PPA rate.
```

This will make it clear whether diversity is helping or just trading away robustness.

---

# 13. Add functional correctness audit

The current plan separates functional validity and says functional diversity should not count as useful. Good. But visible testbench pass may not be enough.

For final paper-facing evidence, add:

```markdown
## Functional Correctness Audit

For any candidate used as a representative elite, best-PPA example, or key
Pareto-front example:

1. If a golden/reference RTL exists:
   - run Yosys equivalence checking for combinational tasks when feasible.
   - for sequential tasks, run bounded equivalence or additional randomized
     simulation when feasible.

2. If formal equivalence is infeasible:
   - run extra randomized tests beyond the benchmark testbench.
   - record test count, seed, reset policy, and assumptions.

3. At minimum audit:
   - best fitness candidate per problem,
   - largest HV-contributing candidate per problem,
   - representative cluster examples,
   - any candidate with unusually large PPA improvement.

4. Label candidates as:
   - benchmark-pass only,
   - extra-sim pass,
   - formal/equivalence pass,
   - inconclusive.
```

This matters because QD/diversity can accidentally preserve under-tested designs that look good on PPA.

---

# 14. Add a “descendant yield” definition

The plan mentions useful descendants and parent-child jump analysis, but it should define the metric.

Add:

```markdown
## Descendant Yield Metrics

For a candidate c at generation t, define descendants within horizon h:

desc_h(c) = candidates generated from c directly or indirectly within h generations.

Useful descendant indicators:
- any descendant is valid-PPA
- any descendant improves parent fitness by epsilon
- any descendant is PPA non-dominated
- any descendant contributes HV
- any descendant enters final Pareto front

Metrics:
- valid_descendant_yield_h
- improved_descendant_yield_h
- pareto_descendant_yield_h
- hv_descendant_yield_h
- expected_best_descendant_fitness_h

Recommended horizons:
- h = 1 direct child
- h = 2 if lineage is reliable
- h = final run if ancestry graph is complete
```

Then for parent-child jump:

```text
descriptor_distance(parent, child) vs child validity/PPA
descriptor_distance(parent, child) vs descendant_yield_h
```

This makes the “stepping-stone” claim measurable.

---

# 15. Add exact diversity metric definitions

The plan lists many metrics but should define canonical formulas. Otherwise different implementers may compute different “coverage” or “entropy.”

Add:

```markdown
## Canonical Diversity Metrics

For a candidate set S and descriptor φ:

1. Coverage:
   coverage(S) = number of occupied cells in fixed audit grid

2. Normalized coverage:
   norm_coverage(S) = occupied_cells / total_cells

3. Occupancy entropy:
   H(S) = -sum_c p_c log(p_c)
   H_norm(S) = H(S) / log(number_of_occupied_cells or total_cells)

4. Mean kNN distance:
   mean over candidates of distance to kth nearest neighbor in normalized
   descriptor space; use k = 5 by default.

5. Cluster count:
   number of clusters with at least min_cluster_size candidates.

6. Effective cluster count:
   exp(entropy over cluster occupancy)

7. Unique canonical netlists:
   count of unique name-insensitive canonical netlist hashes.

8. Unique motif signatures:
   count of unique motif-signature hashes or clusters after thresholding.

9. PPA-front structural diversity:
   number/effective number of structural clusters among non-dominated candidates.

10. HV-contributing diversity:
   number/effective number of structural clusters with nonzero HV contribution.
```

Also specify:

```text
All descriptor-space distances must use standardized features.
Do not compute Euclidean distances over raw mixed-scale features.
```

---

# 16. Add fixed common-audit spaces explicitly

The plan says common-audit metrics are required. Good. I would define the actual common audit spaces now.

Add:

```markdown
## Fixed Common Audit Spaces

Every descriptor family must be evaluated in the following fixed audit spaces.

### Audit A: Manual-BD audit space
Axes:
- combinational logic depth
- FF depth
- log combinational gate count

### Audit B: Yosys-stat audit space
Axes/features:
- log total cell count
- sequential ratio
- mux ratio
- arithmetic ratio
- logic depth
- fanout mean/max
- cell-family histogram

Projection:
- standardize using dev corpus
- PCA or CVT fitted on dev corpus only
- freeze artifact hash

### Audit C: Motif audit space
Features:
- logic/control/arithmetic/other ratios
- motif entropy
- pathlet/cone/fanout/reconvergence motif histogram if available

Projection:
- fixed PCA/CVT or quantile grid fitted on dev corpus only

### Audit D: PPA objective audit space
Axes:
- normalized area improvement
- normalized power improvement
- normalized timing improvement for sequential tasks

Use only for objective-front spread, not as behavior descriptor evidence.
```

This makes cross-method diversity comparisons much cleaner.

---

# 17. Add cluster-label negative controls

Cluster contribution is a central test, but clustering can hallucinate structure.

Add:

```markdown
## Cluster Negative Controls

For every cluster-based claim, include controls:

1. Random labels with same number of clusters and same cluster-size distribution.
2. Shuffled descriptor labels within each problem.
3. Descriptor dimensions permuted independently.
4. Duplicate-only clustering by canonical netlist hash.

A real descriptor/cluster result must beat these controls on:
- Pareto-front cluster contribution,
- HV contribution concentration,
- descendant yield,
- or replay retention.
```

This helps prove the clusters are meaningful, not just arbitrary partitions.

---

# 18. Add Qwen/DeepGate-specific pitfalls

The plan already says Qwen3 and DeepGate3 are diagnostic only. Add practical constraints.

## Qwen / text embedding

```markdown
## Qwen Embedding Specific Rules

Run four text variants:
1. raw RTL
2. comment-stripped RTL
3. identifier-normalized RTL
4. Yosys-normalized write_verilog output, if available

For every candidate, record:
- model name
- checkpoint path/hash
- max length
- truncation flag
- number of tokens/chunks
- pooling method
- instruction prompt
- embedding dimension
- device
- batch size

Required stability checks:
- raw vs comment-stripped distance
- raw vs identifier-normalized distance
- identifier-normalized vs semantically different candidate distance

If Qwen mainly separates formatting, comments, or naming:
  verdict = text-style diagnostic only.
```

Add a cheap baseline:

```text
Compare Qwen against TF-IDF or bag-of-Verilog-token features.
```

If Qwen does not beat a bag-of-token baseline, it is not worth using as a BD.

## DeepGate3 / netlist embedding

```markdown
## DeepGate3 Specific Rules

Before using DeepGate3, record:

- exact graph export format:
  AIG / AIGER / Yosys JSON / gate graph
- whether sequential elements are included or cone-split
- how FFs, PIs, POs, constants, and blackboxes are represented
- whether cell types are preserved or collapsed to AIG gates
- graph size distribution
- extraction failure cases
- model checkpoint and inference code version

Sequential policy:
- for sequential modules, either:
  a. embed register-to-register cones and pool them, or
  b. explicitly mark DeepGate3 as combinational/AIG-only diagnostic.

Do not compare DeepGate3 against ST-NOD without stating what information each
representation retains or loses.
```

This is important because AIG embeddings may erase mux/arithmetic/cell-family distinctions that ST-NOD captures.

---

# 19. Add “what if the answer is no?” section

The plan should explicitly say what conclusions are acceptable if diversity does not matter.

Add:

```markdown
## Negative Outcome Interpretation

If the diversity necessity study fails, this is still a valid result.

Possible conclusions:

1. Diversity is descriptive but not useful:
   candidates occupy different implementation regions, but those regions do
   not predict PPA quality or descendants.

2. Diversity is reconstructive but not causal:
   diversity-aware selection can reconstruct a better historical front, but
   there is no evidence it improves online evolution.

3. Diversity is harmful under current coupling:
   diversity pressure trades away valid-PPA throughput and repair.

4. Manual Smooth-QD archive remains useful as a reporting/Pareto deliverable,
   but Auto-BD should not be the main journal novelty.

5. Future work should focus on:
   - stronger repair operators,
   - better code-level exploitation,
   - benchmark capability,
   - quality-gated novelty lane,
   - or duplicate suppression rather than full Auto-BD.
```

This helps prevent pressure to force a positive Auto-BD story.

---

# 20. Add exact report verdict language

At the end of the Diversity Necessity Report, require one of these verdicts:

```markdown
## Final Verdict

Choose exactly one:

### Verdict A — Diversity not supported
Evidence is descriptive only or inconclusive.
Do not proceed to Auto-BD.

### Verdict B — Diversity useful for illumination only
Diversity reveals different implementation/PPA regions, but does not predict
or improve PPA search.
Use Smooth-QD/archive as reporting/frontier tool only.

### Verdict C — Diversity reconstructive
Diversity-aware retention reconstructs better historical Pareto fronts, but
online utility is not established.
Proceed only to shadow archives or quality-gated offline selection.

### Verdict D — Diversity predictive
Early diversity predicts later PPA/HV/descendant outcomes.
Proceed to small prospective diversity-pressure sweep.

### Verdict E — Diversity actively useful
Prospective diversity pressure improves quality or HV without robustness loss.
Proceed to quality-gated Auto-BD or diversity-aware parent selection.

### Verdict F — Auto-BD candidate justified
A specific descriptor family passes robustness, quality, common-audit, and
interpretability gates.
Proceed to journal-candidate method development.
```

This makes the final decision much less ambiguous.

---

# 21. Add required “negative result table” from 20260618

The plan references the 20260618 results, but the report should include a compact table so future readers do not forget the prior failure.

Add to the report:

```text
Prior Auto-BD Negative Control Summary

method                    valid-PPA     fitness/HV read        verdict
classic REvolution         baseline      strong classic ref     baseline
landing Smooth-QD manual   strongest     best practical         baseline
random descriptor          lower valid   no robust gain         control
Yosys-stat                 lower valid   too coarse             reject/control
motif occupancy            lower valid   poor HV                reject/control
ST-NOD                     audit QD up   valid-PPA down         interesting negative
SR raw PCA                 robust-ish    no PPA gain            reject
SR random ReLU PCA         seed-1 signal seed-3 failed          reject
SR RFF PCA                 diversity up  no PPA gain            reject
VQ codebook                valid collapse all metrics regress   strong reject
```

This is important because the previous preliminary work showed no tested Auto-BD method beat classic or landing Smooth-QD robustly; ST-NOD was scientifically interesting but lost too much valid-PPA throughput.

---

# 22. Add implementation-level artifact schema

The plan says candidate audit table should include many fields. I would make the schema explicit.

Add:

```markdown
## Candidate Audit Table Schema

Required columns:

Identity:
- corpus_root
- run_id
- method
- descriptor_family
- model_id
- benchmark
- problem_id
- seed
- generation
- candidate_id
- parent_id
- operator
- prompt_hash
- config_hash

Validity funnel:
- syntax_pass
- interface_pass
- simulation_compile_pass
- functional_pass
- synthesis_pass
- openroad_pass
- valid_ppa
- failure_stage
- failure_reason

PPA:
- area
- power
- timing_or_period
- area_improvement
- power_improvement
- timing_improvement
- scalar_fitness
- ppa_hv_contribution
- pareto_front_member

Artifacts:
- rtl_path
- canonical_rtl_path
- yosys_json_path
- aig_path
- techmapped_netlist_path
- openroad_report_path
- log_path

Descriptors:
- manual_bd_vector
- yosys_stat_vector
- motif_vector
- stnod_vector
- qwen_embedding_path
- deepgate_embedding_path
- descriptor_version
- projection_hash
- cluster_id

Diversity IDs:
- canonical_netlist_hash
- motif_signature_hash
- ppa_cluster_id
- lineage_cluster_id
```

Then add:

```text
Rows with missing required fields for a given analysis must fail loudly or be
excluded with an explicit coverage reason.
```

This matches the plan’s anti-fallback philosophy.

---

# 23. Add tests for metrics that are easy to get wrong

The TODO says tests should cover corpus indexing and selected analysis metrics. I would list the exact fixtures.

Add:

```markdown
## Required Test Fixtures

1. Corpus indexing fixture:
   - two fake runs
   - two methods
   - missing netlist for one candidate
   - assert coverage table reports missing artifact

2. Pareto/HV fixture:
   - known 2D/3D PPA points
   - known non-dominated front
   - known HV value

3. Coverage/entropy fixture:
   - known descriptor cells
   - known occupied cell count
   - known normalized entropy

4. Oracle downsampling fixture:
   - fixed candidate pool
   - top-k, random, and diversity selectors
   - assert equal retained budget

5. Cluster contribution fixture:
   - known clusters and front members
   - assert cluster HV/front contribution

6. Early-diversity fixture:
   - candidates across generations
   - assert only early candidates are used for early metrics

7. Leakage fixture:
   - projection fitted on full corpus should be marked post-hoc only
   - projection fitted on dev corpus can be used for predictive analysis
```

This will catch many subtle errors.

---

# 24. Add “common failure interpretations” to the report

The report should not only show pass/fail. It should explain likely causes.

Add:

```markdown
## Failure Interpretation Templates

If diversity high but HV low:
  interpretation = diversity is decorative or descriptor misaligned.

If HV high but valid-PPA low:
  interpretation = diversity pressure may trade away repair/robustness.

If early diversity predicts final HV only before controlling for valid count:
  interpretation = diversity is mostly a proxy for valid candidate volume.

If Qwen diversity works but identifier-normalized stability fails:
  interpretation = text-style diversity, not implementation diversity.

If DeepGate diversity works only on combinational tasks:
  interpretation = AIG-level embedding may miss sequential behavior.

If D2 passes but D1/D3/D4/D5 fail:
  interpretation = multiple implementation regions exist, but usefulness is
  not established.

If random descriptor matches real descriptor:
  interpretation = archive mechanics or sampling variance, not meaningful BD.
```

This will make the final report much easier to write and review.

---

# 25. Updated adversarial validation additions

The adversarial prompt is already good. Add these automatic FAIL preconditions:

```text
17. The report claims diversity is useful because D2 and D6 pass, without any
    predictive, reconstructive, random-control, or prospective utility gate.

18. Early-diversity prediction uses PCA/clustering/projection fitted on the full
    final corpus without labeling the claim as post-hoc/descriptive.

19. Oracle downsampling uses final PPA or final-front membership while claiming
    online search utility.

20. Multi-cluster Pareto-front evidence lacks random-label or shuffled-label
    controls.

21. Descriptor-space metrics are computed over raw mixed-scale features without
    standardization or documented distance metric.

22. Qwen embedding claims do not report truncation, identifier-normalization
    stability, or comparison against a simple lexical baseline.

23. DeepGate3 claims do not state whether sequential elements were represented,
    cone-split, or dropped.

24. A D gate is marked PASS without minimum corpus/problem/seed/candidate
    coverage.

25. The final conclusion does not select one of the predefined verdict levels:
    not supported / illumination-only / reconstructive / predictive / active /
    Auto-BD candidate.
```

Add these mechanical checks:

```text
19. Inspect descriptor projection artifacts and verify fitting data does not
    include held-out/future data for predictive claims.

20. Recompute D2 with random cluster labels and verify real clusters beat the
    control.

21. Recompute oracle downsampling at multiple retained budgets k.

22. Check that diversity metrics are reported separately for all candidates,
    functionally valid candidates, synthesis-valid candidates, valid-PPA
    candidates, and Pareto-front candidates.

23. Inspect the final verdict section and verify that claim level matches the
    strongest evidence.
```

---

# 26. Recommended paste-in patch

Here is a compact section you can paste into the plan.

```markdown
## Claim-Level And Anti-Leakage Addendum

The diversity study must separate descriptive, reconstructive, predictive, and
active claims.

- Descriptive: multiple implementation regions exist.
- Reconstructive: diversity-aware retention reconstructs a better historical
  Pareto front at equal candidate budget.
- Predictive: early diversity predicts later HV, best fitness, Pareto expansion,
  or useful descendant yield after controlling for valid candidate count,
  problem, seed, method, and budget.
- Active: a prospective diversity intervention improves PPA/HV without
  robustness loss.
- Method: a concrete Auto-BD/QD method beats landing Smooth-QD manual-BD under
  frozen budget and gates.

Proceed to Auto-BD only if at least one utility gate passes:
D1 early_predictive, D3 replay_retention, D4 prospective_moderate_diversity, or
D5 real_beats_random, and at least one meaning gate passes:
D2 multi_cluster_front or D6 interpretable_regions.

D2 + D6 alone is not enough to proceed to Auto-BD; it only supports an
illumination/reporting claim.

Every fitted descriptor projection or clustering method must declare fitting
data and claim scope. PCA, k-means, VQ, UMAP, scaler, or cluster labels fitted
on the full final corpus may be used for descriptive or reconstructive analysis
only, not predictive claims. Predictive claims require descriptors fitted on
data available before the prediction cutoff or on a separate dev corpus.

Oracle downsampling must be reported in two forms:
(1) oracle reconstructive downsampling, allowed to use final PPA/front
information and labeled reconstructive only;
(2) online-available downsampling, using only information available at candidate
insertion time.

All diversity metrics must be reported separately for:
all candidates, syntax-valid candidates, functionally valid candidates,
synthesis-valid candidates, valid-PPA candidates, and Pareto-front candidates.
The report must include validity-normalized metrics such as HV per valid-PPA
candidate, common-audit QD per valid-PPA candidate, and unique motif signatures
per valid-PPA candidate.

The final report must select exactly one verdict:
A. diversity not supported;
B. diversity useful for illumination only;
C. diversity reconstructive;
D. diversity predictive;
E. diversity actively useful;
F. Auto-BD candidate justified.
```

---

# 27. Bottom-line recommendation

I would proceed with this plan after adding four things:

```text
1. Claim hierarchy:
   descriptive vs reconstructive vs predictive vs active vs method claim.

2. Stricter proceed rule:
   D2 + D6 is not enough; require at least one utility gate.

3. Descriptor fitting/leakage protocol:
   especially for PCA, clustering, Qwen, DeepGate, UMAP, and VQ.

4. Validity-normalized diversity:
   diversity must be measured through the validity funnel, not just on all
   generated candidates or archive cells.
```

With those fixes, the plan becomes quite robust. It would be hard for an implementer to “pass” the task by showing pretty embedding plots or archive occupancy alone. The plan would instead force the correct answer: whether diversity is **descriptive only**, **reconstructive**, **predictive**, **actively useful**, or strong enough to justify another Auto-BD method.
