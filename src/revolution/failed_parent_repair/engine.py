"""Experimental REvolution engine with M-F-only failed-pool routing."""

from __future__ import annotations

import json
from pathlib import Path
from typing import Any, Literal

from revolution.algorithm import EoHEngine


class FailedParentRepairEngine(EoHEngine):
    """Route failed-parent offspring through the existing M-F intent."""

    def __init__(self, **kwargs: Any) -> None:
        super().__init__(**kwargs)
        assert self.population_pool_mode == "dual"
        assert self.classic_operator_kind == "eoh_strategies"
        assert self.eoh_success_operator_set == "classic"
        assert self.strategy_selection_method == "ucb"
        assert self.generation_mode == "whole"
        self.fail_strats = ["M-F"]
        self.fail_strategy_stats = {"M-F": {"count": 0, "value": 0.0}}

    def evolve_one_generation(self) -> Literal["STOP"] | None:
        """Run one classic generation and record its pool-size transition."""

        assert self.logger is not None
        path = Path(self.logger.log_dir) / "failed_parent_repair_pool_telemetry.jsonl"
        if self.current_generation == 0:
            path.write_text("", encoding="utf-8")
        pre_fail_size = len(self.fail_pool)
        pre_success_size = len(self.success_pool)
        outcome = super().evolve_one_generation()
        record = {
            "generation": self.current_generation,
            "pre_selection_fail_pool_size": pre_fail_size,
            "pre_selection_success_pool_size": pre_success_size,
            "post_selection_fail_pool_size": len(self.fail_pool),
            "post_selection_success_pool_size": len(self.success_pool),
            "generation_outcome": "stop" if outcome == "STOP" else "completed",
        }
        with path.open("a", encoding="utf-8") as handle:
            handle.write(json.dumps(record) + "\n")
        return outcome
