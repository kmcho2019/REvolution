#!/usr/bin/env python3
"""Package the Qwen common-audit diagnostic as a useful-BD method package."""

from __future__ import annotations

import argparse
import csv
import json
from pathlib import Path
from typing import Any

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt
import pandas as pd

TABLE_NAMES = (
    "qwen_embedding_manifest",
    "preprocessing_view_manifest",
    "replay_aggregate",
    "qwen_vs_lexical_deltas",
    "collapse_diagnostics",
    "nuisance_axis_diagnostics",
)

REPRESENTATION_LABELS = {
    "fitness_top": "Fitness top",
    "generation_prefix": "Generation",
    "lexical_farthest": "Lexical",
    "qwen_identifier_farthest": "Qwen identifier",
    "qwen_raw_farthest": "Qwen raw",
    "random": "Random",
}


def build_package(qwen_dir: Path) -> dict[str, list[dict[str, Any]]]:
    """Build T06 tables from a Qwen common-audit artifact directory."""

    summary = load_summary(qwen_dir)
    aggregate = read_csv_rows(qwen_dir / "qwen_common_audit_aggregate.csv")
    nearest = read_csv_rows(qwen_dir / "qwen_common_audit_nearest.csv")
    stability = read_csv_rows(qwen_dir / "qwen_common_audit_stability.csv")
    return {
        "qwen_embedding_manifest": embedding_manifest(summary),
        "preprocessing_view_manifest": preprocessing_view_manifest(summary),
        "replay_aggregate": aggregate,
        "qwen_vs_lexical_deltas": qwen_vs_lexical_deltas(aggregate),
        "collapse_diagnostics": collapse_diagnostics(summary, nearest, stability),
        "nuisance_axis_diagnostics": nuisance_axis_diagnostics(summary),
    }


def embedding_manifest(summary: dict[str, Any]) -> list[dict[str, Any]]:
    """Return one manifest row per embedding view."""

    shapes = summary["embedding_shapes"]
    hashes = summary["artifact_sha256"]
    rows = []
    for view, shape in shapes.items():
        rows.append(
            {
                "view": view,
                "model_id": summary["model_id"],
                "candidate_count": summary["candidate_count"],
                "problem_count": summary["problem_count"],
                "embedding_rows": shape[0],
                "embedding_dims": shape[1],
                "embedding_hash": hashes[f"{view}_embeddings.npy"],
                "text_max_chars": summary["text_max_chars"],
                "truncated_text_count": summary["truncated_text_count"],
            }
        )
    return rows


def preprocessing_view_manifest(summary: dict[str, Any]) -> list[dict[str, Any]]:
    """Return preprocessing views used by the prior diagnostic."""

    stability = summary["stability"]
    return [
        {
            "view": "qwen_raw",
            "status": "prior_diagnostic",
            "normalization": "raw RTL text",
            "stability_metric": "reference",
            "stability_value": 1.0,
        },
        {
            "view": "qwen_comment_stripped",
            "status": "prior_diagnostic",
            "normalization": "strip comments",
            "stability_metric": "raw_to_comment_cosine_mean",
            "stability_value": stability["raw_to_comment_cosine_mean"],
        },
        {
            "view": "qwen_identifier_normalized",
            "status": "prior_diagnostic",
            "normalization": "normalize identifiers",
            "stability_metric": "raw_to_identifier_cosine_mean",
            "stability_value": stability["raw_to_identifier_cosine_mean"],
        },
        {
            "view": "canonical_rtl_view",
            "status": "planned_next",
            "normalization": "parse and role-normalize RTL",
            "stability_metric": "not_run",
            "stability_value": "",
        },
        {
            "view": "yosys_netlist_view",
            "status": "planned_next",
            "normalization": "fixed Yosys netlist text",
            "stability_metric": "not_run",
            "stability_value": "",
        },
        {
            "view": "structural_summary_view",
            "status": "planned_next",
            "normalization": "compact non-PPA structural summary",
            "stability_metric": "not_run",
            "stability_value": "",
        },
    ]


def qwen_vs_lexical_deltas(rows: list[dict[str, Any]]) -> list[dict[str, Any]]:
    """Compare each representation with lexical farthest-first selection."""

    by_rep = {row["representation"]: row for row in rows}
    lexical = by_rep["lexical_farthest"]
    metrics = (
        "selected_hypervolume",
        "selected_pareto_size",
        "selected_best_fitness",
        "unique_canonical_netlists",
        "unique_motif_signatures",
    )
    out = []
    for row in rows:
        if row["representation"] == "lexical_farthest":
            continue
        for metric in metrics:
            value = as_float(row[metric])
            baseline = as_float(lexical[metric])
            out.append(
                {
                    "representation": row["representation"],
                    "metric": metric,
                    "value": value,
                    "lexical_value": baseline,
                    "delta": value - baseline,
                    "relative_delta": safe_relative_delta(value, baseline),
                }
            )
    return out


def collapse_diagnostics(
    summary: dict[str, Any],
    nearest: list[dict[str, Any]],
    stability: list[dict[str, Any]],
) -> list[dict[str, Any]]:
    """Return Qwen collapse and stability diagnostics."""

    same_problem = mean_bool(nearest, "same_problem")
    same_corpus = mean_bool(nearest, "same_corpus")
    same_canonical = mean_bool(nearest, "same_canonical_netlist")
    same_motif = mean_bool(nearest, "same_motif_signature")
    return [
        {
            "diagnostic": "nearest_cosine_mean",
            "value": summary["nearest"]["cosine_mean"],
            "sample_count": len(nearest),
            "interpretation": "high values can indicate local clustering",
        },
        {
            "diagnostic": "same_problem_nearest_fraction",
            "value": same_problem,
            "sample_count": len(nearest),
            "interpretation": "problem identity dominates if high",
        },
        {
            "diagnostic": "same_corpus_nearest_fraction",
            "value": same_corpus,
            "sample_count": len(nearest),
            "interpretation": "corpus identity dominates if high",
        },
        {
            "diagnostic": "same_canonical_nearest_fraction",
            "value": same_canonical,
            "sample_count": len(nearest),
            "interpretation": "duplicate alignment",
        },
        {
            "diagnostic": "same_motif_nearest_fraction",
            "value": same_motif,
            "sample_count": len(nearest),
            "interpretation": "motif alignment",
        },
        {
            "diagnostic": "raw_to_comment_cosine_mean",
            "value": summary["stability"]["raw_to_comment_cosine_mean"],
            "sample_count": len(stability),
            "interpretation": "comment stripping stability",
        },
        {
            "diagnostic": "raw_to_identifier_cosine_mean",
            "value": summary["stability"]["raw_to_identifier_cosine_mean"],
            "sample_count": len(stability),
            "interpretation": "identifier sensitivity",
        },
    ]


def nuisance_axis_diagnostics(summary: dict[str, Any]) -> list[dict[str, Any]]:
    """Return nuisance-axis diagnostics from the Qwen audit summary."""

    return [
        {
            "axis": "problem_id",
            "metric": "nearest_same_problem_fraction",
            "value": summary["nearest"]["same_problem_fraction"],
            "risk": "high",
        },
        {
            "axis": "corpus",
            "metric": "nearest_same_corpus_fraction",
            "value": summary["nearest"]["same_corpus_fraction"],
            "risk": "high",
        },
        {
            "axis": "identifier_style",
            "metric": "raw_to_identifier_cosine_mean",
            "value": summary["stability"]["raw_to_identifier_cosine_mean"],
            "risk": "high",
        },
        {
            "axis": "comments",
            "metric": "raw_to_comment_cosine_mean",
            "value": summary["stability"]["raw_to_comment_cosine_mean"],
            "risk": "low",
        },
    ]


def write_package(qwen_dir: Path, technique_dir: Path) -> None:
    """Write T06 tables and figures."""

    tables = build_package(qwen_dir)
    table_dir = technique_dir / "tables"
    figure_dir = technique_dir / "figures"
    table_dir.mkdir(parents=True, exist_ok=True)
    figure_dir.mkdir(parents=True, exist_ok=True)
    for name in TABLE_NAMES:
        write_csv(table_dir / f"{name}.csv", tables[name])
    write_figures(tables, figure_dir)


def write_figures(tables: dict[str, list[dict[str, Any]]], figure_dir: Path) -> None:
    """Write T06 diagnostic figures."""

    aggregate = pd.DataFrame(tables["replay_aggregate"])
    deltas = pd.DataFrame(tables["qwen_vs_lexical_deltas"])
    collapse = pd.DataFrame(tables["collapse_diagnostics"])
    plot_replay_hypervolume(aggregate, figure_dir / "qwen_replay_hypervolume.png")
    plot_vs_lexical(
        deltas,
        "selected_hypervolume",
        "Hypervolume Delta vs Lexical (%)",
        figure_dir / "qwen_vs_lexical_hv_delta.png",
    )
    plot_diversity_counts(aggregate, figure_dir / "qwen_diversity_counts.png")
    plot_collapse(collapse, figure_dir / "qwen_collapse_diagnostics.png")


def plot_replay_hypervolume(frame: pd.DataFrame, output_path: Path) -> None:
    frame = frame.copy()
    frame["label"] = frame["representation"].map(display_representation)
    fig, axis = plt.subplots(figsize=(8.0, 4.6))
    x_positions = range(len(frame))
    axis.bar(x_positions, frame["selected_hypervolume"].astype(float), color="#4C78A8")
    axis.axhline(
        float(frame["baseline_hypervolume"].iloc[0]),
        color="#333333",
        linestyle="--",
        linewidth=1.0,
        label="all valid baseline",
    )
    axis.set_ylabel("Selected Hypervolume")
    axis.set_xticks(list(x_positions), frame["label"], rotation=25, ha="right")
    axis.grid(True, axis="y", alpha=0.25)
    axis.legend(fontsize=8)
    fig.tight_layout()
    fig.savefig(output_path, dpi=180)
    plt.close(fig)


def plot_vs_lexical(
    frame: pd.DataFrame,
    metric: str,
    xlabel: str,
    output_path: Path,
) -> None:
    frame = frame.loc[frame["metric"] == metric].copy()
    frame["relative_percent"] = frame["relative_delta"].astype(float) * 100.0
    frame["label"] = frame["representation"].map(display_representation)
    colors = ["#54A24B" if value >= 0.0 else "#E45756" for value in frame["relative_percent"]]
    fig, axis = plt.subplots(figsize=(8.0, 4.4))
    axis.barh(frame["label"], frame["relative_percent"], color=colors)
    axis.axvline(0.0, color="#333333", linewidth=1.0)
    axis.set_xlabel(xlabel)
    axis.grid(True, axis="x", alpha=0.25)
    fig.tight_layout()
    fig.savefig(output_path, dpi=180)
    plt.close(fig)


def plot_diversity_counts(frame: pd.DataFrame, output_path: Path) -> None:
    frame = frame.copy()
    labels = frame["representation"].map(display_representation)
    x_positions = range(len(frame))
    width = 0.36
    fig, axis = plt.subplots(figsize=(8.0, 4.6))
    axis.bar(
        [x - width / 2 for x in x_positions],
        frame["unique_canonical_netlists"].astype(float),
        width=width,
        label="canonical netlists",
        color="#4C78A8",
    )
    axis.bar(
        [x + width / 2 for x in x_positions],
        frame["unique_motif_signatures"].astype(float),
        width=width,
        label="motif signatures",
        color="#F58518",
    )
    axis.set_ylabel("Unique Count")
    axis.set_xticks(list(x_positions), labels, rotation=25, ha="right")
    axis.grid(True, axis="y", alpha=0.25)
    axis.legend(fontsize=8)
    fig.tight_layout()
    fig.savefig(output_path, dpi=180)
    plt.close(fig)


def plot_collapse(frame: pd.DataFrame, output_path: Path) -> None:
    wanted = (
        "same_problem_nearest_fraction",
        "same_corpus_nearest_fraction",
        "same_canonical_nearest_fraction",
        "same_motif_nearest_fraction",
        "raw_to_comment_cosine_mean",
        "raw_to_identifier_cosine_mean",
    )
    frame = frame.loc[frame["diagnostic"].isin(wanted)].copy()
    labels = [str(item).replace("_", " ") for item in frame["diagnostic"]]
    fig, axis = plt.subplots(figsize=(8.0, 4.8))
    axis.barh(labels, frame["value"].astype(float), color="#4C78A8")
    axis.set_xlim(0.0, 1.0)
    axis.set_xlabel("Fraction or cosine")
    axis.grid(True, axis="x", alpha=0.25)
    fig.tight_layout()
    fig.savefig(output_path, dpi=180)
    plt.close(fig)


def read_csv_rows(path: Path) -> list[dict[str, Any]]:
    with path.open(encoding="utf-8", newline="") as handle:
        return list(csv.DictReader(handle))


def write_csv(path: Path, rows: list[dict[str, Any]]) -> None:
    assert rows, f"empty table: {path}"
    path.parent.mkdir(parents=True, exist_ok=True)
    fieldnames = list(rows[0])
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames, lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def load_summary(qwen_dir: Path) -> dict[str, Any]:
    payload = json.loads((qwen_dir / "qwen_common_audit_summary.json").read_text())
    assert isinstance(payload, dict)
    return payload


def display_representation(value: object) -> str:
    return REPRESENTATION_LABELS.get(str(value), str(value))


def as_float(value: object) -> float:
    assert isinstance(value, str | int | float)
    return float(value)


def safe_relative_delta(value: float, baseline: float) -> float:
    if baseline == 0.0:
        return 0.0 if value == 0.0 else float("inf")
    return (value - baseline) / abs(baseline)


def mean_bool(rows: list[dict[str, Any]], key: str) -> float:
    assert rows, f"empty rows for {key}"
    return sum(str(row[key]) == "True" for row in rows) / len(rows)


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--qwen-dir", type=Path, required=True)
    parser.add_argument("--technique-dir", type=Path, required=True)
    args = parser.parse_args(argv)

    write_package(qwen_dir=args.qwen_dir, technique_dir=args.technique_dir)
    print(f"Packaged Qwen audit into {args.technique_dir}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
