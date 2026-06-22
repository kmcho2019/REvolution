from __future__ import annotations

import csv
import importlib.util
import json
import sys
from pathlib import Path

import numpy as np
import pandas as pd

_SCRIPT = Path(__file__).resolve().parents[2] / "scripts" / "analyze_t33_qwen_replay.py"
_SPEC = importlib.util.spec_from_file_location("analyze_t33_qwen_replay", _SCRIPT)
assert _SPEC is not None and _SPEC.loader is not None
mod = importlib.util.module_from_spec(_SPEC)
sys.modules.setdefault("analyze_t33_qwen_replay", mod)
_SPEC.loader.exec_module(mod)


def test_analyze_t33_replay_writes_tables_and_figures(tmp_path: Path) -> None:
    candidates = tmp_path / "candidates.csv"
    embedding_manifest = tmp_path / "embeddings.csv"
    package_dir = tmp_path / "package"
    _write_candidates(candidates)
    _write_embeddings(embedding_manifest, tmp_path)

    code = mod.main(
        [
            "--embedding-manifest",
            str(embedding_manifest),
            "--candidates-csv",
            str(candidates),
            "--package-dir",
            str(package_dir),
            "--retention-fraction",
            "0.5",
            "--random-seed",
            "0",
        ]
    )

    assert code == 0
    aggregate = pd.read_csv(package_dir / "tables" / "t33_replay_aggregate.csv")
    front = pd.read_csv(package_dir / "tables" / "t33_ppa_front_metrics.csv")
    assert "t33_canonical_yosys_netlist_farthest" in set(aggregate["representation"])
    assert int(front.loc[front["representation"].eq("lexical_farthest"), "selected_count"].iloc[0]) == 2
    assert (package_dir / "figures" / "t33_hypervolume_by_view.png").read_bytes().startswith(b"\x89PNG")
    assert (package_dir / "figures" / "t33_raw_area_power_pareto_front.png").read_bytes().startswith(b"\x89PNG")


def _write_candidates(path: Path) -> None:
    ref = json.dumps({"area": 120.0, "power": 12.0, "eff_clk_period": 6.0})
    rows = []
    for index in range(4):
        rows.append(
            {
                "corpus": "toy",
                "method": "classic",
                "seed": 1,
                "model": "toy",
                "benchmark": "RTLLM",
                "problem_id": "toy/problem",
                "generation": index,
                "candidate_id": f"cand-{index}",
                "sample_index": index,
                "valid_ppa": True,
                "area": 100.0 - index,
                "power": 10.0 - index * 0.2,
                "eff_clk_period": 5.0 - index * 0.1,
                "fitness": float(index),
                "reference_ppa_json": ref,
                "canonical_netlist_hash": f"net-{index % 2}",
                "motif_signature_hash": f"motif-{index % 2}",
                "rtl_line_count": 10 + index,
                "rtl_assign_count": 1,
                "rtl_always_count": 0,
                "rtl_case_count": 0,
                "rtl_if_count": 0,
                "rtl_ternary_count": 0,
                "rtl_nonblocking_count": 0,
                "rtl_blocking_count": 0,
                "rtl_add_count": 0,
                "rtl_mul_count": 0,
                "rtl_wire_count": 1,
                "rtl_reg_count": 0,
                "rtl_comment_count": 0,
            }
        )
    pd.DataFrame(rows).to_csv(path, index=False)


def _write_embeddings(manifest_path: Path, root: Path) -> None:
    rows = []
    for view_index, view in enumerate(mod.T33_VIEWS):
        matrix = np.asarray(
            [[float(index == dim), float(index), float(view_index + 1)] for index, dim in enumerate([0, 1, 2, 0])],
            dtype=np.float32,
        )
        path = root / f"{view}.npy"
        np.save(path, matrix)
        rows.append({"view": view, "embedding_path": path.as_posix()})
    with manifest_path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=["view", "embedding_path"], lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)
