# Probe Log

## 2026-06-25

- Single `Prob045_alu` Yosys export initially failed on X/Z values; adding
  `setundef -zero` allowed ASCII AIG export.
- The exported `Prob045_alu` AIG had about `2.7k` variables and exposed a
  slow DeepGate parser topological-sort path, so the full probe used a bounded
  `400`-variable policy.
- Small generated VerilogEval AIGs parsed and embedded through the official
  pretrained `python-deepgate` model. A two-candidate smoke had cosine
  `0.8249`, confirming the path was not inherently constant.
- Full bounded probe sampled `96` valid-PPA generated candidates, embedded
  `24`, and copied the compact results into this package.
