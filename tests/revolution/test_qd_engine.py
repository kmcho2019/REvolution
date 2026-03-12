from pathlib import Path

import pytest

from revolution.qd.engine import QDEngine
from revolution.algorithm import Heuristic


class _DummyLLM:
    model_name = "stub-model"


class _DummySynth:
    clk_period = 1.0


class _DummyEval:
    pass


def _engine(tmp_path: Path, monkeypatch: pytest.MonkeyPatch) -> QDEngine:
    monkeypatch.setattr(
        "revolution.algorithm.EoHEngine.load_problem_description",
        lambda self: "desc",
    )
    return QDEngine(
        benchmark_name="Bench",
        problem_name="Prob",
        llm_interface=_DummyLLM(),
        verilog_evaluator=_DummyEval(),
        synthesis_evaluator=_DummySynth(),
        population_size=2,
        num_generations=0,
        base_save_path=str(tmp_path / "exp"),
        qd_archive_type="grid",
        qd_num_cells=16,
        qd_grid_axes=("g_A", "g_T"),
    )


def test_qd_engine_phase_mode_defaults_follow_refine_diff_only(tmp_path, monkeypatch):
    engine = _engine(tmp_path, monkeypatch)
    engine.generation_mode = "diff"
    assert engine._phase_mode("fail") == "whole"
    assert engine._phase_mode("seed") == "whole"
    assert engine._phase_mode("refine") == "diff"


def test_qd_engine_rebuilds_archive_from_success_pool(tmp_path, monkeypatch):
    engine = _engine(tmp_path, monkeypatch)
    cand = Heuristic("t", "module m; endmodule", "", score=0.5, generation=0, status="success")
    cand.ppa_success = True
    cand.ppa_metrics = {"power": 0.9, "area": 90.0, "eff_clk_period": 0.8}
    engine.success_pool = [cand]

    engine._rebuild_archive_from_success_pool()

    assert engine.success_archive.occupied_count() == 1
    assert engine.success_pool[0] is cand


def test_qd_engine_rejects_non_grid_archive_runtime(monkeypatch):
    monkeypatch.setattr(
        "revolution.algorithm.EoHEngine.load_problem_description",
        lambda self: "desc",
    )
    with pytest.raises(NotImplementedError, match="grid only"):
        QDEngine(
            benchmark_name="Bench",
            problem_name="Prob",
            llm_interface=_DummyLLM(),
            verilog_evaluator=_DummyEval(),
            synthesis_evaluator=_DummySynth(),
            qd_archive_type="cvt",
        )
