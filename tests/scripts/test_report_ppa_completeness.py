from __future__ import annotations

import csv
from pathlib import Path

from scripts.report_ppa_completeness import completeness_rows, main


def test_report_ppa_completeness_labels_headline_and_diagnostic(tmp_path: Path) -> None:
    candidates = tmp_path / "ppa_candidates.csv"
    references = tmp_path / "reference_ppa_metrics.csv"
    output = tmp_path / "ppa_completeness.csv"
    _write_csv(
        candidates,
        [
            _candidate("classic_revolution", "Prob001", "c1", "10", "1"),
            _candidate("qd_method", "Prob001", "q1", "9", "1"),
            _candidate("classic_revolution", "Prob040", "c2", "8", "1"),
            _candidate("qd_method", "Prob040", "q2", "7", "1"),
            _candidate("classic_revolution", "Prob041", "c3", "6", "1"),
        ],
    )
    _write_csv(
        references,
        [
            _reference("Prob001", "10", "1"),
            _reference("Prob040", "10000", "1"),
            _reference("Prob041", "6", "1"),
        ],
    )

    assert (
        main(
            [
                "--ppa-candidates",
                str(candidates),
                "--reference-ppa-metrics",
                str(references),
                "--classic-method",
                "classic_revolution",
                "--qd-method",
                "qd_method",
                "--reference-missing-problem",
                "RTLLM:Prob040",
                "--output",
                str(output),
            ]
        )
        == 0
    )

    rows = {row["problem"]: row for row in csv.DictReader(output.open())}
    assert rows["Prob001"]["comparison_status"] == "headline"
    assert rows["Prob001"]["classic_valid_ppa"] == "yes"
    assert rows["Prob001"]["qd_valid_ppa"] == "yes"
    assert rows["Prob040"]["reference_ppa_valid"] == "no"
    assert rows["Prob040"]["comparison_status"] == "diagnostic_only"
    assert rows["Prob040"]["reference_missing_reason"] == "marked_missing"
    assert rows["Prob041"]["comparison_status"] == "candidate_missing"
    assert rows["Prob041"]["qd_valid_ppa"] == "no"


def test_completeness_rows_accept_backend_column() -> None:
    rows = completeness_rows(
        [
            {
                "backend": "classic",
                "benchmark": "RTLLM",
                "problem": "Prob001",
                "area": "10",
                "power": "1",
            },
            {
                "backend": "qd",
                "benchmark": "RTLLM",
                "problem": "Prob001",
                "area": "9",
                "power": "0.9",
            },
        ],
        [_reference("Prob001", "10", "1")],
        "classic",
        "qd",
        set(),
    )

    assert rows == [
        {
            "benchmark": "RTLLM",
            "problem": "Prob001",
            "classic_valid_ppa": "yes",
            "qd_valid_ppa": "yes",
            "reference_ppa_valid": "yes",
            "comparison_status": "headline",
            "classic_valid_ppa_count": "1",
            "qd_valid_ppa_count": "1",
            "reference_missing_reason": "",
        }
    ]


def _candidate(method: str, problem: str, candidate_id: str, area: str, power: str) -> dict[str, str]:
    return {
        "method": method,
        "benchmark": "RTLLM",
        "problem": problem,
        "candidate_id": candidate_id,
        "area": area,
        "power": power,
    }


def _reference(problem: str, area: str, power: str) -> dict[str, str]:
    return {
        "benchmark": "RTLLM",
        "problem": problem,
        "ref_area": area,
        "ref_power": power,
    }


def _write_csv(path: Path, rows: list[dict[str, str]]) -> None:
    assert rows
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(rows[0]))
        writer.writeheader()
        writer.writerows(rows)
