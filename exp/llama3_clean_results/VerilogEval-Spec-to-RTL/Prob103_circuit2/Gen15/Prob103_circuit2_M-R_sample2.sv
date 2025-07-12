// TopModule: A combinational circuit implementing the inverse XOR of inputs a, b, c, and d
module TopModule(
    input  logic a,  // Input bit a
    input  logic b,  // Input bit b
    input  logic c,  // Input bit c
    input  logic d,  // Input bit d
    output logic q   // Output bit q
);

    // Temporary variable to hold the XOR result
    logic temp_xor;

    // Calculate the XOR of all input bits
    assign temp_xor = a ^ b ^ c ^ d;

    // Assign the inverted XOR result to the output
    assign q = ~temp_xor;

endmodule