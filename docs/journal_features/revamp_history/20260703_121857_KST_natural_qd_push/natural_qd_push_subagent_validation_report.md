# Natural QD Push Sub-Agent Validation Report

## Post-N10 Negative-Map Addendum

Validation addendum, 2026-07-07. After N04, N02b, N07a/N07b/N07c,
N09, and N10 follow-ups, the exhausted-portfolio alternative outcome is
validated as PASS. The full addendum report is
`negative_map_adversarial_validation_report.md`.

Verdict: PASS. No stronger natural QD/MAP-Elites extension than the
V2/N03b characterization was found under the registered, operator-fair
follow-up loop, and the post-N10 decision map is complete enough to guide
the TCAD manuscript. Required fixes before PASS: none. Residual
compact_8d and held-out items are paper decisions, not blockers for this
goal's follow-up campaign.

---

Validation v2, 2026-07-04. Rubric: `natural_qd_push_adversarial_prompt.md`, judged at the claimed tier exactly: two-scale characterization (replicated screening win; suite-scale HV parity with coverage edge; Branch-B utility 0.413; +5% gate honestly failed; held-out scoped out).

## Verdict

PASS

All headline evidence is sound, operator-fair, and reproducible from packaged artifacts (screen and suite means recomputed independently to the last digit). The prior v1 FAIL was packaging-scoped; its one surviving concrete fix — the canonical-delta 46-scope sign note — is verified executed (`p3_full_rtllm/canonical_statistics/read_note.md:48-57`, `central_comparison_report.md:25-27`, commit `91b6220d5d`). Every remaining unmet item re-derived below is documentation/packaging-grade, so per the rubric's negative-outcome clause (the characterization is operator-fair, seed-replicated, and complete enough to guide the manuscript and the next method selection) the verdict is PASS with a punch list under Non-blocking observations.

## Evidence Checked

- Plan/TODO/history/README of the push; `goal_template.md`; `original_thoughts.md`; TODO is 151 lines (within the 200-line cap).
- `lanes/`: registry (8 rows N01–N08), `lanes/README.md`, all five executed lane packages (N01, N02, N03, N05, N06 — 10 measured screen arms) with methodology/results/commands, 273 committed figure PNGs, and descriptor probes (leakage check: `requires_ppa: false` on every profile; no PPA/fitness/HV/rank/pass-rate/problem-identity inputs).
- `p0_v2_anchor/`: results, commands, seed 1001–1003 packages; `three_seed_summary.csv` recomputed — classic 0.14418 vs V2 0.16284 = +12.9% HV, +16.2% HV-AUC, 3/3 per-seed wins, coverage 8/8 all seeds.
- `p3_full_rtllm/`: `five_seed_verdict.md` (95.2% HV, 100.5% AUC46, coverage 166 vs 164; per-seed rows re-summed), `commands.md` (registered before any full-suite result; promotion arm per the rule registered 2026-07-03 in `p0_v2_anchor/results_report.md:45-51` before P1 reads), `p3b_closure.md` (gt3d killed by its pre-registered 2-seed floor: 0.091397 < 0.90×0.104479 = 0.094031; N03b ladder COMPLETE at 5 seeds, 96.9% HV / 102.5% AUC), `p3c_closure.md` (all ten sweep runs complete), `canonical_statistics/` (`statistical_tests.{md,json}`, `paired_deltas.csv`, `branch_b_utility_{v2,n03b}.csv`: 0.413043 = 95/230 vs bar 0.25).
- Operator-contract audits: `single_thought_count=0` for BOTH arms in every packaged `operator_contract.csv` (30 files — p0 all 3 seeds, all 5 lanes incl. N03 replication seeds, p3 seeds 1001–1005, p3b, p3c).
- `run_validation*.json` (26 files): pins `qd_operator_kind=eoh_strategies`, `representation_kind=code_individual`, `strict_ablation`, seeds; status pass, errors [].
- `tables/`: 8-design screen manifest; `classic_baselines.csv` (screen rows recompute-verified before use; suite 5-seed HV reproduced exactly, 0.103802 vs pinned 0.10380; AUC divergence +0.21% disclosed `tables/README.md:28-35`); `v2_platform_config.md` (faithful pin + strict_ablation ruling dated before the anchor relaunch; unfaithful first anchor quarantined as `_INTERRUPTED_UNFAITHFUL`).
- `exp/natural_qd_push/`: 11 run roots with per-seed vLLM preflight captures (`openai/gpt-oss-120b`, max_model_len 131072) and 128000-token budgets pinned in the stored command (`v2_platform_config.md:78-95`).
- `journal_narrative.md` frozen gates (+5% log-ratio :213-214, branch table :248-254, utility bar :252, Branch-C floor :269-278) cross-checked against `central_comparison_report.md`; `13_findings_dashboard.md` F33–F35 block with 2026-07-04 refresh stamp and contamination-supersession note; June-22 `technique_lineage_ledger.md:363-374` closure note.
- `reviews/`: claude p0 + p3 periodic (PASS_WITH_ACTIONS, actions executed by commits `6fa46cfc77`/`e653bbd1c5`/`8c9e080f20` et al.), codex p1 (PASS_WITH_ACTIONS) and p3 (clean PASS, zero actions, independent recompute 95.18%/100.51%), 10 hourly-watch cycles (PASS/PASS_WITH_ACTIONS), `adversarial_validation_v1_addendum_only.md` (FAIL, packaging-scoped, numbers verified exact).
- Git: 62 commits on `feat/journal-qd-bd-exp-20260703` from `f786d9306b`; `git diff` on `src/revolution/algorithm.py` and `src/revolution/qd/engine.py` EMPTY; new code confined to `src/revolution/qd_natural/` (109-line typed, asserted subclass overriding only parent sampling) + `qd/pareto_analysis.py` (+43) + backend dispatch; HV-AUC regression test vs stored 20260630 tables at abs 1e-9 over 138 rows (`tests/scripts/test_report_hv_auc.py:123-160`); all three validators tracked and tested; no untracked-dir imports; push docs tree clean in `git status`.

## Findings

1. Screening win VERIFIED: +12.9% mean HV, +16.2% HV-AUC, 3/3 seeds, coverage 8/8, operator audits clean on all seeds — the numbers reproduce from `tables/hv_auc.csv` and `three_seed_summary.csv` to the last digit. First replicated operator-fair QD win in the program.
2. Suite characterization VERIFIED: 95.2% HV / 100.5% AUC46 / coverage 166 vs 164 on the 46 reference-complete designs, seeds 1001–1005; classic 5-seed baseline recomputed exactly against the original pcn_v3 run roots.
3. The +5% gate failure is stated honestly everywhere (verdict, central report, dashboard F34); no spin. Canonical statistics corroborate parity (HV delta +0.0035, CI [−0.0089, +0.0210]; 46-scope restriction −0.0050).
4. The v1-mandated scope-sign note is executed and arithmetically correct: the canonical 50-scope delta's positive sign is driven entirely by Prob013_multi_booth (excluded from the 46-scope headline); 0.098801 − 0.103802 = −0.005001 matches the packaged tables.
5. Branch-B utility 0.413 traces to `branch_b_utility_v2.csv:7` (95/230 = 91 nondominated-improving + 4 QD-only) via the tracked script; even under the stricter reading excluding QD-only units (91/230 = 0.396) the 0.25 bar clears — the claim is robust to the definitional nuance.
6. No contaminated June-22 number is cited as mechanism evidence anywhere; every T31+ single-thought citation is flagged as the artifact itself. gt3d was killed by a pre-registered gate; N02's hard-gate kill carries an allowed-set cause class (exploration-tax) plus a registered follow-up.
7. Naturalness held: ≤2 knobs per lane, no trigger mechanisms, published QD concepts named; N03's two-mechanism delta vs V2 is a documented registered exception attributed single-factor against N01a; N08 never ran because no replicated single-factor winner existed — compliant with its pre-registration rule.
8. Persistence: the broad-negative trigger never tripped (the outcome is a positive characterization, not a negative map); the ≥8-packages completion gate is met at measured-arm level (11 screen + 3 suite arms) across 4 strict families, with the arm-level accounting disclosed in history:441-443. Strict top-level count is 5 lane dirs — see observation 7.
9. Engineering rules held: engine.py/algorithm.py untouched (empty diff); validators exist, are tested, and their outputs are consumed in every run package; pytest (18 focused tests)/ruff/pyright recorded clean on touched files; all experiment seeds in {1001..1005}; debug seed 42 never used as evidence (one labeled N02 smoke only).

## Missing Or Weak Evidence

- No literal `ppa_completeness.csv` exists in any package; the reference-complete manifest restriction plus `reference_ppa_metrics.csv` substitute its semantics (disclosed, `p3_full_rtllm/commands.md:47-49`), but the plan's named artifact is absent.
- The +5% log-ratio gate number (+0.0298 vs bar 0.0488) comes from a disclosed INTERIM implementation (bootstrap seed 7777); `statistical_tests.json` shows `hypervolume_log_ratio: {}` and `gate_profile: none` — the canonical script never computed the gate. Self-adverse and independently hand-recomputed with no drift (v1 addendum), so the FAIL direction is not in doubt.
- The entire P3c 10-run sweep is absent from the implementation history (it jumps 10:40 → 23:50 on 2026-07-04); the sweep is documented only in the p3c files, bd_scoreboard, and the hourly-watch log. The `source_aligned_shape_density_3d` profile's provenance likewise appears only in the P3c registration file.
- Three single-seed "closed" verdicts sit within ±5% of classic (N03a +0.7%, N06c +0.5%, N06d −4.3%) against the plan's no-single-seed-verdict rule; mitigated — each loses decisively to its proper comparator (−9.9%/−18.7%/−22.6%), N06d is the registered random floor, and N06c/N06d received 2-seed suite reads in P3c — and none feeds the claimed tier.
- Lane results reports never cite or claim inspection of their 273 committed figures (the p0 anchor report does, `p0_v2_anchor/results_report.md:83-94`); N06's wave-1 collapse-probe gate was satisfied post-launch (quarantine lifted retrospectively), which the push itself converted into the Gate-before-launch constraint.
- The 6x7 classic baseline (0.1701) is pinned but recompute-unverified — acceptable only because N04 never ran; the pinned 5-seed AUC (0.08680) diverges +0.21% from the canonical recompute (0.086982), disclosed and rescoped to HV.
- The v1 validation's Required Fixes 1–7 body was lost to a claude -p capture defect (history:585-589); only the addendum survived. This report supersedes it with the complete re-derived list below.

## Reward-Hacking Or Intent Risks

- Overall LOW: the record is consistently self-adverse — the +5% failure is front-and-center, the 50-scope jackpot sign was disclosed against the push's own interest, the unfaithful first anchor and the N06 quarantine were self-imposed, and four independent review channels (claude periodic, codex, hourly watch, v1 adversary) recomputed the headline numbers to exactness.
- Residual watch items: (a) N06/compact_8d arms fire C-D/M-T fill lanes (other_strategy_count up to 220) that trio/classic never fire — ruled admissible for characterization, but any FUTURE promotion claim from a non-trio descriptor needs an `eoh_success_operator_set`-style operator-mix control; (b) the ≥8-packages gate holds only under arm-level counting — keep that accounting explicit in the manuscript; (c) the central report's Branch-C "floor legs" list swaps in the screening win where the narrative's leg (i) is the pre-existing F2 unified-operator ablation — a labeling slip, not an evidence gap, since F2 pre-exists; (d) the held-out scope-out follows the plan's operationalization rather than a narrative trigger clause; it is defensible because no Branch A/B final claim is made (narrative :112-113 drop clause plus the June-16 F25 decision), but the central report should state that basis precisely.

## Required Fixes Before PASS

None — the verdict is PASS at the claimed tier. The complete re-derived list of still-unmet items follows; all are documentation/packaging-grade.

## Non-blocking observations

1. Append the P3c registration/launch/closure entries (including shape_density provenance) to the implementation history — the audit log must cover all 27 runs.
2. Ship a literal `ppa_completeness.csv` per suite package, or record a versioned exception naming the manifest + `reference_ppa_metrics.csv` as the equivalent.
3. Re-run `report_journal_statistics.py` with the gate profile so the +5% log-ratio FAIL is canonical (currently interim, bootstrap seed 7777, canonical gate field empty).
4. Add protocol-deviation notes for the N03a/N06c/N06d single-seed closes (or relabel "closed" → "parked, single-seed within-band"); assign allowed-set cause classes for N03a/N05a/N06c/N06d and tick the open P1 cause-class TODO item.
5. Reword the central report's Branch-C floor legs to map 1:1 to `journal_narrative.md:269-274` (leg i = the pre-existing F2 ablation; the screening win is an added positive), and cite the :112-113 drop clause + F25 decision for the held-out scope-out.
6. Add one-line visual-inspection notes citing the pairwise-fronts PNGs in each lane results report (p0 already compliant).
7. Tick/annotate the plan's completion-gate checkboxes (currently all `[ ]`) with evidence pointers, and state the arm-level ≥8 accounting (5 lane dirs / 4 strict families; 14 measured arms) in the plan status line.
8. Record the 14 commit subjects at 51–54 chars (>50 golden rule, ≤72 hard cap) as accepted debt — do not rewrite pushed history.
9. Keep the verify-before-N04 annotation on the unverified 6x7 baseline prominent; cite only the canonical 0.086982 AUC going forward.
10. Add a one-word clarifier in `read_note.md` that `bootstrap_seed=42` is the resample RNG of the canonical statistics script, not an experiment seed, to preempt confusion with the banned debug seed.
