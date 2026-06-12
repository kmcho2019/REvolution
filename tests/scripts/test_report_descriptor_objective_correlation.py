from __future__ import annotations

import csv
import importlib.util
import json
import sys
from pathlib import Path

_SCRIPT = (
    Path(__file__).resolve().parent.parent.parent
    / "scripts"
    / "report_descriptor_objective_correlation.py"
)
_SPEC = importlib.util.spec_from_file_location("rdoc", _SCRIPT)
assert _SPEC is not None and _SPEC.loader is not None
mod = importlib.util.module_from_spec(_SPEC)
sys.modules.setdefault("rdoc", mod)
_SPEC.loader.exec_module(mod)


def _write_problem(root: Path, problem: str, rows: list[tuple[list[float], float, float, float]]) -> None:
    pdir = root / "qd" / "model" / "RTLLM" / problem
    pdir.mkdir(parents=True, exist_ok=True)
    with (pdir / "archive_cells.csv").open("w", newline="") as handle:
        writer = csv.writer(handle)
        writer.writerow(["descriptors_json", "g_P", "g_A", "g_T"])
        for descriptors, g_p, g_a, g_t in rows:
            writer.writerow([json.dumps(descriptors), g_p, g_a, g_t])


def test_redundant_axis_flagged_independent_axis_ok(tmp_path):
    root = tmp_path / "run"
    # axis0 tracks g_A exactly (redundant); axis1 is independent noise.
    for problem in ("ProbA", "ProbB", "ProbC"):
        rows = []
        noise = [0.9, 0.1, 0.5, 0.7, 0.3, 0.2]
        for i in range(6):
            g_a = 0.1 * i
            rows.append(([g_a * 10.0, noise[i]], 0.0, g_a, 0.0))
        _write_problem(root, problem, rows)

    out = tmp_path / "report"
    code = mod.main(
        [
            "--run-root", str(root),
            "--axes", "axis0", "axis1",
            "--output-dir", str(out),
        ]
    )
    assert code == 0
    report = json.loads(
        (out / "descriptor_objective_correlation.json").read_text(encoding="utf-8")
    )
    assert report["verdicts"]["axis0"] == "REDUNDANT"
    assert report["verdicts"]["axis1"] == "OK"
    agg = report["aggregates"]["axis0"]["g_A"]
    assert agg["median_abs_r"] > 0.99
    assert agg["problems_evaluated"] == 3
    assert agg["problems_over_threshold"] == 3


def test_small_problems_are_skipped(tmp_path):
    root = tmp_path / "run"
    _write_problem(root, "Tiny", [([1.0, 2.0], 0.0, 0.1, 0.0)] * 3)  # below min 5
    out = tmp_path / "report"
    code = mod.main(
        ["--run-root", str(root), "--axes", "a0", "a1", "--output-dir", str(out)]
    )
    assert code == 0
    report = json.loads(
        (out / "descriptor_objective_correlation.json").read_text(encoding="utf-8")
    )
    assert report["aggregates"]["a0"]["g_A"]["problems_evaluated"] == 0
    assert report["verdicts"]["a0"] == "OK"  # no evidence -> no redundancy claim
