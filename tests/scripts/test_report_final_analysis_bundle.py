from __future__ import annotations

import json
import os
import subprocess
from pathlib import Path

import yaml


def _write_summary(
    path: Path,
    *,
    benchmark: str,
    problem: str,
    functionality: float,
    synthesis: float,
    best_score: float,
    runtime_seconds: float,
    ref_ppa_metric: dict[str, float],
    best_metrics: dict[str, float],
    final_details: list[dict],
    search_mode: str | None = None,
) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    payload = {
        "benchmark_name": benchmark,
        "problem_name": problem,
        "accumulated_success_rates": {
            "functionality": functionality,
            "synthesis_ppa": synthesis,
        },
        "final_population_ppa": {
            "best_score": best_score,
            "best_metrics": best_metrics,
        },
        "final_population_ppa_details": final_details,
        "ref_ppa_metric": ref_ppa_metric,
        "total_runtime_seconds": runtime_seconds,
        "total_llm_api_calls": 4,
        "total_llm_prompt_tokens": 40,
        "total_llm_completion_tokens": 20,
        "run_budget": {
            "primary_budget_axis": "candidate_evaluations",
            "max_evaluations": 8,
            "max_llm_calls": 8,
        },
    }
    if search_mode:
        payload["backend_details"] = {
            "search_mode": search_mode,
            "qd_config": {"archive_type": "cvt"},
        }
    path.write_text(json.dumps(payload, indent=2), encoding="utf-8")


def _write_generation_log(path: Path, payloads: list[dict]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(
        "\n".join(json.dumps(payload) for payload in payloads) + "\n",
        encoding="utf-8",
    )


def _generation_payload(generation: int, candidates: list[tuple[str, float, float, float]]) -> dict:
    details = [
        {
            "id": candidate_id,
            "strategy": "mutate",
            "score": 0.1,
            "ppa_metrics": {
                "area": area,
                "power": power,
                "eff_clk_period": period,
                "report_path": f"/tmp/{candidate_id}.rpt",
            },
        }
        for candidate_id, area, power, period in candidates
    ]
    return {
        "generation": generation,
        "success_rates": {
            "total_functionality": 1.0,
            "total_synthesis_ppa": 1.0,
        },
        "generation_ppa": {
            "best_score": 0.2 + 0.02 * generation,
            "average_score": 0.15 + 0.01 * generation,
        },
        "population_ppa_details": details,
        "status_counts_this_generation": {"success": len(details)},
        "strategy_counts_this_generation": {"M-I": len(details)},
    }


def _write_archive_summary(path: Path) -> None:
    path.write_text(
        json.dumps(
            {
                "archive_type": "cvt",
                "coverage": 0.5,
                "qd_score": 1.4,
                "best_quality": 0.8,
                "descriptor_profile": "wire_ctrl_assign_3d",
                "descriptor_axes": ["seq_ratio", "mux_ratio", "cell_count_log"],
            },
            indent=2,
        ),
        encoding="utf-8",
    )


def _write_archive_cells(path: Path, candidate_ids: list[str]) -> None:
    lines = [
        "cell_id,candidate_id,quality_score,generation,strategy,code_file_path,g_P,g_A,g_T,descriptors_json,parent_ids_json"
    ]
    for index, candidate_id in enumerate(candidate_ids):
        lines.append(
            f"{index},{candidate_id},0.1,{index},seed,/tmp/{candidate_id}.v,0.1,0.1,0.1,[],[]"
        )
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def _write_qd_event(
    path: Path,
    *,
    candidate_id: str,
    generation: int,
    seq_ratio: float,
    mux_ratio: float,
    cell_count_log: float,
    quality_score: float,
) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    payload = {
        "candidate_id": candidate_id,
        "generation": generation,
        "strategy": "M-I",
        "origin_pool": "success_pool",
        "generated_mode": "whole",
        "archive_type": "cvt",
        "archive_axes": ["seq_ratio", "mux_ratio", "cell_count_log"],
        "quality_score": quality_score,
        "score_components": {"g_P": 0.1, "g_A": 0.1, "g_T": 0.1},
        "structural_metrics": {
            "seq_ratio": seq_ratio,
            "mux_ratio": mux_ratio,
            "cell_count_log": cell_count_log,
        },
        "rtl_metrics": {
            "assign_count": 5.0 + generation,
            "if_count": 2.0 + generation,
            "wire_count_log_est": 1.0 + generation * 0.1,
            "ctrl_depth_est": 0.5 + generation * 0.1,
        },
        "dynamic_metrics": {"active_signal_ratio_est": 0.4 + generation * 0.05},
        "physical_metrics": {},
        "descriptor_values": {
            "seq_ratio": seq_ratio,
            "mux_ratio": mux_ratio,
            "cell_count_log": cell_count_log,
        },
        "cell_id": f"{generation},0",
        "decision": "inserted",
        "inserted": True,
        "replaced": False,
        "current_cell_elite": {"code_file_path": f"/tmp/{candidate_id}.sv"},
    }
    path.write_text(json.dumps(payload), encoding="utf-8")


def test_report_final_analysis_bundle_generates_reference_layout(tmp_path: Path) -> None:
    repo_root = Path(__file__).resolve().parents[2]
    script_path = repo_root / "scripts" / "report_final_analysis_bundle.py"
    subset_config = tmp_path / "subset.yaml"
    subset_config.write_text(
        yaml.safe_dump(
            {
                "subset_name": "hard_iteration_subset_v1",
                "selected_problems": [{"benchmark": "RTLLM", "problem": "Prob001"}],
            },
            sort_keys=False,
        ),
        encoding="utf-8",
    )

    run_root = tmp_path / "run_root"
    classic_root = run_root / "classic"
    qd_root = run_root / "cvt_struct"
    ref = {"area": 100.0, "power": 1.0, "eff_clk_period": 1.0}

    classic_details = [
        {
            "id": "classic_a",
            "strategy": "seed",
            "score": 0.1,
            "ppa_metrics": {"area": 95.0, "power": 0.95, "eff_clk_period": 0.95, "report_path": "/tmp/classic_a.rpt"},
        },
        {
            "id": "classic_b",
            "strategy": "mutate",
            "score": 0.12,
            "ppa_metrics": {"area": 93.0, "power": 0.94, "eff_clk_period": 0.94, "report_path": "/tmp/classic_b.rpt"},
        },
    ]
    qd_details = [
        {
            "id": "qd_a",
            "strategy": "seed",
            "score": 0.2,
            "ppa_metrics": {"area": 90.0, "power": 0.92, "eff_clk_period": 0.91, "report_path": "/tmp/qd_a.rpt"},
        },
        {
            "id": "qd_b",
            "strategy": "mutate",
            "score": 0.24,
            "ppa_metrics": {"area": 88.0, "power": 0.89, "eff_clk_period": 0.9, "report_path": "/tmp/qd_b.rpt"},
        },
    ]

    classic_problem = classic_root / "RTLLM" / "Prob001"
    qd_problem = qd_root / "RTLLM" / "Prob001"
    _write_summary(
        classic_problem / "Prob001_summary.json",
        benchmark="RTLLM",
        problem="Prob001",
        functionality=0.7,
        synthesis=0.7,
        best_score=0.12,
        runtime_seconds=10.0,
        ref_ppa_metric=ref,
        best_metrics={"area": 93.0, "power": 0.94, "eff_clk_period": 0.94},
        final_details=classic_details,
    )
    _write_generation_log(
        classic_problem / "generation_log.jsonl",
        [
            _generation_payload(0, [("classic_a", 95.0, 0.95, 0.95)]),
            _generation_payload(1, [("classic_b", 93.0, 0.94, 0.94)]),
        ],
    )

    _write_summary(
        qd_problem / "Prob001_summary.json",
        benchmark="RTLLM",
        problem="Prob001",
        functionality=0.9,
        synthesis=0.9,
        best_score=0.24,
        runtime_seconds=12.0,
        ref_ppa_metric=ref,
        best_metrics={"area": 88.0, "power": 0.89, "eff_clk_period": 0.9},
        final_details=qd_details,
        search_mode="revolution_qd",
    )
    _write_generation_log(
        qd_problem / "generation_log.jsonl",
        [
            _generation_payload(0, [("qd_a", 90.0, 0.92, 0.91), ("qd_b", 89.0, 0.9, 0.9)]),
            _generation_payload(1, [("qd_c", 88.0, 0.89, 0.9), ("qd_d", 87.0, 0.88, 0.89)]),
        ],
    )
    _write_archive_summary(qd_problem / "archive_summary.json")
    _write_archive_cells(qd_problem / "archive_cells.csv", ["qd_a", "qd_b", "qd_c", "qd_d"])
    for generation, candidate_id in enumerate(["qd_a", "qd_b", "qd_c", "qd_d"]):
        _write_qd_event(
            qd_problem / f"Gen{generation}" / f"sample_{generation}" / "qd_archive_event.json",
            candidate_id=candidate_id,
            generation=generation,
            seq_ratio=0.2 + generation * 0.05,
            mux_ratio=0.1 + generation * 0.04,
            cell_count_log=1.0 + generation * 0.1,
            quality_score=0.2 + generation * 0.03,
        )

    result = subprocess.run(
        [
            str(Path(os.sys.executable)),
            str(script_path),
            "--run-root",
            str(run_root),
            "--subset-config",
            str(subset_config),
        ],
        cwd=repo_root,
        capture_output=True,
        text=True,
        check=False,
    )

    assert result.returncode == 0, result.stderr
    output_dir = run_root / "final_analysis"
    assert (output_dir / "backend_comparison.md").is_file()
    assert (output_dir / "hard_iteration_analysis" / "report.md").is_file()
    assert (output_dir / "feature_analysis" / "report.md").is_file()
    assert (output_dir / "pareto_analysis" / "report.md").is_file()
    assert (output_dir / "evolutionary_reports" / "report.md").is_file()
    assert (output_dir / "design_space_analysis" / "report.md").is_file()
    assert (output_dir / "design_space_analysis" / "summary.json").is_file()
    assert (output_dir / "design_space_analysis" / "successful_candidates.csv").is_file()
    assert (output_dir / "report.md").is_file()
    assert (output_dir / "summary.json").is_file()
    design_space_report = (output_dir / "design_space_analysis" / "report.md").read_text(
        encoding="utf-8"
    )
    assert "## Contents" in design_space_report
    design_space_summary = json.loads(
        (output_dir / "design_space_analysis" / "summary.json").read_text(encoding="utf-8")
    )
    assert design_space_summary["classical_anchor_backend"] == "classic"
    assert any(
        item["qd_backend"] == "cvt_struct"
        for item in design_space_summary["pairwise_feature_comparisons"]
    )

    summary = json.loads((output_dir / "summary.json").read_text(encoding="utf-8"))
    assert summary["recommendations"]["overall"] == "cvt_struct"
    assert summary["recommendations"]["multi_objective"] == "cvt_struct"
    assert summary["recommendations"]["pareto_overall"] == "cvt_struct"
    assert "feature_analysis_report" in summary["sections"]
    assert "design_space_analysis_report" in summary["sections"]
    hard_iteration_summary = json.loads(
        (output_dir / "hard_iteration_analysis" / "summary.json").read_text(encoding="utf-8")
    )
    aggregates = {item["backend"]: item for item in hard_iteration_summary["aggregates"]}
    assert aggregates["classic"]["best_score_mean"] == 0.12
    assert aggregates["cvt_struct"]["best_score_mean"] == 0.24


def test_report_final_analysis_bundle_accepts_explicit_backend_runs(tmp_path: Path) -> None:
    repo_root = Path(__file__).resolve().parents[2]
    script_path = repo_root / "scripts" / "report_final_analysis_bundle.py"
    subset_config = tmp_path / "subset.yaml"
    subset_config.write_text(
        yaml.safe_dump(
            {
                "subset_name": "hard_iteration_subset_v1",
                "selected_problems": [{"benchmark": "RTLLM", "problem": "Prob001"}],
            },
            sort_keys=False,
        ),
        encoding="utf-8",
    )

    classic_root = tmp_path / "external" / "classic"
    qd_root = tmp_path / "external" / "cvt_struct"
    output_dir = tmp_path / "analysis" / "final_analysis"
    ref = {"area": 100.0, "power": 1.0, "eff_clk_period": 1.0}

    _write_summary(
        classic_root / "RTLLM" / "Prob001" / "Prob001_summary.json",
        benchmark="RTLLM",
        problem="Prob001",
        functionality=0.7,
        synthesis=0.7,
        best_score=0.12,
        runtime_seconds=10.0,
        ref_ppa_metric=ref,
        best_metrics={"area": 93.0, "power": 0.94, "eff_clk_period": 0.94},
        final_details=[
            {
                "id": "classic_a",
                "strategy": "seed",
                "score": 0.1,
                "ppa_metrics": {
                    "area": 93.0,
                    "power": 0.94,
                    "eff_clk_period": 0.94,
                    "report_path": "/tmp/classic_a.rpt",
                },
            }
        ],
    )
    _write_generation_log(
        classic_root / "RTLLM" / "Prob001" / "generation_log.jsonl",
        [_generation_payload(0, [("classic_a", 93.0, 0.94, 0.94)])],
    )

    _write_summary(
        qd_root / "RTLLM" / "Prob001" / "Prob001_summary.json",
        benchmark="RTLLM",
        problem="Prob001",
        functionality=0.9,
        synthesis=0.9,
        best_score=0.24,
        runtime_seconds=12.0,
        ref_ppa_metric=ref,
        best_metrics={"area": 88.0, "power": 0.89, "eff_clk_period": 0.9},
        final_details=[
            {
                "id": "qd_a",
                "strategy": "seed",
                "score": 0.2,
                "ppa_metrics": {
                    "area": 88.0,
                    "power": 0.89,
                    "eff_clk_period": 0.9,
                    "report_path": "/tmp/qd_a.rpt",
                },
            }
        ],
        search_mode="revolution_qd",
    )
    _write_generation_log(
        qd_root / "RTLLM" / "Prob001" / "generation_log.jsonl",
        [_generation_payload(0, [("qd_a", 88.0, 0.89, 0.9)])],
    )
    _write_archive_summary(qd_root / "RTLLM" / "Prob001" / "archive_summary.json")
    _write_archive_cells(qd_root / "RTLLM" / "Prob001" / "archive_cells.csv", ["qd_a"])
    _write_qd_event(
        qd_root / "RTLLM" / "Prob001" / "Gen0" / "sample_0" / "qd_archive_event.json",
        candidate_id="qd_a",
        generation=0,
        seq_ratio=0.2,
        mux_ratio=0.1,
        cell_count_log=1.0,
        quality_score=0.2,
    )

    result = subprocess.run(
        [
            str(Path(os.sys.executable)),
            str(script_path),
            "--subset-config",
            str(subset_config),
            "--backend_run",
            f"classic={classic_root}",
            "--backend_run",
            f"cvt_struct={qd_root}",
            "--output-dir",
            str(output_dir),
        ],
        cwd=repo_root,
        capture_output=True,
        text=True,
        check=False,
    )

    assert result.returncode == 0, result.stderr
    summary = json.loads((output_dir / "summary.json").read_text(encoding="utf-8"))
    assert summary["run_root"] is None
    assert [item["backend"] for item in summary["backend_runs"]] == ["classic", "cvt_struct"]
    assert (output_dir / "feature_analysis" / "summary.json").is_file()
    assert (output_dir / "design_space_analysis" / "summary.json").is_file()
    assert (output_dir / "report.md").is_file()
    design_space_summary = json.loads(
        (output_dir / "design_space_analysis" / "summary.json").read_text(encoding="utf-8")
    )
    assert design_space_summary["classical_anchor_backend"] == "classic"
