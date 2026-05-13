import csv
import json
import random
import time
from pathlib import Path
from types import SimpleNamespace

import pytest

from revolution.algorithm import Heuristic
from revolution.qd.engine import QDEngine
from revolution.qd.archive import GridQuantileArchive
from revolution.qd.types import ArchiveMember
from revolution.runtime.problem_spec import ProblemSpec


class _DummyLLM:
    model_name = "stub-model"

    async def generate_n_responses(self, *args, **kwargs):
        return []

    async def generate_batch_responses(self, *args, **kwargs):
        return []

    async def get_and_reset_usage_stats(self):
        return {}


class _DummySynth:
    clk_period = 1.0


class _DummyEval:
    pass


def _engine(
    tmp_path: Path,
    monkeypatch: pytest.MonkeyPatch,
    *,
    problem_spec: ProblemSpec | None = None,
    **qd_kwargs,
) -> QDEngine:
    monkeypatch.setattr(
        "revolution.algorithm.EoHEngine.load_problem_description",
        lambda self: "desc",
    )
    kwargs = dict(
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
    kwargs.update(qd_kwargs)
    engine = QDEngine(**kwargs)
    engine.ref_ppa_metrics = {"power": 1.0, "area": 100.0, "eff_clk_period": 1.0}
    return engine


def _qd_member(
    candidate_id: str,
    *,
    generation: int,
    descriptors: tuple[float, ...],
    insertion_index: int,
    quality_score: float | None = None,
) -> ArchiveMember:
    candidate = Heuristic(
        candidate_id,
        "module m; endmodule",
        "",
        score=quality_score if quality_score is not None else float(insertion_index),
        generation=generation,
        status="success",
    )
    candidate.id = candidate_id
    candidate.ppa_success = True
    candidate.ppa_metrics = {"power": 0.9, "area": 90.0, "eff_clk_period": 0.8}
    candidate.graph_metrics = {
        "logic_depth": float(descriptors[0]),
        "ff_depth": float(descriptors[1]),
        "comb_width_log": float(descriptors[2]),
    }
    candidate.archive_insertion_index = insertion_index
    return ArchiveMember(
        candidate_id=candidate_id,
        descriptors=descriptors,
        quality_score=float(candidate.quality_score),
        objectives={
            "g_P": float(insertion_index),
            "g_A": float(1000 - insertion_index),
            "g_T": float(insertion_index % 17),
        },
        payload=candidate,
        insertion_index=insertion_index,
    )


def test_qd_engine_phase_mode_defaults_follow_refine_diff_only(tmp_path, monkeypatch):
    engine = _engine(tmp_path, monkeypatch)
    engine.generation_mode = "diff"
    assert engine._phase_mode("fail") == "whole"
    assert engine._phase_mode("seed") == "whole"
    assert engine._phase_mode("refine") == "diff"


def test_qd_engine_rejects_unknown_rebinning_kind(tmp_path, monkeypatch):
    with pytest.raises(ValueError, match="Unsupported qd_rebinning_kind"):
        _engine(tmp_path, monkeypatch, qd_rebinning_kind="manual")


def test_qd_engine_rebin_recent_window_uses_generation(tmp_path, monkeypatch):
    engine = _engine(
        tmp_path,
        monkeypatch,
        qd_rebinning_kind="ks_triggered",
        qd_rebinning_recent_generations=2,
    )
    engine._qd_rebin_recent_members = [
        _qd_member("gen-0", generation=0, descriptors=(0.0, 0.0, 0.0), insertion_index=1),
        _qd_member("gen-1", generation=1, descriptors=(1.0, 0.0, 1.0), insertion_index=2),
        _qd_member("gen-2", generation=2, descriptors=(2.0, 0.0, 2.0), insertion_index=3),
    ]
    engine.current_generation = 2

    recent = engine._recent_rebin_samples()

    assert [member.candidate_id for member in recent] == ["gen-1", "gen-2"]
    assert [member.candidate_id for member in engine._qd_rebin_recent_members] == [
        "gen-1",
        "gen-2",
    ]


def test_qd_engine_default_grid_axes_include_power_for_sequential_problem(tmp_path, monkeypatch):
    problem_spec = ProblemSpec(
        benchmark_name="RTLLM",
        problem_name="Prob",
        prompt_text="desc",
        top_module="TopModule",
        benchmark_root=tmp_path,
        circuit_type="sequential",
    )
    monkeypatch.setattr(
        "revolution.algorithm.EoHEngine.load_problem_description",
        lambda self: "desc",
    )
    engine = QDEngine(
        benchmark_name="RTLLM",
        problem_name="Prob",
        llm_interface=_DummyLLM(),
        verilog_evaluator=_DummyEval(),
        synthesis_evaluator=_DummySynth(),
        base_save_path=str(tmp_path / "exp"),
        qd_archive_type="grid",
        qd_num_cells=16,
        qd_grid_axes=(),
        problem_spec=problem_spec,
    )
    assert engine.qd_grid_axes == ("g_A", "g_P", "g_T")


def test_qd_engine_uses_problem_spec_prompt_text_for_non_file_backed_problem(tmp_path):
    problem_spec = ProblemSpec(
        benchmark_name="cvdp",
        problem_name="cvdp_demo",
        prompt_text="jsonl prompt text",
        top_module="TopModule",
        benchmark_root=tmp_path / "cvdp_root",
    )
    engine = QDEngine(
        benchmark_name="cvdp",
        problem_name="cvdp_demo",
        llm_interface=_DummyLLM(),
        verilog_evaluator=_DummyEval(),
        synthesis_evaluator=_DummySynth(),
        population_size=1,
        num_generations=0,
        base_save_path=str(tmp_path / "exp"),
        qd_archive_type="grid",
        qd_num_cells=4,
        qd_grid_axes=("g_A", "g_T"),
        problem_spec=problem_spec,
    )
    assert engine.problem_description == "jsonl prompt text"
    assert Path(engine.benchmark_path) == problem_spec.benchmark_root.resolve()


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


def test_qd_engine_pareto_mode_uses_crowded_tournament(tmp_path, monkeypatch):
    cfg = tmp_path / "qd.yaml"
    cfg.write_text(
        "grid_axes:\n"
        "  g_A:\n"
        "    bins: 1\n"
        "    lower_bound: 0.0\n"
        "    upper_bound: 1.0\n",
        encoding="utf-8",
    )
    problem_spec = ProblemSpec(
        benchmark_name="Bench",
        problem_name="Prob",
        prompt_text="desc",
        top_module="TopModule",
        benchmark_root=tmp_path,
        circuit_type="combinational",
    )
    engine = _engine(
        tmp_path,
        monkeypatch,
        problem_spec=problem_spec,
        qd_cell_mode="pareto_front",
        qd_max_elites_per_cell=5,
        qd_grid_axes=("g_A",),
        qd_descriptor_file=str(cfg),
    )
    engine.ref_ppa_metrics = {"power": 1.0, "area": 100.0}
    power = Heuristic("power", "module m; endmodule", "", score=0.1, generation=0, status="success")
    power.id = "power"
    power.ppa_success = True
    power.ppa_metrics = {"power": 0.8, "area": 90.0}
    area = Heuristic("area", "module m; endmodule", "", score=0.9, generation=0, status="success")
    area.id = "area"
    area.ppa_success = True
    area.ppa_metrics = {"power": 0.9, "area": 80.0}
    engine.success_pool = [power, area]

    engine._rebuild_archive_from_success_pool()
    snapshot = engine._build_qd_snapshot(inserted=2, replaced=0, budget=None)
    random.seed(3)
    sampled = {
        parent.id
        for _ in range(200)
        for parent in engine._sample_success_parents(1)
    }

    assert {member.candidate_id for _, member in engine.success_archive.members()} == {
        "power",
        "area",
    }
    assert snapshot["total_archive_members"] == 2
    assert snapshot["mean_front_size"] == 2.0
    assert snapshot["max_front_size"] == 2
    assert sampled == {"power"}


def test_qd_engine_initialized_budget_caps_fail_share_by_archive_member_ratio(
    tmp_path,
    monkeypatch,
):
    cfg = tmp_path / "qd.yaml"
    cfg.write_text(
        "grid_axes:\n"
        "  g_A:\n"
        "    bins: 4\n"
        "    lower_bound: 0.0\n"
        "    upper_bound: 1.0\n",
        encoding="utf-8",
    )
    problem_spec = ProblemSpec(
        benchmark_name="Bench",
        problem_name="Prob",
        prompt_text="desc",
        top_module="TopModule",
        benchmark_root=tmp_path,
        circuit_type="combinational",
    )
    engine = _engine(
        tmp_path,
        monkeypatch,
        problem_spec=problem_spec,
        qd_cell_mode="pareto_front",
        qd_max_elites_per_cell=5,
        qd_grid_axes=("g_A",),
        qd_descriptor_file=str(cfg),
        qd_fill_target_fraction=1.0,
    )
    engine.num_offspring_lambda = 10
    engine.ref_ppa_metrics = {"power": 1.0, "area": 100.0}
    power = Heuristic("power", "module m; endmodule", "", score=0.1, generation=0, status="success")
    power.id = "power"
    power.ppa_success = True
    power.ppa_metrics = {"power": 0.8, "area": 90.0}
    area = Heuristic("area", "module m; endmodule", "", score=0.9, generation=0, status="success")
    area.id = "area"
    area.ppa_success = True
    area.ppa_metrics = {"power": 0.9, "area": 80.0}
    engine.success_pool = [power, area]
    engine._rebuild_archive_from_success_pool()
    engine.fail_pool = [
        Heuristic("failed idea", "module f; endmodule", "", status="failed_functionality")
    ]

    budget = engine._split_generation_budget()

    assert engine.success_archive.occupied_count() == 1
    assert len(engine.success_archive.members()) == 2
    assert budget.phase == "fill"
    assert budget.fail_share == pytest.approx(1 / 3)
    assert budget.fail_budget == 3
    assert budget.seed_budget == 2
    assert budget.backfill_budget == 5

    engine.fail_pool.append(
        Heuristic("later failed idea", "module f2; endmodule", "", status="failed_syntax")
    )
    snapshot = engine._build_qd_snapshot(inserted=0, replaced=0, budget=budget)
    assert snapshot["fail_pool_size"] == 2
    assert snapshot["archive_member_count"] == 2
    assert snapshot["coverage_fail_share"] == pytest.approx(0.75)
    assert snapshot["p_fail_cap"] == pytest.approx(1 / 3)
    assert snapshot["effective_fail_share"] == pytest.approx(1 / 3)
    assert snapshot["total_budget"] == 10
    assert snapshot["planned_parent_source_counts"] == {
        "archive": 5,
        "fail_pool": 3,
        "seed": 2,
    }

    engine.logger = SimpleNamespace(log_dir=str(tmp_path / "artifacts"))
    engine._write_qd_artifacts(snapshot)
    summary_payload = json.loads(
        (tmp_path / "artifacts" / "archive_summary.json").read_text(encoding="utf-8")
    )
    metrics_payload = json.loads(
        (tmp_path / "artifacts" / "qd_metrics.json").read_text(encoding="utf-8")
    )
    assert summary_payload["fail_pool_size"] == 2
    assert summary_payload["archive_member_count"] == 2
    assert summary_payload["coverage_fail_share"] == pytest.approx(0.75)
    assert summary_payload["p_fail_cap"] == pytest.approx(1 / 3)
    assert summary_payload["effective_fail_share"] == pytest.approx(1 / 3)
    assert summary_payload["total_budget"] == 10
    assert summary_payload["planned_parent_source_counts"] == {
        "archive": 5,
        "fail_pool": 3,
        "seed": 2,
    }
    assert metrics_payload["latest_snapshot"]["planned_parent_source_counts"] == {
        "archive": 5,
        "fail_pool": 3,
        "seed": 2,
    }


def test_qd_engine_reports_journal_parent_source_counts(tmp_path, monkeypatch):
    engine = _engine(tmp_path, monkeypatch)
    seed = Heuristic(
        "seed",
        "module s; endmodule",
        "",
        strategy="initial",
        origin_pool="success_pool",
    )
    archive = Heuristic(
        "archive",
        "module a; endmodule",
        "",
        parent_ids=["parent"],
        strategy="M-S",
        origin_pool="success_pool",
    )
    fail = Heuristic(
        "fail",
        "module f; endmodule",
        "",
        parent_ids=["failed"],
        strategy="M-F",
        origin_pool="fail_pool",
    )

    assert engine._journal_parent_source_counts([seed, archive, fail]) == {
        "archive": 1,
        "fail_pool": 1,
        "seed": 1,
    }


def test_qd_engine_two_parent_probability_controls_arity(tmp_path, monkeypatch):
    engine = _engine(
        tmp_path,
        monkeypatch,
        qd_cell_mode="pareto_front",
        qd_two_parent_probability=0.0,
    )

    assert engine._success_parent_arity() == 1
    assert engine.qd_success_parent_requests == 1
    assert engine.qd_two_parent_attempts == 0


def test_qd_engine_two_parent_fallback_counts_underfilled_archive(tmp_path, monkeypatch):
    engine = _engine(
        tmp_path,
        monkeypatch,
        qd_cell_mode="pareto_front",
        qd_two_parent_probability=1.0,
    )

    assert engine._success_parent_arity() == 1
    assert engine.qd_two_parent_attempts == 1
    assert engine.qd_two_parent_fallbacks == 1


def test_qd_engine_two_parent_sampling_uses_distinct_cells(tmp_path, monkeypatch):
    cfg = tmp_path / "qd.yaml"
    cfg.write_text(
        "grid_axes:\n"
        "  g_A:\n"
        "    bins: 2\n"
        "    lower_bound: 0.0\n"
        "    upper_bound: 1.0\n",
        encoding="utf-8",
    )
    problem_spec = ProblemSpec(
        benchmark_name="Bench",
        problem_name="Prob",
        prompt_text="desc",
        top_module="TopModule",
        benchmark_root=tmp_path,
        circuit_type="combinational",
    )
    engine = _engine(
        tmp_path,
        monkeypatch,
        problem_spec=problem_spec,
        qd_cell_mode="pareto_front",
        qd_two_parent_probability=1.0,
        qd_grid_axes=("g_A",),
        qd_descriptor_file=str(cfg),
    )
    engine.ref_ppa_metrics = {"power": 1.0, "area": 100.0}
    left = Heuristic("left", "module m; endmodule", "", score=0.1, generation=0, status="success")
    left.id = "left"
    left.ppa_success = True
    left.ppa_metrics = {"power": 0.9, "area": 90.0}
    right = Heuristic("right", "module m; endmodule", "", score=0.9, generation=0, status="success")
    right.id = "right"
    right.ppa_success = True
    right.ppa_metrics = {"power": 0.9, "area": 10.0}
    engine.success_pool = [left, right]
    engine._rebuild_archive_from_success_pool()

    random.seed(7)
    parents = engine._sample_two_success_parents()

    assert {parent.id for parent in parents} == {"left", "right"}
    assert {
        engine._cell_id_for_candidate(parent)
        for parent in parents
    } == {"0", "1"}


def test_qd_engine_rejects_unknown_cell_mode(tmp_path, monkeypatch):
    with pytest.raises(ValueError, match="qd_cell_mode"):
        _engine(tmp_path, monkeypatch, qd_cell_mode="mystery")


def test_qd_engine_builds_cvt_archive_runtime(monkeypatch, tmp_path):
    monkeypatch.setattr(
        "revolution.algorithm.EoHEngine.load_problem_description",
        lambda self: "desc",
    )
    engine = QDEngine(
        benchmark_name="Bench",
        problem_name="Prob",
        llm_interface=_DummyLLM(),
        verilog_evaluator=_DummyEval(),
        synthesis_evaluator=_DummySynth(),
        base_save_path=str(tmp_path / "exp"),
        qd_archive_type="cvt",
        qd_num_cells=8,
        qd_cvt_axes=("g_A", "g_T"),
        qd_cvt_warmup_successes=1,
    )
    assert engine.success_archive.archive_type == "cvt"
    assert tuple(engine.success_archive.axes) == ("g_A", "g_T")


def test_qd_engine_uses_cvt_axes_for_descriptor_tuple(tmp_path, monkeypatch):
    monkeypatch.setattr(
        "revolution.algorithm.EoHEngine.load_problem_description",
        lambda self: "desc",
    )
    engine = QDEngine(
        benchmark_name="Bench",
        problem_name="Prob",
        llm_interface=_DummyLLM(),
        verilog_evaluator=_DummyEval(),
        synthesis_evaluator=_DummySynth(),
        base_save_path=str(tmp_path / "exp"),
        qd_archive_type="cvt",
        qd_num_cells=8,
        qd_cvt_axes=("seq_ratio", "g_A"),
        qd_cvt_warmup_successes=1,
    )
    cand = Heuristic("t", "module m; endmodule", "", score=0.5, generation=0, status="success")
    cand.ppa_success = True
    cand.ppa_metrics = {"power": 0.9, "area": 90.0, "eff_clk_period": 0.8}
    cand.structural_metrics = {"seq_ratio": 0.25}
    engine.ref_ppa_metrics = {"power": 1.0, "area": 100.0, "eff_clk_period": 1.0}

    descriptors = engine._descriptor_tuple(cand)

    assert descriptors is not None
    assert descriptors[0] == pytest.approx(0.25)
    assert descriptors[1] == pytest.approx(0.1)


def test_qd_engine_builds_grid_archive_from_descriptor_file(tmp_path, monkeypatch):
    cfg = tmp_path / "qd.yaml"
    cfg.write_text(
        "grid_axes:\n"
        "  seq_ratio:\n"
        "    bins: 3\n"
        "    lower_bound: 0.0\n"
        "    upper_bound: 1.0\n",
        encoding="utf-8",
    )
    monkeypatch.setattr(
        "revolution.algorithm.EoHEngine.load_problem_description",
        lambda self: "desc",
    )
    engine = QDEngine(
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
        qd_descriptor_file=str(cfg),
        qd_grid_axes=("seq_ratio",),
    )
    assert engine.success_archive.axes[0].bins == 3
    assert engine.success_archive.axes[0].lower_bound == pytest.approx(0.0)
    assert engine.success_archive.axes[0].upper_bound == pytest.approx(1.0)


def test_qd_engine_grid_profile_is_used_when_qd_grid_axes_are_omitted(tmp_path, monkeypatch):
    monkeypatch.setattr(
        "revolution.algorithm.EoHEngine.load_problem_description",
        lambda self: "desc",
    )
    problem_spec = ProblemSpec(
        benchmark_name="RTLLM",
        problem_name="Prob",
        prompt_text="desc",
        top_module="TopModule",
        benchmark_root=tmp_path,
        circuit_type="sequential",
    )
    engine = QDEngine(
        benchmark_name="RTLLM",
        problem_name="Prob",
        llm_interface=_DummyLLM(),
        verilog_evaluator=_DummyEval(),
        synthesis_evaluator=_DummySynth(),
        population_size=2,
        num_generations=0,
        base_save_path=str(tmp_path / "exp"),
        qd_archive_type="grid",
        qd_num_cells=16,
        qd_descriptor_profile="implemented_structural_compact_3d",
        qd_grid_axes=(),
        problem_spec=problem_spec,
    )
    assert engine.qd_grid_axes == ("comb_ratio", "adder_ratio", "cell_count_log")
    assert [axis.name for axis in engine.success_archive.axes] == [
        "comb_ratio",
        "adder_ratio",
        "cell_count_log",
    ]


def test_qd_engine_writes_grid_artifacts(tmp_path, monkeypatch):
    engine = _engine(tmp_path, monkeypatch)
    engine.logger = SimpleNamespace(log_dir=str(tmp_path / "artifacts"))
    engine.qd_descriptor_profile = "implemented_structural_compact_3d"
    engine.qd_grid_axes = ("comb_ratio", "adder_ratio", "cell_count_log")
    engine.success_archive = engine._build_archive()
    elite = Heuristic("elite", "module m; endmodule", "", score=0.6, generation=0, status="success")
    elite.ppa_success = True
    elite.code_file_path = str(tmp_path / "elite.sv")
    elite.ppa_metrics = {"power": 0.9, "area": 90.0, "eff_clk_period": 0.8}
    elite.structural_metrics = {
        "comb_ratio": 0.8,
        "adder_ratio": 0.1,
        "cell_count_log": 6.2,
    }
    engine.ref_ppa_metrics = {"power": 1.0, "area": 100.0, "eff_clk_period": 1.0}
    engine.success_pool = [elite]
    engine._rebuild_archive_from_success_pool()

    snapshot = engine._build_qd_snapshot(inserted=1, replaced=0, budget=None, runtime_sec=0.1)
    engine._write_qd_artifacts(snapshot)

    history_path = tmp_path / "artifacts" / "archive_history.jsonl"
    cells_path = tmp_path / "artifacts" / "archive_cells.csv"
    summary_path = tmp_path / "artifacts" / "archive_summary.json"
    layout_path = tmp_path / "artifacts" / "grid_layout.json"
    metrics_path = tmp_path / "artifacts" / "qd_metrics.json"
    space_json_path = tmp_path / "artifacts" / "archive_space.json"
    space_report_path = tmp_path / "artifacts" / "archive_space_report.md"
    descriptor_health_json_path = tmp_path / "artifacts" / "descriptor_health.json"
    descriptor_health_report_path = tmp_path / "artifacts" / "descriptor_health_report.md"
    coverage_plot = tmp_path / "artifacts" / "coverage_vs_generation.png"
    legacy_quality_plot = tmp_path / "artifacts" / "grid_quality_heatmap.png"
    occupancy_marginal = tmp_path / "artifacts" / "grid_comb_ratio_occupancy_marginal.png"
    quality_marginal = tmp_path / "artifacts" / "grid_comb_ratio_quality_marginal.png"
    occupancy_projection = tmp_path / "artifacts" / "grid_comb_ratio__adder_ratio_occupancy_projection.png"
    quality_projection = tmp_path / "artifacts" / "grid_comb_ratio__adder_ratio_quality_projection.png"

    assert history_path.is_file()
    assert cells_path.is_file()
    assert summary_path.is_file()
    assert layout_path.is_file()
    assert metrics_path.is_file()
    assert space_json_path.is_file()
    assert space_report_path.is_file()
    assert descriptor_health_json_path.is_file()
    assert descriptor_health_report_path.is_file()
    assert coverage_plot.is_file()
    assert not legacy_quality_plot.exists()
    assert occupancy_marginal.is_file()
    assert quality_marginal.is_file()
    assert occupancy_projection.is_file()
    assert quality_projection.is_file()

    history_entry = json.loads(history_path.read_text(encoding="utf-8").strip())
    assert history_entry["archive_type"] == "grid"
    assert history_entry["occupied_cells"] == 1

    cell_rows = list(csv.DictReader(cells_path.open(encoding="utf-8")))
    assert len(cell_rows) == 1
    assert cell_rows[0]["candidate_id"] == elite.id
    summary_payload = json.loads(summary_path.read_text(encoding="utf-8"))
    metrics_payload = json.loads(metrics_path.read_text(encoding="utf-8"))
    descriptor_health_payload = json.loads(
        descriptor_health_json_path.read_text(encoding="utf-8")
    )
    visualization_files = "".join(summary_payload["visualization_files"])
    assert "coverage_vs_generation.png" in visualization_files
    assert "grid_comb_ratio_occupancy_marginal.png" in visualization_files
    assert "grid_comb_ratio__adder_ratio_quality_projection.png" in visualization_files
    assert summary_payload["descriptor_profile"] == "implemented_structural_compact_3d"
    assert summary_payload["descriptor_axes"] == [
        "comb_ratio",
        "adder_ratio",
        "cell_count_log",
    ]
    assert summary_payload["descriptor_health_files"] == {
        "json": "descriptor_health.json",
        "report": "descriptor_health_report.md",
    }
    space_payload = json.loads(space_json_path.read_text(encoding="utf-8"))
    assert space_payload["archive_type"] == "grid"
    assert "uniform grid binning" in space_payload["assignment_rule"]
    report_text = space_report_path.read_text(encoding="utf-8")
    assert "Multi-axis grids emit per-axis marginal plots" in report_text
    assert "pairwise projected occupancy/quality heatmaps" in report_text
    assert metrics_payload["occupied_cells"] == 1
    assert metrics_payload["coverage"] == pytest.approx(1 / space_payload["num_cells"])
    assert metrics_payload["qd_score"] == pytest.approx(0.6)
    assert metrics_payload["descriptor_profile"] == "implemented_structural_compact_3d"
    assert metrics_payload["descriptor_axes"] == [
        "comb_ratio",
        "adder_ratio",
        "cell_count_log",
    ]
    assert metrics_payload["history_length"] == 1
    assert metrics_payload["latest_snapshot"]["occupied_cells"] == 1
    assert descriptor_health_payload["descriptor_profile"] == "implemented_structural_compact_3d"
    assert descriptor_health_payload["observation_count"] == 1
    assert descriptor_health_payload["archive_entry_count"] == 1
    assert descriptor_health_payload["decision_counts"]["filled_empty"] == 1
    assert any(item["axis"] == "comb_ratio" for item in descriptor_health_payload["axis_health"])
    assert "Descriptor Health Report" in descriptor_health_report_path.read_text(encoding="utf-8")


def test_qd_engine_writes_cvt_layout_metadata(tmp_path, monkeypatch):
    monkeypatch.setattr(
        "revolution.algorithm.EoHEngine.load_problem_description",
        lambda self: "desc",
    )
    engine = QDEngine(
        benchmark_name="Bench",
        problem_name="Prob",
        llm_interface=_DummyLLM(),
        verilog_evaluator=_DummyEval(),
        synthesis_evaluator=_DummySynth(),
        base_save_path=str(tmp_path / "exp"),
        qd_archive_type="cvt",
        qd_num_cells=4,
        qd_cvt_axes=("g_A", "g_T"),
        qd_cvt_warmup_successes=1,
    )
    engine.logger = SimpleNamespace(log_dir=str(tmp_path / "artifacts"))
    cand = Heuristic("elite", "module m; endmodule", "", score=0.6, generation=0, status="success")
    cand.ppa_success = True
    cand.code_file_path = str(tmp_path / "elite.sv")
    cand.ppa_metrics = {"power": 0.9, "area": 90.0, "eff_clk_period": 0.8}
    engine.ref_ppa_metrics = {"power": 1.0, "area": 100.0, "eff_clk_period": 1.0}

    engine._insert_successes([cand])
    engine._write_qd_artifacts(engine._build_qd_snapshot(inserted=1, replaced=0, budget=None))

    layout_payload = json.loads((tmp_path / "artifacts" / "centroids.json").read_text(encoding="utf-8"))
    space_payload = json.loads((tmp_path / "artifacts" / "archive_space.json").read_text(encoding="utf-8"))
    assert layout_payload["archive_type"] == "cvt"
    assert layout_payload["initialized"] is True
    assert len(layout_payload["centroids"]) == 4
    assert space_payload["archive_type"] == "cvt"
    assert space_payload["space_geometry"]["initialized"] is True
    assert (tmp_path / "artifacts" / "archive_space_report.md").is_file()
    assert (tmp_path / "artifacts" / "cvt_quality_projection.png").is_file()


def test_qd_engine_builds_grid_quantile_from_journal_profile(tmp_path, monkeypatch):
    monkeypatch.setattr(
        "revolution.algorithm.EoHEngine.load_problem_description",
        lambda self: "desc",
    )
    engine = QDEngine(
        benchmark_name="Bench",
        problem_name="Prob",
        llm_interface=_DummyLLM(),
        verilog_evaluator=_DummyEval(),
        synthesis_evaluator=_DummySynth(),
        base_save_path=str(tmp_path / "exp"),
        qd_archive_type="grid_quantile",
        qd_descriptor_profile="journal_logic_ff_width_3d",
        qd_grid_quantile_warmup_successes=8,
    )

    assert isinstance(engine.success_archive, GridQuantileArchive)
    assert engine._archive_axes() == ("logic_depth", "ff_depth", "comb_width_log")
    assert engine.success_archive.warmup_successes == 8


def test_qd_engine_grid_quantile_warmup_budget_uses_success_pool(tmp_path, monkeypatch):
    monkeypatch.setattr(
        "revolution.algorithm.EoHEngine.load_problem_description",
        lambda self: "desc",
    )
    engine = QDEngine(
        benchmark_name="Bench",
        problem_name="Prob",
        llm_interface=_DummyLLM(),
        verilog_evaluator=_DummyEval(),
        synthesis_evaluator=_DummySynth(),
        population_size=20,
        num_generations=0,
        base_save_path=str(tmp_path / "exp"),
        qd_archive_type="grid_quantile",
        qd_descriptor_profile="journal_logic_ff_width_3d",
        qd_grid_quantile_warmup_successes=8,
    )
    engine.ref_ppa_metrics = {"power": 1.0, "area": 100.0, "eff_clk_period": 1.0}
    engine.qd_cell_reservoir = 0
    successes = []
    for index in range(3):
        cand = Heuristic(
            f"success-{index}",
            "module m; endmodule",
            "",
            score=0.5 + index,
            generation=0,
            status="success",
        )
        cand.ppa_success = True
        cand.ppa_metrics = {"power": 0.9, "area": 90.0, "eff_clk_period": 0.8}
        cand.graph_metrics = {
            "logic_depth": float(index + 1),
            "ff_depth": 0.0,
            "comb_width_log": float(index + 2),
        }
        successes.append(cand)
    fail = Heuristic("fail", "module m; endmodule", "", score=-1.0, generation=0, status="failed")

    engine.success_pool = successes
    engine._rebuild_archive_from_success_pool()
    engine.fail_pool = [fail]
    budget = engine._split_generation_budget()

    assert len(engine.success_pool) == 3
    assert budget.phase == "warmup"
    assert budget.fail_budget == 5
    assert budget.refine_budget == 15
    assert budget.seed_budget == 0


def test_qd_engine_drops_warmup_reservoir_after_grid_quantile_init(tmp_path, monkeypatch):
    monkeypatch.setattr(
        "revolution.algorithm.EoHEngine.load_problem_description",
        lambda self: "desc",
    )
    engine = QDEngine(
        benchmark_name="Bench",
        problem_name="Prob",
        llm_interface=_DummyLLM(),
        verilog_evaluator=_DummyEval(),
        synthesis_evaluator=_DummySynth(),
        population_size=20,
        num_generations=0,
        base_save_path=str(tmp_path / "exp"),
        qd_archive_type="grid_quantile",
        qd_descriptor_profile="journal_logic_ff_width_3d",
        qd_grid_quantile_warmup_successes=2,
    )
    engine.ref_ppa_metrics = {"power": 1.0, "area": 100.0, "eff_clk_period": 1.0}
    engine.qd_cell_reservoir = 0
    candidates = []
    for index, descriptors in enumerate(((1.0, 0.0, 1.0), (4.0, 1.0, 2.0))):
        cand = Heuristic(
            f"success-{index}",
            "module m; endmodule",
            "",
            score=0.5 + index,
            generation=0,
            status="success",
        )
        cand.ppa_success = True
        cand.ppa_metrics = {"power": 0.9, "area": 90.0, "eff_clk_period": 0.8}
        cand.graph_metrics = {
            "logic_depth": descriptors[0],
            "ff_depth": descriptors[1],
            "comb_width_log": descriptors[2],
        }
        candidates.append(cand)

    engine.success_pool = candidates
    engine._rebuild_archive_from_success_pool()

    assert isinstance(engine.success_archive, GridQuantileArchive)
    assert engine.success_archive.is_initialized is True
    assert not any(cell_id.startswith("warmup:") for cell_id in engine.success_reservoir)


def test_qd_engine_grid_quantile_warmup_budget_keeps_success_share(tmp_path, monkeypatch):
    monkeypatch.setattr(
        "revolution.algorithm.EoHEngine.load_problem_description",
        lambda self: "desc",
    )
    engine = QDEngine(
        benchmark_name="Bench",
        problem_name="Prob",
        llm_interface=_DummyLLM(),
        verilog_evaluator=_DummyEval(),
        synthesis_evaluator=_DummySynth(),
        population_size=20,
        num_generations=0,
        base_save_path=str(tmp_path / "exp"),
        qd_archive_type="grid_quantile",
        qd_descriptor_profile="journal_logic_ff_width_3d",
        qd_grid_quantile_warmup_successes=8,
    )
    engine.success_pool = [
        Heuristic("success", "module m; endmodule", "", score=1.0, generation=0, status="success")
    ]
    engine.fail_pool = [
        Heuristic(f"fail-{index}", "module m; endmodule", "", score=-1.0, generation=0, status="failed")
        for index in range(19)
    ]

    budget = engine._split_generation_budget()

    assert budget.phase == "warmup"
    assert budget.fail_budget == 10
    assert budget.refine_budget == 10


def test_qd_engine_writes_grid_quantile_artifacts(tmp_path, monkeypatch):
    monkeypatch.setattr(
        "revolution.algorithm.EoHEngine.load_problem_description",
        lambda self: "desc",
    )
    engine = QDEngine(
        benchmark_name="Bench",
        problem_name="Prob",
        llm_interface=_DummyLLM(),
        verilog_evaluator=_DummyEval(),
        synthesis_evaluator=_DummySynth(),
        base_save_path=str(tmp_path / "exp"),
        qd_archive_type="grid_quantile",
        qd_descriptor_profile="journal_logic_ff_width_3d",
        qd_grid_quantile_warmup_successes=2,
    )
    artifact_root = tmp_path / "artifacts"
    engine.logger = SimpleNamespace(log_dir=str(artifact_root))
    engine.ref_ppa_metrics = {"power": 1.0, "area": 100.0, "eff_clk_period": 1.0}

    first = Heuristic("a", "module m; endmodule", "", score=0.5, generation=0, status="success")
    first.ppa_success = True
    first.ppa_metrics = {"power": 0.9, "area": 90.0, "eff_clk_period": 0.8}
    first.graph_metrics = {
        "logic_depth": 1.0,
        "ff_depth": 0.0,
        "comb_width_log": 1.0,
    }
    first.code_file_path = str(artifact_root / "Prob_sample1_initial" / "code.sv")
    second = Heuristic("b", "module m; endmodule", "", score=0.7, generation=0, status="success")
    second.ppa_success = True
    second.ppa_metrics = {"power": 0.8, "area": 88.0, "eff_clk_period": 0.7}
    second.graph_metrics = {
        "logic_depth": 4.0,
        "ff_depth": 0.0,
        "comb_width_log": 2.0,
    }
    second.code_file_path = str(artifact_root / "Prob_sample2_initial" / "code.sv")

    inserted, replaced = engine._insert_successes([first, second])
    snapshot = engine._build_qd_snapshot(inserted=inserted, replaced=replaced, budget=None)
    engine._write_qd_artifacts(snapshot)

    space_payload = json.loads((artifact_root / "archive_space.json").read_text(encoding="utf-8"))
    summary_payload = json.loads((artifact_root / "archive_summary.json").read_text(encoding="utf-8"))
    event_payload = json.loads(
        (artifact_root / "Prob_sample1_initial" / "qd_archive_event.json").read_text(encoding="utf-8")
    )
    history_payload = json.loads(
        (artifact_root / "archive_history.jsonl").read_text(encoding="utf-8").strip()
    )

    assert inserted == 0
    assert replaced == 0
    assert space_payload["archive_type"] == "grid_quantile"
    assert space_payload["initialized"] is True
    assert space_payload["intended_num_cells"] == 64
    assert space_payload["warmup_initialization_samples"][0]["archive_insertion_index"] == 1
    assert space_payload["warmup_initialization_samples"][0]["generation_candidate_index"] == 1
    assert space_payload["warmup_replay_results"][0]["inserted"] is True
    assert summary_payload["initialized"] is True
    assert summary_payload["warmup_successes"] == 2
    assert event_payload["decision"] == "warmup_buffered"
    assert event_payload["assignment"]["initialized"] is False
    assert event_payload["archive_insertion_index"] == 1
    assert history_payload["grid_quantile_geometry"]["quantile_boundaries_hash"] == space_payload["quantile_boundaries_hash"]
    assert (artifact_root / "grid_quantile_layout.json").is_file()
    assert (artifact_root / "grid_quantile_occupancy_evolution.html").is_file()
    assert (artifact_root / "grid_quantile_visualization_manifest.json").is_file()
    assert (artifact_root / "grid_quantile_frames" / "frame_0000.png").is_file()


def test_qd_engine_finalizes_degenerate_grid_quantile_at_run_end(tmp_path, monkeypatch):
    monkeypatch.setattr(
        "revolution.algorithm.EoHEngine.load_problem_description",
        lambda self: "desc",
    )
    engine = QDEngine(
        benchmark_name="Bench",
        problem_name="Prob",
        llm_interface=_DummyLLM(),
        verilog_evaluator=_DummyEval(),
        synthesis_evaluator=_DummySynth(),
        base_save_path=str(tmp_path / "exp"),
        qd_archive_type="grid_quantile",
        qd_descriptor_profile="journal_logic_ff_width_3d",
        qd_grid_quantile_warmup_successes=2,
    )
    engine.run_start_time = time.time()
    engine.ref_ppa_metrics = {"power": 1.0, "area": 100.0, "eff_clk_period": 1.0}
    candidates = []
    for index in range(2):
        candidate = Heuristic(
            f"cand-{index}",
            "module m; endmodule",
            "",
            score=0.5 + index,
            generation=0,
            status="success",
        )
        candidate.ppa_success = True
        candidate.ppa_metrics = {"power": 0.9, "area": 90.0, "eff_clk_period": 0.8}
        candidate.graph_metrics = {
            "logic_depth": 1.0,
            "ff_depth": 0.0,
            "comb_width_log": 1.0,
        }
        candidate.code_file_path = str(tmp_path / f"Prob_sample{index}_initial" / "code.sv")
        candidates.append(candidate)

    inserted, replaced = engine._insert_successes(candidates)
    finalization = engine._finalize_pending_archive()

    assert inserted == 0
    assert replaced == 0
    assert finalization == (2, 1)
    assert isinstance(engine.success_archive, GridQuantileArchive)
    assert engine.success_archive.is_initialized is True
    assert engine.success_archive.initialization_mode == "run_finalization_fallback"
    assert engine.success_archive.effective_bins == (1, 1, 1)


def test_qd_engine_initial_artifact_write_records_initial_snapshot(tmp_path, monkeypatch):
    engine = _engine(tmp_path, monkeypatch)
    engine.logger = SimpleNamespace(log_dir=str(tmp_path / "artifacts"))
    elite = Heuristic("elite", "module m; endmodule", "", score=0.6, generation=0, status="success")
    elite.ppa_success = True
    elite.code_file_path = str(tmp_path / "elite.sv")
    elite.ppa_metrics = {"power": 0.9, "area": 90.0, "eff_clk_period": 0.8}
    engine.ref_ppa_metrics = {"power": 1.0, "area": 100.0, "eff_clk_period": 1.0}
    engine.success_pool = [elite]
    engine._rebuild_archive_from_success_pool()

    engine._write_qd_artifacts(
        engine._build_qd_snapshot(inserted=engine.success_archive.occupied_count(), replaced=0, budget=None)
    )

    history_path = tmp_path / "artifacts" / "archive_history.jsonl"
    summary_path = tmp_path / "artifacts" / "archive_summary.json"
    metrics_path = tmp_path / "artifacts" / "qd_metrics.json"

    history_lines = [line for line in history_path.read_text(encoding="utf-8").splitlines() if line.strip()]
    assert len(history_lines) == 1

    summary_payload = json.loads(summary_path.read_text(encoding="utf-8"))
    metrics_payload = json.loads(metrics_path.read_text(encoding="utf-8"))
    assert summary_payload["history_length"] == 1
    assert summary_payload["occupied_cells"] == 1
    assert metrics_payload["history_length"] == 1
    assert metrics_payload["latest_snapshot"]["occupied_cells"] == 1


def test_qd_engine_writes_candidate_archive_event_for_empty_fill(tmp_path, monkeypatch):
    engine = _engine(tmp_path, monkeypatch)
    engine.logger = SimpleNamespace(log_dir=str(tmp_path / "artifacts"))
    cand = Heuristic("elite", "module m; endmodule", "", score=0.6, generation=0, status="success")
    cand.ppa_success = True
    cand.code_file_path = str(tmp_path / "cand" / "code.sv")
    cand.ppa_metrics = {"power": 0.9, "area": 90.0, "eff_clk_period": 0.8}
    cand.rtl_metrics = {"assign_count": 1.0}
    cand.dynamic_metrics = {"toggle_count_log_est": 3.5}
    cand.graph_metrics = {"rent_exponent": 0.42}
    engine.ref_ppa_metrics = {"power": 1.0, "area": 100.0, "eff_clk_period": 1.0}

    inserted, replaced = engine._insert_successes([cand])

    event_path = tmp_path / "cand" / "qd_archive_event.json"
    payload = json.loads(event_path.read_text(encoding="utf-8"))
    assert inserted == 1
    assert replaced == 0
    assert payload["decision"] == "filled_empty"
    assert payload["cell_id"] == "2,2"
    assert payload["rtl_metrics"]["assign_count"] == pytest.approx(1.0)
    assert payload["dynamic_metrics"]["toggle_count_log_est"] == pytest.approx(3.5)
    assert payload["graph_metrics"]["rent_exponent"] == pytest.approx(0.42)
    assert payload["current_cell_elite"]["candidate_id"] == cand.id


def test_qd_engine_writes_candidate_archive_event_for_replacement(tmp_path, monkeypatch):
    engine = _engine(tmp_path, monkeypatch)
    prior = Heuristic("prior", "module m; endmodule", "", score=0.5, generation=0, status="success")
    prior.ppa_success = True
    prior.code_file_path = str(tmp_path / "prior" / "code.sv")
    prior.ppa_metrics = {"power": 0.9, "area": 90.0, "eff_clk_period": 0.8}
    better = Heuristic("better", "module m; endmodule", "", score=0.8, generation=1, status="success")
    better.ppa_success = True
    better.code_file_path = str(tmp_path / "better" / "code.sv")
    better.ppa_metrics = {"power": 0.85, "area": 90.0, "eff_clk_period": 0.8}
    engine.ref_ppa_metrics = {"power": 1.0, "area": 100.0, "eff_clk_period": 1.0}

    engine._insert_successes([prior])
    engine._insert_successes([better])

    payload = json.loads((tmp_path / "better" / "qd_archive_event.json").read_text(encoding="utf-8"))
    assert payload["decision"] == "replaced_elite"
    assert payload["previous_elite"]["candidate_id"] == prior.id
    assert payload["current_cell_elite"]["candidate_id"] == better.id


def test_qd_engine_writes_candidate_archive_event_for_non_inserted_success(tmp_path, monkeypatch):
    engine = _engine(tmp_path, monkeypatch)
    elite = Heuristic("elite", "module m; endmodule", "", score=0.6, generation=0, status="success")
    elite.ppa_success = True
    elite.code_file_path = str(tmp_path / "elite" / "code.sv")
    elite.ppa_metrics = {"power": 0.9, "area": 90.0, "eff_clk_period": 0.8}
    near = Heuristic("near", "module m; endmodule", "", score=0.4, generation=1, status="success")
    near.ppa_success = True
    near.code_file_path = str(tmp_path / "near" / "code.sv")
    near.ppa_metrics = {"power": 0.92, "area": 90.0, "eff_clk_period": 0.8}
    engine.ref_ppa_metrics = {"power": 1.0, "area": 100.0, "eff_clk_period": 1.0}

    engine._insert_successes([elite])
    engine._insert_successes([near])

    payload = json.loads((tmp_path / "near" / "qd_archive_event.json").read_text(encoding="utf-8"))
    assert payload["decision"] == "not_inserted"
    assert payload["previous_elite"]["candidate_id"] == elite.id
    assert payload["current_cell_elite"]["candidate_id"] == elite.id


def test_qd_engine_writes_candidate_archive_event_for_cvt_warmup(tmp_path, monkeypatch):
    monkeypatch.setattr(
        "revolution.algorithm.EoHEngine.load_problem_description",
        lambda self: "desc",
    )
    engine = QDEngine(
        benchmark_name="Bench",
        problem_name="Prob",
        llm_interface=_DummyLLM(),
        verilog_evaluator=_DummyEval(),
        synthesis_evaluator=_DummySynth(),
        base_save_path=str(tmp_path / "exp"),
        qd_archive_type="cvt",
        qd_num_cells=4,
        qd_cvt_axes=("g_A", "g_T"),
        qd_cvt_warmup_successes=2,
    )
    cand = Heuristic("elite", "module m; endmodule", "", score=0.6, generation=0, status="success")
    cand.ppa_success = True
    cand.code_file_path = str(tmp_path / "cand" / "code.sv")
    cand.ppa_metrics = {"power": 0.9, "area": 90.0, "eff_clk_period": 0.8}
    engine.ref_ppa_metrics = {"power": 1.0, "area": 100.0, "eff_clk_period": 1.0}

    engine._insert_successes([cand])

    payload = json.loads((tmp_path / "cand" / "qd_archive_event.json").read_text(encoding="utf-8"))
    assert payload["decision"] == "warmup_buffered"
    assert payload["assignment"]["assignment_status"] == "warmup_pending"


def test_qd_engine_finalizes_partial_cvt_warmup_at_run_end(tmp_path, monkeypatch):
    monkeypatch.setattr(
        "revolution.algorithm.EoHEngine.load_problem_description",
        lambda self: "desc",
    )
    engine = QDEngine(
        benchmark_name="Bench",
        problem_name="Prob",
        llm_interface=_DummyLLM(),
        verilog_evaluator=_DummyEval(),
        synthesis_evaluator=_DummySynth(),
        base_save_path=str(tmp_path / "exp"),
        qd_archive_type="cvt",
        qd_num_cells=4,
        qd_cvt_axes=("g_A", "g_T"),
        qd_cvt_warmup_successes=4,
    )
    engine.logger = SimpleNamespace(log_dir=str(tmp_path / "artifacts"))
    engine.run_start_time = time.time()

    cand = Heuristic("elite", "module m; endmodule", "", score=0.6, generation=0, status="success")
    cand.ppa_success = True
    cand.code_file_path = str(tmp_path / "elite.sv")
    cand.ppa_metrics = {"power": 0.9, "area": 90.0, "eff_clk_period": 0.8}
    engine.ref_ppa_metrics = {"power": 1.0, "area": 100.0, "eff_clk_period": 1.0}

    engine._insert_successes([cand])

    finalization = engine._finalize_pending_archive()

    assert finalization == (1, 0)
    assert engine.success_archive.is_initialized is True

    engine._write_finalization_fallback_artifacts(inserted=1, replaced=0)

    layout_payload = json.loads((tmp_path / "artifacts" / "centroids.json").read_text(encoding="utf-8"))
    summary_payload = json.loads((tmp_path / "artifacts" / "archive_summary.json").read_text(encoding="utf-8"))
    history_lines = [
        line
        for line in (tmp_path / "artifacts" / "archive_history.jsonl").read_text(encoding="utf-8").splitlines()
        if line.strip()
    ]
    history_payload = json.loads(history_lines[-1])

    assert layout_payload["initialized"] is True
    assert layout_payload["initialization_mode"] == "run_finalization_fallback"
    assert summary_payload["occupied_cells"] == 1
    assert history_payload["phase"] == "run_finalization_fallback"
    assert history_payload["generation"] == 1


def test_qd_engine_ks_rebin_triggers_and_cools_down(tmp_path, monkeypatch):
    engine = _engine(
        tmp_path,
        monkeypatch,
        qd_archive_type="grid_quantile",
        qd_descriptor_profile="journal_logic_ff_width_3d",
        qd_grid_quantile_warmup_successes=4,
        qd_cell_mode="pareto_front",
        qd_max_elites_per_cell=50,
        qd_rebinning_kind="ks_triggered",
        qd_rebinning_recent_generations=1,
        qd_rebinning_min_archive_members=20,
        qd_rebinning_cooldown_generations=3,
    )
    artifact_root = tmp_path / "artifacts"
    engine.logger = SimpleNamespace(log_dir=str(artifact_root))
    old_members = [
        _qd_member(
            f"old-{index}",
            generation=0,
            descriptors=(float(index), 0.0, float(index)),
            insertion_index=index + 1,
        )
        for index in range(20)
    ]
    recent_members = [
        _qd_member(
            f"recent-{index}",
            generation=1,
            descriptors=(100.0 + index, 0.0, 100.0 + index),
            insertion_index=100 + index,
        )
        for index in range(20)
    ]
    engine.success_archive.rebuild_from_records(
        old_members,
        initialization_mode="warmup_complete",
    )
    engine._qd_rebin_replay_pool = {
        member.candidate_id: member for member in [*old_members, *recent_members]
    }
    engine._qd_rebin_recent_members = list(recent_members)
    engine.current_generation = 1

    engine._maybe_adaptive_rebin()

    history = [
        json.loads(line)
        for line in (artifact_root / "archive_history.jsonl").read_text(encoding="utf-8").splitlines()
        if line.strip()
    ]
    assert [event["event_kind"] for event in history] == ["rebin_check", "rebin"]
    rebin_event = history[-1]
    assert rebin_event["trigger_axes"]
    assert rebin_event["replay_member_count"] == 40
    assert rebin_event["replay_attempt_count"] == 40
    assert rebin_event["cooldown_remaining"] == 3
    assert rebin_event["total_rebin_count"] == 1
    assert engine._qd_rebin_count == 1
    assert engine._qd_rebin_cooldown_remaining == 3
    assert engine.success_archive.initialization_mode == "adaptive_rebin"

    engine.current_generation = 2
    engine._maybe_adaptive_rebin()

    history_after_cooldown = [
        line
        for line in (artifact_root / "archive_history.jsonl").read_text(encoding="utf-8").splitlines()
        if line.strip()
    ]
    assert len(history_after_cooldown) == 2
    assert engine._qd_rebin_cooldown_remaining == 2


def test_qd_engine_ks_rebin_replays_displaced_member(tmp_path, monkeypatch):
    engine = _engine(
        tmp_path,
        monkeypatch,
        qd_archive_type="grid_quantile",
        qd_descriptor_profile="journal_logic_ff_width_3d",
        qd_grid_quantile_warmup_successes=2,
        qd_rebinning_kind="ks_triggered",
        qd_rebinning_recent_generations=1,
        qd_rebinning_min_archive_members=2,
        qd_rebinning_base_p_threshold=0.5,
    )
    artifact_root = tmp_path / "artifacts"
    engine.logger = SimpleNamespace(log_dir=str(artifact_root))
    old = _qd_member(
        "old",
        generation=0,
        descriptors=(0.0, 0.0, 0.0),
        insertion_index=1,
        quality_score=1.0,
    )
    far = _qd_member(
        "far",
        generation=0,
        descriptors=(10.0, 0.0, 10.0),
        insertion_index=2,
        quality_score=0.5,
    )
    better = _qd_member(
        "better",
        generation=0,
        descriptors=(0.1, 0.0, 0.1),
        insertion_index=3,
        quality_score=2.0,
    )
    support = _qd_member(
        "support",
        generation=0,
        descriptors=(0.05, 0.0, 0.05),
        insertion_index=4,
        quality_score=1.5,
    )
    recent_members = [
        _qd_member(
            f"recent-{index}",
            generation=1,
            descriptors=(100.0 + index, 0.0, 100.0 + index),
            insertion_index=100 + index,
            quality_score=0.0,
        )
        for index in range(4)
    ]
    engine.success_archive.rebuild_from_records(
        [old, far],
        initialization_mode="warmup_complete",
    )
    support_result = engine.success_archive.insert(support)
    assert support_result.replaced is True
    result = engine.success_archive.insert(better)
    assert result.replaced is True
    assert {member.candidate_id for _, member in engine.success_archive.members()} == {
        "better",
        "far",
    }
    engine._qd_rebin_replay_pool = {
        member.candidate_id: member
        for member in [old, far, support, better, *recent_members]
    }
    engine._qd_rebin_recent_members = list(recent_members)
    engine.current_generation = 1

    engine._maybe_adaptive_rebin()

    active_ids = {member.candidate_id for _, member in engine.success_archive.members()}
    assert active_ids & {"old", "support"}
    rebin_event = json.loads(
        (artifact_root / "archive_history.jsonl").read_text(encoding="utf-8").splitlines()[-1]
    )
    assert rebin_event["event_kind"] == "rebin"
    assert rebin_event["displaced_replay_member_count"] >= 1
    assert rebin_event["reactivated_displaced_member_count"] >= 1


def test_qd_engine_creates_targeted_mutation_prompt(tmp_path, monkeypatch):
    engine = _engine(tmp_path, monkeypatch)
    parent = Heuristic("elite", "module m; endmodule", "", score=0.6, generation=0, status="success")
    parent.ppa_success = True
    parent.code_file_path = str(tmp_path / "elite.sv")
    parent.ppa_metrics = {"power": 0.9, "area": 90.0, "eff_clk_period": 0.8}
    parent.structural_metrics = {"seq_ratio": 0.25}
    engine.ref_ppa_metrics = {"power": 1.0, "area": 100.0, "eff_clk_period": 1.0}
    engine.success_pool = [parent]
    engine._rebuild_archive_from_success_pool()

    prompt = engine._create_prompt_M_T([parent])

    assert '"task": "target_descriptor_mutation"' in prompt
    assert '"desired_descriptor_shift"' in prompt
    assert '"archive_axes"' in prompt


def test_qd_engine_creates_diverse_fusion_prompt(tmp_path, monkeypatch):
    monkeypatch.setattr(
        "revolution.algorithm.EoHEngine.load_problem_description",
        lambda self: "desc",
    )
    engine = QDEngine(
        benchmark_name="Bench",
        problem_name="Prob",
        llm_interface=_DummyLLM(),
        verilog_evaluator=_DummyEval(),
        synthesis_evaluator=_DummySynth(),
        base_save_path=str(tmp_path / "exp"),
        qd_archive_type="cvt",
        qd_num_cells=8,
        qd_cvt_axes=("g_A", "g_T"),
        qd_cvt_warmup_successes=1,
    )
    engine.ref_ppa_metrics = {"power": 1.0, "area": 100.0, "eff_clk_period": 1.0}
    parent_a = Heuristic("a", "module a; endmodule", "", score=0.5, generation=0, status="success")
    parent_b = Heuristic("b", "module b; endmodule", "", score=0.7, generation=0, status="success")
    parent_a.ppa_success = True
    parent_b.ppa_success = True
    parent_a.code_file_path = str(tmp_path / "a.sv")
    parent_b.code_file_path = str(tmp_path / "b.sv")
    Path(parent_a.code_file_path).write_text(parent_a.code, encoding="utf-8")
    Path(parent_b.code_file_path).write_text(parent_b.code, encoding="utf-8")
    parent_a.ppa_metrics = {"power": 0.95, "area": 95.0, "eff_clk_period": 0.9}
    parent_b.ppa_metrics = {"power": 0.8, "area": 88.0, "eff_clk_period": 0.7}
    engine._insert_successes([parent_a, parent_b])

    prompt = engine._create_prompt_C_D([parent_a, parent_b])

    assert '"task": "diverse_archive_fusion"' in prompt
    assert '"descriptor_distance"' in prompt
    assert '"parent_descriptors"' in prompt


def test_qd_engine_fill_phase_can_select_targeted_operator(tmp_path, monkeypatch):
    engine = _engine(tmp_path, monkeypatch)
    engine.logger = SimpleNamespace(log_generation=lambda *args, **kwargs: None, log_dir=str(tmp_path / "artifacts"))
    engine.current_generation = 0
    engine.num_offspring_lambda = 4
    engine.fail_pool = []
    parent = Heuristic("elite", "module m; endmodule", "", score=0.6, generation=0, status="success")
    parent.ppa_success = True
    parent.code_file_path = str(tmp_path / "elite.sv")
    parent.ppa_metrics = {"power": 0.9, "area": 90.0, "eff_clk_period": 0.8}
    engine.ref_ppa_metrics = {"power": 1.0, "area": 100.0, "eff_clk_period": 1.0}
    engine.success_pool = [parent]
    engine._rebuild_archive_from_success_pool()

    captured_requests = []

    def _select_strategy(pool_type, available_strategies, selected_this_gen=None):
        return "M-T", {strategy: (1.0 if strategy == "M-T" else 0.0) for strategy in available_strategies}

    async def _generate_batch_responses(llm_requests, *args, **kwargs):
        captured_requests.extend(llm_requests)
        return []

    monkeypatch.setattr(engine, "_select_strategy", _select_strategy)
    monkeypatch.setattr(engine.llm, "generate_batch_responses", _generate_batch_responses)
    monkeypatch.setattr(
        engine,
        "_save_result_to_file",
        lambda *args, **kwargs: (str(tmp_path / "generated.sv"), None),
    )
    monkeypatch.setattr(engine, "_save_format_error_artifacts", lambda *args, **kwargs: None)
    monkeypatch.setattr(engine, "_evaluate_candidates", lambda candidates: None)

    result = engine.evolve_one_generation()

    assert result is None
    assert captured_requests
    assert "target_descriptor_mutation" in captured_requests[0]["prompt"]


def test_journal_qd_fill_phase_uses_archive_only_success_operators(
    tmp_path,
    monkeypatch,
):
    monkeypatch.setattr(
        "revolution.algorithm.EoHEngine.load_problem_description",
        lambda self: "desc",
    )
    engine = QDEngine(
        benchmark_name="Bench",
        problem_name="Prob",
        llm_interface=_DummyLLM(),
        verilog_evaluator=_DummyEval(),
        synthesis_evaluator=_DummySynth(),
        base_save_path=str(tmp_path / "exp"),
        qd_archive_type="cvt",
        qd_num_cells=8,
        qd_descriptor_profile="journal_logic_ff_width_3d",
        qd_cvt_warmup_successes=1,
    )
    engine.logger = SimpleNamespace(
        log_generation=lambda *args, **kwargs: None,
        log_dir=str(tmp_path / "artifacts"),
    )
    engine.current_generation = 0
    engine.num_offspring_lambda = 4
    engine.fail_pool = []
    engine.ref_ppa_metrics = {"power": 1.0, "area": 100.0, "eff_clk_period": 1.0}
    parent = Heuristic(
        "elite",
        "module m; endmodule",
        "",
        score=0.6,
        generation=0,
        status="success",
    )
    parent.ppa_success = True
    parent.code_file_path = str(tmp_path / "elite.sv")
    parent.ppa_metrics = {"power": 0.9, "area": 90.0, "eff_clk_period": 0.8}
    parent.graph_metrics = {
        "logic_depth": 2.0,
        "ff_depth": 1.0,
        "comb_width_log": 1.5,
    }
    Path(parent.code_file_path).write_text(parent.code, encoding="utf-8")
    engine.success_pool = [parent]
    engine._rebuild_archive_from_success_pool()
    assert engine.success_archive.occupied_count() == 1

    success_requests = []

    def _select_strategy(pool_type, available_strategies, selected_this_gen=None):
        if pool_type == "success":
            success_requests.append(tuple(available_strategies))
        return available_strategies[0], {
            strategy: (1.0 if strategy == available_strategies[0] else 0.0)
            for strategy in available_strategies
        }

    monkeypatch.setattr(engine, "_select_strategy", _select_strategy)
    monkeypatch.setattr(engine, "_materialize_offspring", lambda *_args: [])

    result = engine.evolve_one_generation()

    assert result == "STOP"
    assert success_requests
    assert all("M-T" not in request for request in success_requests)
    assert all("C-D" not in request for request in success_requests)


def test_qd_engine_run_returns_failed_when_archive_stays_empty(tmp_path, monkeypatch):
    engine = _engine(tmp_path, monkeypatch)

    monkeypatch.setattr(engine, "_calculate_reference_ppa", lambda: None)
    monkeypatch.setattr(engine, "_initialize_logger", lambda *_args, **_kwargs: None)
    monkeypatch.setattr(engine, "initialize_population", lambda: None)
    monkeypatch.setattr(engine, "_build_qd_snapshot", lambda **_kwargs: {})
    monkeypatch.setattr(engine, "_write_qd_artifacts", lambda _snapshot: None)
    monkeypatch.setattr(engine, "_finalize_run_summary", lambda _elites: None)

    result = engine.run()

    assert result == "Prob,failed"
