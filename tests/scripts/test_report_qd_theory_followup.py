from __future__ import annotations

import importlib
import json
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[2]
if str(REPO_ROOT) not in sys.path:
    sys.path.insert(0, str(REPO_ROOT))

FOLLOWUP_REPORT = importlib.import_module("scripts.report_qd_theory_followup")
load_followup_rows = FOLLOWUP_REPORT.load_followup_rows
summarize_rows = FOLLOWUP_REPORT.summarize_rows


def _write_json(path: Path, payload: dict) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(payload), encoding="utf-8")


def test_report_qd_theory_followup_summarizes_profiles_and_recommends_axes(tmp_path):
    run_root = tmp_path / "followup"

    _write_json(
        run_root / "rtllm" / "cvt_theory_grounded" / "RTLLM" / "Prob001_accu" / "archive_summary.json",
        {
            "archive_type": "cvt",
            "descriptor_profile": "theory_grounded_full_20d",
            "coverage": 0.25,
            "qd_score": 1.2,
            "best_quality": 0.8,
            "occupied_cells": 4,
            "num_cells": 16,
        },
    )
    _write_json(
        run_root / "rtllm" / "cvt_theory_grounded" / "RTLLM" / "Prob001_accu" / "descriptor_health.json",
        {
            "descriptor_profile": "theory_grounded_full_20d",
            "observation_count": 10,
            "collapsed_axes": ["rent_exponent"],
            "axis_health": [
                {
                    "axis": "rtl_cyclomatic_total_log",
                    "observation_stats": {
                        "unique_count": 4,
                        "nonzero_fraction": 1.0,
                        "stddev": 0.3,
                    },
                },
                {
                    "axis": "rent_exponent",
                    "observation_stats": {
                        "unique_count": 1,
                        "nonzero_fraction": 0.0,
                        "stddev": 0.0,
                    },
                },
            ],
        },
    )

    _write_json(
        run_root / "rtllm" / "cvt_structural_fixed" / "RTLLM" / "Prob001_accu" / "archive_summary.json",
        {
            "archive_type": "cvt",
            "descriptor_profile": "implemented_structural_fixed_5d",
            "coverage": 0.4,
            "qd_score": 1.5,
            "best_quality": 0.9,
            "occupied_cells": 6,
            "num_cells": 16,
        },
    )
    _write_json(
        run_root / "rtllm" / "cvt_structural_fixed" / "RTLLM" / "Prob001_accu" / "descriptor_health.json",
        {
            "descriptor_profile": "implemented_structural_fixed_5d",
            "observation_count": 10,
            "collapsed_axes": [],
            "axis_health": [],
        },
    )

    rows = load_followup_rows(run_root)
    summary = summarize_rows(rows)

    assert len(rows) == 2
    assert summary["profiles"][0]["profile"] == "implemented_structural_fixed_5d"
    theory_summary = next(
        item for item in summary["profiles"] if item["profile"] == "theory_grounded_full_20d"
    )
    assert theory_summary["collapsed_axes"] == ["rent_exponent"]
    recommendation = summary["recommended_theory_profile"]
    assert recommendation["selected_axes"] == ["rtl_cyclomatic_total_log"]
