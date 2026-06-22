#!/usr/bin/env python3
"""Replay T13 AURORA-style implementation autoencoder descriptors."""

from __future__ import annotations

import argparse
import hashlib
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
QWEN_AUDIT_PATH = REPO_ROOT / "scripts/run_rtl_diversity_wp1_qwen_common_audit.py"
T33_REPLAY_PATH = REPO_ROOT / "scripts/analyze_t33_qwen_replay.py"

RTL_FEATURES = (
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
GRAPH_FEATURES = (
    "node_count",
    "edge_count",
    "net_count",
    "max_level",
    "unresolved_cycle_nodes",
    "family_inv",
    "family_buf",
    "family_nand",
    "family_nor",
    "family_and",
    "family_or",
    "family_xor",
    "family_xnor",
    "family_aoi",
    "family_oai",
    "family_mux",
    "family_dff",
    "family_latch",
    "family_add",
    "family_other",
)
FORBIDDEN_DESCRIPTOR_INPUTS = (
    "area",
    "power",
    "eff_clk_period",
    "fitness",
    "reference_ppa_json",
    "valid_ppa",
    "syntax_pass",
    "functionality_pass",
    "synthesis_pass",
    "openroad_pass",
    "pareto_member",
    "problem_id",
    "corpus",
    "model",
    "method",
    "seed",
    "candidate_id",
)
RFF_DIM = 64
RFF_SEED = 13013
DISPLAY = {
    "fitness_top": "Fitness top",
    "generation_prefix": "Generation",
    "lexical_farthest": "Lexical",
    "random": "Random",
    "t13_impl_z_farthest": "Implementation features",
    "t13_pca2_farthest": "PCA-2",
    "t13_pca4_farthest": "PCA-4",
    "t13_pca8_farthest": "PCA-8",
    "t13_rff_pca2_farthest": "RFF PCA-2",
    "t13_rff_pca4_farthest": "RFF PCA-4",
    "t13_rff_pca8_farthest": "RFF PCA-8",
    "t13_incremental_pca4_farthest": "Incremental PCA-4",
}


def import_module(path: Path, name: str) -> Any:
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    sys.modules.setdefault(name, module)
    spec.loader.exec_module(module)
    return module


qwen_audit = import_module(QWEN_AUDIT_PATH, "run_rtl_diversity_wp1_qwen_common_audit")
t33_replay = import_module(T33_REPLAY_PATH, "analyze_t33_qwen_replay")


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--candidates-csv", required=True, type=Path)
    parser.add_argument("--graph-manifest-csv", required=True, type=Path)
    parser.add_argument("--package-dir", required=True, type=Path)
    parser.add_argument("--retention-fraction", type=float, default=0.5)
    parser.add_argument("--random-seed", type=int, default=0)
    parser.add_argument("--latent-dims", type=int, nargs="+", default=[2, 4, 8])
    args = parser.parse_args(argv)
    run_analysis(
        candidates_csv=args.candidates_csv,
        graph_manifest_csv=args.graph_manifest_csv,
        package_dir=args.package_dir,
        retention_fraction=args.retention_fraction,
        random_seed=args.random_seed,
        latent_dims=tuple(args.latent_dims),
    )
    return 0


def run_analysis(
    candidates_csv: Path,
    graph_manifest_csv: Path,
    package_dir: Path,
    retention_fraction: float,
    random_seed: int,
    latent_dims: tuple[int, ...],
) -> None:
    assert 0.0 < retention_fraction <= 1.0
    assert latent_dims
    candidates = pd.read_csv(candidates_csv)
    graph_manifest = pd.read_csv(graph_manifest_csv)
    features, feature_manifest = implementation_features(candidates, graph_manifest)
    split = problem_splits(candidates)
    matrices, training = descriptor_matrices(features, candidates, split, latent_dims)
    matrices = {"lexical_farthest": qwen_audit.lexical_matrix(candidates), **matrices}

    replay = qwen_audit.replay_rows(
        candidates,
        matrices,
        retention_fraction=retention_fraction,
        random_seed=random_seed,
    )
    aggregate = qwen_audit.aggregate_replay(replay)
    selected = t33_replay.selected_candidate_rows(candidates, matrices, retention_fraction, random_seed)
    front_metrics = t33_replay.ppa_front_metrics(candidates, selected)
    collapse = collapse_metrics(candidates, matrices)
    archive = archive_metrics(aggregate, front_metrics, collapse)
    latent = latent_diagnostics(candidates, matrices, features)

    table_dir = package_dir / "tables"
    figure_dir = package_dir / "figures"
    table_dir.mkdir(parents=True, exist_ok=True)
    figure_dir.mkdir(parents=True, exist_ok=True)

    feature_manifest.to_csv(table_dir / "feature_manifest.csv", index=False)
    split.to_csv(table_dir / "split_manifest.csv", index=False)
    training.to_csv(table_dir / "autoencoder_training.csv", index=False)
    latent.to_csv(table_dir / "latent_diagnostics.csv", index=False)
    replay.to_csv(table_dir / "replay_rows.csv", index=False)
    aggregate.to_csv(table_dir / "ppa_comparison.csv", index=False)
    selected.to_csv(table_dir / "selected_candidates.csv", index=False)
    front_metrics.to_csv(table_dir / "ppa_front_metrics.csv", index=False)
    collapse.to_csv(table_dir / "collapse_diagnostics.csv", index=False)
    archive.to_csv(table_dir / "archive_metrics.csv", index=False)
    ppa_front_plot_points(candidates, selected, aggregate).to_csv(
        table_dir / "ppa_front_plot_points.csv",
        index=False,
    )

    plot_hypervolume(aggregate, figure_dir / "aurora_hypervolume.png")
    plot_latent_projection(candidates, matrices, aggregate, figure_dir / "aurora_latent_projection.png")
    plot_reconstruction_vs_hv(training, aggregate, figure_dir / "aurora_reconstruction_vs_hv.png")
    plot_multi_problem_area_power_front(
        candidates,
        selected,
        aggregate,
        figure_dir / "aurora_multi_problem_ppa_pareto_fronts.png",
    )
    plot_raw_area_power_front(
        candidates,
        selected,
        aggregate,
        figure_dir / "aurora_raw_area_power_pareto_front.png",
    )


def implementation_features(
    candidates: pd.DataFrame,
    graph_manifest: pd.DataFrame,
) -> tuple[pd.DataFrame, pd.DataFrame]:
    required_candidate = {"sample_index", *RTL_FEATURES}
    required_graph = {"sample_index", *GRAPH_FEATURES}
    assert required_candidate <= set(candidates.columns)
    assert required_graph <= set(graph_manifest.columns)
    merged = candidates[["sample_index", *RTL_FEATURES]].merge(
        graph_manifest[["sample_index", *GRAPH_FEATURES]],
        on="sample_index",
        how="inner",
        validate="one_to_one",
    )
    assert len(merged) == len(candidates)
    rows = []
    feature = pd.DataFrame(index=merged.index)
    for column in RTL_FEATURES:
        values = numeric(merged[column])
        feature[f"log_{column}"] = np.log1p(values)
        rows.append({"feature": f"log_{column}", "source": column, "group": "rtl_count"})
    for column in GRAPH_FEATURES[:5]:
        values = numeric(merged[column])
        feature[f"log_{column}"] = np.log1p(values)
        rows.append({"feature": f"log_{column}", "source": column, "group": "graph_count"})
    node_count = numeric(merged["node_count"])
    edge_count = numeric(merged["edge_count"])
    net_count = numeric(merged["net_count"])
    feature["edge_per_node"] = edge_count / np.maximum(node_count, 1.0)
    feature["net_per_node"] = net_count / np.maximum(node_count, 1.0)
    feature["unresolved_cycle_share"] = numeric(merged["unresolved_cycle_nodes"]) / np.maximum(node_count, 1.0)
    rows.extend(
        [
            {"feature": "edge_per_node", "source": "edge_count/node_count", "group": "graph_ratio"},
            {"feature": "net_per_node", "source": "net_count/node_count", "group": "graph_ratio"},
            {
                "feature": "unresolved_cycle_share",
                "source": "unresolved_cycle_nodes/node_count",
                "group": "graph_ratio",
            },
        ]
    )
    family_columns = GRAPH_FEATURES[5:]
    family_total = np.maximum(
        np.sum([numeric(merged[column]) for column in family_columns], axis=0),
        1.0,
    )
    for column in family_columns:
        feature[f"share_{column}"] = numeric(merged[column]) / family_total
        rows.append({"feature": f"share_{column}", "source": column, "group": "cell_family_share"})
    assert not bool(feature.isna().to_numpy().any())
    return feature, pd.DataFrame(rows)


def descriptor_matrices(
    features: pd.DataFrame,
    candidates: pd.DataFrame,
    split: pd.DataFrame,
    latent_dims: tuple[int, ...],
) -> tuple[dict[str, np.ndarray], pd.DataFrame]:
    matrix = features.to_numpy(dtype=float)
    train_mask = split["split"].eq("train").to_numpy(dtype=bool)
    assert train_mask.any()
    train = matrix[train_mask]
    mean = train.mean(axis=0)
    std = train.std(axis=0)
    std = np.where(std == 0.0, 1.0, std)
    z = (matrix - mean) / std
    matrices = {"t13_impl_z_farthest": z}
    rows = [training_row("t13_impl_z_farthest", "standardized_features", 0, z, z, train_mask)]
    for dim in latent_dims:
        latent, reconstructed = pca_latent(z, train_mask, dim)
        name = f"t13_pca{dim}_farthest"
        matrices[name] = latent
        rows.append(training_row(name, "linear_autoencoder", dim, z, reconstructed, train_mask))
        rff = rff_features(z)
        rff_latent, rff_reconstructed = pca_latent(rff, train_mask, dim)
        rff_name = f"t13_rff_pca{dim}_farthest"
        matrices[rff_name] = rff_latent
        rows.append(training_row(rff_name, "rff_nonlinear_bottleneck", dim, rff, rff_reconstructed, train_mask))
    incremental, incremental_rows = incremental_pca4(z, candidates, train_mask)
    matrices["t13_incremental_pca4_farthest"] = incremental
    rows.extend(incremental_rows)
    return matrices, pd.DataFrame(rows)


def pca_latent(matrix: np.ndarray, train_mask: np.ndarray, dim: int) -> tuple[np.ndarray, np.ndarray]:
    train = matrix[train_mask]
    assert 1 <= dim <= matrix.shape[1]
    assert len(train) > dim
    _u, _s, vh = np.linalg.svd(train - train.mean(axis=0, keepdims=True), full_matrices=False)
    components = vh[:dim]
    centered = matrix - train.mean(axis=0, keepdims=True)
    latent = centered @ components.T
    latent_train = latent[train_mask]
    latent_std = latent_train.std(axis=0)
    latent_std = np.where(latent_std == 0.0, 1.0, latent_std)
    latent = (latent - latent_train.mean(axis=0, keepdims=True)) / latent_std
    reconstructed = (centered @ components.T) @ components + train.mean(axis=0, keepdims=True)
    return latent, reconstructed


def rff_features(matrix: np.ndarray) -> np.ndarray:
    rng = np.random.default_rng(RFF_SEED)
    weights = rng.normal(0.0, 1.0, size=(matrix.shape[1], RFF_DIM))
    bias = rng.uniform(0.0, 2.0 * math.pi, size=RFF_DIM)
    return math.sqrt(2.0 / RFF_DIM) * np.cos(matrix @ weights + bias)


def incremental_pca4(
    matrix: np.ndarray,
    candidates: pd.DataFrame,
    train_mask: np.ndarray,
) -> tuple[np.ndarray, list[dict[str, object]]]:
    dim = min(4, matrix.shape[1])
    generations = sorted(int(item) for item in candidates["generation"].dropna().unique())
    assert generations
    output = np.zeros((len(matrix), dim), dtype=float)
    rows = []
    for generation in generations:
        checkpoint_mask = train_mask & candidates["generation"].astype(int).le(generation).to_numpy(dtype=bool)
        if int(checkpoint_mask.sum()) <= dim:
            checkpoint_mask = train_mask
        latent, reconstructed = pca_latent(matrix, checkpoint_mask, dim)
        row_mask = candidates["generation"].astype(int).eq(generation).to_numpy(dtype=bool)
        output[row_mask] = latent[row_mask]
        rows.append(
            {
                **training_row(
                    "t13_incremental_pca4_farthest",
                    f"incremental_linear_autoencoder_gen{generation}",
                    dim,
                    matrix,
                    reconstructed,
                    checkpoint_mask,
                ),
                "checkpoint_generation": generation,
            }
        )
    return output, rows


def training_row(
    representation: str,
    variant: str,
    latent_dim: int,
    matrix: np.ndarray,
    reconstructed: np.ndarray,
    train_mask: np.ndarray,
) -> dict[str, object]:
    holdout_mask = ~train_mask
    return {
        "representation": representation,
        "variant": variant,
        "latent_dim": latent_dim,
        "input_dim": matrix.shape[1],
        "train_rows": int(train_mask.sum()),
        "holdout_rows": int(holdout_mask.sum()),
        "train_reconstruction_mse": mse(matrix[train_mask], reconstructed[train_mask]),
        "holdout_reconstruction_mse": mse(matrix[holdout_mask], reconstructed[holdout_mask]),
        "checkpoint_generation": "",
    }


def problem_splits(candidates: pd.DataFrame) -> pd.DataFrame:
    rows = []
    for sample_index, corpus, problem in zip(
        candidates["sample_index"].tolist(),
        candidates["corpus"].tolist(),
        candidates["problem_id"].tolist(),
        strict=True,
    ):
        bucket = int(stable_hash(f"{corpus}::{problem}"), 16) % 10
        split = "train" if bucket < 6 else "validation" if bucket < 8 else "holdout"
        rows.append({"sample_index": sample_index, "corpus": corpus, "problem_id": problem, "split": split})
    frame = pd.DataFrame(rows)
    assert set(frame["split"]) == {"train", "validation", "holdout"}
    return frame


def collapse_metrics(candidates: pd.DataFrame, matrices: dict[str, np.ndarray]) -> pd.DataFrame:
    rows = []
    for name, matrix in matrices.items():
        if name == "lexical_farthest":
            continue
        nearest = nearest_indices(matrix)
        same_problem = []
        same_corpus = []
        same_netlist = []
        same_motif = []
        for index, other_index in enumerate(nearest):
            row = candidates.iloc[index]
            other = candidates.iloc[int(other_index)]
            same_problem.append(row["problem_id"] == other["problem_id"])
            same_corpus.append(row["corpus"] == other["corpus"])
            same_netlist.append(
                text_field(row.to_dict(), "canonical_netlist_hash")
                == text_field(other.to_dict(), "canonical_netlist_hash")
            )
            same_motif.append(
                text_field(row.to_dict(), "motif_signature_hash")
                == text_field(other.to_dict(), "motif_signature_hash")
            )
        rows.append(
            {
                "representation": name,
                "same_problem_fraction": float(np.mean(same_problem)),
                "same_corpus_fraction": float(np.mean(same_corpus)),
                "same_canonical_netlist_fraction": float(np.mean(same_netlist)),
                "same_motif_signature_fraction": float(np.mean(same_motif)),
            }
        )
    return pd.DataFrame(rows)


def archive_metrics(aggregate: pd.DataFrame, front: pd.DataFrame, collapse: pd.DataFrame) -> pd.DataFrame:
    lexical = aggregate.loc[aggregate["representation"].eq("lexical_farthest")].iloc[0]
    merged = aggregate.merge(front, on="representation", how="left").merge(collapse, on="representation", how="left")
    rows = []
    for row in merged.to_dict("records"):
        rows.append(
            {
                "representation": row["representation"],
                "selected_hypervolume": to_float(row["selected_hypervolume"]),
                "delta_hv_vs_lexical": to_float(row["selected_hypervolume"])
                - to_float(lexical["selected_hypervolume"]),
                "selected_pareto_size": to_int(row["selected_pareto_size"]),
                "front_hits": optional_int(row.get("selected_all_valid_front_hits")),
                "unique_ppa_points": optional_int(row.get("unique_ppa_points")),
                "same_problem_fraction": optional_float(row.get("same_problem_fraction")),
                "same_corpus_fraction": optional_float(row.get("same_corpus_fraction")),
                "unique_canonical_netlists": to_int(row["unique_canonical_netlists"]),
                "unique_motif_signatures": to_int(row["unique_motif_signatures"]),
            }
        )
    return pd.DataFrame(rows)


def latent_diagnostics(
    candidates: pd.DataFrame,
    matrices: dict[str, np.ndarray],
    features: pd.DataFrame,
) -> pd.DataFrame:
    graph_size = features["log_node_count"].to_numpy(dtype=float)
    rows = []
    for name, matrix in matrices.items():
        if name == "lexical_farthest":
            continue
        normalized = normalize_rows(matrix)
        cosine = normalized @ normalized.T
        upper = cosine[np.triu_indices_from(cosine, k=1)]
        pc1 = pca2(matrix)[:, 0]
        rows.append(
            {
                "representation": name,
                "dimension": matrix.shape[1],
                "mean_pairwise_cosine": float(np.mean(upper)),
                "std_pairwise_cosine": float(np.std(upper)),
                "pc1_graph_size_correlation": corr(pc1, graph_size),
                "unique_problem_count": int(candidates["problem_id"].nunique()),
            }
        )
    return pd.DataFrame(rows)


def plot_hypervolume(aggregate: pd.DataFrame, path: Path) -> None:
    frame = aggregate.copy()
    frame["label"] = frame["representation"].map(label)
    frame = frame.sort_values("selected_hypervolume", ascending=False).head(10)
    colors = ["#54A24B" if str(rep).startswith("t13_") else "#4C78A8" for rep in frame["representation"]]
    fig, axis = plt.subplots(figsize=(8.8, 5.0))
    axis.barh(frame["label"], frame["selected_hypervolume"], color=colors)
    lexical = frame.loc[frame["representation"].eq("lexical_farthest")]
    if not lexical.empty:
        axis.axvline(float(lexical.iloc[0]["selected_hypervolume"]), color="#333333", linestyle="--", linewidth=1.0)
    axis.set_xlabel("Selected Hypervolume")
    axis.grid(True, axis="x", alpha=0.24)
    axis.invert_yaxis()
    fig.tight_layout()
    fig.savefig(path, dpi=180)
    plt.close(fig)


def plot_latent_projection(
    candidates: pd.DataFrame,
    matrices: dict[str, np.ndarray],
    aggregate: pd.DataFrame,
    path: Path,
) -> None:
    representation = best_t13(aggregate)
    projection = pca2(matrices[representation])
    fig, axis = plt.subplots(figsize=(7.2, 5.6))
    for corpus, group in candidates.assign(pc1=projection[:, 0], pc2=projection[:, 1]).groupby("corpus"):
        axis.scatter(group["pc1"], group["pc2"], s=24, alpha=0.72, label=str(corpus))
    axis.set_xlabel(f"{label(representation)} PC1")
    axis.set_ylabel(f"{label(representation)} PC2")
    axis.grid(True, alpha=0.22)
    axis.legend(fontsize=8)
    fig.tight_layout()
    fig.savefig(path, dpi=180)
    plt.close(fig)


def plot_reconstruction_vs_hv(training: pd.DataFrame, aggregate: pd.DataFrame, path: Path) -> None:
    rows = training.loc[training["checkpoint_generation"].astype(str).eq("")]
    frame = rows.merge(aggregate, on="representation", how="inner")
    fig, axis = plt.subplots(figsize=(7.4, 5.0))
    axis.scatter(frame["holdout_reconstruction_mse"], frame["selected_hypervolume"], s=52, color="#54A24B", alpha=0.78)
    for row in frame.to_dict("records"):
        axis.annotate(
            label(str(row["representation"])),
            (row["holdout_reconstruction_mse"], row["selected_hypervolume"]),
            fontsize=7,
        )
    axis.set_xlabel("Holdout Reconstruction MSE")
    axis.set_ylabel("Selected Hypervolume")
    axis.grid(True, alpha=0.24)
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
    reps = ["lexical_farthest", "random", best_t13(aggregate)]
    fig, axes = plt.subplots(1, 2, figsize=(13.2, 5.6))
    for panel_index, axis in enumerate(axes):
        draw_area_power_panel(axis, all_valid, selected_group, reps, panel_index == 0)
    t33_replay.set_pareto_zoom(axes[1], all_valid)
    axes[0].set_title("Full valid-PPA range")
    axes[1].set_title("Lower-left Pareto zoom")
    title = str(focus["problem_id"]).split("/")[-1]
    fig.suptitle(f"T13 Direct Area-Power Pareto Front: {title}")
    axes[0].legend(fontsize=8)
    fig.tight_layout()
    fig.savefig(path, dpi=180)
    plt.close(fig)


def plot_multi_problem_area_power_front(
    candidates: pd.DataFrame,
    selected: pd.DataFrame,
    aggregate: pd.DataFrame,
    path: Path,
) -> None:
    reps = ["lexical_farthest", "random", best_t13(aggregate)]
    groups = front_groups(candidates, limit=4)
    fig, axes = plt.subplots(2, 2, figsize=(13.0, 9.2), squeeze=False)
    handles = []
    labels = []
    for axis, focus_row in zip(axes.ravel(), groups, strict=False):
        focus = pd.Series(focus_row)
        all_valid = focus_candidates(candidates, focus)
        selected_group = focus_candidates(selected, focus)
        draw_area_power_panel(axis, all_valid, selected_group, reps, True)
        axis.set_title(str(focus["problem_id"]).split("/")[-1], fontsize=10)
        axis.text(
            0.02,
            0.96,
            "lower-left is better",
            transform=axis.transAxes,
            fontsize=8,
            color="#333333",
            va="top",
            bbox={"facecolor": "white", "edgecolor": "none", "alpha": 0.7, "pad": 2.0},
        )
        axis_handles, axis_labels = axis.get_legend_handles_labels()
        handles.extend(axis_handles)
        labels.extend(axis_labels)
    for axis in axes.ravel()[len(groups) :]:
        axis.axis("off")
    unique = dict(zip(labels, handles, strict=True))
    fig.legend(unique.values(), unique.keys(), loc="lower center", ncol=min(len(unique), 4), fontsize=8)
    fig.suptitle("T13 Raw Area-Power Pareto Fronts Across Representative Problems")
    fig.tight_layout(rect=(0, 0.06, 1, 0.96))
    fig.savefig(path, dpi=180)
    plt.close(fig)


def draw_area_power_panel(
    axis: Any,
    all_valid: pd.DataFrame,
    selected_group: pd.DataFrame,
    reps: list[str],
    with_labels: bool,
) -> None:
    axis.scatter(
        all_valid["area"],
        all_valid["power"],
        color="#B8B8B8",
        s=24,
        alpha=0.3,
        label="all valid" if with_labels else "_nolegend_",
    )
    t33_replay.draw_front(axis, all_valid, "#111111", "all-valid front" if with_labels else "_nolegend_")
    for representation in reps:
        rows = selected_group.loc[selected_group["representation"].eq(representation)]
        if rows.empty:
            continue
        color = representation_color(representation)
        axis.scatter(
            rows["area"],
            rows["power"],
            s=44,
            label=label(representation) if with_labels else "_nolegend_",
            color=color,
            edgecolor="#222222",
            linewidth=0.35,
        )
        t33_replay.draw_front(axis, rows, color, "_nolegend_")
    axis.set_xlabel("Area (lower is better)")
    axis.set_ylabel("Power (lower is better)")
    axis.grid(True, alpha=0.2)


def ppa_front_plot_points(candidates: pd.DataFrame, selected: pd.DataFrame, aggregate: pd.DataFrame) -> pd.DataFrame:
    rows = []
    best = best_t13(aggregate)
    for focus_row in front_groups(candidates, limit=4):
        focus = pd.Series(focus_row)
        all_valid = focus_candidates(candidates, focus)
        all_front = t33_replay.all_valid_area_power_front(all_valid)
        for row in all_valid.to_dict("records"):
            rows.append(plot_point_row(row, "all_valid", "all_valid", all_front))
        selected_group = focus_candidates(selected, focus)
        for representation in ("lexical_farthest", "random", best):
            for row in selected_group.loc[selected_group["representation"].eq(representation)].to_dict("records"):
                rows.append(plot_point_row(row, representation, "selected", all_front))
    return pd.DataFrame(rows)


def front_groups(candidates: pd.DataFrame, limit: int) -> list[dict[str, object]]:
    valid = candidates.loc[candidates["valid_ppa"].astype(bool)]
    rows = []
    for key, group in valid.groupby(["corpus", "method", "seed", "problem_id"], sort=True):
        corpus, method, seed, problem = cast(tuple[str, str, int, str], key)
        rows.append(
            {
                "corpus": corpus,
                "method": method,
                "seed": int(seed),
                "problem_id": problem,
                "unique_ppa_points": t33_replay.unique_ppa_points(group),
                "front_points": len(t33_replay.pareto_rows(group)),
                "area_span": float(group["area"].max() - group["area"].min()),
                "power_span": float(group["power"].max() - group["power"].min()),
            }
        )
    frame = pd.DataFrame(rows)
    assert not frame.empty
    return (
        frame.sort_values(
            ["unique_ppa_points", "front_points", "area_span", "power_span"],
            ascending=False,
        )
        .head(limit)
        .to_dict("records")
    )


def focus_candidates(frame: pd.DataFrame, focus: pd.Series) -> pd.DataFrame:
    return frame.loc[
        frame["corpus"].eq(focus["corpus"])
        & frame["method"].eq(focus["method"])
        & frame["seed"].eq(focus["seed"])
        & frame["problem_id"].eq(focus["problem_id"])
    ]


def plot_point_row(
    row: dict[str, object],
    representation: str,
    point_type: str,
    all_front: set[tuple[float, float]],
) -> dict[str, object]:
    point = (round(to_float(row["area"]), 9), round(to_float(row["power"]), 12))
    return {
        "representation": representation,
        "point_type": point_type,
        "corpus": row["corpus"],
        "method": row["method"],
        "seed": to_int(row["seed"]),
        "problem_id": row["problem_id"],
        "candidate_id": row["candidate_id"],
        "area": to_float(row["area"]),
        "power": to_float(row["power"]),
        "eff_clk_period": to_float(row["eff_clk_period"]),
        "fitness": to_float(row["fitness"]),
        "is_all_valid_area_power_front": point in all_front,
    }


def nearest_indices(matrix: np.ndarray) -> np.ndarray:
    normalized = normalize_rows(matrix)
    cosine = normalized @ normalized.T
    np.fill_diagonal(cosine, -np.inf)
    return cosine.argmax(axis=1)


def normalize_rows(matrix: np.ndarray) -> np.ndarray:
    norms = np.linalg.norm(matrix, axis=1, keepdims=True)
    norms[norms == 0.0] = 1.0
    return matrix / norms


def pca2(matrix: np.ndarray) -> np.ndarray:
    centered = matrix - matrix.mean(axis=0, keepdims=True)
    _, _, basis = np.linalg.svd(centered, full_matrices=False)
    return centered @ basis[:2].T


def best_t13(aggregate: pd.DataFrame) -> str:
    rows = aggregate.loc[aggregate["representation"].astype(str).str.startswith("t13_")]
    assert not rows.empty
    return str(rows.sort_values("selected_hypervolume", ascending=False).iloc[0]["representation"])


def label(representation: str) -> str:
    return DISPLAY.get(
        representation,
        representation.replace("_farthest", "").replace("t13_", "").replace("_", " "),
    )


def representation_color(representation: str) -> str:
    if representation.startswith("t13_"):
        return "#54A24B"
    if representation == "lexical_farthest":
        return "#4C78A8"
    if representation == "random":
        return "#BAB0AC"
    return "#F58518"


def numeric(series: Any) -> np.ndarray:
    values = np.asarray(pd.to_numeric(series, errors="raise"), dtype=float)
    assert not np.isnan(values).any()
    return values


def stable_hash(text: str) -> str:
    return hashlib.sha256(text.encode("utf-8")).hexdigest()[:16]


def mse(actual: np.ndarray, predicted: np.ndarray) -> float:
    if len(actual) == 0:
        return math.nan
    return float(np.mean((actual - predicted) ** 2))


def corr(left: np.ndarray, right: np.ndarray) -> float:
    if np.std(left) == 0.0 or np.std(right) == 0.0:
        return math.nan
    return float(np.corrcoef(left, right)[0, 1])


def text_field(row: dict[str, Any], key: str) -> str:
    value = row.get(key, "")
    if pd.isna(value):
        return ""
    return str(value)


def optional_float(value: object) -> float:
    if value is None:
        return math.nan
    if isinstance(value, int | float | np.integer | np.floating):
        return float(value)
    return math.nan


def optional_int(value: object) -> int:
    if value is None:
        return 0
    if isinstance(value, int | float | np.integer | np.floating):
        return int(value)
    return 0


def to_int(value: object) -> int:
    assert isinstance(value, int | float | np.integer | np.floating)
    return int(value)


def to_float(value: object) -> float:
    assert isinstance(value, int | float | np.integer | np.floating)
    return float(value)


if __name__ == "__main__":
    raise SystemExit(main())
