from __future__ import annotations

import json
import math
import shlex
import subprocess
import tempfile
from collections import defaultdict
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable

import numpy as np

try:
    from scipy.sparse import csr_matrix
    from scipy.sparse.linalg import eigsh
except Exception:  # pragma: no cover - scipy import failures are environment-specific
    csr_matrix = None
    eigsh = None


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
    sequential_output_bits: frozenset[int]
    sequential_input_bits: frozenset[int]
    signal_bits: frozenset[int]
    combinational_output_to_inputs: dict[int, tuple[int, ...]]
    bit_output_cell: dict[int, str]
    cell_output_bits: dict[str, tuple[int, ...]]


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
        if not graph.partition_nodes:
            return {}

        cc0, cc1, co = self._compute_scoap_scores(graph)
        metrics: dict[str, float] = {}
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
        script = (
            f"read_verilog -sv {shlex.quote(str(path))}; "
            f"{hierarchy_cmd} "
            "proc; opt; flatten; opt; "
            f"write_json {shlex.quote(str(json_path))}"
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

        top_key = self._resolve_top_module_key(modules, top_module_name)
        module_raw = modules.get(top_key)
        if not isinstance(module_raw, dict):
            return self._empty_graph_model()

        ports = module_raw.get("ports", {})
        cells_payload = module_raw.get("cells", {})
        if not isinstance(ports, dict) or not isinstance(cells_payload, dict):
            return self._empty_graph_model()

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
            bits = tuple(bit for bit in port_payload.get("bits", []) if isinstance(bit, int | str))
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
            inputs: dict[str, tuple[int | str, ...]] = {}
            outputs: dict[str, tuple[int | str, ...]] = {}
            is_sequential = self._is_sequential_cell(cell_type)
            sequential_data_inputs: list[int] = []

            for port_name, bits_raw in connections.items():
                if not isinstance(bits_raw, list):
                    continue
                bits = tuple(bit for bit in bits_raw if isinstance(bit, int | str))
                direction = str(port_dirs.get(port_name, "")).lower()
                if direction == "output":
                    outputs[str(port_name)] = bits
                    for bit in bits:
                        if isinstance(bit, int):
                            signal_bits.add(bit)
                            bit_drivers[bit].append((str(cell_name), "cell"))
                            bit_output_cell[bit] = str(cell_name)
                            if is_sequential:
                                sequential_output_bits.add(bit)
                else:
                    inputs[str(port_name)] = bits
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
            sequential_output_bits=frozenset(sequential_output_bits),
            sequential_input_bits=frozenset(sequential_input_bits),
            signal_bits=frozenset(signal_bits),
            combinational_output_to_inputs=combinational_output_to_inputs,
            bit_output_cell=bit_output_cell,
            cell_output_bits=cell_output_bits,
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

    def _extract_rent_metrics(self, graph: GraphModel) -> dict[str, float]:
        points = self._collect_rent_points(graph)
        if len(points) < 2:
            return {
                "rent_exponent": 0.0,
                "rent_k": 0.0,
                "rent_r2": 0.0,
                "rent_sample_count": float(len(points)),
            }

        grouped: dict[int, list[float]] = defaultdict(list)
        for size, terminals in points:
            grouped[size].append(terminals)
        samples = sorted(
            (float(size), float(sum(terminals) / len(terminals)))
            for size, terminals in grouped.items()
            if size >= 2 and sum(terminals) > 0.0
        )
        if len(samples) < 2:
            return {
                "rent_exponent": 0.0,
                "rent_k": 0.0,
                "rent_r2": 0.0,
                "rent_sample_count": float(len(samples)),
            }

        best_samples = list(samples)
        best_fit = self._fit_rent_line(best_samples)
        if best_fit is None:
            return {
                "rent_exponent": 0.0,
                "rent_k": 0.0,
                "rent_r2": 0.0,
                "rent_sample_count": float(len(samples)),
            }

        min_points = max(2, math.ceil(0.75 * len(samples)))
        while len(best_samples) > min_points:
            candidate_samples = best_samples[:-1]
            candidate_fit = self._fit_rent_line(candidate_samples)
            if candidate_fit is None or candidate_fit["sigma"] > best_fit["sigma"]:
                break
            best_samples = candidate_samples
            best_fit = candidate_fit

        return {
            "rent_exponent": float(max(0.0, min(1.0, best_fit["slope"]))),
            "rent_k": float(best_fit["k"]),
            "rent_r2": float(best_fit["r2"]),
            "rent_sample_count": float(len(best_samples)),
        }

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
