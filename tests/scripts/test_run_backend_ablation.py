import sys
from pathlib import Path
from unittest import mock

import yaml
import pytest

PROJECT_ROOT = Path(__file__).resolve().parents[2]
if str(PROJECT_ROOT) not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT))

from scripts.run_backend_ablation import (  # noqa: E402
    _derive_eoh_schedule,
    _resolve_candidate_budget,
    _safe_workers,
    _validate_fairness,
    main as run_backend_ablation_main,
)


@pytest.fixture
def mocker(request):
    """Local fallback for environments without pytest-mock."""

    patchers = []

    class _Mocker:
        def patch(self, target: str, *args, **kwargs):
            patcher = mock.patch(target, *args, **kwargs)
            patchers.append(patcher)
            return patcher.start()

    instance = _Mocker()
    request.addfinalizer(lambda: [patcher.stop() for patcher in reversed(patchers)])
    return instance


def test_safe_workers_bounds():
    assert _safe_workers(0) >= 1
    assert _safe_workers(1) == 1
    assert _safe_workers(10_000) >= 1


def test_resolve_candidate_budget_by_axis():
    assert (
        _resolve_candidate_budget(
            primary_budget_axis="candidate_evaluations",
            max_evaluations=12,
            max_llm_calls_per_problem=None,
        )
        == 12
    )
    assert (
        _resolve_candidate_budget(
            primary_budget_axis="llm_calls",
            max_evaluations=12,
            max_llm_calls_per_problem=8,
        )
        == 8
    )
    assert (
        _resolve_candidate_budget(
            primary_budget_axis="dual_gate",
            max_evaluations=12,
            max_llm_calls_per_problem=8,
        )
        == 8
    )


def test_derive_eoh_schedule_respects_formula():
    pop, generations, estimated = _derive_eoh_schedule(
        target_candidates=42,
        preferred_population_size=4,
        operators_count=5,
    )
    assert pop >= 1
    assert generations >= 0
    assert estimated == 2 * pop + generations * pop * 5
    assert estimated >= 42


def test_validate_fairness_accepts_matching_commands():
    rev = [
        "python",
        "scripts/run_backend.py",
        "--backend",
        "revolution",
        "--benchmarks",
        "RTLLM",
        "VerilogEval-Spec-to-RTL",
        "--api_backend",
        "vllm",
        "--vllm_host",
        "vllm",
        "--vllm_port",
        "8888",
        "--model_name",
        "m",
        "--num_workers",
        "2",
        "--temperature",
        "0.7",
        "--top_p",
        "0.95",
        "--max_tokens",
        "512",
        "--seed",
        "42",
        "--evaluation_mode",
        "strict_ablation",
        "--primary_budget_axis",
        "candidate_evaluations",
        "--population_size",
        "3",
        "--num_generations",
        "0",
    ]
    fs = [
        "python",
        "scripts/run_backend.py",
        "--backend",
        "funsearch",
        "--benchmarks",
        "RTLLM",
        "VerilogEval-Spec-to-RTL",
        "--api_backend",
        "vllm",
        "--vllm_host",
        "vllm",
        "--vllm_port",
        "8888",
        "--model_name",
        "m",
        "--num_workers",
        "2",
        "--temperature",
        "0.7",
        "--top_p",
        "0.95",
        "--max_tokens",
        "512",
        "--seed",
        "42",
        "--evaluation_mode",
        "strict_ablation",
        "--primary_budget_axis",
        "candidate_evaluations",
        "--fs_max_evaluations",
        "3",
    ]
    _validate_fairness(
        revolution_cmd=rev,
        funsearch_cmd=fs,
        eoh_cmd=None,
        primary_budget_axis="candidate_evaluations",
        primary_budget_candidates=3,
        max_llm_calls_per_problem=None,
    )


def test_validate_fairness_rejects_non_strict_mode():
    rev = [
        "python",
        "scripts/run_backend.py",
        "--backend",
        "revolution",
        "--benchmarks",
        "RTLLM",
        "--api_backend",
        "vllm",
        "--vllm_host",
        "vllm",
        "--vllm_port",
        "8888",
        "--model_name",
        "m",
        "--num_workers",
        "2",
        "--temperature",
        "0.7",
        "--top_p",
        "0.95",
        "--max_tokens",
        "512",
        "--seed",
        "42",
        "--evaluation_mode",
        "search_accelerated",
        "--primary_budget_axis",
        "candidate_evaluations",
        "--population_size",
        "1",
        "--num_generations",
        "0",
    ]
    fs = [
        "python",
        "scripts/run_backend.py",
        "--backend",
        "funsearch",
        "--benchmarks",
        "RTLLM",
        "--api_backend",
        "vllm",
        "--vllm_host",
        "vllm",
        "--vllm_port",
        "8888",
        "--model_name",
        "m",
        "--num_workers",
        "2",
        "--temperature",
        "0.7",
        "--top_p",
        "0.95",
        "--max_tokens",
        "512",
        "--seed",
        "42",
        "--evaluation_mode",
        "search_accelerated",
        "--primary_budget_axis",
        "candidate_evaluations",
        "--fs_max_evaluations",
        "1",
    ]
    with pytest.raises(ValueError, match="strict_ablation"):
        _validate_fairness(
            revolution_cmd=rev,
            funsearch_cmd=fs,
            eoh_cmd=None,
            primary_budget_axis="candidate_evaluations",
            primary_budget_candidates=1,
            max_llm_calls_per_problem=None,
        )


def test_validate_fairness_rejects_missing_fs_llm_cap_for_dual_gate():
    rev = [
        "python",
        "scripts/run_backend.py",
        "--backend",
        "revolution",
        "--benchmarks",
        "RTLLM",
        "--api_backend",
        "vllm",
        "--vllm_host",
        "vllm",
        "--vllm_port",
        "8888",
        "--model_name",
        "m",
        "--num_workers",
        "2",
        "--temperature",
        "0.7",
        "--top_p",
        "0.95",
        "--max_tokens",
        "512",
        "--seed",
        "42",
        "--evaluation_mode",
        "strict_ablation",
        "--primary_budget_axis",
        "dual_gate",
        "--population_size",
        "3",
        "--num_generations",
        "0",
    ]
    fs = [
        "python",
        "scripts/run_backend.py",
        "--backend",
        "funsearch",
        "--benchmarks",
        "RTLLM",
        "--api_backend",
        "vllm",
        "--vllm_host",
        "vllm",
        "--vllm_port",
        "8888",
        "--model_name",
        "m",
        "--num_workers",
        "2",
        "--temperature",
        "0.7",
        "--top_p",
        "0.95",
        "--max_tokens",
        "512",
        "--seed",
        "42",
        "--evaluation_mode",
        "strict_ablation",
        "--primary_budget_axis",
        "dual_gate",
        "--fs_max_evaluations",
        "3",
    ]
    with pytest.raises(ValueError, match="fs_max_llm_calls"):
        _validate_fairness(
            revolution_cmd=rev,
            funsearch_cmd=fs,
            eoh_cmd=None,
            primary_budget_axis="dual_gate",
            primary_budget_candidates=3,
            max_llm_calls_per_problem=3,
        )


def test_validate_fairness_accepts_eoh_command():
    rev = [
        "python",
        "scripts/run_backend.py",
        "--backend",
        "revolution",
        "--benchmarks",
        "RTLLM",
        "--api_backend",
        "vllm",
        "--vllm_host",
        "vllm",
        "--vllm_port",
        "8888",
        "--model_name",
        "m",
        "--num_workers",
        "2",
        "--temperature",
        "0.7",
        "--top_p",
        "0.95",
        "--max_tokens",
        "512",
        "--seed",
        "42",
        "--evaluation_mode",
        "strict_ablation",
        "--primary_budget_axis",
        "candidate_evaluations",
        "--population_size",
        "3",
        "--num_generations",
        "0",
    ]
    fs = [
        "python",
        "scripts/run_backend.py",
        "--backend",
        "funsearch",
        "--benchmarks",
        "RTLLM",
        "--api_backend",
        "vllm",
        "--vllm_host",
        "vllm",
        "--vllm_port",
        "8888",
        "--model_name",
        "m",
        "--num_workers",
        "2",
        "--temperature",
        "0.7",
        "--top_p",
        "0.95",
        "--max_tokens",
        "512",
        "--seed",
        "42",
        "--evaluation_mode",
        "strict_ablation",
        "--primary_budget_axis",
        "candidate_evaluations",
        "--fs_max_evaluations",
        "3",
    ]
    eoh = [
        "python",
        "scripts/run_backend.py",
        "--backend",
        "eoh",
        "--benchmarks",
        "RTLLM",
        "--api_backend",
        "vllm",
        "--vllm_host",
        "vllm",
        "--vllm_port",
        "8888",
        "--model_name",
        "m",
        "--num_workers",
        "2",
        "--temperature",
        "0.7",
        "--top_p",
        "0.95",
        "--max_tokens",
        "512",
        "--seed",
        "42",
        "--evaluation_mode",
        "strict_ablation",
        "--primary_budget_axis",
        "candidate_evaluations",
        "--eoh_population_size",
        "1",
        "--eoh_num_generations",
        "1",
        "--eoh_operators",
        "e1",
        "--eoh_max_evaluations",
        "3",
    ]
    _validate_fairness(
        revolution_cmd=rev,
        funsearch_cmd=fs,
        eoh_cmd=eoh,
        primary_budget_axis="candidate_evaluations",
        primary_budget_candidates=3,
        max_llm_calls_per_problem=None,
    )


def test_ablation_main_writes_top_level_config_and_meta(tmp_path):
    save_root = tmp_path / "ablation_run"
    rc = run_backend_ablation_main(
        [
            "--benchmarks",
            "RTLLM",
            "--save_root",
            str(save_root),
            "--seeds",
            "42",
            "--max_evaluations",
            "1",
            "--dry_run",
            "--no-run_report",
        ]
    )
    assert rc == 0

    top_configs = sorted(save_root.glob("*_ablation_config.yaml"))
    assert top_configs
    config_path = top_configs[-1]
    payload = yaml.safe_load(config_path.read_text(encoding="utf-8"))
    assert payload["save_root"] == str(save_root)
    assert payload["benchmarks"] == ["RTLLM"]
    assert payload["seeds"] == [42]

    meta_path = config_path.with_name(f"{config_path.stem}_meta.yaml")
    assert meta_path.exists()
    meta_payload = yaml.safe_load(meta_path.read_text(encoding="utf-8"))
    assert meta_payload["command_line_arguments"]


def test_ablation_generated_config_roundtrip_and_edit(tmp_path):
    save_root_a = tmp_path / "ablation_a"
    rc = run_backend_ablation_main(
        [
            "--benchmarks",
            "RTLLM",
            "--save_root",
            str(save_root_a),
            "--seeds",
            "42",
            "--max_evaluations",
            "1",
            "--dry_run",
            "--no-run_report",
        ]
    )
    assert rc == 0
    generated = sorted(save_root_a.glob("*_ablation_config.yaml"))
    assert generated
    generated_config = generated[-1]

    # Rerun with generated config as input.
    rc_generated = run_backend_ablation_main(
        ["--config", str(generated_config), "--dry_run", "--no-run_report"]
    )
    assert rc_generated == 0

    # Modify config and rerun with updated settings.
    modified = tmp_path / "modified_ablation_config.yaml"
    modified_payload = yaml.safe_load(generated_config.read_text(encoding="utf-8"))
    modified_payload["save_root"] = str(tmp_path / "ablation_b")
    modified_payload["seeds"] = [43]
    modified_payload["max_evaluations"] = 2
    modified.write_text(
        yaml.safe_dump(modified_payload, sort_keys=True),
        encoding="utf-8",
    )

    rc_modified = run_backend_ablation_main(
        ["--config", str(modified), "--dry_run", "--no-run_report"]
    )
    assert rc_modified == 0
    save_root_b = tmp_path / "ablation_b"
    assert sorted(save_root_b.glob("*_ablation_config.yaml"))
