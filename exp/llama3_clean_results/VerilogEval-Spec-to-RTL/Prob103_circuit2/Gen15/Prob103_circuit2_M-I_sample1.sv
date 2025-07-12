// TopModule: An optimized combinational circuit implementing the inverse XOR of inputs a, b, c, and d
module TopModule(
    input  logic a,  // Input bit a
    input  logic b,  // Input bit b
    input  logic c,  // Input bit c
    input  logic d,  // Input bit d
    output logic q   // Output bit q
);

    // Directly implement the inverse XOR operation using a more explicit approach
    logic xor_result;
    assign xor_result = a ^ b ^ c ^ d;
    assign q = ~xor_result;  // Use NOT operator (~) on the XOR result

endmodule