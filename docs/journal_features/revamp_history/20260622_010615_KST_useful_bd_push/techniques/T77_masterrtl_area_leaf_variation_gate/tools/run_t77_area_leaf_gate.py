#!/usr/bin/env python3
"""Check MasterRTL Area-head leaf variation on generated RTL candidates."""

from __future__ import annotations

import csv
import hashlib
import importlib
import json
import os
import pickle
import subprocess
import sys
import warnings
from contextlib import redirect_stdout
from io import StringIO
from pathlib import Path
from typing import Any, cast

import matplotlib
import numpy as np

matplotlib.use("Agg")
import matplotlib.pyplot as plt


ROOT = Path(__file__).resolve().parents[7]
TECHNIQUE = Path(__file__).resolve().parents[1]
MASTER = ROOT / "exp/external_repos/MasterRTL"
T70 = (
    ROOT
    / "docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push"
    / "techniques/T70_generated_rtl_extractor_smoke"
)
T70_RESULTS = T70 / "tables/t70_extractor_results.csv"
AREA_MODEL = MASTER / "ML_model/saved_model/xgboost_Area_model.pkl"

FEATURE_NAMES = (
    "dff_bits",
    "fanout",
    "io_bits",
    "and_ops",
    "or_ops",
    "not_ops",
    "xor_ops",
    "mux_ops",
    "seq_area",
    "comb_area",
    "total_area",
    "static_power",
    "dynamic_power",
    "total_power",
)


def main() -> None:
    assert T70_RESULTS.is_file()
    assert AREA_MODEL.is_file()
    tables = TECHNIQUE / "tables"
    figures = TECHNIQUE / "figures"
    tables.mkdir(exist_ok=True)
    figures.mkdir(exist_ok=True)

    rows = load_candidate_rows()
    area_rows = build_area_rows(rows)
    predictions, leaves, warnings_seen = run_area_head(area_rows)
    write_area_table(area_rows, predictions, leaves, warnings_seen)
    write_head_status()
    write_summary(area_rows, predictions, leaves, warnings_seen)
    write_feature_heatmap(area_rows, predictions, leaves)


def load_candidate_rows() -> list[dict[str, str]]:
    with T70_RESULTS.open() as handle:
        rows = list(csv.DictReader(handle))
    assert len(rows) == 19
    assert all(row["masterrtl_parse_ok"] == "True" for row in rows)
    return rows


def build_area_rows(rows: list[dict[str, str]]) -> list[dict[str, Any]]:
    sys.path.insert(0, str(MASTER / "vlg2ir"))
    os.chdir(MASTER / "feature_extract/area")
    dg = cast(Any, importlib.import_module("DG"))
    graph_stat = cast(Any, importlib.import_module("graph_stat"))

    area_rows: list[dict[str, Any]] = []
    for row in rows:
        graph_path, node_path = parse_paths(row)
        with graph_path.open("rb") as handle:
            graph = pickle.load(handle)
        with node_path.open("rb") as handle:
            node_dict = pickle.load(handle)
        graph_obj = dg.Graph()
        graph_obj.init_graph(graph, node_dict)
        with redirect_stdout(StringIO()):
            feature_values = graph_stat.cal_oper(graph_obj)
        assert len(feature_values) == len(FEATURE_NAMES)
        area_rows.append(
            {
                "candidate_id": row["candidate_id"],
                "problem": row["problem"],
                "kind": row["kind"],
                "code_sha256": row["code_sha256"],
                "graph_sha256": sha256(graph_path),
                "node_dict_sha256": sha256(node_path),
                **dict(zip(FEATURE_NAMES, feature_values, strict=True)),
            }
        )
    return area_rows


def parse_paths(row: dict[str, str]) -> tuple[Path, Path]:
    parse_dir = ROOT / row["artifact_dir"] / "masterrtl/parse"
    stem = f"{row['candidate_id']}_sog"
    graph_path = parse_dir / f"{stem}.pkl"
    node_path = parse_dir / f"{stem}_node_dict.pkl"
    assert graph_path.is_file()
    assert node_path.is_file()
    return graph_path, node_path


def run_area_head(
    area_rows: list[dict[str, Any]],
) -> tuple[np.ndarray, np.ndarray, list[str]]:
    features = np.array(
        [[row[name] for name in FEATURE_NAMES] for row in area_rows],
        dtype=float,
    )
    model, warnings_seen = load_pickle(AREA_MODEL)
    assert int(model.n_features_in_) == features.shape[1]
    return (
        np.asarray(model.predict(features), dtype=float),
        np.asarray(model.apply(features), dtype=float),
        warnings_seen,
    )


def load_pickle(path: Path) -> tuple[Any, list[str]]:
    with warnings.catch_warnings(record=True) as records:
        warnings.simplefilter("always")
        with path.open("rb") as handle:
            model = pickle.load(handle)
    return model, [" ".join(str(item.message).split()) for item in records]


def write_area_table(
    area_rows: list[dict[str, Any]],
    predictions: np.ndarray,
    leaves: np.ndarray,
    warnings_seen: list[str],
) -> None:
    rows: list[dict[str, Any]] = []
    for row, prediction, leaf_row in zip(area_rows, predictions, leaves, strict=True):
        rows.append(
            {
                **row,
                "predicted_area": float(prediction),
                "leaf_row_hash": hashlib.sha256(
                    json.dumps(leaf_row.tolist()).encode()
                ).hexdigest(),
                "unique_leaf_ids": len(set(leaf_row.tolist())),
                "model_warning_count": len(warnings_seen),
            }
        )
    write_csv(TECHNIQUE / "tables/t77_area_candidate_features.csv", rows)


def write_head_status() -> None:
    rows = [
        {
            "head": "Area",
            "status": "evaluated",
            "reason": "Uses source-faithful 14-feature cal_oper SOG vector.",
        },
        {
            "head": "Power",
            "status": "blocked",
            "reason": "Requires toggle-rate side data from synthesis/EDA flow.",
        },
        {
            "head": "WNS",
            "status": "blocked",
            "reason": "Requires MasterRTL timing DAG and path-delay feature flow.",
        },
        {
            "head": "TNS",
            "status": "blocked",
            "reason": "Requires MasterRTL timing DAG and path-delay feature flow.",
        },
    ]
    write_csv(TECHNIQUE / "tables/t77_head_status.csv", rows)


def write_summary(
    area_rows: list[dict[str, Any]],
    predictions: np.ndarray,
    leaves: np.ndarray,
    warnings_seen: list[str],
) -> None:
    feature_rows = {
        tuple(float(row[name]) for name in FEATURE_NAMES) for row in area_rows
    }
    leaf_rows = {tuple(row.tolist()) for row in leaves}
    summary = {
        "tier": "T0_variation_gate_negative",
        "masterrtl_commit": git_head(MASTER),
        "candidate_count": len(area_rows),
        "unique_area_feature_rows": len(feature_rows),
        "unique_area_predictions": int(len(set(predictions.tolist()))),
        "unique_leaf_rows": len(leaf_rows),
        "unique_leaf_ids": int(len(set(leaves.reshape(-1).tolist()))),
        "model_warnings": warnings_seen,
        "decision": (
            "MasterRTL source-faithful area features vary across generated "
            "candidates, but the pretrained Area head maps them all to the "
            "same prediction and leaf row. Do not advance Area-head leaves as "
            "a live BD without retraining or a different model source."
        ),
    }
    (TECHNIQUE / "tables/t77_variation_summary.json").write_text(
        json.dumps(summary, indent=2, sort_keys=True) + "\n"
    )


def write_feature_heatmap(
    area_rows: list[dict[str, Any]],
    predictions: np.ndarray,
    leaves: np.ndarray,
) -> None:
    matrix = np.array(
        [[row[name] for name in FEATURE_NAMES] for row in area_rows],
        dtype=float,
    )
    denom = matrix.std(axis=0)
    denom[denom == 0] = 1.0
    z_matrix = (matrix - matrix.mean(axis=0)) / denom
    leaf_rows = {tuple(row.tolist()) for row in leaves}

    fig = plt.figure(figsize=(13, 7))
    grid = fig.add_gridspec(1, 2, width_ratios=[5, 1.4])
    ax = fig.add_subplot(grid[0, 0])
    image = ax.imshow(z_matrix, aspect="auto", cmap="viridis")
    ax.set_title("MasterRTL Area Features Vary Across Generated RTL")
    ax.set_xlabel("Area feature")
    ax.set_ylabel("T70 candidate")
    ax.set_xticks(range(len(FEATURE_NAMES)))
    ax.set_xticklabels(FEATURE_NAMES, rotation=55, ha="right", fontsize=8)
    ax.set_yticks(range(len(area_rows)))
    ax.set_yticklabels(
        [str(row["candidate_id"]).replace("t70_", "") for row in area_rows],
        fontsize=6,
    )
    fig.colorbar(image, ax=ax, fraction=0.025, pad=0.02, label="z-score")

    ax2 = fig.add_subplot(grid[0, 1])
    ax2.bar(["features", "preds", "leaf rows"], [
        len({tuple(row.tolist()) for row in matrix}),
        len(set(predictions.tolist())),
        len(leaf_rows),
    ], color=["#287c8e", "#8f6a2f", "#8a3f5f"])
    ax2.set_title("Variation Gate")
    ax2.set_ylim(0, len(area_rows))
    ax2.set_ylabel("unique count")
    ax2.tick_params(axis="x", rotation=30)
    ax2.grid(axis="y", alpha=0.25)

    fig.tight_layout()
    fig.savefig(TECHNIQUE / "figures/t77_area_leaf_variation_gate.png", dpi=180)
    plt.close(fig)


def write_csv(path: Path, rows: list[dict[str, Any]]) -> None:
    assert rows
    with path.open("w", newline="") as handle:
        writer = csv.DictWriter(
            handle,
            fieldnames=list(rows[0].keys()),
            lineterminator="\n",
        )
        writer.writeheader()
        writer.writerows(rows)


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def git_head(path: Path) -> str:
    return subprocess.check_output(
        ["git", "-C", str(path), "rev-parse", "HEAD"],
        text=True,
    ).strip()


if __name__ == "__main__":
    main()
