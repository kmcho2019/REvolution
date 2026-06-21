from __future__ import annotations

import importlib.util
import sys
from pathlib import Path

import pandas as pd

_SCRIPT = (
    Path(__file__).resolve().parent.parent.parent
    / "scripts"
    / "analyze_rtl_diversity_budget_funnels.py"
)
_SPEC = importlib.util.spec_from_file_location(
    "analyze_rtl_diversity_budget_funnels", _SCRIPT
)
assert _SPEC is not None and _SPEC.loader is not None
mod = importlib.util.module_from_spec(_SPEC)
sys.modules.setdefault("analyze_rtl_diversity_budget_funnels", mod)
_SPEC.loader.exec_module(mod)


def test_budget_funnel_curves_track_prefix_and_validity():
    frame = pd.DataFrame(
        [
            _row("a", 0, "style_a", True, True, True, True, False, 0.1),
            _row("b", 1, "style_b", True, True, True, True, True, 0.5),
            _row("c", 2, "style_b", True, True, False, False, False, 0.0),
            _row("d", 3, "style_c", True, False, True, False, False, 0.0),
        ]
    )

    curves = mod.budget_funnel_curves(frame)
    aggregate = mod.aggregate_curves(curves)

    half_valid = [
        row
        for row in curves
        if row["budget_fraction"] == 0.5 and row["funnel"] == "valid_ppa"
    ][0]
    full_generated = [
        row
        for row in curves
        if row["budget_fraction"] == 1.0 and row["funnel"] == "generated"
    ][0]
    full_synthesis = [
        row
        for row in curves
        if row["budget_fraction"] == 1.0 and row["funnel"] == "synthesis_valid"
    ][0]
    full_pareto = [
        row
        for row in curves
        if row["budget_fraction"] == 1.0 and row["funnel"] == "pareto_front"
    ][0]

    assert half_valid["prefix_candidate_count"] == 2
    assert half_valid["candidate_count"] == 2
    assert half_valid["unique_style_clusters"] == 2
    assert half_valid["best_fitness"] == 0.5
    assert full_generated["candidate_count"] == 4
    assert full_generated["unique_style_clusters"] == 3
    assert full_synthesis["candidate_count"] == 2
    assert full_pareto["candidate_count"] == 1
    assert aggregate


def _row(
    candidate_id: str,
    generation: int,
    style_cluster: str,
    syntax_pass: bool,
    functionality_pass: bool,
    synthesis_pass: bool,
    valid_ppa: bool,
    pareto_member: bool,
    fitness: float,
) -> dict[str, object]:
    return {
        "corpus": "toy",
        "descriptor_family": "lexical",
        "method": "classic",
        "seed": 1,
        "model": "model",
        "benchmark": "bench",
        "problem_id": "bench/ProbA",
        "generation": generation,
        "candidate_id": candidate_id,
        "syntax_pass": syntax_pass,
        "functionality_pass": functionality_pass,
        "synthesis_pass": synthesis_pass,
        "valid_ppa": valid_ppa,
        "pareto_member": pareto_member,
        "style_cluster": style_cluster,
        "canonical_netlist_hash": f"canon_{candidate_id}" if valid_ppa else "",
        "motif_signature_hash": f"motif_{candidate_id}" if valid_ppa else "",
        "fitness": fitness,
    }
