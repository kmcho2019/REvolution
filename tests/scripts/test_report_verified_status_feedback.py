from __future__ import annotations

import csv
import hashlib
import importlib.util
import json
import os
import subprocess
import sys
from datetime import datetime, timedelta, timezone
from pathlib import Path
from typing import Any

import pytest
import yaml

import scripts.tcad_candidate_admission as admission

_ROOT = Path(__file__).resolve().parents[2]
_PATH = _ROOT / "scripts" / "report_verified_status_feedback.py"
_SPEC = importlib.util.spec_from_file_location("report_verified_status_feedback", _PATH)
assert _SPEC is not None and _SPEC.loader is not None
report = importlib.util.module_from_spec(_SPEC)
sys.modules.setdefault("report_verified_status_feedback", report)
_SPEC.loader.exec_module(report)


def _candidate(
    candidate_id: str,
    status: str,
    origin: str,
    strategy: str,
    parents: list[str],
    code_path: Path,
) -> dict[str, Any]:
    rtl = status in {"success", "failed_synthesis", "failed_synthesis_functionality"}
    synthesis = status in {"success", "failed_synthesis_functionality"}
    return {
        "id": candidate_id,
        "parent_ids": parents,
        "origin_pool": origin,
        "strategy": strategy,
        "status": status,
        "rtl_simulation_success": rtl,
        "synthesis_success": synthesis,
        "post_synthesis_functionality_success": status == "success",
        "ppa_success": status == "success",
        "code_file_path": str(code_path),
        "generated_mode": "whole",
    }


def _write_problem(
    root: Path,
    problem_name: str = "Prob001",
    treatment: bool = False,
    start_minute: int = 0,
) -> Path:
    problem = root / "model" / "RTLLM" / problem_name
    problem.mkdir(parents=True)
    gen0 = []
    for index in range(8):
        sample = problem / "Gen0" / f"sample{index}"
        sample.mkdir(parents=True)
        (sample / "code.sv").write_text("module test; endmodule\n")
        gen0.append(
            _candidate(
                f"g0-{index}",
                "success" if index == 1 else "failed_functionality",
                "initial",
                "initial",
                [],
                sample / "code.sv",
            )
        )
    gen1 = []
    for index in range(8):
        sample = problem / "Gen1" / f"sample{index}"
        sample.mkdir(parents=True)
        (sample / "code.sv").write_text("module test; endmodule\n")
        if index < 2:
            gen1.append(
                _candidate(
                    f"g1-{index}",
                    "success",
                    "fail_pool",
                    "M-F",
                    ["g0-0"],
                    sample / "code.sv",
                )
            )
        else:
            gen1.append(
                _candidate(
                    f"g1-{index}",
                    "success",
                    "success_pool",
                    "M-S",
                    ["g0-1"],
                    sample / "code.sv",
                )
            )

    def ppa_details(
        candidates: list[dict[str, Any]], value: float
    ) -> list[dict[str, Any]]:
        return [
            {
                "id": candidate["id"],
                "strategy": candidate["strategy"],
                "score": 0.2,
                "ppa_metrics": {
                    "tns": 0.0,
                    "wns": 0.0,
                    "eff_clk_period": 0.0,
                    "power": value,
                    "area": value,
                },
            }
            for candidate in candidates
            if candidate["ppa_success"]
        ]

    generations = [
        {
            "generation": 0,
            "generated_candidates": gen0,
            "population_ppa_details": ppa_details(gen0, 99.0),
        },
        {
            "generation": 1,
            "generated_candidates": gen1,
            "population_ppa_details": ppa_details(gen1, 80.0),
        },
    ]
    (problem / "generation_log.jsonl").write_text(
        "\n".join(json.dumps(row) for row in generations) + "\n",
        encoding="utf-8",
    )
    summary = {
        "benchmark_name": "RTLLM",
        "problem_name": problem_name,
        "ref_ppa_metric": {
            "tns": 0.0,
            "wns": 0.0,
            "eff_clk_period": 0.0,
            "power": 100.0,
            "area": 100.0,
        },
        "start_time": datetime(
            2026, 7, 21, 0, start_minute, 10, tzinfo=timezone.utc
        ).isoformat(),
        "end_time": datetime(
            2026, 7, 21, 0, start_minute, 20, tzinfo=timezone.utc
        ).isoformat(),
        "total_candidates_generated": 16,
        "total_llm_api_calls": 16,
        "total_llm_prompt_tokens": 160,
        "total_llm_completion_tokens": 80,
        "total_runtime_seconds": 10.0,
        "final_population_ppa": {"best_score": 0.2},
    }
    (problem / f"{problem_name}_summary.json").write_text(
        json.dumps(summary), encoding="utf-8"
    )
    if treatment:
        telemetry = []
        for generation, candidates in enumerate((gen0, gen1)):
            for candidate in candidates:
                analysis = f"analysis:{candidate['id']}".encode()
                status = candidate["status"]
                prefix = (
                    b""
                    if status == "success"
                    else f"Verified terminal status: {status}\n".encode()
                )
                consumed = prefix + analysis
                artifact = (
                    Path(candidate["code_file_path"]).parent / "code_feedback.txt"
                )
                artifact_bytes = (
                    b"Score: 7\nJustification: test\n\nANALYSIS:\n" + analysis
                )
                artifact.write_bytes(artifact_bytes)
                telemetry.append(
                    {
                        "generation": generation,
                        "candidate_id": candidate["id"],
                        "status": status,
                        "prefix_applied": status != "success",
                        "critic_analysis_utf8_bytes": len(analysis),
                        "critic_analysis_sha256": hashlib.sha256(analysis).hexdigest(),
                        "consumed_feedback_utf8_bytes": len(consumed),
                        "consumed_feedback_sha256": hashlib.sha256(
                            consumed
                        ).hexdigest(),
                        "code_feedback_sha256": hashlib.sha256(
                            artifact_bytes
                        ).hexdigest(),
                    }
                )
        (problem / "verified_status_feedback_telemetry.jsonl").write_text(
            "\n".join(json.dumps(row) for row in telemetry) + "\n",
            encoding="utf-8",
        )
        by_id = {row["candidate_id"]: row for row in telemetry}
        use_telemetry = []
        for candidate in gen1:
            if candidate["origin_pool"] != "fail_pool":
                continue
            parent = by_id[candidate["parent_ids"][0]]
            analysis = f"analysis:{parent['candidate_id']}"
            feedback = f"Verified terminal status: {parent['status']}\n{analysis}"
            serialized_payload = json.dumps(
                {
                    "example": 1,
                    "thought": "test",
                    "feedback": feedback,
                    "code": "module test; endmodule",
                },
                indent=2,
            )
            serialized = serialized_payload.encode()
            use_telemetry.append(
                {
                    "generation": 1,
                    "parent_id": parent["candidate_id"],
                    "feedback_utf8_bytes": parent["consumed_feedback_utf8_bytes"],
                    "feedback_sha256": parent["consumed_feedback_sha256"],
                    "serialized_parent_utf8_bytes": len(serialized),
                    "serialized_parent_sha256": hashlib.sha256(serialized).hexdigest(),
                    "serialized_parent_payload": serialized_payload,
                }
            )
        (problem / "verified_status_feedback_use_telemetry.jsonl").write_text(
            "\n".join(json.dumps(row) for row in use_telemetry) + "\n",
            encoding="utf-8",
        )
    return problem


def _full_rows(
    gains: dict[int, set[str]],
) -> tuple[list[dict[str, Any]], list[str]]:
    problems = [f"Prob{index:03d}" for index in range(50)]
    headline = problems[:46]
    rows = []
    for seed in report.DEVELOPMENT_SEEDS:
        for arm in report.ARMS:
            for problem in problems:
                repaired = int(arm == "treatment" and problem in gains.get(seed, set()))
                rows.append(
                    {
                        "seed": seed,
                        "arm": arm,
                        "problem": problem,
                        "unit_status": "complete",
                        "repaired_design": repaired,
                        "repair_event_count": repaired,
                        "repair_generations": '{"1":1}' if repaired else "{}",
                        "repair_operators": '{"M-F":1}' if repaired else "{}",
                        "repair_stage_transitions": (
                            '{"syntax->valid_ppa":1}' if repaired else "{}"
                        ),
                        "verification_complete_valid_ppa": 1,
                        "rtl_simulation_functionality": 1,
                        "telemetry_valid": int(arm == "treatment"),
                        "prompt_use_valid": int(arm == "treatment"),
                        "final_hv": 0.1 if problem in headline else None,
                        "hv_auc": 0.08 if problem in headline else None,
                    }
                )
    return rows, headline


def _resources() -> list[dict[str, Any]]:
    return [
        {
            "stage": "full_suite",
            "arm_id": f"seed_{seed}_{arm}",
            "seed": seed,
            "arm": arm,
            "candidate_count": 2400,
            "post_gen0_candidate_count": 2000,
            "llm_calls": 4800,
            "llm_tokens": 14_000_000,
            "synthesis_evaluations": 1200,
            "run_wall_seconds": 4500.0,
            "within_cap": True,
        }
        for seed in report.DEVELOPMENT_SEEDS
        for arm in report.ARMS
    ]


def _write_config(
    root: Path,
    mode: str,
    seed: int,
    problems: list[str],
    generations: int,
) -> Path:
    payload = {
        "api_backend": "vllm",
        "backend": "revolution",
        "benchmarks": ["RTLLM"],
        "vllm_host": "20.0.0.103",
        "vllm_port": 8000,
        "vllm_min_model_len": 128000,
        "model_name": "openai/gpt-oss-120b",
        "temperature": 1.0,
        "top_p": 1.0,
        "max_tokens": 128000,
        "diff_max_tokens": 128000,
        "max_llm_calls_per_problem": 100,
        "config": str(
            report.H10_ROOT
            / (
                "smoke_run_config.yaml"
                if generations == 1
                else "full_suite_run_config.yaml"
            )
        ),
        "evaluation_mode": "strict_ablation",
        "generation_mode": "whole",
        "population_pool_mode": "dual",
        "classic_operator_kind": "eoh_strategies",
        "eoh_operators": ["e1", "e2", "m1", "m2", "m3"],
        "eoh_success_operator_set": "classic",
        "strategy_selection": "ucb",
        "epsilon": 0.1,
        "ucb_c": 2.0,
        "representation_kind": "code_individual",
        "repair_kind": "none",
        "repair_max_attempts_per_sample": 0,
        "repair_max_attempts_per_thought": 0,
        "repair_evidence": "stage_scoped_logs",
        "prompt_profile": "default",
        "prompt_root": None,
        "diff_apply_policy": "hybrid",
        "diff_compact_context": True,
        "diff_similarity_threshold": 0.86,
        "diff_fuzzy_margin": 0.03,
        "primary_budget_axis": None,
        "qd_alpha": None,
        "accelerated_synthesis_top_k": 1,
        "rtl_simulation_timeout_s": 60,
        "synthesis_timeout_s": 300,
        "post_synthesis_simulation_timeout_s": 300,
        "vllm_preflight_timeout_s": 5.0,
        "total_worker_slots": 12 if generations == 1 else 48,
        "max_active_problems": 3 if generations == 1 else 12,
        "max_workers_per_problem": 4,
        "backend_subdir": False,
        "seed": seed,
        "problems": problems,
        "population_size": 8,
        "num_generations": generations,
        "search_mode": mode,
        "save_path": str(root),
    }
    root.mkdir(parents=True, exist_ok=True)
    path = root / "run_revolution_config.yaml"
    path.write_text(yaml.safe_dump(payload, sort_keys=False), encoding="utf-8")
    return path


def _use_test_config_contract(
    monkeypatch: pytest.MonkeyPatch, config_path: Path
) -> None:
    config = yaml.safe_load(config_path.read_text())
    normalized = {
        name: value
        for name, value in config.items()
        if name not in report.CONFIG_VARIANT_FIELDS
    }
    payload = json.dumps(normalized, sort_keys=True, separators=(",", ":")).encode()
    monkeypatch.setattr(
        report, "NORMALIZED_CONFIG_SHA256", hashlib.sha256(payload).hexdigest()
    )


def _smoke_resources() -> list[dict[str, Any]]:
    return [
        {
            "stage": "smoke",
            "arm_id": f"smoke_{arm}",
            "seed": 42,
            "arm": arm,
            "candidate_count": 48,
            "post_gen0_candidate_count": 24,
            "llm_calls": 48,
            "llm_tokens": 720,
            "synthesis_evaluations": 27,
            "run_wall_seconds": 30.0,
        }
        for arm in report.ARMS
    ]


def _write_arm_evidence_manifest(
    root: Path, extra_evidence: tuple[Path, ...] = ()
) -> Path:
    manifest = root / "arm_evidence_manifest.sha256"
    paths = {
        path.resolve()
        for path in root.rglob("*")
        if path.is_file() and path.resolve() != manifest.resolve()
    } | {path.resolve() for path in extra_evidence}
    lines = [
        f"{hashlib.sha256(path.read_bytes()).hexdigest()}  "
        f"{os.path.relpath(path, root)}"
        for path in sorted(paths)
    ]
    manifest.write_text("\n".join(lines) + "\n", encoding="utf-8")
    return manifest


def _write_h10_ledger(
    path: Path,
    worksheet_path: Path,
    smoke_resources: list[dict[str, Any]],
    full_resources: list[dict[str, Any]] | None = None,
) -> dict[str, str]:
    worksheet = admission._load_worksheet(worksheet_path)
    worksheet_hash = hashlib.sha256(worksheet_path.read_bytes()).hexdigest()
    implementation_path = path.parent / "implementation.yaml"
    implementation_path.write_text("version: 1\n", encoding="utf-8")
    implementation = {
        "path": str(implementation_path.resolve()),
        "manifest_sha256": hashlib.sha256(implementation_path.read_bytes()).hexdigest(),
    }
    resources = {
        row["arm_id"]: {
            "candidates": row["candidate_count"],
            "calls": row["llm_calls"],
            "tokens": row["llm_tokens"],
            "synthesis": row["synthesis_evaluations"],
            "wall_seconds": str(row["run_wall_seconds"]),
        }
        for row in smoke_resources
    }
    if full_resources is not None:
        for row in full_resources:
            resources[row["arm_id"]] = {
                "candidates": row["candidate_count"],
                "calls": row["llm_calls"],
                "tokens": row["llm_tokens"],
                "synthesis": row["synthesis_evaluations"],
                "wall_seconds": str(row["run_wall_seconds"]),
            }

    events: list[dict[str, Any]] = [
        {
            "kind": "ledger_start",
            "program_start_utc": admission.PROGRAM_START_UTC,
            "program_deadline_utc": admission.PROGRAM_DEADLINE_UTC,
            "wave_id": "wave2",
        }
    ]
    start = datetime(2026, 7, 21, tzinfo=timezone.utc)
    selected = (
        worksheet["arms"] if full_resources is not None else worksheet["arms"][:2]
    )
    for index, arm in enumerate(selected):
        arm_id = arm["id"]
        admitted_at = start + timedelta(minutes=2 * index)
        captured_at = admitted_at + timedelta(minutes=1)
        source = next(
            row
            for row in smoke_resources + (full_resources or [])
            if row["arm_id"] == arm_id
        )
        source["run_start_utc"] = (admitted_at + timedelta(seconds=10)).isoformat()
        source["run_end_utc"] = (admitted_at + timedelta(seconds=20)).isoformat()
        evidence_value = source.get("accounting_evidence_path")
        evidence = (
            Path(evidence_value)
            if evidence_value is not None
            else path.parent / f"{arm_id}.evidence"
        )
        if evidence_value is None:
            evidence.write_text(arm_id, encoding="utf-8")
        source["accounting_evidence_path"] = str(evidence.resolve())
        source["accounting_evidence_sha256"] = hashlib.sha256(
            evidence.read_bytes()
        ).hexdigest()
        actual = resources[arm_id]
        accounting = path.parent / f"{arm_id}.yaml"
        accounting_payload = {
            "version": 1,
            "candidate_id": "H10",
            "worksheet_sha256": worksheet_hash,
            "arm_id": arm_id,
            "arm_status": "completed",
            "captured_at_utc": captured_at.isoformat(),
            "evidence_path": str(evidence),
            "evidence_sha256": hashlib.sha256(evidence.read_bytes()).hexdigest(),
            **actual,
        }
        accounting.write_text(
            yaml.safe_dump(accounting_payload, sort_keys=False), encoding="utf-8"
        )
        identity = {
            "wave_id": "wave2",
            "candidate_id": "H10",
            "worksheet_sha256": worksheet_hash,
            "implementation_manifest_path": implementation["path"],
            "implementation_manifest_sha256": implementation["manifest_sha256"],
            "arm_id": arm_id,
        }
        events.extend(
            [
                {
                    "kind": "admitted",
                    "admitted_at_utc": admitted_at.isoformat(),
                    **identity,
                },
                {
                    "kind": "completed",
                    "actual": actual,
                    "accounting_path": str(accounting),
                    "accounting_sha256": hashlib.sha256(
                        accounting.read_bytes()
                    ).hexdigest(),
                    "evidence_path": str(evidence),
                    "evidence_sha256": hashlib.sha256(
                        evidence.read_bytes()
                    ).hexdigest(),
                    "captured_at_utc": captured_at.isoformat(),
                    **identity,
                },
            ]
        )
    path.write_text(
        "\n".join(json.dumps(event, sort_keys=True) for event in events) + "\n",
        encoding="utf-8",
    )
    return implementation


def _read_failure(
    tmp_path: Path,
    seed: int,
    arm: str,
    problem: str,
    state: str,
) -> dict[tuple[int, Any, str], Any]:
    evidence = tmp_path / f"{arm}-{state}.txt"
    evidence.write_text(state, encoding="utf-8")
    registry = tmp_path / f"{arm}-{state}.yaml"
    registry.write_text(
        yaml.safe_dump(
            {
                "version": 1,
                "units": [
                    {
                        "seed": seed,
                        "arm": arm,
                        "problem": problem,
                        "state": state,
                        "evidence_path": str(evidence),
                        "evidence_sha256": hashlib.sha256(
                            evidence.read_bytes()
                        ).hexdigest(),
                    }
                ],
            },
            sort_keys=False,
        )
    )
    return report._read_failures(registry)


def test_raw_repair_reader_counts_design_once_and_validates_telemetry(
    tmp_path: Path,
) -> None:
    _write_problem(tmp_path, treatment=True)

    row = report._repair_rows(
        "treatment",
        tmp_path,
        ["Prob001"],
        generations=1,
        excluded=set(),
        ppa_problems=set(),
    )["Prob001"]

    assert row["repair_event_count"] == 2
    assert row["repaired_design"] == 1
    assert row["gen0_prefixed_failure_count"] == 7
    assert row["selected_prefixed_parent_count"] == 2
    assert row["telemetry_valid"] == 1


def test_raw_repair_reader_rejects_inconsistent_success(tmp_path: Path) -> None:
    problem = _write_problem(tmp_path)
    path = problem / "generation_log.jsonl"
    rows = [json.loads(line) for line in path.read_text().splitlines()]
    rows[1]["generated_candidates"][0]["ppa_success"] = False
    path.write_text("\n".join(json.dumps(row) for row in rows) + "\n")

    with pytest.raises(AssertionError):
        report._repair_rows(
            "classic",
            tmp_path,
            ["Prob001"],
            generations=1,
            excluded=set(),
            ppa_problems=set(),
        )


def test_raw_repair_reader_rejects_same_generation_parent(tmp_path: Path) -> None:
    problem = _write_problem(tmp_path)
    path = problem / "generation_log.jsonl"
    rows = [json.loads(line) for line in path.read_text().splitlines()]
    child = rows[1]["generated_candidates"][-1]
    child["parent_ids"] = ["g1-0"]
    path.write_text("\n".join(json.dumps(row) for row in rows) + "\n")

    with pytest.raises(AssertionError):
        report._repair_rows(
            "classic",
            tmp_path,
            ["Prob001"],
            generations=1,
            excluded=set(),
            ppa_problems=set(),
        )


def test_raw_repair_reader_rejects_external_code_path(tmp_path: Path) -> None:
    problem = _write_problem(tmp_path)
    log = problem / "generation_log.jsonl"
    rows = [json.loads(line) for line in log.read_text().splitlines()]
    external = tmp_path / "external.sv"
    external.write_text("module test; endmodule\n", encoding="utf-8")
    rows[0]["generated_candidates"][0]["code_file_path"] = str(external)
    log.write_text("\n".join(json.dumps(row) for row in rows) + "\n")

    with pytest.raises(AssertionError):
        report._repair_rows("classic", tmp_path, ["Prob001"], 1, set(), set())


def test_telemetry_rejects_unbound_consumed_hash(tmp_path: Path) -> None:
    problem = _write_problem(tmp_path, treatment=True)
    path = problem / "verified_status_feedback_telemetry.jsonl"
    rows = [json.loads(line) for line in path.read_text().splitlines()]
    failed = next(row for row in rows if row["status"] != "success")
    failed["consumed_feedback_sha256"] = failed["critic_analysis_sha256"]
    path.write_text("\n".join(json.dumps(row) for row in rows) + "\n")

    with pytest.raises(AssertionError):
        report._repair_rows(
            "treatment",
            tmp_path,
            ["Prob001"],
            generations=1,
            excluded=set(),
            ppa_problems=set(),
        )


def test_telemetry_rejects_unbound_selected_parent_use(tmp_path: Path) -> None:
    problem = _write_problem(tmp_path, treatment=True)
    path = problem / "verified_status_feedback_use_telemetry.jsonl"
    rows = [json.loads(line) for line in path.read_text().splitlines()]
    rows[0]["feedback_sha256"] = "0" * 64
    path.write_text("\n".join(json.dumps(row) for row in rows) + "\n")

    with pytest.raises(AssertionError):
        report._repair_rows(
            "treatment",
            tmp_path,
            ["Prob001"],
            generations=1,
            excluded=set(),
            ppa_problems=set(),
        )


def test_telemetry_rejects_payload_without_transformed_feedback(
    tmp_path: Path,
) -> None:
    problem = _write_problem(tmp_path, treatment=True)
    path = problem / "verified_status_feedback_use_telemetry.jsonl"
    rows = [json.loads(line) for line in path.read_text().splitlines()]
    payload = json.dumps({"feedback": "analysis only"}, indent=2)
    rows[0]["serialized_parent_payload"] = payload
    rows[0]["serialized_parent_utf8_bytes"] = len(payload.encode())
    rows[0]["serialized_parent_sha256"] = hashlib.sha256(payload.encode()).hexdigest()
    path.write_text("\n".join(json.dumps(row) for row in rows) + "\n")

    with pytest.raises(AssertionError):
        report._repair_rows(
            "treatment",
            tmp_path,
            ["Prob001"],
            generations=1,
            excluded=set(),
            ppa_problems=set(),
        )


def test_pair_config_rejects_shared_frozen_field_drift(
    monkeypatch: pytest.MonkeyPatch, tmp_path: Path
) -> None:
    problems = ["Prob001"]
    classic = tmp_path / "classic"
    treatment = tmp_path / "treatment"
    config_path = _write_config(classic, "revolution", 42, problems, 1)
    _write_config(treatment, "revolution_verified_status_feedback", 42, problems, 1)
    _use_test_config_contract(monkeypatch, config_path)
    report._validate_pair_configs(classic, treatment, 42, problems, 1)

    for root in (classic, treatment):
        path = next(root.glob("*_revolution_config.yaml"))
        payload = yaml.safe_load(path.read_text())
        payload["ucb_c"] = 999.0
        path.write_text(yaml.safe_dump(payload, sort_keys=False))
    with pytest.raises(AssertionError):
        report._validate_pair_configs(classic, treatment, 42, problems, 1)

    for root in (classic, treatment):
        path = next(root.glob("*_revolution_config.yaml"))
        payload = yaml.safe_load(path.read_text())
        payload["ucb_c"] = 2.0
        payload["qd_alpha"] = 0.5
        path.write_text(yaml.safe_dump(payload, sort_keys=False))
    with pytest.raises(AssertionError):
        report._validate_pair_configs(classic, treatment, 42, problems, 1)

    for root in (classic, treatment):
        path = next(root.glob("*_revolution_config.yaml"))
        payload = yaml.safe_load(path.read_text())
        payload["qd_alpha"] = None
        payload["unregistered"] = True
        path.write_text(yaml.safe_dump(payload, sort_keys=False))
    with pytest.raises(AssertionError):
        report._validate_pair_configs(classic, treatment, 42, problems, 1)


def test_report_rejects_unregistered_manifest(tmp_path: Path) -> None:
    manifest = tmp_path / "manifest.yaml"
    manifest.write_text("version: 1\n", encoding="utf-8")
    with pytest.raises(AssertionError):
        report.generate_report(manifest, tmp_path / "report")


def test_implementation_manifest_requires_exact_file_set(
    monkeypatch: pytest.MonkeyPatch, tmp_path: Path
) -> None:
    source = tmp_path / "source.py"
    source.write_text("pass\n", encoding="utf-8")
    subprocess.run(["git", "init", "-q", str(tmp_path)], check=True)
    subprocess.run(
        ["git", "-C", str(tmp_path), "config", "user.email", "test@example.com"],
        check=True,
    )
    subprocess.run(
        ["git", "-C", str(tmp_path), "config", "user.name", "Test"], check=True
    )
    subprocess.run(["git", "-C", str(tmp_path), "add", "source.py"], check=True)
    subprocess.run(
        ["git", "-C", str(tmp_path), "commit", "-qm", "Add source"], check=True
    )
    commit = subprocess.run(
        ["git", "-C", str(tmp_path), "rev-parse", "HEAD"],
        check=True,
        capture_output=True,
        text=True,
    ).stdout.strip()
    monkeypatch.setattr(report, "REPO_ROOT", tmp_path)
    monkeypatch.setattr(report, "IMPLEMENTATION_FILES", {"source.py"})
    manifest = tmp_path / "implementation.yaml"
    payload = {
        "version": 1,
        "candidate_id": "H10",
        "commit": commit,
        "files": {"source.py": hashlib.sha256(source.read_bytes()).hexdigest()},
    }
    manifest.write_text(yaml.safe_dump(payload), encoding="utf-8")
    subprocess.run(
        ["git", "-C", str(tmp_path), "add", "implementation.yaml"], check=True
    )
    subprocess.run(
        ["git", "-C", str(tmp_path), "commit", "-qm", "Bind implementation"],
        check=True,
    )
    assert report._validate_implementation_manifest(manifest)["commit"] == commit

    payload["commit"] = "a" * 40
    manifest.write_text(yaml.safe_dump(payload), encoding="utf-8")
    with pytest.raises(AssertionError):
        report._validate_implementation_manifest(manifest)

    payload["commit"] = commit
    payload["files"]["extra.py"] = "0" * 64
    manifest.write_text(yaml.safe_dump(payload), encoding="utf-8")
    with pytest.raises(AssertionError):
        report._validate_implementation_manifest(manifest)


def test_raw_hv_auc_recomputes_and_checks_success_count(
    monkeypatch: pytest.MonkeyPatch, tmp_path: Path
) -> None:
    problem = _write_problem(tmp_path)
    reference = {
        "tns": 0.0,
        "wns": 0.0,
        "eff_clk_period": 0.0,
        "power": 100.0,
        "area": 100.0,
    }
    monkeypatch.setattr(report, "_reference_ppa", lambda _: reference)
    row = report._repair_rows(
        "classic",
        tmp_path,
        ["Prob001"],
        generations=1,
        excluded=set(),
        ppa_problems={"Prob001"},
    )["Prob001"]
    assert row["valid_ppa_sample_count"] == 9
    assert row["final_hv"] == pytest.approx(0.04)
    assert row["hv_auc"] == pytest.approx(0.02005)

    log = problem / "generation_log.jsonl"
    original_log = log.read_text()
    generations = [json.loads(line) for line in original_log.splitlines()]
    moved = generations[1]["population_ppa_details"].pop()
    generations[0]["population_ppa_details"].append(moved)
    log.write_text("\n".join(json.dumps(row) for row in generations) + "\n")
    with pytest.raises(AssertionError):
        report._repair_rows(
            "classic",
            tmp_path,
            ["Prob001"],
            generations=1,
            excluded=set(),
            ppa_problems={"Prob001"},
        )

    log.write_text(original_log)
    summary_path = problem / "Prob001_summary.json"
    summary = json.loads(summary_path.read_text())
    summary["ref_ppa_metric"]["power"] = 101.0
    summary_path.write_text(json.dumps(summary))
    with pytest.raises(AssertionError):
        report._repair_rows(
            "classic",
            tmp_path,
            ["Prob001"],
            generations=1,
            excluded=set(),
            ppa_problems={"Prob001"},
        )


def test_arm_evidence_manifest_binds_exact_raw_tree(tmp_path: Path) -> None:
    root = tmp_path / "stage/seed_42/classic"
    root.mkdir(parents=True)
    scheduler = root / "run_scheduler_telemetry.json"
    scheduler.write_text('{"run_wall_seconds": 30}\n', encoding="utf-8")
    artifact = root / "artifact.jsonl"
    artifact.write_text("{}\n", encoding="utf-8")
    registry = tmp_path / "stage/unit_failures.yaml"
    registry.write_text("version: 1\nunits: []\n", encoding="utf-8")
    manifest = _write_arm_evidence_manifest(root, (registry,))

    wall, evidence, digest = report._read_run_wall(root, (registry,))

    assert wall == 30.0
    assert evidence == manifest.resolve()
    assert digest == hashlib.sha256(manifest.read_bytes()).hexdigest()

    artifact.write_text('{"changed": true}\n', encoding="utf-8")
    with pytest.raises(AssertionError):
        report._read_run_wall(root, (registry,))


def test_nonheadline_ppa_success_requires_generation_detail(tmp_path: Path) -> None:
    problem = _write_problem(tmp_path)
    log = problem / "generation_log.jsonl"
    rows = [json.loads(line) for line in log.read_text().splitlines()]
    rows[1]["population_ppa_details"] = []
    log.write_text("\n".join(json.dumps(row) for row in rows) + "\n")
    with pytest.raises(AssertionError):
        report._repair_rows("classic", tmp_path, ["Prob001"], 1, set(), set())


def test_leave_one_problem_out_rejects_plus_one_and_accepts_plus_two() -> None:
    one_rows, headline = _full_rows({1001: {"Prob000"}, 1002: {"Prob001"}})
    one = report.evaluate_full_suite(one_rows, _resources(), headline, True, True)
    assert one["performance_gate"] == "RETIRED"
    assert one["breadth"]["benefit_pass"] is False

    two_rows, headline = _full_rows(
        {
            1001: {"Prob000", "Prob001"},
            1002: {"Prob002", "Prob003"},
        }
    )
    two = report.evaluate_full_suite(two_rows, _resources(), headline, True, True)
    assert two["performance_gate"] == "VIABLE"
    assert two["breadth"]["benefit_pass"] is True


def test_gain_in_only_one_seed_fails() -> None:
    rows, headline = _full_rows({1001: {"Prob000", "Prob001"}, 1002: set()})
    summary = report.evaluate_full_suite(rows, _resources(), headline, True, True)
    assert summary["performance_gate"] == "RETIRED"
    assert summary["breadth"]["per_seed"][1]["delta"] == 0


def test_missing_treatment_retires_and_classic_infrastructure_blocks() -> None:
    rows, headline = _full_rows(
        {
            1001: {"Prob000", "Prob001"},
            1002: {"Prob002", "Prob003"},
        }
    )
    treatment = next(
        row
        for row in rows
        if row["seed"] == 1001
        and row["arm"] == "treatment"
        and row["problem"] == "Prob010"
    )
    treatment["unit_status"] = "treatment_malformed"
    treatment["telemetry_valid"] = 0
    treatment["prompt_use_valid"] = 0
    treatment["verification_complete_valid_ppa"] = 0
    treatment["rtl_simulation_functionality"] = 0
    treatment["final_hv"] = None
    treatment["hv_auc"] = None
    resources = _resources()
    resources[1]["candidate_count"] = 2352
    resources[1]["post_gen0_candidate_count"] = 1960
    summary = report.evaluate_full_suite(rows, resources, headline, True, True)
    assert summary["performance_gate"] == "RETIRED"
    assert summary["gate_results"]["evidence_complete"] is False
    assert summary["statistics"]["final_hv"]["missing_treatment_count"] == 1
    assert summary["statistics"]["final_hv"]["imputed_loss_count"] == 1
    assert summary["statistics"]["final_hv"]["paired_count"] == 91

    treatment["unit_status"] = "complete"
    treatment["telemetry_valid"] = 1
    treatment["prompt_use_valid"] = 1
    treatment["verification_complete_valid_ppa"] = 1
    treatment["rtl_simulation_functionality"] = 1
    treatment["final_hv"] = 0.1
    treatment["hv_auc"] = 0.08
    classic = next(
        row
        for row in rows
        if row["seed"] == 1001
        and row["arm"] == "classic"
        and row["problem"] == "Prob010"
    )
    classic["unit_status"] = "classic_infrastructure_missing"
    classic["verification_complete_valid_ppa"] = 0
    classic["rtl_simulation_functionality"] = 0
    classic["final_hv"] = None
    classic["hv_auc"] = None
    summary = report.evaluate_full_suite(rows, _resources(), headline, True, True)
    assert summary["performance_gate"] == "BLOCKED"

    classic["unit_status"] = "classic_invalid"
    summary = report.evaluate_full_suite(rows, _resources(), headline, True, True)
    assert summary["performance_gate"] == "RETIRED"


def test_classic_method_failure_is_excluded_from_ppa_gates() -> None:
    rows, headline = _full_rows(
        {1001: {"Prob000", "Prob001"}, 1002: {"Prob002", "Prob003"}}
    )
    classic = next(
        row
        for row in rows
        if row["seed"] == 1001
        and row["arm"] == "classic"
        and row["problem"] == "Prob010"
    )
    classic["verification_complete_valid_ppa"] = 0
    classic["final_hv"] = 0.0
    classic["hv_auc"] = 0.0

    summary = report.evaluate_full_suite(rows, _resources(), headline, True, True)

    assert summary["statistics"]["final_hv"]["unit_count"] == 91
    assert summary["classic_method_failures"] == {
        "count": 1,
        "treatment_only_success_count": 1,
        "units": [{"seed": 1001, "problem": "Prob010"}],
    }


def test_catastrophic_hv_ratio_cannot_hide_behind_absolute_margin() -> None:
    rows, headline = _full_rows(
        {1001: {"Prob000", "Prob001"}, 1002: {"Prob002", "Prob003"}}
    )
    for row in rows:
        if row["problem"] not in headline:
            continue
        row["final_hv"] = 0.01 if row["arm"] == "classic" else 0.0051

    summary = report.evaluate_full_suite(rows, _resources(), headline, True, True)

    assert summary["statistics"]["final_hv"]["mean_delta"] == pytest.approx(-0.0049)
    assert summary["catastrophic_final_hv_ratio"] == pytest.approx(0.51)
    assert summary["gate_results"]["final_hv_noninferiority"] is True
    assert summary["gate_results"]["catastrophic_final_hv_ratio"] is False
    assert summary["performance_gate"] == "RETIRED"


@pytest.mark.parametrize(
    "keys",
    [
        ("code", "backend", "sha256"),
        ("benchmarks", "representative", "selection_artifact_sha256"),
        ("benchmarks", "full_suite", "run_manifest_sha256"),
        ("benchmarks", "full_suite", "headline_manifest_sha256"),
        ("benchmarks", "holdout", "manifest_sha256"),
        ("benchmarks", "holdout", "prior_exposure_manifest_sha256"),
    ],
)
def test_frozen_inputs_reject_changed_program_dependency(
    keys: tuple[str, ...],
) -> None:
    program = yaml.safe_load(report.PROGRAM_MANIFEST.read_text(encoding="utf-8"))
    value = program
    for key in keys[:-1]:
        value = value[key]
    value[keys[-1]] = "0" * 64

    with pytest.raises(AssertionError):
        report._validate_frozen_inputs(program)


def test_registered_unit_states_require_disjoint_artifact_presence(
    tmp_path: Path,
) -> None:
    _write_problem(tmp_path)
    program = {
        "budgets": {
            "per_problem": {
                "llm_calls": 100,
                "llm_tokens": 650000,
                "synthesis_evaluations": 48,
                "wall_seconds": 2400,
            }
        }
    }
    malformed = _read_failure(
        tmp_path, 1001, "treatment", "Prob001", "treatment_malformed"
    )
    rows = report._build_arm_rows(
        "treatment", tmp_path, 1001, ["Prob001"], 1, program, malformed, set()
    )
    assert rows[0]["unit_status"] == "treatment_malformed"

    classic_invalid = _read_failure(
        tmp_path, 1001, "classic", "Prob001", "classic_invalid"
    )
    rows = report._build_arm_rows(
        "classic", tmp_path, 1001, ["Prob001"], 1, program, classic_invalid, set()
    )
    assert rows[0]["unit_status"] == "classic_invalid"

    for state, arm in (
        ("treatment_missing", "treatment"),
        ("classic_infrastructure_missing", "classic"),
    ):
        with pytest.raises(AssertionError):
            failures = _read_failure(tmp_path, 1001, arm, "Prob001", state)
            report._build_arm_rows(
                arm,
                tmp_path,
                1001,
                ["Prob001"],
                1,
                program,
                failures,
                set(),
            )


def test_failure_registry_rejects_external_evidence(tmp_path: Path) -> None:
    root = tmp_path / "raw"
    root.mkdir()
    evidence = tmp_path / "outside.txt"
    evidence.write_text("failure", encoding="utf-8")
    registry = root / "unit_failures.yaml"
    registry.write_text(
        yaml.safe_dump(
            {
                "version": 1,
                "units": [
                    {
                        "seed": 1001,
                        "arm": "treatment",
                        "problem": "Prob001",
                        "state": "treatment_missing",
                        "evidence_path": str(evidence),
                        "evidence_sha256": hashlib.sha256(
                            evidence.read_bytes()
                        ).hexdigest(),
                    }
                ],
            }
        ),
        encoding="utf-8",
    )
    with pytest.raises(AssertionError):
        report._read_failures(registry)


def test_evaluator_rejects_unknown_unit_state() -> None:
    rows, headline = _full_rows(
        {1001: {"Prob000", "Prob001"}, 1002: {"Prob002", "Prob003"}}
    )
    rows[0]["unit_status"] = "unknown"
    with pytest.raises(AssertionError):
        report.evaluate_full_suite(rows, _resources(), headline, True, True)


def test_per_seed_coverage_cannot_net_cross_seed_gain() -> None:
    rows, headline = _full_rows(
        {
            1001: {"Prob000", "Prob001"},
            1002: {"Prob002", "Prob003"},
        }
    )
    for problem in ("Prob010", "Prob011"):
        row = next(
            item
            for item in rows
            if item["seed"] == 1001
            and item["arm"] == "treatment"
            and item["problem"] == problem
        )
        row["verification_complete_valid_ppa"] = 0
        row["rtl_simulation_functionality"] = 0
    classic = next(
        item
        for item in rows
        if item["seed"] == 1002
        and item["arm"] == "classic"
        and item["problem"] == "Prob012"
    )
    classic["verification_complete_valid_ppa"] = 0
    classic["rtl_simulation_functionality"] = 0

    summary = report.evaluate_full_suite(rows, _resources(), headline, True, True)
    gates = summary["gate_results"]
    assert gates["valid_ppa46_noninferiority"] is False
    assert gates["rtl_functionality46_noninferiority"] is False
    assert gates["rtl_functionality50_noninferiority"] is False


def test_catastrophic_coverage_uses_loss_only_reduction() -> None:
    rows, headline = _full_rows(
        {1001: {"Prob000", "Prob001"}, 1002: {"Prob002", "Prob003"}}
    )
    for problem in ("Prob010", "Prob011", "Prob012", "Prob013"):
        treatment = next(
            row
            for row in rows
            if row["seed"] == 1001
            and row["arm"] == "treatment"
            and row["problem"] == problem
        )
        treatment["verification_complete_valid_ppa"] = 0
        treatment["rtl_simulation_functionality"] = 0
    for problem in ("Prob020", "Prob021", "Prob022"):
        classic = next(
            row
            for row in rows
            if row["seed"] == 1002
            and row["arm"] == "classic"
            and row["problem"] == problem
        )
        classic["verification_complete_valid_ppa"] = 0
        classic["rtl_simulation_functionality"] = 0

    summary = report.evaluate_full_suite(rows, _resources(), headline, True, True)

    assert summary["catastrophic_coverage_loss"] == {
        "valid_ppa46": 4,
        "rtl_functionality46": 4,
        "rtl_functionality50": 4,
    }
    assert summary["gate_results"]["valid_ppa46_catastrophic"] is False
    assert summary["gate_results"]["rtl_functionality46_catastrophic"] is False
    assert summary["gate_results"]["rtl_functionality50_catastrophic"] is False


def test_exact_200_rows_and_candidate_accounting(tmp_path: Path) -> None:
    rows, headline = _full_rows(
        {
            1001: {"Prob000", "Prob001"},
            1002: {"Prob002", "Prob003"},
        }
    )
    paired, leave_one_out, _ = report._detail_rows(rows)
    report._write_csv(tmp_path / "rows.csv", rows)
    with (tmp_path / "rows.csv").open(newline="", encoding="utf-8") as handle:
        assert len(list(csv.DictReader(handle))) == 200
    assert len(paired) == 100
    assert len(leave_one_out) == 100

    resources = _resources()
    resources[0]["post_gen0_candidate_count"] = 1999
    summary = report.evaluate_full_suite(rows, resources, headline, True, True)
    assert summary["gate_results"]["candidate_budget_equality"] is False
    assert summary["performance_gate"] == "RETIRED"


def test_process_ledger_replays_accounting_and_allows_completed_suffix(
    monkeypatch: pytest.MonkeyPatch, tmp_path: Path
) -> None:
    worksheet = (
        _ROOT
        / "docs/journal_features/revamp_history"
        / "20260720_191404_KST_tcad_revolution_extension"
        / "candidates/H10_verified_status_feedback/candidate_budget.yaml"
    )
    ledger = tmp_path / "ledger.jsonl"
    resources = _smoke_resources()
    full_resources = _resources()
    implementation = _write_h10_ledger(ledger, worksheet, resources, full_resources)
    initial_ledger_sha256 = hashlib.sha256(
        ledger.read_bytes().splitlines(keepends=True)[0]
    ).hexdigest()
    program = tmp_path / "program.yaml"
    program.write_text(
        "wave2_resource_compliance:\n"
        f"  program_ledger_path: {ledger}\n"
        f"  initial_program_ledger_sha256: {initial_ledger_sha256}\n",
        encoding="utf-8",
    )
    monkeypatch.setattr(report, "PROGRAM_MANIFEST", program)
    assert report._ledger_pass("smoke", worksheet, resources, implementation) is True
    assert (
        report._ledger_pass(
            "full_suite",
            worksheet,
            resources + full_resources,
            implementation,
        )
        is True
    )

    original_ledger = ledger.read_text()
    ledger.write_text(" " + original_ledger)
    assert report._ledger_pass("smoke", worksheet, resources, implementation) is False
    ledger.write_text(original_ledger)

    events = [json.loads(line) for line in original_ledger.splitlines()]
    admitted = [event for event in events if event["kind"] == "admitted"]
    admitted[1]["admitted_at_utc"] = admitted[0]["admitted_at_utc"]
    ledger.write_text(
        "\n".join(json.dumps(event, sort_keys=True) for event in events) + "\n"
    )
    assert report._ledger_pass("smoke", worksheet, resources, implementation) is False
    ledger.write_text(original_ledger)

    outside_window = [dict(row) for row in resources]
    outside_window[0]["run_start_utc"] = "2026-07-20T23:59:00+00:00"
    assert (
        report._ledger_pass("smoke", worksheet, outside_window, implementation) is False
    )

    wrong_evidence = [dict(row) for row in resources]
    wrong_evidence[0]["accounting_evidence_sha256"] = "0" * 64
    assert (
        report._ledger_pass("smoke", worksheet, wrong_evidence, implementation) is False
    )

    mismatched_report = [dict(row) for row in resources]
    mismatched_report[0]["llm_calls"] += 1
    assert (
        report._ledger_pass("smoke", worksheet, mismatched_report, implementation)
        is False
    )

    events = [json.loads(line) for line in original_ledger.splitlines()]
    completed = next(event for event in events if event["kind"] == "completed")
    completed["actual"]["calls"] += 1
    ledger.write_text(
        "\n".join(json.dumps(event, sort_keys=True) for event in events) + "\n"
    )
    assert report._ledger_pass("smoke", worksheet, resources, implementation) is False


def test_generate_report_smoke_end_to_end(
    monkeypatch: pytest.MonkeyPatch, tmp_path: Path
) -> None:
    original_program = yaml.safe_load(report.PROGRAM_MANIFEST.read_text())
    original_program["status"] = "FROZEN"
    problems = original_program["benchmarks"]["smoke"]["problems"]
    worksheet = (
        _ROOT
        / "docs/journal_features/revamp_history"
        / "20260720_191404_KST_tcad_revolution_extension"
        / "candidates/H10_verified_status_feedback/candidate_budget.yaml"
    )
    raw_root = tmp_path / "raw"
    for arm, mode in (
        ("classic", "revolution"),
        ("treatment", "revolution_verified_status_feedback"),
    ):
        root = raw_root / "seed_42" / arm
        _write_config(root, mode, 42, problems, 1)
        for problem in problems:
            _write_problem(
                root,
                problem,
                treatment=arm == "treatment",
                start_minute=0 if arm == "classic" else 2,
            )
        (root / "run_scheduler_telemetry.json").write_text(
            json.dumps({"arm": arm, "run_wall_seconds": 30.0}), encoding="utf-8"
        )

    failures = raw_root / "unit_failures.yaml"
    failures.write_text("version: 1\nunits: []\n", encoding="utf-8")
    for arm in report.ARMS:
        root = raw_root / "seed_42" / arm
        extras = (failures,) if arm == "treatment" else ()
        _write_arm_evidence_manifest(root, extras)
    resources = _smoke_resources()
    for row in resources:
        evidence = raw_root / "seed_42" / row["arm"] / "arm_evidence_manifest.sha256"
        row["accounting_evidence_path"] = str(evidence.resolve())
    ledger = tmp_path / "ledger.jsonl"
    implementation = _write_h10_ledger(ledger, worksheet, resources)
    compliance = original_program["wave2_resource_compliance"]
    compliance["program_ledger_path"] = str(ledger)
    compliance["initial_program_ledger_sha256"] = hashlib.sha256(
        ledger.read_bytes().splitlines(keepends=True)[0]
    ).hexdigest()
    program = tmp_path / "program.yaml"
    program.write_text(yaml.safe_dump(original_program, sort_keys=False))
    monkeypatch.setattr(report, "PROGRAM_MANIFEST", program)
    monkeypatch.setattr(
        report,
        "PROGRAM_MANIFEST_SHA256",
        hashlib.sha256(program.read_bytes()).hexdigest(),
    )
    _use_test_config_contract(
        monkeypatch,
        next((raw_root / "seed_42" / "classic").rglob("*_revolution_config.yaml")),
    )

    manifest = tmp_path / "manifest.yaml"
    manifest.write_text(
        yaml.safe_dump(
            {
                "version": 1,
                "candidate_id": "H10",
                "candidate_mode": "revolution_verified_status_feedback",
                "stage": "smoke",
                "raw_root": str(raw_root),
                "worksheet_path": str(worksheet),
                "implementation_manifest": str(tmp_path / "implementation.yaml"),
                "unit_failure_registry": str(failures),
            },
            sort_keys=False,
        )
    )
    monkeypatch.setattr(
        report,
        "REPORT_MANIFEST_SHA256",
        {manifest.resolve(): hashlib.sha256(manifest.read_bytes()).hexdigest()},
    )
    monkeypatch.setattr(
        report,
        "_validate_implementation_manifest",
        lambda _: {"commit": "a" * 40, **implementation},
    )
    output = tmp_path / "report"
    summary = report.generate_report(manifest, output)

    assert summary["smoke_gate"] == "PASS"
    with (output / "arm_problem_rows.csv").open(newline="") as handle:
        assert len(list(csv.DictReader(handle))) == 6

    with pytest.raises(AssertionError):
        report.generate_report(manifest, raw_root / "report")

    substituted = tmp_path / "substituted_failures.yaml"
    substituted.write_text(failures.read_text(), encoding="utf-8")
    payload = yaml.safe_load(manifest.read_text())
    payload["unit_failure_registry"] = str(substituted)
    manifest.write_text(yaml.safe_dump(payload, sort_keys=False))
    monkeypatch.setattr(
        report,
        "REPORT_MANIFEST_SHA256",
        {manifest.resolve(): hashlib.sha256(manifest.read_bytes()).hexdigest()},
    )
    with pytest.raises(AssertionError):
        report.generate_report(manifest, tmp_path / "substituted_report")
