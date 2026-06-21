# Near-Identical Motif Suppression

- Problem groups: 29
- Rows: 116

## Aggregate

| corpus | descriptor_family | method | motif_distance_threshold | problem_group_count | valid_ppa_count | retained_count | suppressed_near_motif_count | mean_retained_fraction | retained_pareto_size | baseline_pareto_size | retained_hypervolume | baseline_hypervolume | retained_best_fitness | baseline_best_fitness | hypervolume_gain_fraction | pareto_gain_fraction |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| rtllm_gen20 | lexical_structural_posthoc | classic_revolution | 0.0 | 29 | 2335 | 246 | 2089 | 0.1698024781027515 | 63 | 793 | 3.150668091762145 | 3.1836011030233298 | 0.6834970284641851 | 0.6834970284641851 | -0.010344578417789112 | -0.9205548549810845 |
| rtllm_gen20 | lexical_structural_posthoc | classic_revolution | 0.01 | 29 | 2335 | 203 | 2132 | 0.15312787448082216 | 61 | 793 | 3.138422618925123 | 3.1836011030233298 | 0.6834970284641851 | 0.6834970284641851 | -0.014191000265486376 | -0.9230769230769231 |
| rtllm_gen20 | lexical_structural_posthoc | classic_revolution | 0.025 | 29 | 2335 | 166 | 2169 | 0.13687342775849015 | 53 | 793 | 3.126594409486521 | 3.1836011030233298 | 0.6834970284641851 | 0.6834970284641851 | -0.017906355630632226 | -0.9331651954602774 |
| rtllm_gen20 | lexical_structural_posthoc | classic_revolution | 0.05 | 29 | 2335 | 124 | 2211 | 0.11720199471045889 | 50 | 793 | 2.9509525674382915 | 3.1836011030233298 | 0.6834970284641851 | 0.6834970284641851 | -0.07307716263953482 | -0.9369482976040353 |
