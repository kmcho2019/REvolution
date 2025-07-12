module fixed_point_subtractor #(
    parameter Q = 16,    // Number of fractional bits (Q <= N)
    parameter N = 32     // Total bit width (N >= 1)
) (
    input wire signed [N-1:0] a,  // First fixed-point operand
    input wire signed [N-1:0] b,  // Second fixed-point operand
    output wire signed [N-1:0] c  // Result (a - b)
);

    // Signed subtraction automatically handles:
    // - All sign combinations
    // - Zero results (sign bit handled correctly)
    // - Fixed-point precision (Q fractional bits)
    assign c = a - b;

endmodule