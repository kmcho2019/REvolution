#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import os
import shlex
import subprocess
import sys
from dataclasses import asdict
from dataclasses import dataclass
from datetime import datetime
from pathlib import Path
from typing import Any
from urllib.error import HTTPError
from urllib.error import URLError
from urllib.request import urlopen

SCRIPT_DIR = os.path.abspath(os.path.dirname(__file__))
REPO_ROOT = os.path.abspath(os.path.join(SCRIPT_DIR, ".."))
if REPO_ROOT not in sys.path:
    sys.path.insert(0, REPO_ROOT)

DEFAULT_SAVE_ROOT = "/tmp/qd_theory_followup_manifest"
DEFAULT_MIN_MODEL_LEN = 128000
DEFAULT_SMOKE_BUDGET = {
    "population_size": 1,
    "num_generations": 0,
    "total_worker_slots": 1,
    "max_workers_per_problem": 1,
}
SETTING_TO_FLAG = (
    ("qd_num_cells", "--qd_num_cells"),
    ("qd_cvt_warmup_successes", "--qd_cvt_warmup_successes"),
    ("population_size", "--population_size"),
    ("num_generations", "--num_generations"),
    ("total_worker_slots", "--total_worker_slots"),
    ("max_workers_per_problem", "--max_workers_per_problem"),
    ("evaluation_mode", "--evaluation_mode"),
    ("temperature", "--temperature"),
    ("top_p", "--top_p"),
    ("max_tokens", "--max_tokens"),
    ("diff_max_tokens", "--diff_max_tokens"),
    ("seed", "--seed"),
)


@dataclass(frozen=True)
class FollowupProfile:
    name: str
    label: str


@dataclass(frozen=True)
class FollowupCase:
    name: str
    benchmark: str
    problems: tuple[str, ...]
    save_subdir: str
    settings: dict[str, Any]


@dataclass(frozen=True)
class ModelInfo:
    name: str
    max_model_len: int | None


@dataclass(frozen=True)
class PlannedCommand:
    case_name: str
    benchmark: str
    profile_name: str
    profile_label: str
    save_path: str
    timeout_s: int
    command: tuple[str, ...]


def _build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description=(
            "Run a manifest-driven theory-grounded follow-up matrix over RTLLM "
            "and VerilogEval control/theory profiles."
        ),
    )
    parser.add_argument(
        "--manifest",
        required=True,
        help="Path to a JSON manifest describing cases, profiles, and defaults.",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Print the resolved commands without executing them.",
    )
    parser.add_argument(
        "--case",
        dest="case_filters",
        action="append",
        default=[],
        help="Optional case name filter. May be provided multiple times.",
    )
    parser.add_argument(
        "--profile",
        dest="profile_filters",
        action="append",
        default=[],
        help="Optional profile name filter. May be provided multiple times.",
    )
    parser.add_argument(
        "--smoke-budget",
        action="store_true",
        help="Override population/generation/worker settings with a tiny smoke budget.",
    )
    parser.add_argument(
        "--run_tag",
        default=None,
        help="Optional fixed run tag. Defaults to a timestamp when omitted.",
    )
    return parser


def load_manifest(path: str | Path) -> dict[str, Any]:
    manifest_path = Path(path).resolve()
    payload = json.loads(manifest_path.read_text(encoding="utf-8"))
    if not isinstance(payload, dict):
        raise ValueError("Manifest must decode to a JSON object.")
    if not isinstance(payload.get("profiles"), list):
        raise ValueError("Manifest must contain a top-level 'profiles' list.")
    if not isinstance(payload.get("cases"), list):
        raise ValueError("Manifest must contain a top-level 'cases' list.")
    payload["_manifest_path"] = str(manifest_path)
    return payload


def _resolve_path(raw_path: str, *, base_dir: Path) -> Path:
    path = Path(raw_path)
    if path.is_absolute():
        return path
    return (base_dir / path).resolve()


def parse_model_len(value: Any) -> int | None:
    if isinstance(value, int):
        return value
    if not isinstance(value, str):
        return None

    cleaned = value.replace("_", "").strip()
    if not cleaned:
        return None
    if cleaned.isdigit():
        return int(cleaned)

    suffix = cleaned[-1].lower()
    if suffix not in {"k", "m", "g"}:
        return None
    base = cleaned[:-1]
    if not base.isdigit():
        return None

    multiplier = 1
    if suffix == "k":
        multiplier = 1_000
    elif suffix == "m":
        multiplier = 1_000_000
    elif suffix == "g":
        multiplier = 1_000_000_000
    return int(base) * multiplier


def parse_profiles(payload: dict[str, Any]) -> list[FollowupProfile]:
    profiles: list[FollowupProfile] = []
    for index, item in enumerate(payload["profiles"]):
        if not isinstance(item, dict):
            raise ValueError(f"Profile entry {index} must be a JSON object.")
        name = item.get("name")
        if not isinstance(name, str) or not name:
            raise ValueError(f"Profile entry {index} requires a non-empty string 'name'.")
        label = item.get("label", name)
        if not isinstance(label, str) or not label:
            raise ValueError(f"Profile '{name}' requires a non-empty string 'label'.")
        profiles.append(FollowupProfile(name=name, label=label))
    return profiles


def parse_cases(payload: dict[str, Any]) -> list[FollowupCase]:
    defaults = payload.get("defaults", {})
    if not isinstance(defaults, dict):
        raise ValueError("Manifest 'defaults' must be a JSON object when provided.")

    cases: list[FollowupCase] = []
    for index, item in enumerate(payload["cases"]):
        if not isinstance(item, dict):
            raise ValueError(f"Case entry {index} must be a JSON object.")

        name = item.get("name")
        benchmark = item.get("benchmark")
        raw_problems = item.get("problems")
        if not isinstance(name, str) or not name:
            raise ValueError(f"Case entry {index} requires a non-empty string 'name'.")
        if not isinstance(benchmark, str) or not benchmark:
            raise ValueError(f"Case '{name}' requires a non-empty string 'benchmark'.")
        if not isinstance(raw_problems, list) or not raw_problems:
            raise ValueError(f"Case '{name}' requires a non-empty 'problems' list.")
        if not all(isinstance(problem, str) and problem for problem in raw_problems):
            raise ValueError(f"Case '{name}' has an invalid 'problems' list.")

        case_settings = item.get("settings", {})
        if not isinstance(case_settings, dict):
            raise ValueError(f"Case '{name}' must use a JSON object for 'settings'.")

        merged_settings = dict(defaults)
        merged_settings.update(case_settings)
        save_subdir = item.get("save_subdir", name)
        if not isinstance(save_subdir, str) or not save_subdir:
            raise ValueError(f"Case '{name}' requires a non-empty string 'save_subdir'.")

        cases.append(
            FollowupCase(
                name=name,
                benchmark=benchmark,
                problems=tuple(raw_problems),
                save_subdir=save_subdir,
                settings=merged_settings,
            )
        )
    return cases


def select_profiles(
    profiles: list[FollowupProfile],
    *,
    filters: list[str],
) -> list[FollowupProfile]:
    if not filters:
        return profiles
    filter_set = set(filters)
    selected = [profile for profile in profiles if profile.name in filter_set]
    if selected:
        return selected
    raise ValueError(f"No manifest profiles matched filters: {sorted(filter_set)}")


def select_cases(
    cases: list[FollowupCase],
    *,
    filters: list[str],
) -> list[FollowupCase]:
    if not filters:
        return cases
    filter_set = set(filters)
    selected = [case for case in cases if case.name in filter_set]
    if selected:
        return selected
    raise ValueError(f"No manifest cases matched filters: {sorted(filter_set)}")


def fetch_model_info(*, host: str, port: int) -> ModelInfo:
    endpoint = f"http://{host}:{port}/v1/models"
    try:
        with urlopen(endpoint) as response:
            payload = json.load(response)
    except HTTPError as error:
        raise RuntimeError(f"Model endpoint returned HTTP {error.code}: {endpoint}") from error
    except URLError as error:
        raise RuntimeError(f"Could not reach model endpoint: {endpoint}") from error

    models = payload.get("data")
    if not isinstance(models, list) or not models:
        raise RuntimeError(f"No models returned from endpoint: {endpoint}")

    first = models[0]
    if not isinstance(first, dict):
        raise RuntimeError(f"Model payload from {endpoint} did not contain an object.")
    model_name = first.get("id")
    if not isinstance(model_name, str) or not model_name:
        raise RuntimeError(f"Model payload from {endpoint} did not contain a string id.")
    return ModelInfo(
        name=model_name,
        max_model_len=parse_model_len(first.get("max_model_len")),
    )


def resolve_run_root(
    payload: dict[str, Any],
    *,
    run_tag: str | None,
) -> Path:
    manifest_path = Path(payload["_manifest_path"])
    raw_save_root = payload.get("save_root", DEFAULT_SAVE_ROOT)
    if not isinstance(raw_save_root, str) or not raw_save_root:
        raise ValueError("Manifest 'save_root' must be a non-empty string when provided.")

    save_root = _resolve_path(raw_save_root, base_dir=manifest_path.parent)
    resolved_tag = run_tag or datetime.utcnow().strftime("%Y%m%d_%H%M%S")
    return save_root / resolved_tag


def apply_smoke_budget(settings: dict[str, Any], *, enabled: bool) -> dict[str, Any]:
    if not enabled:
        return dict(settings)
    smoke_settings = dict(settings)
    smoke_settings.update(DEFAULT_SMOKE_BUDGET)
    return smoke_settings


def build_command(
    *,
    python_bin: str,
    case: FollowupCase,
    profile: FollowupProfile,
    host: str,
    port: int,
    min_model_len: int,
    model_name: str,
    save_root: Path,
    smoke_budget: bool,
) -> PlannedCommand:
    settings = apply_smoke_budget(case.settings, enabled=smoke_budget)
    timeout_s = int(settings.get("timeout_s", 0) or 0)
    save_path = save_root / case.save_subdir / profile.label
    command = [
        python_bin,
        "scripts/run_backend.py",
        "--backend",
        "revolution",
        "--search_mode",
        "revolution_qd",
        "--qd_archive_type",
        "cvt",
        "--qd_descriptor_profile",
        profile.name,
        "--benchmarks",
        case.benchmark,
        "--problems",
        *case.problems,
        "--api_backend",
        "vllm",
        "--vllm_host",
        host,
        "--vllm_port",
        str(port),
        "--vllm_min_model_len",
        str(min_model_len),
        "--model_name",
        model_name,
    ]

    for setting_name, flag in SETTING_TO_FLAG:
        if setting_name not in settings:
            continue
        command.extend([flag, str(settings[setting_name])])

    command.extend(
        [
            "--save_path",
            str(save_path),
            "--no-backend_subdir",
        ]
    )
    return PlannedCommand(
        case_name=case.name,
        benchmark=case.benchmark,
        profile_name=profile.name,
        profile_label=profile.label,
        save_path=str(save_path),
        timeout_s=timeout_s,
        command=tuple(command),
    )


def build_run_plan(
    payload: dict[str, Any],
    *,
    case_filters: list[str],
    profile_filters: list[str],
    smoke_budget: bool,
    run_tag: str | None,
) -> dict[str, Any]:
    host = payload.get("vllm_host", "host.docker.internal")
    port = payload.get("vllm_port", 8000)
    min_model_len = parse_model_len(payload.get("min_model_len", DEFAULT_MIN_MODEL_LEN))
    if not isinstance(host, str) or not host:
        raise ValueError("Manifest 'vllm_host' must be a non-empty string when provided.")
    if not isinstance(port, int):
        raise ValueError("Manifest 'vllm_port' must be an integer when provided.")
    if min_model_len is None:
        raise ValueError("Manifest 'min_model_len' must be an integer or a k/m/g string.")

    profiles = select_profiles(parse_profiles(payload), filters=profile_filters)
    cases = select_cases(parse_cases(payload), filters=case_filters)
    model_info = fetch_model_info(host=host, port=port)
    if model_info.max_model_len is not None and model_info.max_model_len < min_model_len:
        raise RuntimeError(
            f"Model '{model_info.name}' reports max_model_len={model_info.max_model_len}, "
            f"below required {min_model_len}."
        )

    run_root = resolve_run_root(payload, run_tag=run_tag)
    python_bin = sys.executable
    commands: list[PlannedCommand] = []
    for case in cases:
        for profile in profiles:
            commands.append(
                build_command(
                    python_bin=python_bin,
                    case=case,
                    profile=profile,
                    host=host,
                    port=port,
                    min_model_len=min_model_len,
                    model_name=model_info.name,
                    save_root=run_root,
                    smoke_budget=smoke_budget,
                )
            )

    return {
        "manifest": str(Path(payload["_manifest_path"]).resolve()),
        "run_root": str(run_root),
        "vllm_host": host,
        "vllm_port": port,
        "min_model_len": min_model_len,
        "model_info": asdict(model_info),
        "smoke_budget": smoke_budget,
        "profiles": [asdict(profile) for profile in profiles],
        "cases": [asdict(case) for case in cases],
        "commands": [
            {
                "case_name": command.case_name,
                "benchmark": command.benchmark,
                "profile_name": command.profile_name,
                "profile_label": command.profile_label,
                "save_path": command.save_path,
                "timeout_s": command.timeout_s,
                "command": list(command.command),
            }
            for command in commands
        ],
    }


def render_plan(plan: dict[str, Any]) -> str:
    lines = [
        "Theory follow-up manifest runner",
        f"manifest: {plan['manifest']}",
        f"run_root: {plan['run_root']}",
        f"model: {plan['model_info']['name']}",
        f"model_max_len: {plan['model_info'].get('max_model_len')}",
        f"smoke_budget: {plan['smoke_budget']}",
        "",
    ]

    for command in plan["commands"]:
        command_text = render_command_text(command)
        lines.append(f"[{command['case_name']}/{command['profile_label']}] {command_text}")
    return "\n".join(lines)


def _write_run_plan(run_root: Path, plan: dict[str, Any]) -> None:
    run_root.mkdir(parents=True, exist_ok=True)
    (run_root / "theory_followup_manifest.json").write_text(
        json.dumps(plan, indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
    )
    (run_root / "theory_followup_manifest.txt").write_text(
        render_plan(plan) + "\n",
        encoding="utf-8",
    )


def render_command_text(command: dict[str, Any]) -> str:
    command_text = shlex.join(command["command"])
    if command["timeout_s"] > 0:
        return shlex.join(["timeout", f"{command['timeout_s']}s", *command["command"]])
    return command_text


def execute_plan(plan: dict[str, Any]) -> int:
    run_root = Path(plan["run_root"])
    if run_root.exists():
        raise RuntimeError(
            f"Run root already exists: {run_root}. "
            "Choose a new --run_tag or remove the old run root."
        )

    _write_run_plan(run_root, plan)
    env = os.environ.copy()
    if not env.get("OPENAI_API_KEY"):
        env["OPENAI_API_KEY"] = "vllm-local-placeholder"
        print(
            "OPENAI_API_KEY was not set; exported placeholder for local vLLM compatibility.",
            flush=True,
        )

    statuses: list[dict[str, Any]] = []
    exit_code = 0
    for command in plan["commands"]:
        shell_text = render_command_text(command)
        print("", flush=True)
        print(f"[{command['case_name']}/{command['profile_label']}] command:", flush=True)
        print(f"  {shell_text}", flush=True)

        run_args = list(command["command"])
        if command["timeout_s"] > 0:
            run_args = ["timeout", f"{command['timeout_s']}s", *run_args]

        completed = subprocess.run(
            run_args,
            cwd=REPO_ROOT,
            env=env,
            check=False,
        )
        status = {
            "case_name": command["case_name"],
            "profile_name": command["profile_name"],
            "profile_label": command["profile_label"],
            "returncode": completed.returncode,
        }
        statuses.append(status)
        if completed.returncode == 0:
            continue
        exit_code = completed.returncode or 1

    (run_root / "theory_followup_execution_summary.json").write_text(
        json.dumps({"statuses": statuses, "exit_code": exit_code}, indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
    )
    return exit_code


def main(argv: list[str] | None = None) -> int:
    parser = _build_parser()
    args = parser.parse_args(argv)
    plan = build_run_plan(
        load_manifest(args.manifest),
        case_filters=args.case_filters,
        profile_filters=args.profile_filters,
        smoke_budget=args.smoke_budget,
        run_tag=args.run_tag,
    )
    print(render_plan(plan), flush=True)
    if args.dry_run:
        print("Dry run enabled; commands were not executed.", flush=True)
        return 0
    return execute_plan(plan)


if __name__ == "__main__":
    raise SystemExit(main())
