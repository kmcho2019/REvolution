from __future__ import annotations

import importlib.util
import json
import sys
from pathlib import Path

import pandas as pd

_SCRIPT = (
    Path(__file__).resolve().parent.parent.parent
    / "scripts"
    / "build_auto_bd_standard_results.py"
)
_SPEC = importlib.util.spec_from_file_location("build_auto_bd_standard_results", _SCRIPT)
assert _SPEC is not None and _SPEC.loader is not None
mod = importlib.util.module_from_spec(_SPEC)
sys.modules.setdefault("build_auto_bd_standard_results", mod)
_SPEC.loader.exec_module(mod)


def test_build_standard_results_writes_required_files(tmp_path):
    run_dir = _write_run(tmp_path)
    manifest = _write_manifest(tmp_path)
    output = tmp_path / "standard"

    summary = mod.build_standard_results(
        run_dir=run_dir,
        output_dir=output,
        method_name="motif",
        method_family="auto_bd_fixed_vector",
        descriptor_version="motif4_seed1",
        phase="development_preliminary_seed1",
        seed=1001,
        run_manifest=manifest,
        common_audit_bins=4,
    )

    assert summary["candidate_count"] == 1
    assert summary["valid_ppa_candidate_count"] == 1
    assert summary["unique_canonical_netlist_count"] == 1
    candidates = pd.read_parquet(output / "candidates.parquet")
    hashes = pd.read_parquet(output / "netlist_hashes.parquet")
    assert candidates.loc[0, "common_audit_cell_id"].startswith("audit_motif4:")
    assert hashes.loc[0, "canonical_netlist_hash"]
    assert (output / "run_manifest.json").is_file()
    assert (output / "method_summary.json").is_file()


def test_main_writes_standard_results(tmp_path):
    run_dir = _write_run(tmp_path)
    _write_manifest(tmp_path)
    output = tmp_path / "standard"

    code = mod.main(
        [
            "--run-dir",
            str(run_dir),
            "--output-dir",
            str(output),
            "--method-name",
            "motif",
            "--method-family",
            "auto_bd_fixed_vector",
            "--descriptor-version",
            "motif4_seed1",
        ]
    )

    assert code == 0
    assert sorted(path.name for path in output.iterdir()) == sorted(mod.RESULT_FILES)


def test_load_generated_candidates_merges_population_scores(tmp_path):
    problem_dir = tmp_path / "Bench" / "ProbA"
    sample_dir = problem_dir / "Gen0" / "ProbA_sample1_initial"
    sample_dir.mkdir(parents=True)
    code_path = sample_dir / "code.sv"
    (problem_dir / "generation_log.jsonl").write_text(
        json.dumps(
            {
                "generation": 0,
                "generated_candidates": [
                    {
                        "id": "c0",
                        "status": "success",
                        "code_file_path": str(code_path),
                    }
                ],
                "population_ppa_details": [
                    {
                        "id": "c0",
                        "score": 0.75,
                        "ppa_metrics": {"area": 2.0},
                    }
                ],
            }
        )
        + "\n",
        encoding="utf-8",
    )

    rows = mod.load_generated_candidates(problem_dir)

    assert rows[code_path.as_posix()]["score"] == 0.75
    assert rows[code_path.as_posix()]["ppa_metrics"]["area"] == 2.0


def _write_run(tmp_path: Path) -> Path:
    run_dir = tmp_path / "seed_1001" / "revolution" / "model"
    problem_dir = run_dir / "Bench" / "ProbA"
    sample_dir = problem_dir / "Gen0" / "ProbA_sample1_initial"
    sample_dir.mkdir(parents=True)
    (sample_dir / "thought.txt").write_text("prompt", encoding="utf-8")
    (sample_dir / "code.sv").write_text("module m(input a, output y); assign y = a; endmodule\n", encoding="utf-8")
    (sample_dir / "code.syn.v").write_text(
        "module m(input a, output y);\n  INV_X1 u0 (.A(a), .ZN(y));\nendmodule\n",
        encoding="utf-8",
    )
    (sample_dir / "code_synthesis_report.ppa").write_text(
        "tns,wns,eff_clk_period,power,area\n0,0,0,1.0,2.0\n",
        encoding="utf-8",
    )
    (sample_dir / "code_synthesis_report.metrics.json").write_text(
        json.dumps({"ppa_metrics": {"power": 1.0, "area": 2.0, "eff_clk_period": 0.0}}),
        encoding="utf-8",
    )
    (sample_dir / "code_simulation.log").write_text("pass", encoding="utf-8")
    (sample_dir / "qd_archive_event.json").write_text(
        json.dumps(
            {
                "candidate_id": "c0",
                "generation": 0,
                "strategy": "initial",
                "quality_score": 0.5,
                "cell_id": "warmup:0",
                "archive_axes": ["motif_logic_ratio"],
                "descriptor_tuple": [1.0],
                "ppa_metrics": {"power": 1.0, "area": 2.0, "eff_clk_period": 0.0},
            }
        ),
        encoding="utf-8",
    )
    (problem_dir / "ProbA_summary.json").write_text(
        json.dumps(
            {
                "model_name": "model",
                "total_candidates_generated": 1,
                "total_generations": 1,
            }
        ),
        encoding="utf-8",
    )
    (problem_dir / "generation_log.jsonl").write_text(
        json.dumps(
            {
                "generation": 0,
                "runtime_seconds": 1.0,
                "llm_api_calls": 1,
                "success_rates": {
                    "total_syntax": 1.0,
                    "total_functionality": 1.0,
                    "total_synthesis_ppa": 1.0,
                },
                "generation_ppa": {"best_score": 0.5, "average_score": 0.5},
                "generated_candidates": [
                    {
                        "id": "c0",
                        "strategy": "initial",
                        "status": "success",
                        "code_file_path": str(sample_dir / "code.sv"),
                    }
                ],
            }
        )
        + "\n",
        encoding="utf-8",
    )
    (problem_dir / "archive_summary.json").write_text(
        json.dumps({"archive_type": "grid_quantile", "occupied_cells": 1, "qd_score": 0.5}),
        encoding="utf-8",
    )
    return run_dir


def _write_manifest(tmp_path: Path) -> Path:
    path = tmp_path / "seed_1001" / "run_manifest.json"
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(
        json.dumps({field: "x" for field in mod.RUN_MANIFEST_FIELDS}),
        encoding="utf-8",
    )
    return path
