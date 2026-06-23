import csv
import json
from pathlib import Path

from scripts.package_t65_secondary_rtl_cells import main


def test_package_t65_secondary_rtl_cells(tmp_path: Path) -> None:
    dataset_dir = tmp_path / "datasets"
    dataset_dir.mkdir()
    classic_code = tmp_path / "classic.sv"
    qd_code = tmp_path / "qd.sv"
    classic_code.write_text(
        "\n".join(
            [
                "module classic(input logic clk, input logic a, output logic y);",
                "  always_ff @(posedge clk) y <= a;",
                "endmodule",
            ]
        ),
        encoding="utf-8",
    )
    qd_code.write_text(
        "\n".join(
            [
                "module qd(input logic clk, input logic [3:0] a, b, output logic [3:0] y);",
                "  always_ff @(posedge clk) y <= a * b;",
                "  assign y = y ? (a + b) : (a - b);",
                "endmodule",
            ]
        ),
        encoding="utf-8",
    )
    _write_dataset(dataset_dir / "RTLLM__Prob001_demo.json", classic_code, qd_code)
    candidate_csv = tmp_path / "candidates.csv"
    _write_candidate_csv(candidate_csv)

    output_dir = tmp_path / "out"
    result = main(
        [
            "--dataset-dir",
            str(dataset_dir),
            "--candidate-csv",
            str(candidate_csv),
            "--output-dir",
            str(output_dir),
        ]
    )

    assert result == 0
    assert (output_dir / "tables" / "secondary_rtl_features.csv").is_file()
    assert (output_dir / "tables" / "secondary_delta_summary.csv").is_file()
    assert (output_dir / "figures" / "secondary_cell_delta_summary.png").is_file()
    assert (output_dir / "figures" / "front_cell_heatmap.png").is_file()
    assert (output_dir / "figures" / "timing_risk_projection.png").is_file()
    assert (output_dir / "figures" / "visual_inspection_notes.md").is_file()


def _write_dataset(path: Path, classic_code: Path, qd_code: Path) -> None:
    data = {
        "benchmark": "RTLLM",
        "problem": "Prob001_demo",
        "samples": [
            {
                "status": "ppa_valid",
                "technique": "classic",
                "candidate_id": "classic-1",
                "code_file_path": str(classic_code),
                "generation": 0,
                "mode_global_pareto_member": True,
            },
            {
                "status": "ppa_valid",
                "technique": "code_thought_front_slot_qd",
                "candidate_id": "qd-1",
                "code_file_path": str(qd_code),
                "generation": 0,
                "mode_global_pareto_member": True,
            },
        ],
    }
    path.write_text(json.dumps(data), encoding="utf-8")


def _write_candidate_csv(path: Path) -> None:
    rows = [
        {
            "method": "classic_revolution",
            "method_label": "Classic",
            "benchmark": "RTLLM",
            "problem": "Prob001_demo",
            "candidate_id": "classic-1",
            "generation": "0",
            "is_pareto_front": "true",
        },
        {
            "method": "code_thought_front_slot_qd",
            "method_label": "T51 code-thought",
            "benchmark": "RTLLM",
            "problem": "Prob001_demo",
            "candidate_id": "qd-1",
            "generation": "0",
            "is_pareto_front": "true",
        },
    ]
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(rows[0]), lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)
