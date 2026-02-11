import json

from revolution.backends.base import EvolutionBackend
from revolution.runtime.run_artifacts import ArtifactWriter, add_legacy_strategy_key_alias


class _DummyBackend(EvolutionBackend):
    @property
    def name(self) -> str:
        return "dummy"

    def initialize(self) -> None:
        return None

    def run(self):
        return None

    def get_result_summary(self):
        return {}


def test_backend_interface_can_be_implemented():
    backend = _DummyBackend()
    assert backend.name == "dummy"
    backend.initialize()
    assert backend.get_result_summary() == {}


def test_artifact_writer_writes_generation_and_summary(tmp_path):
    writer = ArtifactWriter(
        save_path=tmp_path,
        model_name="model/x",
        benchmark_name="Bench",
        problem_name="Prob001",
    )
    code_path, thought_path = writer.write_candidate(
        generation=0,
        label="sampleA",
        code="module m; endmodule\n",
        thought="initial thought",
        metadata={"score": 1.0},
    )
    assert code_path.endswith("code.sv")
    assert thought_path.endswith("thought.txt")

    writer.append_generation_log({"generation": 0, "ok": True})
    summary_path = writer.write_summary(
        {
            "problem_name": "Prob001",
            "benchmark_name": "Bench",
            "accumulated_strategy_counts": {"M-I": 1},
        }
    )
    summary = json.loads(open(summary_path, "r", encoding="utf-8").read())
    assert summary["accumulated_strategy_counts"]["M-I"] == 1
    assert summary["accumulated_strategy_counts:"]["M-I"] == 1


def test_legacy_strategy_alias_handles_both_forms():
    only_legacy = {"accumulated_strategy_counts:": {"A": 1}}
    fixed_legacy = add_legacy_strategy_key_alias(only_legacy)
    assert fixed_legacy["accumulated_strategy_counts"]["A"] == 1

    only_canonical = {"accumulated_strategy_counts": {"B": 2}}
    fixed_canonical = add_legacy_strategy_key_alias(only_canonical)
    assert fixed_canonical["accumulated_strategy_counts:"]["B"] == 2
