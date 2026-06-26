# T100 Artifacts Manifest

## Planned Inputs

| Path | Purpose |
| --- | --- |
| `commands/run_t100_front_credit_rf_leafid_fg_qdm.md` | Frozen preflight, descriptor probe, smoke, and validation commands. |
| `methodology.md` | Method definition and promotion gates. |
| `tables/descriptor_probe_rf_leafid_fg_qdm.json` | Descriptor contract probe output. |

## Planned Run Output

| Path | Purpose |
| --- | --- |
| `exp/useful_bd_push/front_credit_rf_leafid_fg_qdm_20260626/` | Live T100 run root. |
| `analysis/ppa_distribution/` | Candidate PPA distribution report after packaging. |
| `analysis/pareto_analysis/` | HV and PPA-front report after packaging. |
| `tables/` | Mechanism and backend summary tables after packaging. |

Do not place new live artifacts under `/aux`; it remains read-only historical
evidence.
