from __future__ import annotations

from pathlib import Path

from scripts.package_yosys_sog_audit import assign_cells, feature_from_json


def test_feature_from_json_counts_operator_groups(tmp_path: Path) -> None:
    code = tmp_path / "code.sv"
    code.write_text("module top; endmodule\n", encoding="utf-8")

    feature = feature_from_json(_candidate_row(code), _yosys_json())

    assert feature.module_count == 1
    assert feature.cell_count == 6
    assert feature.operator_count == 5
    assert feature.module_instance_count == 1
    assert feature.arith_count == 2
    assert feature.mul_count == 1
    assert feature.mux_count == 1
    assert feature.compare_count == 1
    assert feature.state_count == 1
    assert feature.sog_complexity_score > feature.operator_count


def test_problem_cell_scope_assigns_cells_per_problem(tmp_path: Path) -> None:
    features = []
    for problem in ("Prob001_accu", "Prob002_adder_16bit"):
        for index in range(4):
            code = tmp_path / f"{problem}_{index}.sv"
            code.write_text("module top; endmodule\n", encoding="utf-8")
            row = _candidate_row(code)
            row["problem"] = problem
            payload = _yosys_json(extra_adders=index)
            features.append(feature_from_json(row, payload))

    assigned = assign_cells(features, "problem")
    by_problem = {
        problem: sorted(feature.sog_cell for feature in assigned if feature.problem == problem)
        for problem in ("Prob001_accu", "Prob002_adder_16bit")
    }

    assert by_problem["Prob001_accu"] == by_problem["Prob002_adder_16bit"]
    assert len(set(by_problem["Prob001_accu"])) > 1


def _candidate_row(code_path: Path) -> dict[str, str]:
    return {
        "method": "classic_revolution",
        "method_label": "Classic",
        "problem": "Prob001_accu",
        "candidate_id": code_path.stem,
        "generation": "0",
        "objective_metrics": "area|power",
        "is_pareto_front": "true",
        "beats_reference": "false",
        "area": "10",
        "power": "1",
        "eff_clk_period": "",
        "rtl_hash": "rtl",
        "netlist_hash": "netlist",
        "family_hash": "family",
        "family_signature": "AND2_X1:1",
        "code_file_path": str(code_path),
    }


def _yosys_json(extra_adders: int = 0) -> dict[str, object]:
    cells = {
        "add0": _cell("$add", 4),
        "mul0": _cell("$mul", 8),
        "mux0": _cell("$mux", 3),
        "eq0": _cell("$eq", 2),
        "reg0": _cell("$sdff", 4),
        "u0": _cell("half_adder", 2),
    }
    for index in range(extra_adders):
        cells[f"add{index + 1}"] = _cell("$add", 4)
    return {
        "modules": {
            "top": {
                "ports": {"a": {"bits": [1, 2]}, "y": {"bits": [3]}},
                "netnames": {"a": {"bits": [1, 2]}, "y": {"bits": [3]}},
                "memories": {},
                "cells": cells,
            }
        }
    }


def _cell(cell_type: str, bit_count: int) -> dict[str, object]:
    return {"type": cell_type, "connections": {"A": list(range(bit_count)), "Y": [99]}}
