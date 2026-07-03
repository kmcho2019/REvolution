# Technical Failure Analysis

## Why Classic Is Hard To Beat

Classic REvolution directly optimizes the PPA objective. With only tens of
LLM candidates per design, this direct exploitation pressure is valuable.
Most QD variants spent some budget on descriptor coverage, archive pressure,
or archive parent recall before the archive had enough time to mature.

Likely failure modes:

| Failure mode | Observed pattern |
| --- | --- |
| Archive fill tax | Empty-cell or broad archive pressure consumes LLM calls that classic spends on quality. |
| Descriptor over-trust | Descriptor spread often does not correspond to useful PPA-front spread. |
| Fragile validity | Diverse RTL changes often fail syntax, functionality, or synthesis. |
| Parent-selection entropy | Archive sampling can replace strong scalar hill climbing too early. |
| Weak encoder objectives | Qwen/DeepGate/MasterRTL axes were valid signals but did not create better fronts. |
| Too little depth | `8x5` and `12x3` budgets may not let archive families mature. |

## What Worked Partly

- Delayed archive activation improved over earlier archive-pressure schedules.
- MasterRTL RF leaf-ID descriptors gave the closest single-seed near miss.
- T100 FG-QDM showed front-rescue can add global-front candidates.
- Front-memory replay showed scalar top-k retention discards some final-front
  candidates, so memory can matter in principle.
- AURORA/raw implementation features and RF/DeepGate hybrids outperformed the
  weakest embedding arms but still lost to classic.

## What Did Not Work

- Pure Qwen3 RTL embedding as archive coordinates.
- Pure DeepGate pooled axes as archive coordinates.
- Direct MasterRTL Area-head leaf embeddings, which collapsed.
- More local-front slots or wider Pareto retention by itself.
- Random or weakly credited FG-QDM memory.
- Fixed MasterRTL geometry tweaks after the first near misses.

## Core Hypothesis For Next Work

The next promising method should not ask diversity to steer most of the
search. It should let classic find good regions, then use diversity only to:

- remember PPA-competitive alternatives classic would evict;
- trigger diversification only after stagnation or front collapse;
- reintroduce archived parents only when a cell has demonstrated child
  quality or front contribution;
- train or adapt descriptors around future PPA-front contribution, not around
  static representation similarity.
