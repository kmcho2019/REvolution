"""Paired statistics for journal-revamp classic-vs-QD evidence.

Implements the statistical machinery required by the TCAD revamp gates
(docs/journal_features/08_journal_revamp_goal.md), revised after the
round-1 adversarial statistics review
(revamp_history/20260612_005012_KST_journal_revamp/narrative_review_round1.md):

- the statistical unit is the problem-seed pair, but problems are treated
  as clusters: confidence intervals use a cluster bootstrap that resamples
  problems with their seed replicates intact;
- missing treatment data where the baseline succeeded is counted as a
  treatment loss AND, when a metric floor is predeclared, imputed into the
  gate-bearing (penalized) mean/CI statistics; complete-case statistics are
  reported alongside, never as the gate;
- Branch-B parity requires an explicit equivalence test (CI entirely
  within a predeclared margin), not absence of significance;
- the win-rate gate additionally requires a minimum number of non-tied
  pairs and an exact sign-test p-value below 0.05.
"""

from __future__ import annotations

import math
import random
from dataclasses import dataclass
from typing import Iterable, Mapping, Sequence

DEFAULT_EQUIVALENCE_MARGIN = 0.03
MIN_NON_TIED_PAIRS_FOR_WIN_RATE = 10


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
    """Aggregated paired-delta statistics for one metric.

    ``mean_delta`` / ``bootstrap_ci_*`` are the gate-bearing statistics:
    when a floor is predeclared, missing-treatment units are imputed at the
    floor (penalized analysis). ``complete_case_*`` report the same
    statistics over fully paired units only, for transparency.
    """

    metric: str
    unit_count: int
    paired_count: int
    imputed_loss_count: int
    missing_treatment_count: int
    missing_baseline_count: int
    mean_delta: float | None
    bootstrap_ci_low: float | None
    bootstrap_ci_high: float | None
    complete_case_mean_delta: float | None
    complete_case_ci_low: float | None
    complete_case_ci_high: float | None
    ci_method: str
    cluster_count: int
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
            "imputed_loss_count": self.imputed_loss_count,
            "missing_treatment_count": self.missing_treatment_count,
            "missing_baseline_count": self.missing_baseline_count,
            "mean_delta": self.mean_delta,
            "bootstrap_ci_low": self.bootstrap_ci_low,
            "bootstrap_ci_high": self.bootstrap_ci_high,
            "complete_case_mean_delta": self.complete_case_mean_delta,
            "complete_case_ci_low": self.complete_case_ci_low,
            "complete_case_ci_high": self.complete_case_ci_high,
            "ci_method": self.ci_method,
            "cluster_count": self.cluster_count,
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
    """Seeded percentile bootstrap CI for the mean of i.i.d. ``values``.

    Prefer :func:`cluster_bootstrap_mean_ci` for problem-seed data; this
    flat variant remains for genuinely independent samples.
    """

    if not values:
        return None, None, None
    mean = sum(values) / len(values)
    if len(values) == 1:
        return mean, None, None
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


def cluster_bootstrap_mean_ci(
    values_by_cluster: Mapping[str, Sequence[float]],
    *,
    n_resamples: int = 10000,
    seed: int = 42,
    alpha: float = 0.05,
) -> tuple[float | None, float | None, float | None]:
    """Cluster bootstrap CI: resample clusters, keep replicates intact.

    Problems are the clusters; the seed replicates of one problem are
    correlated through the problem-method interaction, so resampling whole
    clusters keeps the CI honest at the effective sample size.
    """

    clusters = [list(values) for values in values_by_cluster.values() if values]
    if not clusters:
        return None, None, None
    all_values = [value for cluster in clusters for value in cluster]
    mean = sum(all_values) / len(all_values)
    if len(clusters) == 1:
        return mean, None, None
    rng = random.Random(seed)
    resampled_means: list[float] = []
    n_clusters = len(clusters)
    for _ in range(n_resamples):
        total = 0.0
        count = 0
        for _ in range(n_clusters):
            cluster = clusters[rng.randrange(n_clusters)]
            total += sum(cluster)
            count += len(cluster)
        resampled_means.append(total / count)
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


def equivalence_within_margin(
    ci_low: float | None,
    ci_high: float | None,
    *,
    margin: float = DEFAULT_EQUIVALENCE_MARGIN,
) -> bool:
    """Equivalence by CI containment: the whole CI lies within ±margin.

    This is the two-one-sided-tests (TOST) decision expressed on the
    bootstrap CI; a CI merely *including* zero is never equivalence.
    """

    if ci_low is None or ci_high is None:
        return False
    return ci_low >= -margin and ci_high <= margin


def _unit_cluster(unit_id: str, clusters: Mapping[str, str] | None) -> str:
    if clusters is not None and unit_id in clusters:
        return clusters[unit_id]
    # Default convention: "<seed>/<benchmark>/<problem>" clusters on
    # benchmark/problem.
    parts = unit_id.split("/")
    return "/".join(parts[1:]) if len(parts) >= 3 else unit_id


def summarize_paired_metric(
    metric: str,
    samples: Iterable[PairedSample],
    *,
    tie_epsilon: float = 1e-12,
    missing_treatment_counts_as_loss: bool = True,
    missing_treatment_floor: float | None = None,
    n_resamples: int = 10000,
    seed: int = 42,
    clusters: Mapping[str, str] | None = None,
) -> PairedSummary:
    """Aggregate one metric's paired samples into gate-ready statistics.

    Units where the baseline has a value but the treatment does not count
    as treatment losses in the win-rate/sign test. When
    ``missing_treatment_floor`` is provided, those units also contribute a
    penalized delta of ``floor - baseline`` to the gate-bearing mean/CI;
    otherwise the gate statistics are complete-case (and reported as such
    via ``ci_method``).
    """

    sample_list = list(samples)
    complete_by_cluster: dict[str, list[float]] = {}
    penalized_by_cluster: dict[str, list[float]] = {}
    wins = losses = ties = 0
    missing_treatment = missing_baseline = imputed = 0
    for sample in sample_list:
        cluster = _unit_cluster(sample.unit_id, clusters)
        if sample.baseline is not None and sample.treatment is None:
            missing_treatment += 1
            if missing_treatment_counts_as_loss:
                losses += 1
            if missing_treatment_floor is not None:
                penalized_by_cluster.setdefault(cluster, []).append(
                    missing_treatment_floor - sample.baseline
                )
                imputed += 1
            continue
        if sample.baseline is None and sample.treatment is not None:
            missing_baseline += 1
            continue
        delta = sample.delta
        if delta is None:
            continue
        complete_by_cluster.setdefault(cluster, []).append(delta)
        penalized_by_cluster.setdefault(cluster, []).append(delta)
        if delta > tie_epsilon:
            wins += 1
        elif delta < -tie_epsilon:
            losses += 1
        else:
            ties += 1

    complete_mean, complete_low, complete_high = cluster_bootstrap_mean_ci(
        complete_by_cluster, n_resamples=n_resamples, seed=seed
    )
    if imputed > 0:
        gate_mean, gate_low, gate_high = cluster_bootstrap_mean_ci(
            penalized_by_cluster, n_resamples=n_resamples, seed=seed
        )
        ci_method = "cluster_bootstrap_penalized"
    else:
        gate_mean, gate_low, gate_high = complete_mean, complete_low, complete_high
        ci_method = "cluster_bootstrap"

    paired_count = sum(len(values) for values in complete_by_cluster.values())
    non_tied = wins + losses
    return PairedSummary(
        metric=metric,
        unit_count=len(sample_list),
        paired_count=paired_count,
        imputed_loss_count=imputed,
        missing_treatment_count=missing_treatment,
        missing_baseline_count=missing_baseline,
        mean_delta=gate_mean,
        bootstrap_ci_low=gate_low,
        bootstrap_ci_high=gate_high,
        complete_case_mean_delta=complete_mean,
        complete_case_ci_low=complete_low,
        complete_case_ci_high=complete_high,
        ci_method=ci_method,
        cluster_count=len(penalized_by_cluster or complete_by_cluster),
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
    hypervolume_log_ratio_mean: float | None,
    hypervolume_log_ratio_ci_low: float | None,
    treatment_valid_ppa_any_pass: int,
    baseline_valid_ppa_any_pass: int,
    min_non_tied_pairs: int = MIN_NON_TIED_PAIRS_FOR_WIN_RATE,
) -> list[GateCheck]:
    """Final-gate thresholds for reference-PPA suites (RTLLM/VerilogEval).

    All CI-bearing checks use penalized cluster-bootstrap statistics. The
    hypervolume gate is the predeclared log-ratio statistic: mean
    log((HV_t + eps)/(HV_b + eps)) >= log(1.05) with CI low > 0.
    """

    non_tied = best_quality.wins + best_quality.losses
    hv_required = math.log(1.05)
    checks = [
        GateCheck(
            name="mean_paired_best_quality_delta",
            required=">= +0.03 (penalized)",
            observed=best_quality.mean_delta,
            passed=(best_quality.mean_delta or float("-inf")) >= 0.03,
        ),
        GateCheck(
            name="mean_paired_avg_ppa_improvement_delta",
            required=">= +0.05 (penalized)",
            observed=avg_ppa_improvement.mean_delta,
            passed=(avg_ppa_improvement.mean_delta or float("-inf")) >= 0.05,
        ),
        GateCheck(
            name="best_quality_cluster_ci_low",
            required="> 0",
            observed=best_quality.bootstrap_ci_low,
            passed=(best_quality.bootstrap_ci_low or float("-inf")) > 0.0,
        ),
        GateCheck(
            name="hypervolume_log_ratio_mean",
            required=f">= log(1.05) ({hv_required:.4f})",
            observed=hypervolume_log_ratio_mean,
            passed=(hypervolume_log_ratio_mean or float("-inf")) >= hv_required,
        ),
        GateCheck(
            name="hypervolume_log_ratio_ci_low",
            required="> 0",
            observed=hypervolume_log_ratio_ci_low,
            passed=(hypervolume_log_ratio_ci_low or float("-inf")) > 0.0,
        ),
        GateCheck(
            name="win_rate_non_tied",
            required=">= 60%",
            observed=best_quality.win_rate_non_tied,
            passed=(best_quality.win_rate_non_tied or 0.0) >= 0.60,
        ),
        GateCheck(
            name="win_rate_non_tied_pair_count",
            required=f">= {min_non_tied_pairs}",
            observed=float(non_tied),
            passed=non_tied >= min_non_tied_pairs,
        ),
        GateCheck(
            name="win_rate_sign_test_p",
            required="< 0.05",
            observed=best_quality.sign_test_p,
            passed=(
                best_quality.sign_test_p is not None
                and best_quality.sign_test_p < 0.05
            ),
        ),
        GateCheck(
            name="valid_ppa_any_pass_count",
            required=">= baseline",
            observed=float(treatment_valid_ppa_any_pass),
            passed=treatment_valid_ppa_any_pass >= baseline_valid_ppa_any_pass,
        ),
    ]
    return checks


def evaluate_equivalence_gate(
    summary: PairedSummary,
    *,
    margin: float = DEFAULT_EQUIVALENCE_MARGIN,
    min_non_tied_pairs: int = MIN_NON_TIED_PAIRS_FOR_WIN_RATE,
) -> list[GateCheck]:
    """Branch-B parity: TOST-style CI containment plus a sample-size floor."""

    non_tied = summary.wins + summary.losses
    return [
        GateCheck(
            name=f"{summary.metric}_equivalence_ci_within_margin",
            required=f"95% CI within ±{margin:g} (penalized)",
            observed=summary.bootstrap_ci_high,
            passed=equivalence_within_margin(
                summary.bootstrap_ci_low,
                summary.bootstrap_ci_high,
                margin=margin,
            ),
        ),
        GateCheck(
            name=f"{summary.metric}_equivalence_pair_count",
            required=f">= {min_non_tied_pairs} non-tied pairs",
            observed=float(non_tied),
            passed=non_tied >= min_non_tied_pairs,
        ),
    ]


def evaluate_functional_gates(
    *,
    pass_rate_delta_points: float | None,
    pass_rate_ci_low_points: float | None,
    required_delta_points: float = 5.0,
) -> list[GateCheck]:
    """Final-gate thresholds for functional suites (CVDP).

    Inputs must come from penalized cluster-bootstrap statistics on
    pass-indicator deltas (points = fraction × 100).
    """

    return [
        GateCheck(
            name="functional_pass_rate_delta_points",
            required=f">= +{required_delta_points:g} points (penalized)",
            observed=pass_rate_delta_points,
            passed=(pass_rate_delta_points or float("-inf")) >= required_delta_points,
        ),
        GateCheck(
            name="pass_rate_cluster_ci_low_points",
            required="> 0",
            observed=pass_rate_ci_low_points,
            passed=(pass_rate_ci_low_points or float("-inf")) > 0.0,
        ),
    ]
