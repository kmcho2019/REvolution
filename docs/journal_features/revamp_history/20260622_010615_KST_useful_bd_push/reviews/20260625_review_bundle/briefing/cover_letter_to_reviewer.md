# Cover Letter To Reviewer

We are preparing a TCAD journal extension of a conference RTL-generation work
based on REvolution-style LLM evolutionary optimization. The extension goal was
to test whether quality-diversity methods, especially MAP-Elites-style
archives, can improve RTL PPA evolution by preserving meaningfully different
implementation families.

The two research questions are:

1. Does diversity matter for RTL/Verilog PPA evolution?
2. If it does, what kind of diversity matters?

Our intended positive story was that QD/MAP-Elites should expand the PPA
Pareto front compared with classic REvolution, not merely increase archive
coverage. In particular, we hoped that behavior descriptors based on
synthesis response, RTL/native graph structure, or pretrained circuit encoders
would preserve valid, PPA-competitive implementation families.

The current evidence is uncomfortable. We have tried many descriptors and
archive couplings, including AutoQD-style synthesis-response descriptors,
Qwen3 embeddings, DeepGate-style netlist graph surrogates, AURORA-style
autoencoder descriptors, DE-HNN-style hypergraph descriptors, MGVGA-style
structural contrastive features, and MasterRTL/RTLTimer-inspired RTL-native
features. Several methods show replay or diagnostic signal, but no current
method has a clean promoted same-budget RTLLM win over classic REvolution on
reference-complete HV/HV-AUC/Pareto-front metrics.

We would like an outside technical opinion on whether:

- the negative evidence is already strong enough to pivot the paper claim;
- the proposed decisive experiment is the right way to settle the question;
- we are using QD/MAP-Elites in the wrong shape for expensive, brittle RTL
  generation;
- our behavior descriptor candidates are too weak, too PPA-proxy-like, or too
  disconnected from useful implementation families;
- a reviewer would find a narrower "what failed and why" or "RTL-native
  diversity is necessary but not sufficient" claim publishable.

The key summary is in `executive_summary.md`. The detailed technical analysis
and run evidence are in `technical_analysis.md` and `evidence/`.
