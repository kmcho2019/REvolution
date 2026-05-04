from __future__ import annotations

import json
import os
import subprocess
from pathlib import Path

import yaml


def _write_subset_config(path: Path, selected_problems: list[dict[str, str]]) -> None:
    path.write_text(
        yaml.safe_dump(
            {
                "subset_name": "design_space_subset",
                "selected_problems": selected_problems,
            },
            sort_keys=False,
        ),
        encoding="utf-8",
    )


def _candidate_detail(
    *,
    candidate_id: str,
    report_path: str,
    area: float,
    power: float,
    period: float | None,
    score: float,
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


def _write_generation_log(path: Path, payloads: list[dict]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(
        "\n".join(json.dumps(payload) for payload in payloads) + "\n",
        encoding="utf-8",
    )


def _write_summary(
    path: Path,
    *,
    benchmark: str,
    problem: str,
    ref_ppa_metric: dict[str, float],
    final_details: list[dict],
    search_mode: str | None = None,
    descriptor_profile: str | None = None,
    descriptor_axes: list[str] | None = None,
) -> None:
    payload = {
        "benchmark_name": benchmark,
        "problem_name": problem,
        "accumulated_success_rates": {
            "functionality": 1.0,
            "synthesis_ppa": 1.0,
        },
        "final_population_ppa": {"best_score": 0.4},
        "final_population_ppa_details": final_details,
        "ref_ppa_metric": ref_ppa_metric,
        "total_runtime_seconds": 10.0,
    }
    if search_mode is not None:
        qd_config: dict[str, object] = {"archive_type": "cvt"}
        if descriptor_profile is not None:
            qd_config["descriptor_profile"] = descriptor_profile
        if descriptor_axes is not None:
            qd_config["descriptor_axes"] = descriptor_axes
        payload["backend_details"] = {
            "search_mode": search_mode,
            "qd_config": qd_config,
        }
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(payload, indent=2), encoding="utf-8")


def _write_archive_cells(path: Path, candidate_ids: list[str]) -> None:
    lines = [
        "cell_id,candidate_id,quality_score,generation,strategy,code_file_path,g_P,g_A,g_T,descriptors_json,parent_ids_json"
    ]
    for index, candidate_id in enumerate(candidate_ids):
        lines.append(
            f"{index},{candidate_id},0.1,{index},seed,/tmp/{candidate_id}.sv,0.1,0.1,0.1,[],[]"
        )
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def _code_text(circuit_type: str) -> str:
    if circuit_type == "combinational":
        return (
            "module top(input logic a, input logic b, output logic y);\n"
            "  logic tmp;\n"
            "  assign tmp = a ^ b;\n"
            "  assign y = tmp;\n"
            "endmodule\n"
        )
    return (
        "module top(input logic clk, input logic rst, input logic a, output logic y);\n"
        "  always_ff @(posedge clk or posedge rst) begin\n"
        "    if (rst) y <= 1'b0;\n"
        "    else y <= a;\n"
        "  end\n"
        "endmodule\n"
    )


def _write_candidate_artifacts(
    candidate_dir: Path,
    *,
    area: float,
    power: float,
    period: float | None,
    total_cells: float,
    seq_ratio: float,
    utilization: float,
    circuit_type: str,
) -> None:
    candidate_dir.mkdir(parents=True, exist_ok=True)
    (candidate_dir / "code.sv").write_text(_code_text(circuit_type), encoding="utf-8")
    metrics = {
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
        metrics["ppa_metrics"]["eff_clk_period"] = period
    (candidate_dir / "code_synthesis_report.metrics.json").write_text(
        json.dumps(metrics, indent=2),
        encoding="utf-8",
    )
    (candidate_dir / "code_synthesis_report.ppa").write_text("placeholder\n", encoding="utf-8")


def _write_qd_event(
    candidate_dir: Path,
    *,
    candidate_id: str,
    generation: int,
    descriptor_profile: str | None = None,
) -> None:
    if descriptor_profile == "journal_logic_ff_width_3d":
        descriptor_values = {
            "logic_depth": 4.0 + generation,
            "ff_depth": 1.0 + generation,
            "comb_width_log": 2.0 + generation * 0.2,
        }
        graph_metrics = {**descriptor_values, "combinational_cells": 6.0 + generation}
        archive_axes = ["logic_depth", "ff_depth", "comb_width_log"]
    else:
        descriptor_values = {
            "seq_ratio": 0.3 + generation * 0.05,
            "mux_ratio": 0.1 + generation * 0.02,
            "cell_count_log": 3.0 + generation * 0.1,
        }
        graph_metrics = {}
        archive_axes = ["seq_ratio", "mux_ratio", "cell_count_log"]
    payload = {
        "candidate_id": candidate_id,
        "generation": generation,
        "strategy": "M-I",
        "origin_pool": "success_pool",
        "generated_mode": "whole",
        "archive_type": "cvt",
        "archive_axes": archive_axes,
        "quality_score": 0.3 + generation * 0.02,
        "score_components": {
            "g_P": 0.1 + generation * 0.01,
            "g_A": 0.12 + generation * 0.01,
            "g_T": 0.14 + generation * 0.01,
        },
        "structural_metrics": {
            "seq_ratio": 0.3 + generation * 0.05,
            "mux_ratio": 0.1 + generation * 0.02,
            "cell_count_log": 20.0 + generation,
        },
        "rtl_metrics": {
            "assign_count": 2.0 + generation,
            "if_count": 1.0 + generation,
        },
        "dynamic_metrics": {},
        "graph_metrics": graph_metrics,
        "physical_metrics": {"utilization": 0.7 + generation * 0.01},
        "descriptor_values": descriptor_values,
        "cell_id": f"{generation},0",
        "decision": "inserted",
        "inserted": True,
        "replaced": False,
        "current_cell_elite": {"code_file_path": str(candidate_dir / "code.sv")},
    }
    (candidate_dir / "qd_archive_event.json").write_text(json.dumps(payload), encoding="utf-8")


def _build_problem(
    root: Path,
    *,
    benchmark: str,
    problem: str,
    circuit_type: str,
    search_mode: str | None,
    generations: list[tuple[int, float, float, float | None]],
    include_qd_events: bool,
    descriptor_profile: str | None = None,
    descriptor_axes: list[str] | None = None,
) -> None:
    problem_root = root / benchmark / problem
    ref = {"area": 100.0, "power": 1.0, "eff_clk_period": 1.0 if circuit_type == "sequential" else 0.0}
    generation_payloads: list[dict] = []
    final_details: list[dict] = []
    qd_candidate_ids: list[str] = []
    for generation, area, power, period in generations:
        candidate_id = f"{problem.lower()}_{generation}"
        candidate_dir = problem_root / f"Gen{generation}" / f"{problem}_sample{generation}_M-I"
        _write_candidate_artifacts(
            candidate_dir,
            area=area,
            power=power,
            period=period,
            total_cells=20.0 + generation,
            seq_ratio=0.5 if circuit_type == "sequential" else 0.0,
            utilization=0.65 + generation * 0.02,
            circuit_type=circuit_type,
        )
        if include_qd_events:
            _write_qd_event(
                candidate_dir,
                candidate_id=candidate_id,
                generation=generation,
                descriptor_profile=descriptor_profile,
            )
            qd_candidate_ids.append(candidate_id)
        detail = _candidate_detail(
            candidate_id=candidate_id,
            report_path=str(candidate_dir / "code_synthesis_report.ppa"),
            area=area,
            power=power,
            period=period,
            score=0.2 + generation * 0.02,
        )
        final_details.append(detail)
        generation_payloads.append(
            {
                "generation": generation,
                "population_ppa_details": [detail],
            }
        )
    _write_summary(
        problem_root / f"{problem}_summary.json",
        benchmark=benchmark,
        problem=problem,
        ref_ppa_metric=ref,
        final_details=final_details,
        search_mode=search_mode,
        descriptor_profile=descriptor_profile,
        descriptor_axes=descriptor_axes,
    )
    _write_generation_log(problem_root / "generation_log.jsonl", generation_payloads)
    if include_qd_events:
        _write_archive_cells(problem_root / "archive_cells.csv", qd_candidate_ids)


def test_report_design_space_analysis_generates_mixed_outputs(tmp_path: Path) -> None:
    repo_root = Path(__file__).resolve().parents[2]
    script_path = repo_root / "scripts" / "report_design_space_analysis.py"
    subset_config = tmp_path / "subset.yaml"
    _write_subset_config(
        subset_config,
        [
            {"benchmark": "RTLLM", "problem": "SeqProb"},
            {"benchmark": "RTLLM", "problem": "CombProb"},
        ],
    )

    classic_root = tmp_path / "classic"
    qd_root = tmp_path / "cvt_struct"
    _build_problem(
        classic_root,
        benchmark="RTLLM",
        problem="SeqProb",
        circuit_type="sequential",
        search_mode=None,
        generations=[(0, 94.0, 0.92, 0.88), (1, 92.0, 0.9, 0.84), (2, 90.0, 0.88, 0.8)],
        include_qd_events=False,
    )
    _build_problem(
        classic_root,
        benchmark="RTLLM",
        problem="CombProb",
        circuit_type="combinational",
        search_mode=None,
        generations=[(0, 44.0, 0.7, None)],
        include_qd_events=False,
    )
    _build_problem(
        qd_root,
        benchmark="RTLLM",
        problem="SeqProb",
        circuit_type="sequential",
        search_mode="revolution_qd",
        generations=[(0, 90.0, 0.86, 0.82), (1, 88.0, 0.84, 0.8), (2, 86.0, 0.82, 0.78)],
        include_qd_events=True,
        descriptor_profile="size_control_3d",
    )
    _build_problem(
        qd_root,
        benchmark="RTLLM",
        problem="CombProb",
        circuit_type="combinational",
        search_mode="revolution_qd",
        generations=[(0, 40.0, 0.66, None)],
        include_qd_events=True,
        descriptor_profile="size_control_3d",
    )

    output_dir = tmp_path / "analysis"
    env = os.environ.copy()
    env["MPLBACKEND"] = "Agg"
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
            "--aggregate-ppa-basis",
            "both",
            "--include-3d",
        ],
        cwd=repo_root,
        env=env,
        check=False,
        capture_output=True,
        text=True,
    )

    assert result.returncode == 0, result.stderr
    assert (output_dir / "report.md").is_file()
    assert (output_dir / "summary.json").is_file()
    assert (output_dir / "successful_candidates.csv").is_file()
    assert (output_dir / "recommended_profile.json").is_file()
    assert (output_dir / "aggregate" / "report.md").is_file()

    seq_problem_dir = output_dir / "problems" / "RTLLM" / "SeqProb"
    comb_problem_dir = output_dir / "problems" / "RTLLM" / "CombProb"
    assert (seq_problem_dir / "ppa_gen000_local_power_area.png").is_file()
    assert (seq_problem_dir / "ppa_gen000_local_power_eff_clk_period.png").is_file()
    assert (seq_problem_dir / "ppa_gen000_local_area_eff_clk_period.png").is_file()
    assert (seq_problem_dir / "ppa_gen000_local_3d.png").is_file()
    assert (seq_problem_dir / "ppa_gen002_accumulated_power_area.png").is_file()
    assert (seq_problem_dir / "features_gen002_accumulated_pca.png").is_file()
    assert (seq_problem_dir / "features_gen002_accumulated_tsne.png").is_file()
    assert (seq_problem_dir / "features_classic_vs_cvt_struct_gen002_accumulated_pca.png").is_file()
    assert (seq_problem_dir / "features_classic_vs_cvt_struct_gen002_accumulated_tsne.png").is_file()
    assert (comb_problem_dir / "ppa_gen000_local_power_area.png").is_file()
    assert not (comb_problem_dir / "ppa_gen000_local_3d.png").exists()

    assert (output_dir / "aggregate" / "overall_sequential_normalized_g_P_g_A.png").is_file()
    assert (output_dir / "aggregate" / "overall_sequential_raw_power_area.png").is_file()
    assert (output_dir / "aggregate" / "overall_sequential_classic_vs_cvt_struct_features_pca.png").is_file()
    assert (output_dir / "aggregate" / "overall_sequential_classic_vs_cvt_struct_features_tsne.png").is_file()
    top_report = (output_dir / "report.md").read_text(encoding="utf-8")
    assert "successful_candidates.csv" in top_report
    assert "recommended_profile.json" in top_report
    assert "## Contents" in top_report
    seq_report = (seq_problem_dir / "report.md").read_text(encoding="utf-8")
    assert "## Quick Reference" in seq_report
    assert seq_report.index("## Quick Reference") < seq_report.index("## PPA Chronology")
    assert "## All-backend feature space" in seq_report
    assert "## classic vs cvt_struct" in seq_report
    assert "size_control_3d descriptor profile" in seq_report
    aggregate_report = (output_dir / "aggregate" / "report.md").read_text(encoding="utf-8")
    assert "## Contents" in aggregate_report
    assert "classic vs cvt_struct" in aggregate_report
    summary = json.loads((output_dir / "summary.json").read_text(encoding="utf-8"))
    assert summary["classical_anchor_backend"] == "classic"
    assert any(
        item["qd_backend"] == "cvt_struct" and item["descriptor_profile"] == "size_control_3d"
        for item in summary["pairwise_feature_comparisons"]
    )


def test_report_design_space_analysis_feature_profile_and_explicit_override(tmp_path: Path) -> None:
    repo_root = Path(__file__).resolve().parents[2]
    script_path = repo_root / "scripts" / "report_design_space_analysis.py"
    subset_config = tmp_path / "subset.yaml"
    _write_subset_config(
        subset_config,
        [{"benchmark": "RTLLM", "problem": "SeqProb"}],
    )

    qd_root = tmp_path / "cvt_struct"
    _build_problem(
        qd_root,
        benchmark="RTLLM",
        problem="SeqProb",
        circuit_type="sequential",
        search_mode="revolution_qd",
        generations=[(0, 90.0, 0.86, 0.82), (1, 88.0, 0.84, 0.8)],
        include_qd_events=True,
    )

    env = os.environ.copy()
    env["MPLBACKEND"] = "Agg"

    profile_output = tmp_path / "profile_analysis"
    profile_result = subprocess.run(
        [
            str(Path(os.sys.executable)),
            str(script_path),
            "--subset-config",
            str(subset_config),
            "--backend_run",
            f"cvt_struct={qd_root}",
            "--output-dir",
            str(profile_output),
            "--feature-profile",
            "implemented_structural_fixed_5d",
        ],
        cwd=repo_root,
        env=env,
        check=False,
        capture_output=True,
        text=True,
    )

    assert profile_result.returncode == 0, profile_result.stderr
    profile_payload = json.loads(
        (profile_output / "recommended_profile.json").read_text(encoding="utf-8")
    )
    assert profile_payload["selection_mode"] == "profile"
    assert profile_payload["feature_profile"] == "implemented_structural_fixed_5d"

    explicit_output = tmp_path / "explicit_analysis"
    explicit_result = subprocess.run(
        [
            str(Path(os.sys.executable)),
            str(script_path),
            "--subset-config",
            str(subset_config),
            "--backend_run",
            f"cvt_struct={qd_root}",
            "--output-dir",
            str(explicit_output),
            "--feature-profile",
            "implemented_structural_fixed_5d",
            "--feature",
            "assign_count",
            "--feature",
            "if_count",
        ],
        cwd=repo_root,
        env=env,
        check=False,
        capture_output=True,
        text=True,
    )

    assert explicit_result.returncode == 0, explicit_result.stderr
    explicit_payload = json.loads(
        (explicit_output / "recommended_profile.json").read_text(encoding="utf-8")
    )
    assert explicit_payload["selection_mode"] == "explicit"
    assert explicit_payload["selected_non_target_features"] == ["assign_count", "if_count"]


def test_report_design_space_analysis_pairwise_basis_uses_qd_profile(tmp_path: Path) -> None:
    repo_root = Path(__file__).resolve().parents[2]
    script_path = repo_root / "scripts" / "report_design_space_analysis.py"
    subset_config = tmp_path / "subset.yaml"
    _write_subset_config(
        subset_config,
        [{"benchmark": "RTLLM", "problem": "SeqProb"}],
    )

    classic_root = tmp_path / "classic"
    qd_root = tmp_path / "cvt_struct"
    _build_problem(
        classic_root,
        benchmark="RTLLM",
        problem="SeqProb",
        circuit_type="sequential",
        search_mode=None,
        generations=[(0, 94.0, 0.92, 0.88), (1, 92.0, 0.9, 0.84), (2, 90.0, 0.88, 0.8)],
        include_qd_events=False,
    )
    _build_problem(
        qd_root,
        benchmark="RTLLM",
        problem="SeqProb",
        circuit_type="sequential",
        search_mode="revolution_qd",
        generations=[(0, 90.0, 0.86, 0.82), (1, 88.0, 0.84, 0.8), (2, 86.0, 0.82, 0.78)],
        include_qd_events=True,
        descriptor_profile="implemented_structural_fixed_5d",
    )

    output_dir = tmp_path / "analysis"
    env = os.environ.copy()
    env["MPLBACKEND"] = "Agg"
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
            "--feature",
            "assign_count",
            "--feature",
            "if_count",
        ],
        cwd=repo_root,
        env=env,
        check=False,
        capture_output=True,
        text=True,
    )

    assert result.returncode == 0, result.stderr
    report_text = (output_dir / "problems" / "RTLLM" / "SeqProb" / "report.md").read_text(
        encoding="utf-8"
    )
    assert "explicit report feature subset" in report_text
    assert "implemented_structural_fixed_5d descriptor profile" in report_text


def test_report_design_space_analysis_uses_cached_journal_qd_features(tmp_path: Path) -> None:
    repo_root = Path(__file__).resolve().parents[2]
    script_path = repo_root / "scripts" / "report_design_space_analysis.py"
    subset_config = tmp_path / "subset.yaml"
    _write_subset_config(
        subset_config,
        [{"benchmark": "RTLLM", "problem": "SeqProb"}],
    )

    classic_root = tmp_path / "classic"
    qd_root = tmp_path / "cvt_journal_bd"
    _build_problem(
        classic_root,
        benchmark="RTLLM",
        problem="SeqProb",
        circuit_type="sequential",
        search_mode=None,
        generations=[(0, 94.0, 0.92, 0.88), (1, 92.0, 0.9, 0.84), (2, 90.0, 0.88, 0.8)],
        include_qd_events=False,
    )
    _build_problem(
        qd_root,
        benchmark="RTLLM",
        problem="SeqProb",
        circuit_type="sequential",
        search_mode="revolution_qd",
        generations=[(0, 90.0, 0.86, 0.82), (1, 88.0, 0.84, 0.8), (2, 86.0, 0.82, 0.78)],
        include_qd_events=True,
        descriptor_profile="journal_logic_ff_width_3d",
        descriptor_axes=["logic_depth", "ff_depth", "comb_width_log"],
    )

    output_dir = tmp_path / "analysis"
    env = os.environ.copy()
    env["MPLBACKEND"] = "Agg"
    result = subprocess.run(
        [
            str(Path(os.sys.executable)),
            str(script_path),
            "--subset-config",
            str(subset_config),
            "--backend_run",
            f"classic={classic_root}",
            "--backend_run",
            f"cvt_journal_bd={qd_root}",
            "--output-dir",
            str(output_dir),
            "--feature-method",
            "pca",
        ],
        cwd=repo_root,
        env=env,
        check=False,
        capture_output=True,
        text=True,
    )

    assert result.returncode == 0, result.stderr
    problem_dir = output_dir / "problems" / "RTLLM" / "SeqProb"
    assert (problem_dir / "features_classic_vs_cvt_journal_bd_gen002_accumulated_pca.png").is_file()
    report_text = (problem_dir / "report.md").read_text(encoding="utf-8")
    assert "journal_logic_ff_width_3d descriptor profile" in report_text
    assert "without offline classic graph recovery" in report_text
    summary = json.loads((output_dir / "summary.json").read_text(encoding="utf-8"))
    assert any("Skipped automatic graph recovery" in warning for warning in summary["warnings"])
    assert any("cached only for the QD backend" in warning for warning in summary["warnings"])


def test_report_design_space_analysis_handles_classical_only_small_sample(tmp_path: Path) -> None:
    repo_root = Path(__file__).resolve().parents[2]
    script_path = repo_root / "scripts" / "report_design_space_analysis.py"
    subset_config = tmp_path / "subset.yaml"
    _write_subset_config(
        subset_config,
        [{"benchmark": "RTLLM", "problem": "TinyProb"}],
    )

    classic_root = tmp_path / "classic"
    _build_problem(
        classic_root,
        benchmark="RTLLM",
        problem="TinyProb",
        circuit_type="sequential",
        search_mode=None,
        generations=[(0, 96.0, 0.95, 0.94)],
        include_qd_events=False,
    )

    output_dir = tmp_path / "analysis"
    env = os.environ.copy()
    env["MPLBACKEND"] = "Agg"
    result = subprocess.run(
        [
            str(Path(os.sys.executable)),
            str(script_path),
            "--subset-config",
            str(subset_config),
            "--backend_run",
            f"classic={classic_root}",
            "--output-dir",
            str(output_dir),
            "--feature",
            "assign_count",
            "--feature",
            "if_count",
        ],
        cwd=repo_root,
        env=env,
        check=False,
        capture_output=True,
        text=True,
    )

    assert result.returncode == 0, result.stderr
    report_text = (output_dir / "problems" / "RTLLM" / "TinyProb" / "report.md").read_text(
        encoding="utf-8"
    )
    assert "too_few_successes" in report_text
    assert "Skipped pairwise feature plots because no classical anchor backend was available." not in report_text
    assert (output_dir / "successful_candidates.csv").is_file()


def test_report_design_space_analysis_warns_when_anchor_or_descriptor_basis_missing(tmp_path: Path) -> None:
    repo_root = Path(__file__).resolve().parents[2]
    script_path = repo_root / "scripts" / "report_design_space_analysis.py"
    subset_config = tmp_path / "subset.yaml"
    _write_subset_config(
        subset_config,
        [{"benchmark": "RTLLM", "problem": "SeqProb"}],
    )

    qd_only_root = tmp_path / "qd_only"
    _build_problem(
        qd_only_root,
        benchmark="RTLLM",
        problem="SeqProb",
        circuit_type="sequential",
        search_mode="revolution_qd",
        generations=[(0, 90.0, 0.86, 0.82), (1, 88.0, 0.84, 0.8), (2, 86.0, 0.82, 0.78)],
        include_qd_events=True,
    )

    env = os.environ.copy()
    env["MPLBACKEND"] = "Agg"
    qd_only_output = tmp_path / "qd_only_analysis"
    qd_only_result = subprocess.run(
        [
            str(Path(os.sys.executable)),
            str(script_path),
            "--subset-config",
            str(subset_config),
            "--backend_run",
            f"cvt_struct={qd_only_root}",
            "--output-dir",
            str(qd_only_output),
        ],
        cwd=repo_root,
        env=env,
        check=False,
        capture_output=True,
        text=True,
    )
    assert qd_only_result.returncode == 0, qd_only_result.stderr
    qd_only_summary = json.loads((qd_only_output / "summary.json").read_text(encoding="utf-8"))
    assert any("classical anchor backend" in warning for warning in qd_only_summary["warnings"])

    classic_root = tmp_path / "classic"
    qd_root = tmp_path / "qd_missing_basis"
    _build_problem(
        classic_root,
        benchmark="RTLLM",
        problem="SeqProb",
        circuit_type="sequential",
        search_mode=None,
        generations=[(0, 94.0, 0.92, 0.88), (1, 92.0, 0.9, 0.84), (2, 90.0, 0.88, 0.8)],
        include_qd_events=False,
    )
    _build_problem(
        qd_root,
        benchmark="RTLLM",
        problem="SeqProb",
        circuit_type="sequential",
        search_mode="revolution_qd",
        generations=[(0, 90.0, 0.86, 0.82), (1, 88.0, 0.84, 0.8), (2, 86.0, 0.82, 0.78)],
        include_qd_events=True,
        descriptor_profile=None,
        descriptor_axes=None,
    )
    missing_basis_output = tmp_path / "missing_basis_analysis"
    missing_basis_result = subprocess.run(
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
            str(missing_basis_output),
            "--feature",
            "assign_count",
            "--feature",
            "if_count",
        ],
        cwd=repo_root,
        env=env,
        check=False,
        capture_output=True,
        text=True,
    )
    assert missing_basis_result.returncode == 0, missing_basis_result.stderr
    missing_basis_summary = json.loads(
        (missing_basis_output / "summary.json").read_text(encoding="utf-8")
    )
    assert any("falling back to the global report feature subset" in warning for warning in missing_basis_summary["warnings"])


def test_report_design_space_analysis_help_is_actionable(tmp_path: Path) -> None:
    del tmp_path
    repo_root = Path(__file__).resolve().parents[2]
    script_path = repo_root / "scripts" / "report_design_space_analysis.py"

    result = subprocess.run(
        [
            str(Path(os.sys.executable)),
            str(script_path),
            "--help",
        ],
        cwd=repo_root,
        check=False,
        capture_output=True,
        text=True,
    )

    assert result.returncode == 0, result.stderr
    assert "--backend_run" in result.stdout
    assert "Explicit --feature values override --feature-profile" in result.stdout
    assert "qualitative-only" in result.stdout
