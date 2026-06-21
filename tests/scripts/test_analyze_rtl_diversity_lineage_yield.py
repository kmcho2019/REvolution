from __future__ import annotations

import importlib.util
import json
import sys
from pathlib import Path

import pandas as pd

_SCRIPT = (
    Path(__file__).resolve().parent.parent.parent
    / "scripts"
    / "analyze_rtl_diversity_lineage_yield.py"
)
_SPEC = importlib.util.spec_from_file_location(
    "analyze_rtl_diversity_lineage_yield", _SCRIPT
)
assert _SPEC is not None and _SPEC.loader is not None
mod = importlib.util.module_from_spec(_SPEC)
sys.modules.setdefault("analyze_rtl_diversity_lineage_yield", mod)
_SPEC.loader.exec_module(mod)


def test_lineage_yield_expands_parent_edges(tmp_path):
    root = tmp_path / "main_screening_screening_seed3"
    problem = (
        root
        / "method_a"
        / "seed_1001"
        / "revolution"
        / "openai_gpt-oss-120b"
        / "RTLLM"
        / "ProbA"
    )
    problem.mkdir(parents=True)
    archive = problem / "archive_cells.csv"
    pd.DataFrame(
        [
            _row("parent_a", [], 0, "initial", 0.1, "cell_a"),
            _row("parent_b", [], 0, "initial", 0.2, "cell_b"),
            _row("child", ["parent_a", "parent_b"], 1, "C-D", 0.5, "cell_c"),
        ]
    ).to_csv(archive, index=False)
    audit_csv = tmp_path / "lineage_source_files.csv"
    pd.DataFrame(
        [
            {
                "root": root.as_posix(),
                "path": archive.as_posix(),
                "relative_path": archive.relative_to(root).as_posix(),
                "lineage_nonempty_cells": 1,
            }
        ]
    ).to_csv(audit_csv, index=False)

    edges = mod.lineage_edges(audit_csv)
    parent_rows = mod.parent_yield_rows(edges)
    aggregate = mod.aggregate_rows(edges)

    assert len(edges) == 2
    assert all(edge["parent_found"] for edge in edges)
    assert {edge["quality_delta"] for edge in edges} == {0.3, 0.4}
    assert len(parent_rows) == 2
    assert aggregate[0]["edge_count"] == 2
    assert aggregate[0]["new_cell_edges"] == 2


def _row(
    candidate_id: str,
    parent_ids: list[str],
    generation: int,
    strategy: str,
    quality: float,
    cell_id: str,
) -> dict[str, object]:
    return {
        "cell_id": cell_id,
        "candidate_id": candidate_id,
        "quality_score": quality,
        "generation": generation,
        "strategy": strategy,
        "pareto_rank": 1,
        "parent_ids_json": json.dumps(parent_ids),
    }
