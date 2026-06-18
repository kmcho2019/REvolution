from __future__ import annotations

import importlib.util
import json
import sys
from pathlib import Path

_SCRIPT = (
    Path(__file__).resolve().parent.parent.parent
    / "scripts"
    / "summarize_auto_bd_gate0.py"
)
_SPEC = importlib.util.spec_from_file_location("summarize_auto_bd_gate0", _SCRIPT)
assert _SPEC is not None and _SPEC.loader is not None
mod = importlib.util.module_from_spec(_SPEC)
sys.modules.setdefault("summarize_auto_bd_gate0", mod)
_SPEC.loader.exec_module(mod)


def test_build_summary_counts_valid_ppa(tmp_path):
    run_dir = _write_run(tmp_path)

    payload = mod.build_summary(
        mod.Gate0Inputs(
            run_dir=run_dir,
            method_name="classic_revolution",
            phase="development_preliminary_seed1",
            seed=1001,
        )
    )

    assert payload["covered_problem_count"] == 1
    assert payload["missing_problem_count"] == 1
    assert payload["coverage_problem_set"] == ["Bench/ProbA"]
    assert payload["missing_problem_set"] == ["Bench/ProbB"]
    assert payload["problems"][0]["ppa_artifact_count"] == 1


def test_main_writes_summary(tmp_path):
    run_dir = _write_run(tmp_path)
    output = tmp_path / "gate0.json"

    code = mod.main(["--run-dir", str(run_dir), "--output", str(output)])

    payload = json.loads(output.read_text())
    assert code == 0
    assert payload["method_name"] == "classic_revolution"
    assert payload["coverage_problem_seed_set"] == ["Bench/ProbA#seed=1001"]


def test_load_summary_statuses_allows_failed_rerun_history(tmp_path):
    run_dir = _write_run(tmp_path)
    (run_dir / "20260617_summary_results.txt").write_text(
        "ProbA,initialization_failed\n",
        encoding="utf-8",
    )

    statuses = mod.load_summary_statuses(run_dir)

    assert statuses["ProbA"]["summary_status"] == "success"
    assert statuses["ProbA"]["best_code_path"] == "/tmp/ProbA/code.sv"


def _write_run(tmp_path: Path) -> Path:
    run_dir = tmp_path / "run"
    run_dir.mkdir()
    (run_dir / "20260618_summary_results.txt").write_text(
        "\n".join(
            [
                "ProbA,success,/tmp/ProbA/code.sv,N/A,0.5",
                "ProbB,failed,/tmp/ProbB/code.sv,N/A,0.0",
            ]
        )
        + "\n",
        encoding="utf-8",
    )
    _write_problem(run_dir / "Bench" / "ProbA", has_ppa=True)
    _write_problem(run_dir / "Bench" / "ProbB", has_ppa=False)
    return run_dir


def _write_problem(problem_dir: Path, *, has_ppa: bool) -> None:
    problem_dir.mkdir(parents=True)
    summary = {
        "total_candidates_generated": 2,
        "total_generations": 1,
        "final_population_ppa": {"best_score": 0.5 if has_ppa else None},
    }
    (problem_dir / f"{problem_dir.name}_summary.json").write_text(
        json.dumps(summary),
        encoding="utf-8",
    )
    (problem_dir / "archive_summary.json").write_text("{}", encoding="utf-8")
    (problem_dir / "global_pareto_summary.json").write_text("{}", encoding="utf-8")
    if has_ppa:
        sample_dir = problem_dir / "Gen0" / "sample"
        sample_dir.mkdir(parents=True)
        (sample_dir / "code_synthesis_report.ppa").write_text(
            "tns,wns,eff_clk_period,power,area\n0,0,0,1,1\n",
            encoding="utf-8",
        )
