# CVDP medium tier — capable-but-hard (isolated-graded)

Authoritative isolated-grade verdict (one candidate per process group). Supersedes the in-run `report_generator` functional column, which under-reports under parallel-eval contention (M12/M14).

Sources: `exp/cvdp_medium_fixed/grade_cvdp_medium.json`

| Task | classic | qd_v2 |
|:---|:--:|:--:|
| cvdp_copilot_bus_arbiter_0001 | ❌ fail | ❌ fail |
| cvdp_copilot_concatenate_0001 | ✅ pass | ✅ pass |
| cvdp_copilot_factorial_0001 | ✅ pass | ✅ pass |
| cvdp_copilot_fifo_async_0001 | ❌ fail | ❌ fail |
| cvdp_copilot_neuromorphic_array_0001 | ❌ fail | ❌ fail |
| cvdp_copilot_scrambler_0024 | ✅ pass | ✅ pass |
| cvdp_copilot_secure_read_write_bus_0001 | ✅ pass | ✅ pass |
| cvdp_copilot_signed_adder_0001 | ✅ pass | ✅ pass |
| cvdp_copilot_single_number_0001 | ✅ pass | ✅ pass |
| cvdp_copilot_sync_lifo_0001 | ✅ pass | ✅ pass |
| **Solved** | **7/10** | **7/10** |
