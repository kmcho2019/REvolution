import inspect
from unittest import mock

import pytest

from revolution.algorithm import CVDPEngine, EoHEngine
from revolution.backends.revolution_backend import RevolutionBackendConfig


@pytest.fixture
def mocker(request):
    """Local fallback for environments without pytest-mock."""

    patchers = []

    class _Mocker:
        def patch(self, target: str, *args, **kwargs):
            patcher = mock.patch(target, *args, **kwargs)
            patchers.append(patcher)
            return patcher.start()

    instance = _Mocker()
    request.addfinalizer(lambda: [patcher.stop() for patcher in reversed(patchers)])
    return instance


def test_eoh_engine_default_strategy_selection_is_ucb():
    signature = inspect.signature(EoHEngine.__init__)
    assert signature.parameters["strategy_selection_method"].default == "ucb"


def test_revolution_backend_config_default_strategy_selection_is_ucb():
    assert RevolutionBackendConfig().strategy_selection_method == "ucb"


def test_revolution_backend_config_defaults_to_classic_search_mode():
    cfg = RevolutionBackendConfig()
    assert cfg.search_mode == "revolution"
    assert cfg.qd_archive_type == "grid"
    assert cfg.qd_fail_generation_mode == "auto"


def test_cvdp_engine_default_timeout_is_120_seconds():
    signature = inspect.signature(CVDPEngine.__init__)
    assert signature.parameters["simulation_timeout_s"].default == 120
