# T69 Methodology

## Question

Can we adapt the upstream MasterRTL and RTL-Timer TinyRocket preprocessing
flows to this open-source Yosys environment without using Verific?

## Protocol

1. Keep the upstream repositories under `exp/external_repos/` unchanged.
2. Run the same TinyRocket input RTL, top module, Yosys lowering stages, and
   SOG/BOG output intent as the upstream scripts.
3. Remove only the Verific frontend command from the invocation:
   - MasterRTL: skip `read -verific`, then use the existing
     `read_verilog`, `hierarchy`, `proc`, `flatten`, `opt`, `fsm`, `memory`,
     `techmap`, and `write_verilog` stages.
   - RTL-Timer: skip the emitted `read -verific`, set `cmd=sog`, then use the
     existing `hierarchy`, `proc`, `opt`, `fsm`, `memory`, `techmap`,
     `dfflibmap`, `abc`, `clean`, and `write_verilog` stages with
     `nangate45_sog.lib`.
4. Apply only the upstream cleaner convention to generated artifacts:
   remove Yosys attributes of the form `(* ... *)`, remove block-comment
   tails, and drop blank lines.
5. Verify parser compatibility:
   - MasterRTL must parse the cleaned generated SOG through
     `vlg2ir/analyze.py`.
   - RTL-Timer cleaned SOG BOG must pass Yosys parsing and preserve core BOG
     structural counts against the shipped example.
6. Compare generated TinyRocket artifacts against shipped TinyRocket artifacts
   with graph counts, text counts, hashes, and a visual ratio figure.

## Leakage Rules

T69 uses only upstream example RTL and preprocessing artifacts. It does not use
candidate final PPA, reference PPA, fitness, Pareto rank, hypervolume, test
pass rate, or timing labels as in-loop BD inputs.

## Promotion Rule

T69 cannot be promoted as a QD result. It only unblocks a future RTL-native
descriptor lane if that future lane:

- runs the extractor on REvolution candidate RTL;
- reports extractor success and failure rate by problem;
- records model/checkpoint hashes if any trained RTL-Timer or MasterRTL model
  is used;
- defines archive cells from pre-synthesis RTL/operator/timing-risk features;
- evaluates classic versus QD on a reference-complete paired PPA subset.

## Visual Rule

There is no Phase 03.1 QD viewer for T69 because no live QD archive exists.
The figure here is a preprocessing alignment diagnostic only.
