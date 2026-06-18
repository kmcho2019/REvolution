# Auto-BD Benchmark Task Catalog

Generated from locked subset configs before Auto-BD method comparison.

## Subset Lock

| Role | Config | SHA-256 | Problems |
| --- | --- | --- | ---: |
| development | `data/configs/fast_iteration_subset_v3.yaml` | `dcdde71648a6f289d66f95934c1a6bf731a31c05f666318b5cddfebaa74bbdd5` | 6 |
| main_screening | `data/configs/hard_iteration_subset.yaml` | `1c5534052ed27ad3bef307b57753f493508c84f5f44b619dd81422474b8be902` | 13 |
| heldout_validation | `data/configs/holdout_reference_subset.yaml` | `4c3cab68f5cb58a7e85c0c17204cb57a72f462138dbb3e4f271fe97620f69812` | 10 |
| heldout_pool | `data/configs/holdout_reference_subset.yaml` | `4c3cab68f5cb58a7e85c0c17204cb57a72f462138dbb3e4f271fe97620f69812` | 20 |

## Included Problems

| Split | Benchmark | Problem | Type | Family | Gates | One-shot func |
| --- | --- | --- | --- | --- | ---: | ---: |
| main_screening | RTLLM | Prob004_adder_8bit | combinational | arithmetic_datapath | 26 | 0.10 |
| heldout_validation | RTLLM | Prob009_div_16bit | combinational | arithmetic_datapath | 4325 | 0.90 |
| development | RTLLM | Prob011_multi_16bit | sequential | arithmetic_datapath | 532 | 1.00 |
| heldout_validation | RTLLM | Prob012_multi_8bit | combinational | arithmetic_datapath | 384 | 1.00 |
| heldout_validation | RTLLM | Prob014_multi_pipe_4bit | sequential | arithmetic_datapath | 77 | 0.80 |
| main_screening | RTLLM | Prob015_multi_pipe_8bit | sequential | arithmetic_datapath | 414 | 0.40 |
| development | RTLLM | Prob019_sub_64bit | combinational | arithmetic_datapath | 412 | 1.00 |
| main_screening | RTLLM | Prob024_fsm | combinational | fsm | 22 | 0.10 |
| heldout_validation | RTLLM | Prob026_asyn_fifo | combinational | stateful_datapath | 464 | 0.00 |
| main_screening | RTLLM | Prob037_parallel2serial | sequential | stateful_datapath | 14 | 0.60 |
| heldout_validation | RTLLM | Prob039_serial2parallel | sequential | stateful_datapath | 55 | 0.00 |
| main_screening | RTLLM | Prob041_traffic_light | combinational | control | 74 | 0.20 |
| heldout_validation | RTLLM | Prob043_RAM | sequential | stateful_datapath | 330 | 1.00 |
| main_screening | RTLLM | Prob045_alu | combinational | mixed_or_unknown | 1623 | 0.40 |
| development | RTLLM | Prob048_pe | sequential | mixed_or_unknown | 1730 | 1.00 |
| main_screening | RTLLM | Prob049_signal_generator | sequential | mixed_or_unknown | 44 | 0.70 |
| heldout_validation | VerilogEval-Spec-to-RTL | Prob018_mux256to1 | combinational | arithmetic_datapath | 378 | 1.00 |
| development | VerilogEval-Spec-to-RTL | Prob021_mux256to1v | combinational | arithmetic_datapath | 1574 | 0.80 |
| heldout_validation | VerilogEval-Spec-to-RTL | Prob023_vector100r | combinational | mixed_or_unknown | 100 | 1.00 |
| development | VerilogEval-Spec-to-RTL | Prob030_popcount255 | combinational | arithmetic_datapath | 633 | 1.00 |
| heldout_validation | VerilogEval-Spec-to-RTL | Prob068_countbcd | sequential | mixed_or_unknown | 94 | 0.40 |
| main_screening | VerilogEval-Spec-to-RTL | Prob098_circuit7 | combinational | mixed_or_unknown | 2 | 0.60 |
| development | VerilogEval-Spec-to-RTL | Prob105_rotate100 | sequential | mixed_or_unknown | 561 | 1.00 |
| main_screening | VerilogEval-Spec-to-RTL | Prob116_m2014_q3 | combinational | mixed_or_unknown | 4 | 0.40 |
| heldout_validation | VerilogEval-Spec-to-RTL | Prob124_rule110 | sequential | control | 3178 | 0.50 |
| main_screening | VerilogEval-Spec-to-RTL | Prob135_m2014_q6b | combinational | mixed_or_unknown | 4 | 0.60 |
| main_screening | VerilogEval-Spec-to-RTL | Prob150_review2015_fsmonehot | combinational | fsm | 14 | 0.10 |
| main_screening | VerilogEval-Spec-to-RTL | Prob151_review2015_fsm | sequential | fsm | 40 | 0.10 |
| main_screening | VerilogEval-Spec-to-RTL | Prob153_gshare | sequential | control | 1460 | 0.10 |

Full candidate-pool metadata is in `auto_bd_task_catalog.json`.
