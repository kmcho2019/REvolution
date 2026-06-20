# Updated Auto-BD / Diversity Research Plan After Preliminary Negative Results

## Executive Decision

The preliminary Auto-BD results should be treated as a clean negative screening result for the tested direct Auto-BD variants. The next phase should not be "try a bigger encoder" or "try more descriptors." The next phase should be a diversity-necessity and search-coupling study.

The updated thesis is:

> In RTL/Verilog PPA evolution, implementation diversity may be useful, but only if it is coupled to search in a quality-preserving and feasibility-preserving way. Direct descriptor-driven archive pressure can organize candidates differently, but the tested variants reduce valid-PPA throughput and do not outperform classic REvolution or the landing Smooth-QD manual-BD baseline.

## Key Preliminary Findings To Preserve

### Strongest baseline

The landing Smooth-QD manual-BD baseline is currently the strongest practical baseline, not the direct Auto-BD methods. It uses code individuals, six EoH operators, and manual BDs: combinational logic depth, FF depth, and log combinational gate count.

### Main negative result

The preliminary results show that direct automatic behavior descriptors did not produce a robust journal-positive method. ST-NOD was scientifically interesting, but it traded away too much valid-PPA rate. PCA/RFF/VQ variants added descriptor capacity but did not translate into robust PPA quality.

### Main failure mode

The failure mode is not simply "descriptor too weak." The deeper failure is that descriptor diversity changes parent-selection / archive pressure in a way that reduces valid-PPA throughput. In RTL evolution, the hard funnel is:

```text
Verilog syntax -> correct interface -> functional pass -> synthesis pass -> OpenROAD pass -> good PPA
```

Most Auto-BD signals are available only after candidates pass a large part of this funnel, so they do not help early repair. They mostly affect which already-valid or nearly-valid candidates are retained and used as parents.

## Updated Research Questions

### RQ0: Does diversity matter?

Before any new Auto-BD method is proposed, determine whether implementation diversity among functionally equivalent RTL candidates predicts, improves, or explains PPA outcomes.

### RQ1: What diversity matters?

Distinguish:

- RTL text diversity
- RTL AST/control-dataflow diversity
- synthesized netlist structural diversity
- synthesis-response / trajectory diversity
- PPA-front diversity
- lineage/operator diversity

Useful diversity should mean:

> Functionally equivalent candidates that are structurally or synthesis-response distinct, and whose regions either contribute directly to the PPA Pareto front or produce descendants that do.

### RQ2: How should diversity be coupled to search?

The new hypothesis is that Auto-BD should be used as a secondary, quality-gated diversity mechanism, not as equal-strength parent-selection pressure.

## Work Package 0: Diversity Necessity Study

### Goal

Use existing REvolution and Smooth-QD runs to determine whether diversity is predictive or useful before running expensive new Auto-BD variants.

### Required analyses

1. **Post-hoc descriptor extraction**
   - canonical netlist hash
   - Yosys-stat vector
   - motif occupancy vector
   - ST-NOD / synthesis-response vector if stage dumps are available
   - optional RTL/code embedding
   - optional netlist graph embedding

2. **Early-diversity vs final-quality regression**
   - compute diversity at 25%, 50%, and 75% of budget
   - predict final best fitness and PPA hypervolume
   - control for valid candidate count, problem, and seed

3. **Cluster-to-PPA analysis**
   - cluster valid candidates in each descriptor space
   - measure which clusters contribute to the final PPA Pareto front
   - identify whether best area, best power, and best timing candidates come from different clusters

4. **Counterfactual archive replay**
   - replay retention policies over historical candidate pools:
     - scalar top-k
     - random
     - manual-BD archive
     - Yosys-stat archive
     - motif archive
     - ST-NOD archive
   - compare retained HV, best fitness, unique netlists, unique motif signatures, and later-useful parents

5. **Shadow archive test**
   - run classic REvolution unchanged
   - maintain QD archives in the background
   - check whether shadow archive regions reveal distinct high-quality implementation regimes

6. **Lineage / stepping-stone analysis**
   - trace ancestors of final best/Pareto candidates
   - check whether diverse intermediate candidates were useful parents or merely decorative archive points

### WP0 sign-off

Proceed to new Auto-BD only if at least two of the following pass:

- early implementation diversity predicts final HV or best fitness after controlling for valid count
- final PPA Pareto front uses multiple structural/synthesis-response clusters in most analyzable problems
- diversity-aware counterfactual retention improves retained HV or useful-front coverage over scalar top-k
- shadow archive reveals high-quality regions classic selection would not preserve
- real hardware descriptors beat random descriptors in common audit space
- descriptor clusters have interpretable implementation styles

If WP0 fails, stop Auto-BD as a main method and use Smooth-QD only as a reporting/Pareto archive.

## Work Package 1: Encoder Diagnostics Only

### Goal

Use pretrained or frozen encoders to test whether embedding distance is meaningful, but do not use them in-loop until WP0 passes.

### Candidate encoders

- RTL text/code: Qwen3-Embedding-0.6B, larger Qwen embeddings, CodeBERT/UniXcoder-like encoders, RTL-specialized encoders if available
- Netlist graph: DeepGate/DeepGate3-style AIG/netlist encoders
- Sequential graph: DeepSeq-style encoders
- Multimodal circuit encoders: NetTAG/CircuitFusion-style encoders if available

### Required diagnostic tests

- extraction success
- runtime overhead
- stability under renaming/formatting/comment removal
- correlation with manual BDs
- correlation with PPA metrics
- cluster-to-PPA contribution
- common-audit QD score
- whether embedding distance predicts future valid offspring, PPA improvement, Pareto membership, or useful lineage contribution

### Acceptance rule

An encoder can become an in-loop BD only if it is stable, non-leaky, non-collapsed, interpretable, and predictive of useful diversity. Otherwise it remains a diagnostic visualization tool.

## Work Package 2: Quality-Gated / Repair-Preserving Auto-BD

### Goal

If WP0 supports diversity, test whether Auto-BD can improve archive/Pareto diversity without hurting the valid-PPA funnel.

### Core design

Use classic REvolution or landing Smooth-QD manual-BD as the primary substrate. Add Auto-BD only as a secondary novelty lane.

```text
Phase A: Feasibility-first search
  Run classic REvolution or landing Smooth-QD normally until valid-PPA candidates exist.

Phase B: Quality-gated diversity
  Maintain Auto-BD archive only over valid-PPA candidates.
  Parent selection remains quality-first.
  Auto-BD novelty lane gets only 10-25% quota.
  Archive insertion requires quality floor.
```

### Quality floor options

A candidate may enter the diversity parent pool only if at least one holds:

- candidate is PPA non-dominated
- candidate is within top 25% of valid candidates for the problem
- candidate is within epsilon of the current problem median fitness
- candidate improves one PPA objective without catastrophic regression on others
- candidate contributes to hypervolume

### Novelty-lane sweep

Run:

```text
novelty_parent_fraction = 0.00, 0.10, 0.25, 0.50
```

Interpretation:

- 0.00 wins: diversity pressure is not useful for search
- 0.10 or 0.25 wins: quality-gated diversity helps
- 0.50 collapses: previous failures were due to too much diversity pressure
- real descriptor ≈ random descriptor: archive mechanics help, descriptor semantics do not
- hardware descriptor > random descriptor: implementation diversity matters

### Candidate methods

- QG-ST-NOD: quality-gated ST-NOD archive
- QG-SR-PCA: quality-gated raw synthesis-response PCA
- QG-RFF: quality-gated RFF PCA only if RFF remains diagnostically useful
- QG-duplicate suppression: suppress duplicate canonical netlists and near-identical motif signatures

Do not run VQ/codebook again until a continuous descriptor passes quality-gated tests.

## Work Package 3: Full Auto-BD / AURORA / VQ Only If Needed

Run AURORA/VQ-style descriptors only after WP0 and WP2 show that diversity has causal or predictive value.

Full learned Auto-BD is justified only if:

- simple hardware descriptors are useful but insufficient
- quality-gated novelty helps
- learned embeddings improve common-audit diversity or PPA-front coverage beyond ST-NOD/motif baselines
- robustness does not regress

## Updated Sign-Off Gates

### Gate 0: Coverage preservation

The selected method must not lose any problem where classic REvolution or landing Smooth-QD manual-BD finds at least one valid-PPA candidate.

### Gate 1: Robustness

Compared with landing Smooth-QD manual-BD:

- functionality pass rate drop ≤ 5 percentage points
- synthesis pass rate drop ≤ 5 percentage points
- OpenROAD success drop ≤ 5 percentage points
- valid-PPA rate drop ≤ 2 percentage points preferred, ≤ 5 percentage points maximum

Any method that repeats the ST-NOD-style 10pp valid-PPA drop is rejected regardless of archive diversity.

### Gate 2: PPA quality

Must satisfy at least one:

- ≥ 5% relative improvement in PPA hypervolume for screening, ≥ 10% for final claim
- ≥ 5% relative improvement in average best fitness for screening, ≥ 10% for final claim
- ≥ 2 additional problems with positive PPA improvement
- statistically better anytime curve under equal budget

### Gate 3: Diversity / QD

Must satisfy at least one:

- ≥ 15% common-audit QD score uplift
- ≥ 20% common-audit archive coverage uplift
- ≥ 25% unique motif-signature elite uplift
- more PPA-front clusters without lowering valid-PPA throughput

Internal archive coverage alone does not count.

### Gate 4: Descriptor usefulness

Descriptor cells/clusters must predict at least one:

- Pareto-front membership
- future valid offspring rate
- future PPA improvement
- hypervolume contribution
- distinct PPA trade-off regime

### Gate 5: Interpretability

At least three archive regions/clusters must have concrete explanations such as:

- mux-heavy implementation
- arithmetic-preserving implementation
- arithmetic-decomposed implementation
- shallow-wide logic
- deep-narrow logic
- register-balanced implementation
- control-dominated implementation
- resource-shared implementation

### Gate 6: Report completeness

The method is incomplete unless all reports regenerate from artifacts.

## Required Report Format

### Central report sections

1. Executive decision
2. Preliminary negative result summary
3. Method-by-method result table
4. Failure-mode analysis
5. Diversity necessity tests
6. Encoder diagnostics
7. Quality-gated novelty-lane sweep
8. Per-problem analysis
9. Common audit archive analysis
10. Representative RTL/netlist examples
11. Final accept/reject decision

### Required figures

- robustness funnel by method
- valid-PPA rate by problem and method
- best-fitness anytime curves
- PPA-HV anytime curves
- diversity-over-time vs quality-over-time
- embedding/descriptors scatter colored by fitness and validity
- PPA Pareto front colored by cluster
- counterfactual archive replay bar chart
- novelty-lane sweep plot
- descriptor-vs-manual-BD correlation heatmap
- descriptor-vs-PPA correlation heatmap
- unique canonical netlist / motif signature comparison
- lineage graph for representative best candidates

### Required tables

- method leaderboard
- sign-off gate matrix
- per-method robustness table
- per-problem win/loss/tie matrix
- cluster-to-PPA contribution table
- descriptor stability table
- encoder overhead table
- final accept/reject table

## Updated Directory Structure

```text
auto_bd_after_negative/
  README.md
  00_preliminary_negative_results/
    result_summary.md
    method_result_table.csv
    failure_mode_analysis.md

  01_wp0_diversity_necessity/
    configs/
    scripts/
    artifacts/
    reports/
      diversity_necessity_report.md
      diversity_necessity_report.html

  02_wp1_encoder_diagnostics/
    encoder_registry.yaml
    per_encoder_reports/
    centralized_encoder_report.md

  03_wp2_quality_gated_autobd/
    qg_stnod/
    qg_sr_pca/
    qg_duplicate_suppression/
    novelty_sweep/
    reports/

  04_wp3_full_autobd_if_justified/
    aurora_encoder/
    vq_codebook/
    learned_netlist_bd/

  centralized_reports/
    all_methods_leaderboard.csv
    signoff_gate_matrix.csv
    final_recommendation.md
```

## Updated Research Task Paragraph

The revised task is:

> The preliminary Auto-BD screening produced a clean negative result: direct automatic descriptors such as ST-NOD, SR-PCA/RFF, and VQ/codebook descriptors can reorganize RTL implementation archives, but they do not preserve valid-PPA robustness or beat the landing Smooth-QD manual-BD baseline. Therefore, the next research task is not to build a larger AURORA-style encoder. The next task is to determine whether implementation diversity is actually useful for RTL PPA evolution, and if so, how to couple it to search without damaging repair and valid-PPA throughput. The researcher should first run a retrospective diversity-necessity study over past REvolution/Smooth-QD corpora, then run shadow archives, counterfactual archive replay, cluster-to-PPA analysis, and a quality-gated novelty-lane sweep. Only if these analyses show that hardware-native diversity predicts or improves PPA outcomes should Auto-BD be revived, and then only as a feasible-first, quality-gated, secondary diversity mechanism rather than as the main parent-selection pressure.
