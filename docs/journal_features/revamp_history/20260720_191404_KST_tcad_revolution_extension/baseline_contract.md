# Classic Baseline And Evidence Contract

Status: `FROZEN`, revision 3, 2026-07-20. Independent methodology review closed
with `PASS`. Revision 3 clarifies metric names, representative-set scope,
manifest roles, and discovery-budget scope after pre-implementation review; it
does not change a treatment gate. No treatment result was generated before this
file and `shared/program_manifest.yaml` froze every pre-Wave-1 evidence rule.

## Baseline Identity

The comparator is classic REvolution with the direct-code representation,
dual Fail/Success pools, scalar Success fitness, UCB strategy selection, and
the classic EoH operator set. QD, Pareto, repair, memory, and descriptor modes
are disabled.

| Item | Frozen value |
| --- | --- |
| Classic engine | `src/revolution/algorithm.py`, SHA-256 `78ebc901be4197f7d10a27097328a5f54a1fa60aeb72a999ad6dc3b661236655` |
| Engine git blob | `31e64763a0c7567b206ca0f98fce92c5936b57fc` |
| Last engine change before runs | `bafb47d49bd81cd16c0fe3fb76b6da792331f695`, 2026-07-01 03:10 UTC |
| Backend adapter | `src/revolution/backends/revolution_backend.py`, SHA-256 `8eb619b85befc141188fbd6719967a56c9868d8fd4afac8afc7693dc17c0d4da` |
| Default config | `data/configs/evolution_default.yaml`, SHA-256 `cd44c8de823b9843339718cd8116d325f35a11188b38103553dcc2cbc8c0a34b` |
| Model | `openai/gpt-oss-120b`, vLLM `20.0.0.103:8000`, context 131072 |
| Search budget | population 8, five generations, 48 candidates per problem |
| Sampling | temperature 1.0, top-p 1.0, whole-output generation |
| Operators | `eoh_strategies`, classic success set; never `single_thought_operators` |
| Evaluation | `strict_ablation`; simulation, synthesis, post-synthesis check, valid PPA |

The five archived configs differ only in `seed` and `save_path`. Their hashes
are in `shared/program_manifest.yaml`. The engine's last change predates seed
1001's start at 04:14 UTC on 2026-07-01, and its blob remains current.

## Canonical Reproduction

Raw root:
`exp/useful_bd_push/pcn_v3_experiments_20260701/live/rtllm_full_5seed/classic_revolution_8x5`.
Every seed has 50/50 summaries, 50/50 generation logs, one config, and one
scheduler telemetry file. There are no missing run units.

The reporting chain was rerun under
`exp/tcad_revolution_extension/baseline_20260720/historical_classic_5seed` with:

1. `scripts/report_ppa_distribution.py` on five labeled seed roots;
2. `scripts/report_hv_auc.py` with five generations;
3. `scripts/report_pareto_analysis.py` on the locked RTLLM-46 manifest.

`scripts/report_hv_auc.py` emits only problem-seed units with valid PPA. All headline
means therefore join its output to the locked 46-task manifest and assign zero
HV and zero HV-AUC to absent units. Averaging emitted rows alone is invalid.

| Seed | Mean HV46 | Mean HV-AUC46 | Valid PPA | RTL-sim functional 46 | RTL-sim functional 50 | Valid samples | Calls | Tokens | Synth attempts | Wall s |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 1001 | 0.111401 | 0.090551 | 33/46 | 38/46 | 42/50 | 1002 | 4801 | 14,933,967 | 1271 | 4732.65 |
| 1002 | 0.097557 | 0.081183 | 33/46 | 38/46 | 42/50 | 974 | 4802 | 14,816,625 | 1240 | 4674.88 |
| 1003 | 0.102093 | 0.087210 | 33/46 | 38/46 | 42/50 | 950 | 4800 | 14,900,655 | 1207 | 4658.49 |
| 1004 | 0.103555 | 0.089027 | 32/46 | 37/46 | 41/50 | 974 | 4800 | 14,901,032 | 1240 | 4714.43 |
| 1005 | 0.104404 | 0.086940 | 33/46 | 37/46 | 41/50 | 982 | 4800 | 14,855,773 | 1275 | 4622.40 |
| Mean | **0.103802** | **0.086982** | **164/230** | **188/230** | **208/250** | **976.4** | **4800.6** | **14,881,610** | **1246.6** | **4680.57** |

Across-seed sample standard deviations are `0.005002` for mean HV46 and
`0.003557` for mean HV-AUC46. Valid-PPA and functional coverage vary by at most
one design per seed. A synthesis attempt is one candidate Yosys pipeline start;
Yosys and OpenROAD log lines are not double-counted.

## Synthesis Determinism

Three archived classic candidates were copied to new directories and replayed
twice through Yosys and OpenROAD with gate-level recheck disabled so this audit
measures synthesis/PPA repeatability only. The original and both replays agree
exactly on area, power, and effective clock period:

| Problem | Type | Area | Power | Period |
| --- | --- | ---: | ---: | ---: |
| `Prob003_adder_32bit` | combinational datapath | 137 | 0.0000797 | 0.0 |
| `Prob024_fsm` | control | 36 | 0.00373 | 0.18 |
| `Prob036_edge_detect` | sequential | 19 | 0.00189 | 0.17 |

Replay artifacts are under
`exp/tcad_revolution_extension/baseline_20260720/synthesis_determinism`.
This is a sampled determinism result, not a claim that the entire flow is
noise-free under arbitrary host load.

## Benchmark Roles

- **Smoke:** `Prob002_adder_16bit`, `Prob025_sequence_detector`, and
  `Prob043_RAM`; seed 42; execution and telemetry only.
- **Representative development:** eight RTLLM tasks, seeds 1001 and 1002.
  From classic-only evidence, retain reference-complete tasks with valid PPA in
  all five seeds and positive HV in at least three. Within combinational and
  sequential strata, rank by descending sample standard deviation of final HV
  and take the top four. Circuit type comes from the frozen reference-PPA
  report. The complete eligible ranking and selected flags are frozen in
  `shared/representative_selection.csv`.
  The result is `Prob002_adder_16bit`, `Prob024_fsm`, `Prob041_traffic_light`,
  `Prob045_alu`, `Prob025_sequence_detector`, `Prob027_LIFObuffer`,
  `Prob036_edge_detect`, and `Prob043_RAM`.
  Classic has valid PPA and an RTL-simulation pass on all 16 selected
  problem-seed units. This stage can validate activation, telemetry, and HV
  regression, but it cannot demonstrate a coverage increase.
- **Full-suite development:** all 50 RTLLM tasks at seeds 1001 and 1002.
  Final HV and valid-PPA headlines use the immutable reference-complete 46;
  RTL-simulation functionality is reported on both 46 and 50. Valid-PPA
  coverage is verification-complete through synthesis and the configured
  post-synthesis check.
- **Confirmation:** the same frozen RTLLM manifests at matched seeds
  61001-61005, which have no prior repository evidence. Fresh classic is run
  once and may be shared by at most two frozen finalists.
- **Holdout:** the 30 medium CVDP tasks in `shared/cvdp_holdout_v1.yaml`, seed
  62001, run once after method freeze. It is an RTL-simulation functionality
  generalization surface only and cannot support reference-normalized PPA
  generalization.

The holdout eligibility argument and known contamination are in
`shared/holdout_eligibility_audit.md`. No role is relabeled after observation.

## Statistical Rules

- Unit: problem-seed pair. Cluster: problem, retaining all seed replicates.
- Gate intervals: 10,000-replicate percentile problem-cluster bootstrap, seed
  20260720, 95% confidence.
- Missing treatment where classic has a unit: functionality, valid-PPA, HV, and
  HV-AUC are zero. A higher-is-better normalized PPA score uses the minimum
  locked classic score. Raw lower-is-better area, power, and period are never
  imputed; report their valid-pair complete-case summaries and missing counts as
  secondary evidence.
- Missing classic infrastructure output is rerun before comparison. A genuine
  classic method failure stays visible and is excluded only from paired PPA;
  treatment-only successes are counted separately.
- W/L/T: absolute HV delta at most `1e-9` is a tie. Coverage ties are exact.
  Report an exact two-sided sign test when at least ten pairs are non-tied.
- Report point estimate, cluster interval, W/L/T, sign test, per-seed means,
  leave-one-seed-out sensitivity, and penalized plus complete-case results.

Baseline-only pseudo-pairs 1001->1002 and 1003->1004 estimate problem and seed
delta standard deviations of `0.044447` and `0.023024`. Using the simulation in
`scripts/report_mde_analysis.py` (300 simulations, 400 inner bootstraps), the
approximate 80%-power MDE for mean final HV is `0.02` at both 46x2 and 46x5.
This is a detectability warning, not a minimum accepted uplift: smaller gains
remain eligible but must be described as observed rather than statistically
resolved when their interval crosses zero.

## Frozen Margins And Decisions

- Algorithmic `PAPER_CANDIDATE`: matched mean final HV46 must be strictly above
  classic; final-HV uncertainty and sensitivity must be reported; HV-AUC cannot
  rescue a final-HV loss.
- Supporting-surface noninferiority: final HV46 may trail by at most `0.0050`
  and HV-AUC46 by at most `0.0036`, one classic across-seed standard deviation.
- Coverage noninferiority: valid-PPA and RTL-simulation functionality may each
  trail by at most one problem per seed: two units in development or five in
  confirmation.
- `VIABLE`: a preregistered benefit occurs in both full-suite development seeds
  and every other primary surface remains within the margins above.
- Catastrophic full-suite stop: mean HV46 below 90% of matched classic, either
  coverage deficit at least four of 92 units, invalid mechanism telemetry, or
  candidate-evaluation budget inequality.
- This outcome-based catastrophic stop applies only to the two-seed development
  probe. Confirmation has no outcome-based early stop; infrastructure failures
  follow the rerun/blocker rules without inspecting partial outcomes.
- Calls, tokens, and wall time are reported. A persistent difference over 10%
  is budget-asymmetric and cannot be called an equal-budget headline result.

## Resource Ceilings

One 50-task arm costs 2,400 candidate evaluations, about 4,801 calls,
14.88 million tokens, 1,247 synthesis attempts, and 1.30 endpoint-arm hours.
Ceilings are maxima, not spending targets:

| Scope | Tokens | Candidates | Calls | Synthesis | Endpoint-arm h |
| --- | ---: | ---: | ---: | ---: | ---: |
| One candidate discovery loop, including at most one repeated full probe | 66M | 10,512 | 21,000 | 6,000 | 6 |
| One three-candidate wave | 200M | 32,000 | 64,000 | 18,000 | 18 |
| Entire two-wave program, confirmation, and holdout | 650M | 105,000 | 210,000 | 60,000 | 60 |

The per-candidate ceiling covers smoke, representative, full-suite development,
and one allowed repeated full probe. It excludes confirmation and holdout,
which remain inside the program ceiling. The program also stops after 21
elapsed days. Shared-server accelerator utilization is not exposed;
endpoint-arm wall time is the frozen auditable proxy. Per problem, cap at 48
candidates, 100 calls, 650,000 total tokens, 48 synthesis attempts, and 2,400
seconds. Revisions share these ceilings and never authorize a parameter scan.

## Known Limits

- Historical development seeds are prior-exposed and cannot confirm a new
  method; that is why confirmation uses 61001-61005 with fresh classic.
- The CVDP holdout supports functionality only. A positive program still cannot
  claim cross-benchmark PPA generalization.
- The MDE estimate is based on classic seed pseudo-pairs, not treatment variance.
- Historical calls include feedback calls and initialization is not hidden from
  resource reporting. Candidate-evaluation equality alone is not called full
  resource equality.
