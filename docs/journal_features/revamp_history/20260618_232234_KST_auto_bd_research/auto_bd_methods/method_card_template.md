# Method Name

## 1. Motivation

State the manual-BD weakness this method addresses.

## 2. Core Idea

Describe the behavior observation and why it is meaningful for RTL,
netlist, synthesis, or PPA evolution.

## 3. Input Artifacts

- RTL source:
- Yosys JSON/netlist:
- Synthesis-stage dumps:
- OpenROAD artifacts:
- Other:

## 4. Descriptor Extraction Algorithm

Give exact pseudocode or a pointer to the implementation.

## 5. Descriptor Fitting Protocol

- Fitting kind: fixed offline / online adaptive / post-hoc visualization only
- Training data:
- Validity filters:
- Frozen artifact hashes:
- Rebinning policy:

## 6. Archive Integration

- Archive type:
- Internal descriptor dimensions:
- Internal binning/cell policy:
- Common audit descriptor:
- Common audit binning:

## 7. Hyperparameters

List descriptor, fitting, binning, archive, and report parameters.

## 8. Expected Advantage

Explain why this should outperform or complement the landing Smooth-QD
manual-BD baseline.

## 9. Risks

List leakage, collapse, overfitting, cost, interpretability, and backend
complexity risks.

## 10. Implementation Status

Not started / partial / complete / rejected.

## 11. Experimental Setup

- Benchmark subset:
- Seeds:
- Model and endpoint:
- Evaluation budget:
- Worker/thread policy:
- Synthesis/OpenROAD settings:

## 12. Results

Summarize robustness, PPA, QD, descriptor-quality, and common-audit
metrics. Link generated reports and raw run roots.

## 13. Accept / Reject Decision

Accepted / rejected / needs more evidence.

## 14. Reason

Give the concrete gate evidence behind the decision.

