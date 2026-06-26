# Sequential DeepSeq BD Methodology

## Intent

Test whether sequential/state-aware representations explain diversity that
combinational AIG or text descriptors miss. Use DeepSeq/DeepSeq2 principles
where runnable and deterministic sequential controls otherwise.

This completed T08 package is a retrospective proxy, not a true pretrained
DeepSeq reproduction. It synthesizes measured evidence from source-aligned
state/pipeline, MasterRTL, and RTLTimer descriptor runs that exercised the
same sequential-structure hypothesis under the current REvolution/QD runtime.

## Inputs

- Candidate RTL and fixed benchmark metadata.
- Yosys or source-aligned RTL extraction with FF/DFF, wire, branching, state,
  and pipeline features.
- Existing live-run PPA/front reports from T63, T67, T72, T73, and T75.

Descriptor inputs exclude final PPA, reference PPA, fitness, hypervolume,
Pareto labels, and functional pass labels.

## Completed Proxy Scope

The proxy evidence covers:

- T63 `fused_rtl_state_pipeline_2d`, which uses RTL-native state/pipeline
  descriptors in a live QD screen.
- T67, which keeps the T63 state/pipeline descriptor but changes realization
  to source-preserving seeded thought-code generation.
- T72, which uses source-aligned MasterRTL/RTLTimer cell descriptors.
- T73 and T75, which use source-aligned shape-density axes including DFF and
  wire density.

These runs cover the core DeepSeq-style concern that sequential state,
pipeline, and feedback structure may define useful implementation families.
They do not validate any external DeepSeq pretrained checkpoint.

## Descriptor Inputs

The measured proxy descriptors include:

- state and pipeline structure from fused RTL-native profiles;
- MasterRTL source-aligned branching and graph features;
- RTLTimer wire density and DFF density;
- source-preserving parent RTL used by seeded thought-code generation.

## Archive And Coupling Surfaces

The evidence spans several archive/coupling surfaces:

- T63: RTL-native archive cells under the T51-style live screen.
- T67: the same state/pipeline cells with source-preserving seeded
  realization.
- T72: source-aligned fixed cells derived from generated RTL extractor output.
- T73/T75: source-aligned shape-density cells with stronger occupancy and
  front-pressure variants.

This is enough to decide whether the current branch already has evidence for
the sequential proxy lane. It is not enough to claim that DeepSeq pretrained
embeddings themselves were tested.
