# Audience Glossary

This glossary defines the terms used in the report and slide outline. The goal
is to let a reader understand the evidence before reading the implementation
details.

## Research Terms

Behavior descriptor, or BD:
a numeric summary used by QD/MAP-Elites to place a candidate into an archive.
In this work, a BD should describe implementation behavior, such as synthesis
response or netlist structure, not final PPA score or pass/fail outcome.

Quality diversity, or QD:
an optimization style that tries to keep many high-quality candidates across
different behavior regions instead of keeping only one best candidate.

MAP-Elites:
a QD algorithm family. Candidates are mapped into archive cells by their BD.
Each cell keeps one or more strong candidates, called elites, for that behavior
region.

Archive:
the set of QD cells and their retained elites. An archive is useful only if its
cells hold valid, nonduplicate candidates that expose meaningful PPA tradeoffs.

Elite:
a retained candidate inside an archive cell. In this package, exact T26 uses
Pareto-front archive cells, so a cell may keep multiple nondominated elites.

Classic REvolution:
the non-QD baseline. It uses the same benchmark, model, prompt flow, operators,
seed, population size, and generation count, but it does not use a BD archive.

Exact T26 QD:
the selected QD arm for the milestone. It combines synthesis-response raw
descriptors, a grid-quantile QD archive, Pareto-front cells, and conservative
champion-style exploitation.

Synthesis-response raw descriptor, or SR raw descriptor:
a BD built from direct synthesis-response signals instead of final PPA metrics.
It is intended to describe how the implementation behaves under synthesis,
while avoiding in-loop access to the final optimization target.

## RTL And PPA Terms

RTL:
register-transfer-level Verilog design code.

Netlist:
the synthesized structural circuit representation derived from RTL.

PPA:
power, performance, and area. In this package, area and power are always used;
effective clock period is used when the reference timing data supports it.

PPA improvement:
`(reference - candidate) / abs(reference)`. Larger is better. Area, power, and
effective clock period are minimized, so lower candidate values become positive
improvements.

Valid PPA candidate:
a generated candidate with usable synthesis/PPA metrics. This is stricter than
syntax pass and functionality pass.

Classic-covered problem:
a benchmark problem where classic REvolution produced at least one valid PPA
candidate under the same budget.

PPA-first retention gate:
the hard gate for this milestone. If classic covers a problem, QD must also
produce at least one valid PPA candidate for that problem. Once this passes,
yield drops are warnings rather than automatic rejection.

Yield warning:
a functionality or valid-PPA count drop of at least 50% when classic has at
least 10 passing samples for that stage. If classic has fewer than 10 samples,
the rate is labeled small-n and not used as a hard decision.

## Pareto And Metric Terms

Dominated candidate:
a candidate that is no better than another candidate on every active PPA
objective and worse on at least one active objective.

PPA-front point:
a valid PPA candidate that is not dominated in normalized PPA-improvement
space for one problem and method.

Raw area-power front:
the nondominated front when candidates are plotted directly by raw area and raw
power. This is reader-friendly, but it may omit timing when timing is active.

PPA hypervolume, or HV:
the volume dominated by the nondominated normalized PPA-improvement front.
Negative improvements are clipped to zero before computing HV. Larger HV means
the method found a broader or stronger PPA-improvement front.

HV-AUC:
area under the HV-over-generations curve. Larger HV-AUC means useful front
points appeared earlier or persisted longer during the run.

Best score:
the scalar quality score for the best candidate in a run. It is not the
primary QD metric, but it remains a sanity check because a method can add
front points while losing scalar PPA quality.

Unique PPA point:
a deduplicated normalized PPA-improvement point. This prevents repeated copies
of the same PPA outcome from being counted as diversity.

Unique front family:
a deduplicated implementation family among front candidates, usually based on
canonicalized RTL/netlist or synthesized-cell features. It is a diversity
check, not a direct PPA metric.

Archive coverage:
the fraction of QD archive cells that contain at least one retained elite.

QD score:
the sum of elite quality across occupied archive cells. It is meaningful only
when the archive cells are populated by valid, nonduplicate candidates.

One-seed paired engineering evidence:
a comparison where both methods use the same seed and budget across many
problems. It can show a useful engineering signal, but it cannot prove
seed-stable statistical significance.

Screen subset:
the small problem set used to choose the full-run QD arm before seeing full
RTLLM outcomes.

Screen-excluded aggregate:
the full-run aggregate after removing the screen subset. It checks whether the
selected method still has support outside the problems used for selection.
