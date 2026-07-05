# Natural QD Push — Central Comparison Report (2026-07-04)

The consolidated answer to the push's question: does a natural
QD/MAP-Elites extension of classic REvolution beat classic on HV and
HV-AUC while keeping functionality? Twenty-seven operator-fair live
runs (P0-P3c), every comparison operator-audited
(`single_thought_count=0` both arms), config-pin validated,
seed-honest, and independently reviewer-verified (four scheduled
reviews + ten hourly-watch cycles, all PASS or PASS_WITH_ACTIONS with
every action executed).

## Verdict in one paragraph

**Scale decides.** At screening scale (8 small/mid designs) the
natural extension — Smooth-QD V2: classic's own EoH operators and
(thought, code, feedback) individuals, survivors living in a
grid-quantile MAP-Elites archive with bounded 5-elite per-cell Pareto
fronts and NSGA-II global parent selection — **beats classic
decisively and reproducibly**: +12.9% mean HV, +16.2% canonical
HV-AUC, 3/3 seeds, coverage retained (first replicated operator-fair
QD win in the program). At full-suite scale (46 reference-complete
RTLLM designs, 5 seeds) the same mechanism lands at **HV parity**
(95.2%; canonical stats: delta +0.0035, cluster CI [-0.0089, +0.0210])
with an **HV-AUC tie (100.5%)**, a **functionality edge** (coverage
166 vs 164; canonical functional_any_pass +0.020, 8W/3L; scope note:
the canonical delta's positive sign is 50-scope only — the 46-scope
restriction is -0.0050, see canonical_statistics/read_note.md), and a
**Branch-B utility of 0.413** (bar 0.25): on two of every five
problem-seed units the archive holds a valid, non-dominated
alternative design improving at least one PPA axis over classic's
best. The frozen +5% HV log-ratio gate is NOT met at suite scale,
where outcomes are LLM-capability-bound.

## Headline tables

Screening (frozen 8-design 8x5; classic 3-seed 0.14418):

| Arm | 3-seed mean HV | HV-AUC | Coverage |
| --- | --- | --- | --- |
| Smooth-QD V2 | 0.16284 (+12.9%) | 0.14141 (+16.2%) | 8/8 all seeds |

Full suite (46 ref-complete, 5 seeds; classic 0.103802 / 0.086982 /
cov 164 — recompute-verified against the pinned baselines):

| Arm | Mean HV | HV-AUC46 | Coverage | Utility (bar 0.25) |
| --- | --- | --- | --- | --- |
| Smooth-QD V2 | 0.098801 (95.2%) | 0.087428 (100.5%) | 166 | **0.413** |
| N03b front-slot lane | 0.100587 (96.9%) | 0.089186 (102.5%) | 163 | 0.391 |

Descriptor dial (P3c sweep + screen bake-off; full table in
`lanes/N06_descriptor_bakeoff/bd_scoreboard.md`): descriptor choice
sets two suite HV tiers (trio family + compact_8d at 93-94%, all
others 87-92%); archive geometry (CVT vs grid) is a wash; ONLY
testability semantics lift design coverage (gt3d 34+34/seed, best of
any arm; the random floor proved the effect is semantic); compact_8d
ties the trio's HV with ~4x its collapse resistance (health-grounds
swap candidate, decision deferred to the manuscript).

## The finding set (all pre-registered, gate-governed)

1. **Two-scale result**: QD wins where the LLM is capable and search
   dominates; dilutes to no-cost parity with utility/coverage gains
   where capability binds (consistent with F18-F32).
2. **Contamination forensics**: the June-22 negative map was an
   operator artifact (corrected reruns +30-46 retention points); the
   June QD validity tax is absent — V2 GAINS coverage.
3. **Utility content for the diversity claim**: 0.413 contract-defined
   utility at HV parity — criticism #5 now has concrete, measured
   substance at suite scale.
4. **Mechanism dial**: retention capacity monotone in screen HV
   (attribution ladder, single-seed diagnostic); N03b trades 2 HV
   points for best-in-family AUC; screen and suite INVERT V2/N03b
   ordering (the transfer gap applies between QD variants).
5. **Descriptor dial**: BD choice is a functionality/diversity/health
   dial, not an HV dial; archive health anti-correlates with HV.
6. **Methodology findings**: the ~18-point screen->suite transfer gap
   (small-subset screening validity); jackpot decomposition dominates
   single-seed suite reads; comparator variance across identical
   configs exceeds judged deltas.

## Branch mapping (frozen contract)

REF_WIN and REF_PARITY fail (the HV log-ratio gate is unmet at suite
scale), so Branch A/B headlines are unavailable; the held-out final
gate is scoped out with the verdict as evidence. The supported posture
is the STRONG characterization mapped 1:1 to the narrative's Branch-C
floor (journal_narrative.md:269-274): leg (i) the unified-operator
one-factor ablation = the pre-existing F2 result (parity within QD;
unchanged by this push); leg (ii) transferable root-cause analysis =
the contamination forensics + the capability-bound suite regime + the
utility/coverage content; leg (iii) the benchmark/statistics
infrastructure. The replicated screening win is an ADDED positive on
top of the floor, not a substitute for leg (i). The held-out final
gate is scoped out on the narrative's own basis: no Branch A/B final
claim is made (the :112-113 drop clause) and the June-16 F25 decision
already established documented-limitation handling for the held-out
set.

## Answered / unanswered / TCAD-strength

- Answered: the push's core question at both scales; the descriptor
  question at both scales; the utility content of diversity; the
  contamination question.
- Unanswered (registered follow-ups, non-blocking): N04 budget-depth
  shapes; N02b gamma 0.5; SR ReLU PCA profile; compact_8d swap
  decision; held-out confirmation of the screening win.
- TCAD-strength: the two-scale characterization with a replicated win,
  a 0.41 utility statistic, the descriptor dial, and full
  registration/audit provenance is materially stronger than the
  June-era Branch-C posture on every leg.

## Provenance

Every number: `p0_v2_anchor/`, `p3_full_rtllm/` (verdicts, canonical
statistics, closures), `lanes/` packages; reviews under `reviews/`;
policies in `tables/`; run roots under `exp/natural_qd_push/`
(gitignored evidence, availability recorded).
