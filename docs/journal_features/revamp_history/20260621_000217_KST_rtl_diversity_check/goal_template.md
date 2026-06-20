# Goal Template

Use this draft for `/goal` after reviewing the plan. Keep the activated goal
under 4000 characters.

```text
/goal Objective: implement the RTL diversity check experiment in docs/journal_features/revamp_history/20260621_000217_KST_rtl_diversity_check/rtl_diversity_check_plan.md. Use rtl_diversity_check_implementation_todo.md as the checklist and record commands, artifacts, failures, decisions, and commits in rtl_diversity_check_implementation_history.md.

Outcome: decide whether implementation diversity among functionally equivalent RTL candidates is predictive, reconstructive, or useful for PPA evolution before further AutoQD/AURORA/VQ work. Start from post-hoc corpora, not new live evolution. Define useful diversity as structural, synthesis-response, or embedding distinction whose region contributes to the PPA Pareto front or produces useful descendants.

Interpretation constraint: use the 20260618 Auto-BD results as negative/control evidence. Yosys-stat, motif, ST-NOD, projected synthesis-response, VQ/codebook, and random descriptor arms did not produce clean robust PPA uplift, so do not present them as fresh promising defaults. Ask whether those failures mean diversity is weakly relevant, the wrong diversity was measured, or diversity pressure traded away exploitation and repair.

Data: use this branch, ignored outputs under exp/diversity_check/, and read-only /aux/revolution-history. Index Auto-BD standard_results, old exp roots, recoverable baselines, and aspdac2026-paper artifacts only if locally present. Do not write historical checkouts.

Dataset policy: debug on small subsets, but final claims require a large retrospective corpus/run, preferably broad RTLLM. Use VerilogEval only when existing artifacts make it practical; otherwise label it partial.

Encoder policy: first add Qwen/Qwen3-Embedding-0.6B RTL text diagnostics and DeepGate3 netlist/AIG diagnostics if practical. Treat DeepSeq, NetTAG, CircuitFusion, larger Qwen models, and AURORA/custom training as later-stage only after Qwen/DeepGate3 and existing descriptor evidence justify them.

Live-run policy: no new runs by default. If needed, preflight curl http://20.0.0.103:8000/v1/models and use gpt-oss-120b with max_model_len >= 131072, --max_tokens 128000, and --diff_max_tokens 128000 when relevant.

Required report: regenerate a Diversity Necessity Report with corpus coverage, candidate audit table, encoder leaderboard, D1-D6 gate matrix, diversity-vs-PPA regressions, cluster summaries, counterfactual replay, common-audit metrics, and visualizations: embedding scatter, PPA front by cluster, diversity-over-time vs quality, early-diversity vs final HV, replay bars, stability boxplots, correlation heatmaps, common-audit heatmaps, and representative implementation gallery.

Proceed toward Auto-BD only if at least two D gates pass: early diversity predicts quality after valid-count/problem/seed controls; Pareto front spans multiple structural clusters in >=60% analyzable problems; diversity-aware replay improves retained HV/motif/common-audit coverage; moderate live diversity pressure helps without >5pp robustness drop; real hardware descriptors beat random; descriptor regions are interpretable.

Code constraints: keep code simple, typed where useful, assert required data, avoid broad fallbacks/backward-compat/database machinery, and keep entry points skimmable. Completion requires TODO items checked or scoped with evidence and PASS from rtl_diversity_check_adversarial_prompt.md written to rtl_diversity_check_subagent_validation_report.md. If blocked for three concrete attempts, stop with commands, evidence, blocker, and required input.
```
