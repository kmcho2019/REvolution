# T09 NetTAG Text-Graph BD

Status: `T0 retrospective_text_graph_proxy_not_promoted`.

T09 is closed as a proxy audit over existing text, graph, and hybrid
text/netlist evidence. It does not claim a true NetTAG implementation or a
learned text-attributed graph transformer. The package answers whether the
current branch already found enough signal from text-attributed graph-style
descriptors to justify more direct spend.

## Decision

Do not promote the exact text-graph proxy lane. The replay evidence is real:
T33 shows Qwen text/netlist preprocessing has selected-HV signal, and T36 shows
T11 graph descriptors plus a bounded local-front lane can beat lexical and
fitness-top controls in replay. The live evidence is weaker: T58 maps the T11
graph coordinates into a T51-style live archive and loses classic on HV,
HV-AUC, front points, unique PPA, and reference-beating candidates. T96 adds an
official DeepGate pooled netlist axis to MasterRTL RF model-state axes and
still trails classic and T83.

## Follow-Up

Reopen this lane only if the next method changes the training objective or
coupling mechanism. Good candidates are:

- a true NetTAG-style graph-text model trained on masked node/text
  reconstruction with identifier controls;
- a secondary/reporting graph-text archive that does not steer most LLM calls;
- a front-rescue or source-selection policy that proves graph-text memory
  contributes quality-productive children.
