// TopModule: Refactored combinational circuit implementing the inverse XOR of inputs a, b, c, and d
module TopModule(
    input  logic a,  // Input bit a
    input  logic b,  // Input bit b
    input  logic c,  // Input bit c
    input  logic d,  // Input bit d
    output logic q   // Output bit q
);

    // Intermediate wire to hold the result of the XOR operation
    wire xor_result;

    // Perform the XOR operation among a, b, c, and d
    assign xor_result = a ^ b ^ c ^ d;

    // Assign the output q as the inverse of xor_result
    assign q = ~xor_result;

    // This structure maintains the simplicity and efficiency of the original logic
    // while potentially offering a clearer view of the operation sequence.

endmodule