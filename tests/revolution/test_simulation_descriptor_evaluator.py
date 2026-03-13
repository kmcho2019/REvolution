from pathlib import Path

import pytest

from revolution.simulation_descriptor_evaluator import SimulationDescriptorEvaluator


def test_simulation_descriptor_evaluator_extracts_activity_metrics(tmp_path: Path):
    vcd_path = tmp_path / "activity.vcd"
    vcd_path.write_text(
        "\n".join(
            [
                "$timescale 1ns $end",
                "$scope module tb $end",
                "$var wire 1 ! clk $end",
                "$scope module dut $end",
                "$var wire 1 \" a $end",
                "$var wire 1 # y $end",
                "$upscope $end",
                "$upscope $end",
                "$enddefinitions $end",
                "#0",
                "0!",
                "0\"",
                "0#",
                "#5",
                "1\"",
                "#10",
                "1#",
                "#15",
                "0\"",
                "#20",
                "0#",
            ]
        ),
        encoding="utf-8",
    )

    metrics = SimulationDescriptorEvaluator().extract_metrics(
        vcd_file_path=vcd_path,
        top_module_name="tb",
    )

    assert metrics["tracked_signal_count_est"] == pytest.approx(2.0)
    assert metrics["active_signal_ratio_est"] == pytest.approx(1.0)
    assert metrics["toggle_count_log_est"] > 0.0
    assert metrics["toggle_density_est"] == pytest.approx(2.0)
    assert metrics["avg_toggle_rate_est"] > 0.0
    assert metrics["vcd_time_span_est"] == pytest.approx(20.0)


def test_simulation_descriptor_evaluator_returns_zero_metrics_when_missing_file(tmp_path: Path):
    metrics = SimulationDescriptorEvaluator().extract_metrics(
        vcd_file_path=tmp_path / "missing.vcd",
        top_module_name="tb",
    )

    assert metrics["tracked_signal_count_est"] == pytest.approx(0.0)
    assert metrics["active_signal_ratio_est"] == pytest.approx(0.0)
    assert metrics["toggle_count_log_est"] == pytest.approx(0.0)
