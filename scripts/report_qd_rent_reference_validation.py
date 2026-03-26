#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import math
import os
import re
import shutil
import subprocess
import sys
import time
from concurrent.futures import ThreadPoolExecutor, as_completed
from dataclasses import asdict, dataclass
from pathlib import Path
from statistics import mean, median
from typing import Any

SCRIPT_DIR = os.path.abspath(os.path.dirname(__file__))
REPO_ROOT = os.path.abspath(os.path.join(SCRIPT_DIR, ".."))
SRC_ROOT = os.path.join(REPO_ROOT, "src")
if REPO_ROOT not in sys.path:
    sys.path.insert(0, REPO_ROOT)
if SRC_ROOT not in sys.path:
    sys.path.insert(0, SRC_ROOT)

from revolution.graph_descriptor_evaluator import GraphDescriptorEvaluator  # noqa: E402

PASS_MARKERS = (
    "Mismatches: 0",
    "Your Design Passed",
    "Simulation completed successfully",
)
RENT_METHOD_NAME_BY_INDEX = {
    0: "circuit_partitioning_mlpart",
    1: "graph_traversal",
    2: "rectangle_sampling_i",
    3: "rectangle_sampling_ii",
}
RENT_METHOD_PATTERN = re.compile(
    r"Method\s+(?P<index>\d+)\s*:\s*\n"
    r"(?P<label>.+?)\n"
    r"Arithmetic avg pins per gate:\s*(?P<avg>[-+0-9.eE]+),\s*"
    r"geometric avg pins per gate:\s*(?P<geom_avg>[-+0-9.eE]+)\n"
    r"-+\s*Arithmetic Rent's parameters\s*-+\n"
    r"\(1\)\s*Type 1 pin counting:\s*(?P<arith_t1>[-+0-9.eE]+),\s*"
    r"\(2\)\s*Type 2 pin counting:\s*(?P<arith_t2>[-+0-9.eE]+),\s*"
    r"\(3\)\s*Type 3 pin counting:\s*(?P<arith_t3>[-+0-9.eE]+)\n"
    r"-+\s*Geometric Rent's parameters\s*-+\n"
    r"\(1\)\s*Type 1 pin counting:\s*(?P<geom_t1>[-+0-9.eE]+),\s*"
    r"\(2\)\s*Type 2 pin counting:\s*(?P<geom_t2>[-+0-9.eE]+),\s*"
    r"\(3\)\s*Type 3 pin counting:\s*(?P<geom_t3>[-+0-9.eE]+)",
    flags=re.MULTILINE,
)
RENT_FINAL_FIT_PATTERN = re.compile(
    r"Final\s+#points\s*=\s*(?P<points>\d+),\s*Rent's p\s*=\s*(?P<value>[-+0-9.eE]+|nan|-nan)"
)
RENT_AVG_PINS_PATTERN = re.compile(
    r"Arithmetic avg pins per gate:\s*(?P<avg>[-+0-9.eE]+),\s*"
    r"geometric avg pins per gate:\s*(?P<geom_avg>[-+0-9.eE]+)"
)
RENT_SUMMARY_VALUES_PATTERN = re.compile(
    r"\(1\)\s*Type 1 pin counting:\s*(?P<type1>[-+0-9.eE]+|nan|-nan),\s*"
    r"\(2\)\s*Type 2 pin counting:\s*(?P<type2>[-+0-9.eE]+|nan|-nan),\s*"
    r"\(3\)\s*Type 3 pin counting:\s*(?P<type3>[-+0-9.eE]+|nan|-nan)"
)


@dataclass(frozen=True)
class SynthNetlistCase:
    benchmark: str
    problem: str
    backend: str
    model_label: str
    generation: str
    candidate: str
    netlist_path: str
    simulation_log_path: str
    netlist_size_bytes: int

    @property
    def case_id(self) -> str:
        return (
            f"{self.benchmark}__{self.problem}__{self.backend}__"
            f"{self.generation}__{self.candidate}"
        )


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description=(
            "Stage passing synthesized netlists from a hard-subset run, compare "
            "the repo-native Rent extractor against RentCon, and emit an "
            "analysis bundle with accuracy and runtime summaries."
        ),
    )
    parser.add_argument(
        "--run_root",
        required=True,
        help="Path to the experiment tree that contains code.syn.v outputs.",
    )
    parser.add_argument(
        "--output_root",
        default=None,
        help="Directory for staged samples and final analysis output.",
    )
    parser.add_argument(
        "--case_limit",
        type=int,
        default=None,
        help="Optional maximum number of unique-problem cases to evaluate.",
    )
    parser.add_argument(
        "--workers",
        type=int,
        default=4,
        help="Number of parallel worker threads for per-case processing.",
    )
    parser.add_argument(
        "--openroad_path",
        default="openroad",
        help="OpenROAD executable used to generate placed DEF files.",
    )
    parser.add_argument(
        "--yosys_path",
        default="yosys",
        help="Yosys executable used by the internal graph extractor.",
    )
    parser.add_argument(
        "--reference_root",
        default="/workspace/.rentcon/RentCon-180515",
        help="RentCon reference implementation root directory.",
    )
    parser.add_argument(
        "--repo_root",
        default=REPO_ROOT,
        help="Repository root used to resolve PDK assets.",
    )
    return parser


def discover_passing_cases(run_root: str | Path) -> list[SynthNetlistCase]:
    root = Path(run_root).resolve()
    cases: list[SynthNetlistCase] = []
    for log_path in sorted(root.rglob("code.syn_simulation.log")):
        if not is_passing_log(log_path):
            continue
        netlist_path = log_path.with_name("code.syn.v")
        if not netlist_path.is_file():
            continue

        relative_parts = netlist_path.relative_to(root).parts
        if len(relative_parts) < 7:
            continue

        backend = relative_parts[0]
        model_label = relative_parts[1]
        benchmark = relative_parts[2]
        problem = relative_parts[3]
        generation = relative_parts[4]
        candidate = relative_parts[5]

        cases.append(
            SynthNetlistCase(
                benchmark=benchmark,
                problem=problem,
                backend=backend,
                model_label=model_label,
                generation=generation,
                candidate=candidate,
                netlist_path=str(netlist_path),
                simulation_log_path=str(log_path),
                netlist_size_bytes=netlist_path.stat().st_size,
            )
        )
    return cases


def is_passing_log(path: Path) -> bool:
    try:
        text = path.read_text(encoding="utf-8", errors="ignore")
    except OSError:
        return False
    return any(marker in text for marker in PASS_MARKERS)


def select_problem_representatives(
    cases: list[SynthNetlistCase],
    *,
    case_limit: int | None,
) -> list[SynthNetlistCase]:
    by_problem: dict[tuple[str, str], SynthNetlistCase] = {}
    for case in cases:
        key = (case.benchmark, case.problem)
        chosen = by_problem.get(key)
        if chosen is None:
            by_problem[key] = case
            continue
        if case.netlist_size_bytes < chosen.netlist_size_bytes:
            by_problem[key] = case

    representatives = sorted(
        by_problem.values(),
        key=lambda item: (item.netlist_size_bytes, item.benchmark, item.problem),
    )
    if case_limit is None or case_limit >= len(representatives):
        return representatives
    if case_limit <= 0:
        return []

    selected: list[SynthNetlistCase] = []
    for position in range(case_limit):
        index = round(position * (len(representatives) - 1) / max(1, case_limit - 1))
        selected.append(representatives[index])

    deduped: list[SynthNetlistCase] = []
    seen_ids: set[str] = set()
    for case in selected:
        if case.case_id in seen_ids:
            continue
        seen_ids.add(case.case_id)
        deduped.append(case)
    return deduped


def prepare_output_root(output_root: str | None) -> Path:
    if output_root:
        root = Path(output_root).resolve()
    else:
        timestamp = time.strftime("%Y%m%d_%H%M%S", time.gmtime())
        root = Path(REPO_ROOT) / "exp" / f"qd_rent_reference_validation_{timestamp}"
    root.mkdir(parents=True, exist_ok=True)
    (root / "staged_cases").mkdir(parents=True, exist_ok=True)
    (root / "final_analysis").mkdir(parents=True, exist_ok=True)
    return root


def prepare_rentcon_binary(reference_root: str | Path, output_root: Path) -> Path:
    source_root = Path(reference_root).resolve() / "Source"
    bin_dir = source_root / "bin"
    candidates = [bin_dir / "RentCon.exe"]
    candidates.extend(sorted(bin_dir.glob(".nfs*")))

    for candidate in candidates:
        if not candidate.is_file():
            continue
        runtime_dir = output_root / "tools"
        runtime_dir.mkdir(parents=True, exist_ok=True)
        runtime_binary = runtime_dir / "RentCon.exe"
        shutil.copy2(candidate, runtime_binary)
        runtime_binary.chmod(0o755)
        return runtime_binary

    raise FileNotFoundError(
        f"Could not find a runnable RentCon binary under {source_root}."
    )


def stage_case(case: SynthNetlistCase, output_root: Path) -> dict[str, Any]:
    case_dir = output_root / "staged_cases" / case.case_id
    case_dir.mkdir(parents=True, exist_ok=True)

    staged_netlist = case_dir / "code.syn.v"
    staged_log = case_dir / "code.syn_simulation.log"
    shutil.copy2(case.netlist_path, staged_netlist)
    shutil.copy2(case.simulation_log_path, staged_log)

    metadata_path = case_dir / "case_metadata.json"
    metadata_path.write_text(
        json.dumps(asdict(case), indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
    )

    return {
        "case": case,
        "case_dir": case_dir,
        "staged_netlist": staged_netlist,
        "staged_log": staged_log,
        "metadata_path": metadata_path,
    }


def discover_top_module_name(netlist_path: Path) -> str:
    try:
        text = netlist_path.read_text(encoding="utf-8", errors="ignore")
    except OSError as exc:
        raise ValueError(f"Could not read {netlist_path}") from exc

    for raw_line in text.splitlines():
        stripped = raw_line.strip()
        if not stripped.startswith("module "):
            continue
        remainder = stripped.removeprefix("module ").strip()
        name = remainder.split("(", 1)[0].split(None, 1)[0].strip()
        if name:
            return name.lstrip("\\")
    raise ValueError(f"Could not discover a top module in {netlist_path}")


def measure_internal_rent(
    netlist_path: Path,
    *,
    top_module_name: str,
    yosys_path: str,
) -> dict[str, Any]:
    evaluator = GraphDescriptorEvaluator(yosys_path=yosys_path)

    total_start = time.perf_counter()
    yosys_start = total_start
    payload = evaluator._load_yosys_json(netlist_path, top_module_name=top_module_name)
    yosys_seconds = time.perf_counter() - yosys_start
    if payload is None:
        raise RuntimeError(f"Yosys JSON extraction failed for {netlist_path}")

    graph_start = time.perf_counter()
    graph = evaluator._build_graph_model(payload, top_module_name=top_module_name)
    graph_build_seconds = time.perf_counter() - graph_start
    if not graph.partition_nodes:
        raise RuntimeError(f"Internal graph model is empty for {netlist_path}")

    rent_start = time.perf_counter()
    rent_metrics = evaluator._extract_rent_metrics(graph)
    rent_seconds = time.perf_counter() - rent_start
    total_seconds = time.perf_counter() - total_start

    return {
        "graph_node_count": len(graph.cells),
        "graph_edge_count": len(graph.directed_connections),
        "rent_metrics": rent_metrics,
        "timing_seconds": {
            "internal_total_seconds": total_seconds,
            "yosys_json_seconds": yosys_seconds,
            "graph_build_seconds": graph_build_seconds,
            "rent_fit_seconds": rent_seconds,
        },
    }


def run_openroad_placement(
    *,
    case_dir: Path,
    netlist_path: Path,
    top_module_name: str,
    repo_root: Path,
    openroad_path: str,
) -> dict[str, Any]:
    pdk_root = repo_root / "data" / "pdk" / "Nangate45"
    openroad_script = case_dir / "openroad_place_for_rentcon.tcl"
    openroad_log_path = case_dir / "openroad_place_for_rentcon.log"
    raw_def_path = case_dir / "design_openroad.def"
    rentcon_def_path = case_dir / "design_rentcon_v57.def"

    fake_ram_lefs = sorted(pdk_root.glob("fakeram*.lef"))
    fake_ram_libs = sorted(pdk_root.glob("fakeram*.lib"))

    script_lines = [
        f"read_lef {quote_tcl_path(pdk_root / 'Nangate45.lef')}",
        f"read_lef {quote_tcl_path(pdk_root / 'fake_macros.lef')}",
    ]
    for lef_file in fake_ram_lefs:
        script_lines.append(f"read_lef {quote_tcl_path(lef_file)}")

    script_lines.extend(
        [
            f"read_liberty {quote_tcl_path(pdk_root / 'Nangate45_typ.lib')}",
            f"read_liberty {quote_tcl_path(pdk_root / 'fake_macros.lib')}",
        ]
    )
    for lib_file in fake_ram_libs:
        script_lines.append(f"read_liberty {quote_tcl_path(lib_file)}")

    script_lines.extend(
        [
            f"read_verilog {quote_tcl_path(netlist_path)}",
            f"link_design {top_module_name}",
            (
                "initialize_floorplan -site "
                "FreePDK45_38x28_10R_NP_162NW_34O "
                "-utilization 10 -aspect_ratio 1.0 -core_space 2"
            ),
            f"source {quote_tcl_path(pdk_root / 'Nangate45.tracks')}",
            "place_pins -hor_layers metal3 -ver_layers metal2 -random",
            "global_placement -density 0.7 -pad_left 2 -pad_right 2",
            "detailed_placement",
            f"write_def {quote_tcl_path(raw_def_path)}",
            "exit",
        ]
    )
    openroad_script.write_text("\n".join(script_lines) + "\n", encoding="utf-8")

    command = [openroad_path, str(openroad_script)]
    start = time.perf_counter()
    completed = subprocess.run(
        command,
        check=False,
        capture_output=True,
        text=True,
    )
    elapsed_seconds = time.perf_counter() - start

    log_text = completed.stdout
    if completed.stderr:
        log_text = f"{log_text}\n[stderr]\n{completed.stderr}"
    openroad_log_path.write_text(log_text, encoding="utf-8")

    if completed.returncode != 0:
        raise RuntimeError(
            f"OpenROAD placement failed for {netlist_path} with return code "
            f"{completed.returncode}."
        )
    if not raw_def_path.is_file():
        raise RuntimeError(f"OpenROAD did not emit {raw_def_path}")

    rewrite_def_for_rentcon(raw_def_path, rentcon_def_path)
    return {
        "raw_def_path": str(raw_def_path),
        "rentcon_def_path": str(rentcon_def_path),
        "openroad_script_path": str(openroad_script),
        "openroad_log_path": str(openroad_log_path),
        "openroad_seconds": elapsed_seconds,
    }


def rewrite_def_for_rentcon(source_path: Path, target_path: Path) -> None:
    text = source_path.read_text(encoding="utf-8", errors="ignore")
    if text.startswith("VERSION 5.8 ;"):
        text = text.replace("VERSION 5.8 ;", "VERSION 5.7 ;", 1)
    target_path.write_text(text, encoding="utf-8")


def quote_tcl_path(path: Path) -> str:
    return "{" + str(path) + "}"


def run_rentcon(
    *,
    rentcon_binary: Path,
    mlpart_lib_dir: Path,
    lef_path: Path,
    def_path: Path,
    case_dir: Path,
) -> dict[str, Any]:
    stdout_path = case_dir / "rentcon_stdout.log"
    stderr_path = case_dir / "rentcon_stderr.log"
    env = os.environ.copy()
    current_ld_path = env.get("LD_LIBRARY_PATH", "")
    env["LD_LIBRARY_PATH"] = (
        f"{mlpart_lib_dir}:{current_ld_path}" if current_ld_path else str(mlpart_lib_dir)
    )

    command = [
        str(rentcon_binary),
        "-l",
        str(lef_path),
        "-d",
        str(def_path),
        "-noGT",
        "-noRS",
        "-startsPerRun",
        "1",
        "-totalRuns",
        "1",
        "-verb",
        "1_1_1",
    ]
    start = time.perf_counter()
    completed = subprocess.run(
        command,
        check=False,
        capture_output=True,
        text=True,
        env=env,
        cwd=case_dir,
    )
    elapsed_seconds = time.perf_counter() - start

    stdout_path.write_text(completed.stdout, encoding="utf-8")
    stderr_path.write_text(completed.stderr, encoding="utf-8")

    rent_texts = [completed.stdout]
    extra_text_sources: list[str] = []
    for rent_report_path in sorted(case_dir.glob("*_Rent.txt")):
        try:
            rent_texts.append(
                rent_report_path.read_text(encoding="utf-8", errors="ignore")
            )
        except OSError:
            continue
        extra_text_sources.append(str(rent_report_path))

    parsed_output = parse_rentcon_output("\n".join(rent_texts))
    if not parsed_output["methods"]:
        raise RuntimeError(
            f"RentCon failed for {def_path} with return code {completed.returncode} "
            "and produced no parseable summary."
        )

    return {
        "timing_seconds": {"rentcon_seconds": elapsed_seconds},
        "stdout_path": str(stdout_path),
        "stderr_path": str(stderr_path),
        "return_code": completed.returncode,
        "extra_text_sources": extra_text_sources,
        "parsed_output": parsed_output,
    }


def parse_rentcon_output(text: str) -> dict[str, Any]:
    methods: dict[str, dict[str, Any]] = {}

    for match in RENT_METHOD_PATTERN.finditer(text):
        index = int(match.group("index"))
        method_name = RENT_METHOD_NAME_BY_INDEX.get(index, f"method_{index}")
        method_payload = ensure_method_payload(
            methods,
            method_name=method_name,
            label=match.group("label"),
            method_index=index,
        )
        method_payload["arithmetic"]["avg_pins_per_gate"] = parse_finite_float_or_none(
            match.group("avg")
        )
        method_payload["arithmetic"]["type1"] = parse_float_or_none(match.group("arith_t1"))
        method_payload["arithmetic"]["type2"] = parse_float_or_none(match.group("arith_t2"))
        method_payload["arithmetic"]["type3"] = parse_float_or_none(match.group("arith_t3"))
        method_payload["geometric"]["avg_pins_per_gate"] = parse_finite_float_or_none(
            match.group("geom_avg")
        )
        method_payload["geometric"]["type1"] = parse_float_or_none(match.group("geom_t1"))
        method_payload["geometric"]["type2"] = parse_float_or_none(match.group("geom_t2"))
        method_payload["geometric"]["type3"] = parse_float_or_none(match.group("geom_t3"))

    current_method: str | None = None
    current_domain: str | None = None
    current_type: str | None = None

    for raw_line in text.splitlines():
        line = raw_line.strip()
        if not line:
            continue

        if line.startswith("========="):
            current_method = resolve_method_name_from_label(line)
            if current_method is not None:
                ensure_method_payload(
                    methods,
                    method_name=current_method,
                    label=line,
                    method_index=resolve_method_index(current_method),
                )
            current_domain = None
            current_type = None
            continue

        if line.startswith("Start to fit arithmetic"):
            current_domain = "arithmetic"
            current_type = None
            continue

        if line.startswith("Start to fit geometric"):
            current_domain = "geometric"
            current_type = None
            continue

        if "Arithmetic Rent's parameters" in line:
            current_domain = "arithmetic"
            current_type = None
            continue

        if "Geometric Rent's parameters" in line:
            current_domain = "geometric"
            current_type = None
            continue

        if "Type I Rent's parameter" in line:
            current_type = "type1"
            continue

        if "Type II Rent's parameter" in line:
            current_type = "type2"
            continue

        if "Type III Rent's parameter" in line:
            current_type = "type3"
            continue

        avg_match = RENT_AVG_PINS_PATTERN.search(line)
        if avg_match is not None and current_method is not None:
            method_payload = ensure_method_payload(
                methods,
                method_name=current_method,
                label=current_method,
                method_index=resolve_method_index(current_method),
            )
            method_payload["arithmetic"]["avg_pins_per_gate"] = parse_finite_float_or_none(
                avg_match.group("avg")
            )
            method_payload["geometric"]["avg_pins_per_gate"] = parse_finite_float_or_none(
                avg_match.group("geom_avg")
            )
            continue

        summary_match = RENT_SUMMARY_VALUES_PATTERN.search(line)
        if (
            summary_match is not None
            and current_method is not None
            and current_domain in {"arithmetic", "geometric"}
        ):
            method_payload = ensure_method_payload(
                methods,
                method_name=current_method,
                label=current_method,
                method_index=resolve_method_index(current_method),
            )
            for key in ("type1", "type2", "type3"):
                value = parse_float_or_none(summary_match.group(key))
                if value is None:
                    continue
                method_payload[current_domain][key] = value
            continue

        final_match = RENT_FINAL_FIT_PATTERN.search(line)
        if (
            final_match is None
            or current_method is None
            or current_domain not in {"arithmetic", "geometric"}
            or current_type not in {"type1", "type2", "type3"}
        ):
            continue

        value = parse_float_or_none(final_match.group("value"))
        if value is None:
            continue
        method_payload = ensure_method_payload(
            methods,
            method_name=current_method,
            label=current_method,
            method_index=resolve_method_index(current_method),
        )
        if method_payload[current_domain].get(current_type) is None:
            method_payload[current_domain][current_type] = value

    return {"methods": methods}


def ensure_method_payload(
    methods: dict[str, dict[str, Any]],
    *,
    method_name: str,
    label: str,
    method_index: int | None,
) -> dict[str, Any]:
    existing = methods.get(method_name)
    if existing is not None:
        return existing

    payload = {
        "method_index": method_index,
        "label": clean_method_label(label),
        "arithmetic": {
            "avg_pins_per_gate": None,
            "type1": None,
            "type2": None,
            "type3": None,
        },
        "geometric": {
            "avg_pins_per_gate": None,
            "type1": None,
            "type2": None,
            "type3": None,
        },
    }
    methods[method_name] = payload
    return payload


def resolve_method_name_from_label(label: str) -> str | None:
    normalized = clean_method_label(label).lower()
    if "circuit partitioning" in normalized:
        return "circuit_partitioning_mlpart"
    if "graph traversal" in normalized:
        return "graph_traversal"
    if "rectangle sampling based method ii" in normalized:
        return "rectangle_sampling_ii"
    if "rectangle sampling based method i" in normalized:
        return "rectangle_sampling_i"
    return None


def resolve_method_index(method_name: str) -> int | None:
    for index, known_name in RENT_METHOD_NAME_BY_INDEX.items():
        if known_name == method_name:
            return index
    return None


def parse_float_or_none(raw_value: str) -> float | None:
    try:
        value = float(raw_value)
    except ValueError:
        return None
    if not math.isfinite(value):
        return None
    if abs(value) > 2.0:
        return None
    return value


def parse_finite_float_or_none(raw_value: str) -> float | None:
    try:
        value = float(raw_value)
    except ValueError:
        return None
    if not math.isfinite(value):
        return None
    return value


def clean_method_label(raw_label: str) -> str:
    return raw_label.replace("=", "").strip()


def compare_rent_results(
    internal_payload: dict[str, Any],
    rentcon_payload: dict[str, Any],
    placement_payload: dict[str, Any],
) -> dict[str, Any]:
    rent_metrics = internal_payload["rent_metrics"]
    internal_exponent = float(rent_metrics.get("rent_exponent", 0.0))
    gated_exponent = float(
        rent_metrics.get("rent_exponent_confidence_gated", internal_exponent)
    )
    rent_confidence = float(rent_metrics.get("rent_confidence", 0.0))
    internal_sample_count = float(rent_metrics.get("rent_sample_count", 0.0))
    raw_sample_count = float(rent_metrics.get("rent_raw_sample_count", internal_sample_count))
    retained_sample_ratio = float(
        rent_metrics.get("rent_retained_sample_ratio", 0.0)
    )
    rent_clamped_flag = float(rent_metrics.get("rent_clamped_flag", 0.0))
    methods = rentcon_payload["parsed_output"]["methods"]

    comparison: dict[str, Any] = {
        "internal": {
            "rent_exponent": internal_exponent,
            "rent_exponent_confidence_gated": gated_exponent,
            "rent_confidence": rent_confidence,
            "rent_clamped_flag": rent_clamped_flag,
            "rent_sample_count": internal_sample_count,
            "rent_raw_sample_count": raw_sample_count,
            "rent_retained_sample_ratio": retained_sample_ratio,
            "timing_seconds": internal_payload["timing_seconds"],
            "graph_node_count": internal_payload["graph_node_count"],
            "graph_edge_count": internal_payload["graph_edge_count"],
        },
        "reference": {
            "methods": methods,
            "return_code": rentcon_payload["return_code"],
            "extra_text_sources": rentcon_payload["extra_text_sources"],
            "timing_seconds": {
                "openroad_seconds": placement_payload["openroad_seconds"],
                "rentcon_seconds": rentcon_payload["timing_seconds"]["rentcon_seconds"],
                "reference_total_seconds": (
                    placement_payload["openroad_seconds"]
                    + rentcon_payload["timing_seconds"]["rentcon_seconds"]
                ),
            },
        },
        "delta": {},
        "flags": {
            "internal_clamped": rent_clamped_flag > 0.0,
            "low_sample_count": internal_sample_count <= 2.0,
            "low_confidence": rent_confidence < 0.5,
            "rentcon_nonzero_exit": rentcon_payload["return_code"] != 0,
        },
    }

    cp_method = methods.get("circuit_partitioning_mlpart")
    if cp_method is not None:
        cp_type1_raw = cp_method["arithmetic"].get("type1")
        if isinstance(cp_type1_raw, (int, float)):
            cp_type1 = float(cp_type1_raw)
            comparison["delta"]["raw_vs_circuit_partitioning_type1"] = (
                internal_exponent - cp_type1
            )
            comparison["delta"]["gated_vs_circuit_partitioning_type1"] = (
                gated_exponent - cp_type1
            )

    gt_method = methods.get("graph_traversal")
    if gt_method is not None:
        gt_type1_raw = gt_method["arithmetic"].get("type1")
        if isinstance(gt_type1_raw, (int, float)):
            gt_type1 = float(gt_type1_raw)
            comparison["delta"]["raw_vs_graph_traversal_type1"] = internal_exponent - gt_type1
            comparison["delta"]["gated_vs_graph_traversal_type1"] = gated_exponent - gt_type1

    return comparison


def process_case(
    *,
    case: SynthNetlistCase,
    output_root: Path,
    repo_root: Path,
    openroad_path: str,
    yosys_path: str,
    rentcon_binary: Path,
    mlpart_lib_dir: Path,
) -> dict[str, Any]:
    staged = stage_case(case, output_root)
    case_dir = staged["case_dir"]
    staged_netlist = staged["staged_netlist"]
    top_module_name = discover_top_module_name(staged_netlist)

    internal_payload = measure_internal_rent(
        staged_netlist,
        top_module_name=top_module_name,
        yosys_path=yosys_path,
    )
    placement_payload = run_openroad_placement(
        case_dir=case_dir,
        netlist_path=staged_netlist,
        top_module_name=top_module_name,
        repo_root=repo_root,
        openroad_path=openroad_path,
    )
    rentcon_payload = run_rentcon(
        rentcon_binary=rentcon_binary,
        mlpart_lib_dir=mlpart_lib_dir,
        lef_path=repo_root / "data" / "pdk" / "Nangate45" / "Nangate45.lef",
        def_path=Path(placement_payload["rentcon_def_path"]),
        case_dir=case_dir,
    )
    comparison = compare_rent_results(internal_payload, rentcon_payload, placement_payload)

    result = {
        "status": "ok",
        "case": asdict(case),
        "top_module_name": top_module_name,
        "staged_paths": {
            "case_dir": str(case_dir),
            "netlist_path": str(staged_netlist),
            "simulation_log_path": str(staged["staged_log"]),
            "metadata_path": str(staged["metadata_path"]),
        },
        "internal_payload": internal_payload,
        "placement_payload": placement_payload,
        "rentcon_payload": rentcon_payload,
        "comparison": comparison,
    }
    (case_dir / "case_report.json").write_text(
        json.dumps(result, indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
    )
    return result


def build_report(
    *,
    selected_cases: list[SynthNetlistCase],
    results: list[dict[str, Any]],
    output_root: Path,
    run_root: Path,
    rentcon_binary: Path,
) -> dict[str, Any]:
    successful = [result for result in results if result.get("status") == "ok"]
    failed = [result for result in results if result.get("status") != "ok"]
    return {
        "run_root": str(run_root),
        "output_root": str(output_root),
        "rentcon_binary": str(rentcon_binary),
        "discovered_case_count": len(selected_cases),
        "completed_case_count": len(successful),
        "failed_case_count": len(failed),
        "results": results,
        "summary": summarize_results(successful),
    }


def summarize_results(successful_results: list[dict[str, Any]]) -> dict[str, Any]:
    cp_deltas_raw = collect_float_metric(
        successful_results,
        "comparison.delta.raw_vs_circuit_partitioning_type1",
    )
    cp_deltas_gated = collect_float_metric(
        successful_results,
        "comparison.delta.gated_vs_circuit_partitioning_type1",
    )
    gt_deltas_raw = collect_float_metric(
        successful_results,
        "comparison.delta.raw_vs_graph_traversal_type1",
    )
    gt_deltas_gated = collect_float_metric(
        successful_results,
        "comparison.delta.gated_vs_graph_traversal_type1",
    )
    internal_totals = collect_float_metric(
        successful_results,
        "comparison.internal.timing_seconds.internal_total_seconds",
    )
    rent_fit_totals = collect_float_metric(
        successful_results,
        "comparison.internal.timing_seconds.rent_fit_seconds",
    )
    openroad_totals = collect_float_metric(
        successful_results,
        "comparison.reference.timing_seconds.openroad_seconds",
    )
    rentcon_totals = collect_float_metric(
        successful_results,
        "comparison.reference.timing_seconds.rentcon_seconds",
    )
    reference_totals = collect_float_metric(
        successful_results,
        "comparison.reference.timing_seconds.reference_total_seconds",
    )
    cp_internal_exponents_raw, cp_type1_values_raw = collect_paired_internal_and_reference(
        successful_results,
        internal_path="comparison.internal.rent_exponent",
        method_name="circuit_partitioning_mlpart",
        domain="arithmetic",
        key="type1",
    )
    cp_internal_exponents_gated, cp_type1_values_gated = collect_paired_internal_and_reference(
        successful_results,
        internal_path="comparison.internal.rent_exponent_confidence_gated",
        method_name="circuit_partitioning_mlpart",
        domain="arithmetic",
        key="type1",
    )

    ratio_values: list[float] = []
    for internal_total, reference_total in zip(internal_totals, reference_totals, strict=False):
        if internal_total <= 0.0:
            continue
        ratio_values.append(reference_total / internal_total)

    cp_improved_count, cp_compared_count = count_improved_abs_deltas(
        successful_results,
        raw_path="comparison.delta.raw_vs_circuit_partitioning_type1",
        gated_path="comparison.delta.gated_vs_circuit_partitioning_type1",
    )
    gt_improved_count, gt_compared_count = count_improved_abs_deltas(
        successful_results,
        raw_path="comparison.delta.raw_vs_graph_traversal_type1",
        gated_path="comparison.delta.gated_vs_graph_traversal_type1",
    )

    return {
        "completed_case_count": len(successful_results),
        "mean_abs_cp_type1_delta_raw": mean_absolute(cp_deltas_raw),
        "median_abs_cp_type1_delta_raw": median_absolute(cp_deltas_raw),
        "max_abs_cp_type1_delta_raw": max_absolute(cp_deltas_raw),
        "mean_abs_cp_type1_delta_gated": mean_absolute(cp_deltas_gated),
        "median_abs_cp_type1_delta_gated": median_absolute(cp_deltas_gated),
        "max_abs_cp_type1_delta_gated": max_absolute(cp_deltas_gated),
        "mean_abs_gt_type1_delta_raw": mean_absolute(gt_deltas_raw),
        "median_abs_gt_type1_delta_raw": median_absolute(gt_deltas_raw),
        "mean_abs_gt_type1_delta_gated": mean_absolute(gt_deltas_gated),
        "median_abs_gt_type1_delta_gated": median_absolute(gt_deltas_gated),
        "raw_cp_type1_pearson_r": pearson_correlation(
            cp_internal_exponents_raw,
            cp_type1_values_raw,
        ),
        "gated_cp_type1_pearson_r": pearson_correlation(
            cp_internal_exponents_gated,
            cp_type1_values_gated,
        ),
        "cp_type1_mean_abs_delta_improvement": subtract_or_none(
            mean_absolute(cp_deltas_raw),
            mean_absolute(cp_deltas_gated),
        ),
        "gt_type1_mean_abs_delta_improvement": subtract_or_none(
            mean_absolute(gt_deltas_raw),
            mean_absolute(gt_deltas_gated),
        ),
        "gated_better_than_raw_cp_type1_case_count": cp_improved_count,
        "gated_better_than_raw_cp_type1_case_total": cp_compared_count,
        "gated_better_than_raw_gt_type1_case_count": gt_improved_count,
        "gated_better_than_raw_gt_type1_case_total": gt_compared_count,
        "internal_clamped_case_count": sum(
            1
            for result in successful_results
            if bool(result["comparison"]["flags"]["internal_clamped"])
        ),
        "low_sample_count_case_count": sum(
            1
            for result in successful_results
            if bool(result["comparison"]["flags"]["low_sample_count"])
        ),
        "low_confidence_case_count": sum(
            1
            for result in successful_results
            if bool(result["comparison"]["flags"].get("low_confidence"))
        ),
        "rentcon_nonzero_exit_case_count": sum(
            1
            for result in successful_results
            if bool(result["comparison"]["flags"].get("rentcon_nonzero_exit"))
        ),
        "internal_total_seconds_mean": mean_or_none(internal_totals),
        "internal_total_seconds_median": median_or_none(internal_totals),
        "rent_fit_seconds_mean": mean_or_none(rent_fit_totals),
        "openroad_seconds_mean": mean_or_none(openroad_totals),
        "rentcon_seconds_mean": mean_or_none(rentcon_totals),
        "reference_total_seconds_mean": mean_or_none(reference_totals),
        "reference_over_internal_ratio_mean": mean_or_none(ratio_values),
    }


def collect_float_metric(results: list[dict[str, Any]], path: str) -> list[float]:
    values: list[float] = []
    for result in results:
        value = lookup_path(result, path)
        if isinstance(value, (int, float)):
            values.append(float(value))
    return values


def collect_reference_metric(
    results: list[dict[str, Any]],
    method_name: str,
    domain: str,
    key: str,
) -> list[float]:
    values: list[float] = []
    for result in results:
        methods = lookup_path(result, "rentcon_payload.parsed_output.methods")
        if not isinstance(methods, dict):
            continue
        method = methods.get(method_name)
        if not isinstance(method, dict):
            continue
        domain_payload = method.get(domain)
        if not isinstance(domain_payload, dict):
            continue
        value = domain_payload.get(key)
        if isinstance(value, (int, float)):
            values.append(float(value))
    return values


def collect_paired_internal_and_reference(
    results: list[dict[str, Any]],
    *,
    internal_path: str,
    method_name: str,
    domain: str,
    key: str,
) -> tuple[list[float], list[float]]:
    internal_values: list[float] = []
    reference_values: list[float] = []
    for result in results:
        internal_value = lookup_path(result, internal_path)
        methods = lookup_path(result, "rentcon_payload.parsed_output.methods")
        if not isinstance(internal_value, (int, float)) or not isinstance(methods, dict):
            continue
        method = methods.get(method_name)
        if not isinstance(method, dict):
            continue
        domain_payload = method.get(domain)
        if not isinstance(domain_payload, dict):
            continue
        reference_value = domain_payload.get(key)
        if not isinstance(reference_value, (int, float)):
            continue
        internal_values.append(float(internal_value))
        reference_values.append(float(reference_value))
    return internal_values, reference_values


def count_improved_abs_deltas(
    results: list[dict[str, Any]],
    *,
    raw_path: str,
    gated_path: str,
) -> tuple[int, int]:
    improved_count = 0
    compared_count = 0
    for result in results:
        raw_value = lookup_path(result, raw_path)
        gated_value = lookup_path(result, gated_path)
        if not isinstance(raw_value, (int, float)) or not isinstance(gated_value, (int, float)):
            continue
        compared_count += 1
        if abs(float(gated_value)) < abs(float(raw_value)):
            improved_count += 1
    return improved_count, compared_count


def lookup_path(payload: dict[str, Any], path: str) -> Any:
    current: Any = payload
    for part in path.split("."):
        if not isinstance(current, dict):
            return None
        current = current.get(part)
    return current


def mean_absolute(values: list[float]) -> float | None:
    if not values:
        return None
    return mean(abs(value) for value in values)


def median_absolute(values: list[float]) -> float | None:
    if not values:
        return None
    return median(abs(value) for value in values)


def max_absolute(values: list[float]) -> float | None:
    if not values:
        return None
    return max(abs(value) for value in values)


def mean_or_none(values: list[float]) -> float | None:
    if not values:
        return None
    return mean(values)


def median_or_none(values: list[float]) -> float | None:
    if not values:
        return None
    return median(values)


def pearson_correlation(xs: list[float], ys: list[float]) -> float | None:
    if len(xs) != len(ys) or len(xs) < 2:
        return None
    mean_x = mean(xs)
    mean_y = mean(ys)
    centered_x = [value - mean_x for value in xs]
    centered_y = [value - mean_y for value in ys]
    numerator = sum(x * y for x, y in zip(centered_x, centered_y, strict=False))
    denom_x = math.sqrt(sum(x * x for x in centered_x))
    denom_y = math.sqrt(sum(y * y for y in centered_y))
    if denom_x <= 0.0 or denom_y <= 0.0:
        return None
    return numerator / (denom_x * denom_y)


def subtract_or_none(lhs: float | None, rhs: float | None) -> float | None:
    if lhs is None or rhs is None:
        return None
    return lhs - rhs


def render_markdown_report(report: dict[str, Any]) -> str:
    summary = report["summary"]
    lines = [
        "# Rent Reference Validation Report",
        "",
        f"- run_root: `{report['run_root']}`",
        f"- output_root: `{report['output_root']}`",
        f"- rentcon_binary: `{report['rentcon_binary']}`",
        f"- completed_case_count: `{report['completed_case_count']}`",
        f"- failed_case_count: `{report['failed_case_count']}`",
        f"- mean_abs_cp_type1_delta_raw: `{format_metric(summary.get('mean_abs_cp_type1_delta_raw'))}`",
        f"- mean_abs_cp_type1_delta_gated: `{format_metric(summary.get('mean_abs_cp_type1_delta_gated'))}`",
        f"- cp_type1_mean_abs_delta_improvement: `{format_metric(summary.get('cp_type1_mean_abs_delta_improvement'))}`",
        f"- mean_abs_gt_type1_delta_raw: `{format_metric(summary.get('mean_abs_gt_type1_delta_raw'))}`",
        f"- mean_abs_gt_type1_delta_gated: `{format_metric(summary.get('mean_abs_gt_type1_delta_gated'))}`",
        f"- gt_type1_mean_abs_delta_improvement: `{format_metric(summary.get('gt_type1_mean_abs_delta_improvement'))}`",
        f"- raw_cp_type1_pearson_r: `{format_metric(summary.get('raw_cp_type1_pearson_r'))}`",
        f"- gated_cp_type1_pearson_r: `{format_metric(summary.get('gated_cp_type1_pearson_r'))}`",
        f"- gated_better_than_raw_cp_type1_case_count: `{summary.get('gated_better_than_raw_cp_type1_case_count')}` / `{summary.get('gated_better_than_raw_cp_type1_case_total')}`",
        f"- gated_better_than_raw_gt_type1_case_count: `{summary.get('gated_better_than_raw_gt_type1_case_count')}` / `{summary.get('gated_better_than_raw_gt_type1_case_total')}`",
        f"- internal_clamped_case_count: `{summary.get('internal_clamped_case_count')}`",
        f"- low_sample_count_case_count: `{summary.get('low_sample_count_case_count')}`",
        f"- low_confidence_case_count: `{summary.get('low_confidence_case_count')}`",
        f"- rentcon_nonzero_exit_case_count: `{summary.get('rentcon_nonzero_exit_case_count')}`",
        f"- internal_total_seconds_mean: `{format_metric(summary.get('internal_total_seconds_mean'))}`",
        f"- reference_total_seconds_mean: `{format_metric(summary.get('reference_total_seconds_mean'))}`",
        f"- reference_over_internal_ratio_mean: `{format_metric(summary.get('reference_over_internal_ratio_mean'))}`",
        "",
        "## Per-Case Summary",
        "",
        "| Case | Nodes | Raw p | Gated p | Conf | Samples | CP Type1 | |raw-CP| | |gated-CP| | Internal s | Ref s | Flags |",
        "| --- | ---: | ---: | ---: | ---: | --- | ---: | ---: | ---: | ---: | ---: | --- |",
    ]

    for result in report["results"]:
        if result.get("status") != "ok":
            case = result.get("case", {})
            lines.append(
                f"| {case.get('problem', 'unknown')} | - | - | - | - | - | - | - | - | "
                f"failed: {result.get('error', 'unknown')} |"
            )
            continue

        case = result["case"]
        comparison = result["comparison"]
        cp_type1 = lookup_path(
            result,
            "rentcon_payload.parsed_output.methods.circuit_partitioning_mlpart.arithmetic.type1",
        )
        raw_cp_delta = comparison["delta"].get("raw_vs_circuit_partitioning_type1")
        gated_cp_delta = comparison["delta"].get("gated_vs_circuit_partitioning_type1")
        flags: list[str] = []
        if comparison["flags"]["internal_clamped"]:
            flags.append("clamped")
        if comparison["flags"]["low_sample_count"]:
            flags.append("low-samples")
        if comparison["flags"].get("low_confidence"):
            flags.append("low-confidence")
        if comparison["flags"].get("rentcon_nonzero_exit"):
            flags.append("rentcon-nonzero")

        retained_samples = comparison["internal"]["rent_sample_count"]
        raw_samples = comparison["internal"]["rent_raw_sample_count"]
        sample_text = format_sample_counts(retained_samples, raw_samples)

        lines.append(
            f"| {case['benchmark']}/{case['problem']} | "
            f"{comparison['internal']['graph_node_count']} | "
            f"{format_metric(comparison['internal']['rent_exponent'])} | "
            f"{format_metric(comparison['internal']['rent_exponent_confidence_gated'])} | "
            f"{format_metric(comparison['internal']['rent_confidence'])} | "
            f"{sample_text} | "
            f"{format_metric(cp_type1)} | "
            f"{format_metric(abs(raw_cp_delta) if isinstance(raw_cp_delta, float) else None)} | "
            f"{format_metric(abs(gated_cp_delta) if isinstance(gated_cp_delta, float) else None)} | "
            f"{format_metric(comparison['internal']['timing_seconds']['internal_total_seconds'])} | "
            f"{format_metric(comparison['reference']['timing_seconds']['reference_total_seconds'])} | "
            f"{', '.join(flags) if flags else '-'} |"
        )

    lines.append("")
    return "\n".join(lines)


def format_metric(value: Any) -> str:
    if not isinstance(value, (int, float)):
        return "-"
    return f"{float(value):.6f}"


def format_sample_counts(retained_samples: Any, raw_samples: Any) -> str:
    if not isinstance(retained_samples, (int, float)):
        return "-"
    if not isinstance(raw_samples, (int, float)):
        return format_metric(retained_samples)
    return f"{int(round(float(retained_samples)))}/{int(round(float(raw_samples)))}"


def plot_accuracy_scatter(
    ax: Any,
    *,
    reference_values: list[float],
    internal_values: list[float],
    ylabel: str,
    title: str,
) -> None:
    ax.scatter(reference_values, internal_values)
    low = min(reference_values + internal_values)
    high = max(reference_values + internal_values)
    ax.plot([low, high], [low, high], linestyle="--", color="gray")
    ax.set_xlabel("RentCon CP arithmetic Type I")
    ax.set_ylabel(ylabel)
    ax.set_title(title)


def render_plots(report: dict[str, Any], output_dir: Path) -> list[str]:
    try:
        import importlib

        plt = importlib.import_module("matplotlib.pyplot")
    except Exception:
        return []

    successful = [result for result in report["results"] if result.get("status") == "ok"]
    if not successful:
        return []

    internal_values, cp_values = collect_paired_internal_and_reference(
        successful,
        internal_path="comparison.internal.rent_exponent",
        method_name="circuit_partitioning_mlpart",
        domain="arithmetic",
        key="type1",
    )
    gated_values, gated_cp_values = collect_paired_internal_and_reference(
        successful,
        internal_path="comparison.internal.rent_exponent_confidence_gated",
        method_name="circuit_partitioning_mlpart",
        domain="arithmetic",
        key="type1",
    )
    case_labels = [
        f"{result['case']['problem']}"
        for result in successful
    ]
    internal_times = collect_float_metric(
        successful,
        "comparison.internal.timing_seconds.internal_total_seconds",
    )
    reference_times = collect_float_metric(
        successful,
        "comparison.reference.timing_seconds.reference_total_seconds",
    )

    output_paths: list[str] = []

    if (
        len(internal_values) == len(cp_values)
        and len(gated_values) == len(gated_cp_values)
        and internal_values
        and gated_values
    ):
        fig, axes = plt.subplots(1, 2, figsize=(12, 6), sharex=True, sharey=True)
        plot_accuracy_scatter(
            axes[0],
            reference_values=cp_values,
            internal_values=internal_values,
            ylabel="Internal raw rent_exponent",
            title="Raw Internal vs RentCon",
        )
        plot_accuracy_scatter(
            axes[1],
            reference_values=gated_cp_values,
            internal_values=gated_values,
            ylabel="Internal gated rent_exponent",
            title="Confidence-Gated Internal vs RentCon",
        )
        plot_path = output_dir / "rent_accuracy_scatter.png"
        fig.tight_layout()
        fig.savefig(plot_path, dpi=200)
        plt.close(fig)
        output_paths.append(str(plot_path))

    if (
        len(case_labels) == len(internal_times)
        and len(case_labels) == len(reference_times)
        and case_labels
    ):
        fig, ax = plt.subplots(figsize=(10, 4))
        x_positions = list(range(len(case_labels)))
        ax.bar(
            [position - 0.2 for position in x_positions],
            internal_times,
            width=0.4,
            label="internal",
        )
        ax.bar(
            [position + 0.2 for position in x_positions],
            reference_times,
            width=0.4,
            label="reference",
        )
        ax.set_xticks(x_positions)
        ax.set_xticklabels(case_labels, rotation=45, ha="right")
        ax.set_ylabel("seconds")
        ax.set_title("Rent Runtime Comparison by Case")
        ax.legend()
        plot_path = output_dir / "rent_runtime_comparison.png"
        fig.tight_layout()
        fig.savefig(plot_path, dpi=200)
        plt.close(fig)
        output_paths.append(str(plot_path))

    return output_paths


def write_report_bundle(report: dict[str, Any], output_root: Path) -> None:
    final_analysis_dir = output_root / "final_analysis"
    final_analysis_dir.mkdir(parents=True, exist_ok=True)

    report_json_path = final_analysis_dir / "rent_reference_validation_report.json"
    report_md_path = final_analysis_dir / "rent_reference_validation_report.md"
    report_json_path.write_text(
        json.dumps(report, indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
    )
    report_md_path.write_text(render_markdown_report(report), encoding="utf-8")

    plot_paths = render_plots(report, final_analysis_dir)
    index_payload = {
        "report_json": str(report_json_path),
        "report_md": str(report_md_path),
        "plots": plot_paths,
    }
    (final_analysis_dir / "index.json").write_text(
        json.dumps(index_payload, indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
    )


def evaluate_cases(
    *,
    selected_cases: list[SynthNetlistCase],
    output_root: Path,
    repo_root: Path,
    openroad_path: str,
    yosys_path: str,
    rentcon_binary: Path,
    reference_root: Path,
    workers: int,
) -> list[dict[str, Any]]:
    mlpart_lib_dir = reference_root / "Source" / "MLPart" / "libs"
    max_workers = max(1, min(workers, len(selected_cases) or 1))
    results: list[dict[str, Any]] = []

    with ThreadPoolExecutor(max_workers=max_workers) as executor:
        futures = {
            executor.submit(
                process_case,
                case=case,
                output_root=output_root,
                repo_root=repo_root,
                openroad_path=openroad_path,
                yosys_path=yosys_path,
                rentcon_binary=rentcon_binary,
                mlpart_lib_dir=mlpart_lib_dir,
            ): case
            for case in selected_cases
        }

        for future in as_completed(futures):
            case = futures[future]
            try:
                results.append(future.result())
            except Exception as exc:
                results.append(
                    {
                        "status": "error",
                        "case": asdict(case),
                        "error": str(exc),
                    }
                )

    results.sort(
        key=lambda item: (
            item.get("case", {}).get("benchmark", ""),
            item.get("case", {}).get("problem", ""),
            item.get("case", {}).get("candidate", ""),
        )
    )
    return results


def main(argv: list[str] | None = None) -> int:
    parser = build_parser()
    args = parser.parse_args(argv)

    run_root = Path(args.run_root).resolve()
    repo_root = Path(args.repo_root).resolve()
    reference_root = Path(args.reference_root).resolve()
    output_root = prepare_output_root(args.output_root)
    rentcon_binary = prepare_rentcon_binary(reference_root, output_root)

    discovered_cases = discover_passing_cases(run_root)
    selected_cases = select_problem_representatives(
        discovered_cases,
        case_limit=args.case_limit,
    )
    results = evaluate_cases(
        selected_cases=selected_cases,
        output_root=output_root,
        repo_root=repo_root,
        openroad_path=args.openroad_path,
        yosys_path=args.yosys_path,
        rentcon_binary=rentcon_binary,
        reference_root=reference_root,
        workers=args.workers,
    )

    report = build_report(
        selected_cases=selected_cases,
        results=results,
        output_root=output_root,
        run_root=run_root,
        rentcon_binary=rentcon_binary,
    )
    write_report_bundle(report, output_root)
    print(json.dumps(report["summary"], indent=2, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
