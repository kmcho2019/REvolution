# Experiment Reports — manual-examination index

Human-readable summary reports generated (via the repo's report scripts) for
the headline experiments behind the
[consolidated record §7 evidence index](journal_revamp_consolidated_record.md)
and [doc 13 findings dashboard](../../13_findings_dashboard.md). Purpose: make
the per-problem / per-task results easy to open and inspect, rather than
reading raw JSON.

**Provenance & scope notes (read first):**

- The reports live next to their runs under `exp/` (git-ignored, like the runs
  themselves). They are *regenerable* artifacts — see [§3](#3-regenerate). The
  committed sources of truth remain the consolidated record, doc 13, and
  `manuscript_artifacts/tables.tex`.
- The QD/ablation **per-problem bundles** are generated on **seed 1001 as a
  representative seed**. The decision-bearing numbers are the **5-seed pooled,
  penalized** statistics in each `statistical_tests.md`; the per-problem bundle
  is for qualitative inspection of *where* an arm wins or loses.
- For **CVDP / RealBench**, the authoritative functional verdict is the
  **isolated-grade** summary (one candidate per process group). The in-run
  `report_generator` functional column under-reports valid candidates under
  parallel-eval contention (findings M12 / M14) — do **not** read functional
  pass off the in-run `*_report.md` for these two benchmarks.

---

## 1. QD / ablation comparisons (best-quality, PPA, per-problem)

Pooled Δ is treatment − baseline on best-quality (penalized, 5-seed cluster
bootstrap). Multi-objective winner is `classic` in every comparison below.

| Finding | Comparison | Pooled Δ best-quality (gate) | Pooled stats report | Per-problem bundle (seed 1001) | What to look for |
|---|---|---|---|---|---|
| **F1** | qd_target vs classic | **−0.093** [−0.149, −0.036] | `exp/ablation_matrix/stats/final_5seed_F1_qt_vs_classic/statistical_tests.md` | `exp/ablation_matrix/stats/final_5seed_F1_qt_vs_classic/final_analysis_seed1001/backend_comparison.md` | qd_target's pass@1 collapses on VerilogEval (28% vs 56%): Prob116 7.5% vs 69%, Prob153_gshare 1.7% vs 45%, Prob135 score −1.3% vs +18.6%. It wins a few RTLLM problems (Prob015 +51% vs +24%) but loses pooled. |
| **F2** | qd_target vs qd_six_operators | **+0.001** [−0.008, +0.011] | `exp/ablation_matrix/stats/final_5seed_F2_qt_vs_six/statistical_tests.md` | `exp/ablation_matrix/stats/final_5seed_F2_qt_vs_six/final_analysis_seed1001/backend_comparison.md` | Single thought-operator ≈ six-operator EoH suite **within QD** — the operator-selection simplification at no measured cost (CI straddles 0, inside ±0.03). |
| **F3 / F9** | classic_unified vs classic | **−0.092** [−0.149, −0.037] | `exp/ablation_matrix/stats/floorleg_classic_unified_pooled/statistical_tests.md` | `exp/ablation_matrix/stats/floorleg_classic_unified_pooled/final_analysis_seed1001/backend_comparison.md` | The same single-operator simplification **costs quality on the classic substrate** (no archive to supply exploration). Regime split: RTLLM −0.134 / VerilogEval −0.038. |
| **F23 (V2)** | smooth_qd_nsga2 vs classic | **−0.016** [−0.045, +0.007] | `exp/fast_iter/smooth_qd_nsga2/stats_5seed_vs_classic/statistical_tests.md` | `exp/fast_iter/smooth_qd_nsga2/stats_5seed_vs_classic/final_analysis_seed1001/backend_comparison.md` | The positive contribution: NSGA-II global selection brings smooth-QD to **no-significant-cost** parity (CI low > −0.03). Classic still edges multi-objective, but within the parity band. |
| **F23 (V1)** | smooth_qd_code_individual vs classic | **−0.034** [−0.066, −0.009] | `exp/fast_iter/smooth_qd_code_individual/stats_5seed_vs_classic/statistical_tests.md` | `exp/fast_iter/smooth_qd_code_individual/stats_5seed_vs_classic/final_analysis_seed1001/backend_comparison.md` | V1 (cell-crowded tournament) is **significantly worse** — this is the contrast that shows NSGA-II (V2) is what closes the gap. |

Each `final_analysis_seed1001/` bundle also contains `report.md` (narrative
roll-up), `pareto_analysis/`, `ppa_distribution/`, `feature_analysis/`, and
`design_space_analysis/` for deeper inspection.

## 2. Harder-benchmark capability (functional pass — isolated-graded, authoritative)

| Finding | Result | Authoritative summary | Source grade JSON(s) | What to look for |
|---|---|---|---|---|
| **F18–F21 / F28 / F29** RealBench e203 | classic **4** / qd_v2 **3** / qd **2** valid (of 112) | `exp/fast_iter/capability_remap/grade_realbench_summary.md` | `exp/fast_iter/capability_remap/grade_mismatch_compare.json`, `exp/fast_iter/capability_remap/grade_mismatch_v2.json` | Capability ceiling: only the 2 ALU modules ever pass; the 5 larger modules get **0 valid** across all arms. The `best` column is the F29 "chasm" — closest candidate still misses 21–100% of test vectors. QD never exceeds classic. |
| **F30 / F31** CVDP easy | classic **9/10** = qd_v2 **9/10** | `exp/cvdp_easy_fixed/grade_cvdp_easy_summary.md` | `exp/cvdp_easy_fixed/grade_cvdp_easy.json` | After the F30 interface-confound fix, the LLM solves 9/10; QD adds nothing in the capable regime. Only `perfect_squares` fails — both arms. |
| **F32** CVDP medium | classic **7/10** = qd_v2 **7/10** | `exp/cvdp_medium_fixed/grade_cvdp_medium_summary.md` | `exp/cvdp_medium_fixed/grade_cvdp_medium.json` | Sweet-spot **falsified**: identical task-by-task — both solve the same 7, fail the same 3 (`bus_arbiter`, `fifo_async`, `neuromorphic_array`). |

In-run `report_generator` reports also exist next to these runs
(`…/RealBench_report.md`, `…/cvdp_report.md`) and are useful for syntax /
synthesis / PPA, **but their functional column is the in-run under-report** —
use the isolated-grade summaries above for the functional verdict.

## 3. Regenerate

```bash
# QD/ablation cross-arm bundle (one per comparison; seed 1001 representative)
python scripts/report_final_analysis_bundle.py \
  --backend_run "classic=exp/ablation_matrix/classic/seed_1001/revolution/openai_gpt-oss-120b" \
  --backend_run "qd_target=exp/ablation_matrix/qd_target/seed_1001/revolution/openai_gpt-oss-120b" \
  --subset-config data/configs/hard_iteration_subset.yaml \
  --output-dir exp/ablation_matrix/stats/final_5seed_F1_qt_vs_classic/final_analysis_seed1001

# Per-benchmark pass/PPA table (any run root's model dir)
python scripts/report_generator.py \
  --experiment_result_path exp/cvdp_easy_fixed/qd_v2/revolution/openai_gpt-oss-120b --save_markdown

# Authoritative isolated-grade summary (CVDP / RealBench)
python scripts/render_grade_summary.py --title "CVDP easy tier (isolated-graded)" \
  --out exp/cvdp_easy_fixed/grade_cvdp_easy_summary.md exp/cvdp_easy_fixed/grade_cvdp_easy.json
```

The other comparisons swap the `--backend_run` roots / `--out` paths per the
table above (run roots are listed in the consolidated record §7 and §8).
