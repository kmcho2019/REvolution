from __future__ import annotations

import importlib
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[2]
if str(REPO_ROOT) not in sys.path:
    sys.path.insert(0, str(REPO_ROOT))

REFERENCE_VALIDATION = importlib.import_module(
    "scripts.report_qd_rent_reference_validation"
)
SynthNetlistCase = REFERENCE_VALIDATION.SynthNetlistCase
parse_rentcon_output = REFERENCE_VALIDATION.parse_rentcon_output
render_markdown_report = REFERENCE_VALIDATION.render_markdown_report
select_problem_representatives = REFERENCE_VALIDATION.select_problem_representatives
summarize_results = REFERENCE_VALIDATION.summarize_results


def test_parse_rentcon_output_extracts_method_summaries():
    text = """
Method 0 : 
========= Circuit partitioning based method using MLPart =========
Arithmetic avg pins per gate: 3.333333, geometric avg pins per gate: 3.174802
----------------- Arithmetic Rent's parameters -----------------
(1) Type 1 pin counting: 0.449660, (2) Type 2 pin counting: 0.120331, (3) Type 3 pin counting: 0.449660
----------------- Geometric Rent's parameters -----------------
(1) Type 1 pin counting: 0.251629, (2) Type 2 pin counting: -0.011405, (3) Type 3 pin counting: 0.251629

Method 1 : 
========= Graph traversal based method =========
Arithmetic avg pins per gate: 3.333333, geometric avg pins per gate: 3.174802
----------------- Arithmetic Rent's parameters -----------------
(1) Type 1 pin counting: 0.604071, (2) Type 2 pin counting: 0.443607, (3) Type 3 pin counting: 0.731183
----------------- Geometric Rent's parameters -----------------
(1) Type 1 pin counting: 0.645313, (2) Type 2 pin counting: 0.505028, (3) Type 3 pin counting: 0.795546
"""
    parsed = parse_rentcon_output(text)
    methods = parsed["methods"]

    assert methods["circuit_partitioning_mlpart"]["label"] == (
        "Circuit partitioning based method using MLPart"
    )
    assert methods["circuit_partitioning_mlpart"]["arithmetic"]["type1"] == 0.44966
    assert methods["graph_traversal"]["geometric"]["type3"] == 0.795546


def test_parse_rentcon_output_recovers_fit_sections_without_final_summary():
    text = """
========= Circuit partitioning based method using MLPart =========
Start to fit arithmetic Rent's parameter in Region I ...
-------- Type I Rent's parameter --------
Final #points = 2, Rent's p = 0.908496
-------- Type II Rent's parameter --------
Final #points = 2, Rent's p = 0.808496
-------- Type III Rent's parameter --------
Final #points = 2, Rent's p = 0.708496
Start to fit geometric Rent's parameter in Region I ...
-------- Type I Rent's parameter --------
Final #points = 2, Rent's p = 0.958683
-------- Type II Rent's parameter --------
Final #points = 2, Rent's p = 0.858683
-------- Type III Rent's parameter --------
Final #points = 2, Rent's p = 0.758683
"""
    parsed = parse_rentcon_output(text)
    method = parsed["methods"]["circuit_partitioning_mlpart"]

    assert method["arithmetic"]["type1"] == 0.908496
    assert method["arithmetic"]["type3"] == 0.708496
    assert method["geometric"]["type2"] == 0.858683


def test_select_problem_representatives_keeps_one_case_per_problem():
    cases = [
        SynthNetlistCase(
            benchmark="RTLLM",
            problem="Prob001",
            backend="classic",
            model_label="model",
            generation="Gen0",
            candidate="a",
            netlist_path="/tmp/a.v",
            simulation_log_path="/tmp/a.log",
            netlist_size_bytes=100,
        ),
        SynthNetlistCase(
            benchmark="RTLLM",
            problem="Prob001",
            backend="classic",
            model_label="model",
            generation="Gen1",
            candidate="b",
            netlist_path="/tmp/b.v",
            simulation_log_path="/tmp/b.log",
            netlist_size_bytes=80,
        ),
        SynthNetlistCase(
            benchmark="RTLLM",
            problem="Prob002",
            backend="classic",
            model_label="model",
            generation="Gen0",
            candidate="c",
            netlist_path="/tmp/c.v",
            simulation_log_path="/tmp/c.log",
            netlist_size_bytes=120,
        ),
    ]

    selected = select_problem_representatives(cases, case_limit=None)

    assert len(selected) == 2
    assert {case.problem for case in selected} == {"Prob001", "Prob002"}
    assert next(case for case in selected if case.problem == "Prob001").candidate == "b"


def test_summarize_results_reports_accuracy_and_runtime():
    results = [
        {
            "status": "ok",
            "comparison": {
                "internal": {
                    "rent_exponent": 1.0,
                    "rent_sample_count": 2.0,
                    "timing_seconds": {
                        "internal_total_seconds": 0.02,
                        "rent_fit_seconds": 0.001,
                    },
                },
                "reference": {
                    "timing_seconds": {
                        "openroad_seconds": 0.5,
                        "rentcon_seconds": 0.1,
                        "reference_total_seconds": 0.6,
                    }
                },
                "delta": {
                    "vs_circuit_partitioning_type1": 0.55,
                    "vs_graph_traversal_type1": 0.40,
                },
                "flags": {
                    "internal_clamped": True,
                    "low_sample_count": True,
                },
            },
            "rentcon_payload": {
                "parsed_output": {
                    "methods": {
                        "circuit_partitioning_mlpart": {
                            "arithmetic": {"type1": 0.45}
                        }
                    }
                }
            },
        },
        {
            "status": "ok",
            "comparison": {
                "internal": {
                    "rent_exponent": 0.50,
                    "rent_sample_count": 4.0,
                    "timing_seconds": {
                        "internal_total_seconds": 0.03,
                        "rent_fit_seconds": 0.002,
                    },
                },
                "reference": {
                    "timing_seconds": {
                        "openroad_seconds": 0.7,
                        "rentcon_seconds": 0.2,
                        "reference_total_seconds": 0.9,
                    }
                },
                "delta": {
                    "vs_circuit_partitioning_type1": 0.05,
                    "vs_graph_traversal_type1": -0.02,
                },
                "flags": {
                    "internal_clamped": False,
                    "low_sample_count": False,
                },
            },
            "rentcon_payload": {
                "parsed_output": {
                    "methods": {
                        "circuit_partitioning_mlpart": {
                            "arithmetic": {"type1": 0.45}
                        }
                    }
                }
            },
        },
    ]

    summary = summarize_results(results)

    assert summary["completed_case_count"] == 2
    assert summary["internal_clamped_case_count"] == 1
    assert summary["low_sample_count_case_count"] == 1
    assert summary["mean_abs_cp_type1_delta"] == 0.30000000000000004
    assert summary["internal_total_seconds_mean"] == 0.025
    assert summary["reference_total_seconds_mean"] == 0.75


def test_render_markdown_report_includes_per_case_rows():
    report = {
        "run_root": "/tmp/run",
        "output_root": "/tmp/out",
        "rentcon_binary": "/tmp/RentCon.exe",
        "completed_case_count": 1,
        "failed_case_count": 0,
        "summary": {
            "mean_abs_cp_type1_delta": 0.05,
            "median_abs_cp_type1_delta": 0.05,
            "max_abs_cp_type1_delta": 0.05,
            "mean_abs_gt_type1_delta": 0.02,
            "cp_type1_pearson_r": 0.9,
            "internal_clamped_case_count": 0,
            "low_sample_count_case_count": 0,
            "internal_total_seconds_mean": 0.02,
            "reference_total_seconds_mean": 0.7,
            "reference_over_internal_ratio_mean": 35.0,
        },
        "results": [
            {
                "status": "ok",
                "case": {
                    "benchmark": "RTLLM",
                    "problem": "Prob001_accu",
                },
                "comparison": {
                    "internal": {
                        "graph_node_count": 12,
                        "rent_exponent": 0.45,
                        "rent_sample_count": 5.0,
                        "timing_seconds": {"internal_total_seconds": 0.02},
                    },
                    "reference": {
                        "timing_seconds": {"reference_total_seconds": 0.7}
                    },
                    "delta": {"vs_circuit_partitioning_type1": 0.05},
                    "flags": {
                        "internal_clamped": False,
                        "low_sample_count": False,
                    },
                },
                "rentcon_payload": {
                    "parsed_output": {
                        "methods": {
                            "circuit_partitioning_mlpart": {
                                "arithmetic": {"type1": 0.40}
                            },
                            "graph_traversal": {
                                "arithmetic": {"type1": 0.48}
                            },
                        }
                    }
                },
            }
        ],
    }

    markdown = render_markdown_report(report)

    assert "RTLLM/Prob001_accu" in markdown
    assert "| RTLLM/Prob001_accu | 12 | 0.450000 | 5.000000 | 0.400000 | 0.480000 | 0.050000 | 0.020000 | 0.700000 | - |" in markdown
