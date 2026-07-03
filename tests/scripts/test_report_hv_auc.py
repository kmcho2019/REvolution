from __future__ import annotations

import csv
import importlib.util
import sys
from pathlib import Path

import pytest

_REPO_ROOT = Path(__file__).resolve().parent.parent.parent
_SCRIPT_PATH = _REPO_ROOT / "scripts" / "report_hv_auc.py"
_SPEC = importlib.util.spec_from_file_location("report_hv_auc", _SCRIPT_PATH)
assert _SPEC is not None and _SPEC.loader is not None
report_hv_auc = importlib.util.module_from_spec(_SPEC)
sys.modules.setdefault("report_hv_auc", report_hv_auc)
_SPEC.loader.exec_module(report_hv_auc)

_SUITE_ROOT = (
    _REPO_ROOT
    / "docs"
    / "journal_features"
    / "revamp_history"
    / "20260622_010615_KST_useful_bd_push"
    / "RTLLM_full_suite"
    / "20260630"
)
_FIXTURE = (
    _SUITE_ROOT
    / "analysis"
    / "full"
    / "reference_complete_ppa_distribution"
    / "data"
    / "ppa_candidates.csv"
)
_STORED = _SUITE_ROOT / "tables" / "full_suite_problem_metrics.csv"

_CAND_FIELDS = [
    "backend",
    "benchmark",
    "problem",
    "circuit_type",
    "generation",
    "g_A",
    "g_P",
    "g_T",
]


def _write_candidates(path: Path, rows: list[dict[str, str]]) -> None:
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=_CAND_FIELDS)
        writer.writeheader()
        writer.writerows(rows)


def _read_output(path: Path) -> dict[tuple[str, str], dict[str, str]]:
    with path.open(newline="", encoding="utf-8") as handle:
        return {(row["backend"], row["problem"]): row for row in csv.DictReader(handle)}


def test_synthetic_sequential_and_combinational(tmp_path: Path) -> None:
    rows = [
        # sequential problem: one gen-0 point, a dominating gen-2 point
        {
            "backend": "m",
            "benchmark": "RTLLM",
            "problem": "seqp",
            "circuit_type": "sequential",
            "generation": "0",
            "g_P": "0.5",
            "g_A": "0.5",
            "g_T": "0.5",
        },
        {
            "backend": "m",
            "benchmark": "RTLLM",
            "problem": "seqp",
            "circuit_type": "sequential",
            "generation": "2",
            "g_P": "1.0",
            "g_A": "1.0",
            "g_T": "1.0",
        },
        # combinational problem: single gen-1 point
        {
            "backend": "m",
            "benchmark": "RTLLM",
            "problem": "combp",
            "circuit_type": "combinational",
            "generation": "1",
            "g_P": "0.4",
            "g_A": "0.5",
            "g_T": "",
        },
    ]
    candidates = tmp_path / "ppa_candidates.csv"
    _write_candidates(candidates, rows)
    output = tmp_path / "hv_auc.csv"
    assert (
        report_hv_auc.main(
            [
                "--ppa-candidates",
                str(candidates),
                "--num-generations",
                "2",
                "--output",
                str(output),
            ]
        )
        == 0
    )
    table = _read_output(output)
    seq = table[("m", "seqp")]
    # curve: [0.125, 0.125, 1.0] -> auc = (0.125 + 0.5625) / 2
    assert float(seq["hv_final"]) == pytest.approx(1.0)
    assert float(seq["hv_auc"]) == pytest.approx((0.125 + 0.5625) / 2)
    comb = table[("m", "combp")]
    # curve: [0.0, 0.2, 0.2] -> auc = (0.1 + 0.2) / 2
    assert float(comb["hv_final"]) == pytest.approx(0.2)
    assert float(comb["hv_auc"]) == pytest.approx(0.15)


def test_regression_against_20260630_stored_tables(tmp_path: Path) -> None:
    """The shared implementation must reproduce the stored suite HV-AUC."""
    assert _FIXTURE.is_file() and _STORED.is_file()
    output = tmp_path / "hv_auc.csv"
    assert (
        report_hv_auc.main(
            [
                "--ppa-candidates",
                str(_FIXTURE),
                "--num-generations",
                "5",
                "--output",
                str(output),
            ]
        )
        == 0
    )
    computed = _read_output(output)
    with _STORED.open(newline="", encoding="utf-8") as handle:
        stored_rows = list(csv.DictReader(handle))
    checked = 0
    for row in stored_rows:
        if row["method_key"] not in {
            "classic_revolution_8x5",
            "pcn_v3_rf_stagnation_memory_8x5",
            "deepgate_high_exploit_eoh_8x5",
        }:
            continue
        key = (row["method_key"], row["problem"])
        if key in computed:
            assert float(computed[key]["hv_auc"]) == pytest.approx(
                float(row["hv_auc"]), abs=1e-9
            ), key
        else:
            # No candidate rows: the stored suite scored these as zero.
            assert float(row["hv_auc"]) == pytest.approx(0.0), key
        checked += 1
    assert checked == 138  # 3 methods x 46 reference-complete designs
