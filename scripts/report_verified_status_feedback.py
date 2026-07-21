#!/usr/bin/env python3
"""Validate and report H10 verified-status-feedback evidence."""

from __future__ import annotations

import argparse
import csv
import hashlib
import json
import math
import subprocess
import sys
from collections import Counter
from dataclasses import dataclass
from datetime import datetime
from decimal import Decimal
from pathlib import Path
from typing import Any, Literal, cast

import yaml

REPO_ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(REPO_ROOT))

from revolution.journal_stats import PairedSample, summarize_paired_metric  # noqa: E402
from scripts.report_failed_parent_repair import _completed_stage  # noqa: E402
from revolution.qd.pareto_analysis import (  # noqa: E402
    compute_candidate_improvements,
    cumulative_hypervolume_curve,
    hypervolume_auc,
    objective_metrics_for_reference,
)
from scripts.tcad_candidate_admission import (  # noqa: E402
    _load_accounting,
    _load_ledger,
    _load_worksheet,
    admission_status,
    post_arm_status,
)
from scripts.tcad_extension_gate_contract import (  # noqa: E402
    COVERAGE_SURFACES,
    CoverageSurface,
    evaluate_per_seed_coverage,
    loss_only_coverage_deficit,
)


Arm = Literal["classic", "treatment"]
Stage = Literal["smoke", "full_suite"]
FailureState = Literal[
    "treatment_missing",
    "treatment_malformed",
    "classic_infrastructure_missing",
    "classic_invalid",
]
UnitStatus = Literal[
    "complete",
    "treatment_missing",
    "treatment_malformed",
    "classic_infrastructure_missing",
    "classic_invalid",
]
UNIT_STATUSES = {
    "complete",
    "treatment_missing",
    "treatment_malformed",
    "classic_infrastructure_missing",
    "classic_invalid",
}
ARMS: tuple[Arm, ...] = ("classic", "treatment")
DEVELOPMENT_SEEDS = (1001, 1002)
FAIL_STATUSES = {
    "failed_format",
    "failed_diff",
    "failed_syntax",
    "failed_functionality",
    "failed_synthesis",
    "failed_synthesis_functionality",
}
FAIL_OPERATORS = {"M-F", "M-S", "M-E", "M-R", "M-I"}
SUCCESS_OPERATORS = {"M-S", "M-E", "M-R", "M-I", "C-F"}
TELEMETRY_FIELDS = {
    "generation",
    "candidate_id",
    "status",
    "prefix_applied",
    "critic_analysis_utf8_bytes",
    "critic_analysis_sha256",
    "consumed_feedback_utf8_bytes",
    "consumed_feedback_sha256",
    "code_feedback_sha256",
}
PROMPT_USE_FIELDS = {
    "generation",
    "parent_id",
    "feedback_utf8_bytes",
    "feedback_sha256",
    "serialized_parent_utf8_bytes",
    "serialized_parent_sha256",
    "serialized_parent_payload",
}
GOAL_ROOT = (
    REPO_ROOT
    / "docs/journal_features/revamp_history"
    / "20260720_191404_KST_tcad_revolution_extension"
)
H10_ROOT = GOAL_ROOT / "candidates/H10_verified_status_feedback"
PROGRAM_MANIFEST = GOAL_ROOT / "shared/program_manifest_v8.yaml"
PROGRAM_MANIFEST_SHA256 = (
    "26c83aa4ea6a01ef31f0757a560564c1df1c86ee42745242aad88eaf4ef83666"
)
WORKSHEET_SHA256 = "d7bd17b10e21a2acd970d43feb75603d83b57530efd27fcf38aa2323663a7378"
REPORT_MANIFEST_SHA256 = {
    (H10_ROOT / "smoke_report_manifest.yaml").resolve(): (
        "4b3b027ae0f0806d8f08f997d700acac12fa5dfd90cc6c2896318aedf7e8be2e"
    ),
    (H10_ROOT / "full_suite_report_manifest.yaml").resolve(): (
        "048e2e2cfd491d032fc88dffbffdb3cc7a75838df25082895fe5386e5a0b6aeb"
    ),
}
CONFIG_VARIANT_FIELDS = {
    "config",
    "max_active_problems",
    "num_generations",
    "problems",
    "save_path",
    "search_mode",
    "seed",
    "total_worker_slots",
}
NORMALIZED_CONFIG_SHA256 = (
    "98988daa93d8671f530ac2232f558fcec9968ab489aa40fd0f917ed9d4bc1e28"
)
RUN_CONFIG_SHA256 = {
    1: "20c8b3daf931b0b322568af61c9fa8a4ff85ab5da5fdcf56568cc8471702d490",
    5: "3a4ec607702bac8dbf53eedadfb637d2d5e952c12680834f113865de6576582a",
}
PROMPT_MANIFEST = GOAL_ROOT / "shared/default_prompt_manifest.sha256"
PROMPT_MANIFEST_SHA256 = (
    "044cc29db3bd20ecc1e00568cab74dc3efecaaf5da5a45ebbe306162b7b26a3a"
)
REFERENCE_PPA_MANIFEST = H10_ROOT / "reference_ppa_manifest.sha256"
REFERENCE_PPA_MANIFEST_SHA256 = (
    "bd883853c6f2cb3adf6bf6a000cd2af3c2011bf2cc59f740b36d20c308ca95ed"
)
IMPLEMENTATION_FILES = {
    ".devcontainer/devcontainer.json",
    "data/configs/evolution_default.yaml",
    "pyproject.toml",
    "scripts/report_verified_status_feedback.py",
    "scripts/report_failed_parent_repair.py",
    "scripts/report_tcad_smoke_synthesis.py",
    "scripts/run_backend.py",
    "scripts/tcad_candidate_admission.py",
    "scripts/tcad_extension_gate_contract.py",
    "src/revolution/algorithm.py",
    "src/revolution/backends/revolution_backend.py",
    "src/revolution/journal_stats.py",
    "src/revolution/qd/pareto_analysis.py",
    "src/revolution/verified_status_feedback/__init__.py",
    "src/revolution/verified_status_feedback/engine.py",
    "tests/scripts/test_report_verified_status_feedback.py",
    "tests/scripts/test_report_tcad_smoke_synthesis.py",
    "tests/scripts/test_run_backend.py",
    "tests/scripts/test_tcad_candidate_admission.py",
    "tests/scripts/test_tcad_extension_gate_contract.py",
    "tests/revolution/test_verified_status_feedback.py",
    "tests/revolution/test_revolution_backend.py",
    "uv.lock",
    f"{H10_ROOT.relative_to(REPO_ROOT)}/candidate_budget.yaml",
    f"{H10_ROOT.relative_to(REPO_ROOT)}/hypothesis_card.md",
    f"{H10_ROOT.relative_to(REPO_ROOT)}/full_suite_report_manifest.yaml",
    f"{H10_ROOT.relative_to(REPO_ROOT)}/full_suite_run_config.yaml",
    f"{H10_ROOT.relative_to(REPO_ROOT)}/reference_ppa_manifest.sha256",
    f"{H10_ROOT.relative_to(REPO_ROOT)}/reporter_contract.md",
    f"{H10_ROOT.relative_to(REPO_ROOT)}/smoke_report_manifest.yaml",
    f"{H10_ROOT.relative_to(REPO_ROOT)}/smoke_run_config.yaml",
    f"{(GOAL_ROOT / 'shared/arm_accounting.template.yaml').relative_to(REPO_ROOT)}",
    f"{(GOAL_ROOT / 'shared/candidate_budget.template.yaml').relative_to(REPO_ROOT)}",
    f"{(GOAL_ROOT / 'shared/cvdp_holdout_v1.yaml').relative_to(REPO_ROOT)}",
    f"{(GOAL_ROOT / 'shared/cvdp_prior_exposure.yaml').relative_to(REPO_ROOT)}",
    f"{(GOAL_ROOT / 'shared/representative_selection.csv').relative_to(REPO_ROOT)}",
    f"{(GOAL_ROOT / 'shared/wave2_budget_reference.yaml').relative_to(REPO_ROOT)}",
    f"{(GOAL_ROOT / 'shared/wave2_smoke_synthesis.json').relative_to(REPO_ROOT)}",
    f"{PROGRAM_MANIFEST.relative_to(REPO_ROOT)}",
    f"{PROMPT_MANIFEST.relative_to(REPO_ROOT)}",
    f"{(GOAL_ROOT / 'program_claims_contract_v4.md').relative_to(REPO_ROOT)}",
    f"{(GOAL_ROOT / 'wave2_methodology_addendum.md').relative_to(REPO_ROOT)}",
    f"{(GOAL_ROOT / 'wave2_provenance_amendment.md').relative_to(REPO_ROOT)}",
    "docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/RTLLM_full_suite/20260630/tables/rtllm_reference_complete_manifest.yaml",
    "docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/qd_evaluaton_exp/20260701_1155_PCN_v3_experiments/tables/rtllm_full_manifest.yaml",
}
PPA_METRICS = {"tns", "wns", "eff_clk_period", "power", "area"}


@dataclass(frozen=True)
class RunScope:
    """One exact H10 run scope consumed by the reporter."""

    stage: Stage
    raw_root: Path
    seeds: tuple[int, ...]
    problems: tuple[str, ...]
    generations: int
    ppa_problems: frozenset[str]
    failures: dict[tuple[int, Arm, str], FailureState]


def _path(value: str) -> Path:
    path = Path(value)
    return path if path.is_absolute() else REPO_ROOT / path


def _write_csv(path: Path, rows: list[dict[str, Any]]) -> None:
    assert rows
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(rows[0]), lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def _problem_names(path: Path) -> list[str]:
    payload = yaml.safe_load(path.read_text(encoding="utf-8"))
    rows = payload["selected_problems"]
    problems = [row["problem"] for row in rows]
    assert problems and len(problems) == len(set(problems))
    return problems


def _reference_ppa(problem: str) -> dict[str, float]:
    path = REPO_ROOT / "data/bench/RTLLM" / f"{problem}_ppa.txt"
    with path.open(newline="", encoding="utf-8") as handle:
        rows = list(csv.DictReader(handle))
    assert len(rows) == 1
    assert set(rows[0]) == PPA_METRICS
    return {name: float(value) for name, value in rows[0].items()}


def _validate_sha_manifest(path: Path, expected_sha256: str) -> set[str]:
    assert hashlib.sha256(path.read_bytes()).hexdigest() == expected_sha256
    entries: dict[str, str] = {}
    for line in path.read_text(encoding="utf-8").splitlines():
        digest, relative = line.split("  ", 1)
        assert relative not in entries and not Path(relative).is_absolute()
        target = (REPO_ROOT / relative).resolve()
        assert target.is_relative_to(REPO_ROOT)
        assert hashlib.sha256(target.read_bytes()).hexdigest() == digest
        entries[relative] = digest
    assert entries
    return set(entries)


def _validate_frozen_inputs(program: dict[str, Any]) -> set[str]:
    pending: list[Any] = [program]
    while pending:
        value = pending.pop()
        if isinstance(value, list):
            pending.extend(value)
            continue
        if not isinstance(value, dict):
            continue
        pending.extend(value.values())
        for digest_name, digest in value.items():
            if not isinstance(digest_name, str):
                continue
            if digest_name == "sha256":
                path_names = ("path",)
            elif digest_name.endswith("_sha256"):
                base = digest_name.removesuffix("_sha256")
                path_names = (base, f"{base}_path")
            else:
                continue
            sources = [
                value[name]
                for name in path_names
                if isinstance(value.get(name), str)
            ]
            assert len(sources) <= 1
            if not sources:
                continue
            source = sources[0]
            assert isinstance(digest, str)
            path = _path(source).resolve()
            assert path.is_relative_to(REPO_ROOT) and path.is_file()
            assert str(path.relative_to(REPO_ROOT)) in IMPLEMENTATION_FILES
            assert hashlib.sha256(path.read_bytes()).hexdigest() == digest
    for name in ("classic_core", "backend"):
        artifact = program["code"][name]
        path = _path(artifact["path"]).resolve()
        result = subprocess.run(
            ["git", "-C", str(REPO_ROOT), "hash-object", str(path)],
            capture_output=True,
            text=True,
        )
        assert result.returncode == 0 and result.stdout.strip() == artifact["git_blob"]
    environment = {
        "pyproject": REPO_ROOT / "pyproject.toml",
        "uv_lock": REPO_ROOT / "uv.lock",
        "devcontainer": REPO_ROOT / ".devcontainer/devcontainer.json",
    }
    for name, path in environment.items():
        assert hashlib.sha256(path.read_bytes()).hexdigest() == program["code"][
            "environment"
        ][f"{name}_sha256"]
    _validate_sha_manifest(PROMPT_MANIFEST, PROMPT_MANIFEST_SHA256)
    return _validate_sha_manifest(REFERENCE_PPA_MANIFEST, REFERENCE_PPA_MANIFEST_SHA256)


def _validate_implementation_manifest(path: Path) -> dict[str, str]:
    payload = yaml.safe_load(path.read_text(encoding="utf-8"))
    assert set(payload) == {"version", "candidate_id", "commit", "files"}
    assert payload["version"] == 1 and payload["candidate_id"] == "H10"
    commit = payload["commit"]
    assert (
        isinstance(commit, str)
        and len(commit) == 40
        and all(character in "0123456789abcdef" for character in commit)
    )
    resolved = subprocess.run(
        ["git", "-C", str(REPO_ROOT), "rev-parse", "--verify", f"{commit}^{{commit}}"],
        capture_output=True,
        text=True,
    )
    assert resolved.returncode == 0 and resolved.stdout.strip() == commit
    ancestor = subprocess.run(
        ["git", "-C", str(REPO_ROOT), "merge-base", "--is-ancestor", commit, "HEAD"]
    )
    assert ancestor.returncode == 0
    relative_manifest = path.resolve().relative_to(REPO_ROOT)
    tracked_manifest = subprocess.run(
        ["git", "-C", str(REPO_ROOT), "show", f"HEAD:{relative_manifest}"],
        capture_output=True,
    )
    assert tracked_manifest.returncode == 0
    assert hashlib.sha256(tracked_manifest.stdout).hexdigest() == hashlib.sha256(
        path.read_bytes()
    ).hexdigest()
    files = payload["files"]
    assert isinstance(files, dict) and set(files) == IMPLEMENTATION_FILES
    for relative, digest in files.items():
        assert (
            isinstance(digest, str)
            and len(digest) == 64
            and all(character in "0123456789abcdef" for character in digest)
        )
        assert hashlib.sha256(_path(relative).read_bytes()).hexdigest() == digest
        committed = subprocess.run(
            ["git", "-C", str(REPO_ROOT), "show", f"{commit}:{relative}"],
            capture_output=True,
        )
        assert committed.returncode == 0
        assert hashlib.sha256(committed.stdout).hexdigest() == digest
    return {
        "commit": commit,
        "path": str(path.resolve()),
        "manifest_sha256": hashlib.sha256(path.read_bytes()).hexdigest(),
    }


def _read_run_wall(
    root: Path, extra_evidence: tuple[Path, ...]
) -> tuple[float, Path, str]:
    root = root.resolve()
    stage_root = root.parent.parent
    manifest = root / "arm_evidence_manifest.sha256"
    entries: dict[Path, str] = {}
    for line in manifest.read_text(encoding="utf-8").splitlines():
        digest, relative = line.split("  ", 1)
        target = (root / relative).resolve()
        assert target.is_relative_to(stage_root) and target not in entries
        assert hashlib.sha256(target.read_bytes()).hexdigest() == digest
        entries[target] = digest
    expected = {
        path.resolve()
        for path in root.rglob("*")
        if path.is_file() and path.resolve() != manifest
    } | {path.resolve() for path in extra_evidence}
    assert set(entries) == expected
    paths = sorted(
        path for path in entries if path.name.endswith("_scheduler_telemetry.json")
    )
    assert len(paths) == 1, paths
    path = paths[0].resolve()
    wall = json.loads(path.read_text(encoding="utf-8"))["run_wall_seconds"]
    assert isinstance(wall, (int, float)) and wall > 0
    return float(wall), manifest, hashlib.sha256(manifest.read_bytes()).hexdigest()


def _read_failures(path: Path) -> dict[tuple[int, Arm, str], FailureState]:
    payload = yaml.safe_load(path.read_text(encoding="utf-8"))
    assert set(payload) == {"version", "units"} and payload["version"] == 1
    failures: dict[tuple[int, Arm, str], FailureState] = {}
    for row in payload["units"]:
        assert set(row) == {
            "seed",
            "arm",
            "problem",
            "state",
            "evidence_path",
            "evidence_sha256",
        }
        arm = row["arm"]
        state = row["state"]
        assert arm in ARMS
        match state:
            case "treatment_missing" | "treatment_malformed":
                assert arm == "treatment"
            case "classic_infrastructure_missing" | "classic_invalid":
                assert arm == "classic"
            case unknown:
                raise AssertionError(f"Unknown unit failure: {unknown}")
        evidence = _path(row["evidence_path"]).resolve()
        assert evidence.is_relative_to(path.resolve().parent)
        assert (
            hashlib.sha256(evidence.read_bytes()).hexdigest() == row["evidence_sha256"]
        )
        key = (row["seed"], arm, row["problem"])
        assert key not in failures
        failures[key] = state
    return failures


def _ledger_pass(
    stage: str,
    worksheet_path: Path,
    resource_totals: list[dict[str, Any]],
    implementation: dict[str, str],
) -> bool:
    program = yaml.safe_load(PROGRAM_MANIFEST.read_text(encoding="utf-8"))
    ledger = _path(program["wave2_resource_compliance"]["program_ledger_path"])
    worksheet = _load_worksheet(worksheet_path)
    events = _load_ledger(ledger)
    candidate = [event for event in events if event["candidate_id"] == "H10"]
    arms_by_stage = {
        "smoke": ("smoke_classic", "smoke_treatment"),
        "full_suite": (
            "smoke_classic",
            "smoke_treatment",
            "seed_1001_classic",
            "seed_1001_treatment",
            "seed_1002_classic",
            "seed_1002_treatment",
        ),
    }
    assert stage in arms_by_stage
    arm_ids = arms_by_stage[stage]
    required_events = 2 * len(arm_ids)
    if len(candidate) < required_events or (
        stage == "full_suite" and len(candidate) != required_events
    ):
        return False

    worksheet_hash = hashlib.sha256(worksheet_path.read_bytes()).hexdigest()
    first = events.index(candidate[0])
    ledger_prefix = b"".join(ledger.read_bytes().splitlines(keepends=True)[: first + 1])
    replay = events[:first]
    reported = {
        row["arm_id"]: {
            "candidates": Decimal(row["candidate_count"]),
            "calls": Decimal(row["llm_calls"]),
            "tokens": Decimal(row["llm_tokens"]),
            "synthesis": Decimal(row["synthesis_evaluations"]),
            "wall_seconds": Decimal(str(row["run_wall_seconds"])),
        }
        for row in resource_totals
    }
    resources_by_arm = {row["arm_id"]: row for row in resource_totals}
    if (
        hashlib.sha256(ledger_prefix).hexdigest()
        != program["wave2_resource_compliance"]["initial_program_ledger_sha256"]
        or set(reported) != set(arm_ids)
    ):
        return False

    previous_capture: datetime | None = None
    for index, arm_id in enumerate(arm_ids):
        admitted, completed = candidate[2 * index : 2 * index + 2]
        admitted_at = datetime.fromisoformat(admitted["admitted_at_utc"])
        if (
            admitted["kind"] != "admitted"
            or completed["kind"] != "completed"
            or admitted["arm_id"] != arm_id
            or completed["arm_id"] != arm_id
            or admitted["worksheet_sha256"] != worksheet_hash
            or completed["worksheet_sha256"] != worksheet_hash
            or any(
                event["implementation_manifest_path"] != implementation["path"]
                or event["implementation_manifest_sha256"]
                != implementation["manifest_sha256"]
                for event in (admitted, completed)
            )
            or (previous_capture is not None and admitted_at < previous_capture)
        ):
            return False
        if admission_status(worksheet, replay, arm_id, admitted_at) != "PASS":
            return False
        replay.append(admitted)
        captured_at = datetime.fromisoformat(completed["captured_at_utc"])
        start_value = resources_by_arm[arm_id]["run_start_utc"]
        end_value = resources_by_arm[arm_id]["run_end_utc"]
        if start_value is None or end_value is None:
            return False
        run_start = datetime.fromisoformat(start_value)
        run_end = datetime.fromisoformat(end_value)
        if not admitted_at <= run_start <= run_end <= captured_at:
            return False
        accounting = _load_accounting(
            Path(completed["accounting_path"]),
            worksheet,
            worksheet_hash,
            arm_id,
            admitted_at,
            captured_at,
        )
        if accounting is None:
            return False
        actual, arm_status, provenance = accounting
        source = resources_by_arm[arm_id]
        if (
            arm_status != "completed"
            or actual != completed["actual"]
            or actual != reported[arm_id]
            or Path(completed["evidence_path"]).resolve()
            != Path(source["accounting_evidence_path"]).resolve()
            or completed["evidence_sha256"] != source["accounting_evidence_sha256"]
            or any(completed[name] != value for name, value in provenance.items())
            or post_arm_status(worksheet, replay, actual) != "PASS"
        ):
            return False
        replay.append(completed)
        previous_capture = captured_at
    return True


def _read_config(root: Path) -> tuple[dict[str, Any], Path]:
    paths = sorted(root.rglob("*_revolution_config.yaml"))
    assert len(paths) == 1, paths
    payload = yaml.safe_load(paths[0].read_text(encoding="utf-8"))
    assert isinstance(payload, dict)
    return payload, paths[0]


def _validate_pair_configs(
    classic_root: Path,
    treatment_root: Path,
    seed: int,
    problems: list[str],
    generations: int,
) -> dict[str, str]:
    classic, classic_path = _read_config(classic_root)
    treatment, treatment_path = _read_config(treatment_root)
    config_path = H10_ROOT / (
        "smoke_run_config.yaml" if generations == 1 else "full_suite_run_config.yaml"
    )
    assert (
        hashlib.sha256(config_path.read_bytes()).hexdigest()
        == RUN_CONFIG_SHA256[generations]
    )
    for config, root, mode in (
        (classic, classic_root, "revolution"),
        (treatment, treatment_root, "revolution_verified_status_feedback"),
    ):
        assert config.pop("search_mode") == mode
        assert _path(config.pop("save_path")).resolve() == root.resolve()
        assert _path(config.pop("config")).resolve() == config_path.resolve()
        assert config.pop("seed") == seed
        assert config.pop("problems") == problems
        assert config.pop("num_generations") == generations
        assert config.pop("total_worker_slots") == (12 if generations == 1 else 48)
        assert config.pop("max_active_problems") == (3 if generations == 1 else 12)
    assert classic == treatment
    normalized = json.dumps(classic, sort_keys=True, separators=(",", ":")).encode()
    assert hashlib.sha256(normalized).hexdigest() == NORMALIZED_CONFIG_SHA256
    return {
        "classic": hashlib.sha256(classic_path.read_bytes()).hexdigest(),
        "treatment": hashlib.sha256(treatment_path.read_bytes()).hexdigest(),
    }


def _validate_telemetry(
    problem_root: Path,
    candidates: list[tuple[int, dict[str, Any]]],
) -> tuple[set[str], int]:
    path = problem_root / "verified_status_feedback_telemetry.jsonl"
    records = [
        json.loads(line) for line in path.read_text(encoding="utf-8").splitlines()
    ]
    assert len(records) == len(candidates)
    by_id = {record["candidate_id"]: record for record in records}
    assert len(by_id) == len(records)
    assert set(by_id) == {candidate["id"] for _, candidate in candidates}

    prefixed: set[str] = set()
    consumed_feedback: dict[str, bytes] = {}
    for generation, candidate in candidates:
        record = by_id[candidate["id"]]
        assert set(record) == TELEMETRY_FIELDS
        assert record["generation"] == generation
        assert record["status"] == candidate["status"]
        original_bytes = record["critic_analysis_utf8_bytes"]
        consumed_bytes = record["consumed_feedback_utf8_bytes"]
        original_hash = record["critic_analysis_sha256"]
        consumed_hash = record["consumed_feedback_sha256"]
        assert type(original_bytes) is int and original_bytes >= 0
        assert type(consumed_bytes) is int and consumed_bytes >= 0
        hashes = (
            original_hash,
            consumed_hash,
            record["code_feedback_sha256"],
        )
        assert all(
            isinstance(value, str)
            and len(value) == 64
            and all(character in "0123456789abcdef" for character in value)
            for value in hashes
        )
        artifact = Path(candidate["code_file_path"]).parent / "code_feedback.txt"
        artifact_bytes = artifact.read_bytes()
        assert (
            hashlib.sha256(artifact_bytes).hexdigest() == record["code_feedback_sha256"]
        )
        _, marker, analysis = artifact_bytes.partition(b"\n\nANALYSIS:\n")
        assert marker
        assert len(analysis) == original_bytes
        assert hashlib.sha256(analysis).hexdigest() == original_hash

        status = candidate["status"]
        prefix = (
            b""
            if status == "success"
            else (f"Verified terminal status: {status}\n".encode())
        )
        consumed = prefix + analysis
        assert len(consumed) == consumed_bytes
        assert hashlib.sha256(consumed).hexdigest() == consumed_hash
        consumed_feedback[candidate["id"]] = consumed
        if status == "success":
            assert record["prefix_applied"] is False
            continue
        assert status in FAIL_STATUSES
        assert record["prefix_applied"] is True
        prefixed.add(candidate["id"])
    use_path = problem_root / "verified_status_feedback_use_telemetry.jsonl"
    use_records = [
        json.loads(line) for line in use_path.read_text(encoding="utf-8").splitlines()
    ]
    observed: Counter[tuple[int, str]] = Counter()
    for record in use_records:
        assert set(record) == PROMPT_USE_FIELDS
        generation = record["generation"]
        parent_id = record["parent_id"]
        assert type(generation) is int and 1 <= generation
        assert isinstance(parent_id, str) and parent_id in by_id
        parent_record = by_id[parent_id]
        assert parent_record["status"] in FAIL_STATUSES
        assert (
            record["feedback_utf8_bytes"]
            == parent_record["consumed_feedback_utf8_bytes"]
        )
        assert record["feedback_sha256"] == parent_record["consumed_feedback_sha256"]
        serialized_bytes = record["serialized_parent_utf8_bytes"]
        serialized_hash = record["serialized_parent_sha256"]
        serialized_payload = record["serialized_parent_payload"]
        assert isinstance(serialized_payload, str)
        payload_bytes = serialized_payload.encode()
        assert type(serialized_bytes) is int and serialized_bytes > 0
        assert len(payload_bytes) == serialized_bytes
        assert (
            isinstance(serialized_hash, str)
            and len(serialized_hash) == 64
            and all(character in "0123456789abcdef" for character in serialized_hash)
        )
        assert hashlib.sha256(payload_bytes).hexdigest() == serialized_hash
        payload = json.loads(serialized_payload)
        assert isinstance(payload, dict) and isinstance(payload["feedback"], str)
        assert payload["feedback"].encode() == consumed_feedback[parent_id]
        observed[generation, parent_id] += 1
    expected = Counter(
        (generation, candidate["parent_ids"][0])
        for generation, candidate in candidates
        if generation > 0 and candidate["origin_pool"] == "fail_pool"
    )
    assert observed == expected
    return prefixed, len(use_records)


def _mechanism_evidence(
    arm: Arm,
    problem_root: Path,
    candidates: list[tuple[int, dict[str, Any]]],
) -> tuple[set[str], int]:
    if arm == "classic":
        return set(), 0
    return _validate_telemetry(problem_root, candidates)


def _ppa_context(
    problem: str,
    ppa_problems: set[str],
    summary: dict[str, Any],
) -> tuple[dict[str, float] | None, tuple[str, ...]]:
    if problem not in ppa_problems:
        return None, ()
    reference = _reference_ppa(problem)
    summary_reference = summary["ref_ppa_metric"]
    assert set(summary_reference) == set(reference)
    assert {name: float(summary_reference[name]) for name in reference} == reference
    return reference, objective_metrics_for_reference(reference)


def _repair_rows(
    arm: Arm,
    root: Path,
    problems: list[str],
    generations: int,
    excluded: set[str],
    ppa_problems: set[str],
) -> dict[str, dict[str, Any]]:
    paths = sorted(root.rglob("generation_log.jsonl"))
    by_problem = {path.parent.name: path for path in paths}
    assert len(by_problem) == len(paths)
    assert set(by_problem) <= set(problems)
    rows: dict[str, dict[str, Any]] = {}

    for problem in problems:
        if problem in excluded or problem not in by_problem:
            rows[problem] = {
                "candidate_count": 0,
                "post_gen0_candidate_count": 0,
                "llm_calls": 0,
                "llm_tokens": 0,
                "synthesis_evaluations": 0,
                "rtl_simulation_functionality": 0,
                "verification_complete_valid_ppa": 0,
                "valid_ppa_sample_count": 0,
                "valid_ppa_candidate_ids": "[]",
                "valid_ppa_candidate_generations": "{}",
                "valid_ppa_sample_yield": 0.0,
                "best_normalized_ppa": None,
                "final_hv": None,
                "hv_auc": None,
                "runtime_seconds": 0.0,
                "start_time_utc": None,
                "end_time_utc": None,
                "repair_event_count": 0,
                "rtl_repair_event_count": 0,
                "repaired_design": 0,
                "rtl_repaired_design": 0,
                "repair_generations": "{}",
                "repair_operators": "{}",
                "repair_stage_transitions": "{}",
                "gen0_prefixed_failure_count": 0,
                "selected_prefixed_parent_count": 0,
                "prompt_use_count": 0,
                "prompt_use_valid": 0,
                "telemetry_valid": 0,
            }
            continue

        path = by_problem[problem]
        problem_root = path.parent.resolve()
        summary_paths = list(path.parent.glob("*_summary.json"))
        assert len(summary_paths) == 1
        summary = json.loads(summary_paths[0].read_text(encoding="utf-8"))
        assert summary["benchmark_name"] == "RTLLM"
        assert summary["problem_name"] == problem
        start_time = datetime.fromisoformat(summary["start_time"])
        end_time = datetime.fromisoformat(summary["end_time"])
        utc_offset = start_time.utcoffset()
        assert utc_offset is not None and utc_offset == end_time.utcoffset()
        assert utc_offset.total_seconds() == 0
        runtime_seconds = float(summary["total_runtime_seconds"])
        assert abs((end_time - start_time).total_seconds() - runtime_seconds) < 1.0
        reference, objective_metrics = _ppa_context(problem, ppa_problems, summary)
        points: dict[int, list[tuple[float, ...]]] = {}
        records = [
            json.loads(line) for line in path.read_text(encoding="utf-8").splitlines()
        ]
        assert [record["generation"] for record in records] == list(
            range(generations + 1)
        )
        seen: dict[str, tuple[int, dict[str, Any]]] = {}
        for record in records:
            generation = record["generation"]
            generated = record["generated_candidates"]
            assert isinstance(generated, list) and len(generated) == 8
            generated_by_id: dict[str, dict[str, Any]] = {}
            for candidate in generated:
                assert isinstance(candidate, dict)
                candidate_id = candidate["id"]
                assert isinstance(candidate_id, str) and candidate_id not in seen
                assert candidate_id not in generated_by_id
                assert isinstance(candidate["parent_ids"], list)
                assert candidate["generated_mode"] == "whole"
                _completed_stage(candidate)
                code_path = Path(candidate["code_file_path"]).resolve()
                assert code_path.is_relative_to(problem_root)
                relative_code_path = code_path.relative_to(problem_root)
                assert relative_code_path.parts[0] == f"Gen{generation}"
                assert code_path.is_file()
                if generation == 0:
                    assert candidate["origin_pool"] == "initial"
                    assert candidate["strategy"] == "initial"
                    assert candidate["parent_ids"] == []
                else:
                    assert candidate["parent_ids"]
                    assert set(candidate["parent_ids"]) <= set(seen)
                    assert all(
                        seen[parent_id][0] < generation
                        for parent_id in candidate["parent_ids"]
                    )
                    match candidate["origin_pool"]:
                        case "fail_pool":
                            assert candidate["strategy"] in FAIL_OPERATORS
                            assert len(candidate["parent_ids"]) == 1
                            parent = seen[candidate["parent_ids"][0]][1]
                            assert parent["status"] != "success"
                        case "success_pool":
                            assert candidate["strategy"] in SUCCESS_OPERATORS
                            expected = 2 if candidate["strategy"] == "C-F" else 1
                            assert len(candidate["parent_ids"]) == expected
                            assert len(set(candidate["parent_ids"])) == expected
                            assert all(
                                seen[parent_id][1]["status"] == "success"
                                for parent_id in candidate["parent_ids"]
                            )
                        case origin:
                            raise AssertionError(f"Unknown origin pool: {origin}")
                seen[candidate_id] = (generation, candidate)
                generated_by_id[candidate_id] = candidate

            details = record["population_ppa_details"]
            assert isinstance(details, list)
            assert all(isinstance(detail, dict) for detail in details)
            detail_by_id = {detail["id"]: detail for detail in details}
            assert len(detail_by_id) == len(details)
            assert set(detail_by_id) == {
                candidate_id
                for candidate_id, candidate in generated_by_id.items()
                if candidate["ppa_success"]
            }
            for candidate_id, detail in detail_by_id.items():
                assert detail["strategy"] == generated_by_id[candidate_id]["strategy"]
                metrics = detail["ppa_metrics"]
                assert set(metrics) == PPA_METRICS
                assert all(
                    type(value) in {int, float} and math.isfinite(value)
                    for value in metrics.values()
                )
                assert type(detail["score"]) in {int, float}
                assert math.isfinite(detail["score"])
                if reference is not None:
                    improvements = compute_candidate_improvements(
                        metrics, reference, objective_metrics
                    )
                    assert improvements is not None
                    points.setdefault(generation, []).append(
                        tuple(improvements[name] for name in objective_metrics)
                    )

        candidates = list(seen.values())
        assert len(candidates) == 8 * (generations + 1)
        prefixed, prompt_use_count = _mechanism_evidence(arm, path.parent, candidates)
        fail_children = [
            (generation, candidate)
            for generation, candidate in candidates
            if generation > 0 and candidate["origin_pool"] == "fail_pool"
        ]
        ppa_repairs = [
            (generation, candidate)
            for generation, candidate in fail_children
            if candidate["status"] == "success" and candidate["ppa_success"] is True
        ]
        rtl_repairs = [
            (generation, candidate)
            for generation, candidate in fail_children
            if candidate["rtl_simulation_success"] is True
        ]
        transitions = Counter(
            f"{_completed_stage(seen[candidate['parent_ids'][0]][1])}->"
            f"{_completed_stage(candidate)}"
            for _, candidate in ppa_repairs
        )
        selected_prefixed = sum(
            candidate["parent_ids"][0] in prefixed for _, candidate in fail_children
        )
        candidate_count = 8 * (generations + 1)
        assert summary["total_candidates_generated"] == candidate_count
        llm_tokens = (
            summary["total_llm_prompt_tokens"] + summary["total_llm_completion_tokens"]
        )
        valid_ppa = sum(candidate["ppa_success"] for _, candidate in candidates)
        valid_ppa_ids = sorted(
            candidate["id"] for _, candidate in candidates if candidate["ppa_success"]
        )
        valid_ppa_generations = {
            candidate["id"]: generation
            for generation, candidate in candidates
            if candidate["ppa_success"]
        }
        curve = (
            cumulative_hypervolume_curve(points, generations)
            if reference is not None
            else None
        )
        best_score = summary["final_population_ppa"]["best_score"]
        assert best_score is None or isinstance(best_score, (int, float))
        rows[problem] = {
            "candidate_count": candidate_count,
            "post_gen0_candidate_count": 8 * generations,
            "llm_calls": summary["total_llm_api_calls"],
            "llm_tokens": llm_tokens,
            "synthesis_evaluations": sum(
                candidate["rtl_simulation_success"] for _, candidate in candidates
            ),
            "rtl_simulation_functionality": int(
                any(candidate["rtl_simulation_success"] for _, candidate in candidates)
            ),
            "verification_complete_valid_ppa": int(valid_ppa > 0),
            "valid_ppa_sample_count": valid_ppa,
            "valid_ppa_candidate_ids": json.dumps(valid_ppa_ids, separators=(",", ":")),
            "valid_ppa_candidate_generations": json.dumps(
                valid_ppa_generations, sort_keys=True, separators=(",", ":")
            ),
            "valid_ppa_sample_yield": valid_ppa / candidate_count,
            "best_normalized_ppa": (
                float(best_score) if best_score is not None else None
            ),
            "final_hv": curve[-1] if curve is not None else None,
            "hv_auc": hypervolume_auc(curve) if curve is not None else None,
            "runtime_seconds": runtime_seconds,
            "start_time_utc": start_time.isoformat(),
            "end_time_utc": end_time.isoformat(),
            "repair_event_count": len(ppa_repairs),
            "rtl_repair_event_count": len(rtl_repairs),
            "repaired_design": int(bool(ppa_repairs)),
            "rtl_repaired_design": int(bool(rtl_repairs)),
            "repair_generations": json.dumps(
                dict(
                    sorted(Counter(generation for generation, _ in ppa_repairs).items())
                ),
                separators=(",", ":"),
            ),
            "repair_operators": json.dumps(
                dict(
                    sorted(
                        Counter(
                            candidate["strategy"] for _, candidate in ppa_repairs
                        ).items()
                    )
                ),
                separators=(",", ":"),
            ),
            "repair_stage_transitions": json.dumps(
                dict(sorted(transitions.items())), separators=(",", ":")
            ),
            "gen0_prefixed_failure_count": sum(
                generation == 0 and candidate["id"] in prefixed
                for generation, candidate in candidates
            ),
            "selected_prefixed_parent_count": selected_prefixed,
            "prompt_use_count": prompt_use_count,
            "prompt_use_valid": int(arm == "treatment"),
            "telemetry_valid": int(arm == "treatment"),
        }
    return rows


def _build_arm_rows(
    arm: Arm,
    root: Path,
    seed: int,
    problems: list[str],
    generations: int,
    program: dict[str, Any],
    failures: dict[tuple[int, Arm, str], FailureState],
    ppa_problems: set[str],
) -> list[dict[str, Any]]:
    budget = program["budgets"]["per_problem"]
    registered = {
        problem
        for candidate_seed, candidate_arm, problem in failures
        if candidate_seed == seed and candidate_arm == arm
    }
    evidence = _repair_rows(arm, root, problems, generations, registered, ppa_problems)
    present = {path.parent.name for path in root.rglob("generation_log.jsonl")}
    assert present <= set(problems)
    rows = []
    for problem in problems:
        unit = evidence[problem]
        registered_state = failures.get((seed, arm, problem))
        if registered_state is not None:
            status = registered_state
            if status in {"treatment_missing", "classic_infrastructure_missing"}:
                assert problem not in present
            elif status in {"treatment_malformed", "classic_invalid"}:
                assert problem in present
            else:
                raise AssertionError(f"Unknown unit status: {status}")
        elif problem in present:
            status = "complete"
        elif arm == "treatment":
            status = "treatment_missing"
        else:
            status = "classic_invalid"
        assert status in UNIT_STATUSES
        if status == "complete":
            assert unit["llm_calls"] <= budget["llm_calls"]
            assert unit["llm_tokens"] <= budget["llm_tokens"]
            assert unit["synthesis_evaluations"] <= budget["synthesis_evaluations"]
            assert unit["runtime_seconds"] <= budget["wall_seconds"]
        rows.append(
            {
                "seed": seed,
                "arm": arm,
                "problem": problem,
                "unit_status": status,
                **unit,
            }
        )
    return rows


def _collect_scope(
    scope: RunScope,
    program: dict[str, Any],
    worksheet: dict[str, Any],
) -> tuple[list[dict[str, Any]], list[dict[str, Any]], dict[str, dict[str, str]]]:
    problems = list(scope.problems)
    assert set(scope.failures) <= {
        (seed, arm, problem)
        for seed in scope.seeds
        for arm in ARMS
        for problem in problems
    }
    caps = {arm["id"]: arm["caps"] for arm in worksheet["arms"]}
    rows: list[dict[str, Any]] = []
    resource_totals: list[dict[str, Any]] = []
    config_hashes: dict[str, dict[str, str]] = {}
    for seed in scope.seeds:
        roots = {arm: scope.raw_root / f"seed_{seed}" / arm for arm in ARMS}
        config_hashes[str(seed)] = _validate_pair_configs(
            roots["classic"],
            roots["treatment"],
            seed,
            problems,
            scope.generations,
        )
        seed_rows = {
            arm: _build_arm_rows(
                arm,
                roots[arm],
                seed,
                problems,
                scope.generations,
                program,
                scope.failures,
                set(scope.ppa_problems),
            )
            for arm in ARMS
        }
        for arm in ARMS:
            arm_id = f"smoke_{arm}" if scope.stage == "smoke" else f"seed_{seed}_{arm}"
            cap = caps[arm_id]
            arm_rows = seed_rows[arm]
            start_times = [
                row["start_time_utc"]
                for row in arm_rows
                if row["start_time_utc"] is not None
            ]
            end_times = [
                row["end_time_utc"]
                for row in arm_rows
                if row["end_time_utc"] is not None
            ]
            extra_evidence = (
                (scope.raw_root / "unit_failures.yaml",)
                if seed == scope.seeds[-1] and arm == "treatment"
                else ()
            )
            run_wall, run_evidence, run_evidence_sha256 = _read_run_wall(
                roots[arm], extra_evidence
            )
            rows.extend(arm_rows)
            totals = {
                "stage": scope.stage,
                "arm_id": arm_id,
                "seed": seed,
                "arm": arm,
                "candidate_count": sum(row["candidate_count"] for row in arm_rows),
                "post_gen0_candidate_count": sum(
                    row["post_gen0_candidate_count"] for row in arm_rows
                ),
                "llm_calls": sum(row["llm_calls"] for row in arm_rows),
                "llm_tokens": sum(row["llm_tokens"] for row in arm_rows),
                "synthesis_evaluations": sum(
                    row["synthesis_evaluations"] for row in arm_rows
                ),
                "summed_problem_runtime_seconds": sum(
                    row["runtime_seconds"] for row in arm_rows
                ),
                "run_wall_seconds": run_wall,
                "accounting_evidence_path": str(run_evidence),
                "accounting_evidence_sha256": run_evidence_sha256,
                "run_start_utc": min(start_times) if start_times else None,
                "run_end_utc": max(end_times) if end_times else None,
                "missing_unit_count": sum(
                    row["unit_status"] != "complete" for row in arm_rows
                ),
            }
            totals["within_cap"] = (
                totals["candidate_count"] == cap["candidates"]
                and totals["llm_calls"] <= cap["calls"]
                and totals["llm_tokens"] <= cap["tokens"]
                and totals["synthesis_evaluations"] <= cap["synthesis"]
                and totals["run_wall_seconds"] <= cap["wall_seconds"]
            )
            resource_totals.append(totals)
    return rows, resource_totals, config_hashes


def _breadth_summary(rows: list[dict[str, Any]]) -> dict[str, Any]:
    by_key = {(row["seed"], row["arm"], row["problem"]): row for row in rows}
    problems = sorted({row["problem"] for row in rows})
    per_seed = []
    for seed in DEVELOPMENT_SEEDS:
        classic = [
            by_key[seed, "classic", problem]["repaired_design"] for problem in problems
        ]
        treatment = [
            by_key[seed, "treatment", problem]["repaired_design"]
            for problem in problems
        ]
        deltas = [
            candidate - control
            for control, candidate in zip(classic, treatment, strict=True)
        ]
        gains = [
            problem
            for problem, delta in zip(problems, deltas, strict=True)
            if delta > 0
        ]
        losses = [
            problem
            for problem, delta in zip(problems, deltas, strict=True)
            if delta < 0
        ]
        total = sum(deltas)
        leave_one_out = [total - delta for delta in deltas]
        per_seed.append(
            {
                "seed": seed,
                "classic_breadth": sum(classic),
                "treatment_breadth": sum(treatment),
                "delta": total,
                "wins": len(gains),
                "losses": len(losses),
                "ties": len(deltas) - len(gains) - len(losses),
                "gain_problems": gains,
                "loss_problems": losses,
                "minimum_leave_one_problem_out_delta": min(leave_one_out),
                "leave_one_problem_out_pass": min(leave_one_out) > 0,
            }
        )
    return {
        "per_seed": per_seed,
        "benefit_pass": all(row["leave_one_problem_out_pass"] for row in per_seed),
    }


def _detail_rows(
    rows: list[dict[str, Any]],
) -> tuple[list[dict[str, Any]], list[dict[str, Any]], list[dict[str, Any]]]:
    by_key = {(row["seed"], row["arm"], row["problem"]): row for row in rows}
    seeds = sorted({row["seed"] for row in rows})
    problems = sorted({row["problem"] for row in rows})
    paired = []
    leave_one_out = []
    for seed in seeds:
        deltas = {
            problem: by_key[seed, "treatment", problem]["repaired_design"]
            - by_key[seed, "classic", problem]["repaired_design"]
            for problem in problems
        }
        total_delta = sum(deltas.values())
        for problem in problems:
            classic = by_key[seed, "classic", problem]
            treatment = by_key[seed, "treatment", problem]
            paired.append(
                {
                    "seed": seed,
                    "problem": problem,
                    "classic_repaired": classic["repaired_design"],
                    "treatment_repaired": treatment["repaired_design"],
                    "delta": deltas[problem],
                    "classic_events": classic["repair_event_count"],
                    "treatment_events": treatment["repair_event_count"],
                    "treatment_unit_status": treatment["unit_status"],
                }
            )
            leave_one_out.append(
                {
                    "seed": seed,
                    "omitted_problem": problem,
                    "breadth_delta": total_delta - deltas[problem],
                }
            )

    concentration = []
    for row in rows:
        concentration.append(
            {
                "seed": row["seed"],
                "arm": row["arm"],
                "problem": row["problem"],
                "category": "total",
                "value": "valid_ppa_repairs",
                "count": row["repair_event_count"],
            }
        )
        for field, category in (
            ("repair_generations", "generation"),
            ("repair_operators", "operator"),
            ("repair_stage_transitions", "stage_transition"),
        ):
            for value, count in json.loads(row[field]).items():
                concentration.append(
                    {
                        "seed": row["seed"],
                        "arm": row["arm"],
                        "problem": row["problem"],
                        "category": category,
                        "value": value,
                        "count": count,
                    }
                )
    return paired, leave_one_out, concentration


def evaluate_full_suite(
    rows: list[dict[str, Any]],
    resource_totals: list[dict[str, Any]],
    headline_problems: list[str],
    process_ledger_pass: bool,
    smoke_prerequisite_pass: bool,
) -> dict[str, Any]:
    """Evaluate the frozen H10 development contract from validated unit rows."""
    assert len(rows) == 200
    assert len(headline_problems) == 46
    problems = sorted({row["problem"] for row in rows})
    assert len(problems) == 50
    assert {(row["seed"], row["arm"], row["problem"]) for row in rows} == {
        (seed, arm, problem)
        for seed in DEVELOPMENT_SEEDS
        for arm in ARMS
        for problem in problems
    }
    assert len(resource_totals) == 4
    for row in rows:
        assert row["unit_status"] in UNIT_STATUSES
        assert (
            row["unit_status"]
            not in {
                "treatment_missing",
                "treatment_malformed",
            }
            or row["arm"] == "treatment"
        )
        assert (
            row["unit_status"]
            not in {
                "classic_infrastructure_missing",
                "classic_invalid",
            }
            or row["arm"] == "classic"
        )

    by_key = {(row["seed"], row["arm"], row["problem"]): row for row in rows}
    classic_method_failures = {
        (seed, problem)
        for seed in DEVELOPMENT_SEEDS
        for problem in headline_problems
        if by_key[seed, "classic", problem]["unit_status"] == "complete"
        and by_key[seed, "classic", problem]["verification_complete_valid_ppa"] == 0
    }
    classic_ppa_exclusions = {
        (seed, problem)
        for seed in DEVELOPMENT_SEEDS
        for problem in headline_problems
        if by_key[seed, "classic", problem]["unit_status"] != "complete"
        or (seed, problem) in classic_method_failures
    }
    breadth = _breadth_summary(rows)
    breadth_samples = [
        PairedSample(
            f"{seed}/RTLLM/{problem}",
            float(by_key[seed, "classic", problem]["repaired_design"]),
            float(by_key[seed, "treatment", problem]["repaired_design"]),
        )
        for seed in DEVELOPMENT_SEEDS
        for problem in problems
    ]
    headline_samples = {
        metric: [
            PairedSample(
                f"{seed}/RTLLM/{problem}",
                by_key[seed, "classic", problem][metric],
                by_key[seed, "treatment", problem][metric],
            )
            for seed in DEVELOPMENT_SEEDS
            for problem in headline_problems
            if (seed, problem) not in classic_ppa_exclusions
        ]
        for metric in ("final_hv", "hv_auc")
    }
    statistics = {
        "repair_breadth": summarize_paired_metric(
            "repair_breadth",
            breadth_samples,
            tie_epsilon=0.0,
            n_resamples=10_000,
            seed=20260720,
        ).as_dict(),
        **{
            metric: summarize_paired_metric(
                metric,
                samples,
                tie_epsilon=1e-9,
                missing_treatment_floor=0.0,
                n_resamples=10_000,
                seed=20260720,
            ).as_dict()
            for metric, samples in headline_samples.items()
        },
    }

    classic_coverage: dict[CoverageSurface, dict[int, int]] = {
        surface: {} for surface in COVERAGE_SURFACES
    }
    treatment_coverage: dict[CoverageSurface, dict[int, int]] = {
        surface: {} for surface in COVERAGE_SURFACES
    }
    headline = set(headline_problems)
    for seed in DEVELOPMENT_SEEDS:
        for arm, target in (
            ("classic", classic_coverage),
            ("treatment", treatment_coverage),
        ):
            arm_rows = [
                row for row in rows if row["seed"] == seed and row["arm"] == arm
            ]
            target["valid_ppa46"][seed] = sum(
                row["verification_complete_valid_ppa"]
                for row in arm_rows
                if row["problem"] in headline
            )
            target["rtl_functionality46"][seed] = sum(
                row["rtl_simulation_functionality"]
                for row in arm_rows
                if row["problem"] in headline
            )
            target["rtl_functionality50"][seed] = sum(
                row["rtl_simulation_functionality"] for row in arm_rows
            )
    coverage_gates = evaluate_per_seed_coverage(classic_coverage, treatment_coverage)
    catastrophic_coverage_loss = loss_only_coverage_deficit(
        classic_coverage, treatment_coverage
    )

    resources = {(row["seed"], row["arm"]): row for row in resource_totals}
    assert set(resources) == {(seed, arm) for seed in DEVELOPMENT_SEEDS for arm in ARMS}
    resource_skews: dict[str, float] = {}
    for name in ("llm_calls", "llm_tokens", "run_wall_seconds"):
        for seed in DEVELOPMENT_SEEDS:
            classic = resources[seed, "classic"][name]
            assert classic > 0
            resource_skews[f"{seed}/{name}"] = (
                abs(resources[seed, "treatment"][name] - classic) / classic
            )
        classic = sum(resources[seed, "classic"][name] for seed in DEVELOPMENT_SEEDS)
        treatment = sum(
            resources[seed, "treatment"][name] for seed in DEVELOPMENT_SEEDS
        )
        resource_skews[f"pooled/{name}"] = abs(treatment - classic) / classic

    missing_classic_infrastructure = any(
        row["unit_status"] == "classic_infrastructure_missing" for row in rows
    )
    malformed_or_missing = any(
        row["unit_status"]
        in {"treatment_missing", "treatment_malformed", "classic_invalid"}
        for row in rows
    )
    final_hv_delta = cast(float | None, statistics["final_hv"]["mean_delta"])
    hv_auc_delta = cast(float | None, statistics["hv_auc"]["mean_delta"])
    final_hv_samples = headline_samples["final_hv"]
    assert final_hv_samples
    assert all(sample.baseline is not None for sample in final_hv_samples)
    classic_final_hv = sum(
        cast(float, sample.baseline) for sample in final_hv_samples
    ) / len(final_hv_samples)
    treatment_final_hv = sum(
        0.0 if sample.treatment is None else sample.treatment
        for sample in final_hv_samples
    ) / len(final_hv_samples)
    assert classic_final_hv > 0
    catastrophic_hv_ratio = treatment_final_hv / classic_final_hv
    gate_results = {
        "smoke_prerequisite": smoke_prerequisite_pass,
        "breadth_leave_one_problem_out_each_seed": breadth["benefit_pass"],
        "catastrophic_final_hv_ratio": catastrophic_hv_ratio >= 0.90,
        "final_hv_noninferiority": final_hv_delta is not None
        and final_hv_delta >= -0.005,
        "hv_auc_noninferiority": hv_auc_delta is not None and hv_auc_delta >= -0.0036,
        **{
            f"{surface}_noninferiority": passed
            for surface, passed in coverage_gates.items()
        },
        **{
            f"{surface}_catastrophic": loss <= 3
            for surface, loss in catastrophic_coverage_loss.items()
        },
        "candidate_budget_equality": all(
            row["candidate_count"] == 2400 and row["post_gen0_candidate_count"] == 2000
            for row in resource_totals
        ),
        "mechanism_evidence": all(
            row["unit_status"] == "complete"
            and row["telemetry_valid"] == 1
            and row["prompt_use_valid"] == 1
            for row in rows
            if row["arm"] == "treatment"
        ),
        "arm_resource_caps": all(row["within_cap"] is True for row in resource_totals),
        "auxiliary_resource_parity": max(resource_skews.values()) <= 0.10,
        "evidence_complete": not malformed_or_missing,
        "process_ledger": process_ledger_pass,
    }
    if missing_classic_infrastructure:
        outcome = "BLOCKED"
    elif all(gate_results.values()):
        outcome = "VIABLE"
    else:
        outcome = "RETIRED"
    return {
        "candidate_id": "H10",
        "stage": "full_suite",
        "validated_arm_units": len(rows),
        "breadth": breadth,
        "statistics": statistics,
        "classic_method_failures": {
            "count": len(classic_method_failures),
            "treatment_only_success_count": sum(
                by_key[seed, "treatment", problem]["verification_complete_valid_ppa"]
                for seed, problem in classic_method_failures
            ),
            "units": [
                {"seed": seed, "problem": problem}
                for seed, problem in sorted(classic_method_failures)
            ],
        },
        "catastrophic_final_hv_ratio": catastrophic_hv_ratio,
        "catastrophic_coverage_loss": catastrophic_coverage_loss,
        "coverage": {"classic": classic_coverage, "treatment": treatment_coverage},
        "resource_skews": resource_skews,
        "resource_totals": resource_totals,
        "gate_results": gate_results,
        "performance_gate": outcome,
    }


def _smoke_summary(
    rows: list[dict[str, Any]],
    resource_totals: list[dict[str, Any]],
    process_ledger_pass: bool,
) -> dict[str, Any]:
    assert len(rows) == 6 and len(resource_totals) == 2
    treatment = [row for row in rows if row["arm"] == "treatment"]
    gates = {
        "complete_units": all(row["unit_status"] == "complete" for row in rows),
        "candidate_budget_equality": all(
            row["candidate_count"] == 48 and row["post_gen0_candidate_count"] == 24
            for row in resource_totals
        ),
        "arm_resource_caps": all(row["within_cap"] is True for row in resource_totals),
        "telemetry_exact": all(row["telemetry_valid"] == 1 for row in treatment),
        "prompt_use_exact": all(row["prompt_use_valid"] == 1 for row in treatment),
        "prefixed_gen0_failure": sum(
            row["gen0_prefixed_failure_count"] for row in treatment
        )
        > 0,
        "prefixed_parent_selected": sum(
            row["selected_prefixed_parent_count"] for row in treatment
        )
        > 0,
        "process_ledger": process_ledger_pass,
    }
    return {
        "candidate_id": "H10",
        "stage": "smoke",
        "validated_arm_units": len(rows),
        "resource_totals": resource_totals,
        "gate_results": gates,
        "smoke_gate": "PASS" if all(gates.values()) else "STOP",
    }


def generate_report(manifest_path: Path, output_dir: Path) -> dict[str, Any]:
    """Validate the frozen H10 evidence and write its canonical report."""
    manifest_path = manifest_path.resolve()
    assert manifest_path in REPORT_MANIFEST_SHA256
    assert (
        hashlib.sha256(manifest_path.read_bytes()).hexdigest()
        == (REPORT_MANIFEST_SHA256[manifest_path])
    )
    manifest = yaml.safe_load(manifest_path.read_text(encoding="utf-8"))
    assert isinstance(manifest, dict)
    assert manifest["version"] == 1
    assert manifest["candidate_id"] == "H10"
    assert manifest["candidate_mode"] == "revolution_verified_status_feedback"
    base_keys = {
        "version",
        "candidate_id",
        "candidate_mode",
        "stage",
        "raw_root",
        "worksheet_path",
        "implementation_manifest",
        "unit_failure_registry",
    }
    raw_root = _path(manifest["raw_root"]).resolve()
    raw_roots = [raw_root]
    if "smoke_raw_root" in manifest:
        raw_roots.append(_path(manifest["smoke_raw_root"]).resolve())
    assert all(not output_dir.resolve().is_relative_to(root) for root in raw_roots)
    assert hashlib.sha256(PROGRAM_MANIFEST.read_bytes()).hexdigest() == (
        PROGRAM_MANIFEST_SHA256
    )
    program = yaml.safe_load(PROGRAM_MANIFEST.read_text(encoding="utf-8"))
    assert isinstance(program, dict)
    assert program["version"] == 8 and program["status"] == "FROZEN"
    reference_ppa_paths = _validate_frozen_inputs(program)
    worksheet_path = _path(manifest["worksheet_path"])
    assert hashlib.sha256(worksheet_path.read_bytes()).hexdigest() == WORKSHEET_SHA256
    worksheet = _load_worksheet(worksheet_path)
    assert worksheet["candidate_id"] == "H10"
    implementation = _validate_implementation_manifest(
        _path(manifest["implementation_manifest"])
    )
    stage = manifest["stage"]
    match stage:
        case "smoke":
            assert set(manifest) == base_keys
            failure_registry = _path(manifest["unit_failure_registry"]).resolve()
            assert failure_registry == raw_root / "unit_failures.yaml"
            scope = RunScope(
                "smoke",
                raw_root,
                (42,),
                tuple(program["benchmarks"]["smoke"]["problems"]),
                1,
                frozenset(),
                _read_failures(failure_registry),
            )
            rows, resource_totals, config_hashes = _collect_scope(
                scope, program, worksheet
            )
            summary = _smoke_summary(
                rows,
                resource_totals,
                _ledger_pass("smoke", worksheet_path, resource_totals, implementation),
            )
            output_resources = resource_totals
        case "full_suite":
            assert set(manifest) == base_keys | {
                "smoke_raw_root",
                "smoke_unit_failure_registry",
            }
            benchmark = program["benchmarks"]["full_suite"]
            run_manifest = _path(benchmark["run_manifest"])
            headline_manifest = _path(benchmark["headline_manifest"])
            assert (
                hashlib.sha256(run_manifest.read_bytes()).hexdigest()
                == benchmark["run_manifest_sha256"]
            )
            assert (
                hashlib.sha256(headline_manifest.read_bytes()).hexdigest()
                == benchmark["headline_manifest_sha256"]
            )
            problems = _problem_names(run_manifest)
            headline_problems = _problem_names(headline_manifest)
            assert len(problems) == 50 and len(headline_problems) == 46
            assert reference_ppa_paths == {
                f"data/bench/RTLLM/{problem}_ppa.txt" for problem in headline_problems
            }
            smoke_raw_root = _path(manifest["smoke_raw_root"]).resolve()
            smoke_failure_registry = _path(
                manifest["smoke_unit_failure_registry"]
            ).resolve()
            failure_registry = _path(manifest["unit_failure_registry"]).resolve()
            assert smoke_failure_registry == smoke_raw_root / "unit_failures.yaml"
            assert failure_registry == raw_root / "unit_failures.yaml"
            smoke_scope = RunScope(
                "smoke",
                smoke_raw_root,
                (42,),
                tuple(program["benchmarks"]["smoke"]["problems"]),
                1,
                frozenset(),
                _read_failures(smoke_failure_registry),
            )
            full_scope = RunScope(
                "full_suite",
                raw_root,
                DEVELOPMENT_SEEDS,
                tuple(problems),
                5,
                frozenset(headline_problems),
                _read_failures(failure_registry),
            )
            smoke_rows, smoke_resources, smoke_config = _collect_scope(
                smoke_scope, program, worksheet
            )
            rows, resource_totals, full_config = _collect_scope(
                full_scope, program, worksheet
            )
            smoke_summary = _smoke_summary(
                smoke_rows,
                smoke_resources,
                _ledger_pass("smoke", worksheet_path, smoke_resources, implementation),
            )
            output_resources = smoke_resources + resource_totals
            summary = evaluate_full_suite(
                rows,
                resource_totals,
                headline_problems,
                _ledger_pass(
                    "full_suite", worksheet_path, output_resources, implementation
                ),
                smoke_summary["smoke_gate"] == "PASS",
            )
            summary["smoke_prerequisite"] = smoke_summary
            config_hashes = {"smoke": smoke_config, "full_suite": full_config}
        case unknown:
            raise AssertionError(f"Unknown H10 stage: {unknown}")
    summary["config_sha256"] = config_hashes
    summary["implementation"] = implementation
    summary["frozen_input_sha256"] = {
        "program_manifest": PROGRAM_MANIFEST_SHA256,
        "prompt_manifest": PROMPT_MANIFEST_SHA256,
        "reference_ppa_manifest": REFERENCE_PPA_MANIFEST_SHA256,
    }

    output_dir.mkdir(parents=True, exist_ok=True)
    paired, leave_one_out, concentration = _detail_rows(rows)
    _write_csv(output_dir / "arm_problem_rows.csv", rows)
    _write_csv(output_dir / "paired_repair_by_problem.csv", paired)
    _write_csv(output_dir / "leave_one_problem_out.csv", leave_one_out)
    _write_csv(output_dir / "repair_concentration.csv", concentration)
    _write_csv(output_dir / "resource_totals.csv", output_resources)
    (output_dir / "summary.json").write_text(
        json.dumps(summary, indent=2) + "\n", encoding="utf-8"
    )
    outcome = summary.get("performance_gate", summary.get("smoke_gate"))
    (output_dir / "summary.md").write_text(
        f"# H10 {stage.replace('_', ' ').title()} Report\n\n"
        f"Validated arm/problem rows: `{len(rows)}`.\n\n"
        f"Frozen outcome: `{outcome}`.\n",
        encoding="utf-8",
    )
    return summary


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--manifest", type=Path, required=True)
    parser.add_argument("--output-dir", type=Path, required=True)
    args = parser.parse_args(argv)
    generate_report(args.manifest.resolve(), args.output_dir.resolve())
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
