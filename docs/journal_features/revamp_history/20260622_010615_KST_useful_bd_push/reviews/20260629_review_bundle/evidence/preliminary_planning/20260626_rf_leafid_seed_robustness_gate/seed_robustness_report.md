# T88 RF Leaf-ID Seed Robustness Results

Status: diagnostic negative; do not promote exact T83 to full RTLLM.

## Headline

- Three-seed classic mean HV: `0.144182`
- Three-seed T83 mean HV: `0.125986`
- Relative HV delta: `-12.62%`
- T83 seed-level HV wins: `0/3`

## Robustness

- No-Prob135 classic mean HV: `0.164779`
- No-Prob135 T83 mean HV: `0.134527`
- RTLLM-only classic mean HV: `0.150861`
- RTLLM-only T83 mean HV: `0.108504`

## Decision

T83 remains the current MasterRTL RF model-state category
representative, but the seed gate blocks promotion. The exact
configuration does not meet the near-classic robustness rule and
should not receive larger RTLLM budget without a materially different
coupling mechanism.
