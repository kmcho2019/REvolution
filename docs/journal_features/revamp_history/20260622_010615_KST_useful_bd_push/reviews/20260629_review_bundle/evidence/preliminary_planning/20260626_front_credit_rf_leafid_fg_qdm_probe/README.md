# Front-Credit RF-Leaf FG-QDM Probe

This package tracks the T100 continuation requested after the FG-QDM proposal.
The scheduler already exists, so this probe changes only the descriptor:
T97 front-credit FG-QDM plus T83 RF leaf-ID structural axes.

## Files

- [../../techniques/T100_front_credit_rf_leafid_fg_qdm_memory/](../../techniques/T100_front_credit_rf_leafid_fg_qdm_memory/):
  method card, command reference, and artifact manifest.
- [preregistration.md](preregistration.md): local run contract and stop/go
  gates.
- [commands/run_t100_front_credit_rf_leafid_fg_qdm.md](commands/run_t100_front_credit_rf_leafid_fg_qdm.md):
  copied command reference for this preliminary-planning package.
- [logs/](logs/): preflight, validation, and result notes after execution.

## Current Read

Completed. T100 is the new FG-QDM smoke representative, but it is not promoted
for an eight-design or full-RTLLM run.

Summary:

- mean HV `0.156553` versus classic `0.190331`;
- mean HV above T97 SR front-credit FG-QDM `0.153384`;
- mean HV above T98 same-threshold random control `0.104805`;
- `front_rescue` produced `4/4` valid-PPA children and `2` global-front adds;
- `memory_refine` produced `2/6` valid-PPA children and `0` global-front adds.

Decision: keep T100 as the category representative, but do not spend beyond
the smoke without a new mechanism improvement.
