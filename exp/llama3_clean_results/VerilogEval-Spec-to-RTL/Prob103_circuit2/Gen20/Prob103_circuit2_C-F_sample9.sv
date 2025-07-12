// TopModule: A combinational circuit implementing the inverse XOR of inputs a, b, c, and d
module TopModule(
    input  logic a,  // Input bit a
    input  logic b,  // Input bit b
    input  logic c,  // Input bit c
    input  logic d,  // Input bit d
    output logic q   // Output bit q
);

    // Calculate the inverse XOR of a, b, c, and d directly.
    // This implements the required logic in a concise manner, where q is 1
    // if an odd number of inputs are 1 (except when all are 0), and q is 0
    // when an even number of inputs are 1 or when all inputs are 0.
    assign q = ~(a ^ b ^ c ^ d);

    // Note: For further PPA optimization, consider analyzing input signal probabilities,
    // exploring resource sharing if this module is part of a larger design, and guiding
    // the synthesis tool with directives towards area or power optimization if necessary.

endmodule