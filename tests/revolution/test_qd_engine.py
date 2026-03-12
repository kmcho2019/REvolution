from pathlib import Path

import pytest

from revolution.algorithm import Heuristic
from revolution.qd.engine import QDEngine
from revolution.runtime.problem_spec import ProblemSpec


class _DummyLLM:
    model_name = "stub-model"


class _DummySynth:
    clk_period = 1.0


class _DummyEval:
    pass


def _engine(
    tmp_path: Path,
    monkeypatch: pytest.MonkeyPatch,
    *,
    problem_spec: ProblemSpec | None = None,
) -> QDEngine:
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
        problem_spec=problem_spec,
    )


def test_qd_engine_phase_mode_defaults_follow_refine_diff_only(tmp_path, monkeypatch):
    engine = _engine(tmp_path, monkeypatch)
    engine.generation_mode = "diff"
    assert engine._phase_mode("fail") == "whole"
    assert engine._phase_mode("seed") == "whole"
    assert engine._phase_mode("refine") == "diff"


def test_qd_engine_phase_mode_uses_problem_spec_defaults(tmp_path, monkeypatch):
    problem_spec = ProblemSpec(
        benchmark_name="RealBench",
        problem_name="Prob",
        prompt_text="desc",
        top_module="TopModule",
        benchmark_root=tmp_path,
        phase_generation_defaults={
            "fail": "whole",
            "seed": "whole",
            "backfill": "diff",
            "refine": "diff",
            "crossover": "whole",
        },
    )
    engine = _engine(tmp_path, monkeypatch, problem_spec=problem_spec)
    assert engine._phase_mode("backfill") == "diff"
    assert engine._phase_mode("refine") == "diff"


def test_qd_engine_explicit_phase_override_beats_problem_spec_default(tmp_path, monkeypatch):
    problem_spec = ProblemSpec(
        benchmark_name="RealBench",
        problem_name="Prob",
        prompt_text="desc",
        top_module="TopModule",
        benchmark_root=tmp_path,
        phase_generation_defaults={
            "fail": "whole",
            "seed": "whole",
            "backfill": "diff",
            "refine": "diff",
            "crossover": "whole",
        },
    )
    engine = _engine(
        tmp_path,
        monkeypatch,
        problem_spec=problem_spec,
    )
    engine.qd_backfill_generation_mode = "whole"
    assert engine._phase_mode("backfill") == "whole"


def test_qd_engine_coerces_seed_diff_to_whole_even_from_problem_spec(tmp_path, monkeypatch):
    problem_spec = ProblemSpec(
        benchmark_name="Bench",
        problem_name="Prob",
        prompt_text="desc",
        top_module="TopModule",
        benchmark_root=tmp_path,
        phase_generation_defaults={
            "seed": "diff",
        },
    )
    engine = _engine(tmp_path, monkeypatch, problem_spec=problem_spec)
    assert engine._phase_mode("seed") == "whole"


def test_qd_engine_rebuilds_archive_from_success_pool(tmp_path, monkeypatch):
    engine = _engine(tmp_path, monkeypatch)
    cand = Heuristic("t", "module m; endmodule", "", score=0.5, generation=0, status="success")
    cand.ppa_success = True
    cand.ppa_metrics = {"power": 0.9, "area": 90.0, "eff_clk_period": 0.8}
    engine.success_pool = [cand]

    engine._rebuild_archive_from_success_pool()

    assert engine.success_archive.occupied_count() == 1
    assert engine.success_pool[0] is cand


def test_qd_engine_success_view_includes_reservoir_candidates(tmp_path, monkeypatch):
    engine = _engine(tmp_path, monkeypatch)
    elite = Heuristic("elite", "module m; endmodule", "", score=0.6, generation=0, status="success")
    elite.ppa_success = True
    elite.ppa_metrics = {"power": 0.9, "area": 90.0, "eff_clk_period": 0.8}
    engine.success_pool = [elite]
    engine._rebuild_archive_from_success_pool()

    near_miss = Heuristic("near", "module m; endmodule", "", score=0.4, generation=1, status="success")
    near_miss.ppa_success = True
    near_miss.ppa_metrics = {"power": 0.92, "area": 90.0, "eff_clk_period": 0.8}

    inserted, replaced = engine._insert_successes([near_miss])

    assert inserted == 0
    assert replaced == 0
    assert elite in engine.success_pool
    assert near_miss in engine.success_pool


def test_qd_engine_replacement_pushes_previous_elite_into_reservoir(tmp_path, monkeypatch):
    engine = _engine(tmp_path, monkeypatch)
    prior = Heuristic("prior", "module m; endmodule", "", score=0.5, generation=0, status="success")
    prior.ppa_success = True
    prior.ppa_metrics = {"power": 0.9, "area": 90.0, "eff_clk_period": 0.8}
    engine.success_pool = [prior]
    engine._rebuild_archive_from_success_pool()

    better = Heuristic("better", "module m; endmodule", "", score=0.8, generation=1, status="success")
    better.ppa_success = True
    better.ppa_metrics = {"power": 0.85, "area": 90.0, "eff_clk_period": 0.8}

    inserted, replaced = engine._insert_successes([better])

    assert inserted == 1
    assert replaced == 1
    assert engine.success_pool[0] is better
    assert prior in engine.success_pool


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
