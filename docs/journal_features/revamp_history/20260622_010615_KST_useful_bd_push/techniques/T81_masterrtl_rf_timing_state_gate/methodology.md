# Methodology

## Question

Can MasterRTL's verified pretrained RF timing model provide noncollapsed
model-state descriptors on generated RTL candidates?

## Inputs

- Generated RTL corpus:
  `T70_generated_rtl_extractor_smoke/tables/t70_extractor_results.csv`.
- MasterRTL clone:
  `exp/external_repos/MasterRTL` at commit
  `5bccf38f8db7bb511a793a709863e7cb1b333ab5`.
- Model artifact:
  `exp/external_repos/MasterRTL/ML_model/saved_model/rfr_model.pkl`.
- Training feature reference:
  `exp/external_repos/MasterRTL/ML_model/saved_data/feat_all_lst.pkl`.

## Algorithm

Run the reproducer with `PYTHONHASHSEED=0` because upstream MasterRTL timing
path selection iterates Python sets. For each T70 generated candidate:

1. Load the source-aligned MasterRTL SOG graph and node dictionary.
2. Run MasterRTL's upstream timing preprocessing:
   `preproc/timing/delay_propagation.graph_update`.
3. Run MasterRTL delay initialization:
   `preproc/timing/delay_propagation.init_node_dict`.
4. Skip candidates without split clock nodes or split timing endpoints.
5. Run `feature_extract/timing/logicGraph.ProcessGraph.Graph_STA`.
6. Use a wrapper around the pretrained RF model only to capture the exact
   path-feature matrix that upstream `Graph_STA` sends to `predict`.
7. Feed those path features to `rfr_model.pkl` and record predictions, RF leaf
   rows, unique leaf IDs, and feature-range coverage relative to the saved
   RF training features.

## Descriptor Meaning

The candidate descriptor is not scalar predicted timing. The candidate signal
is the RF model-state region: tree leaf rows and aggregate leaf diversity over
timing paths. This is closer to a learned timing-morphology state than a direct
PPA-proxy axis.

## Anti-Gaming Boundary

The probe does not use final candidate PPA, reference PPA, hypervolume,
fitness, Pareto rank, functional pass rate, or synthesis pass rate as model
inputs. It uses only MasterRTL graph structure, the upstream timing path
feature extraction flow, and the saved RF timing model.

## Live-Run Gate

This is an offline variation gate only. A live BD profile must not be launched
until a narrow runtime descriptor hook is implemented and tested. That hook
must document:

- how combinational/no-clock candidates are handled;
- how path-level leaf rows are pooled into fixed archive coordinates;
- whether the descriptor is used alone or fused with raw structural axes;
- generated-candidate non-collapse and feature-range diagnostics.
