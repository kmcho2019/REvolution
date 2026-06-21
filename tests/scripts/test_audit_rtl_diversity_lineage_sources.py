from __future__ import annotations

import importlib.util
import json
import sys
from pathlib import Path

import pandas as pd

_SCRIPT = (
    Path(__file__).resolve().parent.parent.parent
    / "scripts"
    / "audit_rtl_diversity_lineage_sources.py"
)
_SPEC = importlib.util.spec_from_file_location(
    "audit_rtl_diversity_lineage_sources", _SCRIPT
)
assert _SPEC is not None and _SPEC.loader is not None
mod = importlib.util.module_from_spec(_SPEC)
sys.modules.setdefault("audit_rtl_diversity_lineage_sources", mod)
_SPEC.loader.exec_module(mod)


def test_lineage_audit_counts_nested_and_tabular_edges(tmp_path):
    root = tmp_path / "root"
    problem = root / "method" / "ProblemA"
    problem.mkdir(parents=True)
    (problem / "generation_log.jsonl").write_text(
        json.dumps(
            {
                "generation": 1,
                "population_ppa_details": [
                    {
                        "id": "child_a",
                        "strategy": "M-S",
                        "parent_ids": ["parent_a", "parent_b"],
                    }
                ],
            }
        )
        + "\n",
        encoding="utf-8",
    )
    pd.DataFrame(
        [
            {
                "candidate_id": "child_b",
                "generation": 2,
                "operator_name": "M-I",
                "parent_ids_json": json.dumps(["parent_c"]),
            }
        ]
    ).to_csv(problem / "candidate_catalog.csv", index=False)

    rows = [mod.file_row(root, path) for path in mod.iter_artifact_paths(root)]
    summary = mod.build_summary(tmp_path / "out", [mod.root_row(root)], rows)

    assert summary["file_count"] == 2
    assert summary["lineage_file_count"] == 2
    assert summary["lineage_edge_count"] == 3
    assert summary["generation_file_count"] == 2
    assert summary["operator_file_count"] == 2
