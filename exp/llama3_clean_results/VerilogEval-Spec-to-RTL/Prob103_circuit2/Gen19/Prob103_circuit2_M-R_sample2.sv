// TopModule: A refactored combinational circuit implementing the inverse XOR of inputs a, b, c, and d
module TopModule(
    input  logic a,  // Input bit a
    input  logic b,  // Input bit b
    input  logic c,  // Input bit c
    input  logic d,  // Input bit d
    output logic q   // Output bit q
);

    // Intermediate signal to hold the XOR of inputs a, b, c, and d
    logic xor_result;

    // Compute the XOR of all inputs
    assign xor_result = a ^ b ^ c ^ d;

    // Invert the XOR result to get the final output
    assign q = ~xor_result;

    // The refactored code maintains the same functionality as the original but with improved readability
    // and modularity, allowing for easier understanding and potential modification of the logic.

endmodule