// TopModule: An optimized combinational circuit implementing the inverse XOR of inputs a, b, c, and d
module TopModule(
    input  logic a,  // Input bit a
    input  logic b,  // Input bit b
    input  logic c,  // Input bit c
    input  logic d,  // Input bit d
    output logic q   // Output bit q
);

    // The output q is the inverse of the XOR of all input bits. This can be optimized
    // by first calculating the XOR of all inputs and then inverting the result.
    // This approach is already quite efficient, but we'll maintain it for clarity and simplicity.
    logic xor_result;  // Intermediate result for XOR operation
    assign xor_result = a ^ b ^ c ^ d;  // Calculate XOR of all inputs
    assign q = ~xor_result;  // Invert the XOR result to get the final output

endmodule