from pathlib import Path
from types import SimpleNamespace

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
    backend = RevolutionBackend(
        context=_context(tmp_path),
        services=_services(tmp_path),
        config=RevolutionBackendConfig(),
        base_save_path=str(tmp_path / "exp"),
    )
    backend.initialize()
    assert isinstance(backend.engine, _FakeEngine)
    assert captured["kwargs"]["benchmark_name"] == "Bench"


def test_revolution_backend_uses_qd_engine_for_revolution_qd(monkeypatch, tmp_path):
    captured = {}

    class _FakeQDEngine:
        def __init__(self, **kwargs):
            captured["kwargs"] = kwargs

    monkeypatch.setattr("revolution.backends.revolution_backend.QDEngine", _FakeQDEngine)
    backend = RevolutionBackend(
        context=_context(tmp_path),
        services=_services(tmp_path),
        config=RevolutionBackendConfig(search_mode="revolution_qd", qd_grid_axes=("g_A", "g_T")),
        base_save_path=str(tmp_path / "exp"),
    )
    backend.initialize()
    assert isinstance(backend.engine, _FakeQDEngine)
    assert captured["kwargs"]["qd_grid_axes"] == ("g_A", "g_T")
