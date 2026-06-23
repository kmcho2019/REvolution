from __future__ import annotations

import json
import math
import re
import shlex
import subprocess
import tempfile
from collections import defaultdict
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Iterable, cast

import numpy as np

csr_matrix: Any
eigsh: Any
try:
    from scipy.sparse import csr_matrix as _csr_matrix
    from scipy.sparse.linalg import eigsh as _eigsh
except Exception:  # pragma: no cover - scipy import failures are environment-specific
    csr_matrix = None
    eigsh = None
else:
    csr_matrix = _csr_matrix
    eigsh = _eigsh


_SEQUENTIAL_CELL_MARKERS = (
    "$_DFF",
    "$DFF",
    "$_SDFF",
    "$SDFF",
    "$_ADFF",
    "$ADFF",
    "$_DLATCH",
    "$DLATCH",
    "$_DLH",
    "$_DLL",
    "$_FF",
    "$FF",
)
_SEQUENTIAL_CONTROL_PORTS = {
    "CLK",
    "C",
    "ARST",
    "SRST",
    "SET",
    "CLR",
    "RST",
    "RESET",
    "LOAD",
    "EN",
    "CE",
    "GATE",
    "G",
    "S",
    "R",
}
_SOG_ARITH_TYPES = {"$add", "$sub", "$mul", "$div", "$mod", "$pow"}
_SOG_COMPARE_TYPES = {"$eq", "$eqx", "$ge", "$gt", "$le", "$lt", "$ne", "$nex"}
_SOG_LOGIC_TYPES = {
    "$and",
    "$logic_and",
    "$logic_not",
    "$logic_or",
    "$not",
    "$or",
    "$reduce_and",
    "$reduce_bool",
    "$reduce_or",
    "$reduce_xnor",
    "$reduce_xor",
    "$xnor",
    "$xor",
}
_SOG_MUX_TYPES = {"$bmux", "$demux", "$mux", "$pmux"}
_SOG_SHIFT_TYPES = {"$shift", "$shiftx", "$shl", "$shr", "$sshl", "$sshr"}
_CONST_ZERO = {"0", "1'0", "1'b0"}
_CONST_ONE = {"1", "1'1", "1'b1"}
_INF_SCORE = 1_000_000.0


@dataclass(frozen=True)
class DirectedConnection:
    """One source-sink connection used for boundary counting."""

    source_cell: str | None
    sink_cell: str | None


@dataclass(frozen=True)
class CellModel:
    """Minimal normalized Yosys cell payload."""

    name: str
    cell_type: str
    inputs: dict[str, tuple[int | str, ...]]
    outputs: dict[str, tuple[int | str, ...]]
    is_sequential: bool


@dataclass(frozen=True)
class GraphModel:
    """Normalized graph view shared by the descriptor families."""

    cells: dict[str, CellModel]
    partition_nodes: tuple[str, ...]
    adjacency: dict[str, dict[str, float]]
    directed_adjacency: dict[str, tuple[str, ...]]
    directed_connections: tuple[DirectedConnection, ...]
    module_input_bits: frozenset[int]
    module_output_bits: frozenset[int]
    net_driver_counts: tuple[int, ...]
    net_sink_counts: tuple[int, ...]
    sequential_output_bits: frozenset[int]
    sequential_input_bits: frozenset[int]
    signal_bits: frozenset[int]
    combinational_output_to_inputs: dict[int, tuple[int, ...]]
    bit_output_cell: dict[int, str]
    cell_output_bits: dict[str, tuple[int, ...]]
    ltp_length: int | None = None


class GraphDescriptorEvaluator:
    """Extract graph-theoretic RTL/netlist descriptors from a Yosys JSON dump."""

    def __init__(
        self,
        *,
        yosys_path: str = "yosys",
        yosys_timeout_seconds: int = 30,
    ) -> None:
        self.yosys_path = yosys_path
        self.yosys_timeout_seconds = max(1, int(yosys_timeout_seconds))

    def extract_metrics(
        self,
        *,
        code_file_path: str | Path | None,
        top_module_name: str | None,
    ) -> dict[str, float]:
        """Return graph-derived metrics for one candidate RTL file."""
        if code_file_path is None:
            return {}
        path = Path(code_file_path)
        if not path.is_file():
            return {}

        payload = self._load_yosys_json(path, top_module_name=top_module_name)
        if payload is None:
            return {}
        graph = self._build_graph_model(payload, top_module_name=top_module_name)
        journal_metrics = self._extract_journal_bd_metrics(graph)
        if not graph.partition_nodes:
            return journal_metrics

        cc0, cc1, co = self._compute_scoap_scores(graph)
        metrics: dict[str, float] = dict(journal_metrics)
        metrics.update(self._extract_rent_metrics(graph))
        metrics.update(self._extract_reconvergence_metrics(graph))
        metrics.update(self._extract_scoap_histogram_metrics(graph, cc0=cc0, cc1=cc1, co=co))
        metrics.update(self._extract_spectral_metrics(graph, cc0=cc0, cc1=cc1, co=co))
        return metrics

    def _load_yosys_json(
        self,
        path: Path,
        *,
        top_module_name: str | None,
    ) -> dict[str, object] | None:
        candidate_tops: list[str | None] = []
        if top_module_name:
            candidate_tops.append(top_module_name)
        candidate_tops.extend(self._discover_module_names(path))
        candidate_tops.append(None)

        seen: set[str | None] = set()
        for candidate_top in candidate_tops:
            if candidate_top in seen:
                continue
            seen.add(candidate_top)
            payload = self._run_yosys_json(path, top_module_name=candidate_top)
            if payload is not None:
                return payload
        return None

    def _discover_module_names(self, path: Path) -> list[str]:
        try:
            text = path.read_text(encoding="utf-8", errors="ignore")
        except OSError:
            return []
        names = []
        for raw in text.splitlines():
            stripped = raw.strip()
            if not stripped.startswith("module "):
                continue
            remainder = stripped.removeprefix("module ").strip()
            name = remainder.split("(", 1)[0].split(None, 1)[0].strip()
            if name:
                names.append(name)
        return names

    def _run_yosys_json(
        self,
        path: Path,
        *,
        top_module_name: str | None,
    ) -> dict[str, object] | None:
        with tempfile.NamedTemporaryFile(suffix=".json", delete=False) as handle:
            json_path = Path(handle.name)
        if top_module_name:
            hierarchy_cmd = f"hierarchy -check -top {shlex.quote(top_module_name)};"
        else:
            hierarchy_cmd = "hierarchy -auto-top;"
        # ltp -noff is yosys's independent longest-topological-path pass;
        # its length is logged and parsed as a continuous cross-check on
        # our logic_depth (ours skips buffers, so ours <= ltp).
        script = (
            f"read_verilog -sv {shlex.quote(str(path))}; "
            f"{hierarchy_cmd} "
            "proc; opt; flatten; opt; "
            f"write_json {shlex.quote(str(json_path))}; "
            "ltp -noff"
        )
        command = [self.yosys_path, "-Q", "-p", script]
        try:
            completed = subprocess.run(
                command,
                check=False,
                capture_output=True,
                text=True,
                timeout=self.yosys_timeout_seconds,
            )
        except (FileNotFoundError, subprocess.TimeoutExpired):
            json_path.unlink(missing_ok=True)
            return None
        if completed.returncode != 0 or not json_path.is_file():
            json_path.unlink(missing_ok=True)
            return None
        try:
            payload = json.loads(json_path.read_text(encoding="utf-8"))
        except (OSError, json.JSONDecodeError):
            payload = None
        json_path.unlink(missing_ok=True)
        if not isinstance(payload, dict):
            return None
        ltp_match = re.search(r"Longest topological path in .* \(length=(\d+)\)", completed.stdout or "")
        if ltp_match is not None:
            payload["__ltp_length__"] = int(ltp_match.group(1))
        return payload

    def _build_graph_model(
        self,
        payload: dict[str, object],
        *,
        top_module_name: str | None,
    ) -> GraphModel:
        modules = payload.get("modules")
        if not isinstance(modules, dict) or not modules:
            return self._empty_graph_model()
        modules = cast(dict[str, object], modules)

        top_key = self._resolve_top_module_key(modules, top_module_name)
        module_raw = modules.get(top_key)
        if not isinstance(module_raw, dict):
            return self._empty_graph_model()

        ports_raw = module_raw.get("ports")
        cells_raw = module_raw.get("cells")
        if not isinstance(ports_raw, dict) or not isinstance(cells_raw, dict):
            return self._empty_graph_model()
        ports = cast(dict[str, object], ports_raw)
        cells_payload = cast(dict[str, object], cells_raw)
        ltp_length_raw = payload.get("__ltp_length__")

        cells: dict[str, CellModel] = {}
        bit_drivers: dict[int, list[tuple[str | None, str]]] = defaultdict(list)
        bit_users: dict[int, list[tuple[str | None, str]]] = defaultdict(list)
        module_input_bits: set[int] = set()
        module_output_bits: set[int] = set()
        sequential_output_bits: set[int] = set()
        sequential_input_bits: set[int] = set()
        signal_bits: set[int] = set()
        combinational_output_to_inputs: dict[int, tuple[int, ...]] = {}
        bit_output_cell: dict[int, str] = {}
        cell_output_bits: dict[str, tuple[int, ...]] = {}

        for port_name, port_payload in ports.items():
            if not isinstance(port_payload, dict):
                continue
            direction = str(port_payload.get("direction", "")).lower()
            bits_raw = port_payload.get("bits")
            if not isinstance(bits_raw, list):
                continue
            bits = tuple(bit for bit in bits_raw if isinstance(bit, int | str))
            for bit in bits:
                if isinstance(bit, int):
                    signal_bits.add(bit)
                    if direction == "input":
                        module_input_bits.add(bit)
                        bit_drivers[bit].append((None, "pi"))
                    elif direction == "output":
                        module_output_bits.add(bit)
                        bit_users[bit].append((None, "po"))

        for cell_name, cell_payload in cells_payload.items():
            if not isinstance(cell_payload, dict):
                continue
            cell_type = str(cell_payload.get("type", ""))
            port_dirs = cell_payload.get("port_directions", {})
            connections = cell_payload.get("connections", {})
            if not isinstance(port_dirs, dict) or not isinstance(connections, dict):
                continue
            port_dirs = cast(dict[str, object], port_dirs)
            connections = cast(dict[str, object], connections)
            inputs: dict[str, tuple[int | str, ...]] = {}
            outputs: dict[str, tuple[int | str, ...]] = {}
            is_sequential = self._is_sequential_cell(cell_type)
            sequential_data_inputs: list[int] = []

            for port_name_raw, bits_raw in connections.items():
                if not isinstance(bits_raw, list):
                    continue
                port_name = str(port_name_raw)
                bits = tuple(bit for bit in bits_raw if isinstance(bit, int | str))
                direction = str(port_dirs.get(port_name, "")).lower()
                if direction == "output":
                    outputs[port_name] = bits
                    for bit in bits:
                        if isinstance(bit, int):
                            signal_bits.add(bit)
                            bit_drivers[bit].append((str(cell_name), "cell"))
                            bit_output_cell[bit] = str(cell_name)
                            if is_sequential:
                                sequential_output_bits.add(bit)
                else:
                    inputs[port_name] = bits
                    for bit in bits:
                        if isinstance(bit, int):
                            signal_bits.add(bit)
                            bit_users[bit].append((str(cell_name), "cell"))
                            if is_sequential and not self._is_sequential_control_port(port_name):
                                sequential_data_inputs.append(bit)

            cells[str(cell_name)] = CellModel(
                name=str(cell_name),
                cell_type=cell_type,
                inputs=inputs,
                outputs=outputs,
                is_sequential=is_sequential,
            )
            cell_output_bits[str(cell_name)] = tuple(
                bit
                for bits in outputs.values()
                for bit in bits
                if isinstance(bit, int)
            )
            if not is_sequential:
                input_bits = tuple(
                    bit
                    for bits in inputs.values()
                    for bit in bits
                    if isinstance(bit, int)
                )
                for bits in outputs.values():
                    for bit in bits:
                        if isinstance(bit, int):
                            combinational_output_to_inputs[bit] = input_bits
            else:
                sequential_input_bits.update(sequential_data_inputs)

        directed_connections: list[DirectedConnection] = []
        adjacency: dict[str, dict[str, float]] = {name: {} for name in cells}
        directed_adjacency: dict[str, set[str]] = {name: set() for name in cells}

        for bit, drivers in bit_drivers.items():
            users = bit_users.get(bit, [])
            for source_cell, _ in drivers:
                for sink_cell, _ in users:
                    directed_connections.append(
                        DirectedConnection(
                            source_cell=source_cell,
                            sink_cell=sink_cell,
                        )
                    )
                    if source_cell is None or sink_cell is None or source_cell == sink_cell:
                        continue
                    directed_adjacency[source_cell].add(sink_cell)
                    adjacency[source_cell][sink_cell] = adjacency[source_cell].get(sink_cell, 0.0) + 1.0
                    adjacency[sink_cell][source_cell] = adjacency[sink_cell].get(source_cell, 0.0) + 1.0

        return GraphModel(
            cells=cells,
            partition_nodes=tuple(sorted(cells)),
            adjacency=adjacency,
            directed_adjacency={
                node: tuple(sorted(neighbors)) for node, neighbors in directed_adjacency.items()
            },
            directed_connections=tuple(directed_connections),
            module_input_bits=frozenset(module_input_bits),
            module_output_bits=frozenset(module_output_bits),
            net_driver_counts=tuple(len(bit_drivers.get(bit, ())) for bit in sorted(signal_bits)),
            net_sink_counts=tuple(len(bit_users.get(bit, ())) for bit in sorted(signal_bits)),
            sequential_output_bits=frozenset(sequential_output_bits),
            sequential_input_bits=frozenset(sequential_input_bits),
            signal_bits=frozenset(signal_bits),
            combinational_output_to_inputs=combinational_output_to_inputs,
            bit_output_cell=bit_output_cell,
            cell_output_bits=cell_output_bits,
            ltp_length=ltp_length_raw if isinstance(ltp_length_raw, int) else None,
        )

    def _empty_graph_model(self) -> GraphModel:
        return GraphModel(
            cells={},
            partition_nodes=(),
            adjacency={},
            directed_adjacency={},
            directed_connections=(),
            module_input_bits=frozenset(),
            module_output_bits=frozenset(),
            net_driver_counts=(),
            net_sink_counts=(),
            sequential_output_bits=frozenset(),
            sequential_input_bits=frozenset(),
            signal_bits=frozenset(),
            combinational_output_to_inputs={},
            bit_output_cell={},
            cell_output_bits={},
        )

    def _resolve_top_module_key(
        self,
        modules: dict[str, object],
        top_module_name: str | None,
    ) -> str:
        if top_module_name:
            for key in modules:
                if str(key).lstrip("\\") == top_module_name:
                    return str(key)
        return str(next(iter(modules)))

    def _is_sequential_cell(self, cell_type: str) -> bool:
        normalized = cell_type.upper()
        return any(marker in normalized for marker in _SEQUENTIAL_CELL_MARKERS)

    def _is_sequential_control_port(self, port_name: str) -> bool:
        return port_name.upper() in _SEQUENTIAL_CONTROL_PORTS

    def _extract_journal_bd_metrics(self, graph: GraphModel) -> dict[str, float]:
        combinational_cells = sum(1 for cell in graph.cells.values() if not cell.is_sequential)
        logic_depth = float(self._extract_logic_depth(graph))
        metrics = {
            "logic_depth": logic_depth,
            "ff_depth": float(self._extract_ff_depth(graph)),
            "comb_width_log": math.log1p(float(combinational_cells)),
            "combinational_cells": float(combinational_cells),
        }
        metrics.update(self._extract_t11_runtime_metrics(graph))
        metrics.update(self._extract_sog_metrics(graph))
        if graph.ltp_length is not None:
            # Online cross-check: yosys ltp counts buffers, ours skips them.
            metrics["logic_depth_ltp"] = float(graph.ltp_length)
            metrics["logic_depth_ltp_delta"] = float(graph.ltp_length) - logic_depth
        return metrics

    def _extract_sog_metrics(self, graph: GraphModel) -> dict[str, float]:
        cell_types = [cell.cell_type.lower() for cell in graph.cells.values()]
        module_instances = sum(1 for cell_type in cell_types if not cell_type.startswith("$"))
        operator_count = len(cell_types) - module_instances
        arith_count = self._count_sog_types(cell_types, _SOG_ARITH_TYPES)
        mux_count = self._count_sog_types(cell_types, _SOG_MUX_TYPES)
        compare_count = self._count_sog_types(cell_types, _SOG_COMPARE_TYPES)
        logic_count = self._count_sog_types(cell_types, _SOG_LOGIC_TYPES)
        shift_count = self._count_sog_types(cell_types, _SOG_SHIFT_TYPES)
        state_count = sum(1 for cell in graph.cells.values() if cell.is_sequential)
        memory_count = sum(1 for cell_type in cell_types if cell_type.startswith("$mem"))
        mul_count = self._count_sog_types(cell_types, {"$mul"})
        complexity = (
            operator_count
            + (2 * arith_count)
            + (3 * mul_count)
            + mux_count
            + compare_count
            + state_count
        )
        return {
            "operator_mix_score": (
                float(arith_count + shift_count + compare_count + (0.5 * logic_count))
                / float(operator_count + 1)
            ),
            "state_control_ratio": (
                float(state_count + memory_count + 1)
                / float(mux_count + compare_count + 1)
            ),
            "sog_complexity_score": float(complexity),
            "sog_entropy": self._entropy(
                tuple(
                    float(value)
                    for value in (
                        arith_count,
                        mux_count,
                        compare_count,
                        logic_count,
                        shift_count,
                        state_count,
                        module_instances,
                    )
                )
            ),
        }

    def _count_sog_types(self, cell_types: list[str], names: set[str]) -> int:
        return sum(1 for cell_type in cell_types if cell_type in names)

    def _extract_t11_runtime_metrics(self, graph: GraphModel) -> dict[str, float]:
        """Extract the live-safe graph features closest to T11's top replay axes."""

        node_count = len(graph.partition_nodes)
        edge_count = sum(len(sinks) for sinks in graph.directed_adjacency.values())
        net_count = len(graph.signal_bits)
        levels = self._cell_levels(graph)
        level_deltas = [
            max(levels[sink] - levels[source], 0)
            for source, sinks in graph.directed_adjacency.items()
            for sink in sinks
        ]
        families = [self._t11_cell_family(cell.cell_type) for cell in graph.cells.values()]
        family_total = max(len(families), 1)
        fanouts = tuple(float(value) for value in graph.net_sink_counts)

        return {
            "hyper_mean_fanout": self._mean(fanouts),
            "edge_per_node": float(edge_count) / max(float(node_count), 1.0),
            "log_edge_count": float(edge_count),
            "hyper_directed_edge_count": float(edge_count),
            "hyper_fanout_entropy": self._entropy(fanouts),
            "hyper_driven_net_count": float(sum(1 for value in graph.net_driver_counts if value > 0)),
            "hyper_sink_net_count": float(sum(1 for value in graph.net_sink_counts if value > 0)),
            "log_net_count": float(net_count),
            "hyper_net_count": float(net_count),
            "hyper_cell_count": float(node_count),
            "log_node_count": float(node_count),
            "hyper_max_fanout": max(fanouts, default=0.0),
            "hyper_max_level": max((float(value) for value in levels.values()), default=0.0),
            "log_max_level": max((float(value) for value in levels.values()), default=0.0),
            "hyper_max_level_delta": max((float(value) for value in level_deltas), default=0.0),
            "share_family_inv": float(sum(1 for family in families if family == "inv")) / family_total,
        }

    def _cell_levels(self, graph: GraphModel) -> dict[str, int]:
        indegree = {node: 0 for node in graph.partition_nodes}
        for sinks in graph.directed_adjacency.values():
            for sink in sinks:
                indegree[sink] += 1
        ready = sorted(node for node, count in indegree.items() if count == 0)
        levels = {node: 0 for node in graph.partition_nodes}
        while ready:
            source = ready.pop(0)
            for sink in graph.directed_adjacency[source]:
                levels[sink] = max(levels[sink], levels[source] + 1)
                indegree[sink] -= 1
                if indegree[sink] == 0:
                    ready.append(sink)
            ready.sort()
        return levels

    def _t11_cell_family(self, cell_type: str) -> str:
        normalized = cell_type.upper()
        if "DFF" in normalized or "LATCH" in normalized:
            return "dff"
        if "INV" in normalized or "$NOT" in normalized:
            return "inv"
        if "BUF" in normalized:
            return "buf"
        if "NAND" in normalized:
            return "nand"
        if "NOR" in normalized:
            return "nor"
        if "XNOR" in normalized:
            return "xnor"
        if "XOR" in normalized:
            return "xor"
        if "AND" in normalized:
            return "and"
        if "OR" in normalized:
            return "or"
        if "MUX" in normalized:
            return "mux"
        if "ADD" in normalized:
            return "add"
        return "other"

    def _mean(self, values: tuple[float, ...]) -> float:
        if not values:
            return 0.0
        return float(sum(values) / len(values))

    def _entropy(self, values: tuple[float, ...]) -> float:
        total = sum(values)
        if total <= 0.0:
            return 0.0
        entropy = 0.0
        for value in values:
            if value <= 0.0:
                continue
            probability = value / total
            entropy -= probability * math.log2(probability)
        return float(entropy)

    def _extract_logic_depth(self, graph: GraphModel) -> int:
        """Count non-buffer combinational cells between PI/FF-Q and PO/FF-D boundaries.

        Longest path is computed iteratively (no Python recursion limit on
        deep combinational chains). Combinational cycles are cut at the bit
        where the walk re-enters its own path (contributing depth 0 there);
        results computed under such a cut are NOT memoized, so a bit that is
        also reachable through cycle-free paths keeps its true depth.
        """

        memo: dict[int, int] = {}

        def bit_depth_iterative(root: int) -> int:
            # Each frame: (bit, input_iter, best_input_depth, tainted).
            on_path: set[int] = set()
            results: dict[int, tuple[int, bool]] = {}

            def boundary_depth(bit: int) -> tuple[int, bool] | None:
                if bit in graph.module_input_bits or bit in graph.sequential_output_bits:
                    return 0, False
                cached = memo.get(bit)
                if cached is not None:
                    return cached, False
                driver_name = graph.bit_output_cell.get(bit)
                if driver_name is None:
                    return 0, False
                cell = graph.cells[driver_name]
                if cell.is_sequential:
                    return 0, False
                if not self._cell_input_bits(cell):
                    return 0, False
                return None

            immediate = boundary_depth(root)
            if immediate is not None:
                return immediate[0]
            stack: list[list] = [[root, None, 0, False]]
            on_path.add(root)
            while stack:
                frame = stack[-1]
                bit = frame[0]
                if frame[1] is None:
                    cell = graph.cells[graph.bit_output_cell[bit]]
                    frame.append(cell)
                    frame[1] = iter(self._cell_input_bits(cell))
                advanced = False
                for input_bit in frame[1]:
                    known = results.get(input_bit)
                    if known is not None:
                        frame[2] = max(frame[2], known[0])
                        frame[3] = frame[3] or known[1]
                        continue
                    if input_bit in on_path:
                        frame[3] = True  # cycle cut: contributes 0, taints
                        continue
                    immediate = boundary_depth(input_bit)
                    if immediate is not None:
                        frame[2] = max(frame[2], immediate[0])
                        frame[3] = frame[3] or immediate[1]
                        continue
                    stack.append([input_bit, None, 0, False])
                    on_path.add(input_bit)
                    advanced = True
                    break
                if advanced:
                    continue
                cell = frame[4]
                depth = frame[2] if self._is_buffer_cell(cell.cell_type) else frame[2] + 1
                tainted = frame[3]
                results[bit] = (depth, tainted)
                if not tainted:
                    memo[bit] = depth
                on_path.discard(bit)
                stack.pop()
                if stack:  # fold the finished child into its parent frame
                    parent = stack[-1]
                    parent[2] = max(parent[2], depth)
                    parent[3] = parent[3] or tainted
            return results[root][0]

        endpoints = graph.module_output_bits | graph.sequential_input_bits
        return max((bit_depth_iterative(bit) for bit in endpoints), default=0)

    def _extract_ff_depth(self, graph: GraphModel) -> int:
        """Count FF boundaries on PI-to-PO dependency paths without unrolling feedback cycles."""

        pi_node = "__PI__"
        po_node = "__PO__"
        edges: dict[str, set[str]] = {pi_node: set(), po_node: set()}
        source_memo: dict[int, frozenset[str]] = {}

        def bit_sources(root: int, _visiting: set[int]) -> set[str]:
            # Iterative with taint-aware memoization: combinational-cycle
            # cuts contribute no sources and poison neither the memo nor
            # cycle-free paths through the same bit.
            def immediate(bit: int) -> tuple[set[str], bool] | None:
                if bit in graph.module_input_bits:
                    return {pi_node}, False
                cached = source_memo.get(bit)
                if cached is not None:
                    return set(cached), False
                driver_name = graph.bit_output_cell.get(bit)
                if driver_name is None:
                    return set(), False
                if graph.cells[driver_name].is_sequential:
                    return {driver_name}, False
                return None

            known = immediate(root)
            if known is not None:
                return known[0]
            on_path = {root}
            results: dict[int, tuple[set[str], bool]] = {}
            stack: list[list] = [[root, None, set(), False]]
            while stack:
                frame = stack[-1]
                bit = frame[0]
                if frame[1] is None:
                    cell = graph.cells[graph.bit_output_cell[bit]]
                    frame[1] = iter(self._cell_input_bits(cell))
                advanced = False
                for input_bit in frame[1]:
                    done = results.get(input_bit)
                    if done is not None:
                        frame[2] |= done[0]
                        frame[3] = frame[3] or done[1]
                        continue
                    if input_bit in on_path:
                        frame[3] = True
                        continue
                    base = immediate(input_bit)
                    if base is not None:
                        frame[2] |= base[0]
                        frame[3] = frame[3] or base[1]
                        continue
                    stack.append([input_bit, None, set(), False])
                    on_path.add(input_bit)
                    advanced = True
                    break
                if advanced:
                    continue
                results[bit] = (frame[2], frame[3])
                if not frame[3]:
                    source_memo[bit] = frozenset(frame[2])
                on_path.discard(bit)
                stack.pop()
                if stack:
                    parent = stack[-1]
                    parent[2] |= frame[2]
                    parent[3] = parent[3] or frame[3]
            return results[root][0]

        for cell in graph.cells.values():
            if not cell.is_sequential:
                continue
            edges.setdefault(cell.name, set())
            for bit in self._sequential_data_input_bits(cell):
                for source in bit_sources(bit, set()):
                    edges.setdefault(source, set()).add(cell.name)

        for bit in graph.module_output_bits:
            for source in bit_sources(bit, set()):
                edges.setdefault(source, set()).add(po_node)

        return self._longest_ff_depth(edges, pi_node=pi_node, po_node=po_node)

    def _longest_ff_depth(
        self,
        edges: dict[str, set[str]],
        *,
        pi_node: str,
        po_node: str,
    ) -> int:
        nodes = set(edges)
        for sinks in edges.values():
            nodes.update(sinks)
        if pi_node not in nodes or po_node not in nodes:
            return 0

        components = self._strongly_connected_components(nodes, edges)
        component_by_node = {
            node: idx for idx, component in enumerate(components) for node in component
        }
        weights = [
            sum(1 for node in component if node not in {pi_node, po_node})
            for component in components
        ]
        dag_edges: dict[int, set[int]] = {idx: set() for idx in range(len(components))}
        indegree = {idx: 0 for idx in range(len(components))}
        for source, sinks in edges.items():
            source_idx = component_by_node[source]
            for sink in sinks:
                sink_idx = component_by_node[sink]
                if source_idx == sink_idx or sink_idx in dag_edges[source_idx]:
                    continue
                dag_edges[source_idx].add(sink_idx)
                indegree[sink_idx] += 1

        ready = sorted(idx for idx, count in indegree.items() if count == 0)
        order: list[int] = []
        while ready:
            node = ready.pop(0)
            order.append(node)
            for sink in sorted(dag_edges[node]):
                indegree[sink] -= 1
                if indegree[sink] == 0:
                    ready.append(sink)
            ready.sort()

        pi_idx = component_by_node[pi_node]
        po_idx = component_by_node[po_node]
        distances = {pi_idx: 0}
        for source in order:
            if source not in distances:
                continue
            for sink in dag_edges[source]:
                candidate = distances[source] + weights[sink]
                distances[sink] = max(distances.get(sink, 0), candidate)
        return max(distances.get(po_idx, 0), 0)

    def _strongly_connected_components(
        self,
        nodes: set[str],
        edges: dict[str, set[str]],
    ) -> list[list[str]]:
        index = 0
        stack: list[str] = []
        on_stack: set[str] = set()
        indices: dict[str, int] = {}
        lowlinks: dict[str, int] = {}
        components: list[list[str]] = []

        def visit(node: str) -> None:
            nonlocal index
            indices[node] = index
            lowlinks[node] = index
            index += 1
            stack.append(node)
            on_stack.add(node)

            for sink in sorted(edges.get(node, set())):
                if sink not in indices:
                    visit(sink)
                    lowlinks[node] = min(lowlinks[node], lowlinks[sink])
                elif sink in on_stack:
                    lowlinks[node] = min(lowlinks[node], indices[sink])

            if lowlinks[node] != indices[node]:
                return
            component: list[str] = []
            while True:
                popped = stack.pop()
                on_stack.remove(popped)
                component.append(popped)
                if popped == node:
                    break
            components.append(component)

        for node in sorted(nodes):
            if node not in indices:
                visit(node)
        return components

    def _cell_input_bits(self, cell: CellModel) -> tuple[int, ...]:
        return tuple(
            bit
            for bits in cell.inputs.values()
            for bit in bits
            if isinstance(bit, int)
        )

    def _sequential_data_input_bits(self, cell: CellModel) -> tuple[int, ...]:
        assert cell.is_sequential
        return tuple(
            bit
            for port_name, bits in cell.inputs.items()
            if not self._is_sequential_control_port(port_name)
            for bit in bits
            if isinstance(bit, int)
        )

    def _is_buffer_cell(self, cell_type: str) -> bool:
        normalized = cell_type.upper()
        return self._matches_any(normalized, ("$BUF", "$_BUF", "$POS"))

    def _extract_rent_metrics(self, graph: GraphModel) -> dict[str, float]:
        points = self._collect_rent_points(graph)
        if len(points) < 2:
            return self._empty_rent_metrics(
                graph_node_count=len(graph.partition_nodes),
                raw_sample_count=len(points),
            )

        grouped: dict[int, list[float]] = defaultdict(list)
        for size, terminals in points:
            grouped[size].append(terminals)
        samples = sorted(
            (float(size), float(sum(terminals) / len(terminals)))
            for size, terminals in grouped.items()
            if size >= 2 and sum(terminals) > 0.0
        )
        if len(samples) < 2:
            return self._empty_rent_metrics(
                graph_node_count=len(graph.partition_nodes),
                raw_sample_count=len(samples),
            )

        best_samples = list(samples)
        best_fit = self._fit_rent_line(best_samples)
        if best_fit is None:
            return self._empty_rent_metrics(
                graph_node_count=len(graph.partition_nodes),
                raw_sample_count=len(samples),
            )

        min_points = max(2, math.ceil(0.75 * len(samples)))
        while len(best_samples) > min_points:
            candidate_samples = best_samples[:-1]
            candidate_fit = self._fit_rent_line(candidate_samples)
            if candidate_fit is None or candidate_fit["sigma"] > best_fit["sigma"]:
                break
            best_samples = candidate_samples
            best_fit = candidate_fit

        return self._build_rent_metrics(
            graph_node_count=len(graph.partition_nodes),
            raw_sample_count=len(samples),
            retained_sample_count=len(best_samples),
            fit=best_fit,
        )

    def _empty_rent_metrics(
        self,
        *,
        graph_node_count: int,
        raw_sample_count: int,
    ) -> dict[str, float]:
        return {
            "rent_exponent": 0.0,
            "rent_exponent_confidence_gated": 0.5,
            "rent_confidence": 0.0,
            "rent_clamped_flag": 0.0,
            "rent_k": 0.0,
            "rent_r2": 0.0,
            "rent_sample_count": 0.0,
            "rent_raw_sample_count": float(raw_sample_count),
            "rent_retained_sample_ratio": 0.0,
            "rent_graph_node_count": float(graph_node_count),
        }

    def _build_rent_metrics(
        self,
        *,
        graph_node_count: int,
        raw_sample_count: int,
        retained_sample_count: int,
        fit: dict[str, float],
    ) -> dict[str, float]:
        raw_slope = float(fit["slope"])
        rent_exponent = self._clamp_rent_exponent(raw_slope)
        rent_r2 = max(0.0, min(1.0, float(fit["r2"])))

        retained_ratio = 0.0
        if raw_sample_count > 0:
            retained_ratio = retained_sample_count / raw_sample_count

        was_clamped = not math.isclose(raw_slope, rent_exponent)
        rent_confidence = self._rent_confidence(
            graph_node_count=graph_node_count,
            raw_sample_count=raw_sample_count,
            retained_sample_count=retained_sample_count,
            retained_ratio=retained_ratio,
            rent_r2=rent_r2,
            was_clamped=was_clamped,
        )

        return {
            "rent_exponent": rent_exponent,
            "rent_exponent_confidence_gated": self._confidence_gate_rent_exponent(
                rent_exponent,
                rent_confidence,
            ),
            "rent_confidence": rent_confidence,
            "rent_clamped_flag": 1.0 if was_clamped else 0.0,
            "rent_k": float(fit["k"]),
            "rent_r2": rent_r2,
            "rent_sample_count": float(retained_sample_count),
            "rent_raw_sample_count": float(raw_sample_count),
            "rent_retained_sample_ratio": float(max(0.0, min(1.0, retained_ratio))),
            "rent_graph_node_count": float(graph_node_count),
        }

    def _clamp_rent_exponent(self, slope: float) -> float:
        return float(max(0.0, min(1.0, slope)))

    def _rent_confidence(
        self,
        *,
        graph_node_count: int,
        raw_sample_count: int,
        retained_sample_count: int,
        retained_ratio: float,
        rent_r2: float,
        was_clamped: bool,
    ) -> float:
        if retained_sample_count <= 0 or raw_sample_count <= 0 or graph_node_count <= 0:
            return 0.0

        sample_confidence = min(1.0, retained_sample_count / 6.0)
        node_confidence = min(1.0, graph_node_count / 32.0)
        ratio_confidence = max(0.0, min(1.0, retained_ratio))
        fit_confidence = max(0.0, min(1.0, rent_r2))

        confidence = (
            0.35 * sample_confidence
            + 0.25 * node_confidence
            + 0.25 * fit_confidence
            + 0.15 * ratio_confidence
        )
        if was_clamped:
            confidence *= 0.25
        return float(max(0.0, min(1.0, confidence)))

    def _confidence_gate_rent_exponent(
        self,
        rent_exponent: float,
        rent_confidence: float,
    ) -> float:
        neutral_exponent = 0.5
        gated_exponent = neutral_exponent + rent_confidence * (rent_exponent - neutral_exponent)
        return float(max(0.0, min(1.0, gated_exponent)))

    def _collect_rent_points(self, graph: GraphModel) -> list[tuple[int, float]]:
        if len(graph.partition_nodes) < 2:
            return []

        adjacency_matrix, ordered_nodes = self._adjacency_matrix(graph)
        points: list[tuple[int, float]] = []

        def visit(indices: np.ndarray) -> None:
            if indices.size < 2:
                return
            subset = {ordered_nodes[int(idx)] for idx in indices}
            boundary = self._boundary_pin_count(graph, subset)
            points.append((len(subset), boundary))
            left, right = self._spectral_bisect(adjacency_matrix, indices)
            if left.size >= 2:
                visit(left)
            if right.size >= 2:
                visit(right)

        visit(np.arange(len(ordered_nodes), dtype=int))
        return points

    def _fit_rent_line(self, samples: list[tuple[float, float]]) -> dict[str, float] | None:
        if len(samples) < 2:
            return None
        x = np.log(np.asarray([size for size, _ in samples], dtype=float))
        y = np.log(np.asarray([terminals for _, terminals in samples], dtype=float))
        slope, intercept = np.polyfit(x, y, 1)
        residuals = y - (slope * x + intercept)
        sigma = float(np.sqrt(np.mean(np.square(residuals))))
        ss_tot = float(np.sum(np.square(y - y.mean())))
        ss_res = float(np.sum(np.square(residuals)))
        r2 = 1.0 if ss_tot <= 0.0 else max(0.0, 1.0 - (ss_res / ss_tot))
        return {
            "slope": float(slope),
            "k": float(math.exp(intercept)),
            "sigma": sigma,
            "r2": r2,
        }

    def _boundary_pin_count(self, graph: GraphModel, subset: set[str]) -> float:
        count = 0.0
        for connection in graph.directed_connections:
            source_inside = connection.source_cell in subset if connection.source_cell is not None else False
            sink_inside = connection.sink_cell in subset if connection.sink_cell is not None else False
            if source_inside != sink_inside:
                count += 1.0
        return count

    def _spectral_bisect(
        self,
        adjacency_matrix: np.ndarray,
        indices: np.ndarray,
    ) -> tuple[np.ndarray, np.ndarray]:
        if indices.size < 2:
            return np.array([], dtype=int), np.array([], dtype=int)
        submatrix = adjacency_matrix[np.ix_(indices, indices)]
        if not np.any(submatrix):
            midpoint = indices.size // 2
            return indices[:midpoint], indices[midpoint:]

        fiedler = self._fiedler_vector(submatrix)
        if fiedler is None or np.allclose(fiedler, fiedler[0]):
            midpoint = indices.size // 2
            return indices[:midpoint], indices[midpoint:]

        ordering = np.argsort(fiedler)
        best_cut = ordering[: indices.size // 2]
        best_score = float("inf")
        for cut_size in range(1, indices.size):
            mask = np.zeros(indices.size, dtype=bool)
            mask[ordering[:cut_size]] = True
            left_size = int(mask.sum())
            right_size = int(indices.size - left_size)
            if left_size == 0 or right_size == 0:
                continue
            cut_weight = float(submatrix[np.ix_(mask, ~mask)].sum())
            score = cut_weight * ((1.0 / left_size) + (1.0 / right_size))
            if score < best_score:
                best_score = score
                best_cut = ordering[:cut_size]

        left_mask = np.zeros(indices.size, dtype=bool)
        left_mask[best_cut] = True
        return indices[left_mask], indices[~left_mask]

    def _fiedler_vector(self, adjacency_matrix: np.ndarray) -> np.ndarray | None:
        laplacian = self._normalized_laplacian(adjacency_matrix)
        node_count = laplacian.shape[0]
        if node_count < 2:
            return None
        if csr_matrix is not None and eigsh is not None and node_count > 32:
            try:
                sparse_laplacian = csr_matrix(laplacian)
                values, vectors = eigsh(sparse_laplacian, k=2, which="SM")
                order = np.argsort(values)
                return np.asarray(vectors[:, order[1]], dtype=float)
            except Exception:
                pass
        values, vectors = np.linalg.eigh(laplacian)
        if values.size < 2:
            return None
        return np.asarray(vectors[:, 1], dtype=float)

    def _normalized_laplacian(self, adjacency_matrix: np.ndarray) -> np.ndarray:
        degree = adjacency_matrix.sum(axis=1)
        with np.errstate(divide="ignore"):
            inv_sqrt = 1.0 / np.sqrt(degree)
        inv_sqrt[~np.isfinite(inv_sqrt)] = 0.0
        laplacian = np.eye(adjacency_matrix.shape[0], dtype=float) - (
            inv_sqrt[:, None] * adjacency_matrix * inv_sqrt[None, :]
        )
        isolated = degree <= 0.0
        laplacian[isolated, isolated] = 0.0
        return laplacian

    def _adjacency_matrix(self, graph: GraphModel) -> tuple[np.ndarray, list[str]]:
        nodes = list(graph.partition_nodes)
        matrix = np.zeros((len(nodes), len(nodes)), dtype=float)
        index = {name: idx for idx, name in enumerate(nodes)}
        for source, neighbors in graph.adjacency.items():
            for sink, weight in neighbors.items():
                matrix[index[source], index[sink]] = float(weight)
        return matrix, nodes

    def _extract_reconvergence_metrics(self, graph: GraphModel) -> dict[str, float]:
        branching_sources = 0
        reconvergent_sources = 0
        reconvergent_sinks: set[str] = set()
        adjacency = {
            node: set(neighbors) for node, neighbors in graph.directed_adjacency.items()
        }
        for source in graph.partition_nodes:
            children = sorted(adjacency.get(source, set()))
            if len(children) <= 1:
                continue
            branching_sources += 1
            seen: set[str] = set()
            source_reconverges = False
            for child in children:
                descendants = self._reachable_nodes(adjacency, child, stop_at={source})
                overlap = seen & descendants
                if overlap:
                    source_reconverges = True
                    reconvergent_sinks.update(overlap)
                seen.update(descendants)
            if source_reconverges:
                reconvergent_sources += 1
        total_nodes = max(len(graph.partition_nodes), 1)
        return {
            "reconv_source_ratio": (
                float(reconvergent_sources) / float(branching_sources)
                if branching_sources
                else 0.0
            ),
            "reconv_sink_ratio": float(len(reconvergent_sinks)) / float(total_nodes),
        }

    def _reachable_nodes(
        self,
        adjacency: dict[str, set[str]],
        start: str,
        *,
        stop_at: set[str],
    ) -> set[str]:
        visited: set[str] = set()
        stack = [start]
        while stack:
            node = stack.pop()
            if node in visited or node in stop_at:
                continue
            visited.add(node)
            for neighbor in adjacency.get(node, set()):
                if neighbor not in visited:
                    stack.append(neighbor)
        return visited

    def _compute_scoap_scores(
        self,
        graph: GraphModel,
    ) -> tuple[dict[int, float], dict[int, float], dict[int, float]]:
        cc0: dict[int, float] = {}
        cc1: dict[int, float] = {}
        co: dict[int, float] = {}

        for bit in graph.module_input_bits | graph.sequential_output_bits:
            cc0[bit] = 1.0
            cc1[bit] = 1.0

        for cell in graph.cells.values():
            if not cell.is_sequential:
                continue
            for bits in cell.outputs.values():
                for bit in bits:
                    if isinstance(bit, int):
                        cc0[bit] = 1.0
                        cc1[bit] = 1.0

        topo_cells = self._topological_cells(graph)
        unresolved = {
            name for name, cell in graph.cells.items() if not cell.is_sequential
        }
        for name in topo_cells:
            unresolved.discard(name)
            self._propagate_controllability(graph.cells[name], cc0=cc0, cc1=cc1)
        for name in sorted(unresolved):
            self._propagate_controllability(graph.cells[name], cc0=cc0, cc1=cc1)

        for bit in graph.module_output_bits | graph.sequential_input_bits:
            co[bit] = 0.0

        reverse_cells = list(reversed(topo_cells))
        remaining = {
            name for name, cell in graph.cells.items() if not cell.is_sequential
        }
        for name in reverse_cells:
            remaining.discard(name)
            self._propagate_observability(graph.cells[name], cc0=cc0, cc1=cc1, co=co)
        for name in sorted(remaining):
            self._propagate_observability(graph.cells[name], cc0=cc0, cc1=cc1, co=co)

        for bit in graph.signal_bits:
            cc0.setdefault(bit, _INF_SCORE)
            cc1.setdefault(bit, _INF_SCORE)
            co.setdefault(bit, _INF_SCORE)
        return cc0, cc1, co

    def _topological_cells(self, graph: GraphModel) -> list[str]:
        predecessors: dict[str, set[str]] = {name: set() for name in graph.cells}
        successors: dict[str, set[str]] = {name: set() for name in graph.cells}
        for source, neighbors in graph.directed_adjacency.items():
            for sink in neighbors:
                if graph.cells.get(source) is None or graph.cells.get(sink) is None:
                    continue
                if graph.cells[source].is_sequential or graph.cells[sink].is_sequential:
                    continue
                predecessors[sink].add(source)
                successors[source].add(sink)
        ready = sorted(name for name, preds in predecessors.items() if not preds and not graph.cells[name].is_sequential)
        order: list[str] = []
        while ready:
            node = ready.pop(0)
            order.append(node)
            for sink in sorted(successors[node]):
                predecessors[sink].discard(node)
                if not predecessors[sink] and sink not in order and sink not in ready:
                    ready.append(sink)
            ready.sort()
        return order

    def _propagate_controllability(
        self,
        cell: CellModel,
        *,
        cc0: dict[int, float],
        cc1: dict[int, float],
    ) -> None:
        input_scores = {
            port: tuple(self._score_pair(bit, cc0=cc0, cc1=cc1) for bit in bits)
            for port, bits in cell.inputs.items()
        }
        for bits in cell.outputs.values():
            for bit in bits:
                if not isinstance(bit, int):
                    continue
                out_cc0, out_cc1 = self._compute_output_controllability(
                    cell.cell_type,
                    input_scores=input_scores,
                )
                cc0[bit] = out_cc0
                cc1[bit] = out_cc1

    def _propagate_observability(
        self,
        cell: CellModel,
        *,
        cc0: dict[int, float],
        cc1: dict[int, float],
        co: dict[int, float],
    ) -> None:
        output_cos = [
            co[bit]
            for bits in cell.outputs.values()
            for bit in bits
            if isinstance(bit, int) and bit in co
        ]
        if not output_cos:
            return
        base_output_co = min(output_cos)
        flat_inputs = {
            port: tuple(bit for bit in bits if isinstance(bit, int))
            for port, bits in cell.inputs.items()
        }
        for port, bits in flat_inputs.items():
            if not bits:
                continue
            candidate = self._compute_input_observability(
                cell.cell_type,
                port_name=port,
                input_bits=flat_inputs,
                cc0=cc0,
                cc1=cc1,
                output_co=base_output_co,
            )
            for bit, bit_candidate in zip(bits, candidate):
                current = co.get(bit, _INF_SCORE)
                co[bit] = min(current, bit_candidate)

    def _score_pair(
        self,
        bit: int | str,
        *,
        cc0: dict[int, float],
        cc1: dict[int, float],
    ) -> tuple[float, float]:
        if isinstance(bit, str):
            if bit in _CONST_ZERO:
                return 0.0, _INF_SCORE
            if bit in _CONST_ONE:
                return _INF_SCORE, 0.0
            return _INF_SCORE, _INF_SCORE
        return cc0.get(bit, _INF_SCORE), cc1.get(bit, _INF_SCORE)

    def _compute_output_controllability(
        self,
        cell_type: str,
        *,
        input_scores: dict[str, tuple[tuple[float, float], ...]],
    ) -> tuple[float, float]:
        normalized = cell_type.upper()
        all_scores = [score for scores in input_scores.values() for score in scores]
        if not all_scores:
            return 1.0, 1.0
        if self._matches_any(normalized, ("$NOT", "$LOGIC_NOT", "$_NOT", "INV")):
            in_cc0, in_cc1 = all_scores[0]
            return in_cc1 + 1.0, in_cc0 + 1.0
        if self._matches_any(normalized, ("$AND", "$LOGIC_AND", "$REDUCE_AND", "$_AND")):
            return (
                1.0 + min(score[0] for score in all_scores),
                1.0 + sum(score[1] for score in all_scores),
            )
        if self._matches_any(normalized, ("$NAND", "$_NAND")):
            cc0_out, cc1_out = self._compute_output_controllability(
                "$AND",
                input_scores=input_scores,
            )
            return cc1_out, cc0_out
        if self._matches_any(normalized, ("$OR", "$LOGIC_OR", "$REDUCE_OR", "$_OR", "$BIT_OR")):
            return (
                1.0 + sum(score[0] for score in all_scores),
                1.0 + min(score[1] for score in all_scores),
            )
        if self._matches_any(normalized, ("$NOR", "$_NOR")):
            cc0_out, cc1_out = self._compute_output_controllability(
                "$OR",
                input_scores=input_scores,
            )
            return cc1_out, cc0_out
        if self._matches_any(normalized, ("$XOR", "$LOGIC_XOR", "$REDUCE_XOR", "$_XOR")):
            return self._xor_controllability(all_scores, invert=False)
        if self._matches_any(normalized, ("$XNOR", "$_XNOR")):
            return self._xor_controllability(all_scores, invert=True)
        if "MUX" in normalized:
            data_a = list(input_scores.get("A", ())) or all_scores[:1]
            data_b = list(input_scores.get("B", ())) or all_scores[1:2] or data_a
            select = list(input_scores.get("S", ())) or list(input_scores.get("SEL", ())) or all_scores[-1:]
            sel_cc0 = min(score[0] for score in select)
            sel_cc1 = min(score[1] for score in select)
            a_cc0 = min(score[0] for score in data_a)
            a_cc1 = min(score[1] for score in data_a)
            b_cc0 = min(score[0] for score in data_b)
            b_cc1 = min(score[1] for score in data_b)
            return (
                1.0 + min(sel_cc0 + a_cc0, sel_cc1 + b_cc0),
                1.0 + min(sel_cc0 + a_cc1, sel_cc1 + b_cc1),
            )
        if self._matches_any(normalized, ("$EQ", "$EQX", "$NE", "$NEX")):
            bit_pairs = self._paired_scores(input_scores)
            eq_cc1 = 1.0
            eq_cc0_options: list[float] = []
            for left, right in bit_pairs:
                eq_cc1 += min(left[0] + right[0], left[1] + right[1])
                eq_cc0_options.append(min(left[0] + right[1], left[1] + right[0]))
            eq_cc0 = 1.0 + (min(eq_cc0_options) if eq_cc0_options else min(score[0] for score in all_scores))
            if "$NE" in normalized:
                return eq_cc1, eq_cc0
            return eq_cc0, eq_cc1
        if self._matches_any(normalized, ("$LT", "$LE", "$GT", "$GE", "$ADD", "$SUB", "$MUL", "$DIV", "$MOD", "$SHL", "$SHR", "$SSHL", "$SSHR")):
            support = sum(min(score[0], score[1]) for score in all_scores)
            asym = min(sum(score[0] for score in all_scores), sum(score[1] for score in all_scores))
            return 1.0 + min(support, asym), 1.0 + min(support, asym)
        return (
            1.0 + min(score[0] for score in all_scores),
            1.0 + min(score[1] for score in all_scores),
        )

    def _compute_input_observability(
        self,
        cell_type: str,
        *,
        port_name: str,
        input_bits: dict[str, tuple[int, ...]],
        cc0: dict[int, float],
        cc1: dict[int, float],
        output_co: float,
    ) -> list[float]:
        normalized = cell_type.upper()
        target_bits = list(input_bits.get(port_name, ()))
        other_bits = [
            bit
            for other_port, bits in input_bits.items()
            if other_port != port_name
            for bit in bits
        ]
        if not target_bits:
            return []

        if self._matches_any(normalized, ("$NOT", "$LOGIC_NOT", "$_NOT", "INV", "$POS", "$BUF")):
            return [output_co + 1.0 for _ in target_bits]
        if self._matches_any(normalized, ("$AND", "$LOGIC_AND", "$REDUCE_AND", "$_AND", "$NAND", "$_NAND")):
            support = sum(cc1.get(bit, _INF_SCORE) for bit in other_bits)
            return [output_co + support + 1.0 for _ in target_bits]
        if self._matches_any(normalized, ("$OR", "$LOGIC_OR", "$REDUCE_OR", "$_OR", "$BIT_OR", "$NOR", "$_NOR")):
            support = sum(cc0.get(bit, _INF_SCORE) for bit in other_bits)
            return [output_co + support + 1.0 for _ in target_bits]
        if self._matches_any(normalized, ("$XOR", "$LOGIC_XOR", "$REDUCE_XOR", "$_XOR", "$XNOR", "$_XNOR")):
            support = min(
                sum(cc0.get(bit, _INF_SCORE) for bit in other_bits),
                sum(cc1.get(bit, _INF_SCORE) for bit in other_bits),
            )
            return [output_co + support + 1.0 for _ in target_bits]
        if "MUX" in normalized:
            select_ports = {"S", "SEL"}
            if port_name.upper() in select_ports:
                a_bits = list(input_bits.get("A", ()))
                b_bits = list(input_bits.get("B", ()))
                support = min(
                    sum(cc0.get(bit, _INF_SCORE) for bit in a_bits)
                    + sum(cc1.get(bit, _INF_SCORE) for bit in b_bits),
                    sum(cc1.get(bit, _INF_SCORE) for bit in a_bits)
                    + sum(cc0.get(bit, _INF_SCORE) for bit in b_bits),
                )
                return [output_co + support + 1.0 for _ in target_bits]
            select_bits = list(input_bits.get("S", ())) or list(input_bits.get("SEL", ()))
            select_cost = min(
                sum(cc0.get(bit, _INF_SCORE) for bit in select_bits),
                sum(cc1.get(bit, _INF_SCORE) for bit in select_bits),
            )
            return [output_co + select_cost + 1.0 for _ in target_bits]
        support = sum(min(cc0.get(bit, _INF_SCORE), cc1.get(bit, _INF_SCORE)) for bit in other_bits)
        return [output_co + support + 1.0 for _ in target_bits]

    def _xor_controllability(
        self,
        scores: list[tuple[float, float]],
        *,
        invert: bool,
    ) -> tuple[float, float]:
        zero_costs = [0.0]
        one_costs = [_INF_SCORE]
        for cc0_in, cc1_in in scores:
            next_zero: list[float] = []
            next_one: list[float] = []
            for prev_zero, prev_one in zip(zero_costs, one_costs):
                next_zero.extend((prev_zero + cc0_in, prev_one + cc1_in))
                next_one.extend((prev_zero + cc1_in, prev_one + cc0_in))
            zero_costs = [min(next_zero)]
            one_costs = [min(next_one)]
        out_cc0 = 1.0 + zero_costs[0]
        out_cc1 = 1.0 + one_costs[0]
        return (out_cc1, out_cc0) if invert else (out_cc0, out_cc1)

    def _paired_scores(
        self,
        input_scores: dict[str, tuple[tuple[float, float], ...]],
    ) -> list[tuple[tuple[float, float], tuple[float, float]]]:
        left = list(input_scores.get("A", ()))
        right = list(input_scores.get("B", ()))
        if not left or not right:
            flattened = [score for scores in input_scores.values() for score in scores]
            midpoint = max(1, len(flattened) // 2)
            left = flattened[:midpoint]
            right = flattened[midpoint:] or flattened[:midpoint]
        count = min(len(left), len(right))
        return list(zip(left[:count], right[:count]))

    def _matches_any(self, text: str, prefixes: Iterable[str]) -> bool:
        return any(prefix in text for prefix in prefixes)

    def _extract_scoap_histogram_metrics(
        self,
        graph: GraphModel,
        *,
        cc0: dict[int, float],
        cc1: dict[int, float],
        co: dict[int, float],
    ) -> dict[str, float]:
        bits = sorted(graph.signal_bits)
        if not bits:
            return {
                **{f"scoap_cc0_bin_{idx}_pct": 0.0 for idx in range(4)},
                **{f"scoap_cc1_bin_{idx}_pct": 0.0 for idx in range(4)},
                **{f"scoap_co_bin_{idx}_pct": 0.0 for idx in range(4)},
            }
        metrics: dict[str, float] = {}
        for prefix, values in (("scoap_cc0", cc0), ("scoap_cc1", cc1), ("scoap_co", co)):
            counts = [0, 0, 0, 0]
            for bit in bits:
                counts[self._scoap_bin(values.get(bit, _INF_SCORE))] += 1
            total = float(len(bits))
            for idx, count in enumerate(counts):
                metrics[f"{prefix}_bin_{idx}_pct"] = float(count) / total
        return metrics

    def _scoap_bin(self, value: float) -> int:
        finite_value = value if math.isfinite(value) else _INF_SCORE
        if finite_value <= 1.0:
            return 0
        if finite_value <= 3.0:
            return 1
        if finite_value <= 7.0:
            return 2
        return 3

    def _extract_spectral_metrics(
        self,
        graph: GraphModel,
        *,
        cc0: dict[int, float],
        cc1: dict[int, float],
        co: dict[int, float],
    ) -> dict[str, float]:
        adjacency_matrix, ordered_nodes = self._adjacency_matrix(graph)
        node_count = len(ordered_nodes)
        if node_count == 0:
            return {
                "laplacian_lambda2": 0.0,
                "laplacian_spectral_entropy": 0.0,
                "scoap_signal_smoothness": 0.0,
            }
        laplacian = self._normalized_laplacian(adjacency_matrix)
        eigenvalues = np.linalg.eigvalsh(laplacian)
        eigenvalues = np.clip(eigenvalues, 0.0, None)
        lambda2 = float(eigenvalues[1]) if eigenvalues.size > 1 else 0.0
        positive = eigenvalues[eigenvalues > 1e-12]
        if positive.size <= 1:
            entropy = 0.0
        else:
            spectral_prob = positive / positive.sum()
            entropy = float(
                -np.sum(spectral_prob * np.log(spectral_prob)) / math.log(len(spectral_prob))
            )

        signal = np.asarray(
            [self._node_scoap_signal(graph, node, cc0=cc0, cc1=cc1, co=co) for node in ordered_nodes],
            dtype=float,
        )
        denom = float(signal @ signal)
        smoothness = 0.0 if denom <= 0.0 else float((signal @ laplacian @ signal) / denom)
        return {
            "laplacian_lambda2": max(0.0, min(2.0, lambda2)),
            "laplacian_spectral_entropy": max(0.0, min(1.0, entropy)),
            "scoap_signal_smoothness": max(0.0, min(2.0, smoothness)),
        }

    def _node_scoap_signal(
        self,
        graph: GraphModel,
        node: str,
        *,
        cc0: dict[int, float],
        cc1: dict[int, float],
        co: dict[int, float],
    ) -> float:
        bits = graph.cell_output_bits.get(node, ())
        if not bits:
            return 0.0
        per_bit = [
            math.log1p(
                min(cc0.get(bit, _INF_SCORE), _INF_SCORE)
                + min(cc1.get(bit, _INF_SCORE), _INF_SCORE)
                + min(co.get(bit, _INF_SCORE), _INF_SCORE)
            )
            for bit in bits
        ]
        return float(sum(per_bit) / len(per_bit))
