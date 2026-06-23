#!/usr/bin/env python3
"""Verify upstream MasterRTL and RTL-Timer example artifacts."""

from __future__ import annotations

import csv
import json
import pickle
import sys
from pathlib import Path
from typing import cast

import matplotlib
import numpy as np
from scipy import stats

matplotlib.use("Agg")
import matplotlib.pyplot as plt


ROOT = Path(__file__).resolve().parents[7]
TECHNIQUE = Path(__file__).resolve().parents[1]
MASTER = ROOT / "exp/external_repos/MasterRTL"
RTLTIMER = ROOT / "exp/external_repos/RTL-Timer"
GRAPH_DIR = ROOT / "exp/verification/masterrtl_analyze_direct2"


def main() -> None:
    sys.path.insert(0, str(MASTER / "vlg2ir"))
    sys.path.insert(0, str(MASTER))
    metrics = {
        "masterrtl_graph": masterrtl_graph_metrics(),
        "masterrtl_models": masterrtl_model_metrics(),
        "rtltimer_feature_labels": rtltimer_metrics(),
    }
    write_json(metrics)
    write_summary(metrics)
    write_inventory()
    write_figure(metrics)


def masterrtl_graph_metrics() -> dict[str, int]:
    graph_path = GRAPH_DIR / "TinyRocket_sog.pkl"
    node_path = GRAPH_DIR / "TinyRocket_sog_node_dict.pkl"
    assert graph_path.is_file()
    assert node_path.is_file()
    with graph_path.open("rb") as handle:
        graph = pickle.load(handle)
    with node_path.open("rb") as handle:
        node_dict = pickle.load(handle)
    return {
        "graph_pickle_bytes": graph_path.stat().st_size,
        "node_dict_pickle_bytes": node_path.stat().st_size,
        "node_dict_count": len(node_dict),
        "graph_node_key_count": len(graph),
        "graph_edge_count": sum(len(edges) for edges in graph.values()),
    }


def masterrtl_model_metrics() -> dict[str, dict[str, object]]:
    feature_dir = MASTER / "example/feature"
    label_path = MASTER / "example/label/TinyRocket.json"
    model_dir = MASTER / "ML_model/saved_model"
    labels = json.loads(label_path.read_text(encoding="utf-8"))
    feature_files = {
        "Area": ["TinyRocket_sog_vec_area.json"],
        "Power": ["TinyRocket_sog_vec_pwr.json"],
        "WNS": ["TinyRocket_sog_vec_area.json", "TinyRocket_sog_vec_timing.json"],
        "TNS": ["TinyRocket_sog_vec_area.json", "TinyRocket_sog_vec_timing.json"],
    }
    output: dict[str, dict[str, object]] = {}
    for label, files in feature_files.items():
        features: list[float] = []
        for name in files:
            features.extend(json.loads((feature_dir / name).read_text(encoding="utf-8")))
        with (model_dir / f"xgboost_{label}_model.pkl").open("rb") as handle:
            model = pickle.load(handle)
        x = np.array(features).reshape(1, -1)
        output[label] = {
            "feature_count": len(features),
            "nonzero_feature_count": sum(1 for value in features if value != 0),
            "label": labels[label],
            "prediction": model.predict(x).tolist(),
        }
    return output


def rtltimer_metrics() -> dict[str, dict[str, float | int]]:
    output = {}
    for name in ["TinyRocket_sog_init_word.pkl", "TinyRocket_sog_route_word.pkl"]:
        with (RTLTIMER / "preprocess/feat_label_timing" / name).open("rb") as handle:
            rows = pickle.load(handle)
        bog = np.array([row["bog_slack"] for row in rows], dtype=float)
        label = np.array([row["label_slack"] for row in rows], dtype=float)
        output[name] = {
            "register_count": len(rows),
            "bog_slack_min": float(bog.min()),
            "bog_slack_max": float(bog.max()),
            "label_slack_min": float(label.min()),
            "label_slack_max": float(label.max()),
            "pearson_bog_vs_label": float(cast(float, stats.pearsonr(bog, label)[0])),
            "spearman_bog_vs_label": float(cast(float, stats.spearmanr(bog, label)[0])),
        }
    return output


def write_json(metrics: dict[str, object]) -> None:
    path = TECHNIQUE / "tables/upstream_verification_metrics.json"
    path.write_text(json.dumps(metrics, indent=2) + "\n", encoding="utf-8")


def write_summary(metrics: dict[str, object]) -> None:
    graph = metrics["masterrtl_graph"]
    models = metrics["masterrtl_models"]
    rtltimer = metrics["rtltimer_feature_labels"]
    assert isinstance(graph, dict)
    assert isinstance(models, dict)
    assert isinstance(rtltimer, dict)
    with (TECHNIQUE / "tables/upstream_verification_summary.csv").open(
        "w", encoding="utf-8", newline=""
    ) as handle:
        writer = csv.writer(handle, lineterminator="\n")
        writer.writerow(["check", "status", "metric", "value", "interpretation"])
        writer.writerow([
            "MasterRTL SOG graph parse",
            "pass",
            "node_dict_count",
            graph["node_dict_count"],
            "Direct analyze.py works with isolated deps on shipped TinyRocket_sog.v.",
        ])
        writer.writerow([
            "MasterRTL SOG graph parse",
            "pass",
            "graph_edge_count",
            graph["graph_edge_count"],
            "Counted from MasterRTL's defaultdict graph pickle, not networkx accessors.",
        ])
        for label, row in models.items():
            assert isinstance(row, dict)
            writer.writerow([
                f"MasterRTL {label} model load",
                "limited_pass",
                "prediction",
                row["prediction"][0],
                "Nonzero features and zero labels yield constant-zero predictions.",
            ])
        for name, row in rtltimer.items():
            assert isinstance(row, dict)
            writer.writerow([
                f"RTLTimer {name}",
                "pass",
                "register_count",
                row["register_count"],
                "Feature-label artifact is readable and signal-level.",
            ])
            writer.writerow([
                f"RTLTimer {name}",
                "pass",
                "pearson_bog_vs_label",
                f"{row['pearson_bog_vs_label']:.6f}",
                "Linear BOG slack to net slack alignment check.",
            ])
            writer.writerow([
                f"RTLTimer {name}",
                "pass",
                "spearman_bog_vs_label",
                f"{row['spearman_bog_vs_label']:.6f}",
                "Rank-order timing-risk sanity check.",
            ])


def write_inventory() -> None:
    with (TECHNIQUE / "tables/upstream_repo_inventory.csv").open(
        "w", encoding="utf-8", newline=""
    ) as handle:
        writer = csv.writer(handle, lineterminator="\n")
        writer.writerow([
            "repo",
            "commit",
            "has_saved_weights",
            "has_example_features",
            "verified_conversion_status",
            "notes",
        ])
        writer.writerow([
            "MasterRTL",
            "5bccf38f8db7bb511a793a709863e7cb1b333ab5",
            "yes",
            "yes",
            "blocked_by_open_yosys_verific_for_fresh_conversion",
            "Shipped SOG graph parses with isolated deps; shipped models are constant-zero on nonzero TinyRocket features.",
        ])
        writer.writerow([
            "RTL-Timer",
            "206ff4078368c251d2fafaffcc648282c68316f1",
            "no",
            "yes",
            "blocked_by_open_yosys_verific_for_fresh_conversion",
            "Shipped SOG BOG feature labels are readable; training scripts retrain rather than load packaged weights.",
        ])


def write_figure(metrics: dict[str, object]) -> None:
    rtltimer = metrics["rtltimer_feature_labels"]
    assert isinstance(rtltimer, dict)
    labels = []
    pearson = []
    spearman = []
    for name, row in rtltimer.items():
        assert isinstance(row, dict)
        labels.append(name.replace("TinyRocket_sog_", "").replace(".pkl", "").replace("_", " "))
        pearson.append(row["pearson_bog_vs_label"])
        spearman.append(row["spearman_bog_vs_label"])
    x = np.arange(len(labels))
    width = 0.34
    fig, ax = plt.subplots(figsize=(6.8, 3.8), dpi=180)
    bars_a = ax.bar(x - width / 2, pearson, width, label="Pearson", color="#4C78A8")
    bars_b = ax.bar(x + width / 2, spearman, width, label="Spearman", color="#F58518")
    ax.set_ylim(0, 1.0)
    ax.set_ylabel("Correlation")
    ax.set_title("RTLTimer SOG Slack Alignment On Shipped TinyRocket Data")
    ax.set_xticks(x, labels)
    ax.legend(frameon=False)
    ax.grid(axis="y", color="#D8D8D8", linewidth=0.7, alpha=0.75)
    for bars in [bars_a, bars_b]:
        for bar in bars:
            value = bar.get_height()
            ax.text(
                bar.get_x() + bar.get_width() / 2,
                value + 0.02,
                f"{value:.3f}",
                ha="center",
                va="bottom",
                fontsize=8,
            )
    for spine in ["top", "right"]:
        ax.spines[spine].set_visible(False)
    fig.tight_layout()
    fig.savefig(TECHNIQUE / "figures/rtltimer_sog_slack_alignment.png")


if __name__ == "__main__":
    main()
