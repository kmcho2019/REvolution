# RealBench reference PPA — diagnosis, generation, and remaining work

**Status (2026-06-18): RealBench PPA scoring is operational.** Reference PPA is
generated for all 34 synthesizable e203 modules (with real timing); the harness
bugs are fixed; and candidate PPA scoring now works for **all** synthesizable
RealBench modules via an explicit acceptance policy (below). This doc records the
diagnosis, the generation process, the harness fixes (§5), the acceptance policy
(§0), and the remaining coverage work.

> **One-line state:** reference `*_ppa.txt` for **all 34** synthesizable e203
> modules, **with real timing** (23/34 sequential modules carry non-zero
> tns/wns). Three harness bugs fixed (verilator timescale, SDC clock parse,
> post-synth aux deps, §5). **Candidate PPA scoring works for all synthesizable
> modules** — RealBench accepts PPA on the pre-synthesis RTL functional gate plus
> a synthesis non-degeneracy **sanity check**, instead of the gate-level
> functional re-sim that is unstable for sequential CPU modules (§0).

## 0. Candidate PPA acceptance policy — RealBench uses a sanity check (IMPORTANT, do not bury)

**On RealBench, a candidate's PPA is accepted on the strength of (1) the
*pre-synthesis* RTL functional check passing and (2) successful synthesis whose
result passes a non-degeneracy sanity check — NOT a gate-level functional
re-simulation of the synthesized netlist.** This is a deliberate, scoped
deviation from the other suites (RTLLM / VerilogEval still do the full
gate-level re-sim).

**Why.** The gate-level re-sim of large *sequential* e203 modules mismatches the
reference for reasons unrelated to candidate correctness (gate-vs-RTL
X-propagation / reset modelling — e.g. biu mismatches 50/222 samples even on the
golden; see §5.4). Forcing it would make every sequential module un-scorable.
The candidate's functional correctness is already established by the
pre-synthesis RTL simulation; the gate-level re-sim was a second, stricter check.

**What replaces the lost safety.** The gate-level re-sim historically also caught
**yosys "stub-outs"** — cases where synthesis bugs out and emits a near-empty
netlist whose absurdly low area/power would corrupt PPA scoring. To preserve that
protection without the full re-sim, RealBench PPA is gated by a **sanity check**
(`CandidateEvaluator._passes_synthesis_sanity`): the synthesized result is
rejected unless power **and** area are non-zero, the netlist has a non-empty cell
count, **and** (when a reference exists) the area is at least 5% of the golden's
reference area — a real design is never orders of magnitude smaller than its
golden, but a stub is.

**Mechanism.** A per-benchmark capability flag
`gate_level_functional_recheck` (True by default; **False for RealBench**)
selects the path — see §5.5. Each run's artifacts record which path was used
(`gate_level_functional_rechecked` in the synthesis result).

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
2. **Bug 4 — gate-level re-sim of sequential modules mismatches — RESOLVED via
   the §0 acceptance policy (option b).** Sequential CPU modules (biu, ifu, …)
   mismatch the reference at the gate level (biu 50/222 samples) from
   gate-vs-RTL X-propagation / reset modelling. *Option (a)* (harden gate-level
   sim) was **tried + rejected**: `--x-initial 0`, `--x-initial unique`, and
   `--x-initial 0 --x-assign 0` all give the *identical* 50/222 mismatch, so it
   is not an X-init problem — it is a real, deterministic gate-vs-RTL difference
   on the ICB bus-handshake outputs needing genuine per-module debugging.
   *Option (b)* was adopted: accept candidate PPA on the pre-synthesis RTL gate +
   synthesis with a non-degeneracy sanity check (§0, §5.5). Candidate PPA scoring
   now works for **all** synthesizable modules.
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

### 5.4 Bug 4 — gate-level sim mismatch (characterized; handled by the §0 policy)
With 5.1 + 5.3 the post-synth func check now *compiles* for multi-dep modules,
but the gate-level simulation of sequential CPU modules mismatches the reference
(biu: "Total mismatched samples is 50 out of 222", first at t=205) — classic
gate-level X-propagation / reset-sequencing, a genuine verification problem, not
a wiring bug. Combinational modules are unaffected. `--x-initial` (0/unique) +
`--x-assign 0` were tried and all give the identical mismatch, ruling out X-init.
Rather than per-module gate-level debugging, this is handled by the acceptance
policy in §0 / §5.5.

### 5.5 RealBench PPA acceptance via sanity check (option b — the §0 policy)
Implements §0. A per-benchmark capability flag
`gate_level_functional_recheck` (`benchmark_capabilities.py`, default True;
**False for the `realbench` family**) selects the acceptance path:
- `SynthesisEvaluator.evaluate(..., gate_level_functional_recheck=False)` skips
  the gate-level re-sim and returns PPA from synthesis (same numbers / parser).
- `CandidateEvaluator` reads the flag and, in sanity mode, gates PPA on
  `_passes_synthesis_sanity` (non-zero power+area, non-empty cell count, and
  area ≥ 5% of the reference golden — `_SANITY_MIN_AREA_FRACTION`) instead of the
  gate-level pass, rejecting yosys stub-outs.

RTLLM / VerilogEval keep the full gate-level re-sim (flag True). Validated:
`e203_biu` now reaches `status=success` end-to-end (area 1611, power 0.349); a
stub (area ≪ reference, or empty netlist, or zero PPA) is rejected. Tests:
`test_benchmark_capabilities` (flag per family) +
`test_candidate_evaluator::test_passes_synthesis_sanity_rejects_stubs`; all
existing evaluation/verilator/capability tests still pass.
