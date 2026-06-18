# RealBench reference PPA — diagnosis, generation, and remaining work

**Status (2026-06-18): reference-PPA generation started.** RealBench could not
produce PPA-improvement scores because it had no reference PPA. This doc records
the root-cause diagnosis, the generation process now in place, what it delivers,
and the work still required before RealBench is a *full* PPA benchmark member.

> **One-line state:** the golden designs synthesize cleanly to power+area
> (proven), reference `*_ppa.txt` files are now generated for the synthesizable
> e203 set, and two harness bugs (a broken post-synthesis functional gate and
> degenerate STA timing) remain before candidate PPA *scoring* is end-to-end
> usable.

## 1. Diagnosis — why reference PPA did not exist

Three independent issues, found by code trace + a hands-on synthesis test
(Yosys 0.54 → OpenROAD v2.0, Nangate45):

1. **Reference PPA was never generated (the binding gap).** The engine reads
   reference PPA *only* from a pre-synthesized file
   `<realbench_root>/<problem>_ppa.txt`
   (`src/revolution/algorithm.py:_calculate_reference_ppa`, line ~782) — it never
   synthesizes the golden at runtime (explicit design choice). RTLLM ships 46
   such files; **RealBench shipped 0**, and no manifest entry had a `ppa_path`.
   So `ref_ppa_metric` stayed empty → `supports_reference_ppa=False` →
   `ppa_mode=absolute_only` → `quality_mode=functional_only`. This was an
   *incomplete integration*, not a logic bug: the golden RTL synthesizes fine
   (e.g. `e203_exu_alu_csrctrl` → area 225 µm², power 1.11e-4 W).

2. **The post-synthesis functional gate fails for a subset of modules
   (`%Warning-TIMESCALEMOD` / `%Warning-WIDTHTRUNC`).** The Yosys-emitted netlist
   carries no `` `timescale `` while the testbench does; verilator (IEEE
   1800-2023 strictness) turns this into an error during the post-synthesis
   re-simulation, so `synthesis_functionality_success=False` and the candidate
   flow returns `ppa_metrics=None`. Observed failing: `e203_biu`,
   `e203_clk_ctrl`, `e203_clkgate`; observed passing: `e203_exu_alu_csrctrl`,
   `e203_exu_decode` (consistent with M11, which ran golden decode end-to-end).
   The exact affected fraction is uncharacterized (reference generation
   synthesis-only'd all 34, see below), but wherever it triggers it blocks
   **candidate** PPA scoring — independent of reference generation.

3. **Synthesis STA timing is degenerate.** The flow reports `tns max 0.00 /
   wns max 0.00` for every RealBench module (the clock is not being constrained
   onto the design's register paths), so `eff_clk_period` collapses to 0. Power
   and area are correct; timing is not yet measured.

Separately confirmed (not a bug): the **low functional solve rate** on the large
e203 modules is genuine model difficulty — the prompt carries the full interface,
dependencies/aux are wired into the harness, the golden validates, and failing
candidates compile + simulate but produce wrong logic. RealBench is a legitimate
functional capability probe; the gaps above are specifically about PPA.

## 2. What the generation delivers

`scripts/generate_realbench_reference_ppa.py` synthesizes each manifest golden
through the **same** Yosys+OpenROAD path used to score candidates
(`SynthesisEvaluator._run_synthesis` + `_parse_ppa_log`, with the candidate
evaluator's aux/include/define resolution), and writes
`<output_root>/<problem>_ppa.txt`:

```
tns,wns,eff_clk_period,power,area
<tns>,<wns>,<eff_clk_period>,<power>,<area>
```

It deliberately **skips the post-synthesis functional gate** (issue 2): the
golden is correct by construction (`harness_validated` in the manifest), and the
gate is currently broken — but the PPA numbers come from the identical synthesis
+ parser candidates use, so they stay flow-consistent. Power and area are valid
and non-zero (the fields the engine requires); timing fields are 0 pending the
STA fix (issue 3).

- **Source manifest:** `data/bench/RealBench_v4_synth` (the synthesis-validated
  manifest; 34/40 e203 modules flagged `supports_synthesis`).
- **Coverage generated:** **34/34** synth-capable e203 modules (all of
  `RealBench_v4_synth`'s `supports_synthesis` set), 0 skips. Area spans
  5–26,433 µm² (clkgate → full core), power 1.6e-6–1.3 W — a realistic spread.
- **Files:** the 34 `*_ppa.txt` live in the RealBench tree, which is
  **git-ignored and regenerated** (`.gitignore`: *"Generated RealBench manifest
  tree (rebuild with scripts/build_realbench_manifest.py)"*) — so unlike RTLLM's
  committed `*_ppa.txt`, these are local artifacts. The committed, reproducible
  deliverables are this doc and `scripts/generate_realbench_reference_ppa.py`;
  regenerate the files with the command below after (re)building the tree.

### Reproduce

```bash
PYTHONPATH=src python scripts/generate_realbench_reference_ppa.py \
  --realbench-root data/bench/RealBench_v4_synth        # add --patch-manifest to wire ppa_path
```

## 3. How reference PPA is consumed (two paths)

| Consumer | Reads from | Enabled by the `_ppa.txt` files alone? |
|---|---|---|
| Engine `_calculate_reference_ppa` (writes `ref_ppa_metric`) | `<realbench_root>/<problem>_ppa.txt` directly | **Yes** — populates once the files exist (use `--realbench_root data/bench/RealBench_v4_synth`) |
| `run_backend` → `CandidateEvaluator` (drives `quality_mode`, candidate PPA score) | manifest `ppa_path` via `load_realbench_reference_ppa_metrics` | **No** — needs the manifest `ppa_path` + `supports_synthesis` (see remaining work) |

So the files immediately give the engine a reference; flipping the capability
layer to `quality_mode=ppa` for candidate scoring still needs the manifest wiring.

## 4. Remaining work before RealBench is a full PPA benchmark

1. **Wire the manifest `ppa_path` + `supports_synthesis`.** This is a
   *version-locked-artifact* change: `data/bench/RealBench_v4_synth/module_manifest.json`
   is sha256-locked by the `data/configs/realbench_*_subset.yaml` configs, so it
   must be done as a deliberate version bump that also re-locks the dependent
   subset hashes (per the repo's locked-artifact protocol). Not done in this
   first pass. Because the RealBench tree is regenerated, the cleanest home for
   both the `_ppa.txt` generation and the `ppa_path` wiring is the tree builder
   `scripts/build_realbench_manifest.py` (or a documented post-build step), so a
   rebuilt tree ships reference PPA by construction.
2. **Fix the post-synthesis functional gate (issue 2)** so candidate PPA scoring
   works: prepend `` `timescale `` to the synthesized netlist before the
   post-synth verilator compile, or pass `--timescale-override` /
   `-Wno-TIMESCALEMOD -Wno-WIDTHTRUNC` for that re-sim step
   (`SynthesisEvaluator._check_synthesis_functionality`). Needs a test.
3. **Fix STA timing (issue 3)** so the clock is constrained onto RealBench module
   register paths (`_create_sdc_file` clock-port resolution), yielding real
   `tns/wns/eff_clk_period`. Until then PPA-improvement is power+area only.
4. **Extend coverage to aes/sdc** — only e203 is synthesis-validated today; the
   final-26 subset spans aes/e203/sdc, so aes/sdc need synth-validation before
   their PPA can be generated.

Until 1–3 land, RealBench supports a **functional** capability story (legitimate,
genuine ceiling) plus **power+area reference data**; full PPA-improvement scoring
(with timing) is the follow-up.
