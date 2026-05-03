from __future__ import annotations

import json
from pathlib import Path

import pytest

from revolution.qd.successful_candidate_catalog import (
    candidate_to_row,
    load_successful_candidate_catalog,
    recover_candidate_features,
)


def _write_summary(
    path: Path,
    *,
    benchmark: str,
    problem: str,
    ref_ppa_metric: dict[str, float],
    final_details: list[dict] | None = None,
    search_mode: str | None = None,
    descriptor_profile: str | None = None,
) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    payload = {
        "benchmark_name": benchmark,
        "problem_name": problem,
        "ref_ppa_metric": ref_ppa_metric,
        "accumulated_success_rates": {
            "functionality": 1.0,
            "synthesis_ppa": 1.0,
        },
        "final_population_ppa": {"best_score": 0.2},
        "final_population_ppa_details": final_details or [],
        "total_runtime_seconds": 10.0,
    }
    if search_mode is not None:
        qd_config: dict[str, object] = {}
        if descriptor_profile is not None:
            qd_config["descriptor_profile"] = descriptor_profile
        payload["backend_details"] = {"search_mode": search_mode, "qd_config": qd_config}
    path.write_text(json.dumps(payload, indent=2), encoding="utf-8")


def _write_archive_summary(
    path: Path,
    *,
    descriptor_profile: str | None = None,
    descriptor_axes: list[str] | None = None,
) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    payload: dict[str, object] = {"archive_type": "cvt"}
    if descriptor_profile is not None:
        payload["descriptor_profile"] = descriptor_profile
    if descriptor_axes is not None:
        payload["descriptor_axes"] = descriptor_axes
    path.write_text(json.dumps(payload, indent=2), encoding="utf-8")


def _write_archive_space(
    path: Path,
    *,
    descriptor_profile: str | None = None,
    axes: list[str] | None = None,
) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    payload: dict[str, object] = {"archive_type": "cvt"}
    if descriptor_profile is not None:
        payload["descriptor_profile"] = descriptor_profile
    if axes is not None:
        payload["axes"] = axes
    path.write_text(json.dumps(payload, indent=2), encoding="utf-8")


def _write_generation_log(path: Path, payloads: list[dict]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(
        "\n".join(json.dumps(payload) for payload in payloads) + "\n",
        encoding="utf-8",
    )


def _candidate_detail(
    *,
    candidate_id: str,
    report_path: str,
    area: float,
    power: float,
    period: float | None,
    score: float = 0.2,
) -> dict:
    ppa_metrics: dict[str, float | str] = {
        "area": area,
        "power": power,
        "report_path": report_path,
    }
    if period is not None:
        ppa_metrics["eff_clk_period"] = period
    return {
        "id": candidate_id,
        "strategy": "mutate",
        "score": score,
        "ppa_metrics": ppa_metrics,
    }


def _write_candidate_artifacts(
    candidate_dir: Path,
    *,
    area: float,
    power: float,
    period: float | None,
    total_cells: float,
    seq_ratio: float,
    utilization: float,
    code_text: str,
) -> None:
    candidate_dir.mkdir(parents=True, exist_ok=True)
    (candidate_dir / "code.sv").write_text(code_text, encoding="utf-8")
    metrics_payload = {
        "ppa_metrics": {
            "area": area,
            "power": power,
            "report_path": str(candidate_dir / "code_synthesis_report.ppa"),
        },
        "structural_metrics": {
            "total_cells": total_cells,
            "sequential_cells": total_cells * seq_ratio,
            "combinational_cells": total_cells * (1.0 - seq_ratio),
            "mux_cells": 1.0,
            "arithmetic_cells": 2.0,
            "seq_ratio": seq_ratio,
            "comb_ratio": 1.0 - seq_ratio,
            "mux_ratio": 1.0 / max(total_cells, 1.0),
            "adder_ratio": 2.0 / max(total_cells, 1.0),
            "ltp_noff": 0.0,
            "cell_count_log": total_cells,
        },
        "physical_metrics": {"utilization": utilization},
    }
    if period is not None:
        metrics_payload["ppa_metrics"]["eff_clk_period"] = period
    (candidate_dir / "code_synthesis_report.metrics.json").write_text(
        json.dumps(metrics_payload, indent=2),
        encoding="utf-8",
    )
    (candidate_dir / "code_synthesis_report.ppa").write_text("placeholder\n", encoding="utf-8")


def _write_qd_event(candidate_dir: Path, *, candidate_id: str, generation: int) -> None:
    payload = {
        "candidate_id": candidate_id,
        "generation": generation,
        "strategy": "M-I",
        "origin_pool": "success_pool",
        "generated_mode": "whole",
        "archive_type": "cvt",
        "quality_score": 0.33,
        "score_components": {"g_P": 0.1, "g_A": 0.2, "g_T": 0.3},
        "structural_metrics": {
            "seq_ratio": 0.4,
            "mux_ratio": 0.2,
            "cell_count_log": 25.0,
        },
        "rtl_metrics": {"assign_count": 3.0, "if_count": 2.0},
        "dynamic_metrics": {"active_signal_ratio_est": 0.6},
        "physical_metrics": {"utilization": 0.72},
        "descriptor_values": {
            "seq_ratio": 0.4,
            "mux_ratio": 0.2,
            "cell_count_log": 3.258096538021482,
        },
        "cell_id": "0,0",
        "decision": "inserted",
        "inserted": True,
        "replaced": False,
        "current_cell_elite": {"code_file_path": str(candidate_dir / "code.sv")},
    }
    (candidate_dir / "qd_archive_event.json").write_text(json.dumps(payload), encoding="utf-8")


def _write_archive_cells(path: Path, candidate_ids: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    lines = [
        "cell_id,candidate_id,quality_score,generation,strategy,code_file_path,g_P,g_A,g_T,descriptors_json,parent_ids_json"
    ]
    for index, candidate_id in enumerate(candidate_ids):
        lines.append(
            f"{index},{candidate_id},0.1,{index},seed,/tmp/{candidate_id}.sv,0.1,0.1,0.1,[],[]"
        )
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def test_successful_candidate_catalog_reconstructs_classical_candidates(tmp_path: Path) -> None:
    backend_root = tmp_path / "classic"
    problem_root = backend_root / "RTLLM" / "Prob001"
    candidate_dir = problem_root / "Gen0" / "Prob001_sample0_M-I"
    _write_candidate_artifacts(
        candidate_dir,
        area=90.0,
        power=0.8,
        period=0.7,
        total_cells=20.0,
        seq_ratio=0.5,
        utilization=0.68,
        code_text=(
            "module top(input logic a, input logic b, output logic y);\n"
            "  logic tmp;\n"
            "  assign tmp = a & b;\n"
            "  assign y = tmp;\n"
            "endmodule\n"
        ),
    )
    _write_summary(
        problem_root / "Prob001_summary.json",
        benchmark="RTLLM",
        problem="Prob001",
        ref_ppa_metric={"area": 100.0, "power": 1.0, "eff_clk_period": 1.0},
    )
    _write_generation_log(
        problem_root / "generation_log.jsonl",
        [
            {
                "generation": 0,
                "population_ppa_details": [
                    _candidate_detail(
                        candidate_id="classic_a",
                        report_path=str(candidate_dir / "code_synthesis_report.ppa"),
                        area=90.0,
                        power=0.8,
                        period=0.7,
                    )
                ],
            }
        ],
    )

    catalog = load_successful_candidate_catalog(
        backend_roots={"classic": backend_root},
        allowed_problems={("RTLLM", "Prob001")},
    )

    assert len(catalog.candidates) == 1
    candidate = catalog.candidates[0]
    assert candidate.backend == "classic"
    assert candidate.generation == 0
    assert candidate.has_metrics_json is True
    assert candidate.has_structural_metrics is True
    assert candidate.score_components["g_A"] == 0.1
    assert candidate.score_components["g_P"] == pytest.approx(0.2)
    assert candidate.score_components["g_T"] == pytest.approx(0.3)

    warnings = recover_candidate_features(
        catalog.candidates,
        requested_features=["assign_count", "wire_count_log_est"],
    )
    row = candidate_to_row(candidate)
    assert row["assign_count"] == 2.0
    assert row["wire_count_log_est"] is not None
    assert warnings == []


def test_successful_candidate_catalog_enriches_qd_candidates(tmp_path: Path) -> None:
    backend_root = tmp_path / "cvt_struct"
    problem_root = backend_root / "RTLLM" / "Prob001"
    candidate_dir = problem_root / "Gen1" / "Prob001_sample1_M-I"
    _write_candidate_artifacts(
        candidate_dir,
        area=88.0,
        power=0.78,
        period=0.72,
        total_cells=25.0,
        seq_ratio=0.4,
        utilization=0.72,
        code_text=(
            "module top(input logic clk, input logic a, output logic y);\n"
            "  always_ff @(posedge clk) y <= a;\n"
            "endmodule\n"
        ),
    )
    _write_qd_event(candidate_dir, candidate_id="qd_a", generation=1)
    _write_archive_cells(problem_root / "archive_cells.csv", ["qd_a"])
    _write_summary(
        problem_root / "Prob001_summary.json",
        benchmark="RTLLM",
        problem="Prob001",
        ref_ppa_metric={"area": 100.0, "power": 1.0, "eff_clk_period": 1.0},
        search_mode="revolution_qd",
        descriptor_profile="size_control_3d",
    )
    _write_generation_log(
        problem_root / "generation_log.jsonl",
        [
            {
                "generation": 1,
                "population_ppa_details": [
                    _candidate_detail(
                        candidate_id="qd_a",
                        report_path=str(candidate_dir / "code_synthesis_report.ppa"),
                        area=88.0,
                        power=0.78,
                        period=0.72,
                    )
                ],
            }
        ],
    )

    catalog = load_successful_candidate_catalog(
        backend_roots={"cvt_struct": backend_root},
        allowed_problems={("RTLLM", "Prob001")},
    )

    assert len(catalog.candidates) == 1
    candidate = catalog.candidates[0]
    row = candidate_to_row(candidate)
    assert candidate.has_qd_event is True
    assert candidate.quality_score == 0.33
    assert candidate.is_final_elite is True
    assert candidate.descriptor_profile == "size_control_3d"
    assert row["cell_count_log"] == 3.258096538021482
    assert row["active_signal_ratio_est"] == 0.6
    assert row["utilization"] == 0.72
    assert row["descriptor_profile"] == "size_control_3d"


def test_successful_candidate_catalog_falls_back_to_final_population_details(tmp_path: Path) -> None:
    backend_root = tmp_path / "classic"
    problem_root = backend_root / "RTLLM" / "ProbComb"
    _write_summary(
        problem_root / "ProbComb_summary.json",
        benchmark="RTLLM",
        problem="ProbComb",
        ref_ppa_metric={"area": 40.0, "power": 2.0, "eff_clk_period": 0.0},
        final_details=[
            _candidate_detail(
                candidate_id="final_only",
                report_path=str(problem_root / "missing" / "code_synthesis_report.ppa"),
                area=35.0,
                power=1.5,
                period=None,
            )
        ],
    )

    catalog = load_successful_candidate_catalog(
        backend_roots={"classic": backend_root},
        allowed_problems={("RTLLM", "ProbComb")},
    )

    assert len(catalog.candidates) == 1
    candidate = catalog.candidates[0]
    assert candidate.source == "final_population"
    assert candidate.generation is None
    assert candidate.generation_views_available is False
    assert candidate.circuit_type == "combinational"
    row = candidate_to_row(candidate)
    assert row["g_A"] == 0.125
    assert row["g_P"] == 0.25
    assert row["g_T"] is None


def test_successful_candidate_catalog_uses_archive_summary_profile_fallback(tmp_path: Path) -> None:
    backend_root = tmp_path / "cvt_struct"
    problem_root = backend_root / "RTLLM" / "Prob002"
    _write_archive_summary(
        problem_root / "archive_summary.json",
        descriptor_profile="implemented_structural_fixed_5d",
        descriptor_axes=["seq_ratio", "mux_ratio", "cell_count_log"],
    )
    _write_summary(
        problem_root / "Prob002_summary.json",
        benchmark="RTLLM",
        problem="Prob002",
        ref_ppa_metric={"area": 100.0, "power": 1.0, "eff_clk_period": 1.0},
        final_details=[
            _candidate_detail(
                candidate_id="final_only",
                report_path=str(problem_root / "missing" / "code_synthesis_report.ppa"),
                area=95.0,
                power=0.9,
                period=0.85,
            )
        ],
        search_mode="revolution_qd",
    )

    catalog = load_successful_candidate_catalog(
        backend_roots={"cvt_struct": backend_root},
        allowed_problems={("RTLLM", "Prob002")},
    )

    assert len(catalog.candidates) == 1
    candidate = catalog.candidates[0]
    assert candidate.descriptor_profile == "implemented_structural_fixed_5d"
    assert candidate_to_row(candidate)["descriptor_profile"] == "implemented_structural_fixed_5d"


def test_successful_candidate_catalog_uses_archive_space_profile_fallback(tmp_path: Path) -> None:
    backend_root = tmp_path / "cvt_struct"
    problem_root = backend_root / "RTLLM" / "Prob003"
    _write_archive_space(
        problem_root / "archive_space.json",
        descriptor_profile="large_struct10d",
        axes=["seq_ratio", "comb_ratio", "mux_ratio"],
    )
    _write_summary(
        problem_root / "Prob003_summary.json",
        benchmark="RTLLM",
        problem="Prob003",
        ref_ppa_metric={"area": 100.0, "power": 1.0, "eff_clk_period": 1.0},
        final_details=[
            _candidate_detail(
                candidate_id="final_only",
                report_path=str(problem_root / "missing" / "code_synthesis_report.ppa"),
                area=94.0,
                power=0.88,
                period=0.82,
            )
        ],
        search_mode="revolution_qd",
    )

    catalog = load_successful_candidate_catalog(
        backend_roots={"cvt_struct": backend_root},
        allowed_problems={("RTLLM", "Prob003")},
    )

    assert len(catalog.candidates) == 1
    candidate = catalog.candidates[0]
    assert candidate.descriptor_profile == "large_struct10d"
    assert candidate_to_row(candidate)["descriptor_profile"] == "large_struct10d"
