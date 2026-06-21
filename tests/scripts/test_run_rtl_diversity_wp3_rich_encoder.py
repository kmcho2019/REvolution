from __future__ import annotations

import importlib.util
import sys
from pathlib import Path

import pandas as pd

_SCRIPT = (
    Path(__file__).resolve().parent.parent.parent
    / "scripts"
    / "run_rtl_diversity_wp3_rich_encoder.py"
)
_SPEC = importlib.util.spec_from_file_location(
    "run_rtl_diversity_wp3_rich_encoder", _SCRIPT
)
assert _SPEC is not None and _SPEC.loader is not None
mod = importlib.util.module_from_spec(_SPEC)
sys.modules.setdefault("run_rtl_diversity_wp3_rich_encoder", mod)
_SPEC.loader.exec_module(mod)


def test_run_diagnostic_uses_implementation_features_without_ppa_inputs(tmp_path):
    candidate_audit = tmp_path / "candidate_audit.parquet"
    rows = [
        _row("ProbA", 0, 0.9, True, "[1.0, 0.0, 0.0]", "control_if"),
        _row("ProbA", 1, 0.8, True, "[0.8, 0.1, 0.0]", "control_if"),
        _row("ProbB", 0, 0.7, True, "[0.0, 1.0, 0.0]", "wire_assign"),
        _row("ProbB", 1, 0.6, True, "[0.0, 0.8, 0.2]", "wire_assign"),
        _row("ProbC", 0, 0.5, True, "[0.0, 0.0, 1.0]", "mux_ternary"),
        _row("ProbC", 1, 0.4, True, "[0.1, 0.0, 0.9]", "mux_ternary"),
        _row("ProbD", 0, 0.0, False, "[]", "invalid_no_ppa"),
        _row("ProbD", 1, 0.0, False, "[]", "invalid_no_ppa"),
    ]
    pd.DataFrame(rows).to_parquet(candidate_audit, index=False)

    summary = mod.run_diagnostic(
        candidate_audit=candidate_audit,
        output_dir=tmp_path / "wp3",
        latent_dims=(2, 3),
    )

    assert summary["family"] == "aurora_rich_implementation_linear_autoencoder_probe"
    assert summary["candidate_count"] == 8
    assert summary["valid_ppa_candidate_count"] == 6
    assert "fitness" in summary["forbidden_training_inputs"]
    assert "fitness" not in summary["fitting_inputs"]
    assert "valid_ppa" not in summary["fitting_inputs"]
    assert len(summary["encoders"]) == 2
    assert summary["comparison"]["verdict"] in {
        "diagnostic_follow_up",
        "diagnostic_only_no_proceed",
    }
    replay = pd.read_csv(tmp_path / "wp3" / "wp3_rich_encoder_replay.csv")
    assert set(replay["representation"]) == {
        "implementation_z",
        "rich_ae2",
        "rich_ae3",
    }
    assert (tmp_path / "wp3" / "wp3_rich_encoder_card.md").is_file()
    assert (tmp_path / "wp3" / "wp3_rich_encoder_feature_manifest.csv").is_file()


def _row(
    problem_id: str,
    generation: int,
    fitness: float,
    valid_ppa: bool,
    descriptor_vector: str,
    style_cluster: str,
) -> dict[str, object]:
    row = {
        "corpus": "toy",
        "descriptor_family": "lexical",
        "method": "classic",
        "seed": 1,
        "problem_id": problem_id,
        "generation": generation,
        "candidate_id": f"{problem_id}_{generation}",
        "valid_ppa": valid_ppa,
        "syntax_pass": True,
        "functionality_pass": valid_ppa,
        "synthesis_pass": valid_ppa,
        "area": 10.0 - fitness,
        "power": 5.0 - fitness,
        "eff_clk_period": 2.0 - fitness / 10.0,
        "fitness": fitness if valid_ppa else None,
        "reference_ppa_json": '{"area": 12.0, "power": 6.0, "eff_clk_period": 2.4}',
        "descriptor_vector": descriptor_vector,
        "canonical_netlist_hash": f"canon_{problem_id}_{generation}"
        if valid_ppa
        else "",
        "motif_signature_hash": f"motif_{problem_id}_{generation}" if valid_ppa else "",
        "motif_vector": (
            '{"motif_arith_ratio": 0.1, "motif_control_ratio": 0.2, '
            '"motif_diversity": 0.3, "motif_logic_ratio": 0.4}'
            if valid_ppa
            else ""
        ),
        "style_cluster": style_cluster,
    }
    for feature in mod.LEXICAL_FEATURES:
        row[feature] = float(generation + 1)
    return row
