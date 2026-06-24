from pathlib import Path
from types import SimpleNamespace

import pytest

from revolution.backends.base import BackendExecutionContext
from revolution.backends.revolution_backend import RevolutionBackend, RevolutionBackendConfig
from revolution.runtime.problem_context import ProblemContext
from revolution.runtime.problem_spec import ProblemSpec


def _context(tmp_path: Path) -> BackendExecutionContext:
    bench = tmp_path / "Bench"
    bench.mkdir(parents=True, exist_ok=True)
    problem_context = ProblemContext(
        benchmark_name="Bench",
        problem_name="Prob001",
        benchmark_path=bench,
        prompt_path=bench / "Prob001_prompt.txt",
        problem_description="desc",
        test_sv_path=bench / "Prob001_test.sv",
        ref_sv_path=bench / "Prob001_ref.sv",
        top_module_names_path=bench / "synthesis_top_module_names.json",
    )
    problem_spec = ProblemSpec(
        benchmark_name="Bench",
        problem_name="Prob001",
        prompt_text="desc",
        top_module="TopModule",
        benchmark_root=bench,
    )
    return BackendExecutionContext(
        backend_name="revolution",
        model_name="model",
        benchmark_name="Bench",
        problem_name="Prob001",
        problem_context=problem_context,
        problem_spec=problem_spec,
    )


def _services(tmp_path: Path):
    summary_path = tmp_path / "summary.json"
    return SimpleNamespace(
        llm=object(),
        verilog_evaluator=object(),
        synthesis_evaluator=SimpleNamespace(clk_period=1.0),
        artifact_writer=SimpleNamespace(paths=SimpleNamespace(summary_path=summary_path)),
    )


def test_revolution_backend_uses_classic_engine_by_default(monkeypatch, tmp_path):
    captured = {}

    class _FakeEngine:
        def __init__(self, **kwargs):
            captured["kwargs"] = kwargs

    monkeypatch.setattr("revolution.backends.revolution_backend.EoHEngine", _FakeEngine)
    services = _services(tmp_path)
    services.problem_concurrency = object()
    backend = RevolutionBackend(
        context=_context(tmp_path),
        services=services,
        config=RevolutionBackendConfig(candidate_workers=3),
        base_save_path=str(tmp_path / "exp"),
    )
    backend.initialize()
    assert isinstance(backend.engine, _FakeEngine)
    assert captured["kwargs"]["benchmark_name"] == "Bench"
    assert captured["kwargs"]["problem_spec"].benchmark_name == "Bench"
    assert captured["kwargs"]["candidate_workers"] == 3
    assert captured["kwargs"]["problem_concurrency"] is services.problem_concurrency


def test_revolution_backend_uses_qd_engine_for_revolution_qd(monkeypatch, tmp_path):
    captured = {}

    class _FakeQDEngine:
        def __init__(self, **kwargs):
            captured["kwargs"] = kwargs

    monkeypatch.setattr("revolution.backends.revolution_backend.QDEngine", _FakeQDEngine)
    services = _services(tmp_path)
    services.problem_concurrency = object()
    backend = RevolutionBackend(
        context=_context(tmp_path),
        services=services,
        config=RevolutionBackendConfig(
            search_mode="revolution_qd",
            candidate_workers=4,
            qd_archive_type="cvt",
            qd_grid_axes=("g_A", "g_T"),
            qd_cvt_axes=("seq_ratio", "g_A", "g_T"),
            qd_cvt_warmup_successes=9,
            qd_grid_quantile_warmup_successes=8,
            qd_grid_quantile_adaptive_warmup_successes=4,
            qd_grid_quantile_adaptive_warmup_generation=1,
            qd_adaptive_warmup_champion_lane_fraction=0.6,
            qd_descriptor_profile="hybrid_seq_default",
            qd_cell_mode="pareto_front",
            qd_max_elites_per_cell=5,
            qd_objectives="ppa",
            qd_two_parent_gate="near_front_descriptor",
            qd_front_slot_lane_fraction=0.25,
            representation_kind="thought_only",
            code_samples_per_thought=4,
            repair_kind="bounded_local_repair",
            repair_max_attempts_per_sample=1,
            repair_max_attempts_per_thought=4,
        ),
        base_save_path=str(tmp_path / "exp"),
    )
    backend.initialize()
    assert isinstance(backend.engine, _FakeQDEngine)
    assert captured["kwargs"]["qd_grid_axes"] == ("g_A", "g_T")
    assert captured["kwargs"]["qd_cvt_axes"] == ("seq_ratio", "g_A", "g_T")
    assert captured["kwargs"]["qd_cvt_warmup_successes"] == 9
    assert captured["kwargs"]["qd_grid_quantile_warmup_successes"] == 8
    assert captured["kwargs"]["qd_grid_quantile_adaptive_warmup_successes"] == 4
    assert captured["kwargs"]["qd_grid_quantile_adaptive_warmup_generation"] == 1
    assert captured["kwargs"]["qd_adaptive_warmup_champion_lane_fraction"] == 0.6
    assert captured["kwargs"]["qd_descriptor_profile"] == "hybrid_seq_default"
    assert captured["kwargs"]["qd_cell_reservoir"] == 2
    assert captured["kwargs"]["qd_cell_mode"] == "pareto_front"
    assert captured["kwargs"]["qd_max_elites_per_cell"] == 5
    assert captured["kwargs"]["qd_objectives"] == "ppa"
    assert captured["kwargs"]["qd_two_parent_gate"] == "near_front_descriptor"
    assert captured["kwargs"]["qd_descriptor_file"] is None
    assert captured["kwargs"]["qd_front_slot_lane_fraction"] == pytest.approx(0.25)
    assert captured["kwargs"]["representation_kind"] == "thought_only"
    assert captured["kwargs"]["code_samples_per_thought"] == 4
    assert captured["kwargs"]["repair_kind"] == "bounded_local_repair"
    assert captured["kwargs"]["repair_max_attempts_per_sample"] == 1
    assert captured["kwargs"]["repair_max_attempts_per_thought"] == 4
    assert captured["kwargs"]["problem_spec"].problem_name == "Prob001"
    assert captured["kwargs"]["candidate_workers"] == 4
    assert captured["kwargs"]["problem_concurrency"] is services.problem_concurrency
