// TopModule: A combinational circuit implementing the inverse XOR of inputs a, b, c, and d
module TopModule(
    input  logic a,  // Input bit a
    input  logic b,  // Input bit b
    input  logic c,  // Input bit c
    input  logic d,  // Input bit d
    output logic q   // Output bit q
);

    // Compute the XOR of all inputs
    logic xor_result;
    assign xor_result = a ^ b ^ c ^ d;

    // Handle the exception case where all inputs are 0
    logic all_zero;
    assign all_zero = ~(a | b | c | d);

    // Compute the final output q
    assign q = all_zero | xor_result;

endmodule