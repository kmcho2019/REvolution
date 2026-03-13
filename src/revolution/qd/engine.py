from __future__ import annotations

import asyncio
import datetime
import json
import os
import random
import time
import traceback
from collections import defaultdict
from collections import deque
from typing import Any, Literal, cast

from revolution.algorithm import EoHEngine, EvolStrategyMethodFail, EvolStrategyMethodSuccess, Heuristic
from revolution.algorithm import QD_SUCCESS_STRATEGIES
from revolution.prompt_store import safe_format
from revolution.qd.archive import CVTArchive, GridArchive, GridAxisSpec
from revolution.qd.artifacts import (
    append_archive_history,
    write_archive_cells_csv,
    write_archive_space_files,
    write_candidate_archive_event,
    write_legacy_archive_layout,
    write_qd_summary_files,
)
from revolution.qd.descriptors import (
    descriptor_requirements,
    extract_descriptor_values,
    resolve_descriptor_axes,
    resolve_grid_axis_specs,
)
from revolution.qd.scoring import compute_ppa_gains
from revolution.qd.scheduler import split_qd_budget
from revolution.qd.types import QDArchiveInsertResult


class QDEngine(EoHEngine):
    """Archive-selectable QD engine that reuses the existing REvolution stack."""

    def __init__(
        self,
        *args: Any,
        qd_archive_type: str = "grid",
        qd_num_cells: int = 64,
        qd_fill_target_fraction: float = 0.25,
        qd_cell_reservoir: int = 2,
        qd_cvt_warmup_successes: int | None = None,
        qd_descriptor_profile: str | None = None,
        qd_descriptor_axes: tuple[str, ...] = (),
        qd_descriptor_file: str | None = None,
        qd_grid_axes: tuple[str, ...] = (),
        qd_cvt_axes: tuple[str, ...] = (),
        qd_fail_generation_mode: str = "auto",
        qd_seed_generation_mode: str = "auto",
        qd_backfill_generation_mode: str = "auto",
        qd_refine_generation_mode: str = "auto",
        qd_crossover_generation_mode: str = "auto",
        **kwargs: Any,
    ) -> None:
        super().__init__(*args, **kwargs)
        self.success_strats = list(QD_SUCCESS_STRATEGIES)
        self.success_strategy_stats = {
            strategy: {"count": 0, "value": 0.0}
            for strategy in self.success_strats
        }
        self.qd_archive_type = qd_archive_type
        self.qd_num_cells = max(1, int(qd_num_cells))
        self.qd_fill_target_fraction = float(qd_fill_target_fraction)
        self.qd_cell_reservoir = max(0, int(qd_cell_reservoir))
        self.qd_cvt_warmup_successes = qd_cvt_warmup_successes
        self.qd_descriptor_profile = qd_descriptor_profile
        self.qd_descriptor_axes = tuple(qd_descriptor_axes)
        self.qd_descriptor_file = qd_descriptor_file
        self.qd_grid_axes = self._resolve_grid_axes(qd_grid_axes)
        self.qd_cvt_axes = tuple(qd_cvt_axes)
        self.qd_fail_generation_mode = qd_fail_generation_mode
        self.qd_seed_generation_mode = qd_seed_generation_mode
        self.qd_backfill_generation_mode = qd_backfill_generation_mode
        self.qd_refine_generation_mode = qd_refine_generation_mode
        self.qd_crossover_generation_mode = qd_crossover_generation_mode
        self.success_archive = self._build_archive()
        self.success_reservoir: dict[str, deque[Heuristic]] = {}
        self.qd_generation_history: list[dict[str, Any]] = []

    def _resolve_grid_axes(
        self,
        explicit_grid_axes: tuple[str, ...] = (),
    ) -> tuple[str, ...]:
        circuit_type = (
            self.problem_spec.circuit_type
            if self.problem_spec is not None
            else ("sequential" if self.ref_ppa_metrics.get("eff_clk_period", 0.0) else "combinational")
        )
        return tuple(
            resolve_descriptor_axes(
                profile_name=self.qd_descriptor_profile,
                explicit_axes=explicit_grid_axes or self.qd_descriptor_axes or None,
                descriptor_file=self.qd_descriptor_file,
                archive_type="grid",
                circuit_type=circuit_type,
            )
        )

    def _build_grid_archive(self) -> GridArchive:
        axes = [
            GridAxisSpec(
                name=axis.name,
                bins=axis.bins,
                lower_bound=axis.lower_bound,
                upper_bound=axis.upper_bound,
            )
            for axis in resolve_grid_axis_specs(
                self.qd_grid_axes,
                num_cells=self.qd_num_cells,
                descriptor_file=self.qd_descriptor_file,
            )
        ]
        return GridArchive(axes)

    def _build_cvt_archive(self) -> CVTArchive:
        circuit_type = (
            self.problem_spec.circuit_type
            if self.problem_spec is not None
            else ("sequential" if self.ref_ppa_metrics.get("eff_clk_period", 0.0) else "combinational")
        )
        axes = resolve_descriptor_axes(
            profile_name=self.qd_descriptor_profile,
            explicit_axes=self.qd_cvt_axes or self.qd_descriptor_axes or None,
            descriptor_file=self.qd_descriptor_file,
            archive_type="cvt",
            circuit_type=circuit_type,
        )
        return CVTArchive(
            axes=axes,
            num_cells=self.qd_num_cells,
            warmup_successes=self.qd_cvt_warmup_successes,
        )

    def _build_archive(self) -> GridArchive | CVTArchive:
        if self.qd_archive_type == "grid":
            return self._build_grid_archive()
        if self.qd_archive_type == "cvt":
            return self._build_cvt_archive()
        raise ValueError(f"Unsupported qd_archive_type '{self.qd_archive_type}'.")

    def _archive_axes(self) -> tuple[str, ...]:
        if self.qd_archive_type == "grid":
            return self.qd_grid_axes
        archive_axes = getattr(self.success_archive, "axes", ())
        return tuple(str(axis) for axis in archive_axes)

    def _requires_rtl_descriptor_metrics(self) -> bool:
        return bool(descriptor_requirements(self._archive_axes()).get("requires_rtl_metrics"))

    def _requires_dynamic_descriptor_metrics(self) -> bool:
        return bool(
            descriptor_requirements(self._archive_axes()).get("requires_dynamic_metrics")
        )

    def _phase_mode(self, phase: str) -> Literal["whole", "diff"]:
        override = {
            "fail": self.qd_fail_generation_mode,
            "seed": self.qd_seed_generation_mode,
            "backfill": self.qd_backfill_generation_mode,
            "refine": self.qd_refine_generation_mode,
            "crossover": self.qd_crossover_generation_mode,
        }.get(phase, "auto")
        if override in {"whole", "diff"}:
            if phase == "seed" and override == "diff":
                return "whole"
            return cast(Literal["whole", "diff"], override)
        if self.problem_spec is not None:
            problem_default = self.problem_spec.phase_generation_defaults.get(phase, "auto")
            if problem_default in {"whole", "diff"}:
                if phase == "seed" and problem_default == "diff":
                    return "whole"
                return cast(Literal["whole", "diff"], problem_default)
        if phase == "refine" and self.generation_mode == "diff":
            return "diff"
        return "whole"

    def _descriptor_tuple(self, candidate: Heuristic) -> tuple[float, ...] | None:
        if candidate.status != "success" or not candidate.ppa_success:
            return None
        axes = self._archive_axes()
        if not axes:
            return None
        gains = compute_ppa_gains(candidate.ppa_metrics, self.ref_ppa_metrics)
        descriptor_metrics: dict[str, float] = {}
        descriptor_metrics.update(getattr(candidate, "structural_metrics", {}) or {})
        descriptor_metrics.update(getattr(candidate, "rtl_metrics", {}) or {})
        descriptor_metrics.update(getattr(candidate, "dynamic_metrics", {}) or {})
        descriptor_metrics.update(getattr(candidate, "physical_metrics", {}) or {})
        descriptor_metrics.update(getattr(candidate, "descriptor_values", {}) or {})
        descriptor_metrics.update(gains)
        descriptor_values = extract_descriptor_values(descriptor_metrics, axes)
        return tuple(float(descriptor_values.get(axis, 0.0)) for axis in axes)

    def _rebuild_archive_from_success_pool(self) -> None:
        self.success_archive = self._build_archive()
        self.success_reservoir = {}
        for cand in self.success_pool:
            descriptors = self._descriptor_tuple(cand)
            if descriptors is None:
                continue
            before_occupied = self.success_archive.occupied_count()
            before_qd_score = self._archive_qd_score()
            result = self.success_archive.insert(cand.id, descriptors, cand.score, cand)
            self._write_candidate_qd_event(
                cand,
                descriptor_tuple=descriptors,
                insert_result=result,
                before_occupied=before_occupied,
                after_occupied=self.success_archive.occupied_count(),
                before_qd_score=before_qd_score,
                after_qd_score=self._archive_qd_score(),
            )
        self.success_pool = self._success_view()

    def _archive_elites(self) -> list[Heuristic]:
        elites = [entry.payload for entry in self.success_archive.entries().values()]
        elites.sort(key=lambda cand: cand.score, reverse=True)
        return elites

    def _archive_entries(self) -> list[tuple[str, Any]]:
        return sorted(self.success_archive.entries().items(), key=lambda item: item[0])

    def _record_reservoir_candidate(self, cell_id: str, candidate: Heuristic) -> None:
        if self.qd_cell_reservoir <= 0:
            return
        bucket = self.success_reservoir.setdefault(
            cell_id,
            deque(maxlen=self.qd_cell_reservoir),
        )
        bucket.appendleft(candidate)

    def _success_view(self) -> list[Heuristic]:
        elites = self._archive_elites()
        seen_ids = {cand.id for cand in elites}
        view = list(elites)
        for cell_id in sorted(self.success_reservoir):
            for cand in self.success_reservoir[cell_id]:
                if cand.id in seen_ids:
                    continue
                seen_ids.add(cand.id)
                view.append(cand)
        return view

    def _write_candidate_qd_event(
        self,
        candidate: Heuristic,
        *,
        descriptor_tuple: tuple[float, ...],
        insert_result: QDArchiveInsertResult,
        before_occupied: int,
        after_occupied: int,
        before_qd_score: float,
        after_qd_score: float,
    ) -> None:
        if not candidate.code_file_path:
            return
        event_path = os.path.join(
            os.path.dirname(candidate.code_file_path),
            "qd_archive_event.json",
        )
        write_candidate_archive_event(
            candidate=candidate,
            event_path=event_path,
            archive=self.success_archive,
            archive_axes=self._archive_axes(),
            descriptor_tuple=descriptor_tuple,
            insert_result=insert_result,
            before_occupied=before_occupied,
            after_occupied=after_occupied,
            before_qd_score=before_qd_score,
            after_qd_score=after_qd_score,
            ref_ppa_metrics=self.ref_ppa_metrics,
            space_reference_file=self._archive_space_json_path(),
        )

    def _qd_log_dir(self) -> str | None:
        if self.logger is None:
            return None
        log_dir = getattr(self.logger, "log_dir", None)
        if log_dir is not None:
            os.makedirs(log_dir, exist_ok=True)
        return log_dir

    def _archive_layout_path(self) -> str | None:
        log_dir = self._qd_log_dir()
        if log_dir is None:
            return None
        filename = "grid_layout.json" if self.qd_archive_type == "grid" else "centroids.json"
        return os.path.join(log_dir, filename)

    def _archive_history_path(self) -> str | None:
        log_dir = self._qd_log_dir()
        if log_dir is None:
            return None
        return os.path.join(log_dir, "archive_history.jsonl")

    def _archive_cells_path(self) -> str | None:
        log_dir = self._qd_log_dir()
        if log_dir is None:
            return None
        return os.path.join(log_dir, "archive_cells.csv")

    def _archive_summary_path(self) -> str | None:
        log_dir = self._qd_log_dir()
        if log_dir is None:
            return None
        return os.path.join(log_dir, "archive_summary.json")

    def _qd_metrics_path(self) -> str | None:
        log_dir = self._qd_log_dir()
        if log_dir is None:
            return None
        return os.path.join(log_dir, "qd_metrics.json")

    def _archive_space_json_path(self) -> str | None:
        log_dir = self._qd_log_dir()
        if log_dir is None:
            return None
        return os.path.join(log_dir, "archive_space.json")

    def _archive_space_report_path(self) -> str | None:
        log_dir = self._qd_log_dir()
        if log_dir is None:
            return None
        return os.path.join(log_dir, "archive_space_report.md")

    def _archive_qd_score(self) -> float:
        return sum(float(entry.quality_score) for entry in self.success_archive.entries().values())

    def _gain_stats(self) -> dict[str, float]:
        elites = self._archive_elites()
        if not elites:
            return {
                "best_g_P": 0.0,
                "best_g_A": 0.0,
                "best_g_T": 0.0,
                "mean_g_P": 0.0,
                "mean_g_A": 0.0,
                "mean_g_T": 0.0,
            }
        gains = [compute_ppa_gains(cand.ppa_metrics, self.ref_ppa_metrics) for cand in elites]
        metrics: dict[str, float] = {}
        for axis in ("g_P", "g_A", "g_T"):
            values = [float(gain.get(axis, 0.0)) for gain in gains]
            metrics[f"best_{axis}"] = max(values) if values else 0.0
            metrics[f"mean_{axis}"] = (sum(values) / len(values)) if values else 0.0
        return metrics

    def _build_qd_snapshot(
        self,
        *,
        inserted: int,
        replaced: int,
        budget: Any | None,
        runtime_sec: float | None = None,
    ) -> dict[str, Any]:
        entries = self._archive_entries()
        qualities = [float(entry.quality_score) for _, entry in entries]
        occupied = len(entries)
        coverage = occupied / max(self.success_archive.num_cells, 1)
        snapshot = {
            "generation": self.current_generation,
            "archive_type": self.qd_archive_type,
            "occupied_cells": occupied,
            "num_cells": self.success_archive.num_cells,
            "coverage": coverage,
            "qd_score": sum(qualities),
            "best_quality": max(qualities) if qualities else None,
            "mean_quality": (sum(qualities) / len(qualities)) if qualities else None,
            "new_filled_cells": max(inserted - replaced, 0),
            "replaced_cells": replaced,
            "runtime_seconds": runtime_sec,
        }
        snapshot.update(self._gain_stats())
        if budget is not None:
            snapshot.update(
                {
                    "phase": budget.phase,
                    "fail_budget": budget.fail_budget,
                    "seed_budget": budget.seed_budget,
                    "backfill_budget": budget.backfill_budget,
                    "refine_budget": budget.refine_budget,
                }
            )
        return snapshot

    def _write_archive_layout(self) -> None:
        path = self._archive_layout_path()
        if path is None:
            return
        write_legacy_archive_layout(path=path, archive=self.success_archive)

    def _write_archive_cells(self) -> None:
        path = self._archive_cells_path()
        if path is None:
            return
        write_archive_cells_csv(
            path=path,
            entries=self._archive_entries(),
            ref_ppa_metrics=self.ref_ppa_metrics,
        )

    def _append_archive_history(self, snapshot: dict[str, Any]) -> None:
        path = self._archive_history_path()
        if path is None:
            return
        self.qd_generation_history.append(dict(snapshot))
        append_archive_history(path=path, snapshot=snapshot)

    def _write_qd_summary_files(self) -> None:
        summary_path = self._archive_summary_path()
        metrics_path = self._qd_metrics_path()
        space_json_path = self._archive_space_json_path()
        space_report_path = self._archive_space_report_path()
        if summary_path is None or metrics_path is None:
            return
        visualization_artifacts = write_qd_summary_files(
            summary_path=summary_path,
            metrics_path=metrics_path,
            output_dir=self._qd_log_dir() or os.path.dirname(summary_path),
            history=self.qd_generation_history,
            archive=self.success_archive,
            ref_ppa_metrics=self.ref_ppa_metrics,
            descriptor_profile=self.qd_descriptor_profile,
            descriptor_axes=self._archive_axes(),
        )
        if space_json_path is not None and space_report_path is not None:
            write_archive_space_files(
                json_path=space_json_path,
                report_path=space_report_path,
                archive=self.success_archive,
                descriptor_profile=self.qd_descriptor_profile,
                descriptor_axes=self._archive_axes(),
                occupied_cells=self.success_archive.occupied_count(),
                visualization_files=visualization_artifacts.generated_files,
            )

    def _write_qd_artifacts(self, snapshot: dict[str, Any] | None = None) -> None:
        history_path = self._archive_history_path()
        if history_path is not None and not os.path.exists(history_path):
            open(history_path, "a", encoding="utf-8").close()
        self._write_archive_layout()
        self._write_archive_cells()
        if snapshot is not None:
            self._append_archive_history(snapshot)
        self._write_qd_summary_files()

    def initialize_population(self) -> None:
        super().initialize_population()
        self._rebuild_archive_from_success_pool()

    def _sample_success_parents(self, count: int) -> list[Heuristic]:
        success_view = self._success_view()
        if not success_view:
            return []
        base = min(c.score for c in success_view)
        weights = [max(c.score - base + 0.1, 1e-6) for c in success_view]
        return random.choices(success_view, weights=weights, k=count)

    def _descriptor_distance(self, left: Heuristic, right: Heuristic) -> float:
        left_desc = self._descriptor_tuple(left)
        right_desc = self._descriptor_tuple(right)
        if left_desc is None or right_desc is None:
            return float("-inf")
        return sum((lhs - rhs) ** 2 for lhs, rhs in zip(left_desc, right_desc))

    def _sample_diverse_success_parents(self) -> list[Heuristic]:
        success_view = self._success_view()
        if len(success_view) < 2:
            return self._sample_success_parents(1)
        first = self._sample_success_parents(1)[0]
        alternatives = [cand for cand in success_view if cand.id != first.id]
        if not alternatives:
            return [first]
        second = max(alternatives, key=lambda cand: self._descriptor_distance(first, cand))
        return [first, second]

    def _descriptor_metadata(self, parent: Heuristic) -> dict[str, float]:
        descriptors = self._descriptor_tuple(parent)
        axes = self._archive_axes()
        if descriptors is None:
            return {}
        return {axis: float(value) for axis, value in zip(axes, descriptors)}

    def _descriptor_direction(self, axis: str, current_value: float) -> dict[str, Any]:
        if self.qd_archive_type == "grid":
            grid_axes = {
                axis_spec.name: axis_spec
                for axis_spec in getattr(self.success_archive, "axes", ())
            }
            axis_spec = grid_axes.get(axis)
            if axis_spec is not None:
                midpoint = (axis_spec.lower_bound + axis_spec.upper_bound) / 2.0
                increase = current_value <= midpoint
                return {
                    "axis": axis,
                    "current_value": current_value,
                    "direction": "increase" if increase else "decrease",
                    "target_hint": axis_spec.upper_bound if increase else axis_spec.lower_bound,
                    "rationale": self._descriptor_rationale(axis, increase),
                }
        increase = current_value <= 0.0
        return {
            "axis": axis,
            "current_value": current_value,
            "direction": "increase" if increase else "decrease",
            "target_hint": 1.0 if increase else -1.0,
            "rationale": self._descriptor_rationale(axis, increase),
        }

    def _descriptor_rationale(self, axis: str, increase: bool) -> str:
        direction = "more" if increase else "less"
        mapping = {
            "seq_ratio": f"{direction} explicit pipelining or staging",
            "mux_ratio": f"{direction} control multiplexing pressure",
            "ltp_noff": f"{direction} combinational path depth" if increase else "shorter combinational chains",
            "g_P": f"{direction} power improvement",
            "g_A": f"{direction} area improvement",
            "g_T": f"{direction} timing improvement",
            "wirelength": f"{direction} routing wirelength pressure" if increase else "more localized organization",
            "utilization": f"{direction} placement density",
            "cts_buffer_count": f"{direction} inserted clock-tree buffering",
        }
        return mapping.get(axis, f"{direction} emphasis on {axis}")

    def _target_descriptor_shift(self, parent: Heuristic, limit: int = 2) -> list[dict[str, Any]]:
        descriptor_map = self._descriptor_metadata(parent)
        shifts: list[dict[str, Any]] = []
        for axis in list(self._archive_axes())[: max(1, limit)]:
            current_value = float(descriptor_map.get(axis, 0.0))
            shifts.append(self._descriptor_direction(axis, current_value))
        return shifts

    def _cell_id_for_candidate(self, candidate: Heuristic) -> str | None:
        descriptors = self._descriptor_tuple(candidate)
        if descriptors is None:
            return None
        try:
            return self.success_archive.cell_id_for(descriptors)
        except ValueError:
            return None

    def _create_prompt_M_T(self, parents: list[Heuristic]) -> str:
        """Create a QD-specific targeted-mutation prompt for one successful parent."""
        parent = parents[0]
        descriptor_shift = self._target_descriptor_shift(parent)
        if self.generation_mode == "whole":
            parent_obj = json.loads(self._format_parent_for_prompt(parent, 1))
            context_obj = {
                "task": "target_descriptor_mutation",
                "problem_description": self.problem_description,
                "parent": parent_obj,
                "qd": {
                    "archive_type": self.qd_archive_type,
                    "archive_axes": list(self._archive_axes()),
                    "source_cell_id": self._cell_id_for_candidate(parent),
                    "parent_descriptors": self._descriptor_metadata(parent),
                    "desired_descriptor_shift": descriptor_shift,
                },
            }
            tpl = self.prompts.read("evolve/M-T/whole")
            if tpl:
                return safe_format(tpl, context_json=json.dumps(context_obj, indent=2))
            return (
                "You are an expert Verilog design assistant.\n"
                "Refactor the parent toward the requested descriptor shift while preserving functionality.\n\n"
                "CONTEXT_JSON:\n"
                f"{json.dumps(context_obj, indent=2)}\n\n"
                "Return exactly ONE JSON object and nothing else:\n"
                "{\n"
                '  "format": "eoh_v1",\n'
                '  "mode": "whole",\n'
                '  "thought": "<targeted mutation plan>",\n'
                '  "code": "<full, runnable Verilog as one JSON string>"\n'
                "}\n"
            )
        with open(parent.code_file_path, "r", encoding="utf-8") as handle:
            parent_code = handle.read()
        parent_obj = json.loads(
            self._format_parent_for_prompt(
                parent,
                1,
                include_code=not self.diff_compact_context,
                code_override=parent_code,
            )
        )
        context_obj = {
            "task": "target_descriptor_mutation_via_patch",
            "problem_description": self.problem_description,
            "file_to_edit": parent.code_file_path,
            "original_file": parent_code,
            "parent": parent_obj,
            "qd": {
                "archive_type": self.qd_archive_type,
                "archive_axes": list(self._archive_axes()),
                "source_cell_id": self._cell_id_for_candidate(parent),
                "parent_descriptors": self._descriptor_metadata(parent),
                "desired_descriptor_shift": descriptor_shift,
            },
        }
        tpl = self.prompts.read("evolve/M-T/diff")
        if tpl:
            return safe_format(
                tpl,
                context_json=json.dumps(context_obj, indent=2),
                file_to_edit=parent.code_file_path,
                original_file=parent_code,
            )
        return (
            "You are an expert Verilog design assistant.\n"
            "Edit the base file to move it toward the requested descriptor shift.\n\n"
            "CONTEXT_JSON:\n"
            f"{json.dumps(context_obj, indent=2)}\n\n"
            "Return exactly ONE JSON object and nothing else:\n"
            "{\n"
            '  "format": "eoh_v1",\n'
            '  "mode": "diff",\n'
            '  "thought": "<targeted mutation plan>",\n'
            '  "code": {\n'
            '    "edits": [\n'
            f'      {{ "file": "{parent.code_file_path}", "hunks": [\n'
            '          { "search": "<exact original text>\\n", "replace": "<replacement text>\\n" }\n'
            "        ] }\n"
            "    ]\n"
            "  }\n"
            "}\n"
        )

    def _create_prompt_C_D(self, parents: list[Heuristic]) -> str:
        """Create a QD-specific diverse-fusion prompt for two distant parents."""
        parent1 = parents[0]
        parent2 = parents[1]
        distance = self._descriptor_distance(parent1, parent2)
        if self.generation_mode == "whole":
            p1_obj = json.loads(self._format_parent_for_prompt(parent1, 1))
            p2_obj = json.loads(self._format_parent_for_prompt(parent2, 2))
            context_obj = {
                "task": "diverse_archive_fusion",
                "problem_description": self.problem_description,
                "parents": [p1_obj, p2_obj],
                "qd": {
                    "archive_type": self.qd_archive_type,
                    "archive_axes": list(self._archive_axes()),
                    "parent_descriptors": [
                        self._descriptor_metadata(parent1),
                        self._descriptor_metadata(parent2),
                    ],
                    "descriptor_distance": distance,
                },
            }
            tpl = self.prompts.read("evolve/C-D/whole")
            if tpl:
                return safe_format(tpl, context_json=json.dumps(context_obj, indent=2))
            return (
                "You are an expert Verilog design assistant.\n"
                "Fuse the distant archive parents into a functionally correct design that spans their strengths.\n\n"
                "CONTEXT_JSON:\n"
                f"{json.dumps(context_obj, indent=2)}\n\n"
                "Return exactly ONE JSON object and nothing else:\n"
                "{\n"
                '  "format": "eoh_v1",\n'
                '  "mode": "whole",\n'
                '  "thought": "<diverse fusion strategy>",\n'
                '  "code": "<full, runnable Verilog as one JSON string>"\n'
                "}\n"
            )
        with open(parent1.code_file_path, "r", encoding="utf-8") as handle:
            parent1_code = handle.read()
        with open(parent2.code_file_path, "r", encoding="utf-8") as handle:
            parent2_code = handle.read()
        p1_obj = json.loads(
            self._format_parent_for_prompt(
                parent1,
                1,
                include_code=not self.diff_compact_context,
                code_override=parent1_code,
            )
        )
        p2_obj = json.loads(
            self._format_parent_for_prompt(
                parent2,
                2,
                include_code=not self.diff_compact_context,
                code_override=parent2_code,
            )
        )
        context_obj = {
            "task": "diverse_archive_fusion_via_patch",
            "problem_description": self.problem_description,
            "file_to_edit": parent1.code_file_path,
            "original_file": parent1_code,
            "parents": [p1_obj, p2_obj],
            "qd": {
                "archive_type": self.qd_archive_type,
                "archive_axes": list(self._archive_axes()),
                "parent_descriptors": [
                    self._descriptor_metadata(parent1),
                    self._descriptor_metadata(parent2),
                ],
                "descriptor_distance": distance,
            },
        }
        tpl = self.prompts.read("evolve/C-D/diff")
        if tpl:
            return safe_format(
                tpl,
                context_json=json.dumps(context_obj, indent=2),
                file_to_edit=parent1.code_file_path,
                original_file=parent1_code,
            )
        return (
            "You are an expert Verilog design assistant.\n"
            "Edit Example 1 to incorporate strengths from the distant second parent.\n\n"
            "CONTEXT_JSON:\n"
            f"{json.dumps(context_obj, indent=2)}\n\n"
            "Return exactly ONE JSON object and nothing else:\n"
            "{\n"
            '  "format": "eoh_v1",\n'
            '  "mode": "diff",\n'
            '  "thought": "<diverse fusion plan>",\n'
            '  "code": {\n'
            '    "edits": [\n'
            f'      {{ "file": "{parent1.code_file_path}", "hunks": [\n'
            '          { "search": "<exact original text>\\n", "replace": "<replacement text>\\n" }\n'
            "        ] }\n"
            "    ]\n"
            "  }\n"
            "}\n"
        )

    def _materialize_offspring(
        self,
        llm_results_with_meta: list[tuple[str | None, str | None, dict[str, Any]]],
        metadata: list[dict[str, Any]],
    ) -> list[Heuristic]:
        return self._materialize_offspring_batch(llm_results_with_meta, metadata)

    def _update_fail_pool(self, candidates: list[Heuristic]) -> None:
        status_rank = {
            "failed_format": 0,
            "failed_diff": 1,
            "failed_syntax": 2,
            "failed_functionality": 3,
            "failed_synthesis": 4,
            "failed_synthesis_functionality": 5,
        }
        combined = [cand for cand in self.fail_pool + candidates if cand.status != "success"]
        combined.sort(
            key=lambda cand: (
                status_rank.get(cand.status, -1),
                cand.generation,
            ),
            reverse=True,
        )
        self.fail_pool = combined[: self.population_size]

    def _insert_successes(self, candidates: list[Heuristic]) -> tuple[int, int]:
        inserted = 0
        replaced = 0
        for cand in candidates:
            descriptors = self._descriptor_tuple(cand)
            if descriptors is None:
                continue
            before_occupied = self.success_archive.occupied_count()
            before_qd_score = self._archive_qd_score()
            result = self.success_archive.insert(cand.id, descriptors, cand.score, cand)
            if result.inserted:
                inserted += 1
            if result.replaced:
                replaced += 1
                previous_payload = cast(Heuristic | None, result.previous_payload)
                if previous_payload is not None:
                    self._record_reservoir_candidate(result.cell_id, previous_payload)
            elif self.qd_cell_reservoir > 0:
                self._record_reservoir_candidate(result.cell_id, cand)
            after_occupied = self.success_archive.occupied_count()
            after_qd_score = self._archive_qd_score()
            self._write_candidate_qd_event(
                cand,
                descriptor_tuple=descriptors,
                insert_result=result,
                before_occupied=before_occupied,
                after_occupied=after_occupied,
                before_qd_score=before_qd_score,
                after_qd_score=after_qd_score,
            )
        self.success_pool = self._success_view()
        return inserted, replaced

    def evolve_one_generation(self):
        self.current_generation += 1
        print(f"\n--- Starting QD Generation {self.current_generation} ---")
        self.gen_start_time = time.time()

        budget = split_qd_budget(
            total_budget=self.num_offspring_lambda,
            occupied_cells=self.success_archive.occupied_count(),
            num_cells=self.success_archive.num_cells,
            fill_target_fraction=self.qd_fill_target_fraction,
            fail_pool_empty=not bool(self.fail_pool),
            archive_empty=self.success_archive.occupied_count() == 0,
            empty_cells_remaining=self.success_archive.occupied_count() < self.success_archive.num_cells,
        )

        new_offspring: list[Heuristic] = []
        fail_rewards_this_gen = defaultdict(float)
        success_rewards_this_gen = defaultdict(float)
        strategy_avg_selection_probabilities: dict[str, dict[str, float]] = {
            "fail_pool": {},
            "success_pool": {},
        }

        if budget.seed_budget > 0:
            seed_mode = self._phase_mode("seed")
            seed_results = asyncio.run(
                self.llm.generate_n_responses(
                    prompt=self.problem_description,
                    n=budget.seed_budget,
                    temperature=self.default_llm_temp,
                    top_p=self.default_llm_top_p,
                    max_tokens=self.default_llm_max_tokens,
                    generation_mode=seed_mode,
                    system_prompt_override=self._get_generation_system_prompt(seed_mode),
                )
            )
            seed_meta = [
                {
                    "strategy": "initial",
                    "parents": [],
                    "origin_pool": "success_pool",
                    "resolved_mode": seed_mode,
                }
                for _ in range(len(seed_results))
            ]
            new_offspring.extend(self._materialize_offspring(seed_results, seed_meta))

        llm_requests = []
        request_meta: list[dict[str, Any]] = []

        if self.fail_pool and budget.fail_budget > 0:
            fail_strategies: list[EvolStrategyMethodFail] = ["M-F", "M-E"]
            fail_selected: set[EvolStrategyMethodFail] = set()
            for _ in range(budget.fail_budget):
                strat_name, prob_dist = self._select_strategy("fail", fail_strategies, fail_selected)
                if strat_name is None or prob_dist is None:
                    continue
                fail_selected.add(strat_name)
                parent = random.choice(self.fail_pool)
                mode = self._phase_mode("fail")
                prompt_text = self._with_mode(mode, getattr(self, f"_create_prompt_{strat_name.replace('-', '_')}"), [parent])
                llm_requests.append(
                    self._build_prompt_request(
                        prompt=prompt_text,
                        mode=mode,
                        system_prompt=self._get_generation_system_prompt(mode),
                    )
                )
                request_meta.append(
                    {
                        "strategy": strat_name,
                        "parents": [parent],
                        "origin_pool": "fail_pool",
                        "resolved_mode": mode,
                    }
                )
                for key, value in prob_dist.items():
                    strategy_avg_selection_probabilities["fail_pool"][key] = (
                        strategy_avg_selection_probabilities["fail_pool"].get(key, 0.0)
                        + value
                    )

        success_selected: set[EvolStrategyMethodSuccess] = set()
        success_total_requests = budget.backfill_budget + budget.refine_budget
        for idx in range(success_total_requests):
            if budget.phase == "fill" or idx < budget.backfill_budget:
                available: list[EvolStrategyMethodSuccess] = ["M-T", "M-E"]
                if len(self.success_pool) > 1:
                    available.append("C-D")
                selected_name, prob_dist = self._select_strategy(
                    "success",
                    available,
                    success_selected,
                )
                if selected_name is None or prob_dist is None:
                    continue
                strat_name = selected_name
                success_selected.add(strat_name)
                parents = (
                    self._sample_diverse_success_parents()
                    if strat_name == "C-D"
                    else self._sample_success_parents(1)
                )
                if not parents:
                    break
                mode = self._phase_mode("crossover" if strat_name == "C-D" else "backfill")
                for key, value in prob_dist.items():
                    strategy_avg_selection_probabilities["success_pool"][key] = (
                        strategy_avg_selection_probabilities["success_pool"].get(key, 0.0)
                        + value
                    )
            else:
                parents = self._sample_success_parents(
                    2
                    if idx == success_total_requests - 1 and len(self.success_pool) > 1
                    else 1
                )
                if not parents:
                    break
                available: list[EvolStrategyMethodSuccess] = ["M-S", "M-R", "M-I"]
                if len(self.success_pool) > 1:
                    available.append("C-F")
                selected_name, prob_dist = self._select_strategy(
                    "success",
                    available,
                    success_selected,
                )
                if selected_name is None or prob_dist is None:
                    continue
                strat_name = selected_name
                success_selected.add(strat_name)
                mode = self._phase_mode("crossover" if strat_name == "C-F" else "refine")
                for key, value in prob_dist.items():
                    strategy_avg_selection_probabilities["success_pool"][key] = (
                        strategy_avg_selection_probabilities["success_pool"].get(key, 0.0)
                        + value
                    )

            if strat_name in {"C-F", "C-D"} and len(parents) < 2:
                parents = self._sample_success_parents(2)
                if len(parents) < 2:
                    continue
            if strat_name not in {"C-F", "C-D"}:
                prompt_text = self._with_mode(mode, getattr(self, f"_create_prompt_{strat_name.replace('-', '_')}"), [parents[0]])
            else:
                if parents[0].id == parents[1].id:
                    alt = [cand for cand in self.success_pool if cand.id != parents[0].id]
                    if not alt:
                        continue
                    parents[1] = random.choice(alt)
                prompt_builder = self._create_prompt_C_F if strat_name == "C-F" else self._create_prompt_C_D
                prompt_text = self._with_mode(mode, prompt_builder, parents)

            llm_requests.append(
                self._build_prompt_request(
                    prompt=prompt_text,
                    mode=mode,
                    system_prompt=self._get_generation_system_prompt(mode),
                )
            )
            request_meta.append(
                {
                    "strategy": strat_name,
                    "parents": parents,
                    "origin_pool": "success_pool",
                    "resolved_mode": mode,
                }
            )

        if llm_requests:
            llm_results = asyncio.run(
                self.llm.generate_batch_responses(
                    llm_requests,
                    self.default_llm_temp,
                    self.default_llm_top_p,
                    self.default_llm_max_tokens,
                )
            )
            new_offspring.extend(self._materialize_offspring(llm_results, request_meta))

        if not new_offspring:
            return "STOP"

        self._evaluate_candidates(new_offspring)
        inserted, replaced = self._insert_successes([cand for cand in new_offspring if cand.status == "success"])
        self._update_fail_pool([cand for cand in new_offspring if cand.status != "success"])

        for cand in new_offspring:
            if cand.origin_pool == "fail_pool" and cand.status == "success":
                fail_rewards_this_gen[cand.strategy] += 1.0
            elif cand.origin_pool == "success_pool" and cand.status == "success":
                success_rewards_this_gen[cand.strategy] += 1.0

        gen_runtime = time.time() - self.gen_start_time
        qd_snapshot = self._build_qd_snapshot(
            inserted=inserted,
            replaced=replaced,
            budget=budget,
            runtime_sec=gen_runtime,
        )
        if self.logger:
            self._log_generation_stats(
                new_offspring,
                gen_runtime,
                fail_rewards_this_gen,
                success_rewards_this_gen,
                strategy_avg_selection_probabilities,
            )
            self._write_qd_artifacts(qd_snapshot)

        print(
            f"--- QD Gen {self.current_generation} Complete. Archive({self.success_archive.occupied_count()}), "
            f"Inserted({inserted}), Replaced({replaced}), Fail({len(self.fail_pool)}) ---"
        )
        return None

    def run(self):
        print(
            f"--- Starting REvolution QD Run: Problem '{self.benchmark_name}/{self.problem_name}' ---"
        )
        self.run_start_time = time.time()
        self.run_start_utc = datetime.datetime.now(datetime.timezone.utc)

        try:
            self._calculate_reference_ppa()
            self._initialize_logger(
                f"{self.strategy_selection_method}_qd_{self.qd_archive_type}"
            )
            self.initialize_population()
            initial_snapshot = self._build_qd_snapshot(
                inserted=self.success_archive.occupied_count(),
                replaced=0,
                budget=None,
                runtime_sec=time.time() - self.run_start_time,
            )
            self._write_qd_artifacts(initial_snapshot)
        except Exception as exc:
            print(f"Critical error during QD initialization: {exc}")
            traceback.print_exc()
            return f"{self.problem_name},initialization_failed"

        for _ in range(self.num_generations):
            if self.evolve_one_generation() == "STOP":
                break

        print("\n--- REvolution QD Run Finished ---")
        archive_elites = self._archive_elites()
        self._finalize_run_summary(archive_elites)

        if archive_elites:
            best_solution = archive_elites[0]
            final_report = best_solution.ppa_metrics.get("report_path", "N/A")
            final_score = best_solution.score if best_solution.score is not None else "N/A"
            return f"{self.problem_name},success,{best_solution.code_file_path},{final_report},{final_score}"
        return f"{self.problem_name},failed"
