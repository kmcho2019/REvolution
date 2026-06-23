# T62 Fused RTL-Native BD Methodology

## Question

Can a fused RTL-native descriptor recover better PPA-front archive evidence
than either flattened Yosys-SOG structure or RTL timing-risk morphology alone?

This is a retrospective proxy audit. It does not run a live QD search and it
does not use final PPA, reference PPA, fitness, hypervolume, Pareto rank, or
test outcomes as descriptor inputs.

## Sources

- T15 Yosys-SOG structural features:
  `../T15_masterrtl_sog_bd/tables/sog_features.csv`.
- T61 problem-local RTL timing-risk features:
  `../T61_rtl_timer_problem_local_bd/tables/rtl_timer_features.csv`.
- Full RTLLM PPA completeness table copied from T15:
  `tables/ppa_completeness.csv`.

The join key is `(method, problem, candidate_id)`. The package asserts that
method label, generation, and Pareto-front label match across the two source
tables before producing fused features.

## Descriptor Profiles

Every profile assigns problem-local 4x4 quantile cells. Problem-local cells are
used because RTL implementation families differ strongly by benchmark.

| Profile | Axis 1 | Axis 2 | Intended Meaning |
| --- | --- | --- | --- |
| `operator_timing` | `operator_mix_score` | `timing_risk_score` | Arithmetic/operator mix versus likely timing pressure. |
| `state_pipeline` | `state_control_ratio` | `control_pipeline_ratio` | Control/state structure versus pipeline and gating morphology. |
| `complexity_entropy` | `sog_complexity_score` | `timing_risk_entropy` | Structural complexity versus spread of timing-risk sources. |

These descriptors are RTL-native proxies. They are meant to define archive
families, not to predict final PPA directly.

## Metrics

The audit reports:

- occupied descriptor cells per method and profile;
- Pareto-front descriptor cells per method and profile;
- per-problem exact-T26-minus-classic deltas;
- mean problem-balanced front-cell and occupied-cell deltas;
- the copied `ppa_completeness.csv` so headline readers can see which RTLLM
  problems are reference-complete, candidate-missing, or diagnostic-only.

## Promotion Bar

T62 can only justify a live follow-up if it improves front/archive evidence
without hiding the reference-PPA issue. It cannot promote QD usefulness by
itself because it is retrospective and does not evaluate an in-loop archive.
