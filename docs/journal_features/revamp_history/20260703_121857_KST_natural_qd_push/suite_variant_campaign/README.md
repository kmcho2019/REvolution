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

- Use `qd_operator_kind=eoh_strategies`, `representation_kind=code_individual`,
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
| `commands.md` | Launch/package templates and exact Wave A command shape. |
| `results_log.md` | Append-only run/results ledger for this campaign. |

## Progress

| ID | Status | Current read |
| --- | --- | --- |
| S01 | two seeds packaged | Coverage +1/92 vs matched classic, but two-seed HV and HV-AUC remain below classic and V2. Do not promote as a primary arm. |
| S02 | seed 1001 packaged | Warmup16 beats V2 on seed-1001 HV/HV-AUC and nearly matches classic AUC, but loses coverage. Complete seed 1002. |

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
