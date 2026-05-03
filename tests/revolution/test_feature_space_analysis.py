from __future__ import annotations

import matplotlib.pyplot as plt
import pytest

from revolution.qd.design_space_report_support import add_right_margin_colorbar
from revolution.qd.feature_space_analysis import fit_embedding_model


def _rows() -> list[dict[str, float | str]]:
    return [
        {"backend": "classic", "candidate_id": "a", "f1": 0.1, "f2": 1.0, "f3": 0.4, "color_score": -0.2},
        {"backend": "classic", "candidate_id": "b", "f1": 0.2, "f2": 0.8, "f3": 0.6, "color_score": -0.1},
        {"backend": "classic", "candidate_id": "c", "f1": 0.4, "f2": 0.6, "f3": 0.7, "color_score": 0.0},
        {"backend": "cvt", "candidate_id": "d", "f1": 0.6, "f2": 0.5, "f3": 0.9, "color_score": 0.1},
        {"backend": "cvt", "candidate_id": "e", "f1": 0.8, "f2": 0.4, "f3": 1.1, "color_score": 0.2},
        {"backend": "cvt", "candidate_id": "f", "f1": 1.0, "f2": 0.2, "f3": 1.2, "color_score": 0.3},
    ]


def test_fit_embedding_model_returns_stable_axis_metadata() -> None:
    fit = fit_embedding_model(_rows(), ["f1", "f2", "f3"], method="pca")

    assert fit.note is None
    assert fit.x_label == "PC1"
    assert fit.y_label == "PC2"
    assert fit.usable_features == ("f1", "f2", "f3")
    assert len(fit.points) == 6
    assert fit.color_limits == pytest.approx((-0.2, 0.3))


def test_fit_embedding_model_keeps_tsne_deterministic() -> None:
    fit_a = fit_embedding_model(_rows(), ["f1", "f2", "f3"], method="tsne")
    fit_b = fit_embedding_model(_rows(), ["f1", "f2", "f3"], method="tsne")

    assert fit_a.note is None
    assert fit_a.x_label == "t-SNE 1"
    assert fit_a.y_label == "t-SNE 2"
    assert len(fit_a.points) == len(fit_b.points)
    for point_a, point_b in zip(fit_a.points, fit_b.points, strict=True):
        assert point_a == pytest.approx(point_b)


def test_add_right_margin_colorbar_reserves_space() -> None:
    fig, axes = plt.subplots(1, 2, figsize=(8, 3))
    image = axes[0].scatter([0, 1], [0, 1], c=[0.0, 1.0], cmap="viridis")
    axes[1].scatter([0, 1], [1, 0], c=[0.2, 0.8], cmap="viridis")
    fig.tight_layout(rect=(0.0, 0.0, 0.88, 0.95))

    colorbar_axis = add_right_margin_colorbar(
        fig=fig,
        mappable=image,
        axes=list(axes),
        label="fitness / quality score",
    )

    rightmost_plot_edge = max(axis.get_position().x1 for axis in axes)
    assert colorbar_axis.get_position().x0 > rightmost_plot_edge
    plt.close(fig)
