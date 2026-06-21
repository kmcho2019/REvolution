from __future__ import annotations

import importlib.util
import json
import sys
from pathlib import Path

import pandas as pd

_SCRIPT = (
    Path(__file__).resolve().parent.parent.parent
    / "scripts"
    / "package_useful_bd_mome_pareto_audit.py"
)
_SPEC = importlib.util.spec_from_file_location("package_useful_bd_mome_pareto_audit", _SCRIPT)
assert _SPEC is not None and _SPEC.loader is not None
mod = importlib.util.module_from_spec(_SPEC)
sys.modules.setdefault("package_useful_bd_mome_pareto_audit", mod)
_SPEC.loader.exec_module(mod)


def test_mome_audit_retains_cell_tradeoffs(tmp_path: Path) -> None:
    repo_root = tmp_path / "repo"
    (repo_root / "data" / "bench" / "Bench").mkdir(parents=True)
    (repo_root / "data" / "bench" / "Bench" / "ProbA_ppa.txt").write_text(
        "tns,wns,eff_clk_period,power,area\n0,0,0,10,100\n",
        encoding="utf-8",
    )
    classic_dir = _write_result_dir(tmp_path, "classic_revolution")
    qd_dir = _write_result_dir(tmp_path, "sr_rff_pca_qd")
    central = {
        "artifact_roots": {
            "classic_revolution": classic_dir.as_posix(),
            "sr_rff_pca_qd": qd_dir.as_posix(),
        }
    }
    central_path = tmp_path / "central.json"
    central_path.write_text(json.dumps(central), encoding="utf-8")
    technique_dir = tmp_path / "technique"

    code = mod.main(
        [
            "--central-json",
            str(central_path),
            "--technique-dir",
            str(technique_dir),
            "--repo-root",
            str(repo_root),
            "--capacity",
            "4",
        ]
    )

    assert code == 0
    aggregate = pd.read_csv(technique_dir / "tables" / "aggregate.csv")
    qd = aggregate.loc[aggregate["method_name"].eq("sr_rff_pca_qd")]
    scalar = qd.loc[qd["retention_mode"].eq("scalar_cell_elite")].iloc[0]
    local = qd.loc[qd["retention_mode"].eq("bounded_local_pareto")].iloc[0]
    assert local["retained_candidate_count"] > scalar["retained_candidate_count"]
    assert local["mean_hypervolume"] > scalar["mean_hypervolume"]
    assert (technique_dir / "tables" / "retained_candidates.csv").is_file()
    assert (technique_dir / "figures" / "mome_retention_hypervolume.png").read_bytes().startswith(
        b"\x89PNG"
    )


def _write_result_dir(tmp_path: Path, method: str) -> Path:
    result_dir = tmp_path / method / "seed_1001" / "standard_results"
    result_dir.mkdir(parents=True)
    rows = [
        _candidate(method, "c1", 0, "cell_a", 80.0, 9.0, 0.60, "n1", "m1"),
        _candidate(method, "c2", 1, "cell_a", 90.0, 7.0, 0.45, "n2", "m2"),
        _candidate(method, "c3", 1, "cell_b", 95.0, 9.5, 0.20, "n3", "m3"),
        _candidate(method, "bad", 1, "cell_b", 120.0, 12.0, -0.1, "n4", "m4", valid=False),
    ]
    pd.DataFrame(rows).to_parquet(result_dir / "candidates.parquet")
    (result_dir / "method_summary.json").write_text("{}", encoding="utf-8")
    (result_dir / "run_manifest.json").write_text("{}", encoding="utf-8")
    return result_dir


def _candidate(
    method: str,
    candidate_id: str,
    generation: int,
    cell_id: str,
    area: float,
    power: float,
    fitness: float,
    netlist_hash: str,
    motif_hash: str,
    *,
    valid: bool = True,
) -> dict[str, object]:
    return {
        "method_name": method,
        "problem_id": "Bench/ProbA",
        "candidate_id": candidate_id,
        "generation": generation,
        "operator_name": "initial" if generation == 0 else "M-T",
        "common_audit_cell_id": cell_id,
        "valid_ppa": valid,
        "area": area,
        "power": power,
        "timing_or_clock_period": 0.0,
        "fitness": fitness,
        "canonical_netlist_hash": netlist_hash,
        "motif_signature_hash": motif_hash,
    }
