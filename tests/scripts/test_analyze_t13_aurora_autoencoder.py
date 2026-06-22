from __future__ import annotations

import importlib.util
import json
import sys
from pathlib import Path

import pandas as pd

_SCRIPT = Path(__file__).resolve().parents[2] / "scripts" / "analyze_t13_aurora_autoencoder.py"
_SPEC = importlib.util.spec_from_file_location("analyze_t13_aurora_autoencoder", _SCRIPT)
assert _SPEC is not None and _SPEC.loader is not None
mod = importlib.util.module_from_spec(_SPEC)
sys.modules.setdefault("analyze_t13_aurora_autoencoder", mod)
_SPEC.loader.exec_module(mod)


def test_analyze_t13_writes_aurora_replay_artifacts(tmp_path: Path) -> None:
    candidates = tmp_path / "candidates.csv"
    graph_manifest = tmp_path / "graph_manifest.csv"
    package_dir = tmp_path / "package"
    _write_inputs(candidates, graph_manifest)

    code = mod.main(
        [
            "--candidates-csv",
            str(candidates),
            "--graph-manifest-csv",
            str(graph_manifest),
            "--package-dir",
            str(package_dir),
            "--retention-fraction",
            "0.5",
            "--random-seed",
            "0",
            "--latent-dims",
            "2",
        ]
    )

    assert code == 0
    feature_manifest = pd.read_csv(package_dir / "tables" / "feature_manifest.csv")
    comparison = pd.read_csv(package_dir / "tables" / "ppa_comparison.csv")
    forbidden = {"area", "power", "fitness", "valid_ppa", "functionality_pass"}
    assert forbidden.isdisjoint(set(feature_manifest["source"]))
    assert "t13_pca2_farthest" in set(comparison["representation"])
    assert (package_dir / "tables" / "ppa_front_plot_points.csv").is_file()
    assert (package_dir / "figures" / "aurora_multi_problem_ppa_pareto_fronts.png").read_bytes().startswith(b"\x89PNG")
    assert (package_dir / "figures" / "aurora_hypervolume.png").read_bytes().startswith(b"\x89PNG")


def _write_inputs(candidates: Path, graph_manifest: Path) -> None:
    candidate_rows = []
    graph_rows = []
    ref = json.dumps({"area": 120.0, "power": 12.0, "eff_clk_period": 6.0})
    sample_index = 0
    for problem in _problem_ids():
        for generation in range(4):
            candidate_rows.append(_candidate_row(sample_index, problem, generation, ref))
            graph_rows.append(_graph_row(sample_index, problem))
            sample_index += 1
    pd.DataFrame(candidate_rows).to_csv(candidates, index=False)
    pd.DataFrame(graph_rows).to_csv(graph_manifest, index=False)


def _problem_ids() -> list[str]:
    problems = []
    splits = set()
    index = 0
    while len(problems) < 12 or splits != {"train", "validation", "holdout"}:
        problem = f"toy/Prob{index:03d}"
        bucket = int(mod.stable_hash(f"toy::{problem}"), 16) % 10
        split = "train" if bucket < 6 else "validation" if bucket < 8 else "holdout"
        problems.append(problem)
        splits.add(split)
        index += 1
    return problems


def _candidate_row(index: int, problem: str, generation: int, ref: str) -> dict[str, object]:
    row = {
        "corpus": "toy",
        "method": "classic",
        "seed": 1,
        "model": "toy",
        "benchmark": "RTLLM",
        "problem_id": problem,
        "generation": generation,
        "candidate_id": f"cand-{index}",
        "sample_index": index,
        "valid_ppa": True,
        "area": 120.0 - index,
        "power": 10.0 - index * 0.2,
        "eff_clk_period": 5.0 - index * 0.05,
        "fitness": float(index),
        "reference_ppa_json": ref,
        "canonical_netlist_hash": f"net-{index % 5}",
        "motif_signature_hash": f"motif-{index % 6}",
    }
    for feature in mod.RTL_FEATURES:
        row[feature] = float(index % 7 + 1)
    return row


def _graph_row(index: int, problem: str) -> dict[str, object]:
    row = {
        "sample_index": index,
        "candidate_id": f"cand-{index}",
        "corpus": "toy",
        "problem_id": problem,
        "netlist_path": f"/tmp/cand-{index}.v",
        "parse_status": "parsed",
        "node_count": 10 + index,
        "edge_count": 20 + index,
        "net_count": 15 + index,
        "max_level": index % 5,
        "unresolved_cycle_nodes": index % 3,
    }
    for feature in mod.GRAPH_FEATURES[5:]:
        row[feature] = index % 4
    return row
