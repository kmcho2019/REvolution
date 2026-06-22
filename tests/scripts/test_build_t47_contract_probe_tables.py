from __future__ import annotations

import csv
import subprocess
import sys
from pathlib import Path


SCRIPT = Path("scripts/build_t47_contract_probe_tables.py")


def read_rows(path: Path) -> list[dict[str, str]]:
    with path.open(encoding="utf-8", newline="") as handle:
        return list(csv.DictReader(handle))


def write_ppa(path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(
        "tns,wns,eff_clk_period,power,area\n0,0,0,1.0,2.0\n",
        encoding="utf-8",
    )


def test_build_t47_contract_probe_tables(tmp_path: Path) -> None:
    bench = tmp_path / "bench"
    write_ppa(bench / "RTLLM" / "Prob015_multi_pipe_8bit_ppa.txt")
    write_ppa(bench / "VerilogEval-Spec-to-RTL" / "Prob098_circuit7_ppa.txt")
    out = tmp_path / "tables"

    subprocess.run(
        [
            sys.executable,
            str(SCRIPT),
            "--bench-root",
            str(bench),
            "--output-dir",
            str(out),
        ],
        check=True,
    )

    phase_rows = read_rows(out / "probe_matrix.csv")
    assert [row["phase"] for row in phase_rows] == [
        "hard_tuning_sanity",
        "heldout_dry_run",
        "final_style_escalation",
    ]

    problem_rows = read_rows(out / "probe_problem_matrix.csv")
    assert {"phase", "seed", "arm", "reference_status"} <= set(problem_rows[0])
    assert any(row["reference_status"] == "reference_available" for row in problem_rows)
    assert any(row["reference_status"] == "missing_reference_file" for row in problem_rows)

    quarantine_rows = read_rows(out / "default_reference_quarantine.csv")
    assert {row["problem"] for row in quarantine_rows} == {
        "Prob013_multi_booth_8bit",
        "Prob018_float_multi",
        "Prob040_synchronizer",
    }
    assert {row["decision"] for row in quarantine_rows} == {
        "quarantine_from_headline_reference_ppa"
    }
