from __future__ import annotations

import csv
from pathlib import Path

from scripts.package_rtl_timer_timing_risk_audit import extract_feature, main


def test_extract_feature_counts_timing_risk_terms(tmp_path: Path) -> None:
    code = tmp_path / "code.sv"
    code.write_text(
        """
module top(input clk, input [3:0] a, b, output logic [7:0] y);
always_ff @(posedge clk) begin
  if (a > b) y <= a * b;
  else y <= (a << 1) + b;
end
endmodule
""",
        encoding="utf-8",
    )

    feature = extract_feature(_candidate_row(code, "classic_revolution", "Classic"))

    assert feature.pipeline_event_count >= 3
    assert feature.control_count == 1
    assert feature.mul_count == 1
    assert feature.shift_count == 1
    assert feature.timing_risk_score > 0.0


def test_package_rtl_timer_timing_risk_audit(tmp_path: Path) -> None:
    candidates = tmp_path / "candidate_rows.csv"
    output = tmp_path / "t60"
    classic_code = tmp_path / "classic.sv"
    qd_code = tmp_path / "qd.sv"
    classic_code.write_text("module top; assign y = a + b; endmodule\n", encoding="utf-8")
    qd_code.write_text(
        "module top; always @(posedge clk) if (a == b) y <= a * b; endmodule\n",
        encoding="utf-8",
    )
    _write_csv(
        candidates,
        [
            _candidate_row(classic_code, "classic_revolution", "Classic"),
            _candidate_row(qd_code, "sr_raw_conservative_exploit_qd", "Exact T26 QD"),
        ],
    )

    assert main(["--candidate-rows", str(candidates), "--output-dir", str(output)]) == 0

    features = list(csv.DictReader((output / "tables" / "rtl_timer_features.csv").open()))
    assert len(features) == 2
    assert {row["method"] for row in features} == {
        "classic_revolution",
        "sr_raw_conservative_exploit_qd",
    }
    assert (output / "tables" / "timing_risk_archive_metrics.csv").is_file()
    assert (output / "tables" / "problem_metrics.csv").is_file()
    assert (output / "tables" / "comparison_deltas.csv").is_file()
    assert (output / "figures" / "timing_risk_projection.png").read_bytes().startswith(b"\x89PNG")
    assert (output / "figures" / "visual_inspection_notes.md").is_file()


def _candidate_row(code_path: Path, method: str, label: str) -> dict[str, str]:
    return {
        "method": method,
        "method_label": label,
        "problem": "Prob001_accu",
        "candidate_id": code_path.stem,
        "generation": "0",
        "objective_metrics": "area|power",
        "is_pareto_front": "true",
        "beats_reference": "false",
        "area": "10",
        "power": "1",
        "eff_clk_period": "",
        "rtl_hash": "rtl",
        "netlist_hash": "netlist",
        "family_hash": "family",
        "family_signature": "AND2_X1:1",
        "code_file_path": str(code_path),
    }


def _write_csv(path: Path, rows: list[dict[str, str]]) -> None:
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(rows[0]), lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)
