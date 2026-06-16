"""Build drop-in case-study figures for the manuscript from the run dirs.
Mechanical artifact generation (not prose). Produces the two figures whose data
is directly available; the bespoke thought-lineage and failure panels are left
for manual curation (their source dirs are noted in docs 12/13).

Outputs to docs/journal_features/manuscript_artifacts/figures/:
  - scalar_vs_qd_Prob135.pdf : classic vs QD best-quality trajectory (case study)
  - archive_heatmap_Prob135.png : the final grid-quantile archive slide (copied)

Usage: python scripts/build_manuscript_figures.py
"""

import json
import shutil
from pathlib import Path

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

FIGS = Path("docs/journal_features/manuscript_artifacts/figures")
FIGS.mkdir(parents=True, exist_ok=True)
HS = "exp/fast_iter/hard_subset_42"
PROB = "VerilogEval-Spec-to-RTL/Prob135_m2014_q6b"


def best_trajectory(arm: str) -> tuple[list[int], list[float]]:
    """Running-max best_score per generation for one arm."""
    f = Path(f"{HS}/{arm}/revolution/openai-gpt-oss-120b/{PROB}/generation_log.jsonl")
    gens, run = [], []
    cur = None
    for ln in f.read_text().splitlines():
        d = json.loads(ln)
        s = (d.get("generation_ppa") or {}).get("best_score")
        if s is None:
            continue
        cur = s if cur is None else max(cur, s)
        gens.append(d.get("generation"))
        run.append(cur)
    return gens, run


# Figure 1: scalar-vs-QD best-quality trajectory (the case-study comparison)
fig, ax = plt.subplots(figsize=(5.0, 3.2))
for arm, label, style in [("classic", "Classic (scalar)", "o-"), ("qd", "QD (Pareto archive)", "s--")]:
    g, r = best_trajectory(arm)
    ax.plot(g, r, style, label=label, linewidth=1.8, markersize=5)
ax.set_xlabel("Generation")
ax.set_ylabel("Best PPA quality (cumulative)")
ax.set_title("Prob135 (m2014\\_q6b): classic vs QD search trajectory")
ax.legend(loc="best", fontsize=9)
ax.grid(True, alpha=0.3)
fig.tight_layout()
out1 = FIGS / "scalar_vs_qd_Prob135.pdf"
fig.savefig(out1)
plt.close(fig)
print(f"wrote {out1}")

# Figure 2: archive heatmap — copy the final grid-quantile slide
slides = sorted(Path(f"{HS}/qd/revolution/openai-gpt-oss-120b/{PROB}/grid_quantile_slides").glob("slide_*.png"))
if slides:
    dst = FIGS / "archive_heatmap_Prob135.png"
    shutil.copy(slides[-1], dst)
    print(f"copied {slides[-1]} -> {dst}")
else:
    print("no grid_quantile slides found for the archive heatmap")

print("\nBespoke (manual curation needed — sources in docs 12/13):")
print("  - thought-lineage: exp/fast_iter/rb_failure_regime_v2/variant/.../Prob116_m2014_q3/")
print("  - failure panel:   exp/fast_iter/rb_failure_regime_v2/variant/.../Prob045_alu/")
