from __future__ import annotations

import csv
import importlib.util
import json
import sys
from pathlib import Path

import pytest

_REPO_ROOT = Path(__file__).resolve().parent.parent.parent
_SCRIPT_PATH = _REPO_ROOT / "scripts" / "report_revolution_feedback_contract.py"
_SPEC = importlib.util.spec_from_file_location(
    "report_revolution_feedback_contract", _SCRIPT_PATH
)
assert _SPEC is not None and _SPEC.loader is not None
report = importlib.util.module_from_spec(_SPEC)
sys.modules.setdefault("report_revolution_feedback_contract", report)
_SPEC.loader.exec_module(report)


@pytest.mark.parametrize(
    ("status", "score", "expected"),
    [
        ("success", 10, "compliant"),
        ("success", 9, "mismatch"),
        ("failed_format", 0, "compliant"),
        ("failed_format", 10, "mismatch"),
        ("failed_syntax", 0, "compliant"),
        ("failed_syntax", 1, "mismatch"),
        ("failed_functionality", 1, "compliant"),
        ("failed_functionality", 9, "compliant"),
        ("failed_functionality", 0, "mismatch"),
        ("failed_functionality", 10, "mismatch"),
        ("failed_diff", 0, "undefined"),
        ("failed_synthesis", 10, "undefined"),
        ("failed_synthesis_functionality", 5, "undefined"),
    ],
)
def test_feedback_contract_classification(
    status: str, score: int, expected: str
) -> None:
    assert report._classify(status, score) == expected


def _candidate(
    root: Path,
    candidate_id: str,
    status: str,
    score: int,
    generation: int,
    origin_pool: str,
    parent_ids: list[str],
) -> dict[str, object]:
    candidate_dir = root / "Prob001" / f"Gen{generation}" / candidate_id
    candidate_dir.mkdir(parents=True)
    code_path = candidate_dir / "code.sv"
    code_path.write_text("module x; endmodule\n", encoding="utf-8")
    (candidate_dir / "code_feedback.txt").write_text(
        f"Score: {score}\nJustification: test\n\nANALYSIS:\ntext\n",
        encoding="utf-8",
    )
    return {
        "id": candidate_id,
        "status": status,
        "code_file_path": str(code_path),
        "origin_pool": origin_pool,
        "parent_ids": parent_ids,
    }


def _write_run(root: Path, child_status: str = "success") -> None:
    problem = root / "Prob001"
    parent_ok = _candidate(
        root, "parent_ok", "failed_syntax", 0, 0, "initial", []
    )
    parent_bad = _candidate(
        root, "parent_bad", "failed_functionality", 10, 0, "initial", []
    )
    success = _candidate(root, "success", "success", 10, 0, "initial", [])
    child_ok = _candidate(
        root, "child_ok", child_status, 10, 1, "fail_pool", ["parent_ok"]
    )
    child_bad = _candidate(
        root,
        "child_bad",
        "failed_synthesis",
        4,
        1,
        "fail_pool",
        ["parent_bad"],
    )
    rows = [
        {"generation": 0, "generated_candidates": [parent_ok, parent_bad, success]},
        {"generation": 1, "generated_candidates": [child_ok, child_bad]},
    ]
    (problem / "generation_log.jsonl").write_text(
        "\n".join(json.dumps(row) for row in rows) + "\n", encoding="utf-8"
    )


def test_feedback_contract_report(tmp_path: Path) -> None:
    run_root = tmp_path / "run"
    _write_run(run_root)
    output = tmp_path / "output"
    summary = report.generate_feedback_contract_report(
        [("1001", run_root)], output
    )

    assert summary["candidate_count"] == 5
    with (output / "status_contract.csv").open(
        newline="", encoding="utf-8"
    ) as handle:
        rows = list(csv.DictReader(handle))
    functionality = [
        row
        for row in rows
        if row["status"] == "failed_functionality"
        and row["contract_class"] == "mismatch"
    ]
    assert functionality[0]["candidate_count"] == "1"
    with (output / "fail_parent_outcomes.csv").open(
        newline="", encoding="utf-8"
    ) as handle:
        outcomes = {row["parent_contract_class"]: row for row in csv.DictReader(handle)}
    assert outcomes["compliant"]["valid_ppa_children"] == "1"
    assert outcomes["mismatch"]["valid_ppa_children"] == "0"
    assert "premise evidence only" in (output / "README.md").read_text()


def test_feedback_contract_rejects_unknown_status(tmp_path: Path) -> None:
    run_root = tmp_path / "run"
    _write_run(run_root, child_status="unknown")
    with pytest.raises(AssertionError):
        report.generate_feedback_contract_report(
            [("1001", run_root)], tmp_path / "output"
        )
