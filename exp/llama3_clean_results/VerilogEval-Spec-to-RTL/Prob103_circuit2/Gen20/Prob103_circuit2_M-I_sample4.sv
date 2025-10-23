// TopModule: An optimized combinational circuit implementing the inverse XOR of inputs a, b, c, and d
module TopModule(
    input  logic a,  // Input bit a
    input  logic b,  // Input bit b
    input  logic c,  // Input bit c
    input  logic d,  // Input bit d
    output logic q   // Output bit q
);

    // Directly calculate the inverse XOR of a, b, c, and d
    assign q = ~(a ^ b ^ c ^ d);

    // Alternatively, for potential synthesis optimization:
    // logic xor_ab, xor_abc;
    // assign xor_ab = a ^ b;
    // assign xor_abc = xor_ab ^ c;
    // assign q = ~(xor_abc ^ d);

endmodule