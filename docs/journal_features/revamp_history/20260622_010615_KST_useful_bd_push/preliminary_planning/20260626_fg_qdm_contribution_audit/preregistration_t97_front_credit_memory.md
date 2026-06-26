# T97 Front-Credit FG-QDM Preregistration

Status: proposed continuation; not a promoted method.

## Hypothesis

The first FG-QDM runs may be too permissive: cells can receive memory budget
after passive near-front or local archive insertion, even if memory-lane
offspring have not proved useful. T97 tests whether stricter front-credit
recall reduces wasted memory calls while keeping classic-like hill climbing.

## Method

Use the existing `front_guarded_memory` scheduler. Do not add a new runtime
mode for the first T97 smoke.

Changes from T85:

| Parameter | T85 | T97 |
| --- | ---: | ---: |
| `qd_memory_classic_fraction` | `0.80` | `0.85` |
| `qd_memory_refine_fraction` | `0.15` | `0.10` |
| `qd_memory_rescue_fraction` | `0.05` | `0.05` |
| `qd_memory_min_cell_credit` | `0.20` | `0.50` |
| `qd_memory_front_gap_epsilon` | `0.03` | `0.03` |
| `qd_two_parent_probability` | `0.00` | `0.00` |

The higher `qd_memory_min_cell_credit` makes passive valid-PPA cells
insufficient for sampling. Cells containing global-front members remain
sampleable through the existing guard, and cells need repeated strong credit
to stay active.

## First Descriptor

Use `sr_pca_3d` first because T85 already isolates it as the search-policy
probe. Also run the deterministic random-memory control if the SR run clears
the smoke mechanism gate.

Do not run the RTL-native shape-density version first. T87 already showed zero
valid-PPA memory-lane children, so the descriptor swap is not the immediate
fix.

## Smoke Gate

Run the same three RTLLM problems:

- `Prob045_alu`
- `Prob041_traffic_light`
- `Prob015_multi_pipe_8bit`

Budget: `12x3`, seed `1001`, same model and evaluator settings as T85.

Pass only if:

1. all classic-covered smoke designs remain covered;
2. memory lanes produce at least one valid-PPA child on at least two designs;
3. memory lanes produce at least one global-front or local-front add;
4. mean HV is not clearly worse than T85 SR memory;
5. if the random-memory control is run, SR memory must beat it on either mean
   HV or memory-lane front-add rate without losing coverage.

If this fails, retire exact FG-QDM memory scheduling for now.

## Wider Screen Gate

Only after the smoke passes, run the frozen eight-design `8x5` screen. The
full RTLLM comparison remains blocked unless the frozen screen is near-classic
on mean HV and improves at least one front-material metric.
