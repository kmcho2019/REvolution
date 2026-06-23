# T68 Source-Verified RTL-Native Extractors

Status: `T0 verification_gate`.

T68 is not a QD/MAP-Elites run. It is a source-verification package for the
next RTL-native descriptor attempt. The purpose is to stop treating the earlier
Yosys-SOG and RTLTimer-style proxy features as equivalent to the original
MasterRTL or RTL-Timer implementations.

Core result: upstream example artifacts can be inspected and partially
verified, but fresh upstream conversion is blocked in this environment because
both repositories emit Yosys scripts that require `read -verific`. The next
live RTL-native method must either use a Verific-capable Yosys flow or record a
small, source-aligned preprocessing adaptation before claiming MasterRTL or
RTL-Timer descriptor evidence.

Key files:

- `methodology.md`: verification protocol and promotion rules.
- `results_report.md`: measured result and lane decision.
- `artifacts_manifest.md`: commands, clone commits, and local output paths.
- `tables/upstream_verification_summary.csv`: concise quantitative checks.
- `figures/rtltimer_sog_slack_alignment.png`: RTLTimer SOG slack alignment
  sanity plot from the shipped TinyRocket example.
