# H5 Representative Probe Summary

Validated problem-seed units: `16`; arm units: `32`.

| Metric | Mean delta | 95% problem-cluster CI | W/L/T |
| --- | ---: | --- | --- |
| unconditional_valid_ppa_repair_rate | 0.005208333333333334 | [-0.005208333333333332, 0.015625] | 7/2/7 |
| final_hypervolume | -0.0014420411125003994 | [-0.017776846390777364, 0.009446244477731819] | 6/4/6 |
| hypervolume_auc | 0.007649699075835002 | [-0.0113391842601525, 0.025544514847935004] | 10/2/4 |
| rtl_simulation_functionality | 0.0 | [0.0, 0.0] | 0/0/16 |
| verification_complete_valid_ppa | 0.0 | [0.0, 0.0] | 0/0/16 |
| valid_ppa_sample_yield | 0.029947916666666685 | [-0.016927083333333308, 0.07291666666666669] | 9/6/1 |
| best_normalized_ppa | -0.01151590330197024 | [-0.032270107886995435, 0.005513496343884178] | 4/7/5 |

Representative performance is diagnostic and carries no promotion or retirement gate.

Protocol deviation: `llm_calls_to_first_improvement` had no frozen definition of improvement or call attribution. It is not reported or used for a gate; defining it after outcomes would be post-hoc.

## Per-Seed Direction

| Seed | Metric | Classic | H5 | Delta |
| ---: | --- | ---: | ---: | ---: |
| 1001 | unconditional_valid_ppa_repair_rate | 0.04166666666666667 | 0.04947916666666667 | 0.0078125 |
| 1002 | unconditional_valid_ppa_repair_rate | 0.0390625 | 0.041666666666666664 | 0.0026041666666666644 |
| 1001 | final_hypervolume | 0.17588500271528526 | 0.167756077636585 | -0.00812892507870025 |
| 1002 | final_hypervolume | 0.19170740091620597 | 0.19695224376990542 | 0.005244842853699444 |
| 1001 | hypervolume_auc | 0.15277688057963124 | 0.15006858659814626 | -0.002708293981484977 |
| 1002 | hypervolume_auc | 0.13784940902133 | 0.155857101154485 | 0.018007692133155007 |
| 1001 | rtl_simulation_functionality | 1.0 | 1.0 | 0.0 |
| 1002 | rtl_simulation_functionality | 1.0 | 1.0 | 0.0 |
| 1001 | verification_complete_valid_ppa | 1.0 | 1.0 | 0.0 |
| 1002 | verification_complete_valid_ppa | 1.0 | 1.0 | 0.0 |
| 1001 | valid_ppa_sample_yield | 0.5885416666666666 | 0.640625 | 0.05208333333333337 |
| 1002 | valid_ppa_sample_yield | 0.5833333333333333 | 0.5911458333333334 | 0.007812500000000111 |
| 1001 | best_normalized_ppa | 0.33300910578166165 | 0.3391743978249487 | 0.0061652920432870295 |
| 1002 | best_normalized_ppa | 0.34016472227120864 | 0.3109676236239811 | -0.029197098647227526 |

## Resources

| Seed | Arm | Candidates | Calls | Tokens | Synthesis | Summed problem runtime (s) | Arm wall (s) | Missing |
| ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 1001 | classic | 384 | 768 | 2541425 | 231 | 6527.9252116680145 | None | 0 |
| 1001 | treatment | 384 | 768 | 2512199 | 248 | 6309.565329790115 | None | 0 |
| 1002 | classic | 384 | 768 | 2491536 | 228 | 6286.134085655212 | None | 0 |
| 1002 | treatment | 384 | 769 | 2503833 | 232 | 6389.534421920776 | None | 0 |
