from __future__ import annotations

import math
import re
from dataclasses import dataclass
from collections.abc import Iterable
from pathlib import Path

_SCOPE_RE = re.compile(r"^\$scope\s+\S+\s+([^\s$]+)\s+\$end$")
_UPSCOPE_RE = re.compile(r"^\$upscope\s+\$end$")
_VAR_RE = re.compile(r"^\$var\s+\S+\s+(\d+)\s+(\S+)\s+(.+?)\s+\$end$")
_CLOCK_RESET_RE = re.compile(r"(^|_)(clk|clock|rst|reset)($|_)", re.I)


@dataclass(frozen=True)
class VCDSignal:
    symbol: str
    width: int
    full_name: str


class SimulationDescriptorEvaluator:
    """Extract lightweight activity descriptors from an Icarus/VCD waveform."""

    def extract_metrics(
        self,
        *,
        vcd_file_path: str | Path | None,
        top_module_name: str = "tb",
    ) -> dict[str, float]:
        """Return activity-oriented metrics for one simulated candidate."""
        base_metrics = {
            "tracked_signal_count_est": 0.0,
            "active_signal_ratio_est": 0.0,
            "toggle_count_log_est": 0.0,
            "toggle_density_est": 0.0,
            "avg_toggle_rate_est": 0.0,
            "vcd_time_span_est": 0.0,
        }
        if vcd_file_path is None:
            return base_metrics

        vcd_path = Path(vcd_file_path)
        if not vcd_path.is_file():
            return base_metrics

        try:
            signal_map = self._parse_signal_definitions(vcd_path)
            tracked_signals = self._select_tracked_signals(
                signal_map.values(),
                top_module_name=top_module_name,
            )
            if not tracked_signals:
                return base_metrics

            tracked_symbols = {signal.symbol: signal for signal in tracked_signals}
            previous_values: dict[str, str] = {}
            per_signal_changes = {symbol: 0 for symbol in tracked_symbols}
            total_change_events = 0
            total_bit_toggles = 0.0
            first_time: int | None = None
            current_time = 0

            with vcd_path.open("r", encoding="utf-8", errors="ignore") as handle:
                in_definitions = True
                for raw_line in handle:
                    line = raw_line.strip()
                    if not line:
                        continue
                    if in_definitions:
                        if line == "$enddefinitions $end":
                            in_definitions = False
                        continue
                    if line.startswith("#"):
                        try:
                            current_time = int(line[1:])
                        except ValueError:
                            continue
                        if first_time is None:
                            first_time = current_time
                        continue

                    parsed = self._parse_value_change(line)
                    if parsed is None:
                        continue
                    symbol, raw_value = parsed
                    signal = tracked_symbols.get(symbol)
                    if signal is None:
                        continue

                    normalized = self._normalize_value(raw_value, signal.width)
                    if normalized is None:
                        continue

                    previous = previous_values.get(symbol)
                    if previous is not None and previous != normalized:
                        per_signal_changes[symbol] += 1
                        total_change_events += 1
                        total_bit_toggles += self._bit_toggle_delta(previous, normalized)
                    previous_values[symbol] = normalized

            tracked_signal_count = len(tracked_symbols)
            active_signal_count = sum(
                1 for change_count in per_signal_changes.values() if change_count > 0
            )
            time_origin = first_time if first_time is not None else current_time
            time_span = max(current_time - time_origin, 0)
            base_metrics.update(
                {
                    "tracked_signal_count_est": float(tracked_signal_count),
                    "active_signal_ratio_est": (
                        float(active_signal_count) / max(float(tracked_signal_count), 1.0)
                    ),
                    "toggle_count_log_est": math.log1p(max(total_bit_toggles, 0.0)),
                    "toggle_density_est": (
                        float(total_change_events) / max(float(tracked_signal_count), 1.0)
                    ),
                    "avg_toggle_rate_est": (
                        float(total_change_events) / max(float(time_span), 1.0)
                    ),
                    "vcd_time_span_est": float(time_span),
                }
            )
            return base_metrics
        except OSError:
            return base_metrics

    def _parse_signal_definitions(self, vcd_path: Path) -> dict[str, VCDSignal]:
        signal_map: dict[str, VCDSignal] = {}
        scope_stack: list[str] = []
        with vcd_path.open("r", encoding="utf-8", errors="ignore") as handle:
            for raw_line in handle:
                line = raw_line.strip()
                if not line:
                    continue
                if line == "$enddefinitions $end":
                    break
                scope_match = _SCOPE_RE.match(line)
                if scope_match is not None:
                    scope_stack.append(scope_match.group(1))
                    continue
                if _UPSCOPE_RE.match(line):
                    if scope_stack:
                        scope_stack.pop()
                    continue
                var_match = _VAR_RE.match(line)
                if var_match is None:
                    continue
                width = max(1, int(var_match.group(1)))
                symbol = var_match.group(2)
                reference = " ".join(var_match.group(3).split())
                full_name = ".".join([*scope_stack, reference]) if scope_stack else reference
                signal_map[symbol] = VCDSignal(
                    symbol=symbol,
                    width=width,
                    full_name=full_name,
                )
        return signal_map

    def _select_tracked_signals(
        self,
        signals: Iterable[VCDSignal],
        *,
        top_module_name: str,
    ) -> list[VCDSignal]:
        signal_list = list(signals)
        filtered = [signal for signal in signal_list if not self._ignore_signal(signal.full_name)]
        if not filtered:
            return []

        hierarchical = [
            signal
            for signal in filtered
            if signal.full_name.startswith(f"{top_module_name}.")
            and len(signal.full_name.split(".")) >= 3
        ]
        if hierarchical:
            return hierarchical

        top_scoped = [
            signal
            for signal in filtered
            if signal.full_name.startswith(f"{top_module_name}.")
        ]
        if top_scoped:
            return top_scoped
        return filtered

    def _ignore_signal(self, full_name: str) -> bool:
        lowered = full_name.lower()
        leaf_name = lowered.split(".")[-1]
        if _CLOCK_RESET_RE.search(leaf_name):
            return True
        return any(
            token in lowered
            for token in (
                "expected",
                "golden",
                "reference",
                "scoreboard",
                "monitor",
            )
        )

    def _parse_value_change(self, line: str) -> tuple[str, str] | None:
        if line[0] in "01xXzZ":
            return line[1:], line[0]
        if line[0] in "bBrR":
            parts = line.split()
            if len(parts) != 2:
                return None
            return parts[1], parts[0][1:]
        return None

    def _normalize_value(self, raw_value: str, width: int) -> str | None:
        value = "".join(ch for ch in raw_value.lower() if ch in {"0", "1", "x", "z"})
        if not value:
            return None
        if len(value) >= width:
            return value[-width:]
        if set(value) <= {"x"}:
            pad_char = "x"
        elif set(value) <= {"z"}:
            pad_char = "z"
        else:
            pad_char = "0"
        return f"{pad_char * (width - len(value))}{value}"

    def _bit_toggle_delta(self, previous: str, current: str) -> float:
        if len(previous) != len(current):
            return 1.0
        if any(ch not in {"0", "1"} for ch in previous + current):
            return 1.0
        return float(sum(1 for old_bit, new_bit in zip(previous, current) if old_bit != new_bit))
