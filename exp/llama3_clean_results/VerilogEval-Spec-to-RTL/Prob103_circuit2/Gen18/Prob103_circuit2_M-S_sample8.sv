// Simplified TopModule: A combinational circuit implementing the inverse XOR of inputs a, b, c, and d
module TopModule(
    input  logic a,  // Input bit a
    input  logic b,  // Input bit b
    input  logic c,  // Input bit c
    input  logic d,  // Input bit d
    output logic q   // Output bit q
);

    // The output q is the inverse of the XOR of all input bits.
    // This directly implements the required logic in a concise manner.
    assign q = ~(a ^ b ^ c ^ d);

endmodule