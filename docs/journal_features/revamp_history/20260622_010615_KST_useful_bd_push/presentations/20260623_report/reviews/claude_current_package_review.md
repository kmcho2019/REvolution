I now have enough to write the adversarial review. I've verified the key numbers against the underlying CSVs and cross-checked against the frozen claims contract. Let me note the decisive finding from the data: the `screening` development set is Prob015/041/045, and `comparison_deltas.csv:236-241` exposes the Prob040 pathology.

---

# Adversarial Review — `20260623_report` Package

**Verdict: NOT a clean pass.** The package is unusually transparent about *individual* caveats, but as written the affirmative headline ("Yes, diversity matters / keep the QD line") rests on disclosures that are present but **disconnected**, and on the one metric where QD wins while the metric where QD loses is omitted entirely. Four blocking presentation-integrity issues remain. All are fixable in the docs (no new experiment required) except where multi-seed is the genuine remedy. Must-stay-visible limitations are listed at the end.

---

## P0 — Blockers (overclaim / selective reporting as currently written)

### B1. The entire aggregate HV "win" is one defaulted-reference outlier, and the package never connects the two facts
`full_rtllm/tables/full_comparison_deltas.csv:236-241` shows `Prob040_synchronizer`: QD HV `0.991910` vs classic `0.000000` — QD essentially at the HV ceiling, classic at zero. This single problem moves the 50-problem mean from **−0.009465 (QD loses) to +0.010562 (QD wins)** — I reproduced the report's own counterfactual exactly: `(50·0.010562 − 0.991910)/49 = −0.009465` (`report.md:23-28`).

Now the linkage the package never makes: `Prob040_synchronizer` is **one of the three problems repaired with "the documented high default reference when a benchmark PPA file is absent"** (`report.md:302-307`). So the lone problem carrying the affirmative answer is one whose reference was *synthetically defaulted*, not a benchmark golden. The outlier disclosure (`report.md:23-28`, `slides.md:106`) and the repair disclosure (`report.md:302-307`) sit in different sections and are never joined. A reader cannot currently tell that "the win" = "the defaulted-reference problem."

**Worse, the Prob040 numbers are internally contradictory and look like a normalization artifact:** the same arm/problem has HV `0.991910` (near-maximal "improvement") *and* `best_score = −32.336033` (`full_comparison_deltas.csv:238`) — i.e. ~32× *worse* than reference on the quality scalar. Near-max HV with catastrophic best-quality on the same cell is not physically coherent under a sane reference normalization; it is the signature of a degenerate default-reference axis. Classic, under the *same* default reference, scored HV `0.0` with 48 valid candidates — also unexplained. The package headlines an aggregate win built on this point without showing or addressing the pathology.
- Fix: (1) state at the HV-claim site that Prob040 is a defaulted-reference problem; (2) add a **"Prob040-excluded" row** to `Result Summary` (and to `screen_excluded`, which also still contains Prob040, so its `+0.014325` collapses too); (3) explain the HV `0.99`/best_score `−32` contradiction or quarantine Prob040 from the headline.

### B2. The package omits its worst metric — the quality scalar `best_score` — and that metric is the contract's primary gate
`best_score` appears **nowhere** in `report.md`, `slides.md`, or `glossary.md` (grep: NONE), yet `full_aggregate_metrics.csv:2-3` shows mean `best_score` classic `0.260455` vs QD **`−0.798824`** (delta `−1.059279`, relative `−407%`, `full_comparison_deltas.csv:304`). Even excluding the Prob040 `−32` outlier, the non-Prob040 QD mean stays negative (~`−0.155`), and on the screen cohort QD is also worse (`0.277` vs `0.303`). This scalar is the contract's REF_WIN/REF_PARITY gate metric ("penalized … best-quality mean ≥ +0.03 / within ±0.03", `journal_narrative.md:234,252`). Leading the headline with HV (outlier-won) while silently dropping the quality scalar (decisively lost) is selective reporting. The thesis (`journal_narrative.md:16-30`) justifies *de-emphasizing* scalar PPA, but it does not justify *hiding* a gate-bearing metric — disclose it and state the thesis reason for not leading with it.

### B3. The affirmative headline fails the package's own "Paired HV" gate
`claim_gates.md:16` (Paired HV): *"Aggregate-only wins are insufficient."* `claim_gates.md` `useful_qd` requires *"positive paired evidence on pre-declared PPA metrics."* But per-problem HV is **4 wins / 15 losses / 31 ties** (`report.md:22-23`) — net-*negative* paired evidence. The only positive is the aggregate mean, and that aggregate is itself one-outlier-driven (B1). So the headline ("Yes … should not be dropped," `report.md:15-20`) is an aggregate-only, outlier-driven win that the package's own gate language declares insufficient. The split is disclosed, but the headline still says "Yes." Reframe the lead so the affirmative is explicitly carried by (a) one defaulted-reference problem and (b) front-point count — not by paired PPA evidence.

### B4. Family-audit "front-material" win is the front-point count relabeled — not independent corroboration
`full_family_aggregate_metrics.csv:2-3`: `ppa_front_count` = `front_unique_netlist_count` = `front_unique_family_count` = **61 / 69**, with `front_family_ratio = 1.000000`. So "69 vs 61 front family-proxy hits" and "69 vs 61 front netlists" are arithmetically identical to "69 vs 61 PPA-front points." Yet `report.md:287-290,350-353`, `full_rtllm/README.md:13-14`, and `slides.md:108` present front-points, front-family-proxies, and front-netlists as if they were three corroborating signals. They are one signal counted three times. State explicitly that front-family/front-netlist counts are not independent of the front-point count (front_family_ratio = 1.0), so the family audit's *positive* contribution reduces to "no duplicate-collapse explanation," not added front-material evidence.

---

## P1 — High

### H1. Same seed + same config, different results between screen and full runs → determinism not established
The development screen (Prob015/041/045, seed 1001, `screening/tables/screen_aggregate_metrics.csv`) gives Exact-T26 mean HV `0.183839` and classic `0.181382`. The full run's `screen` cohort — same 3 problems, same seed/model/budget — gives Exact-T26 `0.136053` and classic `0.184434` (`full_aggregate_metrics.csv:4-5`). Both arms shifted materially between two nominally identical runs. Most per-problem headline deltas are `~0.01-0.02`; if run-to-run noise is this large, the non-Prob040 signal is inside the noise band. The contract explicitly requires "a duplicate-synthesis determinism check on sampled candidates" (`journal_narrative.md:63-64`); the package shows none. This both undercuts the "one-seed *paired*" framing and should be surfaced as a reproducibility caveat.

### H2. The package never reconciles itself with the frozen claims contract that governs RTLLM PPA claims
`GUIDELINES.md:15` makes `journal_narrative.md` the ACCEPTED, frozen contract that "wins on any conflict." That contract specifies: finals = seeds **1001–1005** (`:218`); RTLLM evidence = 13-problem hard/tuning subset **plus a held-out 20-problem set never touched by repair/tuning** (`:79`, `:221-228`); gate statistic = penalized cluster-bootstrap HV log-ratio ≥ log(1.05) with sign-test win-rate (`:207-214`); Branch A/B/C decision table (`:246-254`). The package invents a parallel vocabulary (`useful_qd`, `strong_win`, "PPA-first retention gate") and **never references the contract, the held-out/tuning split, or Branch A/B/C at all.** Two concrete conflicts follow:
- **Contamination:** the Prob013/018/040 repair (`report.md:302-307`) is exactly a "repair/tuning" action the contract forbids on held-out problems (`:221-228`). The package reports `all_rtllm` (50) and `screen_excluded` (47) but **never states which of the 50 are hard/fast-subset (tuning) vs held-out.** If Prob040 is a tuning problem, the win is a tuning-set result that must be scoped as such; if held-out, the repair contaminated it. Either way it must be labeled.
- The package should add one paragraph mapping its cohorts and claim levels onto the frozen contract, or explicitly declare itself a pre-final exploratory milestone that does not invoke any frozen gate (the `claim_gates.md:37-42` "Replication Order" note gestures at this but does not name the contract).

### H3. Screen-exclusion is reported but the reversal it reveals is not
The 3 development-screen problems are Prob015/041/045 (`screening/tables/screen_problem_metrics.csv`) — never named in `report.md`/`slides.md`. On those very problems, QD **loses** HV in the full run (`screen` cohort delta `−0.048381`, `full_comparison_deltas.csv:308`). So T26 was selected on a razor-thin screen margin (`+0.002457`, ~+1.35%, `screen_selection_deltas.csv`) on problems where it then underperforms, and **2 of those 3 (Prob041, Prob045) became yield-warnings** in the full run (`report.md:269`). The screen-exclusion gate is mechanically satisfied, but the *direction* (excluding the screened-on problems makes QD look better, and the selection basis reversed) is a selection-validity story the package should tell, not bury.

---

## P2 — Medium

- **M1. Headline emphasis order.** The Executive Answer leads with "+11.18%" / "+15.31%" (`report.md:18-20`) before any caveat (caveats start `:22`). For a slide audience the positive number lands first and unqualified. `+11.18%`/`+15.31%` also sit just above the `strong_win` "≥10%" threshold (`claim_gates.md:31`); these are *aggregate*, not *paired*, deltas — keep them adjacent to the 4W/15L paired split to prevent a reader conflating them with the 10% paired bar.
- **M2. Family-proxy definition is overloaded and imprecise.** `family_audit/README.md:16-18` defines the proxy as "SHA-256 of the synthesized standard-cell **count** signature," while `report.md:346-348` and `full_rtllm/README.md:177-179` define it as a *three-part* bundle (normalized RTL hash + normalized netlist hash + cell-count signature). Which definition produces the `341/311/179/129` numbers is unstated. Also "standard-cell count signature" does not say whether it is a single total count (a very weak family proxy — many distinct netlists share a count) or a per-cell-type histogram. Pin one definition.
- **M3. Result figures are not surfaced in the narrative.** `report.md` embeds six *retrospective* figures inline (`:124,153,169,180,185,197`) — i.e. the part that *failed*/illuminates — but **no** `full_rtllm/figures/*` result figure (HV scatter, win/loss heatmap, validity funnel, representative fronts) appears inline anywhere; they exist only as paths in the artifact index. `slides.md` contains **zero** figures. The "Visual inspection" gate (`claim_gates.md:24`) has notes files, but the headline visual evidence is absent from the presentation surface.
- **M4. Reproducibility script placement vs GUIDELINES.** `retrospective/build_retrospective_summary.py` (`retrospective/README.md:27`) lives in the presentation tree, whereas `GUIDELINES.md:25` says reporting scripts belong in `scripts/`. Minor, but it is a stated convention.

---

## P3 — Low / to verify

- **L1. Token sub-axis skew.** Gated axes pass parity: total tokens within ±10% and LLM calls `4801` vs `4800` (`full_budget_parity.csv`), so the contract's ±10% rule (`journal_narrative.md:164-169`) holds. Note for completeness: QD spends `+9.0%` completion tokens and `+15.6%` *code-completion* tokens for the same call/candidate budget — worth a one-line mention since per-call output length differs.
- **L2. "12x3 budget" shorthand.** `report.md:21` says "12x3" but generated candidates are `2400/50 = 48`/problem = 12×4 (gen0 + 3). Harmless but slightly loose.
- **L3. Commit practice — unverified.** Could not read commit bodies (git log needs approval). `GUIDELINES.md:72` requires signed multi-line commits "never single-line for new work"; recent subjects in the status snapshot look conventional but bodies were not inspected. Confirm before push.

---

## Answers to the five required checks

1. **Family-audit proxy defined precisely?** **No (M2).** Two incompatible definitions (cell-count-only vs three-hash bundle) and "count signature" is ambiguous between total count and histogram. The README's honest hedge ("not a proof of semantic RTL families," `family_audit/README.md:18`) is good, but the proxy that produces the numbers is not pinned. Compounded by B4 (the front-proxy win is the front-point count relabeled).
2. **RTLLM one-seed limitation visible?** **Yes — well disclosed** (`report.md:3,90-92,357,371`; `slides.md:124-126`; `claim_gates.md:31-42`; `full_rtllm/README.md:186-191`). The deeper problem is not visibility of "one seed" but H1 (the seed does not appear to pin results) — disclose that too.
3. **Retrospective tied into the current narrative?** **Yes** (`report.md:94-212`, esp. `:199-212`; `slides.md:40-53`). It correctly licenses the *non-overclaim* posture. One imbalance: a 170k+90k-artifact retrospective "no" is being overturned by a one-seed, one-outlier "yes"; the asymmetry of evidence weight deserves an explicit sentence.
4. **Figures/tables referenced coherently?** **Partially (M3, B4).** Retrospective figures are embedded; headline result figures are not; slides carry no figures; and front-point/front-netlist/front-family are presented as three signals when they are one.
5. **Conflicts with GUIDELINES.md?** **Yes, mainly governance (H2):** the package runs in a parallel gate vocabulary without reconciling to the frozen `journal_narrative.md` contract that GUIDELINES says wins on conflict, and never declares the tuning/held-out split the contract requires. Minor: script placement (M4), commit bodies unverified (L3). Simplicity rules (`GUIDELINES.md:30-42`) target Python and are not implicated by this docs package.

---

## Must-stay-visible limitations (the honest floor for any "keep QD" claim)

1. The aggregate PPA-HV/HV-AUC win **flips negative without `Prob040_synchronizer`** (−0.009465), and `Prob040` is a **defaulted-reference** problem with internally contradictory metrics (HV 0.99 vs best_score −32).
2. Per-problem paired HV is **net-negative: 4 wins / 15 losses / 31 ties**; the win is aggregate-only.
3. QD is **worse on the quality scalar** (`best_score` −0.80 vs +0.26), **valid-PPA yield** (879 vs 1056), **unique PPA points** (318 vs 352), and **reference-beating proxies** (129 vs 179). The only QD-favorable counts are aggregate HV (outlier-driven) and front-point count (≡ family/netlist front count).
4. Evidence is **one seed (1001)**, run-to-run determinism **not demonstrated** (screen vs full diverge), and the comparison is **pre-final/exploratory** relative to the frozen 5-seed, held-out-set contract.
5. Family-proxy results are a **duplicate/front-material proxy only**, not implementation-family dominance; front-proxy counts are not independent of front-point counts.

Remedy for the headline (not just the caveats): multi-seed replication with a determinism check, real benchmark references for the three defaulted problems (or their permanent exclusion from headline HV), and reporting the quality scalar alongside HV. Until then the defensible claim is narrower than "diversity matters" — it is "T26 preserves classic-covered coverage and adds front points at matched budget, with no paired-PPA or quality-scalar advantage once one defaulted-reference problem is removed."
