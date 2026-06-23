# T70 Methodology

## Question

Does the T69 open-Yosys MasterRTL/RTL-Timer preprocessing path work on real
REvolution-generated RTL candidates?

## Candidate Sample

Source run:

`exp/useful_bd_push/t67_rtl_native_seeded_thought_20260623_170935_UTC/hard_tuning/rtl_native_seeded_thought_qd/seed_1001/openai_gpt-oss-120b/RTLLM`

For each of the seven T67 hard/tuning problems, select:

1. the first sorted `code.sv`;
2. the first sorted `code.sv` whose directory contains `code.syn.v`;
3. the last sorted `code.sv` whose directory contains `code.syn.v`.

Duplicate paths are removed. This yields `19` candidates. The sample includes
five candidates without `code.syn.v`; the `code.syn.v` flag is used only to
stratify candidate maturity, not to claim PPA or fitness.

## Extractor Commands

For each candidate, infer the top module from the first Verilog `module`
declaration.

MasterRTL path:

1. `read_verilog -sv <code.sv>`;
2. `hierarchy -check -top <top>`;
3. `proc; flatten; opt; fsm; opt; memory; opt; techmap; opt`;
4. `write_verilog`;
5. remove generated Yosys `(* ... *)` attributes;
6. run upstream `MasterRTL/vlg2ir/analyze.py` in the isolated
   `exp/venvs/rtl_native_verify` environment.

RTL-Timer path:

1. `read_verilog -sv <code.sv>`;
2. `hierarchy -top <top>`;
3. `proc; opt -fast; fsm; opt -fast; memory; opt -fast`;
4. `techmap; opt -fast; rename -wire t:$*DFF*`;
5. `dfflibmap` and `abc` with upstream `nangate45_sog.lib`;
6. `clean; write_verilog`;
7. apply the upstream cleaner-equivalent attribute/blank-line cleanup;
8. parse the cleaned BOG with Yosys.

## Leakage Rules

T70 uses generated RTL text and the existence of `code.syn.v` only as a sample
stratification label. It does not use final PPA, reference PPA, fitness, test
pass rate, hypervolume, Pareto rank, or archive score as descriptor inputs.

## Promotion Rule

T70 cannot be promoted as a QD result. It only unblocks a future RTL-native
descriptor technique. A future promoted method must:

- run the extractor on the candidate set used by the live method;
- define archive cells from pre-synthesis RTL/operator/timing-risk features;
- report candidate-level extraction failures;
- compare classic and QD on reference-complete PPA metrics.
