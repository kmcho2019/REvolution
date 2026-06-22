from __future__ import annotations

import csv
import importlib.util
import json
import sys
from pathlib import Path

_SCRIPT = (
    Path(__file__).resolve().parent.parent.parent
    / "scripts"
    / "package_t33_qwen_ladder_inventory.py"
)
_SPEC = importlib.util.spec_from_file_location("package_t33_qwen_ladder_inventory", _SCRIPT)
assert _SPEC is not None and _SPEC.loader is not None
mod = importlib.util.module_from_spec(_SPEC)
sys.modules.setdefault("package_t33_qwen_ladder_inventory", mod)
_SPEC.loader.exec_module(mod)


def test_package_t33_inventory_writes_source_tables(tmp_path: Path) -> None:
    qwen_dir = tmp_path / "qwen"
    compiled = tmp_path / "compiled"
    output_dir = tmp_path / "technique"
    qwen_dir.mkdir()
    _write_live_qwen(qwen_dir)
    _write_compiled_bundle(compiled)

    code = mod.main(
        [
            "--qwen-dir",
            str(qwen_dir),
            "--compiled-bundle-dir",
            str(compiled),
            "--output-dir",
            str(output_dir),
        ]
    )

    assert code == 0
    inventory = _read_csv(output_dir / "tables" / "t33_source_inventory.csv")
    summary = _read_csv(output_dir / "tables" / "t33_prior_qwen_summary.csv")
    plan = _read_csv(output_dir / "tables" / "t33_preprocessing_ladder_plan.csv")

    assert len(inventory) == 15
    assert {row["source_group"] for row in inventory} == {"live_qwen_dir", "compiled_bundle"}
    assert {"raw_rtl", "canonical_yosys_netlist", "summary_plus_netlist"} <= {
        row["view"] for row in plan
    }
    assert _by_metric(summary, "same_problem_nearest_fraction") == "0.75"
    assert _by_metric(summary, "embedding_shape_qwen_raw") == "4x3"


def _write_live_qwen(qwen_dir: Path) -> None:
    (qwen_dir / "qwen_common_audit_summary.json").write_text(
        json.dumps(
            {
                "aggregate": [
                    _aggregate("lexical_farthest", 1.0, 0.0),
                    _aggregate("qwen_identifier_farthest", 1.1, 0.1),
                    _aggregate("qwen_raw_farthest", 0.9, -0.1),
                ],
                "candidate_count": 4,
                "embedding_shapes": {"qwen_raw": [4, 3]},
                "model_id": "Qwen/test",
                "nearest": {
                    "cosine_mean": 0.9,
                    "same_canonical_netlist_count": 1,
                    "same_corpus_fraction": 0.5,
                    "same_motif_signature_count": 2,
                    "same_problem_fraction": 0.75,
                },
                "problem_count": 2,
                "replay_rows": 4,
                "retention_fraction": 0.5,
                "stability": {
                    "raw_to_comment_cosine_mean": 0.95,
                    "raw_to_identifier_cosine_mean": 0.65,
                },
                "text_max_chars": 128,
                "truncated_text_count": 0,
            }
        ),
        encoding="utf-8",
    )
    for name, _role in mod.LIVE_QWEN_FILES:
        path = qwen_dir / name
        if path.exists():
            continue
        path.write_bytes(b"test")


def _write_compiled_bundle(compiled: Path) -> None:
    for relative_path, _role in mod.COMPILED_FILES:
        path = compiled / relative_path
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text("compiled\n", encoding="utf-8")


def _aggregate(representation: str, hypervolume: float, gain: float) -> dict[str, object]:
    return {
        "representation": representation,
        "selected_hypervolume": hypervolume,
        "vs_lexical_hv_gain_fraction": gain,
    }


def _read_csv(path: Path) -> list[dict[str, str]]:
    with path.open(encoding="utf-8", newline="") as handle:
        return list(csv.DictReader(handle))


def _by_metric(rows: list[dict[str, str]], metric: str) -> str:
    matches = [row for row in rows if row["metric"] == metric]
    assert len(matches) == 1
    return matches[0]["value"]
