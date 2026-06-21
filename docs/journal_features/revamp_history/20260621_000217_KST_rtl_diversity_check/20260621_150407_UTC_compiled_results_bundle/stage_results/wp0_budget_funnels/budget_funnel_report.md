# RTL Diversity Budget/Funnel Curves

- Candidate rows: 203944
- Problem groups: 1069
- Curve rows: 21380
- Aggregate rows: 140
- Checkpoints: [0.25, 0.5, 0.75, 1.0]
- Funnels: ['generated', 'functional', 'synthesis_valid', 'valid_ppa', 'pareto_front']

## Full-Budget Valid-PPA Aggregate

| corpus | descriptor_family | method | budget_fraction | funnel | problem_group_count | total_candidate_count | mean_candidate_count | mean_style_clusters | mean_canonical_netlists | mean_motif_signatures | mean_pareto_members | mean_best_fitness |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| aspdac2026_release | lexical_structural_posthoc | classic_revolution | 1.0 | valid_ppa | 824 | 90058 | 109.29368932038835 | 2.200242718446602 | 0.0 | 0.0 | 50.49635922330097 | 0.20688284843056837 |
| auto_bd_standard_results | classic_revolution | classic_revolution | 1.0 | valid_ppa | 39 | 2205 | 56.53846153846154 | 1.0 | 24.897435897435898 | 18.41025641025641 | 56.53846153846154 | 0.27755805182738824 |
| auto_bd_standard_results | landing_smooth_qd_manual_bd | landing_smooth_qd_manual_bd | 1.0 | valid_ppa | 39 | 2391 | 61.30769230769231 | 1.0 | 26.128205128205128 | 19.333333333333332 | 61.30769230769231 | 0.28865099102555203 |
| auto_bd_standard_results | random_descriptor_qd | random_descriptor_qd | 1.0 | valid_ppa | 39 | 1945 | 49.87179487179487 | 1.0 | 22.53846153846154 | 15.153846153846153 | 49.87179487179487 | 0.2763996981119333 |
| auto_bd_standard_results | sr_random_relu_pca_qd | sr_random_relu_pca_qd | 1.0 | valid_ppa | 39 | 1906 | 48.87179487179487 | 1.0 | 23.076923076923077 | 16.743589743589745 | 48.87179487179487 | 0.2690982818282514 |
| auto_bd_standard_results | synthesis_trajectory_nod | synthesis_trajectory_nod | 1.0 | valid_ppa | 39 | 1896 | 48.61538461538461 | 1.0 | 21.846153846153847 | 15.487179487179487 | 48.61538461538461 | 0.28315714947583676 |
| rtllm_gen20 | lexical_structural_posthoc | classic_revolution | 1.0 | valid_ppa | 50 | 2335 | 46.7 | 1.06 | 8.1 | 5.02 | 15.86 | 0.21202315074093167 |
