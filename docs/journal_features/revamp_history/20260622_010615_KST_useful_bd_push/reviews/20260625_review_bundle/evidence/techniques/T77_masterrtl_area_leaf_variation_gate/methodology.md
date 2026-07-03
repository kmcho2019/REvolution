# T77 Methodology

## Question

Can the verified MasterRTL pretrained Area tree head provide a useful
generated-candidate leaf or margin embedding for the RTL-native BD lane?

## Candidate Set

T77 reuses the `19` generated RTL candidates from T70:

`techniques/T70_generated_rtl_extractor_smoke/tables/t70_extractor_results.csv`

Those candidates already passed the source-aligned MasterRTL SOG parse, so T77
does not rerun Yosys or vLLM.

## Feature Path

T77 uses the source-faithful MasterRTL Area feature path:

1. Load each T70 generated-candidate SOG graph pickle.
2. Load the matching MasterRTL node dictionary.
3. Initialize the upstream `DG.Graph`.
4. Run upstream `graph_stat.cal_oper`.
5. Assert the resulting feature vector has `14` values.
6. Feed the vectors into `xgboost_Area_model.pkl`.
7. Record scalar predictions and tree leaf rows.

This uses the same feature family as
`feature_extract/area/feature_extra_graph_stat.py`. It does not use final PPA,
reference PPA, hypervolume, Pareto rank, or test results as descriptor inputs.

## Blocked Heads

Power and timing are not evaluated in T77:

- Power requires toggle-rate side data from the synthesis/EDA flow.
- WNS and TNS require MasterRTL timing DAG and path-delay feature flow.

T77 records those heads as blocked rather than filling missing inputs with
defaults.

## Promotion Gate

The pretrained Area head would be worth a live BD only if generated candidates
produce nontrivial prediction, margin, or leaf variation. Collapse to one
prediction and one leaf row blocks the method.
