from __future__ import annotations

import csv
import importlib.util
import sys
from pathlib import Path

import yaml

_SCRIPT_PATH = (
    Path(__file__).resolve().parent.parent.parent
    / "scripts"
    / "build_fast_iteration_subset.py"
)
_SPEC = importlib.util.spec_from_file_location("build_fast_iteration_subset", _SCRIPT_PATH)
assert _SPEC is not None and _SPEC.loader is not None
build_fast_iteration_subset = importlib.util.module_from_spec(_SPEC)
sys.modules.setdefault("build_fast_iteration_subset", build_fast_iteration_subset)
_SPEC.loader.exec_module(build_fast_iteration_subset)


def _write_pool(tmp_path: Path) -> Path:
    rows = [
        # benchmark, problem, gates, type, func
        ("RTLLM", "big_seq", 2000, "sequential", 1.0),
        ("RTLLM", "big_comb", 900, "combinational", 0.9),
        ("RTLLM", "small", 80, "combinational", 1.0),  # below gate band
        ("RTLLM", "hard_one", 1500, "sequential", 0.2),  # below func bar
        ("RTLLM", "excluded_hard", 1200, "sequential", 0.9),  # in hard subset
        ("RTLLM", "third_rtllm", 700, "sequential", 0.8),
        ("RTLLM", "fourth_rtllm", 650, "sequential", 0.8),  # beyond cap
        ("VerilogEval-Spec-to-RTL", "ve_seq", 1800, "sequential", 1.0),
        ("VerilogEval-Spec-to-RTL", "ve_comb", 1600, "combinational", 0.8),
        ("VerilogEval-Spec-to-RTL", "ve_extra", 600, "combinational", 1.0),
        ("VerilogEval-Spec-to-RTL", "huge", 5000, "combinational", 1.0),  # above band
    ]
    path = tmp_path / "pool.csv"
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.writer(handle)
        writer.writerow(
            [
                "benchmark",
                "problem",
                "reference_gate_count",
                "circuit_type",
                "functionality_rate",
            ]
        )
        for row in rows:
            writer.writerow(row)
    return path


def _write_hard_subset(tmp_path: Path) -> Path:
    path = tmp_path / "hard.yaml"
    path.write_text(
        yaml.safe_dump(
            {"benchmarks": {"RTLLM": {"problems": ["excluded_hard"]}}}
        ),
        encoding="utf-8",
    )
    return path


def test_selection_filters_buckets_and_caps(tmp_path):
    pool = build_fast_iteration_subset.load_problem_pool(_write_pool(tmp_path))
    excluded = build_fast_iteration_subset.load_excluded_problems(
        _write_hard_subset(tmp_path)
    )

    selected = build_fast_iteration_subset.select_fast_subset(
        pool, excluded=excluded, subset_size=6, per_benchmark_cap=3
    )

    names = [entry["problem"] for entry in selected]
    # Bucket tops: largest per (benchmark, type).
    assert "big_seq" in names and "big_comb" in names
    assert "ve_seq" in names and "ve_comb" in names
    # Filters: band/func/exclusion respected.
    for bad in ("small", "hard_one", "excluded_hard", "huge"):
        assert bad not in names
    # Top-up respects the per-benchmark cap of 3.
    assert len(names) == 6
    rtllm_count = sum(1 for entry in selected if entry["benchmark"] == "RTLLM")
    assert rtllm_count == 3
    assert "fourth_rtllm" not in names  # cap reached before it


def test_main_writes_locked_config(tmp_path, capsys):
    pool_csv = _write_pool(tmp_path)
    hard = _write_hard_subset(tmp_path)
    output = tmp_path / "fast.yaml"

    code = build_fast_iteration_subset.main(
        [
            "--source-csv",
            str(pool_csv),
            "--hard-subset-config",
            str(hard),
            "--output-config",
            str(output),
            "--subset-size",
            "6",
        ]
    )

    assert code == 0
    payload = yaml.safe_load(output.read_text(encoding="utf-8"))
    assert payload["subset_name"] == "fast_iteration_subset_v1"
    assert len(payload["selection"]["source_csv_sha256"]) == 64
    assert payload["recommended_budget"]["population_size"] == 12
    assert payload["recommended_budget"]["num_generations"] == 3
    total = sum(
        len(body["problems"]) for body in payload["benchmarks"].values()
    )
    assert total == 6
    assert "never publication evidence" in payload["purpose"]
    assert "Locked fast-iteration subset: 6 problems" in capsys.readouterr().out


def test_main_fails_when_pool_too_small(tmp_path):
    pool_csv = _write_pool(tmp_path)
    code = build_fast_iteration_subset.main(
        [
            "--source-csv",
            str(pool_csv),
            "--output-config",
            str(tmp_path / "fast.yaml"),
            "--subset-size",
            "12",
        ]
    )
    assert code == 2
