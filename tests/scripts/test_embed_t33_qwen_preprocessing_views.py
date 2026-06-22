from __future__ import annotations

import csv
import importlib.util
import sys
from pathlib import Path

import numpy as np

_SCRIPT = (
    Path(__file__).resolve().parent.parent.parent
    / "scripts"
    / "embed_t33_qwen_preprocessing_views.py"
)
_SPEC = importlib.util.spec_from_file_location("embed_t33_qwen_preprocessing_views", _SCRIPT)
assert _SPEC is not None and _SPEC.loader is not None
mod = importlib.util.module_from_spec(_SPEC)
sys.modules.setdefault("embed_t33_qwen_preprocessing_views", mod)
_SPEC.loader.exec_module(mod)


def test_embed_t33_views_pools_chunks_and_writes_manifests(tmp_path: Path) -> None:
    view_manifest = tmp_path / "views.csv"
    package_dir = tmp_path / "package"
    output_root = tmp_path / "run"
    view_a = tmp_path / "a.txt"
    view_b = tmp_path / "b.txt"
    view_a.write_text("alpha beta\n" * 4, encoding="utf-8")
    view_b.write_text("gamma delta\n" * 2, encoding="utf-8")
    _write_view_manifest(view_manifest, view_a, view_b)

    mod.embed_views(
        view_manifest=view_manifest,
        output_root=output_root,
        package_dir=package_dir,
        model_id="fake",
        batch_size=2,
        chunk_max_chars=12,
        embedder=_fake_embedder,
    )

    manifest = _read_csv(package_dir / "tables" / "t33_embedding_cache_manifest.csv")
    summary = _read_csv(package_dir / "tables" / "t33_embedding_chunk_summary.csv")
    matrix = np.load(output_root / "embeddings" / "t33_raw_rtl_embeddings.npy")

    assert manifest[0]["view"] == "raw_rtl"
    assert manifest[0]["candidate_count"] == "2"
    assert summary[0]["max_chunks_per_candidate"] == "4"
    assert matrix.shape == (2, 3)
    assert np.allclose(np.linalg.norm(matrix, axis=1), 1.0)


def _fake_embedder(texts: list[str], model_id: str, batch_size: int) -> np.ndarray:
    assert model_id == "fake"
    assert batch_size == 2
    rows = []
    for text in texts:
        rows.append([float(len(text)), float(text.count("a")), 1.0])
    matrix = np.asarray(rows, dtype=np.float32)
    return matrix / np.linalg.norm(matrix, axis=1, keepdims=True)


def _write_view_manifest(path: Path, view_a: Path, view_b: Path) -> None:
    rows = [
        {
            "sample_index": "0",
            "candidate_id": "cand-0",
            "view": "raw_rtl",
            "output_path": view_a.as_posix(),
        },
        {
            "sample_index": "1",
            "candidate_id": "cand-1",
            "view": "raw_rtl",
            "output_path": view_b.as_posix(),
        },
    ]
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(rows[0]), lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def _read_csv(path: Path) -> list[dict[str, str]]:
    with path.open(encoding="utf-8", newline="") as handle:
        return list(csv.DictReader(handle))
