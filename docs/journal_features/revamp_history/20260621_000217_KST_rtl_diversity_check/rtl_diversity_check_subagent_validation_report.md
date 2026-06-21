# RTL Diversity Check Restart Validation

Verdict: PASS

Scope: this validation covers current HEAD
`e63f73da83643768e6fa3b549cad2205e3babc6d`
(`feat(diversity): Add Qwen replay`) on branch
`feat/journal-diversity-check-exp-20260620`, plus the current report artifact
`exp/diversity_check/restarted_report_20260621_075346_UTC/`.

This validates only the current `B illumination_only` and
diagnostic-only/no-proceed claim. It does not validate a reconstructive,
predictive, mechanistic, active, or Auto-BD method claim.

## Evidence Inspected

- Active contract:
  `rtl_diversity_check_plan.md`, `rtl_diversity_check_implementation_todo.md`,
  `rtl_diversity_check_implementation_history.md`, `goal_template.md`, and
  `rtl_diversity_check_adversarial_prompt.md`.
- Current generated report:
  `exp/diversity_check/restarted_report_20260621_075346_UTC/diversity_necessity_report.md`,
  `diversity_necessity_report.json`, `d_gate_matrix.csv`,
  `claim_levels.csv`, `counterfactual_replay.csv`,
  `encoder_leaderboard.csv`, `corpus_coverage.csv`, and
  `candidate_audit.csv`.
- Restart artifacts:
  `wp0_stnod_sr_reconstruction_20260621_040536_UTC/`,
  `wp0_quality_gated_novelty_20260621_041500_UTC/`,
  `wp0_lineage_source_audit_20260621_055941_UTC/`,
  `wp0_lineage_descendant_yield_20260621_060447_UTC/`,
  `wp0_budget_funnel_curves_20260621_062414_UTC/`,
  `wp2_near_motif_suppression_20260621_072816_UTC/`,
  `wp3_learned_encoder_20260621_053245_UTC_dim2_fixed/`,
  `wp3_learned_encoder_20260621_053245_UTC_dim3_fixed/`,
  `wp3_rich_encoder_20260621_070533_UTC/`, and
  `wp1_qwen_common_audit_20260621_075031_UTC/`.
- Encoder setup/probe artifacts:
  `qwen3_probe_20260621_032811_UTC/`,
  `qwen3_yosys_probe_20260621_033323_UTC/`,
  `deepgate3_aig_probe_20260621_034421_UTC/`, and
  `deepgate3_tokenizer_probe_20260621_034921_UTC/`.
- Relevant implementation/tests:
  `scripts/report_rtl_diversity_check.py`,
  `scripts/reconstruct_rtl_diversity_wp0.py`,
  `scripts/analyze_rtl_diversity_budget_funnels.py`,
  `scripts/audit_rtl_diversity_lineage_sources.py`,
  `scripts/analyze_rtl_diversity_lineage_yield.py`,
  `scripts/run_rtl_diversity_wp3_learned_encoder.py`,
  `scripts/run_rtl_diversity_wp3_rich_encoder.py`,
  `scripts/analyze_rtl_diversity_near_motif_suppression.py`,
  `scripts/run_rtl_diversity_wp1_qwen_common_audit.py`, and matching
  `tests/scripts/test_*` files.

## Checks Run

- `git status --short --branch && git log --oneline -5`: branch and HEAD
  match the request; only unrelated untracked
  `.devcontainer/devcontainer-lock.json` is present.
- `findmnt -T /aux/revolution-history -o TARGET,SOURCE,FSTYPE,OPTIONS`:
  historical mount is NFS4 with `ro` options. `test -w /aux/revolution-history`
  exited `1`.
- Focused tests:
  `uv run pytest -q tests/scripts/test_report_rtl_diversity_check.py tests/scripts/test_reconstruct_rtl_diversity_wp0.py tests/scripts/test_analyze_rtl_diversity_budget_funnels.py tests/scripts/test_audit_rtl_diversity_lineage_sources.py tests/scripts/test_analyze_rtl_diversity_lineage_yield.py tests/scripts/test_run_rtl_diversity_wp3_learned_encoder.py tests/scripts/test_run_rtl_diversity_wp3_rich_encoder.py tests/scripts/test_analyze_rtl_diversity_near_motif_suppression.py tests/scripts/test_run_rtl_diversity_wp1_qwen_common_audit.py`
  returned `19 passed`.
- `uv run ruff check` on the same touched scripts/tests returned clean.
- `uv run pyright` on the touched scripts returned `0 errors, 0 warnings,
  0 informations`.
- `git diff --check` returned clean.

## Claim Validation

- The generated report selects exactly one final level:
  `Final verdict: **B illumination_only**`.
- `d_gate_matrix.csv` supports that boundary:
  D1 early predictive `FAIL`, D2 multi-cluster front `FAIL`, D3 replay
  retention `FAIL`, D4 prospective moderate diversity `NOT_RUN`,
  D5 real-beats-random `FAIL`, and only D6 interpretable regions `PASS`.
- `claim_levels.csv` marks only `L0 descriptive` as supported. L1
  reconstructive, L2 predictive, L3 mechanistic, and L5 method are not
  supported; L4 active was not run.
- Recomputed from `counterfactual_replay.csv`, mean oracle best-fitness HV is
  `0.042294483949` and mean oracle motif-diversity HV is `0.042866056657`.
  The gain is about 1.35%, matching the report's D3 failure and well below
  the 10% utility gate.
- D2 includes the required shuffled-label control and fails against it:
  report evidence is 48.8% multi-cluster Pareto-front rate versus 56.0%
  shuffled-label rate.
- The report preserves the 20260618 Auto-BD negative/control result and does
  not present Yosys-stat, motif histogram, ST-NOD, projected
  synthesis-response, VQ/codebook, or random descriptors as untested
  promising baselines.
- Corpus coverage is explicit. `corpus_coverage.csv` covers broad RTLLM,
  Auto-BD seed-3 standard-results roots, and ASP-DAC release roots with
  RTLLM and VerilogEval-Spec-to-RTL coverage. The report records 203,944 total
  candidates, 180,544 evolution-analysis candidates, 170,131 ASP-DAC release
  candidates, 10,413 legacy RTLLM candidates, and 23,400 Auto-BD controls.
- Validity is separated from PPA claims. The report and budget-funnel artifact
  stratify generated, functional, synthesis-valid, valid-PPA, and Pareto-front
  candidates; invalid candidates are not used to claim PPA diversity.

## Restart-Specific Checks

- Budget funnels are present:
  `wp0_budget_funnel_curves_20260621_062414_UTC/budget_funnel_summary.json`
  records 203,944 candidates, 1,069 problem groups, 21,380 curve rows, and
  25/50/75/100% checkpoints across generated, functional, synthesis-valid,
  valid-PPA, and Pareto-front funnels.
- ST-NOD/SR reconstruction is present:
  `wp0_stnod_sr_reconstruction_20260621_040536_UTC/` records 9,360 generated
  rows and valid-PPA-scoped non-empty descriptor vectors rather than filling
  missing invalid-candidate descriptors.
- Lineage was searched beyond the first corpus:
  `wp0_lineage_source_audit_20260621_055941_UTC/` and
  `wp0_lineage_descendant_yield_20260621_060447_UTC/` record 271 lineage
  files, 3,358 edges, 2,233 found-parent edges, and 779 positive child-quality
  deltas, but 0/8 method/table groups with positive mean quality delta. This
  supports no mechanistic claim.
- Quality-gated novelty replay was run:
  `wp0_quality_gated_novelty_20260621_041500_UTC/` covers
  `novelty_parent_fraction` values `0`, `0.1`, `0.25`, and `0.5` with a
  prefix-median valid-fitness floor. It preserves best fitness but does not
  recover the baseline Pareto sizes, so it is correctly diagnostic-only.
- Near-motif replay was run:
  `wp2_near_motif_suppression_20260621_072816_UTC/near_motif_suppression_aggregate.csv`
  covers 2,335 RTLLM valid-PPA rows with motif vectors. HV and Pareto retention
  decrease at all tested thresholds, so it does not justify promotion.
- Qwen dependency escalation and real extraction were attempted and succeeded.
  `qwen3_probe_summary.json` records model `Qwen/Qwen3-Embedding-0.6B`, CUDA
  device `NVIDIA RTX A6000`, `torch 2.6.0+cu124`, embedding shape
  `[45, 1024]`, runtime, and non-collapse. `qwen3_yosys_summary.json` records
  15/15 Yosys-normalized conversions.
- Qwen common-audit replay is current:
  `wp1_qwen_common_audit_20260621_075031_UTC/qwen_common_audit_aggregate.csv`
  records 768 candidates. Raw Qwen farthest-first loses HV versus lexical
  farthest-first by 1.25%; identifier-normalized Qwen gains 3.35%, below the
  10% D3 gate. The report keeps Qwen diagnostic-only and does not promote it
  as an in-loop descriptor.
- DeepGate3 was attempted beyond missing-import status:
  artifacts record source/environment setup, AIG export, latch-free parsing,
  and tokenizer embeddings. The central report keeps it no-proceed because
  the bounded embedding slice collapsed with pairwise cosine mean near
  `0.999971` and the state policy is combinational-only.
- AURORA-style learned encoders were not promoted. The dim-2/dim-3 and
  rich AE8/AE16 probes are problem-split, exclude PPA fields from the encoder
  features, and remain `diagnostic_only_no_proceed`; rich AE8/AE16 do not
  improve held-out HV or Pareto retention over the implementation-feature
  baseline.
- No live model calls or live evolution runs are used in the current report,
  so the vLLM preflight and 128K-token policy are correctly scoped out.

## Residual Blockers For Stronger Claims

These do not block the current `B illumination_only` claim, but they block any
higher claim level:

- D3 remains below threshold, D2 fails against shuffled labels, D1 is an
  uncontrolled post-hoc correlation, D4 is not run, and D5 remains negative
  against the 20260618 Auto-BD controls.
- Qwen evidence is bounded and diagnostic. A projection head, larger slice, or
  fine-tuning pass would need an explicit fitting corpus, leakage controls,
  truncation policy, and D1/D3 no-proceed threshold before running.
- DeepGate3 evidence is weak: only three nontrivial embeddings, collapsed
  distances, latch-bearing/sequential cases rejected, and no cone-splitting
  policy.
- Lineage evidence is still not enough for a mechanistic claim. Available
  lineage edges do not show positive mean descendant yield across method/table
  groups.
- Distance-based near-motif suppression is limited to RTLLM rows with stored
  motif vectors; ASP-DAC and Auto-BD imported rows lack comparable
  distance-bearing motif vectors in this audit.
- The report scripts are acceptable as bounded experiment/reporting code, but
  `scripts/report_rtl_diversity_check.py` is long and should not absorb more
  compatibility paths before a stronger, narrower research target is chosen.

No automatic-fail condition applies to the current bounded claim.
