# T66 RTL-Native Front-Guarded Parent QD

Status: completed seed `1001`; `T0 diagnostic_yield_positive_front_negative_not_promoted`.

T66 is the next live RTL-native coupling test after T65. It keeps the T63
state/pipeline RTL descriptor and the T51-style direct-code front-slot
substrate, then makes RTL-native cells affect parent selection through
front-slot parent pressure and low-rate near-front descriptor-compatible
fusion.

The seed-1001 hard/tuning run is executed, validated, packaged, and visually
inspected. It is useful mechanism evidence for RTL-native parent pressure, but
not a promoted QD/front result: T66 improves total valid-PPA count and mean
best score, while classic still wins mean HV, HV-AUC, and aggregate PPA-front
points.
