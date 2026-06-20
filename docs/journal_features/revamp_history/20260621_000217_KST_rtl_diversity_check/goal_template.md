# Goal Template

Status: v2 restart goal, created after the preliminary audit was judged too
shallow for research sign-off. Use this draft for `/goal` after reviewing the
restarted plan. Keep the activated goal under 4000 characters.

```text
/goal Objective: restart the RTL diversity research in docs/journal_features/revamp_history/20260621_000217_KST_rtl_diversity_check after the committed preliminary audit. Treat commit a5fc5018ab as Phase 0 evidence only, not final sign-off. Use rtl_diversity_check_plan.md as the active contract, rtl_diversity_check_implementation_todo.md as the checklist, and rtl_diversity_check_implementation_history.md as the audit log.

Outcome: determine whether implementation diversity among functionally equivalent RTL candidates is merely descriptive, reconstructive, predictive, actively useful, or a justified Auto-BD method. The previous ASP-DAC-backed report reached B illumination_only, but it stopped too early: real Qwen extraction was blocked by missing torch, DeepGate3 was not run end to end, ST-NOD/synthesis-response was not reconstructed, lineage was mostly absent, and no bounded live or quality-gated novelty experiment was attempted.

Required restart: incorporate original_notes work packages. WP0 deepens the diversity-necessity study across D_code, D_struct, D_synth, D_ppa, and D_lineage. WP1 performs real encoder diagnostics before any in-loop claim: Qwen3 Embedding, DeepGate3/AIG, and, if available, DeepSeq/NetTAG/CircuitFusion/larger Qwen as diagnostics with per-encoder method cards. WP2 tests repair-preserving quality-gated diversity pressure: duplicate suppression and novelty_parent_fraction 0/0.10/0.25/0.50 with quality floors. WP3 permits AURORA/VQ/learned encoders only if WP0-WP2 show useful, stable, non-leaky diversity signal.

Hard evidence requirements: attempt Qwen3 embedding extraction; attempt DeepGate3 graph export and embedding; reconstruct ST-NOD/synthesis-response where artifacts allow; attempt lineage/parent-child or descendant-yield analysis on any corpus that exposes it; run at least one bounded live or replay-based quality-gated novelty/duplicate-suppression experiment when retrospective evidence remains inconclusive. Missing Python/model dependencies are not blockers until uv add/optional dependency setup or an isolated submodule-style environment has been tried and logged with command evidence.

Gates: every descriptor/encoder needs extraction, stability, non-collapse, leakage, runtime, interpretability, common-audit, and validity-normalized diversity evidence. Proceed beyond diagnostics only with one utility gate (D1/D3/D4/D5) plus one meaning gate (D2/D6), and only if the result is not explained by valid-count, duplicate-count, or unpaired-corpus confounds. D2+D6 alone is illumination only.

Live policy: use historical corpora first, but do not prohibit live sampling when retrospective evidence is inadequate. Preflight curl http://20.0.0.103:8000/v1/models and use gpt-oss-120b with --max_tokens 128000 and --diff_max_tokens 128000; record model id, max_model_len, seed, subset, budget, and endpoint. Keep /aux/revolution-history read-only.

Completion: update plan/todo/history/adversarial prompt, regenerate reports from artifacts, run relevant tests/checks, run adversarial validation under the restarted prompt, and commit atomically with signed multi-line messages verified after every commit.
```
