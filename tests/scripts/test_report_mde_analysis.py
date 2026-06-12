from __future__ import annotations

import importlib.util
import json
import sys
from pathlib import Path

_SCRIPT = (
    Path(__file__).resolve().parent.parent.parent / "scripts" / "report_mde_analysis.py"
)
_SPEC = importlib.util.spec_from_file_location("rmde", _SCRIPT)
assert _SPEC is not None and _SPEC.loader is not None
mod = importlib.util.module_from_spec(_SPEC)
sys.modules.setdefault("rmde", mod)
_SPEC.loader.exec_module(mod)


def test_power_is_monotone_in_effect_and_scale():
    kwargs = dict(sd_problem=0.05, sd_seed=0.02, n_sim=80, n_boot=120, seed=7)
    p_small = mod.power_continuous(effect=0.01, n_problems=13, n_seeds=5, **kwargs)
    p_large = mod.power_continuous(effect=0.08, n_problems=13, n_seeds=5, **kwargs)
    assert p_large > p_small
    p_more_problems = mod.power_continuous(effect=0.03, n_problems=40, n_seeds=5, **kwargs)
    p_fewer_problems = mod.power_continuous(effect=0.03, n_problems=6, n_seeds=5, **kwargs)
    assert p_more_problems > p_fewer_problems
    # Determinism under the same seed.
    again = mod.power_continuous(effect=0.08, n_problems=13, n_seeds=5, **kwargs)
    assert again == p_large


def test_main_writes_report_with_observed_variance(tmp_path):
    csv_path = tmp_path / "paired_deltas.csv"
    rows = ["unit_id,metric,baseline,treatment,delta,status"]
    for seed in ("42", "1001"):
        for i, delta in enumerate((0.05, 0.10, -0.02, 0.08)):
            rows.append(f"{seed}/RTLLM/Prob{i:03d},best_quality,0.1,{0.1+delta},{delta},paired")
    csv_path.write_text("\n".join(rows) + "\n", encoding="utf-8")
    out = tmp_path / "mde"
    code = mod.main(
        [
            "--paired-csv", str(csv_path),
            "--n-sim", "60", "--n-boot", "100",
            "--output-dir", str(out),
        ]
    )
    assert code == 0
    report = json.loads((out / "mde_analysis.json").read_text(encoding="utf-8"))
    assert report["observed_problems"] == 4
    assert report["sd_problem"] > 0
    assert "20x5" in report["continuous_gates"]
    assert (out / "mde_analysis.md").is_file()
