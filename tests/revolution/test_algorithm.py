import uuid
from unittest.mock import MagicMock

import pytest

from revolution.algorithm import EoHEngine, Heuristic


def test_heuristic_initialization():
    """
    Tests if the Heuristic class initializes with the correct default values.
    """
    thought = "This is a test thought."
    code = "module test; endmodule"

    # Action
    h = Heuristic(
        thought=thought,
        code=code,
        feedback="Initial feedback",
        generation=1,
        strategy="M-F",
        origin_pool="fail_pool",
    )

    # Assert
    assert h.thought == thought
    assert h.code == code
    assert h.generation == 1
    assert h.score == 0.0
    assert h.status == "new"
    assert h.strategy == "M-F"
    assert h.origin_pool == "fail_pool"
    assert h.parent_ids == []

    # Check that a UUID was assigned
    assert isinstance(uuid.UUID(h.id), uuid.UUID)


# Use pytest.mark.parametrize to test multiple scenarios with one function
@pytest.mark.parametrize(
    "is_sequential, ppa_metrics, ref_metrics, expected_score",
    [
        # Scenario 1: Sequential circuit with 10% improvement in all metrics
        (
            True,
            {"power": 0.9, "area": 90.0, "eff_clk_period": 1.8},
            {"power": 1.0, "area": 100.0, "eff_clk_period": 2.0},
            pytest.approx(0.1),  # - ((-0.1) + (-0.1) + (-0.1)) / 3
        ),
        # Scenario 2: Combinational circuit (timing is ignored)
        (
            False,
            {"power": 0.8, "area": 120.0, "eff_clk_period": 0.0},
            {"power": 1.0, "area": 100.0, "eff_clk_period": 0.0},
            pytest.approx(0.0),  # - ((-0.2) + (0.2)) / 2
        ),
        # Scenario 3: Missing metrics in candidate
        (
            True,
            {"power": 0.9, "area": 90.0},  # Missing eff_clk_period
            {"power": 1.0, "area": 100.0, "eff_clk_period": 2.0},
            0,  # Should return 0 if any metric is missing
        ),
    ],
)
def test_calculate_fitness_score(
    mocker, is_sequential, ppa_metrics, ref_metrics, expected_score
):
    """
    Tests the fitness score calculation for different PPA scenarios.
    """
    # Arrange: Mock the parts of EoHEngine that are not under test
    mocker.patch.object(EoHEngine, "load_problem_description", return_value="fake desc")

    # We only need a mock SynthesisEvaluator to get the clk_period
    mock_synth_eval = MagicMock()
    mock_synth_eval.clk_period = 2.0 if is_sequential else 0.0

    engine = EoHEngine(
        benchmark_name="test_bench",
        problem_name="test_prob",
        llm_interface=MagicMock(),
        verilog_evaluator=MagicMock(),
        synthesis_evaluator=mock_synth_eval,
    )
    engine.ref_ppa_metrics = ref_metrics

    candidate = Heuristic(thought="", code="", feedback="")
    candidate.ppa_success = True
    candidate.ppa_metrics = ppa_metrics

    # Action
    score = engine._calculate_fitness_score(candidate)

    # Assert
    assert score == expected_score
