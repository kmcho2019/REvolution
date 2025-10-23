// TopModule: An optimized combinational circuit implementing the inverse XOR of inputs a, b, c, and d
module TopModule(
    input  logic a,  // Input bit a
    input  logic b,  // Input bit b
    input  logic c,  // Input bit c
    input  logic d,  // Input bit d
    output logic q   // Output bit q
);

    // Direct and efficient implementation of the inverse XOR logic
    // Using the XOR operator (^) followed by the NOT operator (~) for simplicity and efficiency
    assign q = ~(a ^ b ^ c ^ d);

    // Considering potential optimizations for PPA metrics:
    // - For Performance, the simplicity of the XOR and NOT operations should yield good timing.
    // - For Power, the low switching activity due to the combinational nature helps minimize power consumption.
    // - For Area, the minimal logic required keeps the area utilization low.

endmodule