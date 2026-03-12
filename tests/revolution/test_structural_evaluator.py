import pytest

from revolution.runtime.structural_evaluator import StructuralEvaluator


def test_structural_evaluator_extracts_ratios_from_cell_counts():
    evaluator = StructuralEvaluator()
    metrics = evaluator.extract_metrics(
        cell_counts={"$_DFF_P_": 4, "$_MUX_": 2, "$_AND_": 4, "$_ADD_": 1},
        ltp_noff=7,
    )

    assert metrics["seq_ratio"] == pytest.approx(4 / 11)
    assert metrics["mux_ratio"] == pytest.approx(2 / 11)
    assert metrics["adder_ratio"] == pytest.approx(1 / 11)
    assert metrics["ltp_noff"] == pytest.approx(7.0)


def test_structural_evaluator_reads_yosys_like_payload():
    evaluator = StructuralEvaluator()
    metrics = evaluator.extract_from_yosys_payload(
        {
            "modules": {
                "top": {
                    "num_cells_by_type": {"$_DFF_P_": 2, "$_MUX_": 1, "$_OR_": 3},
                    "ltp_noff": 5,
                }
            }
        }
    )

    assert metrics["sequential_cells"] == pytest.approx(2.0)
    assert metrics["combinational_cells"] == pytest.approx(4.0)
    assert metrics["ltp_noff"] == pytest.approx(5.0)
