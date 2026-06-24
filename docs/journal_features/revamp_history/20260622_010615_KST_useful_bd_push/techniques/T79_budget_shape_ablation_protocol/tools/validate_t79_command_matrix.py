"""Validate the T79 command matrix without launching live runs."""

from __future__ import annotations

import importlib.util
import sys
from pathlib import Path
from typing import Any

import yaml


WORKSPACE = Path("/workspace")
PACKAGE = Path(__file__).resolve().parents[1]
RUN_BACKEND = WORKSPACE / "scripts/run_backend.py"
SUBSET = PACKAGE / "tables/budget_shape_subset.yaml"
SHAPES = [(12, 3), (8, 5), (6, 7)]


def load_run_backend() -> Any:
    spec = importlib.util.spec_from_file_location("run_backend", RUN_BACKEND)
    assert spec is not None
    assert spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    sys.modules["run_backend"] = module
    spec.loader.exec_module(module)
    return module


def subset_args() -> tuple[list[str], int]:
    payload = yaml.safe_load(SUBSET.read_text())
    rows = payload["selected_problems"]
    benchmarks = sorted({row["benchmark"] for row in rows})
    problems = [row["problem"] for row in rows]
    return ["--benchmarks", *benchmarks, "--problems", *problems], len(rows)


def base_args(population: int, generations: int) -> list[str]:
    selector_args, _ = subset_args()
    return [
        "--backend",
        "revolution",
        *selector_args,
        "--api_backend",
        "vllm",
        "--vllm_host",
        "20.0.0.103",
        "--vllm_port",
        "8000",
        "--vllm_min_model_len",
        "128000",
        "--model_name",
        "openai/gpt-oss-120b",
        "--max_tokens",
        "128000",
        "--diff_max_tokens",
        "128000",
        "--population_size",
        str(population),
        "--num_generations",
        str(generations),
        "--evaluation_mode",
        "strict_ablation",
        "--temperature",
        "1.0",
        "--top_p",
        "1.0",
        "--total_worker_slots",
        "48",
        "--max_active_problems",
        "8",
        "--max_workers_per_problem",
        "6",
        "--no-backend_subdir",
        "--seed",
        "1001",
    ]


def qd_args() -> list[str]:
    return [
        "--search_mode",
        "revolution_qd",
        "--qd_archive_type",
        "grid_quantile",
        "--qd_grid_quantile_warmup_successes",
        "4",
        "--qd_fill_target_fraction",
        "0.25",
        "--qd_improve_backfill_fraction",
        "0.20",
        "--qd_cell_mode",
        "elite_pareto_slot",
        "--qd_max_elites_per_cell",
        "2",
        "--qd_objectives",
        "ppa",
        "--qd_champion_lane_fraction",
        "0.80",
        "--qd_parent_selection",
        "front_slot_lane_nsga2",
        "--qd_front_slot_lane_fraction",
        "0.30",
        "--qd_two_parent_probability",
        "0.0",
        "--qd_two_parent_gate",
        "none",
        "--qd_operator_kind",
        "single_thought_operator",
        "--qd_operator_one_parent_fraction",
        "1.0",
        "--qd_operator_archive_context_size",
        "4",
        "--representation_kind",
        "code_individual",
        "--repair_kind",
        "none",
        "--repair_max_attempts_per_sample",
        "0",
        "--repair_max_attempts_per_thought",
        "0",
        "--repair_evidence",
        "stage_scoped_logs",
        "--qd_descriptor_profile",
        "source_aligned_shape_density_3d",
        "--save_path",
        "exp/useful_bd_push/t79_budget_shape_ablation_DRY/live/qd/seed_1001",
    ]


def classic_args() -> list[str]:
    return [
        "--search_mode",
        "revolution",
        "--classic_operator_kind",
        "eoh_strategies",
        "--representation_kind",
        "code_individual",
        "--save_path",
        "exp/useful_bd_push/t79_budget_shape_ablation_DRY/live/classic/seed_1001",
    ]


def main() -> None:
    run_backend = load_run_backend()
    parser, _ = run_backend._build_parser()
    _, expected_count = subset_args()
    assert expected_count == 8
    for population, generations in SHAPES:
        assert population * (generations + 1) == 48
        for mode_args in (classic_args(), qd_args()):
            args = parser.parse_args(base_args(population, generations) + mode_args)
            tasks = run_backend._discover_tasks(args)
            assert len(tasks) == expected_count
    print("T79 command matrix parses and maps to 8 tasks per arm.")


if __name__ == "__main__":
    main()
