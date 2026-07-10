# Suite-First Variant Campaign

Start date: 2026-07-08.

This campaign reopens experimentation after the post-N10 negative-map
PASS for one reason: the small 8-design screen is now treated as a weak
predictor of full RTLLM behavior. The prior decision map remains valid
for the old gate policy. This folder records the new user-directed policy:
use the screen only for debugging/extraction and spend full RTLLM probes
on more natural variants.

## Goal

Find a natural QD/MAP-Elites extension that meets or improves classic
REvolution on full RTLLM PPA HV while retaining or improving functionality
coverage. A strong result needs 5-seed evidence; early 1- or 2-seed reads
are only triage.

## Literature Anchor

- MAP-Elites: archive high-performing elites over user-chosen behavior
  dimensions (`https://arxiv.org/abs/1504.04909`).
- CVT-MAP-Elites: use centroidal Voronoi tessellations to scale archive
  geometry beyond rigid grids (`https://arxiv.org/abs/1610.05729`).
- Multi-Objective MAP-Elites (MOME): store Pareto fronts in cells for
  multi-objective quality diversity (`https://arxiv.org/abs/2202.03057`).
- Multi-emitter MAP-Elites: natural but higher-risk for this repo because
  emitter changes can blur operator parity (`https://arxiv.org/abs/2007.05352`).

## Baselines

Full RTLLM 46 reference-complete, 8x5, seeds 1001-1005:

| Arm | Mean HV | HV-AUC46 | Coverage |
| --- | --- | --- | --- |
| classic REvolution | 0.103802 | 0.086982 | 164/230 |
| Smooth-QD V2 | 0.098801 | 0.087428 | 166/230 |
| N03b front-slot lane | 0.100587 | 0.089186 | 163/230 |

Primary target: beat or match classic mean HV while retaining or improving
coverage. Secondary target: beat classic HV-AUC or expose a clear
functionality/coverage utility trade.

## Ladder

| Stage | Scope | Decision |
| --- | --- | --- |
| Smoke | full RTLLM, 1 seed | Runtime/extraction/operator-contract gate only. |
| Probe | full RTLLM, 2 seeds | Promote if HV >= classic or coverage/functionality is clearly better. |
| Confirm | full RTLLM, 5 seeds | Manuscript-grade claim attempt. |

Do not use an 8-design screen result as a kill gate. Do use it to avoid
known extraction failures before expensive descriptors.

## Guardrails

- Use `classic_operator_kind=eoh_strategies`,
  `qd_operator_kind=eoh_strategies`, `representation_kind=code_individual`,
  and `single_thought_count=0` for every headline comparison.
- Use `--eoh_success_operator_set classic` for comparator parity.
- Keep `--max_tokens 128000 --diff_max_tokens 128000` and record vLLM
  preflight for every live run.
- Keep variants natural: config-first, at most two clean knobs, no
  PCN-style trigger/credit/stagnation logic, no operator-set changes.
- Combination arms require at least one positive full-suite single-factor
  signal unless explicitly registered as a high-risk exploration.

## Files

| File | Purpose |
| --- | --- |
| `variant_registry.csv` | Candidate list, wave assignment, status. |
| `wave_a_preregistration.md` | First full-suite wave contract. |
| `wave_b_preregistration.md` | Front-slot and Wave B probe contract. |
| `commands.md` | Launch/package templates and exact suite command shape. |
| `results_log.md` | Append-only run/results ledger for this campaign. |
| `restart_handoff_20260709.md` | Restart-safe state through S11 warmup12 closure. |
| `post_s07_followup_decision.md` | Decision note for the first targeted descriptor follow-up after S07. |
| `post_s23_warmup_decision.md` | Decision note bounding S11 as warmup-family closure after S23. |
| `post_s11_suite_decision.md` | Decision note closing the suite-first primary queue after S11. |
| `s32_capacity4_mechanism_card.md` | Fresh mechanism card reopening one S07-family capacity interpolation test. |

## Progress

| ID | Status | Current read |
| --- | --- | --- |
| S01 | two seeds packaged | Coverage +1/92 vs matched classic, but two-seed HV and HV-AUC remain below classic and V2. Do not promote as a primary arm. |
| S02 | two seeds packaged | Warmup16 nearly ties classic two-seed HV-AUC, but loses HV and coverage. Do not promote as a primary arm. |
| S03 | five seeds packaged; not promoted | Slot-2 closes at 96.6% of classic HV, 97.9% of classic HV-AUC, and 163/230 coverage. It recovers V2 final HV to 101.5% of V2, but trails classic on all primary gates. |
| S20 | two seeds packaged; not promoted | Seed 1002 beats matched classic on HV/AUC with equal coverage, but the two-seed read remains below classic and V2 on HV/AUC: S20 `0.095855` HV / `0.085447` HV-AUC46 / `66/92` coverage vs classic `0.104479` / `0.085867` / `66/92` and V2 `0.098539` / `0.087146` / `65/92`. |
| S21 | two seeds packaged; not promoted | Scalar-elite retention closes as a clean negative control: S21 `0.086994` HV / `0.080445` HV-AUC46 / `65/92` coverage vs classic `0.104479` / `0.085867` / `66/92` and V2 `0.098539` / `0.087146` / `65/92`. |
| S09 | two seeds packaged; not promoted | Front-slot lane 0.20 is a front-loss control: S09 `0.096357` HV / `0.085650` HV-AUC46 / `66/92` coverage vs classic `0.104479` / `0.085867` / `66/92` and V2 `0.098539` / `0.087146` / `65/92`. Seed 1001 was positive, but seed 1002 did not replicate it. |
| S22 | two seeds packaged; not promoted | Conservative front-slot lane 0.10 is HV-AUC-positive but not a primary HV win: S22 `0.101722` HV / `0.089115` HV-AUC46 / `66/92` coverage vs classic `0.104479` / `0.085867` / `66/92` and V2 `0.098539` / `0.087146` / `65/92`. It beats V2 and ties classic coverage, but still trails classic final HV. |
| S07 | five seeds packaged; secondary near miss | Capacity3 closes at S07 `0.102481` HV / `0.088031` HV-AUC46 / `165/230` coverage vs classic `0.103802` / `0.086982` / `164/230` and V2 `0.098801` / `0.087428` / `166/230`. It beats classic on HV-AUC46 and coverage and beats V2 on HV/HV-AUC46, but misses the primary classic final-HV gate at 98.7% of classic. Seed-paired stats and case studies are in `S07_capacity3/five_seed_analysis/summary.md`. |
| S23 | seed 1001 packaged; closed negative | Descriptor-reduction control: S23 `0.084403` HV / `0.076832` HV-AUC46 / `31/46` coverage vs matched classic `0.111401` / `0.090551` / `33/46` and V2 `0.096767` / `0.083539` / `32/46`. It reduces descriptor collapse to `4/50` archives but triggers the smoke stop rule at 75.8% of classic final HV. |
| S11 | seed 1001 packaged; closed negative | Warmup12 is a one-knob initialization interpolation between V2 warmup8 and S02 warmup16. Seed 1001 ties matched classic coverage but remains HV-negative: S11 `0.095807` HV / `0.085702` HV-AUC46 / `33/46` coverage vs classic `0.111401` / `0.090551` / `33/46` and V2 `0.096767` / `0.083539` / `32/46`. Close after seed 1001 and keep S12 blocked. |
| S31 | blocked after S23 negative | Contingent S07 combination: S07 capacity3 plus explicit `logic_depth comb_width_log` axes. Do not launch from current evidence because the required S23 single-factor signal was HV-catastrophic. |
| S32 | registered | Capacity4 is the one-knob S07-family interpolation between V2 capacity5 and S07 capacity3. Run seed 1001 first; continue to seed 1002 only if validation passes and the seed is not catastrophic. |

## Initial Wave Choice

Wave A prioritizes variants that are already implemented and mostly
config-only:

1. capacity 7 (N09 transferred screen-classic wins but not V2).
2. warmup 16 (strong screen read, never suite-tested).
3. elite-pareto slot 2 (simpler retention that may generalize).
4. compact_8d CVT completion to 5 seeds (descriptor-health candidate).
5. trio CVT completion to 5 seeds (geometry control).
6. gt3d completion if the paper needs a coverage-focused arm.

Wave B then tests small parent-source/capacity/interpolation variants.

## Extended Queue

`variant_registry.csv` now records a broader suite-first queue through
S31. Rows S01-S28 are either already launched, config-only, or blocked
only by the stated single-factor signal policy. Rows S29-S30 are not
launch-ready: they capture literature-natural brainstorms that would need
a small tested parent-selection module or a descriptor registration gate
before any full-suite run.

Near-term executable choices after S07 five-seed closure are:

1. Do not claim S07 as the primary PPA-HV win. It is secondary
   trajectory/coverage evidence and a clean capacity-control near miss.
2. Treat S09 as closed; do not promote front-slot lane 0.20 to five
   seeds.
3. Use S20 and S21 only as negative parent-selection/retention controls
   unless a later mechanism specifically motivates revisiting them.
4. Treat S22 as an HV-AUC-positive front-slot interpolation control, not
   as the primary TCAD arm.
5. Keep S04/S05/S06 as appendix-only descriptor-health or coverage
   controls unless a fresh decision note selects them; they are not
   primary HV candidates from current evidence.
6. Do not launch S10 front-slot 0.40, S08 capacity9, or S19 capacity11
   from current evidence; front-slot 0.20 failed to replicate and larger
   capacity moved opposite S07's better direction.
7. S11 warmup12 is closed after one valid seed. It ties matched classic
   coverage but remains far below classic final HV and HV-AUC46, so S12
   warmup24 remains blocked.
8. S23 is closed after one valid seed. The reduced 2D descriptor improved
   archive-collapse health but was final-HV catastrophic. Do not broaden
   this into a 2D descriptor scan or launch S31 without a new independent
   mechanism. Keep compact8d/CVT and gt3d/testability for specific
   health/coverage appendices, not the next primary HV lane.
9. S32 capacity4 is the current fresh mechanism-card exception to the
   post-S11 closure. It is not a broad queue reopen; it directly tests
   whether S07 capacity3 was too restrictive for final Pareto quality.
