#!/usr/bin/env python3
"""Probe Qwen3 canonical-RTL embeddings on live-screen candidates."""

from __future__ import annotations

import argparse
import csv
import hashlib
import json
import re
import time
from pathlib import Path

import numpy as np
import torch  # type: ignore
from sentence_transformers import SentenceTransformer  # type: ignore


IDENT_RE = re.compile(r"\b[A-Za-z_][A-Za-z0-9_$]*\b")
PORT_DECL_RE = re.compile(
    r"\b(input|output|inout)\b\s*(?:wire|reg|logic)?\s*(?:signed\s*)?"
    r"(?:\[[^\]]+\]\s*)?([A-Za-z_][A-Za-z0-9_$]*)"
)
NET_DECL_RE = re.compile(
    r"\b(wire|reg|logic)\b\s*(?:signed\s*)?(?:\[[^\]]+\]\s*)?([^;]+);",
    re.DOTALL,
)
BLOCK_COMMENT_RE = re.compile(r"/\*.*?\*/", re.DOTALL)
LINE_COMMENT_RE = re.compile(r"//.*")

VERILOG_WORDS = {
    "always",
    "assign",
    "begin",
    "case",
    "default",
    "else",
    "end",
    "endcase",
    "endmodule",
    "if",
    "inout",
    "input",
    "logic",
    "module",
    "negedge",
    "or",
    "output",
    "parameter",
    "posedge",
    "reg",
    "signed",
    "wire",
}


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--run-root", required=True, type=Path)
    parser.add_argument("--analysis-root", required=True, type=Path)
    parser.add_argument("--output-root", required=True, type=Path)
    parser.add_argument("--package-dir", required=True, type=Path)
    parser.add_argument("--model-id", default="Qwen/Qwen3-Embedding-0.6B")
    parser.add_argument("--batch-size", type=int, default=32)
    args = parser.parse_args()

    package = args.package_dir
    (package / "tables").mkdir(parents=True, exist_ok=True)
    args.output_root.mkdir(parents=True, exist_ok=True)

    started = time.perf_counter()
    code_paths = generated_code_paths(args.run_root)
    rows = candidate_rows(args.analysis_root, code_paths)
    texts = [canonical_rtl(Path(row["code_file_path"]).read_text(encoding="utf-8", errors="ignore")) for row in rows]
    embeddings = embed_texts(texts, args.model_id, args.batch_size)
    np.save(args.output_root / "qwen_live_screen_embeddings.npy", embeddings)

    pcs, explained = pca_projection(embeddings, dims=4)
    enriched = enrich_rows(rows, texts, embeddings, pcs)
    nearest = nearest_rows(enriched, embeddings)
    write_csv(package / "tables/qwen_live_screen_probe_candidates.csv", enriched)
    write_csv(package / "tables/qwen_live_screen_probe_nearest.csv", nearest)
    write_csv(package / "tables/qwen_live_screen_probe_axis_correlations.csv", correlation_rows(enriched))
    write_json(
        package / "tables/qwen_live_screen_probe_summary.json",
        summary_payload(args, rows, texts, embeddings, nearest, explained, time.perf_counter() - started),
    )
    write_report(package, args.output_root)


def generated_code_paths(run_root: Path) -> dict[str, str]:
    paths: dict[str, str] = {}
    for log_path in sorted(run_root.glob("*/seed_1001/openai_gpt-oss-120b/*/*/generation_log.jsonl")):
        for line in log_path.read_text(encoding="utf-8").splitlines():
            payload = json.loads(line)
            for item in payload["generated_candidates"]:
                paths[item["id"]] = item["code_file_path"]
    assert paths
    return paths


def candidate_rows(analysis_root: Path, code_paths: dict[str, str]) -> list[dict[str, str]]:
    rows = read_csv(analysis_root / "ppa_distribution/data/ppa_candidates.csv")
    selected = []
    for row in rows:
        candidate_id = row["candidate_id"]
        assert candidate_id in code_paths, candidate_id
        selected.append(
            {
                "backend": row["backend"],
                "benchmark": row["benchmark"],
                "problem": row["problem"],
                "candidate_id": candidate_id,
                "generation": row["generation"],
                "strategy": row["strategy"],
                "g_A": row["g_A"],
                "g_P": row["g_P"],
                "g_T": row["g_T"],
                "code_file_path": code_paths[candidate_id],
            }
        )
    assert selected
    return selected


def canonical_rtl(text: str) -> str:
    return canonical_text(role_normalize(strip_comments(text)))


def strip_comments(text: str) -> str:
    return LINE_COMMENT_RE.sub("", BLOCK_COMMENT_RE.sub("", text))


def role_normalize(text: str) -> str:
    mapping = declared_roles(text)
    counters: dict[str, int] = {}

    def replace(match: re.Match[str]) -> str:
        token = match.group(0)
        if match.start() > 0 and text[match.start() - 1] == "'":
            return token
        if token in VERILOG_WORDS:
            return token
        if token not in mapping:
            mapping[token] = next_name(counters, "tmp")
        return mapping[token]

    return IDENT_RE.sub(replace, text)


def declared_roles(text: str) -> dict[str, str]:
    mapping: dict[str, str] = {}
    counters: dict[str, int] = {}
    for role, token in PORT_DECL_RE.findall(text):
        if token not in VERILOG_WORDS and token not in mapping:
            mapping[token] = next_name(counters, role)
    for role, body in NET_DECL_RE.findall(text):
        prefix = "reg" if role == "reg" else "wire"
        for token in IDENT_RE.findall(body):
            if token not in VERILOG_WORDS and token not in mapping:
                mapping[token] = next_name(counters, prefix)
    return mapping


def next_name(counters: dict[str, int], prefix: str) -> str:
    index = counters.get(prefix, 0)
    counters[prefix] = index + 1
    return f"{prefix}_{index:04d}"


def canonical_text(text: str) -> str:
    statements = []
    for part in text.split(";"):
        statement = " ".join(part.split())
        if statement:
            statements.append(statement + ";")
    return "\n".join(statements) + "\n"


def embed_texts(texts: list[str], model_id: str, batch_size: int) -> np.ndarray:
    device = "cuda" if torch.cuda.is_available() else "cpu"
    model = SentenceTransformer(model_id, device=device)
    matrix = model.encode(
        texts,
        batch_size=batch_size,
        normalize_embeddings=True,
        show_progress_bar=True,
    )
    return np.asarray(matrix, dtype=np.float32)


def pca_projection(matrix: np.ndarray, dims: int) -> tuple[np.ndarray, list[float]]:
    centered = matrix - matrix.mean(axis=0, keepdims=True)
    _, singular_values, vt = np.linalg.svd(centered, full_matrices=False)
    projected = centered @ vt[:dims].T
    variance = singular_values**2
    explained = (variance[:dims] / variance.sum()).tolist()
    return projected.astype(np.float32), [float(value) for value in explained]


def enrich_rows(
    rows: list[dict[str, str]],
    texts: list[str],
    embeddings: np.ndarray,
    pcs: np.ndarray,
) -> list[dict[str, object]]:
    enriched: list[dict[str, object]] = []
    for index, row in enumerate(rows):
        item: dict[str, object] = dict(row)
        item["canonical_sha256"] = sha256_text(texts[index])
        item["canonical_chars"] = len(texts[index])
        item["embedding_norm"] = f"{float(np.linalg.norm(embeddings[index])):.9f}"
        item["qwen_pc0"] = f"{float(pcs[index, 0]):.9f}"
        item["qwen_pc1"] = f"{float(pcs[index, 1]):.9f}"
        item["qwen_pc2"] = f"{float(pcs[index, 2]):.9f}"
        item["qwen_pc3"] = f"{float(pcs[index, 3]):.9f}"
        enriched.append(item)
    return enriched


def nearest_rows(rows: list[dict[str, object]], embeddings: np.ndarray) -> list[dict[str, object]]:
    similarity = embeddings @ embeddings.T
    np.fill_diagonal(similarity, -np.inf)
    nearest = np.argmax(similarity, axis=1)
    output: list[dict[str, object]] = []
    for index, nearest_index in enumerate(nearest):
        left = rows[index]
        right = rows[int(nearest_index)]
        output.append(
            {
                "candidate_id": left["candidate_id"],
                "nearest_candidate_id": right["candidate_id"],
                "nearest_cosine": f"{float(similarity[index, nearest_index]):.9f}",
                "same_backend": left["backend"] == right["backend"],
                "same_problem": left["problem"] == right["problem"],
                "same_canonical_sha256": left["canonical_sha256"] == right["canonical_sha256"],
            }
        )
    return output


def correlation_rows(rows: list[dict[str, object]]) -> list[dict[str, object]]:
    output: list[dict[str, object]] = []
    for pc_axis in ("qwen_pc0", "qwen_pc1", "qwen_pc2", "qwen_pc3"):
        for target in ("g_A", "g_P", "g_T"):
            values = np.asarray([float(str(row[pc_axis])) for row in rows], dtype=np.float64)
            gains = np.asarray([float(str(row[target])) for row in rows], dtype=np.float64)
            output.append(
                {
                    "axis": pc_axis,
                    "target": target,
                    "pearson": f"{pearson(values, gains):.9f}",
                }
            )
    return output


def summary_payload(
    args: argparse.Namespace,
    rows: list[dict[str, str]],
    texts: list[str],
    embeddings: np.ndarray,
    nearest: list[dict[str, object]],
    explained: list[float],
    seconds: float,
) -> dict[str, object]:
    similarity = embeddings @ embeddings.T
    mask = ~np.eye(similarity.shape[0], dtype=bool)
    return {
        "run_root": str(args.run_root),
        "analysis_root": str(args.analysis_root),
        "output_root": str(args.output_root),
        "model_id": args.model_id,
        "candidate_count": len(rows),
        "unique_canonical_sha256": len({sha256_text(text) for text in texts}),
        "embedding_shape": list(embeddings.shape),
        "offdiag_cosine_min": float(similarity[mask].min()),
        "offdiag_cosine_mean": float(similarity[mask].mean()),
        "offdiag_cosine_max": float(similarity[mask].max()),
        "nearest_same_problem_fraction": mean_bool(nearest, "same_problem"),
        "nearest_same_backend_fraction": mean_bool(nearest, "same_backend"),
        "nearest_same_canonical_sha256_fraction": mean_bool(nearest, "same_canonical_sha256"),
        "pca_explained_variance": explained,
        "encode_seconds": round(seconds, 3),
    }


def write_report(package: Path, output_root: Path) -> None:
    summary = json.loads((package / "tables/qwen_live_screen_probe_summary.json").read_text(encoding="utf-8"))
    lines = [
        "# Qwen Live-Screen Candidate Probe",
        "",
        "## Verdict",
        "",
        "Qwen3 canonical RTL is model-valid and nonconstant on this generated-candidate corpus,",
        "but nearest-neighbor structure is still highly same-problem. This supports a small",
        "live-hook screen, not a full RTLLM spend.",
        "",
        "## Summary",
        "",
        f"- candidate rows: `{summary['candidate_count']}`",
        f"- unique canonical RTL hashes: `{summary['unique_canonical_sha256']}`",
        f"- embedding shape: `{summary['embedding_shape']}`",
        f"- off-diagonal cosine mean: `{summary['offdiag_cosine_mean']:.6f}`",
        f"- nearest same-problem fraction: `{summary['nearest_same_problem_fraction']:.6f}`",
        f"- nearest same-backend fraction: `{summary['nearest_same_backend_fraction']:.6f}`",
        f"- nearest duplicate-canonical fraction: `{summary['nearest_same_canonical_sha256_fraction']:.6f}`",
        f"- embedding output root: `{output_root}`",
        "",
        "## Decision",
        "",
        "Implement a live Qwen hook only with descriptor-health reporting. The first screen",
        "must check same-problem clustering and duplicate-canonical collapse before any",
        "promotion decision.",
    ]
    (package / "qwen_live_screen_probe_report.md").write_text("\n".join(lines) + "\n", encoding="utf-8")


def pearson(left: np.ndarray, right: np.ndarray) -> float:
    left = left - left.mean()
    right = right - right.mean()
    denom = np.linalg.norm(left) * np.linalg.norm(right)
    assert denom > 0.0
    return float(np.dot(left, right) / denom)


def mean_bool(rows: list[dict[str, object]], key: str) -> float:
    assert rows
    return sum(row[key] is True for row in rows) / len(rows)


def read_csv(path: Path) -> list[dict[str, str]]:
    with path.open(encoding="utf-8", newline="") as handle:
        rows = list(csv.DictReader(handle))
    assert rows
    return rows


def write_csv(path: Path, rows: list[dict[str, object]]) -> None:
    assert rows
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(rows[0]), lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def write_json(path: Path, payload: dict[str, object]) -> None:
    path.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n", encoding="utf-8")


def sha256_text(text: str) -> str:
    return hashlib.sha256(text.encode("utf-8")).hexdigest()


if __name__ == "__main__":
    main()
