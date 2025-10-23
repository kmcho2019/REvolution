// TopModule: A combinational circuit implementing the inverse XOR of inputs a, b, c, and d
module TopModule(
    input  logic a,  // Input bit a
    input  logic b,  // Input bit b
    input  logic c,  // Input bit c
    input  logic d,  // Input bit d
    output logic q   // Output bit q
);

    // Direct implementation of the inverse XOR of inputs a, b, c, and d
    // Utilizing the XOR operator (^) followed by the NOT operator (~) for simplicity and efficiency
    assign q = ~(a ^ b ^ c ^ d);

endmodule