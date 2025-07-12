// Refactored TopModule: Breaking down the XOR operation into intermediate steps
module TopModule(
    input  logic a,  // Input bit a
    input  logic b,  // Input bit b
    input  logic c,  // Input bit c
    input  logic d,  // Input bit d
    output logic q   // Output bit q
);

    // Intermediate signals to break down the XOR operation
    logic ab_xor;  // XOR of a and b
    logic abc_xor; // XOR of (a^b) and c

    // Compute the XOR of a and b
    assign ab_xor = a ^ b;

    // Compute the XOR of (a^b) and c
    assign abc_xor = ab_xor ^ c;

    // Finally, compute the XOR of ((a^b)^c) and d, and invert the result
    assign q = ~(abc_xor ^ d);

endmodule