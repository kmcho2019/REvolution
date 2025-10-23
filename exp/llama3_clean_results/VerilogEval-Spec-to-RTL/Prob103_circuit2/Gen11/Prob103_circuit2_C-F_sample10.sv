// TopModule: An optimized combinational circuit implementing the inverse XOR of inputs a, b, c, and d
module TopModule(
    input  logic a,  // Input bit a
    input  logic b,  // Input bit b
    input  logic c,  // Input bit c
    input  logic d,  // Input bit d
    output logic q   // Output bit q
);

    // Direct implementation of the inverse XOR of inputs a, b, c, and d
    // This line calculates the XOR of all input bits and then inverts the result
    // The XOR operator (^) is used to perform the bitwise XOR operation
    // The NOT operator (~) is then used to invert the result of the XOR operation
    assign q = ~(a ^ b ^ c ^ d);

endmodule