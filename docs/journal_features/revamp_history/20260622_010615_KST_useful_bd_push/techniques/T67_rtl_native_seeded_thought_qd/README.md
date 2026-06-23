# T67 RTL-Native Seeded Thought QD

Status: pre-registered; seed `1001` hard/tuning run pending.

T67 is the next RTL-native coupling attempt after T66. It keeps the
reference-complete hard/tuning surface and the `fused_rtl_state_pipeline_2d`
descriptor, but moves the coupling point from parent-pressure tweaks to
source-preserving thought realization.

The method uses `thought_only` with `code_samples_per_thought=3` and
`qd_thought_code_seeded=true`. Once a thought has a successful parent, two of
its three code samples should refine the parent RTL and one should remain a
whole-regeneration leap. No bounded repair calls are added in the first run, so
T67 stays candidate-budget matched to the T50 thought-only control and avoids
hidden extra evaluation budget.

Primary comparators:

- T47 classic hard/tuning seed `1001`;
- T50 candidate-matched thought-only front control;
- T51 code-thought front-slot QD;
- T63 fused RTL-native state/pipeline live screen;
- T66 RTL-native guarded-parent QD.

Do not promote T67 without a completed package, reference-complete
`ppa_completeness.csv`, direct raw PPA figures, and Phase 03.1 viewer artifacts
if archive export succeeds.
