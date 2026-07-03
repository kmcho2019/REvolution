# T85 Methodology

FG-QDM tests whether QD is more useful as memory than as the main optimizer.
The archive does not receive budget to fill empty descriptor cells. Every
valid-PPA candidate is passively considered for archive insertion, while most
new LLM calls still refine a classic-style primary success pool.

## Algorithm

Each problem maintains:

- `PrimaryPool`: classic-style survivor pool, selected by score plus existing
  PPA metric champions.
- `QDMemoryArchive`: descriptor-indexed archive with `elite_pareto_slot`
  retention.
- `GlobalParetoArchive`: nondominated PPA front for retention and diagnostics.

The descriptor axes are descriptor-only. PPA metrics are used for selection,
retention, and reporting, not as descriptor inputs beyond the frozen SR PCA
profile already used by T26.

## Parent Lanes

| Lane | Fraction | Parent source | Prompt intent |
| --- | ---: | --- | --- |
| `classic` | `0.80` | Primary success pool and fail pool | Normal PPA-first refinement |
| `memory_refine` | `0.15` | Credited memory cell champion or slot | Improve a remembered implementation family |
| `front_rescue` | `0.05` | Credited local front slot | Improve a retained tradeoff point |
| `probe` | `0.00` | Disabled | Not used in T85 |

All T85 offspring use one parent. Two-parent fusion is disabled because earlier
T26-family and front-slot screens showed fragile RTL can be harmed by mixing
structurally incompatible parents.

## Memory Cell Credit

Each cell tracks:

- attempts from memory parents;
- valid-PPA offspring from that cell;
- global-front additions;
- local-front additions;
- champion improvements;
- failed offspring;
- exponential moving credit;
- cooldown generation.

Cells are sampleable if they are not cooling down and either contain a global
front member, exceed the minimum credit threshold, or received recent credit.

## Acceptance Gate

T85 is promising only if it preserves every classic-covered design and shows
at least one mechanism signal:

- memory lane has a higher front-add rate per generated candidate than classic;
- front-rescue contributes nondominated material;
- the archive retains a family classic would have evicted and later improves it;
- the SR memory variant beats a random-memory control in the same scheduler.

Headline comparisons must use the reference-complete paired subset. Designs
with missing reference `ppa.txt` are diagnostic-only.
