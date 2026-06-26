"""Extract one pooled DeepGate descriptor vector for an RTL candidate."""

from __future__ import annotations

import argparse
import json
import shlex
import subprocess
import time
from dataclasses import dataclass
from pathlib import Path
from typing import List, Set, Tuple

import deepgate  # type: ignore[reportMissingImports]
import numpy as np
import torch  # type: ignore[reportMissingImports]


@dataclass(frozen=True)
class ConeCandidate:
    output_index: int
    output_literal: int
    cone_vars: Set[int]
    input_vars: Set[int]
    and_lines: List[Tuple[int, int, int]]


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--code", required=True, type=Path)
    parser.add_argument("--top", required=True)
    parser.add_argument("--projection-artifact", required=True, type=Path)
    parser.add_argument("--output-json", required=True, type=Path)
    parser.add_argument("--work-dir", required=True, type=Path)
    parser.add_argument("--max-aig-vars", required=True, type=int)
    parser.add_argument("--max-cone-ands", required=True, type=int)
    parser.add_argument("--max-cones", required=True, type=int)
    return parser.parse_args()


def yosys_script(code_path: Path, top: str, aig_path: Path) -> str:
    return (
        f"read_verilog -sv {shlex.quote(str(code_path))}; "
        f"hierarchy -check -top {shlex.quote(top)}; proc; "
        "async2sync; clk2fflogic; flatten; opt; setundef -zero; "
        "techmap; opt; aigmap; "
        f"write_aiger -ascii {shlex.quote(str(aig_path))}"
    )


def export_transition_aig(code_path: Path, top: str, aig_path: Path) -> None:
    result = subprocess.run(
        ["yosys", "-q", "-p", yosys_script(code_path, top, aig_path)],
        check=False,
        capture_output=True,
        text=True,
        timeout=60,
    )
    assert result.returncode == 0, result.stderr[-2000:]
    abstract_latches_as_transition(aig_path)


def abstract_latches_as_transition(aig_path: Path) -> None:
    lines = aig_path.read_text().splitlines()
    header = lines[0].split()
    assert header[0] == "aag"
    _, inputs, latches, outputs, ands = map(int, header[1:6])
    input_literals = [int(line.split()[0]) for line in lines[1 : 1 + inputs]]
    latch_lines = lines[1 + inputs : 1 + inputs + latches]
    output_literals = [
        int(line.split()[0])
        for line in lines[1 + inputs + latches : 1 + inputs + latches + outputs]
    ]
    and_lines = [
        line.split()
        for line in lines[1 + inputs + latches + outputs : 1 + inputs + latches + outputs + ands]
    ]
    latch_current = [int(line.split()[0]) for line in latch_lines]
    latch_next = [int(line.split()[1]) for line in latch_lines]
    old_input_vars = [literal // 2 for literal in [*input_literals, *latch_current]]
    var_map = {old_var: index + 1 for index, old_var in enumerate(old_input_vars)}
    constants = [
        literal
        for literal in [
            *output_literals,
            *latch_next,
            *(int(item) for line in and_lines for item in line[1:]),
        ]
        if literal < 2
    ]
    constant_var = len(old_input_vars) + 1 if constants else None
    next_var = len(old_input_vars) + 1
    if constant_var is not None:
        next_var += 1
    for line in and_lines:
        var_map[int(line[0]) // 2] = next_var
        next_var += 1

    def remap_literal(literal: int) -> int:
        if literal < 2:
            assert constant_var is not None
            return constant_var * 2 + literal
        return var_map[literal // 2] * 2 + literal % 2

    new_inputs = [str((index + 1) * 2) for index in range(len(old_input_vars))]
    if constant_var is not None:
        new_inputs.append(str(constant_var * 2))
    new_outputs = [
        str(remap_literal(literal))
        for literal in [*output_literals, *latch_next]
    ]
    new_ands = [
        f"{remap_literal(int(line[0]))} {remap_literal(int(line[1]))} {remap_literal(int(line[2]))}"
        for line in and_lines
    ]
    aig_path.write_text(
        "\n".join(
            [
                f"aag {next_var - 1} {len(new_inputs)} 0 {len(new_outputs)} {len(new_ands)}",
                *new_inputs,
                *new_outputs,
                *new_ands,
            ]
        )
        + "\n"
    )


def parse_aag(path: Path) -> Tuple[List[int], List[int], List[Tuple[int, int, int]]]:
    lines = path.read_text().splitlines()
    header = lines[0].split()
    assert header[0] == "aag"
    _, inputs, latches, outputs, ands = map(int, header[1:6])
    assert latches == 0
    input_literals = [int(lines[1 + index].split()[0]) for index in range(inputs)]
    output_start = 1 + inputs
    output_literals = [int(lines[output_start + index].split()[0]) for index in range(outputs)]
    and_start = output_start + outputs
    and_lines = []
    for index in range(ands):
        items = tuple(map(int, lines[and_start + index].split()))
        assert len(items) == 3
        and_lines.append(items)
    return input_literals, output_literals, and_lines


def collect_cone_vars(
    literal: int,
    gates: dict[int, Tuple[int, int]],
    seen: Set[int],
) -> None:
    if literal < 2:
        return
    var = literal // 2
    if var not in gates or var in seen:
        return
    seen.add(var)
    left, right = gates[var]
    collect_cone_vars(left, gates, seen)
    collect_cone_vars(right, gates, seen)


def candidate_cones(path: Path, max_cone_ands: int) -> List[ConeCandidate]:
    _, output_literals, and_lines = parse_aag(path)
    gates = {line[0] // 2: (line[1], line[2]) for line in and_lines}
    cones = []
    for output_index, output_literal in enumerate(output_literals):
        cone_vars: Set[int] = set()
        collect_cone_vars(output_literal, gates, cone_vars)
        if not cone_vars or len(cone_vars) > max_cone_ands:
            continue
        cone_lines = [line for line in and_lines if line[0] // 2 in cone_vars]
        boundary_literals = [output_literal, *(item for line in cone_lines for item in line[1:])]
        input_vars = {
            literal // 2
            for literal in boundary_literals
            if literal >= 2 and literal // 2 not in cone_vars
        }
        cones.append(
            ConeCandidate(
                output_index=output_index,
                output_literal=output_literal,
                cone_vars=cone_vars,
                input_vars=input_vars,
                and_lines=and_lines,
            )
        )
    return sorted(cones, key=lambda cone: (len(cone.cone_vars), cone.output_index))


def write_cone_aag(path: Path, cone: ConeCandidate) -> dict[str, int]:
    cone_lines = [line for line in cone.and_lines if line[0] // 2 in cone.cone_vars]
    literals = [cone.output_literal, *(item for line in cone_lines for item in line[1:])]
    constant_var = len(cone.input_vars) + 1 if any(literal < 2 for literal in literals) else None
    var_map = {var: index + 1 for index, var in enumerate(sorted(cone.input_vars))}
    next_var = len(var_map) + 1
    if constant_var is not None:
        next_var += 1
    for line in cone_lines:
        var_map[line[0] // 2] = next_var
        next_var += 1

    def remap_literal(literal: int) -> int:
        if literal < 2:
            assert constant_var is not None
            return constant_var * 2 + literal
        return var_map[literal // 2] * 2 + literal % 2

    new_inputs = [str((index + 1) * 2) for index in range(len(cone.input_vars))]
    if constant_var is not None:
        new_inputs.append(str(constant_var * 2))
    new_ands = [
        f"{remap_literal(line[0])} {remap_literal(line[1])} {remap_literal(line[2])}"
        for line in cone_lines
    ]
    path.write_text(
        "\n".join(
            [
                f"aag {next_var - 1} {len(new_inputs)} 0 1 {len(new_ands)}",
                *new_inputs,
                str(remap_literal(cone.output_literal)),
                *new_ands,
            ]
        )
        + "\n"
    )
    return {"cone_count": 1, "max_cone_ands": len(new_ands)}


def normalized_mean(vectors: List[np.ndarray]) -> np.ndarray:
    assert vectors
    vector = np.mean(np.asarray(vectors), axis=0)
    norm = np.linalg.norm(vector)
    assert norm > 0.0
    return vector / norm


def embed_aag(model: deepgate.Model, parser: deepgate.AigParser, path: Path) -> np.ndarray:
    graph = parser.read_aiger(str(path))
    assert graph.edge_index is not None
    with torch.no_grad():
        hs, hf = model(graph)
    vector = torch.cat([hs.mean(dim=0), hf.mean(dim=0)]).detach().cpu().numpy()
    norm = np.linalg.norm(vector)
    assert norm > 0.0
    return vector / norm


def project(vector: np.ndarray, artifact_path: Path) -> dict[str, float]:
    payload = json.loads(artifact_path.read_text(encoding="utf-8"))
    assert payload["artifact_kind"] == "deepgate_pooled_projection_v0"
    axes = [str(axis) for axis in payload["axes"]]
    mean = np.asarray(payload["mean"], dtype=np.float64)
    components = np.asarray(payload["components"], dtype=np.float64)
    assert vector.shape == mean.shape
    values = components @ (vector.astype(np.float64) - mean)
    return dict(zip(axes, (float(value) for value in values)))


def main() -> None:
    args = parse_args()
    args.work_dir.mkdir(parents=True, exist_ok=True)
    args.output_json.parent.mkdir(parents=True, exist_ok=True)
    aig_path = args.work_dir / "candidate.aag"
    export_transition_aig(args.code, args.top, aig_path)
    _, _, and_lines = parse_aag(aig_path)
    header = read_header(aig_path)

    torch.set_num_threads(1)
    model = deepgate.Model()
    model.load_pretrained()
    model.eval()
    parser = deepgate.AigParser()

    start = time.monotonic()
    if header["variables"] <= args.max_aig_vars and header["ands"] > 0:
        source = "full_transition"
        cone_count = 0
        max_cone_ands = 0
        vector = embed_aag(model, parser, aig_path)
    else:
        cones = candidate_cones(aig_path, args.max_cone_ands)[: args.max_cones]
        assert cones
        vectors = []
        max_cone_ands = 0
        for index, cone in enumerate(cones):
            cone_path = args.work_dir / f"cone_{index:02d}.aag"
            cone_info = write_cone_aag(cone_path, cone)
            max_cone_ands = max(max_cone_ands, cone_info["max_cone_ands"])
            vectors.append(embed_aag(model, parser, cone_path))
        source = "cone_pool"
        cone_count = len(vectors)
        vector = normalized_mean(vectors)

    metrics = project(vector, args.projection_artifact)
    metrics.update(
        {
            "deepgate_pool_source_full_transition": float(source == "full_transition"),
            "deepgate_pool_cone_count": float(cone_count),
            "deepgate_pool_aig_variables": float(header["variables"]),
            "deepgate_pool_aig_ands": float(header["ands"]),
            "deepgate_pool_max_cone_ands": float(max_cone_ands),
            "deepgate_pool_seconds": float(time.monotonic() - start),
        }
    )
    args.output_json.write_text(
        json.dumps({"metrics": metrics, "source": source, **header}, indent=2, sort_keys=True)
        + "\n",
        encoding="utf-8",
    )


def read_header(aig_path: Path) -> dict[str, int]:
    header = aig_path.read_text().splitlines()[0].split()
    assert header[0] == "aag"
    return {
        "variables": int(header[1]),
        "inputs": int(header[2]),
        "latches": int(header[3]),
        "outputs": int(header[4]),
        "ands": int(header[5]),
    }


if __name__ == "__main__":
    main()
