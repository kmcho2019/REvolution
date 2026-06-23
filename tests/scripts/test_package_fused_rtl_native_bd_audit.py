from __future__ import annotations

import csv
from pathlib import Path

from scripts.package_fused_rtl_native_bd_audit import assign_cells, join_features, main


def test_join_features_requires_matched_candidate_rows() -> None:
    rows = [_sog_row("a", "classic_revolution", "Classic")]
    features = join_features(rows, [_timing_row("a", "classic_revolution", "Classic")])

    assert len(features) == 1
    assert features[0].candidate_id == "a"
    assert features[0].timing_risk_score == 3.0


def test_assign_cells_adds_all_profile_cells() -> None:
    features = []
    for index in range(4):
        row = _sog_row(str(index), "classic_revolution", "Classic")
        row["operator_mix_score"] = str(index)
        timing = _timing_row(str(index), "classic_revolution", "Classic")
        timing["timing_risk_score"] = str(index)
        features.extend(join_features([row], [timing]))

    assigned = assign_cells(features)

    assert {feature.operator_timing_cell for feature in assigned} == {"0,0", "1,1", "2,2", "3,3"}
    assert all(feature.state_pipeline_cell for feature in assigned)
    assert all(feature.complexity_entropy_cell for feature in assigned)


def test_package_fused_rtl_native_bd_audit(tmp_path: Path) -> None:
    sog = tmp_path / "sog.csv"
    timing = tmp_path / "timing.csv"
    completeness = tmp_path / "ppa_completeness.csv"
    output = tmp_path / "t62"
    _write_csv(
        sog,
        [
            _sog_row("c0", "classic_revolution", "Classic"),
            _sog_row("q0", "sr_raw_conservative_exploit_qd", "Exact T26 QD"),
        ],
    )
    _write_csv(
        timing,
        [
            _timing_row("c0", "classic_revolution", "Classic"),
            _timing_row("q0", "sr_raw_conservative_exploit_qd", "Exact T26 QD"),
        ],
    )
    completeness.write_text("problem,comparison_status\nProb001_accu,headline\n", encoding="utf-8")

    assert main(
        [
            "--sog-features",
            str(sog),
            "--timing-features",
            str(timing),
            "--ppa-completeness",
            str(completeness),
            "--output-dir",
            str(output),
        ]
    ) == 0

    assert (output / "tables" / "fused_rtl_features.csv").is_file()
    assert (output / "tables" / "profile_delta_summary.csv").is_file()
    assert (output / "tables" / "ppa_completeness.csv").is_file()
    assert (output / "figures" / "profile_cell_delta_summary.png").read_bytes().startswith(b"\x89PNG")
    assert (output / "figures" / "best_profile_archive_heatmap.png").read_bytes().startswith(b"\x89PNG")


def _sog_row(candidate_id: str, method: str, label: str) -> dict[str, str]:
    return {
        "method": method,
        "method_label": label,
        "problem": "Prob001_accu",
        "candidate_id": candidate_id,
        "generation": "0",
        "is_pareto_front": "true",
        "operator_mix_score": "1.0",
        "state_control_ratio": "2.0",
        "sog_complexity_score": "4.0",
        "sog_entropy": "0.5",
        "code_file_path": "/tmp/code.sv",
    }


def _timing_row(candidate_id: str, method: str, label: str) -> dict[str, str]:
    return {
        "method": method,
        "method_label": label,
        "problem": "Prob001_accu",
        "candidate_id": candidate_id,
        "generation": "0",
        "is_pareto_front": "true",
        "timing_risk_score": "3.0",
        "control_pipeline_ratio": "1.5",
        "timing_risk_entropy": "0.25",
        "code_file_path": "/tmp/code.sv",
    }


def _write_csv(path: Path, rows: list[dict[str, str]]) -> None:
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(rows[0]), lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)
