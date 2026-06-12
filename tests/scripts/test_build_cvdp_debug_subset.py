from __future__ import annotations

import importlib.util
import json
import sys
from pathlib import Path

import yaml

_SCRIPT_PATH = (
    Path(__file__).resolve().parent.parent.parent
    / "scripts"
    / "build_cvdp_debug_subset.py"
)
_SPEC = importlib.util.spec_from_file_location("build_cvdp_debug_subset", _SCRIPT_PATH)
assert _SPEC is not None and _SPEC.loader is not None
build_cvdp_debug_subset = importlib.util.module_from_spec(_SPEC)
sys.modules.setdefault("build_cvdp_debug_subset", build_cvdp_debug_subset)
_SPEC.loader.exec_module(build_cvdp_debug_subset)


def _write_dataset(tmp_path: Path) -> Path:
    records = [
        {"id": "cvdp_a_0001", "categories": ["cid002", "medium"]},
        {"id": "cvdp_a_0002", "categories": ["cid002", "medium"]},
        {"id": "cvdp_a_0003", "categories": ["cid002", "easy"]},
        {"id": "cvdp_b_0001", "categories": ["cid003", "medium"]},
        {"id": "cvdp_b_0002", "categories": ["cid003", "medium"]},
        {"id": "cvdp_b_0003", "categories": ["cid003", "medium"]},
        {"id": "cvdp_c_0001", "categories": ["cid016", "easy"]},
    ]
    path = tmp_path / "cvdp.jsonl"
    path.write_text(
        "\n".join(json.dumps(record) for record in records) + "\n",
        encoding="utf-8",
    )
    return path


def test_select_balanced_subset_is_deterministic_and_balanced(tmp_path):
    dataset = _write_dataset(tmp_path)

    first = build_cvdp_debug_subset.select_balanced_subset(
        jsonl_path=dataset, difficulty="medium", per_category=2, seed=42
    )
    second = build_cvdp_debug_subset.select_balanced_subset(
        jsonl_path=dataset, difficulty="medium", per_category=2, seed=42
    )

    assert first == second
    assert set(first) == {"cid002", "cid003"}
    assert len(first["cid002"]) == 2
    assert len(first["cid003"]) == 2
    assert all(pid.startswith("cvdp_a") for pid in first["cid002"])


def test_select_balanced_subset_changes_with_seed(tmp_path):
    dataset = _write_dataset(tmp_path)

    seeds = {
        seed: build_cvdp_debug_subset.select_balanced_subset(
            jsonl_path=dataset, difficulty="medium", per_category=1, seed=seed
        )["cid003"]
        for seed in range(8)
    }

    assert len({tuple(ids) for ids in seeds.values()}) > 1


def test_main_writes_locked_manifest_with_provenance(tmp_path, capsys):
    dataset = _write_dataset(tmp_path)
    output = tmp_path / "configs" / "cvdp_debug_subset.yaml"

    code = build_cvdp_debug_subset.main(
        [
            "--cvdp_jsonl",
            str(dataset),
            "--output-config",
            str(output),
            "--per-category",
            "2",
            "--seed",
            "42",
        ]
    )

    assert code == 0
    payload = yaml.safe_load(output.read_text(encoding="utf-8"))
    assert payload["version"] == 1
    assert payload["subset_name"] == "cvdp_debug_subset_v1"
    assert payload["selection"]["difficulty"] == "medium"
    assert payload["selection"]["seed"] == 42
    assert len(payload["selection"]["dataset_sha256"]) == 64
    assert payload["selection"]["subset_size"] == 4
    problems = payload["benchmarks"]["cvdp"]["problems"]
    assert sorted(problems) == problems
    assert len(problems) == 4
    flattened = sorted(
        pid for ids in payload["categories"].values() for pid in ids
    )
    assert flattened == problems
    out = capsys.readouterr().out
    assert "Locked CVDP debug subset: 4 tasks" in out


def test_main_fails_cleanly_on_missing_difficulty(tmp_path, capsys):
    dataset = _write_dataset(tmp_path)
    output = tmp_path / "out.yaml"

    code = build_cvdp_debug_subset.main(
        [
            "--cvdp_jsonl",
            str(dataset),
            "--output-config",
            str(output),
            "--difficulty",
            "hard",
        ]
    )

    assert code == 2
    assert not output.exists()


def test_exclude_config_removes_locked_ids(tmp_path):
    dataset = _write_dataset(tmp_path)
    locked = tmp_path / "locked.yaml"
    locked.write_text(
        yaml.safe_dump(
            {"benchmarks": {"cvdp": {"problems": ["cvdp_b_0002", "cvdp_b_0003"]}}}
        ),
        encoding="utf-8",
    )

    exclude_ids = build_cvdp_debug_subset.load_excluded_ids([locked])
    assert exclude_ids == frozenset({"cvdp_b_0002", "cvdp_b_0003"})

    selection = build_cvdp_debug_subset.select_balanced_subset(
        jsonl_path=dataset,
        difficulty="medium",
        per_category=2,
        seed=42,
        exclude_ids=exclude_ids,
    )
    selected = {pid for ids in selection.values() for pid in ids}
    assert selected.isdisjoint(exclude_ids)
    assert selection["cid003"] == ["cvdp_b_0001"]


def test_main_records_exclusion_provenance(tmp_path, capsys):
    dataset = _write_dataset(tmp_path)
    locked = tmp_path / "locked.yaml"
    locked.write_text(
        yaml.safe_dump({"benchmarks": {"cvdp": {"problems": ["cvdp_a_0001"]}}}),
        encoding="utf-8",
    )
    output = tmp_path / "fresh.yaml"

    rc = build_cvdp_debug_subset.main(
        [
            "--cvdp_jsonl", str(dataset),
            "--output-config", str(output),
            "--subset-name", "cvdp_final_30_v1",
            "--seed", "1337",
            "--exclude-config", str(locked),
        ]
    )
    assert rc == 0
    payload = yaml.safe_load(output.read_text(encoding="utf-8"))
    assert payload["selection"]["excluded_id_count"] == 1
    assert payload["selection"]["excluded_configs"] == [str(locked)]
    assert "cvdp_a_0001" not in payload["benchmarks"]["cvdp"]["problems"]
