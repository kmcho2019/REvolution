// TopModule: An optimized combinational circuit implementing the inverse XOR of inputs a, b, c, and d
module TopModule(
    input  logic a,  // Input bit a
    input  logic b,  // Input bit b
    input  logic c,  // Input bit c
    input  logic d,  // Input bit d
    output logic q   // Output bit q
);

    // Implement the inverse XOR operation using a temporary wire for intermediate result
    logic temp_xor;
    assign temp_xor = a ^ b ^ c ^ d;
    assign q = ~temp_xor;  // Use a separate step for inversion

endmodule