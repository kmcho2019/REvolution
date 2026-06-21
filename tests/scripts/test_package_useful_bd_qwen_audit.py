from __future__ import annotations

import csv
import importlib.util
import json
import sys
from pathlib import Path

_SCRIPT = (
    Path(__file__).resolve().parent.parent.parent
    / "scripts"
    / "package_useful_bd_qwen_audit.py"
)
_SPEC = importlib.util.spec_from_file_location("package_useful_bd_qwen_audit", _SCRIPT)
assert _SPEC is not None and _SPEC.loader is not None
mod = importlib.util.module_from_spec(_SPEC)
sys.modules.setdefault("package_useful_bd_qwen_audit", mod)
_SPEC.loader.exec_module(mod)


def test_package_qwen_audit_writes_tables_and_figures(tmp_path: Path) -> None:
    qwen_dir = tmp_path / "qwen"
    qwen_dir.mkdir()
    _write_qwen_artifacts(qwen_dir)

    technique_dir = tmp_path / "technique"
    code = mod.main(["--qwen-dir", str(qwen_dir), "--technique-dir", str(technique_dir)])

    assert code == 0
    assert (technique_dir / "tables" / "qwen_embedding_manifest.csv").is_file()
    assert (technique_dir / "tables" / "qwen_vs_lexical_deltas.csv").is_file()
    assert (technique_dir / "figures" / "qwen_replay_hypervolume.png").read_bytes().startswith(
        b"\x89PNG"
    )
    assert (technique_dir / "figures" / "qwen_collapse_diagnostics.png").read_bytes().startswith(
        b"\x89PNG"
    )


def _write_qwen_artifacts(qwen_dir: Path) -> None:
    summary = {
        "artifact_sha256": {
            "qwen_comment_stripped_embeddings.npy": "comment_hash",
            "qwen_identifier_normalized_embeddings.npy": "identifier_hash",
            "qwen_raw_embeddings.npy": "raw_hash",
        },
        "candidate_count": 4,
        "embedding_shapes": {
            "qwen_comment_stripped": [4, 3],
            "qwen_identifier_normalized": [4, 3],
            "qwen_raw": [4, 3],
        },
        "model_id": "Qwen/test",
        "nearest": {
            "cosine_mean": 0.9,
            "same_corpus_fraction": 0.5,
            "same_problem_fraction": 0.75,
        },
        "problem_count": 2,
        "stability": {
            "raw_to_comment_cosine_mean": 0.95,
            "raw_to_identifier_cosine_mean": 0.65,
        },
        "text_max_chars": 128,
        "truncated_text_count": 0,
    }
    (qwen_dir / "qwen_common_audit_summary.json").write_text(json.dumps(summary), encoding="utf-8")
    _write_csv(
        qwen_dir / "qwen_common_audit_aggregate.csv",
        [
            _aggregate("lexical_farthest", 1.0, 10, 0.4, 5, 4),
            _aggregate("qwen_identifier_farthest", 1.1, 11, 0.45, 6, 5),
            _aggregate("qwen_raw_farthest", 0.9, 12, 0.35, 7, 6),
        ],
    )
    _write_csv(
        qwen_dir / "qwen_common_audit_nearest.csv",
        [
            {
                "sample_index": "0",
                "same_canonical_netlist": "True",
                "same_corpus": "True",
                "same_motif_signature": "False",
                "same_problem": "True",
            },
            {
                "sample_index": "1",
                "same_canonical_netlist": "False",
                "same_corpus": "False",
                "same_motif_signature": "True",
                "same_problem": "False",
            },
        ],
    )
    _write_csv(
        qwen_dir / "qwen_common_audit_stability.csv",
        [
            {
                "sample_index": "0",
                "raw_to_comment_cosine": "0.95",
                "raw_to_identifier_cosine": "0.65",
            }
        ],
    )


def _aggregate(
    representation: str,
    hypervolume: float,
    pareto_size: int,
    best_fitness: float,
    canonical_count: int,
    motif_count: int,
) -> dict[str, object]:
    return {
        "baseline_best_fitness": "0.5",
        "baseline_hypervolume": "1.2",
        "baseline_pareto_size": "20",
        "problem_group_count": "2",
        "representation": representation,
        "selected_best_fitness": str(best_fitness),
        "selected_count": "2",
        "selected_hypervolume": str(hypervolume),
        "selected_pareto_size": str(pareto_size),
        "unique_canonical_netlists": str(canonical_count),
        "unique_motif_signatures": str(motif_count),
        "valid_ppa_count": "4",
        "vs_lexical_hv_gain_fraction": "0.0",
        "vs_lexical_pareto_gain_fraction": "0.0",
    }


def _write_csv(path: Path, rows: list[dict[str, object]]) -> None:
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(rows[0]), lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)
