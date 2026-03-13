from __future__ import annotations

import re
from dataclasses import dataclass
from typing import Any


_SEQUENTIAL_CELL_PREFIXES = ("$_DFF", "$dff", "$adff", "$sdff")
_MUX_CELL_PREFIXES = ("$_MUX", "$mux")
_ARITH_CELL_PREFIXES = ("$_ADD", "$add", "$alu", "$fa")
_NETLIST_INSTANCE_RE = re.compile(
    r"^\s*([\\$A-Za-z_][\\$A-Za-z0-9_]*)\s+([\\$A-Za-z_][\\$A-Za-z0-9_]*)\s*\(",
    re.M,
)


@dataclass(frozen=True)
class StructuralMetrics:
    total_cells: int
    sequential_cells: int
    combinational_cells: int
    mux_cells: int
    arithmetic_cells: int
    seq_ratio: float
    comb_ratio: float
    mux_ratio: float
    adder_ratio: float
    ltp_noff: float
    cell_count_log: float


class StructuralEvaluator:
    """Extract coarse structural descriptors from Yosys-like statistics."""

    def extract_metrics(
        self,
        *,
        cell_counts: dict[str, int],
        ltp_noff: float | int | None = None,
    ) -> dict[str, float]:
        total_cells = max(sum(int(value) for value in cell_counts.values()), 0)
        sequential_cells = self._sum_matching(cell_counts, _SEQUENTIAL_CELL_PREFIXES)
        mux_cells = self._sum_matching(cell_counts, _MUX_CELL_PREFIXES)
        arithmetic_cells = self._sum_matching(cell_counts, _ARITH_CELL_PREFIXES)
        combinational_cells = max(total_cells - sequential_cells, 0)
        denom = max(total_cells, 1)
        ltp = float(ltp_noff or 0.0)
        return {
            "total_cells": float(total_cells),
            "sequential_cells": float(sequential_cells),
            "combinational_cells": float(combinational_cells),
            "mux_cells": float(mux_cells),
            "arithmetic_cells": float(arithmetic_cells),
            "seq_ratio": sequential_cells / denom,
            "comb_ratio": combinational_cells / denom,
            "mux_ratio": mux_cells / denom,
            "adder_ratio": arithmetic_cells / denom,
            "ltp_noff": ltp,
            "cell_count_log": float(total_cells),
        }

    def extract_from_yosys_payload(self, payload: dict[str, Any]) -> dict[str, float]:
        modules = payload.get("modules")
        if not isinstance(modules, dict) or not modules:
            return self.extract_metrics(cell_counts={})
        top_module_raw = next(iter(modules.values()))
        if not isinstance(top_module_raw, dict):
            return self.extract_metrics(cell_counts={})
        top_module: dict[str, Any] = {
            str(name): value for name, value in top_module_raw.items()
        }
        cells = top_module.get("num_cells_by_type", {})
        ltp_noff = top_module.get("ltp_noff", payload.get("ltp_noff", 0.0))
        cell_counts = {
            str(name): int(count)
            for name, count in cells.items()
            if isinstance(name, str) and isinstance(count, int | float)
        }
        return self.extract_metrics(cell_counts=cell_counts, ltp_noff=ltp_noff)

    def extract_from_netlist_text(
        self,
        netlist_text: str,
        *,
        ltp_noff: float | int | None = None,
    ) -> dict[str, float]:
        """Recover cell-composition metrics from a synthesized netlist text dump."""
        cell_counts: dict[str, int] = {}
        for cell_type, _ in _NETLIST_INSTANCE_RE.findall(netlist_text):
            clean_type = cell_type.replace("\\", "")
            cell_counts[clean_type] = cell_counts.get(clean_type, 0) + 1
        return self.extract_metrics(cell_counts=cell_counts, ltp_noff=ltp_noff)

    def _sum_matching(self, cell_counts: dict[str, int], prefixes: tuple[str, ...]) -> int:
        total = 0
        for cell_type, count in cell_counts.items():
            cell_type_lower = cell_type.lower()
            if any(cell_type_lower.startswith(prefix.lower()) for prefix in prefixes):
                total += int(count)
        return total
