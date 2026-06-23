# T68 Source-Verified RTL-Native Extractors Results Report

## Tier Decision

`T0 verification_gate`.

Do not promote the existing T15/T60/T61 proxy features as real MasterRTL or
RTLTimer results. They remain useful diagnostics, but the next RTL-native live
experiment must first align its extractor with the upstream repositories.

## Source Check

| Repository | Commit | Saved weights | Example data | Fresh conversion |
| --- | --- | --- | --- | --- |
| MasterRTL | `5bccf38f8db7bb511a793a709863e7cb1b333ab5` | yes | yes | blocked by `read -verific` |
| RTL-Timer | `206ff4078368c251d2fafaffcc648282c68316f1` | no obvious packaged model weights | yes | blocked by `read -verific` |

MasterRTL's README now points users to RTL-Timer for easier and more accurate
RTL-stage PPA modeling. That does not make the MasterRTL SOG idea unusable,
but it means a reviewer-facing claim should prefer RTL-Timer preprocessing
unless we need MasterRTL's shipped SOG model artifacts specifically.

## Quantitative Checks

| Check | Result | Interpretation |
| --- | ---: | --- |
| MasterRTL direct SOG parse node dictionary | `51337` entries | Direct `analyze.py` works on shipped `TinyRocket_sog.v` with isolated dependencies. |
| MasterRTL direct SOG graph edges | `65938` edges | The graph pickle is nonempty and has the expected upstream graph shape. |
| MasterRTL saved model predictions | all `0.0` on TinyRocket | Weights deserialize, but nonzero TinyRocket feature vectors and zero labels yield constant-zero outputs. This is not an accuracy or useful-output check. |
| RTL-Timer SOG init-word registers | `166` | Feature-label artifact is readable. |
| RTL-Timer SOG init-word Pearson/Spearman | `0.546662` / `0.483940` | Moderate linear and rank alignment. |
| RTL-Timer SOG route-word Pearson/Spearman | `0.846441` / `0.385196` | Strong linear alignment but weaker rank alignment, so the timing-risk signal needs outlier-aware checks before use as a BD. |

The corresponding figure is
`figures/rtltimer_sog_slack_alignment.png`.

The graph edge count is produced by `tools/verify_upstream_artifacts.py` from
MasterRTL's `defaultdict(list)` graph pickle. Do not use NetworkX node/edge
accessors on this artifact; they report misleading zeroes because the pickle is
not a NetworkX graph.

## What Failed

Fresh upstream conversion failed in both repositories because our open-source
Yosys build reports:

```text
ERROR: Command syntax error: This version of Yosys is built without Verific support.
```

The MasterRTL wrapper also masks dependency failure because `auto_run.py` calls
`os.system("python3 analyze.py ...")` and returns success even when the child
process cannot import `ply`. Directly invoking `analyze.py` with the isolated
`uv` environment succeeds.

## Decision

The strongest next RTL-native lane is still MasterRTL/RTLTimer-style
operator/timing structure, but exact proxy escalation is blocked until the
preprocessing path is source-aligned. The next live technique should not be
another regex or Yosys-stat proxy. It should be one of:

- a Verific-capable upstream conversion run;
- a minimal documented patch that removes `read -verific` while preserving the
  upstream SOG/BOG mapping semantics;
- an RTL-Timer retraining/inference path over our generated candidates with
  explicit checkpoint hashes and descriptor sanity metrics.
