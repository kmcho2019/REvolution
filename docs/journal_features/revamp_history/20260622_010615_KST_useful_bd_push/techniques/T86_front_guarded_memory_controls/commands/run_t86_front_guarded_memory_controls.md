# T86 Command Notes

T86 is not launched yet. Before launch:

1. add or identify a deterministic random descriptor profile that is legal for
   live QD use;
2. run the same three-problem smoke subset used by T85;
3. compare against both classic and T85 warmup-4.

Base command should mirror T85 warmup-4 and change only the descriptor profile
and save path:

```bash
--qd_grid_quantile_warmup_successes 4 \
--qd_descriptor_profile <deterministic_random_memory_profile> \
--save_path exp/useful_bd_push/front_guarded_memory_controls_20260626/fg_qdm_random_memory_12x3/seed_1001
```
