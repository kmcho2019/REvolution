# Runtime Hook Smoke Commands

Create the isolated RF timing environment:

```bash
uv venv exp/useful_bd_push/envs/masterrtl_rf_timing
uv pip install \
  --python exp/useful_bd_push/envs/masterrtl_rf_timing/bin/python \
  scikit-learn==1.3.0 \
  numpy==1.26.4 \
  networkx \
  joblib
```

Run the helper directly on the T70 parsed candidate:

```bash
PYTHONHASHSEED=0 uv run \
  --with scikit-learn==1.3.0 \
  --with numpy==1.26.4 \
  --with networkx \
  --with joblib \
  python scripts/extract_masterrtl_rf_timing_metrics.py \
  --master-root exp/external_repos/MasterRTL \
  --parse-dir exp/verification/t70_generated_rtl_extractor_smoke/t70_04_Prob015_multi_pipe_8bit_first_raw/masterrtl/parse \
  --stem t70_04_Prob015_multi_pipe_8bit_first_raw \
  --model exp/external_repos/MasterRTL/ML_model/saved_model/rfr_model.pkl \
  --output /tmp/t82_rf_smoke.json
```

Run the full evaluator smoke:

```bash
uv run python - <<'PY'
from pathlib import Path
from revolution.source_aligned_descriptor_evaluator import SourceAlignedRTLDescriptorEvaluator

code = Path("exp/useful_bd_push/t67_rtl_native_seeded_thought_20260623_170935_UTC/hard_tuning/rtl_native_seeded_thought_qd/seed_1001/openai_gpt-oss-120b/RTLLM/Prob015_multi_pipe_8bit/Gen0/g000_thought_0001/code_sample_0/code.sv")
evaluator = SourceAlignedRTLDescriptorEvaluator(include_rf_timing=True, timeout_seconds=120)
metrics = evaluator.extract_metrics(code_file_path=code, top_module_name="multi_pipe_8bit")
for key in (
    "source_aligned_rf_timing_path_count",
    "source_aligned_rf_timing_leaf_rows",
    "source_aligned_rf_timing_leaf_ids",
    "source_aligned_rf_timing_no_path_flag",
    "source_aligned_masterrtl_branching",
):
    print(key, metrics[key])
PY
```
