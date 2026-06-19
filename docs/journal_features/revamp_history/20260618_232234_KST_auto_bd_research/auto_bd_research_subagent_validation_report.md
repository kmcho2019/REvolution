# Automatic BD Research Sub-Agent Validation Report

Verdict: PASS

## Scope

Validated branch `feat/journal-auto-bd-exp-20260618` at
`6ad95132b04dd10a76c7c941ef1c105116840c7d` against
`auto_bd_research_adversarial_prompt.md`.

The implementer claim is still a final negative result: no Auto-BD
method is selected, and AURORA, seed-5, held-out validation, finalist
functional audit, and finalist PPA remeasurement are scoped out because
no method passed the selection gates.

## Inspected Evidence

- `START_HERE.md`
- `auto_bd_research_plan.md`
- `auto_bd_plan_sketch.md`
- `auto_bd_ruminations.md`
- `auto_bd_research_implementation_todo.md`
- `auto_bd_research_implementation_history.md`
- `auto_bd_run_policy_lock.yaml`
- `auto_bd_final_negative_decision.md`
- `auto_bd_seed1_centralized_report.{md,json}`
- `auto_bd_seed1_promotion_decisions.md`
- `auto_bd_seed3_screening_report.md`
- `auto_bd_seed3_seed1001_centralized_report.{md,json}`
- `auto_bd_seed3_seed1002_centralized_report.{md,json}`
- `auto_bd_seed3_seed1003_centralized_report.{md,json}`
- all method cards, configs, method reports, and accept/reject records
  under `auto_bd_methods/`
- SR-PCA, random-ReLU PCA, RFF PCA, and SR-VQ fitting artifacts
- all 26 `standard_results/` roots under `exp/auto_bd_research/`
- relevant Auto-BD code and tests under `src/revolution/auto_bd/`,
  `scripts/`, and `tests/`
- recent Auto-BD commit messages and sign-offs through `6ad95132b0`

## Commands Run

```bash
git status --short
git branch --show-current
git rev-parse HEAD
git log --oneline -n 8
sed -n '1,260p' auto_bd_research_adversarial_prompt.md
sed -n '1,220p' auto_bd_research_implementation_todo.md
tail -n 240 auto_bd_research_implementation_history.md
git log --format=%B -n 1 6ad95132b0
git show --pretty=fuller --no-patch 6ad95132b0
python - <<'PY' ... inspect centralized report JSON gate matrices ... PY
python - <<'PY' ... inspect run-matrix model/token flags ... PY
UV_LINK_MODE=copy uv run --active python - <<'PY' ... inspect all parquet schemas ... PY
find docs/journal_features -maxdepth 4 -type d ...
```

I did not run the test suite during validation because this task allowed
edits only to this report. I inspected recorded validation evidence and
ran read-only schema/report checks.

## Prior Residual Risk

Resolved.

The previous report noted that older baseline/control/fixed-vector
`standard_results/candidates.parquet` files lacked the new provenance
columns. I inspected all 26 available `standard_results/` roots. Every
root now has:

- all files required by `RESULT_FILES`;
- all `RUN_MANIFEST_FIELDS` in `run_manifest.json`;
- all `CANDIDATE_FIELDS` in `candidates.parquet`;
- all descriptor provenance fields in `descriptor_vectors.parquet`.

Baseline, control, and fixed-vector rows now carry the provenance columns
with empty values. SR-PCA/kernel/VQ rows carry nonempty descriptor hashes.
No schema issue remains from the previous residual-risk item.

## Gate And Policy Checks

Gate 0:

- Seed-1 central report covers all 6 classic-covered development
  problems for every listed method, with no missing classic-covered
  problems.
- Seed-3 central reports for seeds 1001, 1002, and 1003 cover all 13
  classic-covered main-screening problems for every screened method, with
  no missing classic-covered problems.
- No selected method exists, so the selected-method coverage gate is
  satisfied by negative selection rather than by a positive finalist.

Run policy:

- `auto_bd_run_policy_lock.yaml` fixes endpoint
  `http://20.0.0.103:8000/v1`, model `openai/gpt-oss-120b`, observed
  and required context length 131072, and `max_tokens` /
  `diff_max_tokens` at 128000.
- Development and main-screening run matrices contain the required model,
  token, and `--vllm_min_model_len 131072` flags for every entry.
- All 26 inspected `standard_results/run_manifest.json` files use the
  locked model and endpoint.
- Worker and budget policy is locked by phase and does not show
  asymmetric model fallback.

Report comparability:

- Central reports include robustness funnel, failure breakdown,
  leaderboard, gate matrix, comparison matrix, anytime metrics, archive
  metrics, QD summary, descriptor correlations, and representative elites.
- Cross-method QD reporting includes fixed common-audit metrics and
  figure paths for common-audit coverage, entropy, occupied-cell heatmap,
  and descriptor/PPA correlations.
- PPA/HV normalization is recorded with fixed objective directions,
  improvement formula, hypervolume reference policy, invalid-candidate
  handling, and fixed PPA-grid policy.
- Diversity reporting includes canonical netlists, motif signatures, and
  PPA-front netlist counts rather than exact hashes alone.

Descriptor leakage:

- Fitting artifacts for SR-PCA/ReLU/RFF/VQ record fixed-offline fitting,
  205 training candidates, excluded held-out/main-screening/final
  evaluation data, forbidden descriptor inputs, feature-schema hash,
  scaler hash, method-specific map/PCA/codebook/layout hashes, and a
  descriptor hash.
- All inspected projected/codebook candidate rows have nonempty
  descriptor hashes and no missing provenance columns.
- Method cards and configs state that PPA, fitness, hypervolume,
  reference PPA, testbench pass percentage, and problem ID are forbidden
  descriptor inputs.

ST-NOD:

- ST-NOD method docs require stage dumps to be observational.
- The history and method card record the live Yosys fixture check where
  the baseline final synthesized netlist hash matched the ST-NOD final
  stage snapshot.

Functional audit and PPA remeasurement:

- The plan requires these for a final selected method.
- `auto_bd_final_negative_decision.md` scopes them out because no method
  was selected. That is consistent with the adversarial prompt's selected
  finalist condition.

## Code And Artifact Checks

- `src/revolution/auto_bd/results.py` includes the standard result schema
  and the provenance fields.
- `scripts/build_auto_bd_standard_results.py` attaches frozen descriptor
  provenance for SR-PCA/ReLU/RFF/VQ methods and empty provenance values
  for nonlearned methods.
- `tests/scripts/test_build_auto_bd_standard_results.py` checks both
  empty nonlearned descriptor hashes and nonempty learned descriptor
  hashes.
- `src/revolution/auto_bd/method_specs.py` uses literal method families,
  rejects forbidden descriptor inputs, and fails on unknown method kinds.
- The implementation history records focused validation after the latest
  fixes: 58 focused pytest tests, ruff, ty, and pyright all passing.
- Commit `6ad95132b0` has a conventional signed message with no raw `\n`
  text and a single sign-off footer.

## Organization Check

- Method documentation lives under
  `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_methods/`.
- Each attempted method directory has `method_card.md`, `accept_reject.md`,
  and at least one report artifact.
- I did not find scattered Auto-BD method directories directly under
  `docs/journal_features/` outside the scaffold-local tree.

## Remaining Limits

- `ANHV@1.5`, learned-BD scatter plots, and stronger correctness audits
  remain future-finalist requirements. They are not required for the
  current negative selection claim.
- The current evidence supports a negative development/seed-3 decision,
  not a positive held-out journal-method claim.

## Conclusion

No automatic-fail condition remains for the stated final negative result.
The repository now contains a coherent paper trail: all tried methods are
visible, rejected methods remain documented, Gate 0 and robustness/PPA/QD
comparisons are reported, learned descriptor provenance is logged for the
in-loop projected/codebook methods, and all available standard-results
roots now share the provenance-column schema.
