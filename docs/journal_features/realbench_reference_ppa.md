# RealBench reference PPA — diagnosis, generation, and remaining work

**Status (2026-06-18): reference PPA generated + three harness bugs fixed.**
RealBench could not produce PPA-improvement scores because it had no reference
PPA. This doc records the root-cause diagnosis, the generation process, the
harness fixes applied (§5), and the work still required before RealBench is a
*full* PPA benchmark member.

> **One-line state:** reference `*_ppa.txt` are generated for **all 34**
> synthesizable e203 modules, now **with real timing** (23/34 sequential modules
> carry non-zero tns/wns) after fixing the SDC clock bug. **Three harness bugs
> are fixed** (verilator timescale, SDC clock parse, post-synth aux deps, §5);
> candidate PPA scoring now works end-to-end for combinational / dependency-free
> modules. **One deeper issue remains** (bug 4): gate-level functional
> re-simulation of *sequential* CPU modules mismatches (X-propagation / reset),
> still blocking candidate scoring on those.

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
   **→ FIXED (§5.1, the timescale cause) + §5.3 (a related missing-dependency
   cause); a deeper gate-level sim mismatch on sequential modules remains as
   bug 4 (§5.4).**

3. **Synthesis STA timing is degenerate.** The flow reports `tns max 0.00 /
   wns max 0.00` for every RealBench module (the clock is not being constrained
   onto the design's register paths), so `eff_clk_period` collapses to 0. Power
   and area are correct; timing is not yet measured. **→ FIXED (§5.2): the SDC
   parser was discarding the clock; 23/34 modules now carry real timing.**

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

It deliberately **skips the post-synthesis functional gate**: the golden is
correct by construction (`harness_validated` in the manifest), so re-verifying it
adds nothing — and the PPA numbers come from the identical synthesis + parser
candidates use, so they stay flow-consistent. Power and area are valid and
non-zero (the fields the engine requires); after the SDC fix (§5.2) timing is
now real for sequential modules (**23/34** carry non-zero tns/wns; the rest are
combinational or thin wrappers and are correctly 0).

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

1. **Wire the manifest `ppa_path` + `supports_synthesis`** so `run_backend` flips
   `quality_mode=ppa` for candidate scoring (the engine already reads the files
   directly). This is a *version-locked-artifact* change: `module_manifest.json`
   is sha256-locked by `data/configs/realbench_*_subset.yaml`, so it must be a
   deliberate version bump that re-locks the subset hashes. The cleanest home for
   both `_ppa.txt` generation and the `ppa_path` wiring is the tree builder
   `scripts/build_realbench_manifest.py`, so a rebuilt tree ships reference PPA
   by construction.
2. **Bug 4 — gate-level functional re-sim of sequential modules mismatches**
   (§5.4): combinational / dependency-free modules now pass the post-synth func
   check end-to-end (candidate-scorable), but sequential CPU modules (biu, ifu,
   …) mismatch at the gate level (biu: 50/222 samples) from X-propagation / reset
   modelling. Options: (a) harden gate-level sim (verilator `--x-initial`, reset
   sequencing) — per-module verification work; or (b) accept candidate PPA on the
   strength of the *pre-synthesis* RTL functional gate + synthesis (matching how
   reference PPA is generated), treating the gate-level re-sim as advisory — a
   research-design decision for the shared evaluation contract.
   **Option (a) tried + rejected (2026-06-18):** `--x-initial 0`, `--x-initial
   unique`, and `--x-initial 0 --x-assign 0` all yield the *identical* biu 50/222
   mismatch, so it is **not** an X-initialization problem. The mismatches are
   deterministic and concentrated on the ICB bus-handshake outputs
   (`lsu2biu/ifu2biu/ppi *_icb_cmd_*/_rsp_*` ready/valid/data, first at t=205) —
   a real gate-vs-RTL functional difference, not X-pessimism. So bug 4 needs
   genuine per-module gate-level debugging; **option (b) is the pragmatic path**
   to unblock candidate PPA scoring on sequential modules.
3. **Extend coverage to aes/sdc** — only e203 is synthesis-validated today; the
   final-26 subset spans aes/e203/sdc, so aes/sdc need synth-validation first.

## 5. Fixes applied (2026-06-18)

All three are in the shared evaluation harness, covered by
`tests/revolution/test_synthesis_sdc_clock.py` (SDC) plus hands-on validation
(timescale / aux); the 42 existing evaluation + verilator tests still pass.

### 5.1 Verilator timescale (bug 1)
Added `--timescale-override 1ns/1ps` to the verilator command
(`verilator_evaluation.py`). The Yosys netlist carries no `` `timescale ``;
forcing a uniform one removes the netlist-vs-testbench `TIMESCALEMOD` error.
Validated: `e203_exu_alu_csrctrl` now passes the post-synth func check
end-to-end (its testbench also uses `$time`, so this also covers the
`WIDTHTRUNC` warning under the existing `-Wno-fatal`).

### 5.2 SDC clock parse (bug 2)
Rewrote `_create_sdc_file` (`evaluation.py`). The old code split the file on `;`
and unconditionally inspected only the chunk before the first `;`, so any module
with a license header (every e203 golden — the Apache header contains a `;`)
produced **no** `create_clock` → STA ran unconstrained → tns/wns = 0. The new
parser strips comments, locates the `module <name> … ;` header, and pulls clock
ports from the port list. Validated at scale: regenerating all 34 reference
files, **23/34 now carry real timing** (e.g. biu eff_clk 0.6 ns, ifu 2.56 ns);
combinational modules / thin wrappers correctly stay 0.

### 5.3 Post-synth aux dependencies (bug 3)
`_check_synthesis_functionality` now receives + compiles the design's
`aux_files` (the `sirv_gnrl_*` dependency bundles) alongside the netlist.
Multi-module testbenches instantiate those dependency modules directly, and the
flattened netlist defines only the DUT, so without the aux sources verilator
failed with "Cannot find module". Validated: those compile errors are gone for
biu/lsu.

### 5.4 Bug 4 — gate-level sim mismatch (NOT fixed, characterized)
With 5.1 + 5.3 the post-synth func check now *compiles* for multi-dep modules,
but the gate-level simulation of sequential CPU modules mismatches the reference
(biu: "Total mismatched samples is 50 out of 222", first at t=205) — classic
gate-level X-propagation / reset-sequencing, a genuine verification problem, not
a wiring bug. Combinational modules are unaffected. Tracked in remaining-work
item 2.
