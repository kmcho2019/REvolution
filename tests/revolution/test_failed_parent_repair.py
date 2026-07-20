import json
from types import SimpleNamespace

import pytest

from revolution.algorithm import EoHEngine
from revolution.failed_parent_repair import FailedParentRepairEngine


def _fake_classic_init(self, **kwargs):
    self.population_pool_mode = kwargs["population_pool_mode"]
    self.classic_operator_kind = kwargs["classic_operator_kind"]
    self.eoh_success_operator_set = kwargs["eoh_success_operator_set"]
    self.strategy_selection_method = kwargs["strategy_selection_method"]
    self.generation_mode = kwargs["generation_mode"]
    self.fail_strats = ["M-F", "M-S", "M-E", "M-R", "M-I"]
    self.fail_strategy_stats = {
        strategy: {"count": 0, "value": 0.0} for strategy in self.fail_strats
    }
    self.success_strats = ["M-S", "M-E", "M-R", "M-I", "C-F"]
    self.success_strategy_stats = {
        strategy: {"count": 0, "value": 0.0} for strategy in self.success_strats
    }
    self.fail_pool = []
    self.success_pool = []
    self.current_generation = 0
    self.logger = None


def _contract():
    return {
        "population_pool_mode": "dual",
        "classic_operator_kind": "eoh_strategies",
        "eoh_success_operator_set": "classic",
        "strategy_selection_method": "ucb",
        "generation_mode": "whole",
    }


def test_failed_parent_repair_narrows_only_fail_operator_state(monkeypatch):
    monkeypatch.setattr(EoHEngine, "__init__", _fake_classic_init)

    engine = FailedParentRepairEngine(**_contract())
    assert engine.fail_strats == ["M-F"]
    assert engine.fail_strategy_stats == {"M-F": {"count": 0, "value": 0.0}}
    assert engine.success_strats == ["M-S", "M-E", "M-R", "M-I", "C-F"]
    assert engine.success_strategy_stats == {
        strategy: {"count": 0, "value": 0.0} for strategy in engine.success_strats
    }


@pytest.mark.parametrize(
    ("field", "value"),
    [
        ("population_pool_mode", "single"),
        ("classic_operator_kind", "single_thought_operator"),
        ("eoh_success_operator_set", "one_parent"),
        ("strategy_selection_method", "random"),
        ("generation_mode", "diff"),
    ],
)
def test_failed_parent_repair_asserts_classic_contract(monkeypatch, field, value):
    monkeypatch.setattr(EoHEngine, "__init__", _fake_classic_init)
    contract = _contract()
    contract[field] = value

    with pytest.raises(AssertionError):
        FailedParentRepairEngine(**contract)


def test_failed_parent_repair_records_pool_transition(monkeypatch, tmp_path):
    monkeypatch.setattr(EoHEngine, "__init__", _fake_classic_init)

    def _fake_evolve(self):
        self.current_generation += 1
        self.fail_pool = [object()]
        self.success_pool = [object(), object()]
        return None

    monkeypatch.setattr(EoHEngine, "evolve_one_generation", _fake_evolve)
    engine = FailedParentRepairEngine(**_contract())
    engine.fail_pool = [object(), object()]
    engine.success_pool = [object()]
    engine.logger = SimpleNamespace(log_dir=str(tmp_path))

    assert engine.evolve_one_generation() is None
    assert engine.evolve_one_generation() is None

    path = tmp_path / "failed_parent_repair_pool_telemetry.jsonl"
    records = [
        json.loads(line) for line in path.read_text(encoding="utf-8").splitlines()
    ]
    assert records[0] == {
        "generation": 1,
        "pre_selection_fail_pool_size": 2,
        "pre_selection_success_pool_size": 1,
        "post_selection_fail_pool_size": 1,
        "post_selection_success_pool_size": 2,
        "generation_outcome": "completed",
    }
    assert records[1] == {
        "generation": 2,
        "pre_selection_fail_pool_size": 1,
        "pre_selection_success_pool_size": 2,
        "post_selection_fail_pool_size": 1,
        "post_selection_success_pool_size": 2,
        "generation_outcome": "completed",
    }


def test_failed_parent_repair_records_stop_without_selection(monkeypatch, tmp_path):
    monkeypatch.setattr(EoHEngine, "__init__", _fake_classic_init)

    def _fake_stop(self):
        self.current_generation += 1
        return "STOP"

    monkeypatch.setattr(EoHEngine, "evolve_one_generation", _fake_stop)
    engine = FailedParentRepairEngine(**_contract())
    engine.fail_pool = [object()]
    engine.success_pool = [object()]
    engine.logger = SimpleNamespace(log_dir=str(tmp_path))

    assert engine.evolve_one_generation() == "STOP"

    path = tmp_path / "failed_parent_repair_pool_telemetry.jsonl"
    record = json.loads(path.read_text(encoding="utf-8"))
    assert record["generation_outcome"] == "stop"
    assert record["post_selection_fail_pool_size"] == 1
    assert record["post_selection_success_pool_size"] == 1


def test_failed_parent_repair_clears_stale_telemetry_before_generation(
    monkeypatch, tmp_path
):
    monkeypatch.setattr(EoHEngine, "__init__", _fake_classic_init)

    def _failed_evolve(self):
        raise RuntimeError("generation failed")

    monkeypatch.setattr(EoHEngine, "evolve_one_generation", _failed_evolve)
    path = tmp_path / "failed_parent_repair_pool_telemetry.jsonl"
    path.write_text('{"stale": true}\n', encoding="utf-8")
    engine = FailedParentRepairEngine(**_contract())
    engine.logger = SimpleNamespace(log_dir=str(tmp_path))

    with pytest.raises(RuntimeError, match="generation failed"):
        engine.evolve_one_generation()

    assert path.read_text(encoding="utf-8") == ""
