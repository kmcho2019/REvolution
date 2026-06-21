#!/usr/bin/env python3
# pyright: reportArgumentType=false, reportAttributeAccessIssue=false, reportCallIssue=false, reportGeneralTypeIssues=false, reportIndexIssue=false, reportMissingImports=false, reportReturnType=false
"""Run a larger Qwen3 common-audit embedding diagnostic."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import math
import re
import sys
from collections.abc import Callable
from pathlib import Path
from typing import Any

import numpy as np
import pandas as pd

REPO_ROOT = Path(__file__).resolve().parents[1]

try:
    from revolution.qd.pareto_analysis import (
        compute_candidate_improvements,
        hypervolume,
        objective_metrics_for_reference,
        pareto_front,
    )
except ModuleNotFoundError:
    _PARETO_PATH = REPO_ROOT / "src/revolution/qd/pareto_analysis.py"
    _SPEC = importlib.util.spec_from_file_location(
        "_rtl_diversity_pareto_analysis",
        _PARETO_PATH,
    )
    assert _SPEC is not None
    _PARETO = importlib.util.module_from_spec(_SPEC)
    sys.modules.setdefault("_rtl_diversity_pareto_analysis", _PARETO)
    assert _SPEC.loader is not None
    _SPEC.loader.exec_module(_PARETO)
    compute_candidate_improvements = _PARETO.compute_candidate_improvements
    hypervolume = _PARETO.hypervolume
    objective_metrics_for_reference = _PARETO.objective_metrics_for_reference
    pareto_front = _PARETO.pareto_front

DEFAULT_CANDIDATE_AUDIT = (
    REPO_ROOT
    / "exp/diversity_check/restarted_report_20260621_072933_UTC/candidate_audit.parquet"
)
DEFAULT_OUTPUT_DIR = REPO_ROOT / "exp/diversity_check/wp1_qwen_common_audit"
DEFAULT_MODEL_ID = "Qwen/Qwen3-Embedding-0.6B"
LEXICAL_FEATURES = (
    "rtl_line_count",
    "rtl_assign_count",
    "rtl_always_count",
    "rtl_case_count",
    "rtl_if_count",
    "rtl_ternary_count",
    "rtl_nonblocking_count",
    "rtl_blocking_count",
    "rtl_add_count",
    "rtl_mul_count",
    "rtl_wire_count",
    "rtl_reg_count",
    "rtl_comment_count",
)
VERILOG_KEYWORDS = {
    "always",
    "and",
    "assign",
    "begin",
    "case",
    "default",
    "else",
    "end",
    "endcase",
    "endmodule",
    "for",
    "if",
    "input",
    "logic",
    "module",
    "negedge",
    "or",
    "output",
    "posedge",
    "reg",
    "wire",
}


Embedder = Callable[[list[str], str, int], np.ndarray]
QWEN_MODEL_CACHE: dict[tuple[str, str], Any] = {}


def main(argv: list[str] | None = None) -> int:
    args = parse_args(argv)
    summary = run_common_audit(
        candidate_audit=args.candidate_audit,
        output_dir=args.output_dir,
        model_id=args.model_id,
        max_candidates=args.max_candidates,
        per_problem_limit=args.per_problem_limit,
        text_max_chars=args.text_max_chars,
        batch_size=args.batch_size,
        retention_fraction=args.retention_fraction,
        random_seed=args.random_seed,
        embedder=None,
    )
    print(json.dumps(summary, indent=2, sort_keys=True))
    return 0


def parse_args(argv: list[str] | None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--candidate-audit", type=Path, default=DEFAULT_CANDIDATE_AUDIT)
    parser.add_argument("--output-dir", type=Path, default=DEFAULT_OUTPUT_DIR)
    parser.add_argument("--model-id", default=DEFAULT_MODEL_ID)
    parser.add_argument("--max-candidates", type=int, default=768)
    parser.add_argument("--per-problem-limit", type=int, default=6)
    parser.add_argument("--text-max-chars", type=int, default=4096)
    parser.add_argument("--batch-size", type=int, default=16)
    parser.add_argument("--retention-fraction", type=float, default=0.5)
    parser.add_argument("--random-seed", type=int, default=0)
    return parser.parse_args(argv)


def run_common_audit(
    *,
    candidate_audit: Path,
    output_dir: Path,
    model_id: str,
    max_candidates: int,
    per_problem_limit: int,
    text_max_chars: int,
    batch_size: int,
    retention_fraction: float,
    random_seed: int,
    embedder: Embedder | None,
) -> dict[str, Any]:
    """Extract frozen Qwen embeddings and run common-audit replay controls."""

    assert max_candidates > 0
    assert per_problem_limit > 0
    assert text_max_chars > 0
    assert batch_size > 0
    assert 0.0 < retention_fraction <= 1.0

    output_dir.mkdir(parents=True, exist_ok=True)
    candidates = select_candidates(
        load_candidates(candidate_audit),
        max_candidates=max_candidates,
        per_problem_limit=per_problem_limit,
    )
    text_frame = text_variants(candidates, text_max_chars)
    embed = qwen_embed_texts if embedder is None else embedder
    embeddings = {
        "qwen_raw": embed(text_frame["raw_text"].tolist(), model_id, batch_size),
        "qwen_comment_stripped": embed(
            text_frame["comment_stripped_text"].tolist(),
            model_id,
            batch_size,
        ),
        "qwen_identifier_normalized": embed(
            text_frame["identifier_normalized_text"].tolist(),
            model_id,
            batch_size,
        ),
    }
    assert all(len(matrix) == len(candidates) for matrix in embeddings.values())

    lexical = lexical_matrix(candidates)
    stability = stability_rows(candidates, embeddings)
    nearest = nearest_rows(candidates, embeddings["qwen_raw"])
    replay = replay_rows(
        candidates,
        {
            "lexical_farthest": lexical,
            "qwen_raw_farthest": embeddings["qwen_raw"],
            "qwen_identifier_farthest": embeddings["qwen_identifier_normalized"],
        },
        retention_fraction=retention_fraction,
        random_seed=random_seed,
    )
    aggregate = aggregate_replay(replay)
    summary = summary_payload(
        candidate_audit=candidate_audit,
        output_dir=output_dir,
        candidates=candidates,
        text_frame=text_frame,
        embeddings=embeddings,
        stability=stability,
        nearest=nearest,
        replay=replay,
        aggregate=aggregate,
        model_id=model_id,
        max_candidates=max_candidates,
        per_problem_limit=per_problem_limit,
        text_max_chars=text_max_chars,
        retention_fraction=retention_fraction,
    )

    candidates.to_csv(output_dir / "qwen_common_audit_candidates.csv", index=False)
    stability.to_csv(output_dir / "qwen_common_audit_stability.csv", index=False)
    nearest.to_csv(output_dir / "qwen_common_audit_nearest.csv", index=False)
    replay.to_csv(output_dir / "qwen_common_audit_replay.csv", index=False)
    aggregate.to_csv(output_dir / "qwen_common_audit_aggregate.csv", index=False)
    for name, matrix in embeddings.items():
        np.save(output_dir / f"{name}_embeddings.npy", matrix)
    write_card(output_dir / "qwen_common_audit_card.md", summary)
    write_summary(output_dir / "qwen_common_audit_summary.json", summary)
    return summary


def load_candidates(path: Path) -> pd.DataFrame:
    assert path.is_file(), f"missing candidate audit: {path}"
    frame = pd.read_parquet(path) if path.suffix == ".parquet" else pd.read_csv(path)
    required = {
        "corpus",
        "method",
        "seed",
        "model",
        "benchmark",
        "problem_id",
        "generation",
        "candidate_id",
        "rtl_path",
        "valid_ppa",
        "area",
        "power",
        "eff_clk_period",
        "fitness",
        "reference_ppa_json",
        "canonical_netlist_hash",
        "motif_signature_hash",
        *LEXICAL_FEATURES,
    }
    missing = required.difference(frame.columns)
    assert not missing, f"candidate audit missing columns: {sorted(missing)}"
    return frame


def select_candidates(
    frame: pd.DataFrame,
    *,
    max_candidates: int,
    per_problem_limit: int,
) -> pd.DataFrame:
    valid = frame.loc[frame["valid_ppa"].astype(bool)].copy()
    valid["rtl_path"] = valid["rtl_path"].fillna("").astype(str)
    valid = valid.loc[valid["rtl_path"].map(lambda value: Path(value).is_file())]
    valid = valid.sort_values(
        ["corpus", "problem_id", "generation", "candidate_id"],
        kind="mergesort",
    )
    limited = valid.groupby(["corpus", "problem_id"], group_keys=False).head(
        per_problem_limit
    )
    assert not limited.empty, "no valid candidates with readable RTL"
    corpora = sorted(str(value) for value in limited["corpus"].unique())
    quota = max(1, math.ceil(max_candidates / len(corpora)))
    parts = [
        limited.loc[limited["corpus"].eq(corpus)].head(quota)
        for corpus in corpora
    ]
    selected = pd.concat(parts, ignore_index=False)
    if len(selected) < max_candidates:
        remaining = limited.drop(index=selected.index)
        selected = pd.concat(
            [selected, remaining.head(max_candidates - len(selected))],
            ignore_index=False,
        )
    selected = selected.head(max_candidates).copy().reset_index(drop=True)
    selected["sample_index"] = np.arange(len(selected), dtype=int)
    return selected


def text_variants(candidates: pd.DataFrame, text_max_chars: int) -> pd.DataFrame:
    rows = []
    for row in candidates.to_dict("records"):
        text = Path(str(row["rtl_path"])).read_text(encoding="utf-8", errors="ignore")
        rows.append(
            {
                "sample_index": int(row["sample_index"]),
                "candidate_id": row["candidate_id"],
                "raw_chars": len(text),
                "raw_text": text[:text_max_chars],
                "comment_stripped_text": strip_comments(text)[:text_max_chars],
                "identifier_normalized_text": normalize_identifiers(text)[
                    :text_max_chars
                ],
                "truncated": len(text) > text_max_chars,
            }
        )
    return pd.DataFrame(rows)


def qwen_embed_texts(texts: list[str], model_id: str, batch_size: int) -> np.ndarray:
    import torch
    from sentence_transformers import SentenceTransformer

    device = "cuda" if torch.cuda.is_available() else "cpu"
    cache_key = (model_id, device)
    if cache_key not in QWEN_MODEL_CACHE:
        QWEN_MODEL_CACHE[cache_key] = SentenceTransformer(model_id, device=device)
    model = QWEN_MODEL_CACHE[cache_key]
    matrix = model.encode(
        texts,
        batch_size=batch_size,
        normalize_embeddings=True,
        show_progress_bar=False,
    )
    return np.asarray(matrix, dtype=np.float32)


def strip_comments(text: str) -> str:
    without_block = re.sub(r"/\*.*?\*/", "", text, flags=re.DOTALL)
    return re.sub(r"//.*", "", without_block)


def normalize_identifiers(text: str) -> str:
    mapping: dict[str, str] = {}

    def replace(match: re.Match[str]) -> str:
        token = match.group(0)
        if token in VERILOG_KEYWORDS:
            return token
        if token not in mapping:
            mapping[token] = f"id_{len(mapping)}"
        return mapping[token]

    return re.sub(r"\b[A-Za-z_][A-Za-z0-9_$]*\b", replace, text)


def lexical_matrix(candidates: pd.DataFrame) -> np.ndarray:
    matrix = candidates.loc[:, LEXICAL_FEATURES].fillna(0.0).to_numpy(dtype=float)
    return standardize(matrix)


def standardize(matrix: np.ndarray) -> np.ndarray:
    mean = matrix.mean(axis=0)
    std = matrix.std(axis=0)
    std[std == 0.0] = 1.0
    return (matrix - mean) / std


def stability_rows(
    candidates: pd.DataFrame,
    embeddings: dict[str, np.ndarray],
) -> pd.DataFrame:
    raw = normalize_rows(embeddings["qwen_raw"])
    stripped = normalize_rows(embeddings["qwen_comment_stripped"])
    normalized = normalize_rows(embeddings["qwen_identifier_normalized"])
    rows = []
    for index, row in candidates.iterrows():
        rows.append(
            {
                "sample_index": int(row["sample_index"]),
                "candidate_id": row["candidate_id"],
                "corpus": row["corpus"],
                "problem_id": row["problem_id"],
                "raw_to_comment_cosine": float(np.dot(raw[index], stripped[index])),
                "raw_to_identifier_cosine": float(np.dot(raw[index], normalized[index])),
            }
        )
    return pd.DataFrame(rows)


def nearest_rows(candidates: pd.DataFrame, matrix: np.ndarray) -> pd.DataFrame:
    normalized = normalize_rows(matrix)
    cosine = normalized @ normalized.T
    np.fill_diagonal(cosine, -np.inf)
    nearest = cosine.argmax(axis=1)
    rows = []
    for index, row in candidates.iterrows():
        other = candidates.iloc[int(nearest[index])]
        rows.append(
            {
                "sample_index": int(row["sample_index"]),
                "candidate_id": row["candidate_id"],
                "nearest_candidate_id": other["candidate_id"],
                "nearest_cosine": float(cosine[index, nearest[index]]),
                "same_problem": bool(row["problem_id"] == other["problem_id"]),
                "same_corpus": bool(row["corpus"] == other["corpus"]),
                "same_canonical_netlist": same_nonempty(
                    row["canonical_netlist_hash"],
                    other["canonical_netlist_hash"],
                ),
                "same_motif_signature": same_nonempty(
                    row["motif_signature_hash"],
                    other["motif_signature_hash"],
                ),
            }
        )
    return pd.DataFrame(rows)


def same_nonempty(left: object, right: object) -> bool:
    left_text = "" if pd.isna(left) else str(left).strip()
    right_text = "" if pd.isna(right) else str(right).strip()
    return bool(left_text and right_text and left_text == right_text)


def replay_rows(
    candidates: pd.DataFrame,
    matrices: dict[str, np.ndarray],
    *,
    retention_fraction: float,
    random_seed: int,
) -> pd.DataFrame:
    rng = np.random.default_rng(random_seed)
    rows = []
    groups = candidates.groupby(["corpus", "method", "seed", "problem_id"], sort=True)
    for key, group in groups:
        if len(group) < 4:
            continue
        ordered = group.sort_values(["generation", "candidate_id"], kind="mergesort")
        positions = ordered["sample_index"].to_numpy(dtype=int)
        k = max(1, math.ceil(len(positions) * retention_fraction))
        selectors = {
            "generation_prefix": positions[:k],
            "random": np.sort(rng.choice(positions, size=k, replace=False)),
            "fitness_top": ordered.sort_values("fitness", ascending=False)
            .head(k)["sample_index"]
            .to_numpy(dtype=int),
        }
        for name, matrix in matrices.items():
            selectors[name] = positions[farthest_first(matrix[positions], k)]
        baseline_points = improvement_points(ordered)
        baseline_hv = hypervolume(baseline_points)
        baseline_pareto = len(pareto_front(baseline_points))
        for representation, selected_positions in selectors.items():
            selected = ordered.loc[ordered["sample_index"].isin(selected_positions)]
            selected_points = improvement_points(selected)
            corpus, method, seed, problem = key
            rows.append(
                {
                    "corpus": corpus,
                    "method": method,
                    "seed": int(seed),
                    "problem_id": problem,
                    "representation": representation,
                    "valid_ppa_count": int(len(ordered)),
                    "selected_count": int(len(selected)),
                    "baseline_hypervolume": baseline_hv,
                    "selected_hypervolume": hypervolume(selected_points),
                    "baseline_pareto_size": baseline_pareto,
                    "selected_pareto_size": len(pareto_front(selected_points)),
                    "baseline_best_fitness": numeric_max(ordered, "fitness"),
                    "selected_best_fitness": numeric_max(selected, "fitness"),
                    "unique_canonical_netlists": unique_nonempty(
                        selected,
                        "canonical_netlist_hash",
                    ),
                    "unique_motif_signatures": unique_nonempty(
                        selected,
                        "motif_signature_hash",
                    ),
                }
            )
    return pd.DataFrame(rows)


def farthest_first(matrix: np.ndarray, k: int) -> np.ndarray:
    if k >= len(matrix):
        return np.arange(len(matrix), dtype=int)
    selected = [0]
    distances = np.linalg.norm(matrix - matrix[0], axis=1)
    while len(selected) < k:
        distances[selected] = -1.0
        index = int(np.argmax(distances))
        selected.append(index)
        distances = np.minimum(distances, np.linalg.norm(matrix - matrix[index], axis=1))
    return np.array(selected, dtype=int)


def aggregate_replay(rows: pd.DataFrame) -> pd.DataFrame:
    aggregate = (
        rows.groupby("representation", as_index=False)
        .agg(
            problem_group_count=("problem_id", "count"),
            valid_ppa_count=("valid_ppa_count", "sum"),
            selected_count=("selected_count", "sum"),
            baseline_hypervolume=("baseline_hypervolume", "sum"),
            selected_hypervolume=("selected_hypervolume", "sum"),
            baseline_pareto_size=("baseline_pareto_size", "sum"),
            selected_pareto_size=("selected_pareto_size", "sum"),
            baseline_best_fitness=("baseline_best_fitness", "max"),
            selected_best_fitness=("selected_best_fitness", "max"),
            unique_canonical_netlists=("unique_canonical_netlists", "sum"),
            unique_motif_signatures=("unique_motif_signatures", "sum"),
        )
    )
    lexical = aggregate.loc[aggregate["representation"].eq("lexical_farthest")]
    if lexical.empty:
        aggregate["vs_lexical_hv_gain_fraction"] = 0.0
        aggregate["vs_lexical_pareto_gain_fraction"] = 0.0
        return aggregate
    lexical_row = lexical.iloc[0]
    aggregate["vs_lexical_hv_gain_fraction"] = (
        aggregate["selected_hypervolume"]
        - float(lexical_row["selected_hypervolume"])
    ) / max(float(lexical_row["selected_hypervolume"]), 1e-12)
    aggregate["vs_lexical_pareto_gain_fraction"] = (
        aggregate["selected_pareto_size"]
        - float(lexical_row["selected_pareto_size"])
    ) / max(float(lexical_row["selected_pareto_size"]), 1.0)
    return aggregate


def normalize_rows(matrix: np.ndarray) -> np.ndarray:
    norms = np.linalg.norm(matrix, axis=1, keepdims=True)
    norms[norms == 0.0] = 1.0
    return matrix / norms


def improvement_points(frame: pd.DataFrame) -> list[tuple[float, ...]]:
    points = []
    for row in frame.to_dict("records"):
        ref = reference_metrics(row)
        metrics = objective_metrics_for_reference(ref)
        improvements = compute_candidate_improvements(row, ref, metrics)
        if improvements is not None:
            points.append(tuple(improvements[metric] for metric in metrics))
    return points


def reference_metrics(row: dict[str, Any]) -> dict[str, float]:
    raw = row["reference_ppa_json"]
    if raw:
        payload = json.loads(str(raw))
        if payload:
            return {key: float(value) for key, value in payload.items()}
    return {
        "area": max(float(row["area"]) * 1.2, 1.0),
        "power": max(float(row["power"]) * 1.2, 1e-9),
        "eff_clk_period": max(float(row["eff_clk_period"]) * 1.2, 1e-9),
    }


def unique_nonempty(frame: pd.DataFrame, column: str) -> int:
    text = frame[column].fillna("").astype(str).str.strip()
    return int(text.loc[text.ne("") & text.ne("nan")].nunique())


def numeric_max(frame: pd.DataFrame, column: str) -> float | None:
    values = pd.to_numeric(frame[column], errors="coerce").dropna()
    return None if values.empty else float(values.max())


def summary_payload(
    *,
    candidate_audit: Path,
    output_dir: Path,
    candidates: pd.DataFrame,
    text_frame: pd.DataFrame,
    embeddings: dict[str, np.ndarray],
    stability: pd.DataFrame,
    nearest: pd.DataFrame,
    replay: pd.DataFrame,
    aggregate: pd.DataFrame,
    model_id: str,
    max_candidates: int,
    per_problem_limit: int,
    text_max_chars: int,
    retention_fraction: float,
) -> dict[str, Any]:
    qwen = aggregate.loc[aggregate["representation"].eq("qwen_raw_farthest")]
    if qwen.empty:
        verdict = "diagnostic_only_no_replay"
    else:
        row = qwen.iloc[0]
        verdict = (
            "diagnostic_candidate"
            if float(row["vs_lexical_hv_gain_fraction"]) >= 0.10
            else "diagnostic_only_no_proceed"
        )
    summary = {
        "version": 1,
        "model_id": model_id,
        "candidate_audit": candidate_audit.as_posix(),
        "out_dir": output_dir.as_posix(),
        "candidate_count": int(len(candidates)),
        "problem_count": int(candidates["problem_id"].nunique()),
        "corpus_counts": {
            str(key): int(value)
            for key, value in candidates["corpus"].value_counts().sort_index().items()
        },
        "max_candidates": max_candidates,
        "per_problem_limit": per_problem_limit,
        "text_max_chars": text_max_chars,
        "truncated_text_count": int(text_frame["truncated"].sum()),
        "embedding_shapes": {name: list(matrix.shape) for name, matrix in embeddings.items()},
        "stability": {
            "raw_to_comment_cosine_mean": float(stability["raw_to_comment_cosine"].mean()),
            "raw_to_identifier_cosine_mean": float(
                stability["raw_to_identifier_cosine"].mean()
            ),
        },
        "nearest": {
            "same_problem_fraction": float(nearest["same_problem"].mean()),
            "same_corpus_fraction": float(nearest["same_corpus"].mean()),
            "same_canonical_netlist_count": int(nearest["same_canonical_netlist"].sum()),
            "same_motif_signature_count": int(nearest["same_motif_signature"].sum()),
            "cosine_mean": float(nearest["nearest_cosine"].mean()),
        },
        "retention_fraction": retention_fraction,
        "replay_rows": int(len(replay)),
        "aggregate": aggregate.to_dict("records"),
        "leakage_policy": (
            "Frozen Qwen embeddings and lexical controls use RTL text/features only; "
            "PPA fields are used only after selection for replay evaluation."
        ),
        "verdict": verdict,
        "artifacts": {
            "candidates_csv": (output_dir / "qwen_common_audit_candidates.csv").as_posix(),
            "stability_csv": (output_dir / "qwen_common_audit_stability.csv").as_posix(),
            "nearest_csv": (output_dir / "qwen_common_audit_nearest.csv").as_posix(),
            "replay_csv": (output_dir / "qwen_common_audit_replay.csv").as_posix(),
            "aggregate_csv": (output_dir / "qwen_common_audit_aggregate.csv").as_posix(),
            "card_md": (output_dir / "qwen_common_audit_card.md").as_posix(),
        },
    }
    summary["artifact_sha256"] = {
        "qwen_common_audit_candidates.csv": sha256_file(
            output_dir / "qwen_common_audit_candidates.csv"
        )
        if (output_dir / "qwen_common_audit_candidates.csv").is_file()
        else "",
    }
    return summary


def write_summary(path: Path, summary: dict[str, Any]) -> None:
    artifact_paths = [
        "qwen_common_audit_candidates.csv",
        "qwen_common_audit_stability.csv",
        "qwen_common_audit_nearest.csv",
        "qwen_common_audit_replay.csv",
        "qwen_common_audit_aggregate.csv",
        "qwen_raw_embeddings.npy",
        "qwen_comment_stripped_embeddings.npy",
        "qwen_identifier_normalized_embeddings.npy",
        "qwen_common_audit_card.md",
    ]
    hashes = {
        name: sha256_file(path.parent / name)
        for name in artifact_paths
        if (path.parent / name).is_file()
    }
    summary["artifact_sha256"] = hashes
    path.write_text(json.dumps(summary, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    summary["artifact_sha256"][path.name] = sha256_file(path)
    path.write_text(json.dumps(summary, indent=2, sort_keys=True) + "\n", encoding="utf-8")


def write_card(path: Path, summary: dict[str, Any]) -> None:
    lines = [
        "# Qwen3 Common-Audit Diagnostic",
        "",
        f"- Model: `{summary['model_id']}`",
        f"- Candidates: {summary['candidate_count']} across {summary['problem_count']} problems",
        f"- Verdict: `{summary['verdict']}`",
        f"- Stability raw/comment mean: {summary['stability']['raw_to_comment_cosine_mean']:.4f}",
        f"- Stability raw/identifier mean: {summary['stability']['raw_to_identifier_cosine_mean']:.4f}",
        f"- Nearest-neighbor same-problem fraction: {summary['nearest']['same_problem_fraction']:.4f}",
        "",
        "## Replay Aggregate",
        "",
        markdown_table(summary["aggregate"]),
        "",
        "## Leakage Policy",
        "",
        summary["leakage_policy"],
    ]
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def markdown_table(rows: list[dict[str, Any]]) -> str:
    if not rows:
        return "_No rows._"
    columns = list(rows[0])
    lines = [
        "| " + " | ".join(columns) + " |",
        "| " + " | ".join("---" for _ in columns) + " |",
    ]
    for row in rows:
        lines.append("| " + " | ".join(str(row[column]) for column in columns) + " |")
    return "\n".join(lines)


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


if __name__ == "__main__":
    raise SystemExit(main())
