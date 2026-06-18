from __future__ import annotations

import importlib.util
import json
import sys
from pathlib import Path

import pandas as pd

_SCRIPT = (
    Path(__file__).resolve().parent.parent.parent
    / "scripts"
    / "report_auto_bd_standard_results.py"
)
_SPEC = importlib.util.spec_from_file_location("report_auto_bd_standard_results", _SCRIPT)
assert _SPEC is not None and _SPEC.loader is not None
mod = importlib.util.module_from_spec(_SPEC)
sys.modules.setdefault("report_auto_bd_standard_results", mod)
_SPEC.loader.exec_module(mod)


def test_build_report_marks_gate0_and_hv_win(tmp_path: Path) -> None:
    repo_root = _write_reference(tmp_path)
    results_root = tmp_path / "exp"
    _write_standard_dir(
        results_root,
        "classic_revolution",
        area=90.0,
        power=0.9,
        fitness=0.1,
        netlist_hash="classic_hash",
    )
    _write_standard_dir(
        results_root,
        "netlist_motif_occupancy",
        area=80.0,
        power=0.8,
        fitness=0.2,
        netlist_hash="motif_hash",
    )

    report = mod.build_report(
        results_root=results_root,
        repo_root=repo_root,
        phase="development_preliminary_seed1",
        seed=1001,
    )

    gates = {row["method_name"]: row for row in report["gate_matrix"]}
    leaderboard = {row["method_name"]: row for row in report["leaderboard"]}
    robustness = {row["method_name"]: row for row in report["robustness_funnel"]}
    comparisons = {
        (row["method_name"], row["problem_id"]): row
        for row in report["comparison_matrix"]
    }
    failures = {
        (row["method_name"], row["failure_reason"]): row["count"]
        for row in report["failure_breakdown"]
    }
    assert gates["netlist_motif_occupancy"]["gate0"] == "PASS"
    assert leaderboard["netlist_motif_occupancy"]["hv_wins"] == 1
    assert leaderboard["netlist_motif_occupancy"]["fitness_wins"] == 1
    assert comparisons[("netlist_motif_occupancy", "Bench/ProbA")]["fitness_outcome"] == "W"
    assert robustness["classic_revolution"]["total_candidates"] == 2
    assert failures[("classic_revolution", "testbench_functional_failure")] == 1
    assert report["anytime_summary"][0]["final_generation"] == 1
    assert report["qd_summary"][0]["common_audit_coverage"] == 1 / 256
    assert report["qd_summary"][0]["common_audit_entropy_bits"] == 0.0
    assert any(
        row["descriptor_space"] == "common_audit"
        for row in report["descriptor_correlations"]
    )
    assert report["representative_elites"][0]["selection_kind"] == "method_best_fitness"
    assert leaderboard["classic_revolution"]["duplicate_netlist_count"] == 0


def test_main_writes_markdown_and_json(tmp_path: Path) -> None:
    repo_root = _write_reference(tmp_path)
    results_root = tmp_path / "exp"
    _write_standard_dir(
        results_root,
        "classic_revolution",
        area=90.0,
        power=0.9,
        fitness=0.1,
        netlist_hash="classic_hash",
    )
    _write_standard_dir(
        results_root,
        "landing_smooth_qd_manual_bd",
        area=85.0,
        power=0.85,
        fitness=0.15,
        netlist_hash="manual_hash",
    )
    output_md = tmp_path / "report.md"
    output_json = tmp_path / "report.json"
    figure_dir = tmp_path / "figures"

    code = mod.main(
        [
            "--results-root",
            str(results_root),
            "--repo-root",
            str(repo_root),
            "--output-md",
            str(output_md),
            "--output-json",
            str(output_json),
            "--figure-dir",
            str(figure_dir),
        ]
    )

    assert code == 0
    assert "Auto-BD Seed-1 Centralized Report" in output_md.read_text(encoding="utf-8")
    payload = json.loads(output_json.read_text(encoding="utf-8"))
    assert payload["normalization"]["hypervolume_reference_point"] == 0.0
    assert (figure_dir / "anytime_mean_best_fitness.png").read_bytes().startswith(b"\x89PNG")
    assert (figure_dir / "anytime_mean_hypervolume.png").read_bytes().startswith(b"\x89PNG")
    assert (figure_dir / "qd_common_audit_coverage.png").read_bytes().startswith(b"\x89PNG")
    assert (figure_dir / "qd_common_audit_entropy.png").read_bytes().startswith(b"\x89PNG")
    assert (figure_dir / "qd_common_audit_cells_heatmap.png").read_bytes().startswith(b"\x89PNG")
    assert (figure_dir / "descriptor_common_audit_ppa_correlation.png").read_bytes().startswith(
        b"\x89PNG"
    )
    assert (figure_dir / "descriptor_internal_ppa_correlation.png").read_bytes().startswith(
        b"\x89PNG"
    )
    assert (figure_dir / "manual_bd_ppa_correlation.png").read_bytes().startswith(b"\x89PNG")


def _write_reference(tmp_path: Path) -> Path:
    repo_root = tmp_path / "repo"
    bench_dir = repo_root / "data" / "bench" / "Bench"
    bench_dir.mkdir(parents=True)
    (bench_dir / "ProbA_ppa.txt").write_text(
        "tns,wns,eff_clk_period,power,area\n0,0,0,1.0,100.0\n",
        encoding="utf-8",
    )
    return repo_root


def _write_standard_dir(
    results_root: Path,
    method: str,
    *,
    area: float,
    power: float,
    fitness: float,
    netlist_hash: str,
) -> None:
    result_dir = results_root / method / "seed_1001" / "standard_results"
    result_dir.mkdir(parents=True)
    problem_id = "Bench/ProbA"
    archive_type = "none" if method == "classic_revolution" else "grid_quantile"
    archive_cell_id = None if method == "classic_revolution" else "0,0,0"
    descriptor_axes = "[]"
    descriptor_vector = "[]"
    if method == "landing_smooth_qd_manual_bd":
        descriptor_axes = '["logic_depth", "ff_depth", "comb_width_log"]'
        descriptor_vector = "[1.0, 2.0, 3.0]"
    elif method != "classic_revolution":
        descriptor_axes = '["motif_logic_ratio", "motif_control_ratio"]'
        descriptor_vector = "[0.1, 0.2]"
    candidates = pd.DataFrame(
        [
            {
                "method_name": method,
                "problem_id": problem_id,
                "candidate_id": "candidate-0",
                "operator_name": "initial",
                "benchmark_source": "Bench",
                "syntax_pass": True,
                "functionality_pass": True,
                "synthesis_pass": True,
                "openroad_pass": True,
                "valid_ppa": True,
                "failure_reason": "",
                "area": area,
                "power": power,
                "timing_or_clock_period": 0.0,
                "fitness": fitness,
                "canonical_netlist_hash": netlist_hash,
                "motif_signature_hash": f"{netlist_hash}_motif",
                "descriptor_vector": descriptor_vector,
                "common_audit_descriptor_vector": "[0.1, 0.2, 0.3, 0.4]",
                "archive_cell_id": archive_cell_id,
                "common_audit_cell_id": "audit_motif4:0,0,0,0",
                "rtl_path": "exp/example/code.sv",
                "netlist_path": "exp/example/code.syn.v",
                "log_path": "exp/example/code_simulation.log",
                "generation": 0,
            },
            {
                "method_name": method,
                "problem_id": problem_id,
                "candidate_id": "candidate-1",
                "operator_name": "initial",
                "benchmark_source": "Bench",
                "syntax_pass": True,
                "functionality_pass": False,
                "synthesis_pass": False,
                "openroad_pass": False,
                "valid_ppa": False,
                "failure_reason": "testbench_functional_failure",
                "area": None,
                "power": None,
                "timing_or_clock_period": None,
                "fitness": None,
                "canonical_netlist_hash": None,
                "motif_signature_hash": None,
                "descriptor_vector": "[]",
                "common_audit_descriptor_vector": "[]",
                "archive_cell_id": None,
                "common_audit_cell_id": None,
                "rtl_path": "exp/example/bad/code.sv",
                "netlist_path": "",
                "log_path": "exp/example/bad/code_simulation.log",
                "generation": 1,
            }
        ]
    )
    candidates.to_parquet(result_dir / "candidates.parquet", index=False)
    candidates.loc[candidates["valid_ppa"].eq(True)].to_parquet(
        result_dir / "elites.parquet",
        index=False,
    )
    pd.DataFrame(
        [
            {
                "method_name": method,
                "problem_id": problem_id,
                "generation": 0,
                "runtime_seconds": 1.0,
                "llm_api_calls": 2,
            }
        ]
    ).to_parquet(result_dir / "per_generation_metrics.parquet", index=False)
    pd.DataFrame(
        [
            {
                "method_name": method,
                "problem_id": problem_id,
                "seed": 1001,
                "archive_type": archive_type,
                "internal_occupied_cells": None
                if method == "classic_revolution"
                else 1,
                "internal_qd_score": None
                if method == "classic_revolution"
                else fitness,
                "common_audit_bins": 4,
                "common_audit_total_cells": 256,
                "common_audit_occupied_cells": 1,
                "common_audit_coverage": 1 / 256,
                "common_audit_qd_score": fitness,
            }
        ]
    ).to_parquet(result_dir / "archive_snapshots.parquet", index=False)
    pd.DataFrame(
        [
            {
                "method_name": method,
                "problem_id": problem_id,
                "seed": 1001,
                "candidate_id": "candidate-0",
                "descriptor_axes": descriptor_axes,
                "descriptor_vector": descriptor_vector,
                "common_audit_axes": (
                    '["motif_logic_ratio", "motif_control_ratio", '
                    '"motif_arith_ratio", "motif_diversity"]'
                ),
                "common_audit_descriptor_vector": "[0.1, 0.2, 0.3, 0.4]",
                "common_audit_cell_id": "audit_motif4:0,0,0,0",
            }
        ]
    ).to_parquet(result_dir / "descriptor_vectors.parquet", index=False)
    (result_dir / "method_summary.json").write_text(
        json.dumps(
            {
                "method_name": method,
                "valid_ppa_candidate_count": 1,
                "unique_canonical_netlist_count": 1,
                "unique_motif_signature_count": 1,
                "common_audit_occupied_cells": 1,
                "common_audit_qd_score": fitness,
            }
        ),
        encoding="utf-8",
    )
