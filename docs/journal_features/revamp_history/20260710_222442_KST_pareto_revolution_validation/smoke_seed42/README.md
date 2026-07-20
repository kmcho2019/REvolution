# Seed-42 Technical Smoke

Status: technical execution PASS on 2026-07-13. No performance inference or
promotion decision is permitted from this three-problem run.

## Frozen Pair

| Field | Classic | Pareto |
| --- | ---: | ---: |
| Search mode | `revolution` | `revolution_pareto` |
| Problems | 3 | 3 |
| Generation rows | 18 | 18 |
| Evaluated candidates | 144 | 144 |
| LLM calls | 288 | 288 |
| Prompt tokens | 508604 | 505900 |
| Completion tokens | 437614 | 432312 |
| Total tokens | 946218 | 938212 |
| Wall time (s) | 682.73 | 648.29 |
| Functional any-pass | 3/3 | 3/3 |
| Valid-PPA coverage | 2/3 | 2/3 |
| Valid-PPA samples | 48 | 47 |
| Mean HV over fixed 3-task smoke | 0.229532 | 0.231560 |

Pareto total-token skew versus classic is `-0.8461%`, inside the registered
`+/-10%` auxiliary budget boundary. The two saved runtime configs differ only
in `save_path` and `search_mode`.

## Objective Paths

| Problem | Frozen path | Live outcome |
| --- | --- | --- |
| `Prob003_adder_32bit` | normalized, 2 axes | exercised with valid PPA in both arms |
| `Prob025_sequence_detector` | normalized, 3 axes | exercised with valid PPA in both arms |
| `Prob006_adder_pipe_64bit` | negative raw, 3 axes | runtime contract asserted; no valid post-synthesis PPA in either arm |

The no-reference task had functional candidates but zero synthesis/PPA passes.
Consequently, the live run proved its runtime mapping and 3-axis assertion but
did not invoke raw-objective arithmetic on a successful candidate. The exact
raw branch remains covered by the frozen unit test. This limitation does not
authorize a task substitution or smoke rerun.

## Operator Audit

Both arms contain only `initial`, `M-F`, `M-S`, `M-E`, `M-R`, `M-I`, and
`C-F`. Counts are:

| Arm | initial | M-F | M-S | M-E | M-R | M-I | C-F |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Classic | 24 | 15 | 24 | 24 | 21 | 26 | 10 |
| Pareto | 24 | 12 | 21 | 27 | 23 | 29 | 8 |

There are zero `single_thought_operator`, `M-T`, `C-D`, descriptor, or archive
events.

## Technical Decision

The smoke passes its role as an execution/integration check:

- both arms completed the exact `8 x 5` budget on all frozen tasks;
- calls match exactly and token use is symmetric;
- Pareto metadata records descriptor-free post-hoc-front posture and the exact
  objective source/circuit type for each task;
- generated strategies satisfy the EoH-only contract;
- normalized 2-axis and 3-axis search paths produced valid PPA;
- the raw path limitation is disclosed above and cannot support a claim.

The smoke metrics are descriptive only. Full RTLLM seed 1001 remains the first
performance gate.

## Raw Artifacts

- Classic root:
  `exp/pareto_revolution_validation/smoke/seed_42/classic/`
- Pareto root:
  `exp/pareto_revolution_validation/smoke/seed_42/pareto/`
- Package:
  `exp/pareto_revolution_validation/packages/smoke_seed_42/`
- Backend report SHA-256:
  `2f129465443c8ec8b786051ccd6c40040f59adbbde99b90881d74868710faeee`
- Pareto summary SHA-256:
  `a09974001c7e1b12906a64b67865fefc6830b07614207f1e2a95ceb2d3323791`
- Classic runtime config SHA-256:
  `73ab72607b13de0c83fa53b32a6fe3daef44c2b36dbb76fcefa200ccfedcccf2`
- Pareto runtime config SHA-256:
  `a38962923ac09c2eb0725e226032020a652520762edb3a0e4a88294f2cd93efc`

Tracked table copies are `aggregate_backend_metrics.csv` and
`backend_problem_metrics.csv` beside this file.
