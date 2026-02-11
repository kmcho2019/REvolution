import sys
from pathlib import Path


PROJECT_ROOT = Path(__file__).resolve().parents[2]
if str(PROJECT_ROOT) not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT))

import pytest

from scripts.run_backend_ablation import _safe_workers, _validate_fairness  # noqa: E402


def test_safe_workers_bounds():
    assert _safe_workers(0) >= 1
    assert _safe_workers(1) == 1
    assert _safe_workers(10_000) >= 1


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
        "--population_size",
        "3",
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
        "--fs_max_evaluations",
        "3",
    ]
    _validate_fairness(
        revolution_cmd=rev,
        funsearch_cmd=fs,
        primary_budget_candidates=3,
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
        "--population_size",
        "1",
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
        "--fs_max_evaluations",
        "1",
    ]
    with pytest.raises(ValueError, match="strict_ablation"):
        _validate_fairness(
            revolution_cmd=rev,
            funsearch_cmd=fs,
            primary_budget_candidates=1,
        )
