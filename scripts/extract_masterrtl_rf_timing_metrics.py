#!/usr/bin/env python3
"""Extract MasterRTL RF timing-state metrics from a parsed SOG graph."""

from __future__ import annotations

import argparse
import importlib
import json
import os
import pickle
import sys
from pathlib import Path
from typing import Any

import numpy as np


PATH_FEATURE_COUNT = 8


class CapturingModel:
    def __init__(self, model: Any) -> None:
        self.model = model
        self.features: list[np.ndarray] = []

    def predict(self, features: Any) -> np.ndarray:
        matrix = np.asarray(features, dtype=float)
        self.features.append(matrix)
        return np.asarray(self.model.predict(matrix), dtype=float)


def main() -> None:
    args = parse_args()
    args.master_root = args.master_root.resolve()
    args.parse_dir = args.parse_dir.resolve()
    args.model = args.model.resolve()
    args.output = args.output.resolve()
    assert os.environ.get("PYTHONHASHSEED") == "0"
    assert args.master_root.is_dir()
    assert args.parse_dir.is_dir()
    assert args.model.is_file()

    sys.path.insert(0, str(args.master_root / "vlg2ir"))
    sys.path.insert(0, str(args.master_root / "preproc/timing"))
    sys.path.insert(0, str(args.master_root / "feature_extract/timing"))

    graph, node_dict = load_graph(args.parse_dir, args.stem)
    metrics = extract_metrics(args.master_root, graph, node_dict, args.model, args.stem)
    args.output.write_text(json.dumps(metrics, indent=2, sort_keys=True) + "\n")


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--master-root", type=Path, required=True)
    parser.add_argument("--parse-dir", type=Path, required=True)
    parser.add_argument("--stem", required=True)
    parser.add_argument("--model", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    return parser.parse_args()


def load_graph(parse_dir: Path, stem: str) -> tuple[Any, Any]:
    with (parse_dir / f"{stem}_sog.pkl").open("rb") as handle:
        graph = pickle.load(handle)
    with (parse_dir / f"{stem}_sog_node_dict.pkl").open("rb") as handle:
        node_dict = pickle.load(handle)
    return graph, node_dict


def extract_metrics(
    master_root: Path,
    graph: Any,
    node_dict: Any,
    model_path: Path,
    stem: str,
) -> dict[str, float | int]:
    joblib = importlib.import_module("joblib")
    model = joblib.load(model_path)
    assert int(model.n_features_in_) == PATH_FEATURE_COUNT
    model.n_jobs = 1

    dg = importlib.import_module("DG")
    os.chdir(master_root / "preproc/timing")
    delay = importlib.import_module("delay_propagation")
    graph_obj = dg.Graph()
    graph_obj.init_graph(graph, node_dict)
    graph_new, node_dict_new = delay.graph_update(graph_obj)
    graph_init = dg.Graph()
    graph_init.init_graph(graph_new, node_dict_new)
    node_dict_init = delay.init_node_dict(graph_init)
    if not any("_CK_" in str(name) for name in graph_new.nodes):
        return no_path_metrics()
    if not any("_Q_" in str(name) for name in graph_new.nodes):
        return no_path_metrics()

    os.chdir(master_root / "feature_extract/timing")
    nx = importlib.import_module("networkx")
    logic_graph = importlib.import_module("logicGraph")
    capture = CapturingModel(model)
    timing_graph = dg.Graph()
    timing_graph.init_graph(nx.to_dict_of_lists(graph_new), node_dict_init)
    prediction, _heap = logic_graph.ProcessGraph(timing_graph).Graph_STA(capture, stem)
    if prediction is None:
        return no_path_metrics()
    assert capture.features
    features = sort_matrix(np.concatenate(capture.features, axis=0))
    assert features.shape[1] == PATH_FEATURE_COUNT
    predictions = np.asarray(model.predict(features), dtype=float)
    leaves = np.asarray(model.apply(features), dtype=int)
    return {
        "path_count": int(features.shape[0]),
        "unique_leaf_rows": unique_rows(leaves),
        "unique_leaf_ids": int(len(set(leaves.reshape(-1).tolist()))),
        "no_path_flag": 0,
        "prediction_mean": float(predictions.mean()),
    }


def no_path_metrics() -> dict[str, float | int]:
    return {
        "path_count": 0,
        "unique_leaf_rows": 0,
        "unique_leaf_ids": 0,
        "no_path_flag": 1,
        "prediction_mean": 0.0,
    }


def sort_matrix(matrix: np.ndarray) -> np.ndarray:
    assert matrix.ndim == 2
    keys = tuple(matrix[:, index] for index in reversed(range(matrix.shape[1])))
    return matrix[np.lexsort(keys)]


def unique_rows(matrix: np.ndarray) -> int:
    return int(len({tuple(row.tolist()) for row in matrix}))


if __name__ == "__main__":
    main()
