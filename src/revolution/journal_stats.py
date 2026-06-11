"""Paired statistics for journal-revamp classic-vs-QD evidence.

Implements the statistical machinery required by the TCAD revamp gates
(docs/journal_features/08_journal_revamp_goal.md): paired per-unit deltas
(the unit is a problem-seed pair), seeded bootstrap confidence intervals,
win rates over non-tied pairs, an exact two-sided sign test, and gate
evaluation against predeclared thresholds. Missing treatment data where the
baseline succeeded is counted as a treatment loss, never silently dropped.
"""

from __future__ import annotations

import math
import random
from dataclasses import dataclass
from typing import Iterable, Sequence


@dataclass(frozen=True)
class PairedSample:
    """One paired observation for a problem-seed unit."""

    unit_id: str
    baseline: float | None
    treatment: float | None

    @property
    def delta(self) -> float | None:
        if self.baseline is None or self.treatment is None:
            return None
        return self.treatment - self.baseline


@dataclass(frozen=True)
class PairedSummary:
    """Aggregated paired-delta statistics for one metric."""

    metric: str
    unit_count: int
    paired_count: int
    missing_treatment_count: int
    missing_baseline_count: int
    mean_delta: float | None
    bootstrap_ci_low: float | None
    bootstrap_ci_high: float | None
    wins: int
    losses: int
    ties: int
    win_rate_non_tied: float | None
    sign_test_p: float | None

    def as_dict(self) -> dict[str, object]:
        return {
            "metric": self.metric,
            "unit_count": self.unit_count,
            "paired_count": self.paired_count,
            "missing_treatment_count": self.missing_treatment_count,
            "missing_baseline_count": self.missing_baseline_count,
            "mean_delta": self.mean_delta,
            "bootstrap_ci_low": self.bootstrap_ci_low,
            "bootstrap_ci_high": self.bootstrap_ci_high,
            "wins": self.wins,
            "losses": self.losses,
            "ties": self.ties,
            "win_rate_non_tied": self.win_rate_non_tied,
            "sign_test_p": self.sign_test_p,
        }


def bootstrap_mean_ci(
    values: Sequence[float],
    *,
    n_resamples: int = 10000,
    seed: int = 42,
    alpha: float = 0.05,
) -> tuple[float | None, float | None, float | None]:
    """Seeded percentile bootstrap CI for the mean of ``values``."""

    if not values:
        return None, None, None
    mean = sum(values) / len(values)
    if len(values) == 1:
        return mean, mean, mean
    rng = random.Random(seed)
    resampled_means: list[float] = []
    n = len(values)
    for _ in range(n_resamples):
        total = 0.0
        for _ in range(n):
            total += values[rng.randrange(n)]
        resampled_means.append(total / n)
    resampled_means.sort()
    low_index = int((alpha / 2.0) * n_resamples)
    high_index = min(n_resamples - 1, int((1.0 - alpha / 2.0) * n_resamples))
    return mean, resampled_means[low_index], resampled_means[high_index]


def sign_test_p_value(wins: int, losses: int) -> float | None:
    """Exact two-sided sign test over non-tied pairs."""

    n = wins + losses
    if n == 0:
        return None
    k = max(wins, losses)
    tail = sum(math.comb(n, i) for i in range(k, n + 1)) / (2.0**n)
    return min(1.0, 2.0 * tail)


def summarize_paired_metric(
    metric: str,
    samples: Iterable[PairedSample],
    *,
    tie_epsilon: float = 1e-12,
    missing_treatment_counts_as_loss: bool = True,
    n_resamples: int = 10000,
    seed: int = 42,
) -> PairedSummary:
    """Aggregate one metric's paired samples into gate-ready statistics.

    Units where the baseline has a value but the treatment does not are
    counted as treatment losses in the win-rate and sign test (per the goal
    spec rule); they do not contribute a numeric delta to the mean/CI but
    are reported in ``missing_treatment_count``.
    """

    sample_list = list(samples)
    deltas: list[float] = []
    wins = losses = ties = 0
    missing_treatment = missing_baseline = 0
    for sample in sample_list:
        if sample.baseline is not None and sample.treatment is None:
            missing_treatment += 1
            if missing_treatment_counts_as_loss:
                losses += 1
            continue
        if sample.baseline is None and sample.treatment is not None:
            missing_baseline += 1
            continue
        delta = sample.delta
        if delta is None:
            continue
        deltas.append(delta)
        if delta > tie_epsilon:
            wins += 1
        elif delta < -tie_epsilon:
            losses += 1
        else:
            ties += 1

    mean_delta, ci_low, ci_high = bootstrap_mean_ci(
        deltas, n_resamples=n_resamples, seed=seed
    )
    non_tied = wins + losses
    return PairedSummary(
        metric=metric,
        unit_count=len(sample_list),
        paired_count=len(deltas),
        missing_treatment_count=missing_treatment,
        missing_baseline_count=missing_baseline,
        mean_delta=mean_delta,
        bootstrap_ci_low=ci_low,
        bootstrap_ci_high=ci_high,
        wins=wins,
        losses=losses,
        ties=ties,
        win_rate_non_tied=(wins / non_tied) if non_tied else None,
        sign_test_p=sign_test_p_value(wins, losses),
    )


@dataclass(frozen=True)
class GateCheck:
    """One predeclared gate condition with its observed value."""

    name: str
    required: str
    observed: float | None
    passed: bool

    def as_dict(self) -> dict[str, object]:
        return {
            "name": self.name,
            "required": self.required,
            "observed": self.observed,
            "passed": self.passed,
        }


def evaluate_reference_ppa_gates(
    *,
    best_quality: PairedSummary,
    avg_ppa_improvement: PairedSummary,
    hypervolume_relative_improvement: float | None,
    hypervolume_ci_low: float | None,
    treatment_valid_ppa_any_pass: int,
    baseline_valid_ppa_any_pass: int,
) -> list[GateCheck]:
    """Final-gate thresholds for reference-PPA suites (RTLLM/VerilogEval)."""

    checks = [
        GateCheck(
            name="mean_paired_best_quality_delta",
            required=">= +0.03",
            observed=best_quality.mean_delta,
            passed=(best_quality.mean_delta or float("-inf")) >= 0.03,
        ),
        GateCheck(
            name="mean_paired_avg_ppa_improvement_delta",
            required=">= +0.05",
            observed=avg_ppa_improvement.mean_delta,
            passed=(avg_ppa_improvement.mean_delta or float("-inf")) >= 0.05,
        ),
        GateCheck(
            name="best_quality_bootstrap_ci_low",
            required="> 0",
            observed=best_quality.bootstrap_ci_low,
            passed=(best_quality.bootstrap_ci_low or float("-inf")) > 0.0,
        ),
        GateCheck(
            name="hypervolume_relative_improvement",
            required=">= +5%",
            observed=hypervolume_relative_improvement,
            passed=(hypervolume_relative_improvement or float("-inf")) >= 0.05,
        ),
        GateCheck(
            name="hypervolume_bootstrap_ci_low",
            required="> 0",
            observed=hypervolume_ci_low,
            passed=(hypervolume_ci_low or float("-inf")) > 0.0,
        ),
        GateCheck(
            name="win_rate_non_tied",
            required=">= 60%",
            observed=best_quality.win_rate_non_tied,
            passed=(best_quality.win_rate_non_tied or 0.0) >= 0.60,
        ),
        GateCheck(
            name="valid_ppa_any_pass_count",
            required=">= baseline",
            observed=float(treatment_valid_ppa_any_pass),
            passed=treatment_valid_ppa_any_pass >= baseline_valid_ppa_any_pass,
        ),
    ]
    return checks


def evaluate_functional_gates(
    *,
    pass_rate_delta_points: float | None,
    pass_rate_ci_low_points: float | None,
    required_delta_points: float = 5.0,
) -> list[GateCheck]:
    """Final-gate thresholds for functional suites (CVDP)."""

    return [
        GateCheck(
            name="functional_pass_rate_delta_points",
            required=f">= +{required_delta_points:g} points",
            observed=pass_rate_delta_points,
            passed=(pass_rate_delta_points or float("-inf")) >= required_delta_points,
        ),
        GateCheck(
            name="pass_rate_bootstrap_ci_low_points",
            required="> 0",
            observed=pass_rate_ci_low_points,
            passed=(pass_rate_ci_low_points or float("-inf")) > 0.0,
        ),
    ]
