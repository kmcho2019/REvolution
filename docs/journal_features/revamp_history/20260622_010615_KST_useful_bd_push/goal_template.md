# Goal Template

Use this text for `/goal`. It omits the literal `/goal` prefix. Keep the
detailed plan, method list, and policies in sibling docs as the full contract.

```text
Objective: on branch feat/journal-useful-bd-exp-20260622, make a wide-net
persistent push to find useful behavior descriptors for QD/MAP-Elites in RTL
netlist evolution and PPA optimization. Use
docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/ as the
revamp root. The plan is the contract, TODO is the checklist, history is the
audit log, and the metrics, anti-gaming, code, visualization, and vLLM docs are
binding guardrails.

Outcome: find at least one descriptor/archive-coupling technique that is
near-classic or better, or produce a rigorous negative map of failed technique
families. Treat the old 10% utility threshold as a strong-win tier, not the
first filter. Keep any method that matches classic within a
small tolerance, preserves classic-covered valid-PPA problems, or shows a
reproducible positive delta in HV, valid-PPA count, Pareto spread, archive
coverage, or lineage yield.

Current priority milestone: build presentations/20260623_report/ to answer
whether diversity matters for RTL PPA evolution and which diversity matters.
Use prior evidence plus a pre-registered RTLLM 50-problem classic-vs-T26-family
comparison. Screen exact T26, low-fusion T26.1, and gated T26.1 before any
full RTLLM launch; exact T26 remains fallback if new variants fail smoke,
screening, or code-simplicity review. Because the deadline is tight, the
one-seed full RTLLM run is the first milestone; organize its plots, tables, and
presentation materials before starting costly multi-seed replication.

Metrics: do not use average fitness or average best PPA as primary evidence.
Compare classic, landing Smooth-QD/manual-BD, and every method with a common
passive archive. Report global PPA hypervolume, passive archive QD
score/coverage, Pareto-cell count, Pareto spread, unique front families,
valid-PPA yield, duplicate accounting, and AUC metrics for live runs.

Required scope: attempt at least 10 current technique packages from
techniques/T##_slug/ before any broad negative sign-off, including one simple
control, one synthesis/netlist descriptor, one learned/projection descriptor,
and one archive-coupling/Pareto variant. Add extra methods only with method
cards. Every attempted package must have paper-grade methodology,
artifacts_manifest with commands/paths/hashes, figures, tables, results report,
visual inspection notes, and a T0/T1/T2/T3 tier decision.

Constraints: keep model, subset, seeds, prompts, operators, budget, timeouts,
and evaluation flow fixed unless a versioned exception is recorded before
running. For live vLLM runs, preflight the endpoint, record /v1/models
metadata, and use 128000 max_tokens/diff_max_tokens except for tiny smokes.
Freeze the screening subset before interpreting outcomes. Do not use final PPA,
reference PPA, fitness, hypervolume, Pareto rank, or test pass rate as in-loop
BD inputs. Do not count duplicates or invalid candidates as useful diversity.
Any T1+ method must preserve every classic-covered design under the same budget.
For the deadline RTLLM milestone, a 50% or larger relative
functionality/synthesis-validity decline is a visible yield warning, not an
automatic launch blocker, when the selected method still has at least one valid
PPA sample for every classic-covered design. Below 10 classic passing samples,
report raw counts as small-n/noisy and do not decide from the relative rate
alone.

Iteration policy: start from prior evidence, then cheap
deterministic controls, synthesis/netlist descriptors, projection/codebook
descriptors, MOME/adaptive CVT variants, and encoder adaptations such as Qwen,
DeepGate, DeepSeq, NetTAG, CircuitFusion, MGVGA, DE-HNN, DeepCell, MasterRTL
SOG, or AURORA. Keep code modular and skimmable, update docs/docstrings, avoid
broad fallback/back-compat clutter, and use isolated uv envs, source checkouts,
or submodules when the main uv env blocks a method. After each method, update
its package and central history. Every T0 needs a follow-up idea, ablation,
hybrid, or retirement rationale. Commit regularly and inspect every commit
message.

Blocked stop condition: stop only after three concrete attempts hit the same
blocker, with commands, artifacts, missing input, and exact next decision
needed. Do not end because one method is weak. Completion requires
focused tests/checks, inspected intuitive figures, a clear presentation/report
answer to the two main diversity questions, precise conclusions, no overclaimed
tier, no anti-loophole violation, and PASS from the adversarial prompt written
to the validation report.
```
