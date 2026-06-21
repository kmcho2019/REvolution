from __future__ import annotations

import importlib.util
import json
import sys
from pathlib import Path

import numpy as np
import pandas as pd


_SCRIPT = (
    Path(__file__).resolve().parents[2]
    / "scripts"
    / "run_rtl_diversity_wp1_qwen_common_audit.py"
)
_SPEC = importlib.util.spec_from_file_location(
    "run_rtl_diversity_wp1_qwen_common_audit",
    _SCRIPT,
)
assert _SPEC is not None
mod = importlib.util.module_from_spec(_SPEC)
sys.modules.setdefault("run_rtl_diversity_wp1_qwen_common_audit", mod)
assert _SPEC.loader is not None
_SPEC.loader.exec_module(mod)


def test_run_common_audit_with_fake_embedder(tmp_path: Path) -> None:
    audit = tmp_path / "audit.parquet"
    rtl_paths = []
    for index in range(4):
        path = tmp_path / f"candidate_{index}.sv"
        path.write_text(
            f"module top_{index}; assign y = a {'+' if index % 2 else '^'} b; endmodule\n",
            encoding="utf-8",
        )
        rtl_paths.append(path)

    ref = json.dumps({"area": 100.0, "power": 10.0, "eff_clk_period": 5.0})
    rows = []
    for index, path in enumerate(rtl_paths):
        rows.append(
            {
                "corpus": "toy",
                "method": "classic",
                "seed": 1,
                "model": "toy-model",
                "benchmark": "RTLLM",
                "problem_id": "RTLLM/toy",
                "generation": index,
                "candidate_id": f"cand-{index}",
                "rtl_path": path.as_posix(),
                "valid_ppa": True,
                "area": 100.0 - index,
                "power": 10.0 - index * 0.1,
                "eff_clk_period": 5.0 - index * 0.05,
                "fitness": float(index),
                "reference_ppa_json": ref,
                "canonical_netlist_hash": f"net-{index % 2}",
                "motif_signature_hash": f"motif-{index % 2}",
                "rtl_line_count": 1,
                "rtl_assign_count": 1,
                "rtl_always_count": 0,
                "rtl_case_count": 0,
                "rtl_if_count": 0,
                "rtl_ternary_count": 0,
                "rtl_nonblocking_count": 0,
                "rtl_blocking_count": 0,
                "rtl_add_count": int(index % 2 == 1),
                "rtl_mul_count": 0,
                "rtl_wire_count": 0,
                "rtl_reg_count": 0,
                "rtl_comment_count": 0,
            }
        )
    pd.DataFrame(rows).to_parquet(audit, index=False)

    def fake_embedder(texts: list[str], model_id: str, batch_size: int) -> np.ndarray:
        assert model_id == "fake"
        assert batch_size == 2
        return np.array(
            [[float(index), float(len(text) % 7), 1.0] for index, text in enumerate(texts)],
            dtype=np.float32,
        )

    summary = mod.run_common_audit(
        candidate_audit=audit,
        output_dir=tmp_path / "out",
        model_id="fake",
        max_candidates=4,
        per_problem_limit=4,
        text_max_chars=128,
        batch_size=2,
        retention_fraction=0.5,
        random_seed=0,
        embedder=fake_embedder,
    )

    assert summary["candidate_count"] == 4
    assert summary["embedding_shapes"]["qwen_raw"] == [4, 3]
    assert summary["replay_rows"] == 6
    assert (tmp_path / "out" / "qwen_common_audit_summary.json").is_file()
    assert (tmp_path / "out" / "qwen_raw_embeddings.npy").is_file()
    aggregate = pd.read_csv(tmp_path / "out" / "qwen_common_audit_aggregate.csv")
    assert set(aggregate["representation"]) == {
        "fitness_top",
        "generation_prefix",
        "lexical_farthest",
        "qwen_identifier_farthest",
        "qwen_raw_farthest",
        "random",
    }
