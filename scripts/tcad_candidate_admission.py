#!/usr/bin/env python3
"""Admit sequential TCAD arms against frozen cumulative resource gates."""

from __future__ import annotations

import argparse
import fcntl
import hashlib
import json
import re
from dataclasses import dataclass
from datetime import datetime, timedelta, timezone
from decimal import Decimal
from pathlib import Path
from typing import Any, Literal, cast

import yaml


Status = Literal["PASS", "STOP"]
ArmStatus = Literal["completed", "timed_out"]
COUNT_FIELDS = ("candidates", "calls", "tokens", "synthesis")
RESOURCE_FIELDS = (*COUNT_FIELDS, "wall_seconds")
PROGRAM_START_UTC = "2026-07-20T14:21:33+00:00"
PROGRAM_DEADLINE_UTC = "2026-08-10T14:21:33+00:00"
PROGRAM_LEDGER = Path(
    "docs/journal_features/revamp_history/"
    "20260720_191404_KST_tcad_revolution_extension/shared/"
    "wave2_resource_ledger.jsonl"
)
ARM_CONTRACT = (
    ("smoke_classic", "smoke", "classic", 48, 300, 265_153, 35, 161),
    ("smoke_treatment", "smoke", "treatment", 48, 300, 265_153, 35, 161),
    ("seed_1001_classic", "seed_1001", "classic", 2400, 5000, 16_291_915, 1407, 5125),
    ("seed_1001_treatment", "seed_1001", "treatment", 2400, 5000, 16_291_915, 1407, 5125),
    ("seed_1002_classic", "seed_1002", "classic", 2400, 5000, 16_146_270, 1415, 4985),
    ("seed_1002_treatment", "seed_1002", "treatment", 2400, 5000, 16_146_270, 1415, 4985),
)
FROZEN_THRESHOLDS = {
    "candidate": (10_512, 21_000, 66_000_000, 6_000, "21600"),
    "wave": (32_000, 64_000, 200_000_000, 18_000, "64800"),
    "program": (93_768, 187_534, 580_710_448, 53_944, "193564.908"),
}


@dataclass(frozen=True)
class LedgerPosition:
    next_index: int
    pending: bool
    stopped: bool


def _resources(raw: Any) -> dict[str, Decimal]:
    assert isinstance(raw, dict)
    assert set(raw) == set(RESOURCE_FIELDS)
    assert all(type(raw[name]) is int for name in COUNT_FIELDS)
    assert type(raw["wall_seconds"]) in {int, str}
    values = {name: Decimal(raw[name]) for name in RESOURCE_FIELDS}
    assert all(value.is_finite() and value >= 0 for value in values.values())
    return values


def _json_resources(values: dict[str, Decimal]) -> dict[str, int | str]:
    assert all(values[name] == int(values[name]) for name in COUNT_FIELDS)
    return {
        **{name: int(values[name]) for name in COUNT_FIELDS},
        "wall_seconds": format(values["wall_seconds"], "f"),
    }


def _sum_resources(rows: list[dict[str, Decimal]]) -> dict[str, Decimal]:
    return {name: sum((row[name] for row in rows), Decimal(0)) for name in RESOURCE_FIELDS}


def _pair_caps_match(arms: list[dict[str, Any]]) -> bool:
    pairs: dict[str, list[dict[str, Any]]] = {}
    for arm in arms:
        pairs.setdefault(arm["pair"], []).append(arm)
    return all(
        len(pair) == 2
        and {arm["role"] for arm in pair} == {"classic", "treatment"}
        and pair[0]["caps"] == pair[1]["caps"]
        for pair in pairs.values()
    )


def _load_worksheet(path: Path) -> dict[str, Any]:
    worksheet = yaml.safe_load(path.read_text(encoding="utf-8"))
    assert isinstance(worksheet, dict)
    assert set(worksheet) == {
        "version",
        "candidate_id",
        "wave_id",
        "program_start_utc",
        "program_deadline_utc",
        "thresholds",
        "arms",
    }
    assert worksheet["version"] == 1
    assert isinstance(worksheet["candidate_id"], str) and worksheet["candidate_id"]
    assert worksheet["wave_id"] == "wave2"
    assert worksheet["program_start_utc"] == PROGRAM_START_UTC
    assert worksheet["program_deadline_utc"] == PROGRAM_DEADLINE_UTC
    assert set(worksheet["thresholds"]) == set(FROZEN_THRESHOLDS)
    worksheet["thresholds"] = {
        name: _resources(values) for name, values in worksheet["thresholds"].items()
    }
    for name, values in FROZEN_THRESHOLDS.items():
        expected = _resources(dict(zip(RESOURCE_FIELDS, values, strict=True)))
        assert worksheet["thresholds"][name] == expected

    raw_arms = worksheet["arms"]
    assert isinstance(raw_arms, list) and len(raw_arms) == len(ARM_CONTRACT)
    assert all(isinstance(arm, dict) for arm in raw_arms)
    arms = cast(list[dict[str, Any]], raw_arms)
    for arm, expected in zip(arms, ARM_CONTRACT, strict=True):
        assert set(arm) == {"id", "pair", "role", "caps"}
        arm_id, pair, role, *maximum_values = expected
        assert (arm["id"], arm["pair"], arm["role"]) == (arm_id, pair, role)
        arm["caps"] = _resources(arm["caps"])
        maximum = _resources(dict(zip(RESOURCE_FIELDS, maximum_values, strict=True)))
        assert arm["caps"]["candidates"] == maximum["candidates"]
        assert all(arm["caps"][name] <= maximum[name] for name in RESOURCE_FIELDS)
    assert _pair_caps_match(arms)
    return worksheet


def _ledger_position(events: list[dict[str, Any]]) -> LedgerPosition | None:
    next_index = 0
    pending = False
    for event_index, event in enumerate(events):
        if next_index >= len(ARM_CONTRACT):
            return None
        arm_id = ARM_CONTRACT[next_index][0]
        if event["kind"] == "stopped":
            pre_arm = event["reason"] == "admission_infeasible" and not pending
            post_arm = event["reason"] in {
                "post_arm_resource_gate",
                "arm_timeout",
            } and pending
            if (
                event["arm_id"] != arm_id
                or not (pre_arm or post_arm)
                or event_index != len(events) - 1
            ):
                return None
            return LedgerPosition(next_index, pending, True)
        if not pending:
            if event["kind"] != "admitted" or event["arm_id"] != arm_id:
                return None
            pending = True
            continue
        if event["kind"] != "completed" or event["arm_id"] != arm_id:
            return None
        next_index += 1
        pending = False
    return LedgerPosition(next_index, pending, False)


def _candidate_finished(events: list[dict[str, Any]]) -> bool:
    position = _ledger_position(events)
    return position is not None and (
        position.stopped
        or (not position.pending and position.next_index == len(ARM_CONTRACT))
    )


def _load_ledger(path: Path) -> list[dict[str, Any]]:
    events = [json.loads(line) for line in path.read_text().splitlines()]
    assert events and events[0] == {
        "kind": "ledger_start",
        "program_start_utc": PROGRAM_START_UTC,
        "program_deadline_utc": PROGRAM_DEADLINE_UTC,
        "wave_id": "wave2",
    }
    arm_events = events[1:]
    common = {"kind", "wave_id", "candidate_id", "worksheet_sha256", "arm_id"}
    accounting_hashes = set()
    evidence_hashes = set()
    candidate_hashes: dict[str, set[str]] = {}
    for event in arm_events:
        assert event["wave_id"] == "wave2"
        assert isinstance(event["candidate_id"], str) and event["candidate_id"]
        candidate_hashes.setdefault(event["candidate_id"], set()).add(
            event["worksheet_sha256"]
        )
        match event["kind"]:
            case "admitted":
                assert set(event) == common | {"admitted_at_utc"}
            case "completed":
                assert set(event) == common | {
                    "actual",
                    "accounting_path",
                    "accounting_sha256",
                    "evidence_path",
                    "evidence_sha256",
                    "captured_at_utc",
                }
                event["actual"] = _resources(event["actual"])
                accounting_hashes.add(event["accounting_sha256"])
                evidence_hashes.add(event["evidence_sha256"])
            case "stopped":
                assert event["candidate_outcome"] == "RETIRED"
                if event["reason"] == "admission_infeasible":
                    assert set(event) == common | {
                        "candidate_outcome",
                        "reason",
                        "stopped_at_utc",
                    }
                else:
                    assert event["reason"] in {
                        "post_arm_resource_gate",
                        "arm_timeout",
                    }
                    assert set(event) == common | {
                        "actual",
                        "accounting_path",
                        "accounting_sha256",
                        "candidate_outcome",
                        "evidence_path",
                        "evidence_sha256",
                        "captured_at_utc",
                        "reason",
                    }
                    event["actual"] = _resources(event["actual"])
                    accounting_hashes.add(event["accounting_sha256"])
                    evidence_hashes.add(event["evidence_sha256"])
            case _:
                raise AssertionError(f"unknown ledger event: {event['kind']}")
    accounted = [event for event in arm_events if "accounting_sha256" in event]
    assert len(accounting_hashes) == len(accounted)
    assert len(evidence_hashes) == len(accounted)
    for event in accounted:
        accounting = Path(event["accounting_path"])
        evidence = Path(event["evidence_path"])
        assert hashlib.sha256(accounting.read_bytes()).hexdigest() == event[
            "accounting_sha256"
        ]
        assert hashlib.sha256(evidence.read_bytes()).hexdigest() == event[
            "evidence_sha256"
        ]
    assert all(len(hashes) == 1 for hashes in candidate_hashes.values())
    candidate_order: list[str] = []
    for event in arm_events:
        candidate_id = event["candidate_id"]
        if not candidate_order or candidate_id != candidate_order[-1]:
            assert candidate_id not in candidate_order
            if candidate_order:
                previous = _candidate_events(arm_events, candidate_order[-1])
                assert _candidate_finished(previous)
            candidate_order.append(candidate_id)
    for candidate_id in candidate_order:
        candidate_events = [
            event for event in arm_events if event["candidate_id"] == candidate_id
        ]
        assert _ledger_position(candidate_events) is not None
    return arm_events


def _candidate_events(
    events: list[dict[str, Any]], candidate_id: str
) -> list[dict[str, Any]]:
    return [event for event in events if event["candidate_id"] == candidate_id]


def _spent(
    events: list[dict[str, Any]], candidate_id: str | None = None
) -> dict[str, Decimal]:
    selected = [
        event["actual"]
        for event in events
        if "actual" in event
        and (candidate_id is None or event["candidate_id"] == candidate_id)
    ]
    return _sum_resources(selected)


def admission_status(
    worksheet: dict[str, Any],
    events: list[dict[str, Any]],
    arm_id: str,
    now: datetime,
) -> Status:
    """Return whether the next frozen arm fits every cumulative threshold."""
    current = _candidate_events(events, worksheet["candidate_id"])
    if not current and events:
        previous = _candidate_events(events, events[-1]["candidate_id"])
        if not _candidate_finished(previous):
            return "STOP"
    position = _ledger_position(current)
    if position is None or position.pending or position.stopped:
        return "STOP"
    if position.next_index >= len(worksheet["arms"]):
        return "STOP"
    if worksheet["arms"][position.next_index]["id"] != arm_id:
        return "STOP"

    frozen = _sum_resources(
        [arm["caps"] for arm in worksheet["arms"][position.next_index :]]
    )
    projected = {
        "candidate": {
            name: _spent(events, worksheet["candidate_id"])[name] + frozen[name]
            for name in RESOURCE_FIELDS
        },
        "wave": {
            name: _spent(events)[name] + frozen[name] for name in RESOURCE_FIELDS
        },
        "program": {
            name: _spent(events)[name] + frozen[name] for name in RESOURCE_FIELDS
        },
    }
    if any(
        projected[scope][name] > worksheet["thresholds"][scope][name]
        for scope in FROZEN_THRESHOLDS
        for name in RESOURCE_FIELDS
    ):
        return "STOP"

    start = datetime.fromisoformat(PROGRAM_START_UTC)
    deadline = datetime.fromisoformat(PROGRAM_DEADLINE_UTC)
    assert now.utcoffset() == timedelta(0)
    if now < start or now > deadline:
        return "STOP"
    if now + timedelta(seconds=float(frozen["wall_seconds"])) > deadline:
        return "STOP"
    return "PASS"


def post_arm_status(
    worksheet: dict[str, Any],
    events: list[dict[str, Any]],
    actual: dict[str, Decimal],
) -> Status:
    """Return whether an admitted arm stayed inside cumulative resource gates."""
    current = _candidate_events(events, worksheet["candidate_id"])
    position = _ledger_position(current)
    assert position is not None and position.pending and not position.stopped
    arm = worksheet["arms"][position.next_index]
    if actual["candidates"] != arm["caps"]["candidates"]:
        return "STOP"
    if any(actual[name] > arm["caps"][name] for name in RESOURCE_FIELDS):
        return "STOP"

    prior = {
        "candidate": _spent(events, worksheet["candidate_id"]),
        "wave": _spent(events),
        "program": _spent(events),
    }
    if any(
        prior[scope][name] + actual[name] > worksheet["thresholds"][scope][name]
        for scope in FROZEN_THRESHOLDS
        for name in RESOURCE_FIELDS
    ):
        return "STOP"
    return "PASS"


def _load_accounting(
    path: Path,
    worksheet: dict[str, Any],
    worksheet_sha256: str,
    arm_id: str,
    admitted_at: datetime,
    now: datetime,
) -> tuple[dict[str, Decimal], ArmStatus, dict[str, str]] | None:
    if not path.is_file():
        return None
    try:
        raw = yaml.safe_load(path.read_text(encoding="utf-8"))
    except (UnicodeError, yaml.YAMLError):
        return None
    required = {
        "version",
        "candidate_id",
        "worksheet_sha256",
        "arm_id",
        "arm_status",
        "captured_at_utc",
        "evidence_path",
        "evidence_sha256",
        *RESOURCE_FIELDS,
    }
    if not isinstance(raw, dict) or set(raw) != required:
        return None
    if (
        type(raw["version"]) is not int
        or raw["version"] != 1
        or raw["candidate_id"] != worksheet["candidate_id"]
        or raw["worksheet_sha256"] != worksheet_sha256
        or raw["arm_id"] != arm_id
        or type(raw["arm_status"]) is not str
        or raw["arm_status"] not in {"completed", "timed_out"}
        or any(type(raw[name]) is not int or raw[name] < 0 for name in COUNT_FIELDS)
        or type(raw["wall_seconds"]) is not str
        or re.fullmatch(r"(?:0|[1-9][0-9]*)(?:\.[0-9]+)?", raw["wall_seconds"])
        is None
        or type(raw["captured_at_utc"]) is not str
        or type(raw["evidence_path"]) is not str
        or not raw["evidence_path"]
        or type(raw["evidence_sha256"]) is not str
    ):
        return None
    actual = _resources({name: raw[name] for name in RESOURCE_FIELDS})
    try:
        captured = datetime.fromisoformat(raw["captured_at_utc"])
    except ValueError:
        return None
    if (
        captured.utcoffset() != timedelta(0)
        or captured < admitted_at
        or captured > now
    ):
        return None
    evidence = Path(raw["evidence_path"])
    if not evidence.is_file():
        return None
    evidence_sha256 = hashlib.sha256(evidence.read_bytes()).hexdigest()
    if evidence_sha256 != raw["evidence_sha256"]:
        return None
    return actual, cast(ArmStatus, raw["arm_status"]), {
        "accounting_path": str(path),
        "accounting_sha256": hashlib.sha256(path.read_bytes()).hexdigest(),
        "evidence_path": str(evidence),
        "evidence_sha256": evidence_sha256,
        "captured_at_utc": captured.isoformat(),
    }


def _append(path: Path, event: dict[str, Any]) -> None:
    with path.open("a", encoding="utf-8") as handle:
        handle.write(json.dumps(event, sort_keys=True) + "\n")


def _utc_now() -> datetime:
    return datetime.now(timezone.utc)


def _run_locked(args: argparse.Namespace) -> Status:
    worksheet = _load_worksheet(args.worksheet)
    worksheet_sha256 = hashlib.sha256(args.worksheet.read_bytes()).hexdigest()
    with PROGRAM_LEDGER.open("r+", encoding="utf-8") as lock:
        fcntl.flock(lock, fcntl.LOCK_EX)
        events = _load_ledger(PROGRAM_LEDGER)
        current = _candidate_events(events, worksheet["candidate_id"])
        assert all(
            event["worksheet_sha256"] == worksheet_sha256 for event in current
        )
        position = _ledger_position(current)
        assert position is not None
        identity = {
            "wave_id": "wave2",
            "candidate_id": worksheet["candidate_id"],
            "worksheet_sha256": worksheet_sha256,
        }
        now = _utc_now()

        match args.command:
            case "admit":
                expected_arm = (
                    worksheet["arms"][position.next_index]["id"]
                    if position.next_index < len(worksheet["arms"])
                    else None
                )
                previous_active = (
                    not current
                    and bool(events)
                    and not _candidate_finished(
                        _candidate_events(events, events[-1]["candidate_id"])
                    )
                )
                if (
                    position.pending
                    or position.stopped
                    or previous_active
                    or args.arm != expected_arm
                ):
                    return "STOP"
                status = admission_status(worksheet, events, args.arm, now)
                event = {
                    "kind": "admitted",
                    "arm_id": args.arm,
                    "admitted_at_utc": now.isoformat(),
                    **identity,
                }
                if status == "STOP":
                    event = {
                        "kind": "stopped",
                        "arm_id": args.arm,
                        "candidate_outcome": "RETIRED",
                        "reason": "admission_infeasible",
                        "stopped_at_utc": now.isoformat(),
                        **identity,
                    }
                _append(PROGRAM_LEDGER, event)
            case "record":
                if not position.pending or position.stopped:
                    return "STOP"
                arm_id = worksheet["arms"][position.next_index]["id"]
                accounting = _load_accounting(
                    args.actual,
                    worksheet,
                    worksheet_sha256,
                    arm_id,
                    datetime.fromisoformat(current[-1]["admitted_at_utc"]),
                    now,
                )
                if accounting is None:
                    return "STOP"
                actual, arm_status, provenance = accounting
                if any(
                    event.get("accounting_sha256")
                    == provenance["accounting_sha256"]
                    or event.get("evidence_sha256") == provenance["evidence_sha256"]
                    for event in events
                ):
                    return "STOP"
                status = (
                    "STOP"
                    if arm_status == "timed_out"
                    else post_arm_status(worksheet, events, actual)
                )
                event = {
                    "kind": "completed" if status == "PASS" else "stopped",
                    "arm_id": arm_id,
                    "actual": _json_resources(actual),
                    **provenance,
                    **identity,
                }
                if status == "STOP":
                    event |= {
                        "candidate_outcome": "RETIRED",
                        "reason": (
                            "arm_timeout"
                            if arm_status == "timed_out"
                            else "post_arm_resource_gate"
                        ),
                    }
                _append(PROGRAM_LEDGER, event)
            case _:
                raise AssertionError(f"unknown command: {args.command}")
        return status


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    subparsers = parser.add_subparsers(dest="command", required=True)
    admit = subparsers.add_parser("admit")
    admit.add_argument("--worksheet", type=Path, required=True)
    admit.add_argument("--arm", required=True)
    record = subparsers.add_parser("record")
    record.add_argument("--worksheet", type=Path, required=True)
    record.add_argument("--actual", type=Path, required=True)
    print(_run_locked(parser.parse_args()))


if __name__ == "__main__":
    main()
