# RTL Diversity Check Encoder Method Cards

Status: first-pass bounded diagnostics from the restarted WP1 run. These cards
summarize current evidence only; they do not promote any encoder as an in-loop
behavior descriptor.

## Qwen3 RTL Text Encoder

- Encoder id: `qwen3_rtl_text`.
- Model: `Qwen/Qwen3-Embedding-0.6B`.
- Environment:
  `exp/diversity_check/encoder_envs/qwen3_probe`, Python 3.11,
  `torch==2.6.0+cu124`, `transformers==5.12.1`,
  `sentence_transformers==5.6.0`.
- Device: `NVIDIA RTX A6000`.
- Dependency result: the first install pulled `torch==2.12.1+cu130`, which was
  incompatible with the host 550.90.07 driver. Reinstalling
  `torch==2.6.0+cu124` from the PyTorch CUDA 12.4 wheel index made CUDA work.
- Input artifacts: RTL text from
  `exp/diversity_check/full_20260620/candidate_audit.csv`.
- Bounded slice: 15 valid-PPA candidates, first three usable rows from each
  available `(corpus, benchmark)` stratum:
  `rtllm_gen20/RTLLM`, `auto_bd_standard_results/RTLLM`,
  `auto_bd_standard_results/VerilogEval-Spec-to-RTL`,
  `aspdac2026_release/RTLLM`, and
  `aspdac2026_release/VerilogEval-Spec-to-RTL`.
- Variants embedded: raw RTL, comment-stripped RTL, identifier-normalized RTL,
  and Yosys-normalized RTL.
- Main artifacts:
  `exp/diversity_check/qwen3_probe_20260621_032811_UTC/` and
  `exp/diversity_check/qwen3_yosys_probe_20260621_033323_UTC/`.
- Extraction result: success. Raw/comment/identifier run embedded 45 texts
  with shape `[45, 1024]`; Yosys-normalized run embedded 15 texts with shape
  `[15, 1024]`.
- Runtime: initial model load 24.673 s; raw/comment/identifier encode 0.816 s;
  cached Yosys run model load 6.919 s and encode 0.662 s.
- Stability:
  raw-to-comment/identifier mean `0.7481`, minimum `0.512646`;
  raw-to-Yosys min/mean/max `0.7913 / 0.8624 / 0.9307`.
- Non-collapse:
  raw pairwise cosine min/mean/max `0.3860 / 0.5835 / 0.9862`; the smoke does
  not collapse globally.
- Duplicate/netlist signal:
  9 of 15 raw nearest neighbors shared canonical netlist hash; 6 of 15 shared
  normalized RTL hash.
- Leakage risks: identifier erasure changes embeddings sharply, so naming,
  formatting, comments, and problem/corpus signatures can leak into distances.
- Interpretability: moderate. Nearest-neighbor tables can be inspected against
  RTL/netlist hashes, but embedding dimensions are not hardware-native.
- Common-audit status: not done. Current evidence is a bounded smoke, not a
  descriptor-family comparison on the full audit table.
- Verdict: diagnostic-only proceed. Qwen3 is worth a larger common-audit run
  with leakage controls, but current evidence does not support predictive or
  in-loop use.

## DeepGate3 AIG Encoder

- Encoder id: `deepgate3_aig`.
- Source: official DeepGate3 clone at
  `exp/diversity_check/encoder_sources/DeepGate3`, commit
  `908516a4f5ca02f4530a452743d9a0dc15b13f08`.
- Supporting source: `python-deepgate` clone at
  `exp/diversity_check/encoder_sources/python-deepgate`, commit
  `173db7529cefc97f7b9b2b3fa97ec1bd5773754d`.
- Environment:
  `exp/diversity_check/encoder_envs/deepgate3_probe`, Python 3.8,
  `torch==2.2.1+cu121`, `torch_geometric==2.5.2`, PyG CUDA 12.1 extension
  wheels, and `deepgate==2.0.1` installed from source.
- Device: `NVIDIA RTX A6000`.
- Dependency result: source install and imports work with a local
  `mamba_ssm.Mamba` stub. The pinned `mamba-ssm==1.2.0.post1` build failed
  because `nvcc` is absent.
- Input artifacts: same 15-candidate bounded Qwen slice.
- Graph export:
  Yosys `read_verilog -sv`, `hierarchy -auto-top`, `proc`, `flatten`, `opt`,
  `techmap`, `aigmap`, `opt_clean`, and `write_aiger -ascii -symbols`.
- Graph-state policy: combinational AIG only; latch-bearing AIGER rejected;
  no cone splitting in this smoke.
- AIG artifacts:
  `exp/diversity_check/deepgate3_aig_probe_20260621_034421_UTC/`.
- Export result: 9 AIGER exports, 6 latch-free parses, 3 latch-bearing AIGER
  rejections, and 6 sequential/DFFE export failures.
- Embedding artifacts:
  `exp/diversity_check/deepgate3_tokenizer_probe_20260621_034921_UTC/`.
- Extraction result: checkpoint-compatible tokenizer path embedded 3 nontrivial
  adder graphs with shape `[3, 256]`; 3 zero-node constant-output graphs were
  skipped.
- Runtime: model load 0.248 s; encode 0.381 s.
- Checkpoint caveat:
  `trained/dg2_100p.pth` contains DeepGate3 checkpoint keys, while
  `trained/model_last.pth` contains DeepGate2 tokenizer keys. The shipped
  DeepGate3 checkpoint has hop/path transformer weights but no
  `transformer.*` weights for the `plain` architecture.
- Non-collapse: fail on the bounded nontrivial slice. Pairwise cosine
  min/mean/max was `0.999968 / 0.999971 / 0.999976`.
- Leakage risks: graph export drops high-level RTL names/comments, but the
  current combinational-only policy excludes or rejects much of the sequential
  RTL evidence.
- Interpretability: moderate for graph coverage and node counts; weak for the
  collapsed embedding distances in this smoke.
- Common-audit status: not done. The current parsed graph count is too small
  and too same-problem to compare as a descriptor family.
- Verdict: diagnostic-only no-proceed for current form. DeepGate3 setup is no
  longer unattempted, but it needs a sequential/cone policy and a non-collapsed
  larger slice before it can be considered useful.
