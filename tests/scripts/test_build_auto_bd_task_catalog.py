from __future__ import annotations

import csv
import importlib.util
import json
import sys
from pathlib import Path

import yaml

_SCRIPT = (
    Path(__file__).resolve().parent.parent.parent
    / "scripts"
    / "build_auto_bd_task_catalog.py"
)
_SPEC = importlib.util.spec_from_file_location("build_auto_bd_task_catalog", _SCRIPT)
assert _SPEC is not None and _SPEC.loader is not None
mod = importlib.util.module_from_spec(_SPEC)
sys.modules.setdefault("build_auto_bd_task_catalog", mod)
_SPEC.loader.exec_module(mod)


def _write_source_csv(tmp_path: Path) -> Path:
    rows = [
        ("RTLLM", "Prob001_accu", 96, "sequential", 0.9, 0.1, 0.2),
        ("RTLLM", "Prob002_adder_16bit", 52, "combinational", 1.0, 0.2, 0.0),
        ("RTLLM", "Prob003_fsm", 200, "sequential", 0.5, 0.1, 0.7),
        ("VerilogEval-Spec-to-RTL", "Prob004_mux", 150, "combinational", 0.7, 0.1, 0.3),
        ("VerilogEval-Spec-to-RTL", "Prob005_lfsr", 300, "sequential", 0.8, 0.1, 0.4),
        ("VerilogEval-Spec-to-RTL", "Prob006_rule", 80, "combinational", 0.6, 0.1, 0.5),
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
                "synthesis_rate",
                "difficulty_score",
                "summary_path",
            ]
        )
        for row in rows:
            writer.writerow([*row, f"/tmp/{row[1]}_summary.json"])
    return path


def _write_config(path: Path, benchmarks: dict[str, list[str]]) -> Path:
    payload = {
        "benchmarks": {
            benchmark: {"problems": problems}
            for benchmark, problems in benchmarks.items()
        }
    }
    path.write_text(yaml.safe_dump(payload, sort_keys=False), encoding="utf-8")
    return path


def test_build_catalog_writes_json_markdown_and_subset_lock(tmp_path):
    source = _write_source_csv(tmp_path)
    dev = _write_config(tmp_path / "dev.yaml", {"RTLLM": ["Prob001_accu"]})
    main = _write_config(tmp_path / "main.yaml", {"RTLLM": ["Prob003_fsm"]})
    heldout = _write_config(
        tmp_path / "heldout.yaml",
        {
            "RTLLM": ["Prob002_adder_16bit"],
            "VerilogEval-Spec-to-RTL": ["Prob004_mux", "Prob005_lfsr", "Prob006_rule"],
        },
    )
    output = tmp_path / "out"

    code = mod.main(
        [
            "--source-csv",
            str(source),
            "--dev-config",
            str(dev),
            "--main-config",
            str(main),
            "--heldout-config",
            str(heldout),
            "--heldout-count",
            "2",
            "--output-dir",
            str(output),
        ]
    )

    assert code == 0
    catalog = json.loads((output / "auto_bd_task_catalog.json").read_text(encoding="utf-8"))
    subset_lock = yaml.safe_load((output / "auto_bd_subset_lock.yaml").read_text(encoding="utf-8"))
    assert (output / "auto_bd_task_catalog.md").is_file()
    assert catalog["subset_lock"]["development"]["problem_count"] == 1
    assert catalog["subset_lock"]["main_screening"]["problem_count"] == 1
    assert catalog["subset_lock"]["heldout_validation"]["problem_count"] == 2
    assert subset_lock["heldout_validation"]["problem_count"] == 2
    included = {
        row["problem_id"]: row["inclusion_decision"]
        for row in catalog["problems"]
        if row["included"]
    }
    assert included["Prob001_accu"] == "development"
    assert included["Prob003_fsm"] == "main_screening"
    assert len(catalog["source_csv_sha256"]) == 64


def test_balanced_holdout_is_deterministic(tmp_path):
    source = mod.load_source_problems(_write_source_csv(tmp_path))
    pairs = [
        ("RTLLM", "Prob002_adder_16bit"),
        ("VerilogEval-Spec-to-RTL", "Prob004_mux"),
        ("VerilogEval-Spec-to-RTL", "Prob005_lfsr"),
        ("VerilogEval-Spec-to-RTL", "Prob006_rule"),
    ]

    first = mod.balanced_holdout(pairs, source, count=3, seed="seed")
    second = mod.balanced_holdout(pairs, source, count=3, seed="seed")

    assert first == second
    assert len(first) == 3

