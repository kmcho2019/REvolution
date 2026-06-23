# T63 Fused RTL-Native Live Screen Results

Status: pre-registered; no live result yet.

## Current Evidence

The runtime hook and descriptor profile are implemented. The committed profile
probe at `tables/descriptor_probe_fused_rtl_state_pipeline_2d.json` shows:

- axes: `state_control_ratio`, `control_pipeline_ratio`;
- `requires_graph_metrics=true`;
- `requires_rtl_metrics=true`;
- `requires_ppa=false`.

T63 is not promoted, not screened, and not included in any headline comparison
until the live run is executed and packaged.

## Decision

Run the primary `fused_rtl_state_pipeline_2d` screen before considering
`fused_rtl_operator_timing_2d`. The result must be compared against classic and
T51 on the same hard/tuning surface and must include reference-complete PPA
claims only.
