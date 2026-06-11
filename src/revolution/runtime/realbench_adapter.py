from __future__ import annotations

import json
from pathlib import Path
from typing import Any

from revolution.runtime.benchmark_capabilities import (
    derive_quality_mode,
    resolve_benchmark_capabilities,
)
from revolution.runtime.problem_context import (
    ProblemContext,
    resolve_testbench_top_module_from_path,
)
from revolution.runtime.problem_spec import ProblemSpec


def load_realbench_manifest(realbench_root: str | Path) -> list[dict[str, Any]]:
    """Load a lightweight RealBench module-manifest description."""

    root = Path(realbench_root)
    manifest_path = root / "module_manifest.json"
    if not manifest_path.is_file():
        return []
    try:
        payload = json.loads(manifest_path.read_text(encoding="utf-8"))
    except json.JSONDecodeError:
        return []
    if isinstance(payload, list):
        entries = payload
    elif isinstance(payload, dict):
        entries = payload.get("problems", [])
    else:
        entries = []
    return [entry for entry in entries if isinstance(entry, dict)]


def select_realbench_problem_ids(
    realbench_root: str | Path,
    *,
    selected_ids: list[str] | None = None,
    subset: str = "module",
) -> list[str]:
    """Select RealBench problem ids from the module manifest."""

    selected_set = set(selected_ids) if selected_ids else None
    ids: list[str] = []
    for entry in load_realbench_manifest(realbench_root):
        problem_name = str(
            entry.get("problem_name") or entry.get("id") or entry.get("name") or ""
        ).strip()
        if not problem_name:
            continue
        entry_subset = str(entry.get("subset", "module")).strip().lower()
        if subset and entry_subset != subset.lower():
            continue
        if selected_set is not None and problem_name not in selected_set:
            continue
        ids.append(problem_name)
    return ids


def load_realbench_record(
    realbench_root: str | Path,
    problem_name: str,
) -> dict[str, Any] | None:
    """Load one RealBench manifest entry by problem name."""

    for entry in load_realbench_manifest(realbench_root):
        entry_name = str(
            entry.get("problem_name") or entry.get("id") or entry.get("name") or ""
        ).strip()
        if entry_name == problem_name:
            return entry
    return None


def build_realbench_problem_context(
    *,
    benchmark_name: str,
    problem_name: str,
    realbench_root: str | Path,
    realbench_record: dict[str, Any],
) -> ProblemContext:
    """Build a ProblemContext from a RealBench module-manifest entry."""

    root = Path(realbench_root).resolve()
    prompt_path = _resolve_required_path(root, realbench_record, "prompt_path")
    test_sv_path = _resolve_required_path(root, realbench_record, "test_sv_path")
    ref_value = realbench_record.get("ref_sv_path")
    ref_sv_path = _resolve_optional_path(root, ref_value)
    prompt_text = prompt_path.read_text(encoding="utf-8").strip()
    top_module_path = root / "synthesis_top_module_names.json"
    testbench_top_module = str(
        realbench_record.get("testbench_top_module")
        or resolve_testbench_top_module_from_path(test_sv_path)
    )
    return ProblemContext(
        benchmark_name=benchmark_name,
        problem_name=problem_name,
        benchmark_path=root,
        prompt_path=prompt_path,
        problem_description=prompt_text,
        test_sv_path=test_sv_path,
        ref_sv_path=ref_sv_path,
        top_module_names_path=top_module_path,
        testbench_top_module=testbench_top_module,
    )


def build_realbench_problem_spec(
    context: ProblemContext,
    *,
    realbench_record: dict[str, Any],
    supports_reference_ppa: bool,
) -> ProblemSpec:
    """Build a normalized ProblemSpec for RealBench module tasks."""

    top_module = str(realbench_record.get("top_module") or "TopModule")
    testbench_top_module = str(
        realbench_record.get("testbench_top_module") or context.testbench_top_module
    )
    supports_formal = bool(realbench_record.get("supports_formal", False))
    aux_files = tuple(str(item) for item in realbench_record.get("aux_files", []) or [])
    capabilities = resolve_benchmark_capabilities(
        context.benchmark_name,
        supports_reference_ppa=supports_reference_ppa,
        supports_synthesis=bool(realbench_record.get("supports_synthesis", True)),
        top_module=top_module,
        aux_files=aux_files,
        default_timeout_s=_optional_float(realbench_record.get("timeout_s")),
        clock_metadata=_optional_str_mapping(realbench_record.get("clock_metadata")),
        reset_metadata=_optional_str_mapping(realbench_record.get("reset_metadata")),
        license_tag=_optional_str(realbench_record.get("license_tag")),
    )
    supports_synthesis = capabilities.supports_synthesis
    quality_mode = derive_quality_mode(capabilities)
    descriptor_profile = "hybrid_phys_seq" if quality_mode == "ppa" else "rtl_core"
    return ProblemSpec(
        benchmark_name=context.benchmark_name,
        problem_name=context.problem_name,
        prompt_text=context.problem_description,
        top_module=top_module,
        benchmark_root=context.benchmark_path,
        testbench_top_module=testbench_top_module,
        reference_sources=((str(context.ref_sv_path),) if context.ref_sv_path else ()),
        test_harness=str(context.test_sv_path),
        aux_files=aux_files,
        supports_synthesis=supports_synthesis,
        supports_formal=supports_formal,
        supports_reference_ppa=supports_reference_ppa,
        quality_mode=quality_mode,
        circuit_type="unknown",
        default_descriptor_profile=descriptor_profile,
        phase_generation_defaults={
            "fail": "whole",
            "seed": "whole",
            "backfill": "diff",
            "refine": "diff",
            "crossover": "whole",
        },
        metadata={
            "subset": str(realbench_record.get("subset", "module")),
            "supports_formal": str(supports_formal).lower(),
        },
        capabilities=capabilities,
    )


def load_realbench_reference_ppa_metrics(
    realbench_root: str | Path,
    realbench_record: dict[str, Any],
) -> dict[str, float]:
    """Load reference PPA metrics from an explicit RealBench manifest path."""

    ppa_path = _resolve_optional_path(realbench_root, realbench_record.get("ppa_path"))
    if ppa_path is None or not ppa_path.is_file():
        return {}
    lines = ppa_path.read_text(encoding="utf-8").splitlines()
    if len(lines) < 2:
        return {}
    values = lines[1].split(",")
    if len(values) < 5:
        return {}
    try:
        tns = float(values[0])
        wns = float(values[1])
        eff_clk_period = float(values[2])
        power = float(values[3])
        area = float(values[4])
    except ValueError:
        return {}
    return {
        "tns": tns,
        "wns": wns,
        "eff_clk_period": eff_clk_period,
        "power": power,
        "area": area,
    }


def _optional_str(value: Any) -> str | None:
    if not isinstance(value, str) or not value.strip():
        return None
    return value.strip()


def _optional_float(value: Any) -> float | None:
    if isinstance(value, bool) or value is None:
        return None
    try:
        return float(value)
    except (TypeError, ValueError):
        return None


def _optional_str_mapping(value: Any) -> dict[str, str] | None:
    if not isinstance(value, dict) or not value:
        return None
    return {str(key): str(item) for key, item in value.items()}


def _resolve_required_path(root: Path, record: dict[str, Any], key: str) -> Path:
    value = record.get(key)
    path = _resolve_optional_path(root, value)
    if path is None or not path.is_file():
        raise FileNotFoundError(f"RealBench manifest entry missing readable {key}: {value}")
    return path


def _resolve_optional_path(root: str | Path, value: Any) -> Path | None:
    if not isinstance(value, str) or not value.strip():
        return None
    path = Path(value)
    if not path.is_absolute():
        path = Path(root) / path
    return path.resolve()
