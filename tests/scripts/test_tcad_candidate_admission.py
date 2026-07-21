from __future__ import annotations

import csv
import hashlib
import json
import subprocess
import sys
from copy import deepcopy
from datetime import datetime, timezone
from decimal import ROUND_CEILING, Decimal
from pathlib import Path
from typing import Any

import pytest
import yaml

import scripts.tcad_candidate_admission as admission
from scripts.tcad_candidate_admission import (
    ARM_CONTRACT,
    FROZEN_THRESHOLDS,
    PROGRAM_DEADLINE_UTC,
    PROGRAM_START_UTC,
    RESOURCE_FIELDS,
    _load_ledger,
    _load_worksheet,
    _resources,
    admission_status,
    main,
    post_arm_status,
)


NOW = datetime(2026, 7, 21, tzinfo=timezone.utc)


def _raw_resources(values: tuple[int | str, ...]) -> dict[str, int | str]:
    return dict(zip(RESOURCE_FIELDS, values, strict=True))


def _raw_worksheet(candidate_id: str = "H9") -> dict[str, Any]:
    arms: list[dict[str, Any]] = [
        {
            "id": arm_id,
            "pair": pair,
            "role": role,
            "caps": _raw_resources(tuple(values)),
        }
        for arm_id, pair, role, *values in ARM_CONTRACT
    ]
    return {
        "version": 1,
        "candidate_id": candidate_id,
        "wave_id": "wave2",
        "program_start_utc": PROGRAM_START_UTC,
        "program_deadline_utc": PROGRAM_DEADLINE_UTC,
        "thresholds": {
            name: _raw_resources(tuple(values))
            for name, values in FROZEN_THRESHOLDS.items()
        },
        "arms": arms,
    }


def _write_worksheet(path: Path, candidate_id: str = "H9") -> dict[str, Any]:
    path.write_text(
        yaml.safe_dump(_raw_worksheet(candidate_id), sort_keys=False),
        encoding="utf-8",
    )
    return _load_worksheet(path)


def _write_ledger(path: Path) -> None:
    header = {
        "kind": "ledger_start",
        "program_start_utc": PROGRAM_START_UTC,
        "program_deadline_utc": PROGRAM_DEADLINE_UTC,
        "wave_id": "wave2",
    }
    path.write_text(json.dumps(header, sort_keys=True) + "\n", encoding="utf-8")


def _identity(candidate_id: str = "H9") -> dict[str, str]:
    return {
        "wave_id": "wave2",
        "candidate_id": candidate_id,
        "worksheet_sha256": "worksheet",
    }


def _accounting(
    path: Path,
    worksheet_path: Path,
    evidence_path: Path,
    arm_id: str,
    candidates: int,
    wall_seconds: str = "0",
    arm_status: str = "completed",
) -> None:
    raw = {
        "version": 1,
        "candidate_id": "H9",
        "worksheet_sha256": hashlib.sha256(worksheet_path.read_bytes()).hexdigest(),
        "arm_id": arm_id,
        "arm_status": arm_status,
        "captured_at_utc": NOW.isoformat(),
        "evidence_path": str(evidence_path),
        "evidence_sha256": hashlib.sha256(evidence_path.read_bytes()).hexdigest(),
        "candidates": candidates,
        "calls": 0,
        "tokens": 0,
        "synthesis": 0,
        "wall_seconds": wall_seconds,
    }
    path.write_text(yaml.safe_dump(raw, sort_keys=False), encoding="utf-8")


def _cli(
    monkeypatch: pytest.MonkeyPatch,
    ledger_path: Path,
    argv: list[str],
) -> None:
    monkeypatch.setattr(admission, "PROGRAM_LEDGER", ledger_path)
    monkeypatch.setattr(admission, "_utc_now", lambda: NOW)
    monkeypatch.setattr(sys, "argv", argv)
    main()


def test_admission_passes_exact_frozen_thresholds(tmp_path: Path) -> None:
    worksheet = _write_worksheet(tmp_path / "worksheet.yaml")
    assert admission_status(worksheet, [], "smoke_classic", NOW) == "PASS"


def test_admission_stops_one_unit_above_each_threshold(tmp_path: Path) -> None:
    base = _write_worksheet(tmp_path / "base.yaml")
    frozen = {
        name: sum(
            (arm["caps"][name] for arm in base["arms"]),
            Decimal(0),
        )
        for name in RESOURCE_FIELDS
    }
    for scope in FROZEN_THRESHOLDS:
        for field in RESOURCE_FIELDS:
            worksheet = _write_worksheet(tmp_path / f"{scope}-{field}.yaml")
            worksheet["thresholds"][scope][field] = frozen[field] - Decimal(1)
            assert admission_status(worksheet, [], "smoke_classic", NOW) == "STOP"


def test_global_spend_is_charged_to_wave_and_program(tmp_path: Path) -> None:
    worksheet = _write_worksheet(tmp_path / "worksheet.yaml")
    prior = _resources(
        {
            "candidates": 31_000,
            "calls": 63_000,
            "tokens": 199_000_000,
            "synthesis": 17_000,
            "wall_seconds": "64000",
        }
    )
    events = [
        {
            "kind": "completed",
            "arm_id": "smoke_classic",
            "candidate_id": "H10",
            "actual": prior,
        }
    ]
    assert admission_status(worksheet, events, "smoke_classic", NOW) == "STOP"


def test_admission_stops_outside_program_window(tmp_path: Path) -> None:
    worksheet = _write_worksheet(tmp_path / "worksheet.yaml")
    before = datetime(2026, 7, 20, 14, 21, tzinfo=timezone.utc)
    near_deadline = datetime(2026, 8, 10, 14, 20, tzinfo=timezone.utc)
    assert admission_status(worksheet, [], "smoke_classic", before) == "STOP"
    assert admission_status(worksheet, [], "smoke_classic", near_deadline) == "STOP"


def test_worksheet_rejects_changed_window_or_threshold(tmp_path: Path) -> None:
    variants = []
    for start, deadline in (
        (PROGRAM_START_UTC, "2026-08-09T14:21:33+00:00"),
        ("2026-07-21T14:21:33+00:00", "2026-08-11T14:21:33+00:00"),
    ):
        raw = _raw_worksheet()
        raw["program_start_utc"] = start
        raw["program_deadline_utc"] = deadline
        variants.append(raw)
    changed = _raw_worksheet()
    changed["thresholds"]["program"]["tokens"] += 1
    variants.append(changed)

    for index, raw in enumerate(variants):
        path = tmp_path / f"worksheet-{index}.yaml"
        path.write_text(yaml.safe_dump(raw, sort_keys=False), encoding="utf-8")
        with pytest.raises(AssertionError):
            _load_worksheet(path)


def test_worksheet_rejects_changed_ladder(tmp_path: Path) -> None:
    variants = []
    missing = _raw_worksheet()
    missing["arms"] = missing["arms"][:-1]
    variants.append(missing)
    reordered = _raw_worksheet()
    reordered["arms"][0], reordered["arms"][1] = (
        reordered["arms"][1],
        reordered["arms"][0],
    )
    variants.append(reordered)
    duplicated = _raw_worksheet()
    duplicated["arms"][1] = deepcopy(duplicated["arms"][0])
    variants.append(duplicated)

    for index, raw in enumerate(variants):
        path = tmp_path / f"worksheet-{index}.yaml"
        path.write_text(yaml.safe_dump(raw, sort_keys=False), encoding="utf-8")
        with pytest.raises(AssertionError):
            _load_worksheet(path)


def test_post_arm_requires_exact_candidates_and_caps(tmp_path: Path) -> None:
    worksheet = _write_worksheet(tmp_path / "worksheet.yaml")
    events = [{"kind": "admitted", "arm_id": "smoke_classic", **_identity()}]
    cap = worksheet["arms"][0]["caps"]
    assert post_arm_status(worksheet, events, cap) == "PASS"
    for field in RESOURCE_FIELDS:
        actual = cap.copy()
        actual[field] += Decimal(1)
        assert post_arm_status(worksheet, events, actual) == "STOP"
    zero_candidates = cap.copy()
    zero_candidates["candidates"] = Decimal(0)
    assert post_arm_status(worksheet, events, zero_candidates) == "STOP"


def test_invalid_ledger_order_stops_admission(tmp_path: Path) -> None:
    worksheet = _write_worksheet(tmp_path / "worksheet.yaml")
    wrong = [{"kind": "admitted", "arm_id": "smoke_treatment", **_identity()}]
    duplicate = [
        {"kind": "admitted", "arm_id": "smoke_classic", **_identity()},
        {
            "kind": "completed",
            "arm_id": "smoke_classic",
            "actual": worksheet["arms"][0]["caps"],
            **_identity(),
        },
        {
            "kind": "completed",
            "arm_id": "smoke_classic",
            "actual": worksheet["arms"][0]["caps"],
            **_identity(),
        },
    ]
    assert admission_status(worksheet, wrong, "smoke_classic", NOW) == "STOP"
    assert admission_status(worksheet, duplicate, "smoke_treatment", NOW) == "STOP"


def test_cli_binds_admission_to_system_time_and_worksheet(
    tmp_path: Path,
    monkeypatch: pytest.MonkeyPatch,
    capsys: pytest.CaptureFixture[str],
) -> None:
    worksheet_path = tmp_path / "worksheet.yaml"
    ledger_path = tmp_path / "ledger.jsonl"
    _write_worksheet(worksheet_path)
    _write_ledger(ledger_path)
    _cli(
        monkeypatch,
        ledger_path,
        [
            "tcad_candidate_admission.py",
            "admit",
            "--worksheet",
            str(worksheet_path),
            "--arm",
            "smoke_classic",
        ],
    )

    assert capsys.readouterr().out == "PASS\n"
    event = json.loads(ledger_path.read_text().splitlines()[-1])
    assert event["admitted_at_utc"] == NOW.isoformat()
    assert event["worksheet_sha256"] == hashlib.sha256(
        worksheet_path.read_bytes()
    ).hexdigest()


def test_cli_wrong_arm_does_not_mutate_ledger(
    tmp_path: Path,
    monkeypatch: pytest.MonkeyPatch,
    capsys: pytest.CaptureFixture[str],
) -> None:
    worksheet_path = tmp_path / "worksheet.yaml"
    ledger_path = tmp_path / "ledger.jsonl"
    _write_worksheet(worksheet_path)
    _write_ledger(ledger_path)
    before = ledger_path.read_text()
    _cli(
        monkeypatch,
        ledger_path,
        [
            "tcad_candidate_admission.py",
            "admit",
            "--worksheet",
            str(worksheet_path),
            "--arm",
            "smoke_treatment",
        ],
    )
    assert capsys.readouterr().out == "STOP\n"
    assert ledger_path.read_text() == before


def test_active_candidate_blocks_another_candidate(
    tmp_path: Path,
    monkeypatch: pytest.MonkeyPatch,
    capsys: pytest.CaptureFixture[str],
) -> None:
    first_path = tmp_path / "H9.yaml"
    second_path = tmp_path / "H10.yaml"
    ledger_path = tmp_path / "ledger.jsonl"
    _write_worksheet(first_path, "H9")
    _write_worksheet(second_path, "H10")
    _write_ledger(ledger_path)
    _cli(
        monkeypatch,
        ledger_path,
        ["tool", "admit", "--worksheet", str(first_path), "--arm", "smoke_classic"],
    )
    assert capsys.readouterr().out == "PASS\n"
    before = ledger_path.read_text()

    _cli(
        monkeypatch,
        ledger_path,
        ["tool", "admit", "--worksheet", str(second_path), "--arm", "smoke_classic"],
    )

    assert capsys.readouterr().out == "STOP\n"
    assert ledger_path.read_text() == before


def test_ledger_rejects_overlapping_candidates(tmp_path: Path) -> None:
    ledger_path = tmp_path / "ledger.jsonl"
    _write_ledger(ledger_path)
    events = [
        {
            "kind": "admitted",
            "arm_id": "smoke_classic",
            "admitted_at_utc": NOW.isoformat(),
            **_identity("H9"),
        },
        {
            "kind": "admitted",
            "arm_id": "smoke_classic",
            "admitted_at_utc": NOW.isoformat(),
            **_identity("H10"),
        },
    ]
    with ledger_path.open("a", encoding="utf-8") as handle:
        for event in events:
            handle.write(json.dumps(event, sort_keys=True) + "\n")

    with pytest.raises(AssertionError):
        _load_ledger(ledger_path)


def test_concurrent_processes_admit_only_one_candidate(tmp_path: Path) -> None:
    root = Path(__file__).parents[2]
    ledger_path = tmp_path / admission.PROGRAM_LEDGER
    ledger_path.parent.mkdir(parents=True)
    _write_ledger(ledger_path)
    commands = []
    for index in range(4):
        worksheet_path = tmp_path / f"H{index}.yaml"
        _write_worksheet(worksheet_path, f"H{index}")
        commands.append(
            [
                sys.executable,
                str(root / "scripts/tcad_candidate_admission.py"),
                "admit",
                "--worksheet",
                str(worksheet_path),
                "--arm",
                "smoke_classic",
            ]
        )
    processes = [
        subprocess.Popen(
            command,
            cwd=tmp_path,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
        )
        for command in commands
    ]
    results = [process.communicate(timeout=10) for process in processes]

    assert all(process.returncode == 0 for process in processes)
    assert sorted(stdout.strip() for stdout, _ in results) == [
        "PASS",
        "STOP",
        "STOP",
        "STOP",
    ]
    events = _load_ledger(ledger_path)
    assert len(events) == 1
    assert events[0]["kind"] == "admitted"


def test_between_arms_blocks_another_candidate(tmp_path: Path) -> None:
    first = _write_worksheet(tmp_path / "H9.yaml", "H9")
    second = _write_worksheet(tmp_path / "H10.yaml", "H10")
    events = [
        {"kind": "admitted", "arm_id": "smoke_classic", **_identity("H9")},
        {
            "kind": "completed",
            "arm_id": "smoke_classic",
            "actual": first["arms"][0]["caps"],
            **_identity("H9"),
        },
    ]

    assert admission_status(second, events, "smoke_classic", NOW) == "STOP"


def test_terminal_candidate_allows_next_candidate(tmp_path: Path) -> None:
    first = _write_worksheet(tmp_path / "H9.yaml", "H9")
    second = _write_worksheet(tmp_path / "H10.yaml", "H10")
    completed: list[dict[str, Any]] = []
    for arm in first["arms"]:
        completed.extend(
            [
                {"kind": "admitted", "arm_id": arm["id"], **_identity("H9")},
                {
                    "kind": "completed",
                    "arm_id": arm["id"],
                    "actual": arm["caps"],
                    **_identity("H9"),
                },
            ]
        )
    stopped = [
        {
            "kind": "stopped",
            "arm_id": "smoke_classic",
            "reason": "admission_infeasible",
            **_identity("H9"),
        }
    ]

    assert admission_status(second, completed, "smoke_classic", NOW) == "PASS"
    assert admission_status(second, stopped, "smoke_classic", NOW) == "PASS"


def test_accounting_is_arm_bound_and_not_replayable(
    tmp_path: Path,
    monkeypatch: pytest.MonkeyPatch,
    capsys: pytest.CaptureFixture[str],
) -> None:
    worksheet_path = tmp_path / "worksheet.yaml"
    ledger_path = tmp_path / "ledger.jsonl"
    evidence_path = tmp_path / "evidence.json"
    accounting_path = tmp_path / "actual.yaml"
    _write_worksheet(worksheet_path)
    _write_ledger(ledger_path)
    evidence_path.write_text("{}\n", encoding="utf-8")

    _cli(
        monkeypatch,
        ledger_path,
        ["tool", "admit", "--worksheet", str(worksheet_path), "--arm", "smoke_classic"],
    )
    capsys.readouterr()
    _accounting(
        accounting_path,
        worksheet_path,
        evidence_path,
        "smoke_classic",
        48,
        "160.123456789",
    )
    _cli(
        monkeypatch,
        ledger_path,
        ["tool", "record", "--worksheet", str(worksheet_path), "--actual", str(accounting_path)],
    )
    assert capsys.readouterr().out == "PASS\n"
    completed = json.loads(ledger_path.read_text().splitlines()[-1])
    assert completed["actual"]["wall_seconds"] == "160.123456789"

    _cli(
        monkeypatch,
        ledger_path,
        ["tool", "admit", "--worksheet", str(worksheet_path), "--arm", "smoke_treatment"],
    )
    capsys.readouterr()
    before = ledger_path.read_text()
    _cli(
        monkeypatch,
        ledger_path,
        ["tool", "record", "--worksheet", str(worksheet_path), "--actual", str(accounting_path)],
    )
    assert capsys.readouterr().out == "STOP\n"
    assert ledger_path.read_text() == before

    second_accounting = tmp_path / "second-actual.yaml"
    _accounting(
        second_accounting,
        worksheet_path,
        evidence_path,
        "smoke_treatment",
        48,
    )
    _cli(
        monkeypatch,
        ledger_path,
        [
            "tool",
            "record",
            "--worksheet",
            str(worksheet_path),
            "--actual",
            str(second_accounting),
        ],
    )
    assert capsys.readouterr().out == "STOP\n"
    assert ledger_path.read_text() == before


@pytest.mark.parametrize(
    ("field", "value"),
    [
        ("candidates", 0),
        ("calls", 0.5),
        ("tokens", True),
        ("synthesis", -1),
        ("wall_seconds", 0.5),
        ("wall_seconds", "not-a-decimal"),
        ("arm_status", "killed"),
        ("captured_at_utc", "not-a-timestamp"),
        ("evidence_path", []),
        ("evidence_sha256", "bad"),
        ("document", "{\n"),
    ],
)
def test_invalid_accounting_cannot_erase_or_replace_spend(
    tmp_path: Path,
    monkeypatch: pytest.MonkeyPatch,
    capsys: pytest.CaptureFixture[str],
    field: str,
    value: Any,
) -> None:
    worksheet_path = tmp_path / "worksheet.yaml"
    ledger_path = tmp_path / "ledger.jsonl"
    evidence_path = tmp_path / "evidence.json"
    accounting_path = tmp_path / "actual.yaml"
    _write_worksheet(worksheet_path)
    _write_ledger(ledger_path)
    evidence_path.write_text("{}\n", encoding="utf-8")
    _cli(
        monkeypatch,
        ledger_path,
        ["tool", "admit", "--worksheet", str(worksheet_path), "--arm", "smoke_classic"],
    )
    capsys.readouterr()
    _accounting(accounting_path, worksheet_path, evidence_path, "smoke_classic", 48)
    if field == "document":
        accounting_path.write_text(value, encoding="utf-8")
    else:
        raw = yaml.safe_load(accounting_path.read_text())
        raw[field] = value
        accounting_path.write_text(
            yaml.safe_dump(raw, sort_keys=False), encoding="utf-8"
        )
    before = ledger_path.read_text()

    _cli(
        monkeypatch,
        ledger_path,
        ["tool", "record", "--worksheet", str(worksheet_path), "--actual", str(accounting_path)],
    )

    expected = "STOP\n"
    assert capsys.readouterr().out == expected
    if field == "candidates":
        assert json.loads(ledger_path.read_text().splitlines()[-1])["reason"] == (
            "post_arm_resource_gate"
        )
    else:
        assert ledger_path.read_text() == before


def test_ledger_detects_accounting_or_evidence_tampering(
    tmp_path: Path,
    monkeypatch: pytest.MonkeyPatch,
    capsys: pytest.CaptureFixture[str],
) -> None:
    worksheet_path = tmp_path / "worksheet.yaml"
    ledger_path = tmp_path / "ledger.jsonl"
    evidence_path = tmp_path / "evidence.json"
    accounting_path = tmp_path / "actual.yaml"
    _write_worksheet(worksheet_path)
    _write_ledger(ledger_path)
    evidence_path.write_text("{}\n", encoding="utf-8")
    _cli(
        monkeypatch,
        ledger_path,
        ["tool", "admit", "--worksheet", str(worksheet_path), "--arm", "smoke_classic"],
    )
    capsys.readouterr()
    _accounting(accounting_path, worksheet_path, evidence_path, "smoke_classic", 48)
    _cli(
        monkeypatch,
        ledger_path,
        ["tool", "record", "--worksheet", str(worksheet_path), "--actual", str(accounting_path)],
    )
    capsys.readouterr()

    evidence_path.write_text('{"tampered": true}\n', encoding="utf-8")
    with pytest.raises(AssertionError):
        _load_ledger(ledger_path)


def test_timeout_charges_spend_and_retires_candidate(
    tmp_path: Path,
    monkeypatch: pytest.MonkeyPatch,
    capsys: pytest.CaptureFixture[str],
) -> None:
    worksheet_path = tmp_path / "worksheet.yaml"
    ledger_path = tmp_path / "ledger.jsonl"
    evidence_path = tmp_path / "evidence.json"
    accounting_path = tmp_path / "actual.yaml"
    _write_worksheet(worksheet_path)
    _write_ledger(ledger_path)
    evidence_path.write_text("{}\n", encoding="utf-8")
    _cli(
        monkeypatch,
        ledger_path,
        ["tool", "admit", "--worksheet", str(worksheet_path), "--arm", "smoke_classic"],
    )
    capsys.readouterr()
    _accounting(
        accounting_path,
        worksheet_path,
        evidence_path,
        "smoke_classic",
        48,
        arm_status="timed_out",
    )

    _cli(
        monkeypatch,
        ledger_path,
        ["tool", "record", "--worksheet", str(worksheet_path), "--actual", str(accounting_path)],
    )

    assert capsys.readouterr().out == "STOP\n"
    stopped = json.loads(ledger_path.read_text().splitlines()[-1])
    assert stopped["reason"] == "arm_timeout"
    assert stopped["actual"]["candidates"] == 48
    assert _load_ledger(ledger_path)[-1]["reason"] == "arm_timeout"


def test_wave2_pair_equal_envelope_arithmetic() -> None:
    totals = tuple(map(sum, zip(*(row[3:] for row in ARM_CONTRACT), strict=True)))
    assert totals == (9696, 20600, 65_406_676, 5714, 20542)


def test_wave2_envelopes_reproduce_pinned_h5_actuals() -> None:
    root = Path(__file__).parents[2]
    reference_path = root / (
        "docs/journal_features/revamp_history/"
        "20260720_191404_KST_tcad_revolution_extension/shared/"
        "wave2_budget_reference.yaml"
    )
    reference = yaml.safe_load(reference_path.read_text(encoding="utf-8"))
    sources = {}
    for name, source in reference["sources"].items():
        path = root / source["path"]
        assert hashlib.sha256(path.read_bytes()).hexdigest() == source["sha256"]
        sources[name] = path

    with sources["smoke"].open(newline="", encoding="utf-8") as handle:
        smoke = {row["metric"]: row for row in csv.DictReader(handle)}
    smoke_synthesis = json.loads(sources["smoke_synthesis"].read_text())
    smoke_pair = {
        "candidates": smoke_synthesis["classic"]["candidate_count"],
        "calls": int(smoke["problem_count"]["classic"]) * 100,
        "tokens": max(
            int(smoke["total_llm_tokens"]["classic"]),
            int(smoke["total_llm_tokens"]["treatment"]),
        ),
        "synthesis": max(
            smoke_synthesis["classic"]["synthesis_starts"],
            smoke_synthesis["treatment"]["synthesis_starts"],
        ),
        "wall_seconds": max(
            Decimal(smoke["run_wall_seconds"]["classic"]),
            Decimal(smoke["run_wall_seconds"]["treatment"]),
        ),
    }
    with sources["full_suite"].open(newline="", encoding="utf-8") as handle:
        full_rows = list(csv.DictReader(handle))
    pair_actuals = {"smoke": smoke_pair}
    for seed in (1001, 1002):
        rows = [row for row in full_rows if int(row["seed"]) == seed]
        pair_actuals[f"seed_{seed}"] = {
            "candidates": int(rows[0]["candidate_count"]),
            "calls": 5000,
            "tokens": max(int(row["llm_tokens"]) for row in rows),
            "synthesis": max(int(row["synthesis_evaluations"]) for row in rows),
            "wall_seconds": max(Decimal(row["run_wall_seconds"]) for row in rows),
        }

    for arm_id, pair, _, *contract_values in ARM_CONTRACT:
        caps = pair_actuals[pair].copy()
        for field in ("tokens", "synthesis", "wall_seconds"):
            caps[field] = int(
                (Decimal(caps[field]) * Decimal(11) / 10).to_integral_value(
                    rounding=ROUND_CEILING
                )
            )
        contract = _raw_resources(tuple(contract_values))
        assert caps == contract == reference["arm_caps"][arm_id]
