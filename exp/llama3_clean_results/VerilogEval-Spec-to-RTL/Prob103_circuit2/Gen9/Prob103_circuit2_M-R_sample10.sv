// Refactored TopModule: A combinational circuit implementing the inverse XOR of inputs a, b, c, and d
module TopModule(
    input  logic a,  // Input bit a
    input  logic b,  // Input bit b
    input  logic c,  // Input bit c
    input  logic d,  // Input bit d
    output logic q   // Output bit q
);

    // Intermediate signal to hold the XOR result of inputs a, b, c, and d
    logic xor_result;

    // Calculate the XOR of inputs a, b, c, and d
    assign xor_result = a ^ b ^ c ^ d;

    // Calculate the output q as the inverse of xor_result
    assign q = ~xor_result;

endmodule