import csv
import json
import os
import subprocess
from pathlib import Path

import yaml


def _write_csv(path: Path, rows: list[tuple[str, int]]) -> None:
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.writer(handle)
        writer.writerow(["Problem", "Reference Gate Count"])
        writer.writerows(rows)


def _write_summary(
    path: Path,
    *,
    benchmark: str,
    problem: str,
    functionality: float,
    synthesis: float,
    summary_container: str = "success_rates",
) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(
        json.dumps(
            {
                "benchmark_name": benchmark,
                "problem_name": problem,
                summary_container: {
                    "total_functionality": functionality,
                    "total_synthesis_ppa": synthesis,
                },
            }
        ),
        encoding="utf-8",
    )


def _write_ppa(path: Path, eff_clk_period: float) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(
        "tns,wns,eff_clk_period,power,area\n"
        f"0,0,{eff_clk_period},1,1\n",
        encoding="utf-8",
    )


def test_build_hard_iteration_subset_cli_writes_balanced_config(tmp_path):
    repo_root = Path(__file__).resolve().parents[2]
    script_path = repo_root / "scripts" / "build_hard_iteration_subset.py"

    one_shot_root = tmp_path / "one_shot"
    bench_root = tmp_path / "bench"
    rtllm_csv = tmp_path / "RTLLM.csv"
    verilogeval_csv = tmp_path / "VerilogEval-Spec-to-RTL.csv"

    _write_csv(
        rtllm_csv,
        [
            ("Prob101_comb", 1000),
            ("Prob102_comb", 900),
            ("Prob103_comb", 800),
            ("Prob104_comb", 700),
            ("Prob201_seq", 1100),
            ("Prob202_seq", 1000),
            ("Prob203_seq", 900),
            ("Prob204_seq", 800),
        ],
    )
    _write_csv(
        verilogeval_csv,
        [
            ("Prob301_comb", 1200),
            ("Prob302_comb", 1100),
            ("Prob303_comb", 1000),
            ("Prob304_comb", 900),
            ("Prob401_seq", 1300),
            ("Prob402_seq", 1200),
            ("Prob403_seq", 1100),
            ("Prob404_seq", 1000),
        ],
    )

    selected_data = [
        ("RTLLM", "Prob101_comb", 0.35, 0.20, 0.0),
        ("RTLLM", "Prob102_comb", 0.40, 0.20, 0.0),
        ("RTLLM", "Prob103_comb", 0.45, 0.20, 0.0),
        ("RTLLM", "Prob104_comb", 0.72, 0.20, 0.0),
        ("RTLLM", "Prob201_seq", 0.20, 0.20, 0.5),
        ("RTLLM", "Prob202_seq", 0.25, 0.20, 0.6),
        ("RTLLM", "Prob203_seq", 0.30, 0.20, 0.7),
        ("RTLLM", "Prob204_seq", 0.35, 0.20, 0.8),
        ("VerilogEval-Spec-to-RTL", "Prob301_comb", 0.20, 0.20, 0.0),
        ("VerilogEval-Spec-to-RTL", "Prob302_comb", 0.25, 0.20, 0.0),
        ("VerilogEval-Spec-to-RTL", "Prob303_comb", 0.30, 0.20, 0.0),
        ("VerilogEval-Spec-to-RTL", "Prob304_comb", 0.35, 0.20, 0.0),
        ("VerilogEval-Spec-to-RTL", "Prob401_seq", 0.18, 0.20, 0.4),
        ("VerilogEval-Spec-to-RTL", "Prob402_seq", 0.22, 0.20, 0.5),
        ("VerilogEval-Spec-to-RTL", "Prob403_seq", 0.28, 0.20, 0.6),
        ("VerilogEval-Spec-to-RTL", "Prob404_seq", 0.33, 0.20, 0.7),
    ]
    for benchmark, problem, functionality, synthesis, eff_clk_period in selected_data:
        _write_summary(
            one_shot_root / "stub-model" / benchmark / problem / f"{problem}_summary.json",
            benchmark=benchmark,
            problem=problem,
            functionality=functionality,
            synthesis=synthesis,
        )
        _write_ppa(bench_root / benchmark / f"{problem}_ppa.txt", eff_clk_period)

    output_config = tmp_path / "hard_iteration_subset.yaml"
    output_csv = tmp_path / "hard_iteration_subset.csv"
    result = subprocess.run(
        [
            str(Path(os.sys.executable)),
            str(script_path),
            "--one-shot-root",
            str(one_shot_root),
            "--benchmark-root",
            str(bench_root),
            "--rtllm-csv",
            str(rtllm_csv),
            "--verilogeval-csv",
            str(verilogeval_csv),
            "--output-config",
            str(output_config),
            "--output-csv",
            str(output_csv),
        ],
        cwd=repo_root,
        check=False,
        capture_output=True,
        text=True,
    )

    assert result.returncode == 0, result.stderr
    config = yaml.safe_load(output_config.read_text(encoding="utf-8"))
    assert config["selection"]["subset_size"] == 16
    assert config["matrix_defaults"]["qd_num_cells"] == 16
    assert config["matrix_defaults"]["qd_cvt_warmup_successes"] == 4
    assert config["matrix_defaults"]["qd_fill_target_fraction"] == 0.25
    assert config["matrix_defaults"]["qd_cell_reservoir"] == 2
    assert sorted(config["benchmarks"]["RTLLM"]["problems"]) == [
        "Prob101_comb",
        "Prob102_comb",
        "Prob103_comb",
        "Prob104_comb",
        "Prob201_seq",
        "Prob202_seq",
        "Prob203_seq",
        "Prob204_seq",
    ]
    assert sorted(config["benchmarks"]["VerilogEval-Spec-to-RTL"]["problems"]) == [
        "Prob301_comb",
        "Prob302_comb",
        "Prob303_comb",
        "Prob304_comb",
        "Prob401_seq",
        "Prob402_seq",
        "Prob403_seq",
        "Prob404_seq",
    ]
    selected = {(row["benchmark"], row["problem"]): row for row in config["selected_problems"]}
    assert selected[("RTLLM", "Prob104_comb")]["selection_stage"] == "fallback"
    assert selected[("RTLLM", "Prob101_comb")]["circuit_type"] == "combinational"
    assert selected[("RTLLM", "Prob201_seq")]["circuit_type"] == "sequential"

    rows = list(csv.DictReader(output_csv.open("r", encoding="utf-8")))
    assert len(rows) == 16


def test_build_hard_iteration_subset_accepts_accumulated_success_rates(tmp_path):
    repo_root = Path(__file__).resolve().parents[2]
    script_path = repo_root / "scripts" / "build_hard_iteration_subset.py"

    one_shot_root = tmp_path / "one_shot"
    bench_root = tmp_path / "bench"
    rtllm_csv = tmp_path / "RTLLM.csv"
    verilogeval_csv = tmp_path / "VerilogEval-Spec-to-RTL.csv"

    _write_csv(
        rtllm_csv,
        [
            ("Prob101_comb", 1000),
            ("Prob102_comb", 900),
            ("Prob103_comb", 800),
            ("Prob104_comb", 700),
            ("Prob201_seq", 1100),
            ("Prob202_seq", 1000),
            ("Prob203_seq", 900),
            ("Prob204_seq", 800),
        ],
    )
    _write_csv(
        verilogeval_csv,
        [
            ("Prob301_comb", 1200),
            ("Prob302_comb", 1100),
            ("Prob303_comb", 1000),
            ("Prob304_comb", 900),
            ("Prob401_seq", 1300),
            ("Prob402_seq", 1200),
            ("Prob403_seq", 1100),
            ("Prob404_seq", 1000),
        ],
    )

    selected_data = [
        ("RTLLM", "Prob101_comb", 0.35, 0.20, 0.0),
        ("RTLLM", "Prob102_comb", 0.40, 0.20, 0.0),
        ("RTLLM", "Prob103_comb", 0.45, 0.20, 0.0),
        ("RTLLM", "Prob104_comb", 0.72, 0.20, 0.0),
        ("RTLLM", "Prob201_seq", 0.20, 0.20, 0.5),
        ("RTLLM", "Prob202_seq", 0.25, 0.20, 0.6),
        ("RTLLM", "Prob203_seq", 0.30, 0.20, 0.7),
        ("RTLLM", "Prob204_seq", 0.35, 0.20, 0.8),
        ("VerilogEval-Spec-to-RTL", "Prob301_comb", 0.20, 0.20, 0.0),
        ("VerilogEval-Spec-to-RTL", "Prob302_comb", 0.25, 0.20, 0.0),
        ("VerilogEval-Spec-to-RTL", "Prob303_comb", 0.30, 0.20, 0.0),
        ("VerilogEval-Spec-to-RTL", "Prob304_comb", 0.35, 0.20, 0.0),
        ("VerilogEval-Spec-to-RTL", "Prob401_seq", 0.18, 0.20, 0.4),
        ("VerilogEval-Spec-to-RTL", "Prob402_seq", 0.22, 0.20, 0.5),
        ("VerilogEval-Spec-to-RTL", "Prob403_seq", 0.28, 0.20, 0.6),
        ("VerilogEval-Spec-to-RTL", "Prob404_seq", 0.33, 0.20, 0.7),
    ]
    for benchmark, problem, functionality, synthesis, eff_clk_period in selected_data:
        _write_summary(
            one_shot_root / "stub-model" / benchmark / problem / f"{problem}_summary.json",
            benchmark=benchmark,
            problem=problem,
            functionality=functionality,
            synthesis=synthesis,
            summary_container="accumulated_success_rates",
        )
        _write_ppa(bench_root / benchmark / f"{problem}_ppa.txt", eff_clk_period)

    output_config = tmp_path / "hard_iteration_subset.yaml"
    output_csv = tmp_path / "hard_iteration_subset.csv"
    result = subprocess.run(
        [
            str(Path(os.sys.executable)),
            str(script_path),
            "--one-shot-root",
            str(one_shot_root),
            "--benchmark-root",
            str(bench_root),
            "--rtllm-csv",
            str(rtllm_csv),
            "--verilogeval-csv",
            str(verilogeval_csv),
            "--output-config",
            str(output_config),
            "--output-csv",
            str(output_csv),
        ],
        cwd=repo_root,
        check=False,
        capture_output=True,
        text=True,
    )

    assert result.returncode == 0, result.stderr
    config = yaml.safe_load(output_config.read_text(encoding="utf-8"))
    assert config["selection"]["subset_size"] == 16
