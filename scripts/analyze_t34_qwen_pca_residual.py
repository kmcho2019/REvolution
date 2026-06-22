#!/usr/bin/env python3
"""Replay PCA-residual Qwen descriptors for T34."""

from __future__ import annotations

import argparse
import csv
import importlib.util
import math
import sys
from pathlib import Path
from typing import Any

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

REPO_ROOT = Path(__file__).resolve().parents[1]
_QWEN_AUDIT_PATH = REPO_ROOT / "scripts/run_rtl_diversity_wp1_qwen_common_audit.py"
_T33_REPLAY_PATH = REPO_ROOT / "scripts/analyze_t33_qwen_replay.py"


def import_module(path: Path, name: str) -> Any:
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    sys.modules.setdefault(name, module)
    spec.loader.exec_module(module)
    return module


qwen_audit = import_module(_QWEN_AUDIT_PATH, "run_rtl_diversity_wp1_qwen_common_audit")
t33_replay = import_module(_T33_REPLAY_PATH, "analyze_t33_qwen_replay")

BASE_VIEWS = (
    "canonical_rtl",
    "canonical_yosys_netlist",
    "commentless_rtl",
    "identifier_role_rtl",
    "raw_rtl",
    "summary_plus_netlist",
)

RESIDUAL_PLAN = {
    "canonical_rtl": (1, 4, 8, 16),
    "identifier_role_rtl": (1, 4, 8, 16),
    "commentless_rtl": (1, 4, 8),
    "summary_plus_netlist": (1, 4),
}

COLORS = {
    "all_valid": "#B8B8B8",
    "lexical_farthest": "#4C78A8",
    "random": "#BAB0AC",
    "base": "#F58518",
    "residual": "#54A24B",
}


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--embedding-manifest", required=True, type=Path)
    parser.add_argument("--candidates-csv", required=True, type=Path)
    parser.add_argument("--package-dir", required=True, type=Path)
    parser.add_argument("--retention-fraction", type=float, default=0.5)
    parser.add_argument("--random-seed", type=int, default=0)
    args = parser.parse_args(argv)

    run_analysis(
        embedding_manifest=args.embedding_manifest,
        candidates_csv=args.candidates_csv,
        package_dir=args.package_dir,
        retention_fraction=args.retention_fraction,
        random_seed=args.random_seed,
    )
    return 0


def run_analysis(
    embedding_manifest: Path,
    candidates_csv: Path,
    package_dir: Path,
    retention_fraction: float,
    random_seed: int,
) -> None:
    assert 0.0 < retention_fraction <= 1.0
    candidates = pd.read_csv(candidates_csv)
    embeddings = load_embeddings(embedding_manifest)
    matrices = build_matrices(candidates, embeddings)

    replay = qwen_audit.replay_rows(
        candidates,
        matrices,
        retention_fraction=retention_fraction,
        random_seed=random_seed,
    )
    aggregate = qwen_audit.aggregate_replay(replay)
    selected = t33_replay.selected_candidate_rows(
        candidates,
        matrices,
        retention_fraction,
        random_seed,
    )
    front_metrics = t33_replay.ppa_front_metrics(candidates, selected)
    collapse = collapse_metrics(candidates, matrices)
    vs_controls = deltas(aggregate, collapse)

    table_dir = package_dir / "tables"
    figure_dir = package_dir / "figures"
    table_dir.mkdir(parents=True, exist_ok=True)
    figure_dir.mkdir(parents=True, exist_ok=True)

    replay.to_csv(table_dir / "t34_replay_rows.csv", index=False)
    aggregate.to_csv(table_dir / "t34_replay_aggregate.csv", index=False)
    selected.to_csv(table_dir / "t34_selected_candidates.csv", index=False)
    front_metrics.to_csv(table_dir / "t34_ppa_front_metrics.csv", index=False)
    collapse.to_csv(table_dir / "t34_collapse_metrics.csv", index=False)
    vs_controls.to_csv(table_dir / "t34_vs_controls.csv", index=False)

    plot_hypervolume(aggregate, figure_dir / "t34_hypervolume_by_projection.png")
    plot_collapse_vs_hv(aggregate, collapse, figure_dir / "t34_collapse_vs_hypervolume.png")
    plot_raw_area_power_front(
        candidates,
        selected,
        aggregate,
        figure_dir / "t34_raw_area_power_pareto_front.png",
    )


def load_embeddings(path: Path) -> dict[str, np.ndarray]:
    rows = read_rows(path)
    output = {row["view"]: np.load(row["embedding_path"]) for row in rows}
    assert set(BASE_VIEWS) <= set(output)
    return output


def build_matrices(
    candidates: pd.DataFrame,
    embeddings: dict[str, np.ndarray],
) -> dict[str, np.ndarray]:
    matrices = {"lexical_farthest": qwen_audit.lexical_matrix(candidates)}
    for view in BASE_VIEWS:
        matrices[f"t33_{view}_farthest"] = embeddings[view]
    for view, components_list in RESIDUAL_PLAN.items():
        for components in components_list:
            name = f"t34_{view}_pc{components}_residual"
            matrices[name] = residualize(embeddings[view], components)
    concat = np.concatenate(
        [
            normalize_rows(embeddings["canonical_rtl"]),
            normalize_rows(embeddings["canonical_yosys_netlist"]),
        ],
        axis=1,
    )
    matrices["t34_rtl_yosys_concat_pc4_residual"] = residualize(concat, 4)
    matrices["t34_rtl_yosys_concat_pc8_residual"] = residualize(concat, 8)
    return matrices


def residualize(matrix: np.ndarray, components: int) -> np.ndarray:
    assert 0 < components < min(matrix.shape)
    centered = matrix - matrix.mean(axis=0, keepdims=True)
    _, _, basis = np.linalg.svd(centered, full_matrices=False)
    axes = basis[:components]
    residual = centered - centered @ axes.T @ axes
    return normalize_rows(residual)


def normalize_rows(matrix: np.ndarray) -> np.ndarray:
    norms = np.linalg.norm(matrix, axis=1, keepdims=True)
    norms[norms == 0.0] = 1.0
    return matrix / norms


def collapse_metrics(candidates: pd.DataFrame, matrices: dict[str, np.ndarray]) -> pd.DataFrame:
    rows = []
    for name, matrix in matrices.items():
        if name == "lexical_farthest":
            continue
        nearest = nearest_indices(matrix)
        same_problem = []
        same_corpus = []
        for index, other_index in enumerate(nearest):
            row = candidates.iloc[index]
            other = candidates.iloc[int(other_index)]
            same_problem.append(row["problem_id"] == other["problem_id"])
            same_corpus.append(row["corpus"] == other["corpus"])
        rows.append(
            {
                "representation": name,
                "same_problem_fraction": float(np.mean(same_problem)),
                "same_corpus_fraction": float(np.mean(same_corpus)),
                "family": family(name),
            }
        )
    return pd.DataFrame(rows)


def nearest_indices(matrix: np.ndarray) -> np.ndarray:
    normalized = normalize_rows(matrix)
    cosine = normalized @ normalized.T
    np.fill_diagonal(cosine, -np.inf)
    return cosine.argmax(axis=1)


def deltas(aggregate: pd.DataFrame, collapse: pd.DataFrame) -> pd.DataFrame:
    merged = aggregate.merge(collapse, on="representation", how="left")
    lexical = aggregate.loc[aggregate["representation"].eq("lexical_farthest")].iloc[0]
    rows = []
    for row in merged.to_dict("records"):
        rows.append(
            {
                "representation": row["representation"],
                "family": row.get("family", "control"),
                "selected_hypervolume": float(row["selected_hypervolume"]),
                "delta_hv_vs_lexical": float(row["selected_hypervolume"])
                - float(lexical["selected_hypervolume"]),
                "selected_pareto_size": int(row["selected_pareto_size"]),
                "unique_canonical_netlists": int(row["unique_canonical_netlists"]),
                "unique_motif_signatures": int(row["unique_motif_signatures"]),
                "same_problem_fraction": optional_float(row.get("same_problem_fraction")),
                "same_corpus_fraction": optional_float(row.get("same_corpus_fraction")),
            }
        )
    return pd.DataFrame(rows)


def optional_float(value: object) -> float:
    if value is None:
        return math.nan
    if isinstance(value, int | float | np.integer | np.floating):
        return float(value)
    return math.nan


def plot_hypervolume(aggregate: pd.DataFrame, path: Path) -> None:
    frame = aggregate.copy()
    frame["label"] = frame["representation"].map(label)
    frame = frame.sort_values("selected_hypervolume", ascending=False).head(18)
    colors = [COLORS["residual"] if "residual" in rep else COLORS["base"] for rep in frame["representation"]]
    fig, axis = plt.subplots(figsize=(10.5, 7.2))
    axis.barh(frame["label"], frame["selected_hypervolume"], color=colors)
    lexical = aggregate.loc[aggregate["representation"].eq("lexical_farthest")].iloc[0]
    axis.axvline(float(lexical["selected_hypervolume"]), color="#333333", linestyle="--", linewidth=1.0)
    axis.set_xlabel("Selected Hypervolume")
    axis.grid(True, axis="x", alpha=0.24)
    axis.invert_yaxis()
    fig.tight_layout()
    fig.savefig(path, dpi=180)
    plt.close(fig)


def plot_collapse_vs_hv(aggregate: pd.DataFrame, collapse: pd.DataFrame, path: Path) -> None:
    frame = aggregate.merge(collapse, on="representation", how="inner")
    fig, axis = plt.subplots(figsize=(8.4, 5.6))
    for group, color in (("t33_base", COLORS["base"]), ("t34_residual", COLORS["residual"])):
        rows = frame.loc[frame["family"].eq(group)]
        axis.scatter(
            rows["same_problem_fraction"],
            rows["selected_hypervolume"],
            s=54,
            color=color,
            label=group.replace("_", " "),
            edgecolor="#222222",
            linewidth=0.4,
        )
    lexical = aggregate.loc[aggregate["representation"].eq("lexical_farthest")].iloc[0]
    axis.axhline(float(lexical["selected_hypervolume"]), color="#333333", linestyle="--", linewidth=1.0)
    axis.set_xlabel("Same-problem nearest-neighbor fraction")
    axis.set_ylabel("Selected Hypervolume")
    axis.grid(True, alpha=0.24)
    axis.legend(fontsize=8)
    fig.tight_layout()
    fig.savefig(path, dpi=180)
    plt.close(fig)


def plot_raw_area_power_front(
    candidates: pd.DataFrame,
    selected: pd.DataFrame,
    aggregate: pd.DataFrame,
    path: Path,
) -> None:
    focus = t33_replay.focus_group(candidates)
    all_valid = focus_candidates(candidates, focus)
    selected_group = focus_candidates(selected, focus)
    residual = best_representation(aggregate, "t34_")
    base = best_base_representation(aggregate)
    reps = ["lexical_farthest", "random", base, residual]

    fig, axes = plt.subplots(1, 2, figsize=(13.2, 5.6))
    for panel_index, axis in enumerate(axes):
        axis.scatter(
            all_valid["area"],
            all_valid["power"],
            color=COLORS["all_valid"],
            s=28,
            alpha=0.32,
            label="all valid candidates" if panel_index == 0 else "_nolegend_",
        )
        t33_replay.draw_front(
            axis,
            all_valid,
            "#111111",
            "all-valid Pareto front" if panel_index == 0 else "_nolegend_",
        )
        for representation in reps:
            rows = selected_group.loc[selected_group["representation"].eq(representation)]
            if rows.empty:
                continue
            color = color_for(representation)
            axis.scatter(
                rows["area"],
                rows["power"],
                s=58,
                label=label(representation) if panel_index == 0 else "_nolegend_",
                color=color,
                edgecolor="#222222",
                linewidth=0.4,
            )
            t33_replay.draw_front(axis, rows, color, "_nolegend_")
        axis.set_xlabel("Area (lower is better)")
        axis.set_ylabel("Power (lower is better)")
        axis.grid(True, alpha=0.22)
    t33_replay.set_pareto_zoom(axes[1], all_valid)
    title = str(focus["problem_id"]).split("/")[-1]
    axes[0].set_title("Full valid-PPA range")
    axes[1].set_title("Lower-left Pareto zoom")
    fig.suptitle(f"T34 Direct Area-Power Pareto Front: {title}")
    axes[0].legend(fontsize=8)
    fig.tight_layout()
    fig.savefig(path, dpi=180)
    plt.close(fig)


def focus_candidates(frame: pd.DataFrame, focus: pd.Series) -> pd.DataFrame:
    return frame.loc[
        frame["corpus"].eq(focus["corpus"])
        & frame["method"].eq(focus["method"])
        & frame["seed"].eq(focus["seed"])
        & frame["problem_id"].eq(focus["problem_id"])
    ]


def best_representation(aggregate: pd.DataFrame, prefix: str) -> str:
    rows = aggregate.loc[aggregate["representation"].astype(str).str.startswith(prefix)]
    assert not rows.empty
    return str(rows.sort_values("selected_hypervolume", ascending=False).iloc[0]["representation"])


def best_base_representation(aggregate: pd.DataFrame) -> str:
    rows = aggregate.loc[aggregate["representation"].astype(str).str.startswith("t33_")]
    assert not rows.empty
    return str(rows.sort_values("selected_hypervolume", ascending=False).iloc[0]["representation"])


def color_for(representation: str) -> str:
    if representation == "lexical_farthest":
        return COLORS["lexical_farthest"]
    if representation == "random":
        return COLORS["random"]
    if representation.startswith("t34_"):
        return COLORS["residual"]
    return COLORS["base"]


def label(representation: str) -> str:
    text = representation.removeprefix("t33_").removeprefix("t34_")
    text = text.removesuffix("_farthest").removesuffix("_residual")
    return text.replace("_", " ").replace("pc", "PC")


def family(representation: str) -> str:
    if representation.startswith("t34_"):
        return "t34_residual"
    if representation.startswith("t33_"):
        return "t33_base"
    return "control"


def read_rows(path: Path) -> list[dict[str, str]]:
    with path.open(encoding="utf-8", newline="") as handle:
        rows = list(csv.DictReader(handle))
    assert rows
    return rows


if __name__ == "__main__":
    raise SystemExit(main())
