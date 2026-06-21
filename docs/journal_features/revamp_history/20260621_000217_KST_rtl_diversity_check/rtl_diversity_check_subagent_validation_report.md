# RTL Diversity Check Restart Adversarial Validation Report

Verdict: PASS

Scope: this validation covers current HEAD
`b4383b5cc5a9028096bcfc85e6f5b43885e0a4c4` and the regenerated artifact
`exp/diversity_check/restarted_report_20260621_051025_UTC/`. The pass is only
for the current `B illumination_only` / diagnostic-only claim. It is not final
TCAD research sign-off, not a predictive or reconstructive diversity claim,
and not active Auto-BD method promotion.

## Inspected Evidence

- Rubric:
  `docs/journal_features/revamp_history/20260621_000217_KST_rtl_diversity_check/rtl_diversity_check_adversarial_prompt.md`.
- Active plan/checklist/history/goal:
  `rtl_diversity_check_plan.md`, `rtl_diversity_check_implementation_todo.md`,
  `rtl_diversity_check_implementation_history.md`, and `goal_template.md`.
- Restarted report:
  `exp/diversity_check/restarted_report_20260621_051025_UTC/diversity_necessity_report.md`
  and `.json`, plus the generated CSV tables and figures in that directory.
- WP0/WP2 replay artifacts:
  `exp/diversity_check/wp0_quality_gated_novelty_20260621_041500_UTC/`.
- WP1 encoder artifacts:
  `exp/diversity_check/qwen3_probe_20260621_032811_UTC/`,
  `exp/diversity_check/qwen3_yosys_probe_20260621_033323_UTC/`,
  `exp/diversity_check/deepgate3_aig_probe_20260621_034421_UTC/`, and
  `exp/diversity_check/deepgate3_tokenizer_probe_20260621_034921_UTC/`.
- Commit and touched code/tests:
  `b4383b5c`, `95a41e45b8`, `scripts/report_rtl_diversity_check.py`,
  `scripts/reconstruct_rtl_diversity_wp0.py`,
  `tests/scripts/test_report_rtl_diversity_check.py`, and
  `tests/scripts/test_reconstruct_rtl_diversity_wp0.py`.

## Validation Findings

- Branch/worktree: current branch is
  `feat/journal-diversity-check-exp-20260620` at requested HEAD
  `b4383b5c`. `git status --short` shows this validation report modified and
  unrelated untracked `.devcontainer/devcontainer-lock.json`; I did not modify
  the devcontainer lock.
- Historical mount: `findmnt -T /aux/revolution-history` reports the NFS mount
  as `ro`, so the historical checkout remains read-only from this workspace.
- Commit hygiene: `b4383b5c` is a signed, multi-line conventional commit:
  `fix(diversity): Align report case studies`. It is narrow: report
  case-study table alignment, explicit replay metric wording, tests, and
  history evidence.
- Focused validation command run during this pass:
  `PYTHONDONTWRITEBYTECODE=1 uv run pytest -q -p no:cacheprovider tests/scripts/test_report_rtl_diversity_check.py`
  returned `6 passed`.
- Corpus coverage remains adequate for the current claim. The restarted
  candidate audit has 203,944 rows across broad RTLLM, ASP-DAC release, and
  Auto-BD standard-results controls; it includes RTLLM and
  VerilogEval-Spec-to-RTL, five model labels, three Auto-BD seeds, and 23,400
  Auto-BD control rows.
- The candidate audit table includes the required identity, method/seed/model,
  benchmark/problem/generation/operator, validity funnel, PPA, code/netlist
  paths, descriptor provenance, canonical hash, motif hash, and Pareto fields.
  A read-only audit confirmed 102,736 valid-PPA rows, 52,745 Pareto rows, and
  zero non-empty `parent_id` values.
- The report preserves the 20260618 Auto-BD negative/control evidence. It does
  not present Yosys-stat, motif, ST-NOD, projected SR, VQ/codebook, or random
  descriptors as untested promising baselines.
- The final report selects exactly one verdict:
  `B illumination_only`. D1, D2, D3, and D5 are FAIL; D4 is NOT_RUN; only D6
  passes as L0 descriptive evidence. Claim levels mark L1/L2/L3/L5 as not
  supported and L4 as not run.
- The D2 multi-cluster result includes a shuffled-label control and fails
  against it: 48.8% multi-cluster Pareto-front rate versus 56.0% shuffled.
- D3 reconstructive replay fails: best diversity-oracle HV gain is 1.4%,
  below the 10% threshold. The report does not use oracle retention to claim
  online utility.
- WP0/WP2 restart evidence satisfies the key restart precondition for closing
  only as illumination: ST-NOD/SR rows were reconstructed, duplicate
  suppression was run, and quality-gated novelty replay was run with
  `novelty_parent_fraction` values `0.00`, `0.10`, `0.25`, and `0.50`.
- The follow-up fixed the replay wording gap. The regenerated report states
  that the quality gate uses valid-PPA candidates at or above prefix median
  valid fitness, and that novelty uses nearest-selected Euclidean distance
  over the existing four-axis `common_audit_descriptor_vector` without fitting
  a new scaler or using PPA-derived normalization.
- The follow-up fixed the case-study alignment gap. `case_studies.csv` now
  points `best_supported` to `Prob050_square_wave_M-E_sample9.sv` with
  `register_sequential`, and `null_or_median` to
  `Prob130_circuit5_C-F_sample8.sv` with `control_case`; both paths exist and
  match the generated `implementation_gallery.md` snippets.
- Qwen3 is no longer dependency-blocked. The artifacts record real
  `Qwen/Qwen3-Embedding-0.6B` extraction on 45 raw/comment/identifier texts
  with shape `[45, 1024]`, plus 15 Yosys-normalized texts. The report keeps
  Qwen diagnostic-only and does not promote it as an in-loop BD.
- DeepGate3 was attempted beyond missing-import status: source/environment
  setup, AIG export, latch-free parsing, and tokenizer embeddings were run.
  The result is correctly no-proceed/diagnostic-only because the bounded
  embeddings collapsed and the graph-state policy is combinational-only.
- ST-NOD/SR reconstruction remains backed by
  `wp0_reconstruction_summary.json`: 9,360 generated rows, 3,802 QD event
  rows, 312 budget rows, 624 duplicate-suppression rows, and 1,248
  quality-gated novelty rows.
- No live model calls or live evolutionary runs are used in the current
  report, so the vLLM preflight/token-setting requirements remain correctly
  scoped out.

## Residual Risks And Open Gaps

These are not PASS blockers because the current report does not claim above
`B illumination_only`, but they remain blockers for any stronger claim:

- Lineage remains incomplete. The current audit and inspected Auto-BD
  ST-NOD/SR artifacts expose no non-empty parent IDs, and QD events do not
  carry parent IDs. Broader lineage-rich corpus search remains partially open
  before any L3 mechanistic claim.
- Qwen3 extraction is still a bounded smoke. The summary records model,
  device, versions, shape, runtime, and artifact hashes in history, but full
  common-audit utility, larger coverage, and tighter truncation/batch policy
  reporting are still needed before predictive or in-loop claims.
- DeepGate3 evidence is intentionally weak: only three nontrivial embeddings
  were produced, they nearly collapsed, sequential circuits are not handled,
  and cone splitting remains open.
- Near-identical motif suppression remains partial. The current replay covers
  canonical netlist hash and exact motif-signature duplicate suppression; a
  distance-based near-identical motif policy remains open before stronger
  duplicate/novelty claims.
- `scripts/report_rtl_diversity_check.py` is long and carries pyright
  suppressions. It is acceptable as a bounded experiment/reporting script for
  this pass, but it should not grow into a broad compatibility layer.

## Final Verdict

PASS for the refreshed restarted `B illumination_only` report and
diagnostic-only / no-proceed recommendation at
`exp/diversity_check/restarted_report_20260621_051025_UTC/`. The evidence is
not sufficient for reconstructive, predictive, active, mechanistic, or
Auto-BD method claims, and the report does not make those claims.
