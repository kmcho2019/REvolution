// TopModule: A combinational circuit implementing the inverse XOR of inputs a, b, c, and d
module TopModule(
    input  logic a,  // Input bit a
    input  logic b,  // Input bit b
    input  logic c,  // Input bit c
    input  logic d,  // Input bit d
    output logic q   // Output bit q
);

    // Intermediate signals for step-by-step XOR operations
    logic ab_xor;
    logic abc_xor;

    // Calculate XOR of a and b
    assign ab_xor = a ^ b;

    // Calculate XOR of (a ^ b) and c
    assign abc_xor = ab_xor ^ c;

    // Calculate XOR of ((a ^ b) ^ c) and d, then invert the result to get q
    assign q = ~(abc_xor ^ d);

endmodule