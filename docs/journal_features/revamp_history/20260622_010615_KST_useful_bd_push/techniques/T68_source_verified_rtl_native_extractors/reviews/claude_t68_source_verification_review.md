I now have everything I need. All four MasterRTL PPA feature vectors are real, nonzero values, yet the shipped model predicts `0.0` for all of them — which falsifies the "features are zeroed" explanation and points to a degenerate/placeholder model. Here is my review.

---

# T68 Source-Verification Review — Findings

Read-only review of branch `feat/journal-useful-bd-exp-20260622`. I verified the package's factual claims against the actual upstream checkouts under `exp/external_repos/` and the raw run outputs under `exp/verification/`. (Code execution was blocked by the sandbox, so two numeric claims were checked by reading source/data rather than re-running.)

## Severity-ordered findings

### 1. [Medium-High] The "labels/features are zeroed" explanation is factually wrong; it masks a stronger caveat
The package attributes the all-`0.0` MasterRTL predictions to zeroed inputs:
- `results_report.md:29` — "Weights deserialize, but the shipped TinyRocket labels/features are zeroed, so this is not an accuracy check."
- `tables/upstream_verification_summary.csv:4-7` — "Weight loads, but upstream TinyRocket labels/features produce zero prediction."
- `useful_bd_push_implementation_history.md:3857-3859` — same "labels/features are zeroed" wording.

The shipped **feature** vectors are real and nonzero for every PPA type:
- `example/feature/TinyRocket_sog_vec_area.json` = `[2297, 2401, 691, 4161, 2922, 940, 2123, 8002, 10387.0, ...]` (14 values, matches `feature_count: 14`)
- `..._vec_pwr.json` = 17 nonzero/real values (matches `feature_count: 17`)
- `..._vec_timing.json` = `[-1.3523…, -435.0725…]`

Only `example/label/TinyRocket.json` is zeroed (`{"Area":0,"Power":0,"WNS":0,"TNS":0}`). So the model receives **correctly-dimensioned, nonzero features and still returns exactly `0.0`** for all four heads. That means the shipped XGBoost pickles are effectively a **degenerate/placeholder model** (a constant-0 predictor, consistent with being fit on zero labels) — not "weights that would work if fed real features." This is a stronger and more relevant caveat than the one written, and it's exactly the link the user cares about ("outputs actually verified"). As written, a future reader could wrongly conclude "supply nonzero features and the upstream model works." Recommend rewording to: *labels are zeroed and the shipped model returns a constant `0.0` on real features, so the shipped example permits a weight-deserialization check only, not any accuracy or output validation.*

### 2. [Medium] Graph node/edge counts in the committed package contradict the raw run output, unexplained
- Committed `tables/upstream_verification_metrics.json:6-7` → `graph_node_key_count: 22306`, `graph_edge_count: 65938`, presented in `upstream_verification_summary.csv:2-3` and `results_report.md:27-28` as "nonempty… expected upstream graph shape."
- The raw, untracked run output `exp/verification/rtl_native_metrics.json` — same pickle byte sizes (`870007` / `3560907`) and same `node_dict_count: 51337` — reports **`node_count: 0, edge_count: 0`** under different field names.

So the first extraction reported 0 nodes/0 edges and the committed package reports 22306/65938, with no note reconciling them. Likely the first pass used a standard `number_of_nodes()/edges()` accessor on a non-`networkx` object and silently got 0, then a second pass counted differently — but for a *verification* gate the headline number must be reproducible and the discrepancy explained. I could not adjudicate the true count (python execution blocked), so I report the inconsistency rather than which figure is correct. A committed extractor (see #5) would resolve this.

### 3. [Low-Medium] The figure emphasizes Pearson and hides a worse rank correlation
`figures/rtltimer_sog_slack_alignment.png` plots only Pearson (init-word `0.547`, route-word `0.846`), framing route-word as "stronger alignment." But Spearman moves the other way — init-word `0.484` → route-word **`0.385`** (`upstream_verification_metrics.json:43,52`). High Pearson + low Spearman on route-word indicates a leverage/outlier-driven linear fit, not a robustly monotone slack alignment. Both numbers are in the table (so nothing is concealed), but the figure alone overstates the timing-risk story. Recommend plotting Spearman beside Pearson or annotating the rank-corr divergence.

### 4. [Low] Domain terminology is undefined
SOG, BOG, "init-word"/"route-word", `read -verific`, `vlg2ir`/`vlg2bog` appear throughout `methodology.md`/`results_report.md` with no glossary. A reviewer outside the MasterRTL/RTL-Timer ecosystem cannot tell that, e.g., init-word vs route-word are pre/post-route timing-label stages. A 3–4 line glossary in `methodology.md` would make the package self-contained.

### 5. [Low] No committed extractor → the gate isn't reproducible from the package
`commands/upstream_verification.md` documents clone/run commands narratively, but the python that produced `upstream_verification_metrics.json` and the figure is not committed. Given finding #2, a small committed `verify.py` (graph load + counts, model load + predict, Pearson/Spearman, figure) would make the gate reproducible and would have caught the 0-vs-65938 mismatch. This matches the repo's doc-package style, hence low severity, but a verification-purpose package is exactly where a committed checker pays off.

## What T68 gets right (verified)
- **No proxy-as-upstream overclaim.** Status is `T0 verification_gate`; it explicitly refuses to promote T15/T60/T61 as real MasterRTL/RTL-Timer (`results_report.md:7-9`, `best_current_techniques.md:81-88`, `technique_lanes.md:61,74`, `technique_lineage_ledger.md:242`, `current_results_matrix.md:96-100`). This is consistent with T15 already self-labeling as "Yosys-backed SOG proxy, not a full MasterRTL implementation" (`T15.../results_report.md:3-5`). Directly answers the adversarial prompt's external-method check (`useful_bd_push_adversarial_prompt.md:57-60`). Strong anti-gaming posture.
- **`read -verific` blocker is real.** Confirmed in `exp/external_repos/MasterRTL/ys_script/run_TinyRocket_sog.ys:1` and `run_TinyRocket_ast.ys:1`, and RTL-Timer `vlg2bog/scr_ys/run_ys_template.ys` + `auto_run_vlg2bog.py`. Yosys `0.54+29` is genuinely built without Verific.
- **`os.system("python3 …")` masking failure is real and well-caught.** Confirmed at `MasterRTL/vlg2ir/auto_run.py:10`; the direct-invocation workaround is justified and clearly stated (`results_report.md:46-49`).
- **"RTL-Timer ships no model weights" is true.** Only feature-label `.pkl`s exist; no `.pt/.pth/.model/.bin/.ckpt`. Correctly characterized as "retrain rather than load packaged weights" (`upstream_repo_inventory.csv:3`).
- **Leakage rules** correctly forbid upstream PPA/timing labels as in-loop BD inputs (`methodology.md:24-31`).
- **Next steps follow the goal, no early give-up.** Three concrete options — Verific-capable flow, a minimal documented patch removing `read -verific` while preserving SOG/BOG semantics, or RTL-Timer retrain/inference with checkpoint hashes + sanity metrics (`results_report.md:53-62`). Correctly does **not** trip the goal's blocked stop condition (which needs three same-blocker attempts).
- **GUIDELINES alignment:** docs+data only, simple, no defensive fallbacks, abstractions, or back-compat clutter. Figure renders cleanly (verified visually). Tracking docs are internally consistent and the TODO/registry/ledger entries match.

## Verdict: **PASS WITH LIMITATIONS**

T68 correctly handles the user's core concern — it refuses to equate the proxy lanes with real MasterRTL/RTL-Timer, states the `read -verific`, missing-weights, zero-label, and wrapper/env blockers, and points to goal-aligned next steps without giving up. The verification is **sufficient as a gate** (it proves the proxies are not source-equivalent and that fresh conversion is blocked). It is **not yet clean enough to cite as rigorous source verification**: finding #1 (mischaracterized model-output check, the very "outputs verified" link the user flagged) and finding #2 (unreconciled graph-count discrepancy) should be corrected, and ideally the gate should ship a committed extractor (#5). None of these flip the conservative `T0` decision, but #1 and #2 should be fixed before the package is leaned on as evidence of upstream-output verification.
