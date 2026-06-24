# T77 MasterRTL Area Leaf Variation Gate

Status: `T0_variation_gate_negative`.

T77 checks the first generated-candidate follow-up after T76: whether
source-faithful MasterRTL Area features produce useful pretrained tree
prediction or leaf variation on generated RTL candidates.

## Result

The raw MasterRTL Area feature vectors vary, but the pretrained Area XGBoost
head collapses:

- candidates: `19` generated RTL candidates from the T70 extractor smoke;
- unique source-faithful Area feature rows: `17`;
- unique pretrained Area predictions: `1`;
- unique pretrained Area leaf rows: `1`;
- unique leaf IDs across all trees and candidates: `1`.

This means the pretrained Area head should not be used as a live tree-leaf BD
without retraining, calibration, or a different model source.

## Files

| File | Purpose |
| --- | --- |
| `methodology.md` | Source-faithful feature and model protocol. |
| `results_report.md` | Tier decision and interpretation. |
| `artifacts_manifest.md` | Reproducible file index. |
| `commands/variation_gate_v0.md` | Reproduction commands. |
| `tables/t77_area_candidate_features.csv` | Candidate feature vectors, predictions, and leaf hashes. |
| `tables/t77_head_status.csv` | Evaluated and blocked MasterRTL heads. |
| `tables/t77_variation_summary.json` | Compact variation-gate result. |
| `figures/t77_area_leaf_variation_gate.png` | Feature-variation and leaf-collapse visualization. |
| `figures/visual_inspection_notes.md` | Manual figure inspection notes. |
| `tools/run_t77_area_leaf_gate.py` | Reproducer script. |
