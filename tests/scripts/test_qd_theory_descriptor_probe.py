from __future__ import annotations

from argparse import Namespace

from scripts.qd_theory_descriptor_probe import (
    _extract_rentcon_metrics_from_text,
    build_payload,
    compare_rent_metrics,
)


def test_extract_rentcon_metrics_from_text_parses_common_fields():
    metrics = _extract_rentcon_metrics_from_text(
        "Rent's exponent: 0.61\nCoefficient: 2.50\nR^2: 0.97\n"
    )
    assert metrics == {
        "rent_exponent": 0.61,
        "rent_k": 2.5,
        "rent_r2": 0.97,
    }


def test_compare_rent_metrics_reports_deltas():
    comparison = compare_rent_metrics(
        {"rent_exponent": 0.45, "rent_k": 1.8, "rent_r2": 0.92},
        {
            "references": [
                {
                    "reference_path": "/tmp/rentcon",
                    "matches": [
                        {
                            "source": "/tmp/rentcon/out.txt",
                            "metrics": {
                                "rent_exponent": 0.4,
                                "rent_k": 1.5,
                                "rent_r2": 0.9,
                            },
                        }
                    ],
                }
            ]
        },
    )
    assert comparison == {
        "comparisons": [
            {
                "reference_path": "/tmp/rentcon",
                "source": "/tmp/rentcon/out.txt",
                "rentcon_metrics": {
                    "rent_exponent": 0.4,
                    "rent_k": 1.5,
                    "rent_r2": 0.9,
                },
                "repo_metrics": {
                    "rent_exponent": 0.45,
                    "rent_k": 1.8,
                    "rent_r2": 0.92,
                },
                "delta": {
                    "rent_exponent_delta": 0.04999999999999999,
                    "rent_k_delta": 0.30000000000000004,
                    "rent_r2_delta": 0.020000000000000018,
                },
            }
        ]
    }


def test_build_payload_projects_theory_profile(tmp_path, monkeypatch):
    rtl_path = tmp_path / "demo.sv"
    rtl_path.write_text("module demo(input logic a, output logic y); assign y = a; endmodule\n")

    monkeypatch.setattr(
        "scripts.qd_theory_descriptor_probe.RTLDescriptorEvaluator.extract_metrics",
        lambda self, **kwargs: {
            "rtl_cyclomatic_total_log": 5.0,
            "rtl_cyclomatic_max_log": 3.0,
        },
    )
    monkeypatch.setattr(
        "scripts.qd_theory_descriptor_probe.GraphDescriptorEvaluator.extract_metrics",
        lambda self, **kwargs: {
            "rent_exponent": 0.42,
            "rent_exponent_confidence_gated": 0.42,
            "reconv_source_ratio": 0.0,
            "reconv_sink_ratio": 0.0,
            "scoap_cc0_bin_0_pct": 1.0,
            "scoap_cc0_bin_1_pct": 0.0,
            "scoap_cc0_bin_2_pct": 0.0,
            "scoap_cc0_bin_3_pct": 0.0,
            "scoap_cc1_bin_0_pct": 1.0,
            "scoap_cc1_bin_1_pct": 0.0,
            "scoap_cc1_bin_2_pct": 0.0,
            "scoap_cc1_bin_3_pct": 0.0,
            "scoap_co_bin_0_pct": 1.0,
            "scoap_co_bin_1_pct": 0.0,
            "scoap_co_bin_2_pct": 0.0,
            "scoap_co_bin_3_pct": 0.0,
            "laplacian_lambda2": 0.2,
            "laplacian_spectral_entropy": 0.4,
            "scoap_signal_smoothness": 0.6,
            "rent_k": 1.0,
            "rent_r2": 0.8,
        },
    )

    payload = build_payload(
        Namespace(
            rtl=str(rtl_path),
            top="demo",
            profile="theory_grounded_full_20d",
            archive_type="cvt",
            circuit_type="sequential",
            rentcon_reference=[],
        )
    )

    assert payload["profile"] == "theory_grounded_full_20d"
    assert payload["graph_metrics"]["rent_exponent"] == 0.42
    assert payload["descriptor_values"]["rtl_cyclomatic_total_log"] > 0.0
    assert payload["descriptor_values"]["laplacian_lambda2"] == 0.2


def test_build_payload_projects_journal_profile(tmp_path, monkeypatch):
    rtl_path = tmp_path / "demo.sv"
    rtl_path.write_text("module demo(input logic a, output logic y); assign y = a; endmodule\n")

    monkeypatch.setattr(
        "scripts.qd_theory_descriptor_probe.RTLDescriptorEvaluator.extract_metrics",
        lambda self, **kwargs: {},
    )
    monkeypatch.setattr(
        "scripts.qd_theory_descriptor_probe.GraphDescriptorEvaluator.extract_metrics",
        lambda self, **kwargs: {
            "logic_depth": 2.0,
            "ff_depth": 1.0,
            "comb_width_log": 1.5,
            "combinational_cells": 4.0,
        },
    )

    payload = build_payload(
        Namespace(
            rtl=str(rtl_path),
            top="demo",
            profile="journal_logic_ff_width_3d",
            archive_type="cvt",
            circuit_type="sequential",
            rentcon_reference=[],
        )
    )

    assert payload["profile"] == "journal_logic_ff_width_3d"
    assert payload["descriptor_values"] == {
        "logic_depth": 2.0,
        "ff_depth": 1.0,
        "comb_width_log": 1.5,
    }
    assert payload["graph_metrics"]["combinational_cells"] == 4.0
