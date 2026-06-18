# Experiment artifacts — index & provenance

Report files copied from the per-feature journal worktrees and the main
workspace `exp/`, organized to support the briefing
([../README.md](../README.md)). Each subdirectory holds the `backend_comparison.md`
(per-arm + per-problem tables) for one experiment, plus configs / validation /
stats where relevant. Numbers in the briefing trace here; these trace to the
run paths in the **Source** column.

## Read-this-first provenance

- **Two evidence tiers.** The per-feature worktree runs (subdirs 01–07) are
  **single-seed (seed 42), pop 20 × 5 generations** directional ablations — fast
  feature-isolation, *not* publication-grade. The **rigorous confirmations** are
  the **5-seed** locked-subset runs (08 smooth-QD, 09 F1) with paired
  cluster-bootstrap statistics. Read 01–07 as "which way does this component
  push," and 08–09 as "what survives replication."
- **Same setup across 01–07:** 13-problem hard subset
  (`hard_iteration_subset_v1_pruned` = 7 RTLLM + 6 VerilogEval-Spec-to-RTL),
  `openai/gpt-oss-120b`, **240 LLM calls/design for every arm** (budget-matched),
  all arms reach 100% functional + synthesis *any*-pass on all 13 problems. So
  the story is **never** "the journal version is broken" — it is "at equal
  budget and equal solve-rate, the journal version optimizes PPA/quality less
  well." All deltas are vs the per-problem reference design.
- **"Multi-objective winner"** in each report header is decided by mean Pareto
  hypervolume → per-problem HV wins → mean Pareto points.
- The worktree `exp/` trees are **not** on this branch; these copies make the
  briefing self-contained. To re-derive, check out the worktree at the Source
  path.

## Headline: the v2 journal proposal lags classic (integrated run, 01)

13-problem hard subset, seed 42, 240 calls/design each. Higher is better.

| Arm | Avg score Δ vs ref | Avg PPA Δ | Pareto mean HV | HV wins (/13) | Func pass@1 | Multi-obj winner |
|---|---|---|---|---|---|---|
| **classic REvolution** | **+27.61%** | **+34.47%** | **0.1038** | **10** | 48.5% | **✅ classic** |
| v2 journal (rebin off) | +15.55% | +19.13% | 0.0625 | 3 | 48.6% | — |
| v2 journal + KS rebin | +18.14% | +21.30% | 0.0622 | 0 | 46.3% | — |

The full v2 journal configuration leaves **~12 points of score-delta and ~15
points of PPA-delta on the table** versus classic, and classic wins the
multi-objective crown 10 HV-wins to 3. KS adaptive rebinning recovers a little
but does not close the gap (and on this subset the trigger fired its checks but
executed zero actual rebins).

## Subdirectory map

| # | Subdir | What it isolates | Arms (journal arm in **bold**) | One-line significance | Source (worktree run / `exp/`) |
|---|---|---|---|---|---|
| 01 | `01_integrated_v2_vs_classic/` | The integrated v2 QD stack (grid_quantile + per-cell Pareto + 3-descriptor trio + single thought-operator) on **code individuals**, ± KS rebin | classic · **grid_quantile_pareto_journal_bd_unified** (rebin off/on) | Headline: v2 lags classic ~12pp score / ~15pp PPA; HV 0.062 vs 0.104. NB this arm leaves `representation_kind` at the default `code_individual` — the *thought-only* piece is isolated in 02 and run at 5 seeds in 09 | `.worktrees/journal-ks-adaptive-rebinning/exp/journal_adaptive_rebinning_hard_subset/20260513_153507{,_rebin_on_20260513_234625}/` |
| 02 | `02_component_thought_only/` | Thought-only k-code representation | classic · **grid_quantile_pareto_journal_thought_k4** | The mechanism: func pass@1 **higher** (67.9 vs 49.7) yet PPA-Δ **lower** (+21.9 vs +37.0) — thought-only trades code-level optimization for functional reliability; +30 calls, ~2.2× runtime | `.worktrees/journal-thought-only-k-code/exp/journal_thought_only_k4_validation_reuse/20260514_075747/` |
| 03 | `03_component_single_operator/` | Single unified operator vs six-operator EoH | classic · bd_eoh (six-op) · **bd_unified** (single) | Single-op is weakest of the three on score/PPA/HV and **fails the functional-pass-rate gate** (mean Δ −0.186 < −0.10); six-op ≈ classic | `.worktrees/journal-single-mutation-operator/exp/journal_single_thought_operator_hard_subset_prompt_v9/20260513_103524/` |
| 04 | `04_component_quantile_binning/` | Quantile archive binning | classic · **grid_quantile_journal_bd** | **The one component that helps alone**: +25.8 vs +23.6 score, HV 0.107 vs 0.100, 8 HV-wins vs 5 → kept in the landing variant | `.worktrees/journal-quantile-binning/exp/journal_quantile_binning_hard_subset_final/20260505_022158/` |
| 05 | `05_component_pareto_front_cells/` | Per-cell NSGA-II Pareto vs scalar elite | classic · grid_quantile_journal_bd (scalar) · **grid_quantile_pareto_journal_bd** (per-cell Pareto) | Per-cell Pareto gives the best func pass@1 (53.7%) but the **worst** score/PPA of the three; loses MO (2 HV-wins). Per-cell Pareto < scalar elite on quality | `.worktrees/journal-pareto-front-archive/exp/journal_pareto_front_hard_subset/20260506_040658/` |
| 06 | `06_component_bd_trio/` | The 3 behavioral descriptors (CVT archive) | classic · **cvt_journal_bd** | Descriptors alone don't help: classic wins HV 10 vs 3; func pass@1 a tie | `.worktrees/journal-bd-trio/exp/journal_bd_trio_hard_subset_full/20260503_181144/` |
| 07 | `07_variant_rent_exponent_bd/` | BD variant: Rent's-exponent / theory-grounded descriptors (replaces log-cell-count axis) | classic · **cvt_theory_grounded** (`theory_grounded_full_20d`, axis #3 = `rent_exponent`) · 4 structural baselines | The BD variant that **didn't pan out**: func pass@1 36.6 vs 54.6, HV wins 1 vs 9; small score/PPA edges are an artifact of averaging over fewer scorable designs | `.worktrees/qd-theory-grounded-descriptors/exp/hard_iteration_qd_theory_vs_baseline_20260326_160434/` |
| 08 | `08_landing_smooth_qd/` | **The landing variant** (5-seed): code individuals + EoH + champion lane + QD archive; V1 = cell-crowded tournament, V2 = + global NSGA-II selection | classic · **smooth-QD V1** · **smooth-QD V2** | V2 reaches **no-significant-cost parity** (best-quality Δ −0.016, CI [−0.045, +0.007], p=0.17); V1 alone significantly worse (−0.034, CI [−0.066, −0.009]) | `exp/fast_iter/smooth_qd_code_individual/` and `exp/fast_iter/smooth_qd_nsga2/` (`stats_5seed_vs_classic/`) |
| 09 | `09_locked_5seed_ablation/` | Rigorous 5-seed confirmation of the radical v2 (thought-only + single-op = `qd_target`) | classic · **qd_target** | Confirms the regression with paired stats: best-quality Δ **−0.093**, CI [−0.149, −0.036], p<0.001 | `exp/ablation_matrix/stats/final_5seed_F1_qt_vs_classic/` |
| 10 | `10_cvdp_realbench/` | Newer benchmarks, isolated-graded (authoritative functional verdict) | classic · qd_v2 (CVDP); classic/qd/qd_v2 (RealBench) | CVDP easy 9/10 = 9/10, medium 7/10 = 7/10 (QD ties where the model is capable); RealBench: capability ceiling on the 5 large e203 modules | `exp/cvdp_easy_fixed/`, `exp/cvdp_medium_fixed/`, `exp/fast_iter/capability_remap/` |

## Component takeaway (why the integrated v2 regresses)

Reading 02–06 together: most components are individually near-neutral, **quantile
binning is individually positive (04)**, but the two that *isolate the regression*
are **thought-only representation (02)** and the **single unified operator (03)** —
exactly the two pieces the landing variant (08) drops. The integrated run (01)
already lags classic with just the single thought-operator + full archive **on
code individuals** (+15.6 vs +27.6 score); adding **thought-only** on top (the
5-seed `qd_target`, 09) makes it lag rigorously (−0.093 best-quality). So the two
harmful pieces compound, while the descriptor choice (06) and the Rent's-exponent
variant (07) are second-order — they don't rescue quality.
