from __future__ import annotations

import csv
import json
from pathlib import Path

from scripts.package_full_rtllm_family_audit import main


def test_package_full_rtllm_family_audit(tmp_path: Path) -> None:
    run_root = tmp_path / "run"
    package_dir = tmp_path / "package"
    manifest = tmp_path / "manifest.csv"
    candidates = tmp_path / "candidates.csv"
    problems = ["Prob045_alu", "Prob041_traffic_light"]
    manifest.write_text(
        "index,benchmark,problem,prompt_path\n"
        + "\n".join(
            f"{index},RTLLM,{problem},bench/RTLLM/{problem}_prompt.txt"
            for index, problem in enumerate(problems, start=1)
        )
        + "\n",
        encoding="utf-8",
    )
    rows = []
    for problem in problems:
        rows += _write_problem(run_root, "classic_revolution", "Classic", problem, ("AND2_X1",))
        rows += _write_problem(
            run_root,
            "sr_raw_conservative_exploit_qd",
            "Exact T26 QD",
            problem,
            ("XOR2_X1", "XNOR2_X1"),
        )
    _write_candidates(candidates, rows)

    assert (
        main(
            [
                "--run-root",
                str(run_root),
                "--manifest",
                str(manifest),
                "--ppa-candidates",
                str(candidates),
                "--output-dir",
                str(package_dir),
            ]
        )
        == 0
    )

    aggregate = list(
        csv.DictReader((package_dir / "tables" / "full_family_aggregate_metrics.csv").open())
    )
    qd = next(
        row
        for row in aggregate
        if row["cohort"] == "all_rtllm" and row["method"] == "sr_raw_conservative_exploit_qd"
    )
    classic = next(
        row
        for row in aggregate
        if row["cohort"] == "all_rtllm" and row["method"] == "classic_revolution"
    )
    assert classic["front_unique_family_count"] == "2"
    assert qd["front_unique_family_count"] == "4"
    assert qd["audited_family_ratio"] == "1.000000"
    assert "Full RTLLM Family Audit" in (package_dir / "README.md").read_text(encoding="utf-8")
    for figure in (
        "full_family_aggregate_counts.png",
        "full_front_family_delta_heatmap.png",
        "full_family_ratio_distribution.png",
    ):
        assert (package_dir / "figures" / figure).read_bytes().startswith(b"\x89PNG")


def _write_problem(
    root: Path,
    method: str,
    label: str,
    problem: str,
    cell_types: tuple[str, ...],
) -> list[dict[str, str]]:
    mode = f"{method}/seed_1001/openai_gpt-oss-120b"
    problem_root = root / mode / "RTLLM" / problem
    generated = []
    rows = []
    for index, cell_type in enumerate(cell_types):
        candidate_id = f"{method}-{problem}-{index}"
        candidate_dir = problem_root / "Gen0" / f"{problem}_sample{index + 1}_initial"
        candidate_dir.mkdir(parents=True)
        code_path = candidate_dir / "code.sv"
        code_path.write_text(f"module {problem}; assign y = 1'b{index}; endmodule\n", encoding="utf-8")
        (candidate_dir / "code.syn.v").write_text(
            f"module {problem}();\n  {cell_type} _{index}_ ();\nendmodule\n",
            encoding="utf-8",
        )
        generated.append(
            {
                "id": candidate_id,
                "strategy": "initial",
                "status": "success",
                "code_file_path": str(code_path),
            }
        )
        rows.append(
            {
                "method": method,
                "method_label": label,
                "problem": problem,
                "candidate_id": candidate_id,
                "generation": "0",
                "is_pareto_front": "True",
                "area": f"{90.0 - index:.6f}",
                "power": f"{9.0 + index:.6f}",
                "eff_clk_period": "",
                "area_improvement": f"{0.10 + index / 100.0:.6f}",
                "power_improvement": f"{0.10 - index / 100.0:.6f}",
                "eff_clk_period_improvement": "",
                "objective_metrics": "area|power",
            }
        )
    (problem_root / "generation_log.jsonl").write_text(
        json.dumps({"generation": 0, "generated_candidates": generated}) + "\n",
        encoding="utf-8",
    )
    return rows


def _write_candidates(path: Path, rows: list[dict[str, str]]) -> None:
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(rows[0]), lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)
