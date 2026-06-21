# Sequential DeepSeq BD Methodology

## Intent

Test whether sequential/state-aware representations explain diversity that
combinational AIG or text descriptors miss. Use DeepSeq/DeepSeq2 principles
where runnable and deterministic sequential controls otherwise.

## Inputs

- Candidate RTL and fixed benchmark metadata.
- Yosys netlist with FF/latch boundaries and state elements.
- Optional bounded simulation traces from fixed non-reward stimuli.
- DeepSeq-family implementation or a lightweight state-aware surrogate.

Descriptor inputs exclude final PPA, reference PPA, fitness, hypervolume,
Pareto labels, and functional pass labels.

## Preprocessing

1. Extract the sequential graph: PI, PO, FF/latch nodes, combinational cones,
   reset/set paths, enable paths, and feedback edges.
2. Canonicalize state element names and order.
3. Generate bounded random or deterministic stimuli only for descriptor
   summaries; use the same stimuli for all methods and record seeds.
4. For combinational benchmarks, emit explicit zero-state features so they are
   not silently dropped.

## Descriptor

Compute and compare:

- state graph counts: FF count, SCC count, feedback edge count, reset density,
  enable density, and FF-to-FF cone depth;
- transition summaries from fixed stimuli: toggle histograms, state-bit entropy,
  and output-response sketch;
- DeepSeq-style or surrogate sequence embeddings over state transition traces;
- cone embeddings pooled by sequential boundary type.

Normalize within benchmark and freeze any fitted projection before live runs.

## Archive Mapping

Use a grid over sequential entropy and feedback/reconvergence density for
interpretability. Use CVT over the full state-aware vector for higher
dimensional archive pressure.

## Parent Selection Coupling

Only synthesis-valid candidates with extracted sequential graphs can occupy
normal cells. Candidates with extraction failure remain in the validity funnel.
Descriptor stimuli are not testbench pass/fail checks.

## Expected Outputs

- `tables/sequential_features.csv`
- `tables/stimulus_sketches.csv`
- `tables/state_graph_funnel.csv`
- `figures/sequential_projection.png`
- `figures/state_entropy_vs_ppa.png`
