from __future__ import annotations

import importlib.util
import sys
from pathlib import Path

import pandas as pd

_SCRIPT = (
    Path(__file__).resolve().parent.parent.parent
    / "scripts"
    / "run_rtl_diversity_wp3_learned_encoder.py"
)
_SPEC = importlib.util.spec_from_file_location(
    "run_rtl_diversity_wp3_learned_encoder", _SCRIPT
)
assert _SPEC is not None and _SPEC.loader is not None
mod = importlib.util.module_from_spec(_SPEC)
sys.modules.setdefault("run_rtl_diversity_wp3_learned_encoder", mod)
_SPEC.loader.exec_module(mod)


def test_run_diagnostic_writes_leakage_safe_outputs(tmp_path):
    artifact_dir = tmp_path / "wp0"
    artifact_dir.mkdir()
    pd.DataFrame(
        [
            _row("ProbA", 0, 0.9, [0.0, 0.0, 0.0, 0.0]),
            _row("ProbA", 1, 0.8, [0.1, 0.0, 0.0, 0.0]),
            _row("ProbB", 0, 0.7, [1.0, 0.0, 0.0, 0.0]),
            _row("ProbB", 1, 0.6, [1.1, 0.0, 0.0, 0.0]),
            _row("ProbC", 0, 0.5, [0.0, 1.0, 0.0, 0.0]),
            _row("ProbC", 1, 0.4, [0.0, 1.1, 0.0, 0.0]),
        ]
    ).to_parquet(artifact_dir / "wp0_descriptor_rows.parquet", index=False)

    summary = mod.run_diagnostic(
        artifact_dir=artifact_dir,
        output_dir=tmp_path / "wp3",
        latent_dim=2,
    )

    assert summary["family"] == "aurora_linear_autoencoder_probe"
    assert summary["train_candidate_count"] == 4
    assert summary["holdout_candidate_count"] == 2
    assert "fitness" in summary["forbidden_training_inputs"]
    assert summary["comparison"]["verdict"] in {
        "diagnostic_follow_up",
        "diagnostic_only_no_proceed",
    }
    replay = pd.read_csv(tmp_path / "wp3" / "wp3_learned_encoder_replay.csv")
    assert set(replay["representation"]) == {"common_audit_z4", "aurora_linear_ae2"}
    assert (tmp_path / "wp3" / "wp3_learned_encoder_card.md").is_file()


def _row(
    problem_id: str,
    generation: int,
    fitness: float,
    vector: list[float],
) -> dict[str, object]:
    return {
        "method_name": "synthesis_trajectory_nod",
        "seed": 1001,
        "problem_id": problem_id,
        "generation": generation,
        "candidate_id": f"{problem_id}_{generation}",
        "valid_ppa": True,
        "fitness": fitness,
        "area": 1.0 + generation,
        "power": 1.0 + generation,
        "timing_or_clock_period": 1.0 + generation,
        "canonical_netlist_hash": f"canon_{problem_id}_{generation}",
        "motif_signature_hash": f"motif_{problem_id}_{generation}",
        "common_audit_cell_id": f"cell_{problem_id}_{generation}",
        "common_audit_descriptor_vector": str(vector),
    }
