# Holdout Eligibility Audit

Status: `FROZEN_REVIEWED`, 2026-07-20. This audit was completed before any
treatment was launched and passed independent methodology review.

## Source Audit

| Source | Inventory and harness | Prior exposure | Decision |
| --- | --- | --- | --- |
| RTLLM | 50 local testbench tasks; 46 have complete reference PPA. | All 50 and seeds 1001-1005 were repeatedly used by QD, Pareto, memory, and operator studies. | Development and confirmation suite only; never holdout. |
| VerilogEval-Spec-to-RTL | 156 local testbench tasks. | All 156 have evaluated summaries in the archived conference root. Source/evaluated inventory hashes are `301e28ce...` and `4d9147f8...`. | Ineligible. |
| VerilogEval-Code-Complete | Local completion tasks, but not the same generation contract or a validated reference-PPA final surface for this program. | Conference-era use is not cleanly separable. | Ineligible for this goal rather than adding a new task formulation. |
| RealBench | Legacy manifests cover validated AES, e203, and SDC modules. The generated benchmark tree is absent locally. | Debug, final-slice planning, and several e203 outcomes already informed prior method decisions; heavy-run reliability issues remain documented. | Ineligible and unavailable without scope expansion. |
| CVDP | 302 non-agentic, non-commercial tasks with cocotb harnesses; functionality only. | Twenty-nine task IDs have recorded debug/easy/medium outcomes. A separate 30-task manifest was frozen previously but was not valid as a holdout. | Eligible after deterministic exclusion of the 58-task union. |

The VerilogEval evidence is reproduced in
`20260710_222442_KST_pareto_revolution_validation/prelaunch_audits.md`:
the archived root is
`exp/diversity_check/aspdac2026_submission_source/REvolution-aspdac2026-submission/exp/deepseek_clean_results/VerilogEval-Spec-to-RTL`.

## Frozen CVDP Holdout

`shared/cvdp_prior_exposure.yaml` records the union of the 29 outcome-exposed
IDs and all 30 IDs in the old manifest, for 58 unique exclusions. This is
stricter than outcome disjointness: even old manifest membership bars a task.
`scripts/build_cvdp_debug_subset.py` then applied the repository's existing
category-stratified selection rule:

```bash
uv run python scripts/build_cvdp_debug_subset.py \
  --output-config docs/journal_features/revamp_history/20260720_191404_KST_tcad_revolution_extension/shared/cvdp_holdout_v1.yaml \
  --subset-name tcad_extension_cvdp_holdout_v1 \
  --difficulty medium --per-category 6 --seed 20260720 \
  --exclude-config docs/journal_features/revamp_history/20260720_191404_KST_tcad_revolution_extension/shared/cvdp_prior_exposure.yaml
```

Frozen artifacts:

| Artifact | SHA-256 |
| --- | --- |
| CVDP source JSONL | `8b87b0c60a5f3b5f86c620de82a3057533e89c860438ab233250ddd4927d525b` |
| Prior-exposure manifest | `f5d36eb6150e430c2342cc1e31a5df5fa06ba66057d811313307d88363feddc0` |
| Holdout manifest | `9f0b8e1c7946858e901e337e5c963864e21b1724c921f701d7ebe6881f36fc5e` |

The result contains six medium tasks from each of `cid002`, `cid003`, `cid004`,
`cid007`, and `cid016`, with zero overlap with all 58 excluded IDs. The prior
`data/configs/cvdp_final_30_subset.yaml` is barred in full rather than trying to
salvage its 29 outcome-unexposed tasks.

## Use Contract

- Do not run, grade, replace, or inspect holdout outcomes before finalist code,
  configuration, and claims are frozen.
- Run matched classic and each frozen finalist once at seed 62001 with the same
  48-candidate budget.
- CVDP's in-run pass reporting has under-counted valid candidates under load.
  Grade every claimed candidate with isolated cocotb re-evaluation and archive
  the reason-coded result.
- Primary metric: problem-level functional any-pass. Missing treatment output is
  a failure. Report paired task outcomes, W/L/T, exact sign test, calls, tokens,
  runtime, and missing units.
- CVDP has no reference PPA. This holdout can support functionality and task
  generalization only; it cannot validate RTLLM PPA gains.
- A holdout loss does not authorize tuning, task replacement, a second holdout,
  or relabeling as development evidence.

## Eligibility Verdict

`ELIGIBLE_FUNCTIONAL_HOLDOUT`. The 30 selected tasks have no recorded outcome or
prior manifest exposure, but their prompts reside in the local dataset and
their IDs are frozen in this manifest. The defensible claim is repository-
evidence-disjoint evaluation, not a secret benchmark or cross-suite PPA
validation.
