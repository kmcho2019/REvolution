from __future__ import annotations

import csv
import importlib.util
import sys
from pathlib import Path

import numpy as np

_SCRIPT = (
    Path(__file__).resolve().parent.parent.parent
    / "scripts"
    / "analyze_t33_qwen_embedding_diagnostics.py"
)
_SPEC = importlib.util.spec_from_file_location("analyze_t33_qwen_embedding_diagnostics", _SCRIPT)
assert _SPEC is not None and _SPEC.loader is not None
mod = importlib.util.module_from_spec(_SPEC)
sys.modules.setdefault("analyze_t33_qwen_embedding_diagnostics", mod)
_SPEC.loader.exec_module(mod)


def test_analyze_t33_embeddings_writes_collapse_tables(tmp_path: Path) -> None:
    root = tmp_path / "run"
    package = tmp_path / "package"
    root.mkdir()
    matrix = np.asarray(
        [
            [1.0, 0.0, 0.0],
            [0.9, 0.1, 0.0],
            [0.0, 1.0, 0.0],
        ],
        dtype=np.float32,
    )
    matrix = matrix / np.linalg.norm(matrix, axis=1, keepdims=True)
    embedding_path = root / "raw.npy"
    canonical_path = root / "canonical.npy"
    np.save(embedding_path, matrix)
    np.save(canonical_path, matrix)
    embedding_manifest = tmp_path / "embedding_manifest.csv"
    view_manifest = tmp_path / "view_manifest.csv"
    candidates = tmp_path / "candidates.csv"
    _write_embedding_manifest(embedding_manifest, embedding_path, canonical_path)
    _write_view_manifest(view_manifest)
    _write_candidates(candidates)

    code = mod.main(
        [
            "--embedding-manifest",
            str(embedding_manifest),
            "--view-manifest",
            str(view_manifest),
            "--candidates-csv",
            str(candidates),
            "--package-dir",
            str(package),
        ]
    )

    assert code == 0
    collapse = _read_csv(package / "tables" / "t33_collapse_diagnostics.csv")
    nearest = _read_csv(package / "tables" / "t33_nearest_neighbors.csv")
    stability = _read_csv(package / "tables" / "t33_view_stability.csv")

    assert collapse[0]["view"] == "raw_rtl"
    assert collapse[0]["same_problem_fraction"] == "0.666666667"
    assert len(nearest) == 6
    assert len(stability) == 1
    assert nearest[0]["nearest_sample_index"] == "1"


def _write_embedding_manifest(path: Path, raw_path: Path, canonical_path: Path) -> None:
    _write_csv(
        path,
        [
            {"view": "raw_rtl", "embedding_path": raw_path.as_posix()},
            {"view": "canonical_rtl", "embedding_path": canonical_path.as_posix()},
        ],
    )


def _write_view_manifest(path: Path) -> None:
    rows = [
        {"view": "canonical_rtl", "sample_index": "0"},
        {"view": "canonical_rtl", "sample_index": "1"},
        {"view": "canonical_rtl", "sample_index": "2"},
        {"view": "raw_rtl", "sample_index": "0"},
        {"view": "raw_rtl", "sample_index": "1"},
        {"view": "raw_rtl", "sample_index": "2"},
    ]
    _write_csv(path, rows)


def _write_candidates(path: Path) -> None:
    rows = []
    for index, problem in enumerate(["p0", "p0", "p1"]):
        rows.append(
            {
                "sample_index": str(index),
                "candidate_id": f"cand-{index}",
                "problem_id": problem,
                "corpus": "toy",
                "normalized_rtl_sha256": f"rtl-{index}",
                "canonical_netlist_hash": f"net-{index}",
                "motif_signature_hash": f"motif-{index}",
                "style_cluster": "assign",
            }
        )
    _write_csv(path, rows)


def _write_csv(path: Path, rows: list[dict[str, str]]) -> None:
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(rows[0]), lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def _read_csv(path: Path) -> list[dict[str, str]]:
    with path.open(encoding="utf-8", newline="") as handle:
        return list(csv.DictReader(handle))
