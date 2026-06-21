# RTL Diversity Check Conclusion

Final verdict: `B illumination_only`.

The restarted run answered the two main research questions negatively for
method promotion, while preserving one useful positive result: implementation
diversity can be described and illustrated in interpretable RTL/netlist style
regions. It did not become predictive, reconstructive, mechanistic, active, or
a justified Auto-BD method under the declared gates.

## Question 1: Does Diversity Explain Later PPA Quality?

Original question from the notes:

> Does early diversity explain later PPA quality after controlling for the
> number of valid candidates?

Answer: not with the evidence in this restart.

The final audit found a weak positive post-hoc association, but it was not
enough to support the claim. D1 failed because the available early-diversity
signal was an uncontrolled single-run problem-level correlation rather than a
controlled effect with seed/model/budget fixed effects. The final report records
`rho early lexical distance vs final HV=0.300`, but marks that evidence
inconclusive because valid-count, problem, model, and budget confounds remain.

The other utility checks also failed. D2 failed because only 48.8% of valid-PPA
problem groups had multi-cluster Pareto fronts, while shuffled labels reached
56.0%. That means the observed clusters did not beat a label-randomization
control. D3 failed because the best final diversity replay improvement was only
about 1.35% hypervolume over best-fitness retention, below the predeclared 10%
threshold. D5 failed because the 20260618 Auto-BD controls still did not show
robust PPA uplift over classic/manual baselines. D4 was not run because the
offline evidence did not justify a live diversity intervention.

What did pass was D6: the report can explain style regions such as
`arithmetic_additive`, `arithmetic_multiply`, `control_case`, `control_if`,
`mux_ternary`, `wire_assign`, and `register_sequential`. That supports an
illumination or diagnostic claim, not a utility claim.

Bottom line: diversity is measurable and interpretable, but this restart did
not show that it explains or improves later PPA quality after the relevant
controls.

## Question 2: Should We Promote Auto-BD, AURORA, or Learned Encoders?

Original goal wording:

> Determine whether implementation diversity among functionally equivalent RTL
> candidates is merely descriptive, reconstructive, predictive, actively useful,
> or a justified Auto-BD method.

Answer: no promotion is justified by the current evidence.

The restart escalated beyond the preliminary report. It incorporated the ASP-DAC
source archive, rebuilt the final audit over 203,944 candidates, attempted real
Qwen3 extraction, attempted DeepGate3 graph/export/embedding paths, reconstructed
ST-NOD/synthesis-response evidence where artifacts allowed, audited lineage,
ran budget funnels, ran quality-gated novelty replay, ran near-motif
suppression, and tried AURORA-style learned encoder probes. Those attempts were
necessary, but they did not flip any utility gate.

Qwen3 became a real diagnostic instead of a dependency-blocked placeholder.
The common-audit replay embedded 768 candidates and did not collapse. Raw Qwen
farthest-first lost 1.25% hypervolume versus lexical farthest-first, while
identifier-normalized Qwen gained 3.35%. The positive identifier-normalized
result is below the 10% D3 threshold, so Qwen remains diagnostic-only.

DeepGate3 was also pushed further than the preliminary run. The restart
attempted source setup, AIG export, latch-free parsing, and tokenizer embedding.
The bounded slice produced only three nontrivial embeddings and collapsed with
pairwise cosine mean near 0.999971. Sequential/latch-bearing policy also remains
limited. That is no-proceed evidence, not a usable netlist BD.

AURORA-style learned encoders were tested in bounded replay form. The AE2/AE3
and richer AE8/AE16 probes used problem splits and excluded PPA fields from the
encoder inputs. They were non-collapsed, but they did not improve held-out
hypervolume or Pareto retention in a meaningful way. This blocks in-loop
learned BD promotion and makes finetuning unjustified unless a future branch
declares a tighter supervised or contrastive target.

The WP0/WP2 checks reinforce the same decision. Quality-gated novelty preserved
best fitness and increased some structural counts, but did not recover baseline
Pareto sizes. Near-motif suppression decreased hypervolume and Pareto retention
at all tested thresholds. Lineage recovery found 3,358 edges and 779 positive
child-quality deltas, but 0 of 8 method/table groups had positive mean quality
delta, so there is no mechanistic parent-yield claim.

Bottom line: keep Auto-BD, VQ, AURORA, Qwen finetuning, and DeepGate-style
netlist embeddings out of the main method unless a future branch first clears
one utility gate and one meaning gate.

## What Went Wrong Previously

The initial report stopped too early. It treated the missing Qwen dependency and
unrun DeepGate path as practical blockers, relied too much on a smaller
retrospective read, and did not exhaust the original notes' work packages. It
also reached a stronger-looking conclusion before lineage, budget funnels,
near-motif suppression, quality-gated novelty, richer Qwen replay, and learned
encoder probes were available.

The restarted run fixed that process issue by escalating methodically:

- real Qwen3 extraction and common-audit replay were run;
- DeepGate3 export and tokenizer embedding were attempted;
- ST-NOD/synthesis-response replay artifacts were reconstructed where possible;
- lineage source and descendant-yield analyses were added;
- budget/funnel curves were generated across validity stages;
- quality-gated novelty and duplicate suppression were replayed;
- near-motif suppression tested whether pruning near-duplicates helped;
- AURORA-style and rich learned encoders were attempted under leakage controls;
- an independent validation pass confirmed the bounded `B illumination_only`
  claim.

The final answer is still negative, but it is now a much more defensible
negative result.

## How To Use This Bundle

The main evidence path is:

1. `reports/project_docs/goal_template.md`
2. `reports/final_report/diversity_necessity_report.md`
3. `raw_data/final_report/d_gate_matrix.csv`
4. `raw_data/final_report/claim_levels.csv`
5. `stage_results/wp1_qwen/qwen_common_audit_summary.json`
6. `stage_results/wp1_deepgate3/deepgate3_tokenizer_summary.json`
7. `stage_results/wp3_learned_encoders/rich_encoder/wp3_rich_encoder_summary.json`
8. `reports/project_docs/rtl_diversity_check_subagent_validation_report.md`

The clearest visual summaries are:

- `figures/generated/gate_status_summary.png`
- `figures/generated/utility_gate_margins.png`
- `figures/generated/claim_level_ladder.png`
- `figures/generated/corpus_coverage_overview.png`

The earlier, insufficient attempt is preserved under
`reports/derailed_initial_report/` so reviewers can see what changed after the
restart.

## Recommended Next Step

Do not keep adding encoders to the same retrospective question without a
stronger experimental design. The current evidence says the next useful branch,
if we continue, should be a prospective D4 experiment or a tightly scoped
encoder-target experiment.

For a prospective D4 branch, use live or replay-with-identical-mechanics
sampling with:

- one benchmark subset where valid-PPA is achievable;
- fixed model, prompts, operators, seeds, and evaluation flow;
- `archive_parent_fraction` arms at 0, 0.25, and 0.5;
- a quality floor and duplicate/near-motif accounting;
- predeclared success: at least 10% retained HV or best-fitness gain without
  more than 5 percentage points validity loss;
- full lineage instrumentation from the start.

For an encoder branch, do not call it Auto-BD yet. Treat it as a diagnostic
representation study with:

- problem-held-out fitting;
- no PPA fields in encoder inputs;
- hard positives and negatives based on same-problem implementation variants;
- explicit collapse tests;
- a D1/D3 no-proceed threshold before any in-loop run.

Qwen projection heads, DeepGate with cone-splitting or sequential policy, and
AURORA/VQ codebooks are reasonable only under that stricter setup. Without that,
the manuscript should frame RTL implementation diversity as an illumination and
negative-method-selection result rather than a new search method.
