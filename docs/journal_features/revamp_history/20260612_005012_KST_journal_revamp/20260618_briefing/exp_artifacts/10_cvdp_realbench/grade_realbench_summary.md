# RealBench e203 modules — capability ceiling (isolated-graded)

Authoritative isolated-grade verdict (one candidate per process group). Supersedes the in-run `report_generator` functional column, which under-reports under parallel-eval contention (M12/M14).

Sources: `exp/fast_iter/capability_remap/grade_mismatch_compare.json`, `exp/fast_iter/capability_remap/grade_mismatch_v2.json`

Per arm: `valid/n` functionally-valid candidates; `best` = lowest test-vector mismatch fraction reached by any candidate (1.0 = total failure, 0.0 = correct); `sim` = candidates that reached simulation.

| Module | classic valid/n | qd valid/n | qd_v2 valid/n | classic best | qd best | qd_v2 best | classic sim | qd sim | qd_v2 sim |
|:---|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| e203_exu_alu_csrctrl | 2/16 | 1/16 | 1/16 | 0.000 | 0.000 | 0.000 | 4 | 7 | 2 |
| e203_exu_alu_rglr | 2/16 | 1/16 | 2/16 | 0.000 | 0.000 | 0.000 | 6 | 11 | 7 |
| e203_exu_branchslv | 0/16 | 0/16 | 0/16 | 0.250 | 0.250 | 0.288 | 13 | 5 | 12 |
| e203_exu_decode | 0/16 | 0/16 | 0/16 | 1.000 | 1.000 | 1.000 | 5 | 7 | 4 |
| e203_exu_disp | 0/16 | 0/16 | 0/16 | 0.206 | 0.206 | 0.206 | 6 | 9 | 6 |
| e203_exu_longpwbck | 0/16 | 0/16 | 0/16 | 0.855 | 0.880 | 0.662 | 6 | 3 | 1 |
| e203_exu_wbck | 0/16 | 0/16 | 0/16 | 0.326 | 0.413 | 0.413 | 8 | 10 | 12 |
| **Total valid** | **4/112** | **2/112** | **3/112** | — | — | — | — | — | — |
