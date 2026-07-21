from __future__ import annotations

import hashlib
import json
import sys
from pathlib import Path

from scripts.report_tcad_smoke_synthesis import main


def _write_arm(root: Path, successes: int) -> None:
    remaining = successes
    for problem in ("a", "b", "c"):
        path = root / problem / "generation_log.jsonl"
        path.parent.mkdir(parents=True)
        records = []
        for generation in (0, 1):
            count = min(8, remaining)
            remaining -= count
            candidates = [
                {"rtl_simulation_success": index < count} for index in range(8)
            ]
            records.append(
                {"generation": generation, "generated_candidates": candidates}
            )
        path.write_text(
            "".join(json.dumps(record) + "\n" for record in records),
            encoding="utf-8",
        )
    assert remaining == 0


def test_report_records_raw_synthesis_starts(
    tmp_path: Path, monkeypatch
) -> None:
    classic = tmp_path / "classic"
    treatment = tmp_path / "treatment"
    output = tmp_path / "summary.json"
    _write_arm(classic, 31)
    _write_arm(treatment, 30)
    monkeypatch.setattr(
        sys,
        "argv",
        [
            "report_tcad_smoke_synthesis.py",
            "--classic-root",
            str(classic),
            "--treatment-root",
            str(treatment),
            "--output",
            str(output),
        ],
    )

    main()

    result = json.loads(output.read_text())
    assert result["definition"] == "generated_candidates_with_rtl_simulation_success"
    assert result["classic"]["candidate_count"] == 48
    assert result["classic"]["synthesis_starts"] == 31
    assert result["treatment"]["synthesis_starts"] == 30
    for arm in ("classic", "treatment"):
        for source in result[arm]["generation_logs"]:
            path = tmp_path / arm / source["problem"] / "generation_log.jsonl"
            assert hashlib.sha256(path.read_bytes()).hexdigest() == source["sha256"]
