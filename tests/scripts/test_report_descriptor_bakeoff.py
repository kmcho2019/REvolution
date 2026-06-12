from __future__ import annotations

import importlib.util
import json
import sys
from pathlib import Path

spec = importlib.util.spec_from_file_location(
    "report_descriptor_bakeoff",
    Path(__file__).resolve().parents[2] / "scripts" / "report_descriptor_bakeoff.py",
)
assert spec and spec.loader
rdb = importlib.util.module_from_spec(spec)
sys.modules["report_descriptor_bakeoff"] = rdb
spec.loader.exec_module(rdb)


def _profile_dirs(tmp_path, name, delta, mode, occupied, total, collapsed):
    stats = tmp_path / f"{name}_stats.json"
    stats.write_text(
        json.dumps(
            {"metrics": {"best_quality": {"mean_delta": delta, "wins": 1, "losses": 1, "ties": 0}}}
        ),
        encoding="utf-8",
    )
    root = tmp_path / name / "model" / "bench" / "Prob001"
    root.mkdir(parents=True)
    (root / "descriptor_health.json").write_text(
        json.dumps({"occupied_cells": occupied, "collapsed_axes": collapsed}),
        encoding="utf-8",
    )
    (root / "archive_space.json").write_text(
        json.dumps(
            {"initialization_mode": mode, "space_geometry": {"total_cells": total}}
        ),
        encoding="utf-8",
    )
    return stats, tmp_path / name


def test_bakeoff_ranking_and_floor(tmp_path, capsys):
    a_stats, a_root = _profile_dirs(tmp_path, "trio", -0.18, "warmup_patience_fallback", 1, 1, ["x", "y"])
    b_stats, b_root = _profile_dirs(tmp_path, "graph", -0.05, "warmup_complete", 10, 16, [])
    out = tmp_path / "report"

    rc = rdb.main(
        [
            "--profile", f"trio={a_stats}={a_root}",
            "--profile", f"graph={b_stats}={b_root}",
            "--output-dir", str(out),
        ]
    )

    assert rc == 0
    report = json.loads((out / "descriptor_bakeoff.json").read_text(encoding="utf-8"))
    assert report["ranking"] == ["graph", "trio"]
    graph = report["profiles"]["graph"]
    assert graph["warmup_completion_rate"] == 1.0
    assert graph["occupancy_floor_pass"] is True
    trio = report["profiles"]["trio"]
    assert trio["warmup_completion_rate"] == 0.0
    assert report["floor_failures"] == []  # trio occ 1/1 = 1.0 passes floor
    assert trio["collapse_counts"] == {"x": 1, "y": 1}
    assert (out / "descriptor_bakeoff.md").read_text(encoding="utf-8").count("|") > 10
