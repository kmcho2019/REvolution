# Model Smoke Commands

Run from `/workspace`.

## Qwen3

```bash
exp/diversity_check/encoder_envs/qwen3_probe/bin/python - <<'PY'
import json
import numpy as np
import torch
from sentence_transformers import SentenceTransformer

model_id = "Qwen/Qwen3-Embedding-0.6B"
device = "cuda" if torch.cuda.is_available() else "cpu"
model = SentenceTransformer(model_id, device=device)
texts = [
    "module top(input a, input b, output y); assign y = a & b; endmodule",
    "module top(input a, input b, output y); assign y = a | b; endmodule",
    "module top(input clk, input d, output reg q); always @(posedge clk) q <= d; endmodule",
    "module top(input [7:0] a, input [7:0] b, output [8:0] y); assign y = a + b; endmodule",
]
emb = np.asarray(model.encode(texts, batch_size=4, normalize_embeddings=True), dtype=np.float32)
sim = emb @ emb.T
print(json.dumps({
    "model_id": model_id,
    "device": device,
    "shape": list(emb.shape),
    "offdiag_cosine_mean": float(sim[~np.eye(sim.shape[0], dtype=bool)].mean()),
}, indent=2, sort_keys=True))
PY
```

Observed: model loads on CUDA, returns `4x1024` embeddings, and the toy RTL
off-diagonal cosine mean is `0.6888227462768555`.

## DeepGate2 Official Path

```bash
cd exp/diversity_check/encoder_sources/python-deepgate
/workspace/exp/diversity_check/encoder_envs/deepgate3_probe/bin/python - <<'PY'
import json
import numpy as np
import torch
import deepgate

model = deepgate.Model()
model.load_pretrained()
parser = deepgate.AigParser()
paths = ["examples/b05_comb.aig", "examples/test.aiger", "examples/mult.aag"]
embeddings = []
rows = []
for path in paths:
    graph = parser.read_aiger(path)
    hs, hf = model(graph)
    pooled = torch.cat([hs.mean(dim=0), hf.mean(dim=0)]).detach().cpu().numpy()
    embeddings.append(pooled / np.linalg.norm(pooled))
    rows.append({"path": path, "nodes": int(len(graph.gate)), "hs_shape": list(hs.shape), "hf_shape": list(hf.shape)})
emb = np.asarray(embeddings, dtype=np.float32)
sim = emb @ emb.T
print(json.dumps({
    "deepgate_version": getattr(deepgate, "__version__", "unknown"),
    "torch": torch.__version__,
    "cuda_available": torch.cuda.is_available(),
    "rows": rows,
    "offdiag_cosine_mean": float(sim[~np.eye(sim.shape[0], dtype=bool)].mean()),
}, indent=2, sort_keys=True))
PY
```

Observed: official pretrained path works on shipped examples, with pooled
off-diagonal cosine mean `0.9657183289527893`. This does not clear the
generated-candidate bridge, which previously collapsed.

## MasterRTL

```bash
exp/venvs/rtl_native_verify/bin/python \
  docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T76_masterrtl_pretrained_model_gate/tools/verify_masterrtl_pretrained_models.py
```

Observed: the isolated env has `sklearn`, `xgboost`, and `joblib`; the T76
summary reports five loaded model rows. The repo `uv` env is not sufficient
for this script because it lacks `sklearn`.
