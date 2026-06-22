#!/usr/bin/env python3
"""Package the T33 Qwen3 preprocessing-ladder source inventory."""

from __future__ import annotations

import argparse
import csv
import hashlib
import json
from pathlib import Path
from typing import Any

LIVE_QWEN_FILES = (
    ("qwen_common_audit_summary.json", "prior T06 summary"),
    ("qwen_common_audit_aggregate.csv", "prior selection aggregate"),
    ("qwen_common_audit_nearest.csv", "nearest-neighbor diagnostics"),
    ("qwen_common_audit_stability.csv", "preprocessing stability diagnostics"),
    ("qwen_common_audit_replay.csv", "selection replay rows"),
    ("qwen_common_audit_candidates.csv", "candidate metadata"),
    ("qwen_common_audit_card.md", "human-readable diagnostic card"),
    ("qwen_raw_embeddings.npy", "raw RTL embeddings"),
    ("qwen_comment_stripped_embeddings.npy", "commentless RTL embeddings"),
    ("qwen_identifier_normalized_embeddings.npy", "identifier-role embeddings"),
)

COMPILED_FILES = (
    ("stage_results/wp1_qwen/qwen_common_audit_summary.json", "committed T06 summary"),
    ("stage_results/wp1_qwen/qwen_common_audit_aggregate.csv", "committed T06 aggregate"),
    ("stage_results/wp1_qwen/qwen3_probe_summary.json", "older Qwen3 probe summary"),
    ("stage_results/wp1_qwen/qwen3_yosys_summary.json", "older Yosys stability summary"),
    (
        "scripts/processing/run_rtl_diversity_wp1_qwen_common_audit.py",
        "committed Qwen audit script",
    ),
)


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--qwen-dir", required=True, type=Path)
    parser.add_argument("--compiled-bundle-dir", required=True, type=Path)
    parser.add_argument("--output-dir", required=True, type=Path)
    args = parser.parse_args(argv)

    write_inventory(args.qwen_dir, args.compiled_bundle_dir, args.output_dir)
    print(f"Packaged T33 inventory into {args.output_dir}")
    return 0


def write_inventory(qwen_dir: Path, compiled_bundle_dir: Path, output_dir: Path) -> None:
    summary = load_summary(qwen_dir)
    table_dir = output_dir / "tables"
    table_dir.mkdir(parents=True, exist_ok=True)
    write_csv(table_dir / "t33_source_inventory.csv", inventory_rows(qwen_dir, compiled_bundle_dir))
    write_csv(table_dir / "t33_prior_qwen_summary.csv", summary_rows(summary))
    write_csv(table_dir / "t33_preprocessing_ladder_plan.csv", ladder_plan_rows())


def inventory_rows(qwen_dir: Path, compiled_bundle_dir: Path) -> list[dict[str, object]]:
    rows = []
    for relative_path, role in LIVE_QWEN_FILES:
        rows.append(file_row("live_qwen_dir", qwen_dir / relative_path, role))
    for relative_path, role in COMPILED_FILES:
        rows.append(file_row("compiled_bundle", compiled_bundle_dir / relative_path, role))
    return rows


def file_row(source_group: str, path: Path, role: str) -> dict[str, object]:
    assert path.is_file(), path
    return {
        "source_group": source_group,
        "artifact": path.name,
        "role": role,
        "path": path.as_posix(),
        "bytes": path.stat().st_size,
        "sha256": sha256_file(path),
    }


def summary_rows(summary: dict[str, Any]) -> list[dict[str, object]]:
    aggregate = {row["representation"]: row for row in summary["aggregate"]}
    lexical = aggregate["lexical_farthest"]
    qwen_identifier = aggregate["qwen_identifier_farthest"]
    qwen_raw = aggregate["qwen_raw_farthest"]
    rows = [
        metric("model_id", summary["model_id"]),
        metric("candidate_count", summary["candidate_count"]),
        metric("problem_count", summary["problem_count"]),
        metric("replay_rows", summary["replay_rows"]),
        metric("retention_fraction", summary["retention_fraction"]),
        metric("text_max_chars", summary["text_max_chars"]),
        metric("truncated_text_count", summary["truncated_text_count"]),
        metric("nearest_cosine_mean", summary["nearest"]["cosine_mean"]),
        metric("same_problem_nearest_fraction", summary["nearest"]["same_problem_fraction"]),
        metric("same_corpus_nearest_fraction", summary["nearest"]["same_corpus_fraction"]),
        metric(
            "same_canonical_nearest_fraction",
            summary["nearest"]["same_canonical_netlist_count"] / summary["candidate_count"],
        ),
        metric(
            "same_motif_nearest_fraction",
            summary["nearest"]["same_motif_signature_count"] / summary["candidate_count"],
        ),
        metric("raw_to_comment_cosine_mean", summary["stability"]["raw_to_comment_cosine_mean"]),
        metric(
            "raw_to_identifier_cosine_mean",
            summary["stability"]["raw_to_identifier_cosine_mean"],
        ),
        metric("lexical_selected_hypervolume", lexical["selected_hypervolume"]),
        metric("qwen_identifier_selected_hypervolume", qwen_identifier["selected_hypervolume"]),
        metric(
            "qwen_identifier_vs_lexical_hv_gain_fraction",
            qwen_identifier["vs_lexical_hv_gain_fraction"],
        ),
        metric("qwen_raw_selected_hypervolume", qwen_raw["selected_hypervolume"]),
        metric("qwen_raw_vs_lexical_hv_gain_fraction", qwen_raw["vs_lexical_hv_gain_fraction"]),
    ]
    for view, shape in summary["embedding_shapes"].items():
        rows.append(metric(f"embedding_shape_{view}", f"{shape[0]}x{shape[1]}"))
    return rows


def metric(name: str, value: object) -> dict[str, object]:
    return {"metric": name, "value": value}


def ladder_plan_rows() -> list[dict[str, object]]:
    exclusions = "PPA, fitness, HV, Pareto labels, pass/fail labels"
    return [
        plan_row("raw_rtl", "reference_ablation", "original RTL", "sqrt_token_mean", exclusions),
        plan_row("commentless_rtl", "planned", "strip comments", "sqrt_token_mean", exclusions),
        plan_row("identifier_role_rtl", "planned", "role-normalize identifiers", "sqrt_token_mean", exclusions),
        plan_row("canonical_rtl", "planned", "deterministic RTL serialization", "sqrt_token_mean", exclusions),
        plan_row("canonical_yosys_netlist", "planned", "fixed Yosys netlist text", "sqrt_token_mean", exclusions),
        plan_row("summary_plus_netlist", "planned", "structural summary plus netlist", "sqrt_token_mean", exclusions),
    ]


def plan_row(
    view: str,
    status: str,
    source: str,
    primary_pooling: str,
    leakage_exclusion: str,
) -> dict[str, object]:
    return {
        "view": view,
        "status": status,
        "source": source,
        "primary_pooling": primary_pooling,
        "descriptor_candidates": "whitened_pca_cvt; stable_2d_pca; qwen_sr_hybrid; residual_norm",
        "leakage_exclusion": leakage_exclusion,
    }


def load_summary(qwen_dir: Path) -> dict[str, Any]:
    payload = json.loads((qwen_dir / "qwen_common_audit_summary.json").read_text())
    assert isinstance(payload, dict)
    return payload


def write_csv(path: Path, rows: list[dict[str, object]]) -> None:
    assert rows
    fieldnames = list(rows[0])
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames, lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def sha256_file(path: Path) -> str:
    hasher = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            hasher.update(chunk)
    return hasher.hexdigest()


if __name__ == "__main__":
    raise SystemExit(main())
