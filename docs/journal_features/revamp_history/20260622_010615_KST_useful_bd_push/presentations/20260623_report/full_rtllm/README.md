# Full RTLLM Milestone Package

Run root: `exp/useful_bd_push/rtllm_milestone_full_20260622_142254_UTC/merged_ref_default_fix_v0`

## Headline

- Claim status: `reviewable`.
- Mean HV delta, all RTLLM: `0.010562`.
- Mean HV-AUC delta, all RTLLM: `0.012397`.
- Hard retention failures: `0` rows.
- Yield warnings: `4` rows.
- Small-n validity labels: `6` rows.

## Aggregate Metrics

| Cohort | Method | Problems | Mean HV | Mean HV-AUC | Valid PPA | Front Points |
| --- | --- | ---: | ---: | ---: | ---: | ---: |
| all_rtllm | Classic | 50 | 0.094435 | 0.080956 | 1056 | 61 |
| all_rtllm | Exact T26 QD | 50 | 0.104997 | 0.093353 | 879 | 69 |
| screen_excluded | Classic | 47 | 0.088690 | 0.075581 | 989 | 52 |
| screen_excluded | Exact T26 QD | 47 | 0.103015 | 0.093051 | 845 | 62 |

## Retention Gate

| Problem | Metric | Classic | Exact T26 QD | Status |
| --- | --- | ---: | ---: | --- |
| Prob001_accu | functionality_count | 42 | 40 | pass |
| Prob001_accu | valid_ppa_count | 42 | 32 | pass |
| Prob002_adder_16bit | functionality_count | 48 | 48 | pass |
| Prob002_adder_16bit | valid_ppa_count | 48 | 48 | pass |
| Prob003_adder_32bit | functionality_count | 44 | 44 | pass |
| Prob003_adder_32bit | valid_ppa_count | 44 | 30 | pass |
| Prob004_adder_8bit | functionality_count | 29 | 28 | pass |
| Prob004_adder_8bit | valid_ppa_count | 29 | 27 | pass |
| Prob005_adder_bcd | functionality_count | 46 | 45 | pass |
| Prob005_adder_bcd | valid_ppa_count | 46 | 45 | pass |
| Prob006_adder_pipe_64bit | functionality_count | 11 | 9 | pass |
| Prob006_adder_pipe_64bit | valid_ppa_count | 0 | 0 | pass |
| Prob007_comparator_3bit | functionality_count | 47 | 46 | pass |
| Prob007_comparator_3bit | valid_ppa_count | 47 | 30 | pass |
| Prob008_comparator_4bit | functionality_count | 44 | 46 | pass |
| Prob008_comparator_4bit | valid_ppa_count | 44 | 46 | pass |
| Prob009_div_16bit | functionality_count | 36 | 22 | pass |
| Prob009_div_16bit | valid_ppa_count | 36 | 19 | pass |
| Prob010_radix2_div | functionality_count | 0 | 12 | pass |
| Prob010_radix2_div | valid_ppa_count | 0 | 4 | pass |
| Prob011_multi_16bit | functionality_count | 21 | 30 | pass |
| Prob011_multi_16bit | valid_ppa_count | 21 | 30 | pass |
| Prob012_multi_8bit | functionality_count | 37 | 41 | pass |
| Prob012_multi_8bit | valid_ppa_count | 37 | 28 | pass |
| Prob013_multi_booth_8bit | functionality_count | 21 | 28 | pass |
| Prob013_multi_booth_8bit | valid_ppa_count | 3 | 6 | small_n |
| Prob014_multi_pipe_4bit | functionality_count | 32 | 28 | pass |
| Prob014_multi_pipe_4bit | valid_ppa_count | 0 | 0 | pass |
| Prob015_multi_pipe_8bit | functionality_count | 15 | 22 | pass |
| Prob015_multi_pipe_8bit | valid_ppa_count | 14 | 10 | pass |
| Prob016_fixed_point_adder | functionality_count | 41 | 36 | pass |
| Prob016_fixed_point_adder | valid_ppa_count | 0 | 0 | pass |
| Prob017_fixed_point_substractor | functionality_count | 45 | 46 | pass |
| Prob017_fixed_point_substractor | valid_ppa_count | 0 | 0 | pass |
| Prob018_float_multi | functionality_count | 15 | 12 | pass |
| Prob018_float_multi | valid_ppa_count | 4 | 6 | small_n |
| Prob019_sub_64bit | functionality_count | 42 | 46 | pass |
| Prob019_sub_64bit | valid_ppa_count | 42 | 46 | pass |
| Prob020_JC_counter | functionality_count | 42 | 48 | pass |
| Prob020_JC_counter | valid_ppa_count | 42 | 32 | pass |
| Prob021_counter_12 | functionality_count | 46 | 48 | pass |
| Prob021_counter_12 | valid_ppa_count | 46 | 39 | pass |
| Prob022_ring_counter | functionality_count | 0 | 0 | pass |
| Prob022_ring_counter | valid_ppa_count | 0 | 0 | pass |
| Prob023_up_down_counter | functionality_count | 36 | 37 | pass |
| Prob023_up_down_counter | valid_ppa_count | 36 | 29 | pass |
| Prob024_fsm | functionality_count | 14 | 21 | pass |
| Prob024_fsm | valid_ppa_count | 12 | 10 | pass |
| Prob025_sequence_detector | functionality_count | 3 | 10 | small_n |
| Prob025_sequence_detector | valid_ppa_count | 3 | 7 | small_n |
| Prob026_asyn_fifo | functionality_count | 0 | 0 | pass |
| Prob026_asyn_fifo | valid_ppa_count | 0 | 0 | pass |
| Prob027_LIFObuffer | functionality_count | 34 | 43 | pass |
| Prob027_LIFObuffer | valid_ppa_count | 34 | 41 | pass |
| Prob028_LFSR | functionality_count | 0 | 0 | pass |
| Prob028_LFSR | valid_ppa_count | 0 | 0 | pass |
| Prob029_barrel_shifter | functionality_count | 0 | 1 | pass |
| Prob029_barrel_shifter | valid_ppa_count | 0 | 1 | pass |
| Prob030_right_shifter | functionality_count | 43 | 48 | pass |
| Prob030_right_shifter | valid_ppa_count | 33 | 30 | pass |
| Prob031_freq_div | functionality_count | 30 | 39 | pass |
| Prob031_freq_div | valid_ppa_count | 24 | 16 | pass |
| Prob032_freq_divbyeven | functionality_count | 0 | 0 | pass |
| Prob032_freq_divbyeven | valid_ppa_count | 0 | 0 | pass |
| Prob033_freq_divbyfrac | functionality_count | 0 | 0 | pass |
| Prob033_freq_divbyfrac | valid_ppa_count | 0 | 0 | pass |
| Prob034_freq_divbyodd | functionality_count | 0 | 0 | pass |
| Prob034_freq_divbyodd | valid_ppa_count | 0 | 0 | pass |
| Prob035_calendar | functionality_count | 45 | 39 | pass |
| Prob035_calendar | valid_ppa_count | 22 | 22 | pass |
| Prob036_edge_detect | functionality_count | 32 | 34 | pass |
| Prob036_edge_detect | valid_ppa_count | 29 | 29 | pass |
| Prob037_parallel2serial | functionality_count | 18 | 10 | pass |
| Prob037_parallel2serial | valid_ppa_count | 17 | 10 | pass |
| Prob038_pulse_detect | functionality_count | 0 | 0 | pass |
| Prob038_pulse_detect | valid_ppa_count | 0 | 0 | pass |
| Prob039_serial2parallel | functionality_count | 0 | 2 | pass |
| Prob039_serial2parallel | valid_ppa_count | 0 | 2 | pass |
| Prob040_synchronizer | functionality_count | 48 | 44 | pass |
| Prob040_synchronizer | valid_ppa_count | 48 | 32 | pass |
| Prob041_traffic_light | functionality_count | 23 | 20 | pass |
| Prob041_traffic_light | valid_ppa_count | 22 | 11 | yield_warning |
| Prob042_width_8to16 | functionality_count | 9 | 6 | small_n |
| Prob042_width_8to16 | valid_ppa_count | 0 | 0 | pass |
| Prob043_RAM | functionality_count | 41 | 30 | pass |
| Prob043_RAM | valid_ppa_count | 41 | 18 | yield_warning |
| Prob044_ROM | functionality_count | 30 | 33 | pass |
| Prob044_ROM | valid_ppa_count | 30 | 14 | yield_warning |
| Prob045_alu | functionality_count | 31 | 18 | pass |
| Prob045_alu | valid_ppa_count | 31 | 13 | yield_warning |
| Prob046_clkgenerator | functionality_count | 1 | 4 | small_n |
| Prob046_clkgenerator | valid_ppa_count | 0 | 0 | pass |
| Prob047_instr_reg | functionality_count | 36 | 37 | pass |
| Prob047_instr_reg | valid_ppa_count | 34 | 28 | pass |
| Prob048_pe | functionality_count | 22 | 21 | pass |
| Prob048_pe | valid_ppa_count | 22 | 21 | pass |
| Prob049_signal_generator | functionality_count | 28 | 33 | pass |
| Prob049_signal_generator | valid_ppa_count | 28 | 23 | pass |
| Prob050_square_wave | functionality_count | 45 | 44 | pass |
| Prob050_square_wave | valid_ppa_count | 45 | 44 | pass |

## Files

- `tables/full_problem_metrics.csv`
- `tables/full_aggregate_metrics.csv`
- `tables/full_comparison_deltas.csv`
- `tables/full_validity_gates.csv`
- `data/full_ppa_candidates.csv`
- `figures/full_hv_delta_distribution.png`
- `figures/full_hv_auc_delta_distribution.png`
- `figures/full_hv_scatter.png`
- `figures/full_win_loss_heatmap.png`
- `figures/full_validity_funnel.png`
- `figures/full_front_counts.png`
- `figures/full_representative_ppa_fronts.png`

## Claim Discipline

This is one-seed paired engineering evidence. A QD claim must preserve
classic-covered designs and report yield warnings instead of hiding
them. Multi-seed replication remains a follow-on milestone.
