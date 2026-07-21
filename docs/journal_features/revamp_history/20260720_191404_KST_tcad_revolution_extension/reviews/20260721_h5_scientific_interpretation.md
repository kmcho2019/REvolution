# H5 Scientific Interpretation Review

- Date: 2026-07-21
- Mode: read-only independent scientific reviewer
- Session: `019f82b7-ba1c-7711-bef3-94155870f76e`
- Initial verdict: reporter-level `VIABLE`
- Corrected verdict after contract arbitration: `FAIL / RETIRED`

## Scientific Findings

1. H5 increases direct valid-PPA repairs from 73 to 81, or eight events over
   4,800 H5 candidates. The unresolved 14/12/74 W/L/T distribution does not
   establish a broad repair-rate improvement.
2. The net gain is syntax-oriented: `format -> valid_ppa` rises from 28 to 38,
   while later verification-stage transitions supply no net gain. This is not
   evidence of a general hardware-aware repair mechanism.
3. H5's 81 repairs occur in 24/100 problem-seed units, versus classic's 73 in
   27/100. It repeats more repairs in fewer cases and recovers fewer initially
   uncovered designs, consistent with the lower pooled coverage.
4. `Prob024_fsm` supplies seven of the net eight repair events. Removing either
   `Prob024_fsm` or `Prob025_sequence_detector` reverses seed-1002 repair
   direction, although this was not a frozen gate.
5. `Prob036_edge_detect` supplies 63.97% of final-HV uplift and 114.13% of
   HV-AUC uplift despite zero failed-parent requests in both arms and seeds.
   Repair-count deltas have near-zero descriptive correlation with HV/AUC.
6. H5 begins with more successful initial candidates in both seeds and positive
   generation-zero HV differences, so favorable stochastic initialization is
   another plausible source of downstream PPA direction.
7. H5 is a clean, natural conference-component correction, but a weak standalone
   TCAD extension. The existing M-F prompt is generic Verilog correction and
   the observed effect is syntax-stage rather than a new CAD principle.

## Contract Arbitration

The initial review followed the generated reporter label. On explicit
reassessment, the reviewer agreed that the accepted claims contract and frozen
baseline/program manifests govern. Seed 1001's two-design valid-PPA deficit
exceeds the one-design per-seed margin. The later experiment manifest has no
supersession authority, and the preregistration review missed the translation
error. Cumulative discovery resource ceilings were also exceeded.

## Allowed Narrative

Under the frozen two-seed RTLLM development protocol, M-F-only failed-pool
routing produced five and three additional direct fail-origin valid-PPA
repairs. Mean final HV and HV-AUC were higher but statistically unresolved.
Aggregate valid-PPA and RTL-functionality coverage each ended one unit below
classic, and seed 1001 violated valid-PPA coverage noninferiority.

Do not claim general reliability improvement, coverage preservation, causal
PPA improvement, hardware-aware repair, viability, or paper candidacy.
