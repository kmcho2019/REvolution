#!/usr/bin/env python3
"""Build a standardized Auto-BD run manifest from locked policies."""

from __future__ import annotations

import argparse
import hashlib
import json
import subprocess
import sys
from collections.abc import Mapping
from dataclasses import dataclass
from pathlib import Path
from typing import Any

import yaml  # type: ignore[reportMissingModuleSource]

REPO_ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(REPO_ROOT / "src"))

from revolution.auto_bd.results import (  # noqa: E402
    RUN_MANIFEST_FIELDS,
    assert_required_fields,
)

SCAFFOLD_DIR = (
    REPO_ROOT
    / "docs"
    / "journal_features"
    / "revamp_history"
    / "20260618_232234_KST_auto_bd_research"
)
DEFAULT_RUN_POLICY = SCAFFOLD_DIR / "auto_bd_run_policy_lock.yaml"
DEFAULT_SUBSET_LOCK = SCAFFOLD_DIR / "auto_bd_subset_lock.yaml"


@dataclass(frozen=True)
class ManifestInputs:
    """Required paths for one Auto-BD run-manifest build."""

    config_path: Path
    phase: str
    run_policy_path: Path
    subset_lock_path: Path


def sha256_path(path: Path) -> str:
    """Return a deterministic SHA-256 digest for a required file or tree."""

    assert path.exists(), f"missing path: {path}"
    if path.is_file():
        return hashlib.sha256(path.read_bytes()).hexdigest()

    digest = hashlib.sha256()
    files = sorted(item for item in path.rglob("*") if item.is_file())
    assert files, f"empty path tree: {path}"
    for item in files:
        rel = item.relative_to(path).as_posix()
        digest.update(rel.encode("utf-8"))
        digest.update(b"\0")
        digest.update(item.read_bytes())
        digest.update(b"\0")
    return digest.hexdigest()


def sha256_paths(paths: list[Path]) -> str:
    """Return one digest over several required files or trees."""

    assert paths, "expected at least one path to hash"
    digest = hashlib.sha256()
    for path in paths:
        digest.update(_display_path(path).encode("utf-8"))
        digest.update(b"\0")
        digest.update(sha256_path(path).encode("utf-8"))
        digest.update(b"\0")
    return digest.hexdigest()


def build_manifest(
    inputs: ManifestInputs,
    tool_versions: Mapping[str, str],
) -> dict[str, Any]:
    """Build a manifest matching the standard Auto-BD result schema."""

    run_policy = load_yaml_mapping(inputs.run_policy_path)
    phase_policy = _mapping_at(run_policy, "phase_policy")
    phase_body = _mapping_at(phase_policy, inputs.phase)
    seed_key = str(phase_body["seeds"])
    seed_list = _list_at(_mapping_at(run_policy, "seed_policy"), seed_key)
    model_policy = _mapping_at(run_policy, "model_policy")
    worker_policy = _mapping_at(run_policy, "worker_policy")
    prompt_policy = _mapping_at(run_policy, "prompt_policy")
    toolchain_policy = _mapping_at(run_policy, "toolchain_policy")

    manifest: dict[str, Any] = {
        "git_commit": command_stdout(["git", "rev-parse", "HEAD"]),
        "branch": command_stdout(["git", "rev-parse", "--abbrev-ref", "HEAD"]),
        "config_hash": sha256_path(inputs.config_path),
        "subset_hash": sha256_path(inputs.subset_lock_path),
        "seed_list": seed_list,
        "model_id": str(model_policy["model_id"]),
        "endpoint": str(model_policy["endpoint"]),
        "prompt_policy_hash": sha256_paths(_policy_paths(prompt_policy, "hash_paths")),
        "yosys_version": tool_versions["yosys_version"],
        "abc_version": tool_versions["abc_version"],
        "openroad_version": tool_versions["openroad_version"],
        "liberty_file_hash": sha256_path(_policy_path(toolchain_policy, "liberty_file")),
        "pdk_or_tech_config_hash": sha256_path(
            _policy_path(toolchain_policy, "pdk_or_tech_config_path")
        ),
        "constraints_hash": sha256_paths(
            _policy_paths(toolchain_policy, "constraint_hash_paths")
        ),
        "timeout_policy": _mapping_at(run_policy, "timeout_policy"),
        "budget_policy": _mapping_at(run_policy, "budget_policy"),
        "worker_count": _mapping_at(worker_policy, inputs.phase)["total_worker_slots"],
        "thread_policy": {
            "rule": str(worker_policy["rule"]),
            "phase": _mapping_at(worker_policy, inputs.phase),
        },
    }
    assert_required_fields(manifest, RUN_MANIFEST_FIELDS, "run_manifest")
    return manifest


def collect_tool_versions() -> dict[str, str]:
    """Collect EDA tool versions for the manifest."""

    return {
        "yosys_version": binary_version(["yosys", "-V"]),
        "abc_version": binary_version(["abc", "-V"]),
        "openroad_version": binary_version(["openroad", "-version"]),
    }


def binary_version(command: list[str]) -> str:
    """Return a one-line version string, or an explicit unavailable marker."""

    try:
        proc = subprocess.run(command, capture_output=True, text=True, timeout=30)
    except FileNotFoundError:
        return f"unavailable: {command[0]} not found"
    except subprocess.TimeoutExpired:
        return f"unavailable: {' '.join(command)} timed out"
    lines = (proc.stdout or proc.stderr).strip().splitlines()
    return lines[0][:200] if lines else f"rc={proc.returncode}"


def write_manifest(manifest: dict[str, Any], output: Path) -> None:
    """Write a manifest JSON artifact."""

    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(json.dumps(manifest, indent=2, sort_keys=True) + "\n", encoding="utf-8")


def load_yaml_mapping(path: Path) -> dict[str, Any]:
    """Load a required YAML mapping."""

    assert path.is_file(), f"missing YAML file: {path}"
    payload = yaml.safe_load(path.read_text(encoding="utf-8")) or {}
    assert isinstance(payload, dict), f"YAML root must be a mapping: {path}"
    return payload


def command_stdout(command: list[str]) -> str:
    """Run a required command and return stripped stdout."""

    proc = subprocess.run(command, capture_output=True, text=True, check=True)
    return proc.stdout.strip()


def _policy_path(policy: Mapping[str, Any], key: str) -> Path:
    return _resolve_path(str(policy[key]))


def _policy_paths(policy: Mapping[str, Any], key: str) -> list[Path]:
    raw_paths = _list_at(policy, key)
    return [_resolve_path(str(path)) for path in raw_paths]


def _resolve_path(path: str) -> Path:
    item = Path(path)
    return item if item.is_absolute() else REPO_ROOT / item


def _mapping_at(payload: Mapping[str, Any], key: str) -> Mapping[str, Any]:
    value = payload[key]
    assert isinstance(value, dict), f"{key} must be a mapping"
    return value


def _list_at(payload: Mapping[str, Any], key: str) -> list[Any]:
    value = payload[key]
    assert isinstance(value, list), f"{key} must be a list"
    return value


def _display_path(path: Path) -> str:
    return path.relative_to(REPO_ROOT).as_posix() if path.is_relative_to(REPO_ROOT) else str(path)


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--config-path", type=Path, required=True)
    parser.add_argument("--phase", type=str, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--run-policy", type=Path, default=DEFAULT_RUN_POLICY)
    parser.add_argument("--subset-lock", type=Path, default=DEFAULT_SUBSET_LOCK)
    args = parser.parse_args(argv)

    manifest = build_manifest(
        ManifestInputs(
            config_path=args.config_path,
            phase=args.phase,
            run_policy_path=args.run_policy,
            subset_lock_path=args.subset_lock,
        ),
        collect_tool_versions(),
    )
    write_manifest(manifest, args.output)
    print(f"Auto-BD run manifest -> {args.output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
