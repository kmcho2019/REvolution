#!/usr/bin/env python3
"""Embed T33 Qwen3 preprocessing views with chunked pooling."""

from __future__ import annotations

import argparse
import csv
import hashlib
import math
import time
from pathlib import Path
from typing import Callable

import numpy as np

Embedder = Callable[[list[str], str, int], np.ndarray]


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--view-manifest", required=True, type=Path)
    parser.add_argument("--output-root", required=True, type=Path)
    parser.add_argument("--package-dir", required=True, type=Path)
    parser.add_argument("--model-id", required=True)
    parser.add_argument("--batch-size", required=True, type=int)
    parser.add_argument("--chunk-max-chars", required=True, type=int)
    args = parser.parse_args(argv)

    embed_views(
        view_manifest=args.view_manifest,
        output_root=args.output_root,
        package_dir=args.package_dir,
        model_id=args.model_id,
        batch_size=args.batch_size,
        chunk_max_chars=args.chunk_max_chars,
        embedder=qwen_embed_texts,
    )
    return 0


def embed_views(
    view_manifest: Path,
    output_root: Path,
    package_dir: Path,
    model_id: str,
    batch_size: int,
    chunk_max_chars: int,
    embedder: Embedder,
) -> None:
    assert batch_size > 0
    assert chunk_max_chars > 0
    rows = read_rows(view_manifest)
    embedding_dir = output_root / "embeddings"
    embedding_dir.mkdir(parents=True, exist_ok=True)
    table_dir = package_dir / "tables"
    table_dir.mkdir(parents=True, exist_ok=True)

    manifest_rows = []
    chunk_summary_rows = []
    for view in sorted({row["view"] for row in rows}):
        view_rows = [row for row in rows if row["view"] == view]
        started = time.perf_counter()
        pooled, chunk_rows = embed_view(view_rows, model_id, batch_size, chunk_max_chars, embedder)
        output_path = embedding_dir / f"t33_{view}_embeddings.npy"
        np.save(output_path, pooled)
        seconds = time.perf_counter() - started
        manifest_rows.append(
            {
                "view": view,
                "model_id": model_id,
                "candidate_count": pooled.shape[0],
                "embedding_dims": pooled.shape[1],
                "chunk_count": len(chunk_rows),
                "chunk_max_chars": chunk_max_chars,
                "pooling": "sqrt_word_count_weighted_mean",
                "embedding_path": output_path.as_posix(),
                "embedding_sha256": sha256_file(output_path),
                "encode_seconds": f"{seconds:.3f}",
            }
        )
        chunk_summary_rows.extend(summary_for_view(view, chunk_rows))
        write_csv(embedding_dir / f"t33_{view}_chunk_manifest.csv", chunk_rows)

    write_csv(table_dir / "t33_embedding_cache_manifest.csv", manifest_rows)
    write_csv(table_dir / "t33_embedding_chunk_summary.csv", chunk_summary_rows)


def embed_view(
    rows: list[dict[str, str]],
    model_id: str,
    batch_size: int,
    chunk_max_chars: int,
    embedder: Embedder,
) -> tuple[np.ndarray, list[dict[str, object]]]:
    texts = []
    chunk_rows: list[dict[str, object]] = []
    candidate_chunks: list[list[int]] = []
    for row in rows:
        path = Path(row["output_path"])
        text = path.read_text(encoding="utf-8")
        indices = []
        for chunk in chunk_text(text, chunk_max_chars):
            indices.append(len(texts))
            texts.append(chunk)
            chunk_rows.append(
                {
                    "sample_index": row["sample_index"],
                    "candidate_id": row["candidate_id"],
                    "view": row["view"],
                    "chunk_index": len(indices) - 1,
                    "char_count": len(chunk),
                    "word_count": word_count(chunk),
                    "chunk_sha256": sha256_text(chunk),
                }
            )
        candidate_chunks.append(indices)

    chunk_embeddings = embedder(texts, model_id, batch_size)
    assert chunk_embeddings.ndim == 2
    pooled = [
        pool_chunks(chunk_embeddings[indices], [chunk_rows[index] for index in indices])
        for indices in candidate_chunks
    ]
    return np.asarray(pooled, dtype=np.float32), chunk_rows


def chunk_text(text: str, max_chars: int) -> list[str]:
    chunks = []
    current = ""
    for line in text.splitlines(keepends=True):
        if len(line) > max_chars:
            if current:
                chunks.append(current)
                current = ""
            chunks.extend(line[index : index + max_chars] for index in range(0, len(line), max_chars))
            continue
        if current and len(current) + len(line) > max_chars:
            chunks.append(current)
            current = line
            continue
        current += line
    if current:
        chunks.append(current)
    assert chunks
    return chunks


def pool_chunks(embeddings: np.ndarray, chunk_rows: list[dict[str, object]]) -> np.ndarray:
    weights = np.asarray([math.sqrt(int_field(row, "word_count")) for row in chunk_rows], dtype=np.float32)
    weights = weights / weights.sum()
    pooled = np.sum(embeddings * weights[:, None], axis=0)
    norm = np.linalg.norm(pooled)
    assert norm > 0.0
    return np.asarray(pooled / norm, dtype=np.float32)


def summary_for_view(view: str, rows: list[dict[str, object]]) -> list[dict[str, object]]:
    per_candidate: dict[str, int] = {}
    chars = []
    for row in rows:
        key = str(row["candidate_id"])
        per_candidate[key] = per_candidate.get(key, 0) + 1
        chars.append(int_field(row, "char_count"))
    chunk_counts = list(per_candidate.values())
    return [
        {
            "view": view,
            "candidate_count": len(per_candidate),
            "chunk_count": len(rows),
            "mean_chunks_per_candidate": f"{sum(chunk_counts) / len(chunk_counts):.3f}",
            "max_chunks_per_candidate": max(chunk_counts),
            "mean_chunk_chars": f"{sum(chars) / len(chars):.2f}",
            "max_chunk_chars": max(chars),
        }
    ]


def qwen_embed_texts(texts: list[str], model_id: str, batch_size: int) -> np.ndarray:
    torch = __import__("torch")
    sentence_module = __import__("sentence_transformers", fromlist=["SentenceTransformer"])
    sentence_transformer = sentence_module.SentenceTransformer

    device = "cuda" if torch.cuda.is_available() else "cpu"
    model = sentence_transformer(model_id, device=device)
    matrix = model.encode(
        texts,
        batch_size=batch_size,
        normalize_embeddings=True,
        show_progress_bar=True,
    )
    return np.asarray(matrix, dtype=np.float32)


def int_field(row: dict[str, object], key: str) -> int:
    value = row[key]
    assert isinstance(value, int)
    return value


def read_rows(path: Path) -> list[dict[str, str]]:
    with path.open(encoding="utf-8", newline="") as handle:
        rows = list(csv.DictReader(handle))
    assert rows
    return rows


def write_csv(path: Path, rows: list[dict[str, object]]) -> None:
    assert rows
    fieldnames = list(rows[0])
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames, lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def word_count(text: str) -> int:
    return max(1, len(text.split()))


def sha256_text(text: str) -> str:
    return hashlib.sha256(text.encode("utf-8")).hexdigest()


def sha256_file(path: Path) -> str:
    hasher = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            hasher.update(chunk)
    return hasher.hexdigest()


if __name__ == "__main__":
    raise SystemExit(main())
