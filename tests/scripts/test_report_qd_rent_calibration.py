from __future__ import annotations

import json

from scripts.report_qd_rent_calibration import (
    evaluate_manifest,
    render_markdown_report,
)


def test_evaluate_manifest_resolves_relative_paths_and_compares_rent(tmp_path, monkeypatch):
    manifest_dir = tmp_path / "manifest"
    manifest_dir.mkdir()

    rtl_path = manifest_dir / "demo.sv"
    rtl_path.write_text("module demo(input logic a, output logic y); assign y = a; endmodule\n")

    rentcon_path = manifest_dir / "demo_rent.txt"
    rentcon_path.write_text(
        "Rent's exponent: 0.40\nCoefficient: 1.50\nR^2: 0.90\n",
        encoding="utf-8",
    )

    manifest_path = manifest_dir / "manifest.json"
    manifest_path.write_text(
        json.dumps(
            {
                "cases": [
                    {
                        "name": "demo",
                        "rtl": "demo.sv",
                        "top": "demo",
                        "rentcon_reference": ["demo_rent.txt"],
                    }
                ]
            }
        ),
        encoding="utf-8",
    )

    monkeypatch.setattr(
        "scripts.report_qd_rent_calibration.GraphDescriptorEvaluator.extract_metrics",
        lambda self, **kwargs: {
            "rent_exponent": 0.45,
            "rent_k": 1.8,
            "rent_r2": 0.92,
            "rent_sample_count": 5.0,
        },
    )

    report = evaluate_manifest(manifest_path)

    assert report["case_count"] == 1
    assert report["summary"]["cases_with_comparable_rentcon_metrics"] == 1
    assert report["summary"]["mean_abs_rent_exponent_delta"] == 0.04999999999999999
    case = report["cases"][0]
    assert case["name"] == "demo"
    assert case["graph_metrics"]["rent_exponent"] == 0.45
    comparison = case["rent_comparison"]["comparisons"][0]
    assert comparison["rentcon_metrics"]["rent_exponent"] == 0.4
    assert comparison["delta"]["rent_exponent_delta"] == 0.04999999999999999


def test_render_markdown_report_includes_case_rows():
    markdown = render_markdown_report(
        {
            "manifest": "/tmp/manifest.json",
            "case_count": 1,
            "summary": {
                "cases_with_comparable_rentcon_metrics": 1,
                "mean_abs_rent_exponent_delta": 0.05,
                "mean_abs_rent_k_delta": 0.3,
                "mean_abs_rent_r2_delta": 0.02,
            },
            "cases": [
                {
                    "name": "demo",
                    "graph_metrics": {
                        "rent_exponent": 0.45,
                        "rent_r2": 0.92,
                    },
                    "rent_comparison": {
                        "comparisons": [
                            {
                                "source": "/tmp/demo_rent.txt",
                                "rentcon_metrics": {"rent_exponent": 0.4},
                                "delta": {"rent_exponent_delta": 0.05},
                            }
                        ]
                    },
                }
            ],
        }
    )

    assert "| demo | 0.450000 | 0.920000 | 0.400000 | 0.050000 | /tmp/demo_rent.txt |" in markdown
