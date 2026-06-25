from __future__ import annotations

import asyncio
import datetime
import hashlib
import json
import math
import os
import random
import re
import time
import traceback
from collections import defaultdict
from collections import deque
from pathlib import Path
from typing import Any, Literal, cast

from revolution.auto_bd.motif_descriptor import motif_occupancy_descriptor_values
from revolution.auto_bd.netlist_hash import canonical_netlist_hash
from revolution.auto_bd.random_descriptor import random_hash_descriptor_values
from revolution.auto_bd.sr_pca_descriptor import (
    SR_PCA_AXES,
    SrPcaArtifact,
    sr_pca_artifact_from_json,
    sr_raw_feature_values,
    transform_sr_raw_pca,
)
from revolution.auto_bd.sr_vq_descriptor import (
    SR_VQ_AXES,
    SrVqArtifact,
    sr_vq_artifact_from_json,
    transform_sr_vq,
)
from revolution.auto_bd.trajectory_descriptor import (
    synthesis_trajectory_descriptor_values,
)
from revolution.algorithm import (
    CLASSIC_FAIL_STRATEGIES,
    CLASSIC_SUCCESS_STRATEGIES,
    EoHEngine,
    EvolStrategyMethod,
    EvolStrategyMethodFail,
    EvolStrategyMethodSuccess,
    Heuristic,
    QD_SUCCESS_STRATEGIES,
)
from revolution.prompt_store import safe_format
from revolution.qd.archive import (
    CVTArchive,
    GlobalParetoArchive,
    GridArchive,
    GridAxisSpec,
    GridQuantileArchive,
    active_ppa_objectives,
    ranked_front,
)
from revolution.qd.artifacts import (
    append_archive_history,
    write_archive_cells_csv,
    write_archive_space_files,
    write_candidate_archive_event,
    write_descriptor_health_files,
    write_global_pareto_archive_csv,
    write_global_pareto_summary,
    write_legacy_archive_layout,
    write_qd_summary_files,
)
from revolution.qd.descriptors import (
    descriptor_requirements,
    extract_descriptor_values,
    load_qwen_projection_artifact_path,
    load_sr_pca_artifact_path,
    load_sr_vq_artifact_path,
    resolve_descriptor_axes,
    resolve_grid_axis_specs,
)
from revolution.qwen_descriptor_evaluator import QwenCanonicalRTLEmbeddingEvaluator
from revolution.qd.scoring import compute_ppa_gains
from revolution.qd.scheduler import (
    QDBudgetSplit,
    qd_fail_share,
    qd_target_cells,
    split_qd_budget,
)
from revolution.qd.thought_only import (
    CodeSample,
    RepairKind,
    RepresentationKind,
    ThoughtEvaluation,
    ThoughtIndividual,
    parse_thought_spec,
    render_thought_spec,
)
from revolution.qd.types import (
    ArchiveMember,
    GlobalParetoInsertResult,
    QDArchiveInsertResult,
    QDCellMode,
    QDObjectiveMode,
    QDRebinningKind,
    RankedArchiveMember,
)
from revolution.runtime.problem_spec import CircuitType
from revolution.qd.visualization import write_grid_quantile_visualizations_from_artifacts
from scipy.stats import ks_2samp


_ARCHIVE_ONLY_DESCRIPTOR_PROFILES = {"journal_logic_ff_width_3d"}
JournalParentSource = Literal["archive", "fail_pool", "seed"]
QDOperatorKind = Literal["eoh_strategies", "single_thought_operator"]
QDTwoParentGate = Literal["none", "near_front_descriptor"]
QDParentSelection = Literal[
    "cell_crowded_tournament",
    "front_slot_lane_nsga2",
    "nsga2_global_rank",
    "sparse_front_triggered_nsga2",
]
NEAR_FRONT_DESCRIPTOR_DISTANCE_SQ = 6.75
FRONT_SLOT_LANE_FRACTION = 0.10
SPARSE_FRONT_TRIGGER_CHAMPION_LANE_FRACTION = 0.65
SPARSE_FRONT_TRIGGER_MIN_OCCUPIED_CELLS = 4
SPARSE_FRONT_TRIGGER_MIN_EXTRA_FRONT_SLOTS = 2
SINGLE_THOUGHT_OPERATOR_STRATEGY = "single_thought_operator"
THOUGHT_ONLY_CODE_STRATEGY = "thought_only_code"


class QDEngine(EoHEngine):
    """Archive-selectable QD engine that reuses the existing REvolution stack."""

    def __init__(
        self,
        *args: Any,
        qd_archive_type: str = "grid",
        qd_num_cells: int = 64,
        qd_fill_target_fraction: float = 0.25,
        qd_improve_backfill_fraction: float = 0.20,
        qd_cell_reservoir: int = 2,
        qd_cell_mode: str = "scalar_elite",
        qd_max_elites_per_cell: int = 1,
        qd_objectives: str = "ppa",
        qd_two_parent_probability: float = 0.5,
        qd_two_parent_gate: str = "none",
        qd_cvt_warmup_successes: int | None = None,
        qd_grid_quantile_warmup_successes: int = 20,
        qd_grid_quantile_warmup_max_buffer: int = 0,
        qd_grid_quantile_adaptive_warmup_successes: int = 0,
        qd_grid_quantile_adaptive_warmup_generation: int = 1,
        qd_adaptive_warmup_champion_lane_fraction: float | None = None,
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
        qd_operator_kind: str = "eoh_strategies",
        qd_operator_one_parent_fraction: float = 0.5,
        qd_operator_archive_context_size: int = 4,
        qd_operator_fail_feedback_chars: int = 0,
        qd_operator_two_parent_allow_intra_bin: bool = True,
        qd_rebinning_kind: str = "disabled",
        qd_rebinning_recent_generations: int = 3,
        qd_rebinning_min_archive_members: int = 20,
        qd_rebinning_cooldown_generations: int = 3,
        qd_rebinning_base_p_threshold: float = 0.05,
        representation_kind: str = "code_individual",
        code_samples_per_thought: int = 4,
        qd_thought_code_seeded: bool = False,
        qd_seed_sample_fraction: float = 1.0,
        qd_champion_lane_fraction: float = 0.0,
        qd_front_slot_lane_fraction: float = FRONT_SLOT_LANE_FRACTION,
        qd_parent_selection: str = "cell_crowded_tournament",
        representative_sample: str = "best_successful_quality",
        repair_kind: str = "none",
        repair_max_attempts_per_sample: int = 0,
        repair_max_attempts_per_thought: int = 0,
        repair_evidence: str = "stage_scoped_logs",
        **kwargs: Any,
    ) -> None:
        super().__init__(*args, **kwargs)
        self.qd_archive_type = qd_archive_type
        self.qd_num_cells = max(1, int(qd_num_cells))
        self.qd_fill_target_fraction = float(qd_fill_target_fraction)
        if not 0.0 <= float(qd_improve_backfill_fraction) <= 1.0:
            raise ValueError("qd_improve_backfill_fraction must be in [0, 1].")
        self.qd_improve_backfill_fraction = float(qd_improve_backfill_fraction)
        self.qd_cell_reservoir = max(0, int(qd_cell_reservoir))
        if qd_cell_mode not in {"scalar_elite", "pareto_front", "elite_pareto_slot"}:
            raise ValueError(f"Unsupported qd_cell_mode '{qd_cell_mode}'.")
        if qd_objectives != "ppa":
            raise ValueError(f"Unsupported qd_objectives '{qd_objectives}'.")
        if qd_max_elites_per_cell <= 0:
            raise ValueError("qd_max_elites_per_cell must be > 0.")
        if qd_cell_mode == "elite_pareto_slot" and qd_max_elites_per_cell < 2:
            raise ValueError("elite_pareto_slot requires qd_max_elites_per_cell >= 2.")
        if not 0.0 <= float(qd_two_parent_probability) <= 1.0:
            raise ValueError("qd_two_parent_probability must be between 0 and 1.")
        if qd_two_parent_gate not in {"none", "near_front_descriptor"}:
            raise ValueError(f"Unsupported qd_two_parent_gate '{qd_two_parent_gate}'.")
        if qd_operator_kind not in {"eoh_strategies", "single_thought_operator"}:
            raise ValueError(f"Unsupported qd_operator_kind '{qd_operator_kind}'.")
        if not 0.0 <= float(qd_operator_one_parent_fraction) <= 1.0:
            raise ValueError("qd_operator_one_parent_fraction must be between 0 and 1.")
        if qd_operator_archive_context_size < 0:
            raise ValueError("qd_operator_archive_context_size must be >= 0.")
        if qd_operator_fail_feedback_chars < 0:
            raise ValueError("qd_operator_fail_feedback_chars must be >= 0.")
        if qd_rebinning_kind not in {"disabled", "ks_triggered"}:
            raise ValueError(f"Unsupported qd_rebinning_kind '{qd_rebinning_kind}'.")
        if qd_rebinning_kind == "ks_triggered":
            if qd_rebinning_recent_generations <= 0:
                raise ValueError("qd_rebinning_recent_generations must be > 0.")
            if qd_rebinning_min_archive_members <= 0:
                raise ValueError("qd_rebinning_min_archive_members must be > 0.")
            if qd_rebinning_cooldown_generations <= 0:
                raise ValueError("qd_rebinning_cooldown_generations must be > 0.")
            if not 0.0 < float(qd_rebinning_base_p_threshold) < 1.0:
                raise ValueError("qd_rebinning_base_p_threshold must be between 0 and 1.")
        if representation_kind not in {"code_individual", "thought_only"}:
            raise ValueError(f"Unsupported representation_kind '{representation_kind}'.")
        if code_samples_per_thought <= 0:
            raise ValueError("code_samples_per_thought must be > 0.")
        if representative_sample != "best_successful_quality":
            raise ValueError(
                "representative_sample must be 'best_successful_quality'."
            )
        if representation_kind == "thought_only" and (
            self.population_size % int(code_samples_per_thought) != 0
        ):
            raise ValueError(
                "population_size must be divisible by code_samples_per_thought "
                "in thought_only mode"
            )
        if repair_kind not in {"none", "bounded_local_repair"}:
            raise ValueError(f"Unsupported repair_kind '{repair_kind}'.")
        if repair_max_attempts_per_sample < 0:
            raise ValueError("repair_max_attempts_per_sample must be >= 0.")
        if repair_max_attempts_per_thought < 0:
            raise ValueError("repair_max_attempts_per_thought must be >= 0.")
        if repair_evidence != "stage_scoped_logs":
            raise ValueError("repair_evidence must be 'stage_scoped_logs'.")
        if repair_kind == "none" and (
            repair_max_attempts_per_sample != 0
            or repair_max_attempts_per_thought != 0
        ):
            raise ValueError("repair.kind none requires zero repair caps.")
        if repair_kind == "bounded_local_repair" and repair_max_attempts_per_thought <= 0:
            raise ValueError(
                "repair.kind bounded_local_repair requires max_attempts_per_thought > 0."
            )
        if repair_max_attempts_per_thought > (
            int(code_samples_per_thought) * int(repair_max_attempts_per_sample)
        ):
            raise ValueError(
                "repair_max_attempts_per_thought must be <= "
                "code_samples_per_thought * repair_max_attempts_per_sample."
            )
        self.qd_cell_mode: QDCellMode = cast(QDCellMode, qd_cell_mode)
        self.qd_max_elites_per_cell = int(qd_max_elites_per_cell)
        self.qd_objectives: QDObjectiveMode = cast(QDObjectiveMode, qd_objectives)
        self.qd_two_parent_probability = float(qd_two_parent_probability)
        self.qd_two_parent_gate: QDTwoParentGate = cast(
            QDTwoParentGate,
            qd_two_parent_gate,
        )
        self.qd_cvt_warmup_successes = qd_cvt_warmup_successes
        self.qd_grid_quantile_warmup_successes = int(qd_grid_quantile_warmup_successes)
        self.qd_grid_quantile_warmup_max_buffer = int(qd_grid_quantile_warmup_max_buffer)
        if qd_grid_quantile_adaptive_warmup_successes < 0:
            raise ValueError("qd_grid_quantile_adaptive_warmup_successes must be >= 0.")
        if qd_grid_quantile_adaptive_warmup_generation < 0:
            raise ValueError("qd_grid_quantile_adaptive_warmup_generation must be >= 0.")
        self.qd_grid_quantile_adaptive_warmup_successes = int(
            qd_grid_quantile_adaptive_warmup_successes
        )
        self.qd_grid_quantile_adaptive_warmup_generation = int(
            qd_grid_quantile_adaptive_warmup_generation
        )
        if qd_adaptive_warmup_champion_lane_fraction is not None and not (
            0.0 <= float(qd_adaptive_warmup_champion_lane_fraction) <= 1.0
        ):
            raise ValueError(
                "qd_adaptive_warmup_champion_lane_fraction must be in [0, 1]."
            )
        self.qd_adaptive_warmup_champion_lane_fraction = (
            None
            if qd_adaptive_warmup_champion_lane_fraction is None
            else float(qd_adaptive_warmup_champion_lane_fraction)
        )
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
        self.qd_operator_kind: QDOperatorKind = cast(QDOperatorKind, qd_operator_kind)
        self.qd_operator_one_parent_fraction = float(qd_operator_one_parent_fraction)
        self.qd_operator_archive_context_size = int(qd_operator_archive_context_size)
        self.qd_operator_fail_feedback_chars = int(qd_operator_fail_feedback_chars)
        self.qd_operator_two_parent_allow_intra_bin = bool(qd_operator_two_parent_allow_intra_bin)
        self.qd_rebinning_kind: QDRebinningKind = cast(QDRebinningKind, qd_rebinning_kind)
        self.qd_rebinning_recent_generations = int(qd_rebinning_recent_generations)
        self.qd_rebinning_min_archive_members = int(qd_rebinning_min_archive_members)
        self.qd_rebinning_cooldown_generations = int(qd_rebinning_cooldown_generations)
        self.qd_rebinning_base_p_threshold = float(qd_rebinning_base_p_threshold)
        self.representation_kind: RepresentationKind = cast(
            RepresentationKind,
            representation_kind,
        )
        self.code_samples_per_thought = int(code_samples_per_thought)
        self.qd_thought_code_seeded = bool(qd_thought_code_seeded)
        if not 0.0 <= float(qd_seed_sample_fraction) <= 1.0:
            raise ValueError("qd_seed_sample_fraction must be in [0, 1].")
        self.qd_seed_sample_fraction = float(qd_seed_sample_fraction)
        if not 0.0 <= float(qd_champion_lane_fraction) <= 1.0:
            raise ValueError("qd_champion_lane_fraction must be in [0, 1].")
        self.qd_champion_lane_fraction = float(qd_champion_lane_fraction)
        if not 0.0 <= float(qd_front_slot_lane_fraction) <= 1.0:
            raise ValueError("qd_front_slot_lane_fraction must be in [0, 1].")
        self.qd_front_slot_lane_fraction = float(qd_front_slot_lane_fraction)
        if qd_parent_selection not in {
            "cell_crowded_tournament",
            "front_slot_lane_nsga2",
            "nsga2_global_rank",
            "sparse_front_triggered_nsga2",
        }:
            raise ValueError(
                f"Unsupported qd_parent_selection '{qd_parent_selection}'."
            )
        if (
            qd_parent_selection in {
                "front_slot_lane_nsga2",
                "sparse_front_triggered_nsga2",
            }
            and qd_cell_mode != "elite_pareto_slot"
        ):
            raise ValueError(
                f"{qd_parent_selection} requires elite_pareto_slot."
            )
        self.qd_parent_selection: QDParentSelection = cast(
            QDParentSelection,
            qd_parent_selection,
        )
        self.representative_sample = representative_sample
        self.thought_population_size = (
            self.population_size // self.code_samples_per_thought
            if self.representation_kind == "thought_only"
            else self.population_size
        )
        self.repair_kind: RepairKind = cast(RepairKind, repair_kind)
        self.repair_max_attempts_per_sample = int(repair_max_attempts_per_sample)
        self.repair_max_attempts_per_thought = int(repair_max_attempts_per_thought)
        self.repair_evidence = repair_evidence
        self.thought_evaluations: list[ThoughtEvaluation] = []
        self._thought_serial = 0
        self.success_strats = list(self._qd_success_strategies())
        self.success_strategy_stats = {
            strategy: {"count": 0, "value": 0.0}
            for strategy in self.success_strats
        }
        self.success_archive = self._build_archive()
        self.global_pareto_archive = self._build_global_archive()
        self.success_reservoir: dict[str, deque[Heuristic]] = {}
        self.qd_generation_history: list[dict[str, Any]] = []
        self.qd_descriptor_observations: list[dict[str, Any]] = []
        self.qd_success_parent_requests = 0
        self.qd_front_slot_lane_parent_requests = 0
        self.qd_front_slot_lane_parent_hits = 0
        self.qd_sparse_front_trigger_batches = 0
        self.qd_sparse_front_trigger_parent_requests = 0
        self.qd_two_parent_attempts = 0
        self.qd_two_parent_fallbacks = 0
        self.qd_two_parent_gate_attempts = 0
        self.qd_two_parent_gate_accepts = 0
        self.qd_two_parent_gate_rejects = 0
        self._pending_two_parent_gate_pair: list[Heuristic] | None = None
        self._archive_insertion_index = 0
        self._qd_rebin_recent_members: list[ArchiveMember] = []
        self._qd_rebin_replay_pool: dict[str, ArchiveMember] = {}
        self._qd_rebin_cooldown_remaining = 0
        self._qd_rebin_count = 0
        self._qd_last_rebin_axes: tuple[str, ...] = ()
        self._qd_last_rebin_generation: int | None = None
        self._qd_last_corrected_threshold: float | None = None
        self._sr_pca_artifact: SrPcaArtifact | None = None
        self._sr_vq_artifact: SrVqArtifact | None = None
        self._qwen_rtl_embedding_evaluator: QwenCanonicalRTLEmbeddingEvaluator | None = None

    def _uses_descriptor_guided_generation(self) -> bool:
        return self.qd_descriptor_profile not in _ARCHIVE_ONLY_DESCRIPTOR_PROFILES

    def _qd_success_strategies(self) -> tuple[EvolStrategyMethodSuccess, ...]:
        if self._uses_descriptor_guided_generation():
            return QD_SUCCESS_STRATEGIES
        return CLASSIC_SUCCESS_STRATEGIES

    def _circuit_type(self) -> CircuitType:
        if (
            self.problem_spec is not None
            and self.problem_spec.circuit_type in {"combinational", "sequential"}
        ):
            return self.problem_spec.circuit_type
        if self.ref_ppa_metrics.get("eff_clk_period", 0.0):
            return "sequential"
        return "combinational"

    def _objective_names(self) -> tuple[str, ...]:
        if self.qd_objectives == "ppa":
            objectives = active_ppa_objectives(self._circuit_type())
            if "g_T" in objectives and not self.ref_ppa_metrics.get("eff_clk_period", 0.0):
                return tuple(name for name in objectives if name != "g_T")
            return objectives
        raise ValueError(f"Unsupported qd_objectives '{self.qd_objectives}'.")

    def _resolve_grid_axes(
        self,
        explicit_grid_axes: tuple[str, ...] = (),
    ) -> tuple[str, ...]:
        return tuple(
            resolve_descriptor_axes(
                profile_name=self.qd_descriptor_profile,
                explicit_axes=explicit_grid_axes or self.qd_descriptor_axes or None,
                descriptor_file=self.qd_descriptor_file,
                archive_type="grid",
                circuit_type=self._circuit_type(),
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
        return GridArchive(
            axes,
            cell_mode=self.qd_cell_mode,
            max_elites_per_cell=self.qd_max_elites_per_cell,
            objective_names=self._objective_names(),
        )

    def _build_cvt_archive(self) -> CVTArchive:
        axes = resolve_descriptor_axes(
            profile_name=self.qd_descriptor_profile,
            explicit_axes=self.qd_cvt_axes or self.qd_descriptor_axes or None,
            descriptor_file=self.qd_descriptor_file,
            archive_type="cvt",
            circuit_type=self._circuit_type(),
        )
        return CVTArchive(
            axes=axes,
            num_cells=self.qd_num_cells,
            warmup_successes=self.qd_cvt_warmup_successes,
            cell_mode=self.qd_cell_mode,
            max_elites_per_cell=self.qd_max_elites_per_cell,
            objective_names=self._objective_names(),
        )

    def _build_grid_quantile_archive(self) -> GridQuantileArchive:
        axes = resolve_descriptor_axes(
            profile_name=self.qd_descriptor_profile,
            explicit_axes=self.qd_descriptor_axes or None,
            descriptor_file=self.qd_descriptor_file,
            archive_type="grid",
            circuit_type=self._circuit_type(),
        )
        return GridQuantileArchive(
            axes=axes,
            warmup_successes=self.qd_grid_quantile_warmup_successes,
            warmup_max_buffer=self.qd_grid_quantile_warmup_max_buffer,
            cell_mode=self.qd_cell_mode,
            max_elites_per_cell=self.qd_max_elites_per_cell,
            objective_names=self._objective_names(),
        )

    def _build_archive(self) -> GridArchive | CVTArchive | GridQuantileArchive:
        if self.qd_archive_type == "grid":
            return self._build_grid_archive()
        if self.qd_archive_type == "cvt":
            return self._build_cvt_archive()
        if self.qd_archive_type == "grid_quantile":
            return self._build_grid_quantile_archive()
        raise ValueError(f"Unsupported qd_archive_type '{self.qd_archive_type}'.")

    def _build_global_archive(self) -> GlobalParetoArchive | None:
        if self.qd_cell_mode in {"pareto_front", "elite_pareto_slot"}:
            return GlobalParetoArchive(self._objective_names())
        if self.qd_cell_mode == "scalar_elite":
            return None
        raise ValueError(f"Unsupported qd_cell_mode '{self.qd_cell_mode}'.")

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

    def _requires_graph_descriptor_metrics(self) -> bool:
        return bool(
            descriptor_requirements(self._archive_axes()).get("requires_graph_metrics")
        )

    def _requires_source_aligned_descriptor_metrics(self) -> bool:
        return bool(
            descriptor_requirements(self._archive_axes()).get(
                "requires_source_aligned_rtl"
            )
        )

    def _requires_auto_bd_hash_metrics(self) -> bool:
        return bool(
            descriptor_requirements(self._archive_axes()).get("requires_auto_bd_hash")
        )

    def _requires_auto_bd_motif_metrics(self) -> bool:
        return bool(
            descriptor_requirements(self._archive_axes()).get("requires_auto_bd_motif")
        )

    def _requires_auto_bd_stage_metrics(self) -> bool:
        return bool(
            descriptor_requirements(self._archive_axes()).get(
                "requires_auto_bd_stage_dumps"
            )
        )

    def _requires_auto_bd_sr_pca_metrics(self) -> bool:
        return bool(
            descriptor_requirements(self._archive_axes()).get("requires_auto_bd_sr_pca")
        )

    def _requires_auto_bd_sr_vq_metrics(self) -> bool:
        return bool(
            descriptor_requirements(self._archive_axes()).get("requires_auto_bd_sr_vq")
        )

    def _requires_qwen_rtl_embedding_metrics(self) -> bool:
        return bool(
            descriptor_requirements(self._archive_axes()).get(
                "requires_qwen_rtl_embedding"
            )
        )

    def _extract_candidate_qwen_rtl_metrics(self, cand: Heuristic) -> dict[str, float]:
        if not self._requires_qwen_rtl_embedding_metrics():
            return {}
        if self._qwen_rtl_embedding_evaluator is None:
            artifact_path = load_qwen_projection_artifact_path(self.qd_descriptor_file)
            self._qwen_rtl_embedding_evaluator = QwenCanonicalRTLEmbeddingEvaluator(
                artifact_path
            )
        return self._qwen_rtl_embedding_evaluator.extract_metrics(cand.code)

    def _load_sr_pca_artifact(self) -> SrPcaArtifact:
        if self._sr_pca_artifact is None:
            artifact_path = load_sr_pca_artifact_path(self.qd_descriptor_file)
            payload = json.loads(artifact_path.read_text(encoding="utf-8"))
            assert isinstance(payload, dict)
            self._sr_pca_artifact = sr_pca_artifact_from_json(payload)
        return self._sr_pca_artifact

    def _load_sr_vq_artifact(self) -> SrVqArtifact:
        if self._sr_vq_artifact is None:
            artifact_path = load_sr_vq_artifact_path(self.qd_descriptor_file)
            payload = json.loads(artifact_path.read_text(encoding="utf-8"))
            assert isinstance(payload, dict)
            self._sr_vq_artifact = sr_vq_artifact_from_json(payload)
        return self._sr_vq_artifact

    def _extract_candidate_descriptor_values(
        self,
        cand: Heuristic,
        synthesis_result: dict[str, Any],
    ) -> dict[str, float]:
        needs_hash = self._requires_auto_bd_hash_metrics()
        needs_motif = self._requires_auto_bd_motif_metrics()
        needs_stage = self._requires_auto_bd_stage_metrics()
        needs_sr_pca = self._requires_auto_bd_sr_pca_metrics()
        needs_sr_vq = self._requires_auto_bd_sr_vq_metrics()
        needs_qwen = self._requires_qwen_rtl_embedding_metrics()
        if not (
            needs_hash
            or needs_motif
            or needs_stage
            or needs_sr_pca
            or needs_sr_vq
            or needs_qwen
        ):
            return {}
        if not (
            synthesis_result.get("synthesis_success")
            and synthesis_result.get("ppa_success")
        ):
            return {}
        values: dict[str, float] = {}
        netlist_text: str | None = None
        raw_values: dict[str, float] | None = None
        if needs_qwen:
            values.update(self._extract_candidate_qwen_rtl_metrics(cand))
        if needs_hash or needs_motif or needs_sr_pca or needs_sr_vq:
            path = Path(str(synthesis_result["synthesized_netlist_path"]))
            assert path.is_file(), f"missing synthesized netlist: {path}"
            netlist_text = path.read_text(encoding="utf-8", errors="ignore")
            if needs_hash:
                values.update(
                    random_hash_descriptor_values(canonical_netlist_hash(netlist_text))
                )
            if needs_motif:
                values.update(motif_occupancy_descriptor_values(netlist_text))
        if needs_stage or needs_sr_pca or needs_sr_vq:
            if "stage_dump_verilog_paths" not in synthesis_result:
                code_file_path = self._refresh_candidate_code_path(cand)
                stage_dump_result = self.synthesis_evaluator.run_yosys_stage_dumps(
                    verilog_file=code_file_path,
                    synth_top_module_name=self._resolve_synthesis_top_module_name(),
                    output_directory=os.path.dirname(code_file_path),
                )
                synthesis_result.update(stage_dump_result)
                if not bool(stage_dump_result["stage_dump_success"]):
                    synthesis_result["ppa_success"] = False
                    return {}
            stage_paths = tuple(
                Path(str(path)) for path in synthesis_result["stage_dump_verilog_paths"]
            )
            if needs_stage:
                values.update(synthesis_trajectory_descriptor_values(stage_paths))
            if needs_sr_pca or needs_sr_vq:
                assert netlist_text is not None
                raw_values = sr_raw_feature_values(
                    final_netlist_text=netlist_text,
                    stage_verilog_paths=stage_paths,
                )
            if needs_sr_pca:
                artifact = self._load_sr_pca_artifact()
                assert raw_values is not None
                projected = transform_sr_raw_pca(artifact, raw_values)
                for axis, value in zip(
                    SR_PCA_AXES[: len(projected)],
                    projected,
                    strict=True,
                ):
                    values[axis] = value
            if needs_sr_vq:
                artifact = self._load_sr_vq_artifact()
                assert raw_values is not None
                projected = transform_sr_vq(artifact, raw_values)
                for axis, value in zip(
                    SR_VQ_AXES[: len(projected)],
                    projected,
                    strict=True,
                ):
                    values[axis] = value
        return values

    def _phase_mode(self, phase: str) -> Literal["whole", "diff"]:
        if not self._uses_descriptor_guided_generation():
            return self.generation_mode
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
        descriptor_metrics.update(getattr(candidate, "graph_metrics", {}) or {})
        descriptor_metrics.update(getattr(candidate, "physical_metrics", {}) or {})
        descriptor_metrics.update(getattr(candidate, "descriptor_values", {}) or {})
        descriptor_metrics.update(gains)
        descriptor_values = extract_descriptor_values(descriptor_metrics, axes)
        return tuple(float(descriptor_values[axis]) for axis in axes)

    def _archive_member(
        self,
        candidate: Heuristic,
        descriptors: tuple[float, ...],
    ) -> ArchiveMember:
        gains = compute_ppa_gains(candidate.ppa_metrics, self.ref_ppa_metrics)
        objective_names = self._objective_names()
        for name in objective_names:
            assert name in gains
        quality_score = getattr(candidate, "quality_score", None)
        if quality_score is None:
            quality_score = candidate.score
        insertion_index = getattr(candidate, "archive_insertion_index", None)
        assert insertion_index is not None
        return ArchiveMember(
            candidate_id=candidate.id,
            descriptors=descriptors,
            quality_score=float(quality_score),
            objectives={name: float(gains[name]) for name in objective_names},
            payload=candidate,
            insertion_index=int(insertion_index),
        )

    def _rebuild_archive_from_success_pool(self) -> None:
        self.success_archive = self._build_archive()
        self.global_pareto_archive = self._build_global_archive()
        self.success_reservoir = {}
        self.qd_descriptor_observations = []
        self._archive_insertion_index = 0
        self._qd_rebin_recent_members = []
        self._qd_rebin_replay_pool = {}
        self._qd_rebin_cooldown_remaining = 0
        self._qd_rebin_count = 0
        self._qd_last_rebin_axes = ()
        self._qd_last_rebin_generation = None
        self._qd_last_corrected_threshold = None
        for cand in self.success_pool:
            descriptors = self._descriptor_tuple(cand)
            if descriptors is None:
                continue
            self._assign_archive_indices(cand)
            member = self._archive_member(cand, descriptors)
            before_occupied = self.success_archive.occupied_count()
            before_qd_score = self._archive_qd_score()
            result = self.success_archive.insert(member)
            global_update = self._insert_global_pareto(member)
            self._record_rebin_sample(member, result)
            if isinstance(self.success_archive, GridQuantileArchive) and result.decision == "warmup_buffered":
                self.success_reservoir.setdefault(result.cell_id, deque(maxlen=1)).appendleft(cand)
            self._write_candidate_qd_event(
                cand,
                descriptor_tuple=descriptors,
                insert_result=result,
                global_update=global_update,
                before_occupied=before_occupied,
                after_occupied=self.success_archive.occupied_count(),
                before_qd_score=before_qd_score,
                after_qd_score=self._archive_qd_score(),
            )
        if isinstance(self.success_archive, GridQuantileArchive) and self.success_archive.is_initialized:
            self._drop_warmup_reservoir()
        self.success_pool = self._success_view()

    def _archive_elites(self) -> list[Heuristic]:
        elites = [member.payload for _, member in self.success_archive.members()]
        elites.sort(key=lambda cand: cand.score, reverse=True)
        return elites

    def _archive_entries(self) -> list[tuple[str, Any]]:
        return sorted(self.success_archive.entries().items(), key=lambda item: item[0])

    def _archive_members(self) -> list[tuple[str, ArchiveMember]]:
        return self.success_archive.members()

    def _archive_ranked_members(self) -> list[tuple[str, RankedArchiveMember]]:
        return self.success_archive.ranked_members()

    def _archive_initialized_for_rebinning(self) -> bool:
        if isinstance(self.success_archive, GridArchive):
            return True
        if isinstance(self.success_archive, GridQuantileArchive):
            return self.success_archive.is_initialized
        if isinstance(self.success_archive, CVTArchive):
            return self.success_archive.is_initialized
        raise ValueError(f"Unsupported qd_archive_type '{self.qd_archive_type}'.")

    def _record_rebin_sample(
        self,
        member: ArchiveMember,
        result: QDArchiveInsertResult,
    ) -> None:
        _ = result
        self._qd_rebin_recent_members.append(member)
        self._qd_rebin_replay_pool[member.candidate_id] = member

    def _recent_rebin_samples(self) -> list[ArchiveMember]:
        min_generation = self.current_generation - self.qd_rebinning_recent_generations + 1
        self._qd_rebin_recent_members = [
            member
            for member in self._qd_rebin_recent_members
            if int(getattr(member.payload, "generation", 0)) >= min_generation
        ]
        return list(self._qd_rebin_recent_members)

    def _rebin_replay_members(
        self,
        archive_members: list[ArchiveMember],
    ) -> list[ArchiveMember]:
        for member in archive_members:
            self._qd_rebin_replay_pool.setdefault(member.candidate_id, member)
        return sorted(
            self._qd_rebin_replay_pool.values(),
            key=lambda member: (member.insertion_index, member.candidate_id),
        )

    def _geometry_id(self, geometry: dict[str, Any]) -> str:
        encoded = json.dumps(geometry, sort_keys=True, separators=(",", ":")).encode(
            "utf-8"
        )
        return hashlib.sha256(encoded).hexdigest()

    def _append_rebin_history_event(self, event: dict[str, Any]) -> None:
        path = self._archive_history_path()
        if path is None:
            return
        append_archive_history(path=path, snapshot=event)

    def _ks_axis_results(
        self,
        archive_members: list[ArchiveMember],
        recent_samples: list[ArchiveMember],
    ) -> list[dict[str, Any]]:
        results: list[dict[str, Any]] = []
        for index, axis in enumerate(self._archive_axes()):
            archive_values = [
                float(member.descriptors[index])
                for member in archive_members
                if math.isfinite(float(member.descriptors[index]))
            ]
            recent_values = [
                float(member.descriptors[index])
                for member in recent_samples
                if math.isfinite(float(member.descriptors[index]))
            ]
            if not archive_values or not recent_values:
                continue
            ks_statistic, ks_p_value = cast(
                tuple[float, float],
                ks_2samp(archive_values, recent_values),
            )
            results.append(
                {
                    "axis": axis,
                    "archive_count": len(archive_values),
                    "recent_count": len(recent_values),
                    "ks_statistic": float(ks_statistic),
                    "ks_p_value": float(ks_p_value),
                }
            )
        return results

    def _record_rebin_reservoir(
        self,
        member: ArchiveMember,
        result: QDArchiveInsertResult,
    ) -> None:
        if result.replaced:
            for payload in result.removed_payloads:
                previous_payload = cast(Heuristic | None, payload)
                if previous_payload is not None:
                    self._record_reservoir_candidate(result.cell_id, previous_payload)
            return
        if result.inserted:
            return
        self._record_reservoir_candidate(result.cell_id, cast(Heuristic, member.payload))

    def _maybe_adaptive_rebin(self) -> None:
        if self.qd_rebinning_kind == "disabled":
            return
        assert self.qd_rebinning_kind == "ks_triggered"
        if not self._archive_initialized_for_rebinning():
            return
        archive_members = [member for _, member in self._archive_members()]
        check_base = {
            "event_kind": "rebin_check",
            "event_type": "rebin_check",
            "generation": self.current_generation,
            "archive_type": self.qd_archive_type,
            "cell_mode": self.qd_cell_mode,
            "qd_rebinning_kind": self.qd_rebinning_kind,
            "recent_generations": self.qd_rebinning_recent_generations,
            "min_archive_members": self.qd_rebinning_min_archive_members,
            "base_p_threshold": self.qd_rebinning_base_p_threshold,
            "retained_member_count": len(archive_members),
            "replay_member_count": len(self._qd_rebin_replay_pool),
        }
        if self._qd_rebin_cooldown_remaining > 0:
            self._append_rebin_history_event(
                {
                    **check_base,
                    "check_status": "skipped_cooldown",
                    "cooldown_remaining": self._qd_rebin_cooldown_remaining,
                    "active_axis_count": 0,
                    "axis_results": [],
                    "trigger_axes": [],
                    "drift_detected": False,
                }
            )
            self._qd_rebin_cooldown_remaining -= 1
            return

        if len(archive_members) < self.qd_rebinning_min_archive_members:
            self._append_rebin_history_event(
                {
                    **check_base,
                    "check_status": "skipped_min_archive_members",
                    "active_axis_count": 0,
                    "axis_results": [],
                    "trigger_axes": [],
                    "drift_detected": False,
                }
            )
            return
        recent_samples = self._recent_rebin_samples()
        if not recent_samples:
            self._append_rebin_history_event(
                {
                    **check_base,
                    "check_status": "skipped_no_recent_samples",
                    "recent_sample_count": 0,
                    "active_axis_count": 0,
                    "axis_results": [],
                    "trigger_axes": [],
                    "drift_detected": False,
                }
            )
            return

        axis_results = self._ks_axis_results(archive_members, recent_samples)
        if not axis_results:
            self._append_rebin_history_event(
                {
                    **check_base,
                    "check_status": "skipped_no_active_axes",
                    "recent_sample_count": len(recent_samples),
                    "active_axis_count": 0,
                    "axis_results": [],
                    "trigger_axes": [],
                    "drift_detected": False,
                }
            )
            return
        corrected_threshold = self.qd_rebinning_base_p_threshold / len(axis_results)
        self._qd_last_corrected_threshold = corrected_threshold
        trigger_axes = tuple(
            str(result["axis"])
            for result in axis_results
            if float(result["ks_p_value"]) < corrected_threshold
        )
        check_event: dict[str, Any] = {
            **check_base,
            "check_status": "tested",
            "corrected_p_threshold": corrected_threshold,
            "active_axis_count": len(axis_results),
            "axis_results": axis_results,
            "trigger_axes": list(trigger_axes),
            "drift_detected": bool(trigger_axes),
            "recent_sample_count": len(recent_samples),
        }
        self._append_rebin_history_event(check_event)
        if not trigger_axes:
            return

        replay_members = self._rebin_replay_members(archive_members)
        old_geometry = self.success_archive.describe_space()
        old_active_ids = {member.candidate_id for member in archive_members}
        replay_results = self.success_archive.rebuild_from_records(
            replay_members,
            initialization_mode="adaptive_rebin",
        )
        self.success_reservoir = {}
        for member in replay_members:
            result = replay_results[member.candidate_id]
            self._record_rebin_reservoir(member, result)
        self._qd_rebin_count += 1
        self._qd_last_rebin_axes = trigger_axes
        self._qd_last_rebin_generation = self.current_generation
        self._qd_rebin_cooldown_remaining = self.qd_rebinning_cooldown_generations
        self.success_pool = self._success_view()

        new_geometry = self.success_archive.describe_space()
        new_active_ids = {member.candidate_id for _, member in self._archive_members()}
        displaced_ids = {member.candidate_id for member in replay_members} - old_active_ids
        rebin_event = dict(check_event)
        rebin_event.update(
            {
                "event_kind": "rebin",
                "event_type": "rebin",
                "old_geometry_id": self._geometry_id(old_geometry),
                "new_geometry_id": self._geometry_id(new_geometry),
                "old_geometry": old_geometry,
                "new_geometry": new_geometry,
                "replay_member_count": len(replay_members),
                "replay_attempt_count": len(replay_results),
                "final_active_member_count": len(new_active_ids),
                "displaced_replay_member_count": len(displaced_ids),
                "reactivated_displaced_member_count": len(displaced_ids & new_active_ids),
                "cooldown_generations": self.qd_rebinning_cooldown_generations,
                "cooldown_remaining": self._qd_rebin_cooldown_remaining,
                "total_rebin_count": self._qd_rebin_count,
            }
        )
        self._append_rebin_history_event(rebin_event)

    def _insert_global_pareto(
        self,
        member: ArchiveMember,
    ) -> GlobalParetoInsertResult | None:
        if self.global_pareto_archive is None:
            return None
        return self.global_pareto_archive.insert(member)

    def _global_pareto_size(self) -> int:
        if self.global_pareto_archive is None:
            return 0
        return len(self.global_pareto_archive.members())

    def _record_reservoir_candidate(self, cell_id: str, candidate: Heuristic) -> None:
        if self.qd_cell_reservoir <= 0:
            return
        bucket = self.success_reservoir.setdefault(
            cell_id,
            deque(maxlen=self.qd_cell_reservoir),
        )
        bucket.appendleft(candidate)

    def _drop_warmup_reservoir(self) -> None:
        for cell_id in list(self.success_reservoir):
            if cell_id.startswith("warmup:"):
                del self.success_reservoir[cell_id]

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
        global_update: GlobalParetoInsertResult | None,
        before_occupied: int,
        after_occupied: int,
        before_qd_score: float,
        after_qd_score: float,
    ) -> None:
        self.qd_descriptor_observations.append(
            {
                "candidate_id": candidate.id,
                "generation": candidate.generation,
                "strategy": candidate.strategy,
                "decision": insert_result.decision,
                "cell_mode": self.qd_cell_mode,
                "objective_names": list(insert_result.objective_names),
                "objectives": dict(insert_result.objectives or {}),
                "cell_id": insert_result.cell_id,
                "front_size": insert_result.front_size,
                "cell_member_count": insert_result.front_size,
                "pareto_rank": insert_result.pareto_rank,
                "crowding_distance": insert_result.crowding_distance,
                "parent_count": getattr(candidate, "parent_count", None),
                "requested_parent_count": getattr(
                    candidate,
                    "requested_parent_count",
                    getattr(candidate, "parent_count", None),
                ),
                "parent_arity": len(getattr(candidate, "parent_ids", [])),
                "global_archive_size": (
                    global_update.archive_size if global_update is not None else None
                ),
                "descriptor_values": {
                    axis: float(value)
                    for axis, value in zip(self._archive_axes(), descriptor_tuple)
                },
                "quality_score": float(getattr(candidate, "quality_score", candidate.score)),
                "generation_candidate_index": getattr(candidate, "generation_candidate_index", None),
                "archive_insertion_index": getattr(candidate, "archive_insertion_index", None),
            }
        )
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
            space_reference_file=self._archive_space_json_path(),
            global_update=global_update,
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
        if self.qd_archive_type == "grid":
            filename = "grid_layout.json"
        elif self.qd_archive_type == "cvt":
            filename = "centroids.json"
        elif self.qd_archive_type == "grid_quantile":
            filename = "grid_quantile_layout.json"
        else:
            raise ValueError(f"Unsupported qd_archive_type '{self.qd_archive_type}'.")
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

    def _global_pareto_archive_path(self) -> str | None:
        log_dir = self._qd_log_dir()
        if log_dir is None:
            return None
        return os.path.join(log_dir, "global_pareto_archive.csv")

    def _global_pareto_summary_path(self) -> str | None:
        log_dir = self._qd_log_dir()
        if log_dir is None:
            return None
        return os.path.join(log_dir, "global_pareto_summary.json")

    def _global_pareto_history_path(self) -> str | None:
        log_dir = self._qd_log_dir()
        if log_dir is None:
            return None
        return os.path.join(log_dir, "global_pareto_history.jsonl")

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

    def _descriptor_health_json_path(self) -> str | None:
        log_dir = self._qd_log_dir()
        if log_dir is None:
            return None
        return os.path.join(log_dir, "descriptor_health.json")

    def _descriptor_health_report_path(self) -> str | None:
        log_dir = self._qd_log_dir()
        if log_dir is None:
            return None
        return os.path.join(log_dir, "descriptor_health_report.md")

    def _archive_qd_score(self) -> float:
        return sum(float(entry.quality_score) for entry in self.success_archive.entries().values())

    def _assign_archive_indices(self, candidate: Heuristic) -> None:
        self._archive_insertion_index += 1
        candidate.archive_insertion_index = self._archive_insertion_index
        if candidate.generation_candidate_index is not None:
            return
        candidate.generation_candidate_index = self._parse_generation_candidate_index(
            candidate
        )

    def _parse_generation_candidate_index(self, candidate: Heuristic) -> int | None:
        code_path = getattr(candidate, "code_file_path", "")
        if not code_path:
            return None
        basename = os.path.basename(os.path.dirname(code_path))
        match = re.search(r"(?:^|_)sample(\d+)(?:_|$)", basename)
        if match is None:
            return None
        return int(match.group(1))

    def _gain_stats(self) -> dict[str, float]:
        members = [member for _, member in self._archive_members()]
        if not members:
            return {
                "best_g_P": 0.0,
                "best_g_A": 0.0,
                "best_g_T": 0.0,
                "mean_g_P": 0.0,
                "mean_g_A": 0.0,
                "mean_g_T": 0.0,
            }
        metrics: dict[str, float] = {}
        for axis in ("g_P", "g_A", "g_T"):
            values = [float(member.objectives.get(axis, 0.0)) for member in members]
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
        members = self._archive_members()
        qualities = [float(entry.quality_score) for _, entry in entries]
        occupied = self.success_archive.occupied_count()
        front_sizes: dict[str, int] = defaultdict(int)
        for cell_id, _ in members:
            front_sizes[cell_id] += 1
        total_members = len(members)
        coverage = occupied / max(self.success_archive.num_cells, 1)
        archive_initialized = not (
            isinstance(self.success_archive, GridQuantileArchive)
            and not self.success_archive.is_initialized
        )
        coverage_fail_share = None
        p_fail_cap = None
        if budget is None and archive_initialized:
            coverage_fail_share = qd_fail_share(
                occupied_cells=occupied,
                num_cells=self.success_archive.num_cells,
                fill_target_fraction=self.qd_fill_target_fraction,
            )
            p_fail_cap = self._fail_pool_archive_member_ratio()
        snapshot = {
            "generation": self.current_generation,
            "archive_type": self.qd_archive_type,
            "cell_mode": self.qd_cell_mode,
            "max_elites_per_cell": self.qd_max_elites_per_cell,
            "objective_names": list(self._objective_names()),
            "occupied_cells": occupied,
            "total_archive_members": total_members,
            "archive_member_count": total_members,
            "fail_pool_size": len(self.fail_pool),
            "success_pool_size": len(self.success_pool),
            "mean_front_size": (
                total_members / len(front_sizes) if front_sizes else 0.0
            ),
            "max_front_size": max(front_sizes.values()) if front_sizes else 0,
            "global_pareto_size": self._global_pareto_size(),
            "success_parent_requests": self.qd_success_parent_requests,
            "qd_parent_selection": self.qd_parent_selection,
            "front_slot_lane_fraction": self.qd_front_slot_lane_fraction,
            "front_slot_lane_parent_requests": (
                self.qd_front_slot_lane_parent_requests
            ),
            "front_slot_lane_parent_hits": self.qd_front_slot_lane_parent_hits,
            "sparse_front_trigger_batches": self.qd_sparse_front_trigger_batches,
            "sparse_front_trigger_parent_requests": (
                self.qd_sparse_front_trigger_parent_requests
            ),
            "sparse_front_trigger_champion_lane_fraction": (
                SPARSE_FRONT_TRIGGER_CHAMPION_LANE_FRACTION
            ),
            "two_parent_attempts": self.qd_two_parent_attempts,
            "two_parent_fallbacks": self.qd_two_parent_fallbacks,
            "qd_two_parent_probability": self.qd_two_parent_probability,
            "qd_two_parent_gate": self.qd_two_parent_gate,
            "two_parent_gate_attempts": self.qd_two_parent_gate_attempts,
            "two_parent_gate_accepts": self.qd_two_parent_gate_accepts,
            "two_parent_gate_rejects": self.qd_two_parent_gate_rejects,
            "num_cells": self.success_archive.num_cells,
            "fill_target_cells": qd_target_cells(
                self.success_archive.num_cells,
                self.qd_fill_target_fraction,
            ),
            "qd_improve_backfill_fraction": self.qd_improve_backfill_fraction,
            "coverage": coverage,
            "coverage_fail_share": coverage_fail_share,
            "p_fail_cap": p_fail_cap,
            "qd_score": sum(qualities),
            "best_quality": max(qualities) if qualities else None,
            "mean_quality": (sum(qualities) / len(qualities)) if qualities else None,
            "new_filled_cells": max(inserted - replaced, 0),
            "new_archive_members": inserted,
            "replaced_cells": replaced,
            "runtime_seconds": runtime_sec,
            "qd_rebinning_kind": self.qd_rebinning_kind,
            "qd_rebinning_recent_generations": self.qd_rebinning_recent_generations,
            "qd_rebinning_min_archive_members": self.qd_rebinning_min_archive_members,
            "qd_rebinning_cooldown_generations": self.qd_rebinning_cooldown_generations,
            "qd_rebinning_base_p_threshold": self.qd_rebinning_base_p_threshold,
            "total_rebin_count": self._qd_rebin_count,
            "last_rebin_generation": self._qd_last_rebin_generation,
            "last_corrected_p_threshold": self._qd_last_corrected_threshold,
            "rebin_cooldown_remaining": self._qd_rebin_cooldown_remaining,
            "last_rebin_axes": list(self._qd_last_rebin_axes),
            "rebin_recent_sample_count": len(self._recent_rebin_samples()),
            "rebin_replay_member_count": len(self._qd_rebin_replay_pool),
            "qd_grid_quantile_adaptive_warmup_successes": (
                self.qd_grid_quantile_adaptive_warmup_successes
            ),
            "qd_grid_quantile_adaptive_warmup_generation": (
                self.qd_grid_quantile_adaptive_warmup_generation
            ),
            "qd_adaptive_warmup_champion_lane_fraction": (
                self.qd_adaptive_warmup_champion_lane_fraction
            ),
            "representation_kind": self.representation_kind,
            "code_samples_per_thought": self.code_samples_per_thought,
            "thought_population_size": self.thought_population_size,
            "base_code_sample_budget_per_generation": self.population_size,
            "repair_kind": self.repair_kind,
            "repair_max_attempts_per_sample": self.repair_max_attempts_per_sample,
            "repair_max_attempts_per_thought": self.repair_max_attempts_per_thought,
        }
        if isinstance(self.success_archive, GridQuantileArchive):
            snapshot["grid_quantile_geometry"] = (
                self.success_archive.describe_history_geometry()
            )
        snapshot.update(self._gain_stats())
        if budget is not None:
            snapshot.update(
                {
                    "phase": budget.phase,
                    "total_budget": budget.total_budget,
                    "coverage_fail_share": budget.coverage_fail_share,
                    "p_fail_cap": budget.fail_share_cap,
                    "effective_fail_share": budget.fail_share,
                    "fail_share": budget.fail_share,
                    "fail_budget": budget.fail_budget,
                    "success_budget": budget.success_budget,
                    "seed_budget": budget.seed_budget,
                    "backfill_budget": budget.backfill_budget,
                    "refine_budget": budget.refine_budget,
                    "improve_backfill_fraction": budget.improve_backfill_fraction,
                    "planned_parent_source_counts": {
                        "archive": budget.backfill_budget + budget.refine_budget,
                        "fail_pool": budget.fail_budget,
                        "seed": budget.seed_budget,
                    },
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
            ranked_members=self._archive_ranked_members(),
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
        descriptor_health_json_path = self._descriptor_health_json_path()
        descriptor_health_report_path = self._descriptor_health_report_path()
        descriptor_health_files: tuple[str, str] | None = None
        if (
            descriptor_health_json_path is not None
            and descriptor_health_report_path is not None
        ):
            write_descriptor_health_files(
                json_path=descriptor_health_json_path,
                report_path=descriptor_health_report_path,
                archive=self.success_archive,
                descriptor_axes=self._archive_axes(),
                descriptor_profile=self.qd_descriptor_profile,
                observations=self.qd_descriptor_observations,
                recent_samples=self._recent_rebin_samples(),
            )
            descriptor_health_files = (
                os.path.basename(descriptor_health_json_path),
                os.path.basename(descriptor_health_report_path),
            )
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
            global_pareto_size=self._global_pareto_size(),
            descriptor_health_files=descriptor_health_files,
        )
        if space_json_path is not None and space_report_path is not None:
            write_archive_space_files(
                json_path=space_json_path,
                report_path=space_report_path,
                archive=self.success_archive,
                descriptor_profile=self.qd_descriptor_profile,
                descriptor_axes=self._archive_axes(),
                occupied_cells=self.success_archive.occupied_count(),
                rebinning={
                    "qd_rebinning_kind": self.qd_rebinning_kind,
                    "qd_rebinning_recent_generations": self.qd_rebinning_recent_generations,
                    "qd_rebinning_min_archive_members": self.qd_rebinning_min_archive_members,
                    "qd_rebinning_cooldown_generations": self.qd_rebinning_cooldown_generations,
                    "qd_rebinning_base_p_threshold": self.qd_rebinning_base_p_threshold,
                    "total_rebin_count": self._qd_rebin_count,
                    "last_rebin_generation": self._qd_last_rebin_generation,
                    "last_corrected_p_threshold": self._qd_last_corrected_threshold,
                    "last_rebin_axes": list(self._qd_last_rebin_axes),
                },
                visualization_files=visualization_artifacts.generated_files,
            )
            if isinstance(self.success_archive, GridQuantileArchive):
                write_grid_quantile_visualizations_from_artifacts(
                    self._qd_log_dir() or os.path.dirname(summary_path)
                )

    def _write_global_pareto_artifacts(
        self,
        snapshot: dict[str, Any] | None,
    ) -> None:
        if self.global_pareto_archive is None:
            return
        archive_path = self._global_pareto_archive_path()
        summary_path = self._global_pareto_summary_path()
        history_path = self._global_pareto_history_path()
        if archive_path is None or summary_path is None or history_path is None:
            return
        members = self.global_pareto_archive.members()
        write_global_pareto_archive_csv(
            path=archive_path,
            members=members,
            benchmark=self.benchmark_name,
            problem=self.problem_name,
        )
        write_global_pareto_summary(
            path=summary_path,
            members=members,
            objective_names=self._objective_names(),
        )
        if snapshot is None:
            return
        append_archive_history(
            path=history_path,
            snapshot={
                "generation": snapshot["generation"],
                "global_pareto_size": len(members),
                "objective_names": list(self._objective_names()),
            },
        )

    def _write_qd_artifacts(self, snapshot: dict[str, Any] | None = None) -> None:
        history_path = self._archive_history_path()
        if history_path is not None and not os.path.exists(history_path):
            open(history_path, "a", encoding="utf-8").close()
        self._write_archive_layout()
        self._write_archive_cells()
        self._write_global_pareto_artifacts(snapshot)
        if snapshot is not None:
            self._append_archive_history(snapshot)
        self._write_qd_summary_files()

    def _finalize_pending_archive(self) -> tuple[int, int] | None:
        if not isinstance(self.success_archive, CVTArchive | GridQuantileArchive):
            return None

        finalize_results = self.success_archive.finalize_pending()
        if not finalize_results:
            return None

        inserted = sum(1 for result in finalize_results.values() if result.inserted)
        replaced = sum(1 for result in finalize_results.values() if result.replaced)
        if isinstance(self.success_archive, GridQuantileArchive):
            self._drop_warmup_reservoir()
        self.success_pool = self._success_view()
        return inserted, replaced

    def _write_finalization_fallback_artifacts(
        self,
        *,
        inserted: int,
        replaced: int,
    ) -> None:
        if self.logger is None:
            return

        snapshot = self._build_qd_snapshot(
            inserted=inserted,
            replaced=replaced,
            budget=None,
            runtime_sec=time.time() - self.run_start_time,
        )
        snapshot["generation"] = self.current_generation + 1
        snapshot["phase"] = "run_finalization_fallback"
        self._write_qd_artifacts(snapshot)

    def initialize_population(self) -> None:
        if self.representation_kind == "thought_only":
            self._initialize_thought_population()
            self._rebuild_archive_from_success_pool()
            self._maybe_adaptive_warmup_fallback()
            return
        super().initialize_population()
        self._rebuild_archive_from_success_pool()
        self._maybe_adaptive_warmup_fallback()

    def _fail_pool_archive_member_ratio(self) -> float:
        """Return the initialized scheduler's fail-side parent-share cap."""

        fail_count = len(self.fail_pool)
        archive_member_count = len(self._archive_members())
        total = fail_count + archive_member_count
        if total == 0:
            return 0.0
        return fail_count / total

    def _journal_parent_source(self, candidate: Heuristic) -> JournalParentSource:
        if candidate.origin_pool == "fail_pool":
            return "fail_pool"
        if candidate.origin_pool == "initial":
            return "seed"
        if candidate.origin_pool == "success_pool":
            if candidate.strategy == "initial" and not candidate.parent_ids:
                return "seed"
            return "archive"
        raise ValueError(f"Unsupported origin_pool '{candidate.origin_pool}'.")

    def _journal_parent_source_counts(
        self,
        candidates: list[Heuristic],
    ) -> dict[JournalParentSource, int]:
        counts: dict[JournalParentSource, int] = {
            "archive": 0,
            "fail_pool": 0,
            "seed": 0,
        }
        for candidate in candidates:
            counts[self._journal_parent_source(candidate)] += 1
        return counts

    def _split_generation_budget(self) -> QDBudgetSplit:
        if isinstance(self.success_archive, GridQuantileArchive) and not self.success_archive.is_initialized:
            total_pool = len(self.fail_pool) + len(self.success_pool)
            if total_pool == 0:
                return QDBudgetSplit(
                    total_budget=self.num_offspring_lambda,
                    target_cells=self.success_archive.warmup_successes,
                    occupied_cells=self.success_archive.warmup_buffer_size(),
                    fail_share=0.0,
                    coverage_fail_share=None,
                    fail_share_cap=None,
                    fail_budget=0,
                    success_budget=self.num_offspring_lambda,
                    phase="warmup",
                    seed_budget=self.num_offspring_lambda,
                    backfill_budget=0,
                    refine_budget=0,
                )
            fail_budget = round(self.num_offspring_lambda * len(self.fail_pool) / total_pool)
            success_budget = self.num_offspring_lambda - fail_budget
            if self.fail_pool and self.success_pool:
                success_budget = max(success_budget, self.num_offspring_lambda // 2)
                fail_budget = self.num_offspring_lambda - success_budget
            return QDBudgetSplit(
                total_budget=self.num_offspring_lambda,
                target_cells=self.success_archive.warmup_successes,
                occupied_cells=self.success_archive.warmup_buffer_size(),
                fail_share=fail_budget / max(self.num_offspring_lambda, 1),
                coverage_fail_share=None,
                fail_share_cap=None,
                fail_budget=fail_budget,
                success_budget=success_budget,
                phase="warmup",
                seed_budget=0,
                backfill_budget=0,
                refine_budget=success_budget,
            )

        return split_qd_budget(
            total_budget=self.num_offspring_lambda,
            occupied_cells=self.success_archive.occupied_count(),
            num_cells=self.success_archive.num_cells,
            fill_target_fraction=self.qd_fill_target_fraction,
            fail_pool_empty=not bool(self.fail_pool),
            archive_empty=self.success_archive.occupied_count() == 0,
            empty_cells_remaining=self.success_archive.occupied_count() < self.success_archive.num_cells,
            fail_share_cap=self._fail_pool_archive_member_ratio(),
            improve_backfill_fraction=self.qd_improve_backfill_fraction,
        )

    def _split_thought_generation_budget(self) -> QDBudgetSplit:
        original_lambda = self.num_offspring_lambda
        try:
            self.num_offspring_lambda = self.thought_population_size
            return self._split_generation_budget()
        finally:
            self.num_offspring_lambda = original_lambda

    def _global_best_success_member(self) -> Heuristic | None:
        """Highest-quality archive member (the champion), for the champion
        lane (doc 15 Fix A) that biases a fraction of parents toward
        refining the current best instead of pure diverse-cell sampling."""
        best: Heuristic | None = None
        for _, member in self.success_archive.members():
            payload = member.payload
            if not isinstance(payload, Heuristic):
                continue
            if best is None or float(member.quality_score) > float(
                getattr(best, "quality_score", best.score)
            ):
                best = payload
        return best

    def _nsga2_global_pool(self) -> list[Heuristic]:
        """Global NSGA-II parent pool (smooth-QD V2, doc 16).

        Ranks ALL success members by global non-domination rank then crowding
        distance (reusing ``ranked_front``), fills rank-by-rank to
        ``population_size``, and crowding-trims the boundary front via the sort
        key. Unlike the per-cell crowded tournament, selection here is the
        classic NSGA-II environmental rule applied across the whole archive,
        answering the weighted-sum bias (#1) with principled multi-objective
        selection while preferring high-quality rank-1 individuals.
        """
        members = [member for _, member in self.success_archive.members()]
        if not members:
            return []
        ranked = ranked_front(members, self._objective_names())
        ranked.sort(
            key=lambda r: (
                r.pareto_rank,
                -r.crowding_distance,
                r.member.insertion_index,
                r.member.candidate_id,
            )
        )
        return [
            cast(Heuristic, r.member.payload) for r in ranked[: self.population_size]
        ]

    def _front_slot_pool(self) -> list[Heuristic]:
        if self.qd_cell_mode != "elite_pareto_slot":
            return []
        by_cell: dict[str, list[ArchiveMember]] = defaultdict(list)
        for cell_id, member in self._archive_members():
            by_cell[cell_id].append(member)

        slots: list[Heuristic] = []
        for members in by_cell.values():
            if len(members) < 2:
                continue
            elite = max(
                members,
                key=lambda member: (member.quality_score, -member.insertion_index),
            )
            ranked_slots = sorted(
                (
                    item
                    for item in ranked_front(members, self._objective_names())
                    if item.member is not elite
                ),
                key=lambda item: (
                    item.pareto_rank,
                    -item.crowding_distance,
                    item.member.insertion_index,
                    item.member.candidate_id,
                ),
            )
            for item in ranked_slots:
                slots.append(cast(Heuristic, item.member.payload))
        return slots

    def _sample_success_parents(self, count: int) -> list[Heuristic]:
        sparse_front_triggered = self._sparse_front_triggered()
        champion_lane_fraction = self._active_champion_lane_fraction()
        if self.qd_parent_selection in {
            "front_slot_lane_nsga2",
            "nsga2_global_rank",
            "sparse_front_triggered_nsga2",
        }:
            if sparse_front_triggered:
                self.qd_sparse_front_trigger_batches += 1
                self.qd_sparse_front_trigger_parent_requests += count
            front_slots = (
                self._front_slot_pool()
                if self.qd_parent_selection == "front_slot_lane_nsga2"
                else []
            )
            pool = self._nsga2_global_pool()
            if pool:
                champion = (
                    self._global_best_success_member()
                    if champion_lane_fraction > 0.0
                    else None
                )
                parents: list[Heuristic] = []
                for _ in range(count):
                    if (
                        self.qd_parent_selection == "front_slot_lane_nsga2"
                        and random.random() < self.qd_front_slot_lane_fraction
                    ):
                        self.qd_front_slot_lane_parent_requests += 1
                        if front_slots:
                            self.qd_front_slot_lane_parent_hits += 1
                            parents.append(random.choice(front_slots))
                            continue
                    if (
                        champion is not None
                        and random.random() < champion_lane_fraction
                    ):
                        parents.append(champion)  # champion lane: refine the best
                    else:
                        parents.append(random.choice(pool))
                return parents
        if self.qd_cell_mode in {"pareto_front", "elite_pareto_slot"}:
            by_cell = self._ranked_success_members_by_cell()
            if by_cell:
                cell_ids = sorted(by_cell)
                champion = (
                    self._global_best_success_member()
                    if champion_lane_fraction > 0.0
                    else None
                )
                parents: list[Heuristic] = []
                for _ in range(count):
                    if (
                        champion is not None
                        and random.random() < champion_lane_fraction
                    ):
                        parents.append(champion)  # champion lane: refine the best
                    else:
                        cell_id = random.choice(cell_ids)
                        parents.append(self._crowded_tournament(by_cell[cell_id]))
                return parents
        success_view = self._success_view()
        if not success_view:
            return []
        base = min(c.score for c in success_view)
        weights = [max(c.score - base + 0.1, 1e-6) for c in success_view]
        return random.choices(success_view, weights=weights, k=count)

    def _active_champion_lane_fraction(self) -> float:
        fraction = self._champion_lane_fraction()
        if self._sparse_front_triggered():
            return min(fraction, SPARSE_FRONT_TRIGGER_CHAMPION_LANE_FRACTION)
        return fraction

    def _champion_lane_fraction(self) -> float:
        if (
            self.qd_adaptive_warmup_champion_lane_fraction is not None
            and isinstance(self.success_archive, GridQuantileArchive)
            and self.success_archive.initialization_mode == "adaptive_sparse_yield_fallback"
        ):
            return self.qd_adaptive_warmup_champion_lane_fraction
        return self.qd_champion_lane_fraction

    def _sparse_front_triggered(self) -> bool:
        if self.qd_parent_selection != "sparse_front_triggered_nsga2":
            return False
        if self.qd_cell_mode != "elite_pareto_slot":
            return False
        if not self._archive_initialized_for_rebinning():
            return False
        occupied = self.success_archive.occupied_count()
        if occupied < SPARSE_FRONT_TRIGGER_MIN_OCCUPIED_CELLS:
            return False
        extra_front_slots = len(self._archive_members()) - occupied
        return extra_front_slots < SPARSE_FRONT_TRIGGER_MIN_EXTRA_FRONT_SLOTS

    def _ranked_success_members_by_cell(self) -> dict[str, list[RankedArchiveMember]]:
        by_cell: dict[str, list[RankedArchiveMember]] = defaultdict(list)
        for cell_id, ranked_member in self._archive_ranked_members():
            by_cell[cell_id].append(ranked_member)
        return by_cell

    def _crowded_tournament(
        self,
        members: list[RankedArchiveMember],
    ) -> Heuristic:
        if len(members) == 1:
            return cast(Heuristic, members[0].member.payload)
        contenders = random.sample(members, 2)
        winner = min(
            contenders,
            key=lambda item: (
                item.pareto_rank,
                -item.crowding_distance,
                item.member.insertion_index,
                item.member.candidate_id,
            ),
        )
        return cast(Heuristic, winner.member.payload)

    def _gated_near_front_descriptor_pair(self) -> list[Heuristic] | None:
        members = [member for _, member in self.success_archive.members()]
        ranked = ranked_front(members, self._objective_names())
        candidates: list[tuple[Heuristic, tuple[float, ...]]] = []
        for item in ranked:
            payload = item.member.payload
            if item.pareto_rank > 2 or not isinstance(payload, Heuristic):
                continue
            if not bool(payload.ppa_success):
                continue
            descriptors = self._descriptor_tuple(payload)
            if descriptors is None:
                continue
            candidates.append((payload, descriptors))

        pairs: list[list[Heuristic]] = []
        for left_index, (left, left_desc) in enumerate(candidates):
            for right, right_desc in candidates[left_index + 1 :]:
                distance = sum(
                    (left_value - right_value) ** 2
                    for left_value, right_value in zip(left_desc, right_desc)
                )
                if distance <= NEAR_FRONT_DESCRIPTOR_DISTANCE_SQ:
                    pairs.append([left, right])
        if not pairs:
            return None
        return random.choice(pairs)

    def _sample_two_success_parents(
        self,
        *,
        allow_intra_bin: bool = False,
    ) -> list[Heuristic]:
        if self.qd_two_parent_gate == "near_front_descriptor":
            if self._pending_two_parent_gate_pair is not None:
                parents = self._pending_two_parent_gate_pair
                self._pending_two_parent_gate_pair = None
                return parents
            parents = self._gated_near_front_descriptor_pair()
            return parents if parents is not None else self._sample_success_parents(1)
        if self.qd_parent_selection in {
            "front_slot_lane_nsga2",
            "nsga2_global_rank",
            "sparse_front_triggered_nsga2",
        }:
            return self._sample_success_parents(2)
        if self.qd_cell_mode not in {"pareto_front", "elite_pareto_slot"}:
            return self._sample_success_parents(2)
        by_cell = self._ranked_success_members_by_cell()
        cell_ids = sorted(by_cell)
        if not cell_ids:
            return []
        if allow_intra_bin:
            first_cell = random.choice(cell_ids)
            first = self._crowded_tournament(by_cell[first_cell])
            same_cell_alternatives = [
                ranked_member
                for ranked_member in by_cell[first_cell]
                if ranked_member.member.candidate_id != first.id
            ]
            if same_cell_alternatives:
                return [first, self._crowded_tournament(same_cell_alternatives)]
            other_cells = [cell_id for cell_id in cell_ids if cell_id != first_cell]
            if other_cells:
                second_cell = random.choice(other_cells)
                return [first, self._crowded_tournament(by_cell[second_cell])]
            return [first]
        if len(cell_ids) < 2:
            return self._sample_success_parents(1)
        first_cell = random.choice(cell_ids)
        second_cell = random.choice([cell_id for cell_id in cell_ids if cell_id != first_cell])
        return [
            self._crowded_tournament(by_cell[first_cell]),
            self._crowded_tournament(by_cell[second_cell]),
        ]

    def _success_parent_arity(self) -> int | None:
        self._pending_two_parent_gate_pair = None
        if self.qd_cell_mode not in {"pareto_front", "elite_pareto_slot"}:
            return None
        self.qd_success_parent_requests += 1
        if random.random() >= self.qd_two_parent_probability:
            return 1
        self.qd_two_parent_attempts += 1
        if self.success_archive.occupied_count() < 2:
            self.qd_two_parent_fallbacks += 1
            return 1
        if self.qd_two_parent_gate == "none":
            return 2
        self.qd_two_parent_gate_attempts += 1
        parents = self._gated_near_front_descriptor_pair()
        if parents is None:
            self.qd_two_parent_gate_rejects += 1
            self.qd_two_parent_fallbacks += 1
            return 1
        self.qd_two_parent_gate_accepts += 1
        self._pending_two_parent_gate_pair = parents
        return 2

    def _descriptor_distance(self, left: Heuristic, right: Heuristic) -> float:
        left_desc = self._descriptor_tuple(left)
        right_desc = self._descriptor_tuple(right)
        if left_desc is None or right_desc is None:
            return float("-inf")
        return sum((lhs - rhs) ** 2 for lhs, rhs in zip(left_desc, right_desc))

    def _sample_diverse_success_parents(self) -> list[Heuristic]:
        if self.qd_cell_mode in {"pareto_front", "elite_pareto_slot"}:
            return self._sample_two_success_parents()
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

    def _archive_context_sample(self, exclude_ids: set[str]) -> list[Heuristic]:
        """Sample compact thought context from archive members."""
        if self.qd_operator_archive_context_size == 0:
            return []
        candidates = [
            cast(Heuristic, member.payload)
            for _, member in self.success_archive.members()
            if isinstance(member.payload, Heuristic)
            and member.candidate_id not in exclude_ids
        ]
        if not candidates:
            return []
        sample_size = min(self.qd_operator_archive_context_size, len(candidates))
        return random.sample(candidates, sample_size)

    def _format_archive_context_entry(
        self,
        candidate: Heuristic,
    ) -> dict[str, Any]:
        entry: dict[str, Any] = {
            "thought": candidate.thought,
            "evaluation_status": (
                "succeeded"
                if candidate.status == "success" and candidate.ppa_success
                else "failed"
            ),
        }
        if candidate.status == "success" and candidate.ppa_success:
            entry["quality_score"] = float(
                getattr(candidate, "quality_score", candidate.score)
            )
        return entry

    def _format_parent_for_single_thought_operator(
        self,
        parent: Heuristic,
        example_num: int,
    ) -> dict[str, Any]:
        status = (
            "succeeded"
            if parent.status == "success" and parent.ppa_success
            else "failed"
        )
        payload: dict[str, Any] = {
            "example": example_num,
            "thought": parent.thought,
            "evaluation_status": status,
        }
        if status == "succeeded":
            gains = compute_ppa_gains(parent.ppa_metrics, self.ref_ppa_metrics)
            ppa_summary = {
                "quality_score": float(getattr(parent, "quality_score", parent.score)),
            }
            for objective_name in self._objective_names():
                if objective_name in gains:
                    ppa_summary[objective_name] = float(gains[objective_name])
            payload["ppa_summary"] = ppa_summary
        elif self.qd_operator_fail_feedback_chars > 0:
            payload["failure_stage"] = str(parent.status)
            feedback_text = str(getattr(parent, "feedback", "") or "").strip()
            if feedback_text:
                payload["failure_feedback"] = feedback_text[
                    : self.qd_operator_fail_feedback_chars
                ]
        return payload

    def _create_prompt_single_thought_operator(
        self,
        parents: list[Heuristic],
        *,
        archive_context: list[Heuristic] | None = None,
    ) -> str:
        """Create the unified journal thought-generation prompt."""
        if len(parents) not in {1, 2}:
            raise ValueError("single_thought_operator requires one or two parents.")
        parent_payloads = [
            self._format_parent_for_single_thought_operator(parent, index)
            for index, parent in enumerate(parents, start=1)
        ]
        context_obj: dict[str, Any] = {
            "task": SINGLE_THOUGHT_OPERATOR_STRATEGY,
            "parent_count": len(parents),
            "problem_description": self.problem_description,
        }
        if len(parent_payloads) == 1:
            context_obj["parent"] = parent_payloads[0]
        else:
            context_obj["parents"] = parent_payloads
        if archive_context is None:
            archive_context = self._archive_context_sample({parent.id for parent in parents})
        if archive_context:
            context_obj["archive_context"] = [
                self._format_archive_context_entry(candidate)
                for candidate in archive_context
            ]
        tpl = self.prompts.read("evolve/single_thought_operator/whole")
        if not tpl:
            raise FileNotFoundError(
                "Missing prompt template: "
                "evolve/single_thought_operator/whole"
            )
        return safe_format(tpl, context_json=json.dumps(context_obj, indent=2))

    def _thought_generation_system_prompt(self) -> str:
        prompt = self.prompts.read("system/thought_spec")
        if prompt:
            return prompt
        return (
            "You are an expert Verilog design strategist. Return exactly one "
            "valid JSON object with format thought_spec_v1 and no code."
        )

    def _next_thought_id(self) -> str:
        self._thought_serial += 1
        return f"g{self.current_generation:03d}_thought_{self._thought_serial:04d}"

    def _generation_dir(self, generation: int) -> str:
        model_name_cleaned = self.llm.model_name.replace("/", "_")
        path = os.path.join(
            self.base_save_path,
            model_name_cleaned,
            self.benchmark_name,
            self.problem_name,
            f"Gen{generation}",
        )
        os.makedirs(path, exist_ok=True)
        return path

    def _thought_dir(self, generation: int, thought_id: str) -> str:
        path = os.path.join(self._generation_dir(generation), thought_id)
        os.makedirs(path, exist_ok=True)
        return path

    def _write_json_file(self, path: str, payload: dict[str, Any]) -> None:
        with open(path, "w", encoding="utf-8") as f:
            json.dump(payload, f, indent=2)

    def _write_thought_artifacts(self, thought: ThoughtIndividual) -> None:
        thought_dir = self._thought_dir(thought.generation, thought.thought_id)
        self._write_json_file(
            os.path.join(thought_dir, "thought.json"),
            {
                "thought_id": thought.thought_id,
                "generation": thought.generation,
                "thought_spec": thought.thought_spec,
                "parent_ids": thought.parent_ids,
                "parent_count": thought.parent_count,
                "parent_source": thought.parent_source,
                "qd_operator_kind": thought.qd_operator_kind,
                "strategy": thought.strategy,
                "raw_response": thought.raw_response,
            },
        )
        with open(os.path.join(thought_dir, "thought.txt"), "w", encoding="utf-8") as f:
            f.write(render_thought_spec(thought.thought_spec))
        with open(
            os.path.join(thought_dir, "thought_prompt_snapshot.txt"),
            "w",
            encoding="utf-8",
        ) as f:
            f.write(thought.prompt_text)

    def _write_invalid_thought_artifacts(
        self,
        *,
        thought_id: str,
        generation: int,
        raw_response: str,
        errors: list[str],
        meta_rec: dict[str, Any],
    ) -> ThoughtEvaluation:
        thought_dir = self._thought_dir(generation, thought_id)
        payload = {
            "thought_id": thought_id,
            "generation": generation,
            "aggregate_status": "invalid_thought",
            "validation_errors": errors,
            "raw_response": raw_response,
            "parent_ids": [parent.id for parent in meta_rec.get("parents", [])],
            "parent_source": meta_rec["parent_source"],
            "strategy": meta_rec["strategy"],
        }
        self._write_json_file(os.path.join(thought_dir, "thought_validation_error.json"), payload)
        with open(
            os.path.join(thought_dir, "thought_prompt_snapshot.txt"),
            "w",
            encoding="utf-8",
        ) as f:
            f.write(meta_rec["prompt_text"])
        evaluation = ThoughtEvaluation(
            thought_id=thought_id,
            generation=generation,
            code_samples_per_thought=self.code_samples_per_thought,
            sample_ids=[],
            sample_statuses=[],
            success_count=0,
            success_rate=0.0,
            aggregate_status="invalid_thought",
            repair_kind=self.repair_kind,
            repair_attempts_used=0,
            representative_sample_id=None,
            representative_quality_score=None,
            representative_ppa_metrics={},
            representative_descriptor_values={},
            parent_ids=payload["parent_ids"],
            parent_source=meta_rec["parent_source"],
            strategy=meta_rec["strategy"],
            qd_operator_kind=self.qd_operator_kind,
            prompt_profile=self.prompts.profile,
            representation_kind=self.representation_kind,
            population_size=self.population_size,
            thought_population_size=self.thought_population_size,
            validation_errors=errors,
            repair_config=self._repair_config_dict(),
        )
        self._write_thought_evaluation(evaluation)
        return evaluation

    def _write_thought_evaluation(self, evaluation: ThoughtEvaluation) -> None:
        thought_dir = self._thought_dir(evaluation.generation, evaluation.thought_id)
        self._write_json_file(
            os.path.join(thought_dir, "thought_evaluation.json"),
            evaluation.to_json_dict(),
        )

    def _create_prompt_thought_only_seed(self) -> str:
        context_obj = {
            "task": "initial_thought",
            "problem_description": self.problem_description,
            "output_format": "thought_spec_v1",
        }
        tpl = self.prompts.read("thought_only/generate_thought")
        if tpl:
            return safe_format(tpl, context_json=json.dumps(context_obj, indent=2))
        return self._fallback_thought_prompt(context_obj)

    def _create_prompt_single_thought_operator_thought_only(
        self,
        parents: list[Heuristic],
        *,
        archive_context: list[Heuristic] | None = None,
    ) -> str:
        if len(parents) not in {1, 2}:
            raise ValueError("single_thought_operator requires one or two parents.")
        parent_payloads = [
            self._format_parent_for_single_thought_operator(parent, index)
            for index, parent in enumerate(parents, start=1)
        ]
        context_obj: dict[str, Any] = {
            "task": SINGLE_THOUGHT_OPERATOR_STRATEGY,
            "output_format": "thought_spec_v1",
            "parent_count": len(parents),
            "problem_description": self.problem_description,
        }
        if len(parent_payloads) == 1:
            context_obj["parent"] = parent_payloads[0]
        else:
            context_obj["parents"] = parent_payloads
        if archive_context is None:
            archive_context = self._archive_context_sample({parent.id for parent in parents})
        if archive_context:
            context_obj["archive_context"] = [
                self._format_archive_context_entry(candidate)
                for candidate in archive_context
            ]
        tpl = self.prompts.read("evolve/single_thought_operator/thought")
        if tpl:
            return safe_format(tpl, context_json=json.dumps(context_obj, indent=2))
        return self._fallback_thought_prompt(context_obj)

    def _create_prompt_eoh_thought_only(
        self,
        strategy: str,
        parents: list[Heuristic],
    ) -> str:
        context_obj: dict[str, Any] = {
            "task": "eoh_thought_only_adapter",
            "strategy": strategy,
            "output_format": "thought_spec_v1",
            "problem_description": self.problem_description,
            "parents": [
                self._format_parent_for_single_thought_operator(parent, index)
                for index, parent in enumerate(parents, start=1)
            ],
        }
        if len(parents) == 1:
            context_obj["parent"] = context_obj["parents"][0]
        tpl = self.prompts.read(f"evolve/{strategy}/thought")
        if tpl:
            return safe_format(tpl, context_json=json.dumps(context_obj, indent=2))
        return self._fallback_thought_prompt(context_obj)

    def _fallback_thought_prompt(self, context_obj: dict[str, Any]) -> str:
        return (
            "Create one detailed Verilog design thought for the problem.\n"
            "Use parent thoughts only as design-strategy hints. Do not use or "
            "invent parent code, feedback, logs, failure explanations, sibling "
            "sample details, or repair transcripts.\n\n"
            "CONTEXT_JSON:\n"
            f"{json.dumps(context_obj, indent=2)}\n\n"
            "Return exactly ONE JSON object and nothing else:\n"
            "{\n"
            '  "format": "thought_spec_v1",\n'
            '  "summary": "<one or two sentences naming the architecture>",\n'
            '  "interface_contract": "<module/interface behavior from the problem>",\n'
            '  "timing_and_protocol": "<reset, latency, handshakes, pulses, off-by-one boundaries>",\n'
            '  "state_and_datapath_plan": "<registers, counters, datapath operations, output derivation>",\n'
            '  "edge_cases": "<boundary values and rare states>",\n'
            '  "ppa_intent": "<area/timing/power choices after correctness>",\n'
            '  "implementation_constraints": "<single DUT module and benchmark constraints>"\n'
            "}\n"
            "Every field must be a meaningful non-empty string. If a detail is "
            "not specified, use an explicit justified placeholder such as "
            "\"not specified by problem; assume ...\". Do not include code."
        )

    def _best_parent_code(self, parents: list[Heuristic]) -> str:
        """Highest-quality successful parent's RTL, for code-seeded
        realization (doc 15 Fix B). Empty when no parent has working code."""
        coded = [
            p for p in parents
            if getattr(p, "status", None) == "success"
            and isinstance(getattr(p, "code", None), str)
            and p.code.strip()
        ]
        if not coded:
            return ""
        best = max(coded, key=lambda p: float(getattr(p, "quality_score", p.score)))
        return best.code

    def _create_prompt_thought_only_code_seeded(self, thought: ThoughtIndividual) -> str:
        """Thought-guided incremental realization: evolve the parent's
        working RTL toward the thought's intent, preserving compatible
        low-level structure (restores code-level hill-climbing)."""
        context_obj = {
            "task": "code_from_thought_seeded",
            "problem_description": self.problem_description,
            "thought_spec": thought.thought_spec,
            "thought_id": thought.thought_id,
            "parent_code": thought.parent_code,
        }
        tpl = self.prompts.read("thought_only/code/seeded")
        if tpl:
            return safe_format(tpl, context_json=json.dumps(context_obj, indent=2))
        return (
            "Evolve the parent RTL toward the design intent in thought_spec. "
            "The problem description is authoritative when it conflicts with "
            "the thought. Preserve and refine the parent's working low-level "
            "structure where compatible with the thought; rewrite only the "
            "parts the thought's architecture requires. Re-derive interface "
            "names, bit indexing, and value tables from the problem "
            "description, never the parent code.\n\n"
            "CONTEXT_JSON:\n"
            f"{json.dumps(context_obj, indent=2)}\n\n"
            "Return exactly ONE JSON object and nothing else:\n"
            "{\n"
            '  "format": "eoh_v1",\n'
            '  "mode": "whole",\n'
            '  "thought": "<brief note on what was preserved vs changed>",\n'
            '  "code": "<full, runnable Verilog as one JSON string>"\n'
            "}\n"
        )

    def _create_prompt_thought_only_code(self, thought: ThoughtIndividual) -> str:
        context_obj = {
            "task": "code_from_thought",
            "problem_description": self.problem_description,
            "thought_spec": thought.thought_spec,
            "thought_id": thought.thought_id,
        }
        tpl = self.prompts.read("thought_only/code/whole")
        if tpl:
            return safe_format(tpl, context_json=json.dumps(context_obj, indent=2))
        return (
            "Implement the RTL described by the thought_spec. The problem "
            "description is authoritative when it conflicts with the thought.\n\n"
            "CONTEXT_JSON:\n"
            f"{json.dumps(context_obj, indent=2)}\n\n"
            "Return exactly ONE JSON object and nothing else:\n"
            "{\n"
            '  "format": "eoh_v1",\n'
            '  "mode": "whole",\n'
            '  "thought": "<brief implementation rationale for this sample>",\n'
            '  "code": "<full, runnable Verilog as one JSON string>"\n'
            "}\n"
            "Do not include parent code, feedback, logs, repair transcripts, "
            "or sibling code samples."
        )

    def _create_prompt_thought_only_repair(
        self,
        thought: ThoughtIndividual,
        candidate: Heuristic,
    ) -> str:
        context_obj = {
            "task": "sample_local_repair",
            "problem_description": self.problem_description,
            "thought_spec": thought.thought_spec,
            "failure_stage": candidate.status,
            "sample_code": candidate.code,
            "sample_local_feedback": candidate.feedback,
        }
        tpl = self.prompts.read("thought_only/repair/whole")
        if tpl:
            return safe_format(tpl, context_json=json.dumps(context_obj, indent=2))
        return (
            "Repair this one code sample using only the thought_spec, the "
            "sample code, the coarse failure stage, and sample-local feedback.\n\n"
            "CONTEXT_JSON:\n"
            f"{json.dumps(context_obj, indent=2)}\n\n"
            "Return exactly ONE JSON object and nothing else:\n"
            "{\n"
            '  "format": "eoh_v1",\n'
            '  "mode": "whole",\n'
            '  "thought": "<repair rationale>",\n'
            '  "code": "<full repaired Verilog as one JSON string>"\n'
            "}"
        )

    def _build_thought_requests(
        self,
        budget: QDBudgetSplit,
    ) -> tuple[list[Any], list[dict[str, Any]]]:
        llm_requests: list[Any] = []
        request_meta: list[dict[str, Any]] = []

        for _ in range(budget.seed_budget):
            prompt_text = self._create_prompt_thought_only_seed()
            llm_requests.append(
                self._build_prompt_request(
                    prompt=prompt_text,
                    mode="whole",
                    system_prompt=self._thought_generation_system_prompt(),
                )
            )
            request_meta.append(
                {
                    "strategy": "initial",
                    "parents": [],
                    "parent_count": 0,
                    "requested_parent_count": 0,
                    "origin_pool": "initial",
                    "parent_source": "seed",
                    "prompt_text": prompt_text,
                }
            )

        if self.qd_operator_kind == "single_thought_operator":
            self._append_single_operator_thought_requests(
                budget,
                llm_requests,
                request_meta,
            )
            return llm_requests, request_meta

        self._append_eoh_thought_requests(budget, llm_requests, request_meta)
        return llm_requests, request_meta

    def _append_single_operator_thought_requests(
        self,
        budget: QDBudgetSplit,
        llm_requests: list[Any],
        request_meta: list[dict[str, Any]],
    ) -> None:
        if self.fail_pool and budget.fail_budget > 0:
            for _ in range(budget.fail_budget):
                parent = random.choice(self.fail_pool)
                prompt_text = self._create_prompt_single_thought_operator_thought_only(
                    [parent],
                    archive_context=self._archive_context_sample({parent.id}),
                )
                llm_requests.append(
                    self._build_prompt_request(
                        prompt=prompt_text,
                        mode="whole",
                        system_prompt=self._thought_generation_system_prompt(),
                    )
                )
                request_meta.append(
                    {
                        "strategy": SINGLE_THOUGHT_OPERATOR_STRATEGY,
                        "parents": [parent],
                        "parent_count": 1,
                        "requested_parent_count": 1,
                        "origin_pool": "fail_pool",
                        "parent_source": "fail_pool",
                        "prompt_text": prompt_text,
                    }
                )

        success_total_requests = budget.backfill_budget + budget.refine_budget
        for _ in range(success_total_requests):
            wants_two = random.random() >= self.qd_operator_one_parent_fraction
            requested_parent_count = 2 if wants_two else 1
            parents = (
                self._sample_two_success_parents(
                    allow_intra_bin=self.qd_operator_two_parent_allow_intra_bin,
                )
                if wants_two
                else self._sample_success_parents(1)
            )
            if wants_two and len(parents) < 2:
                parents = self._sample_success_parents(1)
            if not parents:
                break
            if len(parents) > 2:
                parents = parents[:2]
            if len(parents) == 2 and parents[0].id == parents[1].id:
                alternatives = [
                    cand for cand in self._success_view() if cand.id != parents[0].id
                ]
                if not alternatives:
                    parents = parents[:1]
                else:
                    parents[1] = random.choice(alternatives)
            prompt_text = self._create_prompt_single_thought_operator_thought_only(
                parents,
                archive_context=self._archive_context_sample(
                    {parent.id for parent in parents}
                ),
            )
            llm_requests.append(
                self._build_prompt_request(
                    prompt=prompt_text,
                    mode="whole",
                    system_prompt=self._thought_generation_system_prompt(),
                )
            )
            request_meta.append(
                {
                    "strategy": SINGLE_THOUGHT_OPERATOR_STRATEGY,
                    "parents": parents,
                    "parent_count": len(parents),
                    "requested_parent_count": requested_parent_count,
                    "origin_pool": "success_pool",
                    "parent_source": "archive",
                    "prompt_text": prompt_text,
                }
            )

    def _append_eoh_thought_requests(
        self,
        budget: QDBudgetSplit,
        llm_requests: list[Any],
        request_meta: list[dict[str, Any]],
    ) -> None:
        if self.fail_pool and budget.fail_budget > 0:
            fail_strategies: list[EvolStrategyMethodFail] = (
                list(CLASSIC_FAIL_STRATEGIES)
                if not self._uses_descriptor_guided_generation()
                else ["M-F", "M-E"]
            )
            fail_selected: set[EvolStrategyMethodFail] = set()
            for _ in range(budget.fail_budget):
                strat_name, _ = self._select_strategy(
                    "fail",
                    fail_strategies,
                    fail_selected,
                )
                if strat_name is None:
                    continue
                fail_selected.add(strat_name)
                parent = random.choice(self.fail_pool)
                prompt_text = self._create_prompt_eoh_thought_only(strat_name, [parent])
                llm_requests.append(
                    self._build_prompt_request(
                        prompt=prompt_text,
                        mode="whole",
                        system_prompt=self._thought_generation_system_prompt(),
                    )
                )
                request_meta.append(
                    {
                        "strategy": strat_name,
                        "parents": [parent],
                        "parent_count": 1,
                        "requested_parent_count": 1,
                        "origin_pool": "fail_pool",
                        "parent_source": "fail_pool",
                        "prompt_text": prompt_text,
                    }
                )

        success_selected: set[EvolStrategyMethodSuccess] = set()
        success_total_requests = budget.backfill_budget + budget.refine_budget
        for idx in range(success_total_requests):
            if self._uses_descriptor_guided_generation() and (
                budget.phase == "fill" or idx < budget.backfill_budget
            ):
                success_available = cast(list[EvolStrategyMethodSuccess], ["M-T", "M-E"])
                if len(self.success_pool) > 1:
                    success_available.append("C-D")
            else:
                success_available = cast(
                    list[EvolStrategyMethodSuccess],
                    ["M-S", "M-E", "M-R", "M-I"],
                )
                if len(self.success_pool) > 1:
                    success_available.append("C-F")
            strat_name, _ = self._select_strategy(
                "success",
                success_available,
                success_selected,
            )
            if strat_name is None:
                continue
            success_selected.add(strat_name)
            parents = (
                self._sample_diverse_success_parents()
                if strat_name == "C-D"
                else
                self._sample_two_success_parents()
                if strat_name == "C-F"
                else self._sample_success_parents(1)
            )
            if not parents:
                break
            if strat_name in {"C-D", "C-F"} and len(parents) < 2:
                continue
            prompt_text = self._create_prompt_eoh_thought_only(strat_name, parents)
            llm_requests.append(
                self._build_prompt_request(
                    prompt=prompt_text,
                    mode="whole",
                    system_prompt=self._thought_generation_system_prompt(),
                )
            )
            request_meta.append(
                {
                    "strategy": strat_name,
                    "parents": parents,
                    "parent_count": len(parents),
                    "requested_parent_count": len(parents),
                    "origin_pool": "success_pool",
                    "parent_source": "archive",
                    "prompt_text": prompt_text,
                }
            )

    def _materialize_thought(
        self,
        result: tuple[str | None, str | None, dict[str, Any]],
        meta_rec: dict[str, Any],
    ) -> tuple[ThoughtIndividual | None, ThoughtEvaluation | None]:
        thought_id = self._next_thought_id()
        thought_text, code_text, meta = result
        raw_response = str(meta.get("raw") or thought_text or code_text or "")
        thought_spec, errors = parse_thought_spec(raw_response)
        if thought_spec is None:
            invalid_eval = self._write_invalid_thought_artifacts(
                thought_id=thought_id,
                generation=self.current_generation,
                raw_response=raw_response,
                errors=errors,
                meta_rec=meta_rec,
            )
            return None, invalid_eval

        parents = meta_rec.get("parents", [])
        thought = ThoughtIndividual(
            thought_id=thought_id,
            generation=self.current_generation,
            thought_spec=thought_spec,
            raw_response=raw_response,
            parent_ids=[parent.id for parent in parents],
            parent_count=int(meta_rec["parent_count"]),
            parent_source=str(meta_rec["parent_source"]),
            qd_operator_kind=self.qd_operator_kind,
            strategy=str(meta_rec["strategy"]),
            prompt_text=str(meta_rec["prompt_text"]),
            parent_code=self._best_parent_code(parents),
        )
        self._write_thought_artifacts(thought)
        return thought, None

    def _save_thought_code_sample(
        self,
        *,
        thought: ThoughtIndividual,
        sample_index: int,
        code_content: str,
        prompt_text: str,
        meta: dict[str, Any],
    ) -> str:
        sample_dir = os.path.join(
            self._thought_dir(thought.generation, thought.thought_id),
            f"code_sample_{sample_index}",
        )
        os.makedirs(sample_dir, exist_ok=True)
        code_path = os.path.join(sample_dir, "code.sv")
        with open(code_path, "w", encoding="utf-8") as f:
            f.write(self._normalize_code_text(str(code_content)))
        with open(os.path.join(sample_dir, "thought.txt"), "w", encoding="utf-8") as f:
            f.write(render_thought_spec(thought.thought_spec))
        with open(
            os.path.join(sample_dir, "prompt_snapshot.txt"),
            "w",
            encoding="utf-8",
        ) as f:
            f.write(prompt_text)
        self._write_json_file(
            os.path.join(sample_dir, "prompt_snapshot.json"),
            {
                "strategy": THOUGHT_ONLY_CODE_STRATEGY,
                "thought_id": thought.thought_id,
                "sample_index": sample_index,
                "parent_ids": thought.parent_ids,
                "origin_pool": thought.parent_source,
                "resolved_mode": "whole",
            },
        )
        self._write_json_file(os.path.join(sample_dir, "llm_meta.json"), meta)
        self._copy_misc_files(sample_dir)
        return code_path

    def _materialize_code_sample(
        self,
        thought: ThoughtIndividual,
        sample_index: int,
        result: tuple[str | None, str | None, dict[str, Any]],
        prompt_text: str,
    ) -> Heuristic:
        sample_thought, code_content, meta = result
        is_format_ok = bool(meta.get("format_ok", False))
        material_to_save = code_content or meta.get("raw", "") or ""
        code_path = self._save_thought_code_sample(
            thought=thought,
            sample_index=sample_index,
            code_content=material_to_save,
            prompt_text=prompt_text,
            meta=meta,
        )
        if not is_format_ok and self.require_strict_format:
            self._save_format_error_artifacts(code_path, meta)
        origin_pool = {
            "seed": "initial",
            "archive": "success_pool",
            "fail_pool": "fail_pool",
        }[thought.parent_source]
        cand = Heuristic(
            thought=render_thought_spec(thought.thought_spec),
            code=material_to_save,
            feedback=("" if is_format_ok else f"FORMAT_ERROR: {meta.get('error', 'unknown')}"),
            generation=thought.generation,
            parent_ids=thought.parent_ids,
            status=("new" if is_format_ok else "failed_format"),
            strategy=cast(EvolStrategyMethod, thought.strategy),
            origin_pool=cast(Any, origin_pool),
        )
        cand.code_file_path = code_path
        cand.generated_mode = "whole"
        cand.parent_count = thought.parent_count
        cand.requested_parent_count = thought.parent_count
        cand.thought_id = thought.thought_id
        cand.code_sample_index = sample_index
        cand.sample_generation_thought = sample_thought or ""
        return cand

    def _generate_n_for_prompt(self, prompt_text: str, n: int) -> list[tuple]:
        """Generate and pad n code-sample responses from one realization prompt."""
        if n <= 0:
            return []
        results = asyncio.run(
            self.llm.generate_n_responses(
                prompt=prompt_text,
                n=n,
                temperature=self.default_llm_temp,
                top_p=self.default_llm_top_p,
                max_tokens=self.default_llm_max_tokens,
                generation_mode="whole",
                system_prompt_override=self._get_generation_system_prompt("whole"),
            )
        )
        while len(results) < n:
            results.append(
                (None, None, {"format_ok": False, "error": "missing_response", "raw": "", "parsed_mode": "whole"})
            )
        return results[:n]

    def _generate_code_samples_for_thought(
        self,
        thought: ThoughtIndividual,
    ) -> list[Heuristic]:
        k = self.code_samples_per_thought
        if self.qd_thought_code_seeded and thought.parent_code:
            # B' hybrid: split k between seeded refinement and whole-regen
            # leaps so architectural escape is preserved (fraction=1.0 = pure
            # Fix B; <1.0 keeps that many whole-regen "leap" samples).
            n_seeded = max(0, min(k, round(k * self.qd_seed_sample_fraction)))
            seeded_p = self._create_prompt_thought_only_code_seeded(thought)
            whole_p = self._create_prompt_thought_only_code(thought)
            pairs = [(r, seeded_p) for r in self._generate_n_for_prompt(seeded_p, n_seeded)]
            pairs += [(r, whole_p) for r in self._generate_n_for_prompt(whole_p, k - n_seeded)]
        else:
            whole_p = self._create_prompt_thought_only_code(thought)
            pairs = [(r, whole_p) for r in self._generate_n_for_prompt(whole_p, k)]
        return [
            self._materialize_code_sample(thought, index, result, prompt_text)
            for index, (result, prompt_text) in enumerate(pairs[:k])
        ]

    def _materialize_repair_sample(
        self,
        thought: ThoughtIndividual,
        parent: Heuristic,
        repair_index: int,
        result: tuple[str | None, str | None, dict[str, Any]],
        prompt_text: str,
    ) -> Heuristic:
        _, code_content, meta = result
        is_format_ok = bool(meta.get("format_ok", False))
        material_to_save = code_content or meta.get("raw", "") or ""
        sample_index = int(getattr(parent, "code_sample_index"))
        repair_dir = os.path.join(
            os.path.dirname(parent.code_file_path),
            f"repair_attempt_{repair_index}",
        )
        os.makedirs(repair_dir, exist_ok=True)
        code_path = os.path.join(repair_dir, "code.sv")
        with open(code_path, "w", encoding="utf-8") as f:
            f.write(self._normalize_code_text(str(material_to_save)))
        with open(os.path.join(repair_dir, "prompt_snapshot.txt"), "w", encoding="utf-8") as f:
            f.write(prompt_text)
        self._write_json_file(os.path.join(repair_dir, "llm_meta.json"), meta)
        if not is_format_ok and self.require_strict_format:
            self._save_format_error_artifacts(code_path, meta)
        cand = Heuristic(
            thought=render_thought_spec(thought.thought_spec),
            code=material_to_save,
            feedback=("" if is_format_ok else f"FORMAT_ERROR: {meta.get('error', 'unknown')}"),
            generation=thought.generation,
            parent_ids=[parent.id],
            status=("new" if is_format_ok else "failed_format"),
            strategy=cast(EvolStrategyMethod, thought.strategy),
            origin_pool=parent.origin_pool,
        )
        cand.code_file_path = code_path
        cand.generated_mode = "whole"
        cand.parent_count = thought.parent_count
        cand.requested_parent_count = thought.parent_count
        cand.thought_id = thought.thought_id
        cand.code_sample_index = sample_index
        cand.repair_attempt_index = repair_index
        return cand

    def _repair_failed_code_samples(
        self,
        thought: ThoughtIndividual,
        samples: list[Heuristic],
    ) -> tuple[list[Heuristic], int]:
        if self.repair_kind == "none":
            return samples, 0
        repaired_samples = list(samples)
        attempts_used = 0
        for idx, sample in enumerate(samples):
            if sample.status == "success":
                continue
            per_sample_attempts = 0
            current = sample
            while (
                current.status != "success"
                and per_sample_attempts < self.repair_max_attempts_per_sample
                and attempts_used < self.repair_max_attempts_per_thought
            ):
                repair_index = per_sample_attempts + 1
                prompt_text = self._create_prompt_thought_only_repair(thought, current)
                result = asyncio.run(
                    self.llm.generate_response(
                        prompt_text,
                        self.default_llm_temp,
                        self.default_llm_top_p,
                        self.default_llm_max_tokens,
                        generation_mode="whole",
                        system_prompt_override=self._get_generation_system_prompt("whole"),
                    )
                )
                repair_sample = self._materialize_repair_sample(
                    thought,
                    current,
                    repair_index,
                    result,
                    prompt_text,
                )
                self._evaluate_candidates([repair_sample])
                attempts_used += 1
                per_sample_attempts += 1
                current = repair_sample
                repaired_samples[idx] = repair_sample
                if repair_sample.status == "success":
                    break
        return repaired_samples, attempts_used

    def _code_sample_summary(self, sample: Heuristic) -> CodeSample:
        return CodeSample(
            thought_id=str(getattr(sample, "thought_id")),
            sample_index=int(getattr(sample, "code_sample_index")),
            candidate_id=sample.id,
            status=sample.status,
            code_file_path=sample.code_file_path,
            quality_score=(
                float(getattr(sample, "quality_score"))
                if getattr(sample, "quality_score", None) is not None
                else None
            ),
            ppa_success=bool(sample.ppa_success),
            ppa_metrics=dict(sample.ppa_metrics),
            descriptor_values=dict(sample.descriptor_values),
            repair_attempts=int(getattr(sample, "repair_attempt_index", 0) or 0),
        )

    def _repair_config_dict(self) -> dict[str, Any]:
        return {
            "kind": self.repair_kind,
            "max_attempts_per_sample": self.repair_max_attempts_per_sample,
            "max_attempts_per_thought": self.repair_max_attempts_per_thought,
            "evidence": self.repair_evidence,
        }

    def _select_representative_sample(
        self,
        samples: list[Heuristic],
    ) -> Heuristic | None:
        successful = [sample for sample in samples if sample.status == "success"]
        if not successful:
            return None
        return max(
            successful,
            key=lambda sample: float(getattr(sample, "quality_score", sample.score)),
        )

    def _build_all_fail_parent(
        self,
        thought: ThoughtIndividual,
        evaluation: ThoughtEvaluation,
        samples: list[Heuristic],
    ) -> Heuristic:
        status = "failed_functionality"
        if evaluation.sample_statuses:
            status = evaluation.sample_statuses[0]
        # Carry sample-level evaluation feedback onto the thought-level
        # wrapper: fail-parent payloads read parent.feedback, and a
        # hardcoded "" silently disabled failure_feedback injection
        # (found live on the first failure-regime screen).
        feedback = next((s.feedback for s in samples if s.feedback), "")
        origin_pool = {
            "seed": "initial",
            "archive": "success_pool",
            "fail_pool": "fail_pool",
        }[thought.parent_source]
        parent = Heuristic(
            thought=render_thought_spec(thought.thought_spec),
            code="",
            feedback=feedback,
            generation=thought.generation,
            parent_ids=thought.parent_ids,
            status=cast(Any, status),
            strategy=cast(EvolStrategyMethod, thought.strategy),
            origin_pool=cast(Any, origin_pool),
        )
        parent.id = thought.thought_id
        parent.code_file_path = os.path.join(
            self._thought_dir(thought.generation, thought.thought_id),
            "thought_evaluation.json",
        )
        parent.thought_id = thought.thought_id
        parent.thought_aggregate_status = evaluation.aggregate_status
        parent.thought_success_rate = evaluation.success_rate
        parent.thought_sample_ids = evaluation.sample_ids
        return parent

    def _aggregate_thought(
        self,
        thought: ThoughtIndividual,
        samples: list[Heuristic],
        repair_attempts_used: int,
    ) -> tuple[ThoughtEvaluation, Heuristic | None, Heuristic | None]:
        sample_summaries = [self._code_sample_summary(sample) for sample in samples]
        sample_ids = [summary.candidate_id for summary in sample_summaries]
        sample_statuses = [summary.status for summary in sample_summaries]
        success_count = sum(1 for status in sample_statuses if status == "success")
        success_rate = success_count / self.code_samples_per_thought
        if success_count == 0:
            aggregate_status: Literal["all_failed", "partial_success", "all_success"] = "all_failed"
        elif success_count == self.code_samples_per_thought:
            aggregate_status = "all_success"
        else:
            aggregate_status = "partial_success"
        representative = self._select_representative_sample(samples)
        representative_id = representative.id if representative is not None else None
        representative_quality = (
            float(getattr(representative, "quality_score", representative.score))
            if representative is not None
            else None
        )
        representative_descriptor_values: dict[str, float] = {}
        if representative is not None:
            representative_descriptors = self._descriptor_tuple(representative)
            if representative_descriptors is not None:
                representative_descriptor_values = {
                    axis: float(value)
                    for axis, value in zip(
                        self._archive_axes(),
                        representative_descriptors,
                    )
                }
                representative.descriptor_values.update(representative_descriptor_values)
        evaluation = ThoughtEvaluation(
            thought_id=thought.thought_id,
            generation=thought.generation,
            code_samples_per_thought=self.code_samples_per_thought,
            sample_ids=sample_ids,
            sample_statuses=sample_statuses,
            success_count=success_count,
            success_rate=success_rate,
            aggregate_status=aggregate_status,
            repair_kind=self.repair_kind,
            repair_attempts_used=repair_attempts_used,
            representative_sample_id=representative_id,
            representative_quality_score=representative_quality,
            representative_ppa_metrics=(
                dict(representative.ppa_metrics) if representative is not None else {}
            ),
            representative_descriptor_values=representative_descriptor_values,
            parent_ids=thought.parent_ids,
            parent_source=thought.parent_source,
            strategy=thought.strategy,
            qd_operator_kind=self.qd_operator_kind,
            prompt_profile=self.prompts.profile,
            representation_kind=self.representation_kind,
            population_size=self.population_size,
            thought_population_size=self.thought_population_size,
            sample_records=[summary.to_json_dict() for summary in sample_summaries],
            repair_config=self._repair_config_dict(),
        )
        self._write_thought_evaluation(evaluation)
        if representative is not None:
            representative.thought_id = thought.thought_id
            representative.thought_aggregate_status = aggregate_status
            representative.thought_success_rate = success_rate
            representative.thought_sample_ids = sample_ids
            representative.thought_representative_sample_id = representative_id
            return evaluation, representative, None
        return evaluation, None, self._build_all_fail_parent(thought, evaluation, samples)

    def _run_thought_generation(
        self,
        budget: QDBudgetSplit,
    ) -> tuple[list[ThoughtEvaluation], list[Heuristic], list[Heuristic], list[Heuristic]]:
        llm_requests, request_meta = self._build_thought_requests(budget)
        if not llm_requests:
            return [], [], [], []
        thought_results = asyncio.run(
            self.llm.generate_batch_responses(
                llm_requests,
                self.default_llm_temp,
                self.default_llm_top_p,
                self.default_llm_max_tokens,
            )
        )
        if len(thought_results) < len(request_meta):
            missing = len(request_meta) - len(thought_results)
            print(
                f"WARNING: LLM returned {len(thought_results)}/{len(request_meta)} "
                f"thoughts. Padding {missing} invalid thoughts."
            )
            for _ in range(missing):
                thought_results.append(
                    (
                        None,
                        None,
                        {
                            "format_ok": False,
                            "error": "missing_response",
                            "raw": "",
                            "parsed_mode": None,
                        },
                    )
                )

        evaluations: list[ThoughtEvaluation] = []
        representatives: list[Heuristic] = []
        fail_parents: list[Heuristic] = []
        all_samples: list[Heuristic] = []

        for result, meta_rec in zip(thought_results, request_meta, strict=False):
            thought, invalid_eval = self._materialize_thought(result, meta_rec)
            if invalid_eval is not None:
                evaluations.append(invalid_eval)
                self.thought_evaluations.append(invalid_eval)
                continue
            assert thought is not None
            samples = self._generate_code_samples_for_thought(thought)
            self._evaluate_candidates(samples)
            samples, repair_attempts_used = self._repair_failed_code_samples(
                thought,
                samples,
            )
            evaluation, representative, fail_parent = self._aggregate_thought(
                thought,
                samples,
                repair_attempts_used,
            )
            evaluations.append(evaluation)
            self.thought_evaluations.append(evaluation)
            all_samples.extend(samples)
            if representative is not None:
                representatives.append(representative)
            if fail_parent is not None:
                fail_parents.append(fail_parent)

        return evaluations, representatives, fail_parents, all_samples

    def _insert_thought_results(
        self,
        representatives: list[Heuristic],
        fail_parents: list[Heuristic],
    ) -> tuple[int, int]:
        inserted, replaced = self._insert_successes(representatives)
        self._update_fail_pool(fail_parents)
        return inserted, replaced

    def _initialize_thought_population(self) -> None:
        print(
            f"\n--- Initializing Thought Population "
            f"(Thoughts: {self.thought_population_size}, "
            f"Code Samples: {self.population_size}) ---"
        )
        self.gen_start_time = time.time()
        budget = QDBudgetSplit(
            total_budget=self.thought_population_size,
            target_cells=self.thought_population_size,
            occupied_cells=0,
            fail_share=0.0,
            coverage_fail_share=None,
            fail_share_cap=None,
            fail_budget=0,
            success_budget=self.thought_population_size,
            phase="warmup",
            seed_budget=self.thought_population_size,
            backfill_budget=0,
            refine_budget=0,
        )
        evaluations, representatives, fail_parents, all_samples = self._run_thought_generation(budget)
        self._insert_thought_results(representatives, fail_parents)
        if self.logger:
            # Log every evaluated code sample, not just per-thought
            # representatives: gate-bearing pools require both arms'
            # evaluated histories to be structurally identical.
            self._log_generation_stats(
                all_samples,
                time.time() - self.gen_start_time,
                defaultdict(float),
                defaultdict(float),
                {"initial": {"initial": 1.0}},
            )
        print(
            f"Generated {len(evaluations)} thoughts and {len(all_samples)} code samples."
        )

    def _evolve_one_thought_generation(self):
        self.current_generation += 1
        print(f"\n--- Starting Thought-Only QD Generation {self.current_generation} ---")
        self.gen_start_time = time.time()
        budget = self._split_thought_generation_budget()
        evaluations, representatives, fail_parents, all_samples = self._run_thought_generation(budget)
        if not evaluations:
            return "STOP"

        inserted, replaced = self._insert_thought_results(representatives, fail_parents)
        self._maybe_adaptive_rebin()
        gen_runtime = time.time() - self.gen_start_time
        qd_snapshot = self._build_qd_snapshot(
            inserted=inserted,
            replaced=replaced,
            budget=budget,
            runtime_sec=gen_runtime,
        )
        qd_snapshot["representation_kind"] = self.representation_kind
        qd_snapshot["code_samples_per_thought"] = self.code_samples_per_thought
        qd_snapshot["thought_population_size"] = self.thought_population_size
        qd_snapshot["generated_thought_count"] = len(evaluations)
        qd_snapshot["generated_code_sample_count"] = len(all_samples)
        qd_snapshot["generated_parent_source_counts"] = {
            "archive": sum(1 for item in evaluations if item.parent_source == "archive"),
            "fail_pool": sum(1 for item in evaluations if item.parent_source == "fail_pool"),
            "seed": sum(1 for item in evaluations if item.parent_source == "seed"),
        }
        if self.logger:
            self._log_generation_stats(
                all_samples,
                gen_runtime,
                defaultdict(float),
                defaultdict(float),
                {"thought_only": {}},
            )
            self._write_qd_artifacts(qd_snapshot)

        print(
            f"--- Thought-Only QD Gen {self.current_generation} Complete. "
            f"Archive({self.success_archive.occupied_count()}), Inserted({inserted}), "
            f"Replaced({replaced}), Fail({len(self.fail_pool)}) ---"
        )
        return None

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
            self._assign_archive_indices(cand)
            member = self._archive_member(cand, descriptors)
            before_occupied = self.success_archive.occupied_count()
            before_qd_score = self._archive_qd_score()
            result = self.success_archive.insert(member)
            global_update = self._insert_global_pareto(member)
            self._record_rebin_sample(member, result)
            if result.inserted:
                inserted += 1
            if result.replaced:
                replaced += 1
                for payload in result.removed_payloads:
                    previous_payload = cast(Heuristic | None, payload)
                    if previous_payload is not None and previous_payload is not cand:
                        self._record_reservoir_candidate(result.cell_id, previous_payload)
            elif isinstance(self.success_archive, GridQuantileArchive) and result.decision == "warmup_buffered":
                self.success_reservoir.setdefault(result.cell_id, deque(maxlen=1)).appendleft(cand)
            elif self.qd_cell_reservoir > 0:
                self._record_reservoir_candidate(result.cell_id, cand)
            after_occupied = self.success_archive.occupied_count()
            after_qd_score = self._archive_qd_score()
            self._write_candidate_qd_event(
                cand,
                descriptor_tuple=descriptors,
                insert_result=result,
                global_update=global_update,
                before_occupied=before_occupied,
                after_occupied=after_occupied,
                before_qd_score=before_qd_score,
                after_qd_score=after_qd_score,
            )
        if isinstance(self.success_archive, GridQuantileArchive) and self.success_archive.is_initialized:
            self._drop_warmup_reservoir()
        self.success_pool = self._success_view()
        return inserted, replaced

    def _maybe_adaptive_warmup_fallback(self) -> tuple[int, int]:
        if self.qd_grid_quantile_adaptive_warmup_successes <= 0:
            return 0, 0
        if self.current_generation < self.qd_grid_quantile_adaptive_warmup_generation:
            return 0, 0
        if not isinstance(self.success_archive, GridQuantileArchive):
            return 0, 0
        results = self.success_archive.initialize_from_warmup_if_ready(
            min_successes=self.qd_grid_quantile_adaptive_warmup_successes,
            initialization_mode="adaptive_sparse_yield_fallback",
        )
        if not results:
            return 0, 0
        inserted = sum(1 for result in results.values() if result.inserted)
        replaced = sum(1 for result in results.values() if result.replaced)
        self._drop_warmup_reservoir()
        self.success_pool = self._success_view()
        return inserted, replaced

    def evolve_one_generation(self):
        if self.representation_kind == "thought_only":
            return self._evolve_one_thought_generation()

        self.current_generation += 1
        print(f"\n--- Starting QD Generation {self.current_generation} ---")
        self.gen_start_time = time.time()

        budget = self._split_generation_budget()

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

        if self.qd_operator_kind == "single_thought_operator":
            mode = "whole"
            if self.fail_pool and budget.fail_budget > 0:
                for _ in range(budget.fail_budget):
                    parent = random.choice(self.fail_pool)
                    prompt_text = self._create_prompt_single_thought_operator(
                        [parent],
                        archive_context=self._archive_context_sample({parent.id}),
                    )
                    llm_requests.append(
                        self._build_prompt_request(
                            prompt=prompt_text,
                            mode=mode,
                            system_prompt=self._get_generation_system_prompt(mode),
                        )
                    )
                    request_meta.append(
                        {
                            "strategy": SINGLE_THOUGHT_OPERATOR_STRATEGY,
                            "parents": [parent],
                            "parent_count": 1,
                            "requested_parent_count": 1,
                            "origin_pool": "fail_pool",
                            "resolved_mode": mode,
                            "prompt_text": prompt_text,
                        }
                    )

            success_total_requests = budget.backfill_budget + budget.refine_budget
            for _ in range(success_total_requests):
                wants_two = random.random() >= self.qd_operator_one_parent_fraction
                requested_parent_count = 2 if wants_two else 1
                parents = (
                    self._sample_two_success_parents(
                        allow_intra_bin=self.qd_operator_two_parent_allow_intra_bin,
                    )
                    if wants_two
                    else self._sample_success_parents(1)
                )
                if wants_two and len(parents) < 2:
                    parents = self._sample_success_parents(1)
                if not parents:
                    break
                if len(parents) > 2:
                    parents = parents[:2]
                if len(parents) == 2 and parents[0].id == parents[1].id:
                    alternatives = [
                        cand for cand in self._success_view() if cand.id != parents[0].id
                    ]
                    if not alternatives:
                        parents = parents[:1]
                    else:
                        parents[1] = random.choice(alternatives)
                prompt_text = self._create_prompt_single_thought_operator(
                    parents,
                    archive_context=self._archive_context_sample(
                        {parent.id for parent in parents}
                    ),
                )
                llm_requests.append(
                    self._build_prompt_request(
                        prompt=prompt_text,
                        mode=mode,
                        system_prompt=self._get_generation_system_prompt(mode),
                    )
                )
                request_meta.append(
                    {
                        "strategy": SINGLE_THOUGHT_OPERATOR_STRATEGY,
                        "parents": parents,
                        "parent_count": len(parents),
                        "requested_parent_count": requested_parent_count,
                        "origin_pool": "success_pool",
                        "resolved_mode": mode,
                        "prompt_text": prompt_text,
                    }
                )
        else:
            if self.fail_pool and budget.fail_budget > 0:
                fail_strategies: list[EvolStrategyMethodFail] = (
                    list(CLASSIC_FAIL_STRATEGIES)
                    if not self._uses_descriptor_guided_generation()
                    else ["M-F", "M-E"]
                )
                fail_selected: set[EvolStrategyMethodFail] = set()
                for _ in range(budget.fail_budget):
                    strat_name, prob_dist = self._select_strategy(
                        "fail",
                        fail_strategies,
                        fail_selected,
                    )
                    if strat_name is None or prob_dist is None:
                        continue
                    fail_selected.add(strat_name)
                    parent = random.choice(self.fail_pool)
                    mode = self._phase_mode("fail")
                    prompt_text = self._with_mode(
                        mode,
                        getattr(self, f"_create_prompt_{strat_name.replace('-', '_')}"),
                        [parent],
                    )
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
                            strategy_avg_selection_probabilities["fail_pool"].get(
                                key,
                                0.0,
                            )
                            + value
                        )

            success_selected: set[EvolStrategyMethodSuccess] = set()
            success_total_requests = budget.backfill_budget + budget.refine_budget
            for idx in range(success_total_requests):
                if not self._uses_descriptor_guided_generation():
                    arity = self._success_parent_arity()
                    if arity == 2:
                        success_available = cast(list[EvolStrategyMethodSuccess], ["C-F"])
                    elif arity == 1:
                        success_available = cast(
                            list[EvolStrategyMethodSuccess],
                            ["M-S", "M-E", "M-R", "M-I"],
                        )
                    else:
                        success_available = list(CLASSIC_SUCCESS_STRATEGIES)
                        if len(self.success_pool) < 2 and "C-F" in success_available:
                            success_available.remove("C-F")
                    selected_name, prob_dist = self._select_strategy(
                        "success",
                        success_available,
                        success_selected,
                    )
                    if selected_name is None or prob_dist is None:
                        continue
                    strat_name = selected_name
                    success_selected.add(strat_name)
                    parents = (
                        self._sample_two_success_parents()
                        if strat_name == "C-F"
                        else self._sample_success_parents(1)
                    )
                    if not parents:
                        break
                    mode = self._phase_mode("crossover" if strat_name == "C-F" else "refine")
                    for key, value in prob_dist.items():
                        strategy_avg_selection_probabilities["success_pool"][key] = (
                            strategy_avg_selection_probabilities["success_pool"].get(
                                key,
                                0.0,
                            )
                            + value
                        )
                elif budget.phase == "fill" or idx < budget.backfill_budget:
                    arity = self._success_parent_arity()
                    if arity is None:
                        success_available = cast(list[EvolStrategyMethodSuccess], ["M-T", "M-E"])
                        if len(self.success_pool) > 1:
                            success_available.append("C-D")
                    elif arity == 2:
                        success_available = cast(list[EvolStrategyMethodSuccess], ["C-D"])
                    else:
                        success_available = cast(list[EvolStrategyMethodSuccess], ["M-T", "M-E"])
                    selected_name, prob_dist = self._select_strategy(
                        "success",
                        success_available,
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
                            strategy_avg_selection_probabilities["success_pool"].get(
                                key,
                                0.0,
                            )
                            + value
                        )
                else:
                    arity = self._success_parent_arity()
                    if arity is None:
                        parent_count = (
                            2
                            if idx == success_total_requests - 1 and len(self.success_pool) > 1
                            else 1
                        )
                        parents = self._sample_success_parents(parent_count)
                    elif arity == 2:
                        parents = self._sample_two_success_parents()
                    else:
                        parents = self._sample_success_parents(1)
                    if not parents:
                        break
                    if arity is None:
                        success_available = cast(
                            list[EvolStrategyMethodSuccess],
                            ["M-S", "M-R", "M-I"],
                        )
                        if len(self.success_pool) > 1:
                            success_available.append("C-F")
                    elif arity == 2:
                        success_available = cast(list[EvolStrategyMethodSuccess], ["C-F"])
                    else:
                        success_available = cast(
                            list[EvolStrategyMethodSuccess],
                            ["M-S", "M-R", "M-I"],
                        )
                    selected_name, prob_dist = self._select_strategy(
                        "success",
                        success_available,
                        success_selected,
                    )
                    if selected_name is None or prob_dist is None:
                        continue
                    strat_name = selected_name
                    success_selected.add(strat_name)
                    mode = self._phase_mode("crossover" if strat_name == "C-F" else "refine")
                    for key, value in prob_dist.items():
                        strategy_avg_selection_probabilities["success_pool"][key] = (
                            strategy_avg_selection_probabilities["success_pool"].get(
                                key,
                                0.0,
                            )
                            + value
                        )

                if strat_name in {"C-F", "C-D"} and len(parents) < 2:
                    parents = self._sample_success_parents(2)
                    if len(parents) < 2:
                        continue
                if strat_name not in {"C-F", "C-D"}:
                    prompt_text = self._with_mode(
                        mode,
                        getattr(self, f"_create_prompt_{strat_name.replace('-', '_')}"),
                        [parents[0]],
                    )
                else:
                    if parents[0].id == parents[1].id:
                        alt = [
                            cand
                            for cand in self.success_pool
                            if cand.id != parents[0].id
                        ]
                        if not alt:
                            continue
                        parents[1] = random.choice(alt)
                    prompt_builder = (
                        self._create_prompt_C_F
                        if strat_name == "C-F"
                        else self._create_prompt_C_D
                    )
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
        fallback_inserted, fallback_replaced = self._maybe_adaptive_warmup_fallback()
        inserted += fallback_inserted
        replaced += fallback_replaced
        self._maybe_adaptive_rebin()

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
        qd_snapshot["generated_parent_source_counts"] = (
            self._journal_parent_source_counts(new_offspring)
        )
        qd_snapshot["generated_candidate_count"] = len(new_offspring)
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
        finalization_counts = self._finalize_pending_archive()
        if finalization_counts is not None:
            inserted, replaced = finalization_counts
            self._write_finalization_fallback_artifacts(
                inserted=inserted,
                replaced=replaced,
            )
        archive_elites = self._archive_elites()
        self._finalize_run_summary(archive_elites)

        if archive_elites:
            best_solution = archive_elites[0]
            final_report = best_solution.ppa_metrics.get("report_path", "N/A")
            final_score = best_solution.score if best_solution.score is not None else "N/A"
            return f"{self.problem_name},success,{best_solution.code_file_path},{final_report},{final_score}"
        return f"{self.problem_name},failed"
