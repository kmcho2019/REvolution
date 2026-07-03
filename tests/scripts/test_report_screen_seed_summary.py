from __future__ import annotations

import csv
import importlib.util
import sys
from pathlib import Path

import pytest

_REPO_ROOT = Path(__file__).resolve().parent.parent.parent
_SCRIPT_PATH = _REPO_ROOT / "scripts" / "report_screen_seed_summary.py"
_SPEC = importlib.util.spec_from_file_location("report_screen_seed_summary", _SCRIPT_PATH)
assert _SPEC is not None and _SPEC.loader is not None
report_screen_seed_summary = importlib.util.module_from_spec(_SPEC)
sys.modules.setdefault("report_screen_seed_summary", report_screen_seed_summary)
_SPEC.loader.exec_module(report_screen_seed_summary)

_ANCHOR = (
    _REPO_ROOT
    / "docs"
    / "journal_features"
    / "revamp_history"
    / "20260703_121857_KST_natural_qd_push"
    / "p0_v2_anchor"
)


def _write_aggregate(path: Path, rows: list[tuple[str, str, str, str, str]]) -> None:
    fields = [
        "backend",
        "benchmark",
        "problem_count",
        "pareto_valid_problem_count",
        "mean_hypervolume",
        "mean_pareto_point_count",
    ]
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.writer(handle)
        writer.writerow(fields)
        for backend, count, valid, hv, pts in rows:
            writer.writerow([backend, "ALL", count, valid, hv, pts])


def _write_hv_auc(path: Path, rows: list[tuple[str, float]]) -> None:
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.writer(handle)
        writer.writerow(["backend", "problem", "hv_final", "hv_auc"])
        for index, (backend, value) in enumerate(rows):
            writer.writerow([backend, f"p{index}", "0", str(value)])


def test_synthetic_two_seed_summary(tmp_path: Path) -> None:
    for seed, base_hv, treat_hv in (("7", "0.10", "0.12"), ("8", "0.20", "0.18")):
        _write_aggregate(
            tmp_path / f"agg{seed}.csv",
            [("base", "8", "8", base_hv, "3.0"), ("treat", "8", "7", treat_hv, "2.0")],
        )
        _write_hv_auc(
            tmp_path / f"auc{seed}.csv",
            [("base", 0.05), ("base", 0.15), ("treat", 0.2)],
        )
    output = tmp_path / "summary.csv"
    assert (
        report_screen_seed_summary.main(
            [
                "--seed", f"7:{tmp_path / 'agg7.csv'}:{tmp_path / 'auc7.csv'}",
                "--seed", f"8:{tmp_path / 'agg8.csv'}:{tmp_path / 'auc8.csv'}",
                "--baseline", "base",
                "--treatment", "treat",
                "--output", str(output),
            ]
        )
        == 0
    )
    rows = {row["seed"]: row for row in csv.DictReader(output.open())}
    assert rows["7"]["treatment_over_baseline_pct"] == "120.0"
    assert rows["7"]["treatment_coverage"] == "7/8"
    assert rows["8"]["treatment_over_baseline_pct"] == "90.0"
    assert float(rows["mean"]["baseline_mean_hv"]) == pytest.approx(0.15)
    assert float(rows["mean"]["treatment_mean_hv"]) == pytest.approx(0.15)
    assert rows["mean"]["treatment_over_baseline_pct"] == "100.0"


def test_regression_against_tracked_anchor_package(tmp_path: Path) -> None:
    seeds = [
        ("1001", _ANCHOR / "pareto_analysis" / "aggregate_backend_metrics.csv", _ANCHOR / "tables" / "hv_auc.csv"),
        ("1002", _ANCHOR / "replication" / "seed_1002" / "pareto_analysis" / "aggregate_backend_metrics.csv", _ANCHOR / "replication" / "seed_1002" / "hv_auc.csv"),
        ("1003", _ANCHOR / "replication" / "seed_1003" / "pareto_analysis" / "aggregate_backend_metrics.csv", _ANCHOR / "replication" / "seed_1003" / "hv_auc.csv"),
    ]
    for _, aggregate_csv, hv_auc_csv in seeds:
        assert aggregate_csv.is_file() and hv_auc_csv.is_file()
    output = tmp_path / "summary.csv"
    argv = []
    for seed, aggregate_csv, hv_auc_csv in seeds:
        argv += ["--seed", f"{seed}:{aggregate_csv}:{hv_auc_csv}"]
    argv += [
        "--baseline", "classic_revolution_8x5",
        "--treatment", "smooth_qd_v2_8x5",
        "--output", str(output),
    ]
    assert report_screen_seed_summary.main(argv) == 0
    rows = {row["seed"]: row for row in csv.DictReader(output.open())}
    assert rows["mean"]["baseline_mean_hv"] == "0.14418173149368418"
    assert rows["mean"]["treatment_mean_hv"] == "0.16283536749649596"
    assert rows["mean"]["treatment_over_baseline_pct"] == "112.9"
    assert rows["1001"]["treatment_over_baseline_pct"] == "123.5"
