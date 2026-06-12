from __future__ import annotations

import importlib.util
import sys
from pathlib import Path

import yaml

spec = importlib.util.spec_from_file_location(
    "generate_ablation_matrix",
    Path(__file__).resolve().parents[2] / "scripts" / "generate_ablation_matrix.py",
)
assert spec and spec.loader
gam = importlib.util.module_from_spec(spec)
sys.modules["generate_ablation_matrix"] = gam
spec.loader.exec_module(gam)


def test_matrix_launcher_covers_all_arms_and_seeds(tmp_path):
    config = tmp_path / "subset.yaml"
    config.write_text(
        yaml.safe_dump(
            {"benchmarks": {"RTLLM": {"problems": ["Prob045_alu"]}}}
        ),
        encoding="utf-8",
    )
    out = tmp_path / "matrix.sh"

    rc = gam.main(
        ["--subset-config", str(config), "--seeds", "1001", "1002", "--output", str(out)]
    )
    assert rc == 0
    script = out.read_text(encoding="utf-8")

    for seed in (1001, 1002):
        assert f"classic/seed_{seed}" in script
        for arm in ("classic_unified", "qd_six_operators", "qd_scalar_elites", "qd_target"):
            assert f"{arm}/seed_{seed}" in script
            assert f"stats/{arm}_seed{seed}" in script
    # one-factor flag checks
    assert "--classic_operator_kind single_thought_operator" in script
    assert "--qd_operator_kind eoh_strategies" in script
    assert "--qd_cell_mode scalar_elite" in script
    assert script.count("report_budget_parity.py") == 8
    assert "--max_tokens 32768" in script and "PYTHONUNBUFFERED=1" in script


def test_qd_six_operator_arm_differs_only_in_operator_kind():
    target = set(gam.QD_TARGET_FLAGS.split())
    six = set(gam.ARMS["qd_six_operators"].split())
    assert target - six == {"single_thought_operator"} | (target - six - {"single_thought_operator"})
    assert ("eoh_strategies" in six) and ("eoh_strategies" not in target)
    # everything else identical
    assert (target - {"single_thought_operator"}) == (six - {"eoh_strategies"})
