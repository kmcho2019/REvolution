#!/usr/bin/env python3
"""Probe MasterRTL RF timing leaf states on generated RTL candidates."""

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
from pathlib import Path
from typing import Any

import matplotlib
import networkx as nx
import numpy as np

matplotlib.use("Agg")
import matplotlib.pyplot as plt


ROOT = Path(__file__).resolve().parents[7]
TECHNIQUE = Path(__file__).resolve().parents[1]
MASTER = ROOT / "exp/external_repos/MasterRTL"
T70_RESULTS = (
    ROOT
    / "docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push"
    / "techniques/T70_generated_rtl_extractor_smoke/tables/t70_extractor_results.csv"
)
RF_MODEL = MASTER / "ML_model/saved_model/rfr_model.pkl"
RF_FEATURES = MASTER / "ML_model/saved_data/feat_all_lst.pkl"
PATH_FEATURE_NAMES = (
    "path_delay",
    "path_len",
    "mux_ops",
    "and_ops",
    "or_ops",
    "not_ops",
    "xor_ops",
    "reserved_zero",
)


class CapturingModel:
    def __init__(self, model: Any) -> None:
        self.model = model
        self.features: list[np.ndarray] = []

    def predict(self, features: Any) -> np.ndarray:
        matrix = np.asarray(features, dtype=float)
        self.features.append(matrix)
        return np.asarray(self.model.predict(matrix), dtype=float)


def main() -> None:
    assert MASTER.is_dir()
    assert T70_RESULTS.is_file()
    assert RF_MODEL.is_file()
    assert RF_FEATURES.is_file()
    assert os.environ.get("PYTHONHASHSEED") == "0"
    (TECHNIQUE / "tables").mkdir(exist_ok=True)
    (TECHNIQUE / "figures").mkdir(exist_ok=True)

    install_masterrtl_imports()
    rows = load_t70_rows()
    model, model_warnings = load_rf_model()
    train_features = load_training_features()
    candidate_rows, path_rows = run_candidates(rows, model, train_features)
    write_csv(TECHNIQUE / "tables/t81_candidate_timing_summary.csv", candidate_rows)
    write_csv(TECHNIQUE / "tables/t81_path_feature_rows.csv", path_rows)
    write_summary(candidate_rows, path_rows, model_warnings, train_features)
    write_figure(candidate_rows)


def install_masterrtl_imports() -> None:
    sys.path.insert(0, str((MASTER / "vlg2ir").resolve()))
    sys.path.insert(0, str((MASTER / "preproc/timing").resolve()))


def load_t70_rows() -> list[dict[str, str]]:
    with T70_RESULTS.open() as handle:
        rows = list(csv.DictReader(handle))
    assert len(rows) == 19
    assert all(row["masterrtl_parse_ok"] == "True" for row in rows)
    return rows


def load_rf_model() -> tuple[Any, list[str]]:
    joblib = importlib.import_module("joblib")
    with warnings.catch_warnings(record=True) as records:
        warnings.simplefilter("always")
        model = joblib.load(RF_MODEL)
    assert int(model.n_features_in_) == len(PATH_FEATURE_NAMES)
    model.n_jobs = 1
    return model, [" ".join(str(item.message).split()) for item in records]


def load_training_features() -> np.ndarray:
    with RF_FEATURES.open("rb") as handle:
        features = np.asarray(pickle.load(handle), dtype=float)
    assert features.ndim == 2
    assert features.shape[1] == len(PATH_FEATURE_NAMES)
    return features


def run_candidates(
    rows: list[dict[str, str]],
    model: Any,
    training_features: np.ndarray,
) -> tuple[list[dict[str, Any]], list[dict[str, Any]]]:
    candidate_rows: list[dict[str, Any]] = []
    path_rows: list[dict[str, Any]] = []
    for row in rows:
        result = run_candidate(row, model, training_features)
        candidate_rows.append(result["candidate"])
        path_rows.extend(result["paths"])
    return candidate_rows, path_rows


def run_candidate(
    row: dict[str, str],
    model: Any,
    training_features: np.ndarray,
) -> dict[str, Any]:
    graph, node_dict = load_masterrtl_graph(row)
    delay = import_delay_module()
    dg = importlib.import_module("DG")
    graph_obj = dg.Graph()
    graph_obj.init_graph(graph, node_dict)
    graph_new, node_dict_new = delay.graph_update(graph_obj)
    graph_init = dg.Graph()
    graph_init.init_graph(graph_new, node_dict_new)
    node_dict_init = delay.init_node_dict(graph_init)
    if not any("_CK_" in str(name) for name in graph_new.nodes):
        return skipped_candidate(row, "no_clock_split")
    if not any("_Q_" in str(name) for name in graph_new.nodes):
        return skipped_candidate(row, "no_timing_endpoint")

    logic_graph = import_feature_timing_logic()
    capture = CapturingModel(model)
    timing_graph = dg.Graph()
    timing_graph.init_graph(nx.to_dict_of_lists(graph_new), node_dict_init)
    os.chdir(MASTER / "feature_extract/timing")
    process = logic_graph.ProcessGraph(timing_graph)
    prediction, _heap = process.Graph_STA(capture, row["candidate_id"])
    if prediction is None:
        return skipped_candidate(row, "no_timing_paths")
    features = sort_matrix(np.concatenate(capture.features, axis=0))
    prediction_array = np.asarray(model.predict(features), dtype=float)
    leaves = np.asarray(model.apply(features), dtype=int)
    return {
        "candidate": candidate_summary(row, features, prediction_array, leaves, training_features),
        "paths": path_feature_rows(row, features, prediction_array, leaves),
    }


def load_masterrtl_graph(row: dict[str, str]) -> tuple[Any, Any]:
    parse_dir = ROOT / row["artifact_dir"] / "masterrtl/parse"
    stem = f"{row['candidate_id']}_sog"
    graph_path = parse_dir / f"{stem}.pkl"
    node_path = parse_dir / f"{stem}_node_dict.pkl"
    assert graph_path.is_file()
    assert node_path.is_file()
    with graph_path.open("rb") as handle:
        graph = pickle.load(handle)
    with node_path.open("rb") as handle:
        node_dict = pickle.load(handle)
    return graph, node_dict


def import_delay_module() -> Any:
    os.chdir(MASTER / "preproc/timing")
    return importlib.import_module("delay_propagation")


def import_feature_timing_logic() -> Any:
    sys.modules.pop("logicGraph", None)
    sys.modules.pop("graph_stat", None)
    sys.path.insert(0, str((MASTER / "feature_extract/timing").resolve()))
    return importlib.import_module("logicGraph")


def skipped_candidate(row: dict[str, str], status: str) -> dict[str, Any]:
    return {
        "candidate": {
            "candidate_id": row["candidate_id"],
            "problem": row["problem"],
            "kind": row["kind"],
            "status": status,
            "path_count": 0,
            "unique_path_feature_rows": 0,
            "prediction_mean": "",
            "prediction_std": "",
            "prediction_min": "",
            "prediction_max": "",
            "unique_leaf_rows": 0,
            "unique_leaf_ids": 0,
            "out_of_range_fraction": "",
        },
        "paths": [],
    }


def candidate_summary(
    row: dict[str, str],
    features: np.ndarray,
    prediction: np.ndarray,
    leaves: np.ndarray,
    training_features: np.ndarray,
) -> dict[str, Any]:
    return {
        "candidate_id": row["candidate_id"],
        "problem": row["problem"],
        "kind": row["kind"],
        "status": "evaluated",
        "path_count": int(features.shape[0]),
        "unique_path_feature_rows": unique_rows(features),
        "prediction_mean": float(prediction.mean()),
        "prediction_std": float(prediction.std()),
        "prediction_min": float(prediction.min()),
        "prediction_max": float(prediction.max()),
        "unique_leaf_rows": unique_rows(leaves),
        "unique_leaf_ids": int(len(set(leaves.reshape(-1).tolist()))),
        "out_of_range_fraction": out_of_range_fraction(features, training_features),
    }


def path_feature_rows(
    row: dict[str, str],
    features: np.ndarray,
    prediction: np.ndarray,
    leaves: np.ndarray,
) -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    for index, (feature_row, pred, leaf_row) in enumerate(
        zip(features, prediction, leaves, strict=True)
    ):
        rows.append(
            {
                "candidate_id": row["candidate_id"],
                "problem": row["problem"],
                "path_index": index,
                **dict(zip(PATH_FEATURE_NAMES, feature_row.tolist(), strict=True)),
                "rf_prediction": float(pred),
                "leaf_row_hash": hashlib.sha256(
                    json.dumps(leaf_row.tolist()).encode()
                ).hexdigest(),
                "leaf_ids_json": json.dumps(leaf_row.tolist()),
            }
        )
    return rows


def unique_rows(matrix: np.ndarray) -> int:
    return int(len({tuple(row.tolist()) for row in matrix}))


def sort_matrix(matrix: np.ndarray) -> np.ndarray:
    assert matrix.ndim == 2
    keys = tuple(matrix[:, index] for index in reversed(range(matrix.shape[1])))
    return matrix[np.lexsort(keys)]


def out_of_range_fraction(features: np.ndarray, training_features: np.ndarray) -> float:
    lower = training_features.min(axis=0)
    upper = training_features.max(axis=0)
    outside = (features < lower) | (features > upper)
    return float(outside.sum() / outside.size)


def write_summary(
    candidate_rows: list[dict[str, Any]],
    path_rows: list[dict[str, Any]],
    model_warnings: list[str],
    training_features: np.ndarray,
) -> None:
    evaluated = [row for row in candidate_rows if row["status"] == "evaluated"]
    summary = {
        "tier": "T0_model_state_gate_positive_not_live",
        "masterrtl_commit": git_head(MASTER),
        "candidate_count": len(candidate_rows),
        "evaluated_candidates": len(evaluated),
        "path_count": len(path_rows),
        "unique_leaf_rows": len({row["leaf_row_hash"] for row in path_rows}),
        "unique_leaf_ids": unique_leaf_ids(path_rows),
        "training_feature_shape": list(training_features.shape),
        "model_warnings": model_warnings,
        "decision": (
            "RF timing state descriptors are evaluated as an offline generated-"
            "candidate gate only. A live BD is allowed only if the report shows "
            "noncollapsed leaves, acceptable feature-range coverage, and honest "
            "coverage limits for combinational candidates."
        ),
    }
    (TECHNIQUE / "tables/t81_rf_timing_summary.json").write_text(
        json.dumps(summary, indent=2, sort_keys=True) + "\n"
    )


def unique_leaf_ids(path_rows: list[dict[str, Any]]) -> int:
    if not path_rows:
        return 0
    values: set[int] = set()
    for row in path_rows:
        values.update(json.loads(str(row["leaf_ids_json"])))
    return len(values)


def write_figure(candidate_rows: list[dict[str, Any]]) -> None:
    labels = [row["candidate_id"].replace("t70_", "") for row in candidate_rows]
    leaf_rows = [
        int(row["unique_leaf_rows"]) if row["status"] == "evaluated" else 0
        for row in candidate_rows
    ]
    path_counts = [
        int(row["path_count"]) if row["status"] == "evaluated" else 0
        for row in candidate_rows
    ]
    colors = [
        "#2563eb" if row["status"] == "evaluated" else "#a1a1aa"
        for row in candidate_rows
    ]

    fig, axes = plt.subplots(1, 2, figsize=(13, 6.5), sharey=True)
    y = np.arange(len(candidate_rows))
    axes[0].barh(y, path_counts, color=colors)
    axes[0].set_title("Timing paths captured")
    axes[0].set_xlabel("path count")
    axes[0].set_yticks(y, labels, fontsize=7)
    axes[0].invert_yaxis()
    axes[0].grid(axis="x", alpha=0.25)

    axes[1].barh(y, leaf_rows, color=colors)
    axes[1].set_title("Unique RF leaf rows")
    axes[1].set_xlabel("unique leaf rows")
    axes[1].grid(axis="x", alpha=0.25)

    fig.suptitle("MasterRTL RF Timing State Gate")
    fig.tight_layout()
    fig.savefig(TECHNIQUE / "figures/t81_rf_timing_state_gate.png", dpi=180)
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


def git_head(path: Path) -> str:
    return subprocess.check_output(
        ["git", "-C", str(path), "rev-parse", "HEAD"],
        text=True,
    ).strip()


if __name__ == "__main__":
    main()
