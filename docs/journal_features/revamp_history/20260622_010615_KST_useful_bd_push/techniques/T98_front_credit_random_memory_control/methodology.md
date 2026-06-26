# T98 Methodology

T98 is the same-threshold random-memory control for T97.

The run keeps T97 fixed:

- same three RTLLM smoke problems;
- seed `1001`;
- budget `12x3`;
- `front_guarded_memory` scheduler;
- `qd_memory_classic_fraction=0.85`;
- `qd_memory_refine_fraction=0.10`;
- `qd_memory_rescue_fraction=0.05`;
- `qd_memory_min_cell_credit=0.50`;
- no fill/backfill budget;
- no two-parent fusion.

The only intended method change is:

| Field | T97 | T98 |
| --- | --- | --- |
| Descriptor profile | `sr_pca_3d` | `random_hash_3d` |
| Descriptor file | synthesis-response PCA | random descriptor |

The control answers whether stricter front-credit FG-QDM still looks useful
when the memory cells are random rather than synthesis-response-derived.
