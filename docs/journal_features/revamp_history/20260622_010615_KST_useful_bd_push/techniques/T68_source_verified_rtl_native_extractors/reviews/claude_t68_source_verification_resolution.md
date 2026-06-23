# Claude T68 Source-Verification Resolution

Review file: `claude_t68_source_verification_review.md`.

Verdict received: `PASS WITH LIMITATIONS`.

Actions taken:

- Corrected the MasterRTL model-output caveat. The shipped feature vectors are
  nonzero, the shipped labels are zero, and the saved models return constant
  `0.0`; this is a deserialization check only.
- Added `tools/verify_upstream_artifacts.py` so the graph counts, model
  predictions, RTL-Timer correlations, tables, and figure are regenerated from
  one committed source.
- Regenerated `tables/upstream_verification_metrics.json` and
  `tables/upstream_verification_summary.csv` with nonzero feature counts and
  explicit defaultdict graph counts.
- Regenerated `figures/rtltimer_sog_slack_alignment.png` to show both Pearson
  and Spearman correlations.
- Added a glossary for SOG, BOG, init-word, route-word, `read -verific`,
  `vlg2ir`, and `vlg2bog`.

Remaining limitation:

T68 remains only a verification gate. It does not prove upstream model accuracy
or source-equivalent extraction on our candidates. The next RTL-native live
method still needs a Verific-capable flow or a source-aligned preprocessing
adaptation.
