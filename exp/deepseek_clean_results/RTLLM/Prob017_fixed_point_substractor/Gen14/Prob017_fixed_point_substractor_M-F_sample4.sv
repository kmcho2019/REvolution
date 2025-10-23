module fixed_point_subtractor #(
    parameter Q = 16,    // Number of fractional bits (default 16)
    parameter N = 32     // Total number of bits (default 32)
) (
    input wire signed [N-1:0] a,  // First fixed-point operand
    input wire signed [N-1:0] b,  // Second fixed-point operand
    output wire signed [N-1:0] c  // Fixed-point result (a - b)
);

    // Signed subtraction handles all cases:
    // - Same/different signs
    // - Zero results
    // - Proper overflow behavior
    assign c = a - b;

endmodule