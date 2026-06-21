# Experimental Setup

This setup makes the next push repeatable and auditable before live sampling.

## Branch And Output Roots

- Branch: `feat/journal-useful-bd-exp-20260622`.
- Planning docs:
  `docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/`.
- Replay/live output root: `exp/useful_bd_push/<technique>/<timestamp>/`.
- Technique packages:
  `docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/<slug>/`.

## Replay Sources

Use replay before live sampling.

| source | path | use |
| --- | --- | --- |
| ASP-DAC release copy | `exp/diversity_check/aspdac2026_submission_source/REvolution-aspdac2026-submission/exp/` | Broad prior runs for DeepSeek, GPT-4.1-mini, and Llama3 variants on RTLLM and VerilogEval. |
| RTL diversity audit | `exp/diversity_check/restarted_report_20260621_075346_UTC/` | Candidate audit, previous Qwen/DeepGate/AURORA diagnostics, and negative evidence. |
| Auto-BD prior run | referenced in `diversity_necessity_report.md` under `/aux/revolution-history/.worktrees/journal-auto-bd-exp-20260618/` | Classic, landing Smooth-QD, random, ST-NOD, synthesis-response, and VQ controls. |
| QD implementation history | `docs/revolution_qd_map_elites_implementation_plan.md` | Prior live QD evidence, especially long-token `20 x 5` RTLLM/VerilogEval comparisons. |

At goal start, verify whether a remote or archived `aspdac2026-paper` ref is
available. The exact local branch ref is not present in this worktree at
scaffold time, but the copied source archive exists under `exp/diversity_check`.

## vLLM Runtime

Use `vllm_runtime_guide.md` for endpoint selection, preflight commands, smoke
harnesses, and live command templates. Known targets include the shared host
endpoint `host.docker.internal:8000`, the compose service `vllm:8888`, and
older historical endpoints that must be revalidated before reuse.

## Fixed Variables

Before a method run, record:

- model and model revision;
- benchmark and problem subset;
- seeds;
- prompt/operator set;
- population size and generations;
- token budgets;
- synthesis and PPA flow versions;
- descriptor fitting corpus;
- archive type, cell count, and centroid/grid definitions;
- dependency environment.

For reasoning-model vLLM experiments, `max_tokens` and `diff_max_tokens` must
be `128000` unless the run is explicitly labeled a tiny smoke.
Record the `/v1/models` response and resolved model id for every live run.

## Method Run Order

1. Build central candidate index and passive archive schema.
2. Re-score classic and landing Smooth-QD with the same metrics.
3. Run P0 deterministic descriptors on replay data.
4. Run P1 QD/archive variants on replay data.
5. Escalate promising P1/P2 methods to bounded live sampling.
6. Escalate P3 learned encoders only after dependency setup and collapse tests.
7. Update each technique package immediately after each run.

The minimum completed push is 10 current method attempts with real artifacts.
Controls can count when rerun under the new metrics, but the final negative map
must cover more than a few familiar failures.

## Dependency Policy

Dependency failure is not a stopping condition until these have been tried and
logged:

1. use existing `.venv`;
2. `uv add <dependency>` if it fits the repo;
3. isolated env under `exp/useful_bd_push/envs/<technique>/`;
4. source checkout or submodule under `exp/useful_bd_push/sources/<technique>/`;
5. faithful surrogate with exact differences recorded.

## Reproducibility Artifacts

Each run root must contain:

- `run_config.json`;
- `candidate_manifest.csv` or equivalent;
- descriptor fit files and hashes;
- passive archive config;
- raw tables needed to regenerate figures;
- generated figures;
- visual inspection notes for generated figures;
- stdout/stderr or run log;
- vLLM preflight capture for live LLM runs;
- `README.md` stating the command and commit hash.

Each technique package must mirror the key paths in `artifacts_manifest.md`.

## Code Cleanliness During Experiments

Follow `code_organization_policy.md` before adding new implementation code.
The intended shape is a small shared evaluator plus method-specific descriptor
extractors. Do not add scattered one-off flags, broad fallback logic,
duplicated report builders, or compatibility shims that make the core pipeline
harder to skim.

New public or non-obvious helpers need type hints and Google-style docstrings.
Update comments and docs when behavior changes. Keep comments sparse and
useful.

## Visualization And Reporting

Follow `visualization_reporting_policy.md` for every technique package and the
central comparison report. Generated figures must be inspected for readability,
clear labels, baseline comparison, and claim support before a technique is
marked complete.
