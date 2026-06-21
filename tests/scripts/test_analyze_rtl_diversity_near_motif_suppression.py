from __future__ import annotations

import importlib.util
import sys
from pathlib import Path

import pandas as pd

_SCRIPT = (
    Path(__file__).resolve().parent.parent.parent
    / "scripts"
    / "analyze_rtl_diversity_near_motif_suppression.py"
)
_SPEC = importlib.util.spec_from_file_location(
    "analyze_rtl_diversity_near_motif_suppression", _SCRIPT
)
assert _SPEC is not None and _SPEC.loader is not None
mod = importlib.util.module_from_spec(_SPEC)
sys.modules.setdefault("analyze_rtl_diversity_near_motif_suppression", mod)
_SPEC.loader.exec_module(mod)


def test_near_motif_suppression_uses_distance_threshold(tmp_path):
    candidate_audit = tmp_path / "candidate_audit.parquet"
    pd.DataFrame(
        [
            _row("a", 0, 0.90, [0.10, 0.20, 0.30, 0.40]),
            _row("b", 1, 0.80, [0.101, 0.20, 0.30, 0.40]),
            _row("c", 2, 0.70, [0.50, 0.20, 0.30, 0.40]),
        ]
    ).to_parquet(candidate_audit, index=False)

    summary = mod.run_analysis(candidate_audit, tmp_path / "out")

    assert summary["motif_vector_valid_count"] == 3
    rows = pd.read_csv(tmp_path / "out" / "near_motif_suppression.csv")
    strict = rows.loc[rows["motif_distance_threshold"].eq(0.0)].iloc[0]
    loose = rows.loc[rows["motif_distance_threshold"].eq(0.01)].iloc[0]
    assert strict["retained_count"] == 3
    assert loose["retained_count"] == 2
    assert loose["suppressed_near_motif_count"] == 1
    assert (tmp_path / "out" / "near_motif_suppression_report.md").is_file()


def _row(
    candidate_id: str,
    generation: int,
    fitness: float,
    motif_values: list[float],
) -> dict[str, object]:
    motif = {
        key: value for key, value in zip(mod.MOTIF_KEYS, motif_values, strict=True)
    }
    return {
        "corpus": "toy",
        "descriptor_family": "lexical",
        "method": "classic",
        "seed": 1,
        "problem_id": "ProbA",
        "generation": generation,
        "candidate_id": candidate_id,
        "valid_ppa": True,
        "motif_vector": str(motif).replace("'", '"'),
        "motif_signature_hash": f"motif_{candidate_id}",
        "canonical_netlist_hash": f"canon_{candidate_id}",
        "area": 10.0 - fitness,
        "power": 5.0 - fitness,
        "eff_clk_period": 2.0 - fitness / 10.0,
        "fitness": fitness,
        "reference_ppa_json": '{"area": 12.0, "power": 6.0, "eff_clk_period": 2.4}',
    }
