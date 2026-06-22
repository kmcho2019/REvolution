#!/usr/bin/env python3
"""Replay T33 Qwen ladder descriptors against lexical and random controls."""

from __future__ import annotations

import argparse
import csv
import importlib.util
import math
import sys
from pathlib import Path
from typing import Any, cast

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

REPO_ROOT = Path(__file__).resolve().parents[1]
_QWEN_AUDIT_PATH = REPO_ROOT / "scripts/run_rtl_diversity_wp1_qwen_common_audit.py"
_SPEC = importlib.util.spec_from_file_location("run_rtl_diversity_wp1_qwen_common_audit", _QWEN_AUDIT_PATH)
assert _SPEC is not None and _SPEC.loader is not None
qwen_audit = importlib.util.module_from_spec(_SPEC)
sys.modules.setdefault("run_rtl_diversity_wp1_qwen_common_audit", qwen_audit)
_SPEC.loader.exec_module(qwen_audit)

T33_VIEWS = (
    "canonical_rtl",
    "canonical_yosys_netlist",
    "commentless_rtl",
    "identifier_role_rtl",
    "raw_rtl",
    "summary_plus_netlist",
)

DISPLAY = {
    "fitness_top": "Fitness top",
    "generation_prefix": "Generation",
    "lexical_farthest": "Lexical",
    "random": "Random",
    "t33_canonical_rtl_farthest": "Canonical RTL",
    "t33_canonical_yosys_netlist_farthest": "Yosys netlist",
    "t33_commentless_rtl_farthest": "Commentless RTL",
    "t33_identifier_role_rtl_farthest": "Identifier-role RTL",
    "t33_raw_rtl_farthest": "Raw RTL",
    "t33_summary_plus_netlist_farthest": "Summary + netlist",
}

COLORS = {
    "all_valid": "#B8B8B8",
    "lexical_farthest": "#4C78A8",
    "random": "#BAB0AC",
    "t33_canonical_yosys_netlist_farthest": "#F58518",
    "t33_summary_plus_netlist_farthest": "#54A24B",
}


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--embedding-manifest", required=True, type=Path)
    parser.add_argument("--candidates-csv", required=True, type=Path)
    parser.add_argument("--package-dir", required=True, type=Path)
    parser.add_argument("--retention-fraction", type=float, default=0.5)
    parser.add_argument("--random-seed", type=int, default=0)
    args = parser.parse_args(argv)

    run_replay(
        embedding_manifest=args.embedding_manifest,
        candidates_csv=args.candidates_csv,
        package_dir=args.package_dir,
        retention_fraction=args.retention_fraction,
        random_seed=args.random_seed,
    )
    return 0


def run_replay(
    embedding_manifest: Path,
    candidates_csv: Path,
    package_dir: Path,
    retention_fraction: float,
    random_seed: int,
) -> None:
    assert 0.0 < retention_fraction <= 1.0
    candidates = pd.read_csv(candidates_csv)
    embeddings = load_embeddings(embedding_manifest)
    matrices = {"lexical_farthest": qwen_audit.lexical_matrix(candidates)}
    matrices.update({f"t33_{view}_farthest": embeddings[view] for view in T33_VIEWS})

    replay = qwen_audit.replay_rows(
        candidates,
        matrices,
        retention_fraction=retention_fraction,
        random_seed=random_seed,
    )
    aggregate = qwen_audit.aggregate_replay(replay)
    selected = selected_candidate_rows(candidates, matrices, retention_fraction, random_seed)
    front_metrics = ppa_front_metrics(candidates, selected)
    table_dir = package_dir / "tables"
    figure_dir = package_dir / "figures"
    table_dir.mkdir(parents=True, exist_ok=True)
    figure_dir.mkdir(parents=True, exist_ok=True)

    replay.to_csv(table_dir / "t33_replay_rows.csv", index=False)
    aggregate.to_csv(table_dir / "t33_replay_aggregate.csv", index=False)
    selected.to_csv(table_dir / "t33_selected_candidates.csv", index=False)
    front_metrics.to_csv(table_dir / "t33_ppa_front_metrics.csv", index=False)
    deltas(aggregate).to_csv(table_dir / "t33_qwen_ladder_vs_controls.csv", index=False)

    plot_hypervolume(aggregate, figure_dir / "t33_hypervolume_by_view.png")
    plot_diversity_counts(aggregate, figure_dir / "t33_duplicate_and_motif_counts.png")
    plot_raw_area_power_front(candidates, selected, figure_dir / "t33_raw_area_power_pareto_front.png")


def load_embeddings(path: Path) -> dict[str, np.ndarray]:
    rows = read_rows(path)
    output = {}
    for row in rows:
        output[row["view"]] = np.load(row["embedding_path"])
    assert set(T33_VIEWS) <= set(output)
    return output


def selected_candidate_rows(
    candidates: pd.DataFrame,
    matrices: dict[str, np.ndarray],
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
            selectors[name] = positions[qwen_audit.farthest_first(matrix[positions], k)]
        corpus, method, seed, problem = cast(tuple[str, str, int, str], key)
        for representation, selected_positions in selectors.items():
            selected = ordered.loc[ordered["sample_index"].isin(selected_positions)]
            for row in selected.to_dict("records"):
                rows.append(
                    {
                        "representation": representation,
                        "corpus": corpus,
                        "method": method,
                        "seed": int(seed),
                        "problem_id": problem,
                        "sample_index": int(row["sample_index"]),
                        "candidate_id": row["candidate_id"],
                        "area": float(row["area"]),
                        "power": float(row["power"]),
                        "eff_clk_period": float(row["eff_clk_period"]),
                        "fitness": float(row["fitness"]),
                        "canonical_netlist_hash": text_field(row, "canonical_netlist_hash"),
                        "motif_signature_hash": text_field(row, "motif_signature_hash"),
                    }
                )
    return pd.DataFrame(rows)


def ppa_front_metrics(candidates: pd.DataFrame, selected: pd.DataFrame) -> pd.DataFrame:
    assert "valid_ppa" in candidates
    valid_candidates = candidates.loc[candidates["valid_ppa"].astype(bool)]
    rows = []
    groups = selected.groupby(["representation", "corpus", "method", "seed", "problem_id"], sort=True)
    for key, group in groups:
        points = list(zip(group["area"].astype(float), group["power"].astype(float), strict=True))
        front = {canonical_ppa_point(group.iloc[index]) for index in lower_left_front(points)}
        representation, corpus, method, seed, problem = cast(tuple[str, str, str, int, str], key)
        all_valid = valid_candidates.loc[
            valid_candidates["corpus"].eq(corpus)
            & valid_candidates["method"].eq(method)
            & valid_candidates["seed"].eq(seed)
            & valid_candidates["problem_id"].eq(problem)
        ]
        all_front = all_valid_area_power_front(all_valid)
        rows.append(
            {
                "representation": representation,
                "corpus": corpus,
                "method": method,
                "seed": int(seed),
                "problem_id": problem,
                "all_valid_count": len(all_valid),
                "all_valid_area_power_front_points": len(all_front),
                "selected_count": len(group),
                "area_power_front_points": len(front),
                "selected_all_valid_front_hits": selected_front_hits(group, all_front),
                "unique_ppa_points": unique_ppa_points(group),
            }
        )
    frame = pd.DataFrame(rows)
    aggregate = frame.groupby("representation", as_index=False).agg(
        problem_group_count=("problem_id", "count"),
        all_valid_count=("all_valid_count", "sum"),
        all_valid_area_power_front_points=("all_valid_area_power_front_points", "sum"),
        selected_count=("selected_count", "sum"),
        area_power_front_points=("area_power_front_points", "sum"),
        selected_all_valid_front_hits=("selected_all_valid_front_hits", "sum"),
        unique_ppa_points=("unique_ppa_points", "sum"),
    )
    assert isinstance(aggregate, pd.DataFrame)
    return aggregate


def lower_left_front(points: list[tuple[float, float]]) -> list[int]:
    front = []
    for index, point in enumerate(points):
        dominated = False
        for other_index, other in enumerate(points):
            if index == other_index:
                continue
            if other[0] <= point[0] and other[1] <= point[1] and (other[0] < point[0] or other[1] < point[1]):
                dominated = True
                break
        if not dominated:
            front.append(index)
    return front


def unique_ppa_points(group: pd.DataFrame) -> int:
    points = {
        (
            round(float(row["area"]), 9),
            round(float(row["power"]), 12),
            round(float(row["eff_clk_period"]), 9),
        )
        for row in group.to_dict("records")
    }
    return len(points)


def all_valid_area_power_front(group: pd.DataFrame) -> set[tuple[float, float]]:
    points = list(zip(group["area"].astype(float), group["power"].astype(float), strict=True))
    return {canonical_ppa_point(group.iloc[index]) for index in lower_left_front(points)}


def selected_front_hits(group: pd.DataFrame, front: set[tuple[float, float]]) -> int:
    selected = {canonical_ppa_point(row) for _, row in group.iterrows()}
    return len(selected.intersection(front))


def canonical_ppa_point(row: pd.Series) -> tuple[float, float]:
    return (round(float(row["area"]), 9), round(float(row["power"]), 12))


def deltas(aggregate: pd.DataFrame) -> pd.DataFrame:
    rows = []
    by_rep = {row["representation"]: row for row in aggregate.to_dict("records")}
    lexical = by_rep["lexical_farthest"]
    random = by_rep["random"]
    metrics = [
        "selected_hypervolume",
        "selected_pareto_size",
        "selected_best_fitness",
        "unique_canonical_netlists",
        "unique_motif_signatures",
    ]
    for row in aggregate.to_dict("records"):
        for metric in metrics:
            value = float(row[metric])
            rows.append(
                {
                    "representation": row["representation"],
                    "metric": metric,
                    "value": value,
                    "lexical_value": float(lexical[metric]),
                    "delta_vs_lexical": value - float(lexical[metric]),
                    "random_value": float(random[metric]),
                    "delta_vs_random": value - float(random[metric]),
                }
            )
    return pd.DataFrame(rows)


def plot_hypervolume(aggregate: pd.DataFrame, path: Path) -> None:
    frame = aggregate.copy()
    frame["label"] = frame["representation"].map(display)
    frame = frame.sort_values("selected_hypervolume", ascending=False)
    colors = ["#F58518" if "Yosys" in label or "Summary" in label else "#4C78A8" for label in frame["label"]]
    fig, axis = plt.subplots(figsize=(9.2, 5.2))
    axis.barh(frame["label"], frame["selected_hypervolume"], color=colors)
    axis.axvline(float(frame.loc[frame["representation"].eq("lexical_farthest"), "selected_hypervolume"].iloc[0]), color="#333333", linewidth=1.0, linestyle="--", label="lexical")
    axis.set_xlabel("Selected Hypervolume")
    axis.grid(True, axis="x", alpha=0.25)
    axis.invert_yaxis()
    axis.legend(fontsize=8)
    fig.tight_layout()
    fig.savefig(path, dpi=180)
    plt.close(fig)


def plot_diversity_counts(aggregate: pd.DataFrame, path: Path) -> None:
    frame = aggregate.copy()
    frame["label"] = frame["representation"].map(display)
    x = np.arange(len(frame))
    width = 0.36
    fig, axis = plt.subplots(figsize=(10.5, 5.2))
    axis.bar(x - width / 2, frame["unique_canonical_netlists"], width, label="canonical netlists", color="#4C78A8")
    axis.bar(x + width / 2, frame["unique_motif_signatures"], width, label="motif signatures", color="#F58518")
    axis.set_xticks(x, frame["label"], rotation=30, ha="right")
    axis.set_ylabel("Unique Count")
    axis.grid(True, axis="y", alpha=0.25)
    axis.legend(fontsize=8)
    fig.tight_layout()
    fig.savefig(path, dpi=180)
    plt.close(fig)


def plot_raw_area_power_front(
    candidates: pd.DataFrame,
    selected: pd.DataFrame,
    path: Path,
) -> None:
    focus = focus_group(candidates)
    assert "valid_ppa" in candidates
    all_valid = candidates.loc[
        candidates["valid_ppa"].astype(bool)
        & candidates["corpus"].eq(focus["corpus"])
        & candidates["method"].eq(focus["method"])
        & candidates["seed"].eq(focus["seed"])
        & candidates["problem_id"].eq(focus["problem_id"])
    ]
    group = selected.loc[
        selected["corpus"].eq(focus["corpus"])
        & selected["method"].eq(focus["method"])
        & selected["seed"].eq(focus["seed"])
        & selected["problem_id"].eq(focus["problem_id"])
    ]
    assert not all_valid.empty
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
        draw_front(
            axis,
            all_valid,
            "#111111",
            "all-valid Pareto front" if panel_index == 0 else "_nolegend_",
        )
        for representation in (
            "lexical_farthest",
            "random",
            "t33_canonical_yosys_netlist_farthest",
            "t33_summary_plus_netlist_farthest",
        ):
            rows = group.loc[group["representation"].eq(representation)]
            if rows.empty:
                continue
            axis.scatter(
                rows["area"],
                rows["power"],
                s=58,
                label=display(representation) if panel_index == 0 else "_nolegend_",
                color=COLORS[representation],
                edgecolor="#222222",
                linewidth=0.4,
            )
            draw_front(axis, rows, COLORS[representation], "_nolegend_")
        axis.set_xlabel("Area (lower is better)")
        axis.set_ylabel("Power (lower is better)")
        axis.grid(True, alpha=0.22)
    set_pareto_zoom(axes[1], all_valid)
    title = str(focus["problem_id"]).split("/")[-1]
    axes[0].set_title("Full valid-PPA range")
    axes[1].set_title("Lower-left Pareto zoom")
    fig.suptitle(f"T33 Direct Area-Power Pareto Front: {title}")
    axes[0].legend(fontsize=8)
    fig.tight_layout()
    fig.savefig(path, dpi=180)
    plt.close(fig)


def focus_group(candidates: pd.DataFrame) -> pd.Series:
    assert "valid_ppa" in candidates
    valid = candidates.loc[candidates["valid_ppa"].astype(bool)]
    rows = []
    groups = valid.groupby(["corpus", "method", "seed", "problem_id"], sort=True)
    for key, group in groups:
        points = list(zip(group["area"].astype(float), group["power"].astype(float), strict=True))
        corpus, method, seed, problem = cast(tuple[str, str, int, str], key)
        rows.append(
            {
                "corpus": corpus,
                "method": method,
                "seed": int(seed),
                "problem_id": problem,
                "unique_ppa_points": unique_ppa_points(group),
                "front_points": len(lower_left_front(points)),
                "area_span": float(group["area"].max() - group["area"].min()),
                "power_span": float(group["power"].max() - group["power"].min()),
            }
        )
    frame = pd.DataFrame(rows)
    assert not frame.empty
    return frame.sort_values(
        ["unique_ppa_points", "front_points", "area_span", "power_span"],
        ascending=False,
    ).iloc[0]


def draw_front(axis: Any, rows: pd.DataFrame, color: str, label: str) -> None:
    front_rows = pareto_rows(rows)
    if front_rows.empty:
        return
    axis.plot(
        front_rows["area"],
        front_rows["power"],
        color=color,
        label=label,
        linewidth=1.6,
        alpha=0.9,
    )


def pareto_rows(rows: pd.DataFrame) -> pd.DataFrame:
    points = list(zip(rows["area"].astype(float), rows["power"].astype(float), strict=True))
    front = lower_left_front(points)
    if not front:
        return rows.iloc[[]]
    return rows.iloc[front].sort_values("area")


def set_pareto_zoom(axis: Any, all_valid: pd.DataFrame) -> None:
    front = pareto_rows(all_valid)
    assert not front.empty
    area_min = float(front["area"].min())
    area_max = float(front["area"].max())
    power_min = float(front["power"].min())
    power_max = float(front["power"].max())
    area_pad = max((area_max - area_min) * 0.12, 1.0)
    power_pad = max((power_max - power_min) * 0.12, 0.001)
    axis.set_xlim(area_min - area_pad, area_max + area_pad)
    axis.set_ylim(max(0.0, power_min - power_pad), power_max + power_pad)


def text_field(row: dict[str, Any], key: str) -> str:
    value = row.get(key, "")
    if pd.isna(value):
        return ""
    return str(value)


def display(value: str) -> str:
    return DISPLAY.get(value, value)


def read_rows(path: Path) -> list[dict[str, str]]:
    with path.open(encoding="utf-8", newline="") as handle:
        rows = list(csv.DictReader(handle))
    assert rows
    return rows


if __name__ == "__main__":
    raise SystemExit(main())
