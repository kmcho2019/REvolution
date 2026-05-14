import csv
import json
from pathlib import Path

from scripts.validate_adaptive_rebinning_run import main as validate_main


PROBLEM = "Prob004_adder_8bit"
BENCHMARK = "RTLLM"


def _subset_config(root: Path) -> Path:
    path = root / "subset.yaml"
    path.write_text(
        "selected_problems:\n"
        f"  - benchmark: {BENCHMARK}\n"
        f"    problem: {PROBLEM}\n",
        encoding="utf-8",
    )
    return path


def _problem_root(run_root: Path, mode: str) -> Path:
    root = run_root / mode / BENCHMARK / PROBLEM
    root.mkdir(parents=True)
    return root


def _write_generation_log(root: Path, count: int) -> None:
    details = [
        {
            "id": f"cand-{index}",
            "score": 0.2 + index * 0.1,
            "ppa_metrics": {"area": 90.0, "power": 0.9, "eff_clk_period": 0.8},
        }
        for index in range(count)
    ]
    (root / "generation_log.jsonl").write_text(
        json.dumps({"generation": 0, "population_ppa_details": details}) + "\n",
        encoding="utf-8",
    )


def _write_problem_summary(root: Path, valid_count: int) -> None:
    _write_generation_log(root, valid_count)
    payload = {
        "problem_name": PROBLEM,
        "benchmark_name": BENCHMARK,
        "accumulated_success_rates": {
            "functionality": 0.5,
            "synthesis_ppa": 0.5,
        },
        "ref_ppa_metric": {"area": 100.0, "power": 1.0, "eff_clk_period": 1.0},
    }
    (root / f"{PROBLEM}_summary.json").write_text(
        json.dumps(payload, indent=2),
        encoding="utf-8",
    )


def _write_archive(
    root: Path,
    *,
    mode_kind: str,
    occupied: int,
    total_members: int,
    coverage: float,
    qd_score: float,
    effective_shape: list[int],
    collapsed_axes: list[str],
    history: list[dict],
    initialization_mode: str | None = None,
) -> None:
    summary = {
        "archive_type": "grid_quantile",
        "cell_mode": "pareto_front",
        "descriptor_profile": "journal_logic_ff_width_3d",
        "objective_names": ["g_P", "g_A", "g_T"],
        "initialized": True,
        "occupied_cells": occupied,
        "total_archive_members": total_members,
        "archive_member_count": total_members,
        "coverage": coverage,
        "qd_score": qd_score,
        "best_quality": qd_score,
        "effective_shape": effective_shape,
        "collapsed_axes": collapsed_axes,
        "qd_rebinning_kind": mode_kind,
    }
    (root / "archive_summary.json").write_text(
        json.dumps(summary, indent=2),
        encoding="utf-8",
    )
    space = {
        "archive_type": "grid_quantile",
        "initialized": True,
        "num_cells": 1,
        "effective_shape": effective_shape,
        "collapsed_axes": collapsed_axes,
    }
    if initialization_mode is not None:
        space["initialization_mode"] = initialization_mode
    (root / "archive_space.json").write_text(json.dumps(space), encoding="utf-8")
    (root / "descriptor_health.json").write_text("{}", encoding="utf-8")
    (root / "descriptor_health_report.md").write_text("# Descriptor Health\n", encoding="utf-8")
    with (root / "archive_cells.csv").open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(
            handle,
            fieldnames=[
                "cell_id",
                "candidate_id",
                "quality_score",
                "g_P",
                "g_A",
                "g_T",
                "descriptors_json",
            ],
        )
        writer.writeheader()
        for index in range(total_members):
            writer.writerow(
                {
                    "cell_id": f"{index}",
                    "candidate_id": f"cand-{index}",
                    "quality_score": 0.5 + index,
                    "g_P": 0.1,
                    "g_A": 0.1,
                    "g_T": 0.1,
                    "descriptors_json": json.dumps([float(index + 1), 0.0, 1.0]),
                }
            )
    (root / "archive_history.jsonl").write_text(
        "".join(json.dumps(event) + "\n" for event in history),
        encoding="utf-8",
    )


def test_validate_adaptive_rebinning_run_writes_artifacts(tmp_path):
    run_root = tmp_path / "run"
    config = _subset_config(tmp_path)
    classic_root = _problem_root(run_root, "classic")
    off_root = _problem_root(run_root, "off")
    on_root = _problem_root(run_root, "on")
    for root, count in ((classic_root, 1), (off_root, 1), (on_root, 2)):
        _write_problem_summary(root, count)
    _write_archive(
        off_root,
        mode_kind="disabled",
        occupied=1,
        total_members=1,
        coverage=0.25,
        qd_score=1.0,
        effective_shape=[2, 1, 2],
        collapsed_axes=["ff_depth"],
        history=[{"generation": 0, "archive_type": "grid_quantile"}],
    )
    check = {
        "event_kind": "rebin_check",
        "generation": 1,
        "corrected_p_threshold": 0.0167,
        "axis_results": [{"axis": "logic_depth", "ks_p_value": 0.001}],
        "trigger_axes": ["logic_depth"],
    }
    rebin = {
        **check,
        "event_kind": "rebin",
        "old_geometry": {"effective_shape": [2, 1, 2]},
        "new_geometry": {"effective_shape": [4, 1, 2]},
        "retained_member_count": 1,
        "replay_member_count": 2,
        "replay_attempt_count": 2,
        "final_active_member_count": 2,
        "displaced_replay_member_count": 1,
        "reactivated_displaced_member_count": 1,
        "cooldown_remaining": 3,
    }
    _write_archive(
        on_root,
        mode_kind="ks_triggered",
        occupied=2,
        total_members=2,
        coverage=0.5,
        qd_score=2.0,
        effective_shape=[4, 1, 2],
        collapsed_axes=["ff_depth"],
        history=[check, rebin],
    )

    result = validate_main(
        [
            "--run-root",
            str(run_root),
            "--subset-config",
            str(config),
            "--classic-mode",
            "classic",
            "--off-mode",
            "off",
            "--on-mode",
            "on",
        ]
    )

    assert result == 0
    payload = json.loads((run_root / "adaptive_rebinning_validation.json").read_text(encoding="utf-8"))
    localized = json.loads(
        (run_root / "adaptive_rebinning_localized_trigger_evidence.json").read_text(
            encoding="utf-8"
        )
    )
    assert payload["valid"] is True
    assert payload["adaptive_problem_audits"][0]["rebin_count"] == 1
    assert localized["status"] == "pass"
    assert (run_root / "adaptive_rebinning_validation.md").is_file()
    assert (run_root / "adaptive_rebinning_localized_trigger_evidence.md").is_file()


def test_validate_adaptive_rebinning_accepts_explained_skip(tmp_path):
    run_root = tmp_path / "run"
    config = _subset_config(tmp_path)
    classic_root = _problem_root(run_root, "classic")
    off_root = _problem_root(run_root, "off")
    on_root = _problem_root(run_root, "on")
    for root, count in ((classic_root, 1), (off_root, 1), (on_root, 2)):
        _write_problem_summary(root, count)
    _write_archive(
        off_root,
        mode_kind="disabled",
        occupied=1,
        total_members=1,
        coverage=0.25,
        qd_score=1.0,
        effective_shape=[1, 1, 1],
        collapsed_axes=["logic_depth", "ff_depth", "comb_width_log"],
        history=[{"generation": 0, "archive_type": "grid_quantile"}],
    )
    _write_archive(
        on_root,
        mode_kind="ks_triggered",
        occupied=2,
        total_members=2,
        coverage=0.5,
        qd_score=2.0,
        effective_shape=[2, 1, 1],
        collapsed_axes=["ff_depth", "comb_width_log"],
        history=[
            {
                "event_kind": "rebin_check",
                "generation": 1,
                "check_status": "skipped_min_archive_members",
                "retained_member_count": 2,
                "min_archive_members": 20,
                "axis_results": [],
                "trigger_axes": [],
            }
        ],
    )

    result = validate_main(
        [
            "--run-root",
            str(run_root),
            "--subset-config",
            str(config),
            "--classic-mode",
            "classic",
            "--off-mode",
            "off",
            "--on-mode",
            "on",
        ]
    )

    assert result == 0
    localized = json.loads(
        (run_root / "adaptive_rebinning_localized_trigger_evidence.json").read_text(
            encoding="utf-8"
        )
    )
    assert localized["status"] == "pass"


def test_validate_adaptive_rebinning_accepts_finalization_fallback(tmp_path):
    run_root = tmp_path / "run"
    config = _subset_config(tmp_path)
    classic_root = _problem_root(run_root, "classic")
    off_root = _problem_root(run_root, "off")
    on_root = _problem_root(run_root, "on")
    for root, count in ((classic_root, 1), (off_root, 1), (on_root, 2)):
        _write_problem_summary(root, count)
    _write_archive(
        off_root,
        mode_kind="disabled",
        occupied=1,
        total_members=1,
        coverage=0.25,
        qd_score=1.0,
        effective_shape=[1, 1, 1],
        collapsed_axes=["logic_depth", "ff_depth", "comb_width_log"],
        history=[{"generation": 0, "archive_type": "grid_quantile"}],
    )
    _write_archive(
        on_root,
        mode_kind="ks_triggered",
        occupied=2,
        total_members=2,
        coverage=0.5,
        qd_score=2.0,
        effective_shape=[1, 1, 1],
        collapsed_axes=["logic_depth", "ff_depth", "comb_width_log"],
        history=[],
        initialization_mode="run_finalization_fallback",
    )

    result = validate_main(
        [
            "--run-root",
            str(run_root),
            "--subset-config",
            str(config),
            "--classic-mode",
            "classic",
            "--off-mode",
            "off",
            "--on-mode",
            "on",
        ]
    )

    assert result == 0
    payload = json.loads((run_root / "adaptive_rebinning_validation.json").read_text(encoding="utf-8"))
    localized = json.loads(
        (run_root / "adaptive_rebinning_localized_trigger_evidence.json").read_text(
            encoding="utf-8"
        )
    )
    assert payload["valid"] is True
    assert localized["status"] == "pass"
